Return-Path: <kvm+bounces-54371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A39DEB1FF63
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 08:31:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ABE4A1894865
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 06:31:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 320722D662E;
	Mon, 11 Aug 2025 06:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xm7JoG4U"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13AE2BD580
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 06:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754893859; cv=none; b=gszGpJ+ce4lo/n3gS+F3KKTc+hzsOpa8TmOFvXnbeiw8fHPX92/lyhkaUITfez38Kx2kkPCvCCQSzsgxnec4oIPl1MO8DLgZ2VSWkGeNIaaHkOtY4+tx37TcKNmPS/37oTxt+hMNbNylySELXRQkRS1wZ+4k2kf2KjgfA9h0HTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754893859; c=relaxed/simple;
	bh=bEnI7ly8+ujv3pMEd5BrfvelITt/bTH6sKbARZelbD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AABjaWXsNKGEgery9M0RWgP12X4dMTlTtoBGQ8YhORXS6drT0AZKEj+Bk31ionFZbXLptcyHthDbwE0n3S9i4jgRMWxQvUXLTea+Pdi5AXy+Y/5LFZ3OWDZ7F5Sjxh9OgijvYB1c8VssuWvGZnzRScpXBl/8EsCxog+eSVcRQvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xm7JoG4U; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754893858; x=1786429858;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bEnI7ly8+ujv3pMEd5BrfvelITt/bTH6sKbARZelbD8=;
  b=Xm7JoG4UiNmm4xgjrgE/dbwasDPuQdGMAL17JPnDIcuIU5Q0Vb0ydivY
   p35LyVZNapN9s+8PZ+ae9eLTXlxU1TWPS12u3G9NkEVkd8f0GT6Uo8eKF
   AiJXZoJY/NBBCHYb1q4dNGWsPzA4YzQKS9A4hj7CKYBTlrEVG/6EQJWSF
   1h5+BnqOBW+ug3LNwLtYrWBwbwX/8iKN0rinXukd3Ptx0y5nH8oBBlrh0
   wmyDCd9Q8VHmb/P+yJmIyS4GXdMFkDt+Y6vYpVc81Q6yZZ4Xy+hA0I8Zs
   33hPtdcVYYkKmCj07MxOFsJ1pYzB5mFoKa7D/aaIlOoVeSnsZ4+AX0ucs
   Q==;
X-CSE-ConnectionGUID: qX1qZBEWThWRDRwMZ/gLow==
X-CSE-MsgGUID: 5CtnQPY4RmibDi/1vx8o0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="79707663"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="79707663"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2025 23:30:57 -0700
X-CSE-ConnectionGUID: vlDx8yYwQ+uOWagnmg9Xhw==
X-CSE-MsgGUID: afwGACJgTBajYdhGDX11tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="196666476"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2025 23:30:55 -0700
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>,
	kvm@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [kvm-unit-tests PATCH 1/2] nVMX: Remove the IA32_DEBUGCTLMSR access in debugctls test
Date: Mon, 11 Aug 2025 14:30:33 +0800
Message-ID: <20250811063035.12626-2-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250811063035.12626-1-chenyi.qiang@intel.com>
References: <20250811063035.12626-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Current debug controls test can pass but will trigger some error
messages because it tries to access LBR (bit 0) and BTF (bit 1) in
IA32_DEBUGCTLMSR:

  kvm_intel: kvm [18663]: vcpu0, guest rIP: 0x407de7 Unhandled WRMSR(0x1d9) = 0x1
  kvm_intel: kvm [18663]: vcpu0, guest rIP: 0x0 Unhandled WRMSR(0x1d9) = 0x2
  kvm_intel: kvm [18663]: vcpu0, guest rIP: 0x40936f Unhandled WRMSR(0x1d9) = 0x3
  kvm_intel: kvm [18663]: vcpu0, guest rIP: 0x40cf09 Unhandled WRMSR(0x1d9) = 0x1
  kvm_intel: kvm [18663]: vcpu0, guest rIP: 0x40940d Unhandled WRMSR(0x1d9) = 0x3

The IA32_DEBUGCTLMSR value isn't used as a criterion for determining
whether the test is passed. It only provides some hints on the expected
values with the control of {ENT_LOAD, EXIT_SAVE}_DBGCTLS. The reality is
different because KVM only allows the guest to access the valid bits
depending on the supported features. Luckily, KVM will exempt BTF and
LBR from validity check which makes the test survive.

Considering that IA32_DEBUGCTLMSR access is not practically effective
and will bring error messages, eliminate the related code and rename
the test to specifically address the DR7 check.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 x86/vmx_tests.c | 46 ++++++++++++++--------------------------------
 1 file changed, 14 insertions(+), 32 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 0b3cfe50..1832bda3 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -1850,21 +1850,18 @@ static int nmi_hlt_exit_handler(union exit_reason exit_reason)
 }
 
 
-static int dbgctls_init(struct vmcs *vmcs)
+static int dbgctls_dr7_init(struct vmcs *vmcs)
 {
 	u64 dr7 = 0x402;
 	u64 zero = 0;
 
-	msr_bmp_init();
 	asm volatile(
 		"mov %0,%%dr0\n\t"
 		"mov %0,%%dr1\n\t"
 		"mov %0,%%dr2\n\t"
 		"mov %1,%%dr7\n\t"
 		: : "r" (zero), "r" (dr7));
-	wrmsr(MSR_IA32_DEBUGCTLMSR, 0x1);
 	vmcs_write(GUEST_DR7, 0x404);
-	vmcs_write(GUEST_DEBUGCTL, 0x2);
 
 	vmcs_write(ENT_CONTROLS, vmcs_read(ENT_CONTROLS) | ENT_LOAD_DBGCTLS);
 	vmcs_write(EXI_CONTROLS, vmcs_read(EXI_CONTROLS) | EXI_SAVE_DBGCTLS);
@@ -1872,23 +1869,19 @@ static int dbgctls_init(struct vmcs *vmcs)
 	return VMX_TEST_START;
 }
 
-static void dbgctls_main(void)
+static void dbgctls_dr7_main(void)
 {
-	u64 dr7, debugctl;
+	u64 dr7;
 
 	asm volatile("mov %%dr7,%0" : "=r" (dr7));
-	debugctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
-	/* Commented out: KVM does not support DEBUGCTL so far */
-	(void)debugctl;
-	report(dr7 == 0x404, "Load debug controls" /* && debugctl == 0x2 */);
+	report(dr7 == 0x404, "DR7: Load debug controls");
 
 	dr7 = 0x408;
 	asm volatile("mov %0,%%dr7" : : "r" (dr7));
-	wrmsr(MSR_IA32_DEBUGCTLMSR, 0x3);
 
 	vmx_set_test_stage(0);
 	vmcall();
-	report(vmx_get_test_stage() == 1, "Save debug controls");
+	report(vmx_get_test_stage() == 1, "DR7: Save debug controls");
 
 	if (ctrl_enter_rev.set & ENT_LOAD_DBGCTLS ||
 	    ctrl_exit_rev.set & EXI_SAVE_DBGCTLS) {
@@ -1899,46 +1892,37 @@ static void dbgctls_main(void)
 	vmcall();
 
 	asm volatile("mov %%dr7,%0" : "=r" (dr7));
-	debugctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
-	/* Commented out: KVM does not support DEBUGCTL so far */
-	(void)debugctl;
 	report(dr7 == 0x402,
-	       "Guest=host debug controls" /* && debugctl == 0x1 */);
+	       "DR7: Guest=host debug controls");
 
 	dr7 = 0x408;
 	asm volatile("mov %0,%%dr7" : : "r" (dr7));
-	wrmsr(MSR_IA32_DEBUGCTLMSR, 0x3);
 
 	vmx_set_test_stage(3);
 	vmcall();
-	report(vmx_get_test_stage() == 4, "Don't save debug controls");
+	report(vmx_get_test_stage() == 4, "DR7: Don't save debug controls");
 }
 
-static int dbgctls_exit_handler(union exit_reason exit_reason)
+static int dbgctls_dr7_exit_handler(union exit_reason exit_reason)
 {
 	u32 insn_len = vmcs_read(EXI_INST_LEN);
 	u64 guest_rip = vmcs_read(GUEST_RIP);
-	u64 dr7, debugctl;
+	u64 dr7;
 
 	asm volatile("mov %%dr7,%0" : "=r" (dr7));
-	debugctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
 
 	switch (exit_reason.basic) {
 	case VMX_VMCALL:
 		switch (vmx_get_test_stage()) {
 		case 0:
-			if (dr7 == 0x400 && debugctl == 0 &&
-			    vmcs_read(GUEST_DR7) == 0x408 /* &&
-			    Commented out: KVM does not support DEBUGCTL so far
-			    vmcs_read(GUEST_DEBUGCTL) == 0x3 */)
+			if (dr7 == 0x400 &&
+			    vmcs_read(GUEST_DR7) == 0x408)
 				vmx_inc_test_stage();
 			break;
 		case 2:
 			dr7 = 0x402;
 			asm volatile("mov %0,%%dr7" : : "r" (dr7));
-			wrmsr(MSR_IA32_DEBUGCTLMSR, 0x1);
 			vmcs_write(GUEST_DR7, 0x404);
-			vmcs_write(GUEST_DEBUGCTL, 0x2);
 
 			vmcs_write(ENT_CONTROLS,
 				vmcs_read(ENT_CONTROLS) & ~ENT_LOAD_DBGCTLS);
@@ -1946,10 +1930,8 @@ static int dbgctls_exit_handler(union exit_reason exit_reason)
 				vmcs_read(EXI_CONTROLS) & ~EXI_SAVE_DBGCTLS);
 			break;
 		case 3:
-			if (dr7 == 0x400 && debugctl == 0 &&
-			    vmcs_read(GUEST_DR7) == 0x404 /* &&
-			    Commented out: KVM does not support DEBUGCTL so far
-			    vmcs_read(GUEST_DEBUGCTL) == 0x2 */)
+			if (dr7 == 0x400 &&
+			    vmcs_read(GUEST_DR7) == 0x404)
 				vmx_inc_test_stage();
 			break;
 		}
@@ -11402,7 +11384,7 @@ struct vmx_test vmx_tests[] = {
 		interrupt_exit_handler, NULL, {0} },
 	{ "nmi_hlt", nmi_hlt_init, nmi_hlt_main,
 		nmi_hlt_exit_handler, NULL, {0} },
-	{ "debug controls", dbgctls_init, dbgctls_main, dbgctls_exit_handler,
+	{ "debug controls dr7", dbgctls_dr7_init, dbgctls_dr7_main, dbgctls_dr7_exit_handler,
 		NULL, {0} },
 	{ "MSR switch", msr_switch_init, msr_switch_main,
 		msr_switch_exit_handler, NULL, {0}, msr_switch_entry_failure },
-- 
2.43.5


