Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6F92513D20
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 23:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352083AbiD1VOj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 17:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352071AbiD1VOd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 17:14:33 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE813728F5
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 14:11:16 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SJX01T015475;
        Thu, 28 Apr 2022 21:10:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=5lNwwdX4GajidCZHNuRT2UnSSdskz8qp0GtSZRhRAXE=;
 b=v1uWdCA6chbvFILfvSxhWWlRRYJp68AeQTdG722hFybt+w0xiR9jiz3PK3S/TWI8OT3G
 hA+lhWocDOiX7XgFmRdZm0sfRqIZ+Em9f0uzsbOh7G17bHs3bAYjQIjWaquSvhqR4Gwx
 ssyzVfucDsn/Xr4zzYFRttY/9+PzQ/3qHXH8vrWUlWDbg1Q+b6WocGj7/80jN3UvTsft
 4znBqgrqiTdCKlPzfpTYWpWrd68FCcC4wes65rGkZLESpMuTVI+ubASkJKCY4swpVl7Y
 opF6X48yPNMcsl5eSJHMTSgPdiKw679iZEC4idHmxt6OBl1k41Gr6Oep6azN+w6xqFWg wg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb9aw5vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:10:47 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23SL5Ca8028531;
        Thu, 28 Apr 2022 21:10:45 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w79nt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:10:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iozS2UmLe+AAmGcTVWA/hXXe2lPbX4Js5ZmFuzTHf5SiweCFflma+Tf/bg/Aqa8McNiGYu1PShuQx19ZPjfLV9MEL2nkOyg9SotGUWN9tJ+r803jclBIsCNu7WLJsxOBtDCX/Lg1e6khzMa3WsiINIoidBy2Za84MXm6ngkir24woa2zgSwvnIABrYAUEpKKM+zjijN3JmziHHmv8VKVdlrBsV8WPQCGU2jEVwkvAOtwL5tqsYt6SkhC/xFQSc5f2aQkEAMDFb/Hrz5Pbpi19Ifn4k+m3PNHUrmQzhJVP/gdmyqw0l/2AtOGOVxT30OLHp43kCLA3zeLrVFRRxbUTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5lNwwdX4GajidCZHNuRT2UnSSdskz8qp0GtSZRhRAXE=;
 b=IET5dpZyooBCnNJHfT8UsyhVdf4JVRvnagNspL8QrZUFthT/UZRKCcycr/ZXE3vrWXt/8bzHhhiMmQRF0PkvWv0/3GWQYG9tilF48iRcEH3Rb9YTAiwKrt2ZblzGt2VfR7hqLuykC9JwzCYqrmgva99V+JlEKguGtUohwkgav3Ll8zxGaveSmTq3fHJuJW/Lmn354WbQxA/8o7dW1DWAK2XXWCk98LA3N7O4w/GoEDRaJjtg/Pk5wWjXxVwTJFQ+mJohMmz0pOgYn7/AMLFTus9BZgyf8ntaE3ECVwg2kkAm+0iGUG92NHgZNQCkqS4n5p22mo+tnTeJUjGJeyjm3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5lNwwdX4GajidCZHNuRT2UnSSdskz8qp0GtSZRhRAXE=;
 b=qe6qPMIUAZAu02c2eF310DgReFpy7NrPYR4UcPabmuVATjKg2Re5z+l1emD8Q8Poc0raB3KSgf8t8DGx3i365Kt33DKox5ISKWmKaYeBvwaikvL2ok3JX+/MYsQ1CMYdjv50T8+nRSng1DKCNZmKywi8IWlGQq+AnuT3FO1dbME=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MWHPR10MB1630.namprd10.prod.outlook.com (2603:10b6:301:a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 28 Apr
 2022 21:10:43 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 21:10:43 +0000
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
Subject: [PATCH RFC 04/19] iommu: Add an unmap API that returns dirtied IOPTEs
Date:   Thu, 28 Apr 2022 22:09:18 +0100
Message-Id: <20220428210933.3583-5-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220428210933.3583-1-joao.m.martins@oracle.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0111.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::27) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 422f200f-ef4f-4419-e4b7-08da295b8e2f
X-MS-TrafficTypeDiagnostic: MWHPR10MB1630:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB163041EC802A3B33E8A8314FBBFD9@MWHPR10MB1630.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q4tz2p4JDmMmypi3X8lI/4DiRlbG6wvBSGM71rzo6FhlUG2ncUPavvMhKuvG4kqMR2BEeCTRYRKsTp/sexB3Q0cj4sPIWiHXMuz3bSZ+xhkJPXTDPxANoe1JCDqqyYOxFkG4v1ZS0HdVis9tR2KGAE6Itp1OBTqI0p1JEEsC0fO8BBNBry7n3AwVw1/OS7s5diC8ZmUEq7ehHUcsZlO7zBJZU4OJ0CVCR4vaYQip593KHzEG12JFgc0fQOFi6T5ih468r4oP84QXgUhr2JV0Ek00EiSFQ+A7rgKIYG/KskW1Man+wzxWrdGhNffjPV//oMD7I6Mx/ZdxajbCpQxpZRAr3XytThtynCRETq4QXgNnJHWncGOUXDzzreBLvGH2awO7Lyf5KGfdVtoPOBQylvKXiNUhx563DP6eaAFnyeIDhoHFElC3AZHP1vmu8GTK2PqakcykAmQq6BkZzaQlCcBe7rVj6RrWa6lv+BcwGeDYjty3CAF0xuAbj9iEoHieHpvOLphc0nFYSjHJEAB0UCpGqqXMtGBR7Z1sZz4Q2Vkcrso5xEQRXNwtLBsCtRWKm1gR8M34lc2Kzk4Jlz5Um1SnmqsM6bibf6GN/5twJLrCnWlRd1bqv73g/KYf3MiJbVwQS70hqaUmaNRwrdU43HZZQ42s0HDOaMiRybyFCqrL1c3IV3N1f5yMU+R6wqPQSL0cN7mtbvC2qC28DPbpJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(6486002)(6512007)(2906002)(66946007)(66476007)(66556008)(38100700002)(4326008)(38350700002)(7416002)(103116003)(8936002)(6666004)(6506007)(5660300002)(26005)(52116002)(508600001)(2616005)(6916009)(54906003)(1076003)(36756003)(83380400001)(316002)(186003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8Ywsf9zDGm7gPNl9ZCuOtYfmDERK2ef/8slN53FBLBLnlAzBESlh0YBTTDhb?=
 =?us-ascii?Q?yRjpg7gf7FD3h38dTY9llbaW28XOw9DenWSxx/gx8RX9I4rfQfmTbSvEG9ll?=
 =?us-ascii?Q?Rl2/UsjnIAfHPaMmpcdRMZHbaC+RMhUii7JsEoC2nWWA7gLk/gNOwYXRRG1C?=
 =?us-ascii?Q?dCAJ1vXiynB5H/lKOQowqISTpKJ7cNnLXtASE5/x50z2xtSeRpns9wpEubc9?=
 =?us-ascii?Q?F5/09OBnoCESZ1t8sTKjuSHAdbkM2GE4nHFLTil+xpjZcf2B75o/aRUmGvnT?=
 =?us-ascii?Q?kzXjJ/OMGxTtatFBfozu0fowbUckuDY9AugvCU8J1fIyh7taPl8Zc7O5o4f/?=
 =?us-ascii?Q?z5msgrIZs0TNl2C+sUzukOk6Ig6+OsOUNSXIW6mf52NZHRdaCjFSw7d+cjfh?=
 =?us-ascii?Q?CGL462ZMDEOTpudX+w/ome0u7SjZlfLJJVABerQ7uEST2N+q6VV+GFeco9bg?=
 =?us-ascii?Q?n1fxPCRQAKouHrgsO3Iap0GcfbBy8vmjtnAWUwjzpm9fILne+WQUdqGqQBED?=
 =?us-ascii?Q?JH/CEjBd/R1QKX1CayVjyaSfZ+6vG5ToZE7ZaqGdWBiQfxxmzCc9ySzPvFjB?=
 =?us-ascii?Q?NgTduyJm+uVUWH4VA4GsrYRyOigkf2C/PkUJ5vh9ulgJIdeb8FSYeXnp28Dn?=
 =?us-ascii?Q?mPtP0cSSZOwQcCPZkH6AkSrJ0eDP0Si7otdQ3kNgK3RpalKz8lM8BOClW+SF?=
 =?us-ascii?Q?LNl66b9Ku9dtYhHxodLZP0x5KEWvw0nJGRhGNHx4pmdGE88o3sNTNcacR911?=
 =?us-ascii?Q?GF9mY0D68VXCjyYQ332RrvHJTW+dATBTTOs7EzzUqpmlJa8nFmdxGIggMLTY?=
 =?us-ascii?Q?tvyYlRP83aZ/jHBbxmdWHnXrhkXgP3b90gtFVAKguk+GS2jH7e+of3lowbfK?=
 =?us-ascii?Q?IKvpbUA5N1BvcRpSJgX8KqKjyFm5Mj2M0FwWOhP+3ti/S1TXpFZ+p5t7OPkw?=
 =?us-ascii?Q?zdwuQyxGFBRJp+ENoWsOOnNSxT7RscMBLMMrNZSPUIwh1I5nw1N3wWh6SobM?=
 =?us-ascii?Q?JMlaHiuDXsAs4LekUDVDyUJhFpXftJiKfJV887GzBoEewq/vHm95Eik5TgO1?=
 =?us-ascii?Q?/0Z4cApOmdlW8L0Ezt+fKZikPyIFPkJ1VTRtyP8dQVT66F1/YRQJAy3AaSQq?=
 =?us-ascii?Q?zQBGuKstRn96LkYKcKJ8iEeFXCS0Pti9y6twbkfc2d3VfqoLfVzM9N752CLR?=
 =?us-ascii?Q?ltGINkFo/EWnFB9+7y1rYZ3l5OuJ4e0sPFj7BR4XNnNS6vEqUizyhzBDalVk?=
 =?us-ascii?Q?hizQdv6hoFHyCc4w3m/9oFRcnDuAjBX80NkybKvYHhb7BkVqPKDsm16/XZsp?=
 =?us-ascii?Q?gCnBvdcA6Ctm1ApjGB7l6l9exh0N11uu75+OYQJxy9eDcwV3Tn5M99d3AK9c?=
 =?us-ascii?Q?jYB03RPBkhXm3v6Th0rvN4agIjSbJe5HiH7iKCGYVYvh9gq34gcgB6nQ2aDc?=
 =?us-ascii?Q?331j0FSEYp+GAeq2/GbLoVRrlK64+PwyDPjK2xnbD2HlO+yj3Qj20aGCOvNW?=
 =?us-ascii?Q?3R21SfStyhu9lRaiACasWI7yxiXQGsVCByU9jgAesjCMMTzjJ3FrCW+QCSeo?=
 =?us-ascii?Q?9yMMUql070xfo+iSCNMJlffCREOlyE2JcsZXD/T3fe+LDF161rDzhqHVsitm?=
 =?us-ascii?Q?WCsJQYiQba/Gollxsrx/waC4amIzx82WHTPpUMbXJxU96c+CEiMjP/O3wJ5E?=
 =?us-ascii?Q?9FcetCGejX32VewuKcgsc7LeY+FSzPvgeh0k8R85dRP4tSaS4kgiFaKjXgD9?=
 =?us-ascii?Q?SMLC4hBIqkf94qh6REexnEhMn8ZAxWs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 422f200f-ef4f-4419-e4b7-08da295b8e2f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 21:10:43.2656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aHIlRSjkMqFS4aOebgibHW24+ltFkRRb6MB1sjjN3UE2pYs8B4Qhq1ljIJ+UMC8uNgxNCP9LDS3hJaEm8qQZRELKWalrU5FtFYkPAfBaLSk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1630
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_04:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=813
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204280125
X-Proofpoint-ORIG-GUID: wn74GMa1FLo1tu5_tYZy1cO7_Gr4sWrz
X-Proofpoint-GUID: wn74GMa1FLo1tu5_tYZy1cO7_Gr4sWrz
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Today, the dirty state is lost and the page wouldn't be migrated to
destination potentially leading the guest into error.

Add an unmap API that reads the dirty bit and sets it in the
user passed bitmap. This unmap iommu API tackles a potentially
racy update to the dirty bit *when* doing DMA on a iova that is
being unmapped at the same time.

The new unmap_read_dirty/unmap_pages_read_dirty does not replace
the unmap pages, but rather only when explicit called with an dirty
bitmap data passed in.

It could be said that the guest is buggy and rather than a special unmap
path tackling the theoretical race ... it would suffice fetching the
dirty bits (with GET_DIRTY_IOVA), and then unmap the IOVA.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/iommu.c      | 43 +++++++++++++++++++++++++++++++-------
 include/linux/io-pgtable.h | 10 +++++++++
 include/linux/iommu.h      | 12 +++++++++++
 3 files changed, 58 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index d18b9ddbcce4..cc04263709ee 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2289,12 +2289,25 @@ EXPORT_SYMBOL_GPL(iommu_map_atomic);
 
 static size_t __iommu_unmap_pages(struct iommu_domain *domain,
 				  unsigned long iova, size_t size,
-				  struct iommu_iotlb_gather *iotlb_gather)
+				  struct iommu_iotlb_gather *iotlb_gather,
+				  struct iommu_dirty_bitmap *dirty)
 {
 	const struct iommu_domain_ops *ops = domain->ops;
 	size_t pgsize, count;
 
 	pgsize = iommu_pgsize(domain, iova, iova, size, &count);
+
+	if (dirty) {
+		if (!ops->unmap_read_dirty && !ops->unmap_pages_read_dirty)
+			return 0;
+
+		return ops->unmap_pages_read_dirty ?
+		       ops->unmap_pages_read_dirty(domain, iova, pgsize,
+						   count, iotlb_gather, dirty) :
+		       ops->unmap_read_dirty(domain, iova, pgsize,
+					     iotlb_gather, dirty);
+	}
+
 	return ops->unmap_pages ?
 	       ops->unmap_pages(domain, iova, pgsize, count, iotlb_gather) :
 	       ops->unmap(domain, iova, pgsize, iotlb_gather);
@@ -2302,7 +2315,8 @@ static size_t __iommu_unmap_pages(struct iommu_domain *domain,
 
 static size_t __iommu_unmap(struct iommu_domain *domain,
 			    unsigned long iova, size_t size,
-			    struct iommu_iotlb_gather *iotlb_gather)
+			    struct iommu_iotlb_gather *iotlb_gather,
+			    struct iommu_dirty_bitmap *dirty)
 {
 	const struct iommu_domain_ops *ops = domain->ops;
 	size_t unmapped_page, unmapped = 0;
@@ -2337,9 +2351,8 @@ static size_t __iommu_unmap(struct iommu_domain *domain,
 	 * or we hit an area that isn't mapped.
 	 */
 	while (unmapped < size) {
-		unmapped_page = __iommu_unmap_pages(domain, iova,
-						    size - unmapped,
-						    iotlb_gather);
+		unmapped_page = __iommu_unmap_pages(domain, iova, size - unmapped,
+						    iotlb_gather, dirty);
 		if (!unmapped_page)
 			break;
 
@@ -2361,18 +2374,34 @@ size_t iommu_unmap(struct iommu_domain *domain,
 	size_t ret;
 
 	iommu_iotlb_gather_init(&iotlb_gather);
-	ret = __iommu_unmap(domain, iova, size, &iotlb_gather);
+	ret = __iommu_unmap(domain, iova, size, &iotlb_gather, NULL);
 	iommu_iotlb_sync(domain, &iotlb_gather);
 
 	return ret;
 }
 EXPORT_SYMBOL_GPL(iommu_unmap);
 
+size_t iommu_unmap_read_dirty(struct iommu_domain *domain,
+			      unsigned long iova, size_t size,
+			      struct iommu_dirty_bitmap *dirty)
+{
+	struct iommu_iotlb_gather iotlb_gather;
+	size_t ret;
+
+	iommu_iotlb_gather_init(&iotlb_gather);
+	ret = __iommu_unmap(domain, iova, size, &iotlb_gather, dirty);
+	iommu_iotlb_sync(domain, &iotlb_gather);
+
+	return ret;
+
+}
+EXPORT_SYMBOL_GPL(iommu_unmap_read_dirty);
+
 size_t iommu_unmap_fast(struct iommu_domain *domain,
 			unsigned long iova, size_t size,
 			struct iommu_iotlb_gather *iotlb_gather)
 {
-	return __iommu_unmap(domain, iova, size, iotlb_gather);
+	return __iommu_unmap(domain, iova, size, iotlb_gather, NULL);
 }
 EXPORT_SYMBOL_GPL(iommu_unmap_fast);
 
diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
index 82b39925c21f..c2ebfe037f5d 100644
--- a/include/linux/io-pgtable.h
+++ b/include/linux/io-pgtable.h
@@ -171,6 +171,16 @@ struct io_pgtable_ops {
 	int (*read_and_clear_dirty)(struct io_pgtable_ops *ops,
 				    unsigned long iova, size_t size,
 				    struct iommu_dirty_bitmap *dirty);
+	size_t (*unmap_read_dirty)(struct io_pgtable_ops *ops,
+				   unsigned long iova,
+				   size_t size,
+				   struct iommu_iotlb_gather *gather,
+				   struct iommu_dirty_bitmap *dirty);
+	size_t (*unmap_pages_read_dirty)(struct io_pgtable_ops *ops,
+					 unsigned long iova,
+					 size_t pgsize, size_t pgcount,
+					 struct iommu_iotlb_gather *gather,
+					 struct iommu_dirty_bitmap *dirty);
 };
 
 /**
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index ca076365d77b..7c66b4e00556 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -340,6 +340,15 @@ struct iommu_domain_ops {
 	int (*read_and_clear_dirty)(struct iommu_domain *domain,
 				    unsigned long iova, size_t size,
 				    struct iommu_dirty_bitmap *dirty);
+	size_t (*unmap_read_dirty)(struct iommu_domain *domain,
+				   unsigned long iova, size_t size,
+				   struct iommu_iotlb_gather *iotlb_gather,
+				   struct iommu_dirty_bitmap *dirty);
+	size_t (*unmap_pages_read_dirty)(struct iommu_domain *domain,
+					 unsigned long iova,
+					 size_t pgsize, size_t pgcount,
+					 struct iommu_iotlb_gather *iotlb_gather,
+					 struct iommu_dirty_bitmap *dirty);
 };
 
 /**
@@ -463,6 +472,9 @@ extern int iommu_map_atomic(struct iommu_domain *domain, unsigned long iova,
 			    phys_addr_t paddr, size_t size, int prot);
 extern size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova,
 			  size_t size);
+extern size_t iommu_unmap_read_dirty(struct iommu_domain *domain,
+				     unsigned long iova, size_t size,
+				     struct iommu_dirty_bitmap *dirty);
 extern size_t iommu_unmap_fast(struct iommu_domain *domain,
 			       unsigned long iova, size_t size,
 			       struct iommu_iotlb_gather *iotlb_gather);
-- 
2.17.2

