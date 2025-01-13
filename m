Return-Path: <kvm+bounces-35259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07C65A0AD4D
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 03:12:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E0D416607B
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 02:12:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADA9C54738;
	Mon, 13 Jan 2025 02:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GN2q6nxD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634DB125D5;
	Mon, 13 Jan 2025 02:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736734351; cv=none; b=lVoO+4ohywH4Aj9clqs+UOtKQWqIRiz+KKhnqQdr92u6806a/MgEA6kJlsTLW1hxbFq+aq05X4q/Wy2wTxEbc5L5MmDZx04DJFOnmHZfyUbU9phcbNsU3yJykHLeXzuvf3/EfUYyWbL0ubYsTFAGF1ZUSAtthHf+HsQRj1wwiSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736734351; c=relaxed/simple;
	bh=sTIaMISbxPrqRPwj70anC65LSpnvKOSP5cudKOCfXEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pHPPW5yCf7H5k/FligWCCOw09TApuzJ2kOgi0dTUUobwglvHvYM7zbswJoSRdTOlqtgI8a5erZP3lI5KiLuuLfYB4VVzFGG7FENkzzAbXzMtE5PM3t9wSWztE6KC9My3WNKn7HKJeMBWdqOiS7/72uxLxMgi+e58tJQd5hTm21U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GN2q6nxD; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736734350; x=1768270350;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sTIaMISbxPrqRPwj70anC65LSpnvKOSP5cudKOCfXEg=;
  b=GN2q6nxDi4xrjAhdoANCdDsH/z0d0j6AXHhQ4PtU7yZOZNXt1O/yaGiR
   B66uRdIFSzF9JE04Ali6l7rpi50T3PA7xCdluDWKcyl4Zzr9NvSSNbUcA
   rpx3i40T0jQggo0luQpdoFjTTPY5IBcUu/P0tbS9itNxo0husfa8qAcWP
   lX1KOuLU+Jyuoy6fzBWF3P48yBqCfczGSzYdlRbIU2zQTCQGK88Pek0nB
   1gXEnTMf58tPV67tJZ9Xag//mmiFPx7kzwseQOPONDLFVeMcK8i82x8BN
   JTQIw+6rQgWVW+mayy1FztpAiOcgDiL+kNLz3Z8VpTIMAQNa87NUzaiA/
   g==;
X-CSE-ConnectionGUID: No2BaPbFTzSMtPP4fmSxDg==
X-CSE-MsgGUID: azK8f7abRGOXy0sqN5LbQQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11313"; a="36880621"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="36880621"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2025 18:12:30 -0800
X-CSE-ConnectionGUID: sBC+HgAiT3uTeb4f5UUYsg==
X-CSE-MsgGUID: qtRGqdU3QWCRu+8JWxUuVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="104842717"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2025 18:12:26 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com
Subject: [PATCH 2/7] KVM: x86/mmu: Return RET_PF* instead of 1 in kvm_mmu_page_fault()
Date: Mon, 13 Jan 2025 10:11:38 +0800
Message-ID: <20250113021138.18875-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250113020925.18789-1-yan.y.zhao@intel.com>
References: <20250113020925.18789-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Return RET_PF* (excluding RET_PF_EMULATE/RET_PF_CONTINUE/RET_PF_INVALID)
instead of 1 in kvm_mmu_page_fault().

The callers of kvm_mmu_page_fault() are KVM page fault handlers (i.e.,
npf_interception(), handle_ept_misconfig(), __vmx_handle_ept_violation(),
kvm_handle_page_fault()). They either check if the return value is > 0 (as
in npf_interception()) or pass it further to vcpu_run() to decide whether
to break out of the kernel loop and return to the user when r <= 0.
Therefore, returning any positive value is equivalent to returning 1.

Warn if r == RET_PF_CONTINUE (which should not be a valid value) to ensure
a positive return value.

This is a preparation to allow TDX's EPT violation handler to check the
RET_PF* value and retry internally for RET_PF_RETRY.

No functional changes are intended.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/mmu.c          | 10 +++++++++-
 arch/x86/kvm/mmu/mmu_internal.h | 12 +++++++++---
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index eedc6ff37b89..53dcf600e934 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6120,8 +6120,16 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	else if (r == RET_PF_SPURIOUS)
 		vcpu->stat.pf_spurious++;
 
+	/*
+	 * None of handle_mmio_page_fault(), kvm_mmu_do_page_fault(), or
+	 * kvm_mmu_write_protect_fault() return RET_PF_CONTINUE.
+	 * kvm_mmu_do_page_fault() only uses RET_PF_CONTINUE internally to
+	 * indicate continuing the page fault handling until to the final
+	 * page table mapping phase.
+	 */
+	WARN_ON_ONCE(r == RET_PF_CONTINUE);
 	if (r != RET_PF_EMULATE)
-		return 1;
+		return r;
 
 emulate:
 	return x86_emulate_instruction(vcpu, cr2_or_gpa, emulation_type, insn,
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 957636660149..4fde91cade1b 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -315,9 +315,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
  * tracepoints via TRACE_DEFINE_ENUM() in mmutrace.h
  *
  * Note, all values must be greater than or equal to zero so as not to encroach
- * on -errno return values.  Somewhat arbitrarily use '0' for CONTINUE, which
- * will allow for efficient machine code when checking for CONTINUE, e.g.
- * "TEST %rax, %rax, JNZ", as all "stop!" values are non-zero.
+ * on -errno return values.
  */
 enum {
 	RET_PF_CONTINUE = 0,
@@ -329,6 +327,14 @@ enum {
 	RET_PF_SPURIOUS,
 };
 
+/*
+ * Define RET_PF_CONTINUE as 0 to allow for
+ * - efficient machine code when checking for CONTINUE, e.g.
+ *   "TEST %rax, %rax, JNZ", as all "stop!" values are non-zero,
+ * - kvm_mmu_do_page_fault() to return other RET_PF_* as a positive value.
+ */
+static_assert(RET_PF_CONTINUE == 0);
+
 static inline void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 						     struct kvm_page_fault *fault)
 {
-- 
2.43.2


