Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55D26513D2B
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 23:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352087AbiD1VOv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 17:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350638AbiD1VOt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 17:14:49 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FA4762B2
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 14:11:29 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SIcuMd003700;
        Thu, 28 Apr 2022 21:10:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=dTlD5HAbZ2TEiqONOYEsS3rToPUnCG/NQdVEeSmXTKg=;
 b=nh244DpC9XOhhVSef+Fgt5PrOpo9+oiqfI6zool5YBjKkODnSbQyPjjwROpjSgP13+Ua
 +jHzUmN6cBGlkskcVmb/AARwKHPIYz1bK9xAAkUSTEaOPCMjgh37jmfdy/GJAh8DC2BM
 n+RIcbohSjkDI+isjFPDgaBVZ0CCP7kjg25BBeZ7z/ziH2tNAjxB3YNLdML/I4chvwUB
 Ui5YE+Bg0aHNXlkYnMKsNLljdv1VkaglwUMMUsDkNxZWQG77U/CTyhyyK/LXYG9vEpr8
 pmAPWy4SmLB3fpVvJMv/9RzHqwKEKtpjUK6Rjwg5nFRydWob/rMaewZxVSC9hTP38uo6 AQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmbb4vsj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:10:58 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23SL6BSB024977;
        Thu, 28 Apr 2022 21:10:57 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w78a7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:10:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j6X66psG4DxwN3z0l8DYKgkVx2/XyEtyPoUO4VMW3zRp6KMDJxE0pPnZ+jAHr0jD8vBnDNxsl5cbu3ENBH1V6ZVZbk/E8ZyLeBeUKyYzRl/NR1e3M8WAypQDDaMGJ+5/d1/f4AuSJaGMz7PbF91Qa4F+YxuBEQ9yqy0Qtm88I/iO8Or9q8LGn49hpfT43rrEy5+/tzb/KUCRt+1ePEzFAuXmq1ZjOljlBozLDrXrtTG591Cb2HFX8Njmd2uRrXot3l2G+yMK0iS4wAJOiVtbg467/dVmkg01fuynpoKcx4sAgTSF8AkMyHhxwT4jMDU0H8Z+IbymPrn/1Nja016AuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dTlD5HAbZ2TEiqONOYEsS3rToPUnCG/NQdVEeSmXTKg=;
 b=b8GVupd76z48713aYAYaX4oWjU/hq480F5unK4cZOj1UOyqD6TO4nKED6odU38bR4JIpO18kzcHYoFMZoubc9rvOjKRdnwOaVRJ+Z/q5bASMRsbVDR8QUgkI5wqyyNMhw6h+1AHQIvmd48ASz74mDwOVtiYBVwPs4ldY9eYvvPEvnIwwq5cTF+IxH30r6PryJkCxl9hVqIar/Ktgpl8AjtdZZPDCS5fk6aj2Sehz+LLz8cThOpb8GfjzOQd+z16HJCTUqaVYSVFvCAMFV/3lVB9090WryOSar+Drl98blOD6kZEU+bIjZNN/oZBx9UBTZ/rjEJwFUv7E7/9ZAi//ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dTlD5HAbZ2TEiqONOYEsS3rToPUnCG/NQdVEeSmXTKg=;
 b=TPSthJI3xpbb5UyzdKkaA9EMWax00lWhbIEqazCVlFKQWM9JdjGbNXtMyryLWv7B8WMLR5uudfREQe7Lb/yNFoofrQmm/ajZKLni6sY4xYD10IMb4c3+IQPDl39aEK+/FWIoczBenbEjl7PZcXfq9TBbabp/L2/3A4h5buGmfYs=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM5PR10MB1564.namprd10.prod.outlook.com (2603:10b6:3:9::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.15; Thu, 28 Apr 2022 21:10:55 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 21:10:55 +0000
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
Subject: [PATCH RFC 07/19] iommufd/vfio-compat: Dirty tracking IOCTLs compatibility
Date:   Thu, 28 Apr 2022 22:09:21 +0100
Message-Id: <20220428210933.3583-8-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220428210933.3583-1-joao.m.martins@oracle.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0111.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::27) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56514688-04c6-497a-345d-08da295b952f
X-MS-TrafficTypeDiagnostic: DM5PR10MB1564:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB15642AFAB4D9A71CA32CC24ABBFD9@DM5PR10MB1564.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MEE+6apYez7FzU5Z/fS4a/I9GwKDKfkrZ8e/6IjNXpbBHcoPsJ/VGU1HVBTxs7i0JEWqzkFW/5gnWsLYWFrc4a7WjJDclcVApn0KB33C1n+VrfgtZBR0nrDq9sJ8z8HzK9upRk3SXtdhiVnxlXabiV1/puJM+QvIaHPQlpDTW6rdkdi+y6sortdT2LdsrI+vdzNWycnQwThh8gdZWoqzD7fO9D7gpyQKTQoG8A3BzqXbf/YaFMO2SmhAHl/bSrahldkhDDRujFm50rYASksay3m8HLh9L+7aU0KkwqkcpW7w1ZENmOwRr0pG0PrUBMDAimOTAwWeCHW9jBdI1d00q0bgu7T/ixOlP0z4Rk3BVOKv8XfSvt/zYuUyacs73je+nCDpZvl+ufVfMHpRFbmtprwGDC/J4hTnaah0FbVjH87+jIJlJodudQVQi+mZoqwToopRice6i5AIMNzpGVBMVEpWqjpFqYdorhAIW7aaFtRjno5jwak6atj3M7L20Vaz3KBtCx9JyUcO/Vt7Y1vuGJ7FtJ1Up4acuwQpACGWTBip/UaSAmmrzxwSvut9A7nOijbJCD4fLKCMSeWSPejtcOWR9L3oYG7PIDbmF53WxuZJe0pNBPe+VUv+FXhzgUqEMsfGZJo9Ft760zWQXPB96L5jD+uAt/PHhSplv0Hu6RPbuinqolu34AiqDRuA4L47cnlAj5rVS4n66pZFZz2yhEGww831ZyqXUuk/GBtURG4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(186003)(86362001)(66946007)(66556008)(4326008)(66476007)(8676002)(2616005)(36756003)(1076003)(103116003)(8936002)(5660300002)(7416002)(26005)(6512007)(6486002)(6916009)(83380400001)(54906003)(508600001)(6506007)(38350700002)(38100700002)(6666004)(2906002)(52116002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9w8zFD6jyNyq0SKZePEAt7Y3wWFXqIDNZ6Mr96Fk5Q9vkEGvGAUHxYWbx9rZ?=
 =?us-ascii?Q?8a3XQc4YQ9R9q7lwDlR12jUPaiIOVfSRk97pZsux2IMrNlumBaUREBIJ+Az5?=
 =?us-ascii?Q?0KWRDBzukNBtRyIBFYr18j3DSdWT6pKyxorL2vzGGWmR6a70EIOWu6AeLhI0?=
 =?us-ascii?Q?7Hwx8eXErEo/uCi3LpdgceSlBvDAE+3neNN1B0H/Xjk8u9SpqrRtwQSDQFL9?=
 =?us-ascii?Q?QPcimau4KiPYHOu8FboJo3HpFqrLZlnIV6IW1AlND6C26XhDU6cuHnK0ZrJq?=
 =?us-ascii?Q?9xqFOMLHHAqA/mBQ4TkRRFe6mBN6BjHurMXGku4xfhhpYdRySEEK0LJwgWyN?=
 =?us-ascii?Q?9BknjDChYOsyciYM/1F85U27X86Fy1LvjMbPAcKouQAn5y5iGNMXSrE5EtZ3?=
 =?us-ascii?Q?3bwv+M/VHjjIblg2rT1He+rGcY9IWWRBVo/6NUYrluaznVPuARf5l3nD7IRv?=
 =?us-ascii?Q?0kCEbMjQMDL9+mYSH+vzEeSGCN6KH75qIfb7CG0nb4u9fT2r+6/PHQBbcerk?=
 =?us-ascii?Q?WPmE7CTQMDx6UkMf/8+x3lHz6sCV3N8ZNDjWsGXRXCbPDFsTZ0PTCCKxJ8AJ?=
 =?us-ascii?Q?KOlUXouW4xL3X2gUGuXXFFQ4IXUryDe+nI8G+almcPan3BeLy/08T24ZS7D8?=
 =?us-ascii?Q?dDXHoARftHXjsgvQ04I9OmdmoEcRxUiHh5kxXU3Nij5VaVd/PwfrSSVm7zWt?=
 =?us-ascii?Q?Q6G6mr0Cm7s1QOkgrr5Cz6n0nhiDR8rWvKTSggpwf9O0WMAMQEQ4CQre52Zx?=
 =?us-ascii?Q?n9mJJyr5AhKBeebZ5pPT0RjL/NE6bivAVpoUOTMJqVaPj5pZjXiLz4YpmCnH?=
 =?us-ascii?Q?UkHt1qDBw/6wxkKuU0IKptGU0Q9urw1keUjqN17RSaM6Ok+FjhKWQq4NRsAo?=
 =?us-ascii?Q?ir+qL03LDSjV8aq9MUZqSsN+TC9R5gu7+y9YSfn8GoCPrBME2Nwgdlf4+aNU?=
 =?us-ascii?Q?lnBOQvauO5qjkH5vbYV6EDzs22GyUT6HZPXQ2slUnrNmleovfCMDJQlirpes?=
 =?us-ascii?Q?j3OZf9uTYan5F/dKKglENOce7MtONi20hx0r8tITJAiTlaZOe4XmoJdWsL7s?=
 =?us-ascii?Q?X/Ddgr1XwwP6LVwuKAk/CnC94ZZLGmB4cdNIJtTyA/ctEpn5JeUmdkEtlIXT?=
 =?us-ascii?Q?S2Eb8bx8YUC2IkTqj3aPqEbUliEUsC8ivs4O1v9wEhXl30HYBNRz4oX1TeSC?=
 =?us-ascii?Q?egcnHLsadkv8gfq2MZ07E7mCnVyU+rYoz1VQdl35SusDW8nclx/iLhYOp//1?=
 =?us-ascii?Q?qsmWqcEfxNgYrXAmFtsoTRfc6ObyVVRc1ylbjNcVlkn7LTcqXyAW930mJVAy?=
 =?us-ascii?Q?5MxfMprxwsuyVQwYjRxzqQw91RJHwcx15A0jck0wbciqfJlIdR5E3IB/oQYJ?=
 =?us-ascii?Q?pL0GWwRfm2gQsafImPFGJMJnAdkb0wcYHeVOCK5ubLvejFyvyJBsut1rmrEl?=
 =?us-ascii?Q?DR0PaOLFS3l0xMUgMqIgG60SGZfDNK4cP0s0mhslSWYwjn1S23XiFId0fNp+?=
 =?us-ascii?Q?Z2oEGEPTGj+0KvojX280BwSONz+3F/JcNPRG0+yNKyj3iqVFQHT6UWufrCSc?=
 =?us-ascii?Q?Zcusu/1F731K7UYfIeGh7H1wB92TqdRe0sU2srlaHF0ilQd/+htnSwzqxs8A?=
 =?us-ascii?Q?H5LRvncS9Ra33vGGmZVAEvrfDkV3xNtoFdJzCUv8q7zV2BB1t6dBRaGmp+VC?=
 =?us-ascii?Q?Uc84JTHKXh+mRfL03YZ0VzV1HvndfxEsnZYs8UVHeZtSPc9GikykJ9lKPjZH?=
 =?us-ascii?Q?HRLb2pFB0Z27ndQb9xsv4y7PUYym5AE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56514688-04c6-497a-345d-08da295b952f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 21:10:55.0521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ofQ54Xys+9SCe42t53yZkdEl4uG74/8kchjoAycyRd6zVaPDpHpFwfOTMPzYrbrPrfdf6HwsYidTuMsjU+12nczCOkFdEeaIY6ct1nXTJg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_04:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204280125
X-Proofpoint-ORIG-GUID: EJNJsQLJDsPS_-LSFBeLWfdUT5JuVi0k
X-Proofpoint-GUID: EJNJsQLJDsPS_-LSFBeLWfdUT5JuVi0k
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the correspondent APIs for performing VFIO dirty tracking,
particularly VFIO_IOMMU_DIRTY_PAGES ioctl subcmds:
* VFIO_IOMMU_DIRTY_PAGES_FLAG_START: Start dirty tracking and allocates
				     the area @dirty_bitmap
* VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP: Stop dirty tracking and frees
				    the area @dirty_bitmap
* VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP: Fetch dirty bitmap while dirty
tracking is active.

Advertise the VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION
whereas it gets set the domain configured page size the same as
iopt::iova_alignment and maximum dirty bitmap size same
as VFIO. Compared to VFIO type1 iommu, the perpectual dirtying is
not implemented and userspace gets -EOPNOTSUPP which is handled by
today's userspace.

Move iommufd_get_pagesizes() definition prior to unmap for
iommufd_vfio_unmap_dma() dirty support to validate the user bitmap page
size against IOPT pagesize.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/iommufd/vfio_compat.c | 221 ++++++++++++++++++++++++++--
 1 file changed, 209 insertions(+), 12 deletions(-)

diff --git a/drivers/iommu/iommufd/vfio_compat.c b/drivers/iommu/iommufd/vfio_compat.c
index dbe39404a105..2802f49cc10d 100644
--- a/drivers/iommu/iommufd/vfio_compat.c
+++ b/drivers/iommu/iommufd/vfio_compat.c
@@ -56,6 +56,16 @@ create_compat_ioas(struct iommufd_ctx *ictx)
 	return ioas;
 }
 
+static u64 iommufd_get_pagesizes(struct iommufd_ioas *ioas)
+{
+	/* FIXME: See vfio_update_pgsize_bitmap(), for compat this should return
+	 * the high bits too, and we need to decide if we should report that
+	 * iommufd supports less than PAGE_SIZE alignment or stick to strict
+	 * compatibility. qemu only cares about the first set bit.
+	 */
+	return ioas->iopt.iova_alignment;
+}
+
 int iommufd_vfio_ioas(struct iommufd_ucmd *ucmd)
 {
 	struct iommu_vfio_ioas *cmd = ucmd->cmd;
@@ -130,9 +140,14 @@ static int iommufd_vfio_unmap_dma(struct iommufd_ctx *ictx, unsigned int cmd,
 				  void __user *arg)
 {
 	size_t minsz = offsetofend(struct vfio_iommu_type1_dma_unmap, size);
-	u32 supported_flags = VFIO_DMA_UNMAP_FLAG_ALL;
+	u32 supported_flags = VFIO_DMA_UNMAP_FLAG_ALL |
+		VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP;
+	struct iommufd_dirty_data dirty, *dirtyp = NULL;
 	struct vfio_iommu_type1_dma_unmap unmap;
+	struct vfio_bitmap bitmap;
 	struct iommufd_ioas *ioas;
+	unsigned long pgshift;
+	size_t pgsize;
 	int rc;
 
 	if (copy_from_user(&unmap, arg, minsz))
@@ -141,14 +156,53 @@ static int iommufd_vfio_unmap_dma(struct iommufd_ctx *ictx, unsigned int cmd,
 	if (unmap.argsz < minsz || unmap.flags & ~supported_flags)
 		return -EINVAL;
 
+	if (unmap.flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) {
+		unsigned long npages;
+
+		if (copy_from_user(&bitmap,
+				   (void __user *)(arg + minsz),
+				   sizeof(bitmap)))
+			return -EFAULT;
+
+		if (!access_ok((void __user *)bitmap.data, bitmap.size))
+			return -EINVAL;
+
+		pgshift = __ffs(bitmap.pgsize);
+		npages = unmap.size >> pgshift;
+
+		if (!npages || !bitmap.size ||
+		    (bitmap.size > DIRTY_BITMAP_SIZE_MAX) ||
+		    (bitmap.size < dirty_bitmap_bytes(npages)))
+			return -EINVAL;
+
+		dirty.iova = unmap.iova;
+		dirty.length = unmap.size;
+		dirty.data = bitmap.data;
+		dirty.page_size = 1 << pgshift;
+		dirtyp = &dirty;
+	}
+
 	ioas = get_compat_ioas(ictx);
 	if (IS_ERR(ioas))
 		return PTR_ERR(ioas);
 
+	pgshift = __ffs(iommufd_get_pagesizes(ioas)),
+	pgsize = (size_t)1 << pgshift;
+
+	/* When dirty tracking is enabled, allow only min supported pgsize */
+	if ((unmap.flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
+	    (bitmap.pgsize != pgsize)) {
+		rc = -EINVAL;
+		goto out_put;
+	}
+
 	if (unmap.flags & VFIO_DMA_UNMAP_FLAG_ALL)
 		rc = iopt_unmap_all(&ioas->iopt);
 	else
-		rc = iopt_unmap_iova(&ioas->iopt, unmap.iova, unmap.size, NULL);
+		rc = iopt_unmap_iova(&ioas->iopt, unmap.iova, unmap.size,
+				     dirtyp);
+
+out_put:
 	iommufd_put_object(&ioas->obj);
 	return rc;
 }
@@ -222,16 +276,6 @@ static int iommufd_vfio_set_iommu(struct iommufd_ctx *ictx, unsigned long type)
 	return 0;
 }
 
-static u64 iommufd_get_pagesizes(struct iommufd_ioas *ioas)
-{
-	/* FIXME: See vfio_update_pgsize_bitmap(), for compat this should return
-	 * the high bits too, and we need to decide if we should report that
-	 * iommufd supports less than PAGE_SIZE alignment or stick to strict
-	 * compatibility. qemu only cares about the first set bit.
-	 */
-	return ioas->iopt.iova_alignment;
-}
-
 static int iommufd_fill_cap_iova(struct iommufd_ioas *ioas,
 				 struct vfio_info_cap_header __user *cur,
 				 size_t avail)
@@ -289,6 +333,26 @@ static int iommufd_fill_cap_dma_avail(struct iommufd_ioas *ioas,
 	return sizeof(cap_dma);
 }
 
+static int iommufd_fill_cap_migration(struct iommufd_ioas *ioas,
+				      struct vfio_info_cap_header __user *cur,
+				      size_t avail)
+{
+	struct vfio_iommu_type1_info_cap_migration cap_mig = {
+		.header = {
+			.id = VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION,
+			.version = 1,
+		},
+		.flags = 0,
+		.pgsize_bitmap = (size_t) 1 << __ffs(iommufd_get_pagesizes(ioas)),
+		.max_dirty_bitmap_size = DIRTY_BITMAP_SIZE_MAX,
+	};
+
+	if (avail >= sizeof(cap_mig) &&
+	    copy_to_user(cur, &cap_mig, sizeof(cap_mig)))
+		return -EFAULT;
+	return sizeof(cap_mig);
+}
+
 static int iommufd_vfio_iommu_get_info(struct iommufd_ctx *ictx,
 				       void __user *arg)
 {
@@ -298,6 +362,7 @@ static int iommufd_vfio_iommu_get_info(struct iommufd_ctx *ictx,
 	static const fill_cap_fn fill_fns[] = {
 		iommufd_fill_cap_iova,
 		iommufd_fill_cap_dma_avail,
+		iommufd_fill_cap_migration,
 	};
 	size_t minsz = offsetofend(struct vfio_iommu_type1_info, iova_pgsizes);
 	struct vfio_info_cap_header __user *last_cap = NULL;
@@ -364,6 +429,137 @@ static int iommufd_vfio_iommu_get_info(struct iommufd_ctx *ictx,
 	return rc;
 }
 
+static int iommufd_vfio_dirty_pages_start(struct iommufd_ctx *ictx,
+				struct vfio_iommu_type1_dirty_bitmap *dirty)
+{
+	struct iommufd_ioas *ioas;
+	int ret = -EINVAL;
+
+	ioas = get_compat_ioas(ictx);
+	if (IS_ERR(ioas))
+		return PTR_ERR(ioas);
+
+	ret = iopt_set_dirty_tracking(&ioas->iopt, NULL, true);
+
+	iommufd_put_object(&ioas->obj);
+
+	return ret;
+}
+
+static int iommufd_vfio_dirty_pages_stop(struct iommufd_ctx *ictx,
+				struct vfio_iommu_type1_dirty_bitmap *dirty)
+{
+	struct iommufd_ioas *ioas;
+	int ret;
+
+	ioas = get_compat_ioas(ictx);
+	if (IS_ERR(ioas))
+		return PTR_ERR(ioas);
+
+	ret = iopt_set_dirty_tracking(&ioas->iopt, NULL, false);
+
+	iommufd_put_object(&ioas->obj);
+
+	return ret;
+}
+
+static int iommufd_vfio_dirty_pages_get_bitmap(struct iommufd_ctx *ictx,
+				struct vfio_iommu_type1_dirty_bitmap_get *range)
+{
+	struct iommufd_dirty_data bitmap;
+	uint64_t npages, bitmap_size;
+	struct iommufd_ioas *ioas;
+	unsigned long pgshift;
+	size_t iommu_pgsize;
+	int ret = -EINVAL;
+
+	ioas = get_compat_ioas(ictx);
+	if (IS_ERR(ioas))
+		return PTR_ERR(ioas);
+
+	down_read(&ioas->iopt.iova_rwsem);
+	pgshift = __ffs(range->bitmap.pgsize);
+	npages = range->size >> pgshift;
+	bitmap_size = range->bitmap.size;
+
+	if (!npages || !bitmap_size || (bitmap_size > DIRTY_BITMAP_SIZE_MAX) ||
+	    (bitmap_size < dirty_bitmap_bytes(npages)))
+		goto out_put;
+
+	iommu_pgsize = 1 << __ffs(iommufd_get_pagesizes(ioas));
+
+	/* allow only smallest supported pgsize */
+	if (range->bitmap.pgsize != iommu_pgsize)
+		goto out_put;
+
+	if (range->iova & (iommu_pgsize - 1))
+		goto out_put;
+
+	if (!range->size || range->size & (iommu_pgsize - 1))
+		goto out_put;
+
+	bitmap.iova = range->iova;
+	bitmap.length = range->size;
+	bitmap.data = range->bitmap.data;
+	bitmap.page_size = 1 << pgshift;
+
+	ret = iopt_read_and_clear_dirty_data(&ioas->iopt, NULL, &bitmap);
+
+out_put:
+	up_read(&ioas->iopt.iova_rwsem);
+	iommufd_put_object(&ioas->obj);
+	return ret;
+}
+
+static int iommufd_vfio_dirty_pages(struct iommufd_ctx *ictx, unsigned int cmd,
+				    void __user *arg)
+{
+	size_t minsz = offsetofend(struct vfio_iommu_type1_dirty_bitmap, flags);
+	struct vfio_iommu_type1_dirty_bitmap dirty;
+	u32 supported_flags = VFIO_IOMMU_DIRTY_PAGES_FLAG_START |
+			VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP |
+			VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP;
+	int ret = 0;
+
+	if (copy_from_user(&dirty, (void __user *)arg, minsz))
+		return -EFAULT;
+
+	if (dirty.argsz < minsz || dirty.flags & ~supported_flags)
+		return -EINVAL;
+
+	/* only one flag should be set at a time */
+	if (__ffs(dirty.flags) != __fls(dirty.flags))
+		return -EINVAL;
+
+	if (dirty.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_START) {
+		ret = iommufd_vfio_dirty_pages_start(ictx, &dirty);
+	} else if (dirty.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP) {
+		ret = iommufd_vfio_dirty_pages_stop(ictx, &dirty);
+	} else if (dirty.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP) {
+		struct vfio_iommu_type1_dirty_bitmap_get range;
+		size_t data_size = dirty.argsz - minsz;
+
+		if (!data_size || data_size < sizeof(range))
+			return -EINVAL;
+
+		if (copy_from_user(&range, (void __user *)(arg + minsz),
+				   sizeof(range)))
+			return -EFAULT;
+
+		if (range.iova + range.size < range.iova)
+			return -EINVAL;
+
+		if (!access_ok((void __user *)range.bitmap.data,
+			       range.bitmap.size))
+			return -EINVAL;
+
+		ret = iommufd_vfio_dirty_pages_get_bitmap(ictx, &range);
+	}
+
+	return ret;
+}
+
+
 /* FIXME TODO:
 PowerPC SPAPR only:
 #define VFIO_IOMMU_ENABLE	_IO(VFIO_TYPE, VFIO_BASE + 15)
@@ -394,6 +590,7 @@ int iommufd_vfio_ioctl(struct iommufd_ctx *ictx, unsigned int cmd,
 	case VFIO_IOMMU_UNMAP_DMA:
 		return iommufd_vfio_unmap_dma(ictx, cmd, uarg);
 	case VFIO_IOMMU_DIRTY_PAGES:
+		return iommufd_vfio_dirty_pages(ictx, cmd, uarg);
 	default:
 		return -ENOIOCTLCMD;
 	}
-- 
2.17.2

