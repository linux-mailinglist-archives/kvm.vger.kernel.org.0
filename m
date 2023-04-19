Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC746E7155
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 04:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbjDSCsH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 22:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbjDSCsF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 22:48:05 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA0B9EEA
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 19:47:30 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id fw30so25262965ejc.5
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 19:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20221208.gappssmtp.com; s=20221208; t=1681872410; x=1684464410;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T2vBa433INXpwxf/vQcrrT0UFfPGPq+8GhQBLQMIVnQ=;
        b=3x3qdfqgPPOdkPFYRRoL/OQsV3IxiwB9/khhNg39FXiAgvw7/7Yq9YdaCcTqSTKdMO
         e3a7xh8XXy+xTWB1c4HQyw2ZyXBNN6+CNFtaHowG6IyPsBGd+zA8o+dSKBOxaaNpeUea
         s1dvdCFgQww8OhXVi5utwAkwfKJL3g8SIxbDREJ9TJkH1XhqcV0wJi0fRtbWY+xoaPnM
         dIc/8hCwmSNE9Odw4s3zyhYdi7Z0/i9T7sfRc4btYCFhPy3+Ps5C7WM0tF5E6Pb8GKQE
         47s95eExISnQL2ApcOfZRBZ+i+ojB4kwHKKL2sb5+NgXE2zFXsuDtoKioWSX7TipfLg9
         cgEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681872410; x=1684464410;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T2vBa433INXpwxf/vQcrrT0UFfPGPq+8GhQBLQMIVnQ=;
        b=lUAT70TtZp8pV/U8nV2+UMcmnu9GFa4OPKUY0hVDJmZfFNU6d42yDT47YwDfz8YJOV
         NS+nTQkfNeORMrMeO6hLK3bGwQQB8uOa2PNn43cELUnzkHWtZfT+l9wySvT1vjQQmHze
         t2x+UFdW+j8TDt6FjiQfA0Er51bnJhLpjxWa8qsZdo3VIJarC0kY5dW/NA5Pt9M9zOoX
         /+QXwx17nOZVGWxGy82VEy4th7TVhP7gYZpfae4V0FKiEUX09I7t5D0E1H0n4gCcxIA+
         8x2GuEk6T2SvlPe/rVq7a6sbWX681yu56pfxZLKKIEAYdAI3BViAmfLgA6K6DtOxeT3m
         d12Q==
X-Gm-Message-State: AAQBX9cYhIVtcg1Qgoc9lAb5AUcolWC2vhVMNrCwkV3tP3qYjFE08z/r
        prVV8L8jdlsgWtlNZboWZ6dsni4krzSx0SVOErvDxg==
X-Google-Smtp-Source: AKy350Z6+jK/PM/xSJspnT7QqbQWFEVMFBr49J7MQW6Uh3I2UmQ5STweXzYucN2UX8zPn3hAX2G+olN+d0Gh41fLahY=
X-Received: by 2002:a17:906:c355:b0:94f:b5c:a254 with SMTP id
 ci21-20020a170906c35500b0094f0b5ca254mr11125425ejb.49.1681872410050; Tue, 18
 Apr 2023 19:46:50 -0700 (PDT)
MIME-Version: 1.0
References: <20230404153452.2405681-1-apatel@ventanamicro.com> <20230404153452.2405681-3-apatel@ventanamicro.com>
In-Reply-To: <20230404153452.2405681-3-apatel@ventanamicro.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Wed, 19 Apr 2023 08:16:37 +0530
Message-ID: <CAAhSdy1FKKt-RpE5f8ZEaQyoJL4oEr=YB3MfKDdHqFmL+AyrHg@mail.gmail.com>
Subject: Re: [PATCH v4 2/9] RISC-V: Detect AIA CSRs from ISA string
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Atish Patra <atishp@rivosinc.com>,
        Anup Patel <apatel@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Palmer,

On Tue, Apr 4, 2023 at 9:05=E2=80=AFPM Anup Patel <apatel@ventanamicro.com>=
 wrote:
>
> We have two extension names for AIA ISA support: Smaia (M-mode AIA CSRs)
> and Ssaia (S-mode AIA CSRs).
>
> We extend the ISA string parsing to detect Smaia and Ssaia extensions.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> Reviewed-by: Atish Patra <atishp@rivosinc.com>

Can you please ACK this patch so that I can include it in Linux-6.4 PR ?

Regards,
Anup

> ---
>  arch/riscv/include/asm/hwcap.h | 2 ++
>  arch/riscv/kernel/cpu.c        | 2 ++
>  arch/riscv/kernel/cpufeature.c | 2 ++
>  3 files changed, 6 insertions(+)
>
> diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwca=
p.h
> index 6263a0de1c6a..74f5dab2148f 100644
> --- a/arch/riscv/include/asm/hwcap.h
> +++ b/arch/riscv/include/asm/hwcap.h
> @@ -42,6 +42,8 @@
>  #define RISCV_ISA_EXT_ZBB              30
>  #define RISCV_ISA_EXT_ZICBOM           31
>  #define RISCV_ISA_EXT_ZIHINTPAUSE      32
> +#define RISCV_ISA_EXT_SMAIA            33
> +#define RISCV_ISA_EXT_SSAIA            34
>
>  #define RISCV_ISA_EXT_MAX              64
>  #define RISCV_ISA_EXT_NAME_LEN_MAX     32
> diff --git a/arch/riscv/kernel/cpu.c b/arch/riscv/kernel/cpu.c
> index 8400f0cc9704..ae1e7bbf9344 100644
> --- a/arch/riscv/kernel/cpu.c
> +++ b/arch/riscv/kernel/cpu.c
> @@ -188,6 +188,8 @@ static struct riscv_isa_ext_data isa_ext_arr[] =3D {
>         __RISCV_ISA_EXT_DATA(zicbom, RISCV_ISA_EXT_ZICBOM),
>         __RISCV_ISA_EXT_DATA(zihintpause, RISCV_ISA_EXT_ZIHINTPAUSE),
>         __RISCV_ISA_EXT_DATA(zbb, RISCV_ISA_EXT_ZBB),
> +       __RISCV_ISA_EXT_DATA(smaia, RISCV_ISA_EXT_SMAIA),
> +       __RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),
>         __RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
>         __RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
>         __RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
> diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeatur=
e.c
> index 59d58ee0f68d..9e92e23f6f82 100644
> --- a/arch/riscv/kernel/cpufeature.c
> +++ b/arch/riscv/kernel/cpufeature.c
> @@ -221,6 +221,8 @@ void __init riscv_fill_hwcap(void)
>                                 }
>                         } else {
>                                 /* sorted alphabetically */
> +                               SET_ISA_EXT_MAP("smaia", RISCV_ISA_EXT_SM=
AIA);
> +                               SET_ISA_EXT_MAP("ssaia", RISCV_ISA_EXT_SS=
AIA);
>                                 SET_ISA_EXT_MAP("sscofpmf", RISCV_ISA_EXT=
_SSCOFPMF);
>                                 SET_ISA_EXT_MAP("sstc", RISCV_ISA_EXT_SST=
C);
>                                 SET_ISA_EXT_MAP("svinval", RISCV_ISA_EXT_=
SVINVAL);
> --
> 2.34.1
>
