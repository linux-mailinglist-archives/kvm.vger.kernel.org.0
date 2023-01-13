Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD2A66A1AE
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 19:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbjAMSOu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 13:14:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbjAMSNw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 13:13:52 -0500
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96634A7B6D;
        Fri, 13 Jan 2023 10:05:34 -0800 (PST)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-4a2f8ad29d5so295541397b3.8;
        Fri, 13 Jan 2023 10:05:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z4pto12rSouFh/dIEU2H2b7i14PEpI0T9dvCoGHqSWA=;
        b=BpnMJiIhqYiZz3eigM1emJUaY9PCw/NmetqKfb/O8lZnOaBfZtSWXZzjNRwYtD9CVw
         Uxf67lk8Qxx7EEqcggwL81GNDNjCzsrKRTHDDMzMQsYffiCYsLJrkHJXfuH0LCK3RibT
         AqzLfsaXq7tAH3g6r7yA0AmCwbjg0P5PED6GBuoFRcVE+j/cWZufPTuxbPTc5kFp1hoP
         C/grHHgFpJ1UQihJSYKdkK6tLRukmvXwb7omrNxLFnbV/va4DY7A3E8s2gnOdUixN+3x
         W455CeOkNY3dTViTLWJw1OT+RBbfNU0h7eRJHJLsQwg11wHLWHq2uiwInBK7BOxJF8Pd
         dETg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z4pto12rSouFh/dIEU2H2b7i14PEpI0T9dvCoGHqSWA=;
        b=aNoRRBjOED+C4ZbDSrILeIEnuKLXioiJve5IQglXcNCQPuFa55ZRhUxL+KWleowLIU
         rpGGzGjq934QfnhBBKsCnLNweMlmuBXtlQqnYuO02E2oXH66fUHn/YDRyP/+vFXqF+sv
         gfwxhpaEr/FtQbZuKfSZ3bI1E8mOSforFbzEbntstQNt9yrckKU4e1cBrHUWZH51sAAk
         4PImpaBbNFD1yT1gYBiSoqSnxRj1rrbuLmXyaAngJxzdtrkxpXbYPt4MzAAsf8bknOpY
         ny7l7UbXIPUDYssW1ab7DE5I6YU9HQu0wfX3ezcayppo92COOFDlUI0M23Vy3i5R2bQX
         FLMw==
X-Gm-Message-State: AFqh2kq5Lf8b7eGOUScoqQBTl/Jg49rnYUhVh12B/eyeB47/NSwD6/G+
        /8G2qTAI6E6xQ6pL+kIuruA=
X-Google-Smtp-Source: AMrXdXtalijBBdCMZhQ8k7FyN+Oiyguirc34cGy+spxk2vmWC3AHP1oHn2Dyy/oD+Rs4wXKe4GAj5Q==
X-Received: by 2002:a05:7500:2897:b0:ee:2795:1b41 with SMTP id de23-20020a057500289700b000ee27951b41mr4290706gab.20.1673633133188;
        Fri, 13 Jan 2023 10:05:33 -0800 (PST)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id t13-20020a05620a450d00b006fba0a389a4sm13204179qkp.88.2023.01.13.10.05.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 10:05:32 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailauth.nyi.internal (Postfix) with ESMTP id 9C66827C0054;
        Fri, 13 Jan 2023 13:05:31 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Fri, 13 Jan 2023 13:05:31 -0500
X-ME-Sender: <xms:aZ3BY-qoWGqcNKRKnvQs2pyB43z0nKMXiXle27FNu2kV3ZIZWcBJ3w>
    <xme:aZ3BY8pDMNvXAuti_tQaaE5Mv_Hsp4jxxPPpU9kqIizmrhm83VoR2Z3wpZaAK6PKO
    su7TfdSxwMDFJH8tQ>
X-ME-Received: <xmr:aZ3BYzOxDFJPOk_6tNlHxfLNQguqTRbDR0n8ilQv8uFRA97V0ksImf_oNDQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrleekgddutdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhu
    nhcuhfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrg
    htthgvrhhnpeehudfgudffffetuedtvdehueevledvhfelleeivedtgeeuhfegueeviedu
    ffeivdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    gsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtdei
    gedqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehfih
    igmhgvrdhnrghmvg
X-ME-Proxy: <xmx:aZ3BY96wgjDfxqkkvQNliEHTmo8TZMvZ8uMHDzkJwEUKicEB9an_DQ>
    <xmx:aZ3BY96GeN-VuxoRwYh8u5YrxzCBTCR_Jju1Kw7fi-FDwx1MPFVvzA>
    <xmx:aZ3BY9h8C8l7mTixeAvIczYmIu27p17yZZ5Q-fJTZ6wagd8kXFsNnA>
    <xmx:a53BY-NDPVaEk5u2mXPQTDAkKFU-D77WYVlaAqfXfVSGyahlKcr5jA>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Jan 2023 13:05:29 -0500 (EST)
Date:   Fri, 13 Jan 2023 10:05:22 -0800
From:   Boqun Feng <boqun.feng@gmail.com>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
        kvm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, seanjc@google.com,
        Joel Fernandes <joel@joelfernandes.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Luczaj <mhal@rbox.co>
Subject: Re: [PATCH 2/3] rcu: Equip sleepable RCU with lockdep dependency
 graph checks
Message-ID: <Y8GdYgSBtyKwf/qj@boqun-archlinux>
References: <20230113065955.815667-1-boqun.feng@gmail.com>
 <20230113065955.815667-3-boqun.feng@gmail.com>
 <20230113112949.GX4028633@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113112949.GX4028633@paulmck-ThinkPad-P17-Gen-1>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 13, 2023 at 03:29:49AM -0800, Paul E. McKenney wrote:
> On Thu, Jan 12, 2023 at 10:59:54PM -0800, Boqun Feng wrote:
> > Although all flavors of RCU are annotated correctly with lockdep as
> > recursive read locks, their 'check' parameter of lock_acquire() is
> > unset. It means that RCU read locks are not added into the lockdep
> > dependency graph therefore deadlock detection based on dependency graph
> > won't catch deadlock caused by RCU. This is fine for "non-sleepable" RCU
> > flavors since wait-context detection and other context based detection
> > can catch these deadlocks. However for sleepable RCU, this is limited.
> > 
> > Actually we can detect the deadlocks caused by SRCU by 1) making
> > srcu_read_lock() a 'check'ed recursive read lock and 2) making
> > synchronize_srcu() a empty write lock critical section. Even better,
> > with the newly introduced lock_sync(), we can avoid false positives
> > about irq-unsafe/safe. So do it.
> > 
> > Note that NMI safe SRCU read side critical sections are currently not
> > annonated, since step-by-step approach can help us deal with
> > false-positives. These may be annotated in the future.
> > 
> > Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> 
> Nice, thank you!!!
> 
> Acked-by: Paul E. McKenney <paulmck@kernel.org>
> 
> Or if you would prefer that I take the series through -rcu, please just
> let me know.
> 

I prefer that the first two patches go through your tree, because it
reduces the synchronization among locking, rcu and KVM trees to the
synchronization betwen rcu and KVM trees.

For patch #3, since it's not really ready yet, so I don't know, but I
guess when it's finished, probably better go through -rcu.

Regards,
Boqun

> 							Thanx, Paul
> 
> > ---
> >  include/linux/srcu.h  | 23 +++++++++++++++++++++--
> >  kernel/rcu/srcutiny.c |  2 ++
> >  kernel/rcu/srcutree.c |  2 ++
> >  3 files changed, 25 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/srcu.h b/include/linux/srcu.h
> > index 9b9d0bbf1d3c..a1595f8c5155 100644
> > --- a/include/linux/srcu.h
> > +++ b/include/linux/srcu.h
> > @@ -102,6 +102,21 @@ static inline int srcu_read_lock_held(const struct srcu_struct *ssp)
> >  	return lock_is_held(&ssp->dep_map);
> >  }
> >  
> > +static inline void srcu_lock_acquire(struct lockdep_map *map)
> > +{
> > +	lock_map_acquire_read(map);
> > +}
> > +
> > +static inline void srcu_lock_release(struct lockdep_map *map)
> > +{
> > +	lock_map_release(map);
> > +}
> > +
> > +static inline void srcu_lock_sync(struct lockdep_map *map)
> > +{
> > +	lock_map_sync(map);
> > +}
> > +
> >  #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
> >  
> >  static inline int srcu_read_lock_held(const struct srcu_struct *ssp)
> > @@ -109,6 +124,10 @@ static inline int srcu_read_lock_held(const struct srcu_struct *ssp)
> >  	return 1;
> >  }
> >  
> > +#define srcu_lock_acquire(m) do { } while (0)
> > +#define srcu_lock_release(m) do { } while (0)
> > +#define srcu_lock_sync(m) do { } while (0)
> > +
> >  #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
> >  
> >  #define SRCU_NMI_UNKNOWN	0x0
> > @@ -182,7 +201,7 @@ static inline int srcu_read_lock(struct srcu_struct *ssp) __acquires(ssp)
> >  
> >  	srcu_check_nmi_safety(ssp, false);
> >  	retval = __srcu_read_lock(ssp);
> > -	rcu_lock_acquire(&(ssp)->dep_map);
> > +	srcu_lock_acquire(&(ssp)->dep_map);
> >  	return retval;
> >  }
> >  
> > @@ -226,7 +245,7 @@ static inline void srcu_read_unlock(struct srcu_struct *ssp, int idx)
> >  {
> >  	WARN_ON_ONCE(idx & ~0x1);
> >  	srcu_check_nmi_safety(ssp, false);
> > -	rcu_lock_release(&(ssp)->dep_map);
> > +	srcu_lock_release(&(ssp)->dep_map);
> >  	__srcu_read_unlock(ssp, idx);
> >  }
> >  
> > diff --git a/kernel/rcu/srcutiny.c b/kernel/rcu/srcutiny.c
> > index b12fb0cec44d..336af24e0fe3 100644
> > --- a/kernel/rcu/srcutiny.c
> > +++ b/kernel/rcu/srcutiny.c
> > @@ -197,6 +197,8 @@ void synchronize_srcu(struct srcu_struct *ssp)
> >  {
> >  	struct rcu_synchronize rs;
> >  
> > +	srcu_lock_sync(&ssp->dep_map);
> > +
> >  	RCU_LOCKDEP_WARN(lockdep_is_held(ssp) ||
> >  			lock_is_held(&rcu_bh_lock_map) ||
> >  			lock_is_held(&rcu_lock_map) ||
> > diff --git a/kernel/rcu/srcutree.c b/kernel/rcu/srcutree.c
> > index ca4b5dcec675..408088c73e0e 100644
> > --- a/kernel/rcu/srcutree.c
> > +++ b/kernel/rcu/srcutree.c
> > @@ -1267,6 +1267,8 @@ static void __synchronize_srcu(struct srcu_struct *ssp, bool do_norm)
> >  {
> >  	struct rcu_synchronize rcu;
> >  
> > +	srcu_lock_sync(&ssp->dep_map);
> > +
> >  	RCU_LOCKDEP_WARN(lockdep_is_held(ssp) ||
> >  			 lock_is_held(&rcu_bh_lock_map) ||
> >  			 lock_is_held(&rcu_lock_map) ||
> > -- 
> > 2.38.1
> > 
