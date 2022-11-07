Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEA861F6A2
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 15:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbiKGOxF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 09:53:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbiKGOxE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 09:53:04 -0500
Received: from out203-205-221-210.mail.qq.com (out203-205-221-210.mail.qq.com [203.205.221.210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157141C42C;
        Mon,  7 Nov 2022 06:53:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1667832778;
        bh=ydwp8OFfyNC3czSkVZxP+swyc/Ys7TW8cMf+ICjld9k=;
        h=From:To:Cc:Subject:Date;
        b=W6P3FhiqTwfi328eGZnLO2Ur77Nv8f9zhcyUBz6y6Vd701AEqano1e8S/YehKpiKr
         6CTVf9z8krhqLhKGAUhCDjR/TY4s+aD9ixPozrQx+mfnGlFTpdzcyDypJwglWczSFf
         E9tuw5aRJBCViM+WEg1Zt4jkXhxLtQSuS/JYW0MU=
Received: from localhost.localdomain ([111.199.191.46])
        by newxmesmtplogicsvrszc2-1.qq.com (NewEsmtp) with SMTP
        id D390D68D; Mon, 07 Nov 2022 22:52:57 +0800
X-QQ-mid: xmsmtpt1667832777tphmmd7vn
Message-ID: <tencent_00082C8BFA925A65E11570F417F1CD404505@qq.com>
X-QQ-XMAILINFO: N3l5ASPewLWq4Uhl1CArSyWT4MJYqsh11W6vWdIGDNfLbUYEvf45isialscPab
         OLxIzzPDyTAMDfml6D+gAq12nohz/4KXm4d1/IAL3HR4vKJd3+OxcRt1t8igkIJ4Zx7sibC7EHKN
         Bjeb/86YJyrIA8WXHttuEDnnw0v1czODpHScabmXKKO2GDtl2yxVypwVyUjkyhrz1NNM5sBQCT+c
         wcv9RYr0TopiUf/O2Fgpu+kAbfVVgH3p1dqW3EaCBsGIQx0+XSed/wSL9hzUrLMgNmn8Eyosa5la
         z4ZJLdEoz38MjBDDL3ioWXmM7Kgp+0UEy7R0HAOpxNXldsJyFZiOArXJhCsBhZUbxobDxWAxdjt7
         eO1R90fxkFjDyspl4vOXPGPX94z/W9iKwfKvDckejT5qRNx0bwVrqVF/Lkjip7Xk8fjknwdNZYf4
         4IgBIoLMgJ2wjHj4QVrxv9NMR2dF1JqvqSrCZkl92OlPubZhzgu1VKPTs11LHKZbY3Q6LlgzcdVp
         JKRi5PCqqq4MoRxU2w3cZrPP+uAKXT0uulCMV9FNDy1uOicCKrdHmAW+goD5pY/uZ2ED3Y5jAn/z
         lHTW4E2t9/BHeoycGzFvEqdARAnKNaVg9es0EoyeinRRcQjSRnVwwnb1ySROgejrf4Ank7K2tiso
         6VwNIDC8VA4qhTk1dXuhebJGYucX9heQqSPPs4JyAowLSBQcmVtDPSjXleuJrf5H7OU2v0F5BrNp
         XQTPeq9yZks96RvHKdo6cdB8fqkiA/OpFEklP8/mDe4VXxexvs40grZK6EkooIZTmdlvQmiJjH0v
         6Bph9gwMSilsGBCJlKyPOqos+lmZqTgakRCb7LeHNojTyLKTG+XxnPXBAg0/SHwmigOp4U+dWx4n
         TuijpOGxCrhElX3WTO8Tt4i2fF2Dp9PQmm41oPxGl7FrjbFX8/Jiz6oF4JfD7mDALc+zZ8wTirdx
         AsRKy2Gz2BkTrs24K1JVJgYExT1Fyc
From:   Rong Tao <rtoax@foxmail.com>
To:     pbonzini@redhat.com
Cc:     Rong Tao <rongtao@cestc.cn>,
        Dmitry Klochkov <kdmitry556@gmail.com>,
        kvm@vger.kernel.org (open list:KERNEL VIRTUAL MACHINE (KVM)),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] tools/kvm_stat: update exit reasons for vmx/svm/aarch64/userspace
Date:   Mon,  7 Nov 2022 22:52:49 +0800
X-OQ-MSGID: <20221107145250.23018-1-rtoax@foxmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RDNS_DYNAMIC,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Rong Tao <rongtao@cestc.cn>

Update EXIT_REASONS from source, including VMX_EXIT_REASONS,
SVM_EXIT_REASONS, AARCH64_EXIT_REASONS, USERSPACE_EXIT_REASONS.

Signed-off-by: Rong Tao <rongtao@cestc.cn>
---
 tools/kvm/kvm_stat/kvm_stat | 96 +++++++++++++++++++++++++++++++------
 1 file changed, 82 insertions(+), 14 deletions(-)

diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
index 9c366b3a676d..a34b781a3ce8 100755
--- a/tools/kvm/kvm_stat/kvm_stat
+++ b/tools/kvm/kvm_stat/kvm_stat
@@ -41,11 +41,14 @@ VMX_EXIT_REASONS = {
     'EXCEPTION_NMI':        0,
     'EXTERNAL_INTERRUPT':   1,
     'TRIPLE_FAULT':         2,
-    'PENDING_INTERRUPT':    7,
+    'INIT_SIGNAL':          3,
+    'SIPI_SIGNAL':          4,
+    'INTERRUPT_WINDOW':     7,
     'NMI_WINDOW':           8,
     'TASK_SWITCH':          9,
     'CPUID':                10,
     'HLT':                  12,
+    'INVD':                 13,
     'INVLPG':               14,
     'RDPMC':                15,
     'RDTSC':                16,
@@ -65,26 +68,48 @@ VMX_EXIT_REASONS = {
     'MSR_READ':             31,
     'MSR_WRITE':            32,
     'INVALID_STATE':        33,
+    'MSR_LOAD_FAIL':        34,
     'MWAIT_INSTRUCTION':    36,
+    'MONITOR_TRAP_FLAG':    37,
     'MONITOR_INSTRUCTION':  39,
     'PAUSE_INSTRUCTION':    40,
     'MCE_DURING_VMENTRY':   41,
     'TPR_BELOW_THRESHOLD':  43,
     'APIC_ACCESS':          44,
+    'EOI_INDUCED':          45,
+    'GDTR_IDTR':            46,
+    'LDTR_TR':              47,
     'EPT_VIOLATION':        48,
     'EPT_MISCONFIG':        49,
+    'INVEPT':               50,
+    'RDTSCP':               51,
+    'PREEMPTION_TIMER':     52,
+    'INVVPID':              53,
     'WBINVD':               54,
     'XSETBV':               55,
     'APIC_WRITE':           56,
+    'RDRAND':               57,
     'INVPCID':              58,
+    'VMFUNC':               59,
+    'ENCLS':                60,
+    'RDSEED':               61,
+    'PML_FULL':             62,
+    'XSAVES':               63,
+    'XRSTORS':              64,
+    'UMWAIT':               67,
+    'TPAUSE':               68,
+    'BUS_LOCK':             74,
+    'NOTIFY':               75,
 }
 
 SVM_EXIT_REASONS = {
     'READ_CR0':       0x000,
+    'READ_CR2':       0x002,
     'READ_CR3':       0x003,
     'READ_CR4':       0x004,
     'READ_CR8':       0x008,
     'WRITE_CR0':      0x010,
+    'WRITE_CR2':      0x012,
     'WRITE_CR3':      0x013,
     'WRITE_CR4':      0x014,
     'WRITE_CR8':      0x018,
@@ -105,6 +130,7 @@ SVM_EXIT_REASONS = {
     'WRITE_DR6':      0x036,
     'WRITE_DR7':      0x037,
     'EXCP_BASE':      0x040,
+    'LAST_EXCP':      0x05f,
     'INTR':           0x060,
     'NMI':            0x061,
     'SMI':            0x062,
@@ -151,21 +177,45 @@ SVM_EXIT_REASONS = {
     'MWAIT':          0x08b,
     'MWAIT_COND':     0x08c,
     'XSETBV':         0x08d,
+    'RDPRU':          0x08e,
+    'EFER_WRITE_TRAP':           0x08f,
+    'CR0_WRITE_TRAP':            0x090,
+    'CR1_WRITE_TRAP':            0x091,
+    'CR2_WRITE_TRAP':            0x092,
+    'CR3_WRITE_TRAP':            0x093,
+    'CR4_WRITE_TRAP':            0x094,
+    'CR5_WRITE_TRAP':            0x095,
+    'CR6_WRITE_TRAP':            0x096,
+    'CR7_WRITE_TRAP':            0x097,
+    'CR8_WRITE_TRAP':            0x098,
+    'CR9_WRITE_TRAP':            0x099,
+    'CR10_WRITE_TRAP':           0x09a,
+    'CR11_WRITE_TRAP':           0x09b,
+    'CR12_WRITE_TRAP':           0x09c,
+    'CR13_WRITE_TRAP':           0x09d,
+    'CR14_WRITE_TRAP':           0x09e,
+    'CR15_WRITE_TRAP':           0x09f,
+    'INVPCID':        0x0a2,
     'NPF':            0x400,
+    'AVIC_INCOMPLETE_IPI':       0x401,
+    'AVIC_UNACCELERATED_ACCESS': 0x402,
+    'VMGEXIT':        0x403,
 }
 
-# EC definition of HSR (from arch/arm64/include/asm/kvm_arm.h)
+# EC definition of HSR (from arch/arm64/include/asm/esr.h)
 AARCH64_EXIT_REASONS = {
     'UNKNOWN':      0x00,
-    'WFI':          0x01,
+    'WFx':          0x01,
     'CP15_32':      0x03,
     'CP15_64':      0x04,
     'CP14_MR':      0x05,
     'CP14_LS':      0x06,
     'FP_ASIMD':     0x07,
     'CP10_ID':      0x08,
+    'PAC':          0x09,
     'CP14_64':      0x0C,
-    'ILL_ISS':      0x0E,
+    'BTI':          0x0D,
+    'ILL':          0x0E,
     'SVC32':        0x11,
     'HVC32':        0x12,
     'SMC32':        0x13,
@@ -173,21 +223,26 @@ AARCH64_EXIT_REASONS = {
     'HVC64':        0x16,
     'SMC64':        0x17,
     'SYS64':        0x18,
-    'IABT':         0x20,
-    'IABT_HYP':     0x21,
+    'SVE':          0x19,
+    'ERET':         0x1A,
+    'FPAC':         0x1C,
+    'SME':          0x1D,
+    'IMP_DEF':      0x1F,
+    'IABT_LOW':     0x20,
+    'IABT_CUR':     0x21,
     'PC_ALIGN':     0x22,
-    'DABT':         0x24,
-    'DABT_HYP':     0x25,
+    'DABT_LOW':     0x24,
+    'DABT_CUR':     0x25,
     'SP_ALIGN':     0x26,
     'FP_EXC32':     0x28,
     'FP_EXC64':     0x2C,
     'SERROR':       0x2F,
-    'BREAKPT':      0x30,
-    'BREAKPT_HYP':  0x31,
-    'SOFTSTP':      0x32,
-    'SOFTSTP_HYP':  0x33,
-    'WATCHPT':      0x34,
-    'WATCHPT_HYP':  0x35,
+    'BREAKPT_LOW':  0x30,
+    'BREAKPT_CUR':  0x31,
+    'SOFTSTP_LOW':  0x32,
+    'SOFTSTP_CUR':  0x33,
+    'WATCHPT_LOW':  0x34,
+    'WATCHPT_CUR':  0x35,
     'BKPT32':       0x38,
     'VECTOR32':     0x3A,
     'BRK64':        0x3C,
@@ -220,6 +275,19 @@ USERSPACE_EXIT_REASONS = {
     'S390_TSCH':        22,
     'EPR':              23,
     'SYSTEM_EVENT':     24,
+    'S390_STSI':        25,
+    'IOAPIC_EOI':       26,
+    'HYPERV':           27,
+    'ARM_NISV':         28,
+    'X86_RDMSR':        29,
+    'X86_WRMSR':        30,
+    'DIRTY_RING_FULL':  31,
+    'AP_RESET_HOLD':    32,
+    'X86_BUS_LOCK':     33,
+    'XEN':              34,
+    'RISCV_SBI':        35,
+    'RISCV_CSR':        36,
+    'NOTIFY':           37,
 }
 
 IOCTL_NUMBERS = {
-- 
2.31.1

