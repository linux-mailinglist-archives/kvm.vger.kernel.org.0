Return-Path: <kvm+bounces-30531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B5E09BB5E9
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 14:25:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 72DD91C21526
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 13:25:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38688433D1;
	Mon,  4 Nov 2024 13:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TFmWsye/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EA842A9B
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 13:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730726717; cv=none; b=a5adxHU/J+0S59tkcvNyN08aT26Mv4tF3NOHTc6aDlmbj8Q28wxit2ilZmgJm9ga+2UUtqulaMUlNusVGLXqBKHp89ghQqERGf4oZX86mv2Y2dJ+Gh+vOhxNM+KuI0buc1u19v9i16t5FTENc8IT21tcKNZgowJoLx78r3zU8+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730726717; c=relaxed/simple;
	bh=iWPtGVAMoZUj8eqvMYfyIm+HjKmN0BUy+Yn8UBnZF1M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=f5ECXi5aLKUST/UKmiYL/XJXVd9Sv+w5BliTAGUYRQy8U/s9j8GCR7wZKNPiEy194c8sG/L5Kn1F+uBeKPUBDmOh1Xsvbup/Yfs4jNXCtyGE/J4q1WJ0OZ660QnlsYopxPZpjwYNIMXAHt+fig7EIa4Boek4jwdRRHagE59swq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TFmWsye/; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730726716; x=1762262716;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iWPtGVAMoZUj8eqvMYfyIm+HjKmN0BUy+Yn8UBnZF1M=;
  b=TFmWsye/gyNog0/twiZ4jVphDbO02C8T3XALeh3SHuU10FW4E6l6jWHi
   5L3l4PaxCasrU+EAhxp89trqDi/7uWGSGVP35dnTfkeVBddJAjFXrFofJ
   BYid//X49b/MpHkk4A60+n8jZbfJS0LoflbtL0cZFUpRJFwcREAdJqnWJ
   SlzKOfAv7DKOOWyHinOEO8qXb6BHJFoH6VLZRwLLhUjhHrO7ijiP6pnWj
   m9OwIjX6IF/vEc3TR5Tjt3PXXv+cgwobgxdnDh7eNEgA1Jakp9BcR6xiw
   DTUb4NOaNkDOr4xalpJkn4C7/nV+iLJgHZqtDhcHs0M3s4GJglvd/X41E
   w==;
X-CSE-ConnectionGUID: pHREYkpWT62GFsMQgBEBRQ==
X-CSE-MsgGUID: OARnt9+pQQm5dxwBvwt+ew==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="47884019"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="47884019"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 05:25:16 -0800
X-CSE-ConnectionGUID: Oc5jkxhOQRyDPKcAQ4tTuA==
X-CSE-MsgGUID: P/4kaKlASvu4bubGC3mF6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="84100437"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa007.jf.intel.com with ESMTP; 04 Nov 2024 05:25:16 -0800
From: Yi Liu <yi.l.liu@intel.com>
To: joro@8bytes.org,
	jgg@nvidia.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com
Cc: alex.williamson@redhat.com,
	eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev,
	zhenzhong.duan@intel.com,
	vasant.hegde@amd.com
Subject: [PATCH v5 00/12] iommufd support pasid attach/replace
Date: Mon,  4 Nov 2024 05:25:01 -0800
Message-Id: <20241104132513.15890-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

PASID (Process Address Space ID) is a PCIe extension to tag the DMA
transactions out of a physical device, and most modern IOMMU hardware
have supported PASID granular address translation. So a PASID-capable
device can be attached to multiple hwpts (a.k.a. domains), and each
attachment is tagged with a pasid.

This series is based on the preparation series [1] [2], it first adds a
missing iommu API to replace the domain for a pasid. Based on the iommu
pasid attach/ replace/detach APIs, this series adds iommufd APIs for device
drivers to attach/replace/detach pasid to/from hwpt per userspace's request,
and adds selftest to validate the iommufd APIs.

The completed code can be found in the below link [3]. Heads up! The existing
iommufd selftest was broken, there was a fix [4] to it, but not been
upstreamed yet. If want to run the iommufd selftest, please apply that fix.
Sorry for the inconvenience.

[1] https://lore.kernel.org/linux-iommu/20241104131842.13303-1-yi.l.liu@intel.com/
[2] https://lore.kernel.org/linux-iommu/20241104132033.14027-1-yi.l.liu@intel.com/
[3] https://github.com/yiliu1765/iommufd/tree/iommufd_pasid
[4] https://lore.kernel.org/linux-iommu/20240111073213.180020-1-baolu.lu@linux.intel.com/

Change log:

v5:
 - Fix a mistake in patch 02 of v4 (Kevin)
 - Move the iommufd_handle helpers to device.c
 - Add IOMMU_HWPT_ALLOC_PASID check to enforce pasid-compatible domain for pasid
   capable device in iommufd
 - Update the iommufd selftest to use IOMMU_HWPT_ALLOC_PASID

v4: https://lore.kernel.org/linux-iommu/20240912131255.13305-1-yi.l.liu@intel.com/
 - Replace remove_dev_pasid() by supporting set_dev_pasid() for blocking domain (Kevin)
	- This is done by the preparation series "Support attaching PASID to the blocked_domain"
 - Misc tweaks to foil the merging of the iommufd iopf series. Three new patches are added:
	- iommufd: Always pass iommu_attach_handle to iommu core
	- iommufd: Move the iommufd_handle helpers to iommufd_private.h
	- iommufd: Refactor __fault_domain_replace_dev() to be a wrapper of iommu_replace_group_handle()
 - Renmae patch 03 of v3 to be "iommufd: Support pasid attach/replace"
 - Add test case for attaching/replacing iopf-capable hwpt to pasid

v3: https://lore.kernel.org/kvm/20240628090557.50898-1-yi.l.liu@intel.com/
 - Split the set_dev_pasid op enhancements for domain replacement to be a
   separate series "Make set_dev_pasid op supportting domain replacement" [1].
   The below changes are made in the separate series.
   *) set_dev_pasid() callback should keep the old config if failed to attach to
      a domain. This simplifies the caller a lot as caller does not need to attach
      it back to old domain explicitly. This also avoids some corner cases in which
      the core may do duplicated domain attachment as described in below link (Jason)
      https://lore.kernel.org/linux-iommu/BN9PR11MB52768C98314A95AFCD2FA6478C0F2@BN9PR11MB5276.namprd11.prod.outlook.com/
   *) Drop patch 10 of v2 as it's a bug fix and can be submitted separately (Kevin)
   *) Rebase on top of Baolu's domain_alloc_paging refactor series (Jason)
 - Drop the attach_data which includes attach_fn and pasid, insteadly passing the
   pasid through the device attach path. (Jason)
 - Add a pasid-num-bits property to mock dev to make pasid selftest work (Kevin)

v2: https://lore.kernel.org/linux-iommu/20240412081516.31168-1-yi.l.liu@intel.com/
 - Domain replace for pasid should be handled in set_dev_pasid() callbacks
   instead of remove_dev_pasid and call set_dev_pasid afteward in iommu
   layer (Jason)
 - Make xarray operations more self-contained in iommufd pasid attach/replace/detach
   (Jason)
 - Tweak the dev_iommu_get_max_pasids() to allow iommu driver to populate the
   max_pasids. This makes the iommufd selftest simpler to meet the max_pasids
   check in iommu_attach_device_pasid()  (Jason)

v1: https://lore.kernel.org/kvm/20231127063428.127436-1-yi.l.liu@intel.com/#r
 - Implemnet iommu_replace_device_pasid() to fall back to the original domain
   if this replacement failed (Kevin)
 - Add check in do_attach() to check corressponding attach_fn per the pasid value.

rfc: https://lore.kernel.org/linux-iommu/20230926092651.17041-1-yi.l.liu@intel.com/

Regards,
	Yi Liu

Yi Liu (12):
  iommu: Introduce a replace API for device pasid
  iommufd: Refactor __fault_domain_replace_dev() to be a wrapper of
    iommu_replace_group_handle()
  iommufd: Move the iommufd_handle helpers to device.c
  iommufd: Always pass iommu_attach_handle to iommu core
  iommufd: Pass pasid through the device attach/replace path
  iommufd: Support pasid attach/replace
  iommufd: Allocate auto_domain with IOMMU_HWPT_ALLOC_PASID flag if
    device is PASID-capable
  iommufd: Enforce pasid compatible domain for PASID-capable device
  iommufd/selftest: Add set_dev_pasid in mock iommu
  iommufd/selftest: Add a helper to get test device
  iommufd/selftest: Add test ops to test pasid attach/detach
  iommufd/selftest: Add coverage for iommufd pasid attach/detach

 drivers/iommu/intel/iommu.c                   |   6 +-
 drivers/iommu/iommu-priv.h                    |   4 +
 drivers/iommu/iommu.c                         |  90 +++++-
 drivers/iommu/iommufd/Makefile                |   1 +
 drivers/iommu/iommufd/device.c                | 111 +++++--
 drivers/iommu/iommufd/fault.c                 |  88 ++----
 drivers/iommu/iommufd/hw_pagetable.c          |  12 +-
 drivers/iommu/iommufd/iommufd_private.h       |  81 ++++-
 drivers/iommu/iommufd/iommufd_test.h          |  31 ++
 drivers/iommu/iommufd/pasid.c                 | 157 ++++++++++
 drivers/iommu/iommufd/selftest.c              | 210 ++++++++++++-
 include/linux/iommufd.h                       |   7 +
 tools/testing/selftests/iommu/iommufd.c       | 277 ++++++++++++++++++
 .../selftests/iommu/iommufd_fail_nth.c        |  35 ++-
 tools/testing/selftests/iommu/iommufd_utils.h |  78 +++++
 15 files changed, 1054 insertions(+), 134 deletions(-)
 create mode 100644 drivers/iommu/iommufd/pasid.c

-- 
2.34.1


