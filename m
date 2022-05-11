Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD35F523E0B
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 21:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347312AbiEKTy5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 15:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347302AbiEKTys (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 15:54:48 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2995B980AD;
        Wed, 11 May 2022 12:54:47 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id jt15so2866079qvb.8;
        Wed, 11 May 2022 12:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5t8Oxec4sElz4YLe4jTh7Rv3M6RvFFCEE4KbIo6pKL8=;
        b=MBXjSVHkzVZt6JxWZaoB+pZZIqWUPtJJosEoEdlK0MyDi/NBw0KxmTp8xgmFOqwz/M
         DyN4Qvcr3xd8zXnIGAvuR62r1gZBpAy8HUsyUpfKnbRaQKFpBM6NXAH9lmkpLTT2Loik
         2b4vnbSnd6OQSM/V4bNuffNLQ1S9s5n/N41bUbW5H3eB5LBselEDuHZmKRgM9cHxP3zF
         SACIvZEm3VsAf2ltSKPaw7GCoNIbOdoDUYKbfU42G8/Xq0u6d2FCOtb1VjX/FDo+Vun9
         GQFV90co5X+hXQaYSwx1R0abkFxZBj1s1pyJHSuJh+Nt1FxAQUFYLe2rw8CmZhO5gfCV
         uEmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5t8Oxec4sElz4YLe4jTh7Rv3M6RvFFCEE4KbIo6pKL8=;
        b=EObN2b5tQkxXaF6pItzC4Eo96rifvRgriZ8t2M2FWQSdr/QTX4dQqE4drJXuQ6EDMc
         orz4pDFmw3swBFIKZ67vJ1sd2gh6r4OyxuG+TXQW5oKK1kQPGWyrUwSzOzTwMT0KjcTD
         L323CDrJEVHnGpDS+iFhJZegatLTpHkuDp+npUPJX+ucAD90sIHO5YlCza8lmlS5TmW4
         XYMUHn4EzvafpRcO7UxAg1RrKb4AFEyNrDdAsJaQv0keS5y0Cyv+O+bjXrcjbb42lFbl
         lXxvEuAM9+dtnoe0BwkgTTY0V8CUtjyokNEqyuaN2ipV4Y2+Lnz4+nikw4an6rSY/YyG
         lC9w==
X-Gm-Message-State: AOAM533RFucBVUrpGDf95RLbQtc/U32Y5BhlChUKgLe6RjXAVTHtS3hL
        UUaoZ2D/eSocG8elUkkfE+t8FAVIE5EVhJL+qM4=
X-Google-Smtp-Source: ABdhPJwZxJL36r3TJEuSALSFJHzcqX99I0ShUQCLsGNhbCLGwMem1HTY0+ljd7jJEvA+Kt+XjlQyyIUsqDAEdJZ4Ut4=
X-Received: by 2002:a05:6214:5189:b0:45d:d051:ea06 with SMTP id
 kl9-20020a056214518900b0045dd051ea06mr5929790qvb.2.1652298886196; Wed, 11 May
 2022 12:54:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220510154217.5216-1-ubizjak@gmail.com> <20220510165506.GP76023@worktop.programming.kicks-ass.net>
 <CAFULd4aNME5s2zGOO0A11kdjfHekH=ceSH7jUfAhmZaJWHv9cQ@mail.gmail.com>
 <20220511075409.GX76023@worktop.programming.kicks-ass.net>
 <CAFULd4aXpt_pnCR5OK5B1m5sErfB3uj_ez=-KW7=0qQheEdVzA@mail.gmail.com> <Ynven5y2u9WNfwK+@google.com>
In-Reply-To: <Ynven5y2u9WNfwK+@google.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Wed, 11 May 2022 21:54:34 +0200
Message-ID: <CAFULd4bZDO5-3T4q9fanHFrRTDj8v6fypiTc=dFPO9Rp61g9eQ@mail.gmail.com>
Subject: Re: [PATCH] locking/atomic/x86: Introduce try_cmpxchg64
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Marco Elver <elver@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 11, 2022 at 6:04 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, May 11, 2022, Uros Bizjak wrote:
> > On Wed, May 11, 2022 at 9:54 AM Peter Zijlstra <peterz@infradead.org> wrote:
> > > Still, does 32bit actually support that stuff?
> >
> > Unfortunately, it does:
> >
> > kvm-intel-y        += vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
> >                vmx/evmcs.o vmx/nested.o vmx/posted_intr.o
> >
> > And when existing cmpxchg64 is substituted with cmpxchg, the
> > compilation dies for 32bits with:
>
> ...
>
> > > Anyway, your patch looks about right, but I find it *really* hard to
> > > care about 32bit code these days.
> >
> > Thanks, this is also my sentiment, but I hope the patch will enable
> > better code and perhaps ease similar situation I have had elsewhere.
>
> IMO, if we merge this it should be solely on the benefits to 64-bit code.  Yes,
> KVM still supports 32-bit kernels, but I'm fairly certain the only people that
> run 32-bit KVM are KVM developers.  32-bit KVM has been completely broken for
> multiple releases at least once, maybe twice, and no one ever complained.

Yes, the idea was to improve cmpxchg64 with the implementation of
try_cmpxchg64 for 64bit targets. However, the issue with 32bit targets
stood in the way, so the effort with 32-bit implementation was mainly
to unblock progression for 64-bit targets.

Uros.
