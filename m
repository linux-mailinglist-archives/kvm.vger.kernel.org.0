Return-Path: <kvm+bounces-14163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 855608A02E5
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 00:10:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3CBB028724F
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 22:10:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB22B19DF65;
	Wed, 10 Apr 2024 22:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VusY2BjZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B900194C64;
	Wed, 10 Apr 2024 22:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712786880; cv=none; b=WtetQgsnaJWaDJduKrWgma0eQN5AZbD3BZyVqS7gOk9RHSC+xJXDsnnpPhNcVTjuWc8H0jfH3dw6XlQ1ymy5N2aSExM7qW18Xm1wNvu9lTZgjp8VA0TlgL2JP6Qp8Y7HZzUolIoCjjJjmkasx1KURCB81q35v30oFlpGZbr86yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712786880; c=relaxed/simple;
	bh=GIu4IpEu0OR4p8boNWIAIqwgqflasHfUe3Ym3NmIEMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQ26O6l3CmtoQwiy/4JXZiUimFQGP9HvpWxIljJ0PIVV+6nOXK1EvvXRzz/bexyiyetly8cvOYT5uSiBoRVeiU7URCOhBipwRcsUWF0OW6W9GIRH7u1TRdRxJvm7K+raxIae4LbFwEvR6YDAN7CHY5zA8FVNbZTl+BUk1MCc+2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VusY2BjZ; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712786879; x=1744322879;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GIu4IpEu0OR4p8boNWIAIqwgqflasHfUe3Ym3NmIEMM=;
  b=VusY2BjZT8XIhSPVtJn9TdLFGbRPQRydsqYYVf8Hc/lB9jYXJ+2z0ZC7
   ZWMyz2jjtB6pL2D45EetufBX6BWNcQUQpJ4nfREJ19UvdIZCPz6dNMfwi
   Eg+AYsuphKDXVAFtmpDbN1xL308qo1F5sMlJQtgD+FVkH1EQJJrhl12q4
   Ew0+hOcoSzb2gKir1o1Kjft7CiO32ynU3kugNi/VdYfciVXGv9iY5EnGZ
   7Gh5hOXf5Mjp665DrQgNgKKu7FdE/pHFNxgLFLe97hJOa0bNhocFfYeSG
   UGR+M5A87F65R9USXJj2lY9uwCbCeEdaquyK0tVcIpt40gC19ndBUQP77
   Q==;
X-CSE-ConnectionGUID: FnnMdapzQpS08QyJtjFrOA==
X-CSE-MsgGUID: 8EiHSVjHQ52PCrOjlDvVhg==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="8041142"
X-IronPort-AV: E=Sophos;i="6.07,191,1708416000"; 
   d="scan'208";a="8041142"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 15:07:57 -0700
X-CSE-ConnectionGUID: VJ9idWvQQhu6SaChP5XnSw==
X-CSE-MsgGUID: l1Ty1mbXRF6bFVTrL6gurA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,191,1708416000"; 
   d="scan'208";a="25476319"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 15:07:56 -0700
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	David Matlack <dmatlack@google.com>,
	Federico Parola <federico.parola@polito.it>,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH v2 07/10] KVM: x86: Always populate L1 GPA for KVM_MAP_MEMORY
Date: Wed, 10 Apr 2024 15:07:33 -0700
Message-ID: <2f1de1b7b6512280fae4ac05e77ced80a585971b.1712785629.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <cover.1712785629.git.isaku.yamahata@intel.com>
References: <cover.1712785629.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Forcibly switch vCPU mode out from guest mode and SMM mode before calling
KVM page fault handler for KVM_MAP_MEMORY.

KVM_MAP_MEMORY populates guest memory with guest physical address (GPA).
If the vCPU is in guest mode, it populates with L2 GPA.  If vCPU is in SMM
mode, it populates the SMM address pace.  The API would be difficult to use
as such.  Change vCPU MMU mode around populating the guest memory to always
populate with L1 GPA.

There are several options to populate L1 GPA irrelevant to vCPU mode.
- Switch vCPU MMU only: This patch.
  Pros: Concise implementation.
  Cons: Heavily dependent on the KVM MMU implementation.
- Use kvm_x86_nested_ops.get/set_state() to switch to/from guest mode.
  Use __get/set_sregs2() to switch to/from SMM mode.
  Pros: straightforward.
  Cons: This may cause unintended side effects.
- Refactor KVM page fault handler not to pass vCPU. Pass around necessary
  parameters and struct kvm.
  Pros: The end result will have clearly no side effects.
  Cons: This will require big refactoring.
- Return error on guest mode or SMM mode:  Without this patch.
  Pros: No additional patch.
  Cons: Difficult to use.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v2:
- Newly added.
---
 arch/x86/kvm/x86.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2c765de3531e..8ba9c1720ac9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5871,8 +5871,10 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 int kvm_arch_vcpu_map_memory(struct kvm_vcpu *vcpu,
 			     struct kvm_memory_mapping *mapping)
 {
+	struct kvm_mmu *mmu = NULL, *walk_mmu = NULL;
 	u64 end, error_code = 0;
 	u8 level = PG_LEVEL_4K;
+	bool is_smm;
 	int r;
 
 	/*
@@ -5882,18 +5884,40 @@ int kvm_arch_vcpu_map_memory(struct kvm_vcpu *vcpu,
 	if (!tdp_enabled)
 		return -EOPNOTSUPP;
 
+	/* Force to use L1 GPA despite of vcpu MMU mode. */
+	is_smm = !!(vcpu->arch.hflags & HF_SMM_MASK);
+	if (is_smm ||
+	    vcpu->arch.mmu != &vcpu->arch.root_mmu ||
+	    vcpu->arch.walk_mmu != &vcpu->arch.root_mmu) {
+		vcpu->arch.hflags &= ~HF_SMM_MASK;
+		mmu = vcpu->arch.mmu;
+		walk_mmu = vcpu->arch.walk_mmu;
+		vcpu->arch.mmu = &vcpu->arch.root_mmu;
+		vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
+		kvm_mmu_reset_context(vcpu);
+	}
+
 	/* reload is optimized for repeated call. */
 	kvm_mmu_reload(vcpu);
 
 	r = kvm_tdp_map_page(vcpu, mapping->base_address, error_code, &level);
 	if (r)
-		return r;
+		goto out;
 
 	/* mapping->base_address is not necessarily aligned to level-hugepage. */
 	end = (mapping->base_address & KVM_HPAGE_MASK(level)) +
 		KVM_HPAGE_SIZE(level);
 	mapping->size -= end - mapping->base_address;
 	mapping->base_address = end;
+
+out:
+	/* Restore MMU state. */
+	if (is_smm || mmu) {
+		vcpu->arch.hflags |= is_smm ? HF_SMM_MASK : 0;
+		vcpu->arch.mmu = mmu;
+		vcpu->arch.walk_mmu = walk_mmu;
+		kvm_mmu_reset_context(vcpu);
+	}
 	return r;
 }
 
-- 
2.43.2


