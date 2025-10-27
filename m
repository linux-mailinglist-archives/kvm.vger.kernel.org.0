Return-Path: <kvm+bounces-61240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A575C1215A
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 00:44:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C5AB84EA881
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 23:44:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B5BF32E695;
	Mon, 27 Oct 2025 23:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B/b0X+fA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B7B241663;
	Mon, 27 Oct 2025 23:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761608635; cv=none; b=sfh9dxaHt9wRb13YDnrPrBKoMPUeN5zE7jjcEqNIQ3rC0vJ3rmvtfeKl7gFdifx/2hbOPWyssxsl6yXqjZs8SWwBFg4OnfH2zFCWiPqW7hNxB2wel3xaEQduoX+JxWJRfYG9HRLw2wV/9iN8N3+UhL/pnxkspIn6LaU/zbQ9J28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761608635; c=relaxed/simple;
	bh=np9lYkk9Aaue363IWvenK7Ed/IkD9gwpyDzUewa6jtE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ir42mgg7WCCbcQt64q9KjyzjSlLXRSomHKGq3pXTrWVBuHPLgligrqbyV0ZaTN84o0t/3OtgeLtC3DxPubM0cIXHlWhAkhVR2LkzhzwF32lXWKAOR7/aQuEeGlj7UL6NrDIcmk1h6uxTmgvbP7wYAtTZLhRrLXaRC9OLLh6EDSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B/b0X+fA; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761608633; x=1793144633;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=np9lYkk9Aaue363IWvenK7Ed/IkD9gwpyDzUewa6jtE=;
  b=B/b0X+fAnaS0pQBlGg+MrEn4eDg62/6Wv3c1WPKodhk5ztGNaZNIMHQf
   lJdoKbWd44tSiBXu7kV6UZneqQjy5ToDdvY8tsSJsf/tDQ5ycQd/Pzz8y
   1IFHR4qhwV5VYe787GjCXyazegEluCj1DyUf06O4OxXnYsmQiUOvVoO10
   ntIEKKG1Q2Jonw6mKEBBOULHwwDoneaxQTyzAblKe+DSginJNxLbMcAlb
   aDLt1qOmefKqVnL7NnPBq6gDR14d3PbWOzk2dhw6sYBY9+SXJVFHUTDfh
   KbUEqGLV10+/p1gLh6gZbeKKVoOyojdcVCoA/BPKD2SvLnA/GWyurZAgY
   w==;
X-CSE-ConnectionGUID: 5X+vsNUNRW2hKMPXmWp1Ww==
X-CSE-MsgGUID: Ej5Le/9VS7O4UuAfdawajw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74302491"
X-IronPort-AV: E=Sophos;i="6.19,259,1754982000"; 
   d="scan'208";a="74302491"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 16:43:38 -0700
X-CSE-ConnectionGUID: CYrN42YdQBuvT8yg4IZlrw==
X-CSE-MsgGUID: eScPoOK9RNKfbWxNt5HJbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,259,1754982000"; 
   d="scan'208";a="215845046"
Received: from jjgreens-desk15.amr.corp.intel.com (HELO desk) ([10.124.222.186])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 16:43:38 -0700
Date: Mon, 27 Oct 2025 16:43:36 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: [PATCH v3 2/3] x86/vmscape: Replace IBPB with branch history clear
 on exit to userspace
Message-ID: <20251027-vmscape-bhb-v3-2-5793c2534e93@linux.intel.com>
X-Mailer: b4 0.14.2
References: <20251027-vmscape-bhb-v3-0-5793c2534e93@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027-vmscape-bhb-v3-0-5793c2534e93@linux.intel.com>

IBPB mitigation for VMSCAPE is an overkill for CPUs that are only affected
by the BHI variant of VMSCAPE. On such CPUs, eIBRS already provides
indirect branch isolation between guest and host userspace. But, a guest
could still poison the branch history.

To mitigate that, use the recently added clear_bhb_long_loop() to isolate
the branch history between guest and userspace. Add cmdline option
'vmscape=on' that automatically selects the appropriate mitigation based
on the CPU.

Acked-by: David Kaplan <david.kaplan@amd.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 Documentation/admin-guide/hw-vuln/vmscape.rst   |  8 ++++
 Documentation/admin-guide/kernel-parameters.txt |  4 +-
 arch/x86/include/asm/cpufeatures.h              |  1 +
 arch/x86/include/asm/entry-common.h             | 12 +++---
 arch/x86/include/asm/nospec-branch.h            |  2 +-
 arch/x86/kernel/cpu/bugs.c                      | 53 ++++++++++++++++++-------
 arch/x86/kvm/x86.c                              |  5 ++-
 7 files changed, 61 insertions(+), 24 deletions(-)

diff --git a/Documentation/admin-guide/hw-vuln/vmscape.rst b/Documentation/admin-guide/hw-vuln/vmscape.rst
index d9b9a2b6c114c05a7325e5f3c9d42129339b870b..580f288ae8bfc601ff000d6d95d711bb9084459e 100644
--- a/Documentation/admin-guide/hw-vuln/vmscape.rst
+++ b/Documentation/admin-guide/hw-vuln/vmscape.rst
@@ -86,6 +86,10 @@ The possible values in this file are:
    run a potentially malicious guest and issues an IBPB before the first
    exit to userspace after VM-exit.
 
+ * 'Mitigation: Clear BHB before exit to userspace':
+
+   As above, conditional BHB clearing mitigation is enabled.
+
  * 'Mitigation: IBPB on VMEXIT':
 
    IBPB is issued on every VM-exit. This occurs when other mitigations like
@@ -108,3 +112,7 @@ The mitigation can be controlled via the ``vmscape=`` command line parameter:
 
    Force vulnerability detection and mitigation even on processors that are
    not known to be affected.
+
+ * ``vmscape=on``:
+
+   Choose the mitigation based on the VMSCAPE variant the CPU is affected by.
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 6c42061ca20e581b5192b66c6f25aba38d4f8ff8..4b4711ced5e187495476b5365cd7b3df81db893b 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -8104,9 +8104,11 @@
 
 			off		- disable the mitigation
 			ibpb		- use Indirect Branch Prediction Barrier
-					  (IBPB) mitigation (default)
+					  (IBPB) mitigation
 			force		- force vulnerability detection even on
 					  unaffected processors
+			on		- (default) automatically select IBPB
+			                  or BHB clear mitigation based on CPU
 
 	vsyscall=	[X86-64,EARLY]
 			Controls the behavior of vsyscalls (i.e. calls to
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 4091a776e37aaed67ca93b0a0cd23cc25dbc33d4..3d547c3eab4e3290de3eee8e89f21587fee34931 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -499,6 +499,7 @@
 #define X86_FEATURE_IBPB_EXIT_TO_USER	(21*32+14) /* Use IBPB on exit-to-userspace, see VMSCAPE bug */
 #define X86_FEATURE_ABMC		(21*32+15) /* Assignable Bandwidth Monitoring Counters */
 #define X86_FEATURE_MSR_IMM		(21*32+16) /* MSR immediate form instructions */
+#define X86_FEATURE_CLEAR_BHB_EXIT_TO_USER (21*32+17) /* Clear branch history on exit-to-userspace, see VMSCAPE bug */
 
 /*
  * BUG word(s)
diff --git a/arch/x86/include/asm/entry-common.h b/arch/x86/include/asm/entry-common.h
index ce3eb6d5fdf9f2dba59b7bad24afbfafc8c36918..b629e85c33aa7387042cce60040b8a493e3e6d46 100644
--- a/arch/x86/include/asm/entry-common.h
+++ b/arch/x86/include/asm/entry-common.h
@@ -94,11 +94,13 @@ static inline void arch_exit_to_user_mode_prepare(struct pt_regs *regs,
 	 */
 	choose_random_kstack_offset(rdtsc());
 
-	/* Avoid unnecessary reads of 'x86_ibpb_exit_to_user' */
-	if (cpu_feature_enabled(X86_FEATURE_IBPB_EXIT_TO_USER) &&
-	    this_cpu_read(x86_ibpb_exit_to_user)) {
-		indirect_branch_prediction_barrier();
-		this_cpu_write(x86_ibpb_exit_to_user, false);
+	if (unlikely(this_cpu_read(x86_predictor_flush_exit_to_user))) {
+		if (cpu_feature_enabled(X86_FEATURE_IBPB_EXIT_TO_USER))
+			indirect_branch_prediction_barrier();
+		if (cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_EXIT_TO_USER))
+			clear_bhb_long_loop();
+
+		this_cpu_write(x86_predictor_flush_exit_to_user, false);
 	}
 }
 #define arch_exit_to_user_mode_prepare arch_exit_to_user_mode_prepare
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 49707e563bdf71bdd05d3827f10dd2b8ac6bca2c..745394be734f3c2b5640c9aef10156fe1d02636b 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -534,7 +534,7 @@ void alternative_msr_write(unsigned int msr, u64 val, unsigned int feature)
 		: "memory");
 }
 
-DECLARE_PER_CPU(bool, x86_ibpb_exit_to_user);
+DECLARE_PER_CPU(bool, x86_predictor_flush_exit_to_user);
 
 static inline void indirect_branch_prediction_barrier(void)
 {
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index d7fa03bf51b4517c12cc68e7c441f7589a4983d1..592730201b6e50a6b1f381e4179a0e45560418cc 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -109,12 +109,11 @@ DEFINE_PER_CPU(u64, x86_spec_ctrl_current);
 EXPORT_PER_CPU_SYMBOL_GPL(x86_spec_ctrl_current);
 
 /*
- * Set when the CPU has run a potentially malicious guest. An IBPB will
- * be needed to before running userspace. That IBPB will flush the branch
- * predictor content.
+ * Set when the CPU has run a potentially malicious guest. Indicates that a
+ * branch predictor flush is needed before running userspace.
  */
-DEFINE_PER_CPU(bool, x86_ibpb_exit_to_user);
-EXPORT_PER_CPU_SYMBOL_GPL(x86_ibpb_exit_to_user);
+DEFINE_PER_CPU(bool, x86_predictor_flush_exit_to_user);
+EXPORT_PER_CPU_SYMBOL_GPL(x86_predictor_flush_exit_to_user);
 
 u64 x86_pred_cmd __ro_after_init = PRED_CMD_IBPB;
 
@@ -3197,13 +3196,15 @@ enum vmscape_mitigations {
 	VMSCAPE_MITIGATION_AUTO,
 	VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER,
 	VMSCAPE_MITIGATION_IBPB_ON_VMEXIT,
+	VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER,
 };
 
 static const char * const vmscape_strings[] = {
-	[VMSCAPE_MITIGATION_NONE]		= "Vulnerable",
+	[VMSCAPE_MITIGATION_NONE]			= "Vulnerable",
 	/* [VMSCAPE_MITIGATION_AUTO] */
-	[VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER]	= "Mitigation: IBPB before exit to userspace",
-	[VMSCAPE_MITIGATION_IBPB_ON_VMEXIT]	= "Mitigation: IBPB on VMEXIT",
+	[VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER]		= "Mitigation: IBPB before exit to userspace",
+	[VMSCAPE_MITIGATION_IBPB_ON_VMEXIT]		= "Mitigation: IBPB on VMEXIT",
+	[VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER]	= "Mitigation: Clear BHB before exit to userspace",
 };
 
 static enum vmscape_mitigations vmscape_mitigation __ro_after_init =
@@ -3221,6 +3222,8 @@ static int __init vmscape_parse_cmdline(char *str)
 	} else if (!strcmp(str, "force")) {
 		setup_force_cpu_bug(X86_BUG_VMSCAPE);
 		vmscape_mitigation = VMSCAPE_MITIGATION_AUTO;
+	} else if (!strcmp(str, "on")) {
+		vmscape_mitigation = VMSCAPE_MITIGATION_AUTO;
 	} else {
 		pr_err("Ignoring unknown vmscape=%s option.\n", str);
 	}
@@ -3231,18 +3234,35 @@ early_param("vmscape", vmscape_parse_cmdline);
 
 static void __init vmscape_select_mitigation(void)
 {
-	if (!boot_cpu_has_bug(X86_BUG_VMSCAPE) ||
-	    !boot_cpu_has(X86_FEATURE_IBPB)) {
+	if (!boot_cpu_has_bug(X86_BUG_VMSCAPE)) {
 		vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
 		return;
 	}
 
-	if (vmscape_mitigation == VMSCAPE_MITIGATION_AUTO) {
-		if (should_mitigate_vuln(X86_BUG_VMSCAPE))
-			vmscape_mitigation = VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER;
-		else
-			vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
+	if (vmscape_mitigation == VMSCAPE_MITIGATION_AUTO &&
+	    !should_mitigate_vuln(X86_BUG_VMSCAPE))
+		vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
+
+	if (vmscape_mitigation == VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER &&
+	    !boot_cpu_has(X86_FEATURE_IBPB)) {
+		pr_err("IBPB not supported, switching to AUTO select\n");
+		vmscape_mitigation = VMSCAPE_MITIGATION_AUTO;
 	}
+
+	if (vmscape_mitigation != VMSCAPE_MITIGATION_AUTO)
+		return;
+
+	/*
+	 * CPUs with BHI_CTRL(ADL and newer) can avoid the IBPB and use BHB
+	 * clear sequence. These CPUs are only vulnerable to the BHI variant
+	 * of the VMSCAPE attack and does not require an IBPB flush.
+	 */
+	if (boot_cpu_has(X86_FEATURE_BHI_CTRL))
+		vmscape_mitigation = VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER;
+	else if (boot_cpu_has(X86_FEATURE_IBPB))
+		vmscape_mitigation = VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER;
+	else
+		vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
 }
 
 static void __init vmscape_update_mitigation(void)
@@ -3261,6 +3281,8 @@ static void __init vmscape_apply_mitigation(void)
 {
 	if (vmscape_mitigation == VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER)
 		setup_force_cpu_cap(X86_FEATURE_IBPB_EXIT_TO_USER);
+	else if (vmscape_mitigation == VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER)
+		setup_force_cpu_cap(X86_FEATURE_CLEAR_BHB_EXIT_TO_USER);
 }
 
 #undef pr_fmt
@@ -3352,6 +3374,7 @@ void cpu_bugs_smt_update(void)
 		break;
 	case VMSCAPE_MITIGATION_IBPB_ON_VMEXIT:
 	case VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER:
+	case VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER:
 		/*
 		 * Hypervisors can be attacked across-threads, warn for SMT when
 		 * STIBP is not already enabled system-wide.
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b4b5d2d0963467a81c7cc00575547619654295c6..0212de0ec2da153acb4218dc187dfcb87eae7115 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11397,8 +11397,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 * set for the CPU that actually ran the guest, and not the CPU that it
 	 * may migrate to.
 	 */
-	if (cpu_feature_enabled(X86_FEATURE_IBPB_EXIT_TO_USER))
-		this_cpu_write(x86_ibpb_exit_to_user, true);
+	if (cpu_feature_enabled(X86_FEATURE_IBPB_EXIT_TO_USER) ||
+	    cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_EXIT_TO_USER))
+		this_cpu_write(x86_predictor_flush_exit_to_user, true);
 
 	/*
 	 * Consume any pending interrupts, including the possible source of

-- 
2.34.1



