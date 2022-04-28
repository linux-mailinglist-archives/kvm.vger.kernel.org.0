Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56B0C513D3D
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 23:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352114AbiD1VPc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 17:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351560AbiD1VP3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 17:15:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7517FF5E
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 14:11:55 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SJNZ6Y015535;
        Thu, 28 Apr 2022 21:11:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Tj8L04emcw+t2hd7kxDF8zDoSb+8xHICG4zLHgb/VuY=;
 b=x4B2fCkzx1Lz3uA6nqtp3ATVkJ+HaWHmGat2lzyqhUDbxzrwUL5Yem3nFuB/8JPoWuCG
 yM51IhNT6VbMXTx/mtOQrm+SkgfMRKt/6TB5zhqLbDB9ICPAaAGPBzIrVUNRWBsAlUfv
 RFCMe9j7TCyvMmc3x5AJCk0LBtH0BMDqlDRoLOe4i8mcPHVL+45gTPV3wAczoKqPk2e7
 hcN45QeXvzivblCfJPdqKz5WeyIfSGLCCmT49eqiDO78K4gx98D9VqZyVB2UxzaKmnwG
 6rJCnv9ZmNva7zaFrH/fbghxic4JLx8NZtFnZ70bWZT/9VdOhRWaL5nWeQPHOac9YiA6 aA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb9aw5x9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:11:35 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23SL5CuW028560;
        Thu, 28 Apr 2022 21:11:33 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w79p9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:11:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ca4Lg5167hFUuO9p2hSF6fvvW6TZQ8XNixohghysDPZdRKK3ZPTTgk+46icUaGo4Z/aTpi3B8HZW2y4RZHDrIzGAR7nwpKXHiaql77wmkulHj465bQELJi3IyiAuF3iErl0hA5gNMVruHEN1onPi5GL6FE+WuAVJwCMrJErx00Lmq/90Vx2PpqCi5P/hP76HG2D4WF0+UNNrYbHT++qJ1qwX7u+0ABuTGlxHqFxM/4v3s3uKadkhhZ/y1Ie855IgxPpTLQnz98PfM2QxcE40EA9Y7B+w2KV2jKoyf30wB0GUZ5TZmvgkWn+lL4s5qtxTG7cfSJGTx0QbnYGBUinhiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tj8L04emcw+t2hd7kxDF8zDoSb+8xHICG4zLHgb/VuY=;
 b=QtOQhwDObpMtUEm58dk6YpO36TdCYY2gnMbzu92Gv8WSLBy+lBiCiHgWe79x81tzW8VjVWhQ+cYB6rrp1MVbovFVC3QXZC2jq18yoMFoYfIO3LPKDaomomHJAbzdzdx9M+PJ3wne/Wp+ffHe3QHSPQrjRdMygpnkPmSrcQVaXm4EBsTpg+qZH84v+pNEmixCAQJ+dTMg6fYnt0VjQmUTZrJHMUMQ5W+jIOJ2S/wZ13z2Oz5woEr8svQyXNU3PSZ9Wz+/gMUJpBATqgJiInxSHAH71ztRmGJ5XDwO1S9iY6ygMmQL6Mzv3JmqwwFXoDYh5wtXexl8RAZCV6by+5iVzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tj8L04emcw+t2hd7kxDF8zDoSb+8xHICG4zLHgb/VuY=;
 b=B69ZvgmiVhDPeN6NecqYvlz/8p4/WZYg6uu5i1CE9kmTnn0fryK7/D16Q806JuQ1Q3vaJ3DZmSNGS4OYg/EINcz1y5AjpCetPCe0zJ9KFBuPJgNFfc2GZzja/R3i678NbQEt6h+Tt9054V80dnSOZf6OJuQ/SygZYDgRyoCBw8E=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MWHPR10MB1630.namprd10.prod.outlook.com (2603:10b6:301:a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 28 Apr
 2022 21:11:31 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 21:11:31 +0000
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
Subject: [PATCH RFC 17/19] iommu/arm-smmu-v3: Add unmap_read_dirty() support
Date:   Thu, 28 Apr 2022 22:09:31 +0100
Message-Id: <20220428210933.3583-18-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220428210933.3583-1-joao.m.martins@oracle.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0111.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::27) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6179d43-38ce-4d90-09c1-08da295baaa5
X-MS-TrafficTypeDiagnostic: MWHPR10MB1630:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB16306E30D1F610C36E1114CBBBFD9@MWHPR10MB1630.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eom+rOjHsHZ6B5zNDYa4qyG1Rhp+TcX8mew7CA2uYz/DVm7si3CTqV/agiRusVLRYqnPuLHYt+twS3n/RWrOGis02jXEr9frGeiC+iCRqdfrZdMYzYQcTHyBMDYW69IC5e+m9epb3PDwbuktlrmge8DfGbIVnxINsU80xPQX69bO7cr/HkwvLMWxrXduBCP0ji7Wq0G+T383ojAVvmHRgXXEYBq/8DPw52/+SkRLOQSyFnIoch3n+utS8B0hJH/HP+5LHRQBFEGFz7LqFXIaueF7DgN7h9Bf+wQegnY/tZjTF8JhrBkmATL/UZYay8+VR31QnxRbbxdyzN+XF0ia7JcXPUOU1DUVzsaASVBGK6iP0P876FfVUl/8IHKGOWzu8fOsshYxp1k/fcn2rv+n4XcfjH1JLVSV/ZabL4WjOEZRuJf9xamqPtnUgpTQMwXqFxezROUOZ6n2ifh3XtcJZQjSZgCPeBTHh6RK/h+SbyBnLdbzJthtS9ZjdCYLHAAYgcb3Y1Otn3XulJFckMXFhTh5kC6mFk3qVUq4RyjqukD2ZuXOXOVmcNMX9T8l/Y5YgYxSatCwweKRDZD3FhY4wcLCbyfp7F2ptwT+Cac5eBn4a7iN1yRRurXm6bs/Cg+EF4TBTpcg06++TX9ed2+4Rvld6YXEGMjVViG325e6XXhsh0LBmCSxr8i74cERLPbdcGl3YsxZwMm6qvzxdGX+P3g+8Tn7PYsQmD06EWU8tdY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(6486002)(6512007)(2906002)(66946007)(66476007)(66556008)(38100700002)(4326008)(38350700002)(7416002)(103116003)(8936002)(6506007)(5660300002)(26005)(52116002)(508600001)(2616005)(6916009)(54906003)(1076003)(36756003)(83380400001)(316002)(186003)(86362001)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FBvQZThSENt+1J05z3advwKTzTpuYsn6rPgoOxj3mcnf2PDjdINvsQ9Jr5d+?=
 =?us-ascii?Q?W0HaueWrSyGUDU6BGAmy8j+jxkMOO5lj3iNF2tXEZdCrG5ECViUWbGSanBii?=
 =?us-ascii?Q?XXXCVhCPIkMXROBQmVQe7uM354ODtPzIi40KW5Sg0z8YO7PHMIi8ftYTaWZ5?=
 =?us-ascii?Q?8VR+7FuL83nYDiP194eX7AnYwo7DKJSZP+7KCKZMHcanNivrPW4iJnmvjvw1?=
 =?us-ascii?Q?5Ii0zoYZ2OMYRnKTkQHoArbKxUpnaGz8zhvnmUp/xrKBPiL/36pxTeyEAhBC?=
 =?us-ascii?Q?WuXkKz1EpQ80qt41lggqrYWu4bv/fQP4tj1QfpELqNuth+FRWlCS4UcLyKLT?=
 =?us-ascii?Q?Q/wrbmRP+pmgVxdVybeI2s6OaVac8zz/1C9sH9pWbZpJng4U/gnOdoqurTQz?=
 =?us-ascii?Q?1dDSTOCJSXOWtjNiBQRq14XHfxLmmq7bf6CzUWRO32Y7FzAMj0xC0ab9/O8V?=
 =?us-ascii?Q?ioy1hR/Gt1bCPn9pKBPkklfA/DhNRnT0v1e3MhtSAyQ/Fe02xr3lh3djp0ne?=
 =?us-ascii?Q?Kdln+CRa1oL4k5T5lRRzYemiDs9Y1Ltl2c4LGBy+V2nylxRTHzPN/S967WgN?=
 =?us-ascii?Q?d6oIuzfGCHV/OSGqrWX6K0YBm8A6+S3JwIiTAAnTFql8VZYTmoiVQmSmp6cm?=
 =?us-ascii?Q?KUgVzPt+TCrhIQhkKld40x2v69dQSlFXwkf97SThBiR2isl60ZrT2EQGI9fg?=
 =?us-ascii?Q?kEPaiSCi3jf7Wv+LWuPxp6eK+d/VXRBguj2rrIgp6HQDWr7RnI+enbbIvvrG?=
 =?us-ascii?Q?PDmQUBQwN5bAtZkayGeiUgkK5V9n5ThvmG28mBAG9YfQqWmJpZxHav5P9SzM?=
 =?us-ascii?Q?c+ES92Z+AMeayhvv7q29v1LWgf8wEAZAxj9Y/wmuY23x6l8Xn2KhIW10Brav?=
 =?us-ascii?Q?i4za33iHq3oeJHeNM3sOhw0Xo8B99KnJO2ggdViEF0PTP48rRDqqF8qQi6Fb?=
 =?us-ascii?Q?KFR418Cvl/cq+dtU/CWiZ5RMU2HHQFydWy+ZlegR1/wP1gFXdg1XtfB1iubS?=
 =?us-ascii?Q?RascD1Q2rRtApbxTOfqwSA9mXIWsNjHnSDeb6h4ql5dkq7g+0bk0TdrUMUdu?=
 =?us-ascii?Q?j4LOC7ebp+Dc9CXQtDDIiZ0vuTgVFZPj9khGjWQjWzG82Mjbjm7t6P0zxyr3?=
 =?us-ascii?Q?5Tz5jNf4CDeQIIeANUKEUZ86zdZhNbclXbdRdEtG4jlyM53cSdpG3vnPYHrv?=
 =?us-ascii?Q?etjbVfbLs17UsVo9EzErYAXKHYePxWrvF5Zy43SRM4i5rnIbmS7ovPVrFyde?=
 =?us-ascii?Q?WPUjgA09NKYGmTEYF+4/3Y1hK1cQ619STlS1an8WMo+Px3oVETu8823WJohR?=
 =?us-ascii?Q?OMgr2EWrWfdzOcpDg7ALlFb0G0lnPErxldvIbNmfbPEXMGbxBVbxfL8vSqky?=
 =?us-ascii?Q?DVEIT75/9rQ8Wn6JpiZbQcvie1QaFh7T7TdkqFFSuGlFTuhNyHr2FMCS8nxx?=
 =?us-ascii?Q?kvjClZKdTMoYS3hxw6COLDPSiOWBejKGAydt2TeYp0/+viZGQz5rPOcVqoNc?=
 =?us-ascii?Q?3xHEd46Cmfo1imG8YoLsK//cXp8AcxzgfYXJoIeWRGiUQnGhzxFO7gX37PET?=
 =?us-ascii?Q?PEHlTvIMw+2QeKr2ojsusGRIeBdw5kksfN7tPb2UK6KSueB96XklbPLJYqVY?=
 =?us-ascii?Q?/MidID5Y/LVSTH9vK2gp6ESFE+HIN3vdK6/3TlxHzVQJfZ/vD+sCBJ/LWngT?=
 =?us-ascii?Q?g4nqGKX5vycsrzH2p4zSVdPthQSbxcGTBExOwvxawnT+WmIrJFnaGbOioh7G?=
 =?us-ascii?Q?bpnVYTnVcDAYw547+74P2T1twAnJZ+I=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6179d43-38ce-4d90-09c1-08da295baaa5
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 21:11:31.3688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bs5C5GFRV09y8fbmRRseno5YI4M+stQUc2aJjO4ZQ/XzSSODOniBpIjdRUQ260ywwLAutiggY2DKRNMFlZiAKkOnTHPiVFEp49a46aZFISM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1630
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_04:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=690
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204280125
X-Proofpoint-ORIG-GUID: K2dIcOVHUJTKGgylCDjSq5J4cNUQih10
X-Proofpoint-GUID: K2dIcOVHUJTKGgylCDjSq5J4cNUQih10
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Mostly reuses unmap existing code with the extra addition of
marshalling into a bitmap of a page size. To tackle the race,
switch away from a plain store to a cmpxchg() and check whether
IOVA was dirtied or not once it succeeds.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 17 +++++
 drivers/iommu/io-pgtable-arm.c              | 78 +++++++++++++++++----
 2 files changed, 82 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 5f728f8f20a2..d1fb757056cc 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2499,6 +2499,22 @@ static size_t arm_smmu_unmap_pages(struct iommu_domain *domain, unsigned long io
 	return ops->unmap_pages(ops, iova, pgsize, pgcount, gather);
 }
 
+static size_t arm_smmu_unmap_pages_read_dirty(struct iommu_domain *domain,
+					      unsigned long iova, size_t pgsize,
+					      size_t pgcount,
+					      struct iommu_iotlb_gather *gather,
+					      struct iommu_dirty_bitmap *dirty)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct io_pgtable_ops *ops = smmu_domain->pgtbl_ops;
+
+	if (!ops)
+		return 0;
+
+	return ops->unmap_pages_read_dirty(ops, iova, pgsize, pgcount,
+					   gather, dirty);
+}
+
 static void arm_smmu_flush_iotlb_all(struct iommu_domain *domain)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
@@ -2938,6 +2954,7 @@ static struct iommu_ops arm_smmu_ops = {
 		.free			= arm_smmu_domain_free,
 		.read_and_clear_dirty	= arm_smmu_read_and_clear_dirty,
 		.set_dirty_tracking_range = arm_smmu_set_dirty_tracking,
+		.unmap_pages_read_dirty	= arm_smmu_unmap_pages_read_dirty,
 	}
 };
 
diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index 361410aa836c..143ee7d73f88 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -259,10 +259,30 @@ static void __arm_lpae_clear_pte(arm_lpae_iopte *ptep, struct io_pgtable_cfg *cf
 		__arm_lpae_sync_pte(ptep, 1, cfg);
 }
 
+static bool __arm_lpae_clear_dirty_pte(arm_lpae_iopte *ptep,
+				       struct io_pgtable_cfg *cfg)
+{
+	arm_lpae_iopte tmp;
+	bool dirty = false;
+
+	do {
+		tmp = cmpxchg64(ptep, *ptep, 0);
+		if ((tmp & ARM_LPAE_PTE_DBM) &&
+		    !(tmp & ARM_LPAE_PTE_AP_RDONLY))
+			dirty = true;
+	} while (tmp);
+
+	if (!cfg->coherent_walk)
+		__arm_lpae_sync_pte(ptep, 1, cfg);
+
+	return dirty;
+}
+
 static size_t __arm_lpae_unmap(struct arm_lpae_io_pgtable *data,
 			       struct iommu_iotlb_gather *gather,
 			       unsigned long iova, size_t size, size_t pgcount,
-			       int lvl, arm_lpae_iopte *ptep);
+			       int lvl, arm_lpae_iopte *ptep,
+			       struct iommu_dirty_bitmap *dirty);
 
 static void __arm_lpae_init_pte(struct arm_lpae_io_pgtable *data,
 				phys_addr_t paddr, arm_lpae_iopte prot,
@@ -306,8 +326,13 @@ static int arm_lpae_init_pte(struct arm_lpae_io_pgtable *data,
 			size_t sz = ARM_LPAE_BLOCK_SIZE(lvl, data);
 
 			tblp = ptep - ARM_LPAE_LVL_IDX(iova, lvl, data);
+
+			/*
+			 * No need for dirty bitmap as arm_lpae_init_pte() is
+			 * only called from __arm_lpae_map()
+			 */
 			if (__arm_lpae_unmap(data, NULL, iova + i * sz, sz, 1,
-					     lvl, tblp) != sz) {
+					     lvl, tblp, NULL) != sz) {
 				WARN_ON(1);
 				return -EINVAL;
 			}
@@ -564,7 +589,8 @@ static size_t arm_lpae_split_blk_unmap(struct arm_lpae_io_pgtable *data,
 				       struct iommu_iotlb_gather *gather,
 				       unsigned long iova, size_t size,
 				       arm_lpae_iopte blk_pte, int lvl,
-				       arm_lpae_iopte *ptep, size_t pgcount)
+				       arm_lpae_iopte *ptep, size_t pgcount,
+				       struct iommu_dirty_bitmap *dirty)
 {
 	struct io_pgtable_cfg *cfg = &data->iop.cfg;
 	arm_lpae_iopte pte, *tablep;
@@ -617,13 +643,15 @@ static size_t arm_lpae_split_blk_unmap(struct arm_lpae_io_pgtable *data,
 		return num_entries * size;
 	}
 
-	return __arm_lpae_unmap(data, gather, iova, size, pgcount, lvl, tablep);
+	return __arm_lpae_unmap(data, gather, iova, size, pgcount,
+				lvl, tablep, dirty);
 }
 
 static size_t __arm_lpae_unmap(struct arm_lpae_io_pgtable *data,
 			       struct iommu_iotlb_gather *gather,
 			       unsigned long iova, size_t size, size_t pgcount,
-			       int lvl, arm_lpae_iopte *ptep)
+			       int lvl, arm_lpae_iopte *ptep,
+			       struct iommu_dirty_bitmap *dirty)
 {
 	arm_lpae_iopte pte;
 	struct io_pgtable *iop = &data->iop;
@@ -649,7 +677,11 @@ static size_t __arm_lpae_unmap(struct arm_lpae_io_pgtable *data,
 			if (WARN_ON(!pte))
 				break;
 
-			__arm_lpae_clear_pte(ptep, &iop->cfg);
+			if (likely(!dirty))
+				__arm_lpae_clear_pte(ptep, &iop->cfg);
+			else if (__arm_lpae_clear_dirty_pte(ptep, &iop->cfg))
+				iommu_dirty_bitmap_record(dirty, iova, size);
+
 
 			if (!iopte_leaf(pte, lvl, iop->fmt)) {
 				/* Also flush any partial walks */
@@ -671,17 +703,20 @@ static size_t __arm_lpae_unmap(struct arm_lpae_io_pgtable *data,
 		 * minus the part we want to unmap
 		 */
 		return arm_lpae_split_blk_unmap(data, gather, iova, size, pte,
-						lvl + 1, ptep, pgcount);
+						lvl + 1, ptep, pgcount, dirty);
 	}
 
 	/* Keep on walkin' */
 	ptep = iopte_deref(pte, data);
-	return __arm_lpae_unmap(data, gather, iova, size, pgcount, lvl + 1, ptep);
+	return __arm_lpae_unmap(data, gather, iova, size, pgcount,
+				lvl + 1, ptep, dirty);
 }
 
-static size_t arm_lpae_unmap_pages(struct io_pgtable_ops *ops, unsigned long iova,
-				   size_t pgsize, size_t pgcount,
-				   struct iommu_iotlb_gather *gather)
+static size_t __arm_lpae_unmap_pages(struct io_pgtable_ops *ops,
+				     unsigned long iova,
+				     size_t pgsize, size_t pgcount,
+				     struct iommu_iotlb_gather *gather,
+				     struct iommu_dirty_bitmap *dirty)
 {
 	struct arm_lpae_io_pgtable *data = io_pgtable_ops_to_data(ops);
 	struct io_pgtable_cfg *cfg = &data->iop.cfg;
@@ -697,13 +732,29 @@ static size_t arm_lpae_unmap_pages(struct io_pgtable_ops *ops, unsigned long iov
 		return 0;
 
 	return __arm_lpae_unmap(data, gather, iova, pgsize, pgcount,
-				data->start_level, ptep);
+				data->start_level, ptep, dirty);
+}
+
+static size_t arm_lpae_unmap_pages(struct io_pgtable_ops *ops, unsigned long iova,
+				   size_t pgsize, size_t pgcount,
+				   struct iommu_iotlb_gather *gather)
+{
+	return __arm_lpae_unmap_pages(ops, iova, pgsize, pgcount, gather, NULL);
 }
 
 static size_t arm_lpae_unmap(struct io_pgtable_ops *ops, unsigned long iova,
 			     size_t size, struct iommu_iotlb_gather *gather)
 {
-	return arm_lpae_unmap_pages(ops, iova, size, 1, gather);
+	return __arm_lpae_unmap_pages(ops, iova, size, 1, gather, NULL);
+}
+
+static size_t arm_lpae_unmap_pages_read_dirty(struct io_pgtable_ops *ops,
+					      unsigned long iova,
+					      size_t pgsize, size_t pgcount,
+					      struct iommu_iotlb_gather *gather,
+					      struct iommu_dirty_bitmap *dirty)
+{
+	return __arm_lpae_unmap_pages(ops, iova, pgsize, pgcount, gather, dirty);
 }
 
 static phys_addr_t arm_lpae_iova_to_phys(struct io_pgtable_ops *ops,
@@ -969,6 +1020,7 @@ arm_lpae_alloc_pgtable(struct io_pgtable_cfg *cfg)
 		.iova_to_phys	= arm_lpae_iova_to_phys,
 		.read_and_clear_dirty = arm_lpae_read_and_clear_dirty,
 		.set_dirty_tracking   = arm_lpae_set_dirty_tracking,
+		.unmap_pages_read_dirty     = arm_lpae_unmap_pages_read_dirty,
 	};
 
 	return data;
-- 
2.17.2

