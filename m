Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8BC16E4573
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 12:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjDQKnO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 06:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjDQKnM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 06:43:12 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 002D04214;
        Mon, 17 Apr 2023 03:42:18 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8AxEk6iGD1kIOcdAA--.34835S3;
        Mon, 17 Apr 2023 18:00:02 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Bx57yWGD1kua0qAA--.48254S32;
        Mon, 17 Apr 2023 18:00:02 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, zhaotianrui@loongson.cn
Subject: [PATCH v7 30/30] LoongArch: KVM: Supplement kvm document about loongarch-specific part
Date:   Mon, 17 Apr 2023 17:59:50 +0800
Message-Id: <20230417095950.875228-31-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230417095950.875228-1-zhaotianrui@loongson.cn>
References: <20230417095950.875228-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Bx57yWGD1kua0qAA--.48254S32
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoW3AFyUuF4rtFW3WrW3uFWrGrg_yoW7Cw4UpF
        ZIk3yfKr48try7t347J34jqry3GFyxtF47Ca4ftr1xC3Wjyw1kJrnFyrW8JFWUC348AF18
        AFy0yw47CFyUAw7anT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bcxFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26F4UJVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCE
        c2xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E74AGY7Cv6cx26r
        WlOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r126r1D
        MxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_WwCFx2IqxVCFs4IE7xkEbVWUJV
        W8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
        14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
        IY67AKxVWDJVCq3wCI42IY6xIIjxv20xvEc7CjxVAFwI0_Cr1j6rxdMIIF0xvE42xK8VAv
        wI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWxJr0_GcWlIxAIcVC2z280aVCY1x0267
        AKxVWxJr0_GcJvcSsGvfC2KfnxnUUI43ZEXa7xRiTKZJUUUUU==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Supplement kvm document about loongarch-specific part, such as add
api introduction for GET/SET_ONE_REG, GET/SET_FPU, GET/SET_MP_STATE,
etc.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 Documentation/virt/kvm/api.rst | 71 +++++++++++++++++++++++++++++-----
 1 file changed, 62 insertions(+), 9 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a5c803f39832..84c26a577559 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -416,6 +416,12 @@ Reads the general purpose registers from the vcpu.
 	__u64 pc;
   };
 
+  /* loongarch */
+  struct kvm_regs {
+        unsigned long gpr[32];
+        unsigned long pc;
+  };
+
 
 4.12 KVM_SET_REGS
 -----------------
@@ -506,7 +512,7 @@ translation mode.
 ------------------
 
 :Capability: basic
-:Architectures: x86, ppc, mips, riscv
+:Architectures: x86, ppc, mips, riscv, loongarch
 :Type: vcpu ioctl
 :Parameters: struct kvm_interrupt (in)
 :Returns: 0 on success, negative on failure.
@@ -592,6 +598,14 @@ b) KVM_INTERRUPT_UNSET
 
 This is an asynchronous vcpu ioctl and can be invoked from any thread.
 
+LOONGARCH:
+^^^^^^^^^^
+
+Queues an external interrupt to be injected into the virtual CPU. A negative
+interrupt number dequeues the interrupt.
+
+This is an asynchronous vcpu ioctl and can be invoked from any thread.
+
 
 4.17 KVM_DEBUG_GUEST
 --------------------
@@ -737,7 +751,7 @@ signal mask.
 ----------------
 
 :Capability: basic
-:Architectures: x86
+:Architectures: x86, loongarch
 :Type: vcpu ioctl
 :Parameters: struct kvm_fpu (out)
 :Returns: 0 on success, -1 on error
@@ -746,7 +760,7 @@ Reads the floating point state from the vcpu.
 
 ::
 
-  /* for KVM_GET_FPU and KVM_SET_FPU */
+  /* x86: for KVM_GET_FPU and KVM_SET_FPU */
   struct kvm_fpu {
 	__u8  fpr[8][16];
 	__u16 fcw;
@@ -761,12 +775,22 @@ Reads the floating point state from the vcpu.
 	__u32 pad2;
   };
 
+  /* loongarch: for KVM_GET_FPU and KVM_SET_FPU */
+  struct kvm_fpu {
+        __u32 fcsr;
+        __u32 none;
+        __u64 fcc;
+        struct kvm_fpureg {
+                __u64 val64[4];
+        }fpr[32];
+  };
+
 
 4.23 KVM_SET_FPU
 ----------------
 
 :Capability: basic
-:Architectures: x86
+:Architectures: x86, loongarch
 :Type: vcpu ioctl
 :Parameters: struct kvm_fpu (in)
 :Returns: 0 on success, -1 on error
@@ -775,7 +799,7 @@ Writes the floating point state to the vcpu.
 
 ::
 
-  /* for KVM_GET_FPU and KVM_SET_FPU */
+  /* x86: for KVM_GET_FPU and KVM_SET_FPU */
   struct kvm_fpu {
 	__u8  fpr[8][16];
 	__u16 fcw;
@@ -790,6 +814,16 @@ Writes the floating point state to the vcpu.
 	__u32 pad2;
   };
 
+  /* loongarch: for KVM_GET_FPU and KVM_SET_FPU */
+  struct kvm_fpu {
+        __u32 fcsr;
+        __u32 none;
+        __u64 fcc;
+        struct kvm_fpureg {
+                __u64 val64[4];
+        }fpr[32];
+  };
+
 
 4.24 KVM_CREATE_IRQCHIP
 -----------------------
@@ -1387,7 +1421,7 @@ documentation when it pops into existence).
 -------------------
 
 :Capability: KVM_CAP_ENABLE_CAP
-:Architectures: mips, ppc, s390, x86
+:Architectures: mips, ppc, s390, x86, loongarch
 :Type: vcpu ioctl
 :Parameters: struct kvm_enable_cap (in)
 :Returns: 0 on success; -1 on error
@@ -1442,7 +1476,7 @@ for vm-wide capabilities.
 ---------------------
 
 :Capability: KVM_CAP_MP_STATE
-:Architectures: x86, s390, arm64, riscv
+:Architectures: x86, s390, arm64, riscv, loongarch
 :Type: vcpu ioctl
 :Parameters: struct kvm_mp_state (out)
 :Returns: 0 on success; -1 on error
@@ -1460,7 +1494,7 @@ Possible values are:
 
    ==========================    ===============================================
    KVM_MP_STATE_RUNNABLE         the vcpu is currently running
-                                 [x86,arm64,riscv]
+                                 [x86,arm64,riscv,loongarch]
    KVM_MP_STATE_UNINITIALIZED    the vcpu is an application processor (AP)
                                  which has not yet received an INIT signal [x86]
    KVM_MP_STATE_INIT_RECEIVED    the vcpu has received an INIT signal, and is
@@ -1516,11 +1550,14 @@ For riscv:
 The only states that are valid are KVM_MP_STATE_STOPPED and
 KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
 
+On loongarch, the KVM_MP_STATE_RUNNABLE state is only used which reflect the
+vcpu is runnable.
+
 4.39 KVM_SET_MP_STATE
 ---------------------
 
 :Capability: KVM_CAP_MP_STATE
-:Architectures: x86, s390, arm64, riscv
+:Architectures: x86, s390, arm64, riscv, loongarch
 :Type: vcpu ioctl
 :Parameters: struct kvm_mp_state (in)
 :Returns: 0 on success; -1 on error
@@ -1538,6 +1575,9 @@ For arm64/riscv:
 The only states that are valid are KVM_MP_STATE_STOPPED and
 KVM_MP_STATE_RUNNABLE which reflect if the vcpu should be paused or not.
 
+On loongarch, the KVM_MP_STATE_RUNNABLE state is only used which reflect the
+vcpu is runnable.
+
 4.40 KVM_SET_IDENTITY_MAP_ADDR
 ------------------------------
 
@@ -2839,6 +2879,19 @@ Following are the RISC-V D-extension registers:
   0x8020 0000 0600 0020 fcsr      Floating point control and status register
 ======================= ========= =============================================
 
+LoongArch registers are mapped using the lower 32 bits. The upper 16 bits of
+that is the register group type.
+
+LoongArch csr registers are used to control guest cpu or get status of guest
+cpu, and they have the following id bit patterns::
+
+  0x9030 0000 0001 00 <reg:5> <sel:3>   (64-bit)
+
+LoongArch KVM control registers are used to implement some new defined functions
+such as set vcpu counter or reset vcpu, and they have the following id bit patterns::
+
+  0x9030 0000 0002 <reg:16>
+
 
 4.69 KVM_GET_ONE_REG
 --------------------
-- 
2.31.1

