Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD165328E7
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 13:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236604AbiEXLZj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 07:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbiEXLZh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 07:25:37 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77DF17A45D
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 04:25:36 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id t6so25263980wra.4
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 04:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IrQKUMgGfJCg4Qp/wyG56UieXV8r90cWTrXiOz7LDck=;
        b=Gy4q7CN99HFyXAicqG9X11IlQ+svRqwnN8b26/bIiFUYInmpSeZdUBS3liSbUIVsla
         wWqnBTLpRQPJXp79wdo0TnrKGBjeXoH4SAS6hOlROajnfLUnMxqS9d1aBvJMrZpmBlmU
         3w5uSFppAXGa1yK8Vd3H9oCbvZcA3UMQD1EBvSxo0HYq1UPQ92+AbDrlGLPE8klvrRTs
         D0PRsfDlXTkRrjxnorF72umS/EPsYzL5y1oK0SJLDG+nwR3peuR7Rzkpfm12leFAYxpX
         clNf3Yy0i28wX0quPqA3glr021cdnZGGrEnVORu8zgPSuMm/hbUSHkuiQJqq1MJNgfSh
         1N/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IrQKUMgGfJCg4Qp/wyG56UieXV8r90cWTrXiOz7LDck=;
        b=Jk73VXo4NlF1Wf6mZIdZAKJT3sG5pNTuxuE7AHvVh+4+UWb/wAh371/XCx738C8Mxg
         pgNuxwaFDLH/lzqeJ6XXkybf7fJQMY1Vux8IcpvLHNLiyN5HFST/z2euRLhn+bEWP4z0
         ezq9cadPjguySxuD0rBZqPuYM4tD04gPMCt1eIsFoHZL7xxW/TXxUempej+CDegTQNeR
         3kdDBO78CwD+/Ftc/GuSeYmV/zsVnKS6zkYq/xn7FQe4d4NC9CrpI6SovJieusExGe6s
         5/E6gg6Jqd3Sr3lxQph8RBFK2D1nLhWJ8JW3PZB2Nc/LsvJM4muGGww604kBayxmVzSX
         m/ng==
X-Gm-Message-State: AOAM531hekP6+9UO458C3gtRzZu7+npFRcr7/IbCMQwp9Nvi6Z+aNNJk
        odCfIU5P/3JkNdHM/8Q7ce8VqG1nF2qGM0k0y6HpNA==
X-Google-Smtp-Source: ABdhPJxSztbMN+n2TmP0z6nr9DurWwl3+BCxash8ct2jbn4OvYv+CLh96rMCl3y/TYL6GZCHByl5uXayneQiJM2qHqo=
X-Received: by 2002:a05:6000:1f18:b0:20f:e61b:520e with SMTP id
 bv24-20020a0560001f1800b0020fe61b520emr6372906wrb.214.1653391534839; Tue, 24
 May 2022 04:25:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220426185245.281182-1-atishp@rivosinc.com> <20220426185245.281182-3-atishp@rivosinc.com>
In-Reply-To: <20220426185245.281182-3-atishp@rivosinc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 24 May 2022 16:55:23 +0530
Message-ID: <CAAhSdy1utVaeMBUYKRQeEPtXxD5gXAs3WCacoXYm9fmHx5yyVA@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] RISC-V: Enable sstc extension parsing from DT
To:     Atish Patra <atishp@rivosinc.com>
Cc:     "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Atish Patra <atishp@atishpatra.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        DTML <devicetree@vger.kernel.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 27, 2022 at 12:23 AM Atish Patra <atishp@rivosinc.com> wrote:
>
> The ISA extension framework now allows parsing any multi-letter
> ISA extension.
>
> Enable that for sstc extension.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

Looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/include/asm/hwcap.h | 1 +
>  arch/riscv/kernel/cpu.c        | 1 +
>  arch/riscv/kernel/cpufeature.c | 1 +
>  3 files changed, 3 insertions(+)
>
> diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
> index 0734e42f74f2..25915eb60d61 100644
> --- a/arch/riscv/include/asm/hwcap.h
> +++ b/arch/riscv/include/asm/hwcap.h
> @@ -52,6 +52,7 @@ extern unsigned long elf_hwcap;
>   */
>  enum riscv_isa_ext_id {
>         RISCV_ISA_EXT_SSCOFPMF = RISCV_ISA_EXT_BASE,
> +       RISCV_ISA_EXT_SSTC,
>         RISCV_ISA_EXT_ID_MAX = RISCV_ISA_EXT_MAX,
>  };
>
> diff --git a/arch/riscv/kernel/cpu.c b/arch/riscv/kernel/cpu.c
> index ccb617791e56..ca0e4c0db17e 100644
> --- a/arch/riscv/kernel/cpu.c
> +++ b/arch/riscv/kernel/cpu.c
> @@ -88,6 +88,7 @@ int riscv_of_parent_hartid(struct device_node *node)
>   */
>  static struct riscv_isa_ext_data isa_ext_arr[] = {
>         __RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
> +       __RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
>         __RISCV_ISA_EXT_DATA("", RISCV_ISA_EXT_MAX),
>  };
>
> diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
> index 1b2d42d7f589..a214537c22f1 100644
> --- a/arch/riscv/kernel/cpufeature.c
> +++ b/arch/riscv/kernel/cpufeature.c
> @@ -192,6 +192,7 @@ void __init riscv_fill_hwcap(void)
>                                 set_bit(*ext - 'a', this_isa);
>                         } else {
>                                 SET_ISA_EXT_MAP("sscofpmf", RISCV_ISA_EXT_SSCOFPMF);
> +                               SET_ISA_EXT_MAP("sstc", RISCV_ISA_EXT_SSTC);
>                         }
>  #undef SET_ISA_EXT_MAP
>                 }
> --
> 2.25.1
>
