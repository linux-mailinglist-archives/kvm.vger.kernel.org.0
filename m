Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8351513D3F
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 23:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352002AbiD1VQU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 17:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352158AbiD1VQR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 17:16:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8074B7EA24
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 14:12:48 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SIUvXI032115;
        Thu, 28 Apr 2022 21:11:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=rSitlollJCyEXryqFrrPlzG4OKubS6xsQQ+NSc3FyYY=;
 b=OTpiSKJrPMowBXrHHr9GcAw9dzgpNpeDMOmIoOC5e4PmXMBMzXGQPPqBs0eGqD2xh6yE
 qyLUTFhyKuR1SoTb0wLoCQVhUodfglR/xU1KCBTRo3WLQLgCYj7sYtA0dBaZp1SSdXAA
 3pqRVJdLNZbXGYZddPQb+xTopRf0TuSuyowTGvSeDqUnA0pWxdeH+VUCcHvhMwIQUwDR
 W/VSMZ2fhJAUihrDBvO2h2HGpdKgrO6LXDSOgX0u/3HHdDSLIsAcj92APpqoMfaZW5Ts
 Rt1iDr4y++F14sJMdNR8wHZDlSUPUA0A4jZfcEF9PXtk6rbbuUlhJ4fyd76POhx2eh2V uA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb104ndp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:11:21 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23SL6eDC028841;
        Thu, 28 Apr 2022 21:11:20 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5ype979-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:11:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ek3IXRsMDMWrhLe0Pt8zZ3euc+ZoPF0a193GkJijI7Yag9dMC9xvCMLtBAmVPjIT/3GswJbip4/GLA0jU6yrASqS0vHVQqrep4ZnsyLjiTNUsBO/eJ2n3ogGazr1sQKjhIhnZIaAgNU0a/fCwRcA4EG/F+tWrH84K0QFXJ/A5Sy2dKCd3/cyQAz93WuOAmvGh4t0euyN9N0juzdQuyIL56/eDA6/ma/P8AXn9bPqmmww7urAErXe7Ab9BzW2Kh3IfacfNzdqIX42zqtpfvR9eVPUkI3BRHTmfeF5gJWPqGNtMqTZVU+bUaano9ofAvKuZycx4ZLFkQOARyx5mZjQbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rSitlollJCyEXryqFrrPlzG4OKubS6xsQQ+NSc3FyYY=;
 b=dFECkleBxVvW5jlCyP9xGUNnqfJ9lPN4gv9DEbDbpYw6JyoSSVpIndDdX75TsV2fDOZHKwBsKV7z/+W4Fut46qstIcL1+trefBQASriVdxM/aj9fX5I2ZjAd8DC4AkkK9ZFVFBNrEBCnKfA0Bx6c0OubGQqHp4Mm9/lQmUyIqF8iEdoaYTof2cdJmyNTlB3HVY5Mjt0ZqyRWLkbY8Q1SmmQizUsLubUsYUqGhANvgFy93wsJ/2jqQ4GWmxjxzbYYO/Cgy88ItY+ME6mrHdRmAUfJmwcOoZZMpXfLF0QPYGbZAI3mEjIQ2P8NhNTbbgVbtf7McRNVk6Qcq4pMJ0wMgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rSitlollJCyEXryqFrrPlzG4OKubS6xsQQ+NSc3FyYY=;
 b=rxkVFTLTo2RntysRPKJIHHiPLhr2gOyBp7OVu+4tDt9czX0xQHbNDrxP6tS5utj5JQYfoHSDjC6hzAm7banJNb+rlMA9TCiYGBIvQk6HJt7YLW8KjkmaN0KXLpRinkjpmP/TjSQUIJxbbZqPLnprSQRcOcvAAvNtUuct4MjGNBQ=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB3341.namprd10.prod.outlook.com (2603:10b6:208:12f::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 28 Apr
 2022 21:11:17 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 21:11:17 +0000
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
Subject: [PATCH RFC 13/19] iommu/arm-smmu-v3: Add feature detection for BBML
Date:   Thu, 28 Apr 2022 22:09:27 +0100
Message-Id: <20220428210933.3583-14-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220428210933.3583-1-joao.m.martins@oracle.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0111.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::27) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 128a9619-1a9b-4c82-f2e1-08da295ba29e
X-MS-TrafficTypeDiagnostic: MN2PR10MB3341:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB3341E47A284D547324AA98A2BBFD9@MN2PR10MB3341.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ChZrGcl6eRtqc6HHjwNr7W1qOlmTgA/31KX0UUxtSMN9I3QZ8FUhSWF/WB6RWw8P9Z9eDlYqr8pDPVl2NPEaMSm7VxNX7TRX2XabOSGh2WfdJvoKHpMJxn2jvw1ytiD7C8m5hcp4NrL8PXwAPWuzfkKVO+3/PjXKaDX5VqRmKkQWD5d9Idxqz1e4hOJJwf9Bb+6CMD2RuqkrpXBWK+sNG5bdxoCLs6GJs747uxD2OZFpqR2+fq2WXD42I5buW0ljA6nA/8i3fgZPxS27U/Kh063tg+8qp5+T/Lg7J5e62zMKx9qdVkGOTvlYkLjA0BqcfF+0rIzrAvMEKIXmrYGBtRbzxz8VL04ssTJOGntAFyjp4xJ1Htqop0rIarL3HtjJSmdPEWDk2oUY+9mTOo5Bfy0+je0hBtFP42JKhdZqff04pbwXYWFYNgDRYPQJXMwiJgymNQFS10O4lS+Nc4NyuArpu7IF1q9YPMNa7W11P2DhXeJAtgHpOvvzMdZte4Cw5mWTi6Zq0OR5NPjfVyugWpw+9jIR5V6Uen3kAd6Cbt4cdBHRBWqZZKScs3nWP2afD4kQdsP3GSSsQoFVll0FIV39fNB2B8b6AXXVLnka5/nCnL+mEVc/7beWXouqtaRp2lZipiu9dk5pXFRGSGTxfjmMgO6l1Fmi16+7pknZvbOVD/JRPuLa7jEFeok9mE3p7GPKDIp60BqFmUX3p5DEYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(6512007)(103116003)(83380400001)(508600001)(1076003)(2616005)(52116002)(26005)(6506007)(6666004)(186003)(2906002)(7416002)(36756003)(316002)(5660300002)(6916009)(86362001)(54906003)(38100700002)(38350700002)(8676002)(4326008)(66476007)(8936002)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z0pRgV//JgAs0gmTd1mr74J0TDBHJA4RUCuzfuxKAMRRarWqC1JkF2K56Sbp?=
 =?us-ascii?Q?vvT7Shxa5F5+uoIV3Au+6Vo580G65eDNBLERfXYQSjyMa76h9o2M47akVu6/?=
 =?us-ascii?Q?DUMcV8P4+TvLwq0YBH2lRDzeoEOcNOGXWIKXq7HALyfqizCP/zV521FGlQ4K?=
 =?us-ascii?Q?1TXd4u3PErvgMZ+IybNn+9UWbCf9Ki5b2z5F2+mAItJej9/b93mPoKk6lUri?=
 =?us-ascii?Q?ZgnREX/hkVagdBekkYj9hW6VNDsbvtJGYbg5Tv8Cq+XJlCJ6QvJdgqr1Yxpj?=
 =?us-ascii?Q?S1DJztGPhUUUMVWjW9BAMaBXBm87NZ32yLDRoGBGAW6ntS+aaqufFcX+XQOh?=
 =?us-ascii?Q?Wc7euOP7gAmALRaH1ESz1UMmgwTaKog+bNc8mj6epZswMkqeOi0DvrVysr0B?=
 =?us-ascii?Q?4CZj09L5+i59nJnauYUGkqTanT7fs4cMo2AnbnCTGrKJZnzUkqhzP4O93wr4?=
 =?us-ascii?Q?x+RV6KIBqNhR0LRPvmA4q+oEOzqL2WlYU0mZMflpymH3sTL2sXGBIDEZcsBr?=
 =?us-ascii?Q?k62nbdz7pjW3HjZAwUffyKHdOZIjqfMPKSk2/LQmbkVyXRGUCsBO7okloQNt?=
 =?us-ascii?Q?8BKrh8qaRQ+31Yz8ZtP1blVpejqKnKhSnyAUB7UDuSlY5iwGDsZ7wKhsw+2y?=
 =?us-ascii?Q?3Pzk9wZlpttN4kVcaEs0WnMr2rJCNkD1oMWez1sY/9fyucBY/KjK9zWgwqxn?=
 =?us-ascii?Q?lDZRXrbzPKg1+s85qVqsQFr6UrJb7w6AVRIelR9jPAON5ZrLmVBk5fGnH6DC?=
 =?us-ascii?Q?lYX3Zor2HkhPMVH/cp38362f6cnk+ulIWtXw0qjMXyjlUOpvMx/DItWROwwh?=
 =?us-ascii?Q?+RriksOiR85Kny3K88Yg++XYB2N6Wi6UjxTMWlAcA9Uxjhe8hHEWvjwdrv4c?=
 =?us-ascii?Q?Cz1/pmuGT55Jbi/SSzBanUDssES7pP7BjMx3xDrSMduPzqJVWga5xYalEWVD?=
 =?us-ascii?Q?SkSu9bb0z9tsZKHosaPwZaocM/G+t7gi3gj7bO9pQ68t06P90SEWNQ6RiTbx?=
 =?us-ascii?Q?i6wRCgBInPJHp3m75qziF6PPVgE6BK7BzzFGl62bSp9uzXYVOCyICv561wIk?=
 =?us-ascii?Q?OrXbXX9kPYq+6qDsep/OKoNj4d1wZZztXn14wzWQHU7Mj6pzrzOnFEcQ2Xtz?=
 =?us-ascii?Q?cEEZqpSVEuL7c/LjkoBq3JKpwav2PuePLJhDOJc2gdDtO+5vl2DKulCBz9UR?=
 =?us-ascii?Q?l5f88i8XZ/hroYWCBlgt0tsUR5J6xsJFnDiXEx1uHudCuoymjExGNDDZ2pWc?=
 =?us-ascii?Q?jPuXSOOMAnsH1zTEQiQcGS2jCYeioMwki5j/uCx7k/MWMtY5YF//g/mKFYFO?=
 =?us-ascii?Q?hZa0US6zHEm2hywrAh5KvhMLFqAs8hLD96g0t9Q2SGrghOCKh9ugCsrNrx5N?=
 =?us-ascii?Q?pyJchKstHsVPn0cP+9fJoSjH1aBmIdtMf/X5pbkT0/1rA28IO2vED++0iyTJ?=
 =?us-ascii?Q?2TBdAKEBd8lntYKXFnxGGJpa05nVaGXyhcMcefCSU4YW81ZGUjgqn0gxhNEk?=
 =?us-ascii?Q?gclkW2dUmJB4Q0qsiFr/XFRRzYl4UbZCdFedzKBB1n0GjuqsLdEb9Q2tqru/?=
 =?us-ascii?Q?JDJ7cDpYB/3uExBOqXBJ3n7WhizcKVaam4HWSwgupWE4CmDXw5auehfTdVH8?=
 =?us-ascii?Q?J5Rt/PW2qrqB1Akl4vqZ3P3QU4wP+2g87m8CCTuuru1sO4mgJAxJNtZJ0sSd?=
 =?us-ascii?Q?vvLDAeSOUdoUBumoxzDvMPFiIo/0wwql4iWrNWm5RbmKpMPhq7qaWmfV6hYm?=
 =?us-ascii?Q?JHnCmXa2eEh1VyRq2QJvqDn1YE0xy7A=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 128a9619-1a9b-4c82-f2e1-08da295ba29e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 21:11:17.5465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XbnEh1kJIIhVNN+dxAU2eQ/0xnYV7DfYMzzTSyyvlVvlLo0In4Al9+xMBaQz/I3DZ6jzcp5rvnUvKXICh4cP5XXJWKhN+v/nukC0CVn3DSs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3341
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_04:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204280125
X-Proofpoint-ORIG-GUID: UlS2Lnwu5xCfI2b1j9FhtQi_GCcTIigL
X-Proofpoint-GUID: UlS2Lnwu5xCfI2b1j9FhtQi_GCcTIigL
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Kunkun Jiang <jiangkunkun@huawei.com>

This detects BBML feature and if SMMU supports it, transfer BBMLx
quirk to io-pgtable.

BBML1 requires still marking PTE nT prior to performing a
translation table update, while BBML2 requires neither break-before-make
nor PTE nT bit being set. For dirty tracking it needs to clear
the dirty bit so checking BBML2 tells us the prerequisite. See SMMUv3.2
manual, section "3.21.1.3 When SMMU_IDR3.BBML == 2 (Level 2)" and
"3.21.1.2 When SMMU_IDR3.BBML == 1 (Level 1)"

Co-developed-by: Keqian Zhu <zhukeqian1@huawei.com>
Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
[joaomart: massage commit message with the need to have BBML quirk
 and add the Quirk io-pgtable flags]
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 19 +++++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  6 ++++++
 include/linux/io-pgtable.h                  |  3 +++
 3 files changed, 28 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 14609ece4e33..4dba53bde2e3 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2203,6 +2203,11 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain,
 		.iommu_dev	= smmu->dev,
 	};
 
+	if (smmu->features & ARM_SMMU_FEAT_BBML1)
+		pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_ARM_BBML1;
+	else if (smmu->features & ARM_SMMU_FEAT_BBML2)
+		pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_ARM_BBML2;
+
 	pgtbl_ops = alloc_io_pgtable_ops(fmt, &pgtbl_cfg, smmu_domain);
 	if (!pgtbl_ops)
 		return -ENOMEM;
@@ -3591,6 +3596,20 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 
 	/* IDR3 */
 	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR3);
+	switch (FIELD_GET(IDR3_BBML, reg)) {
+	case IDR3_BBML0:
+		break;
+	case IDR3_BBML1:
+		smmu->features |= ARM_SMMU_FEAT_BBML1;
+		break;
+	case IDR3_BBML2:
+		smmu->features |= ARM_SMMU_FEAT_BBML2;
+		break;
+	default:
+		dev_err(smmu->dev, "unknown/unsupported BBM behavior level\n");
+		return -ENXIO;
+	}
+
 	if (FIELD_GET(IDR3_RIL, reg))
 		smmu->features |= ARM_SMMU_FEAT_RANGE_INV;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 1487a80fdf1b..e15750be1d95 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -54,6 +54,10 @@
 #define IDR1_SIDSIZE			GENMASK(5, 0)
 
 #define ARM_SMMU_IDR3			0xc
+#define IDR3_BBML			GENMASK(12, 11)
+#define IDR3_BBML0			0
+#define IDR3_BBML1			1
+#define IDR3_BBML2			2
 #define IDR3_RIL			(1 << 10)
 
 #define ARM_SMMU_IDR5			0x14
@@ -644,6 +648,8 @@ struct arm_smmu_device {
 #define ARM_SMMU_FEAT_E2H		(1 << 18)
 #define ARM_SMMU_FEAT_HA		(1 << 19)
 #define ARM_SMMU_FEAT_HD		(1 << 20)
+#define ARM_SMMU_FEAT_BBML1		(1 << 21)
+#define ARM_SMMU_FEAT_BBML2		(1 << 22)
 	u32				features;
 
 #define ARM_SMMU_OPT_SKIP_PREFETCH	(1 << 0)
diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
index c2ebfe037f5d..d7626ca67dbf 100644
--- a/include/linux/io-pgtable.h
+++ b/include/linux/io-pgtable.h
@@ -85,6 +85,9 @@ struct io_pgtable_cfg {
 	#define IO_PGTABLE_QUIRK_ARM_MTK_EXT	BIT(3)
 	#define IO_PGTABLE_QUIRK_ARM_TTBR1	BIT(5)
 	#define IO_PGTABLE_QUIRK_ARM_OUTER_WBWA	BIT(6)
+	#define IO_PGTABLE_QUIRK_ARM_BBML1      BIT(7)
+	#define IO_PGTABLE_QUIRK_ARM_BBML2      BIT(8)
+
 	unsigned long			quirks;
 	unsigned long			pgsize_bitmap;
 	unsigned int			ias;
-- 
2.17.2

