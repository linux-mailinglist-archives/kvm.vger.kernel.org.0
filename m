Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA063F3570
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 22:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240270AbhHTUkZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 16:40:25 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:1874 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229811AbhHTUkY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Aug 2021 16:40:24 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17KKQnH8028645;
        Fri, 20 Aug 2021 20:39:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=G/2sxM2EInI4v4pojuFc3CrpqvtVXroGLIP1qPNQl+Q=;
 b=eYYixp4+MNLzL61CpmCkbYa1VVEH296a6v2jAbVZrb//ijJgVMYdfEcXETUyE5uH0L/I
 RMJEGZhqc+c3kQTUmTQYnlaLglHBKYcaeLyW/FSJ1fI1er9np5YFyT3eKOTdTsXalpML
 sxQy8ZFqQx00lswm7of1xpMujGsuu9CMAd7EOMUfib1CiVDeNKhogQEeTXUXSq48oHkM
 /3ggRNitxIyxyrnWtY4X3wAsrpcI+LgjWi7oyiM9Xn6jGswwOmuzCdoxcCKg5NMhReyf
 UeSFghn1hDvM/OuMOb/449VH/yz5N0bvAFnnKeLgq7lR5NFKeruoMYMsrJdRm7zpqkzF Hw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2020-01-29; bh=G/2sxM2EInI4v4pojuFc3CrpqvtVXroGLIP1qPNQl+Q=;
 b=peSgcRElRCQSdcYCspcGRObaBLjttJugoa0gmFE4sJ35ocrvhBDs7LnfmXC7lFPRmYCF
 a4Tr8gKjdZ8NQU0m7CFI0MqQk57k48Cfh/J+Unfe1mN7gi2J8UP9hFuQujxYoJDCRvhl
 bRqEtG5XVEhJsnI13/uuQPQOuy2EtXCyKQr4/mG6fm+0ZfW9R9UzQNHUON7K20zC4gGS
 Vn/LUCj8gBQQRSpvZTWdaRsasiZHi47IxX2sHz+lE/4gavxniuL3jl94vK/TBcNZ+fJf
 kRy/bInLtWOQUKODDSKsiq6F9/G/CR7IlFuZMMcXilLJTsa9CHdoedbGeBEDlZGJvMiW pg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aj6rfsv42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Aug 2021 20:39:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17KKPIZo127836;
        Fri, 20 Aug 2021 20:39:43 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by aserp3020.oracle.com with ESMTP id 3ae5ne8qm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Aug 2021 20:39:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fdDSGnrrLCAAnx1zk+K78iqCTDZizF+s2UK1zv47yTKpCaJdlO8n2VyUwBggG4a/ryoZp7ZJudaraXz3PHsvNsiGvahSMAivqKV6CBozPat/jLgZa6ikapCNiEW6IbxZrTQcb5HVnT+M+kKHue9CBBT4BIDKZeRZUNTCudcgZCiA3sDP99Olly++cycObJwEQO/zsnY/Tfs7x05kKXZiCvDEFzsUarJVAuCzvydx0tiunbaElZAxHWoXK8FPeSZuyccSmEDaMF1dIO0MioNQ9y6NSQvI973lnvQBDzzdZbfbemHqYPWeRZd9QbakgwN3k/kXSgT/CsBMjxvuo7zJdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G/2sxM2EInI4v4pojuFc3CrpqvtVXroGLIP1qPNQl+Q=;
 b=BsAYPTDvPLOQ0nlwCUvLD5ngK8qH0YHgOftuCnihHEaUc+kItTE8omZotRPidBMlzNSaHVrDetrmKhGs92LdK4lY00/z6GeRy2pqs1GBYbdUjJEio23l3pIoA3voctzEUZPz8EVi6vuhAo2/1Bfxm6nQN425G9UFMUQGFHjp5Bjo9zGV/qtcAk9AXYxm98sNPG3+pBb6dO5aRjyC716Eeb3NVJGZbYRmmNj4W9qjFZWz0d1/bss7lFu4r2MW0/+UPYuIdOxOV8UVaMLR2AuI/JzIo+VW/ndK6ar0x1Q9nZMzrVgmxFH5G7uLrq2Rm6Ty4VyxYPGfpk0SNLog/ZoY7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G/2sxM2EInI4v4pojuFc3CrpqvtVXroGLIP1qPNQl+Q=;
 b=BseUxwu9Pp7feeaGDKBsELd6GaLnqVCQP6TWNodlW3ujRgzFA7LZ7ZfO8hh4lfVYNPVKEiNXP06LNujim2tezMKg+b2YGicYnE80XilhG7V1uE+vVn1geh/K7ZX1Qpv1K0rdpbS1vCi+oYxoFnSEiBlK4RMGDbZyliXBsDMGAdQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MN2PR10MB3533.namprd10.prod.outlook.com (2603:10b6:208:118::32)
 by MN2PR10MB3502.namprd10.prod.outlook.com (2603:10b6:208:118::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 20:39:41 +0000
Received: from MN2PR10MB3533.namprd10.prod.outlook.com
 ([fe80::b4a5:da86:b597:8547]) by MN2PR10MB3533.namprd10.prod.outlook.com
 ([fe80::b4a5:da86:b597:8547%7]) with mapi id 15.20.4436.021; Fri, 20 Aug 2021
 20:39:41 +0000
From:   Anthony Yznaga <anthony.yznaga@oracle.com>
To:     kvm@vger.kernel.org
Cc:     alex.williamson@redhat.com, steven.sistare@oracle.com
Subject: [PATCH v2] vfio/type1: Fix vfio_find_dma_valid return
Date:   Fri, 20 Aug 2021 13:39:34 -0700
Message-Id: <1629491974-27042-1-git-send-email-anthony.yznaga@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0003.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::21) To MN2PR10MB3533.namprd10.prod.outlook.com
 (2603:10b6:208:118::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-qasparc-x86-2.us.oracle.com (148.87.23.6) by SN7P222CA0003.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Fri, 20 Aug 2021 20:39:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c15d4e63-3d1c-45db-9bc7-08d9641aa2ca
X-MS-TrafficTypeDiagnostic: MN2PR10MB3502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB350236E0C25838A7E8BCFFB5ECC19@MN2PR10MB3502.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Odvfryn/+KLjfTrgjjMtCtIZLGvLaGNmqUmrD/E4kDTvXWQZZX/Jk45qyTvkgvtzkJPJUBZbA7DQR1w6yJpYHM3x6f5zK3GoKgDn2lgwCpWetwPb+K6N+87tm+cB0+iW+nal1CHkeRZzx6Z3m+zA5X/pAKztjsIlGg5l7cGerZvgwrtLoH1JJSWUg18hcCqFAkEXADtNeHURga9DMlReJIoPJah24w24pcWZgYPHqJ17s54IyExePBHtnM1OYYXQ+GiAjyNcn0E06jx8hXSCJckjp7t83K8dbP1us7CGIw21mudQmCboGEZUwrS6nrGQbR31nuzGGO7D/e/2WqO8QDPe8TAm4PKmIe78/a4qFDavSrD/pskCYWi8krCkKE+r86s/E8w3kZ8jJIOlmyteLP/5hYHm7W8nrAMJxbkR27GRvmA0jltxONHGJemrksJsSmJ1zhuHQpXbmtf4tP0HDav9Vlmyoy6tWIdq9OnOicERbiTDxyKAbDUW3PqxSscb1GKOTpO+MUjrz3Ktu5DpYNMaG2BoVLDd3Qi0KWXOrB0piojKZFsb9Dmfh8TAL3NG/iPiOYJdW0Usy7MUSr9SbNyadbbCDwg7N9th6ilEwsTXn8Yj6xmDaWJMxwZ5lUBFcHrjJ68dY3oR9Qe+fvliwMQBP08WAceQMbyoKM7Hmp/OXpNOIrVf771H3hPKrhqINTT1+e4n6aqIC8FXUO/1kQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB3533.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(346002)(376002)(39860400002)(66946007)(66476007)(6916009)(52116002)(2906002)(86362001)(38350700002)(66556008)(107886003)(8936002)(36756003)(7696005)(8676002)(316002)(478600001)(956004)(2616005)(5660300002)(186003)(6666004)(6486002)(83380400001)(26005)(4326008)(44832011)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EmhK31G5SGUnRuL4fsLtVJJBvXa8vYQcPgB31Ydo46xu/5HN+JhMckAT2GPQ?=
 =?us-ascii?Q?2y5OSIBFr7JO16ftIh3S0wGR9vO5Gu0xiilzv/IMUK7+d8PeF8gJ8tNPejNB?=
 =?us-ascii?Q?f0y5koXl9mHpJN8Gc6rdOHB7qYSXVHzgGZ4lnHlJdgWq8Uh35w5H6GQs5XyL?=
 =?us-ascii?Q?RdPMIxqweTnCwqvqlKXbiaHoMA73YM9Xf7DW1CNF+vTSzUL5z0b9iR14hP4Y?=
 =?us-ascii?Q?cfgphG0VqLbKJUpZVsn0M6l57v3xCpDP5D9TJOJDumK48/gyPb2vr6oC3mrT?=
 =?us-ascii?Q?H7DAdWuTIfhOLftpvU3NC4KPV2jqmG4TDfQm3PR/dmHQ6iO4n1QU2wrQcyv+?=
 =?us-ascii?Q?YJBq+l5DeqscFlBcwG1tYK7BPMZijrqjgp2zPJ3ETpQk43xy6FZDkpfsbhsb?=
 =?us-ascii?Q?JDsDvI8Deb1Xo2uYQEGQHIM3q8fqSHHyrPJ67hrPCnzpzrbSQ00d0QJvZNzV?=
 =?us-ascii?Q?YAzheUDtvlHI711/CehA5UJnP/BcrFbdO83sMdtCOi5yDm4m8m1o1r4Q2OJ1?=
 =?us-ascii?Q?KAc2vrjPmG3mSCl26kA4drabf8iC/yB11IvK/UXCq4XvcrgWzRB121BUupOR?=
 =?us-ascii?Q?Gc8z8f6mVdOosQvG/Lx1XGLDtK3JvEMHtnbpi2sILRrfyC5V725BCKzOpori?=
 =?us-ascii?Q?0NP0W4eV/4BOGib86E1zEcnhDw0T2/ultYBFVzW66uAMpZhR5imaNj+Q6uJc?=
 =?us-ascii?Q?tq4kQ8EnR20ULm4aDSa+jiqn1ccosD/QOma+liVCBNaaylgUZlIE+Sa4woyF?=
 =?us-ascii?Q?fsQ5tLtxVCVMVugzh/JLk2mNq4tKuCI372vHwVYWVsgMlgtue2N+/gTd8PfS?=
 =?us-ascii?Q?8lnkRBqQMLD5+AcFrFoWye+pAt5pJ+efzqy+8J53OzqBmEl5UyDScsUibzDh?=
 =?us-ascii?Q?3PFuqWs14eE6MEHp6PFNtEEXAtfB45BvaoITVChFkctkvpZ/UHi5jhmi8MLL?=
 =?us-ascii?Q?MMm9CAUJhhvx8BZqLQAa4rVvjEtVi+MNrggoC7F4ARuFuq3kYMhiPnv9/2BZ?=
 =?us-ascii?Q?CNavyi6Z569Q58fWCQGijAE+RqfriQCPefX7+T6zkjJsWbINoiCeUP/WmAFh?=
 =?us-ascii?Q?16P4W3pe270xrENLnMijUdMfKHx01fNePIcMR80e8ZqFxQTDOF4q9HxzFgi1?=
 =?us-ascii?Q?uM7g97JxleMsqMt+CyOmujk/ngjmy9oNod9M5lPY60pjF6svBf8yvIOCMiHk?=
 =?us-ascii?Q?DUitDCSdD/7RBZ5qJb3svHKGvn0r/y9sMP51AnZ2EIMx+NPKrB42+Km4W1D/?=
 =?us-ascii?Q?v4gihWy8mz+bax4eUQvCg4bLe0QlzkWgQvTjENAwBhysJLV91GPq3jgmQNcY?=
 =?us-ascii?Q?6TxcMBcny2+RaT4qZa6eAX4l?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c15d4e63-3d1c-45db-9bc7-08d9641aa2ca
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB3533.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 20:39:41.4389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ERgifYYp9g8tN8JmHtZQmx00dA35nNBjIs6ca6IRsD7qApLtp9h8c8qsRoZfx1EsjSljTn6qMZCXy9EYTq70HKtLcqfKZD0aDyO2M0pFYwM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3502
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10082 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108200115
X-Proofpoint-GUID: XWnu9J5ZmxiI_w0-E5cEhX5nkj4hPeky
X-Proofpoint-ORIG-GUID: XWnu9J5ZmxiI_w0-E5cEhX5nkj4hPeky
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix vfio_find_dma_valid to return WAITED on success if it was necessary
to wait which mean iommu lock was dropped and reacquired.  This allows
vfio_iommu_type1_pin_pages to recheck vaddr_invalid_count and possibly
avoid the checking the validity of every vaddr in its list.

Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
---
v2:
  use Alex Williamson's simplified fix

 drivers/vfio/vfio_iommu_type1.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 0b4f7c174c7a..0e9217687f5c 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -612,17 +612,17 @@ static int vfio_wait(struct vfio_iommu *iommu)
 static int vfio_find_dma_valid(struct vfio_iommu *iommu, dma_addr_t start,
 			       size_t size, struct vfio_dma **dma_p)
 {
-	int ret;
+	int ret = 0;
 
 	do {
 		*dma_p = vfio_find_dma(iommu, start, size);
 		if (!*dma_p)
-			ret = -EINVAL;
+			return -EINVAL;
 		else if (!(*dma_p)->vaddr_invalid)
-			ret = 0;
+			return ret;
 		else
 			ret = vfio_wait(iommu);
-	} while (ret > 0);
+	} while (ret == WAITED);
 
 	return ret;
 }
-- 
1.8.3.1

