Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2242EC345
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 19:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbhAFShx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 6 Jan 2021 13:37:53 -0500
Received: from mail-oi1-f170.google.com ([209.85.167.170]:34973 "EHLO
        mail-oi1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbhAFShx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 13:37:53 -0500
Received: by mail-oi1-f170.google.com with SMTP id s2so4513520oij.2
        for <kvm@vger.kernel.org>; Wed, 06 Jan 2021 10:37:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4OCaT6ljZofXDjlCJHZtg9aKPhRWN14GpOhwvn1+Rc0=;
        b=Xaj/JZxVcZ+VCgbh9J6OmcbbZXtj6aW2+zvWBYHznTaH/ohhRBqALV32QYt8jURDQj
         DFd94EUNXpKsyvH9Ng2qHzZvCJSaLsWWODJe5me3J1YF6fht3RBXfoyunrvcePqqI2yw
         4RrlGPwzib82WEkTFOSm1unZxGSY4FR/s0eqPIYnWFwwBDw9fJUuVFHndN5Jl/tIXJJJ
         pmUChlplLC2CSblpJ4IpDsCqsRhcELhsBOE4cUBwbi/YeqW/8ZO6VWwHSZsqNMLKU9S6
         qYL+k5OdNsdgUtTrljcLAxBF6rcqbLNJ4BshuS6XkbuOyTRnaao5Mcn7cNpwynzjHyMG
         1VCQ==
X-Gm-Message-State: AOAM531VPhB4zM+3in6exubMhe78EMCM7TSGuliBaNayPvlPlRHUbE0d
        BJ2GAnW9m02k+8drWBoblC50prFwxTmYhJ8IVEY=
X-Google-Smtp-Source: ABdhPJwBzsgzIp/+Hck4LCMdb+vD0yXvZEqb4D+eKf15c2i1SHC6Geo1dgHUsROFTVFTzjHqiiv9Ql1+/F01uLhTt/8=
X-Received: by 2002:aca:c752:: with SMTP id x79mr3792236oif.46.1609958232072;
 Wed, 06 Jan 2021 10:37:12 -0800 (PST)
MIME-Version: 1.0
References: <20201215225757.764263-1-f4bug@amsat.org> <20201215225757.764263-3-f4bug@amsat.org>
 <1f23c2f4-28b9-ac3b-356e-ea9cc0213690@amsat.org>
In-Reply-To: <1f23c2f4-28b9-ac3b-356e-ea9cc0213690@amsat.org>
From:   =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>
Date:   Wed, 6 Jan 2021 19:37:00 +0100
Message-ID: <CAAdtpL65=s-eUGKjXe-KzyqyHs1+a1qwHyp72xNRNo0gHxE8Hg@mail.gmail.com>
Subject: Re: [PATCH v2 02/24] target/mips/translate: Expose check_mips_64() to
 32-bit mode
To:     Richard Henderson <richard.henderson@linaro.org>,
        "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 6, 2021 at 7:20 PM Philippe Mathieu-Daudé <f4bug@amsat.org> wrote:
>
> Hi,
>
> ping for code review? :)

FWIW the full series (rebased on mips-next) is available here:
https://gitlab.com/philmd/qemu/-/commits/mips_msa_decodetree

>
> Due to the "Simplify ISA definitions"
> https://www.mail-archive.com/qemu-devel@nongnu.org/msg770056.html
> patch #3 is not necessary.
>
> This is the last patch unreviewed.
>
> On 12/15/20 11:57 PM, Philippe Mathieu-Daudé wrote:
> > To allow compiling 64-bit specific translation code more
> > generically (and removing #ifdef'ry), allow compiling
> > check_mips_64() on 32-bit targets.
> > If ever called on 32-bit, we obviously emit a reserved
> > instruction exception.
> >
> > Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> > ---
> >  target/mips/translate.h | 2 --
> >  target/mips/translate.c | 8 +++-----
> >  2 files changed, 3 insertions(+), 7 deletions(-)
> >
> > diff --git a/target/mips/translate.h b/target/mips/translate.h
> > index a9eab69249f..942d803476c 100644
> > --- a/target/mips/translate.h
> > +++ b/target/mips/translate.h
> > @@ -127,9 +127,7 @@ void generate_exception_err(DisasContext *ctx, int excp, int err);
> >  void generate_exception_end(DisasContext *ctx, int excp);
> >  void gen_reserved_instruction(DisasContext *ctx);
> >  void check_insn(DisasContext *ctx, uint64_t flags);
> > -#ifdef TARGET_MIPS64
> >  void check_mips_64(DisasContext *ctx);
> > -#endif
> >  void check_cp1_enabled(DisasContext *ctx);
> >
> >  void gen_base_offset_addr(DisasContext *ctx, TCGv addr, int base, int offset);
> > diff --git a/target/mips/translate.c b/target/mips/translate.c
> > index 5c62b32c6ae..af543d1f375 100644
> > --- a/target/mips/translate.c
> > +++ b/target/mips/translate.c
> > @@ -2972,18 +2972,16 @@ static inline void check_ps(DisasContext *ctx)
> >      check_cp1_64bitmode(ctx);
> >  }
> >
> > -#ifdef TARGET_MIPS64
> >  /*
> > - * This code generates a "reserved instruction" exception if 64-bit
> > - * instructions are not enabled.
> > + * This code generates a "reserved instruction" exception if cpu is not
> > + * 64-bit or 64-bit instructions are not enabled.
> >   */
> >  void check_mips_64(DisasContext *ctx)
> >  {
> > -    if (unlikely(!(ctx->hflags & MIPS_HFLAG_64))) {
> > +    if (unlikely((TARGET_LONG_BITS != 64) || !(ctx->hflags & MIPS_HFLAG_64))) {
>
> Since TARGET_LONG_BITS is known at build time, this can be simplified
> as:
>
> if ((TARGET_LONG_BITS != 64) || unlikely!(ctx->hflags & MIPS_HFLAG_64)))
>
> >          gen_reserved_instruction(ctx);
> >      }
> >  }
> > -#endif
> >
> >  #ifndef CONFIG_USER_ONLY
> >  static inline void check_mvh(DisasContext *ctx)
> >
