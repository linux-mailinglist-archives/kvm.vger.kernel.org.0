Return-Path: <kvm+bounces-65826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 89BA5CB8EFE
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:01:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2AD263077306
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 14:01:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23EA52773C3;
	Fri, 12 Dec 2025 14:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LDlf3TRG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237734A3E;
	Fri, 12 Dec 2025 14:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765548093; cv=none; b=E+9IpA9y+0fQ/yREUdU4Wy7xuXKEsHMxFpJ7w9/wEn37v1K2flCE4WOA4500BsUOGxYXQBmiPDcH52L1FhBzkK0cx14S5S2IiGMziWXAMpG/szfbe5eWgYdhweMgY4uOHvge0WHxOfNZLXsAGD4DAqRQ/hQtp1HhjhLpmXDHqtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765548093; c=relaxed/simple;
	bh=KyT//ya6ekujeogcywDmXm9hXco8vl51HP4W8cm1u1c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bSbTmblgd+HTBQtMT+cJdsvm6CvqlVBhei4QRjmD47pmiNKlfYwLXvpJ3vNW+o59Z/d4nmH1eO2faRxWL4thLFFZej9EvoNdOpzHnrP7c/APEztB1aHWMbiubAfXpLMq0INNv4AZpHfKSIN+3lEYKBoeVKDisWsOZOScSC+7mP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LDlf3TRG; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765548091; x=1797084091;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KyT//ya6ekujeogcywDmXm9hXco8vl51HP4W8cm1u1c=;
  b=LDlf3TRGF8DpejziaupeG2MMMFD6V9HW3/yOW6P0rB9wKfj8diWcxRSV
   0NFPve9F8TQrq4DXLU0exwDi7i+Z2P0B39DSpotiRwKjTm60bbshHyWg3
   bCw1Auyrg2RwjdK3qEJAdt1p9qO7+338nJbRW/OUeVr4sAM4ddcrpS8q/
   leb6PD3MP3gd6dJTbrp5Nd5yjciyfCzjPAHcnAv8D6AoRRX51ZBtj3K0h
   raEn4Zyt4ItUYbtAawRr5FfCnpLnPQhGaJ+eBh6ApDrjpn/e+CMbXYniT
   rNvtmlNtZ0u1TTnqQNdywHFuaw3pO+Uxk8Q+l1xjjWcQ7WGUPTbVbxcUM
   Q==;
X-CSE-ConnectionGUID: oBkWtDBQTxuSpaajjQJrXQ==
X-CSE-MsgGUID: tu0Ks7VVQbysSyg5Pkpdng==
X-IronPort-AV: E=McAfee;i="6800,10657,11640"; a="67708945"
X-IronPort-AV: E=Sophos;i="6.21,143,1763452800"; 
   d="scan'208";a="67708945"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2025 06:01:30 -0800
X-CSE-ConnectionGUID: TULZOOkYSm+ElqOze/+1qA==
X-CSE-MsgGUID: AnhuXa3KQuSCy4Lcj0G3Kg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,143,1763452800"; 
   d="scan'208";a="196849410"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.22])
  by orviesa009.jf.intel.com with ESMTP; 12 Dec 2025 06:01:29 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xiaoyao.li@intel.com,
	farrah.chen@intel.com
Subject: [PATCH v2] KVM: x86: Don't read guest CR3 when doing async pf while the MMU is direct
Date: Fri, 12 Dec 2025 21:50:51 +0800
Message-ID: <20251212135051.2155280-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't read guest CR3 in kvm_arch_setup_async_pf() if the MMU is direct
and use INVALID_GPA instead.

When KVM tries to perform the host-only async page fault for the shared
memory of TDX guests, the following WARNING is triggered:

  WARNING: CPU: 1 PID: 90922 at arch/x86/kvm/vmx/main.c:483 vt_cache_reg+0x16/0x20
  Call Trace:
  __kvm_mmu_faultin_pfn
  kvm_mmu_faultin_pfn
  kvm_tdp_page_fault
  kvm_mmu_do_page_fault
  kvm_mmu_page_fault
  tdx_handle_ept_violation

This WARNING is triggered when calling kvm_mmu_get_guest_pgd() to cache
the guest CR3 in kvm_arch_setup_async_pf() for later use in
kvm_arch_async_page_ready() to determine if it's possible to fix the
page fault in the current vCPU context to save one VM exit. However, when
guest state is protected, KVM cannot read the guest CR3.

Since protected guests aren't compatible with shadow paging, i.e, they
must use direct MMU, avoid calling kvm_mmu_get_guest_pgd() to read guest
CR3 when the MMU is direct and use INVALID_GPA instead.

Note that for protected guests mmu->root_role.direct is always true, so
that kvm_mmu_get_guest_pgd() in kvm_arch_async_page_ready() won't be
reached.

Reported-by: Farrah Chen <farrah.chen@intel.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v2:
- Use arch.direct_map to key off the reading of guest CR3;
- drop the handling in kvm_arch_async_page_ready() since the read CR3
  operation cannot be reached for direct MMU (protected guests);
---
 arch/x86/kvm/mmu/mmu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 667d66cf76d5..257835185f90 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4521,7 +4521,10 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu,
 	arch.gfn = fault->gfn;
 	arch.error_code = fault->error_code;
 	arch.direct_map = vcpu->arch.mmu->root_role.direct;
-	arch.cr3 = kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu);
+	if (arch.direct_map)
+		arch.cr3 = INVALID_GPA;
+	else
+		arch.cr3 = kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu);
 
 	return kvm_setup_async_pf(vcpu, fault->addr,
 				  kvm_vcpu_gfn_to_hva(vcpu, fault->gfn), &arch);

base-commit: 7d0a66e4bb9081d75c82ec4957c50034cb0ea449
-- 
2.43.0


