Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA6A50A2A1
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 16:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357680AbiDUOib (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 10:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389456AbiDUOiP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 10:38:15 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA70913D39
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 07:35:24 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id p12so3511699lfs.5
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 07:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zQXdcZYLTgL+7c/dGrHyarz4xtqMzDlgUfL99vE41bw=;
        b=CsuOgFLYG0kT9MEviWVke1X8+c5ACXlhwdM9tDmBQpbSbsD37e/e4qon8Z8O/dowBo
         f5wTnk3tt2CsqrBryUFjvwRjxyGejeUqrte7wcrDselQYWxV+SQdGSGOEwmaw3XX1rVA
         9m+0UqM9CWGCNZUQrdqD9PaiJK7pXtsnPU/XxzjtfDn0bY7kXduy+B6EkqQEnbjLb12v
         G/izCo80AETHSWzU4FEfzk+hR1xkcak0rleedpiExdSCUPHOkBZ0yNYKmX558k/73rgj
         KdrGBIjHDDOj1Jx4GsPzY58EUouSLyIhB5XHwoFryjfOELTGS5zL+42nijLRUhh/DiyY
         UouQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zQXdcZYLTgL+7c/dGrHyarz4xtqMzDlgUfL99vE41bw=;
        b=JIgyh8LxpRXnDk26z9OmBxJ3Ibb3LjRMedrf3S8opUJQJrrHjYkfQWkAF45ZqFwtEQ
         6aXu0ecXQ2jxA6A5AvW50AMmEDZmlm4XXpIb2OteIfnTQh6gzJe9ceoNMPC9rb5rv7SR
         kwtEL/r3EnAV2wxEXq8K0hT/eP2FCGLE7B7WFxXnN+eGR5rakUHMuQxqKwS8C2ElgSNo
         RwRco30ve3V9f92NsPVq2xBiQxaO1jOi13YrZ3rX6bnUxxZ2ypcGXJ87JPoJn4I+CFE6
         YVFAoDYxGajbms6bKxv/rD6HktWJYtb8CdsltQ2ULabLbpCh/cpcKG9nWRoPIjFxeTCT
         O+UQ==
X-Gm-Message-State: AOAM533JMnV8CGWN2DetWT2kefG4GwCmlpj4XywdrR81CxQJlFsvSzJk
        nG7i5I/KzZQNdDk1L6tUaZEXhRcln1VqntTtRbzViEq/Uhc=
X-Google-Smtp-Source: ABdhPJwLS7YGuueyG9RO46uk14YM1dXrpo94aQXCXAcITZI7mOCr8ohv/daBRoURpNPA9YlAmGVwkC8Pm8cInciGnz4=
X-Received: by 2002:a05:6512:c01:b0:448:6aec:65c5 with SMTP id
 z1-20020a0565120c0100b004486aec65c5mr18960186lfu.193.1650551722806; Thu, 21
 Apr 2022 07:35:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220330164306.2376085-1-pgonda@google.com> <CAL715W+S-SJwXBhYO=_T-9uAPLt6cQ-Hn+_+ehefAh6+kQ_zOA@mail.gmail.com>
 <YkYdlfYM/FWlMqMg@google.com> <CAL715WLhy7EkJCyO7vzak3O8iw8GDRHkPF8aRtDedPXO1vx_Qw@mail.gmail.com>
 <Yk3bSmQTspjZHUZf@google.com> <CAMkAt6obVDW_LFvQzUYw6v7okiNq1KAbUOMoM3bN6zeJUGg6Xw@mail.gmail.com>
 <Yl2IN6CHQzkts4XE@google.com>
In-Reply-To: <Yl2IN6CHQzkts4XE@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Thu, 21 Apr 2022 08:35:11 -0600
Message-ID: <CAMkAt6qEazsM1qMbg3EaKHD3BD_xrUrqORqg4XmNu-aqGmK0iQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: SEV: Add cond_resched() to loop in sev_clflush_pages()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Mingwei Zhang <mizhang@google.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 18, 2022 at 9:48 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Apr 06, 2022, Peter Gonda wrote:
> > On Wed, Apr 6, 2022 at 12:26 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Wed, Apr 06, 2022, Mingwei Zhang wrote:
> > > > Hi Sean,
> > > >
> > > > > > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > > > > > index 75fa6dd268f0..c2fe89ecdb2d 100644
> > > > > > > --- a/arch/x86/kvm/svm/sev.c
> > > > > > > +++ b/arch/x86/kvm/svm/sev.c
> > > > > > > @@ -465,6 +465,7 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
> > > > > > >                 page_virtual = kmap_atomic(pages[i]);
> > > > > > >                 clflush_cache_range(page_virtual, PAGE_SIZE);
> > > > > > >                 kunmap_atomic(page_virtual);
> > > > > > > +               cond_resched();
> > > > > >
> > > > > > If you add cond_resched() here, the frequency (once per 4K) might be
> > > > > > too high. You may want to do it once per X pages, where X could be
> > > > > > something like 1G/4K?
> > > > >
> > > > > No, every iteration is perfectly ok.  The "cond"itional part means that this will
> > > > > reschedule if and only if it actually needs to be rescheduled, e.g. if the task's
> > > > > timeslice as expired.  The check for a needed reschedule is cheap, using
> > > > > cond_resched() in tight-ish loops is ok and intended, e.g. KVM does a reched
> > > > > check prior to enterring the guest.
> > > >
> > > > Double check on the code again. I think the point is not about flag
> > > > checking. Obviously branch prediction could really help. The point I
> > > > think is the 'call' to cond_resched(). Depending on the kernel
> > > > configuration, cond_resched() may not always be inlined, at least this
> > > > is my understanding so far? So if that is true, then it still might
> > > > not always be the best to call cond_resched() that often.
> > >
> > > Eh, compared to the cost of 64 back-to-back CLFLUSHOPTs, the cost of __cond_resched()
> > > is peanuts.  Even accounting for the rcu_all_qs() work, it's still dwarfed by the
> > > cost of flushing data from the cache.  E.g. based on Agner Fog's wonderful uop
> > > latencies[*], the actual flush time for a single page is going to be upwards of
> > > 10k cycles, whereas __cond_resched() is going to well under 100 cycles in the happy
> > > case of no work.  Even if those throughput numbers are off by an order of magnitude,
> > > e.g. CLFLUSHOPT can complete in 15 cycles, that's still ~1k cycles.
> > >
> > > Peter, don't we also theoretically need cond_resched() in the loops in
> > > sev_launch_update_data()?  AFAICT, there's no articifical restriction on the size
> > > of the payload, i.e. the kernel is effectively relying on userspace to not update
> > > large swaths of memory.
> >
> > Yea we probably do want to cond_resched() in the for loop inside of
> > sev_launch_update_data(). Ithink in  sev_dbg_crypt() userspace could
> > request a large number of pages to be decrypted/encrypted for
> > debugging but se have a call to sev_pin_memory() in the loop so that
> > will have a cond_resded() inside of __get_users_pages(). Or should we
> > have a cond_resded() inside of the loop in sev_dbg_crypt() too?
>
> I believe sev_dbg_crypt() needs a cond_resched() of its own, sev_pin_memory()
> isn't guaranteed to get into the slow path of internal_get_user_pages_fast().

Ah, understood thanks. I'll send out patches for those two paths. I
personally haven't seen any warning logs from them though.
