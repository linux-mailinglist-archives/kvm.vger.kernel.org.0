Return-Path: <kvm+bounces-47939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F0292AC7803
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 07:45:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88DEFA42BA6
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 05:44:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E93D625D1FC;
	Thu, 29 May 2025 05:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YxSnAp9X"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9559825C81E;
	Thu, 29 May 2025 05:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748497351; cv=none; b=dE/ew3wMZp0w7wgEAzIgh7Eky0Byn967wQiDrEzIZy7sX9cEw8jMVVL+p2gLLkIfX/a+WF64ffFew5p68rnezH7Vk1loylQNvFILsyn/RDRObRAYzXLpBCyp3TqhNrVp8kZfsnZviCCo8LYXUcRhTNxZNKwZB7k0jqyjLPE/xaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748497351; c=relaxed/simple;
	bh=dc9UGJ2UOu8eBX3b96rS/6oZiGutVnEA2gyyRmtg9bU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Hod8y7PgLy2+jFsdgHyzf1usya1D/8vJCAyE/aDElQHkfulX1XAonc8v5qI4y1SPZSh9wVy33kmNkTFVxPHS25919WMy5zznN7DnmQ7b1FhDZzo1ZGeO6p+/OJz//8+myfLtPSF9hC8Z7uzX16yA/gM8NHlW8XCpCk9zO6vduRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YxSnAp9X; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748497350; x=1780033350;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dc9UGJ2UOu8eBX3b96rS/6oZiGutVnEA2gyyRmtg9bU=;
  b=YxSnAp9X5lA3Mf+9OJjz7aF7el5jxX5Pll6FPmpux5xspl7qskYuxfbP
   oeV3ZZlo6Bvnw7meoT+O8OexlceMhC5C8tKlgc5JDuL0vzYuzx5d6ExA5
   xi++EXymgZegUOBvtew6KCOMa+6HViTsNSTTn6C8c/nZvwojx4+GGC96o
   26l7PMCUmucCOkcxy/k34JKUmLxBCRzgqMEhJRi29I4C/5tTgxj1RwJuO
   +tVHruYZRzXIa7SEhGHmoDTyvCadVzQ/z3YlAD/aJJxqejbK858NZSEeS
   gkWCVeVoqNPcY3r9hrld6PmZCNqC1N/LOSbOPluHAOVyyAww9oJmJ+Hjr
   g==;
X-CSE-ConnectionGUID: P3FMu/plSXGdfFaMJ4M+vQ==
X-CSE-MsgGUID: zuFI7IRFSKC2/OBro/55/A==
X-IronPort-AV: E=McAfee;i="6700,10204,11447"; a="67963010"
X-IronPort-AV: E=Sophos;i="6.15,323,1739865600"; 
   d="scan'208";a="67963010"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 22:42:30 -0700
X-CSE-ConnectionGUID: 5Xn1NSYcQ3CI5iCeaC7oJA==
X-CSE-MsgGUID: FK39mpxeSamJZbUyKZEQJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,323,1739865600"; 
   d="scan'208";a="144443332"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by fmviesa009.fm.intel.com with ESMTP; 28 May 2025 22:42:23 -0700
From: Xu Yilun <yilun.xu@linux.intel.com>
To: kvm@vger.kernel.org,
	sumit.semwal@linaro.org,
	christian.koenig@amd.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	dan.j.williams@intel.com,
	aik@amd.com,
	linux-coco@lists.linux.dev
Cc: dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	vivek.kasireddy@intel.com,
	yilun.xu@intel.com,
	yilun.xu@linux.intel.com,
	linux-kernel@vger.kernel.org,
	lukas@wunner.de,
	yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch,
	leon@kernel.org,
	baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com,
	tao1.su@intel.com,
	linux-pci@vger.kernel.org,
	zhiw@nvidia.com,
	simona.vetter@ffwll.ch,
	shameerali.kolothum.thodi@huawei.com,
	aneesh.kumar@kernel.org,
	iommu@lists.linux.dev,
	kevin.tian@intel.com
Subject: [RFC PATCH 08/30] KVM: x86/mmu: Handle page fault for vfio_dmabuf backed MMIO
Date: Thu, 29 May 2025 13:34:51 +0800
Message-Id: <20250529053513.1592088-9-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
References: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for resolving page faults on vfio_dmabuf backed MMIO. Now
only support setup KVM MMU mapping on shared roots, i.e. vfio_dmabuf
works for shared assigned devices.

Further work is to support private MMIO for private assigned
devices (known as TDI in TDISP spec).

Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
---
 arch/x86/kvm/mmu/mmu.c   | 16 ++++++++++++++++
 include/linux/kvm_host.h |  5 +++++
 2 files changed, 21 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 63bb77ee1bb1..40d33bd6b532 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4523,6 +4523,22 @@ static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
 	if (fault->is_private)
 		return kvm_mmu_faultin_pfn_private(vcpu, fault);
 
+	/* vfio_dmabuf slot is also applicable for shared mapping */
+	if (kvm_slot_is_vfio_dmabuf(fault->slot)) {
+		int max_order, r;
+
+		r = kvm_vfio_dmabuf_get_pfn(vcpu->kvm, fault->slot, fault->gfn,
+					    &fault->pfn, &max_order);
+		if (r)
+			return r;
+
+		fault->max_level = min(kvm_max_level_for_order(max_order),
+				       fault->max_level);
+		fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
+
+		return RET_PF_CONTINUE;
+	}
+
 	foll |= FOLL_NOWAIT;
 	fault->pfn = __kvm_faultin_pfn(fault->slot, fault->gfn, foll,
 				       &fault->map_writable, &fault->refcounted_page);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d16f47c3d008..b850d3cff83c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -623,6 +623,11 @@ static inline bool kvm_slot_can_be_private(const struct kvm_memory_slot *slot)
 	return slot && (slot->flags & KVM_MEM_GUEST_MEMFD);
 }
 
+static inline bool kvm_slot_is_vfio_dmabuf(const struct kvm_memory_slot *slot)
+{
+	return slot && (slot->flags & KVM_MEM_VFIO_DMABUF);
+}
+
 static inline bool kvm_slot_dirty_track_enabled(const struct kvm_memory_slot *slot)
 {
 	return slot->flags & KVM_MEM_LOG_DIRTY_PAGES;
-- 
2.25.1


