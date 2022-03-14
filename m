Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 386814D8F6B
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 23:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244288AbiCNWUg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 18:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232234AbiCNWUg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 18:20:36 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46EA9FD16
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 15:19:22 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id y19-20020a25ad13000000b006336877f6d0so1591880ybi.9
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 15:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=PUbw9oR4TOWQqbTABcpCBiJL0Yev5THBA5pdKZN8yvA=;
        b=J1hE3hHr1zsdx2TTT9uQ8g+cnB6YxCSxV/wyXzB5ur+pe3dFPt3rEDefpO4XE55lsi
         8gZiynrR3zS+GagnwyB0TvwYdmUul0KHqjqaIgpD5T46pJmV0OASYur87Q7bFLZiNDL9
         2ZmcmF7zGimVqA9byNlp52uJl4VPvf93OGjKWOHQ1dlyii6F67dB9vyYXwt4snrOVhRO
         aRC6Uir5qzkUNS4BGa4DvdECbKXrWaq5ZffLZWKmDXltB+6n9bktUoRYgRJbAnF4rZSO
         coryXU4576gWvx5IoZQz+Vdu7MFNiBcenKyUl7qG3OLRplbEr8GhlIVXm2xJelcBJNVD
         sMPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=PUbw9oR4TOWQqbTABcpCBiJL0Yev5THBA5pdKZN8yvA=;
        b=DufcdepXIIK1hzTTq+xYU7zh7tCrk7Sgl9MfGKQ6ftoPFZ0v2wfWN7zhsC/IMUgU3Q
         nwSSFdrp1w2jmbe3iuHkLpiynXP5mc9NEVidtP24xqKMlNQCKOal/1M2ZXDV7nK0+vBB
         T1d+Et/S56zwo+ouioobwt7so2ySGArUnuqdTAIQhJvU8T9wV3Ku6+z6ej2TEdrB2fQ1
         80FnNjeVNvl3czZggMA7HxaMUC+50/hiyuBnQtWjNkcGgOWctu+w3rgXhRfFyFnzk8OS
         4RzA01iUanXmZl3QMrbFiSz6zriL7xXxEW3CuKuwReewieHbozrXMdBCT6NDb/OKY0pM
         pCuA==
X-Gm-Message-State: AOAM531GMVPViRfobotE0yq/iuAP/wutpEnGD6UeXIUBnuvd5l08lj+2
        n+7+eOxkyBOv2Hnp/OHzBhJRcsJTtFuJqDI4hSI=
X-Google-Smtp-Source: ABdhPJyVdzLvoXd1ovJfPXOpK4i088ln7nkAB8by2vP1a15Mrq9AQrg9C6VUjpBiPOWFoO0KptOWMVCryVCPZwLSxY0=
X-Received: from ndesaulniers1.mtv.corp.google.com ([2620:15c:211:202:eff1:725e:2848:530f])
 (user=ndesaulniers job=sendgmr) by 2002:a5b:7cf:0:b0:623:df1c:b83d with SMTP
 id t15-20020a5b07cf000000b00623df1cb83dmr20604797ybq.75.1647296361448; Mon,
 14 Mar 2022 15:19:21 -0700 (PDT)
Date:   Mon, 14 Mar 2022 15:19:03 -0700
Message-Id: <20220314221909.2027027-1-ndesaulniers@google.com>
Mime-Version: 1.0
X-Developer-Key: i=ndesaulniers@google.com; a=ed25519; pk=lvO/pmg+aaCb6dPhyGC1GyOCvPueDrrc8Zeso5CaGKE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1647296343; l=8543;
 s=20211004; h=from:subject; bh=/onzoCSytyNT3SABwW/OByMJJIxIi8oEiyApyZBwU0U=;
 b=E+R0wTk1bVgZLouAH40yCEBUVKAcS1zwU8U71ZI/iiVQFeBG4+m1x/2/gvtH8niazhrp3Bn/yx2d
 /snHQfSVAOa+pZQIMJOV1CmVLD3K6sFRL3Xkykt9GB5kiposo2GQ
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH] lockdep: fix -Wunused-parameter for _THIS_IP_
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Ingo Molnar <mingo@redhat.com>, Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Joey Gouly <joey.gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While looking into a bug related to the compiler's handling of addresses
of labels, I noticed some uses of _THIS_IP_ seemed unused in lockdep.
Drive by cleanup.

-Wunused-parameter:
kernel/locking/lockdep.c:1383:22: warning: unused parameter 'ip'
kernel/locking/lockdep.c:4246:48: warning: unused parameter 'ip'
kernel/locking/lockdep.c:4844:19: warning: unused parameter 'ip'

Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
 arch/arm64/kernel/entry-common.c |  8 ++++----
 include/linux/irqflags.h         |  4 ++--
 include/linux/kvm_host.h         |  2 +-
 kernel/entry/common.c            |  6 +++---
 kernel/locking/lockdep.c         | 22 ++++++++--------------
 kernel/sched/idle.c              |  2 +-
 kernel/trace/trace_preemptirq.c  |  4 ++--
 7 files changed, 21 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
index ef7fcefb96bd..8a4244316e25 100644
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -73,7 +73,7 @@ static __always_inline void __exit_to_kernel_mode(struct pt_regs *regs)
 	if (interrupts_enabled(regs)) {
 		if (regs->exit_rcu) {
 			trace_hardirqs_on_prepare();
-			lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+			lockdep_hardirqs_on_prepare();
 			rcu_irq_exit();
 			lockdep_hardirqs_on(CALLER_ADDR0);
 			return;
@@ -118,7 +118,7 @@ static __always_inline void enter_from_user_mode(struct pt_regs *regs)
 static __always_inline void __exit_to_user_mode(void)
 {
 	trace_hardirqs_on_prepare();
-	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+	lockdep_hardirqs_on_prepare();
 	user_enter_irqoff();
 	lockdep_hardirqs_on(CALLER_ADDR0);
 }
@@ -176,7 +176,7 @@ static void noinstr arm64_exit_nmi(struct pt_regs *regs)
 	ftrace_nmi_exit();
 	if (restore) {
 		trace_hardirqs_on_prepare();
-		lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+		lockdep_hardirqs_on_prepare();
 	}
 
 	rcu_nmi_exit();
@@ -212,7 +212,7 @@ static void noinstr arm64_exit_el1_dbg(struct pt_regs *regs)
 
 	if (restore) {
 		trace_hardirqs_on_prepare();
-		lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+		lockdep_hardirqs_on_prepare();
 	}
 
 	rcu_nmi_exit();
diff --git a/include/linux/irqflags.h b/include/linux/irqflags.h
index 4b140938b03e..5ec0fa71399e 100644
--- a/include/linux/irqflags.h
+++ b/include/linux/irqflags.h
@@ -20,13 +20,13 @@
 #ifdef CONFIG_PROVE_LOCKING
   extern void lockdep_softirqs_on(unsigned long ip);
   extern void lockdep_softirqs_off(unsigned long ip);
-  extern void lockdep_hardirqs_on_prepare(unsigned long ip);
+  extern void lockdep_hardirqs_on_prepare(void);
   extern void lockdep_hardirqs_on(unsigned long ip);
   extern void lockdep_hardirqs_off(unsigned long ip);
 #else
   static inline void lockdep_softirqs_on(unsigned long ip) { }
   static inline void lockdep_softirqs_off(unsigned long ip) { }
-  static inline void lockdep_hardirqs_on_prepare(unsigned long ip) { }
+  static inline void lockdep_hardirqs_on_prepare(void) { }
   static inline void lockdep_hardirqs_on(unsigned long ip) { }
   static inline void lockdep_hardirqs_off(unsigned long ip) { }
 #endif
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f11039944c08..f32bed70a5c5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -441,7 +441,7 @@ static __always_inline void guest_state_enter_irqoff(void)
 {
 	instrumentation_begin();
 	trace_hardirqs_on_prepare();
-	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+	lockdep_hardirqs_on_prepare();
 	instrumentation_end();
 
 	guest_context_enter_irqoff();
diff --git a/kernel/entry/common.c b/kernel/entry/common.c
index bad713684c2e..3ce3a0a6c762 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -124,7 +124,7 @@ static __always_inline void __exit_to_user_mode(void)
 {
 	instrumentation_begin();
 	trace_hardirqs_on_prepare();
-	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+	lockdep_hardirqs_on_prepare();
 	instrumentation_end();
 
 	user_enter_irqoff();
@@ -412,7 +412,7 @@ noinstr void irqentry_exit(struct pt_regs *regs, irqentry_state_t state)
 			instrumentation_begin();
 			/* Tell the tracer that IRET will enable interrupts */
 			trace_hardirqs_on_prepare();
-			lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+			lockdep_hardirqs_on_prepare();
 			instrumentation_end();
 			rcu_irq_exit();
 			lockdep_hardirqs_on(CALLER_ADDR0);
@@ -465,7 +465,7 @@ void noinstr irqentry_nmi_exit(struct pt_regs *regs, irqentry_state_t irq_state)
 	ftrace_nmi_exit();
 	if (irq_state.lockdep) {
 		trace_hardirqs_on_prepare();
-		lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+		lockdep_hardirqs_on_prepare();
 	}
 	instrumentation_end();
 
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index f8a0212189ca..05604795b39c 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -1378,7 +1378,7 @@ static struct lock_list *alloc_list_entry(void)
  */
 static int add_lock_to_list(struct lock_class *this,
 			    struct lock_class *links_to, struct list_head *head,
-			    unsigned long ip, u16 distance, u8 dep,
+			    u16 distance, u8 dep,
 			    const struct lock_trace *trace)
 {
 	struct lock_list *entry;
@@ -3131,19 +3131,15 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
 	 * to the previous lock's dependency list:
 	 */
 	ret = add_lock_to_list(hlock_class(next), hlock_class(prev),
-			       &hlock_class(prev)->locks_after,
-			       next->acquire_ip, distance,
-			       calc_dep(prev, next),
-			       *trace);
+			       &hlock_class(prev)->locks_after, distance,
+			       calc_dep(prev, next), *trace);
 
 	if (!ret)
 		return 0;
 
 	ret = add_lock_to_list(hlock_class(prev), hlock_class(next),
-			       &hlock_class(next)->locks_before,
-			       next->acquire_ip, distance,
-			       calc_depb(prev, next),
-			       *trace);
+			       &hlock_class(next)->locks_before, distance,
+			       calc_depb(prev, next), *trace);
 	if (!ret)
 		return 0;
 
@@ -4234,14 +4230,13 @@ static void __trace_hardirqs_on_caller(void)
 
 /**
  * lockdep_hardirqs_on_prepare - Prepare for enabling interrupts
- * @ip:		Caller address
  *
  * Invoked before a possible transition to RCU idle from exit to user or
  * guest mode. This ensures that all RCU operations are done before RCU
  * stops watching. After the RCU transition lockdep_hardirqs_on() has to be
  * invoked to set the final state.
  */
-void lockdep_hardirqs_on_prepare(unsigned long ip)
+void lockdep_hardirqs_on_prepare(void)
 {
 	if (unlikely(!debug_locks))
 		return;
@@ -4838,8 +4833,7 @@ EXPORT_SYMBOL_GPL(__lockdep_no_validate__);
 
 static void
 print_lock_nested_lock_not_held(struct task_struct *curr,
-				struct held_lock *hlock,
-				unsigned long ip)
+				struct held_lock *hlock)
 {
 	if (!debug_locks_off())
 		return;
@@ -5015,7 +5009,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	chain_key = iterate_chain_key(chain_key, hlock_id(hlock));
 
 	if (nest_lock && !__lock_is_held(nest_lock, -1)) {
-		print_lock_nested_lock_not_held(curr, hlock, ip);
+		print_lock_nested_lock_not_held(curr, hlock);
 		return 0;
 	}
 
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index d17b0a5ce6ac..499a3e286cd0 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -105,7 +105,7 @@ void __cpuidle default_idle_call(void)
 		 * last -- this is very similar to the entry code.
 		 */
 		trace_hardirqs_on_prepare();
-		lockdep_hardirqs_on_prepare(_THIS_IP_);
+		lockdep_hardirqs_on_prepare();
 		rcu_idle_enter();
 		lockdep_hardirqs_on(_THIS_IP_);
 
diff --git a/kernel/trace/trace_preemptirq.c b/kernel/trace/trace_preemptirq.c
index f4938040c228..95b58bd757ce 100644
--- a/kernel/trace/trace_preemptirq.c
+++ b/kernel/trace/trace_preemptirq.c
@@ -46,7 +46,7 @@ void trace_hardirqs_on(void)
 		this_cpu_write(tracing_irq_cpu, 0);
 	}
 
-	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+	lockdep_hardirqs_on_prepare();
 	lockdep_hardirqs_on(CALLER_ADDR0);
 }
 EXPORT_SYMBOL(trace_hardirqs_on);
@@ -94,7 +94,7 @@ __visible void trace_hardirqs_on_caller(unsigned long caller_addr)
 		this_cpu_write(tracing_irq_cpu, 0);
 	}
 
-	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+	lockdep_hardirqs_on_prepare();
 	lockdep_hardirqs_on(CALLER_ADDR0);
 }
 EXPORT_SYMBOL(trace_hardirqs_on_caller);
-- 
2.35.1.723.g4982287a31-goog

