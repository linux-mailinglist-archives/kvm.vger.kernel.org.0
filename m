Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B64BF513D52
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 23:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352192AbiD1VSf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 17:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352200AbiD1VS2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 17:18:28 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6152FD4
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 14:15:09 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SJ5fta018590;
        Thu, 28 Apr 2022 21:14:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Ycl9bCTfViJUXB4zPoEGRaUlR1GC5CiBqImMZENF1bE=;
 b=FP/9aFsugwFrjcahsTxVWg/RAdjx2yvfDJ9Z1VK/AqK9oS1wF+Lo6Uj1iS9Ip2x4nZG4
 Lz87sG43gBzCWnfbiqoNDn0c3Mfhpdc3/8ke8aZOVYEhbAUyO4IUvB7iiz5e4PgCkadd
 t8Uo9fRhNSB7GXsHy1UTuJn2JJNcLGCsgba16hUrSvqkbNm/5TkksKwOw5yggaA+TMYA
 zhzmk7BZ9EI8jlnCPeokecw1PmFF746I5Xvkhbtja4ts2Fv64TUQKEtEpYxHK4ATOsfb
 T/6rO5FHlRMYlFdjCBPGpe21aloWNySJIv8HPvvomoc2C8VlxEQ9mN3L7K8MoaoFcHAY 0w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb5k59ny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:14:53 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23SL5Cge028520;
        Thu, 28 Apr 2022 21:14:52 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w79rpn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:14:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ixSBQukmaVS6NKb9mM9doqzXSWRuFNwb7smIpieKvdMHe/+CpwYHkfVq6nBHbUnAAiYuq21WSdQ85rFmvRJZo0nT4t177tO837HNXvOOohTwcvHoUiksjb/E2woOugyhzQxWIUp1Yww50CCDy8r24PT1miqDYmPp0dyr63fwtBjo6rRN4D3mb7vyOU0fESwWQdG+iHft2rxTabIBW2NRTVdMijuYsZ8Uf1QJHq32i/rhf9pjlQ04u7pGW3DUR3scucoqtTGL1IZQxZ2N/S4yaBcl+98TvLZV6j3h4Ynut6wg7uqFRyMW5maQ9VG3TcruqJWBlsrzFuZZmVjs/tIztA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ycl9bCTfViJUXB4zPoEGRaUlR1GC5CiBqImMZENF1bE=;
 b=egYROaPK+gNVA6oGRWAJKxRB+ZU5ngPJT4NiGA8R8CkteDqiuunV9qLQMYRm2ds8oO7n9LEu1SXWlG98VOxYH78MjffGw4Cf6+nrzmXUdRvwSu9MdhOe0vX/jPZpGAz5AeA8mKZWwkY46VH6YeLgQxBnOu8Sh9EMuaomiKvHdSGOZMENPaxaVDqbfh1N88ro9wMs1bjKHhf1yH3QpBJcNyIPqb9O5wh2c3raRKCh4/9mN1tmFqedvNQUdxKCasXwoHBCQdGMKc0rjgrYHtmfRfFGESictmYPIHb8rMIGokwjndJFT20UmLwzRUYrjHkCzaQS295eVQ9vPpK5fhONGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ycl9bCTfViJUXB4zPoEGRaUlR1GC5CiBqImMZENF1bE=;
 b=GOfvnENJiTkGE2J4QRKushuO2UYu3+YmXjiokMWGadmLoQkt5125jVD9AEe3M46NMErScvOjYKBHNUWkKnDYUk+JpsEi/zfqBrUqSHIkVMaiFJscu4IhZOaHp3tvlzYbD5oFK8Pl1o3jUj/q7bKLbyVdw+fxbdSv+k7i5vSSV0U=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CH0PR10MB5289.namprd10.prod.outlook.com (2603:10b6:610:d8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 28 Apr
 2022 21:14:50 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 21:14:50 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
To:     qemu-devel@nongnu.org
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Xu <peterx@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Thanos Makatos <thanos.makatos@nutanix.com>,
        "John G . Johnson" <john.g.johnson@oracle.com>, kvm@vger.kernel.org
Subject: [PATCH RFC 09/10] migration/dirtyrate: Expand dirty_bitmap to be tracked separately for devices
Date:   Thu, 28 Apr 2022 22:13:50 +0100
Message-Id: <20220428211351.3897-10-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220428211351.3897-1-joao.m.martins@oracle.com>
References: <20220428211351.3897-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0297.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::21) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1443a39a-b421-4d11-76b0-08da295c2117
X-MS-TrafficTypeDiagnostic: CH0PR10MB5289:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB5289E348CD5480FB662900A8BBFD9@CH0PR10MB5289.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YJ8sZapUH7MrnVGq9vohzlqcO30VlhC+eAa4j1UDIWR+/12NmGg3UMNw6yR2AkxnPDqzPQ8OO+/vInArgdB6bwInz2vq44OG/SHAfnfjJAMItJnNn19MVWm1mh0Gw4ifwYtRfP3FmIkMkjusfKwrIZYXn8S0FypDWu7BGuQwq5Wq3UW3xtmxYjd1e60CUMl3IFnumJGKFOVUL08Jwhw/kJWAVC9Oxi9L5USTINPp1OuG5PWBCW4RLPh9rBpY2d63uZo8j0henass0qehZ4FGbbCqMObi3u5nePslJA3kpgn7jOrafcH5fRSci4DBs8trMm7Me4kexs4pHT3gv+iV2ebZVkq0D5tPUbgbCNyQdQ+uUtO/5QXhyuasBuoTcRGQIrHW4rqoFQA/PZr+4+1QwuXr9pNfnIqLJonhn8u562SMjzSTVhnyjyXRtDP4hxkyDRMyeki+66Nd+RqwA3jXKqVk7v01M+8za71wgrbsdsNUYlpCGXzSzm1we3dO2qXdcafxkZit9UOdU2rX7oJLaGt4Aw59ubTYT7shpXOw6SEg0IQqAH1YKaeslE2M/SJSDIcA3RevFkxzK+Nq+Go93fGrK+7Iq3wpdqNKkRz8g1jXbn07TP/I4tyfa4qrpw5OJmGWWNXaDTiZewVr6/TlzRY0hGnuRnC++bsagrNKNe3zzL8yM+NrVqgokpR7rUyIA3YqaDlm8wFsCa+286yGSeqcaibfU0qJkwjtc8UwsAQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(186003)(1076003)(30864003)(38350700002)(38100700002)(5660300002)(2616005)(7416002)(103116003)(26005)(316002)(6916009)(36756003)(66946007)(8676002)(66476007)(4326008)(66556008)(8936002)(52116002)(86362001)(6512007)(2906002)(6486002)(508600001)(83380400001)(6506007)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pXNZeBqyIywJnEWLy9AnFUoc1LC9G91ouZSzByDW7P2/dpgqjj4X3D/DimdS?=
 =?us-ascii?Q?ECbFY8m+bXDm97gJPy80whmFjGHldwARHPYJfnTtP7ucGH8X1iQZYRoOf2/v?=
 =?us-ascii?Q?z8uOnHrexOuap7D+BNVf2rXqwQSyNJkm2aYEyV304aPHufLrgSJd0i+Tpzyv?=
 =?us-ascii?Q?qGnQsheSmbuiW6a/fagjv+HiTZ/EHokwGxTrFg+0BcfRklyHTeTGvDCpi12Z?=
 =?us-ascii?Q?5rr3pciP47YAu3YzKfsVE0V4aNej0mHkC7xP33XNAtHYMCZCAs/kA7D2GI/G?=
 =?us-ascii?Q?qDRDyEwv3KJgVLr9EbpCMuuGpkUDhHZQbFg+NJCY2Vm8wrFsRqTU9d+NgTXW?=
 =?us-ascii?Q?Gv7jrskFSbhnlioSmK2STY4oEW8pnkuCpIfXEth3XxwDjXxMlF+kSO0x7Wvu?=
 =?us-ascii?Q?vlponDOFOcBKVU8V9d8RA9ApVrZ1MU2Onzfm1aklLNIC3aRMkOYxxkOldsfT?=
 =?us-ascii?Q?ctWyAxUrW678dr39l2I1d1VHYUPI2tgWReEzQIapNK3L3oi6iCOwLL5crmh1?=
 =?us-ascii?Q?ATuf27mfakRBV5fOgun05xcgIqfiQV2HfY4Fmoe96Px1ybNFF3+NQWgV1n01?=
 =?us-ascii?Q?JF9a1oOJ/BLRdKcKvjL+jtR8HUCe0H26pHrxiw2PaDA+13Yr42743pVSMS6G?=
 =?us-ascii?Q?sL+Z32+kgNf1lC8Kpo6pJI6Ewt+vM+3f81h02MT9ae9dj/QJcUOt9c8Sw8Ve?=
 =?us-ascii?Q?GFBh8m9DPIuJtLDGs/FfPlJsbb/v5wifbPFUZNTDtLCgp9OUHZ2OFqjR/OdH?=
 =?us-ascii?Q?yeNjjzTkdbMMSDrLSt1O2R34Lr3ck11S3/G4vpaQakgzvwUYZa8WCBKnDTHB?=
 =?us-ascii?Q?zRQ3NSkalbhJsox1qNjVWTzUfZA8tPgvOAID4HLq28AOeKtV2VHGRFmvapED?=
 =?us-ascii?Q?jfq9EIsI/sI+vvtpI+w2mF2cfyAZW/H37ne4mDCYewUQKwohRVD/HgrjT7ml?=
 =?us-ascii?Q?u2x+ZBEfmFSHW7gg5eXfANd2YH4fl11pfOgMtiaptmtjJ3Fc8fkd4sepzyWd?=
 =?us-ascii?Q?N7dgUcjs/9yd49c0GP/Rtw4yqGE7/NxyVwnoiNW5fgy8d/4T3m9zGPRl0gDv?=
 =?us-ascii?Q?qRnbR3ic0Zv3KVu5oTKP0CMdS7QJmIDmdNYJJ44mUEjF904lkxRKs3dbiVWY?=
 =?us-ascii?Q?SAj4Oo0lh4AVQeAUdlF1arqpj8UXJlyvEaG6b4ScwoEQEhzhMd5Y5IxRqXOP?=
 =?us-ascii?Q?Yz9Eu+fn0aLTqH/6UzPOfLhvYgdFdlpE+9ThHoGD9FehsRgkjXclZPKJ6wMA?=
 =?us-ascii?Q?PZI3Q2QgZeV3U+UZ8zBVxmgqed/TWBONRyN6qHuLZ41nna5FzH5UpSeSR0Pm?=
 =?us-ascii?Q?y/eB3FfrXaSNV5R5dG2anC0vLAor7FHhmcoK5CcTrwaTukKBu92KP+sEQ6mD?=
 =?us-ascii?Q?EmqdKBLDHiHF+ecGFBR9J+WdBo9jbFuQl0BdMQdF+3iauB8Vfmv5xA/yKf34?=
 =?us-ascii?Q?1aAizGz9cji3PyNZfsiYyItKL6NXo5YRhgYjiy5gajZiw/0Lh1fvPdiNGxDS?=
 =?us-ascii?Q?kwKj1Pq3GIv4wJfwiXLQGd/CiGP9l6Xr7R8r/vPRNXLcoIFO+WELBWlHh+Y8?=
 =?us-ascii?Q?YHWSj2ygvZ7ytRQzZMdBb3yCTwA6eeWKUan4DapZmrkli3aBxOnidski3sXS?=
 =?us-ascii?Q?AkQBJB31b9dG0HGI9nVTWclvjnxWuI2Un0otgwkeY8LpzCAHnzVn98O2Kcmb?=
 =?us-ascii?Q?KmtHo/oWrCRzkYJ5NexxAIQBfXfOVSA7avwFauwWi/7HWbNp6G+Tj2CkiNqw?=
 =?us-ascii?Q?vuV/fCSHahIxnyoBx+MhmDnZ2THL2cs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1443a39a-b421-4d11-76b0-08da295c2117
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 21:14:50.1667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ICZ5Q6mEeN+EGwNhnQaLFHW6QZkDxuPmFTfCfOeKiPde8KTMZsuQEeLKw4GLMZqF1kPZSTDjrw7Huu87CxYZyQEwd4ey0uNR3LIZeN8p0fs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5289
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_04:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204280125
X-Proofpoint-GUID: qgvNMg-R-DSmfFP2Uojb43Rf05DEYZZr
X-Proofpoint-ORIG-GUID: qgvNMg-R-DSmfFP2Uojb43Rf05DEYZZr
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Expand dirtyrate measurer that is accessible via HMP calc_dirty_rate
or QMP 'calc-dirty-rate' to receive a @scope argument. The scope
then restricts the dirty tracking to be done at devices only,
while neither enabling or using the KVM (CPU) dirty tracker.
The default stays as is i.e. dirty-ring / dirty-bitmap from KVM.

This is useful to test, exercise the IOMMU dirty tracker and observe
how much a given device is dirtying memory.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 accel/kvm/kvm-all.c   | 12 +++++++++
 hmp-commands.hx       |  5 ++--
 hw/vfio/container.c   |  8 ++++++
 hw/vfio/iommufd.c     |  4 +++
 include/exec/memory.h | 10 +++++++-
 migration/dirtyrate.c | 59 +++++++++++++++++++++++++++++++++----------
 migration/dirtyrate.h |  1 +
 qapi/migration.json   | 15 +++++++++++
 softmmu/memory.c      |  5 ++++
 9 files changed, 102 insertions(+), 17 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 5f1377ca048c..b4bbe0d20f6e 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1517,6 +1517,10 @@ static void kvm_log_sync(MemoryListener *listener,
 {
     KVMMemoryListener *kml = container_of(listener, KVMMemoryListener, listener);
 
+    if (memory_global_dirty_devices()) {
+        return;
+    }
+
     kvm_slots_lock();
     kvm_physical_sync_dirty_bitmap(kml, section);
     kvm_slots_unlock();
@@ -1529,6 +1533,10 @@ static void kvm_log_sync_global(MemoryListener *l)
     KVMSlot *mem;
     int i;
 
+    if (memory_global_dirty_devices()) {
+        return;
+    }
+
     /* Flush all kernel dirty addresses into KVMSlot dirty bitmap */
     kvm_dirty_ring_flush();
 
@@ -1558,6 +1566,10 @@ static void kvm_log_clear(MemoryListener *listener,
     KVMMemoryListener *kml = container_of(listener, KVMMemoryListener, listener);
     int r;
 
+    if (memory_global_dirty_devices()) {
+        return;
+    }
+
     r = kvm_physical_log_clear(kml, section);
     if (r < 0) {
         error_report_once("%s: kvm log clear failed: mr=%s "
diff --git a/hmp-commands.hx b/hmp-commands.hx
index 8476277aa9c9..28122d268ea3 100644
--- a/hmp-commands.hx
+++ b/hmp-commands.hx
@@ -1739,10 +1739,11 @@ ERST
 
     {
         .name       = "calc_dirty_rate",
-        .args_type  = "dirty_ring:-r,dirty_bitmap:-b,second:l,sample_pages_per_GB:l?",
-        .params     = "[-r] [-b] second [sample_pages_per_GB]",
+        .args_type  = "dirty_devices:-d,dirty_ring:-r,dirty_bitmap:-b,second:l,sample_pages_per_GB:l?",
+        .params     = "[-d] [-r] [-b] second [sample_pages_per_GB]",
         .help       = "start a round of guest dirty rate measurement (using -r to"
                       "\n\t\t\t specify dirty ring as the method of calculation and"
+                      "\n\t\t\t specify devices as the only scope and"
                       "\n\t\t\t -b to specify dirty bitmap as method of calculation)",
         .cmd        = hmp_calc_dirty_rate,
     },
diff --git a/hw/vfio/container.c b/hw/vfio/container.c
index 6bc1b8763f75..fff8319c0036 100644
--- a/hw/vfio/container.c
+++ b/hw/vfio/container.c
@@ -84,6 +84,10 @@ static bool vfio_devices_all_dirty_tracking(VFIOContainer *bcontainer)
     VFIODevice *vbasedev;
     MigrationState *ms = migrate_get_current();
 
+    if (bcontainer->dirty_pages_supported) {
+        return true;
+    }
+
     if (!migration_is_setup_or_active(ms->state)) {
         return false;
     }
@@ -311,6 +315,10 @@ static int vfio_get_dirty_bitmap(VFIOContainer *bcontainer, uint64_t iova,
     uint64_t pages;
     int ret;
 
+    if (!memory_global_dirty_devices()) {
+        return 0;
+    }
+
     dbitmap = g_malloc0(sizeof(*dbitmap) + sizeof(*range));
 
     dbitmap->argsz = sizeof(*dbitmap) + sizeof(*range);
diff --git a/hw/vfio/iommufd.c b/hw/vfio/iommufd.c
index d75ecbf2ae52..4686cc713aac 100644
--- a/hw/vfio/iommufd.c
+++ b/hw/vfio/iommufd.c
@@ -150,6 +150,10 @@ static int iommufd_get_dirty_bitmap(VFIOContainer *bcontainer, uint64_t iova,
     VFIOIOASHwpt *hwpt;
     unsigned long *data, page_size, bitmap_size, pages;
 
+    if (!memory_global_dirty_devices()) {
+        return 0;
+    }
+
     if (!bcontainer->dirty_pages_supported) {
         return 0;
     }
diff --git a/include/exec/memory.h b/include/exec/memory.h
index 4d5997e6bbae..59c1d8bcc495 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -69,7 +69,10 @@ static inline void fuzz_dma_read_cb(size_t addr,
 /* Dirty tracking enabled because measuring dirty rate */
 #define GLOBAL_DIRTY_DIRTY_RATE (1U << 1)
 
-#define GLOBAL_DIRTY_MASK  (0x3)
+/* Dirty tracking enabled because measuring devices dirty rate */
+#define GLOBAL_DIRTY_DIRTY_RATE_DEVICES (1U << 2)
+
+#define GLOBAL_DIRTY_MASK  (0x7)
 
 extern unsigned int global_dirty_tracking;
 
@@ -2433,6 +2436,11 @@ void memory_global_dirty_log_start(unsigned int flags);
  */
 void memory_global_dirty_log_stop(unsigned int flags);
 
+/**
+ * memory_global_dirty_devices: check if the scope is just devices
+ */
+bool memory_global_dirty_devices(void);
+
 void mtree_info(bool flatview, bool dispatch_tree, bool owner, bool disabled);
 
 /**
diff --git a/migration/dirtyrate.c b/migration/dirtyrate.c
index aace12a78764..8c00cb6a3702 100644
--- a/migration/dirtyrate.c
+++ b/migration/dirtyrate.c
@@ -45,6 +45,8 @@ static int CalculatingState = DIRTY_RATE_STATUS_UNSTARTED;
 static struct DirtyRateStat DirtyStat;
 static DirtyRateMeasureMode dirtyrate_mode =
                 DIRTY_RATE_MEASURE_MODE_PAGE_SAMPLING;
+static DirtyRateScope dirtyrate_scope =
+                DIRTY_RATE_SCOPE_ALL;
 
 static int64_t set_sample_page_period(int64_t msec, int64_t initial_time)
 {
@@ -99,6 +101,7 @@ static struct DirtyRateInfo *query_dirty_rate_info(void)
     info->calc_time = DirtyStat.calc_time;
     info->sample_pages = DirtyStat.sample_pages;
     info->mode = dirtyrate_mode;
+    info->scope = dirtyrate_scope;
 
     if (qatomic_read(&CalculatingState) == DIRTY_RATE_STATUS_MEASURED) {
         info->has_dirty_rate = true;
@@ -406,32 +409,44 @@ static inline void record_dirtypages(DirtyPageRecord *dirty_pages,
     }
 }
 
-static void dirtyrate_global_dirty_log_start(void)
+static void dirtyrate_global_dirty_log_start(DirtyRateScope scope)
 {
+    unsigned int flags = GLOBAL_DIRTY_DIRTY_RATE;
+
+    if (scope == DIRTY_RATE_SCOPE_DIRTY_DEVICES) {
+        flags |= GLOBAL_DIRTY_DIRTY_RATE_DEVICES;
+    }
+
     qemu_mutex_lock_iothread();
-    memory_global_dirty_log_start(GLOBAL_DIRTY_DIRTY_RATE);
+    memory_global_dirty_log_start(flags);
     qemu_mutex_unlock_iothread();
 }
 
-static void dirtyrate_global_dirty_log_stop(void)
+static void dirtyrate_global_dirty_log_stop(DirtyRateScope scope)
 {
+    unsigned int flags = GLOBAL_DIRTY_DIRTY_RATE;
+
+    if (scope == DIRTY_RATE_SCOPE_DIRTY_DEVICES) {
+        flags |= GLOBAL_DIRTY_DIRTY_RATE_DEVICES;
+    }
+
     qemu_mutex_lock_iothread();
     memory_global_dirty_log_sync();
-    memory_global_dirty_log_stop(GLOBAL_DIRTY_DIRTY_RATE);
+    memory_global_dirty_log_stop(flags);
     qemu_mutex_unlock_iothread();
 }
 
 static int64_t do_calculate_dirtyrate_vcpu(DirtyPageRecord dirty_pages)
 {
-    uint64_t memory_size_MB;
+    uint64_t memory_size_KB;
     int64_t time_s;
     uint64_t increased_dirty_pages =
         dirty_pages.end_pages - dirty_pages.start_pages;
 
-    memory_size_MB = (increased_dirty_pages * TARGET_PAGE_SIZE) >> 20;
+    memory_size_KB = (increased_dirty_pages * TARGET_PAGE_SIZE) >> 10;
     time_s = DirtyStat.calc_time;
 
-    return memory_size_MB / time_s;
+    return memory_size_KB / time_s;
 }
 
 static inline void record_dirtypages_bitmap(DirtyPageRecord *dirty_pages,
@@ -466,9 +481,14 @@ static void calculate_dirtyrate_dirty_bitmap(struct DirtyRateConfig config)
     int64_t msec = 0;
     int64_t start_time;
     DirtyPageRecord dirty_pages;
+    unsigned int flags = GLOBAL_DIRTY_DIRTY_RATE;
+
+    if (config.scope == DIRTY_RATE_SCOPE_DIRTY_DEVICES) {
+        flags |= GLOBAL_DIRTY_DIRTY_RATE_DEVICES;
+    }
 
     qemu_mutex_lock_iothread();
-    memory_global_dirty_log_start(GLOBAL_DIRTY_DIRTY_RATE);
+    memory_global_dirty_log_start(flags);
 
     /*
      * 1'round of log sync may return all 1 bits with
@@ -500,7 +520,7 @@ static void calculate_dirtyrate_dirty_bitmap(struct DirtyRateConfig config)
      * 1. fetch dirty bitmap from kvm
      * 2. stop dirty tracking
      */
-    dirtyrate_global_dirty_log_stop();
+    dirtyrate_global_dirty_log_stop(config.scope);
 
     record_dirtypages_bitmap(&dirty_pages, false);
 
@@ -527,7 +547,7 @@ static void calculate_dirtyrate_dirty_ring(struct DirtyRateConfig config)
     DirtyStat.dirty_ring.nvcpu = nvcpu;
     DirtyStat.dirty_ring.rates = malloc(sizeof(DirtyRateVcpu) * nvcpu);
 
-    dirtyrate_global_dirty_log_start();
+    dirtyrate_global_dirty_log_start(config.scope);
 
     CPU_FOREACH(cpu) {
         record_dirtypages(dirty_pages, cpu, true);
@@ -540,7 +560,7 @@ static void calculate_dirtyrate_dirty_ring(struct DirtyRateConfig config)
     msec = set_sample_page_period(msec, start_time);
     DirtyStat.calc_time = msec / 1000;
 
-    dirtyrate_global_dirty_log_stop();
+    dirtyrate_global_dirty_log_stop(config.scope);
 
     CPU_FOREACH(cpu) {
         record_dirtypages(dirty_pages, cpu, false);
@@ -631,6 +651,8 @@ void *get_dirtyrate_thread(void *arg)
 void qmp_calc_dirty_rate(int64_t calc_time,
                          bool has_sample_pages,
                          int64_t sample_pages,
+                         bool has_scope,
+                         DirtyRateScope scope,
                          bool has_mode,
                          DirtyRateMeasureMode mode,
                          Error **errp)
@@ -701,6 +723,7 @@ void qmp_calc_dirty_rate(int64_t calc_time,
     config.sample_period_seconds = calc_time;
     config.sample_pages_per_gigabytes = sample_pages;
     config.mode = mode;
+    config.scope = scope;
 
     cleanup_dirtyrate_stat(config);
 
@@ -709,6 +732,7 @@ void qmp_calc_dirty_rate(int64_t calc_time,
      * been used in last calculation
      **/
     dirtyrate_mode = mode;
+    dirtyrate_scope = scope;
 
     start_time = qemu_clock_get_ms(QEMU_CLOCK_REALTIME) / 1000;
     init_dirtyrate_stat(start_time, config);
@@ -736,9 +760,11 @@ void hmp_info_dirty_rate(Monitor *mon, const QDict *qdict)
                    info->calc_time);
     monitor_printf(mon, "Mode: %s\n",
                    DirtyRateMeasureMode_str(info->mode));
+    monitor_printf(mon, "Scope: %s\n",
+                   DirtyRateScope_str(info->scope));
     monitor_printf(mon, "Dirty rate: ");
     if (info->has_dirty_rate) {
-        monitor_printf(mon, "%"PRIi64" (MB/s)\n", info->dirty_rate);
+        monitor_printf(mon, "%"PRIi64" (KB/s)\n", info->dirty_rate);
         if (info->has_vcpu_dirty_rate) {
             DirtyRateVcpuList *rate, *head = info->vcpu_dirty_rate;
             for (rate = head; rate != NULL; rate = rate->next) {
@@ -762,7 +788,9 @@ void hmp_calc_dirty_rate(Monitor *mon, const QDict *qdict)
     bool has_sample_pages = (sample_pages != -1);
     bool dirty_ring = qdict_get_try_bool(qdict, "dirty_ring", false);
     bool dirty_bitmap = qdict_get_try_bool(qdict, "dirty_bitmap", false);
+    bool dirty_devices = qdict_get_try_bool(qdict, "dirty_devices", false);
     DirtyRateMeasureMode mode = DIRTY_RATE_MEASURE_MODE_PAGE_SAMPLING;
+    DirtyRateScope scope = DIRTY_RATE_SCOPE_ALL;
     Error *err = NULL;
 
     if (!sec) {
@@ -781,9 +809,12 @@ void hmp_calc_dirty_rate(Monitor *mon, const QDict *qdict)
     } else if (dirty_ring) {
         mode = DIRTY_RATE_MEASURE_MODE_DIRTY_RING;
     }
+    if (dirty_devices) {
+        scope = DIRTY_RATE_SCOPE_DIRTY_DEVICES;
+    }
 
-    qmp_calc_dirty_rate(sec, has_sample_pages, sample_pages, true,
-                        mode, &err);
+    qmp_calc_dirty_rate(sec, has_sample_pages, sample_pages,
+                       true, scope, true, mode, &err);
     if (err) {
         hmp_handle_error(mon, err);
         return;
diff --git a/migration/dirtyrate.h b/migration/dirtyrate.h
index 69d4c5b8655f..4061edf9f4de 100644
--- a/migration/dirtyrate.h
+++ b/migration/dirtyrate.h
@@ -44,6 +44,7 @@ struct DirtyRateConfig {
     uint64_t sample_pages_per_gigabytes; /* sample pages per GB */
     int64_t sample_period_seconds; /* time duration between two sampling */
     DirtyRateMeasureMode mode; /* mode of dirtyrate measurement */
+    DirtyRateScope scope; /* scope of dirtyrate measurement */
 };
 
 /*
diff --git a/qapi/migration.json b/qapi/migration.json
index 27d7b281581d..082830c6e771 100644
--- a/qapi/migration.json
+++ b/qapi/migration.json
@@ -1793,6 +1793,19 @@
 { 'enum': 'DirtyRateMeasureMode',
   'data': ['page-sampling', 'dirty-ring', 'dirty-bitmap'] }
 
+##
+# @DirtyRateScope:
+#
+# An enumeration of scope of measuring dirtyrate.
+#
+# @dirty-devices: calculate dirtyrate by devices only.
+#
+# Since: 6.2
+#
+##
+{ 'enum': 'DirtyRateScope',
+  'data': ['all', 'dirty-devices'] }
+
 ##
 # @DirtyRateInfo:
 #
@@ -1827,6 +1840,7 @@
            'calc-time': 'int64',
            'sample-pages': 'uint64',
            'mode': 'DirtyRateMeasureMode',
+           'scope': 'DirtyRateScope',
            '*vcpu-dirty-rate': [ 'DirtyRateVcpu' ] } }
 
 ##
@@ -1851,6 +1865,7 @@
 ##
 { 'command': 'calc-dirty-rate', 'data': {'calc-time': 'int64',
                                          '*sample-pages': 'int',
+                                         '*scope': 'DirtyRateScope',
                                          '*mode': 'DirtyRateMeasureMode'} }
 
 ##
diff --git a/softmmu/memory.c b/softmmu/memory.c
index bfa5d5178c5b..120c41f3b303 100644
--- a/softmmu/memory.c
+++ b/softmmu/memory.c
@@ -2826,6 +2826,11 @@ void memory_global_dirty_log_start(unsigned int flags)
     }
 }
 
+bool memory_global_dirty_devices(void)
+{
+    return !!(global_dirty_tracking & GLOBAL_DIRTY_DIRTY_RATE_DEVICES);
+}
+
 static void memory_global_dirty_log_do_stop(unsigned int flags)
 {
     assert(flags && !(flags & (~GLOBAL_DIRTY_MASK)));
-- 
2.17.2

