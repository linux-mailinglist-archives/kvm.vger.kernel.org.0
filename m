Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4182459A56B
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 20:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350742AbiHSScJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 14:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349790AbiHSScI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 14:32:08 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB29FC8762;
        Fri, 19 Aug 2022 11:32:06 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id u15so1647527ejt.6;
        Fri, 19 Aug 2022 11:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=8M7zvEV1EjOinuu0/2qV6kFVAXmq1t0nJAMuoRVdbdE=;
        b=OjzbobpnwezG9oOO0D3mqTlOH2RNSu4r0nogaaHp3yLiFaL9iSFcc9jKxJNdaliY4r
         +sof2HsYV4LldXKlP1L4mxNTFPUILVVxajwccNizy2oTfFmv4MOqO1x4a719N9KyGRSq
         VwfZUsvOp9U63E4LDrpMmo8FCJfCk6flcOpKx1Ku8woZC0gZgrPeuW9hKrEVjWbNp6n+
         G/wix3nes/dB53tfVEBUYNXnLhvROq4quXRoHI6ycRqGeodV/63Ry3KYaQ0u70nBNqTf
         ChpZDn6psIVDIAcGzWcrkr8v9sADjc7OGL7PKtwwljfXGdtRD5NK+FS9+BhGHa6atrxM
         Q0Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=8M7zvEV1EjOinuu0/2qV6kFVAXmq1t0nJAMuoRVdbdE=;
        b=To1rj7XYXRKSFeZLBcSHNT1TLV7UyvfU/Y46LUNWqH2GloKNIDdkuq2S6RKL+SSZy6
         /Y1MTPuOGxqiiWguOUCXCzqk4pFyBI4lCaEYBIE1/UCD+Ic4dEUkjDa6bPZRhvK+F22C
         DicNizLn8kU048tLRQCW8cB+sdnvAOQPCToYlyOLmTP7UduhINgBDs/3tHDWSxKBHFlE
         MywNRqFV0mH+35kDS5el4vnRRJo59PJzH/AtkarBAk1WekNl3bLK9UktUBWQkvPUt6lL
         7qcYsT8Juwx/FSIvXri7fvNEY3t9WhVZix4zBV7+EDULYhnhNwWCPNo3wsuu+rMhpNxP
         wLVA==
X-Gm-Message-State: ACgBeo0uxs1YQkCeTGY+uJ+I8JXJR58e7LGlz/uIcLPK51aB0W7jVDZ+
        sZYTotx3L9A3ElQPjLattplw/bL4bisqCaze4lV3iJFkG5g=
X-Google-Smtp-Source: AA6agR4aYE+hGNo+6qjl3AaYARmI4Kr6rF+W8Kgen2c+mElNtZtQUvjOd81QElgSQbjXmnAkEFxFPh1O3+Q1febkRLE=
X-Received: by 2002:a17:907:e8d:b0:730:a4e8:27ed with SMTP id
 ho13-20020a1709070e8d00b00730a4e827edmr5455063ejc.58.1660933925080; Fri, 19
 Aug 2022 11:32:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220819170053.2686006-1-ndesaulniers@google.com>
 <Yv/Ff3mAfyCeWtmo@mail.local> <CAKwvOdnCGywz02Mf220njrS16fm4vTnFRFKALtJCqMbQY8Xz_w@mail.gmail.com>
 <CAK7LNAQy66UAWy+tyLYpzf51brdwVESAK8igcHud=4=-v5QxmQ@mail.gmail.com>
In-Reply-To: <CAK7LNAQy66UAWy+tyLYpzf51brdwVESAK8igcHud=4=-v5QxmQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 19 Aug 2022 11:31:53 -0700
Message-ID: <CAADnVQJFc9AnH_9CW+bSRotkKvOmkO9jq-RF6dmyPYOpq691Yg@mail.gmail.com>
Subject: Re: [PATCH] Kconfig: eradicate CC_HAS_ASM_GOTO
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-um@lists.infradead.org, kvm@vger.kernel.org,
        clang-built-linux <llvm@lists.linux.dev>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>
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

On Fri, Aug 19, 2022 at 10:42 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> On Sat, Aug 20, 2022 at 2:28 AM Nick Desaulniers
> <ndesaulniers@google.com> wrote:
> >
> > On Fri, Aug 19, 2022 at 10:16 AM Alexandre Belloni
> > <alexandre.belloni@bootlin.com> wrote:
> > >
> > > On 19/08/2022 10:00:53-0700, Nick Desaulniers wrote:
> > > > GCC has supported asm goto since 4.5, and Clang has since version 9.0.0.
> > > > The minimum supported versions of these tools for the build according to
> > > > Documentation/process/changes.rst are 5.1 and 11.0.0 respectively.
> > > >
> > > > Remove the feature detection script, Kconfig option, and clean up some
> > > > fallback code that is no longer supported.
> > > >
> > > > The removed script was also testing for a GCC specific bug that was
> > > > fixed in the 4.7 release.
> > > >
> > > > The script was also not portable; users of Dash shell reported errors
> > > > when it was invoked.
> > > >
> > >
> > > To be clear, the script was portable, what is not working with dash is
> > > the current detection of CC_HAS_ASM_GOTO_TIED_OUTPUT. I'll try the other
> > > suggestion from Masahiro.
> >
> > Ah, that was his point about echo; that makes more sense.
> >
> > Unless a v2 is required, perhaps Masahiro would be kind enough to drop
> > this sentence from the commit message when applying?
>
> I can if there is nothing else to fix.
>
>
> And, Alexandre's Reported-by is irrelevant.
>
> As for the subject prefix "Kconfig:",
> I prefer something else, for example,
> "asm goto:" or "jump label:".
>
> I want to reserve "Kconfig:" for changes in scripts/kconfig/.
>
>
> >
> > >
> > > > --- a/arch/x86/include/asm/cpufeature.h
> > > > +++ b/arch/x86/include/asm/cpufeature.h
> > > > @@ -155,11 +155,11 @@ extern void clear_cpu_cap(struct cpuinfo_x86 *c, unsigned int bit);
> > > >
> > > >  #define setup_force_cpu_bug(bit) setup_force_cpu_cap(bit)
> > > >
> > > > -#if defined(__clang__) && !defined(CONFIG_CC_HAS_ASM_GOTO)
> > > > +#if defined(__clang__) && __clang_major__ < 9
> > >
> > > Shouldn't we simply mandates clang >= 9 and drop the whole section? This
> > > is what you do later on.
> >
> > I considered it, but I don't think it would be safe to do so in this
> > header.  If you look at the comment block below it, it mentions that
> > these kernel headers are being sucked into UAPI headers that are used
> > outside of the kernel builds, such as when building eBPF programs.  So
> > we don't know what userspace tools might be consuming these headers.
> > The original intent of the guard was to not break eBPF compilation
> > with older clang releases, so I've retained. that functionality.
> >
> > + Alexei to review
> > (author of
> > commit b1ae32dbab50 ("x86/cpufeature: Guard asm_volatile_goto usage
> > for BPF compilation")
>
>
> I am not sure at this point.
> Wait for the input from Alexei.

It's probably best to remove this old workaround.
bpftrace still has code that does:
  cflags.push_back("-D__BPF_TRACING__");
and bpftrace sort-of works with llvm 6+,
but they need to move to a newer clang for tons of other reasons
including lots of fixes in the clang bpf backend that were
added over the years.
So just nuke this old hack.
