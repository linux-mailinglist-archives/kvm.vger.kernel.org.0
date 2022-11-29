Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C30DE63C946
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 21:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236323AbiK2UaS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 15:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236350AbiK2UaD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 15:30:03 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2062.outbound.protection.outlook.com [40.107.212.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EDB165E6B
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:30:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jn4/CV8vUW5+0kWJBVsILMC4K0r+aXAht6H7ia1kKbfzU2qvb6GeHYSAlfn7No8LN3ypDJgtpTsQIFRrxHCNqfi0AEG8LwMD5QxyaCaWrpox/Ew2s6rjPTJKOU72ljBVz9QmBJHAbDjcBMpfCWgjURYxBn/B7fzWNnGD76YkBpSRXubRvpFARvomDxA0zC/fmLsYOEi44ky2MKqwMGv+w4xhE0G5y8LKoSjgwGDg7LZmzCLoHcbVyonuhgfEHtIBb41WBVwS4VTXZukOKTnNsm6ZNHtfY5S2ITC/i+rxuoa4whEn15+vpWKouy6sggT6v3MJqzE/SIr7AipCNZzdpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8GjFuzbY5mlJoe8lGYNp7S+O8/NMm1dryWE1pKqtkV0=;
 b=i6VvXkIWGE4Xz6AKrtUxfgGzwdvFHqhFmco0U7IJEJLxfYe3ovoJRKFjY46SUodIJDocLqyRltx/bIQLTS4FhTVnqO3T/5OND/QUAqe/A45RBYQhmc3WFuWAM6BLD/z76+vREf0N9X6LDlHGmuSKzHnhTOxlG/grPXwcmzJoBZfoHtDM5vV4M2E0CT/RsluoE8VoyJjqtKo35K9K2xpKdN3PmH5//GAArY89laB4n1XLSyRwGIgMNARRCe7d11Q7kdPW6qP/NuezzSXFCcqSJUO+wwlOa+BWUwmEQyhl4sgH+d5XTUbdpKl564Guk+Cm9j+m+fWuJZKNiLApih2gCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8GjFuzbY5mlJoe8lGYNp7S+O8/NMm1dryWE1pKqtkV0=;
 b=tjsrBxMzTYryn2vat0qV02gV6Sgfnc78JsvGprAXDOW89wsps/aTBxUGeh5a2jwK56VvxOGntPLUt5PAbismlYxeSdxn2ulJR3/iTz4O0fxnQWeTz8fv79JLI7Qvn/q0sImM3bmISZJxQkN4e1VhDi6/CmB32hIc3hSqqjKvisjU9w+HQ6HXb6kr85w9uXoYFC1Xx6QWDe2wyOSpLKCB1lr4uWGdtEy9jtEEfYe8FW48IbSfrIsSGR2A0qltc2fdk0aITHLnsmLg19+llIc0dvMLzJh2kMVkYYqHJLwBH43ZnV1uF3yo7kV2EVrzsGKK7A6xwe5Enp8wjVokkQrM5w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY5PR12MB6059.namprd12.prod.outlook.com (2603:10b6:930:2c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 20:29:53 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 20:29:53 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Anthony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH v6 18/19] iommufd: Add additional invariant assertions
Date:   Tue, 29 Nov 2022 16:29:41 -0400
Message-Id: <18-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0063.namprd05.prod.outlook.com
 (2603:10b6:a03:74::40) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY5PR12MB6059:EE_
X-MS-Office365-Filtering-Correlation-Id: 86f36ba1-1d7a-4806-c1e1-08dad24875b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CxCmhJ1ha1nkMbhyRP5eNjzBa49vhtW8kZr0ak5e6Bc1qFEtDnRWVEHFb5z+cnr4XbzgcoU1/z1YalutF5GEhwhLvErp4qmxHczPYbmQle3E8agkcgut41a6PXs1UmTZxLezXLvTNiStsSktOH2GTjmOIbN1aEp5ZI61Af/xlzfpVF7aNUxwJiJNn9unlJ4At5QHBMzXcdsoCWl96cooylN4UvZEJZHt8xqu4z/pvh1ZfG3tiRv2Hk+JOH7bQ8OYINZyOaO/0GnEIzotUsIDhmG6tfQwGyKOGSbq5ZdsMRk0KWo4zbdkBzU5inQhp3/S2Kv9+BnB3ONjPQX/2VIUj21G8cjKFs+AZbchVMWzmoF7HEt60mqolcw37GTbcBt5QzyUM66tRSIrZFXN4+SwR0xJ2s15H0+D9FzOUgL0Gf0Mu3HamqFsWVndrRW8VLixzL/sTgaYVPorkYF2mIsqrxq5sKi67tpBpm3b50CcUX5+6lv0Ug5Eyl4GgXl/67V2XulQD1a9hxd0Asq6ryl8n48bxVPpe2ijLWqqBLXa+hNbZc/uIBzKI3ftATZBtLv3Q0t5JjXwdPWfh/kp80r9+Q3idsMPYDUUxO/2OtBu42euYMUWhPNeSTaHA4u1UwFtDZXPya6bEZzdldgXP7fmi3Hf2CvtFjpYqUAV3JzLCE+kxIvWJLyH+u3+AqEFCzgz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(451199015)(109986013)(36756003)(86362001)(54906003)(6486002)(316002)(478600001)(2906002)(66476007)(66556008)(66946007)(4326008)(8936002)(7416002)(41300700001)(8676002)(5660300002)(83380400001)(38100700002)(26005)(6506007)(6666004)(6512007)(186003)(2616005)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Kf1kFb2deOPsJTsyT/ImrI4iMXc6MT1jt0wgS3EHOukch+DVqmwKvBJf2j2U?=
 =?us-ascii?Q?UlfKLrmYZFn3DQkXojv2O9nUp1Wb0jmvv2pByPLKAj7nZDZiNfnZLm3pJDbQ?=
 =?us-ascii?Q?mXuHF/PDlVQltcBnbzEP4f5v59gOouoJEJI8HtHET/QWPZX4bpck6hzKXhVu?=
 =?us-ascii?Q?DkjxZJ2t8/nUhTOCnytErNhnsL8yzeyBTbpJJmKXzrd6MzO5ekDf2Ej0oA7c?=
 =?us-ascii?Q?rL+GydCNhL56XC2oad2Geten0hevxZh57zYdqQavEpq0CW80kZoxlB+4NKLz?=
 =?us-ascii?Q?BAPu0BWlgItj38ek6PI6IIrpjT5s6OjrZT7FRWlea5NCVMFZYf7eK/PLegoe?=
 =?us-ascii?Q?AZ9Vd5Xa8PbHz70xr9NQVWzYWzI1zsYJd2zIAcZPCQ49FvIkeQBnPHeF55v/?=
 =?us-ascii?Q?rK16xR2Mo0re8j23egHpPRys95Gq8WKMEKsev6xpfbZsIeU8jM/J+efVZ8b3?=
 =?us-ascii?Q?0uQ2O+DCdN+EswjJYIrnNL0VO4uGMYI1exzAGpsq5gyCWxTKKZ34wJOwp5Fd?=
 =?us-ascii?Q?yMT5IMyIl+ApmYJqPXrmWsbvK+Ng+mrgx4NkRmRl/cJCD4AwQKgFdVCX8oze?=
 =?us-ascii?Q?JK0VnGIgbVInp7Y3J+S3goPpPdogk04maq/j0R7bG18kdoHvlBqTw0cjUHwR?=
 =?us-ascii?Q?+hM+oCiV5u1zymq/8KDsEyCYVvQDq+Lb4ZhTF8Ty6wtLKLVr2EVTkaXHmLmj?=
 =?us-ascii?Q?IVsEtP1S/wHlUOukT+Npf14vYLrOgbYx2i398rtSs9sCmknEEzEgfUP4XCSW?=
 =?us-ascii?Q?2BpemDCNVh0Cq7oa9fh9tLscaNexdtHryJdH8+ipX5X7uoMVWqtfzdjeeXC1?=
 =?us-ascii?Q?05Jfhv6b7hV9O5Q91Gx/4OlQBseM+Zdr20Z9zU+Q69Ae1j0V7b81UTLs66YP?=
 =?us-ascii?Q?wPZHolFfF7G23hhuHQhaU1Kj619DoXe+V2qCK2oh4Nb/0swFz7+HoPMMuWAY?=
 =?us-ascii?Q?qJ2JtlTdsIdVLYZdDEBhHXRpHGnh6bgckAgHmkFEKs8dinpperZfM1ntvDqF?=
 =?us-ascii?Q?z+af/vTwgYyv69m95IPo8e/kdKorZCJ88+yIGoxR/A6Yf3U8ZNfR902OP+9B?=
 =?us-ascii?Q?GUsDyPp2HpAOCOr1itwogcvIFx/AOGIeoEzbbr9fOu5hP9QeQPSUNBvVISsR?=
 =?us-ascii?Q?cfDMl1OWn9mxtJzkECBGsPBU0IQSFTQtSVN86lYms+jMg9cD9rFQvIiCoBC3?=
 =?us-ascii?Q?CyPKOWPzTjZZfvngp09doCzh3QEniKos61ppOaTxV3aHicWkNCD2Ye5aAMTa?=
 =?us-ascii?Q?wKyl4YhB0hJlGqCUVdPL44ddiSF8PcemFV+5csQxrm/YotBjez3Fqi9Os+/F?=
 =?us-ascii?Q?dOjNdtWOkyRrO3MLy9MUjfaj84EVxU8KQJWmyfyAvwAaBCi2UmHTbmFnFgUB?=
 =?us-ascii?Q?15PWebU33eOgH/yOPk7wmrUm/NXXybo06XFW8ME+ctGsp7pHj8i8gzlxzzxv?=
 =?us-ascii?Q?gaL55H+1m1qmyVugZdNtEp7cDHTiop62mccUId50SIEnQ9Y4CuflUbflViw0?=
 =?us-ascii?Q?t6853QRAwnujwmXI8FJQXupxLnTfFSM2SrG1jeNdBpLGruvoSpxb4T255MLN?=
 =?us-ascii?Q?uq/8M5yI15r/j/zZc3J2i0v0MIKmXT4VmD1XXcoL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86f36ba1-1d7a-4806-c1e1-08dad24875b6
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 20:29:48.4329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iUBTovVfZyfIDbohpIt1c/6prxrroBBuAfQoC4X7u7FLIzwUi/gY3cZahCclwixp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6059
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These are on performance paths so we protect them using the
CONFIG_IOMMUFD_TEST to not take a hit during normal operation.

These are useful when running the test suite and syzkaller to find data
structure inconsistencies early.

Tested-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com> # s390
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/device.c       |  5 ++++
 drivers/iommu/iommufd/io_pagetable.c | 22 +++++++++++++++
 drivers/iommu/iommufd/io_pagetable.h |  3 ++
 drivers/iommu/iommufd/pages.c        | 42 ++++++++++++++++++++++++++--
 4 files changed, 70 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 67ce36152e8ab2..dd2a415b603e3b 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -625,6 +625,11 @@ int iommufd_access_pin_pages(struct iommufd_access *access, unsigned long iova,
 	struct iopt_area *area;
 	int rc;
 
+	/* Driver's ops don't support pin_pages */
+	if (IS_ENABLED(CONFIG_IOMMUFD_TEST) &&
+	    WARN_ON(access->iova_alignment != PAGE_SIZE || !access->ops->unmap))
+		return -EINVAL;
+
 	if (!length)
 		return -EINVAL;
 	if (check_add_overflow(iova, length - 1, &last_iova))
diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index 4f4a9d9aac570e..3467cea795684c 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -251,6 +251,11 @@ static int iopt_alloc_area_pages(struct io_pagetable *iopt,
 			(uintptr_t)elm->pages->uptr + elm->start_byte, length);
 		if (rc)
 			goto out_unlock;
+		if (IS_ENABLED(CONFIG_IOMMUFD_TEST) &&
+		    WARN_ON(iopt_check_iova(iopt, *dst_iova, length))) {
+			rc = -EINVAL;
+			goto out_unlock;
+		}
 	} else {
 		rc = iopt_check_iova(iopt, *dst_iova, length);
 		if (rc)
@@ -277,6 +282,8 @@ static int iopt_alloc_area_pages(struct io_pagetable *iopt,
 
 static void iopt_abort_area(struct iopt_area *area)
 {
+	if (IS_ENABLED(CONFIG_IOMMUFD_TEST))
+		WARN_ON(area->pages);
 	if (area->iopt) {
 		down_write(&area->iopt->iova_rwsem);
 		interval_tree_remove(&area->node, &area->iopt->area_itree);
@@ -642,6 +649,9 @@ void iopt_destroy_table(struct io_pagetable *iopt)
 {
 	struct interval_tree_node *node;
 
+	if (IS_ENABLED(CONFIG_IOMMUFD_TEST))
+		iopt_remove_reserved_iova(iopt, NULL);
+
 	while ((node = interval_tree_iter_first(&iopt->allowed_itree, 0,
 						ULONG_MAX))) {
 		interval_tree_remove(node, &iopt->allowed_itree);
@@ -688,6 +698,8 @@ static void iopt_unfill_domain(struct io_pagetable *iopt,
 				continue;
 
 			mutex_lock(&pages->mutex);
+			if (IS_ENABLED(CONFIG_IOMMUFD_TEST))
+				WARN_ON(!area->storage_domain);
 			if (area->storage_domain == domain)
 				area->storage_domain = storage_domain;
 			mutex_unlock(&pages->mutex);
@@ -792,6 +804,16 @@ static int iopt_check_iova_alignment(struct io_pagetable *iopt,
 		    (iopt_area_length(area) & align_mask) ||
 		    (area->page_offset & align_mask))
 			return -EADDRINUSE;
+
+	if (IS_ENABLED(CONFIG_IOMMUFD_TEST)) {
+		struct iommufd_access *access;
+		unsigned long index;
+
+		xa_for_each(&iopt->access_list, index, access)
+			if (WARN_ON(access->iova_alignment >
+				    new_iova_alignment))
+				return -EADDRINUSE;
+	}
 	return 0;
 }
 
diff --git a/drivers/iommu/iommufd/io_pagetable.h b/drivers/iommu/iommufd/io_pagetable.h
index 2ee6942c3ef4a5..83e7c175f2a277 100644
--- a/drivers/iommu/iommufd/io_pagetable.h
+++ b/drivers/iommu/iommufd/io_pagetable.h
@@ -101,6 +101,9 @@ static inline size_t iopt_area_length(struct iopt_area *area)
 static inline unsigned long iopt_area_start_byte(struct iopt_area *area,
 						 unsigned long iova)
 {
+	if (IS_ENABLED(CONFIG_IOMMUFD_TEST))
+		WARN_ON(iova < iopt_area_iova(area) ||
+			iova > iopt_area_last_iova(area));
 	return (iova - iopt_area_iova(area)) + area->page_offset +
 	       iopt_area_index(area) * PAGE_SIZE;
 }
diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index c5d2d9a8c56203..429fa3b0a239cd 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -162,12 +162,20 @@ void interval_tree_double_span_iter_next(
 
 static void iopt_pages_add_npinned(struct iopt_pages *pages, size_t npages)
 {
-	pages->npinned += npages;
+	int rc;
+
+	rc = check_add_overflow(pages->npinned, npages, &pages->npinned);
+	if (IS_ENABLED(CONFIG_IOMMUFD_TEST))
+		WARN_ON(rc || pages->npinned > pages->npages);
 }
 
 static void iopt_pages_sub_npinned(struct iopt_pages *pages, size_t npages)
 {
-	pages->npinned -= npages;
+	int rc;
+
+	rc = check_sub_overflow(pages->npinned, npages, &pages->npinned);
+	if (IS_ENABLED(CONFIG_IOMMUFD_TEST))
+		WARN_ON(rc || pages->npinned > pages->npages);
 }
 
 static void iopt_pages_err_unpin(struct iopt_pages *pages,
@@ -189,6 +197,9 @@ static void iopt_pages_err_unpin(struct iopt_pages *pages,
 static unsigned long iopt_area_index_to_iova(struct iopt_area *area,
 					     unsigned long index)
 {
+	if (IS_ENABLED(CONFIG_IOMMUFD_TEST))
+		WARN_ON(index < iopt_area_index(area) ||
+			index > iopt_area_last_index(area));
 	index -= iopt_area_index(area);
 	if (index == 0)
 		return iopt_area_iova(area);
@@ -198,6 +209,9 @@ static unsigned long iopt_area_index_to_iova(struct iopt_area *area,
 static unsigned long iopt_area_index_to_iova_last(struct iopt_area *area,
 						  unsigned long index)
 {
+	if (IS_ENABLED(CONFIG_IOMMUFD_TEST))
+		WARN_ON(index < iopt_area_index(area) ||
+			index > iopt_area_last_index(area));
 	if (index == iopt_area_last_index(area))
 		return iopt_area_last_iova(area);
 	return iopt_area_iova(area) - area->page_offset +
@@ -286,6 +300,8 @@ static void batch_skip_carry(struct pfn_batch *batch, unsigned int skip_pfns)
 {
 	if (!batch->total_pfns)
 		return;
+	if (IS_ENABLED(CONFIG_IOMMUFD_TEST))
+		WARN_ON(batch->total_pfns != batch->npfns[0]);
 	skip_pfns = min(batch->total_pfns, skip_pfns);
 	batch->pfns[0] += skip_pfns;
 	batch->npfns[0] -= skip_pfns;
@@ -301,6 +317,8 @@ static int __batch_init(struct pfn_batch *batch, size_t max_pages, void *backup,
 	batch->pfns = temp_kmalloc(&size, backup, backup_len);
 	if (!batch->pfns)
 		return -ENOMEM;
+	if (IS_ENABLED(CONFIG_IOMMUFD_TEST) && WARN_ON(size < elmsz))
+		return -EINVAL;
 	batch->array_size = size / elmsz;
 	batch->npfns = (u32 *)(batch->pfns + batch->array_size);
 	batch_clear(batch);
@@ -429,6 +447,10 @@ static int batch_iommu_map_small(struct iommu_domain *domain,
 	unsigned long start_iova = iova;
 	int rc;
 
+	if (IS_ENABLED(CONFIG_IOMMUFD_TEST))
+		WARN_ON(paddr % PAGE_SIZE || iova % PAGE_SIZE ||
+			size % PAGE_SIZE);
+
 	while (size) {
 		rc = iommu_map(domain, iova, paddr, PAGE_SIZE, prot);
 		if (rc)
@@ -718,6 +740,10 @@ static int pfn_reader_user_pin(struct pfn_reader_user *user,
 	uintptr_t uptr;
 	long rc;
 
+	if (IS_ENABLED(CONFIG_IOMMUFD_TEST) &&
+	    WARN_ON(last_index < start_index))
+		return -EINVAL;
+
 	if (!user->upages) {
 		/* All undone in pfn_reader_destroy() */
 		user->upages_len =
@@ -956,6 +982,10 @@ static int pfn_reader_fill_span(struct pfn_reader *pfns)
 	struct iopt_area *area;
 	int rc;
 
+	if (IS_ENABLED(CONFIG_IOMMUFD_TEST) &&
+	    WARN_ON(span->last_used < start_index))
+		return -EINVAL;
+
 	if (span->is_used == 1) {
 		batch_from_xarray(&pfns->batch, &pfns->pages->pinned_pfns,
 				  start_index, span->last_used);
@@ -1008,6 +1038,10 @@ static int pfn_reader_next(struct pfn_reader *pfns)
 	while (pfns->batch_end_index != pfns->last_index + 1) {
 		unsigned int npfns = pfns->batch.total_pfns;
 
+		if (IS_ENABLED(CONFIG_IOMMUFD_TEST) &&
+		    WARN_ON(interval_tree_double_span_iter_done(&pfns->span)))
+			return -EINVAL;
+
 		rc = pfn_reader_fill_span(pfns);
 		if (rc)
 			return rc;
@@ -1091,6 +1125,10 @@ static int pfn_reader_first(struct pfn_reader *pfns, struct iopt_pages *pages,
 {
 	int rc;
 
+	if (IS_ENABLED(CONFIG_IOMMUFD_TEST) &&
+	    WARN_ON(last_index < start_index))
+		return -EINVAL;
+
 	rc = pfn_reader_init(pfns, pages, start_index, last_index);
 	if (rc)
 		return rc;
-- 
2.38.1

