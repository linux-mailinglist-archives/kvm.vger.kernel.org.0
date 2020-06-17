Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF741FD69F
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 23:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgFQVDs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 17:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgFQVDr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 17:03:47 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11849C06174E
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 14:03:46 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id b4so3456377qkn.11
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 14:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rba7pljRMVc6wa2lS86kVUPY7O/d9hkT9SFA7+vY6nY=;
        b=R5z5IR5FLnMnMqf2RggbF8wnsY2icPxT3w46kmMuEmy69k/4Mr4UNe+RuR+WiEPvG3
         9c8CJRRyY7m6nltryWkmWziQvRZfYasj4SE4VArK46KiVyJ+gazqevXOxXuZqTuDay8U
         9X86q5vyz5COzSuzfdMrSntdJ3rZjYQt7Eq5Lt1dQttkcMCrcVV8Vo1J9H6x1Btp9rjo
         6Sr1nzX1mKh5hhoW25c15laX42Nri5JALP/VjoR4EXVD56IZn2Zv6dyI+FR9L/LqrxXz
         fbXETyMyprillHLMW8zUjP4+c2fyHOBDmvmInXSFqQ+yIOGH5Gtlr4YE5cLe6r/hZBmA
         uerw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rba7pljRMVc6wa2lS86kVUPY7O/d9hkT9SFA7+vY6nY=;
        b=ZcgoxfBSGK6CLSKG1iowRRDLLhX+bFbnKDzfHDnif1lHpjZKX6P+VqK6cp7VJHj3u5
         1iUfDCNr6w8uvFjNYiwYxyUqxz27hXMuScl0+glbder56WJspW/LajJPzy6UiutEkruu
         mzyZm4v49rJqBFudbr864+7IWY7UcgswWN+aOkhohZ3KbK8HfRkcLRC17z9NZmvbxw0w
         XUADZrGO9vPlOzCk9g8mnllKuLlzFJnUrIwqDZlrk9qT8EtXYTf7Qb21JBy5lxzQ2wY4
         zhZttN4Xjwdwfg3OqRHUO037RcKtG8rXkm4eamEwY29RMuLl8XjTNZHrz3kZePYYO0PC
         czyQ==
X-Gm-Message-State: AOAM533xFOp+gKwprksxSoLeRx5Y8028h1tWeqri3+RFpj3MLYyT0mTN
        b+wQ/Z2aBT8OjHyB0EI8QbMFKA==
X-Google-Smtp-Source: ABdhPJzZuLORD87VxHFuUa7rIS/eYuoX8SDFPbCz5s962zeXaI0xoYOVy9OxMVd8SVfCrJEKucANOw==
X-Received: by 2002:a37:9684:: with SMTP id y126mr589113qkd.348.1592427825231;
        Wed, 17 Jun 2020 14:03:45 -0700 (PDT)
Received: from Rfoley-MA01.hsd1.ma.comcast.net ([2601:199:4480:60c0:fc79:714c:9711:2e9c])
        by smtp.gmail.com with ESMTPSA id w13sm997245qkb.91.2020.06.17.14.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 14:03:44 -0700 (PDT)
From:   Robert Foley <robert.foley@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     alex.bennee@linaro.org, cota@braap.org, peter.puhov@linaro.org,
        robert.foley@linaro.org, Eduardo Habkost <ehabkost@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Wenchao Wang <wenchao.wang@intel.com>,
        Colin Xu <colin.xu@intel.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        haxm-team@intel.com (open list:X86 HAXM CPUs),
        kvm@vger.kernel.org (open list:X86 KVM CPUs)
Subject: [PATCH v10 20/73] i386: convert to cpu_halted
Date:   Wed, 17 Jun 2020 17:01:38 -0400
Message-Id: <20200617210231.4393-21-robert.foley@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200617210231.4393-1-robert.foley@linaro.org>
References: <20200617210231.4393-1-robert.foley@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Emilio G. Cota" <cota@braap.org>

Cc: Eduardo Habkost <ehabkost@redhat.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Signed-off-by: Emilio G. Cota <cota@braap.org>
[RF: Converted new code in i386/hax-all.c to cpu_halted]
Signed-off-by: Robert Foley <robert.foley@linaro.org>
---
 target/i386/cpu.c         |  2 +-
 target/i386/cpu.h         |  2 +-
 target/i386/hax-all.c     |  6 +++---
 target/i386/helper.c      |  4 ++--
 target/i386/hvf/hvf.c     |  4 ++--
 target/i386/hvf/x86hvf.c  |  4 ++--
 target/i386/kvm.c         | 10 +++++-----
 target/i386/misc_helper.c |  2 +-
 target/i386/whpx-all.c    |  6 +++---
 9 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index b1b311baa2..4d3ab0f3a2 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6084,7 +6084,7 @@ static void x86_cpu_reset(DeviceState *dev)
     /* We hard-wire the BSP to the first CPU. */
     apic_designate_bsp(cpu->apic_state, s->cpu_index == 0);
 
-    s->halted = !cpu_is_bsp(cpu);
+    cpu_halted_set(s, !cpu_is_bsp(cpu));
 
     if (kvm_enabled()) {
         kvm_arch_reset_vcpu(cpu);
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 7d77efd9e4..c618b90568 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1880,7 +1880,7 @@ static inline void cpu_x86_load_seg_cache_sipi(X86CPU *cpu,
                            sipi_vector << 12,
                            env->segs[R_CS].limit,
                            env->segs[R_CS].flags);
-    cs->halted = 0;
+    cpu_halted_set(cs, 0);
 }
 
 int cpu_x86_get_descr_debug(CPUX86State *env, unsigned int selector,
diff --git a/target/i386/hax-all.c b/target/i386/hax-all.c
index c93bb23a44..acfb7a6e10 100644
--- a/target/i386/hax-all.c
+++ b/target/i386/hax-all.c
@@ -511,7 +511,7 @@ static int hax_vcpu_hax_exec(CPUArchState *env)
     if (((cpu->interrupt_request & CPU_INTERRUPT_HARD) &&
          (env->eflags & IF_MASK)) ||
         (cpu->interrupt_request & CPU_INTERRUPT_NMI)) {
-        cpu->halted = 0;
+        cpu_halted_set(cpu, 0);
     }
 
     if (cpu->interrupt_request & CPU_INTERRUPT_INIT) {
@@ -529,7 +529,7 @@ static int hax_vcpu_hax_exec(CPUArchState *env)
         hax_vcpu_sync_state(env, 1);
     }
 
-    if (cpu->halted) {
+    if (cpu_halted(cpu)) {
         /* If this vcpu is halted, we must not ask HAXM to run it. Instead, we
          * break out of hax_smp_cpu_exec() as if this vcpu had executed HLT.
          * That way, this vcpu thread will be trapped in qemu_wait_io_event(),
@@ -594,7 +594,7 @@ static int hax_vcpu_hax_exec(CPUArchState *env)
                 !(cpu->interrupt_request & CPU_INTERRUPT_NMI)) {
                 /* hlt instruction with interrupt disabled is shutdown */
                 env->eflags |= IF_MASK;
-                cpu->halted = 1;
+                cpu_halted_set(cpu, 1);
                 cpu->exception_index = EXCP_HLT;
                 ret = 1;
             }
diff --git a/target/i386/helper.c b/target/i386/helper.c
index c3a6e4fabe..058de4073d 100644
--- a/target/i386/helper.c
+++ b/target/i386/helper.c
@@ -450,7 +450,7 @@ void x86_cpu_dump_state(CPUState *cs, FILE *f, int flags)
                      (env->hflags >> HF_INHIBIT_IRQ_SHIFT) & 1,
                      (env->a20_mask >> 20) & 1,
                      (env->hflags >> HF_SMM_SHIFT) & 1,
-                     cs->halted);
+                    cpu_halted(cs));
     } else
 #endif
     {
@@ -477,7 +477,7 @@ void x86_cpu_dump_state(CPUState *cs, FILE *f, int flags)
                      (env->hflags >> HF_INHIBIT_IRQ_SHIFT) & 1,
                      (env->a20_mask >> 20) & 1,
                      (env->hflags >> HF_SMM_SHIFT) & 1,
-                     cs->halted);
+                    cpu_halted(cs));
     }
 
     for(i = 0; i < 6; i++) {
diff --git a/target/i386/hvf/hvf.c b/target/i386/hvf/hvf.c
index be016b951a..b3bd2285fa 100644
--- a/target/i386/hvf/hvf.c
+++ b/target/i386/hvf/hvf.c
@@ -709,7 +709,7 @@ int hvf_vcpu_exec(CPUState *cpu)
         vmx_update_tpr(cpu);
 
         qemu_mutex_unlock_iothread();
-        if (!cpu_is_bsp(X86_CPU(cpu)) && cpu->halted) {
+        if (!cpu_is_bsp(X86_CPU(cpu)) && cpu_halted(cpu)) {
             qemu_mutex_lock_iothread();
             return EXCP_HLT;
         }
@@ -742,7 +742,7 @@ int hvf_vcpu_exec(CPUState *cpu)
                 (env->eflags & IF_MASK))
                 && !(cpu->interrupt_request & CPU_INTERRUPT_NMI) &&
                 !(idtvec_info & VMCS_IDT_VEC_VALID)) {
-                cpu->halted = 1;
+                cpu_halted_set(cpu, 1);
                 ret = EXCP_HLT;
                 break;
             }
diff --git a/target/i386/hvf/x86hvf.c b/target/i386/hvf/x86hvf.c
index 5cbcb32ab6..c09cf160ef 100644
--- a/target/i386/hvf/x86hvf.c
+++ b/target/i386/hvf/x86hvf.c
@@ -446,7 +446,7 @@ int hvf_process_events(CPUState *cpu_state)
     if (((cpu_state->interrupt_request & CPU_INTERRUPT_HARD) &&
         (env->eflags & IF_MASK)) ||
         (cpu_state->interrupt_request & CPU_INTERRUPT_NMI)) {
-        cpu_state->halted = 0;
+        cpu_halted_set(cpu_state, 0);
     }
     if (cpu_state->interrupt_request & CPU_INTERRUPT_SIPI) {
         hvf_cpu_synchronize_state(cpu_state);
@@ -458,5 +458,5 @@ int hvf_process_events(CPUState *cpu_state)
         apic_handle_tpr_access_report(cpu->apic_state, env->eip,
                                       env->tpr_access_type);
     }
-    return cpu_state->halted;
+    return cpu_halted(cpu_state);
 }
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index b3c13cb898..eda51904dd 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -3594,7 +3594,7 @@ static int kvm_get_mp_state(X86CPU *cpu)
     }
     env->mp_state = mp_state.mp_state;
     if (kvm_irqchip_in_kernel()) {
-        cs->halted = (mp_state.mp_state == KVM_MP_STATE_HALTED);
+        cpu_halted_set(cs, mp_state.mp_state == KVM_MP_STATE_HALTED);
     }
     return 0;
 }
@@ -4152,7 +4152,7 @@ int kvm_arch_process_async_events(CPUState *cs)
         kvm_queue_exception(env, EXCP12_MCHK, 0, 0);
         env->has_error_code = 0;
 
-        cs->halted = 0;
+        cpu_halted_set(cs, 0);
         if (kvm_irqchip_in_kernel() && env->mp_state == KVM_MP_STATE_HALTED) {
             env->mp_state = KVM_MP_STATE_RUNNABLE;
         }
@@ -4175,7 +4175,7 @@ int kvm_arch_process_async_events(CPUState *cs)
     if (((cs->interrupt_request & CPU_INTERRUPT_HARD) &&
          (env->eflags & IF_MASK)) ||
         (cs->interrupt_request & CPU_INTERRUPT_NMI)) {
-        cs->halted = 0;
+        cpu_halted_set(cs, 0);
     }
     if (cs->interrupt_request & CPU_INTERRUPT_SIPI) {
         kvm_cpu_synchronize_state(cs);
@@ -4188,7 +4188,7 @@ int kvm_arch_process_async_events(CPUState *cs)
                                       env->tpr_access_type);
     }
 
-    return cs->halted;
+    return cpu_halted(cs);
 }
 
 static int kvm_handle_halt(X86CPU *cpu)
@@ -4199,7 +4199,7 @@ static int kvm_handle_halt(X86CPU *cpu)
     if (!((cs->interrupt_request & CPU_INTERRUPT_HARD) &&
           (env->eflags & IF_MASK)) &&
         !(cs->interrupt_request & CPU_INTERRUPT_NMI)) {
-        cs->halted = 1;
+        cpu_halted_set(cs, 1);
         return EXCP_HLT;
     }
 
diff --git a/target/i386/misc_helper.c b/target/i386/misc_helper.c
index b6b1d41b14..c396b6c7b9 100644
--- a/target/i386/misc_helper.c
+++ b/target/i386/misc_helper.c
@@ -558,7 +558,7 @@ static void do_hlt(X86CPU *cpu)
     CPUX86State *env = &cpu->env;
 
     env->hflags &= ~HF_INHIBIT_IRQ_MASK; /* needed if sti is just before */
-    cs->halted = 1;
+    cpu_halted_set(cs, 1);
     cs->exception_index = EXCP_HLT;
     cpu_loop_exit(cs);
 }
diff --git a/target/i386/whpx-all.c b/target/i386/whpx-all.c
index c78baac6df..efc2d88810 100644
--- a/target/i386/whpx-all.c
+++ b/target/i386/whpx-all.c
@@ -759,7 +759,7 @@ static int whpx_handle_halt(CPUState *cpu)
           (env->eflags & IF_MASK)) &&
         !(cpu->interrupt_request & CPU_INTERRUPT_NMI)) {
         cpu->exception_index = EXCP_HLT;
-        cpu->halted = true;
+        cpu_halted_set(cpu, true);
         ret = 1;
     }
     qemu_mutex_unlock_iothread();
@@ -918,7 +918,7 @@ static void whpx_vcpu_process_async_events(CPUState *cpu)
     if (((cpu->interrupt_request & CPU_INTERRUPT_HARD) &&
          (env->eflags & IF_MASK)) ||
         (cpu->interrupt_request & CPU_INTERRUPT_NMI)) {
-        cpu->halted = false;
+        cpu_halted_set(cpu, false);
     }
 
     if (cpu->interrupt_request & CPU_INTERRUPT_SIPI) {
@@ -944,7 +944,7 @@ static int whpx_vcpu_run(CPUState *cpu)
     int ret;
 
     whpx_vcpu_process_async_events(cpu);
-    if (cpu->halted) {
+    if (cpu_halted(cpu)) {
         cpu->exception_index = EXCP_HLT;
         atomic_set(&cpu->exit_request, false);
         return 0;
-- 
2.17.1

