Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994F8642144
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 02:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbiLEB4z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Dec 2022 20:56:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbiLEB4y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Dec 2022 20:56:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9459BF5D;
        Sun,  4 Dec 2022 17:56:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E80C860F49;
        Mon,  5 Dec 2022 01:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 517CCC43147;
        Mon,  5 Dec 2022 01:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670205411;
        bh=8jmag+zdhlpIrdCg/EmeruIQiYK399RSMXQZO3BnSnY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=XVYrIrdYRxAty1CPBYGiPXLodmFl1HPuMZiSaI6kBn0c3wbemnYv973wLS3JGa+zq
         jVz3K1VwjjFh1puaIRMZCZVklsYLME0gmyAifxw0hUL/y2PU8ala30Yob8yxvTDMwA
         pLAD3cMZT0Tkvk55E5t68KZ7+As+g5/gvPZzqLdMbF4Oai9Rqs80UsVmk2JQFjDRhv
         w4Su8oxYR1k3LX5P3jU57i40R0DMdnPJYHrTG/GF+TZQtXDiov007S8/ctirtrqSqt
         5v/0SWD3LGNEi9BKZm//qQMSKDVD2Ei3qlHtxFKfWNkvAV4fTLO0MBlfop94U3chx5
         JYk8njz1+SO9A==
Received: by mail-ed1-f53.google.com with SMTP id s5so13779094edc.12;
        Sun, 04 Dec 2022 17:56:51 -0800 (PST)
X-Gm-Message-State: ANoB5plR+543leZ8Mwa/aHPaBEesbZE8BgmXTxrLuMtiA6cJQqKvp9V8
        bM2RmUdfrUZVi/++3aqztvl0g4uuBUskFN8MZEc=
X-Google-Smtp-Source: AA0mqf4J6OuW5Lxey4HxfLt6VmFzq2aRjz9BPkc9bxwRmMODVSswpx7UJQwNpkllMDjy2rx1QiI06gNmWUYhcAaiuj8=
X-Received: by 2002:a05:6402:22db:b0:46c:c16b:b4c4 with SMTP id
 dm27-20020a05640222db00b0046cc16bb4c4mr2010500edb.419.1670205409406; Sun, 04
 Dec 2022 17:56:49 -0800 (PST)
MIME-Version: 1.0
References: <20221204174632.3677-1-jszhang@kernel.org> <20221204174632.3677-11-jszhang@kernel.org>
In-Reply-To: <20221204174632.3677-11-jszhang@kernel.org>
From:   Guo Ren <guoren@kernel.org>
Date:   Mon, 5 Dec 2022 09:56:37 +0800
X-Gmail-Original-Message-ID: <CAJF2gTR5VW0m=czqF2cQOcX5Vstow6EsuT044_E4WLo-NeVCOg@mail.gmail.com>
Message-ID: <CAJF2gTR5VW0m=czqF2cQOcX5Vstow6EsuT044_E4WLo-NeVCOg@mail.gmail.com>
Subject: Re: [PATCH v2 10/13] riscv: alternative: patch alternatives in the vDSO
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

Are there any patches that depend on it? Any existing utilization? My
first idea is to let __vdso_flush_icache use it, the standard
implementation is so heavy for user space JIT scenario, maybe vendors
could give a custom one.

On Mon, Dec 5, 2022 at 1:57 AM Jisheng Zhang <jszhang@kernel.org> wrote:
>
> Make it possible to use alternatives in the vDSO, so that better
> implementations can be used if possible.
>
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> ---
>  arch/riscv/include/asm/vdso.h     |  4 ++++
>  arch/riscv/kernel/alternative.c   | 25 +++++++++++++++++++++++++
>  arch/riscv/kernel/vdso.c          |  5 -----
>  arch/riscv/kernel/vdso/vdso.lds.S |  7 +++++++
>  4 files changed, 36 insertions(+), 5 deletions(-)
>
> diff --git a/arch/riscv/include/asm/vdso.h b/arch/riscv/include/asm/vdso.h
> index af981426fe0f..b6ff7473fb8a 100644
> --- a/arch/riscv/include/asm/vdso.h
> +++ b/arch/riscv/include/asm/vdso.h
> @@ -28,8 +28,12 @@
>  #define COMPAT_VDSO_SYMBOL(base, name)                                         \
>         (void __user *)((unsigned long)(base) + compat__vdso_##name##_offset)
>
> +extern char compat_vdso_start[], compat_vdso_end[];
> +
>  #endif /* CONFIG_COMPAT */
>
> +extern char vdso_start[], vdso_end[];
> +
>  #endif /* !__ASSEMBLY__ */
>
>  #endif /* CONFIG_MMU */
> diff --git a/arch/riscv/kernel/alternative.c b/arch/riscv/kernel/alternative.c
> index 9d88375624b5..eaf7ddaba54c 100644
> --- a/arch/riscv/kernel/alternative.c
> +++ b/arch/riscv/kernel/alternative.c
> @@ -11,7 +11,9 @@
>  #include <linux/cpu.h>
>  #include <linux/uaccess.h>
>  #include <asm/alternative.h>
> +#include <asm/module.h>
>  #include <asm/sections.h>
> +#include <asm/vdso.h>
>  #include <asm/vendorid_list.h>
>  #include <asm/sbi.h>
>  #include <asm/csr.h>
> @@ -187,6 +189,27 @@ static void __init_or_module _apply_alternatives(struct alt_entry *begin,
>                                 stage);
>  }
>
> +static void __init apply_vdso_alternatives(void)
> +{
> +       const struct elf64_hdr *hdr;
> +       const struct elf64_shdr *shdr;
> +       const struct elf64_shdr *alt;
> +       struct alt_entry *begin, *end;
> +
> +       hdr = (struct elf64_hdr *)vdso_start;
> +       shdr = (void *)hdr + hdr->e_shoff;
> +       alt = find_section(hdr, shdr, ".alternative");
> +       if (!alt)
> +               return;
> +
> +       begin = (void *)hdr + alt->sh_offset,
> +       end = (void *)hdr + alt->sh_offset + alt->sh_size,
> +
> +       _apply_alternatives((struct alt_entry *)begin,
> +                           (struct alt_entry *)end,
> +                           RISCV_ALTERNATIVES_BOOT);
> +}
> +
>  void __init apply_boot_alternatives(void)
>  {
>         /* If called on non-boot cpu things could go wrong */
> @@ -195,6 +218,8 @@ void __init apply_boot_alternatives(void)
>         _apply_alternatives((struct alt_entry *)__alt_start,
>                             (struct alt_entry *)__alt_end,
>                             RISCV_ALTERNATIVES_BOOT);
> +
> +       apply_vdso_alternatives();
>  }
>
>  /*
> diff --git a/arch/riscv/kernel/vdso.c b/arch/riscv/kernel/vdso.c
> index 123d05255fcf..1f47bc6566cf 100644
> --- a/arch/riscv/kernel/vdso.c
> +++ b/arch/riscv/kernel/vdso.c
> @@ -22,11 +22,6 @@ struct vdso_data {
>  };
>  #endif
>
> -extern char vdso_start[], vdso_end[];
> -#ifdef CONFIG_COMPAT
> -extern char compat_vdso_start[], compat_vdso_end[];
> -#endif
> -
>  enum vvar_pages {
>         VVAR_DATA_PAGE_OFFSET,
>         VVAR_TIMENS_PAGE_OFFSET,
> diff --git a/arch/riscv/kernel/vdso/vdso.lds.S b/arch/riscv/kernel/vdso/vdso.lds.S
> index 150b1a572e61..4a0606633290 100644
> --- a/arch/riscv/kernel/vdso/vdso.lds.S
> +++ b/arch/riscv/kernel/vdso/vdso.lds.S
> @@ -40,6 +40,13 @@ SECTIONS
>         . = 0x800;
>         .text           : { *(.text .text.*) }          :text
>
> +       . = ALIGN(4);
> +       .alternative : {
> +               __alt_start = .;
> +               *(.alternative)
> +               __alt_end = .;
> +       }
> +
>         .data           : {
>                 *(.got.plt) *(.got)
>                 *(.data .data.* .gnu.linkonce.d.*)
> --
> 2.37.2
>


-- 
Best Regards
 Guo Ren
