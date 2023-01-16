Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9DD666D1CE
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 23:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233546AbjAPWf7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 17:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbjAPWf4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 17:35:56 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F4A222E5;
        Mon, 16 Jan 2023 14:35:54 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id x5so2208239qti.3;
        Mon, 16 Jan 2023 14:35:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WpALo6yYkl3lNut55yl7mbAkmluyUA+Fh6lVM7D5hFw=;
        b=Vg80NC8KuDcPxzAZ95A6ngBnA0gb9XTUeqXc4pS8+itbQRMetIIAe4ra4aC9LkPknq
         Nyr+jRD/hEEPHsEWqadCbhHJcO3TnDUjK7+f9qhjw7qQ4PbGev0/cw9Ft5Moa+y6ymKm
         RpkmQWXakg3OCgTotu8oX0X1BBPH8MRIqqC9/4BLfAeB+zl3AAuQZi9G1B2rHHbDUxOV
         dJR53A2Sg/TexO+VRBqI/hM6fy5yAs/DI3XAQzQtKDCEvrNQTmMmOjYz6HooQ+pAR4SS
         ekMwzqqNSLGDybsfKUgJsX/Dr+YyMnzfI/NtKSOcLiuKpVymnXVYKDQWBIfmFPxt1zGL
         jxnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WpALo6yYkl3lNut55yl7mbAkmluyUA+Fh6lVM7D5hFw=;
        b=nGoQrTUaveU2AmqEo/op+yV/ZV5KgfvrjKtkDSh4yUq9gwajkb24PqdtwEiEDHU5GX
         4F5wxiGfcxBaxDxWVyI7VSBs9qJuaUIGS/o/ij7Pv1A+ovD2jFwQoVQs6LcbNB6Wwl1E
         N7MShrU3KditAM83oO7UGHQSiYFE4rP7MAFBhgEIhKreMG+UlajexkrRSn+mQGz7lAg9
         rx0UArVDeestQreuYxaXZiutr9Fwq2PTVcwXuNTotUDz50sWeABf9ZohBZFRxI2Ng04K
         3sLT7PxMHh0rXdp65M6YNLvDobW+iQQzS944CXO3WzMqpJnO8fk6PCnNO/6KUCl8m5Ki
         UVZg==
X-Gm-Message-State: AFqh2krJZ1RBUm04mZTJ36Izv8KF0uM3bFIXm/DEe0UsIJGIa+7ImYTY
        LhtYvcF5y7NlU8e261kkx+M=
X-Google-Smtp-Source: AMrXdXsPBhuxoF1FOtd+AgnhUfVPQSMHBWTiZ6T+QeKBs+shfw9LTRlRfa4lxMrKAxS9DNw7GOoYSA==
X-Received: by 2002:ac8:4f58:0:b0:3b3:9d40:b407 with SMTP id i24-20020ac84f58000000b003b39d40b407mr19071825qtw.62.1673908553390;
        Mon, 16 Jan 2023 14:35:53 -0800 (PST)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id q22-20020a05620a2a5600b0070638ad5986sm5460630qkp.85.2023.01.16.14.35.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 14:35:52 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 1930E27C0054;
        Mon, 16 Jan 2023 17:35:50 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 16 Jan 2023 17:35:52 -0500
X-ME-Sender: <xms:RdHFY6h_u8hGqyGFqI6hV82fdC_a5V6oG3naXWz87t5TmTyX9Z858w>
    <xme:RdHFY7BmXJOOAuYSXMdOeakj3Wi5ZR7_Y5iiHHneImWVI4qHImGSFpM517yFkpOli
    jqtiTgI4OTPKMXYBw>
X-ME-Received: <xmr:RdHFYyExOgTGpfdArLIHlVxsq8A35t1OE_gWkIuTSzooJ4azzWOpRZHwl0I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedruddthecutefuodetggdotefrodftvfcurf
    hrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhquhhnucfh
    vghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrfgrthhtvg
    hrnhephedugfduffffteeutddvheeuveelvdfhleelieevtdeguefhgeeuveeiudffiedv
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghoqh
    hunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedtieegqddu
    jeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfhhigihmvg
    drnhgrmhgv
X-ME-Proxy: <xmx:RdHFYzT9OUJHHBD-HdVszTOmJBzxoBAsrLDmclCFcvjKUXkX-jDhbw>
    <xmx:RdHFY3xLYQy_3o6KCfrp7Qyp5slluDmCREnvzjfjWfJrGeufEHG6jA>
    <xmx:RdHFYx4odU6f8HRrrQ7342uWfTt9sJ6neNWQISm56ES47dqzBcVuOg>
    <xmx:RtHFY3n2P3Z-klDKTRyQLGZ72BERLw167Irk0mAhGPU7hS1Pt1vwDA>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Jan 2023 17:35:49 -0500 (EST)
Date:   Mon, 16 Jan 2023 14:35:33 -0800
From:   Boqun Feng <boqun.feng@gmail.com>
To:     Waiman Long <longman@redhat.com>
Cc:     linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
        kvm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, seanjc@google.com,
        Joel Fernandes <joel@joelfernandes.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Luczaj <mhal@rbox.co>
Subject: Re: [PATCH 4/3] locking/lockdep: Improve the deadlock scenario print
 for sync and read lock
Message-ID: <Y8XRNdrW3t1jvpMF@boqun-archlinux>
References: <20230113065955.815667-1-boqun.feng@gmail.com>
 <20230113235722.1226525-1-boqun.feng@gmail.com>
 <221e35b8-88f5-5fc5-6961-6a8ce060a97b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <221e35b8-88f5-5fc5-6961-6a8ce060a97b@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 16, 2023 at 05:21:09PM -0500, Waiman Long wrote:
> On 1/13/23 18:57, Boqun Feng wrote:
> > Lock scenario print is always a weak spot of lockdep splats. Improvement
> > can be made if we rework the dependency search and the error printing.
> > 
> > However without touching the graph search, we can improve a little for
> > the circular deadlock case, since we have the to-be-added lock
> > dependency, and know whether these two locks are read/write/sync.
> > 
> > In order to know whether a held_lock is sync or not, a bit was
> > "stolen" from ->references, which reduce our limit for the same lock
> > class nesting from 2^12 to 2^11, and it should still be good enough.
> > 
> > Besides, since we now have bit in held_lock for sync, we don't need the
> > "hardirqoffs being 1" trick, and also we can avoid the __lock_release()
> > if we jump out of __lock_acquire() before the held_lock stored.
> > 
> > With these changes, a deadlock case evolved with read lock and sync gets
> > a better print-out from:
> > 
> > 	[...]  Possible unsafe locking scenario:
> > 	[...]
> > 	[...]        CPU0                    CPU1
> > 	[...]        ----                    ----
> > 	[...]   lock(srcuA);
> > 	[...]                                lock(srcuB);
> > 	[...]                                lock(srcuA);
> > 	[...]   lock(srcuB);
> > 
> > to
> > 
> > 	[...]  Possible unsafe locking scenario:
> > 	[...]
> > 	[...]        CPU0                    CPU1
> > 	[...]        ----                    ----
> > 	[...]   rlock(srcuA);
> > 	[...]                                lock(srcuB);
> > 	[...]                                lock(srcuA);
> > 	[...]   sync(srcuB);
> > 
> > Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> > ---
> >   include/linux/lockdep.h  |  3 ++-
> >   kernel/locking/lockdep.c | 48 ++++++++++++++++++++++++++--------------
> >   2 files changed, 34 insertions(+), 17 deletions(-)
> > 
> > diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
> > index ba09df6a0872..febd7ecc225c 100644
> > --- a/include/linux/lockdep.h
> > +++ b/include/linux/lockdep.h
> > @@ -134,7 +134,8 @@ struct held_lock {
> >   	unsigned int read:2;        /* see lock_acquire() comment */
> >   	unsigned int check:1;       /* see lock_acquire() comment */
> >   	unsigned int hardirqs_off:1;
> > -	unsigned int references:12;					/* 32 bits */
> > +	unsigned int sync:1;
> > +	unsigned int references:11;					/* 32 bits */
> >   	unsigned int pin_count;
> >   };
> > diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
> > index cffa026a765f..4031d87f6829 100644
> > --- a/kernel/locking/lockdep.c
> > +++ b/kernel/locking/lockdep.c
> > @@ -1880,6 +1880,8 @@ print_circular_lock_scenario(struct held_lock *src,
> >   	struct lock_class *source = hlock_class(src);
> >   	struct lock_class *target = hlock_class(tgt);
> >   	struct lock_class *parent = prt->class;
> > +	int src_read = src->read;
> > +	int tgt_read = tgt->read;
> >   	/*
> >   	 * A direct locking problem where unsafe_class lock is taken
> > @@ -1907,7 +1909,10 @@ print_circular_lock_scenario(struct held_lock *src,
> >   	printk(" Possible unsafe locking scenario:\n\n");
> >   	printk("       CPU0                    CPU1\n");
> >   	printk("       ----                    ----\n");
> > -	printk("  lock(");
> > +	if (tgt_read != 0)
> > +		printk("  rlock(");
> > +	else
> > +		printk("  lock(");
> >   	__print_lock_name(target);
> >   	printk(KERN_CONT ");\n");
> >   	printk("                               lock(");
> > @@ -1916,7 +1921,12 @@ print_circular_lock_scenario(struct held_lock *src,
> >   	printk("                               lock(");
> >   	__print_lock_name(target);
> >   	printk(KERN_CONT ");\n");
> > -	printk("  lock(");
> > +	if (src_read != 0)
> > +		printk("  rlock(");
> > +	else if (src->sync)
> > +		printk("  sync(");
> > +	else
> > +		printk("  lock(");
> >   	__print_lock_name(source);
> >   	printk(KERN_CONT ");\n");
> >   	printk("\n *** DEADLOCK ***\n\n");
> 
> src can be sync() but not the target. Is there a reason why that is the
> case?
> 

The functions annotated by sync() don't create real critical sections,
so no lock dependency can be created from a sync(), for example:

	synchronize_srcu(A);
	mutex_lock(B);

no dependency from A to B. In the scenario case, if we see a dependency
target -> source, the target cannot be a lock_sync(). I will add better
documentation later.

> 
> > @@ -4530,7 +4540,13 @@ mark_usage(struct task_struct *curr, struct held_lock *hlock, int check)
> >   					return 0;
> >   		}
> >   	}
> > -	if (!hlock->hardirqs_off) {
> > +
> > +	/*
> > +	 * For lock_sync(), don't mark the ENABLED usage, since lock_sync()
> > +	 * creates no critical section and no extra dependency can be introduced
> > +	 * by interrupts
> > +	 */
> > +	if (!hlock->hardirqs_off && !hlock->sync) {
> >   		if (hlock->read) {
> >   			if (!mark_lock(curr, hlock,
> >   					LOCK_ENABLED_HARDIRQ_READ))
> > @@ -4909,7 +4925,7 @@ static int __lock_is_held(const struct lockdep_map *lock, int read);
> >   static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
> >   			  int trylock, int read, int check, int hardirqs_off,
> >   			  struct lockdep_map *nest_lock, unsigned long ip,
> > -			  int references, int pin_count)
> > +			  int references, int pin_count, int sync)
> >   {
> >   	struct task_struct *curr = current;
> >   	struct lock_class *class = NULL;
> > @@ -4960,7 +4976,8 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
> >   	class_idx = class - lock_classes;
> > -	if (depth) { /* we're holding locks */
> > +	if (depth && !sync) {
> > +		/* we're holding locks and the new held lock is not a sync */
> >   		hlock = curr->held_locks + depth - 1;
> >   		if (hlock->class_idx == class_idx && nest_lock) {
> >   			if (!references)
> > @@ -4994,6 +5011,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
> >   	hlock->trylock = trylock;
> >   	hlock->read = read;
> >   	hlock->check = check;
> > +	hlock->sync = !!sync;
> >   	hlock->hardirqs_off = !!hardirqs_off;
> >   	hlock->references = references;
> >   #ifdef CONFIG_LOCK_STAT
> > @@ -5055,6 +5073,10 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
> >   	if (!validate_chain(curr, hlock, chain_head, chain_key))
> >   		return 0;
> > +	/* For lock_sync(), we are done here since no actual critical section */
> > +	if (hlock->sync)
> > +		return 1;
> > +
> >   	curr->curr_chain_key = chain_key;
> >   	curr->lockdep_depth++;
> >   	check_chain_key(curr);
> 
> Even with sync, there is still a corresponding lock_acquire() and
> lock_release(), you can't exit here without increasing lockdep_depth. That
> can cause underflow.
> 

I actually remove the __lock_release() in lock_sync() in this patch, so
I think it's OK. But I must admit the whole submission is to give David
something to see whether the output is an improvement, so I probably
should separate the output changes and the lock_sync() internall into
two patches (and the later can also be folded into the introduction
patch).

Regards,
Boqun

> Cheers,
> Longman
> 
