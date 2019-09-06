Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB9EAC1D4
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 23:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391195AbfIFVDn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 17:03:43 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:34746 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390971AbfIFVDn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 17:03:43 -0400
Received: by mail-vk1-f202.google.com with SMTP id v72so2842956vkv.1
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2019 14:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6o/Tmg2c7YTP90Ofm0aXe06LJ8nMJyFr26MyqVY35So=;
        b=ZBvtFPxGbAIugHUFtvHJouvhNlzLeR18MP2OblfcPpq4rhuJZefRRXny/+Q1kSEZ9H
         L3yTivcMHHn0dSpUWGVOsLOnge/jsr6T4zlkzIAP12YiTytO7aVkBZzqsn8QzV49Bw/P
         FpWxRlDIFczKQytf+u0aMku9YFWOLJCI/2V5CdzvI81SmsbHipzxChceu7EBC6byoEm5
         QBWTMUrtsowsEd4EyfV7a5iRtEO8nLI/SCLjvHC5VFa4KSrV6yfOnB3gOOBxcWjEAt8H
         +qVafODgvHDKzTcKezplBnzlNJVGIUWFo6/KRK66F1I35qK6Gsg4z6wW0Y5kSJVPmuoi
         hPQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6o/Tmg2c7YTP90Ofm0aXe06LJ8nMJyFr26MyqVY35So=;
        b=pPPs052hpRVboSomvUIvahVnDzLR1OuwXUl1mddh9HsK7QKk7UbhutBFJeI3JDv32a
         9DSGe2/xMxD4bTLAADXtGG9JWnmD8v0o8I6eIMDR6eVWoEWpL+4R9BVDja4xtAalNZRM
         kZyzACO6sjkWeML3fpB+sTm5dg6Kh5Xl3tAvPXHoNAegjf27leAPHvW2B44+Hm8VGFl8
         fRJPzFgQmp0h1c/fQYjx8NjzWcc5Va/L8w24/rTSIg3OeMnIKWEm0VLy2tKhoQ+estCB
         BPwgcN7B5eaetMLRY6tEancpbRxmRA9OYqH3FBsqMSSTyOrVTW2AWoPMsTC8uFCI/Yij
         3VUQ==
X-Gm-Message-State: APjAAAW8Y/0a9aTWQrVv/9WnWcfaqgVYfBoWpDv/qwS+G4LgAGGkxf9G
        LRt3lo6ttoxsLQ6BSgz/m+XPkxs9guoNjqsM4xc4WidZFl7LpfdlEwchr+IkBHfyY5xYYZvowBE
        400ND8p07OQd+f7RpzAIRIoUWY/3yI8KtjY0KPRqscmr1ZcdPrFT0UMu5sg==
X-Google-Smtp-Source: APXvYqxVbMD8oxJt9upQSmcu9uLyMoRqDyb4OSsluSOY6WKy839PfdeUpXkB2HBDeJTnbxJwbiWIkyMTzuY=
X-Received: by 2002:a67:fbc8:: with SMTP id o8mr3321182vsr.173.1567803821273;
 Fri, 06 Sep 2019 14:03:41 -0700 (PDT)
Date:   Fri,  6 Sep 2019 14:03:13 -0700
In-Reply-To: <20190906210313.128316-1-oupton@google.com>
Message-Id: <20190906210313.128316-10-oupton@google.com>
Mime-Version: 1.0
References: <20190906210313.128316-1-oupton@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [kvm-unit-tests PATCH v4 9/9] x86: VMX: Add tests for nested "load IA32_PERF_GLOBAL_CTRL"
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
 x86/vmx_tests.c | 172 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 172 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 84e1a7935aa1..86424dab615a 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -6854,6 +6854,176 @@ static void test_host_efer(void)
 	test_efer(HOST_EFER, "HOST_EFER", EXI_CONTROLS, EXI_LOAD_EFER);
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
+		unsigned int reserved:19;
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
+		(((1ull << edx.split.num_counters_fixed) - 1) << 32));
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
+ * "load IA32_PERF_GLOBAL_CTRL" VM-{entry,exit} control. This test function
+ * will test the provided ctrl_val disabled and enabled.
+ *
+ * @nr - VMCS field number corresponding to the Host/Guest state field
+ * @name - Name of the above VMCS field for printing in test report
+ * @ctrl_nr - VMCS field number corresponding to the VM-{entry,exit} control
+ * @ctrl_val - Bit to set on the ctrl field.
+ */
+static void test_load_perf_global_ctrl(u32 nr, const char *name, u32 ctrl_nr,
+				       const char *ctrl_name, u64 ctrl_val)
+{
+	u64 ctrl_saved = vmcs_read(ctrl_nr);
+	u64 pgc_saved = vmcs_read(nr);
+	u64 i, val;
+	bool host = nr == HOST_PERF_GLOBAL_CTRL;
+	struct vmx_state_area_test_data *data = &vmx_state_area_test_data;
+
+	if (!host) {
+		vmx_set_test_stage(1);
+		test_reset_guest(guest_state_test_main);
+	}
+	data->msr = MSR_CORE_PERF_GLOBAL_CTRL;
+	msr_bmp_init();
+	vmcs_write(ctrl_nr, ctrl_saved & ~ctrl_val);
+	data->enabled = false;
+	report_prefix_pushf("\"load IA32_PERF_GLOBAL_CTRL\"=0 on %s",
+			    ctrl_name);
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
+					true, host);
+			else
+				test_pgc_vmlaunch(
+					0,
+					VMX_ENTRY_FAILURE | VMX_FAIL_STATE,
+					true, host);
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
+static void test_load_host_perf_global_ctrl(void)
+{
+	if (!(ctrl_exit_rev.clr & EXI_LOAD_PERF)) {
+		printf("\"load IA32_PERF_GLOBAL_CTRL\" "
+		       "exit control not supported\n");
+		return;
+	}
+
+	test_load_perf_global_ctrl(HOST_PERF_GLOBAL_CTRL, "HOST_PERF_GLOBAL_CTRL",
+		      EXI_CONTROLS, "EXI_CONTROLS", EXI_LOAD_PERF);
+}
+
+
+static void test_load_guest_perf_global_ctrl(void)
+{
+	if (!(ctrl_enter_rev.clr & ENT_LOAD_PERF)) {
+		printf("\"load IA32_PERF_GLOBAL_CTRL\" "
+		       "entry control not supported\n");
+	}
+
+	test_load_perf_global_ctrl(GUEST_PERF_GLOBAL_CTRL, "GUEST_PERF_GLOBAL_CTRL",
+		      ENT_CONTROLS, "ENT_CONTROLS", ENT_LOAD_PERF);
+}
+
 /*
  * PAT values higher than 8 are uninteresting since they're likely lumped
  * in with "8". We only test values above 8 one bit at a time,
@@ -7147,6 +7317,7 @@ static void vmx_host_state_area_test(void)
 	test_sysenter_field(HOST_SYSENTER_EIP, "HOST_SYSENTER_EIP");
 
 	test_host_efer();
+	test_load_host_perf_global_ctrl();
 	test_load_host_pat();
 	test_host_segment_regs();
 	test_host_desc_tables();
@@ -7181,6 +7352,7 @@ static void test_load_guest_pat(void)
 static void vmx_guest_state_area_test(void)
 {
 	test_load_guest_pat();
+	test_load_guest_perf_global_ctrl();
 }
 
 static bool valid_vmcs_for_vmentry(void)
-- 
2.23.0.187.g17f5b7556c-goog

