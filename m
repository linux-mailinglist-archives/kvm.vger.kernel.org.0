Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB446D20F1
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 14:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbjCaMxe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 08:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbjCaMx3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 08:53:29 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782B71FD38
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 05:53:25 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id x3so89118324edb.10
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 05:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112; t=1680267204;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YIZnVNAeusSw2DklqSF0RmxvOxwbV5Dj+erXFtgfBtA=;
        b=WzN8sl+ja+DSJjEqAeZpmG8GXY9GKJuU8urNlcQdUzweq6Uu3o5ks6Ju9S74aGupiR
         HzV2uKx/E9/Pj4I7qg1mHYPxO1pdtSQ87bT/eU0ZQD9BPaZojeN086LXpX+0a4y1IrhJ
         uF/f+zQDB/jDpRYyHR7/2GfCCB9VhQ33mlYwKH1Jd+VAy5ulzlOPrmczkiKTIICqUXya
         xU9TGe94YFKPmlE2btyW2PE0Qv/ymnr+0NKGmFvq7NXYesbNYZrMV5ZWCLj0tmUhX647
         TQROSUPOZ2ocj3iWDrm6DUEB9JGcHWR2/FFLvt/aqFZAFwdNyTP9Zd8tK/PvTnfg78zE
         vLmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680267204;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YIZnVNAeusSw2DklqSF0RmxvOxwbV5Dj+erXFtgfBtA=;
        b=dQr+RzLt72mtEJ/UriwI3cL2A3ND+tfCHYUE5BVLAmRCdcrAeUz6zdt61TJjTY9JJi
         zIB30TNhfsw/JSV/6GmqSOyEKmJc9UThuc2lVfysADFtmlDPWZ3XdIJP89IZmoZyppYt
         n7Y4a75yJh3QgyUeBLNWhQE0f2eP7oCrmNt69gs6HvZA1tboqlUSv5NwTwgG5KRoEOtC
         O1JVCOMGHrXW7xC1XaRH6I7jVHCUlA4788uJSey/duxtji+WN0u95iw+dBDP9Focg0Bg
         dD6lEG/2klKtd6ZeZZFDfM0OMiy3SQPlVHw0c2c0RKcV6y4XuYn5fTgVr8HZUXUFCW1/
         Ae7g==
X-Gm-Message-State: AAQBX9fErY8yFt5267N2is0XJbt4mwW6A13zvd8Q0FDN3ZARp6dqK5Pz
        QvA1lhaitnsvndoW5856VwoaGg6RSXYUnJblPNcwKA==
X-Google-Smtp-Source: AKy350aXJtieoI5T98QbeE9lxz4pl2omhYkDSZLjnzLzVIg3TVO430qunA++yOjjQfcGF1NH3RBLqUE4qLo4jY8BK6w=
X-Received: by 2002:a17:907:9623:b0:93e:aac:bb8d with SMTP id
 gb35-20020a170907962300b0093e0aacbb8dmr13612957ejc.13.1680267203799; Fri, 31
 Mar 2023 05:53:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230128072737.2995881-3-apatel@ventanamicro.com> <mhng-0f9bdf58-5289-4db4-8fd7-38898824c44f@palmer-ri-x1c9>
In-Reply-To: <mhng-0f9bdf58-5289-4db4-8fd7-38898824c44f@palmer-ri-x1c9>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 31 Mar 2023 18:23:11 +0530
Message-ID: <CAAhSdy3vPQw1OcRx3kQwt8UHgKa+18Ut-SzZkb8gQTHDRK7e2w@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] RISC-V: Detect AIA CSRs from ISA string
To:     Palmer Dabbelt <palmer@dabbelt.com>
Cc:     apatel@ventanamicro.com, pbonzini@redhat.com,
        atishp@atishpatra.org, Paul Walmsley <paul.walmsley@sifive.com>,
        ajones@ventanamicro.com, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Palmer

On Fri, Feb 3, 2023 at 5:54=E2=80=AFAM Palmer Dabbelt <palmer@dabbelt.com> =
wrote:
>
> On Fri, 27 Jan 2023 23:27:32 PST (-0800), apatel@ventanamicro.com wrote:
> > We have two extension names for AIA ISA support: Smaia (M-mode AIA CSRs=
)
> > and Ssaia (S-mode AIA CSRs).
>
> This has pretty much the same problem that we had with the other
> AIA-related ISA string patches, where there's that ambiguity with the
> non-ratified chapters.  IIRC when this came up in GCC the rough idea was
> to try and document that we're going to interpret the standard ISA
> strings that way, but now that we're doing custom ISA extensions it
> seems saner to just define on here that removes the ambiguity.
>
> I just sent
> <https://lore.kernel.org/r/20230203001201.14770-1-palmer@rivosinc.com/>
> which documents that.

The IOMMU and AIA chapter8 are frozen and in public review.
Refer, https://lists.riscv.org/g/tech-aia/message/346

This means the entire AIA specification is now frozen (i.e. no
chapters in draft state).

I will rebase this series and send-out v3. It would be great if you
can ACK the PATCH2 of this series.

Thanks,
Anup

>
> > We extend the ISA string parsing to detect Smaia and Ssaia extensions.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> > ---
> >  arch/riscv/include/asm/hwcap.h | 2 ++
> >  arch/riscv/kernel/cpu.c        | 2 ++
> >  arch/riscv/kernel/cpufeature.c | 2 ++
> >  3 files changed, 6 insertions(+)
> >
> > diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hw=
cap.h
> > index 86328e3acb02..341ef30a3718 100644
> > --- a/arch/riscv/include/asm/hwcap.h
> > +++ b/arch/riscv/include/asm/hwcap.h
> > @@ -59,6 +59,8 @@ enum riscv_isa_ext_id {
> >       RISCV_ISA_EXT_ZIHINTPAUSE,
> >       RISCV_ISA_EXT_SSTC,
> >       RISCV_ISA_EXT_SVINVAL,
> > +     RISCV_ISA_EXT_SMAIA,
> > +     RISCV_ISA_EXT_SSAIA,
> >       RISCV_ISA_EXT_ID_MAX
> >  };
> >  static_assert(RISCV_ISA_EXT_ID_MAX <=3D RISCV_ISA_EXT_MAX);
> > diff --git a/arch/riscv/kernel/cpu.c b/arch/riscv/kernel/cpu.c
> > index 1b9a5a66e55a..a215ec929160 100644
> > --- a/arch/riscv/kernel/cpu.c
> > +++ b/arch/riscv/kernel/cpu.c
> > @@ -162,6 +162,8 @@ arch_initcall(riscv_cpuinfo_init);
> >   *    extensions by an underscore.
> >   */
> >  static struct riscv_isa_ext_data isa_ext_arr[] =3D {
> > +     __RISCV_ISA_EXT_DATA(smaia, RISCV_ISA_EXT_SMAIA),
> > +     __RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),
>
> This will conflict with that ISA string refactoring I just merged.  It
> should be a pretty mechanical merge conflict, but if you want we can do
> a shared tag with the first few patches and I can handle the merge
> conflict locally.
>
> >       __RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
> >       __RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
> >       __RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
> > diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeat=
ure.c
> > index 93e45560af30..3c5b51f519d5 100644
> > --- a/arch/riscv/kernel/cpufeature.c
> > +++ b/arch/riscv/kernel/cpufeature.c
> > @@ -228,6 +228,8 @@ void __init riscv_fill_hwcap(void)
> >                               SET_ISA_EXT_MAP("zihintpause", RISCV_ISA_=
EXT_ZIHINTPAUSE);
> >                               SET_ISA_EXT_MAP("sstc", RISCV_ISA_EXT_SST=
C);
> >                               SET_ISA_EXT_MAP("svinval", RISCV_ISA_EXT_=
SVINVAL);
> > +                             SET_ISA_EXT_MAP("smaia", RISCV_ISA_EXT_SM=
AIA);
> > +                             SET_ISA_EXT_MAP("ssaia", RISCV_ISA_EXT_SS=
AIA);
> >                       }
> >  #undef SET_ISA_EXT_MAP
> >               }
