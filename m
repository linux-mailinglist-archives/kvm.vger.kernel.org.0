Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D703E4A32
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 18:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233411AbhHIQrh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 12:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233083AbhHIQrg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 12:47:36 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58ABAC0613D3
        for <kvm@vger.kernel.org>; Mon,  9 Aug 2021 09:47:16 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id o20so24378358oiw.12
        for <kvm@vger.kernel.org>; Mon, 09 Aug 2021 09:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4Q4zxO7vdS8HSQuned3Ij+Zp035NjsUriOcL/f8N/vE=;
        b=j2NpvGoKzxZPRA+ABQcxnU1qZrlIAbco1aqaPepiA06jVBmXNDE1AMHKWODflPyxkt
         /2Sz1Zy4PGSj4dpl8ohZRQSyzJ1mhEAaNeogwo9pI6Y9jnSMis3QEczWoadtCDGR6l0H
         DEj7QhwSxVR/qaNumhl1Nb82dI7xD0YkQgMKxpTkmsytsoifq0Ig/wQmrIcLjUha8Wv9
         LyZFbV1lmp7stjsluzC8e5g8wGtdcHCfZ8r4hDVCpZwTue5GNG5PjqqD+GyU3q3zScOO
         SDti6XDZWG983fcO7y3LnKW2YsLjqVio4FX+bqFrKnCIH4Kq09N1Wps2Etv4XpOEH0c5
         joWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4Q4zxO7vdS8HSQuned3Ij+Zp035NjsUriOcL/f8N/vE=;
        b=IM8mKwuuF214kkbLO++l4QV4Ez80esbRL8WBaYHGivvdG/NHL9s9hR4soir3+LC88C
         /DLk8po9ds3YVk+FDdu6bbGwPevzprRgKhYbQgh7KfDLQwJzTvlQWPQ873Wj47AGxyW2
         Ib21P7fEt5hl54jpIyUJp5XUBMqqn7qIQ+lAQrd68nn4Y/l5qMi0dAWIwbLGpEa6YLsA
         heRBDxK7CbRWWGGPI8ZCg3VSvCdrCph366LirXKXh6flJJKwaPaj0jE3dDbKF0wi2OR/
         +/JMUGNEK+XT2mpf4Frf7eKj7IHriTaPk/CJG6OCVBP0OddIRaDFEiSrHhVkjQD3UoRk
         e24A==
X-Gm-Message-State: AOAM532sWgvHq5Mt/qSQEUAoHnlpfwGShR45laEVgctnTWgsuGa2s3gn
        vL4WpuGX37xqBwmoGglfDTPZM9Aa1unEJzGAiaX2EA==
X-Google-Smtp-Source: ABdhPJwgSuZYBnqb3tIFQyk4qh0XbxDhU7djxzN8HiAnNxkgxx5IIQ14tSytznaExbjZGBhrwxClrKDH/W7N/TOsSC8=
X-Received: by 2002:aca:6704:: with SMTP id z4mr38751oix.13.1628527635519;
 Mon, 09 Aug 2021 09:47:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210713142023.106183-1-mlevitsk@redhat.com> <20210713142023.106183-9-mlevitsk@redhat.com>
 <c51d3f0b46bb3f73d82d66fae92425be76b84a68.camel@redhat.com>
 <YPXJQxLaJuoF6aXl@google.com> <564fd4461c73a4ec08d68e2364401db981ecba3a.camel@redhat.com>
 <YQ2vv7EXGN2jgQBb@google.com> <5f991ac11006ae890961a76d35a63b7c9c56b47c.camel@redhat.com>
In-Reply-To: <5f991ac11006ae890961a76d35a63b7c9c56b47c.camel@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 9 Aug 2021 09:47:04 -0700
Message-ID: <CALMp9eRxthu+5NMRTL4+NtcsAcMyYmLiQs4Get5=UAAH_yqH=w@mail.gmail.com>
Subject: Re: KVM's support for non default APIC base
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 9, 2021 at 2:40 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
>
> On Fri, 2021-08-06 at 21:55 +0000, Sean Christopherson wrote:
> > On Thu, Jul 22, 2021, Maxim Levitsky wrote:
> > > On Mon, 2021-07-19 at 18:49 +0000, Sean Christopherson wrote:
> > > > On Sun, Jul 18, 2021, Maxim Levitsky wrote:
> > > -> APIC MMIO area has to be MMIO for 'apic_mmio_write' to be called,
> > >    thus must contain no guest memslots.
> > >    If the guest relocates the APIC base somewhere where we have a memslot,
> > >    memslot will take priority, while on real hardware, LAPIC is likely to
> > >    take priority.
> >
> > Yep.  The thing that really bites us is that other vCPUs should still be able to
> > access the memory defined by the memslot, e.g. to make it work we'd have to run
> > the vCPU with a completely different MMU root.
> That is something I haven't took in the account.
> Complexity of supporting this indeed isn't worth it.
>
> >
> > > As far as I know the only good reason to relocate APIC base is to access it
> > > from the real mode which is not something that is done these days by modern
> > > BIOSes.
> > >
> > > I vote to make it read only (#GP on MSR_IA32_APICBASE write when non default
> > > base is set and apic enabled) and remove all remains of the support for
> > > variable APIC base.
> >
> > Making up our own behavior is almost never the right approach.  E.g. _best_ case
> > scenario for an unexpected #GP is the guest immediately terminates.  Worst case
> > scenario is the guest eats the #GP and continues on, which is basically the status
> > quo, except it's guaranteed to now work, whereas todays behavior can at least let
> > the guest function, for some definitions of "function".
>
> Well, at least the Intel's PRM does state that APIC base relocation is not guaranteed
> to work on all CPUs, so giving the guest a #GP is like telling it that current CPU doesn't
> support it. In theory, a very well behaving guest can catch the exception and
> fail back to the default base.
>
> I don't understand what do you mean by 'guaranteed to now work'. If the guest
> ignores this #GP and still thinks that APIC base relocation worked, it is its fault.
> A well behaving guest should never assume that a msr write that failed with #GP
> worked.
>
>
> >
> > I think the only viable "solution" is to exit to userspace on the guilty WRMSR.
> > Whether or not we can do that without breaking userspace is probably the big
> > question.  Fully emulating APIC base relocation would be a tremendous amount of
> > effort and complexity for practically zero benefit.
>
> I have nothing against this as well although I kind of like the #GP approach a bit more,
> and knowing that there are barely any reasons
> to relocate the APIC base, and that it doesn't work well, there is a good chance
> that no one does it anyway (except our kvm unit tests, but that isn't an issue).
>
> >
> > > (we already have a warning when APIC base is set to non default value)
> >
> > FWIW, that warning is worthless because it's _once(), i.e. won't help detect a
> > misbehaving guest unless it's the first guest to misbehave on a particular
> > instantiation of KVM.   _ratelimited() would improve the situation, but not
> > completely eliminate the possibility of a misbehaving guest going unnoticed.
> > Anything else isn't an option becuase it's obviously guest triggerable.
>
> 100% agree.
>
> I'll say I would first make it _ratelimited() for few KVM versions, and then
> if nobody complains, make it a KVM internal error / #GP, and remove all the leftovers
> from the code that pretend that it can work.

Printing things to syslog is not very helpful. Any time that kvm
violates the architectural specification, it should provide
information about the emulation error to userspace.
