Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 357A7513D1E
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 23:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352080AbiD1VOf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 17:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352060AbiD1VOb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 17:14:31 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0DF7307E
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 14:11:15 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SIUM5P025802;
        Thu, 28 Apr 2022 21:10:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=b6AQWyN5uACA/brOZsKVmQnMszBYfdIkztLt0kkSo3c=;
 b=jPX+GszJFc2uqP9RDqTIgVHjHZnGmsRupaP3feTIYGHp0nP9RmtREC6gXua28/qpu1AY
 1+2x3QkDGDVqGCjDrIBuZGkFWnO87KKDvjZjPVN0LzGkR+Qi3Di1ZFYoxEdU/umrL1uv
 aLnQz01QTSgiNOVzeZJtCUwubd7/fZkRIveqYCOBQfWK1WDGu0lGEZiPFDYDL9PQiuj8
 92wUFeVFWK/tKEJxZNa2Srqf6YpT+J3+iJZogkLppaJkpNU03tyDGR3/Dq1UXawGcKEp
 kcblURxf7kjv7qHAAdC+3ywJ/QFWEzQmMolMj+tx4vhl+hAnrxBbk8atioD1Rdkyu0ap pg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb1mwbg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:10:51 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23SL6c0H028673;
        Thu, 28 Apr 2022 21:10:49 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5ype8vh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:10:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AcFpRfjhvKvLLTLixpNeJb5z7s3EZy7dJhP3Y2luZsfRG3wTr3wa5F+G57fGh490Mmbk5cVPeICHTMYXmZ7GHBJcSx3Hl4RqYgU6QUJfqH8IGqy9KEjvKcHSokE4gFlnhQuUz7OgiGwZbut+XMMYt73dCysFtQ3knWc40+P2EnNhrFHWixpNdRPNDJhG/WG8/K+0gLXYZsJe8jOGRgu9/rbCzfjiCDEnKdmJhfbIJohtKnkdt8VTeTgcH+TV7+1MtQbmxuvkACJRjvtTSDb82R2ZaakRwicBpqtMN7klhx+UW21DNXOJ8h/7wPWHRijQ7qzQlicXvD3zo0H0aJ2aWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b6AQWyN5uACA/brOZsKVmQnMszBYfdIkztLt0kkSo3c=;
 b=LUk5Rbj1KTRoddCXw6Xz/j2Of689ijj73LyUijP2XqOkyZSKXI1ejBPULdOGEpWQTakTBaGNUo6Uf2kGlWxrX8jwTy52GJIADy0u+oN0NMCx4YRKujH1mQyqJ/2xNkOPUJK1ftkbT9hGuqZ9VSoUKWDTVS6xJINty6U1jkGh80mYla56aR5xAJuFX+qP/ZJ6yJm5XCW3pqdThTm2HLNKKULSNXEoYVArt64AGAmDpPXWFmXRqQWSD2HZE0M03QVFY8WDFdUZqRgaIiffEpoly4fNrtUENdEs8grZ3RlZnYjTZU1LJCKSvroxVYJCuQ7hGNpVMuypSEZyBI+RLFxRzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b6AQWyN5uACA/brOZsKVmQnMszBYfdIkztLt0kkSo3c=;
 b=E5yAUP/Y5u1/onN149ZjoBt5C+N/k8JX21+NWKJYdhQXtBMyU5Tu9aD3jAkkOkLpgAVGkS0XdZ2Sd/S4iVbipc7YBbO4Nye4gDkA95Xgo8iXf0lBH86PqMo4WXZ54oJe3aDvkGIhY+SeDFdo1oUxOFl4qJUGgef6bbDoWTuX+Sc=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM5PR10MB1564.namprd10.prod.outlook.com (2603:10b6:3:9::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.15; Thu, 28 Apr 2022 21:10:47 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 21:10:46 +0000
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
Subject: [PATCH RFC 05/19] iommufd: Add a dirty bitmap to iopt_unmap_iova()
Date:   Thu, 28 Apr 2022 22:09:19 +0100
Message-Id: <20220428210933.3583-6-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220428210933.3583-1-joao.m.martins@oracle.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0111.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::27) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3cdd5c8-eaa5-423d-26e3-08da295b9059
X-MS-TrafficTypeDiagnostic: DM5PR10MB1564:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB1564D8568F8A31654A5D27B5BBFD9@DM5PR10MB1564.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I2Ea+0uYqieIz6KmeGDp9W7O+ybMHYoCPDHhSh5DE/GIzKG1pKlu958W/pjV68aqv+Gr1iPY9/BKjq6uPDOTt03ObW2vYmks5GR1lfCeqVyFd66brM9pSUX5wPjjeKfA8Lm1K5eQcCDXpzzItXb94/CjqFKxcJyKNmpZ/vEzi2t26Pmwm6mWZ1fP+gwyXGFLPT8FcvywWeia1M5HfBrlfzqNobpbQQa/xF6QvU0xSgBjPHo/yw3ooM7Z1dK9M+VToC/gjB2fhG08wGQfbZLfz6a1b1ad/gbms0DNv2J3fOvJ8lF/uSve2US+7Lz4qD661x03t4oz5HDAxrwTWRrNYNIe5CyehC4hsCMImoTbiPTLkOh4PUmoQ7335QO6Mnb1r+j2fl42PjuwWGs+sR8m9nYjYbYxe9nbPb+esBY+6Dd01+zSuGeNahIeUxNIhK4TzXaeGtVRhQjPhqlJ5w4FEFz5+5yBchhWtGAIlEZb29MM+hWdUjlmiLubzyBY8B91dxG1P7RuPfyU1853nBSvDfZkMrEAYFr+VlO6pFETPBHO1SYhFVCbHozkyCBsARe4aakvROU0lpAKeg9HUGK3tsgWvnP70semrS4lbm61rbFoXPKJcjE05rGpQRHsGaTRMdhbUkXc6qht+xRjYBP2go3aiVHTHRwGWw1xJki/mt+sFicdqrg9ePrjKs7eskxcn5RbtH+uVXtkBereF8Q6c9UYFnRb3VewJSqtSUcrWyI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(186003)(86362001)(66946007)(66556008)(4326008)(66476007)(8676002)(2616005)(36756003)(1076003)(103116003)(8936002)(5660300002)(7416002)(30864003)(26005)(6512007)(6486002)(6916009)(83380400001)(54906003)(508600001)(6506007)(38350700002)(38100700002)(6666004)(2906002)(52116002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Op348Zos+ycYg+/mbGfpWKyjt4Ou5byYsRJGsOMKUkUTdbq+SayQMWnVNXCW?=
 =?us-ascii?Q?nfLZASotjrSCvpGlhrziiFLgxjop8VVZb0vG08FgR/+Ba7pUBrDggJtZ2P/g?=
 =?us-ascii?Q?5ITfeauLZItbyG8u+ivUmWghSDGHFbW9r2OFKjPJR5aK1GiRqOER3bXbrVai?=
 =?us-ascii?Q?H2Cl8YBwWC4do4Zt2nZ7WdJT9fljZFS6bqcwr+S4Z4LgrQJjnjtezIIhLk39?=
 =?us-ascii?Q?iZkIjDY3DOY4XM+Hqb+Nzr12AsBq/OLqwLfEimyxU76U5JdYawswbLfynYPH?=
 =?us-ascii?Q?IDBxtRu8IWKwm1UkCYiAiJsjxDW5MqPWXzUWWZ2HjoYsXrlGqAsD5ToxHreC?=
 =?us-ascii?Q?s/Bep9XXO+FnPiVzH6CIHfmo+IPrMzz+cKniJveAvn6dtZjt0q3dxKrtrSd0?=
 =?us-ascii?Q?vyepZ+Rkf44jWIo34D13seDlomqCpNw1s26NIaiCbYhoe9XZZpcdg5tJ5u3O?=
 =?us-ascii?Q?PWhiJFdkmALA9rLBa1fYH4sFlkUPJyUTxlqE96CLh9JyzgPgPmA6SwhVoBkN?=
 =?us-ascii?Q?A8ZC7AW733Dsn/gZ5sDOeWBY8EfYE+9SZSXISy9trbjqwu8JlTgaJ3KapasE?=
 =?us-ascii?Q?hPAQx01rfOgSEYYvXwMhK0gQ3eYLvN4upcpFp4T3RgxbCIIX7OxXS2FzeW4G?=
 =?us-ascii?Q?IcNnNTdtq0+q3H9gD6tdz0KfuxApPFc/of3WJpcWUkbEQzf8jyRIedRfQJYU?=
 =?us-ascii?Q?7InRHFlO9axAFANMwMgR0dFBXNoQvhF99wXE/+IB63G9dR4BMB6xHqfUu11V?=
 =?us-ascii?Q?nmuSkKPTeILhg3JJjFmUiaF910Zc9moJJskHf0Tn0rBXtsW72mk7sb0ko+8W?=
 =?us-ascii?Q?ykfZPXUZRxkp+OcseUg8KAGiqywuZWlZG5OUIneYT8tl2Qy2Dyz/zLBklzWl?=
 =?us-ascii?Q?J2YBtRyijMqas7uDqIhfOBeLODJCquaVOw7dfhYr4M6feDXiAOHf6uTJwF6/?=
 =?us-ascii?Q?6scnCT76ZN02/KblTpoXc4CjaCcGsGTfFwRnZSFj0vpQK0cdFXxuv2Ap+qKt?=
 =?us-ascii?Q?EeOoMXuxCiPyVvomNsc8Mai6VVM7Pb2CN76PmkMDvcAlttO6pB7FVuaMO+yf?=
 =?us-ascii?Q?9IJ4ga19p4Jwjk8HUdTi5i/C0ZVT8AmM+bna7v8+lCBJDmRmvGbQVFGTrJYV?=
 =?us-ascii?Q?BnFD9BwfZtYbXF6/Q1c6uQyryVtWreDS2/yLajIxc4ltyHeSm0oClbpY7qs3?=
 =?us-ascii?Q?bR0iucvhzRFW77cux9gRyEkL3pY7IpG5XoK7Y/EiBVuLS9aQT4S9oWXQ+C14?=
 =?us-ascii?Q?zFQm661K8MKfZLUsdOuECNWJDH5J3epVlBshO/NFV2pBN8DInYgPcselrmUR?=
 =?us-ascii?Q?OFar2kTMh84qWMeruXJ263NCJkVOxXfCEsu+XybWzQBxbWOHstZlIXoHGTzL?=
 =?us-ascii?Q?Ft6Ou0/HW3WsRqxz8EYrVBOBw9LnzV5GxjFlRyZAFeJucG6LqNIWDfQvhxtl?=
 =?us-ascii?Q?fxkzclwSgfiMIsYF8siq7unJE90hMEBkb6njyZaFLRDwW05bgG9xHpbIEvte?=
 =?us-ascii?Q?XYEtTOXTzcsXmuV7PUgbYI8hsMBcJu9h5uSLlXTC8hgJXp8c2CjcG60NUFE4?=
 =?us-ascii?Q?bkGCwzxyI7edNzIwasgrksDONUW1jY2liTOAu6kc7yTBNbLv7fwBCzzS2bS0?=
 =?us-ascii?Q?bGiWjCKRT0BkMdSiuF+WouPI/vh7uFtUg+aU09YQZRQ2Gx0WFn2eZfwssugy?=
 =?us-ascii?Q?g0hRNCyGHSFdEnjiCGslQtBWoFogoUeaCnCaNn2bR25v+tL5g+8bk22xFKpL?=
 =?us-ascii?Q?Xrf48JAGZB3rMJvImNkyCMgD2mOwmhc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3cdd5c8-eaa5-423d-26e3-08da295b9059
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 21:10:46.9542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qKCxS0pwfdmn3QlmGWg6Xj9L5UeL3ddDBNCA+aIRpOZvossJOkKGuIwqpTVoSp8wgo9YuBKZ+1VcirpPzg7rspn+U5v9kSfHRD6HxiRKVq8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_04:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=827 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204280125
X-Proofpoint-GUID: kyH6UwAwODfGvJG8o8ogQZSJu7MdJO8r
X-Proofpoint-ORIG-GUID: kyH6UwAwODfGvJG8o8ogQZSJu7MdJO8r
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an argument to the kAPI that unmaps an IOVA from the attached
domains, to also receive a bitmap.

When passed an iommufd_dirty_data::bitmap we call out the special
dirty unmap (iommu_unmap_read_dirty()). The bitmap data is
iterated, similarly, like the read_and_clear_dirty() in IOVA
chunks using the previously added iommufd_dirty_iter* helper
functions.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/iommufd/io_pagetable.c    | 13 ++--
 drivers/iommu/iommufd/io_pagetable.h    |  3 +-
 drivers/iommu/iommufd/ioas.c            |  2 +-
 drivers/iommu/iommufd/iommufd_private.h |  4 +-
 drivers/iommu/iommufd/pages.c           | 79 +++++++++++++++++++++----
 drivers/iommu/iommufd/vfio_compat.c     |  2 +-
 6 files changed, 80 insertions(+), 23 deletions(-)

diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index 835b5040fce9..6f4117c629d4 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -542,13 +542,14 @@ struct iopt_pages *iopt_get_pages(struct io_pagetable *iopt, unsigned long iova,
 }
 
 static int __iopt_unmap_iova(struct io_pagetable *iopt, struct iopt_area *area,
-			     struct iopt_pages *pages)
+			     struct iopt_pages *pages,
+			     struct iommufd_dirty_data *bitmap)
 {
 	/* Drivers have to unpin on notification. */
 	if (WARN_ON(atomic_read(&area->num_users)))
 		return -EBUSY;
 
-	iopt_area_unfill_domains(area, pages);
+	iopt_area_unfill_domains(area, pages, bitmap);
 	WARN_ON(atomic_read(&area->num_users));
 	iopt_abort_area(area);
 	iopt_put_pages(pages);
@@ -560,12 +561,13 @@ static int __iopt_unmap_iova(struct io_pagetable *iopt, struct iopt_area *area,
  * @iopt: io_pagetable to act on
  * @iova: Starting iova to unmap
  * @length: Number of bytes to unmap
+ * @bitmap: Bitmap of dirtied IOVAs
  *
  * The requested range must exactly match an existing range.
  * Splitting/truncating IOVA mappings is not allowed.
  */
 int iopt_unmap_iova(struct io_pagetable *iopt, unsigned long iova,
-		    unsigned long length)
+		    unsigned long length, struct iommufd_dirty_data *bitmap)
 {
 	struct iopt_pages *pages;
 	struct iopt_area *area;
@@ -590,7 +592,8 @@ int iopt_unmap_iova(struct io_pagetable *iopt, unsigned long iova,
 	area->pages = NULL;
 	up_write(&iopt->iova_rwsem);
 
-	rc = __iopt_unmap_iova(iopt, area, pages);
+	rc = __iopt_unmap_iova(iopt, area, pages, bitmap);
+
 	up_read(&iopt->domains_rwsem);
 	return rc;
 }
@@ -614,7 +617,7 @@ int iopt_unmap_all(struct io_pagetable *iopt)
 		area->pages = NULL;
 		up_write(&iopt->iova_rwsem);
 
-		rc = __iopt_unmap_iova(iopt, area, pages);
+		rc = __iopt_unmap_iova(iopt, area, pages, NULL);
 		if (rc)
 			goto out_unlock_domains;
 
diff --git a/drivers/iommu/iommufd/io_pagetable.h b/drivers/iommu/iommufd/io_pagetable.h
index c8b6a60ff24c..c8baab25ab08 100644
--- a/drivers/iommu/iommufd/io_pagetable.h
+++ b/drivers/iommu/iommufd/io_pagetable.h
@@ -48,7 +48,8 @@ struct iopt_area {
 };
 
 int iopt_area_fill_domains(struct iopt_area *area, struct iopt_pages *pages);
-void iopt_area_unfill_domains(struct iopt_area *area, struct iopt_pages *pages);
+void iopt_area_unfill_domains(struct iopt_area *area, struct iopt_pages *pages,
+			      struct iommufd_dirty_data *bitmap);
 
 int iopt_area_fill_domain(struct iopt_area *area, struct iommu_domain *domain);
 void iopt_area_unfill_domain(struct iopt_area *area, struct iopt_pages *pages,
diff --git a/drivers/iommu/iommufd/ioas.c b/drivers/iommu/iommufd/ioas.c
index 48149988c84b..19d6591aa005 100644
--- a/drivers/iommu/iommufd/ioas.c
+++ b/drivers/iommu/iommufd/ioas.c
@@ -243,7 +243,7 @@ int iommufd_ioas_unmap(struct iommufd_ucmd *ucmd)
 			rc = -EOVERFLOW;
 			goto out_put;
 		}
-		rc = iopt_unmap_iova(&ioas->iopt, cmd->iova, cmd->length);
+		rc = iopt_unmap_iova(&ioas->iopt, cmd->iova, cmd->length, NULL);
 	}
 
 out_put:
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 4c12b4a8f1a6..3e3a97f623a1 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -47,8 +47,6 @@ int iopt_map_user_pages(struct io_pagetable *iopt, unsigned long *iova,
 int iopt_map_pages(struct io_pagetable *iopt, struct iopt_pages *pages,
 		   unsigned long *dst_iova, unsigned long start_byte,
 		   unsigned long length, int iommu_prot, unsigned int flags);
-int iopt_unmap_iova(struct io_pagetable *iopt, unsigned long iova,
-		    unsigned long length);
 int iopt_unmap_all(struct io_pagetable *iopt);
 
 struct iommufd_dirty_data {
@@ -63,6 +61,8 @@ int iopt_set_dirty_tracking(struct io_pagetable *iopt,
 int iopt_read_and_clear_dirty_data(struct io_pagetable *iopt,
 				   struct iommu_domain *domain,
 				   struct iommufd_dirty_data *bitmap);
+int iopt_unmap_iova(struct io_pagetable *iopt, unsigned long iova,
+		    unsigned long length, struct iommufd_dirty_data *bitmap);
 
 struct iommufd_dirty_iter {
 	struct iommu_dirty_bitmap dirty;
diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index 3fd39e0201f5..722c77cbbe3a 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -144,16 +144,64 @@ static void iommu_unmap_nofail(struct iommu_domain *domain, unsigned long iova,
 	WARN_ON(ret != size);
 }
 
+static void iommu_unmap_read_dirty_nofail(struct iommu_domain *domain,
+					  unsigned long iova, size_t size,
+					  struct iommufd_dirty_data *bitmap,
+					  struct iommufd_dirty_iter *iter)
+{
+	size_t ret = 0;
+
+	ret = iommufd_dirty_iter_init(iter, bitmap);
+	WARN_ON(ret);
+
+	for (; iommufd_dirty_iter_done(iter);
+	     iommufd_dirty_iter_advance(iter)) {
+		ret = iommufd_dirty_iter_get(iter);
+		if (ret < 0)
+			break;
+
+		ret = iommu_unmap_read_dirty(domain,
+			iommufd_dirty_iova(iter),
+			iommufd_dirty_iova_length(iter), &iter->dirty);
+
+		iommufd_dirty_iter_put(iter);
+
+		/*
+		 * It is a logic error in this code or a driver bug
+		 * if the IOMMU unmaps something other than exactly
+		 * as requested.
+		 */
+		if (ret != size) {
+			WARN_ONCE(1, "unmapped %ld instead of %ld", ret, size);
+			break;
+		}
+	}
+
+	iommufd_dirty_iter_free(iter);
+}
+
 static void iopt_area_unmap_domain_range(struct iopt_area *area,
 					 struct iommu_domain *domain,
 					 unsigned long start_index,
-					 unsigned long last_index)
+					 unsigned long last_index,
+					 struct iommufd_dirty_data *bitmap)
 {
 	unsigned long start_iova = iopt_area_index_to_iova(area, start_index);
 
-	iommu_unmap_nofail(domain, start_iova,
-			   iopt_area_index_to_iova_last(area, last_index) -
-				   start_iova + 1);
+	if (bitmap) {
+		struct iommufd_dirty_iter iter;
+
+		iommu_dirty_bitmap_init(&iter.dirty, bitmap->iova,
+					__ffs(bitmap->page_size), NULL);
+
+		iommu_unmap_read_dirty_nofail(domain, start_iova,
+			iopt_area_index_to_iova_last(area, last_index) -
+					   start_iova + 1, bitmap, &iter);
+	} else {
+		iommu_unmap_nofail(domain, start_iova,
+				   iopt_area_index_to_iova_last(area, last_index) -
+					   start_iova + 1);
+	}
 }
 
 static struct iopt_area *iopt_pages_find_domain_area(struct iopt_pages *pages,
@@ -808,7 +856,8 @@ static bool interval_tree_fully_covers_area(struct rb_root_cached *root,
 static void __iopt_area_unfill_domain(struct iopt_area *area,
 				      struct iopt_pages *pages,
 				      struct iommu_domain *domain,
-				      unsigned long last_index)
+				      unsigned long last_index,
+				      struct iommufd_dirty_data *bitmap)
 {
 	unsigned long unmapped_index = iopt_area_index(area);
 	unsigned long cur_index = unmapped_index;
@@ -821,7 +870,8 @@ static void __iopt_area_unfill_domain(struct iopt_area *area,
 	if (interval_tree_fully_covers_area(&pages->domains_itree, area) ||
 	    interval_tree_fully_covers_area(&pages->users_itree, area)) {
 		iopt_area_unmap_domain_range(area, domain,
-					     iopt_area_index(area), last_index);
+					     iopt_area_index(area),
+					     last_index, bitmap);
 		return;
 	}
 
@@ -837,7 +887,7 @@ static void __iopt_area_unfill_domain(struct iopt_area *area,
 		batch_from_domain(&batch, domain, area, cur_index, last_index);
 		cur_index += batch.total_pfns;
 		iopt_area_unmap_domain_range(area, domain, unmapped_index,
-					     cur_index - 1);
+					     cur_index - 1, bitmap);
 		unmapped_index = cur_index;
 		iopt_pages_unpin(pages, &batch, batch_index, cur_index - 1);
 		batch_clear(&batch);
@@ -852,7 +902,8 @@ static void iopt_area_unfill_partial_domain(struct iopt_area *area,
 					    unsigned long end_index)
 {
 	if (end_index != iopt_area_index(area))
-		__iopt_area_unfill_domain(area, pages, domain, end_index - 1);
+		__iopt_area_unfill_domain(area, pages, domain,
+					  end_index - 1, NULL);
 }
 
 /**
@@ -891,7 +942,7 @@ void iopt_area_unfill_domain(struct iopt_area *area, struct iopt_pages *pages,
 			     struct iommu_domain *domain)
 {
 	__iopt_area_unfill_domain(area, pages, domain,
-				  iopt_area_last_index(area));
+				  iopt_area_last_index(area), NULL);
 }
 
 /**
@@ -1004,7 +1055,7 @@ int iopt_area_fill_domains(struct iopt_area *area, struct iopt_pages *pages)
 			if (end_index != iopt_area_index(area))
 				iopt_area_unmap_domain_range(
 					area, domain, iopt_area_index(area),
-					end_index - 1);
+					end_index - 1, NULL);
 		} else {
 			iopt_area_unfill_partial_domain(area, pages, domain,
 							end_index);
@@ -1025,7 +1076,8 @@ int iopt_area_fill_domains(struct iopt_area *area, struct iopt_pages *pages)
  * Called during area destruction. This unmaps the iova's covered by all the
  * area's domains and releases the PFNs.
  */
-void iopt_area_unfill_domains(struct iopt_area *area, struct iopt_pages *pages)
+void iopt_area_unfill_domains(struct iopt_area *area, struct iopt_pages *pages,
+			      struct iommufd_dirty_data *bitmap)
 {
 	struct io_pagetable *iopt = area->iopt;
 	struct iommu_domain *domain;
@@ -1041,10 +1093,11 @@ void iopt_area_unfill_domains(struct iopt_area *area, struct iopt_pages *pages)
 		if (domain != area->storage_domain)
 			iopt_area_unmap_domain_range(
 				area, domain, iopt_area_index(area),
-				iopt_area_last_index(area));
+				iopt_area_last_index(area), bitmap);
 
 	interval_tree_remove(&area->pages_node, &pages->domains_itree);
-	iopt_area_unfill_domain(area, pages, area->storage_domain);
+	__iopt_area_unfill_domain(area, pages, area->storage_domain,
+				  iopt_area_last_index(area), bitmap);
 	area->storage_domain = NULL;
 out_unlock:
 	mutex_unlock(&pages->mutex);
diff --git a/drivers/iommu/iommufd/vfio_compat.c b/drivers/iommu/iommufd/vfio_compat.c
index 5b196de00ff9..dbe39404a105 100644
--- a/drivers/iommu/iommufd/vfio_compat.c
+++ b/drivers/iommu/iommufd/vfio_compat.c
@@ -148,7 +148,7 @@ static int iommufd_vfio_unmap_dma(struct iommufd_ctx *ictx, unsigned int cmd,
 	if (unmap.flags & VFIO_DMA_UNMAP_FLAG_ALL)
 		rc = iopt_unmap_all(&ioas->iopt);
 	else
-		rc = iopt_unmap_iova(&ioas->iopt, unmap.iova, unmap.size);
+		rc = iopt_unmap_iova(&ioas->iopt, unmap.iova, unmap.size, NULL);
 	iommufd_put_object(&ioas->obj);
 	return rc;
 }
-- 
2.17.2

