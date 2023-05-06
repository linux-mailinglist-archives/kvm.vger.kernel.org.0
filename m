Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEC1A6F8DF3
	for <lists+kvm@lfdr.de>; Sat,  6 May 2023 04:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbjEFCYe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 22:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjEFCYb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 22:24:31 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7A2115B8A
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 19:24:29 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8CxOupculVk8okFAA--.9030S3;
        Sat, 06 May 2023 10:24:28 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxOLZXulVkj9RMAA--.9112S3;
        Sat, 06 May 2023 10:24:26 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        gaosong@loongson.cn, "Michael S . Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, maobibo@loongson.cn,
        zhaotianrui@loongson.cn, philmd@linaro.org,
        richard.henderson@linaro.org, peter.maydell@linaro.org
Subject: [PATCH RFC v3 1/9] linux-headers: Add KVM headers for loongarch
Date:   Sat,  6 May 2023 10:24:14 +0800
Message-Id: <20230506022422.59442-2-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230506022422.59442-1-zhaotianrui@loongson.cn>
References: <20230506022422.59442-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8DxOLZXulVkj9RMAA--.9112S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoWxuF4Uuw43uFW5XFy3Jr18Krg_yoWrAF4fpF
        1UAr43Gr40qrn3u3yxGF1UZr13WF4fAa1v9FyxW3yIyr1j93s5Jw1qkFs8GF98Jr18C34x
        ZF1Yyw1j9F92y3DanT9S1TB71UUUUUJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bckFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7
        CjxVAFwI0_Gr1j6F4UJwAaw2AFwI0_Jrv_JF1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAq
        jxCEc2xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E74AGY7Cv6c
        x26rWlOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r12
        6r1DMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_WwCFx2IqxVCFs4IE7xkEbV
        WUJVW8JwCFI7km07C267AKxVWUXVWUAwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
        Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
        IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k2
        6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0zRXo7NUUUUU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch is only a placeholder now, which is used to
show some kvm structures and macros for reviewers.
And it will be replaced by using update-linux-headers.sh
when the linux loongarch kvm patches are accepted.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 linux-headers/asm-loongarch/kvm.h | 99 +++++++++++++++++++++++++++++++
 linux-headers/linux/kvm.h         |  9 +++
 2 files changed, 108 insertions(+)
 create mode 100644 linux-headers/asm-loongarch/kvm.h

diff --git a/linux-headers/asm-loongarch/kvm.h b/linux-headers/asm-loongarch/kvm.h
new file mode 100644
index 0000000000..6420f59f9e
--- /dev/null
+++ b/linux-headers/asm-loongarch/kvm.h
@@ -0,0 +1,99 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Copyright (C) 2023 Loongson Technology Corporation Limited
+ */
+
+#ifndef __UAPI_ASM_LOONGARCH_KVM_H
+#define __UAPI_ASM_LOONGARCH_KVM_H
+
+#include <linux/types.h>
+
+/*
+ * KVM Loongarch specific structures and definitions.
+ */
+
+#define __KVM_HAVE_READONLY_MEM
+
+#define KVM_COALESCED_MMIO_PAGE_OFFSET 1
+
+/*
+ * for KVM_GET_REGS and KVM_SET_REGS
+ */
+struct kvm_regs {
+	/* out (KVM_GET_REGS) / in (KVM_SET_REGS) */
+	__u64 gpr[32];
+	__u64 pc;
+};
+
+/*
+ * for KVM_GET_FPU and KVM_SET_FPU
+ */
+struct kvm_fpu {
+	__u32 fcsr;
+	__u32 none;
+	__u64 fcc;    /* 8x8 */
+	struct kvm_fpureg {
+		__u64 val64[4];
+	} fpr[32];
+};
+
+/*
+ * For LoongArch, we use KVM_SET_ONE_REG and KVM_GET_ONE_REG to access various
+ * registers.  The id field is broken down as follows:
+ *
+ *  bits[63..52] - As per linux/kvm.h
+ *  bits[51..32] - Must be zero.
+ *  bits[31..16] - Register set.
+ *
+ * Register set = 0: GP registers from kvm_regs (see definitions below).
+ *
+ * Register set = 1: CSR registers.
+ *
+ * Register set = 2: KVM specific registers (see definitions below).
+ *
+ * Register set = 3: FPU / SIMD registers (see definitions below).
+ *
+ * Other sets registers may be added in the future.  Each set would
+ * have its own identifier in bits[31..16].
+ */
+
+#define KVM_REG_LOONGARCH_GP		(KVM_REG_LOONGARCH | 0x00000ULL)
+#define KVM_REG_LOONGARCH_CSR		(KVM_REG_LOONGARCH | 0x10000ULL)
+#define KVM_REG_LOONGARCH_KVM		(KVM_REG_LOONGARCH | 0x20000ULL)
+#define KVM_REG_LOONGARCH_FPU		(KVM_REG_LOONGARCH | 0x30000ULL)
+#define KVM_REG_LOONGARCH_MASK		(KVM_REG_LOONGARCH | 0x30000ULL)
+#define KVM_CSR_IDX_MASK		(0x10000 - 1)
+
+/*
+ * KVM_REG_LOONGARCH_KVM - KVM specific control registers.
+ */
+
+#define KVM_REG_LOONGARCH_COUNTER	(KVM_REG_LOONGARCH_KVM | KVM_REG_SIZE_U64 | 3)
+#define KVM_REG_LOONGARCH_VCPU_RESET	(KVM_REG_LOONGARCH_KVM | KVM_REG_SIZE_U64 | 4)
+
+struct kvm_debug_exit_arch {
+};
+
+/* for KVM_SET_GUEST_DEBUG */
+struct kvm_guest_debug_arch {
+};
+
+/* definition of registers in kvm_run */
+struct kvm_sync_regs {
+};
+
+/* dummy definition */
+struct kvm_sregs {
+};
+
+struct kvm_loongarch_interrupt {
+	/* in */
+	__u32 cpu;
+	__u32 irq;
+};
+
+#define KVM_NR_IRQCHIPS		1
+#define KVM_IRQCHIP_NUM_PINS	64
+#define KVM_MAX_CORES		256
+
+#endif /* __UAPI_ASM_LOONGARCH_KVM_H */
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 599de3c6e3..d82e1da7a8 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -264,6 +264,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_RISCV_SBI        35
 #define KVM_EXIT_RISCV_CSR        36
 #define KVM_EXIT_NOTIFY           37
+#define KVM_EXIT_LOONGARCH_IOCSR  38
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -336,6 +337,13 @@ struct kvm_run {
 			__u32 len;
 			__u8  is_write;
 		} mmio;
+		/* KVM_EXIT_LOONGARCH_IOCSR */
+		struct {
+			__u64 phys_addr;
+			__u8  data[8];
+			__u32 len;
+			__u8  is_write;
+		} iocsr_io;
 		/* KVM_EXIT_HYPERCALL */
 		struct {
 			__u64 nr;
@@ -1352,6 +1360,7 @@ struct kvm_dirty_tlb {
 #define KVM_REG_ARM64		0x6000000000000000ULL
 #define KVM_REG_MIPS		0x7000000000000000ULL
 #define KVM_REG_RISCV		0x8000000000000000ULL
+#define KVM_REG_LOONGARCH	0x9000000000000000ULL
 
 #define KVM_REG_SIZE_SHIFT	52
 #define KVM_REG_SIZE_MASK	0x00f0000000000000ULL
-- 
2.31.1

