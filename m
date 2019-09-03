Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6B4EA76A1
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 23:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbfICV6Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 17:58:24 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:38546 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbfICV6X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 17:58:23 -0400
Received: by mail-pf1-f202.google.com with SMTP id b8so15070885pfd.5
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2019 14:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JeYG/CdRS4FJjwc/zJdCeh9ANv77iaZ4013EMkx3oLc=;
        b=kjRIvuf3TT05qpCoJZz3m6GnD21RCJMM3Bd/+ZtkPvMqD7S9TnY4qRRFUyUtc0y0Yb
         vAaiAiHIqIG5AnEbhg/cTGb5Xnmbn27A3xkto0sEXBAODg1vUEwCfZTSjejXrYNEVOaU
         c2x5q1ca5I8YQwyw7guhXlPBFaqecwNLkfuufT29fT8J2lK/xCJBTlTSWoDmUzgyKXdI
         6/LnNL6AoodzxyvI4uYB0aun9vV+CuymkhbJPGEV7fxZ0nLnU321QykHleBqQcs1Wm1/
         489HG81/2W12AY7feeipSnNnVyJR+8qBsRM3naE3mkbb0NiX0WRRaZxZSt3hyBpeiYkF
         plpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JeYG/CdRS4FJjwc/zJdCeh9ANv77iaZ4013EMkx3oLc=;
        b=uMoPblCS5z0lUP5ZlqovCsvaUWZH+ywqvun3fO46nFE7FHi54P96SZTE9v29uPtzDt
         1GGMDIMJnoVgn3Mhy4JFK0e40Xcvh7wITWF5zb2MGuF8dbuLQGkBRw0+I9bLuYxmYPJA
         pl/bjopDLLGvQPqdcDOUyKbY0uXBQc0k4v/T5KdOdkchn6BY9+NlHXIs3/B7G/pD2rM0
         tbSlK8hHxjr0GNHdvKxiR7kGnDcqN8BpvYZLG1j/E9HlJBzlI76H0zkvhBvWtVpCq8CY
         0tJKG388GLANCNitqsthsvTwOYZXy/SgScuiX9hoMlnHKJJxwo0AU4NWPE9ksUICESmd
         iopQ==
X-Gm-Message-State: APjAAAUqzWdxkKERbt8v6icJmNWbNMCcN0vXG6liFTb0KhC+QC+BtSHr
        svxG7wgEwCX54L7P5WpIkWlJR3YFRKpZzaeMS/LcZwHWaNJgTzm3+usXUo6KrxLhrI4Z13IYEGr
        YpVIbj2joFynjo7HhHy3ehTd39PHd3JAFKQJse/WxtWM1QpCCuFlIUagtiQ==
X-Google-Smtp-Source: APXvYqzQfbtzpiE1Fxt81iHH3MXI0nVspsJZ78h0qdIHqnX78tz5Y224aXK2JaiOpic/zakYJROit9XfpW4=
X-Received: by 2002:a63:3805:: with SMTP id f5mr31966106pga.272.1567547902783;
 Tue, 03 Sep 2019 14:58:22 -0700 (PDT)
Date:   Tue,  3 Sep 2019 14:58:01 -0700
In-Reply-To: <20190903215801.183193-1-oupton@google.com>
Message-Id: <20190903215801.183193-9-oupton@google.com>
Mime-Version: 1.0
References: <20190903215801.183193-1-oupton@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [kvm-unit-tests PATCH v3 8/8] x86: VMX: Add tests for nested "load IA32_PERF_GLOBAL_CTRL"
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
---
 x86/vmx_tests.c | 199 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 197 insertions(+), 2 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index b72a27583793..73c46eba6be9 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -5033,7 +5033,7 @@ static void guest_state_test_main(void)
 			break;
 
 		if (data->enabled) {
-			obs = rdmsr(obs);
+			obs = rdmsr(data->msr);
 			report("Guest state is 0x%lx (expected 0x%lx)",
 			       data->exp == obs, obs, data->exp);
 		}
@@ -6854,6 +6854,200 @@ static void test_host_efer(void)
 	test_efer(HOST_EFER, "HOST_EFER", EXI_CONTROLS, EXI_LOAD_EFER);
 }
 
+union cpuid10_eax {
+	struct {
+		unsigned int version_id:8;
+		unsigned int num_counters:8;
+		unsigned int bit_width:8;
+		unsigned int mask_length:8;
+	} split;
+	unsigned int full;
+};
+
+union cpuid10_edx {
+	struct {
+		unsigned int num_counters_fixed:5;
+		unsigned int bit_width_fixed:8;
+		unsigned int reserved:19;
+	} split;
+	unsigned int full;
+};
+
+static bool valid_pgc(u64 val)
+{
+	struct cpuid id;
+	union cpuid10_eax eax;
+	union cpuid10_edx edx;
+	u64 mask;
+
+	id = cpuid(0xA);
+	eax.full = id.a;
+	edx.full = id.d;
+	mask = ~(((1ull << eax.split.num_counters) - 1) |
+		(((1ull << edx.split.num_counters_fixed) - 1) << 32));
+
+	return !(val & mask);
+}
+
+static void test_pgc_vmlaunch(u32 xerror, bool xfail, bool host)
+{
+	u32 inst_err;
+	u64 guest_rip, inst_len, obs;
+	bool success;
+	struct load_state_test_data *data = &load_state_test_data;
+
+	if (host) {
+		success = vmlaunch_succeeds();
+		obs = rdmsr(data->msr);
+		if (data->enabled && success)
+			report("Host state is 0x%lx (expected 0x%lx)",
+			       data->exp == obs, obs, data->exp);
+	} else {
+		if (xfail)
+			enter_guest_with_invalid_guest_state();
+		else
+			enter_guest();
+		success = VMX_VMCALL == (vmcs_read(EXI_REASON) & 0xff);
+		guest_rip = vmcs_read(GUEST_RIP);
+		inst_len = vmcs_read(EXI_INST_LEN);
+		if (success)
+			vmcs_write(GUEST_RIP, guest_rip + inst_len);
+	}
+	if (!success) {
+		inst_err = vmcs_read(VMX_INST_ERROR);
+		report("vmlaunch failed, VMX Inst Error is %d (expected %d)",
+		       xerror == inst_err, inst_err, xerror);
+	} else {
+		report("vmlaunch succeeded", success != xfail);
+	}
+}
+
+/*
+ * test_load_pgc is a generic function for testing the
+ * "load IA32_PERF_GLOBAL_CTRL" VM-{entry,exit} control. This test function
+ * will test the provided ctrl_val disabled and enabled.
+ *
+ * @nr - VMCS field number corresponding to the Host/Guest state field
+ * @name - Name of the above VMCS field for printing in test report
+ * @ctrl_nr - VMCS field number corresponding to the VM-{entry,exit} control
+ * @ctrl_val - Bit to set on the ctrl field.
+ */
+static void test_load_pgc(u32 nr, const char *name, u32 ctrl_nr,
+			  const char *ctrl_name, u64 ctrl_val)
+{
+	u64 ctrl_saved = vmcs_read(ctrl_nr);
+	u64 pgc_saved = vmcs_read(nr);
+	u64 i, val;
+	bool host = nr == HOST_PERF_GLOBAL_CTRL;
+	struct load_state_test_data *data = &load_state_test_data;
+
+	data->msr = MSR_CORE_PERF_GLOBAL_CTRL;
+	msr_bmp_init();
+	if (!host) {
+		vmx_set_test_stage(1);
+		test_set_guest(guest_state_test_main);
+	}
+	vmcs_write(ctrl_nr, ctrl_saved & ~ctrl_val);
+	data->enabled = false;
+	report_prefix_pushf("\"load IA32_PERF_GLOBAL_CTRL\"=0 on %s",
+			    ctrl_name);
+	for (i = 0; i < 64; i++) {
+		val = 1ull << i;
+		vmcs_write(nr, val);
+		report_prefix_pushf("%s = 0x%lx", name, val);
+		/*
+		 * If the "load IA32_PERF_GLOBAL_CTRL" bit is 0 then
+		 * the {HOST,GUEST}_IA32_PERF_GLOBAL_CTRL field is ignored,
+		 * thus setting reserved bits in this field does not cause
+		 * vmlaunch to fail.
+		 */
+		test_pgc_vmlaunch(0, false, host);
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
+			test_pgc_vmlaunch(0, false, host);
+		} else {
+			/*
+			 * [SDM 30.4]
+			 *
+			 * Invalid host state fields result in an VM
+			 * instruction error with error number 8
+			 * (VMXERR_ENTRY_INVALID_HOST_STATE_FIELD)
+			 */
+			if (host) {
+				test_pgc_vmlaunch(
+					VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
+					true, host);
+			/*
+			 * [SDM 26.1]
+			 *
+			 * If a VM-Entry fails according to one of
+			 * the guest-state checks, the exit reason on the VMCS
+			 * will be set to reason number 33 (VMX_FAIL_STATE)
+			 */
+			} else {
+				test_pgc_vmlaunch(
+					0,
+					true, host);
+				TEST_ASSERT_EQ(
+					VMX_ENTRY_FAILURE | VMX_FAIL_STATE,
+					vmcs_read(EXI_REASON));
+			}
+		}
+		report_prefix_pop();
+	}
+
+	report_prefix_pop();
+
+	if (nr == GUEST_PERF_GLOBAL_CTRL) {
+		/*
+		 * Let the guest finish execution
+		 */
+		vmx_set_test_stage(2);
+		vmcs_write(ctrl_nr, ctrl_saved);
+		vmcs_write(nr, pgc_saved);
+		enter_guest();
+	}
+
+	vmcs_write(ctrl_nr, ctrl_saved);
+	vmcs_write(nr, pgc_saved);
+}
+
+static void test_load_host_pgc(void)
+{
+	if (!(ctrl_exit_rev.clr & EXI_LOAD_PERF)) {
+		printf("\"load IA32_PERF_GLOBAL_CTRL\" "
+		       "exit control not supported\n");
+		return;
+	}
+
+	test_load_pgc(HOST_PERF_GLOBAL_CTRL, "HOST_PERF_GLOBAL_CTRL",
+		      EXI_CONTROLS, "EXI_CONTROLS", EXI_LOAD_PERF);
+}
+
+
+static void test_load_guest_pgc(void)
+{
+	if (!(ctrl_enter_rev.clr & ENT_LOAD_PERF)) {
+		printf("\"load IA32_PERF_GLOBAL_CTRL\" "
+		       "entry control not supported\n");
+	}
+
+	test_load_pgc(GUEST_PERF_GLOBAL_CTRL, "GUEST_PERF_GLOBAL_CTRL",
+		      ENT_CONTROLS, "ENT_CONTROLS", ENT_LOAD_PERF);
+}
+
 /*
  * PAT values higher than 8 are uninteresting since they're likely lumped
  * in with "8". We only test values above 8 one bit at a time,
@@ -7147,6 +7341,7 @@ static void vmx_host_state_area_test(void)
 	test_sysenter_field(HOST_SYSENTER_EIP, "HOST_SYSENTER_EIP");
 
 	test_host_efer();
+	test_load_host_pgc();
 	test_load_host_pat();
 	test_host_segment_regs();
 	test_host_desc_tables();
@@ -8587,7 +8782,6 @@ static int invalid_msr_entry_failure(struct vmentry_failure *failure)
 	return VMX_TEST_VMEXIT;
 }
 
-
 #define TEST(name) { #name, .v2 = name }
 
 /* name/init/guest_main/exit_handler/syscall_handler/guest_regs */
@@ -8637,6 +8831,7 @@ struct vmx_test vmx_tests[] = {
 	TEST(vmx_host_state_area_test),
 	TEST(vmx_guest_state_area_test),
 	TEST(vmentry_movss_shadow_test),
+	TEST(test_load_guest_pgc),
 	/* APICv tests */
 	TEST(vmx_eoi_bitmap_ioapic_scan_test),
 	TEST(vmx_hlt_with_rvi_test),
-- 
2.23.0.187.g17f5b7556c-goog

