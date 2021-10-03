Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39DE3420387
	for <lists+kvm@lfdr.de>; Sun,  3 Oct 2021 21:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbhJCTMq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Oct 2021 15:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbhJCTMp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Oct 2021 15:12:45 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06026C0613EC
        for <kvm@vger.kernel.org>; Sun,  3 Oct 2021 12:10:58 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id b20so62627780lfv.3
        for <kvm@vger.kernel.org>; Sun, 03 Oct 2021 12:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fdrFUv4MJhSYnTwW7FieR5I+UW7WAn8vEjCCBBzPFn0=;
        b=ACmnvGRojodPlQTW4VdzIJip0rrYahMQUY7hRB6fIioy+TQlXtTmVerLmSOj5FSeAH
         tasPXIFb6jhU+OK8S5pnaGMzPi65WkBY1ajRiq7OXNGXCV3wWSKNrNraE8I65cd2Y063
         5knhoueIWAAKBH2Q7SbXSG970nQS8TdBubWK8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fdrFUv4MJhSYnTwW7FieR5I+UW7WAn8vEjCCBBzPFn0=;
        b=ozOpQV+aKPBJkBrl7G3GylXPjZD2l9G58BYTD4H6VbHXrqMdDXvgph9BwkQTGb40Qn
         Y8SP02hKPcitv5PwNXsc4ifAmmc5hT2Q6MV8iL0SwIOSnOE6bfWul2jiRwLmChlOFu5P
         JhL4LiU2GBT9uziIfXIU3RaZBzz9RxAdNfCLO7TlvtqjWh8S80O5pwH1tfd5qNTuRTBG
         MvLPtMNqy1CSeJvCalaxFvOJb3R6MJi9jbXPwhL4T0s5NaghRscyKsXSoJm9oZ8xvEDW
         m2rltKZLhRsf76/BQC+LokyQlG7ghCEv+TCTOd5FYMQ/HbMS3G5Q5oQko8bf1OuCXiXl
         s7LQ==
X-Gm-Message-State: AOAM533eeVUrPkCB8PGRguCoZecdFXkBbxLUL6exitFQ/BgZn3tv+UrO
        GjAr2ePvQ+GGAMXJS8PBUMedxw37karCC/nd
X-Google-Smtp-Source: ABdhPJykDzrA3nMTX2DsveDSu9Tzg9L+k+r9WtNeVCrewToGgJlG4e8ye8+5j+q0AvyPbSwStBpFNQ==
X-Received: by 2002:a2e:a409:: with SMTP id p9mr11839521ljn.324.1633288255989;
        Sun, 03 Oct 2021 12:10:55 -0700 (PDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id i29sm471406lfp.204.2021.10.03.12.10.54
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Oct 2021 12:10:54 -0700 (PDT)
Received: by mail-lf1-f53.google.com with SMTP id e15so62324689lfr.10
        for <kvm@vger.kernel.org>; Sun, 03 Oct 2021 12:10:54 -0700 (PDT)
X-Received: by 2002:a05:6512:12c4:: with SMTP id p4mr10648009lfg.280.1633288253969;
 Sun, 03 Oct 2021 12:10:53 -0700 (PDT)
MIME-Version: 1.0
References: <YVl7RR5NcbPyiXgO@zn.tnic> <CAHk-=wh9JzLmwAqA2+cA=Y4x_TYNBZv_OM4eSEDFPF8V_GAPug@mail.gmail.com>
 <CAHk-=wiZwq-0LknKhXN4M+T8jbxn_2i9mcKpO+OaBSSq_Eh7tg@mail.gmail.com>
In-Reply-To: <CAHk-=wiZwq-0LknKhXN4M+T8jbxn_2i9mcKpO+OaBSSq_Eh7tg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 3 Oct 2021 12:10:38 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjtJ532TqnLN+CLqZJXx=MWHjQqi0-fR8PSQ-nGZ_iMvg@mail.gmail.com>
Message-ID: <CAHk-=wjtJ532TqnLN+CLqZJXx=MWHjQqi0-fR8PSQ-nGZ_iMvg@mail.gmail.com>
Subject: Re: [GIT PULL] objtool/urgent for v5.15-rc4
To:     Borislav Petkov <bp@suse.de>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>
Cc:     x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replying to myself just to add more proper people to the cc.

I'm also wondering how I could possibly be the only person who saw the warning.

I don't think I am, and I think that people who signed off on commit
24ff65257375 ("objtool: Teach get_alt_entry() about more relocation
types") and claimed to have "tested" it, clearly didn't actually do
so.

PeterZ/Josh/Nathan: see the thread at

   https://lore.kernel.org/lkml/CAHk-=wiZwq-0LknKhXN4M+T8jbxn_2i9mcKpO+OaBSSq_Eh7tg@mail.gmail.com/

if you need more context, but I suspect you can figure it out just
from this email too.

              Linus

On Sun, Oct 3, 2021 at 12:02 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sun, Oct 3, 2021 at 11:38 AM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Looking at the kvm code, that kvm_fastop_exception thing is some funky sh*t.
> >
> > I _think_ the problem is that 'kvm_fastop_exception' is done with bare
> > asm at the top-level and that triggers some odd interaction with other
> > section data, but I really don't know.
>
> No, it's the fact that it is marked as a global function (why?) that
> it then causes problems.
>
> Now, I don't actually see why it would cause problems (the same way I
> don't see why it's marked global). But removing that
>
>      ".global kvm_fastop_exception \n"
>
> works.
>
> I suspect it makes the linker do the relocation for us before objtool
> runs, because now that it's a local name, there is no worry about
> multiply defined symbols of the same name or anything like that.
>
> I also suspect that the reason for the warning is that the symbol type
> has never been declared, so it's not marked as a STT_FUNC in the
> relocation information.
>
> So independently of this kvm_fastop_exception issue, I'd suggest the
> attached patch for objtool to make the warning more informative for
> people who try to debug this.
>
> So I have a fix ("remove the global declaration"), but I really don't
> like how random this is.
>
> I also tried to instead keep the symbol global, and just mark
> kvm_fastop_exception as a function (and add the proper size
> annotation), but that only causes more objtool warnings for the
> (generated asm) functions that *use* that symbol. Because they also
> don't seem to be properly annotated.
>
> Again, removing the global annotation works around the problem, but
> the real underlying issue does seem to be that "funky sh*t" going on
> in arch/x86/kvm/emulate.c.
>
> So I'd like more people to look at this.
>
> In the meantime, I think the exception handling for kvm
> divide/multiply emulation is badly broken right now. Hmm?
>
>                 Linus
