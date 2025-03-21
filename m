Return-Path: <kvm+bounces-41701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EDE0A6C1FB
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 19:01:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B245D3B78AC
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 18:01:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2156822F166;
	Fri, 21 Mar 2025 18:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b9VTe5KD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9455222B8D7
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 18:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742580108; cv=none; b=KlRVuEjxNKqdNIaMI0vveJ77/pB9xVZBNuvXfN50Bd4pa6ybpBCTDnjIsg3DkN6On/IomKZsr6QVdgsJXoj/Ogq7Lxuzlpi8k38Q8hW9o4GoN7oKqv41c+HJCxQEfSLzkHHyP9UgDnIExTUT9vBxPQAaFCauJ8AMo8lK+gmEgFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742580108; c=relaxed/simple;
	bh=b2QY8/xiGqneAQFzgGZpoe/ISXWf+zirqa7nta+E6pk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=g58nYD4rL78zW0JydjBDHfZ3SC47YnM6nFf/Z+7wE3UItev2qNhbssx5DrvD2j0bcnHxdnzrD/AjF7QNxl5CAdoZOefVVKBU2fxdVafwFC4rOde07J/4mtu3Tn6ZNmjxR8zJqGRw8+oUcWlSCWI3+V/tn2B+qave274Yf3mk3JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b9VTe5KD; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742580107; x=1774116107;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=b2QY8/xiGqneAQFzgGZpoe/ISXWf+zirqa7nta+E6pk=;
  b=b9VTe5KDXSEfCgUWQ+gmBBbG/nj3Lc/zEJM4z2DBigdhocFuBbt+QGmk
   DOjh9AKGrHEziogAx0aaeCX6ACE92iCzZrFT6Bj++1je6uisyxGfx984k
   pYBPZKbvW+Qn8Gu+ttBZFevJx+fpmLbsZyMv11Q7MT/2ymUNWkKb9WSZx
   DuGfd1mXqqYfjKJ49euL6E+k8Ef6hHx5t1+p0p2oDfkDirKtdkL/HINtv
   VtJzm0Vw2XEgLn2i8rCxORo+TyY+LSceUx3tJwjrmNH+NQZcnkHLYruZf
   nMCqP5BSJU0YO5DvR+NI+Lby3pUWlhF7wntu6jetloCpbixMMXAzVlhMZ
   w==;
X-CSE-ConnectionGUID: +6SnK1tiSV6NFJfClxr+vw==
X-CSE-MsgGUID: pyIs6ZI9QpqI0oLmTQ219w==
X-IronPort-AV: E=McAfee;i="6700,10204,11380"; a="55234657"
X-IronPort-AV: E=Sophos;i="6.14,265,1736841600"; 
   d="scan'208";a="55234657"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 11:01:45 -0700
X-CSE-ConnectionGUID: ZiRX75bbStKzBNKon1KkwA==
X-CSE-MsgGUID: dBlrIsQVQFmTj5F29SUBvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,265,1736841600"; 
   d="scan'208";a="160694106"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa001.jf.intel.com with ESMTP; 21 Mar 2025 11:01:45 -0700
From: Yi Liu <yi.l.liu@intel.com>
To: alex.williamson@redhat.com
Cc: jgg@nvidia.com,
	yi.l.liu@intel.com,
	kevin.tian@intel.com,
	eric.auger@redhat.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	zhenzhong.duan@intel.com,
	willy@infradead.org,
	zhangfei.gao@linaro.org,
	vasant.hegde@amd.com
Subject: [PATCH v9 0/5] vfio-pci support pasid attach/detach
Date: Fri, 21 Mar 2025 11:01:38 -0700
Message-Id: <20250321180143.8468-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series introduces the PASID attach/detach user APIs (uAPIs) that
allow userspace to attach or detach a device's PASID to or from a specified
IOAS/hwpt. Currently, only the vfio-pci driver is enabled in this series.

Following this update, PASID-capable devices bound to vfio-pci can report
PASID capabilities to userspace and virtual machines (VMs), facilitating
PASID use cases such as Shared Virtual Addressing (SVA). In discussions
about reporting the virtual PASID (vPASID) to VMs [1], it was agreed that
the userspace virtual machine monitor (VMM) will synthesize the vPASID
capability. The VMM must identify a suitable location to insert the vPASID
capability, including handling hidden bits for certain devices. However,
this responsibility lies with userspace and is not the focus of this series.

This series begins by adding helpers for PASID attachment in the vfio core,
then extends the device character device (cdev) attach/detach ioctls to
support PASID attach/detach operations. At the conclusion of this series,
the IOMMU_GET_HW_INFO ioctl is extended to report PCI PASID capabilities
to userspace. Userspace should verify this capability before utilizing any
PASID-related uAPIs provided by VFIO, as agreed in [2]. This series depends
on the iommufd PASID attach/detach series [3].

The complete code is available at [4] and has been tested with a modified
QEMU branch [5].

[1] https://lore.kernel.org/kvm/BN9PR11MB5276318969A212AD0649C7BE8CBE2@BN9PR11MB5276.namprd11.prod.outlook.com/
[2] https://lore.kernel.org/kvm/4f2daf50-a5ad-4599-ab59-bcfc008688d8@intel.com/
[3] https://lore.kernel.org/linux-iommu/20250321171940.7213-1-yi.l.liu@intel.com/
[4] https://github.com/yiliu1765/iommufd/tree/iommufd_pasid
[5] https://github.com/yiliu1765/qemu/tree/wip/zhenzhong/iommufd_nesting_rfcv2-test-pasid

Change log:

v9:
 - Remove unnecessary parentheses in flag check (Nic)
 - Use the MOCK_PASID_WIDTH in the place of 20 is used in patch 05 (Nic)
 - Drop duplicated pci.h include (Nic)

v8: https://lore.kernel.org/kvm/20250313124753.185090-1-yi.l.liu@intel.com/
 - Rebased on top of the latest iommufd series, mainly using the latest
   kAPI for pasid attach

v7: https://lore.kernel.org/kvm/20250216054638.24603-1-yi.l.liu@intel.com/#t
 - Add Alex's and Kevin's r-b on vfio patches
 - Minor tweaks on patch 04 (Kevin)

v6: https://lore.kernel.org/kvm/20241219133534.16422-1-yi.l.liu@intel.com/
 - Drop the vfio_copy_user_data() generalization as it is not totally clear
   what it would cover. (Alex)
 - Reworked the patch 03 of v5 a bit. e.g. lift the pasid_{at|de}tach_ioas op test
   before the second user data copy; make 'if (xend > minsz)' to be 'if (xend)'
   and remove the comment accordingly. This is because we don't generalize
   the user data copy now, so xend is either 0 or non-zero, no need to check
   against minsz.
 - Make the IOMMU_GET_HW_INFO report out_max_pasid_log2 by checking the
   dev->iommu->max_pasids. This is because iommu drivers enables PASID
   as long as it supports. So checking it is enough. Also, it is more friendly
   to non-PCI PASID supports compared with reading the PCI config space to
   check if PASID is enabled.
 - Add selftest coverage for reporting max_pasid_log2 in IOMMU_HW_INFO ioctl.

v5: https://lore.kernel.org/kvm/20241108121742.18889-1-yi.l.liu@intel.com/
 - Fix a wrong return value (Alex)
 - Fix the policy of setting the xend array per flag extension (Alex)
 - A separate patch to generalize the code of copy user data (Alex)

v4: https://lore.kernel.org/kvm/20241104132732.16759-1-yi.l.liu@intel.com/
 - Add acked-by for the ida patch from Matthew
 - Add r-b from Kevin and Jason on patch 01, 02 and 04 of v3
 - Add common code to copy user data for the user struct with new fields
 - Extend the VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT to support pasid, patch 03
   is updated per this change. Hence drop r-b of it. (Kevin, Alex)
 - Add t-b from Zhangfei for patch 4 of v3
 - Nits from Vasant

v3: https://lore.kernel.org/linux-iommu/20240912131729.14951-1-yi.l.liu@intel.com/
 - Misc enhancement on patch 01 of v2 (Alex, Jason)
 - Add Jason's r-b to patch 03 of v2
 - Drop the logic that report PASID via VFIO_DEVICE_FEATURE ioctl
 - Extend IOMMU_GET_HW_INFO to report PASID support (Kevin, Jason, Alex)

v2: https://lore.kernel.org/kvm/20240412082121.33382-1-yi.l.liu@intel.com/
 - Use IDA to track if PASID is attached or not in VFIO. (Jason)
 - Fix the issue of calling pasid_at[de]tach_ioas callback unconditionally (Alex)
 - Fix the wrong data copy in vfio_df_ioctl_pasid_detach_pt() (Zhenzhong)
 - Minor tweaks in comments (Kevin)

v1: https://lore.kernel.org/kvm/20231127063909.129153-1-yi.l.liu@intel.com/
 - Report PASID capability via VFIO_DEVICE_FEATURE (Alex)

rfc: https://lore.kernel.org/linux-iommu/20230926093121.18676-1-yi.l.liu@intel.com/

Regards,
	Yi Liu

Yi Liu (5):
  ida: Add ida_find_first_range()
  vfio-iommufd: Support pasid [at|de]tach for physical VFIO devices
  vfio: VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT support pasid
  iommufd: Extend IOMMU_GET_HW_INFO to report PASID capability
  iommufd/selftest: Add coverage for reporting max_pasid_log2 via
    IOMMU_HW_INFO

 drivers/iommu/iommufd/device.c                | 34 ++++++++-
 drivers/pci/ats.c                             | 33 +++++++++
 drivers/vfio/device_cdev.c                    | 60 +++++++++++++---
 drivers/vfio/iommufd.c                        | 50 +++++++++++++
 drivers/vfio/pci/vfio_pci.c                   |  2 +
 include/linux/idr.h                           | 11 +++
 include/linux/pci-ats.h                       |  3 +
 include/linux/vfio.h                          | 14 ++++
 include/uapi/linux/iommufd.h                  | 14 +++-
 include/uapi/linux/vfio.h                     | 29 +++++---
 lib/idr.c                                     | 67 ++++++++++++++++++
 lib/test_ida.c                                | 70 +++++++++++++++++++
 tools/testing/selftests/iommu/iommufd.c       | 18 +++++
 .../selftests/iommu/iommufd_fail_nth.c        |  3 +-
 tools/testing/selftests/iommu/iommufd_utils.h | 17 +++--
 15 files changed, 400 insertions(+), 25 deletions(-)

-- 
2.34.1


