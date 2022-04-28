Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C446C513D2D
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 23:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352094AbiD1VOx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 17:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352093AbiD1VOw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 17:14:52 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89B8771EC
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 14:11:30 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SIXQLs025808;
        Thu, 28 Apr 2022 21:11:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=OIjmxiY2DHe86aC8+wWVFVUdPJmc3VV3VhTkc/cTV58=;
 b=cVzoVnfIK2fYtjZXdk0ktjtlsoesnvFrtUdMLBRcv2BMChH9Z55lKGI8SjWL8ZK36oXv
 aUsZIfa/L4Tjt2d6WuAlKllbYc4LFXCkS7efarnWTizd3MGfWY2J5mBZ8Ng3EUbg4XLs
 hg9K+5IMnEYQ7Z1oA4K7bkD6iGNEmDIN9AGLKkY4P5jI4XDHroP9P2O6Nwj4jXLiFEQo
 twxFJAgg6CTvjj1O/uyvqsiyjgVxlwIt4EQlsE3heN+5eIm/6BnVxKAq7U1w+WwTgf0b
 FjCAxQBnapQ4g4fb5uC9qK+MKbE1swYM9rI+684JfqlW9rfpDYoWJjAU9UeUbv3NUDzE Hg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb1mwbgn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:11:11 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23SL6d6m028764;
        Thu, 28 Apr 2022 21:11:09 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5ype943-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:11:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cSTwnhoZf0wFlTCoI4umOQrOSs6kmLEyRgxXzgV5Wy7BLVCO5t/4kAKjyAitGAgCu/12PVsFK9VUzYSmMYUfniOEBpmXpTrW49x1PPx3PhiimSNW+wgBkLF66hVFgs3nKg89E2ohEHPCUwcyb19pSSF6mCl6HCuVNWrVOPg1HjsW6gTtY2I1KgDbFT5B7P7XC3UNC1vUWMCaZgr8w4QPVR9TnBwoyssQ6rrlJYIttBUQl5xALvrFDhseKW5HH0qaZ//DwT/H+vWkyYBBBv5W0Df6UGhE78dAR9B7rFRKVq2p+191pOVPDfovfhR4vTBTkNj4iBgMDWVdAQXSWZrITw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OIjmxiY2DHe86aC8+wWVFVUdPJmc3VV3VhTkc/cTV58=;
 b=ERds3r8PffZrIvO/rL75PPUB0C9y4xIMnTgjRLJ3x2OmgI0opp3X63GgZzAFEYMHAYvQkp4zEL+mJmweHiwdt/0svt6dHPwnIW5yWL68nWgbVwy+c7ELxBoJeFENraS4SaCL3Bsm5hiL7mCc3OB9Kxpo/VO+NhO4sAXKw8qblK2Cl1AeOOjCzux9sEic13rK8LksbozlFG39izd+k+ppTCJZBD5qENciS9o2jcBwuqKWF3hQX/cWjKeO62xnwj1xIovDc1H/uymNRzgtANJNj8TwSVA8JD4duurTho23ZomzfR9tjXUdUWMQIH7PufcwQ7LtEWggF66E8W3hEXcetA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OIjmxiY2DHe86aC8+wWVFVUdPJmc3VV3VhTkc/cTV58=;
 b=yf7LMXBJoQrYYsYPJamwg8ay10Me09FQKHjZF1NC1bwBDRL4xMCF6dH1Nzv/4ddn6C138fzxp74S/FdQU4mTeXgiCEodcO8n23qQK5tt6R0za7259Z+Gbj2TRrxkO3a9SDmPAg/D+eiWTS5xtSsZaOFoy2/5v+IOCU7KnHbOGVY=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM5PR10MB1564.namprd10.prod.outlook.com (2603:10b6:3:9::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.15; Thu, 28 Apr 2022 21:11:07 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 21:11:07 +0000
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
Subject: [PATCH RFC 10/19] iommu/amd: Add unmap_read_dirty() support
Date:   Thu, 28 Apr 2022 22:09:24 +0100
Message-Id: <20220428210933.3583-11-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220428210933.3583-1-joao.m.martins@oracle.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0111.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::27) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d36ae59-c1aa-4e27-0587-08da295b9c4b
X-MS-TrafficTypeDiagnostic: DM5PR10MB1564:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB1564E039FB6DE336CC5F398FBBFD9@DM5PR10MB1564.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BBBhtgf9SrM5zk9LbEkq6xNdUjS4dBSzB9PDIujpZFHPwRkGvowi/2VC5kAg2JZXOkR3uunolYrMMrUSJ/JIvYmSttBQNkIy1p4poHRCUxSMYQJdJaGuIKMh7EwKPVAcnguxPeDcDnco4q/r3njYRwpzelTp3PA8fMouWXlmngwfh4rlWCwdI0H1PPK5fs7vxJHnuSqfwWJd/QMAIlVba0/0yVCiGERMaL4n9OSTj7syCdvntNU4wA8U7qpUuCQo3i/iFDd6EH7ld8YDZLJ+KCcOlHKNM5kKgDQ0qI0BHypkiSgALVZkdpSVEYsjnor8lIF+qcHEJbRwgjd0mArtOeLwZlwYU6Fmr5HYb8dpNnyExs3WYf/jKBQDQsa6pIegOl1c4bNYBwFzVb8dqD8Iuj51NZT69CoIHoHT/WUs1ok4rqjFGiNXRv24GEYMiwEDBAGQJPBKtv43mlH7qjiph845zvIRyVfmubOCjiw/3ni4gimoOLk2SiMQPfcw0g+lnfWInns8d+Wqqb0JThoCz9iQfIobkWlFuuyJPl4g8075deUFv1AihI83zOH2rGJbQowE+iafhHSK+smlmJwDfIDZ7CDPClY8riUv0UQgHbEfgqyr3N0QUcYkRhtGzAHehkJPJLdR2mqqKA8gY3+vlyUt0oYrAKwJdUziOZIhLKvz5E0Yx83qRH8LLRbbY0VnLpF5Bj//fZ5yn12W/myMrVoLLnEPPznES2hz49L+/xw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(186003)(86362001)(66946007)(66556008)(4326008)(66476007)(8676002)(2616005)(36756003)(1076003)(103116003)(8936002)(5660300002)(7416002)(26005)(6512007)(6486002)(6916009)(83380400001)(54906003)(508600001)(6506007)(38350700002)(38100700002)(6666004)(2906002)(52116002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vvMi3VwxnpUW7qa5BRi6PUb8n6EaspacmLjQVWsxTGkneiDolmfP27rLBFZK?=
 =?us-ascii?Q?b4gHVM29EiJmpvxoDpW3VOMedOijH7MV/OzY4WRrbF3QQHsqjtr/VYDfo/8f?=
 =?us-ascii?Q?fSyluwKaBdX5JLDVnutlxK7wmH9yq0IQZk1Gjc43wbvEQ8b+77L6KH7ZV4Bm?=
 =?us-ascii?Q?A1NGZU8YjSWXTCafNsjQGo7zlf1n0LK0crRexZJKLquYm+8NTcEHIgPIFqLR?=
 =?us-ascii?Q?cCr7XpHSLRI9iOo8Uj/gd2NEDe9ADUSZUCpeKeivuoXBsRwBaPep+Xu44KZw?=
 =?us-ascii?Q?pfCCb9hCyErSBC4TyIgPBpFO9GZFiAHTW+o36F69IsygrZaOwgskvCxdSnvQ?=
 =?us-ascii?Q?D7oVahMnhHnkWvSkHhtXaHxRKG8rLPZTjIKB4YvP90qHyjyiTqW0SyHXnynM?=
 =?us-ascii?Q?zgBouVQcZiCmirWX1cFWrCkJtk75gnoK/dFlLFUcoTPJFx6g/Wn6noWQovdP?=
 =?us-ascii?Q?MObkxUcuTatRBDBHN+2Jxsfj91lHtbOjWUu/THJ4iiK1ZN289WRABCE3PPOc?=
 =?us-ascii?Q?Mf3OElCoZv58CoXDlSvZat5A9Gav7GhKJ8HJE8OPe2cWzR9f+fPvI5wERYzO?=
 =?us-ascii?Q?FIISpMEh/fe+b9wvBOnJt1ojwO3KDxNWfAUg+S9iMt39xsxyVtT010Q/Hek4?=
 =?us-ascii?Q?V48LCOulFUwRTDot4TAcyARYlfD6wUoyyH2J14UDyHrWTt7NLcmMUAhRaUX4?=
 =?us-ascii?Q?r3BLvz2zRRTU9nmILhrwfhql5Tm6q5RYqZDYulIeMDs2Vq60duKEHeIobP8b?=
 =?us-ascii?Q?VTOT2ZKFsXJ+DquTsexlNcQSSThDeGmUwiUveyhogNflwGjDQbZKAasJArgM?=
 =?us-ascii?Q?qkVIz6LpGrpxcX+7SIhhAPDhWVmHHFGHBA7+g9kUXEL6I8URByo6MfBaWmeG?=
 =?us-ascii?Q?B9ctpfP4xawS6rEEm/ydpGUL0kVb3/AnY4mOVxYstjyAK5BoQaQiLXoquRCV?=
 =?us-ascii?Q?fsDVH5D8/uBiGfOUY5AaUVeViHiIl9tyL4LE7Syn6y0iO2/jHn26BeDC+lNv?=
 =?us-ascii?Q?P0Dazn0axbl+lgVcVuoWky+h2GPt6kH0qf9BendlSeBs63HoOjObaSCxUVat?=
 =?us-ascii?Q?S2VvBGS+290jB/K+dOUBlt9h9O64a7JiyLH+zRr9mfP0SVQ3GVlf2HiJf3pC?=
 =?us-ascii?Q?YgrxZa0O5uvYI9k65eDwohJej64w3SsADyk82J9qHIXNrHU1c2473wQv2CkU?=
 =?us-ascii?Q?yqWE4P8caSMfbcQ65ZZKI13n8TjNoRBUKTMbZWH1JVK2pwPw+OnQTIhHVPCZ?=
 =?us-ascii?Q?3YmFk6gMVR9QeT8ZwfxGKZst6XEShKZ6ePf2UIrhcm3rF1KBco1EjaPmCnr9?=
 =?us-ascii?Q?gaFVx4quCxC623/3PgKuG8mPv2LuXAHcPdwaNnJtZSS+JQcIS3j/qVo3pTnJ?=
 =?us-ascii?Q?s4nIc1HDFOIJ8pB63lk1AukwojOazFAg7dpsVy86yR0YwvNDvULMekBi6awL?=
 =?us-ascii?Q?++CvJfiONUH+m9BcYEY4fEI7m9fu3ZsaXYOHayCprWg0BJZnVj9+UyyRqjUK?=
 =?us-ascii?Q?CEanaG2DaH9g7Hhq3PgbCzLvHidJdErFfbxSuOavzH1B+hKfzSLYUZkUtB+p?=
 =?us-ascii?Q?txf8uiJ+WZODfa+a/5iAEP/GNmZeYm1hUjy3pphnXD0KpSjQf+wObjVQT+Qy?=
 =?us-ascii?Q?Kic0QcvUhsn/dRBGc66MQRcWvJffFVOb9kOC9mEQfW63jncSa2/mz56jzIu0?=
 =?us-ascii?Q?vZ0D2705oCrRXLizCPLLNjtswT9Sa2huvAVJ5P8N4/ZW4Opg7utopvw4VHHs?=
 =?us-ascii?Q?n8btCUK32vue/bUyB4nDWQ6GnRxeKpA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d36ae59-c1aa-4e27-0587-08da295b9c4b
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 21:11:07.0408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fXtUrmEzcjK9mZbr6u7apQu5jxkb8U1mMYFJ1glHWYAN17OAf30MC1ZPKtJFhvKfAdOGsTHAQiKiKskDVy7Pa4I8gdiZwJPXb84bgF6QhuI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_04:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=858 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204280125
X-Proofpoint-GUID: LpyGw_fyI--zmj5HRtDBPZeEt7hT8r0z
X-Proofpoint-ORIG-GUID: LpyGw_fyI--zmj5HRtDBPZeEt7hT8r0z
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD implementation of unmap_read_dirty() is pretty simple as
mostly reuses unmap code with the extra addition of marshalling
the dirty bit into the bitmap as it walks the to-be-unmapped
IOPTE.

Extra care is taken though, to switch over to cmpxchg as opposed
to a non-serialized store to the PTE and testing the dirty bit
only set until cmpxchg succeeds to set to 0.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/amd/io_pgtable.c | 44 +++++++++++++++++++++++++++++-----
 drivers/iommu/amd/iommu.c      | 22 +++++++++++++++++
 2 files changed, 60 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index 8325ef193093..1868c3b58e6d 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -355,6 +355,16 @@ static void free_clear_pte(u64 *pte, u64 pteval, struct list_head *freelist)
 	free_sub_pt(pt, mode, freelist);
 }
 
+static bool free_pte_dirty(u64 *pte, u64 pteval)
+{
+	bool dirty = false;
+
+	while (IOMMU_PTE_DIRTY(cmpxchg64(pte, pteval, 0)))
+		dirty = true;
+
+	return dirty;
+}
+
 /*
  * Generic mapping functions. It maps a physical address into a DMA
  * address space. It allocates the page table pages if necessary.
@@ -428,10 +438,11 @@ static int iommu_v1_map_page(struct io_pgtable_ops *ops, unsigned long iova,
 	return ret;
 }
 
-static unsigned long iommu_v1_unmap_page(struct io_pgtable_ops *ops,
-				      unsigned long iova,
-				      size_t size,
-				      struct iommu_iotlb_gather *gather)
+static unsigned long __iommu_v1_unmap_page(struct io_pgtable_ops *ops,
+					   unsigned long iova,
+					   size_t size,
+					   struct iommu_iotlb_gather *gather,
+					   struct iommu_dirty_bitmap *dirty)
 {
 	struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(ops);
 	unsigned long long unmapped;
@@ -445,11 +456,15 @@ static unsigned long iommu_v1_unmap_page(struct io_pgtable_ops *ops,
 	while (unmapped < size) {
 		pte = fetch_pte(pgtable, iova, &unmap_size);
 		if (pte) {
-			int i, count;
+			unsigned long i, count;
+			bool pte_dirty = false;
 
 			count = PAGE_SIZE_PTE_COUNT(unmap_size);
 			for (i = 0; i < count; i++)
-				pte[i] = 0ULL;
+				pte_dirty |= free_pte_dirty(&pte[i], pte[i]);
+
+			if (unlikely(pte_dirty && dirty))
+				iommu_dirty_bitmap_record(dirty, iova, unmap_size);
 		}
 
 		iova = (iova & ~(unmap_size - 1)) + unmap_size;
@@ -461,6 +476,22 @@ static unsigned long iommu_v1_unmap_page(struct io_pgtable_ops *ops,
 	return unmapped;
 }
 
+static unsigned long iommu_v1_unmap_page(struct io_pgtable_ops *ops,
+					 unsigned long iova,
+					 size_t size,
+					 struct iommu_iotlb_gather *gather)
+{
+	return __iommu_v1_unmap_page(ops, iova, size, gather, NULL);
+}
+
+static unsigned long iommu_v1_unmap_page_read_dirty(struct io_pgtable_ops *ops,
+				unsigned long iova, size_t size,
+				struct iommu_iotlb_gather *gather,
+				struct iommu_dirty_bitmap *dirty)
+{
+	return __iommu_v1_unmap_page(ops, iova, size, gather, dirty);
+}
+
 static phys_addr_t iommu_v1_iova_to_phys(struct io_pgtable_ops *ops, unsigned long iova)
 {
 	struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(ops);
@@ -575,6 +606,7 @@ static struct io_pgtable *v1_alloc_pgtable(struct io_pgtable_cfg *cfg, void *coo
 	pgtable->iop.ops.unmap        = iommu_v1_unmap_page;
 	pgtable->iop.ops.iova_to_phys = iommu_v1_iova_to_phys;
 	pgtable->iop.ops.read_and_clear_dirty = iommu_v1_read_and_clear_dirty;
+	pgtable->iop.ops.unmap_read_dirty = iommu_v1_unmap_page_read_dirty;
 
 	return &pgtable->iop;
 }
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 0a86392b2367..a8fcb6e9a684 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2144,6 +2144,27 @@ static size_t amd_iommu_unmap(struct iommu_domain *dom, unsigned long iova,
 	return r;
 }
 
+static size_t amd_iommu_unmap_read_dirty(struct iommu_domain *dom,
+					 unsigned long iova, size_t page_size,
+					 struct iommu_iotlb_gather *gather,
+					 struct iommu_dirty_bitmap *dirty)
+{
+	struct protection_domain *domain = to_pdomain(dom);
+	struct io_pgtable_ops *ops = &domain->iop.iop.ops;
+	size_t r;
+
+	if ((amd_iommu_pgtable == AMD_IOMMU_V1) &&
+	    (domain->iop.mode == PAGE_MODE_NONE))
+		return 0;
+
+	r = (ops->unmap_read_dirty) ?
+		ops->unmap_read_dirty(ops, iova, page_size, gather, dirty) : 0;
+
+	amd_iommu_iotlb_gather_add_page(dom, gather, iova, page_size);
+
+	return r;
+}
+
 static phys_addr_t amd_iommu_iova_to_phys(struct iommu_domain *dom,
 					  dma_addr_t iova)
 {
@@ -2370,6 +2391,7 @@ const struct iommu_ops amd_iommu_ops = {
 		.free		= amd_iommu_domain_free,
 		.set_dirty_tracking = amd_iommu_set_dirty_tracking,
 		.read_and_clear_dirty = amd_iommu_read_and_clear_dirty,
+		.unmap_read_dirty = amd_iommu_unmap_read_dirty,
 	}
 };
 
-- 
2.17.2

