Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 504C0513D48
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 23:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352173AbiD1VSE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 17:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235788AbiD1VSB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 17:18:01 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15ED580BE6
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 14:14:45 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SJjjKJ015405;
        Thu, 28 Apr 2022 21:14:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=9NobxHFt2Af998yqPC3P34K6XbEr0IFgaKETrAv4lII=;
 b=iI30munGQf+ig3PnnFXe2BtQOmIu3F4XwkMRKci5CWtwD+gwv6VwOcmD4gWIuHBS8iYI
 IFt/Ig28s/r4CG9U0gMMGjnopB+rRhXQUhZZG1AuHRTrCMwdpZ8/o1sEtRwgh80gALuQ
 5JrwpPK71M3KEM84LgfRK487bNS2a26vJp9ZV9JuUBPU+ZI7lhRrYTTGJyEdOUCdUIbl
 iylouhElqxBih/j6O/m/OnQt4JAQUpcA4fNMDq27E8FDzQ+B9sapWFJ/5iFfhsE6ISzs
 3HNaN594/o2XZNPeYUI9GAhqgS3PkaSiezifkR/zzKZKvKnefygo0BDXKzC49ArEU0Xh tg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb9aw638-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:14:29 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23SL6Bko024994;
        Thu, 28 Apr 2022 21:14:27 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w78ccf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:14:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JuhAqpm2CYB2XJFqMusS0GSeuZ0I8P6cdwV+taV2PErcmcGfSX51LDcSMAXC2t6l6HlLSP0Xf1gkfqG9TSuqKXy4Qip+PdJ43da8XYyG6IMxYoZfwR+CTMDfaGYj1x7LCoSFzeAd6IW1vrPjlPcg2bZbcBr7Ia/iOUK5kT9cVQGa4DLgi4MBeu1lY4JrMpqTJpY7tYSQX5Wo/qO05vC681c4NTyCyAOzB7jTUChFInZwk6vI0xaUirL1sVhALrOhanMDn8Jsm6RoxDZMukOxyHC0QelauIr4QFn9iD0aVI4L7o/1PL7wQafZAUsnCfUZJ6Dob+7fGnRpfxwS+zZAxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9NobxHFt2Af998yqPC3P34K6XbEr0IFgaKETrAv4lII=;
 b=EouYm313OxJpagSJ42x+X/STO6Z0zTplH+cGcivzspo3T6b1+0gicE6icOmJelO+/eeM1qYcoF4vW/ENMugSvXa/s481RVpZjiDFYr8dSD81MThz+8o4uRpvFbfmwUBWHjksOIDB+GAboufI2uK6100m7BheRh5+VrJ7x8TEagEwHfsDIDzQdeb2gVIbb8MAxr4bXanKLQEzWLd91DakD+abtlW0ytVapo+xdnw694f2H7jiWBmNCVTlHnLC3HOAGlPko9EXj8JdYyJLXJKcp3aI9SJn/90oPSb8jH6cAwczioi5vvZkvqFn1+8vR9FKj+k6aRCxcGBIkhUIZuvz3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9NobxHFt2Af998yqPC3P34K6XbEr0IFgaKETrAv4lII=;
 b=skzyBzZ2wWscI6cr4iG1gfFFqaZmZKoeMVcv0G0XCSO+DzzHGzWFitofBUM4xz0F2vcaVeSinv7+dPntVaexyB7+F/8ZvuVNFMr2ys4iqgkECaGlxiUH0YYEnXDgqGr+aiApklLqDTXWHKjQYuoRZTJYYX9fjDTkeVLZmZbvn+A=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM6PR10MB3260.namprd10.prod.outlook.com (2603:10b6:5:1ab::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 28 Apr
 2022 21:14:25 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 21:14:25 +0000
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
Subject: [PATCH RFC 04/10] intel_iommu: Second Stage Access Dirty bit support
Date:   Thu, 28 Apr 2022 22:13:45 +0100
Message-Id: <20220428211351.3897-5-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220428211351.3897-1-joao.m.martins@oracle.com>
References: <20220428211351.3897-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0297.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::21) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8497ee26-c7ab-4302-8d8f-08da295c12a0
X-MS-TrafficTypeDiagnostic: DM6PR10MB3260:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB32606E6493199544BB8BE602BBFD9@DM6PR10MB3260.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UBcVHJ7jgyQDb8sRx860UUIBFs2Xl8IKEba8VpRc0ocfGiOGQaJblEoO9ToZB6cmBWuAJxRB3nJV6Oud8j1j5Xh4TEiL1Pdkvfzaj3bE3GGizBl1t0GHuTHnr8CCe6cDRl8gF/q3Fa2wphtnn8mVEkZXy1b69C6y16qT4IefNj7UcZZYGkpjCiagwRZArn39pKiJExvDzmtY2QcJZx9QRzz5+ve0qISd3t3j/Rang8MoKRDlOcXVBEfZqwQ3AWHx964rEQePI5krxEQcGiGakNN9682NAhfTlI+68/ygjEzuWzLdN15ZCC6nWTS7RcWHmAsmuuDM0BM/JaFkRFsHxFkgvmnyWOLobtiOfBI0GNOtVU1SxCZZ3Bcc9ukOkQLy3jsFp92IhH1G6JMbuRbjzUi1d71yM1/4/RhlYueza4SXmDsT09+uV1ZOtCvLt9cdQCooohqE6OXQsQRARZNAkuUpICAo2e9VFyrSQBQ/DlmouGHTEw3swDvBgNdpjJGkxT7FMi9xnpSz2qzorYBFI+3phZ5tp03QC+piuz0ByJpXCMxUhsP1SVv8heuxtOFqYLnRDWyI9GszKMPnEacBRZyV/HNzJ5/msPynLPlUdRzcWk+qUsu6Dsmjr9Na/6WWJGOxtGFAXVZQvgNCgekjAVX0sClfYDpoGhrGfVTUr7U5RA9Qq8Vl6r8jcawVcJnZHduu4Ktmw7Mcuo2PaR7vSBfw8SZWJdZsfrOqMPHOkx4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(66476007)(66556008)(2616005)(1076003)(186003)(54906003)(103116003)(6506007)(36756003)(6512007)(6666004)(26005)(52116002)(316002)(8676002)(66946007)(83380400001)(6916009)(8936002)(7416002)(4326008)(508600001)(2906002)(38350700002)(38100700002)(86362001)(6486002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Yd3u1McnjijFbCbkyuAXGjbnwMPvH+361PXfT1ULbz8xy8TTovvUOexdTnQ/?=
 =?us-ascii?Q?jwNw/auBTAGxkdNf3jjlgzf6bQYtEduv+2fnn9xisehN3WA9MUJsmB73bDfu?=
 =?us-ascii?Q?Qz28S1IXEj7/rT82W8Gj2JeEuZntj57uYQnhisA9Kv9kkWqrswi0CGP5HiKk?=
 =?us-ascii?Q?cbgwTo0b6RjQUp1KBxxSJHoW9daMJrQZ/yJM0hhXjnpZ+hGA4d34wPVOGiAF?=
 =?us-ascii?Q?J0bboBJShQP4Srrv6HAVya5zBRrnK39GJsTaFbgNgbuS/yYVpzEviTZkXbMr?=
 =?us-ascii?Q?1dU7XKSCs0/t4qrH+gDkjPGL5MJNdfgvR9k0fajSnuUYqq+ad0DUX1zF4chl?=
 =?us-ascii?Q?pDNdFsseW0RfKNfgmtgToGwqakMhCy3O/wtBTpoeMpi1rl/FIxZW0DaMo8xF?=
 =?us-ascii?Q?iHJ5OoAeKqKyn4xlSu+VFs8T+Vg6VAOF63/yd9xGEjWydNRyqiAsedKl5fBL?=
 =?us-ascii?Q?0Pt6kEne59L5dCVKsjhlr7/FwQTKQkPeujyaOrTtpoKV3bWWpeeOA4KuTvkT?=
 =?us-ascii?Q?KV8pTmVbYCl6AkhJ4sqtaRQLyihoiCenKDuzy5t1eW+NSqaqpL3RgXZiX2nz?=
 =?us-ascii?Q?NnfEzoKU2uK5U+Fy+d4XK3+gXbWowQcHT+3r1zYeka+O6dwQQ6rQBaZmX766?=
 =?us-ascii?Q?/ckla+JjrkbeOI7PP06sGO8Uy9SaD/Ux/tL2PeM6gR4mp+m1AET4Yw/zx5Jg?=
 =?us-ascii?Q?nJO76Sl2l7Jb5UNvWpDzqZBgKZPJYS8N/yskBcQT6g76NXq678BGqgJkzUdR?=
 =?us-ascii?Q?/h1YLDu1t0qvp9SNThfoIYMymxEAOxyPe2RxBypGE/ZGn+bSlc8sRv9G7W1v?=
 =?us-ascii?Q?EQ9zqDSWBMg5xzuaxXdyMc6bX1cyZ2jIGP8bEThkZzILm2Pc/Y+V7pSubI/o?=
 =?us-ascii?Q?8gwmUAvJDdp/DoMgcSw7KIq3zWegvu7ohT5aV/bG4g2JOkUIZiQOYeSttOza?=
 =?us-ascii?Q?ia/ZMKQ4SIxtRJay8VFK6AHm0ZdymQw4PxT1V3aIkHn0NT25UjeUGqQZ4GWz?=
 =?us-ascii?Q?REzm2WhhtvBtPnVha4CG0qaZdf7wIHkoDVBAtujMmBqYX9h36VEFDfZZipYj?=
 =?us-ascii?Q?jrwDzMsURq6S9Y7NiHaXTOISL70lDpHu/LpLTX492ZhrFGCOFPDc2ntIE31l?=
 =?us-ascii?Q?caxz9geSg81GGYBDWsGhYbDCs3ctlDTJKkT/ROFAvQu7GCaWe+YeyXCar7CW?=
 =?us-ascii?Q?PqDRUFDNaVKZEjElZETYbZqcsAPso/wv5rKaWaOVKToZcywxSl6/+vAZp0n/?=
 =?us-ascii?Q?214ZSfOKouOXfL//SSiiIbXnwT645Wk4Ixi/LyS/1WKfUv5LAWgycveKh0Zv?=
 =?us-ascii?Q?CuM3MVqsZEfEWclfO3VW4k24qvu8r7Hy/SFJkZV7iONiGulScQ8ldUyEwyRf?=
 =?us-ascii?Q?cGo5rkQpAkfX9sDvs52CZpFAjm4QhDvXt+KW6CrEAkL+t1hgwaP+6JfilXjY?=
 =?us-ascii?Q?4VcPhRIF3ehLeVGE3OhnN7VZTcziUuPjU1lfPQ99+XLqml4WwbRqktbiH4tb?=
 =?us-ascii?Q?nbuN4fL1szEVMs6GtlwBfl319OrWG/rkKkmdJaJaKMEmenvFp8MjJwlCGISC?=
 =?us-ascii?Q?LfBO1P9ic01K5VNWJnULhIYH+gg5aNUt66GuCGgIc1/LKwr/TN9pNR/lfvME?=
 =?us-ascii?Q?w5fEyzLG/kchUHOl8F+wmYbP7orGe58jMaBO6qiSCjlNx/LfJ0foffWGLv3l?=
 =?us-ascii?Q?D+BCRH3vLeEkjpr89sjCV+TbF2kszpJHbJAd9ccAOTGDlBrAdvJprdlL2Rpk?=
 =?us-ascii?Q?y/IknTxkwWkK6D6ErVwHcB8Ptll/NFs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8497ee26-c7ab-4302-8d8f-08da295c12a0
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 21:14:25.5872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bd/lB2maCEsXBiVl2e8MCwrDsqyhjj8tNCy2e/Vn2dyj99ajCM0lV8nf1JN1sl6w2obyd4qF8AAehIjmf19bxtXRTR3hWnaa1EZFsbN/vuY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3260
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_04:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204280125
X-Proofpoint-ORIG-GUID: BpLC7tB9_eGcGMSIQs_7ymksCOSorgmB
X-Proofpoint-GUID: BpLC7tB9_eGcGMSIQs_7ymksCOSorgmB
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

IOMMU advertises Access/Dirty bits if the extended capability
DMAR register reports it (ECAP, mnemonic ECAP.SSADS albeit it used
to be known as SLADS before). The first stage table, though, has no bit for
advertising Access/Dirty, unless referenced via a scalable-mode PASID Entry.
Relevant Intel IOMMU SDM ref for first stage table "3.6.2 Accessed, Extended
Accessed, and Dirty Flags" and second stage table "3.7.2 Accessed and Dirty
Flags".

To enable it we depend on scalable-mode for the second-stage table,
so we limit use of dirty-bit to scalable-mode To use SSADS, we set a bit in
the scalable-mode PASID Table entry, by setting bit 9 (SSADE). When
we do so we require flushing the context/pasid-table caches and IOTLB much
like AMD. Relevant SDM refs:

"3.7.2 Accessed and Dirty Flags"
"6.5.3.3 Guidance to Software for Invalidations,
 Table 23. Guidance to Software for Invalidations"

To read out what's dirtied, same thing as past implementations is done.
Dirty bit support is located in the same location (bit 9). The IOTLB
caches some attributes when SSADE is enabled and dirty-ness information,
so we also need to flush IOTLB to make sure IOMMU attempts to set the
dirty bit again. Relevant manuals over the hardware translation is
chapter 6 with some special mention to:

"6.2.3.1 Scalable-Mode PASID-Table Entry Programming Considerations"
"6.2.4 IOTLB"

The first 12bits of the PTE are already cached via the SLPTE pointer,
similar to how it is added in amd-iommu. Use also the previously
added PASID entry cache in order to fetch whether Dirty bit was
enabled or not in the SM second stage table.

This is useful for covering and prototyping IOMMU support for access/dirty
bits.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 hw/i386/intel_iommu.c          | 85 ++++++++++++++++++++++++++++++----
 hw/i386/intel_iommu_internal.h |  4 ++
 hw/i386/trace-events           |  2 +
 3 files changed, 82 insertions(+), 9 deletions(-)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 752940fa4c0e..e946f793a968 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -651,6 +651,21 @@ static uint64_t vtd_get_slpte(dma_addr_t base_addr, uint32_t index)
     return slpte;
 }
 
+/* Get the content of a spte located in @base_addr[@index] */
+static uint64_t vtd_set_slpte(dma_addr_t base_addr, uint32_t index,
+                              uint64_t slpte)
+{
+
+    if (dma_memory_write(&address_space_memory,
+                         base_addr + index * sizeof(slpte), &slpte,
+                         sizeof(slpte), MEMTXATTRS_UNSPECIFIED)) {
+        slpte = (uint64_t)-1;
+        return slpte;
+    }
+
+    return vtd_get_slpte(base_addr, index);
+}
+
 /* Given an iova and the level of paging structure, return the offset
  * of current level.
  */
@@ -720,6 +735,11 @@ static inline bool vtd_pe_present(VTDPASIDEntry *pe)
     return pe->val[0] & VTD_PASID_ENTRY_P;
 }
 
+static inline bool vtd_pe_slad_enabled(VTDPASIDEntry *pe)
+{
+    return pe->val[0] & VTD_SM_PASID_ENTRY_SLADE;
+}
+
 static int vtd_get_pe_in_pasid_leaf_table(IntelIOMMUState *s,
                                           uint32_t pasid,
                                           dma_addr_t addr,
@@ -1026,6 +1046,33 @@ static VTDBus *vtd_find_as_from_bus_num(IntelIOMMUState *s, uint8_t bus_num)
     return NULL;
 }
 
+static inline bool vtd_ssad_update(IntelIOMMUState *s, uint16_t pe_flags,
+                                   uint64_t *slpte, bool is_write,
+                                   bool reads, bool writes)
+{
+    bool dirty, access = reads;
+
+    if (!(pe_flags & VTD_SM_PASID_ENTRY_SLADE)) {
+        return false;
+    }
+
+    dirty = access = false;
+
+    if (is_write && writes && !(*slpte & VTD_SL_D)) {
+        *slpte |= VTD_SL_D;
+        trace_vtd_dirty_update(*slpte);
+        dirty = true;
+    }
+
+    if (((!is_write && reads) || dirty) && !(*slpte & VTD_SL_A)) {
+        *slpte |= VTD_SL_A;
+        trace_vtd_access_update(*slpte);
+        access = true;
+    }
+
+    return dirty || access;
+}
+
 /* Given the @iova, get relevant @slptep. @slpte_level will be the last level
  * of the translation, can be used for deciding the size of large page.
  */
@@ -1039,6 +1086,7 @@ static int vtd_iova_to_slpte(IntelIOMMUState *s, VTDContextEntry *ce,
     uint32_t offset;
     uint64_t slpte;
     uint64_t access_right_check;
+    uint16_t pe_flags;
 
     if (!vtd_iova_range_check(s, iova, ce, aw_bits)) {
         error_report_once("%s: detected IOVA overflow (iova=0x%" PRIx64 ")",
@@ -1054,14 +1102,7 @@ static int vtd_iova_to_slpte(IntelIOMMUState *s, VTDContextEntry *ce,
         slpte = vtd_get_slpte(addr, offset);
 
         if (slpte == (uint64_t)-1) {
-            error_report_once("%s: detected read error on DMAR slpte "
-                              "(iova=0x%" PRIx64 ")", __func__, iova);
-            if (level == vtd_get_iova_level(s, ce)) {
-                /* Invalid programming of context-entry */
-                return -VTD_FR_CONTEXT_ENTRY_INV;
-            } else {
-                return -VTD_FR_PAGING_ENTRY_INV;
-            }
+            goto inv_slpte;
         }
         *reads = (*reads) && (slpte & VTD_SL_R);
         *writes = (*writes) && (slpte & VTD_SL_W);
@@ -1081,6 +1122,14 @@ static int vtd_iova_to_slpte(IntelIOMMUState *s, VTDContextEntry *ce,
         }
 
         if (vtd_is_last_slpte(slpte, level)) {
+            pe_flags = vtd_sm_pasid_entry_flags(s, ce);
+            if (vtd_ssad_update(s, pe_flags, &slpte, is_write,
+                                *reads, *writes)) {
+                slpte = vtd_set_slpte(addr, offset, slpte);
+                if (slpte == (uint64_t)-1) {
+                    goto inv_slpte;
+                }
+            }
             *slptep = slpte;
             *slpte_level = level;
             return 0;
@@ -1088,6 +1137,16 @@ static int vtd_iova_to_slpte(IntelIOMMUState *s, VTDContextEntry *ce,
         addr = vtd_get_slpte_addr(slpte, aw_bits);
         level--;
     }
+
+inv_slpte:
+    error_report_once("%s: detected read error on DMAR slpte "
+                      "(iova=0x%" PRIx64 ")", __func__, iova);
+    if (level == vtd_get_iova_level(s, ce)) {
+        /* Invalid programming of context-entry */
+        return -VTD_FR_CONTEXT_ENTRY_INV;
+    } else {
+        return -VTD_FR_PAGING_ENTRY_INV;
+    }
 }
 
 typedef int (*vtd_page_walk_hook)(IOMMUTLBEvent *event, void *private);
@@ -1742,6 +1801,13 @@ static bool vtd_do_iommu_translate(VTDAddressSpace *vtd_as, PCIBus *bus,
         slpte = iotlb_entry->slpte;
         access_flags = iotlb_entry->access_flags;
         page_mask = iotlb_entry->mask;
+        if (vtd_ssad_update(s, iotlb_entry->sm_pe_flags, &slpte, is_write,
+                            access_flags & IOMMU_RO, access_flags & IOMMU_WO)) {
+                uint32_t offset;
+
+                offset = vtd_iova_level_offset(addr, vtd_get_iova_level(s, &ce));
+                vtd_set_slpte(addr, offset, slpte);
+        }
         goto out;
     }
 
@@ -3693,7 +3759,8 @@ static void vtd_init(IntelIOMMUState *s)
 
     /* TODO: read cap/ecap from host to decide which cap to be exposed. */
     if (s->scalable_mode) {
-        s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_SLTS;
+        s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_SLTS |
+                   VTD_ECAP_SLADS;
     }
 
     if (s->snoop_control) {
diff --git a/hw/i386/intel_iommu_internal.h b/hw/i386/intel_iommu_internal.h
index 1ff13b40f9bb..c00f6e7b4a72 100644
--- a/hw/i386/intel_iommu_internal.h
+++ b/hw/i386/intel_iommu_internal.h
@@ -192,6 +192,7 @@
 #define VTD_ECAP_MHMV               (15ULL << 20)
 #define VTD_ECAP_SRS                (1ULL << 31)
 #define VTD_ECAP_SMTS               (1ULL << 43)
+#define VTD_ECAP_SLADS              (1ULL << 45)
 #define VTD_ECAP_SLTS               (1ULL << 46)
 
 /* CAP_REG */
@@ -492,6 +493,7 @@ typedef struct VTDRootEntry VTDRootEntry;
 
 #define VTD_SM_PASID_ENTRY_AW          7ULL /* Adjusted guest-address-width */
 #define VTD_SM_PASID_ENTRY_DID(val)    ((val) & VTD_DOMAIN_ID_MASK)
+#define VTD_SM_PASID_ENTRY_SLADE       (1ULL << 9)
 
 /* Second Level Page Translation Pointer*/
 #define VTD_SM_PASID_ENTRY_SLPTPTR     (~0xfffULL)
@@ -515,5 +517,7 @@ typedef struct VTDRootEntry VTDRootEntry;
 #define VTD_SL_PT_BASE_ADDR_MASK(aw) (~(VTD_PAGE_SIZE - 1) & VTD_HAW_MASK(aw))
 #define VTD_SL_IGN_COM              0xbff0000000000000ULL
 #define VTD_SL_TM                   (1ULL << 62)
+#define VTD_SL_A                    (1ULL << 8)
+#define VTD_SL_D                    (1ULL << 9)
 
 #endif
diff --git a/hw/i386/trace-events b/hw/i386/trace-events
index eb5f075873cd..e4122ee8a999 100644
--- a/hw/i386/trace-events
+++ b/hw/i386/trace-events
@@ -66,6 +66,8 @@ vtd_frr_new(int index, uint64_t hi, uint64_t lo) "index %d high 0x%"PRIx64" low
 vtd_warn_invalid_qi_tail(uint16_t tail) "tail 0x%"PRIx16
 vtd_warn_ir_vector(uint16_t sid, int index, int vec, int target) "sid 0x%"PRIx16" index %d vec %d (should be: %d)"
 vtd_warn_ir_trigger(uint16_t sid, int index, int trig, int target) "sid 0x%"PRIx16" index %d trigger %d (should be: %d)"
+vtd_access_update(uint64_t slpte) "slpte 0x%"PRIx64
+vtd_dirty_update(uint64_t slpte) "slpte 0x%"PRIx64
 
 # amd_iommu.c
 amdvi_evntlog_fail(uint64_t addr, uint32_t head) "error: fail to write at addr 0x%"PRIx64" +  offset 0x%"PRIx32
-- 
2.17.2

