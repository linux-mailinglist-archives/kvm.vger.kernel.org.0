Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 790AE5328E1
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 13:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236570AbiEXLYb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 07:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiEXLYa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 07:24:30 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8FB79395
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 04:24:29 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id h19-20020a05600c351300b003975cedb52bso744001wmq.1
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 04:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yfCYl4aV74lIhtPwwS5Hj7a7JLAdHT5HtAXAEPKuxxw=;
        b=SkEJCBhdLlFzmsU79CLKeBLhUBGc21SllCmNz5BJw0D+GbWUAg3Zor9zFl//oWG9OQ
         1KqWUyp7inB2ZpNmoLokYAd8tGeJKSoR6AekxiFG2LEQatcPdWNKdIJWK29PLSmaZsB5
         JxL1fWSOpTzkKylyxE3ZuvMWFMEstvhrZYDbUuNk/rZ5Zx4zngCqCIbqcQ6YH/vuBi20
         VIks0/oZF9dqUp065iC0043Ymy+cQlQwBdgRz00WN4dOlxYm0cxnVAM5rVfDclmsh21e
         3fWOrYqDrjvFiqnovynEsyG8xRnUrUKu6yIGDITpsgMjPaUn6Cg+Ts3d7vsLJrCJ2tZH
         tHfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yfCYl4aV74lIhtPwwS5Hj7a7JLAdHT5HtAXAEPKuxxw=;
        b=PgJkVdvFRlwGGtJFCqPTniEpTgVgvLTHWGC3NpsAnnYzB5Pn6uxbEQOk9mu+OTj6Pq
         1QMUvBXQaqboPGDmuqzFb2ocKke9Yl3qt1yuTvPS6VWGzWrtAJQW7IcC8C1FOcCkYsiE
         WuFLXQjkdfdqfIcXR8U+k3F+mj5HtXH6MaBumfNng0GBpv2Hs/0X5aZ6nKTs6qjDPalB
         6m/EWSFAa5GcD9KHWhUvBQVHu6THnVybHIy0JDaLq+PjU0a3Eh0SE8EN0zWrS4iHmfYr
         N3eSOVmQWCNwADHPo8iGtO+OODXdAm1GXMX8YaW/Vz+RpObHMIu0jbqT+ezeU2JC6NKl
         99iQ==
X-Gm-Message-State: AOAM532sDA3EJsu5qP7EqhjyojU0dtj/cUJVhjs1dYNSkOmEEZRF8PXO
        yC3WLgnvvzKiJzD2kTX0tk65Lz6JS+IPtDr4rwVFw+DBWT18pKJb
X-Google-Smtp-Source: ABdhPJw17mFO2a4bDkcxbKfi5pHfVkge6/luoUZPssTZkTO6b1Ep89/x1yZbqkfqlaxo1Z8MUx6f2F8ncymnnSC1FM0=
X-Received: by 2002:a05:600c:5112:b0:397:53f5:e15b with SMTP id
 o18-20020a05600c511200b0039753f5e15bmr3292625wms.93.1653391468187; Tue, 24
 May 2022 04:24:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220426185245.281182-1-atishp@rivosinc.com> <20220426185245.281182-2-atishp@rivosinc.com>
In-Reply-To: <20220426185245.281182-2-atishp@rivosinc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 24 May 2022 16:54:16 +0530
Message-ID: <CAAhSdy2Xco9wZrQ8tFfFNkNxkOcDksvi3EySdVNFtKGxVyceYQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] RISC-V: Add SSTC extension CSR details
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
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 27, 2022 at 12:23 AM Atish Patra <atishp@rivosinc.com> wrote:
>
> This patch just introduces the required CSR fields related to the
> SSTC extension.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

Looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/include/asm/csr.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
> index e935f27b10fd..10f4e1c36908 100644
> --- a/arch/riscv/include/asm/csr.h
> +++ b/arch/riscv/include/asm/csr.h
> @@ -227,6 +227,9 @@
>  #define CSR_SIP                        0x144
>  #define CSR_SATP               0x180
>
> +#define CSR_STIMECMP           0x14D
> +#define CSR_STIMECMPH          0x15D
> +
>  #define CSR_VSSTATUS           0x200
>  #define CSR_VSIE               0x204
>  #define CSR_VSTVEC             0x205
> @@ -236,6 +239,8 @@
>  #define CSR_VSTVAL             0x243
>  #define CSR_VSIP               0x244
>  #define CSR_VSATP              0x280
> +#define CSR_VSTIMECMP          0x24D
> +#define CSR_VSTIMECMPH         0x25D
>
>  #define CSR_HSTATUS            0x600
>  #define CSR_HEDELEG            0x602
> @@ -251,6 +256,8 @@
>  #define CSR_HTINST             0x64a
>  #define CSR_HGATP              0x680
>  #define CSR_HGEIP              0xe12
> +#define CSR_HENVCFG            0x60A
> +#define CSR_HENVCFGH           0x61A
>
>  #define CSR_MSTATUS            0x300
>  #define CSR_MISA               0x301
> @@ -312,6 +319,10 @@
>  #define IE_TIE         (_AC(0x1, UL) << RV_IRQ_TIMER)
>  #define IE_EIE         (_AC(0x1, UL) << RV_IRQ_EXT)
>
> +/* ENVCFG related bits */
> +#define HENVCFG_STCE   63
> +#define HENVCFGH_STCE  31
> +
>  #ifndef __ASSEMBLY__
>
>  #define csr_swap(csr, val)                                     \
> --
> 2.25.1
>
