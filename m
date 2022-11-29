Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC91D63C949
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 21:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236637AbiK2UaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 15:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236425AbiK2UaE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 15:30:04 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2081.outbound.protection.outlook.com [40.107.212.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8ED65E72
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:30:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YDJdkykl4nlrm/y6hvb+rBiKloOAXdeNYTGRSJGQ8LrWEkzmyYHYmi5rdjPn72/VMaj2MxAzCMrUIRBluRC4i6ak8MhInL525ryeXJvfNWVmXRS0qpB2fBYstdyVQfZaiBoZDD39Vn+oyEhKrTOLvZvKVn/0Zxi69c9yEGS0/H4rWZtgJJnLon4y/Yqpv6KbTaXiGw4fKclB4bu+4yOBUaCns/QLBlsnUW6XE5uZ9AXKZnBy70jHsjRsn1NyQ/kY7ib6kVdE1gNBQ1jjEryM61zi6T5fkPk+3ovysha+pKgthLxyn+pBCf0gY8o5bZ6su9XoXRQR0qzzrTn5y33l3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PbYDoZjO9IN/P160STJrfA6D6AxJg0xR1ZisxDCPIP4=;
 b=PYEYjh2ETR/Fx86jCyEjgzPURb5vPUCpR1POYlZawV+xsYv4sgdpZ6T+swm85yqqCemYGMPZBNdIXTPKGcyetd4oRn5nC0O8J/Yo7J/nAmP3HdzmWy+302BXnUbRCIePfaiBKPl0+qlkm5iqleXi6utr3v9R2fkkOHPLXP7mEG2m50Lsz/6a9jupCZMBI73lY0A814Svmfw0lZCzCo9efkEuRx4XY3d2RPRecXpZ/wPIk2GchDc+/alKOYDoqPKoLQlsU8fvZnJX0phGR+zF6nh+pBYaPaLHSFMbvsuTQhfzIvsOauNi/Fg+2LzT1Kf6eYZ9Kbgy7YbJRGCMIKbFBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PbYDoZjO9IN/P160STJrfA6D6AxJg0xR1ZisxDCPIP4=;
 b=BLmcpv8pLsIf3b3yCpPn336PKcX9HeF1/oxkFLw3z6I5ILV6IOBDc1NxvKcWuekLMG91kHzNMcLKbFfXnQyZWYcOtPe+zGzSp5Jpu1mRTUPhdqplZxcvyZavSEGC1dw61GXOZ0iuYGJouuPYqtGPPVNmt2MKPeAYHrbY3jl6OCOg0GslQGHqTX5IQbO5dvWspPuKrP4GL4mSdcvJSsQeE2LtbF5TZblUi1rb4Ka6K8c/0WYF0DUPuOlU7hpv9WRinHL0DaXdCFF6vMF1DqpBjjypDm6rxfmHQZOT69Xramgj+unQnOqVY01zWtMBfF3gum752UYmXkc9XlzSKWJ7qA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY5PR12MB6059.namprd12.prod.outlook.com (2603:10b6:930:2c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 20:29:54 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 20:29:54 +0000
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
Subject: [PATCH v6 17/19] iommufd: Add some fault injection points
Date:   Tue, 29 Nov 2022 16:29:40 -0400
Message-Id: <17-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0098.namprd05.prod.outlook.com
 (2603:10b6:a03:334::13) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY5PR12MB6059:EE_
X-MS-Office365-Filtering-Correlation-Id: ac700b93-456f-465c-5caf-08dad24875d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9B/S0zREv6b9CWDNOt0RRhiA/xOpLVZDygKrssrK19pVnEd2sbQdpYpx6+H9B13wlq5BUmbt+4L6oiqVCxkit9PLBbjCz3yco+NxusXkYYDM572TPjZdKx1TgLvUOAnrJ2rB3vE8Wss1bnr/fIPzRBYEuv7xlM7W2nY0lM20TnJ2sV/mcqKdrJ5rFPOehTM7WYG6QRBBoR3e1VZoKcoJDbJyf2GRZiyHLO9RfkMTd+9WjinLVsYjsms/yCPc1xEHQrUt8MeXAwY39d+933pZDgKImWO7jvaTIC+9Nsc/Tefu3mqVRrWKvgLJqBeWQgNGNgPEwR/UY2iAK8QUHdN0xYzjOLP0WdxtKydMcfO3Ez5+RX33QazsOH6GVtIaHD4yXTekyP4SC8zEtYGYxiWuC4uWjBPeuuICszQnOB2dGGl07DMHDWPreJGPksg4xOJST3jB2Z8j+2xMbO4yFYSXCHQCt3yL8zCWV04Lht0NyZ/jEneVD54vXb+rQsiyHm0FZyNZ3PMcgwdlheAn1JGdwt25ergyFNpp+aGKDbUMbTyU05Nk2r6NpBy0lykdC5kvI+nptC3mTiSv8eOAo5elOtZPfEGMPxuY4LCby6kI8uVYvmBy6HAFy5JXQDficJs6knv1spzGK+jJdMWt87DtSkL+GcmtevbYfj6QqC+ayFBZ9m19inMStoJ0HcWOTmaD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(451199015)(109986013)(36756003)(86362001)(54906003)(6486002)(316002)(478600001)(2906002)(66476007)(66556008)(66946007)(4326008)(8936002)(7416002)(41300700001)(8676002)(5660300002)(83380400001)(38100700002)(26005)(6506007)(6666004)(6512007)(186003)(2616005)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VKUWLr6AelcqNquRpICcXRur95tt6FGHIKgpVrzOUhRshxg+/FjYZCNipqdW?=
 =?us-ascii?Q?Qv2XVWE8jG6lKl4hZDJg3Pgosm29T+MaYuy9i8giNGRPMo2BoyBpARej4JqK?=
 =?us-ascii?Q?6UoZkuP5O2iE0qmMxv/TrPWz22n5PAtrC6CJJq3/YCPcdJo+mJMb/b6Hpzgt?=
 =?us-ascii?Q?Kjizy3vkuaKyd+T06m3yITkeOlJkWxiy8JCZn+vmcq0EepKzbmxShg/F+Fo1?=
 =?us-ascii?Q?+YAO85vid0JBxSERNavaALIC0huuj0UcJQLtHo+KaNI0zmExGVviRSyQULr+?=
 =?us-ascii?Q?+BvysMDNTjiBrzYQqi6xi79xk2+y6zuD8IagwLFur3CWQedmYvuPVgaE2GRR?=
 =?us-ascii?Q?tWrr6AbJhoHXjc7r3mbYI7OJA/pBvRLjmaeEcPHz8H4Zhb6N4kPHlmXJoC+a?=
 =?us-ascii?Q?JN4V1M4uVTfSKVsF0La39HM1vFIkuvhuijpV+r12rFbdP7PpLYhkVgCJRpU7?=
 =?us-ascii?Q?W4/MiOz/iv2skyAPsGIRlral8ef11+3SdCjgerrMVwXJEpZyw3owd4nuVn/A?=
 =?us-ascii?Q?BTMtwUzQfODzFdZ7v9njj31Ciz6RmD3YnfBgYyxFLl7Qb6Lbii36Q2WHglhS?=
 =?us-ascii?Q?4WVevBxPKATsGp1/7REIkCuRkYohxpcRIPh3BUGCcmF0oxEd3nRBWTZ24HVQ?=
 =?us-ascii?Q?qwAme0biTwia/aNyWw4iHbaZFKVgAcuPLC/Oh6SYexzrnWf+fuex9ZMKhm14?=
 =?us-ascii?Q?8IxiD0Vu7E+/oicJlo9wl+sXMw4Pf9zAJHVBOQ+O+B+C6sUh4C1zyRCkZ57a?=
 =?us-ascii?Q?/fF2CrCJ18PeIbEdM1KHIiSzQXdsgkH395O2TS2ThALWqgvk02S5Zc8Vj2l0?=
 =?us-ascii?Q?kQ8p8VMN8DYY7ScG6tlock8cnznX5TOGdqzok8fsySJs7b7NvxzDaCMsyR9X?=
 =?us-ascii?Q?0tMA00RrgSQARit49Rto/6HcubDnaxd8S89JK7MxBfkY8Pon0j5Y0NpYOR5n?=
 =?us-ascii?Q?1mK+gxzowto1CtmuP8Fg77R1Khfsu2uawOwUGJumKmVehQDfDgLBh/89+25S?=
 =?us-ascii?Q?g9QeKoktUuaB7I+pZVYnM99yz3ATcycurw5bgncYWiUfPQoQScTyLCjJ46rs?=
 =?us-ascii?Q?Oc6LVRvhLBhmCjPAUSpMZpAEDBbl0xXekn7oCo8Nmsm8vz+NOlw4AbqmigJ6?=
 =?us-ascii?Q?WUZDcyBFNAQvbglMjmk+ZBXhB6DgwjPmCfX7KqTwF5X8gMkWFVBc1zULRqaf?=
 =?us-ascii?Q?OMlZD4UutSA3Tas7sww7EEkTFw39zXaKUIhyuYRwzKvWR91m/UwXfzj9TO1Q?=
 =?us-ascii?Q?TNLWrKvOhFUWD/kxKt/QcYJO9Jw7VrzFlx7pIA4KkjL3JR1TdVjBeU779ca4?=
 =?us-ascii?Q?W2uwwePT24xhvCcwIZxW0KXig/vhUs2JNq85em5q7aJmKQRutECnhHinih2V?=
 =?us-ascii?Q?ld7dXhno1fjylaUkpc0wegSrotnnBE5iyd6SSIbPUgIKM0MIWmul7nOgqvW6?=
 =?us-ascii?Q?wmHVOzepV/dyrIvdlYYUvqhGqGhf+mPlHSRiiMQZgQ9zxlum0VC/e51Ia8qk?=
 =?us-ascii?Q?8M3ewpGdAd+oneuaIvgjD6KiRvnn2PIbmPeUE987OTTRsL93OCM8z010Zeam?=
 =?us-ascii?Q?QFh4RJ3vKhLDqd3dXny7EFCEq5HJpCeU2N9wRoeo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac700b93-456f-465c-5caf-08dad24875d3
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 20:29:48.4797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IUgDzrfLZ+GaoiwO17aQRSt0yR1d3J83Qw1ky9yg9KBGR7C8tsLySTFHj8f4IdxZ
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

This increases the coverage the fail_nth test gets, as well as via
syzkaller.

Tested-by: Matthew Rosato <mjrosato@linux.ibm.com> # s390
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/main.c  |  3 +++
 drivers/iommu/iommufd/pages.c | 26 ++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 7c8f40bc8d98d5..bcb463e581009c 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -102,6 +102,9 @@ struct iommufd_object *iommufd_get_object(struct iommufd_ctx *ictx, u32 id,
 {
 	struct iommufd_object *obj;
 
+	if (iommufd_should_fail())
+		return ERR_PTR(-ENOENT);
+
 	xa_lock(&ictx->objects);
 	obj = xa_load(&ictx->objects, id);
 	if (!obj || (type != IOMMUFD_OBJ_ANY && obj->type != type) ||
diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index 640331b8a07919..c5d2d9a8c56203 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -80,6 +80,10 @@ static void *temp_kmalloc(size_t *size, void *backup, size_t backup_len)
 
 	if (*size < backup_len)
 		return backup;
+
+	if (!backup && iommufd_should_fail())
+		return NULL;
+
 	*size = min_t(size_t, *size, TEMP_MEMORY_LIMIT);
 	res = kmalloc(*size, GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY);
 	if (res)
@@ -544,6 +548,7 @@ static int pages_to_xarray(struct xarray *xa, unsigned long start_index,
 			   unsigned long last_index, struct page **pages)
 {
 	struct page **end_pages = pages + (last_index - start_index) + 1;
+	struct page **half_pages = pages + (end_pages - pages) / 2;
 	XA_STATE(xas, xa, start_index);
 
 	do {
@@ -551,6 +556,15 @@ static int pages_to_xarray(struct xarray *xa, unsigned long start_index,
 
 		xas_lock(&xas);
 		while (pages != end_pages) {
+			/* xarray does not participate in fault injection */
+			if (pages == half_pages && iommufd_should_fail()) {
+				xas_set_err(&xas, -EINVAL);
+				xas_unlock(&xas);
+				/* aka xas_destroy() */
+				xas_nomem(&xas, GFP_KERNEL);
+				goto err_clear;
+			}
+
 			old = xas_store(&xas, xa_mk_value(page_to_pfn(*pages)));
 			if (xas_error(&xas))
 				break;
@@ -561,6 +575,7 @@ static int pages_to_xarray(struct xarray *xa, unsigned long start_index,
 		xas_unlock(&xas);
 	} while (xas_nomem(&xas, GFP_KERNEL));
 
+err_clear:
 	if (xas_error(&xas)) {
 		if (xas.xa_index != start_index)
 			clear_xarray(xa, start_index, xas.xa_index - 1);
@@ -728,6 +743,10 @@ static int pfn_reader_user_pin(struct pfn_reader_user *user,
 	npages = min_t(unsigned long, last_index - start_index + 1,
 		       user->upages_len / sizeof(*user->upages));
 
+
+	if (iommufd_should_fail())
+		return -EFAULT;
+
 	uptr = (uintptr_t)(pages->uptr + start_index * PAGE_SIZE);
 	if (!remote_mm)
 		rc = pin_user_pages_fast(uptr, npages, user->gup_flags,
@@ -872,6 +891,8 @@ static int pfn_reader_user_update_pinned(struct pfn_reader_user *user,
 		npages = pages->last_npinned - pages->npinned;
 		inc = false;
 	} else {
+		if (iommufd_should_fail())
+			return -ENOMEM;
 		npages = pages->npinned - pages->last_npinned;
 		inc = true;
 	}
@@ -1721,6 +1742,11 @@ static int iopt_pages_rw_page(struct iopt_pages *pages, unsigned long index,
 		return iopt_pages_rw_slow(pages, index, index, offset, data,
 					  length, flags);
 
+	if (iommufd_should_fail()) {
+		rc = -EINVAL;
+		goto out_mmput;
+	}
+
 	mmap_read_lock(pages->source_mm);
 	rc = pin_user_pages_remote(
 		pages->source_mm, (uintptr_t)(pages->uptr + index * PAGE_SIZE),
-- 
2.38.1

