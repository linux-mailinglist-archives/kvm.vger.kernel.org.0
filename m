Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C640513D2E
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 23:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352090AbiD1VOt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 17:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352084AbiD1VOs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 17:14:48 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736B0762A7
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 14:11:29 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SJOLeP011286;
        Thu, 28 Apr 2022 21:11:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=nWNzeEqOr5U03MiU2g2XtdGYO86CNtCzbczSeHNIRHo=;
 b=PmB8e0QIARb4mUw91wVv0Q6Mvdq+6JxbSNfuaZzmb/LyIxD5L5vbIIesKNbf5qOSrF+H
 pZKaObeeN58/XBFmGrfhfuSKx4XWljfKU2PY98lnA7FdqUgjaiXNMjiy9Ub5f2xhx2ux
 cfmXoNApFD3hlvPVRXHdYclpJXcWl06G4mdWfVLReKJbw0Ge52Co8RSRU1xICGRPa+rt
 CdVYBYZHWdUUmZui3rMViZno051GnMaJWTYcdFM9sMEgVM6MXPCmojng5s2TqeAZDf0o
 aO3N9ZrJkUCzMzIY/at7L70iX/3Ek0dUxjRQrwLyDyJyBMNm/0JN+KZP5XqZoJwLHUf2 5A== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmaw4nb4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:11:03 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23SL6Cas025136;
        Thu, 28 Apr 2022 21:11:03 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w78a9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:11:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KyNM62YrFNTSs4oJ3mQY40Bg1OYK6H6FVi0IqIsfjFDqTdb596kaPm80R7Ika6RaPmWXFjqraGFhHGwXkxkYiZaB6PpJ9LTNABxQ6LFjemU+UjASq1GXlClqILoo5uViA+Sa+dUz27nfJSIqMA7gGEaONgpgJ2q07hidz64KuWmpOwHtj7+8bZxh8pL2cMoJR2PlhLqnLfMYpE1MLFfUoseYIX+2CxBvUyc3AoO5i2KiFip/73lRonYE1R9YjUnSncEuo9cKh78/PN14AMfQTivXqFXgy7dz5AvktZB/lmS5OH0+1zFkLvGx30pa51RNQZNCfDCFkRUs90RO45Ev7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nWNzeEqOr5U03MiU2g2XtdGYO86CNtCzbczSeHNIRHo=;
 b=jb/vNdJhJY7RsdvXzoMUbjox6KvxyCUCZ3YbFivE7xAAIIiUyUDS/RMJsU8xUGI66CqOnCYhYESC42xLNi1uPrQtL1iQAkiWnHxP0kiRs0ODW7tV4yqM8wZ38hKbTo9PLWBYd/H7gzKoAT95mxsH5tpZNn7ZdO2qT4PFFRFDiD4OrzcHdEvrAOoS/or88x0aCk6nOviYiv2P6xbpaOW3owcVS8vWqHjWcSzKCZXbyLGJzPKSxv01GAsOpsnI8zneZva9qme8z9aCMLtdriERcPqKDltoZkRniDiZfhIFUMWCQijFxdE0tNxvnJsRZpQuTLee+ycLqFxzWkKNyh6ZmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nWNzeEqOr5U03MiU2g2XtdGYO86CNtCzbczSeHNIRHo=;
 b=R6iTZdt4qTxfzyLY3/2SOBx1uhHa65tgck/XlqR5d4CISzas3Jguf7EiCo8jPdWFOHYXEhJcfn1+B1Da8CfrOWDZemVdn+J+1KPBHJHxBPHSmO/+OX8gMRIl0RInpkbz0+VifOgQUIRCfUqozGY1DVYiqX3xdzwV5wNSLIgVd+Y=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM5PR10MB1564.namprd10.prod.outlook.com (2603:10b6:3:9::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.15; Thu, 28 Apr 2022 21:11:00 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 21:11:00 +0000
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
Subject: [PATCH RFC 08/19] iommufd: Add a test for dirty tracking ioctls
Date:   Thu, 28 Apr 2022 22:09:22 +0100
Message-Id: <20220428210933.3583-9-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220428210933.3583-1-joao.m.martins@oracle.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0111.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::27) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5bbf4679-2548-444d-e01a-08da295b982c
X-MS-TrafficTypeDiagnostic: DM5PR10MB1564:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB15641D49BB11AEE97F316BC5BBFD9@DM5PR10MB1564.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AStTLR626tJ989mW5NWmZ/YX7uSI5aqu37klRiFo0lzZKJaDfsViv1zt0E86q5eMsoyYAjaCdNRx5KHI66kPNi4yVsGQTgfR+K9Hq+PLu6Bli3kyoXbrC0W7BiSFtCGX81/IQjmulx5DU3vuiKqzIkUTQFalqsWWpZ27r6vhYH/2MXfxs7a1SsI/NLO38i5fZ2iHIC2v5NGkbO1wt9Ca4828HJzpMnqvSfHFJ89jnuQ43zGdDT2v8Ze6rfZUi5z89WQ0CnGKl0jUZx1DlHmUd6uQT20836v8fQKuzJYKIyUBl9jh8ud7f4m+JwcE2MxXj4Ed4ldXHdc6KDMKuXF0/Z1wm6KCGHFCAOJJv9y/AezVgWcte+RX+Sn/dYtiW8plf/X+7Q556IZP6PqEa+qWwYpMKcKhqkQj2ZN7LcBMliybVPTm1ncTBI3pcYGBjLu9kJ0Mz5TkFeCwlZJjhDGd4EqtTaqznd38b01UNEZFpP4KO9Ftk4TtjzMXyoqefBQkmBGdh6iWe77qLux2/yG443nfeGwKL3lh1C2dkfiYz7DrITbaixCiDaDbhoPquyGe/Aec3IWDmjzKS9mzRWWXuN8JAqCds75nQe6Tna9iX94qiSJIdugoYnIRFry0gmcHLe5yfXI3H1crZBxdRQmeapFqASH7ebechgoUxY0ALxAR6WFbsnA1qe0VoHeXmPP0Gw+nm1L+rF5IOeeLeBpmXR9zOhdrVHHzkQ6/WwbJQtQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(186003)(86362001)(66946007)(66556008)(4326008)(66476007)(8676002)(2616005)(36756003)(1076003)(103116003)(8936002)(5660300002)(7416002)(30864003)(26005)(6512007)(6486002)(6916009)(83380400001)(54906003)(508600001)(6506007)(38350700002)(38100700002)(6666004)(2906002)(52116002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6HDLaAIjMCV2Uo2tIz7D7B+aZBkKiWLYTnp8ddsN3ol93dcE8pm8r50AeD7F?=
 =?us-ascii?Q?6qanEPJEEIPeOq1UYFePG72DzQzrwo18KHuAw7jC65X0e0C9etwiRhosD4e8?=
 =?us-ascii?Q?r+T2wbkPErPMyplz0NMJHOPUe/MgolqhRjD1L9hEMOrKqg/6lK1AK6aEdrKd?=
 =?us-ascii?Q?sVCOs3yKhK7f3tjCi/NxYwNUMcwbRr8o5lw7rDfFclF6EyUnmMycNiMn5vsg?=
 =?us-ascii?Q?2E/hyLCmyLKSxpVamhxqwHb78J91uqMOhg+upxS3DWf8R+QiGVPovBsYPcqH?=
 =?us-ascii?Q?enSfxv91E3F6wmQr1BjAHALaMd6SafqWFdW0ztpKU91XZ1hhoMrxI7A0Cpgp?=
 =?us-ascii?Q?CwJiCqLUxekp/Zx6XZb8XogSn/7V4vobN5Mqu7UfsHXeQRNY/1x1yCWiz4ec?=
 =?us-ascii?Q?XzpZgLnMEN3esOiOHfJicCxoYLGWzEHhJ2PSOLpCd3IZh8Qa++INUjzIteKn?=
 =?us-ascii?Q?pJwx8UdyTiFC1iYN4DWYGjaf4At9OYegJkL4uYEGmBgnFUcE8LAKeiXHm669?=
 =?us-ascii?Q?hgtZjHibnJ8zqVia7x5CoLyigpgwSuiOwQTVU0Bhw/1XBy13tw5JI6+oCYLp?=
 =?us-ascii?Q?oXUe3i23ZdeJBgM1M2HQIol9veJqagt89RlzR4yV+z+WxhMGIIvfq94KyvNy?=
 =?us-ascii?Q?0B0it2LcPH1eAvSE4q9ZKQAArlfdWQU4FpgXKAZ1CUG1rugDSkfoWkFmIReh?=
 =?us-ascii?Q?D0kHIvjEOQCHteb1kYsk8d/RBFJTWKkC8Gdoein+hMir1yaJ/QbGZNpAgCE9?=
 =?us-ascii?Q?kXIorIC6wftNpvvgGIFxbeb20Fv31taTa4IaWhsM6vMq8JHInxyb86QZYvtx?=
 =?us-ascii?Q?ibjd/xak/M265ObdaI6W3taz5elCABd7mC3fs3QN+spEisgxFUrw1zwcxemS?=
 =?us-ascii?Q?QeQGwFWtJodWxuEGgxHRENLyd4WSJ0ZTax8wziSsUThAXRfZqk5wL3ghZAB3?=
 =?us-ascii?Q?JrUo8jneCMEfusX2T+LAj2Beq6E0CFNZKzXz04Qp0XsH02usU5RkL0Iy2i6D?=
 =?us-ascii?Q?KDFI2/RHTRgJtYl61GT1bCwnn3TwfnY3HTP6+qD1qefGxOLOx/6mwV1hoa8x?=
 =?us-ascii?Q?4XszdumQ7u6jZZ4miasszFhhInfsNqm1A1cr0Rwpm43ZhGiGE4v3AWVm3KgI?=
 =?us-ascii?Q?PkI4Ns8Rfn/VwO5t4ILr+yL/AIjhYO3InE0ZhmZ0uxFrdOV075emyeKIOIXY?=
 =?us-ascii?Q?gd+LFDwvGeqXMTfN8zNFLczTQSztUNftc1emsQRfIbCk1Gt6/GdmFf/dHF+w?=
 =?us-ascii?Q?eBH3Jm6ybEnlThQ4c9D9mgm7ugyt4f1A1yIMqE1wtvwCFM/JQyeHG9aPYvy7?=
 =?us-ascii?Q?5t7b15nYKlBewwINHiX3J12ngPlVqgsZ4oaf6WcJN3pnU1bZGQFcSPBrXbnL?=
 =?us-ascii?Q?1+5XVsUH1lKO20We55oKBrY8JGTgjTiaBURUrOaC6Wy/D/owtCl/UAqjlCz8?=
 =?us-ascii?Q?B3m3V/4MBw61TXIu6bLNhVWjifVhYvlivUC757yWMyLM2qAKE30N3Y2Xe0jf?=
 =?us-ascii?Q?HRV4fPeqROYzHQ005pKMf9avpWnygvw8WHm1penOd1gS+6ZiMdtjrIxRIpgN?=
 =?us-ascii?Q?4DvpHH/j/SlWjHUzN3aK/JLnlU73A6edcDCIC0P256xavKsECn6TKqpkmm3E?=
 =?us-ascii?Q?lHNC5/EtZwhQTjYQBBSmZkpA7zWtE27BRytMcbwnfCuow5whPXbAevXc45lO?=
 =?us-ascii?Q?WyPa07NAIR5aKVe8CUMBoJnKgWLUHLchsdyD63/qZQRdPcseaBJtfpwM+ckA?=
 =?us-ascii?Q?LQCNMdKDGsXteQuHatjhNSrKBNbtaE4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bbf4679-2548-444d-e01a-08da295b982c
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 21:11:00.0999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gz1+FX0HG57RMf159bXlLY0UhbRBpKOQljZPIjg7AHbtkKLkUiO/ilRfsiVFavutu5iFHu4gsi/KVx8CdNPRmR5UMbdqJFLO2V84hsmmXfI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_04:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204280125
X-Proofpoint-GUID: iMg0MBxcmswVNYTDZsV6d3PfcrvweZaa
X-Proofpoint-ORIG-GUID: iMg0MBxcmswVNYTDZsV6d3PfcrvweZaa
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new test ioctl for simulating the dirty IOVAs
in the mock domain, and implement the mock iommu domain ops
that get the dirty tracking supported.

The selftest exercises the usual main workflow of:

1) Setting/Clearing dirty tracking from the iommu domain
2) Read and clear dirty IOPTEs
3) Unmap and read dirty back

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/iommufd/iommufd_test.h    |   9 ++
 drivers/iommu/iommufd/selftest.c        | 137 +++++++++++++++++++++++-
 tools/testing/selftests/iommu/Makefile  |   1 +
 tools/testing/selftests/iommu/iommufd.c | 135 +++++++++++++++++++++++
 4 files changed, 279 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommufd/iommufd_test.h b/drivers/iommu/iommufd/iommufd_test.h
index d22ef484af1a..90dafa513078 100644
--- a/drivers/iommu/iommufd/iommufd_test.h
+++ b/drivers/iommu/iommufd/iommufd_test.h
@@ -14,6 +14,7 @@ enum {
 	IOMMU_TEST_OP_MD_CHECK_REFS,
 	IOMMU_TEST_OP_ACCESS_PAGES,
 	IOMMU_TEST_OP_SET_TEMP_MEMORY_LIMIT,
+	IOMMU_TEST_OP_DIRTY,
 };
 
 enum {
@@ -57,6 +58,14 @@ struct iommu_test_cmd {
 		struct {
 			__u32 limit;
 		} memory_limit;
+		struct {
+			__u32 flags;
+			__aligned_u64 iova;
+			__aligned_u64 length;
+			__aligned_u64 page_size;
+			__aligned_u64 uptr;
+			__aligned_u64 out_nr_dirty;
+		} dirty;
 	};
 	__u32 last;
 };
diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index a665719b493e..b02309722436 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -13,6 +13,7 @@
 size_t iommufd_test_memory_limit = 65536;
 
 enum {
+	MOCK_DIRTY_TRACK = 1,
 	MOCK_IO_PAGE_SIZE = PAGE_SIZE / 2,
 
 	/*
@@ -25,9 +26,11 @@ enum {
 	_MOCK_PFN_START = MOCK_PFN_MASK + 1,
 	MOCK_PFN_START_IOVA = _MOCK_PFN_START,
 	MOCK_PFN_LAST_IOVA = _MOCK_PFN_START,
+	MOCK_PFN_DIRTY_IOVA = _MOCK_PFN_START << 1,
 };
 
 struct mock_iommu_domain {
+	unsigned long flags;
 	struct iommu_domain domain;
 	struct xarray pfns;
 };
@@ -133,7 +136,7 @@ static size_t mock_domain_unmap_pages(struct iommu_domain *domain,
 
 		for (cur = 0; cur != pgsize; cur += MOCK_IO_PAGE_SIZE) {
 			ent = xa_erase(&mock->pfns, iova / MOCK_IO_PAGE_SIZE);
-			WARN_ON(!ent);
+
 			/*
 			 * iommufd generates unmaps that must be a strict
 			 * superset of the map's performend So every starting
@@ -143,12 +146,12 @@ static size_t mock_domain_unmap_pages(struct iommu_domain *domain,
 			 * passed to map_pages
 			 */
 			if (first) {
-				WARN_ON(!(xa_to_value(ent) &
+				WARN_ON(ent && !(xa_to_value(ent) &
 					  MOCK_PFN_START_IOVA));
 				first = false;
 			}
 			if (pgcount == 1 && cur + MOCK_IO_PAGE_SIZE == pgsize)
-				WARN_ON(!(xa_to_value(ent) &
+				WARN_ON(ent && !(xa_to_value(ent) &
 					  MOCK_PFN_LAST_IOVA));
 
 			iova += MOCK_IO_PAGE_SIZE;
@@ -171,6 +174,75 @@ static phys_addr_t mock_domain_iova_to_phys(struct iommu_domain *domain,
 	return (xa_to_value(ent) & MOCK_PFN_MASK) * MOCK_IO_PAGE_SIZE;
 }
 
+static int mock_domain_set_dirty_tracking(struct iommu_domain *domain,
+					  bool enable)
+{
+	struct mock_iommu_domain *mock =
+		container_of(domain, struct mock_iommu_domain, domain);
+	unsigned long flags = mock->flags;
+
+	/* No change? */
+	if (!(enable ^ !!(flags & MOCK_DIRTY_TRACK)))
+		return -EINVAL;
+
+	flags = (enable ?
+		 flags | MOCK_DIRTY_TRACK : flags & ~MOCK_DIRTY_TRACK);
+
+	mock->flags = flags;
+	return 0;
+}
+
+static int mock_domain_read_and_clear_dirty(struct iommu_domain *domain,
+					    unsigned long iova, size_t size,
+					    struct iommu_dirty_bitmap *dirty)
+{
+	struct mock_iommu_domain *mock =
+		container_of(domain, struct mock_iommu_domain, domain);
+	unsigned long i, max = size / MOCK_IO_PAGE_SIZE;
+	void *ent, *old;
+
+	if (!(mock->flags & MOCK_DIRTY_TRACK))
+		return -EINVAL;
+
+	for (i = 0; i < max; i++) {
+		unsigned long cur = iova + i * MOCK_IO_PAGE_SIZE;
+
+		ent = xa_load(&mock->pfns, cur / MOCK_IO_PAGE_SIZE);
+		if (ent &&
+		    (xa_to_value(ent) & MOCK_PFN_DIRTY_IOVA)) {
+			unsigned long val;
+
+			/* Clear dirty */
+			val = xa_to_value(ent) & ~MOCK_PFN_DIRTY_IOVA;
+			old = xa_store(&mock->pfns, cur / MOCK_IO_PAGE_SIZE,
+				       xa_mk_value(val), GFP_KERNEL);
+			WARN_ON_ONCE(ent != old);
+			iommu_dirty_bitmap_record(dirty, cur, MOCK_IO_PAGE_SIZE);
+		}
+	}
+
+	return 0;
+}
+
+static size_t mock_domain_unmap_read_dirty(struct iommu_domain *domain,
+					   unsigned long iova, size_t page_size,
+					   struct iommu_iotlb_gather *gather,
+					   struct iommu_dirty_bitmap *dirty)
+{
+	struct mock_iommu_domain *mock =
+		container_of(domain, struct mock_iommu_domain, domain);
+	void *ent;
+
+	WARN_ON(page_size != MOCK_IO_PAGE_SIZE);
+
+	ent = xa_erase(&mock->pfns, iova / MOCK_IO_PAGE_SIZE);
+	if (ent && (xa_to_value(ent) & MOCK_PFN_DIRTY_IOVA) &&
+	    (mock->flags & MOCK_DIRTY_TRACK))
+		iommu_dirty_bitmap_record(dirty, iova, page_size);
+
+	return ent ? page_size : 0;
+}
+
 static const struct iommu_ops mock_ops = {
 	.owner = THIS_MODULE,
 	.pgsize_bitmap = MOCK_IO_PAGE_SIZE,
@@ -181,6 +253,9 @@ static const struct iommu_ops mock_ops = {
 			.map_pages = mock_domain_map_pages,
 			.unmap_pages = mock_domain_unmap_pages,
 			.iova_to_phys = mock_domain_iova_to_phys,
+			.set_dirty_tracking = mock_domain_set_dirty_tracking,
+			.read_and_clear_dirty = mock_domain_read_and_clear_dirty,
+			.unmap_read_dirty = mock_domain_unmap_read_dirty,
 		},
 };
 
@@ -442,6 +517,56 @@ static int iommufd_test_access_pages(struct iommufd_ucmd *ucmd,
 	return rc;
 }
 
+static int iommufd_test_dirty(struct iommufd_ucmd *ucmd,
+			      unsigned int mockpt_id, unsigned long iova,
+			      size_t length, unsigned long page_size,
+			      void __user *uptr, u32 flags)
+{
+	unsigned long i, max = length / page_size;
+	struct iommu_test_cmd *cmd = ucmd->cmd;
+	struct iommufd_hw_pagetable *hwpt;
+	struct mock_iommu_domain *mock;
+	int rc, count = 0;
+
+	if (iova % page_size || length % page_size ||
+	    (uintptr_t)uptr % page_size)
+		return -EINVAL;
+
+	hwpt = get_md_pagetable(ucmd, mockpt_id, &mock);
+	if (IS_ERR(hwpt))
+		return PTR_ERR(hwpt);
+
+	if (!(mock->flags & MOCK_DIRTY_TRACK)) {
+		rc = -EINVAL;
+		goto out_put;
+	}
+
+	for (i = 0; i < max; i++) {
+		unsigned long cur = iova + i * page_size;
+		void *ent, *old;
+
+		if (!test_bit(i, (unsigned long *) uptr))
+			continue;
+
+		ent = xa_load(&mock->pfns, cur / page_size);
+		if (ent) {
+			unsigned long val;
+
+			val = xa_to_value(ent) | MOCK_PFN_DIRTY_IOVA;
+			old = xa_store(&mock->pfns, cur / page_size,
+				       xa_mk_value(val), GFP_KERNEL);
+			WARN_ON_ONCE(ent != old);
+			count++;
+		}
+	}
+
+	cmd->dirty.out_nr_dirty = count;
+	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
+out_put:
+	iommufd_put_object(&hwpt->obj);
+	return rc;
+}
+
 void iommufd_selftest_destroy(struct iommufd_object *obj)
 {
 	struct selftest_obj *sobj = container_of(obj, struct selftest_obj, obj);
@@ -486,6 +611,12 @@ int iommufd_test(struct iommufd_ucmd *ucmd)
 			cmd->access_pages.length,
 			u64_to_user_ptr(cmd->access_pages.uptr),
 			cmd->access_pages.flags);
+	case IOMMU_TEST_OP_DIRTY:
+		return iommufd_test_dirty(
+			ucmd, cmd->id, cmd->dirty.iova,
+			cmd->dirty.length, cmd->dirty.page_size,
+			u64_to_user_ptr(cmd->dirty.uptr),
+			cmd->dirty.flags);
 	case IOMMU_TEST_OP_SET_TEMP_MEMORY_LIMIT:
 		iommufd_test_memory_limit = cmd->memory_limit.limit;
 		return 0;
diff --git a/tools/testing/selftests/iommu/Makefile b/tools/testing/selftests/iommu/Makefile
index 7bc38b3beaeb..48d4dcf11506 100644
--- a/tools/testing/selftests/iommu/Makefile
+++ b/tools/testing/selftests/iommu/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 CFLAGS += -Wall -O2 -Wno-unused-function
+CFLAGS += -I../../../../tools/include/
 CFLAGS += -I../../../../include/uapi/
 CFLAGS += -I../../../../include/
 
diff --git a/tools/testing/selftests/iommu/iommufd.c b/tools/testing/selftests/iommu/iommufd.c
index 5c47d706ed94..3a494f7958f4 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -13,13 +13,18 @@
 #define __EXPORTED_HEADERS__
 #include <linux/iommufd.h>
 #include <linux/vfio.h>
+#include <linux/bitmap.h>
+#include <linux/bitops.h>
 #include "../../../../drivers/iommu/iommufd/iommufd_test.h"
+#define BITS_PER_BYTE 8
 
 static void *buffer;
+static void *bitmap;
 
 static unsigned long PAGE_SIZE;
 static unsigned long HUGEPAGE_SIZE;
 static unsigned long BUFFER_SIZE;
+static unsigned long BITMAP_SIZE;
 
 #define MOCK_PAGE_SIZE (PAGE_SIZE / 2)
 
@@ -52,6 +57,10 @@ static __attribute__((constructor)) void setup_sizes(void)
 	BUFFER_SIZE = PAGE_SIZE * 16;
 	rc = posix_memalign(&buffer, HUGEPAGE_SIZE, BUFFER_SIZE);
 	assert(rc || buffer || (uintptr_t)buffer % HUGEPAGE_SIZE == 0);
+
+	BITMAP_SIZE = BUFFER_SIZE / MOCK_PAGE_SIZE / BITS_PER_BYTE;
+	rc = posix_memalign(&bitmap, PAGE_SIZE, BUFFER_SIZE);
+	assert(rc || buffer || (uintptr_t)buffer % PAGE_SIZE == 0);
 }
 
 /*
@@ -546,6 +555,132 @@ TEST_F(iommufd_ioas, iova_ranges)
 	EXPECT_EQ(0, cmd->out_valid_iovas[1].last);
 }
 
+TEST_F(iommufd_ioas, dirty)
+{
+	struct iommu_ioas_map map_cmd = {
+		.size = sizeof(map_cmd),
+		.flags = IOMMU_IOAS_MAP_FIXED_IOVA,
+		.ioas_id = self->ioas_id,
+		.user_va = (uintptr_t)buffer,
+		.length = BUFFER_SIZE,
+		.iova = MOCK_APERTURE_START,
+	};
+	struct iommu_test_cmd mock_cmd = {
+		.size = sizeof(mock_cmd),
+		.op = IOMMU_TEST_OP_MOCK_DOMAIN,
+		.id = self->ioas_id,
+	};
+	struct iommu_hwpt_set_dirty set_dirty_cmd = {
+		.size = sizeof(set_dirty_cmd),
+		.flags = IOMMU_DIRTY_TRACKING_ENABLED,
+		.hwpt_id = self->ioas_id,
+	};
+	struct iommu_test_cmd dirty_cmd = {
+		.size = sizeof(dirty_cmd),
+		.op = IOMMU_TEST_OP_DIRTY,
+		.id = self->ioas_id,
+		.dirty = { .iova = MOCK_APERTURE_START,
+			   .length = BUFFER_SIZE,
+			   .page_size = MOCK_PAGE_SIZE,
+			   .uptr = (uintptr_t)bitmap },
+	};
+	struct iommu_hwpt_get_dirty_iova get_dirty_cmd = {
+		.size = sizeof(get_dirty_cmd),
+		.hwpt_id = self->ioas_id,
+		.bitmap = {
+			.iova = MOCK_APERTURE_START,
+			.length = BUFFER_SIZE,
+			.page_size = MOCK_PAGE_SIZE,
+			.data = (__u64 *)bitmap,
+		}
+	};
+	struct iommu_ioas_unmap_dirty unmap_dirty_cmd = {
+		.size = sizeof(unmap_dirty_cmd),
+		.ioas_id = self->ioas_id,
+		.bitmap = {
+			.iova = MOCK_APERTURE_START,
+			.length = BUFFER_SIZE,
+			.page_size = MOCK_PAGE_SIZE,
+			.data = (__u64 *)bitmap,
+		},
+	};
+	struct iommu_destroy destroy_cmd = { .size = sizeof(destroy_cmd) };
+	unsigned long i, count, nbits = BITMAP_SIZE * BITS_PER_BYTE;
+
+	/* Toggle dirty with a domain and a single map */
+	ASSERT_EQ(0, ioctl(self->fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_MOCK_DOMAIN),
+			   &mock_cmd));
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_MAP, &map_cmd));
+
+	set_dirty_cmd.hwpt_id = mock_cmd.id;
+	ASSERT_EQ(0,
+		  ioctl(self->fd, IOMMU_HWPT_SET_DIRTY, &set_dirty_cmd));
+	EXPECT_ERRNO(EINVAL,
+		  ioctl(self->fd, IOMMU_HWPT_SET_DIRTY, &set_dirty_cmd));
+
+	/* Mark all even bits as dirty in the mock domain */
+	for (count = 0, i = 0; i < nbits; count += !(i%2), i++)
+		if (!(i % 2))
+			set_bit(i, (unsigned long *) bitmap);
+	ASSERT_EQ(count, BITMAP_SIZE * BITS_PER_BYTE / 2);
+
+	dirty_cmd.id = mock_cmd.id;
+	ASSERT_EQ(0,
+		  ioctl(self->fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_DIRTY),
+			&dirty_cmd));
+	ASSERT_EQ(BITMAP_SIZE * BITS_PER_BYTE / 2,
+		  dirty_cmd.dirty.out_nr_dirty);
+
+	get_dirty_cmd.hwpt_id = mock_cmd.id;
+	memset(bitmap, 0, BITMAP_SIZE);
+	ASSERT_EQ(0,
+		  ioctl(self->fd, IOMMU_HWPT_GET_DIRTY_IOVA, &get_dirty_cmd));
+
+	/* All even bits should be dirty */
+	for (count = 0, i = 0; i < nbits; count += !(i%2), i++)
+		ASSERT_EQ(!(i % 2), test_bit(i, (unsigned long *) bitmap));
+	ASSERT_EQ(count, dirty_cmd.dirty.out_nr_dirty);
+
+	memset(bitmap, 0, BITMAP_SIZE);
+	ASSERT_EQ(0,
+		  ioctl(self->fd, IOMMU_HWPT_GET_DIRTY_IOVA, &get_dirty_cmd));
+
+	/* Should be all zeroes */
+	for (i = 0; i < nbits; i++)
+		ASSERT_EQ(0, test_bit(i, (unsigned long *) bitmap));
+
+	/* Mark all even bits as dirty in the mock domain */
+	for (count = 0, i = 0; i < nbits; count += !(i%2), i++)
+		if (!(i % 2))
+			set_bit(i, (unsigned long *) bitmap);
+	ASSERT_EQ(count, BITMAP_SIZE * BITS_PER_BYTE / 2);
+	ASSERT_EQ(0,
+		  ioctl(self->fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_DIRTY),
+			&dirty_cmd));
+	ASSERT_EQ(BITMAP_SIZE * BITS_PER_BYTE / 2,
+		  dirty_cmd.dirty.out_nr_dirty);
+
+	memset(bitmap, 0, BITMAP_SIZE);
+	ASSERT_EQ(0,
+		  ioctl(self->fd, IOMMU_IOAS_UNMAP_DIRTY, &unmap_dirty_cmd));
+
+	/* All even bits should be dirty */
+	for (count = 0, i = 0; i < nbits; count += !(i%2), i++)
+		ASSERT_EQ(!(i % 2), test_bit(i, (unsigned long *) bitmap));
+	ASSERT_EQ(count, dirty_cmd.dirty.out_nr_dirty);
+
+	set_dirty_cmd.flags = IOMMU_DIRTY_TRACKING_DISABLED;
+	ASSERT_EQ(0,
+		     ioctl(self->fd, IOMMU_HWPT_SET_DIRTY, &set_dirty_cmd));
+	EXPECT_ERRNO(EINVAL,
+		     ioctl(self->fd, IOMMU_HWPT_SET_DIRTY, &set_dirty_cmd));
+
+	destroy_cmd.id = mock_cmd.mock_domain.device_id;
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_DESTROY, &destroy_cmd));
+	destroy_cmd.id = mock_cmd.id;
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_DESTROY, &destroy_cmd));
+}
+
 TEST_F(iommufd_ioas, access)
 {
 	struct iommu_ioas_map map_cmd = {
-- 
2.17.2

