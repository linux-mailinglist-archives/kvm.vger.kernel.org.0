Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A06469DAFD
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 08:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233516AbjBUHN3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 02:13:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233502AbjBUHN1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 02:13:27 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD99E72B9
        for <kvm@vger.kernel.org>; Mon, 20 Feb 2023 23:13:13 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id bg28so2497367wmb.0
        for <kvm@vger.kernel.org>; Mon, 20 Feb 2023 23:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vrull.eu; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PKUefFK9SiP/kDBGD+FrqYGyTRY+XtYHTqFfXzLRCic=;
        b=Wn/WwmyzxpAuhNVifq3JYfnKu8T/n2i/txGrpukajWWRJwYuCjQT2rjWs04z7XGtUx
         V5hazoONpR83YdFjd4oPC7KhWET8tvlpNJyz0kdw4Vd50KxRh0f3WNePwGB+tUdsZ4W/
         oLhrGc4DhkqoT93Hp5b3zyWPTYhOYyiPmLjDRLi6RTjwBM6JsPPTIrXaG2HP2Ot5yCmC
         h9HjtQBpH4iXY8GdIzaPeJ5olenWTLIoCktzV8KXLKw1yx/kOtjBght0vm2QuGDXNGwW
         7HrkSDSPEw22C2medMeG4ERmJkjkWpprGX1CSci82dWL/FM35rI8vH9Hj3F+Y4THzQYK
         N3Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PKUefFK9SiP/kDBGD+FrqYGyTRY+XtYHTqFfXzLRCic=;
        b=d4wDCEVTAMOJQrKcgM/aE0syiQGSgAF4d10meIwaHUWeRfVi4asj7YtKJLdMVljX6M
         qMgvaxLmzYi9kMTzWzZ6bR6HactrAIQDWVw/ZrmSHjPF6jBkSkQiGfTuMhMqiBrC5ptf
         dLSx78elVlqo7wpgYDOyAJcRLxqHqOwB7qW4IHocf86K5Rzh0vxcH9z0RYMMCA7ZoxUf
         4qWdxNhOrMj8ZbutduKW2GKRsl81XBUV5JUbEx4vwtYXIYYShqrARDjJw0x5lqAhRBoZ
         1M51IlRXwMYdRpTddu1IoW0ahzXjiRk+Ov8yB9q/QB44MVcHWal/R4/2l23i/nYM6mER
         KJ0g==
X-Gm-Message-State: AO0yUKVZ75Abf1YjeCs+/iROASuN1rXMLe37ctL7yKAHgbQbGLOpIqJT
        KuzUm/K4qCgfPspeVl+lOme4sEla9eHmN94rX1DzTolEXCcOqg==
X-Google-Smtp-Source: AK7set+H1FIoSX3EEh1yGR9n51hoiM91i0p+8wSWyTcgIW4iRjlyf1gAZ3YDv3sxlv0ULcTUiG4yHijCYkpJw3gnib8=
X-Received: by 2002:a05:600c:600a:b0:3e4:2f8d:ae35 with SMTP id
 az10-20020a05600c600a00b003e42f8dae35mr386805wmb.185.1676963592042; Mon, 20
 Feb 2023 23:13:12 -0800 (PST)
MIME-Version: 1.0
References: <20230128072737.2995881-3-apatel@ventanamicro.com>
 <mhng-0f9bdf58-5289-4db4-8fd7-38898824c44f@palmer-ri-x1c9> <CAEg0e7hrQFu+cdZy+3QO1ML9FNTPBehZwOOBnr1F-5ABYDnkGg@mail.gmail.com>
In-Reply-To: <CAEg0e7hrQFu+cdZy+3QO1ML9FNTPBehZwOOBnr1F-5ABYDnkGg@mail.gmail.com>
From:   =?UTF-8?Q?Christoph_M=C3=BCllner?= <christoph.muellner@vrull.eu>
Date:   Tue, 21 Feb 2023 08:12:58 +0100
Message-ID: <CAEg0e7hRjMSgYZbPTQztbQ3bGZf-r8wAfCK5ZnDXOcx27HcTCA@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] RISC-V: Detect AIA CSRs from ISA string
To:     Palmer Dabbelt <palmer@dabbelt.com>
Cc:     apatel@ventanamicro.com, pbonzini@redhat.com,
        atishp@atishpatra.org, Paul Walmsley <paul.walmsley@sifive.com>,
        ajones@ventanamicro.com, anup@brainfault.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

The RISC-V Architectural Review Committee has discussed the concerns
regarding the non-ratified chapters in the AIA specification.

Here is the relevant quote from the meeting minutes:
"""
Although the Advanced Interrupt Architecture (AIA) has already passed
Architecture Review (with a minor edit still pending), the committee
has some suggestions about its final steps to ratification, to avoid
the AIA document having a mixture of ratified and non-ratified content:

- The AIA document's remaining draft chapter on the Duo-PLIC, which is
  not currently on a path to ratification, can be removed to a separate
  document.

- Ratification of the full AIA (without Duo-PLIC) can be postponed to
  coincide with ratification of the IOMMU specification, given that
  the latter is now expected in a reasonable time, and the AIA's last
  chapter concerning IOMMUs is already scheduled to go through public
  review and be ratified only together with the IOMMU specification.
"""

The full meeting minutes can be found here:
  https://lists.riscv.org/g/tech-chairs/message/1381

BR
Christoph

On Wed, Feb 15, 2023 at 4:41 PM Christoph M=C3=BCllner
<christoph.muellner@vrull.eu> wrote:
>
> On Fri, Feb 3, 2023 at 1:25 AM Palmer Dabbelt <palmer@dabbelt.com> wrote:
> >
> > On Fri, 27 Jan 2023 23:27:32 PST (-0800), apatel@ventanamicro.com wrote=
:
> > > We have two extension names for AIA ISA support: Smaia (M-mode AIA CS=
Rs)
> > > and Ssaia (S-mode AIA CSRs).
> >
> > This has pretty much the same problem that we had with the other
> > AIA-related ISA string patches, where there's that ambiguity with the
> > non-ratified chapters.  IIRC when this came up in GCC the rough idea wa=
s
> > to try and document that we're going to interpret the standard ISA
> > strings that way, but now that we're doing custom ISA extensions it
> > seems saner to just define on here that removes the ambiguity.
>
>
> To avoid the impression that I did not work on that, here is the v2
> from November,
> that attempts to document this:
>   https://gcc.gnu.org/pipermail/gcc-patches/2022-November/607326.html
>
> My proposed text was:
> +Note, that AIA support (@samp{Smaia} and @samp{Ssaia}) is based on an AI=
A
> +specification, which is frozen but contains draft chapters ("Duo-PLIC" a=
nd
> +"IOMMU Support").
>
> Btw, I did not get any feedback on that patch.
>
> I also tried to address this on spec level (the PR has been linked) and r=
aised
> that to tech-aia (the conversation has been linked).
>
> Another thing that I want to highlight, since it was discussed a lot rece=
ntly
> (e.g. just a few minutes ago in tech-chairs).
> There is a chance of a last-minute spec change of AIA:
>   https://github.com/riscv/riscv-aia/pull/37
>
> BR
> Christoph
>
>
>
> >
> >
> > I just sent
> > <https://lore.kernel.org/r/20230203001201.14770-1-palmer@rivosinc.com/>
> > which documents that.
> >
> > > We extend the ISA string parsing to detect Smaia and Ssaia extensions=
.
> > >
> > > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> > > ---
> > >  arch/riscv/include/asm/hwcap.h | 2 ++
> > >  arch/riscv/kernel/cpu.c        | 2 ++
> > >  arch/riscv/kernel/cpufeature.c | 2 ++
> > >  3 files changed, 6 insertions(+)
> > >
> > > diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/=
hwcap.h
> > > index 86328e3acb02..341ef30a3718 100644
> > > --- a/arch/riscv/include/asm/hwcap.h
> > > +++ b/arch/riscv/include/asm/hwcap.h
> > > @@ -59,6 +59,8 @@ enum riscv_isa_ext_id {
> > >       RISCV_ISA_EXT_ZIHINTPAUSE,
> > >       RISCV_ISA_EXT_SSTC,
> > >       RISCV_ISA_EXT_SVINVAL,
> > > +     RISCV_ISA_EXT_SMAIA,
> > > +     RISCV_ISA_EXT_SSAIA,
> > >       RISCV_ISA_EXT_ID_MAX
> > >  };
> > >  static_assert(RISCV_ISA_EXT_ID_MAX <=3D RISCV_ISA_EXT_MAX);
> > > diff --git a/arch/riscv/kernel/cpu.c b/arch/riscv/kernel/cpu.c
> > > index 1b9a5a66e55a..a215ec929160 100644
> > > --- a/arch/riscv/kernel/cpu.c
> > > +++ b/arch/riscv/kernel/cpu.c
> > > @@ -162,6 +162,8 @@ arch_initcall(riscv_cpuinfo_init);
> > >   *    extensions by an underscore.
> > >   */
> > >  static struct riscv_isa_ext_data isa_ext_arr[] =3D {
> > > +     __RISCV_ISA_EXT_DATA(smaia, RISCV_ISA_EXT_SMAIA),
> > > +     __RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),
> >
> > This will conflict with that ISA string refactoring I just merged.  It
> > should be a pretty mechanical merge conflict, but if you want we can do
> > a shared tag with the first few patches and I can handle the merge
> > conflict locally.
> >
> > >       __RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
> > >       __RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
> > >       __RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
> > > diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufe=
ature.c
> > > index 93e45560af30..3c5b51f519d5 100644
> > > --- a/arch/riscv/kernel/cpufeature.c
> > > +++ b/arch/riscv/kernel/cpufeature.c
> > > @@ -228,6 +228,8 @@ void __init riscv_fill_hwcap(void)
> > >                               SET_ISA_EXT_MAP("zihintpause", RISCV_IS=
A_EXT_ZIHINTPAUSE);
> > >                               SET_ISA_EXT_MAP("sstc", RISCV_ISA_EXT_S=
STC);
> > >                               SET_ISA_EXT_MAP("svinval", RISCV_ISA_EX=
T_SVINVAL);
> > > +                             SET_ISA_EXT_MAP("smaia", RISCV_ISA_EXT_=
SMAIA);
> > > +                             SET_ISA_EXT_MAP("ssaia", RISCV_ISA_EXT_=
SSAIA);
> > >                       }
> > >  #undef SET_ISA_EXT_MAP
> > >               }
> >
> > _______________________________________________
> > linux-riscv mailing list
> > linux-riscv@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-riscv
