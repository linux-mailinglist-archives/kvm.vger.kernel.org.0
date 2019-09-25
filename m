Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73CE4BE224
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 18:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501955AbfIYQOg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 12:14:36 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37601 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2501930AbfIYQOf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 12:14:35 -0400
Received: by mail-wr1-f65.google.com with SMTP id i1so7653946wro.4
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 09:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Rj7/KDF66bdDSEPloby9vBkkQ1BDy0pvyO2EacE/Ml4=;
        b=JOTYodMPxJPqyTrEvGZMeq3XfGvDm7z5V+rx57E1ibjCGpi2RTTbvjw3u6H6XGqpMQ
         dlE25dUAkU6W5X9lLCllXfmSQQ6UaByQiRoWySzH/oXRBWoNaM3p0clt6rQPzzuXEEGu
         udJXtvtKKnuPuWt+6ZZlWKTs+Fir27Q3vKBmEa4lF1+Q72Z2+BCkn5oxaM0ODFfME0qg
         WL/yIZQh5vtkbs24DMxEznXouzK2OAjm/AZCrvkYSP7Ut0mky2YYE+KqWGIYx8gJOx2P
         QyV0oCpBHL6263TNk36DK4OspH45LbkXnWyKqo1JnKLhYv2KtueKrIsrGm97fHELhMbT
         ao8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=Rj7/KDF66bdDSEPloby9vBkkQ1BDy0pvyO2EacE/Ml4=;
        b=NV96K7UZncjqOuhydQ2i+dpqP1yrC1xCuiNkiseiupHfUDpAP1QrbU3p+UcoReW9tW
         WZu0J6t4P4LonvySNR7vAivv0vgU6AjCsxVzJZVqHMNXHlDHuiX+z2ZQjxqei6UaRc4e
         t6PUGA5Q6pC5f6N9ropikS9HURt9k8De9HW6DnIjPyv7D1/rF1ri9Rhe9vdKNypjski0
         efwzsiBEMnCUuk7IQFdABknab1EZOG0h4NaowOmo7THfZ/zTuUbKx4dJNgkS7+1E8Nhs
         brh2vaVEfFzpRp0TwsTLYUCQvQLRDKrJTGW71BlGNCxrfAU4z00gsthjmtVYe9X8wuVf
         kOZA==
X-Gm-Message-State: APjAAAUx+PaGvTKP6xgS+pVPRBDgLDpHylel1I3TLPE/9DL75w2GT3P1
        l2Cgpxh7xVJfCX3+djpykZJYoiI0
X-Google-Smtp-Source: APXvYqzFoMYQQoNSGawZfku2wIXIi+J+wLU9xqhzTdNa8QV2wYYRhpNq9IVv3hy9R/qO1gA6q0UXQg==
X-Received: by 2002:adf:cc8a:: with SMTP id p10mr9997803wrj.321.1569428073024;
        Wed, 25 Sep 2019 09:14:33 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a71sm4055293wme.11.2019.09.25.09.14.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Sep 2019 09:14:32 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: [PATCH kvm-unit-tests 4/4] x86: vmx_tests: add GUEST_EFER tests
Date:   Wed, 25 Sep 2019 18:14:26 +0200
Message-Id: <1569428066-27894-5-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1569428066-27894-1-git-send-email-pbonzini@redhat.com>
References: <1569428066-27894-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Conflicts:
	x86/vmx_tests.c
---
 x86/vmx_tests.c | 87 ++++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 70 insertions(+), 17 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 97aff6e..dba61a3 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -5030,19 +5030,23 @@ static void guest_state_test_main(void)
 	asm volatile("fnop");
 }
 
+static void advance_guest_state_test(void)
+{
+	u32 reason = vmcs_read(EXI_REASON);
+	if (! (reason & 0x80000000)) {
+		u64 guest_rip = vmcs_read(GUEST_RIP);
+		u32 insn_len = vmcs_read(EXI_INST_LEN);
+		vmcs_write(GUEST_RIP, guest_rip + insn_len);
+	}
+}
+
 static void report_guest_state_test(const char *test, u32 xreason,
 				    u64 field, const char * field_name)
 {
 	u32 reason = vmcs_read(EXI_REASON);
-	u64 guest_rip;
-	u32 insn_len;
 
 	report("%s, %s %lx", reason == xreason, test, field_name, field);
-
-	guest_rip = vmcs_read(GUEST_RIP);
-	insn_len = vmcs_read(EXI_INST_LEN);
-	if (! (reason & 0x80000021))
-		vmcs_write(GUEST_RIP, guest_rip + insn_len);
+	advance_guest_state_test();
 }
 
 /*
@@ -6720,6 +6724,25 @@ static void test_host_ctl_regs(void)
 	vmcs_write(HOST_CR3, cr3_saved);
 }
 
+static void test_efer_vmlaunch(u32 fld, bool ok)
+{
+	if (fld == HOST_EFER) {
+		if (ok)
+			test_vmx_vmlaunch(0, false);
+		else
+			test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD, false);
+	} else {
+		if (ok) {
+			enter_guest();
+			report("vmlaunch succeeds", vmcs_read(EXI_REASON) == VMX_VMCALL);
+		} else {
+			enter_guest_with_invalid_guest_state();
+			report("vmlaunch fails", vmcs_read(EXI_REASON) == (VMX_ENTRY_FAILURE | VMX_FAIL_STATE));
+		}
+		advance_guest_state_test();
+	}
+}
+
 static void test_efer_one(u32 fld, const char * fld_name, u64 efer,
 			  u32 ctrl_fld, u64 ctrl,
 			  int i, const char *efer_bit_name)
@@ -6727,12 +6750,27 @@ static void test_efer_one(u32 fld, const char * fld_name, u64 efer,
 	bool ok;
 
 	ok = true;
-	if (ctrl & EXI_LOAD_EFER) {
+	if (ctrl_fld == EXI_CONTROLS && (ctrl & EXI_LOAD_EFER)) {
 		if (!!(efer & EFER_LMA) != !!(ctrl & EXI_HOST_64))
 			ok = false;
 		if (!!(efer & EFER_LME) != !!(ctrl & EXI_HOST_64))
 			ok = false;
 	}
+	if (ctrl_fld == ENT_CONTROLS && (ctrl & ENT_LOAD_EFER)) {
+		/* Check LMA too since CR0.PG is set.  */
+		if (!!(efer & EFER_LMA) != !!(ctrl & ENT_GUEST_64))
+			ok = false;
+		if (!!(efer & EFER_LME) != !!(ctrl & ENT_GUEST_64))
+			ok = false;
+	}
+
+	/*
+	 * Skip the test if it would enter the guest in 32-bit mode.
+	 * Perhaps write the test in assembly and make sure it
+	 * can be run in either mode?
+	 */
+	if (fld == GUEST_EFER && ok && !(ctrl & ENT_GUEST_64))
+		return;
 
 	vmcs_write(ctrl_fld, ctrl);
 	vmcs_write(fld, efer);
@@ -6741,11 +6779,7 @@ static void test_efer_one(u32 fld, const char * fld_name, u64 efer,
 			    (i & 1) ? "on" : "off",
 			    (i & 2) ? "on" : "off");
 
-	if (ok)
-		test_vmx_vmlaunch(0, false);
-	else
-		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
-				  false);
+	test_efer_vmlaunch(fld, ok);
 	report_prefix_pop();
 }
 
@@ -6792,7 +6826,7 @@ static void test_efer(u32 fld, const char * fld_name, u32 ctrl_fld,
 	}
 
 	report_prefix_pushf("%s %lx", fld_name, efer_saved);
-	test_vmx_vmlaunch(0, false);
+	test_efer_vmlaunch(fld, true);
 	report_prefix_pop();
 
 	/*
@@ -6804,7 +6838,7 @@ static void test_efer(u32 fld, const char * fld_name, u32 ctrl_fld,
 			efer = efer_saved | (1ull << i);
 			vmcs_write(fld, efer);
 			report_prefix_pushf("%s %lx", fld_name, efer);
-			test_vmx_vmlaunch(0, false);
+			test_efer_vmlaunch(fld, true);
 			report_prefix_pop();
 		}
 	}
@@ -6815,8 +6849,7 @@ static void test_efer(u32 fld, const char * fld_name, u32 ctrl_fld,
 			efer = efer_saved | (1ull << i);
 			vmcs_write(fld, efer);
 			report_prefix_pushf("%s %lx", fld_name, efer);
-			test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
-					  false);
+			test_efer_vmlaunch(fld, false);
 			report_prefix_pop();
 		}
 	}
@@ -6863,6 +6896,25 @@ static void test_host_efer(void)
 }
 
 /*
+ * If the 'load IA32_EFER' VM-enter control is 1, bits reserved in the
+ * IA32_EFER MSR must be 0 in the field for that register. In addition,
+ * the values of the LMA and LME bits in the field must each be that of
+ * the 'IA32e-mode guest' VM-exit control.
+ */
+static void test_guest_efer(void)
+{
+	if (!(ctrl_enter_rev.clr & ENT_LOAD_EFER)) {
+		printf("\"Load-IA32-EFER\" entry control not supported\n");
+		return;
+	}
+
+	vmcs_write(GUEST_EFER, rdmsr(MSR_EFER));
+	test_efer(GUEST_EFER, "GUEST_EFER", ENT_CONTROLS,
+		  ctrl_enter_rev.clr & ENT_LOAD_EFER,
+		  ENT_GUEST_64);
+}
+
+/*
  * PAT values higher than 8 are uninteresting since they're likely lumped
  * in with "8". We only test values above 8 one bit at a time,
  * in order to reduce the number of VM-Entries and keep the runtime reasonable.
@@ -7230,6 +7282,7 @@ static void vmx_guest_state_area_test(void)
 	test_set_guest(guest_state_test_main);
 
 	test_load_guest_pat();
+	test_guest_efer();
 
 	/*
 	 * Let the guest finish execution
-- 
1.8.3.1

