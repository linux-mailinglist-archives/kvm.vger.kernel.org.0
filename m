Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A21E529EDB4
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 14:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbgJ2N4G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 09:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbgJ2N4G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Oct 2020 09:56:06 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1CF2C0613CF
        for <kvm@vger.kernel.org>; Thu, 29 Oct 2020 06:56:05 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id t25so3879314ejd.13
        for <kvm@vger.kernel.org>; Thu, 29 Oct 2020 06:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0c1+bR9T+IplOpKDV6RvsAZ3ZFdVzQUrH0NfTUm42po=;
        b=vXEhrLtERJ9KdvJrljvr86XAWaPWGWu/mpmmOiBfg29cKmexUAH9RuzLZOZrvy+Wm8
         Jw3qPzVBGH/6jSVWIRq9cHNIJ1yCBiVPEjzwqqKw/SjFoCZjcyGZGTUsUGOTRMIeWylW
         nUt60iBERHk8ZrVY4t2ABYkEUQkc8Fi3qFu5tTnxwS/ZxHh4LNbDcYXuV7S51To2sY4t
         SFZuLc4ROkO+GH5tqattr0nhu5jmzi8OIVXB0Sku3YSzvHpGMo9mueuzpwEDu/uvvpnF
         i5Jcsa7p5wiRyzhcJXRX0ksFQB/Tmq7fWZV4iAmJcs3KuV8Tqtr0+zwLC/4xhC3S/GYz
         15tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0c1+bR9T+IplOpKDV6RvsAZ3ZFdVzQUrH0NfTUm42po=;
        b=BLSdHI8akYC8q5YCVjtTqWJGwnehT96D0oZOHMeZzN0wH4e7poJ/QnObzxBxRkge1j
         nf21gViwA6SX+3/KfTQVdRmTpSziqJrspRsZalt5XddDOV88HpKwQi5ujevwzVcCuh1Q
         /AaPhSxwdTz9oM6QoRnB1hpLXGd2KX628PFgww8WHowt9hXLWb+lgd7DGSAfvUM8NbQl
         MQScHQOSUsdH5hQ0BlZyyt143s3844xSx1e6+8kgCX+iHA3i6lZ+uivRUuoDI5WFr/xP
         Mb0sPaOSL5yUGXe6wz91XKy+6zUySR9SiW2x+JlxAGmnEwbDLiuGXIFhg1+vOunDALse
         QDaw==
X-Gm-Message-State: AOAM533y2JNXrFIL5y4WGobQ33aaCgW/CJgr+JIyc3SgBf7tE5jFJxNU
        KzEzIpJuEEBH+onrFYMBKZPdrM8+XQ5CYw==
X-Google-Smtp-Source: ABdhPJxZ2KNY34o2P1qMFC7JpDPTt0TXSskEiJdDyPhiBdzaOQAT1QkjlkGegDZ4uxVw2/hcjVZqkQ==
X-Received: by 2002:a17:906:fca:: with SMTP id c10mr4346402ejk.128.1603979763889;
        Thu, 29 Oct 2020 06:56:03 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id j20sm1591453edt.4.2020.10.29.06.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 06:56:03 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH] KVM/VMX/SVM: Move kvm_machine_check function to x86.h
Date:   Thu, 29 Oct 2020 14:56:00 +0100
Message-Id: <20201029135600.122392-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move kvm_machine_check to x86.h to avoid two exact copies
of the same function in kvm.c and svm.c.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
 arch/x86/kvm/svm/svm.c | 20 --------------------
 arch/x86/kvm/vmx/vmx.c | 20 --------------------
 arch/x86/kvm/x86.h     | 20 ++++++++++++++++++++
 3 files changed, 20 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2f32fd09e259..f2ad59d19040 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -33,7 +33,6 @@
 #include <asm/debugreg.h>
 #include <asm/kvm_para.h>
 #include <asm/irq_remapping.h>
-#include <asm/mce.h>
 #include <asm/spec-ctrl.h>
 #include <asm/cpu_device_id.h>
 
@@ -1929,25 +1928,6 @@ static bool is_erratum_383(void)
 	return true;
 }
 
-/*
- * Trigger machine check on the host. We assume all the MSRs are already set up
- * by the CPU and that we still run on the same CPU as the MCE occurred on.
- * We pass a fake environment to the machine check handler because we want
- * the guest to be always treated like user space, no matter what context
- * it used internally.
- */
-static void kvm_machine_check(void)
-{
-#if defined(CONFIG_X86_MCE)
-	struct pt_regs regs = {
-		.cs = 3, /* Fake ring 3 no matter what the guest ran on */
-		.flags = X86_EFLAGS_IF,
-	};
-
-	do_machine_check(&regs);
-#endif
-}
-
 static void svm_handle_mce(struct vcpu_svm *svm)
 {
 	if (is_erratum_383()) {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0f390c748b18..0329f09a2ca6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -40,7 +40,6 @@
 #include <asm/irq_remapping.h>
 #include <asm/kexec.h>
 #include <asm/perf_event.h>
-#include <asm/mce.h>
 #include <asm/mmu_context.h>
 #include <asm/mshyperv.h>
 #include <asm/mwait.h>
@@ -4714,25 +4713,6 @@ static int handle_rmode_exception(struct kvm_vcpu *vcpu,
 	return 1;
 }
 
-/*
- * Trigger machine check on the host. We assume all the MSRs are already set up
- * by the CPU and that we still run on the same CPU as the MCE occurred on.
- * We pass a fake environment to the machine check handler because we want
- * the guest to be always treated like user space, no matter what context
- * it used internally.
- */
-static void kvm_machine_check(void)
-{
-#if defined(CONFIG_X86_MCE)
-	struct pt_regs regs = {
-		.cs = 3, /* Fake ring 3 no matter what the guest ran on */
-		.flags = X86_EFLAGS_IF,
-	};
-
-	do_machine_check(&regs);
-#endif
-}
-
 static int handle_machine_check(struct kvm_vcpu *vcpu)
 {
 	/* handled by vmx_vcpu_run() */
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 3900ab0c6004..e1bde3f3f2d5 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -3,6 +3,7 @@
 #define ARCH_X86_KVM_X86_H
 
 #include <linux/kvm_host.h>
+#include <asm/mce.h>
 #include <asm/pvclock.h>
 #include "kvm_cache_regs.h"
 #include "kvm_emulate.h"
@@ -366,6 +367,25 @@ static inline bool kvm_dr6_valid(u64 data)
 	return !(data >> 32);
 }
 
+/*
+ * Trigger machine check on the host. We assume all the MSRs are already set up
+ * by the CPU and that we still run on the same CPU as the MCE occurred on.
+ * We pass a fake environment to the machine check handler because we want
+ * the guest to be always treated like user space, no matter what context
+ * it used internally.
+ */
+static inline void kvm_machine_check(void)
+{
+#if defined(CONFIG_X86_MCE)
+	struct pt_regs regs = {
+		.cs = 3, /* Fake ring 3 no matter what the guest ran on */
+		.flags = X86_EFLAGS_IF,
+	};
+
+	do_machine_check(&regs);
+#endif
+}
+
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 int kvm_spec_ctrl_test_value(u64 value);
-- 
2.26.2

