Return-Path: <kvm+bounces-55295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA7CEB2FAD2
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 15:43:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A2FF62211A
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 13:38:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14E63369998;
	Thu, 21 Aug 2025 13:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QnYw+yYj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E48F350830;
	Thu, 21 Aug 2025 13:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755783134; cv=none; b=Ye9aVx9c+XFXxTXa4xeuWQ+vY1Xw6+V+4MzkIjRlfYI34xAKCWH+2wynwoAn6Ngv8SpZil6vLd+9E/ATgpGC5ZY9hwmFm9RQ39/6owZr6upmeHjDd976CbUEaM3IKJ38bHDxVToAcvfKvq7gCTbtrvsdBo7bJWo+Cs2IdPZ8PWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755783134; c=relaxed/simple;
	bh=44sfvsVLkWzYIKjJBhUUON2fh5Joe2QMneUTwfIHc0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=skEkJ8f5PpgCgH+qowYTLejWQEQnfs3G/uteB7xUNtDvNl2GbSDrFUBQ7lfEXop8E6iB0D8nsvdBbPf+xnb0TnYa5mhyxBPsbqbupnYfThgyUSgv9i+cerAr2XmvB7qzo/tmAu9zlAEfiv+yGZUNsqyRWte5CS8Nq7ysa6ZWSfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QnYw+yYj; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755783131; x=1787319131;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=44sfvsVLkWzYIKjJBhUUON2fh5Joe2QMneUTwfIHc0k=;
  b=QnYw+yYjxh5a4aaiyOVbrBP/yaRg4z8DuPn13b1P5z1B2/HSRqo86I7v
   FG5wGJYDjfQbNKg26jga2IQKrsVe94otqWsrhPe8ZorpwuGUrS7b1nqEK
   2zo/VDMGTLgjVy//fH/v4ias14twZ4Aqhu3MjMbPWcmASdXlTBMkF/hJC
   S7euVJigPA92F3sNK7dP8IYve+HVQEMtp+/eCYmQ/OiIFv3/TW7CmbKr0
   /89MBHqIDRvzHn864CABm39DgF2AHPPMs/l6ke9S8f4q30FTFJ6YMNvhs
   GqhirkuMZ9Rv35BLEuZNYLCpBy/x6akjgpNClQqSdy8YJwsR2ABlzQ1GN
   A==;
X-CSE-ConnectionGUID: CGkhG2svQn61wwRrRSXXhw==
X-CSE-MsgGUID: m9eLB+hjS/+GKCrJz8ElXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="69446214"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="69446214"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:32:01 -0700
X-CSE-ConnectionGUID: 4y1u8fUfQ2CgEMJta5eT7A==
X-CSE-MsgGUID: anp4ohx5R/W8veHaoqYkVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="199285430"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:31:53 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: chao.gao@intel.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	john.allen@amd.com,
	mingo@redhat.com,
	minipli@grsecurity.net,
	mlevitsk@redhat.com,
	pbonzini@redhat.com,
	rick.p.edgecombe@intel.com,
	seanjc@google.com,
	tglx@linutronix.de,
	weijiang.yang@intel.com,
	x86@kernel.org,
	xin@zytor.com
Subject: [PATCH v13 15/21] KVM: x86: Enable CET virtualization for VMX and advertise to userspace
Date: Thu, 21 Aug 2025 06:30:49 -0700
Message-ID: <20250821133132.72322-16-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250821133132.72322-1-chao.gao@intel.com>
References: <20250821133132.72322-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

Expose CET features to guest if KVM/host can support them, clear CPUID
feature bits if KVM/host cannot support.

Set CPUID feature bits so that CET features are available in guest CPUID.
Add CR4.CET bit support in order to allow guest set CET master control
bit.

Disable KVM CET feature if unrestricted_guest is unsupported/disabled as
KVM does not support emulating CET.

The CET load-bits in VM_ENTRY/VM_EXIT control fields should be set to make
guest CET xstates isolated from host's.

On platforms with VMX_BASIC[bit56] == 0, inject #CP at VMX entry with error
code will fail, and if VMX_BASIC[bit56] == 1, #CP injection with or without
error code is allowed. Disable CET feature bits if the MSR bit is cleared
so that nested VMM can inject #CP if and only if VMX_BASIC[bit56] == 1.

Don't expose CET feature if either of {U,S}_CET xstate bits is cleared
in host XSS or if XSAVES isn't supported.

CET MSRs are reset to 0s after RESET, power-up and INIT, clear guest CET
xsave-area fields so that guest CET MSRs are reset to 0s after the events.

Meanwhile explicitly disable SHSTK and IBT for SVM because CET KVM enabling
for SVM is not ready.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
v13: Limit SHSTK to 64-bit kernels
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/include/asm/vmx.h      |  1 +
 arch/x86/kvm/cpuid.c            |  2 ++
 arch/x86/kvm/svm/svm.c          |  4 ++++
 arch/x86/kvm/vmx/capabilities.h |  5 +++++
 arch/x86/kvm/vmx/vmx.c          | 30 +++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h          |  6 ++++--
 arch/x86/kvm/x86.c              | 22 +++++++++++++++++++---
 arch/x86/kvm/x86.h              |  3 +++
 9 files changed, 68 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b7f82a421718..061c0cd73d39 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -142,7 +142,7 @@
 			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
 			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
-			  | X86_CR4_LAM_SUP))
+			  | X86_CR4_LAM_SUP | X86_CR4_CET))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index ce10a7e2d3d9..c85c50019523 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -134,6 +134,7 @@
 #define VMX_BASIC_DUAL_MONITOR_TREATMENT	BIT_ULL(49)
 #define VMX_BASIC_INOUT				BIT_ULL(54)
 #define VMX_BASIC_TRUE_CTLS			BIT_ULL(55)
+#define VMX_BASIC_NO_HW_ERROR_CODE_CC		BIT_ULL(56)
 
 static inline u32 vmx_basic_vmcs_revision_id(u64 vmx_basic)
 {
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b5f87254ced7..ee05b876c656 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -944,6 +944,7 @@ void kvm_set_cpu_caps(void)
 		VENDOR_F(WAITPKG),
 		F(SGX_LC),
 		F(BUS_LOCK_DETECT),
+		X86_64_F(SHSTK),
 	);
 
 	/*
@@ -970,6 +971,7 @@ void kvm_set_cpu_caps(void)
 		F(AMX_INT8),
 		F(AMX_BF16),
 		F(FLUSH_L1D),
+		F(IBT),
 	);
 
 	if (boot_cpu_has(X86_FEATURE_AMD_IBPB_RET) &&
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7e7821ee8ee1..0e2c60466797 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5241,6 +5241,10 @@ static __init void svm_set_cpu_caps(void)
 	kvm_caps.supported_perf_cap = 0;
 	kvm_caps.supported_xss = 0;
 
+	/* KVM doesn't yet support CET virtualization for SVM. */
+	kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
+	kvm_cpu_cap_clear(X86_FEATURE_IBT);
+
 	/* CPUID 0x80000001 and 0x8000000A (SVM features) */
 	if (nested) {
 		kvm_cpu_cap_set(X86_FEATURE_SVM);
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 7d290b2cb0f4..47b0dec8665a 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -76,6 +76,11 @@ static inline bool cpu_has_vmx_basic_inout(void)
 	return	vmcs_config.basic & VMX_BASIC_INOUT;
 }
 
+static inline bool cpu_has_vmx_basic_no_hw_errcode(void)
+{
+	return	vmcs_config.basic & VMX_BASIC_NO_HW_ERROR_CODE_CC;
+}
+
 static inline bool cpu_has_virtual_nmis(void)
 {
 	return vmcs_config.pin_based_exec_ctrl & PIN_BASED_VIRTUAL_NMIS &&
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e8155635cb42..8d2186d6549f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2615,6 +2615,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		{ VM_ENTRY_LOAD_IA32_EFER,		VM_EXIT_LOAD_IA32_EFER },
 		{ VM_ENTRY_LOAD_BNDCFGS,		VM_EXIT_CLEAR_BNDCFGS },
 		{ VM_ENTRY_LOAD_IA32_RTIT_CTL,		VM_EXIT_CLEAR_IA32_RTIT_CTL },
+		{ VM_ENTRY_LOAD_CET_STATE,		VM_EXIT_LOAD_CET_STATE },
 	};
 
 	memset(vmcs_conf, 0, sizeof(*vmcs_conf));
@@ -4882,6 +4883,14 @@ void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);  /* 22.2.1 */
 
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
+		vmcs_writel(GUEST_SSP, 0);
+		vmcs_writel(GUEST_INTR_SSP_TABLE, 0);
+	}
+	if (kvm_cpu_cap_has(X86_FEATURE_IBT) ||
+	    kvm_cpu_cap_has(X86_FEATURE_SHSTK))
+		vmcs_writel(GUEST_S_CET, 0);
+
 	kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
 
 	vpid_sync_context(vmx->vpid);
@@ -6349,6 +6358,10 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 	if (vmcs_read32(VM_EXIT_MSR_STORE_COUNT) > 0)
 		vmx_dump_msrs("guest autostore", &vmx->msr_autostore.guest);
 
+	if (vmentry_ctl & VM_ENTRY_LOAD_CET_STATE)
+		pr_err("S_CET = 0x%016lx, SSP = 0x%016lx, SSP TABLE = 0x%016lx\n",
+		       vmcs_readl(GUEST_S_CET), vmcs_readl(GUEST_SSP),
+		       vmcs_readl(GUEST_INTR_SSP_TABLE));
 	pr_err("*** Host State ***\n");
 	pr_err("RIP = 0x%016lx  RSP = 0x%016lx\n",
 	       vmcs_readl(HOST_RIP), vmcs_readl(HOST_RSP));
@@ -6379,6 +6392,10 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 		       vmcs_read64(HOST_IA32_PERF_GLOBAL_CTRL));
 	if (vmcs_read32(VM_EXIT_MSR_LOAD_COUNT) > 0)
 		vmx_dump_msrs("host autoload", &vmx->msr_autoload.host);
+	if (vmexit_ctl & VM_EXIT_LOAD_CET_STATE)
+		pr_err("S_CET = 0x%016lx, SSP = 0x%016lx, SSP TABLE = 0x%016lx\n",
+		       vmcs_readl(HOST_S_CET), vmcs_readl(HOST_SSP),
+		       vmcs_readl(HOST_INTR_SSP_TABLE));
 
 	pr_err("*** Control State ***\n");
 	pr_err("CPUBased=0x%08x SecondaryExec=0x%08x TertiaryExec=0x%016llx\n",
@@ -7963,7 +7980,6 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_UMIP);
 
 	/* CPUID 0xD.1 */
-	kvm_caps.supported_xss = 0;
 	if (!cpu_has_vmx_xsaves())
 		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
 
@@ -7975,6 +7991,18 @@ static __init void vmx_set_cpu_caps(void)
 
 	if (cpu_has_vmx_waitpkg())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
+
+	/*
+	 * Disable CET if unrestricted_guest is unsupported as KVM doesn't
+	 * enforce CET HW behaviors in emulator. On platforms with
+	 * VMX_BASIC[bit56] == 0, inject #CP at VMX entry with error code
+	 * fails, so disable CET in this case too.
+	 */
+	if (!cpu_has_load_cet_ctrl() || !enable_unrestricted_guest ||
+	    !cpu_has_vmx_basic_no_hw_errcode()) {
+		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
+		kvm_cpu_cap_clear(X86_FEATURE_IBT);
+	}
 }
 
 static bool vmx_is_io_intercepted(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 24d65dac5e89..08a9a0075404 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -484,7 +484,8 @@ static inline u8 vmx_get_rvi(void)
 	 VM_ENTRY_LOAD_IA32_EFER |					\
 	 VM_ENTRY_LOAD_BNDCFGS |					\
 	 VM_ENTRY_PT_CONCEAL_PIP |					\
-	 VM_ENTRY_LOAD_IA32_RTIT_CTL)
+	 VM_ENTRY_LOAD_IA32_RTIT_CTL |					\
+	 VM_ENTRY_LOAD_CET_STATE)
 
 #define __KVM_REQUIRED_VMX_VM_EXIT_CONTROLS				\
 	(VM_EXIT_SAVE_DEBUG_CONTROLS |					\
@@ -506,7 +507,8 @@ static inline u8 vmx_get_rvi(void)
 	       VM_EXIT_LOAD_IA32_EFER |					\
 	       VM_EXIT_CLEAR_BNDCFGS |					\
 	       VM_EXIT_PT_CONCEAL_PIP |					\
-	       VM_EXIT_CLEAR_IA32_RTIT_CTL)
+	       VM_EXIT_CLEAR_IA32_RTIT_CTL |				\
+	       VM_EXIT_LOAD_CET_STATE)
 
 #define KVM_REQUIRED_VMX_PIN_BASED_VM_EXEC_CONTROL			\
 	(PIN_BASED_EXT_INTR_MASK |					\
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 34e4b2c4b892..9930678f5a3b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -223,7 +223,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
 
-#define KVM_SUPPORTED_XSS     0
+#define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_USER | \
+				 XFEATURE_MASK_CET_KERNEL)
 
 bool __read_mostly allow_smaller_maxphyaddr = 0;
 EXPORT_SYMBOL_GPL(allow_smaller_maxphyaddr);
@@ -9991,6 +9992,20 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
 		kvm_caps.supported_xss = 0;
 
+	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
+	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
+		kvm_caps.supported_xss &= ~(XFEATURE_MASK_CET_USER |
+					    XFEATURE_MASK_CET_KERNEL);
+
+	if ((kvm_caps.supported_xss & (XFEATURE_MASK_CET_USER |
+	     XFEATURE_MASK_CET_KERNEL)) !=
+	    (XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)) {
+		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
+		kvm_cpu_cap_clear(X86_FEATURE_IBT);
+		kvm_caps.supported_xss &= ~(XFEATURE_MASK_CET_USER |
+					    XFEATURE_MASK_CET_KERNEL);
+	}
+
 	if (kvm_caps.has_tsc_control) {
 		/*
 		 * Make sure the user can only configure tsc_khz values that
@@ -12646,10 +12661,11 @@ static void kvm_xstate_reset(struct kvm_vcpu *vcpu, bool init_event)
 	/*
 	 * On INIT, only select XSTATE components are zeroed, most components
 	 * are unchanged.  Currently, the only components that are zeroed and
-	 * supported by KVM are MPX related.
+	 * supported by KVM are MPX and CET related.
 	 */
 	xfeatures_mask = (kvm_caps.supported_xcr0 | kvm_caps.supported_xss) &
-			 (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
+			 (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR |
+			  XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL);
 	if (!xfeatures_mask)
 		return;
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 27fec4ed4c4e..d6b21ba41416 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -681,6 +681,9 @@ static inline bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		__reserved_bits |= X86_CR4_PCIDE;       \
 	if (!__cpu_has(__c, X86_FEATURE_LAM))           \
 		__reserved_bits |= X86_CR4_LAM_SUP;     \
+	if (!__cpu_has(__c, X86_FEATURE_SHSTK) &&       \
+	    !__cpu_has(__c, X86_FEATURE_IBT))           \
+		__reserved_bits |= X86_CR4_CET;         \
 	__reserved_bits;                                \
 })
 
-- 
2.47.3


