Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDD03513D42
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 23:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352123AbiD1VPk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 17:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352129AbiD1VPg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 17:15:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58FF9811B0
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 14:12:03 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SKDo9u018591;
        Thu, 28 Apr 2022 21:11:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=94yaTtglIWm4hKDEKJdxKy6dTj8aaec73GqihUOP0Ss=;
 b=Ql6Wi6Gn4oBqNBuvuao44t9AQ5qffURVcRWWlDlCYDwgjxf0N0G0f/u2u6V6KIBn8FsZ
 W2awzVBeRRFnMzriLvAbqXpQSs49mfZnhZBEul87B6/gqKAly6sbTaAYnAVVM2cN8DmN
 vsH9oMfqyQln86lnzz+TIxv3KkYm/RACLAKA7/R4Wvc6h+WDiaMrniNAVnKbDs2d224m
 Nx0vkTbYf/Hna71JGIBHHvG0CEhtgoXAMZinm/a13B5gTwJTV+U4ltVyQVzbuu2VxHeO
 s+Hr4AN8DoLyuLZPYskx+9zjGtZaYscbbUZ6gFPhRJA4yCzMxWJydle6yqtag6je0XPT +w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb5k59gt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:11:41 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23SL5CuZ028560;
        Thu, 28 Apr 2022 21:11:40 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w79pb3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:11:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KuGYbbdVJEtAhf2JnWSURMAErWlFZFI0TnehPlApIJp1gDm1YUQN3KnyYnysIlzQMhjYVGfDYZCSjCxPSVNBtIDzxMZyai5fEwEIHYKZUJbaxmoaeMknQRKq/M34v4Yn7rKehgc4xIqC9802lqvkalcPd6tF8XG5BT8To6LAy8DL9STgiputee6kXulwk1/N5KCQPzTaIQQtz5/nHcY5Y1nUvxqH1XCLmu8BDAupFtddZNjOIMaa2J+JKbV+p4Paq2gZurzTQf1Ssz/Cv40jaldJcdWJjmP/gMuGX7GJvYDa09lOyp0zDik7yvQ8MFuAdesXnhPSinkV6JPTW09Y8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=94yaTtglIWm4hKDEKJdxKy6dTj8aaec73GqihUOP0Ss=;
 b=SGE9EiCrXAJZYm5CXX34xWdB0L4TiVCyqrdUULrSkmsO/n7p65C0iVF8InrLQwDKvA3RtBOnvZvih5kgU47FEAdLkbvPAFCLkhn7PMzIyZnd09cI862xhGjj/Yvu/cSbmDLtUfApjYvieXd46aa0eUsY+WzLZjAS/9b1voKWDlrhNxTLwKDCtEK209RJPHgykimzZ36pOo9oWVTyQVizac99hmNYzDr5V2EdS228sI6s11xq2M6it1JEjBEQxGevd6B3hVvdbWjLaZf14pdotB2v7HhGU+wjBuRiSrAoOXJaUBY1YdVfhavxQEwj6/nonNcc24wQxTWMdDFjdN0leA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=94yaTtglIWm4hKDEKJdxKy6dTj8aaec73GqihUOP0Ss=;
 b=TuCb3zcAPxogHn7bYAYG+VBkifa779fusQxqHD6sq9mTg7TF7SSwxSMUH4QFm77lMYylyjy6phj4QIkuRsduUSYkKSvnXGk/gGzLHQ3AEonvvIvD46i3FWe6SObtP7MVmISwWlBHAvBHKymPIUDMzngYcKsTt6aUXF98fk4xU9Y=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB3341.namprd10.prod.outlook.com (2603:10b6:208:12f::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 28 Apr
 2022 21:11:38 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 21:11:38 +0000
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
Subject: [PATCH RFC 19/19] iommu/intel: Add unmap_read_dirty() support
Date:   Thu, 28 Apr 2022 22:09:33 +0100
Message-Id: <20220428210933.3583-20-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220428210933.3583-1-joao.m.martins@oracle.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0111.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::27) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ab00713-cb1b-4d02-944a-08da295baf27
X-MS-TrafficTypeDiagnostic: MN2PR10MB3341:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB33413E57E5B04116A4F829FCBBFD9@MN2PR10MB3341.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uuW8DCGbscJpteT3TTTot1w0v1nFDz3liE8Wf5+4oZjLkpUD2HRSvgwcqq4A5pMPy6kQ0TyNFqwrXb/KCK4rSlxCbt+YUdZM+bkdm4zUwV5N0b29AEnS7OufAK/1jaKDY1FkFalCiHXdpiSkz4FYYlk12ZVgVlDg4YOfMNVtomZ5+NQB3Q7EYA4p5WpZHChHb74S0OGYYj5zvem9oKVfnf/xwfr4qp0a4dHHZYq8H5lV+vNJe96ZFrxuYX10oMeQQ/zjvqgGa3/m8RiJ01nHXLWIP0tlMzuKEtwnWAfTFvpwK9wh1WxsvOm2TYuNJK+jE4GhLQ4/Fa0zGUNxBvC5GsYd6sXKixaI1QcJcRyqUJYpYS67VCv0+potchlRNnI9Bqp5nhuBhXCuHZxXCQFww6b8jskU6XXFPfpI1OoaWvEvcmtdfQ7OqHwYFpRsST0vMqgIwQK6BEu2YTYpj/t47wOkZzliW8AAZQfMcF5tjEuNiBSpiFOYIUEgiab3ogtnMTPsCkiDfeNj+lLwfjvIW9dcibMSbrjMYFjyqMVG+uA/UR2vuZX44yseMor4DXyec/oUgWdfKP6s2K6HBKYkJqbP2WVLe76YtFB2LSbUOLBOqrdVyVzNbBHF0u1OfbG/ATUarE7p53hHy0Kag921Kh6vVrDuM4pPTSikSsblaYqzGiSoUCrkfOdXjqNNy+ZchnvwT3CEBoIONgz5+KIJWkz1ELkEu5wNhgkfOp3ll5Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(6512007)(103116003)(83380400001)(508600001)(1076003)(2616005)(52116002)(26005)(6506007)(6666004)(186003)(2906002)(7416002)(36756003)(316002)(5660300002)(6916009)(86362001)(54906003)(38100700002)(38350700002)(8676002)(4326008)(66476007)(8936002)(66946007)(66556008)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8TSVkUj+HVViTkR1IZ1IFTad7Du1vkqjINDH+QR1RWFBvaw40eAEFw6kzqV/?=
 =?us-ascii?Q?g1m0EFbkOxix/MYkrHTegO8trBAb5MjDqNQL9lt1CvhovOgcYkQx15boNcv9?=
 =?us-ascii?Q?iuQAG7NWiqElE7mHOVa/FV9AYnyvFTeRqFhyKkeHDshOJ+OGskzoBvB7lYcw?=
 =?us-ascii?Q?bsKtMTOUaE9lcxgZc3RVoBhBTctj12dOiqG438qruIxY2ar9QsxGGzH1raNJ?=
 =?us-ascii?Q?1EFFoavqCiIhtg+13MxJ7nnAR8zu1rWNN0Hb0JUp+kjvdijvaJKmChb9V5hW?=
 =?us-ascii?Q?mhkvgjkOqTchJY8SJG08U/qSuD+UK0RVMQItkz4MJE2lhHhtS+zL35cs4QUf?=
 =?us-ascii?Q?Xits1Vujt1M5YG0tktl8S+3RUBoPoqKjqItC6xZRVxVzwNLv6smsYC8EipT9?=
 =?us-ascii?Q?tiHPYfz286/FbuDLT+NQbhzGo2zgRDVQZT+7xguKC35RgxOW7jm92g7PxYeT?=
 =?us-ascii?Q?UgEHPvHsuo6W/9o27aIgidy8bxSfQQqQYQlqjRMQjcqNmc77Zgwam6srBSVQ?=
 =?us-ascii?Q?mqjjoFVpHrLziBDJNb0Shdw/WBD2jN1miQZEAR6+M6Sk7Gg6snOZ4pDoEZjN?=
 =?us-ascii?Q?1JymGCpApL/AhlBSdxahxLnAqNmKW1UKPxRvuCkTkQswHLPdKPNm3648KkzZ?=
 =?us-ascii?Q?tIdpk6WIJ8McbtIRmWRpxSq9czoQHatdmqIEfno6Ik8IUl8qIL1aisLxg9dj?=
 =?us-ascii?Q?rjOy8mPLpkdkYyb4akim5QPIDsiV5Ci1V2xHjPJrwN/wiVacjJXk9/NmOOLY?=
 =?us-ascii?Q?d06DOIgm+j3NOYiSxczQcCJOH5TR/eYAFn63Hb2szgHfJhJL3NI0ugk0y50S?=
 =?us-ascii?Q?r2miS0c/sl2CC5X2g2WobMEjmvbjd5U6hj6zSTZyNNyPg2jWD81cmSqANcSt?=
 =?us-ascii?Q?tnO2k+XogrftXyjiEZjuc1aGO7p6xZCTFvmNxldVS9XTbN/XbEMj6UYX2Kbc?=
 =?us-ascii?Q?jEU7zH40+drKCjYtyQN3u9tWQpeJIOpWdPd3M61ZVKxwjJHVjVDodmyKstG9?=
 =?us-ascii?Q?uZCaXsPUhbazWzfm89pbVhr+ouXPKIoYcjStXq21naUKLK0nuSV9ma/zzgRG?=
 =?us-ascii?Q?df9mXZ6ZHt6Gv9a0FlQ3OYhL8hGjcrN4IA+zIfnFmsBkXx4CiUMTtKU6exCW?=
 =?us-ascii?Q?ubjjmXxqh41eNXE4r6poMWfCqkoWsjbtiBpOtWTBTBzJHQgjchb+MVChWvRn?=
 =?us-ascii?Q?3n8TGIQPcsZEO9eTWT5XFkrvDPaTh+cHVP+HRw0zNvAY2orJ08rsGRGZBy+X?=
 =?us-ascii?Q?R0UQaGHjADcDTn0Dy0zKEyBRBw5umrtiPHaEDiyDMP7b6f5zqUFQxoYcGMe5?=
 =?us-ascii?Q?RVEB528bfpHBdlXkAUHc4saC6alqCuM9rVy0KJzjXALLIlwkms6sPTE8289m?=
 =?us-ascii?Q?gtgOF9vr7TaSdwvLi7jZsRnUHSsON2dDipd7xXHtw9LjWd912pFIDbUPKkT5?=
 =?us-ascii?Q?yqwZE5L6AviA8wLf/0ncV635PMoYvO0TDrFEVInU6pMbVhMGbBcXpgiKqujF?=
 =?us-ascii?Q?n0ItHcbAf0RkHOvj9PMQxLvfLV3s4i/zxthPLk7//+Z3Os6MLq3keImC5B5F?=
 =?us-ascii?Q?VnKSj+nl8c1PYY2tLaJ6oyZKe4VnKCYC2jKbpkeEZd2vZ2BeKvwJk34hVlpM?=
 =?us-ascii?Q?7qIAJxKtlDgIOlj9PkT6g0vb+xU3BfbkMf12LMuFnjVf2P67CqfUq9xTTXv3?=
 =?us-ascii?Q?KRIPAzumSjBHMnYZGdscHKtvhhcangwcKPIvtYA48PnVoxEkSoK9ZnZe1mT3?=
 =?us-ascii?Q?sWk2EN9qrHZtfT7eIEDY+B4L+/Nyk98=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ab00713-cb1b-4d02-944a-08da295baf27
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 21:11:38.6684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sJeJ8PxgVEvYHmIC82HmD9VFqB6P28d61HjoAiHvOLBjqXIDU0yAGRFAsp2HPyGu3cncKYZ0/GkuqymS/Yzp5s/yBYJTSa2WbRC4MtBC3Mo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3341
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_04:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204280125
X-Proofpoint-GUID: AKW_-Hk2wq8P_MHF85KRAZZtF3M9fwjc
X-Proofpoint-ORIG-GUID: AKW_-Hk2wq8P_MHF85KRAZZtF3M9fwjc
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Similar to other IOMMUs base unmap_read_dirty out of how unmap() with
the exception to having a non-racy clear of the PTE to return whether it
was dirty or not.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/intel/iommu.c | 43 ++++++++++++++++++++++++++++---------
 include/linux/intel-iommu.h | 16 ++++++++++++++
 2 files changed, 49 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 92af43f27241..e80e98f5202b 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1317,7 +1317,8 @@ static void dma_pte_list_pagetables(struct dmar_domain *domain,
 static void dma_pte_clear_level(struct dmar_domain *domain, int level,
 				struct dma_pte *pte, unsigned long pfn,
 				unsigned long start_pfn, unsigned long last_pfn,
-				struct list_head *freelist)
+				struct list_head *freelist,
+				struct iommu_dirty_bitmap *dirty)
 {
 	struct dma_pte *first_pte = NULL, *last_pte = NULL;
 
@@ -1338,7 +1339,11 @@ static void dma_pte_clear_level(struct dmar_domain *domain, int level,
 			if (level > 1 && !dma_pte_superpage(pte))
 				dma_pte_list_pagetables(domain, level - 1, pte, freelist);
 
-			dma_clear_pte(pte);
+			if (dma_clear_pte_dirty(pte) && dirty)
+				iommu_dirty_bitmap_record(dirty,
+					pfn << VTD_PAGE_SHIFT,
+					level_size(level) << VTD_PAGE_SHIFT);
+
 			if (!first_pte)
 				first_pte = pte;
 			last_pte = pte;
@@ -1347,7 +1352,7 @@ static void dma_pte_clear_level(struct dmar_domain *domain, int level,
 			dma_pte_clear_level(domain, level - 1,
 					    phys_to_virt(dma_pte_addr(pte)),
 					    level_pfn, start_pfn, last_pfn,
-					    freelist);
+					    freelist, dirty);
 		}
 next:
 		pfn = level_pfn + level_size(level);
@@ -1362,7 +1367,8 @@ static void dma_pte_clear_level(struct dmar_domain *domain, int level,
    the page tables, and may have cached the intermediate levels. The
    pages can only be freed after the IOTLB flush has been done. */
 static void domain_unmap(struct dmar_domain *domain, unsigned long start_pfn,
-			 unsigned long last_pfn, struct list_head *freelist)
+			 unsigned long last_pfn, struct list_head *freelist,
+			 struct iommu_dirty_bitmap *dirty)
 {
 	BUG_ON(!domain_pfn_supported(domain, start_pfn));
 	BUG_ON(!domain_pfn_supported(domain, last_pfn));
@@ -1370,7 +1376,8 @@ static void domain_unmap(struct dmar_domain *domain, unsigned long start_pfn,
 
 	/* we don't need lock here; nobody else touches the iova range */
 	dma_pte_clear_level(domain, agaw_to_level(domain->agaw),
-			    domain->pgd, 0, start_pfn, last_pfn, freelist);
+			    domain->pgd, 0, start_pfn, last_pfn, freelist,
+			    dirty);
 
 	/* free pgd */
 	if (start_pfn == 0 && last_pfn == DOMAIN_MAX_PFN(domain->gaw)) {
@@ -2031,7 +2038,8 @@ static void domain_exit(struct dmar_domain *domain)
 	if (domain->pgd) {
 		LIST_HEAD(freelist);
 
-		domain_unmap(domain, 0, DOMAIN_MAX_PFN(domain->gaw), &freelist);
+		domain_unmap(domain, 0, DOMAIN_MAX_PFN(domain->gaw), &freelist,
+			     NULL);
 		put_pages_list(&freelist);
 	}
 
@@ -4125,7 +4133,8 @@ static int intel_iommu_memory_notifier(struct notifier_block *nb,
 			struct intel_iommu *iommu;
 			LIST_HEAD(freelist);
 
-			domain_unmap(si_domain, start_vpfn, last_vpfn, &freelist);
+			domain_unmap(si_domain, start_vpfn, last_vpfn,
+				     &freelist, NULL);
 
 			rcu_read_lock();
 			for_each_active_iommu(iommu, drhd)
@@ -4737,7 +4746,8 @@ static int intel_iommu_map_pages(struct iommu_domain *domain,
 
 static size_t intel_iommu_unmap(struct iommu_domain *domain,
 				unsigned long iova, size_t size,
-				struct iommu_iotlb_gather *gather)
+				struct iommu_iotlb_gather *gather,
+				struct iommu_dirty_bitmap *dirty)
 {
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
 	unsigned long start_pfn, last_pfn;
@@ -4753,7 +4763,7 @@ static size_t intel_iommu_unmap(struct iommu_domain *domain,
 	start_pfn = iova >> VTD_PAGE_SHIFT;
 	last_pfn = (iova + size - 1) >> VTD_PAGE_SHIFT;
 
-	domain_unmap(dmar_domain, start_pfn, last_pfn, &gather->freelist);
+	domain_unmap(dmar_domain, start_pfn, last_pfn, &gather->freelist, dirty);
 
 	if (dmar_domain->max_addr == iova + size)
 		dmar_domain->max_addr = iova;
@@ -4771,7 +4781,19 @@ static size_t intel_iommu_unmap_pages(struct iommu_domain *domain,
 	unsigned long pgshift = __ffs(pgsize);
 	size_t size = pgcount << pgshift;
 
-	return intel_iommu_unmap(domain, iova, size, gather);
+	return intel_iommu_unmap(domain, iova, size, gather, NULL);
+}
+
+static size_t intel_iommu_unmap_read_dirty(struct iommu_domain *domain,
+					   unsigned long iova,
+					   size_t pgsize, size_t pgcount,
+					   struct iommu_iotlb_gather *gather,
+					   struct iommu_dirty_bitmap *dirty)
+{
+	unsigned long pgshift = __ffs(pgsize);
+	size_t size = pgcount << pgshift;
+
+	return intel_iommu_unmap(domain, iova, size, gather, dirty);
 }
 
 static void intel_iommu_tlb_sync(struct iommu_domain *domain,
@@ -5228,6 +5250,7 @@ const struct iommu_ops intel_iommu_ops = {
 		.free			= intel_iommu_domain_free,
 		.set_dirty_tracking	= intel_iommu_set_dirty_tracking,
 		.read_and_clear_dirty   = intel_iommu_read_and_clear_dirty,
+		.unmap_pages_read_dirty = intel_iommu_unmap_read_dirty,
 	}
 };
 
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 1328d1805197..c7f0801ccba6 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -664,6 +664,22 @@ static inline void dma_clear_pte(struct dma_pte *pte)
 	pte->val = 0;
 }
 
+static inline bool dma_clear_pte_dirty(struct dma_pte *pte)
+{
+	bool dirty = false;
+	u64 val;
+
+	val = READ_ONCE(pte->val);
+
+	do {
+		val = cmpxchg64(&pte->val, val, 0);
+		if ((val & VTD_PAGE_MASK) & DMA_SL_PTE_DIRTY)
+			dirty = true;
+	} while (val);
+
+	return dirty;
+}
+
 static inline u64 dma_pte_addr(struct dma_pte *pte)
 {
 #ifdef CONFIG_64BIT
-- 
2.17.2

