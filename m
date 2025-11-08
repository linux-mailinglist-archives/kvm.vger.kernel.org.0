Return-Path: <kvm+bounces-62409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F9D7C434F2
	for <lists+kvm@lfdr.de>; Sat, 08 Nov 2025 22:30:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17D30188CF07
	for <lists+kvm@lfdr.de>; Sat,  8 Nov 2025 21:30:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87FFB2853E0;
	Sat,  8 Nov 2025 21:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="MNvwIzka";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="w7b2hVnG"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928AA21257A
	for <kvm@vger.kernel.org>; Sat,  8 Nov 2025 21:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762637403; cv=none; b=nmK+O+ac0fso7XjbFGpq2pnC1BJyYjeI9hYYH8vSYjJJel1BOMM7c/BC3MfZyu2Bs8NtlwhkpqTgEgD1p1l/rAaOaL/lffv/fUPjmOoMVIHvYs20L1owNFHjBtxVO6MyZlmdOq2tgziK1B3r9gT0hoE9X5a2JUYYy7NVLdU1ao4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762637403; c=relaxed/simple;
	bh=HQAdEFAAKfC7LoXfuDJYaPVo/CwjpPXwX3mxFGFAp6M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XnV3thndfDkhq5z1yo6faXR8GZcffgyqvIOYEr+BNMTDjkPXtZRVwdEEQD3TB+KIHVO3ZNvhC8QmUQT1NMlBskSOMnIxTRBIbxwOuBMA4UNmvGl18amg8kuZIjC0FPwR7b84VxWHmw7F01jN33XV49gYaYRpd7x5eCuLCK0+sKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=MNvwIzka; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=w7b2hVnG; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 694AD1D0012F;
	Sat,  8 Nov 2025 16:29:58 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Sat, 08 Nov 2025 16:29:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1762637398; x=1762723798; bh=JjpgHJdB/9V47pLWIPa0Z
	Ar596J1YfgHVxJQNaWOg5Y=; b=MNvwIzkaYpWpp4yQ0bnP7Pz4j9m8v45FyGgjq
	f6P1hm9Dh9jvlOiX4JJ+6VmHUGwR90+9Q2TQOV01f9tDFiBsGiaXGS2kIDGGNLhj
	huYlKG5Q3xSfNlYZlzcYzybJkDOmAEKEqD6nfj8wfaWcpro9f6wZPWWgdsPWSRyb
	tSNyF5iQwiN35yqQFjwLovInVwgMo+H8LcgrbDcfFNlMrCx2xyAFyo12ESKq/Dfq
	mBgI9dggwrCoGn78/awGX588d/X3fH9QoEDA1bCVtwNd6AInboLpHno6uPTYzUGx
	OlE5SsZA18U3ZEvWHXRGa6S3PcrISGfuGRedfjSep4/8yZpmw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1762637398; x=1762723798; bh=JjpgHJdB/9V47pLWIPa0ZAr596J1YfgHVxJ
	QNaWOg5Y=; b=w7b2hVnGqwzV5Gxc0D8c+aI7zYvgVKt3FAQXCqu1iZTk12zETfu
	Ba7+aYIn9KQxfmDNj0i9h1ogVDuZ17XnuTxDep7O7W9fYIRoR+Kr1QB9iZ+8g2Bn
	mPa4a2wVpMUkGpv2N551o3gEh7B176TZc62gWHCk4wjdSWqqxNswSIPGDGIDHlRq
	o1p9lreMjqpgvyPG3m0snA0otoDcFQKeYeIDOYz0ktaqN48Jhh9L+XVMUYvpIdnC
	uQJaN4sSWEoojp/vh4bNmL0OuGRF4bn88svqAZqE8IB7eXx4YKEQVPk+N2u8cE9V
	Nhuo9/v2jGIb3dZEUBfStIx2ZBe6THn2qAQ==
X-ME-Sender: <xms:VbYPaaitBsa0ITtSq7GU0qRUOmzWgKGNNNjUkyB9C8wwFa-C4tsM0A>
    <xme:VbYPaeshLg8X4C1z5gg7C9xV5iO44i5xtL2KTn9lvc5DXte7vHhXbWEw8oWhewGWS
    7tzoHSyhRhA4lS2yP406m9fr1yba5pfkMrJBisNsISITBIpshc1>
X-ME-Received: <xmr:VbYPab7thEBctESX-JwAUmQnZ9zfjIuz1rQAK3AQlhg1f00jfqTRJZebXTEqFPTzYc0qTwQg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduleefiedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpeetlhgvgicuhghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigs
    ohhtrdhorhhgqeenucggtffrrghtthgvrhhnpedvvdffueevtdfgkedvhffffeegteelge
    efieehteegueeifffhhffhteffleetvdenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpegrlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtg
    hpthhtohepiedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepughmrghtlhgrtghk
    sehgohhoghhlvgdrtghomhdprhgtphhtthhopegrlhgvgiesshhhrgiisghothdrohhrgh
    dprhgtphhtthhopegrlhgvgidrfihilhhlihgrmhhsohhnsehnvhhiughirgdrtghomhdp
    rhgtphhtthhopehjghhgsehnvhhiughirgdrtghomhdprhgtphhtthhopegrmhgrshhtrh
    hosehfsgdrtghomhdprhgtphhtthhopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:VbYPaaNdR7lp0klyjaHhMeKgqRQBO-xzsrHzKszQzYdtkNn-aWvExA>
    <xmx:VbYPaZsfPRSq1p9AKl_vNvq3i1r3nimAfoKvvJz6ZWoiv0dTqtyh7g>
    <xmx:VbYPadbVf6RkO3aD6eC6M2JJOoow_qnddzs300n-9vnFVtVq1-SFlQ>
    <xmx:VbYPabzG3KfQD31lZhUjkgID1kYLRjWDOPf35Bm06WttGjYthKzCDg>
    <xmx:VrYPabSCVSv6xR3QrEsJYoFunSPlKOhi6UP8Zb4jNTAqnztdB1mDo5hT>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 8 Nov 2025 16:29:57 -0500 (EST)
From: Alex Williamson <alex@shazbot.org>
To: dmatlack@google.com,
	alex@shazbot.org
Cc: Alex Williamson <alex.williamson@nvidia.com>,
	jgg@nvidia.com,
	amastro@fb.com,
	kvm@vger.kernel.org
Subject: [PATCH] vfio: selftests: Incorporate IOVA range info
Date: Sat,  8 Nov 2025 14:29:49 -0700
Message-ID: <20251108212954.26477-1-alex@shazbot.org>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alex Williamson <alex.williamson@nvidia.com>

Not all IOMMUs support the same virtual address width as the processor,
for instance older Intel consumer platforms only support 39-bits of
IOMMU address space.  On such platforms, using the virtual address as
the IOVA and mappings at the top of the address space both fail.

VFIO and IOMMUFD have facilities for retrieving valid IOVA ranges,
VFIO_IOMMU_TYPE1_INFO_CAP_IOVA_RANGE and IOMMU_IOAS_IOVA_RANGES,
respectively.  These provide compatible arrays of ranges from which
we can construct a simple allocator and record the maximum supported
IOVA address.

Use this new allocator in place of reusing the virtual address, and
incorporate the maximum supported IOVA into the limit testing.  This
latter change doesn't test quite the same absolute end-of-address space
behavior but still seems to have some value.  Testing for overflow is
skipped when a reduced address space is supported as the desired errno
is not generated.

Signed-off-by: Alex Williamson <alex.williamson@nvidia.com>
---

This happened upon another interesting vfio-compat difference for
IOMMUFD, native type1 returns the correct set of IOVA ranges after
VFIO_SET_IOMMU, vfio-compat requires the next step of calling
VFIO_GROUP_GET_DEVICE_FD to attach the device to the IOAS.  If
checked prior to this, the IOVA range is reported as the full
64-bit address space.  ISTR this is known, but it's sufficiently
subtle to make note of again.

 .../selftests/vfio/lib/include/vfio_util.h    |  10 ++
 .../selftests/vfio/lib/vfio_pci_device.c      | 134 ++++++++++++++++++
 .../selftests/vfio/vfio_dma_mapping_test.c    |   7 +-
 .../selftests/vfio/vfio_pci_driver_test.c     |   2 +-
 4 files changed, 150 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/include/vfio_util.h b/tools/testing/selftests/vfio/lib/include/vfio_util.h
index 240409bf5f8a..6ee7748c2a06 100644
--- a/tools/testing/selftests/vfio/lib/include/vfio_util.h
+++ b/tools/testing/selftests/vfio/lib/include/vfio_util.h
@@ -10,6 +10,8 @@
 
 #include "../../../kselftest.h"
 
+#define ALIGN(x, a)	(((x) + (a - 1)) & (~((a) - 1)))
+
 #define VFIO_LOG_AND_EXIT(...) do {		\
 	fprintf(stderr, "  " __VA_ARGS__);	\
 	fprintf(stderr, "\n");			\
@@ -183,6 +185,12 @@ struct vfio_pci_device {
 	int msi_eventfds[PCI_MSIX_FLAGS_QSIZE + 1];
 
 	struct vfio_pci_driver driver;
+
+	int nr_iova_ranges;
+	struct vfio_iova_range *iova_ranges;
+	int iova_range_idx;
+	iova_t iova_next;
+	iova_t iova_max;
 };
 
 /*
@@ -206,6 +214,8 @@ struct vfio_pci_device *vfio_pci_device_init(const char *bdf, const char *iommu_
 void vfio_pci_device_cleanup(struct vfio_pci_device *device);
 void vfio_pci_device_reset(struct vfio_pci_device *device);
 
+iova_t vfio_pci_get_next_iova(struct vfio_pci_device *device, size_t size);
+
 int __vfio_pci_dma_map(struct vfio_pci_device *device,
 		       struct vfio_dma_region *region);
 int __vfio_pci_dma_unmap(struct vfio_pci_device *device,
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index a381fd253aa7..295a00084880 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -14,6 +14,7 @@
 #include <uapi/linux/types.h>
 #include <linux/limits.h>
 #include <linux/mman.h>
+#include <linux/overflow.h>
 #include <linux/types.h>
 #include <linux/vfio.h>
 #include <linux/iommufd.h>
@@ -386,10 +387,66 @@ static void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf
 	ioctl_assert(device->group_fd, VFIO_GROUP_SET_CONTAINER, &device->container_fd);
 }
 
+iova_t vfio_pci_get_next_iova(struct vfio_pci_device *device, size_t size)
+{
+	int idx = device->iova_range_idx;
+	struct vfio_iova_range *range = &device->iova_ranges[idx];
+
+	VFIO_ASSERT_LT(idx, device->nr_iova_ranges, "IOVA allocate out of space\n");
+	VFIO_ASSERT_GT(size, 0, "Invalid size arg, zero\n");
+	VFIO_ASSERT_EQ(size & (size - 1), 0, "Invalid size arg, non-power-of-2\n");
+
+	for (;;) {
+		iova_t iova, end;
+
+		iova = ALIGN(device->iova_next, size);
+
+		if (iova < device->iova_next || iova > range->end ||
+		    check_add_overflow(iova, size - 1, &end) ||
+		    end > range->end) {
+			device->iova_range_idx = ++idx;
+			VFIO_ASSERT_LT(idx, device->nr_iova_ranges,
+				       "Out of ranges for allocation\n");
+			device->iova_next = (++range)->start;
+			continue;
+		}
+
+		if (check_add_overflow(end, (iova_t)1, &device->iova_next) ||
+		    device->iova_next > range->end) {
+			device->iova_range_idx = ++idx;
+			if (idx < device->nr_iova_ranges)
+				device->iova_next = (++range)->start;
+		}
+
+		return iova;
+	}
+}
+
+static void vfio_pci_fill_iova_ranges(struct vfio_pci_device *device,
+				      struct vfio_iova_range *ranges, int nr)
+{
+	int i;
+
+	VFIO_ASSERT_GT(nr, 0, "Empty IOVA ranges\n");
+	device->nr_iova_ranges = nr;
+
+	device->iova_ranges = calloc(nr, sizeof(struct vfio_iova_range));
+	VFIO_ASSERT_NOT_NULL(device->iova_ranges);
+	memcpy(device->iova_ranges, ranges, nr * sizeof(struct vfio_iova_range));
+
+	device->iova_next = device->iova_ranges[0].start;
+
+	for (i = 0; i < device->nr_iova_ranges; i++) {
+		if (device->iova_ranges[i].end > device->iova_max)
+			device->iova_max = device->iova_ranges[i].end;
+	}
+}
+
 static void vfio_pci_container_setup(struct vfio_pci_device *device, const char *bdf)
 {
 	unsigned long iommu_type = device->iommu_mode->iommu_type;
 	const char *path = device->iommu_mode->container_path;
+	struct vfio_iommu_type1_info *iommu_info;
 	int version;
 	int ret;
 
@@ -408,6 +465,51 @@ static void vfio_pci_container_setup(struct vfio_pci_device *device, const char
 
 	device->fd = ioctl(device->group_fd, VFIO_GROUP_GET_DEVICE_FD, bdf);
 	VFIO_ASSERT_GE(device->fd, 0);
+
+	iommu_info = calloc(1, sizeof(*iommu_info));
+	VFIO_ASSERT_NOT_NULL(iommu_info);
+	iommu_info->argsz = sizeof(*iommu_info);
+
+	ioctl_assert(device->container_fd, VFIO_IOMMU_GET_INFO, (void *)iommu_info);
+
+	if ((iommu_info->flags & VFIO_IOMMU_INFO_CAPS) &&
+	    iommu_info->argsz != sizeof(*iommu_info)) {
+		u32 next, info_size = iommu_info->argsz;
+		struct vfio_info_cap_header *hdr;
+		char *ptr;
+
+		iommu_info = realloc(iommu_info, info_size);
+		VFIO_ASSERT_NOT_NULL(iommu_info);
+
+		ioctl_assert(device->container_fd, VFIO_IOMMU_GET_INFO,
+			     (void *)iommu_info);
+		VFIO_ASSERT_EQ(iommu_info->argsz, info_size);
+		VFIO_ASSERT_GT(iommu_info->flags & VFIO_IOMMU_INFO_CAPS, 0);
+		VFIO_ASSERT_GT(iommu_info->cap_offset, 0);
+
+		next = iommu_info->cap_offset;
+		ptr = (char *)iommu_info;
+
+		while (next) {
+			hdr =  (struct vfio_info_cap_header *)(ptr + next);
+			if (hdr->id == VFIO_IOMMU_TYPE1_INFO_CAP_IOVA_RANGE) {
+				VFIO_ASSERT_EQ(hdr->version, 1);
+				break;
+			}
+
+			next = hdr->next;
+		}
+
+		if (next) {
+			struct vfio_iommu_type1_info_cap_iova_range *ranges;
+
+			ranges = (struct vfio_iommu_type1_info_cap_iova_range *)hdr;
+			vfio_pci_fill_iova_ranges(device, ranges->iova_ranges,
+						  ranges->nr_iovas);
+		}
+	}
+
+	free(iommu_info);
 }
 
 static void vfio_pci_device_setup(struct vfio_pci_device *device)
@@ -547,6 +649,10 @@ static void vfio_device_attach_iommufd_pt(int device_fd, u32 pt_id)
 static void vfio_pci_iommufd_setup(struct vfio_pci_device *device, const char *bdf)
 {
 	const char *cdev_path = vfio_pci_get_cdev_path(bdf);
+	struct iommu_ioas_iova_ranges *ioas_ranges;
+	struct vfio_iova_range *iova_ranges;
+	size_t size;
+	int ret, i;
 
 	device->fd = open(cdev_path, O_RDWR);
 	VFIO_ASSERT_GE(device->fd, 0);
@@ -563,6 +669,34 @@ static void vfio_pci_iommufd_setup(struct vfio_pci_device *device, const char *b
 	vfio_device_bind_iommufd(device->fd, device->iommufd);
 	device->ioas_id = iommufd_ioas_alloc(device->iommufd);
 	vfio_device_attach_iommufd_pt(device->fd, device->ioas_id);
+
+	ioas_ranges = calloc(1, sizeof(*ioas_ranges));
+	VFIO_ASSERT_NOT_NULL(ioas_ranges);
+	ioas_ranges->size = sizeof(*ioas_ranges);
+	ioas_ranges->ioas_id = device->ioas_id;
+
+	ret = ioctl(device->iommufd, IOMMU_IOAS_IOVA_RANGES, ioas_ranges);
+
+	VFIO_ASSERT_NE(ret, 0);
+	VFIO_ASSERT_EQ(errno, EMSGSIZE);
+	VFIO_ASSERT_NE(ioas_ranges->num_iovas, 0);
+
+	size = sizeof(*ioas_ranges) + (ioas_ranges->num_iovas *
+				       sizeof(struct iommu_iova_range));
+	ioas_ranges = realloc(ioas_ranges, size);
+	VFIO_ASSERT_NOT_NULL(ioas_ranges);
+
+	ioas_ranges->allowed_iovas = (uintptr_t)(ioas_ranges + 1);
+
+	ioctl_assert(device->iommufd, IOMMU_IOAS_IOVA_RANGES, ioas_ranges);
+
+	VFIO_ASSERT_EQ(sizeof(struct vfio_iova_range),
+		       sizeof(struct iommu_iova_range));
+
+	iova_ranges = (void *)ioas_ranges->allowed_iovas;
+
+	vfio_pci_fill_iova_ranges(device, iova_ranges, ioas_ranges->num_iovas);
+	free(ioas_ranges);
 }
 
 struct vfio_pci_device *vfio_pci_device_init(const char *bdf, const char *iommu_mode)
diff --git a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
index 4f1ea79a200c..d5ab9f84e675 100644
--- a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
+++ b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
@@ -142,7 +142,7 @@ TEST_F(vfio_dma_mapping_test, dma_map_unmap)
 	else
 		ASSERT_NE(region.vaddr, MAP_FAILED);
 
-	region.iova = (u64)region.vaddr;
+	region.iova = vfio_pci_get_next_iova(self->device, size);
 	region.size = size;
 
 	vfio_pci_dma_map(self->device, &region);
@@ -233,7 +233,7 @@ FIXTURE_SETUP(vfio_dma_map_limit_test)
 	ASSERT_NE(region->vaddr, MAP_FAILED);
 
 	/* One page prior to the end of address space */
-	region->iova = ~(iova_t)0 & ~(region_size - 1);
+	region->iova = self->device->iova_max & ~(region_size - 1);
 	region->size = region_size;
 }
 
@@ -276,6 +276,9 @@ TEST_F(vfio_dma_map_limit_test, overflow)
 	struct vfio_dma_region *region = &self->region;
 	int rc;
 
+	if (self->device->iova_max != UINT64_MAX)
+		SKIP(return, "IOMMU address space insufficient for overflow test\n");
+
 	region->size = self->mmap_size;
 
 	rc = __vfio_pci_dma_map(self->device, region);
diff --git a/tools/testing/selftests/vfio/vfio_pci_driver_test.c b/tools/testing/selftests/vfio/vfio_pci_driver_test.c
index 2dbd70b7db62..b8ff04bf6c86 100644
--- a/tools/testing/selftests/vfio/vfio_pci_driver_test.c
+++ b/tools/testing/selftests/vfio/vfio_pci_driver_test.c
@@ -29,7 +29,7 @@ static void region_setup(struct vfio_pci_device *device,
 	VFIO_ASSERT_NE(vaddr, MAP_FAILED);
 
 	region->vaddr = vaddr;
-	region->iova = (u64)vaddr;
+	region->iova = vfio_pci_get_next_iova(self->device, size);
 	region->size = size;
 
 	vfio_pci_dma_map(device, region);
-- 
2.51.1


