Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3762945241A
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 02:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354286AbhKPBft (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 20:35:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242935AbhKOSsN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 13:48:13 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6836EC036F93
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 09:51:16 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id bf8so36470333oib.6
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 09:51:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9xlnMRyeRrwqZbGMs0R7rHUJzwnKp9w0F+3XQjwF9Zk=;
        b=KkGPReuch8Z8/OVUCdA+5RNJfCLXCRJk2wbcjnp6w8fmmj5flUtPlUclw8oyGHS1NB
         KZkkJSCa3BtwtOrfMVzRkiohuTBdhDMy6XHEmQye6x9sAMW6c9ojBRLB6JttzpqFfoER
         ftXuStR98AI+P6OCfBFxLaAyVShQChyPGhcfiGm891MCUeB0zudZsAhNqNze9j/blm9v
         tL1Yxq8MkIWziZ563wIiIXzxt9Ep+szE3REup1IyZhT2goWqa1ia2iPo2sTsibhpGrFj
         f3O9T3jjkl0RHMVeXh0VjWc81uniGK65Z3H8zf5JYSVsslFaqF7iz6YGjd8g2iMzf+9A
         2WAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9xlnMRyeRrwqZbGMs0R7rHUJzwnKp9w0F+3XQjwF9Zk=;
        b=dmlicTXsxf0K7Z6eIJh+bFVqSsJt/dTgCzkKqULWcnEZkXXZ89j40bi8SpYJAZj/00
         9CF4CoWtWA+qI1u2CkR52sa1uyOme8bbQHF89vQtGgd5/CmjQQK1j/F3xohcOo+AobG2
         LtyLEq0epW2KOp/1mYnIWoYyh7HGJN92aA6rTVoWKMwORK2qm9+31tQfz13guBvJKVTh
         59HIuK2jgrGtsIR2hjBqRhx2SAfOzsYBNoGvNCwjT/2ypGZnRERi+iiVdHlkW4Ni0NIh
         eo60VLILANCWJSAWSQQmK4X8YHpcVi3EhC+VcVV3BR8S8Plttv8TrhSjq3TrRgEufnbw
         gOww==
X-Gm-Message-State: AOAM53337K/gRMp7iDAWc34E2eSOO9Te4ScgD12oBoTEJ5XMNOnSkbsj
        xGQJeKmMBASFt3efUqGseiSpdfC8W8DgFVx9HR/YDA==
X-Google-Smtp-Source: ABdhPJxN2cbfAn0wDKGPhacJ+VB/zVS9wH5tOXzJVnghC4nr/Z3n/IovkyYexDgrP+6puBqr5B0Gv8mQJzKHBzokTBo=
X-Received: by 2002:aca:3055:: with SMTP id w82mr44473114oiw.2.1636998675456;
 Mon, 15 Nov 2021 09:51:15 -0800 (PST)
MIME-Version: 1.0
References: <20211112235235.1125060-1-jmattson@google.com> <d4f3b54a-3298-cec3-3193-da46ae9a1f09@gmail.com>
In-Reply-To: <d4f3b54a-3298-cec3-3193-da46ae9a1f09@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 15 Nov 2021 09:51:04 -0800
Message-ID: <CALMp9eQ+dy4TmuNRDipN6XWb4Q0KoEMv6u+-E8b4ypbkpJxdXA@mail.gmail.com>
Subject: Re: [PATCH 0/2] kvm: x86: Fix PMU virtualization for some basic events
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     kvm@vger.kernel.org,
        "Inc. (kernel-recipes.org)" <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 14, 2021 at 7:43 PM Like Xu <like.xu.linux@gmail.com> wrote:
>
> On 13/11/2021 7:52 am, Jim Mattson wrote:
> > Google Cloud has a customer that needs accurate virtualization of two
> > architected PMU events on Intel hardware: "instructions retired" and
> > "branch instructions retired." The existing PMU virtualization code
> > fails to account for instructions that are emulated by kvm.
>
> Does this customer need to set force_emulation_prefix=Y ?

No. That module parameter does make it easier to write the test, though.

It's possible that the L0 hypervisor will never emulate a branch
instruction for this use case. However, since the code being
instrumented is potential malware, one can't make the usual
assumptions about "well-behaved" code. For example, it is quite
possible that the code in question deliberately runs with the TLBs and
in-memory page tables out of sync. Therefore, it's hard to prove that
the "branch instructions retired" patch isn't needed.

> Is this "accurate statistics" capability fatal to the use case ?

Yes, that is my understanding.

> >
> > Accurately virtualizing all PMU events for all microarchitectures is a
> > herculean task, but there are only 8 architected events, so maybe we
> > can at least try to get those right.
>
> I assume you mean the architectural events "Instruction Retired"
> and "Branch Instruction Retired" defined by the Intel CPUID
> since it looks we don't have a similar concept on AMD.

Yes.

> This patch set opens Pandora's Box, especially when we have
> the real accurate Guest PEBS facility, and things get even
> more complicated for just some PMU corner use cases.

KVM's PMU virtualization is rife with bugs, but this patch set doesn't
make that worse. It actually makes things better by fixing two of
those bugs.

> >
> > Eric Hankland wrote this code originally, but his plate is full, so
> > I've volunteered to shepherd the changes through upstream acceptance.
>
> Does Eric have more code to implement
> accurate virtualization on the following events ?

No. We only offer PMU virtualization to one customer, and that
customer is only interested in the two events addressed by this patch
set.

> "UnHalted Core Cycles"
> "UnHalted Reference Cycles"
> "LLC Reference"
> "LLC Misses"
> "Branch Misses Retired"
> "Topdown Slots" (unimplemented)
>
> Obviously, it's difficult, even absurd, to emulate these.

Sorry; I should not have mentioned the eight architected events. It's
not entirely clear what some of these events mean in a virtual
environment. Let's just stick to the two events covered by this patch
set.

> > Jim Mattson (2):
> >    KVM: x86: Update vPMCs when retiring instructions
> >    KVM: x86: Update vPMCs when retiring branch instructions
> >
> >   arch/x86/kvm/emulate.c     | 57 +++++++++++++++++++++-----------------
> >   arch/x86/kvm/kvm_emulate.h |  1 +
> >   arch/x86/kvm/pmu.c         | 31 +++++++++++++++++++++
> >   arch/x86/kvm/pmu.h         |  1 +
> >   arch/x86/kvm/vmx/nested.c  |  6 +++-
> >   arch/x86/kvm/x86.c         |  5 ++++
> >   6 files changed, 75 insertions(+), 26 deletions(-)
> >
