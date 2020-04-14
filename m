Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C94D1A6FF1
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 02:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390370AbgDNAKe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 20:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727878AbgDNAKd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Apr 2020 20:10:33 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F08C0A3BDC
        for <kvm@vger.kernel.org>; Mon, 13 Apr 2020 17:10:33 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id x6so3479467pjg.5
        for <kvm@vger.kernel.org>; Mon, 13 Apr 2020 17:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bVvnLr/13Rl1XJjZsivRn7ggZ8MLXPQ/yl/t3ThpoaI=;
        b=RXm1S12ruTwKRtz7mCQPgTkIPLoTzGOaiUL3LDnLkW2X0qOKL4+OzFij0qYp0OKlmt
         KCQhkf8bLnh4cHQcbLg+OPkwhlQwuycW8FNF5Arultd9v7Ea0zq1/ZPY+UEDHnaNXeuy
         LQJlA/3MrCSi9ElipRGMHJcA9yhWLeJdGlz2NSUaDakxRSEK+uvym9jbaLtviztJfi8O
         hfiM/nqIa0L4H7qvj+Pb0o9RUeXTcPtCVQKiEtvce6RckNLDWK5LejszauzwlCSIXcYT
         sf7/1pp7QV1Nvuf3jnGO7v+wxMgqMtZm7aL6va5FV2Vi/sRRYEoEzjm4iFKKRDemgDDq
         kxfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bVvnLr/13Rl1XJjZsivRn7ggZ8MLXPQ/yl/t3ThpoaI=;
        b=HqdUkg50utgZeyxeWZ5cMgb8Jj4brceJWXJnfuC1h/pVNiR4GQiR7k8gxDhjBRNH0b
         AFYnIjospLSpCnVYtIpwP8fR1jqkuR5Oa88U0ewL/P2UEqquIADHiMx250sYq48VoHTt
         8VjfU9MIK3x8XBnSCNcX1DfB3eb3+STp9kA9k/Oe5sf7WtEWRNZKfJwThguuPqWCNOrt
         aaitxuYpcaIoMxz4njnkmhBOr7QGLvVKXFQQ/CQ3hU6xl8MGrojHC78Nq0OJfu1Du2LA
         sVvHA99yo021deJBtXueT2osvBdzjRD/MJywy6kx8I/G8rN9gJ0UuF0qwGu/5Iw8trvL
         vX1A==
X-Gm-Message-State: AGi0PubttyFZ5qJfV5mc3+0xASn+u7cT4Y9C4v+Q0nrVdADvrWe9I6RL
        QX9Ml2CAmPO/rdUrhO54Vud7jKvjQxaVygoExOdY8DxQaQrLqNSl6886T2YWSiI5wwfPH+hcLFQ
        eZeWAavZIjzdgfXTCVADrrfE/+MpiWb6NpqTqOEE45aPNnqJWaNjwC4gHTB++FGU=
X-Google-Smtp-Source: APiQypJn+ICm4+7HDZKJB5RGhvwH2+IEzBAMHuBnGyf8jJqlEXJUKEtJLbOfaxB7j4bFoYsoEAxTYTzUJ5PELQ==
X-Received: by 2002:a17:90a:c392:: with SMTP id h18mr25032688pjt.89.1586823032394;
 Mon, 13 Apr 2020 17:10:32 -0700 (PDT)
Date:   Mon, 13 Apr 2020 17:10:26 -0700
In-Reply-To: <20200414001026.50051-1-jmattson@google.com>
Message-Id: <20200414001026.50051-2-jmattson@google.com>
Mime-Version: 1.0
References: <20200414001026.50051-1-jmattson@google.com>
X-Mailer: git-send-email 2.26.0.110.g2183baf09c-goog
Subject: [kvm-unit-tests PATCH 2/2] x86: VMX: Add another corner-case
 VMX-preemption timer test
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ensure that the delivery of a "VMX-preemption timer expired" VM-exit
doesn't disrupt single-stepping in the guest. Note that passing this
test doesn't ensure correctness.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 x86/vmx_tests.c | 104 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index fccb27f..86b8880 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -8438,6 +8438,109 @@ static void vmx_preemption_timer_zero_test(void)
 	handle_exception(DB_VECTOR, old_db);
 }
 
+static u64 vmx_preemption_timer_tf_test_prev_rip;
+
+static void vmx_preemption_timer_tf_test_db_handler(struct ex_regs *regs)
+{
+	extern char vmx_preemption_timer_tf_test_endloop;
+
+	if (vmx_get_test_stage() == 2) {
+		/*
+		 * Stage 2 means that we're done, one way or another.
+		 * Arrange for the iret to drop us out of the wbinvd
+		 * loop and stop single-stepping.
+		 */
+		regs->rip = (u64)&vmx_preemption_timer_tf_test_endloop;
+		regs->rflags &= ~X86_EFLAGS_TF;
+	} else if (regs->rip == vmx_preemption_timer_tf_test_prev_rip) {
+		/*
+		 * The RIP should alternate between the wbinvd and the
+		 * jmp instruction in the code below. If we ever see
+		 * the same instruction twice in a row, that means a
+		 * single-step trap has been dropped. Let the
+		 * hypervisor know about the failure by executing a
+		 * VMCALL.
+		 */
+		vmcall();
+	}
+	vmx_preemption_timer_tf_test_prev_rip = regs->rip;
+}
+
+static void vmx_preemption_timer_tf_test_guest(void)
+{
+	/*
+	 * The hypervisor doesn't intercept WBINVD, so the loop below
+	 * shouldn't be a problem--it's just two instructions
+	 * executing in VMX non-root mode. However, when the
+	 * hypervisor is running in a virtual environment, the parent
+	 * hypervisor might intercept WBINVD and emulate it. If the
+	 * parent hypervisor is broken, the single-step trap after the
+	 * WBINVD might be lost.
+	 */
+	asm volatile("vmcall\n\t"
+		     "0: wbinvd\n\t"
+		     "1: jmp 0b\n\t"
+		     "vmx_preemption_timer_tf_test_endloop:");
+}
+
+/*
+ * Ensure that the delivery of a "VMX-preemption timer expired"
+ * VM-exit doesn't disrupt single-stepping in the guest. Note that
+ * passing this test doesn't ensure correctness, because the test will
+ * only fail if the VMX-preemtion timer fires at the right time (or
+ * the wrong time, as it were).
+ */
+static void vmx_preemption_timer_tf_test(void)
+{
+	handler old_db;
+	u32 reason;
+	int i;
+
+	if (!(ctrl_pin_rev.clr & PIN_PREEMPT)) {
+		report_skip("'Activate VMX-preemption timer' not supported");
+		return;
+	}
+
+	old_db = handle_exception(DB_VECTOR,
+				  vmx_preemption_timer_tf_test_db_handler);
+
+	test_set_guest(vmx_preemption_timer_tf_test_guest);
+
+	enter_guest();
+	skip_exit_vmcall();
+
+	vmx_set_test_stage(1);
+	vmcs_set_bits(PIN_CONTROLS, PIN_PREEMPT);
+	vmcs_write(PREEMPT_TIMER_VALUE, 50000);
+	vmcs_write(GUEST_RFLAGS, X86_EFLAGS_FIXED | X86_EFLAGS_TF);
+
+	/*
+	 * The only exit we should see is "VMX-preemption timer
+	 * expired."  If we get a VMCALL exit, that means the #DB
+	 * handler has detected a missing single-step trap. It doesn't
+	 * matter where the guest RIP is when the VMX-preemption timer
+	 * expires (whether it's in the WBINVD loop or in the #DB
+	 * handler)--a single-step trap should never be discarded.
+	 */
+	for (i = 0; i < 10000; i++) {
+		enter_guest();
+		reason = (u32)vmcs_read(EXI_REASON);
+		if (reason == VMX_PREEMPT)
+			continue;
+		TEST_ASSERT(reason == VMX_VMCALL);
+		skip_exit_insn();
+		break;
+	}
+
+	report(reason == VMX_PREEMPT, "No single-step traps skipped");
+
+	vmx_set_test_stage(2);
+	vmcs_clear_bits(PIN_CONTROLS, PIN_PREEMPT);
+	enter_guest();
+
+	handle_exception(DB_VECTOR, old_db);
+}
+
 static void vmx_db_test_guest(void)
 {
 	/*
@@ -9743,6 +9846,7 @@ struct vmx_test vmx_tests[] = {
 	TEST(vmx_pending_event_hlt_test),
 	TEST(vmx_store_tsc_test),
 	TEST(vmx_preemption_timer_zero_test),
+	TEST(vmx_preemption_timer_tf_test),
 	/* EPT access tests. */
 	TEST(ept_access_test_not_present),
 	TEST(ept_access_test_read_only),
-- 
2.26.0.110.g2183baf09c-goog

