Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 617214F6A13
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 21:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbiDFTik (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 15:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232488AbiDFThg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 15:37:36 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38281864A7
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 11:34:32 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id m12so4416204ljp.8
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 11:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HSwp1BDG0k7X/+K+RwJOW/sVCMMxMSEnJISgNBGi2bg=;
        b=Ys/1WSnGhYSt2OK9wL+F2ZyDI0KN3bD3nkQ7cSEAfHt1sAJ+3HACDKvwFqmgSO0McZ
         QFScanM5uUJaQB9Dg7NYmvPo2C65E+TWz5N6SYM8r9Roi/wG86Rh7LzBhbgvInT42DFQ
         7Qn1qPwmokjVsWFL7xBCD7dR5M2pNWfz9LutvoFMBLrdy9yPU0pbuHgbnhyGep2+PxlF
         B+WXQTlzC15jmupuOPCyOclnMpoFIGqpDpOFln7aOg1ado+Q4UuO8F1YYm+el0+4BD9G
         8Afv9mb1mWYGKWv/eaktdDgf0tWjnHCB0QK0RS14sBPVGz+3igXdnZum3nr2wGmSxHnv
         Op4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HSwp1BDG0k7X/+K+RwJOW/sVCMMxMSEnJISgNBGi2bg=;
        b=sVVeVOrJi7+zwdOIxzpmmuOsBxC7wCfabMuBt0XHP1tyDmcFkFdWwJg1OkR+2wz3bF
         ORm3WB4esiNmVLFisyExJH+RjfmyxgRaj2A76Geh3ltP/COipHAuTjhCoe9jmAVKfLqL
         0W/j6mcmw8uou679GS+0LV6MIbRU+sSkcbfjVPv+CKDcFofwipUfXU1fNC6uPUelZdot
         p1dvxu+ckYGgY5uzOjK646fJiK0sxFucOUOW2gViws7GxSZPwKrP/FRQP2BzfqFaN/Tg
         3ckA/EHO3DzhrVtW+M00ik9I/RRig66YkLjOhcpomznRDhc/Cchg3PX075l9sAWiulRp
         jkbw==
X-Gm-Message-State: AOAM5305kUdPKSQrHHOpEIwHou8qQc7C3DXNtmrg9A6OF0M1t4p6we0A
        XTPW2VuJskZ6mReMluI5d0jUmHf0gekDZpE8sLBDcCQl0mpeyQ==
X-Google-Smtp-Source: ABdhPJwumCsczWpIy24fNgQlHvwaiW2/ShuvoT5gCcoB1T6IdJSpe3MINoXCfDWffgbKbUzSewBdIR9qz3k8q2Uxfpw=
X-Received: by 2002:a05:651c:b1e:b0:249:95d3:7832 with SMTP id
 b30-20020a05651c0b1e00b0024995d37832mr6253661ljr.426.1649270070676; Wed, 06
 Apr 2022 11:34:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220330164306.2376085-1-pgonda@google.com> <CAL715W+S-SJwXBhYO=_T-9uAPLt6cQ-Hn+_+ehefAh6+kQ_zOA@mail.gmail.com>
 <YkYdlfYM/FWlMqMg@google.com> <CAL715WLhy7EkJCyO7vzak3O8iw8GDRHkPF8aRtDedPXO1vx_Qw@mail.gmail.com>
 <Yk3bSmQTspjZHUZf@google.com>
In-Reply-To: <Yk3bSmQTspjZHUZf@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Wed, 6 Apr 2022 12:34:19 -0600
Message-ID: <CAMkAt6obVDW_LFvQzUYw6v7okiNq1KAbUOMoM3bN6zeJUGg6Xw@mail.gmail.com>
Subject: Re: [PATCH] KVM: SEV: Add cond_resched() to loop in sev_clflush_pages()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Mingwei Zhang <mizhang@google.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 6, 2022 at 12:26 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Apr 06, 2022, Mingwei Zhang wrote:
> > Hi Sean,
> >
> > > > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > > > index 75fa6dd268f0..c2fe89ecdb2d 100644
> > > > > --- a/arch/x86/kvm/svm/sev.c
> > > > > +++ b/arch/x86/kvm/svm/sev.c
> > > > > @@ -465,6 +465,7 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
> > > > >                 page_virtual = kmap_atomic(pages[i]);
> > > > >                 clflush_cache_range(page_virtual, PAGE_SIZE);
> > > > >                 kunmap_atomic(page_virtual);
> > > > > +               cond_resched();
> > > >
> > > > If you add cond_resched() here, the frequency (once per 4K) might be
> > > > too high. You may want to do it once per X pages, where X could be
> > > > something like 1G/4K?
> > >
> > > No, every iteration is perfectly ok.  The "cond"itional part means that this will
> > > reschedule if and only if it actually needs to be rescheduled, e.g. if the task's
> > > timeslice as expired.  The check for a needed reschedule is cheap, using
> > > cond_resched() in tight-ish loops is ok and intended, e.g. KVM does a reched
> > > check prior to enterring the guest.
> >
> > Double check on the code again. I think the point is not about flag
> > checking. Obviously branch prediction could really help. The point I
> > think is the 'call' to cond_resched(). Depending on the kernel
> > configuration, cond_resched() may not always be inlined, at least this
> > is my understanding so far? So if that is true, then it still might
> > not always be the best to call cond_resched() that often.
>
> Eh, compared to the cost of 64 back-to-back CLFLUSHOPTs, the cost of __cond_resched()
> is peanuts.  Even accounting for the rcu_all_qs() work, it's still dwarfed by the
> cost of flushing data from the cache.  E.g. based on Agner Fog's wonderful uop
> latencies[*], the actual flush time for a single page is going to be upwards of
> 10k cycles, whereas __cond_resched() is going to well under 100 cycles in the happy
> case of no work.  Even if those throughput numbers are off by an order of magnitude,
> e.g. CLFLUSHOPT can complete in 15 cycles, that's still ~1k cycles.
>
> Peter, don't we also theoretically need cond_resched() in the loops in
> sev_launch_update_data()?  AFAICT, there's no articifical restriction on the size
> of the payload, i.e. the kernel is effectively relying on userspace to not update
> large swaths of memory.

Yea we probably do want to cond_resched() in the for loop inside of
sev_launch_update_data(). Ithink in  sev_dbg_crypt() userspace could
request a large number of pages to be decrypted/encrypted for
debugging but se have a call to sev_pin_memory() in the loop so that
will have a cond_resded() inside of __get_users_pages(). Or should we
have a cond_resded() inside of the loop in sev_dbg_crypt() too?

>
> [*] https://www.agner.org/optimize/instruction_tables.pdf
