Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83DB0513D35
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 23:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352120AbiD1VPd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 17:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352119AbiD1VPa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 17:15:30 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C857FF7D
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 14:11:56 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SJjjJe015405;
        Thu, 28 Apr 2022 21:11:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=jmxl/UBDw/bAYd1H0RDytBhu9qPhzxt3/kc0GtSkS/o=;
 b=TJFkFlq5/6VpBsjK8p4DkaOcXlt58Dh4K0JQaiMdg37kinxfmZazxvGL8Eq4NE/VRUnR
 VZKd+bB3gl4x0i4M3tJt0BEH2Fy+25ZBDaXSK/xHm9B6cF4VEqC+/tPzMthGmuZfldrx
 r9slRKCA75UKwfc7IEKYHddy3cwKVacw9msV0bUhMlFgnSrERZeyEJi8f87yRNCOGYZc
 1xsCBhtUiG04i8/f37+RpEHqamBgPrh8R2r+AV4o7t9vVj4kvxrfVcAK1tFFiagY5ZYD
 OEKrZpu612tuQ+zpcX2NDCafro8y7V1gDQfIfZzyJ0OK3gQFZfzWVKC55itVki7XYLid kw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb9aw5x3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:11:31 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23SL6BN4024993;
        Thu, 28 Apr 2022 21:11:29 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w78ajs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:11:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WByV9EV6D7y/QuWvGVgc2FT9Ofk5FFAE2Zgb8o/5fYcysddeWII/yqE2QDtYR0o3UjpS2EOOdnCpe8R5vh1tk5l9csuiHXuhAOhjlgCAbfVSQ/KYxoOCty6Ih7v32LXqNisV85Nf8ziSvRI3tQMDYtWPc/kRQIh+0wuM8mES5P7E8quR4LNURx5eU88/MA1Ap6c4+AR1qHZ02xom7Bh55DW9n2pOzUbE8LQSMC/inwaZpY3FuHx9Jy+5qgop90pja+6qQhatGvBQ6Ucj6hE57CIOZJis6FohCDJfj5Cph1UJgakCGFdPdv4d7+zdQDOQiYdx3EL7wVep3chkVu2tlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jmxl/UBDw/bAYd1H0RDytBhu9qPhzxt3/kc0GtSkS/o=;
 b=ETnJUrW9xGZ7DxqBx9IHL92/aIIQkmvRJ+8+Ggp75kksJuUpTJX9ntPUlfvADdfoKyHmB12ZAJK+b6NjMpOQ6/I2lLpG8+2g9R6cvS6cynY8H+drAf19LYVicRAj5q4ROQXEOK+U8uCOw6+UZ0sKwJfA1X+RaK5kZ84nzBVVpAL3HltTnRuiVXxeUBI75To7kEnB6PXY9Pee28uIJdsOXnf6P7w+in+/g5s6SUB4icKQCkc5y3UEJx1s01DLIqcwncQzK9aVxXTI6iOcnX/faQgPXseB+I24UAIUS9QBbq+0X0UBttGJThlkhK5UknJZ32W/MsgfGBRzirA5yLZMRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jmxl/UBDw/bAYd1H0RDytBhu9qPhzxt3/kc0GtSkS/o=;
 b=fklHKvVhXp5xNphHY1QyyRQLne3xjDy8mAiSi3XWCinP+o/Z9VVda0fqwPFe7sTCcJTm1EvUd4G+unpf/f/61Jo71YiEecs1kRzXTgDMPlb2TPoqkkpsK5qzBDBBcAqLnB2j2sIw3L9W/HhWvaVvnl/v6Z98J821/ol0bI4d1QU=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB3341.namprd10.prod.outlook.com (2603:10b6:208:12f::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 28 Apr
 2022 21:11:28 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 21:11:27 +0000
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
Subject: [PATCH RFC 16/19] iommu/arm-smmu-v3: Enable HTTU for stage1 with io-pgtable mapping
Date:   Thu, 28 Apr 2022 22:09:30 +0100
Message-Id: <20220428210933.3583-17-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220428210933.3583-1-joao.m.martins@oracle.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0111.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::27) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b21035c-432c-4300-749e-08da295ba8c3
X-MS-TrafficTypeDiagnostic: MN2PR10MB3341:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB334190680B7CC52735304319BBFD9@MN2PR10MB3341.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kusKUdx+amn9ZVCmy/JnmuKokeD2cW67U2zhqliQBqB6MYqjqJ3wviG4ouXzx06Z5p/r/cUS/AkVXvMdDRYSDMUvJWDSz94S+LVk99eBZuyUWQt6+xcg2UnV7inPXXdVw4Lcz0lXGlg44T5SD0E6T25RgnDGNOreLJTwPzkQ5ehK5Ym3TBhegFhB2jNEgfllsDXxlQUfMb9uWSK5wMXRW+FolP1ba1E6qzdnKOcl5PasNvqjm1ePDR2NPPtnLHDfvpeGm2BCzlwx3rEvVmDuOM83KfmFqFuMBhP8og7DJEK9bFCO88PBvKAeMHtbVOZwfccQBm+ozMMjR3L5UnGNnZZH63zvWg523tXCaU85HzF9w+UUE/LAO2Vz4Lx+FOKUZyvXYbVfGqk0KCgm/B78IV5MhbOqnEt3utA+9zxYKopk1hwRx4o5tBBVTsdxvnoj2Wh1Ehi43ODUZ78525uzlReTCABb7wXuKJVVhBSSFW1kS0V4651O6FkyEfwQxTYt4FTkG9kWfUdBAZGUsXeTJXdlWWoEZWX+W+0ur5d5PKip72YQltJkK8ENaCEYqT7yZg1qJXMlYPKTxK22whlp1X4mMTsdXma4PaWghxNAmBmvirltxtP0qQBnvFHGYvUh6S9yJ9TVqN6eXar7mfABoLJert/AwCHeVCP8uHkwhX1YfUvCEQy3SA+6f40t9WIf8mujcVYzd5HSvRVRsVGMew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(6512007)(103116003)(83380400001)(508600001)(1076003)(2616005)(52116002)(26005)(6506007)(6666004)(186003)(2906002)(7416002)(36756003)(316002)(5660300002)(6916009)(86362001)(54906003)(38100700002)(38350700002)(8676002)(4326008)(66476007)(8936002)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VVB23OUc8qm8DbfyXS/0iQUGTiblDh+bv7cui8GIybNULNt85SFBw8AP7CBN?=
 =?us-ascii?Q?E7gCsBy2FsJBwE6qCdE15wtNMfDT2zozEdD2CL8x89UffONzV71EVd3ebN+0?=
 =?us-ascii?Q?XYISnATHb5yJ+rRwGeBSJuq4nxQgp1cqhLuHBZUN1b5/HLoKm1FfWrZMI8Qv?=
 =?us-ascii?Q?vlBH+EDavi8zFOltjb1Ae3utNC4DwgHqUM/6GlNtS+hmxTw8h2HC3jXbtnKY?=
 =?us-ascii?Q?uR+g7z/QHvolY5s+eI2rDfG9aHGZUNzAkyLIPMqVfxE2xoDx+xwJjMVGkZla?=
 =?us-ascii?Q?iac85AqBJp4k3NfCL3xJVUQIEnAgpxYVaMt/oz8HP9ojRmOriCMZuE6ubZJP?=
 =?us-ascii?Q?APylZIrJtdVVqb7/C9bom4i9V1IHA9ZRYssfiQLoiqF5mw4NNNfb7lxzZtDU?=
 =?us-ascii?Q?vTeipxP+jkLjNGlAyY6ocjjO709U64w2IfRBf5le2IRD/sBs/US0KPA8WzM3?=
 =?us-ascii?Q?9GIstXCFYREcM/Ggh9OaEq3YZ5wlHyz7vIeFoEQORNvLuTC3LHnxSeH96EZP?=
 =?us-ascii?Q?Nl4RkRJlnY0dBjFvQeFCWf25FAgMH/Wdaox1qpY0lih+AY2xMsp1NK8QkRD1?=
 =?us-ascii?Q?e4T5UNPn3twW+3bEnfSP8Fr54gD5OuFIEJieNt/+HtkF/OShIObSGuPCGgNQ?=
 =?us-ascii?Q?ZEwdnLW+nJIxBKrUaevCHWOVvHrYSEVY6JYAo699G3k+xdMyV1TBUiLA/6it?=
 =?us-ascii?Q?K/xPemVL1sqYpVAfv8X4FdlIQLe6rnyDHj7ABrGSjYDaHwuzygivNtRMecRL?=
 =?us-ascii?Q?FLtE8CAD+vf90E6iWdWyiALX5NUoJpXXTJciTnoaB8Emu9wkV7bRvCm4VCs+?=
 =?us-ascii?Q?Fw9bh6sPQgqPiiMidGtHhyDomm8dmyV7dC9lcACAPK7SuxQ4VSigDmojVnt6?=
 =?us-ascii?Q?oKYO8r0a60Beh1mJIHQrE60SQNrTkAJ3xl8wqYdQnqcJmO62/eBqOarUxz4B?=
 =?us-ascii?Q?TbmzATjesWW5u8AJxT/7NrrKgk08Q+byQDZJOen5QNMqLiuJeXmK1KH83XdR?=
 =?us-ascii?Q?Q7RcVxOowmsXEWeAD7pANS/2VN8bSvQavP2QZuN/9nx5NHUdJIPxoDMSVLY5?=
 =?us-ascii?Q?Ds22nMXTi7g/kuTe/OMJb0SN1ppp8qvoO1Pk8WiTRnzDlFpcogdLfZnP1fwB?=
 =?us-ascii?Q?QeS6ibPgNT6zyOhxTZi1mf8rwizrWqTvFeuGLrNgTrU8h0krnL6SaumV1J+f?=
 =?us-ascii?Q?v0KwPy/mPXhHf6PvTjiZYSv+bK58ZtZEBfUpDFNtWQnqmdQkzV48p4UcwfKf?=
 =?us-ascii?Q?eA+sXTeeSBehMWy7QGNYPfWEqpxiHhqb10V8R+7TgMaBfXoU/OOfw85HOX6j?=
 =?us-ascii?Q?dwYpGQP9k9jDa3rMveUIVe7QPfNaVPC0/Mj5cPOgRJ0Y9F0GZJIk/c8mQg5a?=
 =?us-ascii?Q?76YhzRdAdeUtDcjQNYD4xQo8DbBx/R7kqpEo5Ad6ZKxn3ueVD3xKetqJhcFv?=
 =?us-ascii?Q?h1Qz/qWvYYDjtuVA0r4j/gpCLFqCJHnO47r3o2cuV+C3RTfrKyh6O4yaT3ND?=
 =?us-ascii?Q?i91l34GoUIbiywXq5zJr7YlZatsGMCy6edblX3sSJw8r0J2uVrjJA686D377?=
 =?us-ascii?Q?xPf8yrYGn2mA4o77l5QhgHC78PqM28Kf3gGx7AL0sP4ivMXqfpMXdne8ekD/?=
 =?us-ascii?Q?+bRGabiRrA7NT3uHqubdJSmv+nBYEnjW4b3L6/QqnSkzNGBPLiD3E1IwLEc9?=
 =?us-ascii?Q?vLlr7MAM44YI6MONR3I8NoGJhMJGPwuy7g5xoyiEQO6kM9ODx7BfsjZf69VM?=
 =?us-ascii?Q?L42/6SI0E6WpSIdYhM3KNs5B4T3jTic=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b21035c-432c-4300-749e-08da295ba8c3
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 21:11:27.8990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZkZ5ia8peu/Dnrp/J8g35keb+s9OoVQA3A5+vnyQBUYiYvJRAQywL2a3490eGbi0J+kSkgsEyp4t7okF0HjTf3xsmWu0uE0fY/fHa8B6qIE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3341
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_04:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204280125
X-Proofpoint-ORIG-GUID: 1sreTTDlVZWDBsTMnr_7q1k9u3a9pykQ
X-Proofpoint-GUID: 1sreTTDlVZWDBsTMnr_7q1k9u3a9pykQ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Kunkun Jiang <jiangkunkun@huawei.com>

As nested mode is not upstreamed now, we just aim to support dirty
log tracking for stage1 with io-pgtable mapping (means not support
SVA mapping). If HTTU is supported, we enable HA/HD bits in the SMMU
CD and transfer ARM_HD quirk to io-pgtable.

We additionally filter out HD|HA if not supportted. The CD.HD bit
is not particularly useful unless we toggle the DBM bit in the PTE
entries.

Co-developed-by: Keqian Zhu <zhukeqian1@huawei.com>
Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
[joaomart:Convey HD|HA bits over to the context descriptor
 and update commit message]
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 11 +++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  3 +++
 include/linux/io-pgtable.h                  |  1 +
 3 files changed, 15 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 1ca72fcca930..5f728f8f20a2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1077,10 +1077,18 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_domain *smmu_domain, int ssid,
 		 * this substream's traffic
 		 */
 	} else { /* (1) and (2) */
+		struct arm_smmu_device *smmu = smmu_domain->smmu;
+		u64 tcr = cd->tcr;
+
 		cdptr[1] = cpu_to_le64(cd->ttbr & CTXDESC_CD_1_TTB0_MASK);
 		cdptr[2] = 0;
 		cdptr[3] = cpu_to_le64(cd->mair);
 
+		if (!(smmu->features & ARM_SMMU_FEAT_HD))
+			tcr &= ~CTXDESC_CD_0_TCR_HD;
+		if (!(smmu->features & ARM_SMMU_FEAT_HA))
+			tcr &= ~CTXDESC_CD_0_TCR_HA;
+
 		/*
 		 * STE is live, and the SMMU might read dwords of this CD in any
 		 * order. Ensure that it observes valid values before reading
@@ -2100,6 +2108,7 @@ static int arm_smmu_domain_finalise_s1(struct arm_smmu_domain *smmu_domain,
 			  FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0, tcr->orgn) |
 			  FIELD_PREP(CTXDESC_CD_0_TCR_SH0, tcr->sh) |
 			  FIELD_PREP(CTXDESC_CD_0_TCR_IPS, tcr->ips) |
+			  CTXDESC_CD_0_TCR_HA | CTXDESC_CD_0_TCR_HD |
 			  CTXDESC_CD_0_TCR_EPD1 | CTXDESC_CD_0_AA64;
 	cfg->cd.mair	= pgtbl_cfg->arm_lpae_s1_cfg.mair;
 
@@ -2203,6 +2212,8 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain,
 		.iommu_dev	= smmu->dev,
 	};
 
+	if (smmu->features & ARM_SMMU_FEAT_HD)
+		pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_ARM_HD;
 	if (smmu->features & ARM_SMMU_FEAT_BBML1)
 		pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_ARM_BBML1;
 	else if (smmu->features & ARM_SMMU_FEAT_BBML2)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index e15750be1d95..ff32242f2fdb 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -292,6 +292,9 @@
 #define CTXDESC_CD_0_TCR_IPS		GENMASK_ULL(34, 32)
 #define CTXDESC_CD_0_TCR_TBI0		(1ULL << 38)
 
+#define CTXDESC_CD_0_TCR_HA            (1UL << 43)
+#define CTXDESC_CD_0_TCR_HD            (1UL << 42)
+
 #define CTXDESC_CD_0_AA64		(1UL << 41)
 #define CTXDESC_CD_0_S			(1UL << 44)
 #define CTXDESC_CD_0_R			(1UL << 45)
diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
index d7626ca67dbf..a11902ae9cf1 100644
--- a/include/linux/io-pgtable.h
+++ b/include/linux/io-pgtable.h
@@ -87,6 +87,7 @@ struct io_pgtable_cfg {
 	#define IO_PGTABLE_QUIRK_ARM_OUTER_WBWA	BIT(6)
 	#define IO_PGTABLE_QUIRK_ARM_BBML1      BIT(7)
 	#define IO_PGTABLE_QUIRK_ARM_BBML2      BIT(8)
+	#define IO_PGTABLE_QUIRK_ARM_HD         BIT(9)
 
 	unsigned long			quirks;
 	unsigned long			pgsize_bitmap;
-- 
2.17.2

