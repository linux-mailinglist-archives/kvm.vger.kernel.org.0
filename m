Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25691A6B54
	for <lists+kvm@lfdr.de>; Mon, 13 Apr 2020 19:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732775AbgDMRZB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 13:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732579AbgDMRZA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Apr 2020 13:25:00 -0400
Received: from mail-vs1-xe4a.google.com (mail-vs1-xe4a.google.com [IPv6:2607:f8b0:4864:20::e4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B51DC0A3BDC
        for <kvm@vger.kernel.org>; Mon, 13 Apr 2020 10:25:00 -0700 (PDT)
Received: by mail-vs1-xe4a.google.com with SMTP id o4so1485337vsq.9
        for <kvm@vger.kernel.org>; Mon, 13 Apr 2020 10:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=EDZIse0CAyjRG1ZA+ncXw6cx+Fx0Toi1Y2+CeJFFGks=;
        b=qFzpKqFOzRskUpskTA5ehIzjzc4ufCnYaA4NawvXVdojf9v+V/sBD37aq+jJqVoPQy
         JPNL9yF9rBkjEhN6ogI61lCLgmwaIpQoiUiW2KuIJ+dKBtH3SdhEBG5w9NglbaG0Kh2E
         BecRYqDuIh2cKZSY4w/NJoT1EHnsY3Id69I2/FvBAF46jRTwbBk90ZhdTA6f+t0U6jNE
         QNDiBizeQcnAFFTQK7KnWdo5wkQ9Lp34EUaBNS0H6VCfAOS6rDYjgJBppVmEo56ij13t
         T+7oJgStoHWZRBF3CEpfGCG/i8sa4nK+RcU6vHjKzDSxg+nyxHilTLJ4orkaDU19reD3
         5NjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=EDZIse0CAyjRG1ZA+ncXw6cx+Fx0Toi1Y2+CeJFFGks=;
        b=tcKxwnGos06piz9iBJYOWLm6e6iom88EzVTHCgShn1Hvt2hQYSH86GLCqEGs+H7vtU
         cNuF9bqU8aEK5vOVrsH1aPRmnoRegtCWeYC2GK5WOm/nuSlO9ohB8OP7xqNyvcoqO8/Y
         OObbaydI3qFQNo33B/GS/0VakQPGRNAX+OXgg2ubSMiJYE5GhkRT8Sg4zh5I8pn43qkW
         BpLC88Bp9msJQSW35Jy9Ll4luK+6WViUpTWNjBRHpuiIbDTQFtUL6yNOFGtFFITIse9T
         qGugJl02iVIpkMp/jFjK6rrqExo2s5ycIlkLVrwcDGh8BuxqOp5C20Ocg3TWZuuRKyie
         QKtw==
X-Gm-Message-State: AGi0PuaqSpg9WluJO22ZqEFZa6c6XwUFfXi9eOAmASGtoRiyAfq3PGBt
        jT/XChp1V60H63gTs9xT29MuK66r/adma+HlEcqhXbHsIGHgdhOGYi3FUkwdaistP5EDLGiQXsH
        EHM+U+zAcICQUdQ/4smuib1s0QRoIa3w12/P+k5Cua1bMptIVCsoIdUOXcA7eKmpbZOKb7es=
X-Google-Smtp-Source: APiQypLnJIMOeCOdk4z65pjH6kzca9uMVsp17UccWRmmUNH1JJvEgZC/3RS+4EHzLGUHvBxnReqeTHnqDwuK1qVugQ==
X-Received: by 2002:a05:6102:50b:: with SMTP id l11mr12915552vsa.199.1586798699537;
 Mon, 13 Apr 2020 10:24:59 -0700 (PDT)
Date:   Mon, 13 Apr 2020 10:24:32 -0700
Message-Id: <20200413172432.70180-1-brigidsmith@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.0.110.g2183baf09c-goog
Subject: [kvm-unit-tests RESEND PATCH] x86: gtests: add new test for
 vmread/vmwrite flags preservation
From:   Simon Smith <brigidsmith@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Simon Smith <brigidsmith@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This commit adds new unit tests for commit a4d956b93904 ("KVM: nVMX:
vmread should not set rflags to specify success in case of #PF")

The two new tests force a vmread and a vmwrite on an unmapped
address to cause a #PF and verify that the low byte of %rflags is
preserved and that %rip is not advanced.  The cherry-pick fixed a
bug in vmread, but we include a test for vmwrite as well for
completeness.

Before the aforementioned commit, the ALU flags would be incorrectly
cleared and %rip would be advanced (for vmread).

Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Simon Smith <brigidsmith@google.com>
---
 x86/vmx.c | 121 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 121 insertions(+)

diff --git a/x86/vmx.c b/x86/vmx.c
index 647ab49408876..e9235ec4fcad9 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -32,6 +32,7 @@
 #include "processor.h"
 #include "alloc_page.h"
 #include "vm.h"
+#include "vmalloc.h"
 #include "desc.h"
 #include "vmx.h"
 #include "msr.h"
@@ -368,6 +369,122 @@ static void test_vmwrite_vmread(void)
 	free_page(vmcs);
 }
 
+ulong finish_fault;
+u8 sentinel;
+bool handler_called;
+static void pf_handler(struct ex_regs *regs)
+{
+	// check that RIP was not improperly advanced and that the
+	// flags value was preserved.
+	report("RIP has not been advanced!",
+		regs->rip < finish_fault);
+	report("The low byte of RFLAGS was preserved!",
+		((u8)regs->rflags == ((sentinel | 2) & 0xd7)));
+
+	regs->rip = finish_fault;
+	handler_called = true;
+
+}
+
+static void prep_flags_test_env(void **vpage, struct vmcs **vmcs, handler *old)
+{
+	// get an unbacked address that will cause a #PF
+	*vpage = alloc_vpage();
+
+	// set up VMCS so we have something to read from
+	*vmcs = alloc_page();
+
+	memset(*vmcs, 0, PAGE_SIZE);
+	(*vmcs)->hdr.revision_id = basic.revision;
+	assert(!vmcs_clear(*vmcs));
+	assert(!make_vmcs_current(*vmcs));
+
+	*old = handle_exception(PF_VECTOR, &pf_handler);
+}
+
+static void test_read_sentinel(void)
+{
+	void *vpage;
+	struct vmcs *vmcs;
+	handler old;
+
+	prep_flags_test_env(&vpage, &vmcs, &old);
+
+	// set the proper label
+	extern char finish_read_fault;
+
+	finish_fault = (ulong)&finish_read_fault;
+
+	// execute the vmread instruction that will cause a #PF
+	handler_called = false;
+	asm volatile ("movb %[byte], %%ah\n\t"
+		      "sahf\n\t"
+		      "vmread %[enc], %[val]; finish_read_fault:"
+		      : [val] "=m" (*(u64 *)vpage)
+		      : [byte] "Krm" (sentinel),
+		      [enc] "r" ((u64)GUEST_SEL_SS)
+		      : "cc", "ah"
+		      );
+	report("The #PF handler was invoked", handler_called);
+
+	// restore old #PF handler
+	handle_exception(PF_VECTOR, old);
+}
+
+static void test_vmread_flags_touch(void)
+{
+	// set up the sentinel value in the flags register. we
+	// choose these two values because they candy-stripe
+	// the 5 flags that sahf sets.
+	sentinel = 0x91;
+	test_read_sentinel();
+
+	sentinel = 0x45;
+	test_read_sentinel();
+}
+
+static void test_write_sentinel(void)
+{
+	void *vpage;
+	struct vmcs *vmcs;
+	handler old;
+
+	prep_flags_test_env(&vpage, &vmcs, &old);
+
+	// set the proper label
+	extern char finish_write_fault;
+
+	finish_fault = (ulong)&finish_write_fault;
+
+	// execute the vmwrite instruction that will cause a #PF
+	handler_called = false;
+	asm volatile ("movb %[byte], %%ah\n\t"
+		      "sahf\n\t"
+		      "vmwrite %[val], %[enc]; finish_write_fault:"
+		      : [val] "=m" (*(u64 *)vpage)
+		      : [byte] "Krm" (sentinel),
+		      [enc] "r" ((u64)GUEST_SEL_SS)
+		      : "cc", "ah"
+		      );
+	report("The #PF handler was invoked", handler_called);
+
+	// restore old #PF handler
+	handle_exception(PF_VECTOR, old);
+}
+
+static void test_vmwrite_flags_touch(void)
+{
+	// set up the sentinel value in the flags register. we
+	// choose these two values because they candy-stripe
+	// the 5 flags that sahf sets.
+	sentinel = 0x91;
+	test_write_sentinel();
+
+	sentinel = 0x45;
+	test_write_sentinel();
+}
+
+
 static void test_vmcs_high(void)
 {
 	struct vmcs *vmcs = alloc_page();
@@ -1994,6 +2111,10 @@ int main(int argc, const char *argv[])
 		test_vmcs_lifecycle();
 	if (test_wanted("test_vmx_caps", argv, argc))
 		test_vmx_caps();
+	if (test_wanted("test_vmread_flags_touch", argv, argc))
+		test_vmread_flags_touch();
+	if (test_wanted("test_vmwrite_flags_touch", argv, argc))
+		test_vmwrite_flags_touch();
 
 	/* Balance vmxon from test_vmxon. */
 	vmx_off();
-- 
2.26.0.110.g2183baf09c-goog

