Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21F61FBCF2
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 01:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfKNARv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 19:17:51 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:37245 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbfKNARu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 19:17:50 -0500
Received: by mail-pf1-f202.google.com with SMTP id z21so3056975pfr.4
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 16:17:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=nylFVGJM1JJqusN0N1wcSxuBrkk2n/VpoC80tEizbbo=;
        b=sAjH4Y5gL2mt6UMK2kf5yARh8OTj5UIfaYWHbTd9M5V4JMqgos42Tg/DCMW06kLp9g
         vupSKG5WCyJlJCp0RU61KHKYBDvaM8OmeaRAVeJCxpMKGdBhIC4YTniSejOQMO6M89y9
         WGywFklM0W5pvn54p7QQeaIwHfvW4w+vCL9oTRjKclO4RJ2M+2HSvd+2GbmdWC8CGuqq
         5HMzsLdfPaJf9sduu8gIsW2Tw9sn4gDW9R/qnrXArtfybsbpFFbm8nB4cgAPhtdfpbbf
         2R6RN2jOFyAuyf5i/uUBrnD8sTYyyV7TiHEvJc1x6vZQxZmGLACMX3gxw4S2TsW+TCGe
         A0hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nylFVGJM1JJqusN0N1wcSxuBrkk2n/VpoC80tEizbbo=;
        b=RggbJQSJuSen1dh8w0KyVh+LDJRA4H2j5hHMh4S0DpV8fLDi4+36Icwsrlx7Cz5leM
         fJh96rWkNUwFSLTXPJRXz/x0dTzu9OfA4prOi0nJXmeyvhAxmMCJzIuccf/YsSuz5TUf
         Ocr9inz/w5JsXP+m54Dmiu1CMIMw4hBAXp1eFvYaohYTv93yW4C4S4Te+xWpjqBez6xu
         AKd4s1u4gBHbJSxgj7uAttpvz8gNtowIFKqmryQ2Y+KNzgUuQPaP5bfAUYyozt0xjvOq
         3edm3+HgRIAoXUs7yYbhBofrqD6J7Nm0TN7s8nnhtapp/ZXwtcIALZ6NQA347VjuH89c
         knHw==
X-Gm-Message-State: APjAAAVsIRo36/mCLC+57SEIMA6rv0sJzUSZCrDYB7yvRBAz0afWDYQx
        RFXWMNKXSxlGeKWCs1WJXuUIHanWR9/PET5XjCLDLazECH/1nQWbZKb8p7B0/U5n4wTpwqShJm9
        yT/wO/4l2KUTn9VigLho5aONN+OsWkgfB+sRdpeY5Fb4zoJKbdk5TkWQQoA==
X-Google-Smtp-Source: APXvYqx58cV1ipuSvVsP9sH39FzPYPrlpcsiTIbWcguNaTZ7WlUYpMfUeD+KnalrUNa7g3K2KuMYo4u/SfY=
X-Received: by 2002:a63:555b:: with SMTP id f27mr6792946pgm.66.1573690669314;
 Wed, 13 Nov 2019 16:17:49 -0800 (PST)
Date:   Wed, 13 Nov 2019 16:17:22 -0800
In-Reply-To: <20191114001722.173836-1-oupton@google.com>
Message-Id: <20191114001722.173836-9-oupton@google.com>
Mime-Version: 1.0
References: <20191114001722.173836-1-oupton@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [kvm-unit-tests PATCH v5 8/8] x86: VMX: Add tests for nested "load IA32_PERF_GLOBAL_CTRL"
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tests to verify that KVM performs the correct checks on Host/Guest state
at VM-entry, as described in SDM 26.3.1.1 "Checks on Guest Control
Registers, Debug Registers, and MSRs" and SDM 26.2.2 "Checks on Host
Control Registers and MSRs".

Test that KVM does the following:

    If the "load IA32_PERF_GLOBAL_CTRL" VM-entry control is 1, the
    reserved bits of the IA32_PERF_GLOBAL_CTRL MSR must be 0 in the
    GUEST_IA32_PERF_GLOBAL_CTRL VMCS field. Otherwise, the VM-entry
    should fail with an exit reason of "VM-entry failure due to invalid
    guest state" (33). On a successful VM-entry, the correct value
    should be observed when the nested VM performs an RDMSR on
    IA32_PERF_GLOBAL_CTRL.

    If the "load IA32_PERF_GLOBAL_CTRL" VM-exit control is 1, the
    reserved bits of the IA32_PERF_GLOBAL_CTRL MSR must be 0 in the
    HOST_IA32_PERF_GLOBAL_CTRL VMCS field. Otherwise, the VM-entry
    should fail with a VM-instruction error of "VM entry with invalid
    host-state field(s)" (8). On a successful VM-exit, the correct value
    should be observed when L1 performs an RDMSR on
    IA32_PERF_GLOBAL_CTRL.

Suggested-by: Jim Mattson <jmattson@google.com>
Co-developed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/vmx_tests.c | 160 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 160 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 95c1c01d2966..0d5e463f9887 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7032,6 +7032,164 @@ static void test_load_host_pat(void)
 	test_pat(HOST_PAT, "HOST_PAT", EXI_CONTROLS, EXI_LOAD_PAT);
 }
 
+union cpuidA_eax {
+	struct {
+		unsigned int version_id:8;
+		unsigned int num_counters_gp:8;
+		unsigned int bit_width:8;
+		unsigned int mask_length:8;
+	} split;
+	unsigned int full;
+};
+
+union cpuidA_edx {
+	struct {
+		unsigned int num_counters_fixed:5;
+		unsigned int bit_width_fixed:8;
+		unsigned int reserved:9;
+	} split;
+	unsigned int full;
+};
+
+static bool valid_pgc(u64 val)
+{
+	struct cpuid id;
+	union cpuidA_eax eax;
+	union cpuidA_edx edx;
+	u64 mask;
+
+	id = cpuid(0xA);
+	eax.full = id.a;
+	edx.full = id.d;
+	mask = ~(((1ull << eax.split.num_counters_gp) - 1) |
+		 (((1ull << edx.split.num_counters_fixed) - 1) << 32));
+
+	return !(val & mask);
+}
+
+static void test_pgc_vmlaunch(u32 xerror, u32 xreason, bool xfail, bool host)
+{
+	u32 inst_err;
+	u64 obs;
+	bool success;
+	struct vmx_state_area_test_data *data = &vmx_state_area_test_data;
+
+	if (host) {
+		success = vmlaunch_succeeds();
+		obs = rdmsr(data->msr);
+		if (!success) {
+			inst_err = vmcs_read(VMX_INST_ERROR);
+			report("vmlaunch failed, VMX Inst Error is %d (expected %d)",
+			       xerror == inst_err, inst_err, xerror);
+		} else {
+			report("Host state is 0x%lx (expected 0x%lx)",
+			       !data->enabled || data->exp == obs, obs, data->exp);
+			report("vmlaunch succeeded", success != xfail);
+		}
+	} else {
+		if (xfail) {
+			enter_guest_with_invalid_guest_state();
+		} else {
+			enter_guest();
+		}
+		report_guest_state_test("load GUEST_PERF_GLOBAL_CTRL",
+					xreason, GUEST_PERF_GLOBAL_CTRL,
+					"GUEST_PERF_GLOBAL_CTRL");
+	}
+}
+
+/*
+ * test_load_perf_global_ctrl is a generic function for testing the
+ * "load IA32_PERF_GLOBAL_CTRL" VM-{Entry,Exit} controls. This test function
+ * tests the provided ctrl_val when disabled and enabled.
+ *
+ * @nr: VMCS field number corresponding to the host/guest state field
+ * @name: Name of the above VMCS field for printing in test report
+ * @ctrl_nr: VMCS field number corresponding to the VM-{Entry,Exit} control
+ * @ctrl_val: Bit to set on the ctrl_field
+ */
+static void test_perf_global_ctrl(u32 nr, const char *name, u32 ctrl_nr,
+				  const char *ctrl_name, u64 ctrl_val)
+{
+	u64 ctrl_saved = vmcs_read(ctrl_nr);
+	u64 pgc_saved = vmcs_read(nr);
+	u64 i, val;
+	bool host = nr == HOST_PERF_GLOBAL_CTRL;
+	struct vmx_state_area_test_data *data = &vmx_state_area_test_data;
+
+	data->msr = MSR_CORE_PERF_GLOBAL_CTRL;
+	msr_bmp_init();
+	vmcs_write(ctrl_nr, ctrl_saved & ~ctrl_val);
+	data->enabled = false;
+	report_prefix_pushf("\"load IA32_PERF_GLOBAL_CTRL\"=0 on %s",
+			    ctrl_name);
+
+	for (i = 0; i < 64; i++) {
+		val = 1ull << i;
+		vmcs_write(nr, val);
+		report_prefix_pushf("%s = 0x%lx", name, val);
+		test_pgc_vmlaunch(0, VMX_VMCALL, false, host);
+		report_prefix_pop();
+	}
+	report_prefix_pop();
+
+	vmcs_write(ctrl_nr, ctrl_saved | ctrl_val);
+	data->enabled = true;
+	report_prefix_pushf("\"load IA32_PERF_GLOBAL_CTRL\"=1 on %s",
+			    ctrl_name);
+	for (i = 0; i < 64; i++) {
+		val = 1ull << i;
+		data->exp = val;
+		vmcs_write(nr, val);
+		report_prefix_pushf("%s = 0x%lx", name, val);
+		if (valid_pgc(val)) {
+			test_pgc_vmlaunch(0, VMX_VMCALL, false, host);
+		} else {
+			if (host)
+				test_pgc_vmlaunch(
+					VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
+					0,
+					true,
+					host);
+			else
+				test_pgc_vmlaunch(
+					0,
+					VMX_ENTRY_FAILURE | VMX_FAIL_STATE,
+					true,
+					host);
+		}
+		report_prefix_pop();
+	}
+
+	report_prefix_pop();
+	vmcs_write(ctrl_nr, ctrl_saved);
+	vmcs_write(nr, pgc_saved);
+}
+
+static void test_load_host_perf_global_ctrl(void)
+{
+	if (!(ctrl_exit_rev.clr & EXI_LOAD_PERF)) {
+		printf("\"load IA32_PERF_GLOBAL_CTRL\" exit control not supported\n");
+		return;
+	}
+
+	test_perf_global_ctrl(HOST_PERF_GLOBAL_CTRL, "HOST_PERF_GLOBAL_CTRL",
+				   EXI_CONTROLS, "EXI_CONTROLS", EXI_LOAD_PERF);
+}
+
+
+static void test_load_guest_perf_global_ctrl(void)
+{
+	if (!(ctrl_enter_rev.clr & ENT_LOAD_PERF)) {
+		printf("\"load IA32_PERF_GLOBAL_CTRL\" entry control not supported\n");
+		return;
+	}
+
+	test_perf_global_ctrl(GUEST_PERF_GLOBAL_CTRL, "GUEST_PERF_GLOBAL_CTRL",
+				   ENT_CONTROLS, "ENT_CONTROLS", ENT_LOAD_PERF);
+}
+
+
 /*
  * test_vmcs_field - test a value for the given VMCS field
  * @field: VMCS field
@@ -7261,6 +7419,7 @@ static void vmx_host_state_area_test(void)
 	test_host_segment_regs();
 	test_host_desc_tables();
 	test_host_addr_size();
+	test_load_host_perf_global_ctrl();
 }
 
 /*
@@ -7296,6 +7455,7 @@ static void vmx_guest_state_area_test(void)
 
 	test_load_guest_pat();
 	test_guest_efer();
+	test_load_guest_perf_global_ctrl();
 
 	/*
 	 * Let the guest finish execution
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

