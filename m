Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38AC92E0138
	for <lists+kvm@lfdr.de>; Mon, 21 Dec 2020 20:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725849AbgLUTt0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Dec 2020 14:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgLUTt0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Dec 2020 14:49:26 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972AEC0613D3;
        Mon, 21 Dec 2020 11:48:45 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id i24so10725960edj.8;
        Mon, 21 Dec 2020 11:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=REHRRpEqcqIxtzDgCEnLfnlCBNOPVwyGaF2sWG0peaw=;
        b=I75EkRKy9tco2xXRkMTScAvl0XTsFdcdghintw0/yakTylDRDM0gY0iwi/2B1f0LMI
         KybCNLMyFEx5wL+UY9IMHQrheJEYGLXeno66GKp8M2xyeCFgk3rUxvJhyt8SyuZp93+z
         DIXtFRzPnrVn//ijRv6ZsF9hbnOrvOzBDQCPILTih8MckZWCPfCInQySmzmMfDdMhVJq
         DWE3KoDdWQjdk8lnHQ/R5yoKuAm501e3/qp8nksov+UcM8kf/KewUDDMQVxcZVrqkDHs
         rZD8Jivs82lgws0/dVrDqsHo1Ep3jyzpO5yBMHNyVlee455JOTibQHKKhxWs+5t2pycr
         c5Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=REHRRpEqcqIxtzDgCEnLfnlCBNOPVwyGaF2sWG0peaw=;
        b=WX/Cj8tLagua4Hl4K4gUUxE/VPVxJHTa4vPB/bIUY+c4Nh2L+HRnVuzLZnxhQucUzb
         GIJ5CkGHdqJp7kp/yynzHjgT9dtOOAhLPFYDgV3IVcCRDAmJaN2Ipsv/2gNpz+9vtLPU
         +Lu6XzhOlley/KLjpQyWqVMnz8Ro1hz6Clkhd/jWtuzYVV66+5UHRvkorVsM9V6pZ3Ms
         5K/dGlxhczgdvuJvH1CjXf/2bEAvuEjwAQgP3tyd06uGntYfHtOaUWwh+6woVtSw0q83
         S+plRabQp0+FRAzly1PCyxmtHdmjxjVo6etEeZ3LXhwyKH7cfJ4YFsGytRzkNvSv0Kpe
         nAQg==
X-Gm-Message-State: AOAM532AYWguduLASa3zx2FkQr7uK/Dfbk0o+Kyho4f453SJ4diimLnV
        x6qxmST5r/ZNx3Muo/fYcNcOfOdZVvFP6g==
X-Google-Smtp-Source: ABdhPJx6v9VyJ2Qck17brnwjDjndTtBIhNvf5t6aDkT7+bbFSUQiA4206Z/iyEWbbZazfWPw2X4OLQ==
X-Received: by 2002:a50:c3c5:: with SMTP id i5mr17332512edf.166.1608580123766;
        Mon, 21 Dec 2020 11:48:43 -0800 (PST)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id qp16sm9450347ejb.74.2020.12.21.11.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 11:48:43 -0800 (PST)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: [PATCH v3] KVM/x86: Move definition of __ex to x86.h
Date:   Mon, 21 Dec 2020 20:48:00 +0100
Message-Id: <20201221194800.46962-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Merge __kvm_handle_fault_on_reboot with its sole user
and move the definition of __ex to a common include to be
shared between VMX and SVM.

v2: Rebase to the latest kvm/queue.

v3: Incorporate changes from review comments.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/include/asm/kvm_host.h | 25 -------------------------
 arch/x86/kvm/svm/sev.c          |  2 --
 arch/x86/kvm/svm/svm.c          |  2 --
 arch/x86/kvm/vmx/vmx.c          |  4 +---
 arch/x86/kvm/vmx/vmx_ops.h      |  4 +---
 arch/x86/kvm/x86.h              | 24 ++++++++++++++++++++++++
 6 files changed, 26 insertions(+), 35 deletions(-)

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
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 75c9c6a0a3a4..b82f2689f2d7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2320,9 +2320,7 @@ static void vmclear_local_loaded_vmcss(void)
 }
 
 
-/* Just like cpu_vmxoff(), but with the __kvm_handle_fault_on_reboot()
- * tricks.
- */
+/* Just like cpu_vmxoff(), but with the fault handling. */
 static void kvm_cpu_vmxoff(void)
 {
 	asm volatile (__ex("vmxoff"));
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
index c5ee0f5ce0f1..5b16d2b5c3bc 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -8,6 +8,30 @@
 #include "kvm_cache_regs.h"
 #include "kvm_emulate.h"
 
+asmlinkage void kvm_spurious_fault(void);
+
+/*
+ * Handle a fault on a hardware virtualization (VMX or SVM) instruction.
+ *
+ * Hardware virtualization extension instructions may fault if a reboot turns
+ * off virtualization while processes are running.  Usually after catching the
+ * fault we just panic; during reboot instead the instruction is ignored.
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
2.29.2

