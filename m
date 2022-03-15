Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 809534D9E4A
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 16:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349529AbiCOPB0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 11:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349544AbiCOPBY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 11:01:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6D47155BD7
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 08:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647356410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=khFAaXb87QUv7Avz4IPJcQUVJx3txq8L5uNH3RG0cQ8=;
        b=bhveUt2TQ5iiqwjwbLIR0v4InhwA84isramNTs4r16UmQ4ee5o5GwcS9QYPgv8QmDGSRFG
        dvFbsdJhwDuqGCaNyeW6ZcjzaWsWAyeh8lddZm4xfY3YFYVspCLFeeauAS2DfMVmshjomc
        4T+IkZDED3pcBiC2sOURp1Cnf6cWrmk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-y0UEwhkwNk2oVvrJ_is5Vw-1; Tue, 15 Mar 2022 11:00:07 -0400
X-MC-Unique: y0UEwhkwNk2oVvrJ_is5Vw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4FE39805F46;
        Tue, 15 Mar 2022 15:00:06 +0000 (UTC)
Received: from [10.22.34.226] (unknown [10.22.34.226])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2553A555C92;
        Tue, 15 Mar 2022 15:00:05 +0000 (UTC)
Message-ID: <2a77efcb-8dbb-732d-bc5d-d4cfe4c32184@redhat.com>
Date:   Tue, 15 Mar 2022 11:00:04 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] lockdep: fix -Wunused-parameter for _THIS_IP_
Content-Language: en-US
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
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
References: <20220314221909.2027027-1-ndesaulniers@google.com>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <20220314221909.2027027-1-ndesaulniers@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/14/22 18:19, Nick Desaulniers wrote:
> While looking into a bug related to the compiler's handling of addresses
> of labels, I noticed some uses of _THIS_IP_ seemed unused in lockdep.
> Drive by cleanup.
>
> -Wunused-parameter:
> kernel/locking/lockdep.c:1383:22: warning: unused parameter 'ip'
> kernel/locking/lockdep.c:4246:48: warning: unused parameter 'ip'
> kernel/locking/lockdep.c:4844:19: warning: unused parameter 'ip'
>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
>   arch/arm64/kernel/entry-common.c |  8 ++++----
>   include/linux/irqflags.h         |  4 ++--
>   include/linux/kvm_host.h         |  2 +-
>   kernel/entry/common.c            |  6 +++---
>   kernel/locking/lockdep.c         | 22 ++++++++--------------
>   kernel/sched/idle.c              |  2 +-
>   kernel/trace/trace_preemptirq.c  |  4 ++--
>   7 files changed, 21 insertions(+), 27 deletions(-)
>
> diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
> index ef7fcefb96bd..8a4244316e25 100644
> --- a/arch/arm64/kernel/entry-common.c
> +++ b/arch/arm64/kernel/entry-common.c
> @@ -73,7 +73,7 @@ static __always_inline void __exit_to_kernel_mode(struct pt_regs *regs)
>   	if (interrupts_enabled(regs)) {
>   		if (regs->exit_rcu) {
>   			trace_hardirqs_on_prepare();
> -			lockdep_hardirqs_on_prepare(CALLER_ADDR0);
> +			lockdep_hardirqs_on_prepare();
>   			rcu_irq_exit();
>   			lockdep_hardirqs_on(CALLER_ADDR0);
>   			return;
> @@ -118,7 +118,7 @@ static __always_inline void enter_from_user_mode(struct pt_regs *regs)
>   static __always_inline void __exit_to_user_mode(void)
>   {
>   	trace_hardirqs_on_prepare();
> -	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
> +	lockdep_hardirqs_on_prepare();
>   	user_enter_irqoff();
>   	lockdep_hardirqs_on(CALLER_ADDR0);
>   }
> @@ -176,7 +176,7 @@ static void noinstr arm64_exit_nmi(struct pt_regs *regs)
>   	ftrace_nmi_exit();
>   	if (restore) {
>   		trace_hardirqs_on_prepare();
> -		lockdep_hardirqs_on_prepare(CALLER_ADDR0);
> +		lockdep_hardirqs_on_prepare();
>   	}
>   
>   	rcu_nmi_exit();
> @@ -212,7 +212,7 @@ static void noinstr arm64_exit_el1_dbg(struct pt_regs *regs)
>   
>   	if (restore) {
>   		trace_hardirqs_on_prepare();
> -		lockdep_hardirqs_on_prepare(CALLER_ADDR0);
> +		lockdep_hardirqs_on_prepare();
>   	}
>   
>   	rcu_nmi_exit();
> diff --git a/include/linux/irqflags.h b/include/linux/irqflags.h
> index 4b140938b03e..5ec0fa71399e 100644
> --- a/include/linux/irqflags.h
> +++ b/include/linux/irqflags.h
> @@ -20,13 +20,13 @@
>   #ifdef CONFIG_PROVE_LOCKING
>     extern void lockdep_softirqs_on(unsigned long ip);
>     extern void lockdep_softirqs_off(unsigned long ip);
> -  extern void lockdep_hardirqs_on_prepare(unsigned long ip);
> +  extern void lockdep_hardirqs_on_prepare(void);
>     extern void lockdep_hardirqs_on(unsigned long ip);
>     extern void lockdep_hardirqs_off(unsigned long ip);
>   #else
>     static inline void lockdep_softirqs_on(unsigned long ip) { }
>     static inline void lockdep_softirqs_off(unsigned long ip) { }
> -  static inline void lockdep_hardirqs_on_prepare(unsigned long ip) { }
> +  static inline void lockdep_hardirqs_on_prepare(void) { }
>     static inline void lockdep_hardirqs_on(unsigned long ip) { }
>     static inline void lockdep_hardirqs_off(unsigned long ip) { }
>   #endif
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f11039944c08..f32bed70a5c5 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -441,7 +441,7 @@ static __always_inline void guest_state_enter_irqoff(void)
>   {
>   	instrumentation_begin();
>   	trace_hardirqs_on_prepare();
> -	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
> +	lockdep_hardirqs_on_prepare();
>   	instrumentation_end();
>   
>   	guest_context_enter_irqoff();
> diff --git a/kernel/entry/common.c b/kernel/entry/common.c
> index bad713684c2e..3ce3a0a6c762 100644
> --- a/kernel/entry/common.c
> +++ b/kernel/entry/common.c
> @@ -124,7 +124,7 @@ static __always_inline void __exit_to_user_mode(void)
>   {
>   	instrumentation_begin();
>   	trace_hardirqs_on_prepare();
> -	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
> +	lockdep_hardirqs_on_prepare();
>   	instrumentation_end();
>   
>   	user_enter_irqoff();
> @@ -412,7 +412,7 @@ noinstr void irqentry_exit(struct pt_regs *regs, irqentry_state_t state)
>   			instrumentation_begin();
>   			/* Tell the tracer that IRET will enable interrupts */
>   			trace_hardirqs_on_prepare();
> -			lockdep_hardirqs_on_prepare(CALLER_ADDR0);
> +			lockdep_hardirqs_on_prepare();
>   			instrumentation_end();
>   			rcu_irq_exit();
>   			lockdep_hardirqs_on(CALLER_ADDR0);
> @@ -465,7 +465,7 @@ void noinstr irqentry_nmi_exit(struct pt_regs *regs, irqentry_state_t irq_state)
>   	ftrace_nmi_exit();
>   	if (irq_state.lockdep) {
>   		trace_hardirqs_on_prepare();
> -		lockdep_hardirqs_on_prepare(CALLER_ADDR0);
> +		lockdep_hardirqs_on_prepare();
>   	}
>   	instrumentation_end();
>   
> diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
> index f8a0212189ca..05604795b39c 100644
> --- a/kernel/locking/lockdep.c
> +++ b/kernel/locking/lockdep.c
> @@ -1378,7 +1378,7 @@ static struct lock_list *alloc_list_entry(void)
>    */
>   static int add_lock_to_list(struct lock_class *this,
>   			    struct lock_class *links_to, struct list_head *head,
> -			    unsigned long ip, u16 distance, u8 dep,
> +			    u16 distance, u8 dep,
>   			    const struct lock_trace *trace)
>   {
>   	struct lock_list *entry;
> @@ -3131,19 +3131,15 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
>   	 * to the previous lock's dependency list:
>   	 */
>   	ret = add_lock_to_list(hlock_class(next), hlock_class(prev),
> -			       &hlock_class(prev)->locks_after,
> -			       next->acquire_ip, distance,
> -			       calc_dep(prev, next),
> -			       *trace);
> +			       &hlock_class(prev)->locks_after, distance,
> +			       calc_dep(prev, next), *trace);
>   
>   	if (!ret)
>   		return 0;
>   
>   	ret = add_lock_to_list(hlock_class(prev), hlock_class(next),
> -			       &hlock_class(next)->locks_before,
> -			       next->acquire_ip, distance,
> -			       calc_depb(prev, next),
> -			       *trace);
> +			       &hlock_class(next)->locks_before, distance,
> +			       calc_depb(prev, next), *trace);
>   	if (!ret)
>   		return 0;
>   
> @@ -4234,14 +4230,13 @@ static void __trace_hardirqs_on_caller(void)
>   
>   /**
>    * lockdep_hardirqs_on_prepare - Prepare for enabling interrupts
> - * @ip:		Caller address
>    *
>    * Invoked before a possible transition to RCU idle from exit to user or
>    * guest mode. This ensures that all RCU operations are done before RCU
>    * stops watching. After the RCU transition lockdep_hardirqs_on() has to be
>    * invoked to set the final state.
>    */
> -void lockdep_hardirqs_on_prepare(unsigned long ip)
> +void lockdep_hardirqs_on_prepare(void)
>   {
>   	if (unlikely(!debug_locks))
>   		return;
> @@ -4838,8 +4833,7 @@ EXPORT_SYMBOL_GPL(__lockdep_no_validate__);
>   
>   static void
>   print_lock_nested_lock_not_held(struct task_struct *curr,
> -				struct held_lock *hlock,
> -				unsigned long ip)
> +				struct held_lock *hlock)
>   {
>   	if (!debug_locks_off())
>   		return;
> @@ -5015,7 +5009,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
>   	chain_key = iterate_chain_key(chain_key, hlock_id(hlock));
>   
>   	if (nest_lock && !__lock_is_held(nest_lock, -1)) {
> -		print_lock_nested_lock_not_held(curr, hlock, ip);
> +		print_lock_nested_lock_not_held(curr, hlock);
>   		return 0;
>   	}
>   
> diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
> index d17b0a5ce6ac..499a3e286cd0 100644
> --- a/kernel/sched/idle.c
> +++ b/kernel/sched/idle.c
> @@ -105,7 +105,7 @@ void __cpuidle default_idle_call(void)
>   		 * last -- this is very similar to the entry code.
>   		 */
>   		trace_hardirqs_on_prepare();
> -		lockdep_hardirqs_on_prepare(_THIS_IP_);
> +		lockdep_hardirqs_on_prepare();
>   		rcu_idle_enter();
>   		lockdep_hardirqs_on(_THIS_IP_);
>   
> diff --git a/kernel/trace/trace_preemptirq.c b/kernel/trace/trace_preemptirq.c
> index f4938040c228..95b58bd757ce 100644
> --- a/kernel/trace/trace_preemptirq.c
> +++ b/kernel/trace/trace_preemptirq.c
> @@ -46,7 +46,7 @@ void trace_hardirqs_on(void)
>   		this_cpu_write(tracing_irq_cpu, 0);
>   	}
>   
> -	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
> +	lockdep_hardirqs_on_prepare();
>   	lockdep_hardirqs_on(CALLER_ADDR0);
>   }
>   EXPORT_SYMBOL(trace_hardirqs_on);
> @@ -94,7 +94,7 @@ __visible void trace_hardirqs_on_caller(unsigned long caller_addr)
>   		this_cpu_write(tracing_irq_cpu, 0);
>   	}
>   
> -	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
> +	lockdep_hardirqs_on_prepare();
>   	lockdep_hardirqs_on(CALLER_ADDR0);
>   }
>   EXPORT_SYMBOL(trace_hardirqs_on_caller);

LGTM

Acked-by: Waiman Long <longman@redhat.com>

