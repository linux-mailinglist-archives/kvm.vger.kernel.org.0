Return-Path: <kvm+bounces-54372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2031FB1FF64
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 08:31:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA46F3B457E
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 06:31:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38BCD27F005;
	Mon, 11 Aug 2025 06:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RCi3Wd9F"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70A52472B5
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 06:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754893860; cv=none; b=Da3IjAWfNDmWf5/Do9IsoTYWgJz2zP+e8NjUFx3zOoPEQXYh4UBEEty+JIMEIRucPq1716lkhEIMIx9fkVnd5lLxIPE1Lo67sEkQWdr8VvvBO4VKvniXlT8ND2HkbfTiUIr3kqMklM+hOGH4bRLpKnAYnngwsZCbZftNqlV3YRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754893860; c=relaxed/simple;
	bh=mGUpX4WS9wfIFkw/95FRbsHW3HLjNG7iYS4odbqc8O0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LC582F2KJthaPblOcsCCYo3Dldrp0ZsMchj0jUeesIBKMDI2qIH2t3XcYopI/UzjUWhQX28Is2eXFS5ExV/zzN9sRbuL8wVNmZYGnKMkXXZ62nKS8KTetEAp3Dv4UJgPQzSFsIILqOnUFzl9zykW42QMOkS6azlWVpUglk4gEZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RCi3Wd9F; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754893859; x=1786429859;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mGUpX4WS9wfIFkw/95FRbsHW3HLjNG7iYS4odbqc8O0=;
  b=RCi3Wd9FbBf1bVL9tzGlliSzUkxHr1rsce9Vm038Tew6IxCUs7vqSX4f
   JGp2yYuleCNphF8ZW6+xQ5hLMJhXkFmvIYPwO4bxW1JKEWQ7Xwv8Jalfw
   aO570joIMFxR1s99rBIyZPTZT3udZLPkTRWNPdJYC23i/Dvj/M5vdGU3V
   Y+oQ4jS9uI8wqnsi9WvlC1M9HbJVh1hLMQkirrmGNp0QTTMhV9Cw1P2dj
   NnbEgESjhfQpGQgmSKxa2DwZiqoT7sW6XOJTl1rtrcTl207OpoVA1eaNX
   PZaSUIR2MvomecJltWOLaSLxdWQ6RoeFwv8b1KQm5iA1NZvs1T3shmVsx
   w==;
X-CSE-ConnectionGUID: 8Fxy5SuFSJOREXpG8kGVsQ==
X-CSE-MsgGUID: AbarfXzmRpaX8foPnTFn4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="79707684"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="79707684"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2025 23:30:59 -0700
X-CSE-ConnectionGUID: meUYSaMASl+sHQdaibF//g==
X-CSE-MsgGUID: 84lE4hkuRXCoJu3MAtBLkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="196666484"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2025 23:30:57 -0700
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>,
	kvm@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [kvm-unit-tests PATCH 2/2] nVMX: Test IA32_DEBUGCTLMSR behavior on set and cleared save/load debug controls
Date: Mon, 11 Aug 2025 14:30:34 +0800
Message-ID: <20250811063035.12626-3-chenyi.qiang@intel.com>
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

Besides the existing DR7 test on debug controls, introduce a similar
separate test for IA32_DEBUGCTLMSR.

Previously, the IA32_DEBUGCTLMSR was combined with the DR7 test. However,
it attempted to access the LBR and BTF bits in the MSR which can be
invalid. Although KVM will exempt these two bits from validity check,
they will be cleared and resulted in the unexpected MSR value.

In this new test, access a valid bit (DEBUGCTLMSR_BUS_LOCK_DETECT, bit 2)
based on the enumration of Bus Lock Detect.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 x86/vmx_tests.c | 88 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 1832bda3..9a2e598f 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -1944,6 +1944,92 @@ static int dbgctls_dr7_exit_handler(union exit_reason exit_reason)
 	return VMX_TEST_VMEXIT;
 }
 
+static int dbgctls_msr_init(struct vmcs *vmcs)
+{
+	/* Check for DEBUGCTLMSR_BUS_LOCK_DETECT(bit 2) in IA32_DEBUGCTLMSR */
+	if (!(cpuid(7).c & (1 << 24))) {
+		report_skip("%s : \"Bus Lock Detect\" not supported", __func__);
+		return VMX_TEST_VMSKIP;
+	}
+
+	msr_bmp_init();
+	wrmsr(MSR_IA32_DEBUGCTLMSR, 0x0);
+	vmcs_write(GUEST_DEBUGCTL, 0x4);
+
+	vmcs_write(ENT_CONTROLS, vmcs_read(ENT_CONTROLS) | ENT_LOAD_DBGCTLS);
+	vmcs_write(EXI_CONTROLS, vmcs_read(EXI_CONTROLS) | EXI_SAVE_DBGCTLS);
+
+	return VMX_TEST_START;
+}
+
+static void dbgctls_msr_main(void)
+{
+	u64 debugctl;
+
+	debugctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
+	report(debugctl == 0x4, "DEBUGCTLMSR: Load debug controls");
+
+	vmx_set_test_stage(0);
+	vmcall();
+	report(vmx_get_test_stage() == 1, "DEBUGCTLMSR: Save debug controls");
+
+	if (ctrl_enter_rev.set & ENT_LOAD_DBGCTLS ||
+	    ctrl_exit_rev.set & EXI_SAVE_DBGCTLS) {
+		printf("\tDebug controls are always loaded/saved\n");
+		return;
+	}
+	vmx_set_test_stage(2);
+	vmcall();
+
+	debugctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
+	report(debugctl == 0x0,
+	       "DEBUGCTLMSR: Guest=host debug controls");
+
+	vmx_set_test_stage(3);
+	vmcall();
+	report(vmx_get_test_stage() == 4, "DEBUGCTLMSR: Don't save debug controls");
+}
+
+static int dbgctls_msr_exit_handler(union exit_reason exit_reason)
+{
+	u32 insn_len = vmcs_read(EXI_INST_LEN);
+	u64 guest_rip = vmcs_read(GUEST_RIP);
+	u64 debugctl;
+
+	debugctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
+
+	switch (exit_reason.basic) {
+	case VMX_VMCALL:
+		switch (vmx_get_test_stage()) {
+		case 0:
+			if (debugctl == 0 &&
+			    vmcs_read(GUEST_DEBUGCTL) == 0x4)
+				vmx_inc_test_stage();
+			break;
+		case 2:
+			wrmsr(MSR_IA32_DEBUGCTLMSR, 0x0);
+			vmcs_write(GUEST_DEBUGCTL, 0x4);
+
+			vmcs_write(ENT_CONTROLS,
+				vmcs_read(ENT_CONTROLS) & ~ENT_LOAD_DBGCTLS);
+			vmcs_write(EXI_CONTROLS,
+				vmcs_read(EXI_CONTROLS) & ~EXI_SAVE_DBGCTLS);
+			break;
+		case 3:
+			if (debugctl == 0 &&
+			    vmcs_read(GUEST_DEBUGCTL) == 0x4)
+				vmx_inc_test_stage();
+			break;
+		}
+		vmcs_write(GUEST_RIP, guest_rip + insn_len);
+		return VMX_TEST_RESUME;
+	default:
+		report_fail("Unknown exit reason, %d", exit_reason.full);
+		print_vmexit_info(exit_reason);
+	}
+	return VMX_TEST_VMEXIT;
+}
+
 struct vmx_msr_entry {
 	u32 index;
 	u32 reserved;
@@ -11386,6 +11472,8 @@ struct vmx_test vmx_tests[] = {
 		nmi_hlt_exit_handler, NULL, {0} },
 	{ "debug controls dr7", dbgctls_dr7_init, dbgctls_dr7_main, dbgctls_dr7_exit_handler,
 		NULL, {0} },
+	{ "debug controls msr", dbgctls_msr_init, dbgctls_msr_main, dbgctls_msr_exit_handler,
+		NULL, {0} },
 	{ "MSR switch", msr_switch_init, msr_switch_main,
 		msr_switch_exit_handler, NULL, {0}, msr_switch_entry_failure },
 	{ "vmmcall", vmmcall_init, vmmcall_main, vmmcall_exit_handler, NULL, {0} },
-- 
2.43.5


