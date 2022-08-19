Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7C159A508
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 20:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350628AbiHSSBq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 14:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351889AbiHSSAz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 14:00:55 -0400
X-Greylist: delayed 141 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 19 Aug 2022 10:48:06 PDT
Received: from condef-02.nifty.com (condef-02.nifty.com [202.248.20.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B642E15714
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 10:48:06 -0700 (PDT)
Received: from conssluserg-05.nifty.com ([10.126.8.84])by condef-02.nifty.com with ESMTP id 27JHgP1R007754
        for <kvm@vger.kernel.org>; Sat, 20 Aug 2022 02:42:25 +0900
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42]) (authenticated)
        by conssluserg-05.nifty.com with ESMTP id 27JHg1Wr019732;
        Sat, 20 Aug 2022 02:42:02 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-05.nifty.com 27JHg1Wr019732
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1660930922;
        bh=KG4FLh078Vt2N1P5TXYssv5+zwbnf0PgknkaoFYzijQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BtK+lTo6jtk9HhWaLKAFv1J+Pxi40MSQyuMSytde6Hafttt6P5JVWM7zdjnpDNxVT
         NewWzYNDiD5qQyHE4NR4TnA9Zocv3UOwNOW1Nq4yUEv4hzV79HximvkIbwSKtF1k1d
         ITUi37/73G//MtWqDGIA4DSZgbHyCz7nXeFzsW8ZI6vMQLbu/kYgdmQfXBOtxG3+jx
         0RHlJavErvZwJXLxlXLD+N/GQM1QOxve5dpmrdGmIJ4446Uz3PM5yUGsmMldcNR74l
         udkQU1nd/UTzBfYiHaxkMg2Fh3gr9IaSPiqHzSLtS4RGCBC/AWgGMnD9++tCrrKa1Z
         geLV0OAGvL4qA==
X-Nifty-SrcIP: [209.85.221.42]
Received: by mail-wr1-f42.google.com with SMTP id e20so5467972wri.13;
        Fri, 19 Aug 2022 10:42:01 -0700 (PDT)
X-Gm-Message-State: ACgBeo2m2xTQ1CUx5++q2LZpNp89ezWgcErbIR0EVfWqDjemRFP1B2Nq
        CZ5NO/ZmNXxqCY8HpN1mXcdWyaF6Od5ccKQVrmo=
X-Google-Smtp-Source: AA6agR5fCqfs4m8WbADmO1+mqZqUkCCpgFYtSaoGfgziW6XZ+xfPlfuOsNgaVbqrBz5UOgCA97JrOvd/Jx2BBndK1wE=
X-Received: by 2002:a5d:588f:0:b0:220:761a:6894 with SMTP id
 n15-20020a5d588f000000b00220761a6894mr4967512wrf.406.1660930920162; Fri, 19
 Aug 2022 10:42:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220819170053.2686006-1-ndesaulniers@google.com>
 <Yv/Ff3mAfyCeWtmo@mail.local> <CAKwvOdnCGywz02Mf220njrS16fm4vTnFRFKALtJCqMbQY8Xz_w@mail.gmail.com>
In-Reply-To: <CAKwvOdnCGywz02Mf220njrS16fm4vTnFRFKALtJCqMbQY8Xz_w@mail.gmail.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Sat, 20 Aug 2022 02:41:13 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQy66UAWy+tyLYpzf51brdwVESAK8igcHud=4=-v5QxmQ@mail.gmail.com>
Message-ID: <CAK7LNAQy66UAWy+tyLYpzf51brdwVESAK8igcHud=4=-v5QxmQ@mail.gmail.com>
Subject: Re: [PATCH] Kconfig: eradicate CC_HAS_ASM_GOTO
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-um@lists.infradead.org, kvm@vger.kernel.org,
        clang-built-linux <llvm@lists.linux.dev>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Aug 20, 2022 at 2:28 AM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> On Fri, Aug 19, 2022 at 10:16 AM Alexandre Belloni
> <alexandre.belloni@bootlin.com> wrote:
> >
> > On 19/08/2022 10:00:53-0700, Nick Desaulniers wrote:
> > > GCC has supported asm goto since 4.5, and Clang has since version 9.0.0.
> > > The minimum supported versions of these tools for the build according to
> > > Documentation/process/changes.rst are 5.1 and 11.0.0 respectively.
> > >
> > > Remove the feature detection script, Kconfig option, and clean up some
> > > fallback code that is no longer supported.
> > >
> > > The removed script was also testing for a GCC specific bug that was
> > > fixed in the 4.7 release.
> > >
> > > The script was also not portable; users of Dash shell reported errors
> > > when it was invoked.
> > >
> >
> > To be clear, the script was portable, what is not working with dash is
> > the current detection of CC_HAS_ASM_GOTO_TIED_OUTPUT. I'll try the other
> > suggestion from Masahiro.
>
> Ah, that was his point about echo; that makes more sense.
>
> Unless a v2 is required, perhaps Masahiro would be kind enough to drop
> this sentence from the commit message when applying?

I can if there is nothing else to fix.


And, Alexandre's Reported-by is irrelevant.

As for the subject prefix "Kconfig:",
I prefer something else, for example,
"asm goto:" or "jump label:".

I want to reserve "Kconfig:" for changes in scripts/kconfig/.


>
> >
> > > --- a/arch/x86/include/asm/cpufeature.h
> > > +++ b/arch/x86/include/asm/cpufeature.h
> > > @@ -155,11 +155,11 @@ extern void clear_cpu_cap(struct cpuinfo_x86 *c, unsigned int bit);
> > >
> > >  #define setup_force_cpu_bug(bit) setup_force_cpu_cap(bit)
> > >
> > > -#if defined(__clang__) && !defined(CONFIG_CC_HAS_ASM_GOTO)
> > > +#if defined(__clang__) && __clang_major__ < 9
> >
> > Shouldn't we simply mandates clang >= 9 and drop the whole section? This
> > is what you do later on.
>
> I considered it, but I don't think it would be safe to do so in this
> header.  If you look at the comment block below it, it mentions that
> these kernel headers are being sucked into UAPI headers that are used
> outside of the kernel builds, such as when building eBPF programs.  So
> we don't know what userspace tools might be consuming these headers.
> The original intent of the guard was to not break eBPF compilation
> with older clang releases, so I've retained. that functionality.
>
> + Alexei to review
> (author of
> commit b1ae32dbab50 ("x86/cpufeature: Guard asm_volatile_goto usage
> for BPF compilation")


I am not sure at this point.
Wait for the input from Alexei.






> ).
> --
> Thanks,
> ~Nick Desaulniers



-- 
Best Regards
Masahiro Yamada
