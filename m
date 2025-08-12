Return-Path: <kvm+bounces-54494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DF19B21B31
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 05:03:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E29BC683DD4
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 03:01:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C13B12EA484;
	Tue, 12 Aug 2025 02:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iqsmVDUt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C852E9EA3;
	Tue, 12 Aug 2025 02:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754967403; cv=none; b=A00O6H3mQrtoK02suFuy2QOAp/3OKPHRC4sQsCYt32PAlcgdyX7Z1ngTBvkDjNq3eocBJZF9N7sQz29g2yBSgOglptZMIQTkN121ViNU1aUSeMlNP75gOfmEHQc2+ve12deaLKzr5N1AERPasQDeNK0NPRq0oL9AoOcKDRI5sig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754967403; c=relaxed/simple;
	bh=HpNMVy/JD/QbfDg5M+Dl2AXw1+lzyY5V2vaaZ5hfoGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/ZPt0skDsWFTtx/3ztLyDtVmw9fBy61nAHn8YIn8BaqbttCeXN61fK98rPUkf65pAtcbwAjkHrqhMCweyZlkB1VyEFPZtkEV7OocxCYKk7DuFW2qkb0+6jcSMOoPKo/1mjIaO9+qdf3agXNdg/TCv5Mb7rBpbHjh1QNcrhqcxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iqsmVDUt; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754967401; x=1786503401;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HpNMVy/JD/QbfDg5M+Dl2AXw1+lzyY5V2vaaZ5hfoGM=;
  b=iqsmVDUtoHaQHSQIDNmzYxu5pJBBAaaaQXY4emlMzcargvJWpCOdbnxa
   vPW+/zlGnG4q6oRavMtQEUt/4rw/pWEV+zLzWhXCOM3yaOTNDR+jcYB22
   1xpdh5ejzkoXrQGeGuDhwLnqFYm8jaSplENjLl0O7Uax+P/Qkmf8A6xtG
   6oj0fbXHpz37tv6O0LlAYEcmJ4j95Busi6uptuLUwrWx19In+f3p5XPqT
   yUJiWdA9iCZm7qOe6bz/9jGOOlnAvhN6RUHo/hTGt8vwNAQ7rAmKFssUl
   lBqIM9O+hQChdikSXHSxkZYBbp2Trjjr7VoAzC5wfSfYV/d4EC8103h+L
   g==;
X-CSE-ConnectionGUID: yYOCEJtaTRSaqggm0lz/Rg==
X-CSE-MsgGUID: wYH2nRsLSUCJpgoBnv+0WQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="57100650"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="57100650"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:56:41 -0700
X-CSE-ConnectionGUID: Iz33e7F2TluOWpN6VNxPoQ==
X-CSE-MsgGUID: IAyRF1E3She7p0bGIJA9yA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="171321369"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:56:41 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: mlevitsk@redhat.com,
	rick.p.edgecombe@intel.com,
	weijiang.yang@intel.com,
	xin@zytor.com,
	Mathias Krause <minipli@grsecurity.net>,
	John Allen <john.allen@amd.com>,
	Chao Gao <chao.gao@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v12 22/24] KVM: nVMX: Enable CET support for nested guest
Date: Mon, 11 Aug 2025 19:55:30 -0700
Message-ID: <20250812025606.74625-23-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250812025606.74625-1-chao.gao@intel.com>
References: <20250812025606.74625-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

Set up CET MSRs, related VM_ENTRY/EXIT control bits and fixed CR4 setting
to enable CET for nested VM.

vmcs12 and vmcs02 needs to be synced when L2 exits to L1 or when L1 wants
to resume L2, that way correct CET states can be observed by one another.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
v12: use a consistent order when referring to s_cet, ssp, and ssp_table
     throughout the patch this patch. -- Xin
---
 arch/x86/kvm/vmx/nested.c | 80 ++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmcs12.c |  6 +++
 arch/x86/kvm/vmx/vmcs12.h | 14 ++++++-
 arch/x86/kvm/vmx/vmx.c    |  2 +
 arch/x86/kvm/vmx/vmx.h    |  3 ++
 5 files changed, 102 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 618cc6c6425c..f20f205c6560 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -721,6 +721,27 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_IA32_MPERF, MSR_TYPE_R);
 
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_U_CET, MSR_TYPE_RW);
+
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_S_CET, MSR_TYPE_RW);
+
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_PL0_SSP, MSR_TYPE_RW);
+
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_PL1_SSP, MSR_TYPE_RW);
+
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_PL2_SSP, MSR_TYPE_RW);
+
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_PL3_SSP, MSR_TYPE_RW);
+
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW);
+
 	kvm_vcpu_unmap(vcpu, &map);
 
 	vmx->nested.force_msr_bitmap_recalc = false;
@@ -2521,6 +2542,32 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 	}
 }
 
+static inline void cet_vmcs_fields_get(struct kvm_vcpu *vcpu, u64 *s_cet,
+				       u64 *ssp, u64 *ssp_tbl)
+{
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_IBT) ||
+	    guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK))
+		*s_cet = vmcs_readl(GUEST_S_CET);
+
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK)) {
+		*ssp = vmcs_readl(GUEST_SSP);
+		*ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
+	}
+}
+
+static inline void cet_vmcs_fields_set(struct kvm_vcpu *vcpu, u64 s_cet,
+				       u64 ssp, u64 ssp_tbl)
+{
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_IBT) ||
+	    guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK))
+		vmcs_writel(GUEST_S_CET, s_cet);
+
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK)) {
+		vmcs_writel(GUEST_SSP, ssp);
+		vmcs_writel(GUEST_INTR_SSP_TABLE, ssp_tbl);
+	}
+}
+
 static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 {
 	struct hv_enlightened_vmcs *hv_evmcs = nested_vmx_evmcs(vmx);
@@ -2637,6 +2684,10 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
 
+	if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE)
+		cet_vmcs_fields_set(&vmx->vcpu, vmcs12->guest_s_cet,
+				    vmcs12->guest_ssp, vmcs12->guest_ssp_tbl);
+
 	set_cr4_guest_host_mask(vmx);
 }
 
@@ -2676,6 +2727,13 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
 		vmx_guest_debugctl_write(vcpu, vmx->nested.pre_vmenter_debugctl);
 	}
+
+	if (!vmx->nested.nested_run_pending ||
+	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE))
+		cet_vmcs_fields_set(vcpu, vmx->nested.pre_vmenter_s_cet,
+				    vmx->nested.pre_vmenter_ssp,
+				    vmx->nested.pre_vmenter_ssp_tbl);
+
 	if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
 	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
 		vmcs_write64(GUEST_BNDCFGS, vmx->nested.pre_vmenter_bndcfgs);
@@ -3552,6 +3610,12 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	     !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
 		vmx->nested.pre_vmenter_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
 
+	if (!vmx->nested.nested_run_pending ||
+	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE))
+		cet_vmcs_fields_get(vcpu, &vmx->nested.pre_vmenter_s_cet,
+				    &vmx->nested.pre_vmenter_ssp,
+				    &vmx->nested.pre_vmenter_ssp_tbl);
+
 	/*
 	 * Overwrite vmcs01.GUEST_CR3 with L1's CR3 if EPT is disabled *and*
 	 * nested early checks are disabled.  In the event of a "late" VM-Fail,
@@ -4479,6 +4543,9 @@ static bool is_vmcs12_ext_field(unsigned long field)
 	case GUEST_IDTR_BASE:
 	case GUEST_PENDING_DBG_EXCEPTIONS:
 	case GUEST_BNDCFGS:
+	case GUEST_S_CET:
+	case GUEST_SSP:
+	case GUEST_INTR_SSP_TABLE:
 		return true;
 	default:
 		break;
@@ -4529,6 +4596,10 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
 	vmcs12->guest_pending_dbg_exceptions =
 		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
 
+	cet_vmcs_fields_get(&vmx->vcpu, &vmcs12->guest_s_cet,
+			    &vmcs12->guest_ssp,
+			    &vmcs12->guest_ssp_tbl);
+
 	vmx->nested.need_sync_vmcs02_to_vmcs12_rare = false;
 }
 
@@ -4760,6 +4831,10 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 	if (vmcs12->vm_exit_controls & VM_EXIT_CLEAR_BNDCFGS)
 		vmcs_write64(GUEST_BNDCFGS, 0);
 
+	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_CET_STATE)
+		cet_vmcs_fields_set(vcpu, vmcs12->host_s_cet, vmcs12->host_ssp,
+				    vmcs12->host_ssp_tbl);
+
 	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PAT) {
 		vmcs_write64(GUEST_IA32_PAT, vmcs12->host_ia32_pat);
 		vcpu->arch.pat = vmcs12->host_ia32_pat;
@@ -7037,7 +7112,7 @@ static void nested_vmx_setup_exit_ctls(struct vmcs_config *vmcs_conf,
 		VM_EXIT_HOST_ADDR_SPACE_SIZE |
 #endif
 		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT |
-		VM_EXIT_CLEAR_BNDCFGS;
+		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_CET_STATE;
 	msrs->exit_ctls_high |=
 		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
 		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
@@ -7059,7 +7134,8 @@ static void nested_vmx_setup_entry_ctls(struct vmcs_config *vmcs_conf,
 #ifdef CONFIG_X86_64
 		VM_ENTRY_IA32E_MODE |
 #endif
-		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS;
+		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS |
+		VM_ENTRY_LOAD_CET_STATE;
 	msrs->entry_ctls_high |=
 		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER |
 		 VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index 106a72c923ca..4233b5ca9461 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -139,6 +139,9 @@ const unsigned short vmcs12_field_offsets[] = {
 	FIELD(GUEST_PENDING_DBG_EXCEPTIONS, guest_pending_dbg_exceptions),
 	FIELD(GUEST_SYSENTER_ESP, guest_sysenter_esp),
 	FIELD(GUEST_SYSENTER_EIP, guest_sysenter_eip),
+	FIELD(GUEST_S_CET, guest_s_cet),
+	FIELD(GUEST_SSP, guest_ssp),
+	FIELD(GUEST_INTR_SSP_TABLE, guest_ssp_tbl),
 	FIELD(HOST_CR0, host_cr0),
 	FIELD(HOST_CR3, host_cr3),
 	FIELD(HOST_CR4, host_cr4),
@@ -151,5 +154,8 @@ const unsigned short vmcs12_field_offsets[] = {
 	FIELD(HOST_IA32_SYSENTER_EIP, host_ia32_sysenter_eip),
 	FIELD(HOST_RSP, host_rsp),
 	FIELD(HOST_RIP, host_rip),
+	FIELD(HOST_S_CET, host_s_cet),
+	FIELD(HOST_SSP, host_ssp),
+	FIELD(HOST_INTR_SSP_TABLE, host_ssp_tbl),
 };
 const unsigned int nr_vmcs12_fields = ARRAY_SIZE(vmcs12_field_offsets);
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 56fd150a6f24..4ad6b16525b9 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -117,7 +117,13 @@ struct __packed vmcs12 {
 	natural_width host_ia32_sysenter_eip;
 	natural_width host_rsp;
 	natural_width host_rip;
-	natural_width paddingl[8]; /* room for future expansion */
+	natural_width host_s_cet;
+	natural_width host_ssp;
+	natural_width host_ssp_tbl;
+	natural_width guest_s_cet;
+	natural_width guest_ssp;
+	natural_width guest_ssp_tbl;
+	natural_width paddingl[2]; /* room for future expansion */
 	u32 pin_based_vm_exec_control;
 	u32 cpu_based_vm_exec_control;
 	u32 exception_bitmap;
@@ -294,6 +300,12 @@ static inline void vmx_check_vmcs12_offsets(void)
 	CHECK_OFFSET(host_ia32_sysenter_eip, 656);
 	CHECK_OFFSET(host_rsp, 664);
 	CHECK_OFFSET(host_rip, 672);
+	CHECK_OFFSET(host_s_cet, 680);
+	CHECK_OFFSET(host_ssp, 688);
+	CHECK_OFFSET(host_ssp_tbl, 696);
+	CHECK_OFFSET(guest_s_cet, 704);
+	CHECK_OFFSET(guest_ssp, 712);
+	CHECK_OFFSET(guest_ssp_tbl, 720);
 	CHECK_OFFSET(pin_based_vm_exec_control, 744);
 	CHECK_OFFSET(cpu_based_vm_exec_control, 748);
 	CHECK_OFFSET(exception_bitmap, 752);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ae8be898e1df..3ab0fe6e47c9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7711,6 +7711,8 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 	cr4_fixed1_update(X86_CR4_PKE,        ecx, feature_bit(PKU));
 	cr4_fixed1_update(X86_CR4_UMIP,       ecx, feature_bit(UMIP));
 	cr4_fixed1_update(X86_CR4_LA57,       ecx, feature_bit(LA57));
+	cr4_fixed1_update(X86_CR4_CET,	      ecx, feature_bit(SHSTK));
+	cr4_fixed1_update(X86_CR4_CET,	      edx, feature_bit(IBT));
 
 	entry = kvm_find_cpuid_entry_index(vcpu, 0x7, 1);
 	cr4_fixed1_update(X86_CR4_LAM_SUP,    eax, feature_bit(LAM));
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 89200586b35a..3bf7748ddfc2 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -181,6 +181,9 @@ struct nested_vmx {
 	 */
 	u64 pre_vmenter_debugctl;
 	u64 pre_vmenter_bndcfgs;
+	u64 pre_vmenter_s_cet;
+	u64 pre_vmenter_ssp;
+	u64 pre_vmenter_ssp_tbl;
 
 	/* to migrate it to L1 if L2 writes to L1's CR8 directly */
 	int l1_tpr_threshold;
-- 
2.47.1


