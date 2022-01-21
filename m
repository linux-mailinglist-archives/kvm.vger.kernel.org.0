Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B41A6496577
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 20:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbiAUTMT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 14:12:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiAUTMS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 14:12:18 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A16DC06173B
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 11:12:18 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id h14so30224771ybe.12
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 11:12:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9s//Ke6XVp/BFtyxa2zRwkd1F0XoucRgvD4MGu7oJe4=;
        b=WZ+SYoyd5jOVdb6zNfY7s7A+pH7BJGfMvy/gpYcs0XN7z8mS4oFSuHxL72kDr5qrb7
         0ICMKQPCeYWCp9Dd8kzr6U/xCUs0b1QYzVhMyeNOfKQzeAyXLzkyWcnH6jVPyQ6Oll54
         WzLCautazM9iZ3jvCbHmuAzV/ptXCDjvFCgIbqtoiidssZS1AhJNc+alBNW9GLeXGczL
         0wzVEWg5BBPVPecoWTEBV07a1H6f8dWUrkVgupzTXeHjgPmRilNX+E/QiYGcQnAl0p06
         3PIQS/DefEI3SfaRQCLFlkjzF47riGlDOnBlkUQFLvEs351ueh/vm8hqlCwj63TDy/JA
         lnnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9s//Ke6XVp/BFtyxa2zRwkd1F0XoucRgvD4MGu7oJe4=;
        b=Wse2wZJc6FZA6CjZWc0o/B3mVTpS8tOWchf+1wYzwaziIPhmsPMSR26zEBMqOX81zL
         Ju6U+zJqEgNa1nMDYkAS4CN0yO/wwxFKhRHj6vm+elBMsNzKZ2rRqZ7idIFoBOMImoJX
         2zON56SLey/fMEYAzEyNg45gsCghWZA423494Z3j74YICYoP63mhapYR8ifIPVzjlC+r
         ZKJgZVv1iS5IzoPbYtv0gz5AKEA3Bg0WtHV28Lj5ECn57jgA9Q5EZLudOXCSn/KPrpnm
         zsWf1lkNUks3mh4ZEg3ZlOxvqSnxRAtppNFfob33lhQUlVyltXyGCgoURqJYu5oIHbn5
         /oeA==
X-Gm-Message-State: AOAM531jnqEwwwXBVBQsP5dkF5EU8QGAhLd+MMJLJbk7+Slo1sTywA1h
        MYPC/yWEolHSlFQ0KVo3IcWkk74Oyy1Gd/ZaPa0ASg==
X-Google-Smtp-Source: ABdhPJw0IX097xeTBOPoA1sndovvtYOnVG7MqkMeCM6gXFlVBaewFQkRdaPj1BUPjy4Y87YrBxIxu88WkOrKjglXi4k=
X-Received: by 2002:a25:264e:: with SMTP id m75mr7767041ybm.31.1642792337129;
 Fri, 21 Jan 2022 11:12:17 -0800 (PST)
MIME-Version: 1.0
References: <20220121155855.213852-1-aaronlewis@google.com>
 <20220121155855.213852-4-aaronlewis@google.com> <Yer0oCazOfKXs4t3@google.com>
In-Reply-To: <Yer0oCazOfKXs4t3@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Fri, 21 Jan 2022 11:12:05 -0800
Message-ID: <CAAAPnDEgV5HYeqE+pFRdZ4b6y1VMhwv=aXWVGWHS4M84-w5LHQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v4 3/3] x86: Add test coverage for
 nested_vmx_reflect_vmexit() testing
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 21, 2022 at 10:00 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Jan 21, 2022, Aaron Lewis wrote:
> > Add a framework and test cases to ensure exceptions that occur in L2 are
> > forwarded to the correct place by nested_vmx_reflect_vmexit().
> >
> > Add testing for exceptions: #GP, #UD, #DE, #DB, #BP, and #AC.
> >
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > Change-Id: I0196071571671f06165983b5055ed7382fa3e1fb
>
> Don't forget to strip the Change-Id before posting.

D'oh... Good catch.

>
> > ---
> >  x86/unittests.cfg |   9 +++-
> >  x86/vmx_tests.c   | 129 ++++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 137 insertions(+), 1 deletion(-)
> >
> > diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> > index 9a70ba3..6ec7a98 100644
> > --- a/x86/unittests.cfg
> > +++ b/x86/unittests.cfg
> > @@ -288,7 +288,7 @@ arch = i386

> > +[vmx_exception_test]
> > +file = vmx.flat
> > +extra_params = -cpu max,+vmx -append vmx_exception_test
> > +arch = x86_64
> > +groups = vmx nested_exception
> > +timeout = 10
>
> Leave this out (for now), including it in the main "vmx" test is sufficient.
> I'm definitely in favor of splitting up the "vmx" behemoth, but it's probably
> best to do that in a separate commit/series so that we can waste time bikeshedding
> over how to organize things :-)
>

Why leave this out when vmx_pf_exception_test, vmx_pf_no_vpid_test,
vmx_pf_invvpid_test, and vmx_pf_vpid_test have their own?  They seem
similar to me.

> > +
> > +static uint64_t usermode_callback(void)
> > +{
> > +     /* Trigger an #AC by writing 8 bytes to a 4-byte aligned address. */
> > +     asm volatile(
> > +             "sub $0x10, %rsp\n\t"
> > +             "movq $0, 0x4(%rsp)\n\t"
> > +             "add $0x10, %rsp\n\t");
>
> Sorry, didn't look closely at this before.  This can simply be:
>
>         asm volatile("movq $0, 0x4(%rsp)\n\t");
>
> as the access is expected to fault.  Or if you want to be paranoid about not
> overwriting the stack:
>
>         asm volatile("movq $0, -0x4(%rsp)\n\t");
>
> It's probably also a good idea to call out that the stack is aligned on a 16-byte
> boundary.  If you were trying to guarnatee alignment, then you would need to use
> AND instead of SUB.  E.g.
>
>         asm volatile("push  %rbp\n\t"
>                      "movq  %rsp, %rbp\n\t"
>                      "andq  $-0x10, %rsp\n\t"
>                      "movq  $0, -0x4(%rsp)\n\t"
>                      "movq  %rbp, %rsp\n\t"
>                      "popq  %rbp\n\t");
>
> But my vote would be to just add a comment, I would consider it a test bug if the
> stack isn't properly aligned.
>

I can improve the comment, and I agree that it would be a test bug if
the stack isn't properly aligned.

I'll switch this to using the more paranoid approach if I'm not going
to modify RSP.

> > +
> > +     return 0;
> > +}
> > +
