Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99A892DC3EB
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 17:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgLPQUH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 11:20:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:51036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbgLPQUG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 11:20:06 -0500
X-Gm-Message-State: AOAM531jdY6j/E1HvsiMU0fg95s4SdR4BIVEZnzT3g1weaTwCXM5FJfQ
        lc9atexYeH7px5F8HGA4dyzE0Syu5SZfKV3rP2I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608135566;
        bh=e6He3ekWHHxQXD65oTijcmijPeftY4zBgvBXqBjhqMc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NiLJCCQUNsCUhHmX0Nnd2AQ+cELTf2MZoafTB9KjPgIKXeqJmpGbqD9GXRCRk0Oy+
         9Du4SY4ffKb73699YHqPJW9pjU6xza9/a6Z/X3DQ5kaHHEG9j6iuUWlxuONN/2AUHq
         Nnt3oLj6giS0JrGP10k5/sg5YsdIchbsEwMcLzQqvkUSPwFRJLA8Hyx151GKpfMBB3
         r3XZ26P16IHVisv6T/e4uGr4pMd6VLhZby1x7Qrb2wxiJMQjALund7Juo/K8nlvuxQ
         6sFW1oPloYRuT1UHBsl/RO2/Vm/m/vEDWtkgwHyyXmOoc+OzaGoz4/aR5PTmtnbuB8
         b49oAvTfrp//w==
X-Google-Smtp-Source: ABdhPJxHqfr7b8G3mhHBUm+4LEJ54YE+wZJRJWmLsnb7Uzwy5ht+tXiGxUKVA5hFxPJn6zDGZSEbqNZbHoVpNmkqroc=
X-Received: by 2002:aca:b809:: with SMTP id i9mr2394743oif.174.1608135565285;
 Wed, 16 Dec 2020 08:19:25 -0800 (PST)
MIME-Version: 1.0
References: <MW4PR21MB1857CC85A6844C89183C93E9BFC59@MW4PR21MB1857.namprd21.prod.outlook.com>
 <20201216092649.GM3040@hirez.programming.kicks-ass.net> <20201216105926.GS3092@hirez.programming.kicks-ass.net>
 <20201216133014.GT3092@hirez.programming.kicks-ass.net> <20201216134249.GU3092@hirez.programming.kicks-ass.net>
In-Reply-To: <20201216134249.GU3092@hirez.programming.kicks-ass.net>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 16 Dec 2020 17:19:14 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFCbUSpMmX01oCskwoyHL1B+62GH7wywJnvQUzh0NdAqQ@mail.gmail.com>
Message-ID: <CAMj1kXFCbUSpMmX01oCskwoyHL1B+62GH7wywJnvQUzh0NdAqQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] jump_label/static_call: Add MAINTAINERS
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Dexuan Cui <decui@microsoft.com>, Ingo Molnar <mingo@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jessica Yu <jeyu@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jason Baron <jbaron@akamai.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 16 Dec 2020 at 14:42, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Wed, Dec 16, 2020 at 02:30:14PM +0100, Peter Zijlstra wrote:
> >
> > FWIW, I recently noticed we're not being Cc'ed on patches for this
> > stuff, so how about we do something like the below?
> >
> > Anybody holler if they don't agree with the letter assigned, or if they
> > feel they've been left out entirely and want in on the 'fun' :-)
> >
> > ---
> > Subject: jump_label/static_call: Add MAINTAINERS
> > From: Peter Zijlstra <peterz@infradead.org>
> >
> > These files don't appear to have a MAINTAINERS entry and as such
> > patches miss being seen by people who know this code.
> >
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > ---
> >  MAINTAINERS |   12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -16766,6 +16766,18 @@ M:   Ion Badulescu <ionut@badula.org>
> >  S:   Odd Fixes
> >  F:   drivers/net/ethernet/adaptec/starfire*
> >
> > +STATIC BRANCH/CALL
> > +M:   Peter Zijlstra <peterz@infradead.org>
> > +M:   Josh Poimboeuf <jpoimboe@redhat.com>
> > +M:   Jason Baron <jbaron@akamai.com>
> > +R:   Steven Rostedt <rostedt@goodmis.org>
> > +R:   Ard Biesheuvel <ardb@kernel.org>
> > +S:   Supported
>
> F:      arch/*/include/asm/jump_label*.h
> F:      arch/*/include/asm/static_call*.h
> F:      arch/*/kernel/jump_label.c
> F:      arch/*/kernel/static_call.c
>
> These too?
>

Yes, that makes sense.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
