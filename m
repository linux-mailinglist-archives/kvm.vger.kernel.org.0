Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75C6F72503F
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 00:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239988AbjFFWxv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 18:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238217AbjFFWxu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 18:53:50 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010AC119
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 15:53:48 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-4f620583bc2so4449726e87.1
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 15:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google; t=1686092027; x=1688684027;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XjJMiQ5w1XTPPbpdRBELR1zKtrWIvK1twSB7HWY4pu8=;
        b=mfskhz4iEylIjlHni1fvj3nELXtwocVQsqkILmDfLRyghnqtTZFCzI+Gab38jBRltq
         n4853KaTlAWS1M/yVUy+e8SLsResMCgkqobcG5KE0I9jC58+y2vwKOXQaLFSGxtNC3EZ
         qKqL3rd9sZVbpc1ZW89zUMZueMELW1MNfxSCM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686092027; x=1688684027;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XjJMiQ5w1XTPPbpdRBELR1zKtrWIvK1twSB7HWY4pu8=;
        b=fDMQnItA4D6mbq8iBDwAbsbCSBBkKOnAG44yHHSGTpcfaz7H4IKpoFVYP31wv7kBJ2
         MAdhh4Dhkd2NYeYy5Tr/Elx65anADCilHCWDfvOAm27GIN4lgj3yaee+032GMuv1Cq0b
         heNoPpFaL4QF6YWZ23tZ5vm/+ZvFeGwxHyAjOP7a8NtopuWh2y2JDcsDvGeXvu87IDqA
         ZRz8+zOwNu2hfgR2qomrh//7jkdo/CX9lZ1AZwYq4dwvW2PQCHxgu+nIKC9pfH+Q1inW
         ZngGtuVuom1h1D6u8rwXNRyfOYtS7Uyh4ikqw6T73JHu45Do1QAzLZPHdKK9lJI3quyt
         +CnQ==
X-Gm-Message-State: AC+VfDw2LuajIvqbz/dUja/FT/7Vyr5xV/t/Xy+ivRW5GkZerZIS4/Ow
        ANTTJAhcCkq9AWoX5zYeCzYuK8c7qGFD/1MgGV/O
X-Google-Smtp-Source: ACHHUZ7gSkQmw1YJLMlVzZ00W76dJMzR9peUN3YL4RBzO3ovm1RvKi+qFvcmNU7mz3JiSjCw5WFvJuiT2SqQe3bqj2o=
X-Received: by 2002:a2e:9795:0:b0:2ae:d39c:4c36 with SMTP id
 y21-20020a2e9795000000b002aed39c4c36mr1492715lji.7.1686092027210; Tue, 06 Jun
 2023 15:53:47 -0700 (PDT)
MIME-Version: 1.0
References: <20230517105135.1871868-1-apatel@ventanamicro.com> <20230517105135.1871868-5-apatel@ventanamicro.com>
In-Reply-To: <20230517105135.1871868-5-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Tue, 6 Jun 2023 15:53:35 -0700
Message-ID: <CAOnJCUKpPAZ5-49xNxhYRZ01o9pbQx84j3xbtL-5CsJuSrR18g@mail.gmail.com>
Subject: Re: [PATCH 04/10] RISC-V: KVM: Set kvm_riscv_aia_nr_hgei to zero
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 17, 2023 at 3:52=E2=80=AFAM Anup Patel <apatel@ventanamicro.com=
> wrote:
>
> We hard-code the kvm_riscv_aia_nr_hgei to zero until IMSIC HW
> guest file support is added in KVM RISC-V.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/kvm/aia.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
> index c78c06d99e39..3f97575707eb 100644
> --- a/arch/riscv/kvm/aia.c
> +++ b/arch/riscv/kvm/aia.c
> @@ -408,7 +408,7 @@ int kvm_riscv_aia_alloc_hgei(int cpu, struct kvm_vcpu=
 *owner,
>
>         raw_spin_unlock_irqrestore(&hgctrl->lock, flags);
>
> -       /* TODO: To be updated later by AIA in-kernel irqchip support */
> +       /* TODO: To be updated later by AIA IMSIC HW guest file support *=
/
>         if (hgei_va)
>                 *hgei_va =3D NULL;
>         if (hgei_pa)
> @@ -610,6 +610,14 @@ int kvm_riscv_aia_init(void)
>         if (kvm_riscv_aia_nr_hgei)
>                 kvm_riscv_aia_nr_hgei--;
>
> +       /*
> +        * Number of usable HGEI lines should be minimum of per-HART
> +        * IMSIC guest files and number of bits in HGEIE
> +        *
> +        * TODO: To be updated later by AIA IMSIC HW guest file support
> +        */
> +       kvm_riscv_aia_nr_hgei =3D 0;
> +
>         /* Initialize guest external interrupt line management */
>         rc =3D aia_hgei_init();
>         if (rc)
> --
> 2.34.1
>

Reviewed-by: Atish Patra <atishp@rivosinc.com>

--=20
Regards,
Atish
