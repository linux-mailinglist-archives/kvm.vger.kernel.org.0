Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E14D5AB90F
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 21:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbiIBT7h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 15:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiIBT7f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 15:59:35 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2056.outbound.protection.outlook.com [40.107.102.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3797117E11
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 12:59:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YK3GWkI4u04XH0gBx4+0ffIYaSx3+ElypB0xWUa9IGuuUegK80i2wY6KI2jI2CcGk4se791D8lkIzH9zHLu77N5W63xoaC/FIv1r2YdXFozDTO4U5D9fDfdGBrG7XaiFsvfqfIt4E2eWL+pYlr6xBjOIc0vMWpWrkZJAru82BwOf9w2fi8OVKIIKpNCU+PRI+bOtB2FHo360ukTPXjZ0JNE7kebXoOo3LDI4/6ymTeNEriq9sxd9zqA7PZHZjNEFGlVdZ3Up1M23Y/uvggABm1gVBgW+AvU1vJMI6KQonHxxMl7cIhRod8gueokXynLbtdT9ZVe6omh++TzJ85Z7Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IQMP//xtWQmxbQRvZ+4O31nJjfn3ZkT/dSg+dzUtVsI=;
 b=JlpnC84LU/klgW/4ZRFF6Grq3WmW/5DdtGn5WPBGpBOT+dj/Nfc897x8v/aOgi3rUA8p2WOQ27QbVEWvsSjg0YR8Ug9V4dqfmCoQA6QnM/MR+ANhB+pFCtFKFLZbWF1gQ+Vxm3+PJxwMBdTzNLrb8rDP08dbF83fSIEqzfc1ghK0eJfVGqw/eCbWasrbp4ePy4Y78EfVR6MhwMO74aAV60B4D/MtsGey9imESDm1UeX6wpJvQtSKmeLSo6w6Vi5mmipplMFmPBhH/gt42a6Cl/b8y6hQx2TPVhuAWzWpJx0O07RlpHMj2bWiDfIv6cdlXomTvHEsgAVEOoDo4hHYuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IQMP//xtWQmxbQRvZ+4O31nJjfn3ZkT/dSg+dzUtVsI=;
 b=XmiBmk1f7PWF9qkZJJBwbStaWnjSffJpnjKWUgUA3zPzCW8DrhX/cWPZUn1RHCHpZ0Ed6xBIsad02LHR6GGVOjMGfWL1Zre2vn7wRTmvWNigHZltMayoEQaavzP1/4QMiNWGsuj9pQujcFfSQtVAXH0bjwV2SGJ+ESgw194x9+KY6bTK2SQLkMUTbIW5g4ZeSHbDnw8DGKWfXSJTd/Ea+RL1vwg82R0iZkTLdpdQppgoms4aovpl52YRUHIrRKFtSkvbNP0mdx2gtjwCdDnZaf59OoJQA6GMm2bh0WX7vBBQ1fUs8OW0tqgMAMgM3wzOvJS5L6epHGoeIImrTCzqnw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM4PR12MB6566.namprd12.prod.outlook.com (2603:10b6:8:8d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 19:59:30 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5588.016; Fri, 2 Sep 2022
 19:59:30 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH RFC v2 06/13] iommufd: Algorithms for PFN storage
Date:   Fri,  2 Sep 2022 16:59:22 -0300
Message-Id: <6-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0118.namprd03.prod.outlook.com
 (2603:10b6:208:32a::33) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a67aa78-fea0-4a5a-21c9-08da8d1da5ba
X-MS-TrafficTypeDiagnostic: DM4PR12MB6566:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dWzjBQdNZbcbdB9HC27On4QFSjAov5+eKZbHBP206wrWMsE0Vr8K3RlJoOSdOqTuHMvsDA6tE1m+hqoK0q+lOqi5aESTeyEpsSJul+qcwONKGs3Dkck6tffAMN/tdu/VE/vyLQnvJDs9DfmMw4lc67X5i6uiyubN3h1ybccwvsraJGDIkEgunVq0d7YebqnqAQDA6sV/bBpuiJxtrUfGSKtktUEF2kEuVIxeN5z2iaveEnY9xn5kk+SkCvKdo3wPcRUB4YV7jpA+yWq4LMoS648f3/UntjGJKWdIu3sw/xjj3sWGoakqSiMUniHAOnhpdOd92HWc8EYTxhWXnxmYFBG0fowh/LcivRrCinGzGlLNiymvtdj0TyqCuJmUIG5WU0Km+UrSJyYgE7Qe6Ime7r5DWz1gsDFzbz7yPdZH7xS1RvuTGNUvuo27RCJLUQRyJSqA9lCDTFzGj+pxcKxj+cf0RVciYNd8wuvuqm7xBKA8VJ2TNIzGUGbNO0/T/gdb1VQF7+/xD0SU3BPBk9gB0E6+qYiNSDyq4pKue+hVDZ9tv79AKbSsnt0FJFhieSbgtm7B6tAAyPpPZHQUI7SuaXaqBE5z5t9J3+TqztC1jA0X9htK2eUTTXlO7VFDp1Ct7NveHrZTwGQZzUpLztsuC2hx5vZ3ra69VZ/75FvuOFIzGAejLwhfQVm99DR5xCKoyVDbqk9c/7b6+hRop6VCD52Jz+aMfvE9R2voLRXojNT0lA4/pVRoli3eaNSRlzFIc/34H4djIF98AxfJF2qL5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(30864003)(5660300002)(109986005)(6506007)(36756003)(83380400001)(41300700001)(8936002)(6666004)(6486002)(478600001)(2906002)(38100700002)(66476007)(8676002)(66946007)(66556008)(4326008)(86362001)(54906003)(7416002)(26005)(6512007)(186003)(2616005)(316002)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JaUcwMmwPnEiN1LY6TGlND/9dGmiFK4nTiUXBo/oBu9DArtLcYTsLlKwxnKS?=
 =?us-ascii?Q?U88Cpqx+JriGFt7NqdJOBuQQvxv5slKJk1uV7XVRr0D7kWW+c9Z30rgxlyKq?=
 =?us-ascii?Q?bi7OReSr3FTwzrEUn2JOGYcqDJyyxloIiR0jwCWCoSqyDa7Y4AX79ltRn1uO?=
 =?us-ascii?Q?RDmJaJhqsbOV7VAjZTj85v7Ld3fbfNqhnrr39YVcs2ij/EC0KXPHB+uOtOVg?=
 =?us-ascii?Q?u4rHMY+Dr60faVHsbTym/w3POREGQg/MrcHdVsf+vIPTru8ovvK/u/G1p4EU?=
 =?us-ascii?Q?Z9XU6XwvZPCpZYU+i+5ae3ssz2re5Q4k3D382f6MQcg8Op+OmTM6+kEVLmkB?=
 =?us-ascii?Q?ZU5haUsgTDwPZcdGxvusWM/4GKSjTEo3fwwVq2p3nvLQu5fm5aEbdS0s+yd2?=
 =?us-ascii?Q?95YkNt8aavJX9EwrkZ0XUS43WySgj8WP/hgBvn3KlAP6u9CPv2BwAaqgV0Em?=
 =?us-ascii?Q?BKEKage+jGgQp0yPSGcc9GxYl7RsP/6xtKvd38rmYwbxobIqOAcQM+/TXwM1?=
 =?us-ascii?Q?OSR+rc7GE1cOVo3ZmBUCN8Wf7mMGX0XKn8lg+vARx7K9VA/PaFEQLdQ6IMoE?=
 =?us-ascii?Q?sMLLouk+evd2lKuDmKriT3O/1of2Az++vb9YYlR/AJewDVkTxNdoA51pLouJ?=
 =?us-ascii?Q?psCd2rzR+qSD7QnSr+97c8nQzfKmsENw0FlJyW2/R2tng/zE1ihbzHWEsUoj?=
 =?us-ascii?Q?Y6oG+53eFpNZv4enYCbhT8TMjom9EkIf6OyzReSZzo08lLM20NBAATbXITEI?=
 =?us-ascii?Q?bvpeVozeVD7zYZpQL4WMv9UUkCOkpA9XlA11jj/4awKWocLt1wrIeAwGbp6N?=
 =?us-ascii?Q?hZZ25pngZz9eaGHVK8WG9/YQGkfQxVBtjSYhLJ43tb7ZQC0qZnn4sdDy6gZH?=
 =?us-ascii?Q?RzTef5ImPHZZL9FC1OzD+0t5ekUV6f1JQXjhKCH44v0K9cvatKtR20/DsmxH?=
 =?us-ascii?Q?KJfAGSbNrP6q2KrHClYu3LZbDZbaSkFN79vF/mVOsk63Np1Vu9m4L9vN3/9U?=
 =?us-ascii?Q?s/5NhMnpPXl/ugiXn8oMm3WW0MwzHZA48Zj+QZFbMaFQvRlRKcfsI0HxJgMe?=
 =?us-ascii?Q?sqiYN1lbvjJHEIZKf0/tgyD6wWlrGoYzbUJWSxnbY2W7aOVMiHc3j0sOGZz0?=
 =?us-ascii?Q?o/m0shznMflJIKJKotA2yr9KqwNDKXqzNd5Kh22dqirwWIgtdM1Gmox1pgYo?=
 =?us-ascii?Q?p0V4es7gjzczLaXmrFueJYP1vI/cBKAJqCdmNJ4d5lOGh8i61/QHE6CTXsxy?=
 =?us-ascii?Q?frlM4+7xmmArDYDfyfzBbD3lK3+FKz8/o1grXlIgujMXhK39F/Gi4xQ4UQAa?=
 =?us-ascii?Q?hhMkeht8Tvla4b8e1dhCA9pGAYxd1bT622funidRKquZb6QMyQJRGbohMMpf?=
 =?us-ascii?Q?CA06CdyMVP9XPBdwz+vX2fxfSgLCPqI6Tda9q7N7cv9ahko7E/HWhbOx2nVX?=
 =?us-ascii?Q?J0D1ziPViD1oG/e4NJiotAjio/H0AV3TyvN95DR7ZSWxB+3OeDinjvfV9zfx?=
 =?us-ascii?Q?9kGRBFITH7MKp0lnsKkuYUiQjSMSuX8epgDL26A7rFagc0fa06/byNCGi+cU?=
 =?us-ascii?Q?PD3eaMx67octlQSYzJJWhDrispNKD+vOc3HVHXXc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a67aa78-fea0-4a5a-21c9-08da8d1da5ba
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 19:59:30.3165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wSKlNlX9RrqH2BNiSttoBrP0HupfKWnkchyvKJg54uVwUq7VnVjC6b0rzO2C3wrs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6566
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The iopt_pages which represents a logical linear list of PFNs held in
different storage tiers. Each area points to a slice of exactly one
iopt_pages, and each iopt_pages can have multiple areas and users.

The three storage tiers are managed to meet these objectives:

 - If no iommu_domain or user exists then minimal memory should be
   consumed by iomufd
 - If a page has been pinned then an iopt_pages will not pin it again
 - If an in-kernel user exists then the xarray must provide the backing
   storage to avoid allocations on domain removals
 - Otherwise any iommu_domain will be used for storage

In a common configuration with only an iommu_domain the iopt_pages does
not allocate significant memory itself.

The external interface for pages has several logical operations:

  iopt_area_fill_domain() will load the PFNs from storage into a single
  domain. This is used when attaching a new domain to an existing IOAS.

  iopt_area_fill_domains() will load the PFNs from storage into multiple
  domains. This is used when creating a new IOVA map in an existing IOAS

  iopt_pages_add_user() creates an iopt_pages_user that tracks an in-kernel
  user of PFNs. This is some external driver that might be accessing the
  IOVA using the CPU, or programming PFNs with the DMA API. ie a VFIO
  mdev.

  iopt_pages_fill_xarray() will load PFNs into the xarray and return a
  'struct page *' array. It is used by iopt_pages_user's to extract PFNs
  for in-kernel use. iopt_pages_fill_from_xarray() is a fast path when it
  is known the xarray is already filled.

As an iopt_pages can be referred to in slices by many areas and users it
uses interval trees to keep track of which storage tiers currently hold
the PFNs. On a page-by-page basis any request for a PFN will be satisfied
from one of the storage tiers and the PFN copied to target domain/array.

Unfill actions are similar, on a page by page basis domains are unmapped,
xarray entries freed or struct pages fully put back.

Significant complexity is required to fully optimize all of these data
motions. The implementation calculates the largest consecutive range of
same-storage indexes and operates in blocks. The accumulation of PFNs
always generates the largest contiguous PFN range possible to optimize and
this gathering can cross storage tier boundaries. For cases like 'fill
domains' care is taken to avoid duplicated work and PFNs are read once and
pushed into all domains.

The map/unmap interaction with the iommu_domain always works in contiguous
PFN blocks. The implementation does not require or benefit from any
split/merge optimization in the iommu_domain driver.

This design suggests several possible improvements in the IOMMU API that
would greatly help performance, particularly a way for the driver to map
and read the pfns lists instead of working with one driver call per page
to read, and one driver call per contiguous range to store.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/io_pagetable.h |  71 ++++
 drivers/iommu/iommufd/pages.c        | 579 +++++++++++++++++++++++++++
 2 files changed, 650 insertions(+)

diff --git a/drivers/iommu/iommufd/io_pagetable.h b/drivers/iommu/iommufd/io_pagetable.h
index 24a0f1a9de6197..fe3be8dd38240e 100644
--- a/drivers/iommu/iommufd/io_pagetable.h
+++ b/drivers/iommu/iommufd/io_pagetable.h
@@ -49,6 +49,14 @@ struct iopt_area {
 	unsigned int num_users;
 };
 
+int iopt_area_fill_domains(struct iopt_area *area, struct iopt_pages *pages);
+void iopt_area_unfill_domains(struct iopt_area *area, struct iopt_pages *pages);
+
+int iopt_area_fill_domain(struct iopt_area *area, struct iommu_domain *domain);
+void iopt_area_unfill_domain(struct iopt_area *area, struct iopt_pages *pages,
+			     struct iommu_domain *domain);
+void iopt_unmap_domain(struct io_pagetable *iopt, struct iommu_domain *domain);
+
 static inline unsigned long iopt_area_index(struct iopt_area *area)
 {
 	return area->pages_node.start;
@@ -69,6 +77,39 @@ static inline unsigned long iopt_area_last_iova(struct iopt_area *area)
 	return area->node.last;
 }
 
+static inline size_t iopt_area_length(struct iopt_area *area)
+{
+	return (area->node.last - area->node.start) + 1;
+}
+
+#define __make_iopt_iter(name)                                                 \
+	static inline struct iopt_##name *iopt_##name##_iter_first(            \
+		struct io_pagetable *iopt, unsigned long start,                \
+		unsigned long last)                                            \
+	{                                                                      \
+		struct interval_tree_node *node;                               \
+                                                                               \
+		lockdep_assert_held(&iopt->iova_rwsem);                        \
+		node = interval_tree_iter_first(&iopt->name##_itree, start,    \
+						last);                         \
+		if (!node)                                                     \
+			return NULL;                                           \
+		return container_of(node, struct iopt_##name, node);           \
+	}                                                                      \
+	static inline struct iopt_##name *iopt_##name##_iter_next(             \
+		struct iopt_##name *last_node, unsigned long start,            \
+		unsigned long last)                                            \
+	{                                                                      \
+		struct interval_tree_node *node;                               \
+                                                                               \
+		node = interval_tree_iter_next(&last_node->node, start, last); \
+		if (!node)                                                     \
+			return NULL;                                           \
+		return container_of(node, struct iopt_##name, node);           \
+	}
+
+__make_iopt_iter(area)
+
 /*
  * This holds a pinned page list for multiple areas of IO address space. The
  * pages always originate from a linear chunk of userspace VA. Multiple
@@ -100,4 +141,34 @@ struct iopt_pages {
 	struct rb_root_cached domains_itree;
 };
 
+struct iopt_pages *iopt_alloc_pages(void __user *uptr, unsigned long length,
+				    bool writable);
+void iopt_release_pages(struct kref *kref);
+static inline void iopt_put_pages(struct iopt_pages *pages)
+{
+	kref_put(&pages->kref, iopt_release_pages);
+}
+
+void iopt_pages_fill_from_xarray(struct iopt_pages *pages, unsigned long start,
+				 unsigned long last, struct page **out_pages);
+int iopt_pages_fill_xarray(struct iopt_pages *pages, unsigned long start,
+			   unsigned long last, struct page **out_pages);
+void iopt_pages_unfill_xarray(struct iopt_pages *pages, unsigned long start,
+			      unsigned long last);
+
+int iopt_pages_add_user(struct iopt_pages *pages, unsigned long start,
+			unsigned long last, struct page **out_pages,
+			bool write);
+void iopt_pages_remove_user(struct iopt_area *area, unsigned long start,
+			    unsigned long last);
+
+/*
+ * Each interval represents an active iopt_access_pages(), it acts as an
+ * interval lock that keeps the PFNs pinned and stored in the xarray.
+ */
+struct iopt_pages_user {
+	struct interval_tree_node node;
+	refcount_t refcount;
+};
+
 #endif
diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index a5c369c94b2f11..91db42dd6aaeaa 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -140,6 +140,18 @@ static void iommu_unmap_nofail(struct iommu_domain *domain, unsigned long iova,
 	WARN_ON(ret != size);
 }
 
+static void iopt_area_unmap_domain_range(struct iopt_area *area,
+					 struct iommu_domain *domain,
+					 unsigned long start_index,
+					 unsigned long last_index)
+{
+	unsigned long start_iova = iopt_area_index_to_iova(area, start_index);
+
+	iommu_unmap_nofail(domain, start_iova,
+			   iopt_area_index_to_iova_last(area, last_index) -
+				   start_iova + 1);
+}
+
 static struct iopt_area *iopt_pages_find_domain_area(struct iopt_pages *pages,
 						     unsigned long index)
 {
@@ -716,3 +728,570 @@ static int pfn_reader_first(struct pfn_reader *pfns, struct iopt_pages *pages,
 	}
 	return 0;
 }
+
+struct iopt_pages *iopt_alloc_pages(void __user *uptr, unsigned long length,
+				    bool writable)
+{
+	struct iopt_pages *pages;
+
+	/*
+	 * The iommu API uses size_t as the length, and protect the DIV_ROUND_UP
+	 * below from overflow
+	 */
+	if (length > SIZE_MAX - PAGE_SIZE || length == 0)
+		return ERR_PTR(-EINVAL);
+
+	pages = kzalloc(sizeof(*pages), GFP_KERNEL_ACCOUNT);
+	if (!pages)
+		return ERR_PTR(-ENOMEM);
+
+	kref_init(&pages->kref);
+	xa_init_flags(&pages->pinned_pfns, XA_FLAGS_ACCOUNT);
+	mutex_init(&pages->mutex);
+	pages->source_mm = current->mm;
+	mmgrab(pages->source_mm);
+	pages->uptr = (void __user *)ALIGN_DOWN((uintptr_t)uptr, PAGE_SIZE);
+	pages->npages = DIV_ROUND_UP(length + (uptr - pages->uptr), PAGE_SIZE);
+	pages->users_itree = RB_ROOT_CACHED;
+	pages->domains_itree = RB_ROOT_CACHED;
+	pages->writable = writable;
+	pages->has_cap_ipc_lock = capable(CAP_IPC_LOCK);
+	pages->source_task = current->group_leader;
+	get_task_struct(current->group_leader);
+	pages->source_user = get_uid(current_user());
+	return pages;
+}
+
+void iopt_release_pages(struct kref *kref)
+{
+	struct iopt_pages *pages = container_of(kref, struct iopt_pages, kref);
+
+	WARN_ON(!RB_EMPTY_ROOT(&pages->users_itree.rb_root));
+	WARN_ON(!RB_EMPTY_ROOT(&pages->domains_itree.rb_root));
+	WARN_ON(pages->npinned);
+	WARN_ON(!xa_empty(&pages->pinned_pfns));
+	mmdrop(pages->source_mm);
+	mutex_destroy(&pages->mutex);
+	put_task_struct(pages->source_task);
+	free_uid(pages->source_user);
+	kfree(pages);
+}
+
+/* Quickly guess if the interval tree might fully cover the given interval */
+static bool interval_tree_fully_covers(struct rb_root_cached *root,
+				       unsigned long index, unsigned long last)
+{
+	struct interval_tree_node *node;
+
+	node = interval_tree_iter_first(root, index, last);
+	if (!node)
+		return false;
+	return node->start <= index && node->last >= last;
+}
+
+static bool interval_tree_fully_covers_area(struct rb_root_cached *root,
+					    struct iopt_area *area)
+{
+	return interval_tree_fully_covers(root, iopt_area_index(area),
+					  iopt_area_last_index(area));
+}
+
+static void __iopt_area_unfill_domain(struct iopt_area *area,
+				      struct iopt_pages *pages,
+				      struct iommu_domain *domain,
+				      unsigned long last_index)
+{
+	unsigned long unmapped_index = iopt_area_index(area);
+	unsigned long cur_index = unmapped_index;
+	u64 backup[BATCH_BACKUP_SIZE];
+	struct pfn_batch batch;
+
+	lockdep_assert_held(&pages->mutex);
+
+	/* Fast path if there is obviously something else using every pfn */
+	if (interval_tree_fully_covers_area(&pages->domains_itree, area) ||
+	    interval_tree_fully_covers_area(&pages->users_itree, area)) {
+		iopt_area_unmap_domain_range(area, domain,
+					     iopt_area_index(area), last_index);
+		return;
+	}
+
+	/*
+	 * unmaps must always 'cut' at a place where the pfns are not contiguous
+	 * to pair with the maps that always install contiguous pages. This
+	 * algorithm is efficient in the expected case of few pinners.
+	 */
+	batch_init_backup(&batch, last_index + 1, backup, sizeof(backup));
+	while (cur_index != last_index + 1) {
+		unsigned long batch_index = cur_index;
+
+		batch_from_domain(&batch, domain, area, cur_index, last_index);
+		cur_index += batch.total_pfns;
+		iopt_area_unmap_domain_range(area, domain, unmapped_index,
+					     cur_index - 1);
+		unmapped_index = cur_index;
+		iopt_pages_unpin(pages, &batch, batch_index, cur_index - 1);
+		batch_clear(&batch);
+	}
+	batch_destroy(&batch, backup);
+	update_unpinned(pages);
+}
+
+static void iopt_area_unfill_partial_domain(struct iopt_area *area,
+					    struct iopt_pages *pages,
+					    struct iommu_domain *domain,
+					    unsigned long end_index)
+{
+	if (end_index != iopt_area_index(area))
+		__iopt_area_unfill_domain(area, pages, domain, end_index - 1);
+}
+
+/**
+ * iopt_unmap_domain() - Unmap without unpinning PFNs in a domain
+ * @iopt: The iopt the domain is part of
+ * @domain: The domain to unmap
+ *
+ * The caller must know that unpinning is not required, usually because there
+ * are other domains in the iopt.
+ */
+void iopt_unmap_domain(struct io_pagetable *iopt, struct iommu_domain *domain)
+{
+	struct interval_tree_span_iter span;
+
+	interval_tree_for_each_span (&span, &iopt->area_itree, 0, ULONG_MAX)
+		if (!span.is_hole)
+			iommu_unmap_nofail(domain, span.start_used,
+					   span.last_used - span.start_used +
+						   1);
+}
+
+/**
+ * iopt_area_unfill_domain() - Unmap and unpin PFNs in a domain
+ * @area: IOVA area to use
+ * @pages: page supplier for the area (area->pages is NULL)
+ * @domain: Domain to unmap from
+ *
+ * The domain should be removed from the domains_itree before calling. The
+ * domain will always be unmapped, but the PFNs may not be unpinned if there are
+ * still users.
+ */
+void iopt_area_unfill_domain(struct iopt_area *area, struct iopt_pages *pages,
+			     struct iommu_domain *domain)
+{
+	__iopt_area_unfill_domain(area, pages, domain,
+				  iopt_area_last_index(area));
+}
+
+/**
+ * iopt_area_fill_domain() - Map PFNs from the area into a domain
+ * @area: IOVA area to use
+ * @domain: Domain to load PFNs into
+ *
+ * Read the pfns from the area's underlying iopt_pages and map them into the
+ * given domain. Called when attaching a new domain to an io_pagetable.
+ */
+int iopt_area_fill_domain(struct iopt_area *area, struct iommu_domain *domain)
+{
+	struct pfn_reader pfns;
+	int rc;
+
+	lockdep_assert_held(&area->pages->mutex);
+
+	rc = pfn_reader_first(&pfns, area->pages, iopt_area_index(area),
+			      iopt_area_last_index(area));
+	if (rc)
+		return rc;
+
+	while (!pfn_reader_done(&pfns)) {
+		rc = batch_to_domain(&pfns.batch, domain, area,
+				     pfns.batch_start_index);
+		if (rc)
+			goto out_unmap;
+
+		rc = pfn_reader_next(&pfns);
+		if (rc)
+			goto out_unmap;
+	}
+
+	rc = update_pinned(area->pages);
+	if (rc)
+		goto out_unmap;
+	goto out_destroy;
+
+out_unmap:
+	iopt_area_unfill_partial_domain(area, area->pages, domain,
+					pfns.batch_start_index);
+out_destroy:
+	pfn_reader_destroy(&pfns);
+	return rc;
+}
+
+/**
+ * iopt_area_fill_domains() - Install PFNs into the area's domains
+ * @area: The area to act on
+ * @pages: The pages associated with the area (area->pages is NULL)
+ *
+ * Called during area creation. The area is freshly created and not inserted in
+ * the domains_itree yet. PFNs are read and loaded into every domain held in the
+ * area's io_pagetable and the area is installed in the domains_itree.
+ *
+ * On failure all domains are left unchanged.
+ */
+int iopt_area_fill_domains(struct iopt_area *area, struct iopt_pages *pages)
+{
+	struct pfn_reader pfns;
+	struct iommu_domain *domain;
+	unsigned long unmap_index;
+	unsigned long index;
+	int rc;
+
+	lockdep_assert_held(&area->iopt->domains_rwsem);
+
+	if (xa_empty(&area->iopt->domains))
+		return 0;
+
+	mutex_lock(&pages->mutex);
+	rc = pfn_reader_first(&pfns, pages, iopt_area_index(area),
+			      iopt_area_last_index(area));
+	if (rc)
+		goto out_unlock;
+
+	while (!pfn_reader_done(&pfns)) {
+		xa_for_each (&area->iopt->domains, index, domain) {
+			rc = batch_to_domain(&pfns.batch, domain, area,
+					     pfns.batch_start_index);
+			if (rc)
+				goto out_unmap;
+		}
+
+		rc = pfn_reader_next(&pfns);
+		if (rc)
+			goto out_unmap;
+	}
+	rc = update_pinned(pages);
+	if (rc)
+		goto out_unmap;
+
+	area->storage_domain = xa_load(&area->iopt->domains, 0);
+	interval_tree_insert(&area->pages_node, &pages->domains_itree);
+	goto out_destroy;
+
+out_unmap:
+	xa_for_each (&area->iopt->domains, unmap_index, domain) {
+		unsigned long end_index = pfns.batch_start_index;
+
+		if (unmap_index <= index)
+			end_index = pfns.batch_end_index;
+
+		/*
+		 * The area is not yet part of the domains_itree so we have to
+		 * manage the unpinning specially. The last domain does the
+		 * unpin, every other domain is just unmapped.
+		 */
+		if (unmap_index != area->iopt->next_domain_id - 1) {
+			if (end_index != iopt_area_index(area))
+				iopt_area_unmap_domain_range(
+					area, domain, iopt_area_index(area),
+					end_index - 1);
+		} else {
+			iopt_area_unfill_partial_domain(area, pages, domain,
+							end_index);
+		}
+	}
+out_destroy:
+	pfn_reader_destroy(&pfns);
+out_unlock:
+	mutex_unlock(&pages->mutex);
+	return rc;
+}
+
+/**
+ * iopt_area_unfill_domains() - unmap PFNs from the area's domains
+ * @area: The area to act on
+ * @pages: The pages associated with the area (area->pages is NULL)
+ *
+ * Called during area destruction. This unmaps the iova's covered by all the
+ * area's domains and releases the PFNs.
+ */
+void iopt_area_unfill_domains(struct iopt_area *area, struct iopt_pages *pages)
+{
+	struct io_pagetable *iopt = area->iopt;
+	struct iommu_domain *domain;
+	unsigned long index;
+
+	lockdep_assert_held(&iopt->domains_rwsem);
+
+	mutex_lock(&pages->mutex);
+	if (!area->storage_domain)
+		goto out_unlock;
+
+	xa_for_each (&iopt->domains, index, domain)
+		if (domain != area->storage_domain)
+			iopt_area_unmap_domain_range(
+				area, domain, iopt_area_index(area),
+				iopt_area_last_index(area));
+
+	interval_tree_remove(&area->pages_node, &pages->domains_itree);
+	iopt_area_unfill_domain(area, pages, area->storage_domain);
+	area->storage_domain = NULL;
+out_unlock:
+	mutex_unlock(&pages->mutex);
+}
+
+/*
+ * Erase entries in the pinned_pfns xarray that are not covered by any users.
+ * This does not unpin the pages, the caller is responsible to deal with the pin
+ * reference. The main purpose of this action is to save memory in the xarray.
+ */
+static void iopt_pages_clean_xarray(struct iopt_pages *pages,
+				    unsigned long index, unsigned long last)
+{
+	struct interval_tree_span_iter span;
+
+	lockdep_assert_held(&pages->mutex);
+
+	interval_tree_for_each_span (&span, &pages->users_itree, index, last)
+		if (span.is_hole)
+			clear_xarray(&pages->pinned_pfns, span.start_hole,
+				     span.last_hole);
+}
+
+/**
+ * iopt_pages_unfill_xarray() - Update the xarry after removing a user
+ * @pages: The pages to act on
+ * @start: Starting PFN index
+ * @last: Last PFN index
+ *
+ * Called when an iopt_pages_user is removed, removes pages from the itree.
+ * The user should already be removed from the users_itree.
+ */
+void iopt_pages_unfill_xarray(struct iopt_pages *pages, unsigned long start,
+			      unsigned long last)
+{
+	struct interval_tree_span_iter span;
+	struct pfn_batch batch;
+	u64 backup[BATCH_BACKUP_SIZE];
+
+	lockdep_assert_held(&pages->mutex);
+
+	if (interval_tree_fully_covers(&pages->domains_itree, start, last))
+		return iopt_pages_clean_xarray(pages, start, last);
+
+	batch_init_backup(&batch, last + 1, backup, sizeof(backup));
+	interval_tree_for_each_span (&span, &pages->users_itree, start, last) {
+		unsigned long cur_index;
+
+		if (!span.is_hole)
+			continue;
+		cur_index = span.start_hole;
+		while (cur_index != span.last_hole + 1) {
+			batch_from_xarray(&batch, &pages->pinned_pfns,
+					  cur_index, span.last_hole);
+			iopt_pages_unpin(pages, &batch, cur_index,
+					 cur_index + batch.total_pfns - 1);
+			cur_index += batch.total_pfns;
+			batch_clear(&batch);
+		}
+		clear_xarray(&pages->pinned_pfns, span.start_hole,
+			     span.last_hole);
+	}
+	batch_destroy(&batch, backup);
+	update_unpinned(pages);
+}
+
+/**
+ * iopt_pages_fill_from_xarray() - Fast path for reading PFNs
+ * @pages: The pages to act on
+ * @start: The first page index in the range
+ * @last: The last page index in the range
+ * @out_pages: The output array to return the pages
+ *
+ * This can be called if the caller is holding a refcount on an iopt_pages_user
+ * that is known to have already been filled. It quickly reads the pages
+ * directly from the xarray.
+ *
+ * This is part of the SW iommu interface to read pages for in-kernel use.
+ */
+void iopt_pages_fill_from_xarray(struct iopt_pages *pages, unsigned long start,
+				 unsigned long last, struct page **out_pages)
+{
+	XA_STATE(xas, &pages->pinned_pfns, start);
+	void *entry;
+
+	rcu_read_lock();
+	while (true) {
+		entry = xas_next(&xas);
+		if (xas_retry(&xas, entry))
+			continue;
+		WARN_ON(!xa_is_value(entry));
+		*(out_pages++) = pfn_to_page(xa_to_value(entry));
+		if (start == last)
+			break;
+		start++;
+	}
+	rcu_read_unlock();
+}
+
+/**
+ * iopt_pages_fill_xarray() - Read PFNs
+ * @pages: The pages to act on
+ * @start: The first page index in the range
+ * @last: The last page index in the range
+ * @out_pages: The output array to return the pages, may be NULL
+ *
+ * This populates the xarray and returns the pages in out_pages. As the slow
+ * path this is able to copy pages from other storage tiers into the xarray.
+ *
+ * On failure the xarray is left unchanged.
+ *
+ * This is part of the SW iommu interface to read pages for in-kernel use.
+ */
+int iopt_pages_fill_xarray(struct iopt_pages *pages, unsigned long start,
+			   unsigned long last, struct page **out_pages)
+{
+	struct interval_tree_span_iter span;
+	unsigned long xa_end = start;
+	struct pfn_reader pfns;
+	int rc;
+
+	rc = pfn_reader_init(&pfns, pages, start, last);
+	if (rc)
+		return rc;
+
+	interval_tree_for_each_span (&span, &pages->users_itree, start, last) {
+		if (!span.is_hole) {
+			if (out_pages)
+				iopt_pages_fill_from_xarray(
+					pages + (span.start_used - start),
+					span.start_used, span.last_used,
+					out_pages);
+			continue;
+		}
+
+		rc = pfn_reader_seek_hole(&pfns, &span);
+		if (rc)
+			goto out_clean_xa;
+
+		while (!pfn_reader_done(&pfns)) {
+			rc = batch_to_xarray(&pfns.batch, &pages->pinned_pfns,
+					     pfns.batch_start_index);
+			if (rc)
+				goto out_clean_xa;
+			batch_to_pages(&pfns.batch, out_pages);
+			xa_end += pfns.batch.total_pfns;
+			out_pages += pfns.batch.total_pfns;
+			rc = pfn_reader_next(&pfns);
+			if (rc)
+				goto out_clean_xa;
+		}
+	}
+
+	rc = update_pinned(pages);
+	if (rc)
+		goto out_clean_xa;
+	pfn_reader_destroy(&pfns);
+	return 0;
+
+out_clean_xa:
+	if (start != xa_end)
+		iopt_pages_unfill_xarray(pages, start, xa_end - 1);
+	pfn_reader_destroy(&pfns);
+	return rc;
+}
+
+static struct iopt_pages_user *
+iopt_pages_get_exact_user(struct iopt_pages *pages, unsigned long index,
+			  unsigned long last)
+{
+	struct interval_tree_node *node;
+
+	lockdep_assert_held(&pages->mutex);
+
+	/* There can be overlapping ranges in this interval tree */
+	for (node = interval_tree_iter_first(&pages->users_itree, index, last);
+	     node; node = interval_tree_iter_next(node, index, last))
+		if (node->start == index && node->last == last)
+			return container_of(node, struct iopt_pages_user, node);
+	return NULL;
+}
+
+/**
+ * iopt_pages_add_user() - Record an in-knerel user for PFNs
+ * @pages: The source of PFNs
+ * @start: First page index
+ * @last: Inclusive last page index
+ * @out_pages: Output list of struct page's representing the PFNs
+ * @write: True if the user will write to the pages
+ *
+ * Record that an in-kernel user will be accessing the pages, ensure they are
+ * pinned, and return the PFNs as a simple list of 'struct page *'.
+ *
+ * This should be undone through a matching call to iopt_pages_remove_user()
+ */
+int iopt_pages_add_user(struct iopt_pages *pages, unsigned long start,
+			unsigned long last, struct page **out_pages, bool write)
+{
+	struct iopt_pages_user *user;
+	int rc;
+
+	if (pages->writable != write)
+		return -EPERM;
+
+	user = iopt_pages_get_exact_user(pages, start, last);
+	if (user) {
+		refcount_inc(&user->refcount);
+		iopt_pages_fill_from_xarray(pages, start, last, out_pages);
+		return 0;
+	}
+
+	user = kzalloc(sizeof(*user), GFP_KERNEL_ACCOUNT);
+	if (!user)
+		return -ENOMEM;
+
+	rc = iopt_pages_fill_xarray(pages, start, last, out_pages);
+	if (rc)
+		goto out_free;
+
+	user->node.start = start;
+	user->node.last = last;
+	refcount_set(&user->refcount, 1);
+	interval_tree_insert(&user->node, &pages->users_itree);
+	return 0;
+
+out_free:
+	kfree(user);
+	return rc;
+}
+
+/**
+ * iopt_pages_remove_user() - Release an in-kernel user for PFNs
+ * @area: The source of PFNs
+ * @start: First page index
+ * @last: Inclusive last page index
+ *
+ * Undo iopt_pages_add_user() and unpin the pages if necessary. The caller must
+ * stop using the PFNs before calling this.
+ */
+void iopt_pages_remove_user(struct iopt_area *area, unsigned long start,
+			    unsigned long last)
+{
+	struct iopt_pages_user *user;
+	struct iopt_pages *pages = area->pages;
+
+	mutex_lock(&pages->mutex);
+	user = iopt_pages_get_exact_user(pages, start, last);
+	if (WARN_ON(!user))
+		goto out_unlock;
+
+	WARN_ON(area->num_users == 0);
+	area->num_users--;
+
+	if (!refcount_dec_and_test(&user->refcount))
+		goto out_unlock;
+
+	interval_tree_remove(&user->node, &pages->users_itree);
+	iopt_pages_unfill_xarray(pages, start, last);
+	kfree(user);
+out_unlock:
+	mutex_unlock(&pages->mutex);
+}
-- 
2.37.3

