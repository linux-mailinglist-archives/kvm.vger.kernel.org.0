Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13668643C4D
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 05:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbiLFEfH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 23:35:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiLFEe6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 23:34:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A150FDF35;
        Mon,  5 Dec 2022 20:34:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30B4FB81693;
        Tue,  6 Dec 2022 04:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5D8C43142;
        Tue,  6 Dec 2022 04:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670301293;
        bh=msa/VwPes92I5wu/vP8BsHcD7BgDu9WgymdDavuJWxA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=CuN4sq4wwjyML+PXFapg5qJk6mPVkcHbsZuwUZjLtlsZ5kbDTDW9yKUt5aRjbYsRZ
         /PDYBgG3STC8wsEpxguMFPcLUwY083/OOrBO2grps/+zm4Qg3ZZ9CoYIS9AoEJQoV7
         abALkPKNw35YJVZKjxYiJLyWXZXbvq1nlub2MzObwFeyNEwLVDlvAM0LZIvDSUAon/
         DWLJfhyYJ6ASDTbzyTumOv833Xps7A9U+wi7T8TTTDXvijP3eJLJAsSGhj5tlIAC/W
         sfa6xXY6wzyfzZwYKDbb9WwOZzKjHHAYSKjQRCPTxhC1wRrTXiQbAop/xtGMe9mm8H
         MVTAiu+BHK01Q==
Received: by mail-ej1-f52.google.com with SMTP id m18so1804061eji.5;
        Mon, 05 Dec 2022 20:34:53 -0800 (PST)
X-Gm-Message-State: ANoB5pmSi6byheI8KlT3y5jJre0xB+BzM6weyrCGXGgiH3ypsFHe+9bI
        m7UjwY5nWSm47c8xKB6/oq7ENx8hIhiAMnvRZBo=
X-Google-Smtp-Source: AA0mqf6GuGvHiOPgth8wIKnoKnt5jLhpQ86kofAEtziMuYgxI4HGvPlxaa3cPf+bC0eiMd9r7hVWqPfgNab+xB5zkpw=
X-Received: by 2002:a17:906:ee2:b0:78d:3f96:b7aa with SMTP id
 x2-20020a1709060ee200b0078d3f96b7aamr56776437eji.74.1670301292065; Mon, 05
 Dec 2022 20:34:52 -0800 (PST)
MIME-Version: 1.0
References: <20221204174632.3677-1-jszhang@kernel.org> <20221204174632.3677-10-jszhang@kernel.org>
 <CAJF2gTRxm7LJFtups5fexJ5ishm9_j3e+yzfKv3nTtQqUtXPtA@mail.gmail.com> <Y44LuRcQYPnVnFje@xhacker>
In-Reply-To: <Y44LuRcQYPnVnFje@xhacker>
From:   Guo Ren <guoren@kernel.org>
Date:   Tue, 6 Dec 2022 12:34:40 +0800
X-Gmail-Original-Message-ID: <CAJF2gTQ98fyTNc6d3PJrkMjUjUstN8s1FcRNyZQCLiN5CV5NCw@mail.gmail.com>
Message-ID: <CAJF2gTQ98fyTNc6d3PJrkMjUjUstN8s1FcRNyZQCLiN5CV5NCw@mail.gmail.com>
Subject: Re: [PATCH v2 09/13] riscv: switch to relative alternative entries
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Andrew Jones <ajones@ventanamicro.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 5, 2022 at 11:28 PM Jisheng Zhang <jszhang@kernel.org> wrote:
>
> On Mon, Dec 05, 2022 at 08:51:41AM +0800, Guo Ren wrote:
> > On Mon, Dec 5, 2022 at 1:57 AM Jisheng Zhang <jszhang@kernel.org> wrote:
> > >
> > > Instead of using absolute addresses for both the old instrucions and
> > > the alternative instructions, use offsets relative to the alt_entry
> > > values. So we can not only cut the size of the alternative entry, but
> > > also meet the prerequisite for patching alternatives in the vDSO,
> > > since absolute alternative entries are subject to dynamic relocation,
> > > which is incompatible with the vDSO building.
> > >
> > > Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> > > ---
> > >  arch/riscv/errata/sifive/errata.c           |  4 +++-
> > >  arch/riscv/errata/thead/errata.c            | 11 ++++++++---
> > >  arch/riscv/include/asm/alternative-macros.h | 20 ++++++++++----------
> > >  arch/riscv/include/asm/alternative.h        | 12 ++++++------
> > >  arch/riscv/kernel/cpufeature.c              | 13 ++++++-------
> > >  5 files changed, 33 insertions(+), 27 deletions(-)
> > >
> > > diff --git a/arch/riscv/errata/sifive/errata.c b/arch/riscv/errata/sifive/errata.c
> > > index 1031038423e7..0e537cdfd324 100644
> > > --- a/arch/riscv/errata/sifive/errata.c
> > > +++ b/arch/riscv/errata/sifive/errata.c
> > > @@ -107,7 +107,9 @@ void __init_or_module sifive_errata_patch_func(struct alt_entry *begin,
> > >
> > >                 tmp = (1U << alt->errata_id);
> > >                 if (cpu_req_errata & tmp) {
> > > -                       patch_text_nosync(alt->old_ptr, alt->alt_ptr, alt->alt_len);
> > > +                       patch_text_nosync((void *)&alt->old_offset + alt->old_offset,
> > > +                                         (void *)&alt->alt_offset + alt->alt_offset,
> >  (void *)&alt->alt_offset + alt->alt_offset. ??!!
>
> Hi Guo,
>
> what's the problem? I can't catch your meaning, could you please proide
> more details?
Can you explain why:

alt->old_ptr = (void *)&alt->old_offset + alt->old_offset

| offset | <- &offset
| ...       |
| value | <- ptr = &offset + offset

I don't make sense of the above.

>
> Thanks
>
> >
> > > +                                         alt->alt_len);
> > >                         cpu_apply_errata |= tmp;
> > >                 }
> > >         }
> > > diff --git a/arch/riscv/errata/thead/errata.c b/arch/riscv/errata/thead/errata.c
> > > index 21546937db39..2a6e335b5a32 100644
> > > --- a/arch/riscv/errata/thead/errata.c
> > > +++ b/arch/riscv/errata/thead/errata.c
> > > @@ -68,6 +68,7 @@ void __init_or_module thead_errata_patch_func(struct alt_entry *begin, struct al
> > >         struct alt_entry *alt;
> > >         u32 cpu_req_errata = thead_errata_probe(stage, archid, impid);
> > >         u32 tmp;
> > > +       void *oldptr, *updptr;
> > >
> > >         for (alt = begin; alt < end; alt++) {
> > >                 if (alt->vendor_id != THEAD_VENDOR_ID)
> > > @@ -77,12 +78,16 @@ void __init_or_module thead_errata_patch_func(struct alt_entry *begin, struct al
> > >
> > >                 tmp = (1U << alt->errata_id);
> > >                 if (cpu_req_errata & tmp) {
> > > +                       oldptr = (void *)&alt->old_offset + alt->old_offset;
> > > +                       updptr = (void *)&alt->alt_offset + alt->alt_offset;
> > > +
> > >                         /* On vm-alternatives, the mmu isn't running yet */
> > >                         if (stage == RISCV_ALTERNATIVES_EARLY_BOOT)
> > > -                               memcpy((void *)__pa_symbol(alt->old_ptr),
> > > -                                      (void *)__pa_symbol(alt->alt_ptr), alt->alt_len);
> > > +                               memcpy((void *)__pa_symbol(oldptr),
> > > +                                      (void *)__pa_symbol(updptr),
> > > +                                      alt->alt_len);
> > >                         else
> > > -                               patch_text_nosync(alt->old_ptr, alt->alt_ptr, alt->alt_len);
> > > +                               patch_text_nosync(oldptr, updptr, alt->alt_len);
> > >                 }
> > >         }
> > >
> > > diff --git a/arch/riscv/include/asm/alternative-macros.h b/arch/riscv/include/asm/alternative-macros.h
> > > index ec2f3f1b836f..dd40727bc859 100644
> > > --- a/arch/riscv/include/asm/alternative-macros.h
> > > +++ b/arch/riscv/include/asm/alternative-macros.h
> > > @@ -7,11 +7,11 @@
> > >  #ifdef __ASSEMBLY__
> > >
> > >  .macro ALT_ENTRY oldptr newptr vendor_id errata_id new_len
> > > -       RISCV_PTR \oldptr
> > > -       RISCV_PTR \newptr
> > > -       REG_ASM \vendor_id
> > > -       REG_ASM \new_len
> > > -       .word   \errata_id
> > > +       .long \oldptr - .
> > > +       .long \newptr - .
> > > +       .short \vendor_id
> > > +       .short \new_len
> > > +       .long \errata_id
> > >  .endm
> > >
> > >  .macro ALT_NEW_CONTENT vendor_id, errata_id, enable = 1, new_c : vararg
> > > @@ -75,11 +75,11 @@
> > >  #include <linux/stringify.h>
> > >
> > >  #define ALT_ENTRY(oldptr, newptr, vendor_id, errata_id, newlen)                \
> > > -       RISCV_PTR " " oldptr "\n"                                       \
> > > -       RISCV_PTR " " newptr "\n"                                       \
> > > -       REG_ASM " " vendor_id "\n"                                      \
> > > -       REG_ASM " " newlen "\n"                                         \
> > > -       ".word " errata_id "\n"
> > > +       ".long  ((" oldptr ") - .) \n"                                  \
> > > +       ".long  ((" newptr ") - .) \n"                                  \
> > > +       ".short " vendor_id "\n"                                        \
> > > +       ".short " newlen "\n"                                           \
> > > +       ".long  " errata_id "\n"
> > >
> > >  #define ALT_NEW_CONTENT(vendor_id, errata_id, enable, new_c)           \
> > >         ".if " __stringify(enable) " == 1\n"                            \
> > > diff --git a/arch/riscv/include/asm/alternative.h b/arch/riscv/include/asm/alternative.h
> > > index 33eae9541684..3baf32e05b46 100644
> > > --- a/arch/riscv/include/asm/alternative.h
> > > +++ b/arch/riscv/include/asm/alternative.h
> > > @@ -33,12 +33,12 @@ void riscv_alternative_fix_jal(void *alt_ptr, unsigned int len,
> > >                                int patch_offset);
> > >
> > >  struct alt_entry {
> > > -       void *old_ptr;           /* address of original instruciton or data  */
> > > -       void *alt_ptr;           /* address of replacement instruction or data */
> > > -       unsigned long vendor_id; /* cpu vendor id */
> > > -       unsigned long alt_len;   /* The replacement size */
> > > -       unsigned int errata_id;  /* The errata id */
> > > -} __packed;
> > > +       s32 old_offset;         /* offset to original instruciton or data  */
> > > +       s32 alt_offset;         /* offset to replacement instruction or data */
> > > +       u16 vendor_id;          /* cpu vendor id */
> > > +       u16 alt_len;            /* The replacement size */
> > > +       u32 errata_id;          /* The errata id */
> > > +};
> > >
> > >  struct errata_checkfunc_id {
> > >         unsigned long vendor_id;
> > > diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
> > > index 6244be5cd94a..adeac90b1d8e 100644
> > > --- a/arch/riscv/kernel/cpufeature.c
> > > +++ b/arch/riscv/kernel/cpufeature.c
> > > @@ -257,6 +257,7 @@ void __init_or_module riscv_cpufeature_patch_func(struct alt_entry *begin,
> > >                                                   unsigned int stage)
> > >  {
> > >         struct alt_entry *alt;
> > > +       void *oldptr, *updptr;
> > >
> > >         if (stage == RISCV_ALTERNATIVES_EARLY_BOOT)
> > >                 return;
> > > @@ -270,17 +271,15 @@ void __init_or_module riscv_cpufeature_patch_func(struct alt_entry *begin,
> > >                         continue;
> > >                 }
> > >
> > > +               oldptr = (void *)&alt->old_offset + alt->old_offset;
> > > +               updptr = (void *)&alt->alt_offset + alt->alt_offset;
> > >                 if (!__riscv_isa_extension_available(NULL, alt->errata_id))
> > >                         continue;
> > >
> > >                 /* do the basic patching */
> > > -               patch_text_nosync(alt->old_ptr, alt->alt_ptr, alt->alt_len);
> > > -               riscv_alternative_fix_auipc_jalr(alt->old_ptr,
> > > -                                                alt->alt_len,
> > > -                                                alt->old_ptr - alt->alt_ptr);
> > > -               riscv_alternative_fix_jal(alt->old_ptr,
> > > -                                         alt->alt_len,
> > > -                                         alt->old_ptr - alt->alt_ptr);
> > > +               patch_text_nosync(oldptr, updptr, alt->alt_len);
> > > +               riscv_alternative_fix_auipc_jalr(oldptr, alt->alt_len, oldptr - updptr);
> > > +               riscv_alternative_fix_jal(oldptr, alt->alt_len, oldptr - updptr);
> > >         }
> > >  }
> > >  #endif
> > > --
> > > 2.37.2
> > >
> >
> >
> > --
> > Best Regards
> >  Guo Ren



-- 
Best Regards
 Guo Ren
