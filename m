Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDA77200FF
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 13:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235554AbjFBL5R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 07:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234500AbjFBL5P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 07:57:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F46E57;
        Fri,  2 Jun 2023 04:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=TNU/G9TSMeyQi8I5o1Gz1jaa+8f4RLEdgRB4a+ht+Qw=; b=ND0Cui7lGRCITibE4mA3XHf5OL
        o9n8Wi78YIiyjLwgjWx2Siqy5aDe5ovwgAhLmEh1yrZsD/+fKvUlmc0hhtA1qWXdTnqR5OGv8lX0q
        XzwjEbJ5Zbe0gdzoPg6I8ya3Fe51qPKL1tgMzor5Uf16y883dDhXuyyzlBVp7Y+hhpwxBNwqIVHdo
        h5fOsfrBCZrEO8UtvQXSVhchce5sGM3t7NMU/To+fQ1rEujUCw2WPonTcbn6slckHwmrk+IwJt0tB
        VKQZkKj0qjxSBMYPYEwWhBrlAlPWc9q9g6FhS4lwisAlETMV3g3azsF0NmqKFaO5vWaSbcM5esA1n
        4+e3EkWg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1q53Mt-009BAi-Ri; Fri, 02 Jun 2023 11:54:55 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id E62313002F0;
        Fri,  2 Jun 2023 13:54:51 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id CA1C924553E74; Fri,  2 Jun 2023 13:54:51 +0200 (CEST)
Date:   Fri, 2 Jun 2023 13:54:51 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Valentin Schneider <vschneid@redhat.com>
Cc:     bigeasy@linutronix.de, mark.rutland@arm.com, maz@kernel.org,
        catalin.marinas@arm.com, will@kernel.org, chenhuacai@kernel.org,
        kernel@xen0n.name, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, pbonzini@redhat.com, wanpengli@tencent.com,
        vkuznets@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, jgross@suse.com, boris.ostrovsky@oracle.com,
        daniel.lezcano@linaro.org, kys@microsoft.com,
        haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        rafael@kernel.org, longman@redhat.com, boqun.feng@gmail.com,
        pmladek@suse.com, senozhatsky@chromium.org, rostedt@goodmis.org,
        john.ogness@linutronix.de, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        bsegall@google.com, mgorman@suse.de, bristot@redhat.com,
        jstultz@google.com, sboyd@kernel.org, linux-kernel@vger.kernel.org,
        loongarch@lists.linux.dev, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 04/13] arm64/arch_timer: Provide noinstr
 sched_clock_read() functions
Message-ID: <20230602115451.GG620383@hirez.programming.kicks-ass.net>
References: <20230519102058.581557770@infradead.org>
 <20230519102715.435618812@infradead.org>
 <xhsmho7m9ptrk.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xhsmho7m9ptrk.mognet@vschneid.remote.csb>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 24, 2023 at 05:40:47PM +0100, Valentin Schneider wrote:
> On 19/05/23 12:21, Peter Zijlstra wrote:
> > With the intent to provide local_clock_noinstr(), a variant of
> > local_clock() that's safe to be called from noinstr code (with the
> > assumption that any such code will already be non-preemptible),
> > prepare for things by providing a noinstr sched_clock_read() function.
> >
> > Specifically, preempt_enable_*() calls out to schedule(), which upsets
> > noinstr validation efforts.
> >
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > ---
> >  arch/arm64/include/asm/arch_timer.h  |    8 ----
> >  drivers/clocksource/arm_arch_timer.c |   60 ++++++++++++++++++++++++++---------
> >  2 files changed, 47 insertions(+), 21 deletions(-)
> >
> > --- a/arch/arm64/include/asm/arch_timer.h
> > +++ b/arch/arm64/include/asm/arch_timer.h
> > @@ -88,13 +88,7 @@ static inline notrace u64 arch_timer_rea
> >
> >  #define arch_timer_reg_read_stable(reg)					\
> >       ({								\
> > -		u64 _val;						\
> > -									\
> > -		preempt_disable_notrace();				\
> > -		_val = erratum_handler(read_ ## reg)();			\
> > -		preempt_enable_notrace();				\
> > -									\
> > -		_val;							\
> > +		erratum_handler(read_ ## reg)();			\
> >       })
> >
> >  /*
> > --- a/drivers/clocksource/arm_arch_timer.c
> > +++ b/drivers/clocksource/arm_arch_timer.c
> > @@ -191,22 +191,40 @@ u32 arch_timer_reg_read(int access, enum
> >       return val;
> >  }
> >
> > -static notrace u64 arch_counter_get_cntpct_stable(void)
> > +static noinstr u64 _arch_counter_get_cntpct_stable(void)
> >  {
> >       return __arch_counter_get_cntpct_stable();
> >  }
> >
> 
> I tripped over the underscores when reviewing this :( This must be
> getting close to the symbol length limit, but could we give this a helpful
> prefix or suffix? raw_* or *_noinstr?
> 
> > @@ -1074,6 +1092,13 @@ struct arch_timer_kvm_info *arch_timer_g
> >
> >  static void __init arch_counter_register(unsigned type)
> >  {
> > +	/*
> > +	 * Default to cp15 based access because arm64 uses this function for
> > +	 * sched_clock() before DT is probed and the cp15 method is guaranteed
> > +	 * to exist on arm64. arm doesn't use this before DT is probed so even
> > +	 * if we don't have the cp15 accessors we won't have a problem.
> > +	 */
> > +	u64 (*scr)(void) = arch_counter_get_cntvct;
> 
> So this bit sent me on a little spelunking session :-)
> 
> From a control flow perspective the initialization isn't required, but then
> I looked into the comment and found it comes from the
> arch_timer_read_counter() definition... Which itself doesn't get used by
> sched_clock() until the sched_clock_register() below!
> 
> So AFAICT that comment was true as of
> 
>   220069945b29 ("clocksource: arch_timer: Add support for memory mapped timers")
> 
> but not after a commit that came 2 months later:
> 
>   65cd4f6c99c1 ("arch_timer: Move to generic sched_clock framework")
> 
> which IIUC made arm/arm64 follow the default approach of using the
> jiffy-based sched_clock() before probing DT/ACPI and registering a "proper"
> sched_clock.
> 
> All of that to say: the comment about arch_timer_read_counter() vs early
> sched_clock() doesn't apply anymore, but I think we need to keep its
> initalization around for stuff like get_cycles(). This initialization here
> should be OK to put to the bin, though.

Something like the below folded in then?

---
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -191,7 +191,7 @@ u32 arch_timer_reg_read(int access, enum
 	return val;
 }
 
-static noinstr u64 _arch_counter_get_cntpct_stable(void)
+static noinstr u64 raw_counter_get_cntpct_stable(void)
 {
 	return __arch_counter_get_cntpct_stable();
 }
@@ -210,7 +210,7 @@ static noinstr u64 arch_counter_get_cntp
 	return __arch_counter_get_cntpct();
 }
 
-static noinstr u64 _arch_counter_get_cntvct_stable(void)
+static noinstr u64 raw_counter_get_cntvct_stable(void)
 {
 	return __arch_counter_get_cntvct_stable();
 }
@@ -1092,13 +1092,7 @@ struct arch_timer_kvm_info *arch_timer_g
 
 static void __init arch_counter_register(unsigned type)
 {
-	/*
-	 * Default to cp15 based access because arm64 uses this function for
-	 * sched_clock() before DT is probed and the cp15 method is guaranteed
-	 * to exist on arm64. arm doesn't use this before DT is probed so even
-	 * if we don't have the cp15 accessors we won't have a problem.
-	 */
-	u64 (*scr)(void) = arch_counter_get_cntvct;
+	u64 (*scr)(void);
 	u64 start_count;
 	int width;
 
@@ -1110,7 +1104,7 @@ static void __init arch_counter_register
 		    arch_timer_uses_ppi == ARCH_TIMER_VIRT_PPI) {
 			if (arch_timer_counter_has_wa()) {
 				rd = arch_counter_get_cntvct_stable;
-				scr = _arch_counter_get_cntvct_stable;
+				scr = raw_counter_get_cntvct_stable;
 			} else {
 				rd = arch_counter_get_cntvct;
 				scr = arch_counter_get_cntvct;
@@ -1118,7 +1112,7 @@ static void __init arch_counter_register
 		} else {
 			if (arch_timer_counter_has_wa()) {
 				rd = arch_counter_get_cntpct_stable;
-				scr = _arch_counter_get_cntpct_stable;
+				scr = raw_counter_get_cntpct_stable;
 			} else {
 				rd = arch_counter_get_cntpct;
 				scr = arch_counter_get_cntpct;
