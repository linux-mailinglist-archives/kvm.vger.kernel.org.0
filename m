Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54762DF941
	for <lists+kvm@lfdr.de>; Mon, 21 Dec 2020 07:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728472AbgLUG2D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Dec 2020 01:28:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727224AbgLUG2D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Dec 2020 01:28:03 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7372AC061282;
        Sun, 20 Dec 2020 22:27:22 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id o19so21067204lfo.1;
        Sun, 20 Dec 2020 22:27:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+yFQgFOQhWeyxieX0Af5kAdCP317roKj/FPadzHAYxg=;
        b=J53es2jHVMRxI6zzpKs2GtKmmzgE6uYUjmXwjP1rxwMJUREKg0FsfOBvawfl0fCK6B
         8jKgOeVUMLxozzTpw9Au+5W/Wkx/qbuKNJOQwqzttB2JgVnM1RjiPEMDD+v3OdROiiRS
         /OytTXAmKvY1iMu69BVgA07aExUHV1Wc//L9Yf4pi+w0RB+Oa4vJbfqaanlLIfEgXAk1
         8GOaOD5g5mPJLkTxmOIvYnVlt9F5dYFwccj7Xzt3+HJ1peekbczEEgaykQD5q0RiBost
         VT51rRn72a9L2dFYfdm1Hyrn7J2BTJaVRayEQxYm8F61eOPJKyzGil14QzqLd9Q/s/Cm
         N+Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+yFQgFOQhWeyxieX0Af5kAdCP317roKj/FPadzHAYxg=;
        b=UR/O4lYeaHPffUwWF2j39wHSszkjUNB+qmqCLJ15rzL2YxBqQ3HAQjini7gDE4vYVW
         w3b2m/xnL7v0uk2UJMa7seVLCpd0Qt2NJV1gefl/PgCjvNAkAQyd22kRFDFCEJA7PVgx
         KNXOoXuNxr9hh5IZCyBIO8uIcYjn77kO2Qyq4uKlsimdNXFfDcaFhArBwScT+/N4A92M
         d22eBYDHYrJq/Vza4OqxauFtfxMRkTheMbxAUEeQUTqsmZbmxGadz03jVRTWSof2ygg7
         gRQ75bVU5oNGn+MzMW2LZGAjrh/ZoTtPT88ZDLhSp3NTHFjguRUnU8KB3SHNpL7NKYZ7
         NDZg==
X-Gm-Message-State: AOAM531exTWjbi7BvPRGlMSTbvWggzY33dnypVsfGaydjevn/4l3GXxX
        +AoCeobvRHGSUVHp430umP6iRhUf7vQJlQ==
X-Google-Smtp-Source: ABdhPJydp4MiMj554hC3LFH2YcpiMZmEXM4rO1R4x5SlFIwqjXjZA5n1rWPq48cBrfEAFT/ltLwpqQ==
X-Received: by 2002:a17:906:3114:: with SMTP id 20mr12979083ejx.460.1608498679599;
        Sun, 20 Dec 2020 13:11:19 -0800 (PST)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id j5sm27794940edl.42.2020.12.20.13.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 13:11:19 -0800 (PST)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: [PATCH v2] KVM/x86: Move definition of __ex to x86.h
Date:   Sun, 20 Dec 2020 22:11:09 +0100
Message-Id: <20201220211109.129946-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Merge __kvm_handle_fault_on_reboot with its sole user
and move the definition of __ex to a common include to be
shared between VMX and SVM.

v2: Rebase to latest kvm/queue.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/include/asm/kvm_host.h | 25 -------------------------
 arch/x86/kvm/svm/sev.c          |  2 --
 arch/x86/kvm/svm/svm.c          |  2 --
 arch/x86/kvm/vmx/vmx_ops.h      |  4 +---
 arch/x86/kvm/x86.h              | 23 +++++++++++++++++++++++
 5 files changed, 24 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 39707e72b062..a78e4b1a5d77 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1634,31 +1634,6 @@ enum {
 #define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)
 #define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).smm)
 
-asmlinkage void kvm_spurious_fault(void);
-
-/*
- * Hardware virtualization extension instructions may fault if a
- * reboot turns off virtualization while processes are running.
- * Usually after catching the fault we just panic; during reboot
- * instead the instruction is ignored.
- */
-#define __kvm_handle_fault_on_reboot(insn)				\
-	"666: \n\t"							\
-	insn "\n\t"							\
-	"jmp	668f \n\t"						\
-	"667: \n\t"							\
-	"1: \n\t"							\
-	".pushsection .discard.instr_begin \n\t"			\
-	".long 1b - . \n\t"						\
-	".popsection \n\t"						\
-	"call	kvm_spurious_fault \n\t"				\
-	"1: \n\t"							\
-	".pushsection .discard.instr_end \n\t"				\
-	".long 1b - . \n\t"						\
-	".popsection \n\t"						\
-	"668: \n\t"							\
-	_ASM_EXTABLE(666b, 667b)
-
 #define KVM_ARCH_WANT_MMU_NOTIFIER
 int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
 			unsigned flags);
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e57847ff8bd2..ba492b6d37a0 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -25,8 +25,6 @@
 #include "cpuid.h"
 #include "trace.h"
 
-#define __ex(x) __kvm_handle_fault_on_reboot(x)
-
 static u8 sev_enc_bit;
 static int sev_flush_asids(void);
 static DECLARE_RWSEM(sev_deactivate_lock);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 941e5251e13f..733d9f98a121 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -42,8 +42,6 @@
 
 #include "svm.h"
 
-#define __ex(x) __kvm_handle_fault_on_reboot(x)
-
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
diff --git a/arch/x86/kvm/vmx/vmx_ops.h b/arch/x86/kvm/vmx/vmx_ops.h
index 692b0c31c9c8..7e3cb53c413f 100644
--- a/arch/x86/kvm/vmx/vmx_ops.h
+++ b/arch/x86/kvm/vmx/vmx_ops.h
@@ -4,13 +4,11 @@
 
 #include <linux/nospec.h>
 
-#include <asm/kvm_host.h>
 #include <asm/vmx.h>
 
 #include "evmcs.h"
 #include "vmcs.h"
-
-#define __ex(x) __kvm_handle_fault_on_reboot(x)
+#include "x86.h"
 
 asmlinkage void vmread_error(unsigned long field, bool fault);
 __attribute__((regparm(0))) void vmread_error_trampoline(unsigned long field,
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index c5ee0f5ce0f1..3cb12788ddc5 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -8,6 +8,29 @@
 #include "kvm_cache_regs.h"
 #include "kvm_emulate.h"
 
+asmlinkage void kvm_spurious_fault(void);
+
+/*
+ * Hardware virtualization extension instructions may fault if a
+ * reboot turns off virtualization while processes are running.
+ * Usually after catching the fault we just panic; during reboot
+ * instead the instruction is ignored.
+ */
+#define __ex(insn)							\
+	"666:	" insn "\n"						\
+	"	jmp 669f\n"						\
+	"667:\n"							\
+	"	.pushsection .discard.instr_begin\n"			\
+	"	.long 667b - .\n"					\
+	"	.popsection\n"						\
+	"	call kvm_spurious_fault\n"				\
+	"668:\n"							\
+	"	.pushsection .discard.instr_end\n"			\
+	"	.long 668b - .\n"					\
+	"	.popsection\n"						\
+	"669:\n"							\
+	_ASM_EXTABLE(666b, 667b)
+
 #define KVM_DEFAULT_PLE_GAP		128
 #define KVM_VMX_DEFAULT_PLE_WINDOW	4096
 #define KVM_DEFAULT_PLE_WINDOW_GROW	2
-- 
2.26.2

