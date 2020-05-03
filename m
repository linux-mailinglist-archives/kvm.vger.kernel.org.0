Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A93591C2B35
	for <lists+kvm@lfdr.de>; Sun,  3 May 2020 12:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgECKOA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 May 2020 06:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727916AbgECKN7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 3 May 2020 06:13:59 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913E6C061A0C;
        Sun,  3 May 2020 03:13:59 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id u22so5588916plq.12;
        Sun, 03 May 2020 03:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2HreKVDkgb2ZEZpEWOQgsvmgO+r8H3ubfnJned6T7sc=;
        b=AAr5F3SNw7C4Q98wwrX7yhWFpCO/ZfidNmcxUMu4jK2yVOQVdTQjIhW3Szkrkk6SiG
         6QDGQcVwk914VwvovEyf9ZUH6cHrWfy4OHbkUd0NlQn8d2ocf4z5in7/NS3aoOJu3T5h
         4cfvw3K3Da3/9dTpsiK0Ohc2qrhrpk1uv10cfvuK/M9HD9qfsWB2l5Kbbi+tQlgu7kRe
         vW81u+6LPKeL2b7ZbllbdiC7LglmQTDOp6+MppXn+efisvHbJQACdNn9G0bbDumjIEfr
         KvIS9TEx7y49vWE8JAN7CeLAa6iaUH2z/TRZVkg9tFOUep7uiWkxb1K/AVm8LDqVCoh9
         M5NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=2HreKVDkgb2ZEZpEWOQgsvmgO+r8H3ubfnJned6T7sc=;
        b=uJ6YLEkyEgt/nCG78XAhfzqSOofMHIzDHNZNd5wrtOfKFHVybLPE4XNnyf5HlozIjZ
         QAsxxphrHyRlOI5JG0EzPtcDVdAhC88+2HSOycj0FAMAz41I6YLdmy+QlfW4rNLrX8u1
         2jh08XjNR6T8qyFbXdi1Av/mwqqGUAgpDu8wJmlMUqABCsIWoyJ6fPYD0kzYiytyXTaU
         T0dot6+sBTGLWUXW/XAsgTMn/8C0/PSuymHWZiRQ5fHqtWQm3fhC69jOeWvpssApYuiC
         vxO6c/kmKEd3J8bo7kn4PzqIRKrlFGvJQc07OVp4LQU/nblIeBbq3I4TSEn0xAx4mRio
         KCTQ==
X-Gm-Message-State: AGi0PuY4TY0FGehyLvn4d4aKHrrHNJKIdVKjFjcnjVMdI+UKaK7Fob/+
        rsIi/iBpyr17jP5YQjbPcPE=
X-Google-Smtp-Source: APiQypJHEnlSEN+OhJ7jC3XTecKnYZTetY/oc3lMJap6djnlR2vYYHLnzme4VNkULv6rLt/UoOlIPA==
X-Received: by 2002:a17:90a:a893:: with SMTP id h19mr10530005pjq.138.1588500839087;
        Sun, 03 May 2020 03:13:59 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id r26sm6329902pfq.75.2020.05.03.03.13.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 May 2020 03:13:58 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        linux-mips@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V3 09/14] KVM: MIPS: Add more types of virtual interrupts
Date:   Sun,  3 May 2020 18:06:02 +0800
Message-Id: <1588500367-1056-10-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1588500367-1056-1-git-send-email-chenhc@lemote.com>
References: <1588500367-1056-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In current implementation, MIPS KVM uses IP2, IP3, IP4 and IP7 for
external interrupt, two kinds of IPIs and timer interrupt respectively,
but Loongson-3 based machines prefer to use IP2, IP3, IP6 and IP7 for
two kinds of external interrupts, IPI and timer interrupt. So we define
two priority-irq mapping tables: kvm_loongson3_priority_to_irq[] for
Loongson-3, and kvm_default_priority_to_irq[] for others. The virtual
interrupt infrastructure is updated to deliver all types of interrupts
from IP2, IP3, IP4, IP6 and IP7.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/kvm/interrupt.c | 93 +++++++----------------------------------------
 arch/mips/kvm/interrupt.h | 14 ++++---
 arch/mips/kvm/mips.c      | 40 ++++++++++++++++++--
 arch/mips/kvm/vz.c        | 53 ++++-----------------------
 4 files changed, 67 insertions(+), 133 deletions(-)

diff --git a/arch/mips/kvm/interrupt.c b/arch/mips/kvm/interrupt.c
index 7257e8b6..d28c2c9c 100644
--- a/arch/mips/kvm/interrupt.c
+++ b/arch/mips/kvm/interrupt.c
@@ -61,27 +61,8 @@ void kvm_mips_queue_io_int_cb(struct kvm_vcpu *vcpu,
 	 * the EXC code will be set when we are actually
 	 * delivering the interrupt:
 	 */
-	switch (intr) {
-	case 2:
-		kvm_set_c0_guest_cause(vcpu->arch.cop0, (C_IRQ0));
-		/* Queue up an INT exception for the core */
-		kvm_mips_queue_irq(vcpu, MIPS_EXC_INT_IO);
-		break;
-
-	case 3:
-		kvm_set_c0_guest_cause(vcpu->arch.cop0, (C_IRQ1));
-		kvm_mips_queue_irq(vcpu, MIPS_EXC_INT_IPI_1);
-		break;
-
-	case 4:
-		kvm_set_c0_guest_cause(vcpu->arch.cop0, (C_IRQ2));
-		kvm_mips_queue_irq(vcpu, MIPS_EXC_INT_IPI_2);
-		break;
-
-	default:
-		break;
-	}
-
+	kvm_set_c0_guest_cause(vcpu->arch.cop0, 1 << (intr + 8));
+	kvm_mips_queue_irq(vcpu, kvm_irq_to_priority(intr));
 }
 
 void kvm_mips_dequeue_io_int_cb(struct kvm_vcpu *vcpu,
@@ -89,26 +70,8 @@ void kvm_mips_dequeue_io_int_cb(struct kvm_vcpu *vcpu,
 {
 	int intr = (int)irq->irq;
 
-	switch (intr) {
-	case -2:
-		kvm_clear_c0_guest_cause(vcpu->arch.cop0, (C_IRQ0));
-		kvm_mips_dequeue_irq(vcpu, MIPS_EXC_INT_IO);
-		break;
-
-	case -3:
-		kvm_clear_c0_guest_cause(vcpu->arch.cop0, (C_IRQ1));
-		kvm_mips_dequeue_irq(vcpu, MIPS_EXC_INT_IPI_1);
-		break;
-
-	case -4:
-		kvm_clear_c0_guest_cause(vcpu->arch.cop0, (C_IRQ2));
-		kvm_mips_dequeue_irq(vcpu, MIPS_EXC_INT_IPI_2);
-		break;
-
-	default:
-		break;
-	}
-
+	kvm_clear_c0_guest_cause(vcpu->arch.cop0, 1 << (-intr + 8));
+	kvm_mips_dequeue_irq(vcpu, kvm_irq_to_priority(-intr));
 }
 
 /* Deliver the interrupt of the corresponding priority, if possible. */
@@ -116,50 +79,20 @@ int kvm_mips_irq_deliver_cb(struct kvm_vcpu *vcpu, unsigned int priority,
 			    u32 cause)
 {
 	int allowed = 0;
-	u32 exccode;
+	u32 exccode, ie;
 
 	struct kvm_vcpu_arch *arch = &vcpu->arch;
 	struct mips_coproc *cop0 = vcpu->arch.cop0;
 
-	switch (priority) {
-	case MIPS_EXC_INT_TIMER:
-		if ((kvm_read_c0_guest_status(cop0) & ST0_IE)
-		    && (!(kvm_read_c0_guest_status(cop0) & (ST0_EXL | ST0_ERL)))
-		    && (kvm_read_c0_guest_status(cop0) & IE_IRQ5)) {
-			allowed = 1;
-			exccode = EXCCODE_INT;
-		}
-		break;
-
-	case MIPS_EXC_INT_IO:
-		if ((kvm_read_c0_guest_status(cop0) & ST0_IE)
-		    && (!(kvm_read_c0_guest_status(cop0) & (ST0_EXL | ST0_ERL)))
-		    && (kvm_read_c0_guest_status(cop0) & IE_IRQ0)) {
-			allowed = 1;
-			exccode = EXCCODE_INT;
-		}
-		break;
-
-	case MIPS_EXC_INT_IPI_1:
-		if ((kvm_read_c0_guest_status(cop0) & ST0_IE)
-		    && (!(kvm_read_c0_guest_status(cop0) & (ST0_EXL | ST0_ERL)))
-		    && (kvm_read_c0_guest_status(cop0) & IE_IRQ1)) {
-			allowed = 1;
-			exccode = EXCCODE_INT;
-		}
-		break;
-
-	case MIPS_EXC_INT_IPI_2:
-		if ((kvm_read_c0_guest_status(cop0) & ST0_IE)
-		    && (!(kvm_read_c0_guest_status(cop0) & (ST0_EXL | ST0_ERL)))
-		    && (kvm_read_c0_guest_status(cop0) & IE_IRQ2)) {
-			allowed = 1;
-			exccode = EXCCODE_INT;
-		}
-		break;
+	if (priority == MIPS_EXC_MAX)
+		return 0;
 
-	default:
-		break;
+	ie = 1 << (kvm_priority_to_irq[priority] + 8);
+	if ((kvm_read_c0_guest_status(cop0) & ST0_IE)
+	    && (!(kvm_read_c0_guest_status(cop0) & (ST0_EXL | ST0_ERL)))
+	    && (kvm_read_c0_guest_status(cop0) & ie)) {
+		allowed = 1;
+		exccode = EXCCODE_INT;
 	}
 
 	/* Are we allowed to deliver the interrupt ??? */
diff --git a/arch/mips/kvm/interrupt.h b/arch/mips/kvm/interrupt.h
index 3bf0a49..c3e878c 100644
--- a/arch/mips/kvm/interrupt.h
+++ b/arch/mips/kvm/interrupt.h
@@ -21,11 +21,12 @@
 #define MIPS_EXC_NMI                5
 #define MIPS_EXC_MCHK               6
 #define MIPS_EXC_INT_TIMER          7
-#define MIPS_EXC_INT_IO             8
-#define MIPS_EXC_EXECUTE            9
-#define MIPS_EXC_INT_IPI_1          10
-#define MIPS_EXC_INT_IPI_2          11
-#define MIPS_EXC_MAX                12
+#define MIPS_EXC_INT_IO_1           8
+#define MIPS_EXC_INT_IO_2           9
+#define MIPS_EXC_EXECUTE            10
+#define MIPS_EXC_INT_IPI_1          11
+#define MIPS_EXC_INT_IPI_2          12
+#define MIPS_EXC_MAX                13
 /* XXXSL More to follow */
 
 #define C_TI        (_ULCAST_(1) << 30)
@@ -38,6 +39,9 @@
 #define KVM_MIPS_IRQ_CLEAR_ALL_AT_ONCE   (0)
 #endif
 
+extern u32 *kvm_priority_to_irq;
+u32 kvm_irq_to_priority(u32 irq);
+
 void kvm_mips_queue_irq(struct kvm_vcpu *vcpu, unsigned int priority);
 void kvm_mips_dequeue_irq(struct kvm_vcpu *vcpu, unsigned int priority);
 int kvm_mips_pending_timer(struct kvm_vcpu *vcpu);
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 8f05dd0..5ca122c 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -489,7 +489,10 @@ int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
 	int intr = (int)irq->irq;
 	struct kvm_vcpu *dvcpu = NULL;
 
-	if (intr == 3 || intr == -3 || intr == 4 || intr == -4)
+	if (intr == kvm_priority_to_irq[MIPS_EXC_INT_IPI_1] ||
+	    intr == kvm_priority_to_irq[MIPS_EXC_INT_IPI_2] ||
+	    intr == (-kvm_priority_to_irq[MIPS_EXC_INT_IPI_1]) ||
+	    intr == (-kvm_priority_to_irq[MIPS_EXC_INT_IPI_2]))
 		kvm_debug("%s: CPU: %d, INTR: %d\n", __func__, irq->cpu,
 			  (int)intr);
 
@@ -498,10 +501,10 @@ int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
 	else
 		dvcpu = vcpu->kvm->vcpus[irq->cpu];
 
-	if (intr == 2 || intr == 3 || intr == 4) {
+	if (intr == 2 || intr == 3 || intr == 4 || intr == 6) {
 		kvm_mips_callbacks->queue_io_int(dvcpu, irq);
 
-	} else if (intr == -2 || intr == -3 || intr == -4) {
+	} else if (intr == -2 || intr == -3 || intr == -4 || intr == -6) {
 		kvm_mips_callbacks->dequeue_io_int(dvcpu, irq);
 	} else {
 		kvm_err("%s: invalid interrupt ioctl (%d:%d)\n", __func__,
@@ -1620,6 +1623,34 @@ static struct notifier_block kvm_mips_csr_die_notifier = {
 	.notifier_call = kvm_mips_csr_die_notify,
 };
 
+static u32 kvm_default_priority_to_irq[MIPS_EXC_MAX] = {
+	[MIPS_EXC_INT_TIMER] = C_IRQ5,
+	[MIPS_EXC_INT_IO_1]  = C_IRQ0,
+	[MIPS_EXC_INT_IPI_1] = C_IRQ1,
+	[MIPS_EXC_INT_IPI_2] = C_IRQ2,
+};
+
+static u32 kvm_loongson3_priority_to_irq[MIPS_EXC_MAX] = {
+	[MIPS_EXC_INT_TIMER] = C_IRQ5,
+	[MIPS_EXC_INT_IO_1]  = C_IRQ0,
+	[MIPS_EXC_INT_IO_2]  = C_IRQ1,
+	[MIPS_EXC_INT_IPI_1] = C_IRQ4,
+};
+
+u32 *kvm_priority_to_irq = kvm_default_priority_to_irq;
+
+u32 kvm_irq_to_priority(u32 irq)
+{
+	int i;
+
+	for (i = MIPS_EXC_INT_TIMER; i < MIPS_EXC_MAX; i++) {
+		if (kvm_priority_to_irq[i] == (1 << (irq + 8)))
+			return i;
+	}
+
+	return MIPS_EXC_MAX;
+}
+
 static int __init kvm_mips_init(void)
 {
 	int ret;
@@ -1638,6 +1669,9 @@ static int __init kvm_mips_init(void)
 	if (ret)
 		return ret;
 
+	if (boot_cpu_type() == CPU_LOONGSON64)
+		kvm_priority_to_irq = kvm_loongson3_priority_to_irq;
+
 	register_die_notifier(&kvm_mips_csr_die_notifier);
 
 	return 0;
diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
index ab320f0..63d5b35 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -225,23 +225,7 @@ static void kvm_vz_queue_io_int_cb(struct kvm_vcpu *vcpu,
 	 * interrupts are asynchronous to vcpu execution therefore defer guest
 	 * cp0 accesses
 	 */
-	switch (intr) {
-	case 2:
-		kvm_vz_queue_irq(vcpu, MIPS_EXC_INT_IO);
-		break;
-
-	case 3:
-		kvm_vz_queue_irq(vcpu, MIPS_EXC_INT_IPI_1);
-		break;
-
-	case 4:
-		kvm_vz_queue_irq(vcpu, MIPS_EXC_INT_IPI_2);
-		break;
-
-	default:
-		break;
-	}
-
+	kvm_vz_queue_irq(vcpu, kvm_irq_to_priority(intr));
 }
 
 static void kvm_vz_dequeue_io_int_cb(struct kvm_vcpu *vcpu,
@@ -253,44 +237,22 @@ static void kvm_vz_dequeue_io_int_cb(struct kvm_vcpu *vcpu,
 	 * interrupts are asynchronous to vcpu execution therefore defer guest
 	 * cp0 accesses
 	 */
-	switch (intr) {
-	case -2:
-		kvm_vz_dequeue_irq(vcpu, MIPS_EXC_INT_IO);
-		break;
-
-	case -3:
-		kvm_vz_dequeue_irq(vcpu, MIPS_EXC_INT_IPI_1);
-		break;
-
-	case -4:
-		kvm_vz_dequeue_irq(vcpu, MIPS_EXC_INT_IPI_2);
-		break;
-
-	default:
-		break;
-	}
-
+	kvm_vz_dequeue_irq(vcpu, kvm_irq_to_priority(-intr));
 }
 
-static u32 kvm_vz_priority_to_irq[MIPS_EXC_MAX] = {
-	[MIPS_EXC_INT_TIMER] = C_IRQ5,
-	[MIPS_EXC_INT_IO]    = C_IRQ0,
-	[MIPS_EXC_INT_IPI_1] = C_IRQ1,
-	[MIPS_EXC_INT_IPI_2] = C_IRQ2,
-};
-
 static int kvm_vz_irq_deliver_cb(struct kvm_vcpu *vcpu, unsigned int priority,
 				 u32 cause)
 {
 	u32 irq = (priority < MIPS_EXC_MAX) ?
-		kvm_vz_priority_to_irq[priority] : 0;
+		kvm_priority_to_irq[priority] : 0;
 
 	switch (priority) {
 	case MIPS_EXC_INT_TIMER:
 		set_gc0_cause(C_TI);
 		break;
 
-	case MIPS_EXC_INT_IO:
+	case MIPS_EXC_INT_IO_1:
+	case MIPS_EXC_INT_IO_2:
 	case MIPS_EXC_INT_IPI_1:
 	case MIPS_EXC_INT_IPI_2:
 		if (cpu_has_guestctl2)
@@ -311,7 +273,7 @@ static int kvm_vz_irq_clear_cb(struct kvm_vcpu *vcpu, unsigned int priority,
 			       u32 cause)
 {
 	u32 irq = (priority < MIPS_EXC_MAX) ?
-		kvm_vz_priority_to_irq[priority] : 0;
+		kvm_priority_to_irq[priority] : 0;
 
 	switch (priority) {
 	case MIPS_EXC_INT_TIMER:
@@ -329,7 +291,8 @@ static int kvm_vz_irq_clear_cb(struct kvm_vcpu *vcpu, unsigned int priority,
 		}
 		break;
 
-	case MIPS_EXC_INT_IO:
+	case MIPS_EXC_INT_IO_1:
+	case MIPS_EXC_INT_IO_2:
 	case MIPS_EXC_INT_IPI_1:
 	case MIPS_EXC_INT_IPI_2:
 		/* Clear GuestCtl2.VIP irq if not using Hardware Clear */
-- 
2.7.0

