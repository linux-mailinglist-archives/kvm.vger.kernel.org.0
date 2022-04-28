Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E63C513D1F
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 23:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352067AbiD1VOb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 17:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352025AbiD1VO3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 17:14:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3269D728FE
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 14:11:12 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SJYOFX015530;
        Thu, 28 Apr 2022 21:10:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=CUmRoBPqVYaqr0SxHh1fixayjJ3SERmIxGlj220iSJA=;
 b=WqxsTQwoTlHH1iEUmbhMZPqEXKfQaqhaD5nYNuXEGU+E/ofpWhuuXNtL3Bwz/T+Vt3wd
 LVFaeUJ9VLAzByDutQTVMRa4OhI4qfet3oNifBvybOjj9f3Z9oGXE7krFsHjHVEAuw+M
 9ukIWVweO0vP12dhK5o0CD4GdgLIQgjbEsZVnhWmmFZeQxQMr+zpIC+P/TcdIHXQ4zQb
 n8IlUuJDt9S/2iOk/NnkTghihj1QWM6uY3vYSVriiYFA7Xh8kuhHExlBxmCKt/CzGP/K
 vxNxI2o8vK0chihtD48Xb8TFD0su5m1/ifBXJe5/qSvjny9arrHea/CFvQwZ0rrNAJU5 bA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb9aw5ve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:10:43 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23SL5Ca5028531;
        Thu, 28 Apr 2022 21:10:41 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w79ns8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:10:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BZ8J0BlSMP7ozEcgetktxPyM9ThWXtwk1y/jBeBqELPs9aMcAh9tDnKiICTSGq604bIiMgWUY8/8sbYKEUcA92OKQEz8HlDX6V2OJGZQ9KP0VJajoPvHSEvW6RyL/1Qt52cBO5kHNeQKhN9F6tewAhQwHkZvKWQCJpxN1JBBamTWgqOJWYOjqrHOWvjQJRHEZvXZ8xBYb5xmy1WKm15Xjbzi8VFscS4OSTf54Gde2Ffg4iCR6wzt/FWeJh6pZWeKtNim+U8nfPWZNu8BR1yByqA5KdDNXLqR0kKUO2WpUNv8OdKIfx4UeXUD2nG6pMXFn+R7ANoK4sQMaFjXwAs8CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CUmRoBPqVYaqr0SxHh1fixayjJ3SERmIxGlj220iSJA=;
 b=NkrgRpTMbqRfttJQRG0wX35/T0z0Abbho9ZwgZdBJhiQm9NpLCw61CBpvqYk3MhXdmLq/um2fLNx6/3M8jGribdtXk99kQnqiq0Z2YAqR+LMXt/a7I7wDY+okJbEFqHx2VEfDT9lj8FiOa0kpL2+GX8TIc18NzK7dnmgZheOXp5R8fazgO5mMsYvSKytwwhdzwOrjJLNGrV2fFghE1NxqYjC4IBeU8H1BjfP3E228Aj7U5jtGIkrAHocbSG50MeGkwXRG3JcHwDRaL+7xrbYa44ISIX0oPMaN7O/AUk0Asz+ZOerC3x+miEKAH5VHXOTSCzeEeOi4ZszBOF+8YQ4bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CUmRoBPqVYaqr0SxHh1fixayjJ3SERmIxGlj220iSJA=;
 b=PmaGtVdh/Uyg4IHiFlSawtjdciUuYNaRRsrOSIhFEGgMhdoyTQB7oIWWB0df+EdNMfQTTc7idAy30N8xApTzRXW1YJ9YuoipZ7fZdTrXJCm9wWU9rjocK+4jLzmbOKNF098mAD/ygPVBU+lImERV549AJjhrCTzoa+ujiFETUwA=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM5PR10MB1564.namprd10.prod.outlook.com (2603:10b6:3:9::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.15; Thu, 28 Apr 2022 21:10:39 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 21:10:39 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
To:     iommu@lists.linux-foundation.org
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH RFC 03/19] iommufd: Dirty tracking data support
Date:   Thu, 28 Apr 2022 22:09:17 +0100
Message-Id: <20220428210933.3583-4-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220428210933.3583-1-joao.m.martins@oracle.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0111.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::27) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e53cf57e-1943-4f24-caaa-08da295b8bf5
X-MS-TrafficTypeDiagnostic: DM5PR10MB1564:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB1564C1D03859EEFEB591AEADBBFD9@DM5PR10MB1564.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iNZWiEdfEHJKBUtzcFmU2PWItQnuX0gPCMneBxkBagakQzha5a+4uMEDusU3F/7fLL4s6pYnoM8Q3bvKOvHD991TzTUxkoqv2q5hNbMBeI/DanwgTl1iIIRiHt1SE66lft/tGsla3SpucJn2p6WCqgx+HSkYDbY+NlrJuxDr+9tdirR3qQZGPrvwiCtIbfDjb8/lD73ylQWJiRvbYGUKUNBQUsEdUcA5j6y1CzKyWMTlle5/GzAy/32s6x5KES9DtDKtUXYRCfQQvooocyTzAFDqAzvOTmw78HVzJ09Sxzh31jEGhFTuCojH0O0y21zdgdk7Eo1FFOZNPur/CpX2qhLQraePGe9Pb5MbB6fses3PXorEW/RJqyEDn5vuiivAC64mjoSm4fs8rxjsp9va0MNwicrThojxAGhjYeacWhh7U2J3QivejAoj1wLkDwdEYLUiRYD4AAZqQsCzxmz/x7ydGBsg8ipjPzHR2g46i+EyVYub7Y9H3B9Y9E+EnzjogbEOIm/JKc1QBy6lsI87qICzUw9/QvSNyzz62hroRCPW0ybuk9oUS3Ed8blQWLw2XddCropbH6IHmgnF46hhRV0Y/NnAkk+AiOpUWj4cCxqLm78zRMVFHNIrUVZF67k6xxIeTVf6UrLN4ij+fR1kugZ6rgno5H3XeKBUNwf8dp6YmILBeetvFwbeLrRQr0LoJoameG+jBrwtataMb9nal30sycxzHpBTrRuG3C2S0j4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(186003)(86362001)(66946007)(66556008)(4326008)(66476007)(8676002)(2616005)(36756003)(1076003)(103116003)(8936002)(5660300002)(7416002)(26005)(6512007)(6486002)(6916009)(83380400001)(54906003)(508600001)(6506007)(38350700002)(38100700002)(6666004)(2906002)(52116002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mr0DMVgqxEozX+KOcgfuFO/28vGb8SnGFHNerVVMlfEWOQOu4wCBItrsf/tr?=
 =?us-ascii?Q?0xLvVIfbE5vIYKxkxAQoHTU5NxqsOle8vqq4K3cYjlv7rloVKLPcCkAhsGws?=
 =?us-ascii?Q?ZhYArLrcCQNXdwoUJj6+AFdmm7H1jMVdNhSfvdzQhiHnD6wvtvamejXWxZBZ?=
 =?us-ascii?Q?MKsTqR/1N4C0deyIyzlmw/LJ+Y3N9Xyyi8DvnxKn3ojn47BvOmDq0Ri0C8Yh?=
 =?us-ascii?Q?wB0qp5IhSwWP5ahESQdX7SNvFiO2icqL2tQO4hvB0HIuQnib7BAVNaIpMXdQ?=
 =?us-ascii?Q?54eH8ThpEJHBfvTgL0kB6YTZIWzujIF6dcdNf7LXgOa9Xa4Nslv9vu5KHHWs?=
 =?us-ascii?Q?xyRiqfhGq5pbMVfoTcT0m4193BlYcT1hYqKxNACFXnuapBGaSeTiwJYkyd7H?=
 =?us-ascii?Q?MU38w5gYnoGNmwvwh+pgcpo07rjOisVmMkFnPWegQrHuqB5yLlzZK0a/0MNM?=
 =?us-ascii?Q?GBFWS2uXdDGRSId6jb6PMnaKAtqErJgSfKjNtI/D9NX9rK35v/mish2tK+O0?=
 =?us-ascii?Q?0x/4PY4RJe5umnmZZHCaTBpGAcohgs3+GmylAl8bQgaEMCTkM+pYEY4k3wy5?=
 =?us-ascii?Q?zYYRouykDcn4eGXXW5G2DcbaKX0URatHE9SVCrH8wTujo4xyj29WTcqAQAZp?=
 =?us-ascii?Q?YGprwO5XZWnlecgNODHaFWbdlF07K7dPRLaZU3MKPsYG7V46yF2CwJQ53DXX?=
 =?us-ascii?Q?M0Fuc2Pc78s8bsKQ0zRbyM2bltY9jv+VXJG5ML95NaPz1Lx9Zprpz+DEKE7Y?=
 =?us-ascii?Q?u0dv4Js77FUm0fCFnb66OXe4rvTT37RLTMHcymexRIj3P2xIWe1Bx+J9hRIy?=
 =?us-ascii?Q?pZmP/Iys0aXeLVyZW7LIvFUplSMQTpPHD3b+TYMobM4wR94XBBdenP786bb5?=
 =?us-ascii?Q?rfv4eGv5vhWvpr0GuxaAxeC+Qw1Y92/fRbO5bvKX+vJBFuH0GOOt645I8Vxw?=
 =?us-ascii?Q?TOb799VNcI0dxIPvPsbIhs9CxVNAo6jc+do4SwaFX7HUHd52bocR3LtXFMOw?=
 =?us-ascii?Q?ifv0xHe2usN25DRIFGEwpIDxqTLj/p/czk+z/23WlX3ofJscBJJ+66CidrmL?=
 =?us-ascii?Q?EwDqL04ZbXexhjvPI2ojD02x5fy6nVtVsLUKVzPfOQXBZBZPJNvST9k58FUB?=
 =?us-ascii?Q?NSWjjQKni+40LGG/VrMmNREe/kg4+Z3u9LxBKB63OhChm2FM3QmBpQMf65Jo?=
 =?us-ascii?Q?Q6GDKj4Fre9nj+NhCvJlCVgejizU1nbW5g2/ebdpMbgibUv3b18pR6A67jAZ?=
 =?us-ascii?Q?8W9ySJddeSCDVSmgO7UCb/QLl/R7MJxbdaAEbqYQ0g+RZ2XdsRKEfmrZ39bX?=
 =?us-ascii?Q?u4JrSZU+KmMTZmgytAQMHy7mLfupLHLdW+d45eZ3jUD93Xrw/TsU1VC2rUiz?=
 =?us-ascii?Q?ijrnOzQFD4+bL/P9Uw9LuPUHJj6LPHlJ4uIsDC/dcI1CVOrf5EbXIgF9M2os?=
 =?us-ascii?Q?FKSJ5Sfu5Va8xkwPboaXGeZtVNIn8mYBOEQhIFJP/6FIFT0GVmUue9fId5pj?=
 =?us-ascii?Q?rWy/JHnAAf2Q4LIQ7ESr8kyx3t3F5RnWLVcAw551cTgdSKyCCEjTOoNsNH9k?=
 =?us-ascii?Q?hiXrKuzqnAqfNt1xWjQ4vUpTkFcthZq3D2sHmg/nhYMlMNv26qOMw3UoKj3G?=
 =?us-ascii?Q?NHtsT2qz4+/+jz+KJXGSKfVBQnBjM3oUJlga5k5jol3kyjjJs352U6SDNfga?=
 =?us-ascii?Q?7sKCpzl0X81NVP5ZGNC4bNDAt4QE52hpuk/oVcF86IauTHCdBk5wSEKomW3t?=
 =?us-ascii?Q?B//MCNzcdF8Y+oAgqUWvFIs8fWSHp/s=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e53cf57e-1943-4f24-caaa-08da295b8bf5
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 21:10:39.5593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nmug+DOMsnElHxD0BPDF18Y45ia8SzIwT7oMoZuW1f+sZBeh28eDDYBQdjFnIMsHkg6iiqC+SuQpWJJSWliLvL8wmMV0EPk5WI69Ce1bYMc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_04:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204280125
X-Proofpoint-ORIG-GUID: ZqozNA_0JF9tZu64zWWLZkhcVsLpExM1
X-Proofpoint-GUID: ZqozNA_0JF9tZu64zWWLZkhcVsLpExM1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an IO pagetable API iopt_read_and_clear_dirty_data() that
performs the reading of dirty IOPTEs for a given IOVA range and
then copying back to userspace from each area-internal bitmap.

Underneath it uses the IOMMU equivalent API which will read the
dirty bits, as well as atomically clearing the IOPTE dirty bit
and flushing the IOTLB at the end. The dirty bitmaps pass an
iotlb_gather to allow batching the dirty-bit updates.

Most of the complexity, though, is in the handling of the user
bitmaps to avoid copies back and forth. The bitmap user addresses
need to be iterated through, pinned and then passing the pages
into iommu core. The amount of bitmap data passed at a time for a
read_and_clear_dirty() is 1 page worth of pinned base page
pointers. That equates to 16M bits, or rather 64G of data that
can be returned as 'dirtied'. The flush the IOTLB at the end of
the whole scanned IOVA range, to defer as much as possible the
potential DMA performance penalty.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/iommufd/io_pagetable.c    | 169 ++++++++++++++++++++++++
 drivers/iommu/iommufd/iommufd_private.h |  44 ++++++
 2 files changed, 213 insertions(+)

diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index f4609ef369e0..835b5040fce9 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -14,6 +14,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
+#include <uapi/linux/iommufd.h>
 
 #include "io_pagetable.h"
 
@@ -347,6 +348,174 @@ int iopt_set_dirty_tracking(struct io_pagetable *iopt,
 	return ret;
 }
 
+int iommufd_dirty_iter_init(struct iommufd_dirty_iter *iter,
+			    struct iommufd_dirty_data *bitmap)
+{
+	struct iommu_dirty_bitmap *dirty = &iter->dirty;
+	unsigned long bitmap_len;
+
+	bitmap_len = dirty_bitmap_bytes(bitmap->length >> dirty->pgshift);
+
+	import_single_range(WRITE, bitmap->data, bitmap_len,
+			    &iter->bitmap_iov, &iter->bitmap_iter);
+	iter->iova = bitmap->iova;
+
+	/* Can record up to 64G at a time */
+	dirty->pages = (struct page **) __get_free_page(GFP_KERNEL);
+
+	return !dirty->pages ? -ENOMEM : 0;
+}
+
+void iommufd_dirty_iter_free(struct iommufd_dirty_iter *iter)
+{
+	struct iommu_dirty_bitmap *dirty = &iter->dirty;
+
+	if (dirty->pages) {
+		free_page((unsigned long) dirty->pages);
+		dirty->pages = NULL;
+	}
+}
+
+bool iommufd_dirty_iter_done(struct iommufd_dirty_iter *iter)
+{
+	return iov_iter_count(&iter->bitmap_iter) > 0;
+}
+
+static inline unsigned long iommufd_dirty_iter_bytes(struct iommufd_dirty_iter *iter)
+{
+	unsigned long left = iter->bitmap_iter.count - iter->bitmap_iter.iov_offset;
+
+	left = min_t(unsigned long, left, (iter->dirty.npages << PAGE_SHIFT));
+
+	return left;
+}
+
+unsigned long iommufd_dirty_iova_length(struct iommufd_dirty_iter *iter)
+{
+	unsigned long left = iommufd_dirty_iter_bytes(iter);
+
+	return ((BITS_PER_BYTE * left) << iter->dirty.pgshift);
+}
+
+unsigned long iommufd_dirty_iova(struct iommufd_dirty_iter *iter)
+{
+	unsigned long skip = iter->bitmap_iter.iov_offset;
+
+	return iter->iova + ((BITS_PER_BYTE * skip) << iter->dirty.pgshift);
+}
+
+void iommufd_dirty_iter_advance(struct iommufd_dirty_iter *iter)
+{
+	iov_iter_advance(&iter->bitmap_iter, iommufd_dirty_iter_bytes(iter));
+}
+
+void iommufd_dirty_iter_put(struct iommufd_dirty_iter *iter)
+{
+	struct iommu_dirty_bitmap *dirty = &iter->dirty;
+
+	if (dirty->npages)
+		unpin_user_pages(dirty->pages, dirty->npages);
+}
+
+int iommufd_dirty_iter_get(struct iommufd_dirty_iter *iter)
+{
+	struct iommu_dirty_bitmap *dirty = &iter->dirty;
+	unsigned long npages;
+	unsigned long ret;
+	void *addr;
+
+	addr = iter->bitmap_iov.iov_base + iter->bitmap_iter.iov_offset;
+	npages = iov_iter_npages(&iter->bitmap_iter,
+				 PAGE_SIZE / sizeof(struct page *));
+
+	ret = pin_user_pages_fast((unsigned long) addr, npages,
+				  FOLL_WRITE, dirty->pages);
+	if (ret <= 0)
+		return -EINVAL;
+
+	dirty->npages = ret;
+	dirty->iova = iommufd_dirty_iova(iter);
+	dirty->start_offset = offset_in_page(addr);
+	return 0;
+}
+
+static int iommu_read_and_clear_dirty(struct iommu_domain *domain,
+				      struct iommufd_dirty_data *bitmap)
+{
+	const struct iommu_domain_ops *ops = domain->ops;
+	struct iommu_iotlb_gather gather;
+	struct iommufd_dirty_iter iter;
+	int ret = 0;
+
+	if (!ops || !ops->read_and_clear_dirty)
+		return -EOPNOTSUPP;
+
+	iommu_dirty_bitmap_init(&iter.dirty, bitmap->iova,
+				__ffs(bitmap->page_size), &gather);
+	ret = iommufd_dirty_iter_init(&iter, bitmap);
+	if (ret)
+		return -ENOMEM;
+
+	for (; iommufd_dirty_iter_done(&iter);
+	     iommufd_dirty_iter_advance(&iter)) {
+		ret = iommufd_dirty_iter_get(&iter);
+		if (ret)
+			break;
+
+		ret = ops->read_and_clear_dirty(domain,
+			iommufd_dirty_iova(&iter),
+			iommufd_dirty_iova_length(&iter), &iter.dirty);
+
+		iommufd_dirty_iter_put(&iter);
+
+		if (ret)
+			break;
+	}
+
+	iommu_iotlb_sync(domain, &gather);
+	iommufd_dirty_iter_free(&iter);
+
+	return ret;
+}
+
+int iopt_read_and_clear_dirty_data(struct io_pagetable *iopt,
+				   struct iommu_domain *domain,
+				   struct iommufd_dirty_data *bitmap)
+{
+	unsigned long iova, length, iova_end;
+	struct iommu_domain *dom;
+	struct iopt_area *area;
+	unsigned long index;
+	int ret = -EOPNOTSUPP;
+
+	iova = bitmap->iova;
+	length = bitmap->length - 1;
+	if (check_add_overflow(iova, length, &iova_end))
+		return -EOVERFLOW;
+
+	down_read(&iopt->iova_rwsem);
+	area = iopt_find_exact_area(iopt, iova, iova_end);
+	if (!area) {
+		up_read(&iopt->iova_rwsem);
+		return -ENOENT;
+	}
+
+	if (!domain) {
+		down_read(&iopt->domains_rwsem);
+		xa_for_each(&iopt->domains, index, dom) {
+			ret = iommu_read_and_clear_dirty(dom, bitmap);
+			if (ret)
+				break;
+		}
+		up_read(&iopt->domains_rwsem);
+	} else {
+		ret = iommu_read_and_clear_dirty(domain, bitmap);
+	}
+
+	up_read(&iopt->iova_rwsem);
+	return ret;
+}
+
 struct iopt_pages *iopt_get_pages(struct io_pagetable *iopt, unsigned long iova,
 				  unsigned long *start_byte,
 				  unsigned long length)
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index d00ef3b785c5..4c12b4a8f1a6 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -8,6 +8,8 @@
 #include <linux/xarray.h>
 #include <linux/refcount.h>
 #include <linux/uaccess.h>
+#include <linux/iommu.h>
+#include <linux/uio.h>
 
 struct iommu_domain;
 struct iommu_group;
@@ -49,8 +51,50 @@ int iopt_unmap_iova(struct io_pagetable *iopt, unsigned long iova,
 		    unsigned long length);
 int iopt_unmap_all(struct io_pagetable *iopt);
 
+struct iommufd_dirty_data {
+	unsigned long iova;
+	unsigned long length;
+	unsigned long page_size;
+	unsigned long *data;
+};
+
 int iopt_set_dirty_tracking(struct io_pagetable *iopt,
 			    struct iommu_domain *domain, bool enable);
+int iopt_read_and_clear_dirty_data(struct io_pagetable *iopt,
+				   struct iommu_domain *domain,
+				   struct iommufd_dirty_data *bitmap);
+
+struct iommufd_dirty_iter {
+	struct iommu_dirty_bitmap dirty;
+	struct iovec bitmap_iov;
+	struct iov_iter bitmap_iter;
+	unsigned long iova;
+};
+
+void iommufd_dirty_iter_put(struct iommufd_dirty_iter *iter);
+int iommufd_dirty_iter_get(struct iommufd_dirty_iter *iter);
+int iommufd_dirty_iter_init(struct iommufd_dirty_iter *iter,
+			    struct iommufd_dirty_data *bitmap);
+void iommufd_dirty_iter_free(struct iommufd_dirty_iter *iter);
+bool iommufd_dirty_iter_done(struct iommufd_dirty_iter *iter);
+void iommufd_dirty_iter_advance(struct iommufd_dirty_iter *iter);
+unsigned long iommufd_dirty_iova_length(struct iommufd_dirty_iter *iter);
+unsigned long iommufd_dirty_iova(struct iommufd_dirty_iter *iter);
+static inline unsigned long dirty_bitmap_bytes(unsigned long nr_pages)
+{
+	return (ALIGN(nr_pages, BITS_PER_TYPE(u64)) / BITS_PER_BYTE);
+}
+
+/*
+ * Input argument of number of bits to bitmap_set() is unsigned integer, which
+ * further casts to signed integer for unaligned multi-bit operation,
+ * __bitmap_set().
+ * Then maximum bitmap size supported is 2^31 bits divided by 2^3 bits/byte,
+ * that is 2^28 (256 MB) which maps to 2^31 * 2^12 = 2^43 (8TB) on 4K page
+ * system.
+ */
+#define DIRTY_BITMAP_PAGES_MAX  ((u64)INT_MAX)
+#define DIRTY_BITMAP_SIZE_MAX   dirty_bitmap_bytes(DIRTY_BITMAP_PAGES_MAX)
 
 int iopt_access_pages(struct io_pagetable *iopt, unsigned long iova,
 		      unsigned long npages, struct page **out_pages, bool write);
-- 
2.17.2

