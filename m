Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC0C76202E
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 19:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbjGYRak (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 13:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjGYRai (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 13:30:38 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8061A8
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 10:30:37 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d052f49702dso5181715276.3
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 10:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690306236; x=1690911036;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=D9n8d2TuXAS+B/d6Ex7Hzq+rbxx9B3dvXIRtwwEdaDY=;
        b=gdnXDpiOPkNuhBHjZYhEdUAsw1lcGPNMbE8YMkQdrbEMdHjGWWtyjrU56TiY6V9dCd
         WQxml/lTT5K6kNBx1h/RYiS6sgGL0xbZNidmqfgQoJBFs7S06i2kVKFqqY/L87K6kb5g
         m7lZuONGTqYlqM8Iu9x8ugm2P9bdG0iW5KQfrEmBea7mWXfZLEWxoTMX2P+KCPG61aJ9
         4Ht4jSFXVm7bxi7aXYEmORXGU6X5Vkof+j6o0A0pZgcTEQkKgi9TegD5cWpMvrA2ijaD
         HBjUMIF75THP7+fHIDUGPHsg2Ynt6zbkV9mHAw63BsSo+9l6Fq3Wxc3lbyW/9tjIaCQG
         yzNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690306236; x=1690911036;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D9n8d2TuXAS+B/d6Ex7Hzq+rbxx9B3dvXIRtwwEdaDY=;
        b=X9NHAJ7BHz0mGlxXto+n90qoURDHLvSx6kTRcUkEgnQ51Hr9rTxyt0NBRwU79+R5H9
         D0jm+Y05JErgCvC6YwgY4FVbP7tr+ns5tHPkPvn+tTIdUNXnWYJ//jk+sQyhSk/o/5Rr
         nCjNqv4LWNvs5ZfP86EqMvSpmQX7aUeagOWHPFS29VJOTrqmTorEDl7UTQC53OTrnhyV
         CPKMl+dPGOaRX6IcE9HSQy6mAAN4JFOnwPBom0s7g88xJiqBr5EYZZ5prfyEN3ppkdg8
         RAkJ2KtZF7+MDtOB+/RYtcGupNlp5HFdYzeoV3Ir2NyTYIHk6v268tpydpz4Zl3a3leW
         Wu3g==
X-Gm-Message-State: ABy/qLZJqELlgCDtjXBJQOV0eFs13IaL1oDTk6MsRrlI53PtPB42J6zt
        ojA782B8p3p9MCky2+eS5ez6sWaiScg=
X-Google-Smtp-Source: APBJJlHcZf4N4q1Xy0x+AoGEnbKF6M8gjsSxZ4X/cQxsLvG6lSe3dFeHv5eiJ/zqIegHXlJNtta6H/9gepQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:78a:0:b0:cab:9746:ef0e with SMTP id
 b10-20020a5b078a000000b00cab9746ef0emr77724ybq.12.1690306236335; Tue, 25 Jul
 2023 10:30:36 -0700 (PDT)
Date:   Tue, 25 Jul 2023 10:30:34 -0700
In-Reply-To: <CAG+wEg21f6PPEnP2N7oE=48PBSd_2bHOcRsTy_ZuBpa2=dGuiA@mail.gmail.com>
Mime-Version: 1.0
References: <ZHZCEUzr9Ak7rkjG@google.com> <20230721143407.2654728-1-amaan.cheval@gmail.com>
 <ZLrCUkwot/yiVC8T@google.com> <CAG+wEg21f6PPEnP2N7oE=48PBSd_2bHOcRsTy_ZuBpa2=dGuiA@mail.gmail.com>
Message-ID: <ZMAGuic1viMLtV7h@google.com>
Subject: Re: Deadlock due to EPT_VIOLATION
From:   Sean Christopherson <seanjc@google.com>
To:     Amaan Cheval <amaan.cheval@gmail.com>
Cc:     brak@gameservers.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 24, 2023, Amaan Cheval wrote:
> > > I've also run a `function_graph` trace on some of the affected hosts, if you
> > > think it might be helpful...
> >
> > It wouldn't hurt to see it.
> >
> 
> Here you go:
> https://transfer.sh/SfXSCHp5xI/ept-function-graph.log

Yeesh.  There is a ridiculous amount of potentially problematic activity.  KSM is
active in that trace, it looks like NUMA balancing might be in play, there might
be hugepage shattering, etc.

> > > Another interesting observation we made was that when we migrate a guest to a
> > > different host, the guest _stays_ locked up and throws EPT violations on the new
> > > host as well
> >
> > Ooh, that's *very* interesting.  That pretty much rules out memslot and mmu_notifier
> > issues.
> 
> Good to know, thanks!

Let me rephrase that statement: it rules out a certain class of memslot and
mmu_notifier bugs, namely bugs where KVM would incorrect leave an invalidation
refcount (for lack of a better term) elevated.  It doesn't mean memslot changes
and/or mmu_notifier events aren't at fault.

Can you migrate a hung guest to a host that is completely unloaded?  And ideally,
disable KSM and NUMA autobalancing on the target host.  And then get a
function_graph trace on that host, assuming the vCPU remains stuck.  There is *so*
much going on in the above graph that it's impossible to determine if there's a
kernel bug, e.g. it's possible the vCPU is stuck purely because it's being trashed
to the point where it can't make forward progress.

> > To mostly confirm this is likely what's happening, can you enable all of the async
> > #PF tracepoints in KVM?  The exact tracepoints might vary dependending on which kernel
> > version you're running, just enable everything with "async" in the name, e.g.
> >
> >   # ls -1 /sys/kernel/debug/tracing/events/kvm | grep async
> >   kvm_async_pf_completed/
> >   kvm_async_pf_not_present/
> >   kvm_async_pf_ready/
> >   kvm_async_pf_repeated_fault/
> >   kvm_try_async_get_page/
> >
> > If kvm_try_async_get_page() is more or less keeping pace with the "pf_taken" stat,
> > then this is likely what's happening.
> 
> I did this and unfortunately, don't see any of these functions being
> called at all despite
> EPT_VIOLATIONs still being thrown and pf_taken still climbing. (Tried both with
> `trace-cmd -e ...` and using `bpftrace` and none of those functions
> are being called
> during the deadlock/guest being stuck.)

Well fudge.

> > And then to really confirm, this small bpf program will yell if get_user_pages_remote()
> > fails when attempting get a single page (which is always the case for KVM's async
> > #PF usage).
> >
> > $ tail gup_remote.bt
> > kretfunc:get_user_pages_remote
> > {
> >         if ( args->nr_pages == 1 && retval != 1 ) {
> >                 printf("Failed remote gup() on address %lx, ret = %d\n", args->start, retval);
> >         }
> > }
> >
> 
> Our hosts don't have kfunc/kretfunc support (`bpftrace --info` reports
> `kret: no`),
> but I tried just a kprobe to verify that get_user_pages_remote is
> being called at all -
> does not seem like it is, unfortunately:
> 
> ```
> # bpftrace -e 'kprobe:get_user_pages_remote { @[comm] = count(); }'
> Attaching 1 probe...
> ^C
> #
> ```
> 
> So I guess that disproves the async #PF theory?

Yeah.  Definitely not related async page fault.
