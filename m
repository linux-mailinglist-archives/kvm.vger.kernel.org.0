Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11039513D4C
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 23:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352171AbiD1VSF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 17:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352162AbiD1VSB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 17:18:01 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346B080220
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 14:14:46 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SJYOGM015530;
        Thu, 28 Apr 2022 21:14:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=19+8wQdY7VNogk3Juc0dCtE2gVtLfYmUxah1u4a17X0=;
 b=aMuX64ghFcLiXpaoC9ylQ26YkB/Zy01BUM37OaWERGROief9K+7PZzdClqe8MApwX7xp
 mH5aKyhck16NpnwykwyTHcqUWrf7Ge9VxTX/J+m8MWvlQlgL49GpTCMjTQidSOi65inb
 1HmgiC4A/tx6/mcYfce+p4JsdUGVYk9tGAyXw6EHLLKC57+La3an1B1WOgoD7eTgxSOR
 8GazA/IG4ZqXc7OSvOhXJepvuK37uW41RxTfBNN4tSbxjxVBw0PVbWiyxOnzNwzm8EpL
 Vl/8jv0DsOa7dJU+22V4obo5mQB/p/rc2X9TOPohCy56e7Y9l/tD4E8yaKlxwfge9swp YQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb9aw635-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:14:25 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23SL6c5f028692;
        Thu, 28 Apr 2022 21:14:24 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5ypebpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:14:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vne7pH/E/lTVVhvr0Fn2dWJLwzxOpqGyiWwNRu0gbSCd+Jb+ae5hFvbAqDFV3NBHDhrAlfDnhHD5TmCsDIksyNQ5SUjeddrh+0u+4Qmz1Vs8/RY8e7ZJ86BGZv2ADAmfZ11KFLdk8gDRgWgFrQFYm/vrnpnqwKThPUxlkPa8h3I7P15MIpXFODYo58IUQNrn+hxA9iL9oHifXL379KRfmCLZS47SPVvsmgNCrUwbrzXk1J24vSMDcx4f32b/7YUq6p7out3gBs93DJ39S5K19MERr4PntTh4toZUN3GiC2RmToFKi6xnb4AJY8SXm11MZbSh/MK6+RDeG7nw2M3m3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=19+8wQdY7VNogk3Juc0dCtE2gVtLfYmUxah1u4a17X0=;
 b=TPDohXvvN6suvzRDlytsYZILALBkxCu6u1IKgn2tXvyjVC8op14ZRAWbyTHT4wYv7qXkPLCqkQJmmdgZJlZDXa7pmZPBz9zUiMe1TzTOjCJQd5HnoKvV9RTUpkpKqF908nR1qMUwEM27t7CC8utOcGo3QcrdxE/Ro5rjQuBWnuLFLU9GXPumdgJDHVibgfitDpOs/50AZAbobiNWguSMppqhcfIHi4rBx+p615X5KE9yigmtXmroJIhF8O6WValDBvBkDSn0Tx4cdcZukZQo3DwZiN+0Q8JvhkpNAitSTKGPlTkuUprOsFvjSpsLxSGViasNpaySWCfTw/dSdwra5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=19+8wQdY7VNogk3Juc0dCtE2gVtLfYmUxah1u4a17X0=;
 b=apsQv6XDpVhr/XFJCIXDyibmmkPTLF6ZhtB/Fhx5Lv6IJHj5A03RpGY1ZI+ktkjSK9NxTV51j3T++PwGQ69hYrxWhcJ+wqB12GyqFUzLd9RTO6P769cMsUBhoKoVVdxWLF8LS/S3suVZ7p99hgl5vpEqCdbWA2SPnEnM30srAaw=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CH0PR10MB5289.namprd10.prod.outlook.com (2603:10b6:610:d8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 28 Apr
 2022 21:14:21 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 21:14:21 +0000
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
Subject: [PATCH RFC 03/10] intel-iommu: Cache PASID entry flags
Date:   Thu, 28 Apr 2022 22:13:44 +0100
Message-Id: <20220428211351.3897-4-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220428211351.3897-1-joao.m.martins@oracle.com>
References: <20220428211351.3897-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0297.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::21) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7919b7c6-153d-4145-e7a2-08da295c1026
X-MS-TrafficTypeDiagnostic: CH0PR10MB5289:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB5289517D2B238A99C3DC4AC9BBFD9@CH0PR10MB5289.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ictRycHlInJCnVOLZBGdxI3LwNAA3ewlnTEmidENxkKfA9y7ksgmZEspwBpvR8v/f/SBpYj79OR8Q+F29k6ljwidQSAWs3LyNv5c04fLtgknmY5WCCul5kYOCECuXf0duPXkc2ClMsBPHZKv0bR4kSdkvN8pW0vzoK/bxyyY4suJzWrKKSPbkwxS6cU4jjb8pmeEGEtsfA0c/+k1Slm3hYQISwACZhT5o4pf1/8RwLQxnWh0Vv6QzpK5qJtOD+XNHM5u7y9XG7P4bocWxL1k/xwAgmt4huWocD9si7evxHfSOOmYkmVV+9YCoW5s24j+IKceAHsqUW3JsRqPw/sDpJTEKgn/qfUri++Rj14pZyzoUinZ0s3GIamfJ0hBPeECQ5z6kFmwyewWGcU154vziwnoxQE+h66xuYOnpGmwSQq2YlBpjtUiWTSCWWkQxvZJitRze5ivfZ9lRHw5BifRzpA8891hOwBKsggjYcHCSX/JY27GrU2NO+wTSRGHNcWOCLUgVfK0upfOaGmKw4t4lbBgNyEDzmDUXNh/RrbS/LztjE6NDbditm/NiMze505oYC1duDLt7YnCKdktMlwJcUdEOvXIBoKtgz1RZwNVgq01uLRXNVJwA5khX4exO/+lXooluBDTTh1Xn2l9kKTYu/WxuWzrjHhxnq8LELJ0LWA+N4K0p0SZKSt7io4WGCnswRjHn48GFUv2e1dm+LQhCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(54906003)(186003)(1076003)(38350700002)(38100700002)(5660300002)(2616005)(7416002)(103116003)(26005)(316002)(6916009)(36756003)(66946007)(8676002)(66476007)(4326008)(66556008)(8936002)(52116002)(86362001)(6512007)(2906002)(6486002)(508600001)(83380400001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?13rahZpLq7ne2wdvcXXvZbNENBu3OCuHmzR63GS9+1rasFZUM+MsTlENPTpz?=
 =?us-ascii?Q?IzyYWgyczA46t+LJTm2XzrOOGYrpmi9TIbdFl5wsRkhtSANI2iJC33FWFdwt?=
 =?us-ascii?Q?IVyNA7h9CCI8x4YkQEounnpglx6XJeKg6Sx+RzIxbxLQr2guKrMjZc5m1k+E?=
 =?us-ascii?Q?8eFEDtN1AoxIJ5qYtUtzfEZ/H34B0OtgezMSeCIdTlIyjM4AT3DWWKvU05ci?=
 =?us-ascii?Q?InZl095SLVjpTV/jENTGM7L+d6DEwqUKsZaqRtJWjAEHLua9sb2kAqfsu2j5?=
 =?us-ascii?Q?tt5dPyjRCMNNbkNSYnXBxi6pXbayfIMbOIHVPgRjUTPN7sEWXihGo+jWD7a1?=
 =?us-ascii?Q?oiRHoj7vc7lETIF0mbCfW2Cwit0V5oYF6C4DctgRF1QO+MeDq1PETEoNd6/+?=
 =?us-ascii?Q?kHspZbZNg1A4ht2rawLdMl6zA5dhhxhfTqLcUyVWAxmrq4ZNvJYabZwt9coJ?=
 =?us-ascii?Q?+JuzrA7n2gIktbxv+qWlPbNA3YHmYjIIqCBbwYQVSbUbOJLkraT9NPhu0ipb?=
 =?us-ascii?Q?+wt7gJ4XsYyVdI8vP6+0LaBDY+eBezV4yQwUUUQeglBmDo01QWbUY1CMj1Q6?=
 =?us-ascii?Q?wpRwglaht5BGuONa2mEF0lW0S8Btj9hIjpqo+VuGVolHFXgEhzd7c8FZkFaG?=
 =?us-ascii?Q?VYBtsOySZA/Knxv1QNy9Jm7EFjS1IJNrZyy5nk/3JIrHXNquHOEZ0Auu8lqP?=
 =?us-ascii?Q?Py678+WN25ZkzKClO3Byg9wL/pOWQ3dNJlfAfwJsqLrJ+17Q/nBmBXGafc1Z?=
 =?us-ascii?Q?RUkatZE+JaeFhXj1Ocb8BfvRDUC/5HpmKp0q0Ig5/5vovjQ8agAWt+jt7WzK?=
 =?us-ascii?Q?nz2D3TU9u/O56RgfSnrKsw7Y2sg2wBn/viWFJVAjAi8FdDY6EeurWUA4/ugq?=
 =?us-ascii?Q?EkriPyHxcD/GHR9nLdvZikVomzCUOtzzAinjcZeqsUNtDUhyDfNO3yECTQES?=
 =?us-ascii?Q?bl94ZGO799ReTeeQN6+ORMh+b16gwfvBXXDaqp7K55ltsLpDuIbSl3yhvqqI?=
 =?us-ascii?Q?+dyPpPm5BvHWY2kq4jNX3zC0P5LeBGbSOi0a6uQAkAwhF9MYcgtCm7V1E2EW?=
 =?us-ascii?Q?YlSzqgZe9xpkJlqFpukE7qjPQZjIyYouQHpZzdcOpl1wb6f6FZNNYG1N97mA?=
 =?us-ascii?Q?5okCnxJwMg+8yjbWdHXAzkEND13xT4amDUxfi+PrnaxtzlD7rh0OfurymsYy?=
 =?us-ascii?Q?bp81Gd747Znq11+NgkvFy4bP3FaNY1ZypAH7JbBxqOXBDIqC8VZy8lFkO2Hy?=
 =?us-ascii?Q?7z6j3UzL+1di06nGau6RRAr0BHxTTJELarihrcZks3iWCCbaxTKBZ6mwk58u?=
 =?us-ascii?Q?F/aKdr9lpuMyslE8wjZPidkx7gZCDUSKI/cLmHt6QStJW5Pb4HsS/EOBSqtm?=
 =?us-ascii?Q?mVKOFseY2CAXReMKoInr89SfmdjvT/w19zIrbHXDTTUJznl0yVWQyD/p4hK6?=
 =?us-ascii?Q?Mo2b+pwHVwHShxD33IEqtL/mC8Lsk0Tkmom15XvjV+4nIJ58J4HqSLGfQqce?=
 =?us-ascii?Q?WZrbcN5gOl8sQ8JzjVtOv7817HLoT2/KoC8IcN8jZyGCCB0Ww3jqSxtWhqhQ?=
 =?us-ascii?Q?oQysmb/UZnOQlRSvA2bQSJAqqB74OJPk2hQOVq8hYkQZtfUtWEBrPgIXaQn5?=
 =?us-ascii?Q?sh6VZSWtrnGijRHvQ0lmb+5zpYBAhleyK8QRTgVuYmtdzLKKL0ktjUXYeA3/?=
 =?us-ascii?Q?5w+jnbVG7gb65ZAXvC4XwWHDexS4XaAAagK8X93T/Oa55V4SiHk5Gy2YpX5x?=
 =?us-ascii?Q?d7yQD4EqswjxihTdD+1ZCNC1+tyMRXg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7919b7c6-153d-4145-e7a2-08da295c1026
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 21:14:21.5917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JPGHwru9LCSxjFr3BCF4olDCkcKDXsm6y7qedqfH0HxSzP8BpbLP2HmXxFBX0CMaguRUTTwnX0JLDn9Zr7MDXAs1H/bnab9cLWEazrLn0CI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5289
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_04:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=843 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204280125
X-Proofpoint-ORIG-GUID: dp-NIMTM0YdDCDp1Y0vEaPAzTu6nwfuC
X-Proofpoint-GUID: dp-NIMTM0YdDCDp1Y0vEaPAzTu6nwfuC
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On a successful translation, cache the PASID Table entry
flags set at the context at the time i.e. the first 12bits.
These bits contain read, write, dirty and access for example.

This is a preparatory for SSADS which requires updating A/D
bits on a translation based on the fact that SSADS was enabled
on the given scalable mode PASID Table entry.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 hw/i386/intel_iommu.c         | 18 ++++++++++++++++--
 include/hw/i386/intel_iommu.h |  1 +
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index c64aa81a83fc..752940fa4c0e 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -314,7 +314,7 @@ out:
 /* Must be with IOMMU lock held */
 static void vtd_update_iotlb(IntelIOMMUState *s, uint16_t source_id,
                              uint16_t domain_id, hwaddr addr, uint64_t slpte,
-                             uint8_t access_flags, uint32_t level)
+                             uint8_t access_flags, uint32_t level, uint16_t pe)
 {
     VTDIOTLBEntry *entry = g_malloc(sizeof(*entry));
     uint64_t *key = g_malloc(sizeof(*key));
@@ -331,6 +331,7 @@ static void vtd_update_iotlb(IntelIOMMUState *s, uint16_t source_id,
     entry->slpte = slpte;
     entry->access_flags = access_flags;
     entry->mask = vtd_slpt_level_page_mask(level);
+    entry->sm_pe_flags = pe;
     *key = vtd_get_iotlb_key(gfn, source_id, level);
     g_hash_table_replace(s->iotlb, key, entry);
 }
@@ -965,6 +966,19 @@ static dma_addr_t vtd_get_iova_pgtbl_base(IntelIOMMUState *s,
     return vtd_ce_get_slpt_base(ce);
 }
 
+static uint64_t vtd_sm_pasid_entry_flags(IntelIOMMUState *s,
+                                         VTDContextEntry *ce)
+{
+    VTDPASIDEntry pe;
+
+    if (!s->root_scalable) {
+        return 0;
+    }
+
+    vtd_ce_get_rid2pasid_entry(s, ce, &pe);
+    return pe.val[0] & (~VTD_SM_PASID_ENTRY_SLPTPTR);
+}
+
 /*
  * Rsvd field masks for spte:
  *     vtd_spte_rsvd 4k pages
@@ -1789,7 +1803,7 @@ static bool vtd_do_iommu_translate(VTDAddressSpace *vtd_as, PCIBus *bus,
     page_mask = vtd_slpt_level_page_mask(level);
     access_flags = IOMMU_ACCESS_FLAG(reads, writes);
     vtd_update_iotlb(s, source_id, vtd_get_domain_id(s, &ce), addr, slpte,
-                     access_flags, level);
+                     access_flags, level, vtd_sm_pasid_entry_flags(s, &ce));
 out:
     vtd_iommu_unlock(s);
     entry->iova = addr & page_mask;
diff --git a/include/hw/i386/intel_iommu.h b/include/hw/i386/intel_iommu.h
index 3b5ac869db6e..11446012a94c 100644
--- a/include/hw/i386/intel_iommu.h
+++ b/include/hw/i386/intel_iommu.h
@@ -123,6 +123,7 @@ struct VTDIOTLBEntry {
     uint64_t slpte;
     uint64_t mask;
     uint8_t access_flags;
+    uint16_t sm_pe_flags;
 };
 
 /* VT-d Source-ID Qualifier types */
-- 
2.17.2

