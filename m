Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AABAE668F32
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 08:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234479AbjAMH0C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 02:26:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241000AbjAMHZa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 02:25:30 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68B96CFE5;
        Thu, 12 Jan 2023 23:18:59 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id a25so11304044qto.10;
        Thu, 12 Jan 2023 23:18:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :feedback-id:from:to:cc:subject:date:message-id:reply-to;
        bh=+z0/hUtMCEe+Sodh1Dnn7/1zn6Dfmpve/g4mWQscvnU=;
        b=gMi4yBqvjYTeivpx6erYaQRng/JeBNDvpfW4l4cAXrLtAlv17q1L7nIsIGZshaFQJD
         4O5FJPzLlKR95nqyv2DAtOwwLVZp99yWXEAW2NoU0BHd5pCj8iIKBftU6GS/Me5y6szE
         uHI9z1wEuPcO7sPPJdoDWlt9UQ7Ba6kgRXvqDGDfziaLSAFGDhEs3eAvQOwLYTDmkGZg
         SW0saiZXPYnBf5KuWl39sYyDxluKJ6NWLeMfKMlnzk52KJZ4P3zyuGziW/M6LVzVQ2D9
         GxOLIeJi4EgvYudYTOQ+HSEH04z/eVnLpSMAOqGzuWmSWPt2erm64Tjoh1ZcX3gQNgjs
         rEhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :feedback-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+z0/hUtMCEe+Sodh1Dnn7/1zn6Dfmpve/g4mWQscvnU=;
        b=4fnGi8V6C1MalOAPExUD+TUpm0IQOUWBozzQS8LRZ7vN4mX9uEquVRveU3fI9KLkQ8
         DJ2N6HmTDLIkMUgq2ki0EVEJb3baGXiHUz3EjVly3vEJHXnvdcuswtbOLQSQy3jJX45M
         x2XCsxNzzPxu944XlBasRoGMTl96HTVMlTZZ7rpqikQmwRSmIEojkohpRC9DPTRW1Qso
         rst1jrgzEGyAvUfie3TrDnKxNE+BIl1ZFbOfeFS90X0Kyv4CdXd6Jj/F+7H7p8f/iXQO
         YfjfBVEk4mqCKG5z5PUfM1C0LDmc4PH8iwvPenAa9BE4bxoGXF0a7XMSrpRC10w84dWA
         ng8Q==
X-Gm-Message-State: AFqh2krCnQ8RHZACu0nk23gT3XBpJ3lLouxavZ52g/DTtHdyW06aXbyP
        /oKznNrr2YtDx9xworxVF2c=
X-Google-Smtp-Source: AMrXdXv+4L9qMRN8pXTWxPtd0XoDnknLpiUJASz0U0PwjOdpaxVPX/fatCYOVbdwQhYy/+TeE9bqxg==
X-Received: by 2002:a05:622a:5c1a:b0:3a6:c4eb:2e52 with SMTP id gd26-20020a05622a5c1a00b003a6c4eb2e52mr115266387qtb.43.1673594339012;
        Thu, 12 Jan 2023 23:18:59 -0800 (PST)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id z26-20020ac8101a000000b003a70a675066sm10138312qti.79.2023.01.12.23.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 23:18:58 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailauth.nyi.internal (Postfix) with ESMTP id 05D2D27C0054;
        Fri, 13 Jan 2023 02:18:58 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Fri, 13 Jan 2023 02:18:58 -0500
X-ME-Sender: <xms:4QXBYxgoeVoETsJsOoSd25V4FXonWZRGLIG34PCakAfKpvPzhkqtKw>
    <xme:4QXBY2C-sW30f7WEh6nhvsNrPCcyN9-q6ZZH50SpZwQUn-EVRqA28iRAddC5pEDy1
    YHqpvOvSbOBhJys3A>
X-ME-Received: <xmr:4QXBYxGnmB3XTu-felmKZcawQ--DozNEG8m06UHp6BxjegQlbIMIGXkh8p4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrleejgddutdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpeeuohhq
    uhhnucfhvghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrf
    grthhtvghrnhepgfelheetkefgudetjeejkefhjeefvdeifedthfehgffgheehieeliefh
    tdetheefnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhquhhnodhmvghsmhhtphgruhht
    hhhpvghrshhonhgrlhhithihqdeiledvgeehtdeigedqudejjeekheehhedvqdgsohhquh
    hnrdhfvghngheppehgmhgrihhlrdgtohhmsehfihigmhgvrdhnrghmvg
X-ME-Proxy: <xmx:4QXBY2TUp8Zn3QzMzdO5thttlDS1SVHPP5rrL9UNUurHc6dFI9gAEg>
    <xmx:4QXBY-wKux4yE0QX43JLh88_oAV0SrmtCW09-GOhccFOQIBCutWXng>
    <xmx:4QXBY85K6luKpC0kLNCwK6dmebthLvOU1Wna7fKk5GcDyqrjl93D5g>
    <xmx:4gXBYw6tAI-PASSYUj768zg5_fKQYmiFrpp4kQIFfwEhsF8L4Z6feg>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Jan 2023 02:18:57 -0500 (EST)
Date:   Thu, 12 Jan 2023 23:18:51 -0800
From:   Boqun Feng <boqun.feng@gmail.com>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, Joel Fernandes <joel@joelfernandes.org>,
        Matthew Wilcox <willy@infradead.org>,
        Josh Triplett <josh@joshtriplett.org>, rcu@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] Documentation: kvm: fix SRCU locking order docs
Message-ID: <Y8EF24o932lcshKs@boqun-archlinux>
References: <20230111183031.2449668-1-pbonzini@redhat.com>
 <a14a13a690277d4cc95a4b26aa2d9a4d9b392a74.camel@infradead.org>
 <20230112152048.GJ4028633@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230112152048.GJ4028633@paulmck-ThinkPad-P17-Gen-1>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 12, 2023 at 07:20:48AM -0800, Paul E. McKenney wrote:
> On Thu, Jan 12, 2023 at 08:24:16AM +0000, David Woodhouse wrote:
> > On Wed, 2023-01-11 at 13:30 -0500, Paolo Bonzini wrote:
> > > 
> > > +- ``synchronize_srcu(&kvm->srcu)`` is called inside critical sections
> > > +  for kvm->lock, vcpu->mutex and kvm->slots_lock.  These locks _cannot_
> > > +  be taken inside a kvm->srcu read-side critical section; that is, the
> > > +  following is broken::
> > > +
> > > +      srcu_read_lock(&kvm->srcu);
> > > +      mutex_lock(&kvm->slots_lock);
> > > +
> > 
> > "Don't tell me. Tell lockdep!"
> > 
> > Did we conclude in
> > https://lore.kernel.org/kvm/122f38e724aae9ae8ab474233da1ba19760c20d2.camel@infradead.org/
> > that lockdep *could* be clever enough to catch a violation of this rule
> > by itself?
> > 
> > The general case of the rule would be that 'if mutex A is taken in a
> > read-section for SCRU B, then any synchronize_srcu(B) while mutex A is
> > held shall be verboten'. And vice versa.
> > 
> > If we can make lockdep catch it automatically, yay!
> 
> Unfortunately, lockdep needs to see a writer to complain, and that patch
> just adds a reader.  And adding that writer would make lockdep complain
> about things that are perfectly fine.  It should be possible to make
> lockdep catch this sort of thing, but from what I can see, doing so
> requires modifications to lockdep itself.
> 

Please see if the follow patchset works:

	https://lore.kernel.org/lkml/20230113065955.815667-1-boqun.feng@gmail.com

"I have been called. I must answer. Always." ;-) 

> > If not, I'm inclined to suggest that we have explicit wrappers of our
> > own for kvm_mutex_lock() which will do the check directly.
> 
> This does allow much more wiggle room.  For example, you guys could decide
> to let lockdep complain about things that other SRCU users want to do.
> For completeness, here is one such scenario:
> 
> CPU 0:  read_lock(&rla); srcu_read_lock(&srcua); ...
> 
> CPU 1:  srcu_read_lock(&srcua); read_lock(&rla); ...
> 
> CPU 2:  synchronize_srcu(&srcua);
> 
> CPU 3: 	write_lock(&rla); ...
> 
> If you guys are OK with lockdep complaining about this, then doing a

Actually lockdep won't complain about this, since srcu_read_lock() is
always a recursive read lock, so it won't break other srcu_read_lock().
FWIW if CPU2 or CPU3 does

	write_lock(&rla); 
	synchronize_srcu(&srcua);

it's a deadlock (with CPU 1)

Regards,
Boqun

> currently mythical rcu_write_acquire()/rcu_write_release() pair around
> your calls to synchronize_srcu() should catch the other issue.
> 
> And probably break something else, but you have to start somewhere!  ;-)
> 
> 							Thanx, Paul
