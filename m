Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A52345394C
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 19:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239362AbhKPSTf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 13:19:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbhKPSTe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 13:19:34 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0410EC061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 10:16:37 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id y26so55526665lfa.11
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 10:16:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wD4FHaq/A31lK/F/hM3HFoBBxkhquyn2APzkV6254nc=;
        b=rGrA37i63tbk+RPlyXgWrmx2if/sLivGebBLR5iAG68tirdyCcGo3fixQJpJp3hdRN
         cWJwr1UwAxLsrqe0aOsa8zoLlTilWf2OWjIut5lqBRPHwraYM7e7/8ag4qzsNOkJ3zoQ
         twHbTUz/JcFB1OKnimgjPjuoLXoZS3D753rPo9rjRX6xKJt5vaemP+PTIMIlpY6uFdUq
         2PJ+vJV0yYoUYUfvTzbBNrwtZ5evQU4qwhzn/+3MqlR6xJwwV2uHrLsJf/ewTfsEYV86
         /wtMEJXHUhi9B8Unf2MkyxYvgZ8htvkg7r+VaV6y/0YrhZvspPeMu0i3AbyiaBa4fZBc
         Wf5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wD4FHaq/A31lK/F/hM3HFoBBxkhquyn2APzkV6254nc=;
        b=otAb6J/I/ZOgmiPso80nwDzqqAj1lW6hM2JYfe3QbnasQRgg3TtqrHay+zsrL0AtC1
         k4bFks7YH7SChpU6vtzo2sGONyp6wb+/AJg93N0sqcOcPy+pDkB2QdSxBWhXSM0ea3np
         yTlUP2Lu+9YBZsKtwgqWitEiMlf2fhLa9X3FqvQygwoHeBL3JSK3hnKKKEj10ku7amx4
         MaQKxlIleeQ/zaxZxVH0ta2FJ55Q8BIv1LsmNmlA7JlYe3Zzakar/n5DvGAKm55Tp2w4
         X+VwjHpEQeSCpBLTfE0Y8Gbpcl3IMJMPmMFWGzPtbqG7uSDRY2nADXlxEVoMGyomGi3V
         8nJQ==
X-Gm-Message-State: AOAM530VFoQlbslnIBhhNuCeMBxqCNIXHoquEKUuXQhvrL6nG9jcunt8
        50VW2eGfvSoKOn9yw4R/R04alRX2dHXwYl+CxNErfw==
X-Google-Smtp-Source: ABdhPJz22M5YHyoZufeoG88HGxpDeWcfc9qHrxrb/dVyH0ozZxs2JGFSJRmo2M32UCRrmxCQ+fJO5I5u1DpyGu/dHWE=
X-Received: by 2002:a05:6512:3d16:: with SMTP id d22mr8286468lfv.523.1637086595150;
 Tue, 16 Nov 2021 10:16:35 -0800 (PST)
MIME-Version: 1.0
References: <20211114164312.GA28736@makvihas> <87o86leo34.fsf@redhat.com> <04b7e240-8e1d-1402-3cef-e65469bd9317@redhat.com>
In-Reply-To: <04b7e240-8e1d-1402-3cef-e65469bd9317@redhat.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 16 Nov 2021 10:16:22 -0800
Message-ID: <CAKwvOdmy6Fo-FvximsRN+i0sZ5ZgWjWdD-m2fLN-rhvBuqO9mw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: fix cocci warnings
To:     Paolo Bonzini <pbonzini@redhat.com>,
        David Bolvansky <david.bolvansky@gmail.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vihas Mak <makvihas@gmail.com>, seanjc@google.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 16, 2021 at 1:50 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 11/15/21 10:59, Vitaly Kuznetsov wrote:
> > One minor remark: 'kvm_set_pte_rmapp()' handler is passed to
> > 'kvm_handle_gfn_range()' which does
> >
> >          bool ret = false;
> >
> >          for_each_slot_rmap_range(...)
> >                  ret |= handler(...);
> >
> > and I find '|=' to not be very natural with booleans. I'm not sure it's
> > worth changing though.
>
> Changing that would be "harder" than it seems because "ret = ret ||
> handler(...)" is wrong, and "|" is even more unnatural than "|=" (so
> much that clang warns about it).
>
> In fact I wonder if "|=" with a bool might end up warning with clang,
> which we should check before applying this patch.  It doesn't seem to be
> in the original commit[1], but better safe than sorry: Nick, does clang
> intend to warn also about "ret |= fn()" and "ret &= fn()"?  Technically,
> it is a bitwise operation with side-effects in the RHS.

I think that warning had more to due with typo's where `||` or `&&`
was meant (to short circuit the side effects) but `|` or `&` was typed
by accident, keeping both side effects.  I'm not sure what the typo
would be in `ret |= fn();`.

>
> Paolo
>
> [1] https://github.com/llvm/llvm-project/commit/f59cc9542bfb461
>


-- 
Thanks,
~Nick Desaulniers
