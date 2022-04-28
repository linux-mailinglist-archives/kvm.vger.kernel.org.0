Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD36D513D38
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 23:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352107AbiD1VPa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 17:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352106AbiD1VP2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 17:15:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786C57FF57
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 14:11:55 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SJX01X015475;
        Thu, 28 Apr 2022 21:11:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=XlzXFBhGqVZ87SXR+cMXnEPS9RJaU8MiTb9GiwI8uEY=;
 b=UECo/OfYI39q3H9Na/SlEcPhJ5rcK1oUxukktt1hsbZkjVQo8msV35xP2YZjFcES7vSq
 GTryBaAtKykK774GmZyO9m3TxTcvJsvgaFPGzunJCTCzKU2IdahSCDxbq5xTR+begIOr
 vfWVYJfj3XFbBXouiBJ+VEk6aJ7LyFdtF/wzWis/1gWKG7Wzym0+DzSLG9oCNt9lXp5t
 hfkB7i4OVwqdx0qmQFeae4nWUb5tkiDq/oNf39gaptjSwbuxN/4SrLe79OeLC5h6jbnK
 y+ZvmJMaW+9faEwSfWBH3zB4BlkgmVAmeva2YLms4q9u/vD9pdtFrqCZhunjCHBOk+y+ Qg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb9aw5wv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:11:24 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23SL5Bfb028504;
        Thu, 28 Apr 2022 21:11:22 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w79p67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:11:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Axc+UviMB4I3E3Zn+S1LLRLCFMlliqMr4mEZo8irgEVQArn+/SnlyTe3dog/sQK0q7crq/gXjf+h10UpdSU31EnZw4ef9I5K5YY4aiSm6R4V8r7P2pCN6KliW5YyHf8Pnogvr7zcESsoZIGBU2M5ulcXvsB3o1P9ak2kFXI9LlZmoMjMAPdlGSblI/CIWWqM+wZcG5ylAn8nrSfJfYhzpY54GfZB8kYoBsXR8bsfXDgvSE5/DHkhiUiImqwKwbmOFLVZTXX0jqUyUpA1DG60RxHnFAkBz2x71QzUj4ZrVQ3raPRRd7G8NWJnP5bylNT8WdTWs9cgojCMMD1BFzOo4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XlzXFBhGqVZ87SXR+cMXnEPS9RJaU8MiTb9GiwI8uEY=;
 b=SDAMV2ctyPWLji9LQVgrllsILy/OmU0Vz3LKslWiaLqTlJSQP3BmxJxOH/rNmeBQSv8HndXC9hjig4Y3TzNfwvNussi/CPSCNm5/sBUkHOnNH0/mqHcj74TiXgVICe+e53LwnS/KdWp/gg4YU5Nzg5sQMWPkljw2l8XT17pJcTE1iE0nxMx9zlf7Pli4PpXnpsy1e8MSFAjcLFI9VgvBwDOPj5gnimweC6zYwAp2NGH635XUvR/E4d26NaDLzHvW7pNmxN9OK4M3L8qCxklh0nZhNjcbZv7bZY/BtJAHMbpYDQ1voiI5b+sWw6U34MCRy6bwnjGKcJprlLwBiAID1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XlzXFBhGqVZ87SXR+cMXnEPS9RJaU8MiTb9GiwI8uEY=;
 b=LgKNjSdtSNNvIOJu7bggBSzsVJ+kiCm9VK1hX9YR3CfjHDRPtY6xKys09IrdjNECw1Nlrz3deAXRrLlZI49771J8YQpwbjQAU9WldP1HtNe99c5+PuIkSeHvn41nYKVFc57lUuUAiavA+MbwUzppvHYw/JsQkSc5N2q6iFhCM+k=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB3341.namprd10.prod.outlook.com (2603:10b6:208:12f::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 28 Apr
 2022 21:11:21 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 21:11:21 +0000
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
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kunkun Jiang <jiangkunkun@huawei.com>
Subject: [PATCH RFC 14/19] iommu/arm-smmu-v3: Add read_and_clear_dirty() support
Date:   Thu, 28 Apr 2022 22:09:28 +0100
Message-Id: <20220428210933.3583-15-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220428210933.3583-1-joao.m.martins@oracle.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0111.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::27) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 758a4fbe-3e45-485b-3cab-08da295ba4ab
X-MS-TrafficTypeDiagnostic: MN2PR10MB3341:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB3341F5A51994C6F4BB9EFFAEBBFD9@MN2PR10MB3341.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iBC+TgNhSH3Z1c2GoxpQ8iHsuykPOb3x9cCY7/+J0HucBJAerGHnzRJjIh4aVn2w5XLNWyxdeFkwqe2QesvNrXmKtTM1GYBwjMAuHn188UMxPvz6ZZRegb+lmxoYT//Ld2zHX4ifsRpa4ZjbzzhxzLB0BDtXuxJaF8dgKwwSXMYD/P/ouVZu7gW2NRfY8u+uefdDTJv5SBQmrJGOdlQbLLNjADpNY76WcnL8/LI3Z0DvYIop7Ck4PrS1RXedfH0alsw8x797qq+62ePGoEIyquwVLDZO0Lqq5h20ewI2p89erHQKcoOdjs7ib4ppt7xwG4RiUPv9cWXD8++anet1oHobVztrnIhv18nSh8slJ1WLz/rx+SdYcIQr2VntgaSJGqDgr4bYObSRA1yn7BisdYk4/O5clqr/Cwg4whbtfBcGBGpsX+SEktVMC8XwwhTRbqZpWZ/N4nCXAg5UUbPCRSgZxIPX00c8FditxMCUsKPSoi3pEjKgjbXyOn2nP1swYJYM/2b+fj6f8n5vWQ03cMGL2LOw+v0lYfVRsEnTxqLWIFd9273YLJSxBcNNs/Cyp5nvQRyugUvN2NIAGu3LQx4GfgwYODXEGKaBwO8CYa4WPDab5+o5cLerS9px+JQvn/pAmWqe8HknEdHWUNt44uCfkPFmWkFmWqSUvf4gEHOw34r3NwAGIyoCvowFp2U0dVI6MpieXhIBEgnACXQzeN6BDjEpLmHUD/tnm3+GpJ8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(6512007)(103116003)(83380400001)(508600001)(1076003)(2616005)(52116002)(26005)(6506007)(186003)(2906002)(7416002)(36756003)(316002)(5660300002)(6916009)(86362001)(54906003)(38100700002)(38350700002)(8676002)(4326008)(66476007)(8936002)(66946007)(66556008)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F6vL/zqu+jWL692xAJih09uhwSB6CGp8fPly+0+h48IDyS8LhvX2ndhHm+Wy?=
 =?us-ascii?Q?dJ6ZhD2sODiVIytTjdwUhpTslqCmtPmn7TPwEAua0wnNoVfa2vi6FmbRVJYU?=
 =?us-ascii?Q?ON3ogzhizCpA+m7m8UuPFsSsSI5yskiI11S0a6lp3rfAPO1NGQiMzmnqZMmZ?=
 =?us-ascii?Q?NScJYzhCUnqv0WHDQu87J9oeYlis5L47qyPmY1wYwJeX20VPa63DJ15PD+GV?=
 =?us-ascii?Q?YuJFDMv6/DczdaRSQc+xNxgOU07RmqANZynriQOhmxDHeIurbRrZvRq0ij6T?=
 =?us-ascii?Q?sZyri2W9DLMcc+6X316zU4FpBJPTF0J7pDR9czJCzimIge1w2JNk1W2jd9Jb?=
 =?us-ascii?Q?i/sykls0QZL1ysQXSOFTGC2DwqUBag5AjR/t+Jn8P00jESeaif1N57TeFMXZ?=
 =?us-ascii?Q?Rkg1CwyqeAClEqQb4bRQRPGDeKelWRDNn3dxNNG0UzYKMcpuLuHc+PUgIdZI?=
 =?us-ascii?Q?7/gr0UEBTAjG6XDePsm16xaNvLwPRmpxkffp6G4vfOTNMB4fCwBZNCJS4o4O?=
 =?us-ascii?Q?qrXLT1vufIxs9xJq/DOBq8JGGmFaZwjzgW5mIwXzv3/YT+GGzixchOtLuzqd?=
 =?us-ascii?Q?wCj8aJquyrSg9lhln/vvr5eH8KT0PmP8ydajbuep2U1szG575AHa1rthzTdx?=
 =?us-ascii?Q?9blGRVGICTPvQzUQXZ4hQDXcWhf1A3xWmtbH9hHeiyGnpTsvZAe5J8cqzz/4?=
 =?us-ascii?Q?8fmVJiR0ZJLxRgjl++OFDq7BFWg19yArzZxmMoTmBs3TP9fQzCWrXhFJj4gG?=
 =?us-ascii?Q?7fqYh0Jx4UDmGRB7rqETQc3K8TtzmRRrA0QGPwUUHYaY+Zhz8SR77NIRiezm?=
 =?us-ascii?Q?mlctun+wKwwK5mfWWZkdayLphw5eQQ8ChU2vlf+LZYiMBIvjn3VvjYS8uLan?=
 =?us-ascii?Q?zM0bgZV8IpYy7ouAmvPZgFiYOVuy7cQt6cFH1rT2ClMqKPfjPRU2AZRe2ypF?=
 =?us-ascii?Q?A0ifiQs1qvxoJSDrO/+RCVzc0l3H6o7T70FFxoHInIVT0r4O8rDbsYFBLd68?=
 =?us-ascii?Q?Trfj6L6dByC2mtQz1tROGOdi3AOiHkPHpa8aPTVP8rSc34usCBRI1BX5nW3B?=
 =?us-ascii?Q?1uPhcvAhYTEIqx6kAlaq9ROMscXFrX8eZCTo9Q1e/X7SywxuQetsP+P8O0Li?=
 =?us-ascii?Q?QIBOvh4RDnhUMRYObbUW1x3fLCEFhFTlzjrbD8BZROm1xGvFC/mccn6GGvAz?=
 =?us-ascii?Q?kFreFf9grVSFG3UuyIUdVivVMCyisFZNLJBn7NGweQPx4xNz//mibXGG2U8v?=
 =?us-ascii?Q?tneRArxFaY3GDqprmfcA+X3rmrWY7Iipppf9eHsU3DDPpCPPpb/dy2rR63Na?=
 =?us-ascii?Q?rkfJZrUWBcIN+RGCS7dwR3ihTAIPCJ1x1NhzavTp52RXiVPwo9im3VW6BUXM?=
 =?us-ascii?Q?/3pzwxPj88sQI6D/2+AaMhqmd8zxwqqPDsEoVb5j+Eo8KfGh+5SEqaHX2wef?=
 =?us-ascii?Q?b3Pt00snqGyvRNmmlXPzCAxa/zpVnFh68jMBzsD3LL8i9eJQJ6d1M/Ew26d5?=
 =?us-ascii?Q?ZNNoOWDoefyS5dsPOmgEwxU20pOFo7CL645nDCqBaRnE15IT54ZcZLNDykvU?=
 =?us-ascii?Q?QVXrkrpwYRIAWS414vxhZRfiXTA7Bssw2xFi1SJmNUk6inmrJvQyqmR7/ekt?=
 =?us-ascii?Q?WearmvAOa2Xz+XkQ6i1MHwWHGdDlJqJ5/6PH23Nifh0pgGAM7kIGb1tKQ7cl?=
 =?us-ascii?Q?24HUWaiBNlPVHrvtnvC+1UDlyOzAck2kMyE5npJF/x3WJliGTdy2mvAXG1zz?=
 =?us-ascii?Q?Ulq/RGPHbhhPJ8nAZ6Xxa4D1lF9WRYw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 758a4fbe-3e45-485b-3cab-08da295ba4ab
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 21:11:21.0932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jboXBTnushVtK9GqodQpTqA+KgPAF0HMeUh7aT7kqJohQ2iKvEodJD5yNHjU++ka6yPt3t5NdkbEX6wobJtyaWbepqo+ge5y3P+3kZ0wVus=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3341
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_04:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=691
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204280125
X-Proofpoint-ORIG-GUID: bKVDO1ikx9xeGgau8JmjI3WERtrtyZb4
X-Proofpoint-GUID: bKVDO1ikx9xeGgau8JmjI3WERtrtyZb4
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

.read_and_clear_dirty() IOMMU domain op takes care of
reading the dirty bits (i.e. PTE has both DBM and AP[2] set)
and marshalling into a bitmap of a given page size.

While reading the dirty bits we also clear the PTE AP[2]
bit to mark it as writable-clean.

Structure it in a way that the IOPTE walker is generic,
and so we pass a function pointer over what to do on a per-PTE
basis. This is useful for a followup patch where we supply an
io-pgtable op to enable DBM when starting/stopping dirty tracking.

Co-developed-by: Keqian Zhu <zhukeqian1@huawei.com>
Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
Co-developed-by: Kunkun Jiang <jiangkunkun@huawei.com>
Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  27 ++++++
 drivers/iommu/io-pgtable-arm.c              | 102 +++++++++++++++++++-
 2 files changed, 128 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 4dba53bde2e3..232057d20197 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2743,6 +2743,32 @@ static int arm_smmu_enable_nesting(struct iommu_domain *domain)
 	return ret;
 }
 
+static int arm_smmu_read_and_clear_dirty(struct iommu_domain *domain,
+					 unsigned long iova, size_t size,
+					 struct iommu_dirty_bitmap *dirty)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct io_pgtable_ops *ops = smmu_domain->pgtbl_ops;
+	struct arm_smmu_device *smmu = smmu_domain->smmu;
+	int ret;
+
+	if (!(smmu->features & ARM_SMMU_FEAT_HD) ||
+	    !(smmu->features & ARM_SMMU_FEAT_BBML2))
+		return -ENODEV;
+
+	if (smmu_domain->stage != ARM_SMMU_DOMAIN_S1)
+		return -EINVAL;
+
+	if (!ops || !ops->read_and_clear_dirty) {
+		pr_err_once("io-pgtable don't support dirty tracking\n");
+		return -ENODEV;
+	}
+
+	ret = ops->read_and_clear_dirty(ops, iova, size, dirty);
+
+	return ret;
+}
+
 static int arm_smmu_of_xlate(struct device *dev, struct of_phandle_args *args)
 {
 	return iommu_fwspec_add_ids(dev, args->args, 1);
@@ -2871,6 +2897,7 @@ static struct iommu_ops arm_smmu_ops = {
 		.iova_to_phys		= arm_smmu_iova_to_phys,
 		.enable_nesting		= arm_smmu_enable_nesting,
 		.free			= arm_smmu_domain_free,
+		.read_and_clear_dirty	= arm_smmu_read_and_clear_dirty,
 	}
 };
 
diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index 94ff319ae8ac..3c99028d315a 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -75,6 +75,7 @@
 
 #define ARM_LPAE_PTE_NSTABLE		(((arm_lpae_iopte)1) << 63)
 #define ARM_LPAE_PTE_XN			(((arm_lpae_iopte)3) << 53)
+#define ARM_LPAE_PTE_DBM		(((arm_lpae_iopte)1) << 51)
 #define ARM_LPAE_PTE_AF			(((arm_lpae_iopte)1) << 10)
 #define ARM_LPAE_PTE_SH_NS		(((arm_lpae_iopte)0) << 8)
 #define ARM_LPAE_PTE_SH_OS		(((arm_lpae_iopte)2) << 8)
@@ -84,7 +85,7 @@
 
 #define ARM_LPAE_PTE_ATTR_LO_MASK	(((arm_lpae_iopte)0x3ff) << 2)
 /* Ignore the contiguous bit for block splitting */
-#define ARM_LPAE_PTE_ATTR_HI_MASK	(((arm_lpae_iopte)6) << 52)
+#define ARM_LPAE_PTE_ATTR_HI_MASK	(((arm_lpae_iopte)13) << 51)
 #define ARM_LPAE_PTE_ATTR_MASK		(ARM_LPAE_PTE_ATTR_LO_MASK |	\
 					 ARM_LPAE_PTE_ATTR_HI_MASK)
 /* Software bit for solving coherency races */
@@ -93,6 +94,9 @@
 /* Stage-1 PTE */
 #define ARM_LPAE_PTE_AP_UNPRIV		(((arm_lpae_iopte)1) << 6)
 #define ARM_LPAE_PTE_AP_RDONLY		(((arm_lpae_iopte)2) << 6)
+#define ARM_LPAE_PTE_AP_RDONLY_BIT	7
+#define ARM_LPAE_PTE_AP_WRITABLE	(ARM_LPAE_PTE_AP_RDONLY | \
+					 ARM_LPAE_PTE_DBM)
 #define ARM_LPAE_PTE_ATTRINDX_SHIFT	2
 #define ARM_LPAE_PTE_nG			(((arm_lpae_iopte)1) << 11)
 
@@ -737,6 +741,101 @@ static phys_addr_t arm_lpae_iova_to_phys(struct io_pgtable_ops *ops,
 	return iopte_to_paddr(pte, data) | iova;
 }
 
+static int __arm_lpae_read_and_clear_dirty(unsigned long iova, size_t size,
+					   arm_lpae_iopte *ptep, void *opaque)
+{
+	struct iommu_dirty_bitmap *dirty = opaque;
+	arm_lpae_iopte pte;
+
+	pte = READ_ONCE(*ptep);
+	if (WARN_ON(!pte))
+		return -EINVAL;
+
+	if (pte & ARM_LPAE_PTE_AP_WRITABLE)
+		return 0;
+
+	if (!(pte & ARM_LPAE_PTE_DBM))
+		return 0;
+
+	iommu_dirty_bitmap_record(dirty, iova, size);
+	set_bit(ARM_LPAE_PTE_AP_RDONLY_BIT, (unsigned long *)ptep);
+	return 0;
+}
+
+static int __arm_lpae_iopte_walk(struct arm_lpae_io_pgtable *data,
+				 unsigned long iova, size_t size,
+				 int lvl, arm_lpae_iopte *ptep,
+				 int (*fn)(unsigned long iova, size_t size,
+					   arm_lpae_iopte *pte, void *opaque),
+				 void *opaque)
+{
+	arm_lpae_iopte pte;
+	struct io_pgtable *iop = &data->iop;
+	size_t base, next_size;
+	int ret;
+
+	if (WARN_ON_ONCE(!fn))
+		return -EINVAL;
+
+	if (WARN_ON(lvl == ARM_LPAE_MAX_LEVELS))
+		return -EINVAL;
+
+	ptep += ARM_LPAE_LVL_IDX(iova, lvl, data);
+	pte = READ_ONCE(*ptep);
+	if (WARN_ON(!pte))
+		return -EINVAL;
+
+	if (size == ARM_LPAE_BLOCK_SIZE(lvl, data)) {
+		if (iopte_leaf(pte, lvl, iop->fmt))
+			return fn(iova, size, ptep, opaque);
+
+		/* Current level is table, traverse next level */
+		next_size = ARM_LPAE_BLOCK_SIZE(lvl + 1, data);
+		ptep = iopte_deref(pte, data);
+		for (base = 0; base < size; base += next_size) {
+			ret = __arm_lpae_iopte_walk(data, iova + base,
+						    next_size, lvl + 1, ptep,
+						    fn, opaque);
+			if (ret)
+				return ret;
+		}
+		return 0;
+	} else if (iopte_leaf(pte, lvl, iop->fmt)) {
+		return fn(iova, size, ptep, opaque);
+	}
+
+	/* Keep on walkin */
+	ptep = iopte_deref(pte, data);
+	return __arm_lpae_iopte_walk(data, iova, size, lvl + 1, ptep,
+				     fn, opaque);
+}
+
+static int arm_lpae_read_and_clear_dirty(struct io_pgtable_ops *ops,
+					 unsigned long iova, size_t size,
+					 struct iommu_dirty_bitmap *dirty)
+{
+	struct arm_lpae_io_pgtable *data = io_pgtable_ops_to_data(ops);
+	struct io_pgtable_cfg *cfg = &data->iop.cfg;
+	arm_lpae_iopte *ptep = data->pgd;
+	int lvl = data->start_level;
+	long iaext = (s64)iova >> cfg->ias;
+
+	if (WARN_ON(!size || (size & cfg->pgsize_bitmap) != size))
+		return -EINVAL;
+
+	if (cfg->quirks & IO_PGTABLE_QUIRK_ARM_TTBR1)
+		iaext = ~iaext;
+	if (WARN_ON(iaext))
+		return -EINVAL;
+
+	if (data->iop.fmt != ARM_64_LPAE_S1 &&
+	    data->iop.fmt != ARM_32_LPAE_S1)
+		return -EINVAL;
+
+	return __arm_lpae_iopte_walk(data, iova, size, lvl, ptep,
+				     __arm_lpae_read_and_clear_dirty, dirty);
+}
+
 static void arm_lpae_restrict_pgsizes(struct io_pgtable_cfg *cfg)
 {
 	unsigned long granule, page_sizes;
@@ -817,6 +916,7 @@ arm_lpae_alloc_pgtable(struct io_pgtable_cfg *cfg)
 		.unmap		= arm_lpae_unmap,
 		.unmap_pages	= arm_lpae_unmap_pages,
 		.iova_to_phys	= arm_lpae_iova_to_phys,
+		.read_and_clear_dirty = arm_lpae_read_and_clear_dirty,
 	};
 
 	return data;
-- 
2.17.2

