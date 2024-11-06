Return-Path: <kvm+bounces-30975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0BCE9BF20D
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 16:47:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 200D11C25801
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 15:47:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E56E91E04BF;
	Wed,  6 Nov 2024 15:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T3gjiwVX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0304E204F76
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 15:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730907972; cv=none; b=IRKlVEPweDkxO3gy2qrKhIcL4gOEo4Ahoa4JDXPXP4s9VEbEp0VaXjHfoj30SpO0qMxBnOvEfyzVv+dwhcnoMdvUE5GdN3teoY5R5jPpc+5QKXMN5WF0Zpu/8ss/LfOf8ZC+ts44DyqKriuNygfbY3d0ISDN/ttHdlyEHa3uCS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730907972; c=relaxed/simple;
	bh=ok1bm6oJEXsjE5A1pKLAnqVemj1Frxd8q1RIPh1PQMQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=e0KIQNqVO/lzrIZnG2nQKwZ92+kjPApndRHhWH5WQtRecjQk0/ExHnj7siFpKNrLn8PnD/sjx3L0qX1o6qbdsClrbQA7Gv02E4urqXpK/8C3D7vNBZOc3eCy6fvR0zS436M+cu4v231zHvpBe1iFypXor6TPnhhwymiohzUh0G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T3gjiwVX; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730907971; x=1762443971;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ok1bm6oJEXsjE5A1pKLAnqVemj1Frxd8q1RIPh1PQMQ=;
  b=T3gjiwVXlRsdQuy5t9wOsR2lVMgjn48czVxiILU0mjs5qW8nc3aBzZWp
   RFRAaKLKpDHo4e+gSA7TJGjp7TSGY8aFOeFORzFgZi4l7P8XlX2JRrn2O
   xiTeyZ7BEq0IwcTEWOmpsY70UZp0IX9bUj5uGYtObo4msoL9N2oJJ1A+k
   IJyBCz8C15E5fm8gkGvDJYLLC7l1jJaREQ568etCO4rjQG5puxOzaT1cC
   nUAA1XjR4J9IDyENk2LTCV6M4ENNuOYvKWsWz+k5RvUtEOv6oozieIRav
   c7NqnO+EENZsL7CtCxc7Ai/QFiBezZx+AbHy/GhL7OwptFgZqixINByYd
   Q==;
X-CSE-ConnectionGUID: fgZcVhJNTlmc3Y39VX+HRQ==
X-CSE-MsgGUID: X+FgiHcdTzaCQ4JYwjhJAA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="48174209"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="48174209"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 07:46:08 -0800
X-CSE-ConnectionGUID: cYGEY023RCSKPzn8x1L/uA==
X-CSE-MsgGUID: ZBTrgxtLSA+YuN2W7eNH1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,263,1725346800"; 
   d="scan'208";a="89468110"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa005.jf.intel.com with ESMTP; 06 Nov 2024 07:46:07 -0800
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
	vasant.hegde@amd.com,
	willy@infradead.org
Subject: [PATCH v5 00/13] Make set_dev_pasid op supporting domain replacement
Date: Wed,  6 Nov 2024 07:45:53 -0800
Message-Id: <20241106154606.9564-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This splits the preparation works of the iommu and the Intel iommu driver
out from the iommufd pasid attach/replace series. [1]

To support domain replacement, the definition of the set_dev_pasid op
needs to be enhanced. Meanwhile, the existing set_dev_pasid callbacks
should be extended as well to suit the new definition.

This series first passes the old domain to the set_dev_pasid op, and prepares
the Intel iommu set_dev_pasid callbacks (paging domain, identity domain, and
sva domain) for the new definition, add the missing set_dev_pasid callback
for the nested domain, makes ARM SMMUv3 set_dev_pasid op to suit the new
set_dev_pasid op definition, and in the end, claims the set_dev_pasid op support
domain replacement. The AMD set_dev_pasid callback is extended to fail if the
caller tries to do the domain replacement to meet the new definition of
set_dev_pasid op. AMD iommu driver would support it later per Vasant [2].

[1] https://lore.kernel.org/linux-iommu/20240412081516.31168-1-yi.l.liu@intel.com/
[2] https://lore.kernel.org/linux-iommu/fa9c4fc3-9365-465e-8926-b4d2d6361b9c@amd.com/

v5:
 - Drop the nonsense function description in patch 02 of v4 (Kevin, Baulu)
 - Add the error message as the setup helpers in replace helpers (Kevin)
 - Check old domain id with the domain id in pasid entry within the replace helpers.
   Along with it, iommu_domain_did() is added (Kevin, Baolu)
 - Merge patch 05 and 09 of v4 and name the patch as consolidating the dev_pasid_info
   add/remove (Baolu)
 - Drop patch 10 of v4, hence patch 09 of v5 (Baolu, Kevin, Jason)
 - Add r-b tags from Baolu, Kevin, Vasant
 - Rebase on top of Joerg's next tree (75bc266cd1a6)
 
v4: https://lore.kernel.org/linux-iommu/20241104131842.13303-1-yi.l.liu@intel.com/
 - Fix a missing input argument modification in patch 01 (Nicolin)
 - Per Baolu's suggestion, this series does not extend the pasid setup helpers to
   handle domain replacement, instead it adds pasid replace helpers, hence
   drop patch 02 of v3 as it is no longer required in this series.
 - Add a new helper to consolidate the cache flush for the modifications to a
   present pasid entry (the fields other than P and SSADE)   (Baolu)
 - Update the set_dev_pasid op of intel identity domain to handle replacement
 - Consolidate the dev_pasid_info code of intel_svm_set_dev_pasid()
 - Add a separate set_dev_pasid callback for nested domain instead of sharing
   intel_iommu_set_dev_pasid()  (Baolu)
 - Drop patch 05 of v3 as Baolu has another patch that touches it.

v3: https://lore.kernel.org/linux-iommu/20241018055402.23277-1-yi.l.liu@intel.com/
 - Add Kevin and Jason's r-b to patch 01, 02, 04, 05 and 06 of v2
 - Add back the patch 03 of v1 to make the pasid setup helpers do all the pasid entry
   modification, hence the set_dev_pasid path is really rollback-less, which is spotted
   by Baolu.
 - Rename prepare_domain_attach_device() (Baolu)
 - Use unsigned int instead of u32 for flags (Baolu)
 - Remove a stale comment in arm_smmu_set_pasid (Will)

v2: https://lore.kernel.org/linux-iommu/20240912130427.10119-1-yi.l.liu@intel.com/
 - Make ARM SMMUv3 set_dev_pasid op support domain replacement (Jason)
 - Drop patch 03 of v1 (Kevin)
 - Multiple tweaks in VT-d driver (Kevin)

v1: https://lore.kernel.org/linux-iommu/20240628085538.47049-1-yi.l.liu@intel.com/

Regards,
	Yi Liu

Jason Gunthorpe (1):
  iommu/arm-smmu-v3: Make set_dev_pasid() op support replace

Yi Liu (12):
  iommu: Pass old domain to set_dev_pasid op
  iommu/vt-d: Add a helper to flush cache for updating present pasid
    entry
  iommu/vt-d: Refactor the pasid setup helpers
  iommu/vt-d: Add pasid replace helpers
  iommu/vt-d: Consolidate the struct dev_pasid_info add/remove
  iommu/vt-d: Add iommu_domain_did() to get did
  iommu/vt-d: Make intel_iommu_set_dev_pasid() to handle domain
    replacement
  iommu/vt-d: Limit intel_iommu_set_dev_pasid() for paging domain
  iommu/vt-d: Make intel_svm_set_dev_pasid() support domain replacement
  iommu/vt-d: Make identity_domain_set_dev_pasid() to handle domain
    replacement
  iommu/vt-d: Add set_dev_pasid callback for nested domain
  iommu: Make set_dev_pasid op support domain replacement

 drivers/iommu/amd/amd_iommu.h                 |   3 +-
 drivers/iommu/amd/pasid.c                     |   6 +-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |   5 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  12 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   2 +-
 drivers/iommu/intel/iommu.c                   | 174 +++++---
 drivers/iommu/intel/iommu.h                   |  34 ++
 drivers/iommu/intel/nested.c                  |  50 +++
 drivers/iommu/intel/pasid.c                   | 381 ++++++++++++++----
 drivers/iommu/intel/pasid.h                   |  22 +-
 drivers/iommu/intel/svm.c                     |  36 +-
 drivers/iommu/iommu.c                         |   3 +-
 include/linux/iommu.h                         |   5 +-
 13 files changed, 566 insertions(+), 167 deletions(-)

-- 
2.34.1


