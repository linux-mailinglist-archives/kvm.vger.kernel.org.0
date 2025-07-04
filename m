Return-Path: <kvm+bounces-51569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 57E45AF8CBD
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 10:52:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 300BF5A4E56
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:52:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD71028A400;
	Fri,  4 Jul 2025 08:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="diOzG93x"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFED91DF258;
	Fri,  4 Jul 2025 08:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751619038; cv=none; b=ZkuocJUKBU5KZzgbLo/zQYhfVX6A73WAmpNt5RzzfAKT65bfZPBn8ewXE8YB6uBD8T5QNgYrdpNNHp4KP+q53aQETywfqe3gnzJIpDRjdLmKBeoQaw1MiUgo+8Zr8XNf9gO59EWOPvQd8dy9YsAf7q2gSNZEEJ4CXwGF1NuOK/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751619038; c=relaxed/simple;
	bh=Y8FVAZZOqlAyMuyNqdpgt/TPPtNKIW5RI4r24ziXFkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EhFThqghFdZ0Xyi90OQP+c1ofMIsSe4uLtuWOi6rNh/Ais6WfoIl+q/uE/9fO+3UZter8UFVDYKtcbsE+db1SqnrEIiTD1NhUaEAeZkgHB2cwrpVSBK9e7VzMF/CmYYWNtaC3XrrelWGRum0d0jkARQiIFDf/6dRf+PX6qbRw7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=diOzG93x; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751619037; x=1783155037;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y8FVAZZOqlAyMuyNqdpgt/TPPtNKIW5RI4r24ziXFkA=;
  b=diOzG93x4JYXYfmqr4p0xOu9NENq3/Cm9Ksjsv+sSbsFfHQIr1AYj/nM
   bjNd/ILJAkU3o0unihvPgNeJ9CVDwnr80tsTZLyToGvZIxErNVbEVeoo3
   DhZ/zU/kr4waP8l8jdODOJ/jxi2lOjRXfB+JW81S8oUeOeB5zeFPHwyAE
   KXZ/572xrzfP44TsagACtM5swS5IZOZn+Njy9thFSSM+wwb1o6iLrAgnZ
   r2WWHNVeBtRWD5bN6ESHnlILnwi/SXzuAUt+2yuFeaRJjY8UAHsfCGZRP
   +EXom3hBBewYc6p0BVG8bwVQPX2H3Cc2AZM0J6hgPIJdiQ47hGyuKK/oe
   w==;
X-CSE-ConnectionGUID: i+xAgtDXRwSyOnnQ/xSX3A==
X-CSE-MsgGUID: Z/h0OXmMRVaM5QPtYBvCZg==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="79391569"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="79391569"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 01:50:35 -0700
X-CSE-ConnectionGUID: NC7eQ9ADTNKuYUs+oRxr9w==
X-CSE-MsgGUID: g1vZJWfpR9u8xvR3x97hoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="154721946"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 01:50:35 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com
Cc: rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com,
	minipli@grsecurity.net,
	xin@zytor.com,
	Chao Gao <chao.gao@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v11 01/23] KVM: x86: Rename kvm_{g,s}et_msr()* to show that they emulate guest accesses
Date: Fri,  4 Jul 2025 01:49:32 -0700
Message-ID: <20250704085027.182163-2-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250704085027.182163-1-chao.gao@intel.com>
References: <20250704085027.182163-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

Rename kvm_{g,s}et_msr()* to kvm_emulate_msr_{read,write}()* to make it
more obvious that KVM uses these helpers to emulate guest behaviors,
i.e., host_initiated == false in these helpers.

Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  8 ++++----
 arch/x86/kvm/smm.c              |  4 ++--
 arch/x86/kvm/vmx/nested.c       | 13 +++++++------
 arch/x86/kvm/x86.c              | 28 +++++++++++++++-------------
 4 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 142a8421400f..1f3f8601747f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2150,11 +2150,11 @@ void kvm_prepare_event_vectoring_exit(struct kvm_vcpu *vcpu, gpa_t gpa);
 
 void kvm_enable_efer_bits(u64);
 bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer);
-int kvm_get_msr_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 *data);
-int kvm_set_msr_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 data);
+int kvm_emulate_msr_read_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 *data);
+int kvm_emulate_msr_write_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 data);
 int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data, bool host_initiated);
-int kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data);
-int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data);
+int kvm_emulate_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data);
+int kvm_emulate_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 data);
 int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu);
 int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu);
 int kvm_emulate_as_nop(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
index 9864c057187d..51d0646622ef 100644
--- a/arch/x86/kvm/smm.c
+++ b/arch/x86/kvm/smm.c
@@ -529,7 +529,7 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
 
 	vcpu->arch.smbase =         smstate->smbase;
 
-	if (kvm_set_msr(vcpu, MSR_EFER, smstate->efer & ~EFER_LMA))
+	if (kvm_emulate_msr_write(vcpu, MSR_EFER, smstate->efer & ~EFER_LMA))
 		return X86EMUL_UNHANDLEABLE;
 
 	rsm_load_seg_64(vcpu, &smstate->tr, VCPU_SREG_TR);
@@ -620,7 +620,7 @@ int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
 
 		/* And finally go back to 32-bit mode.  */
 		efer = 0;
-		kvm_set_msr(vcpu, MSR_EFER, efer);
+		kvm_emulate_msr_write(vcpu, MSR_EFER, efer);
 	}
 #endif
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c69df3aba8d1..e7374834453c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -991,7 +991,7 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 				__func__, i, e.index, e.reserved);
 			goto fail;
 		}
-		if (kvm_set_msr_with_filter(vcpu, e.index, e.value)) {
+		if (kvm_emulate_msr_write_with_filter(vcpu, e.index, e.value)) {
 			pr_debug_ratelimited(
 				"%s cannot write MSR (%u, 0x%x, 0x%llx)\n",
 				__func__, i, e.index, e.value);
@@ -1027,7 +1027,7 @@ static bool nested_vmx_get_vmexit_msr_value(struct kvm_vcpu *vcpu,
 		}
 	}
 
-	if (kvm_get_msr_with_filter(vcpu, msr_index, data)) {
+	if (kvm_emulate_msr_read_with_filter(vcpu, msr_index, data)) {
 		pr_debug_ratelimited("%s cannot read MSR (0x%x)\n", __func__,
 			msr_index);
 		return false;
@@ -2764,7 +2764,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) &&
 	    kvm_pmu_has_perf_global_ctrl(vcpu_to_pmu(vcpu)) &&
-	    WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
+	    WARN_ON_ONCE(kvm_emulate_msr_write(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
 				     vmcs12->guest_ia32_perf_global_ctrl))) {
 		*entry_failure_code = ENTRY_FAIL_DEFAULT;
 		return -EINVAL;
@@ -4752,8 +4752,9 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 	}
 	if ((vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL) &&
 	    kvm_pmu_has_perf_global_ctrl(vcpu_to_pmu(vcpu)))
-		WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
-					 vmcs12->host_ia32_perf_global_ctrl));
+		WARN_ON_ONCE(kvm_emulate_msr_write(vcpu,
+					MSR_CORE_PERF_GLOBAL_CTRL,
+					vmcs12->host_ia32_perf_global_ctrl));
 
 	/* Set L1 segment info according to Intel SDM
 	    27.5.2 Loading Host Segment and Descriptor-Table Registers */
@@ -4931,7 +4932,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 				goto vmabort;
 			}
 
-			if (kvm_set_msr_with_filter(vcpu, h.index, h.value)) {
+			if (kvm_emulate_msr_write_with_filter(vcpu, h.index, h.value)) {
 				pr_debug_ratelimited(
 					"%s WRMSR failed (%u, 0x%x, 0x%llx)\n",
 					__func__, j, h.index, h.value);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7543dac7ae70..11d84075cd14 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1929,33 +1929,35 @@ static int kvm_get_msr_ignored_check(struct kvm_vcpu *vcpu,
 				 __kvm_get_msr);
 }
 
-int kvm_get_msr_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 *data)
+int kvm_emulate_msr_read_with_filter(struct kvm_vcpu *vcpu, u32 index,
+				     u64 *data)
 {
 	if (!kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_READ))
 		return KVM_MSR_RET_FILTERED;
 	return kvm_get_msr_ignored_check(vcpu, index, data, false);
 }
-EXPORT_SYMBOL_GPL(kvm_get_msr_with_filter);
+EXPORT_SYMBOL_GPL(kvm_emulate_msr_read_with_filter);
 
-int kvm_set_msr_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 data)
+int kvm_emulate_msr_write_with_filter(struct kvm_vcpu *vcpu, u32 index,
+				      u64 data)
 {
 	if (!kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_WRITE))
 		return KVM_MSR_RET_FILTERED;
 	return kvm_set_msr_ignored_check(vcpu, index, data, false);
 }
-EXPORT_SYMBOL_GPL(kvm_set_msr_with_filter);
+EXPORT_SYMBOL_GPL(kvm_emulate_msr_write_with_filter);
 
-int kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data)
+int kvm_emulate_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data)
 {
 	return kvm_get_msr_ignored_check(vcpu, index, data, false);
 }
-EXPORT_SYMBOL_GPL(kvm_get_msr);
+EXPORT_SYMBOL_GPL(kvm_emulate_msr_read);
 
-int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data)
+int kvm_emulate_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 data)
 {
 	return kvm_set_msr_ignored_check(vcpu, index, data, false);
 }
-EXPORT_SYMBOL_GPL(kvm_set_msr);
+EXPORT_SYMBOL_GPL(kvm_emulate_msr_write);
 
 static void complete_userspace_rdmsr(struct kvm_vcpu *vcpu)
 {
@@ -2027,7 +2029,7 @@ int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
 	u64 data;
 	int r;
 
-	r = kvm_get_msr_with_filter(vcpu, ecx, &data);
+	r = kvm_emulate_msr_read_with_filter(vcpu, ecx, &data);
 
 	if (!r) {
 		trace_kvm_msr_read(ecx, data);
@@ -2052,7 +2054,7 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
 	u64 data = kvm_read_edx_eax(vcpu);
 	int r;
 
-	r = kvm_set_msr_with_filter(vcpu, ecx, data);
+	r = kvm_emulate_msr_write_with_filter(vcpu, ecx, data);
 
 	if (!r) {
 		trace_kvm_msr_write(ecx, data);
@@ -8484,7 +8486,7 @@ static int emulator_get_msr_with_filter(struct x86_emulate_ctxt *ctxt,
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	int r;
 
-	r = kvm_get_msr_with_filter(vcpu, msr_index, pdata);
+	r = kvm_emulate_msr_read_with_filter(vcpu, msr_index, pdata);
 	if (r < 0)
 		return X86EMUL_UNHANDLEABLE;
 
@@ -8507,7 +8509,7 @@ static int emulator_set_msr_with_filter(struct x86_emulate_ctxt *ctxt,
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	int r;
 
-	r = kvm_set_msr_with_filter(vcpu, msr_index, data);
+	r = kvm_emulate_msr_write_with_filter(vcpu, msr_index, data);
 	if (r < 0)
 		return X86EMUL_UNHANDLEABLE;
 
@@ -8527,7 +8529,7 @@ static int emulator_set_msr_with_filter(struct x86_emulate_ctxt *ctxt,
 static int emulator_get_msr(struct x86_emulate_ctxt *ctxt,
 			    u32 msr_index, u64 *pdata)
 {
-	return kvm_get_msr(emul_to_vcpu(ctxt), msr_index, pdata);
+	return kvm_emulate_msr_read(emul_to_vcpu(ctxt), msr_index, pdata);
 }
 
 static int emulator_check_rdpmc_early(struct x86_emulate_ctxt *ctxt, u32 pmc)
-- 
2.47.1


