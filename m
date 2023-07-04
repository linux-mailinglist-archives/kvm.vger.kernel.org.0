Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABA3C747459
	for <lists+kvm@lfdr.de>; Tue,  4 Jul 2023 16:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbjGDOqY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 10:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjGDOqX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 10:46:23 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B698E49
        for <kvm@vger.kernel.org>; Tue,  4 Jul 2023 07:46:22 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-98e39784a85so1026678066b.1
        for <kvm@vger.kernel.org>; Tue, 04 Jul 2023 07:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1688481980; x=1691073980;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=V1Ae3RuOxJhgI3BLugmtWq6zSsW+2ghmr3c9wVK5GFg=;
        b=pRSqaZGrtTWOvZr/isOwp6GM3vtrB6NZyPfVOZdLhRLvqlonBE1oN+OIsG7xN650tx
         msc5MaXPYAJlq+1A56sfyAxW4l7pUOmgJXmtr8OgoS0kWq8aokOG8y3K8dPh6IvZu9r0
         RRZSl5GPtoaZEaCrhkId8OaVBvphmdz4o/p6Bd+vqNCG/4Xab9kKKfv5ZA5wpJJL3TL9
         XwBelheP8ZhL6odLZBAh6eOziNGoK4VYjPhQmGUM4wevDAeoq1KzG6H8nPmPUolQITZu
         E/FNEdy2N9/A8u8S7ZpK2FfCQBYXD8KbWzTpHuxI02iubIbXNLQUj5uqDH1FBbltTF7x
         u7NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688481980; x=1691073980;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V1Ae3RuOxJhgI3BLugmtWq6zSsW+2ghmr3c9wVK5GFg=;
        b=BT3kmc0lmeXAmDrbPtvt2LtAIbWWW+Mu/HZRLDs5jkw6c25gKNIAyVEsssYfpbnvwq
         zJi5vjApViH6pq3NN43m1sCia0Ndnmn34GpAs16T1K6AIWGM1va0+cXYrdlt89ck73YL
         0xdC+zYS2I0uAkeVzFazBD1kHUk+p1z3m8BrCjGc0YOFxdbz3tMdf3IBA7mh9PZC5GJk
         b1rhrvQ7iLS0Blh7Wpte/DpAb+74Ss4PB0Y1a0JS9VCZigD9IvdKLkRqL3Ut1PDDzKbW
         HDE+TC3noyXS+sE7L/+h/7SDPsQDFa4xwbEZYE8m/PwV7HldM6r4A0/ORgqdg/B/BcA2
         koaA==
X-Gm-Message-State: AC+VfDyO8a0Km5ZsIjI0c47MmxincnaysCPMXZSbKodHjXFKJqHz7FCY
        mnh5rnqWNfOhwEEgrej0Lpkmkg==
X-Google-Smtp-Source: APBJJlHjRSFZSI7aVge0lLdM56gpzgi/7b+9c350rXY0yAmVOGJ/CQlVtcVO4S9Z4q5yAY7mfB4oww==
X-Received: by 2002:a17:907:3fa3:b0:988:d841:7f90 with SMTP id hr35-20020a1709073fa300b00988d8417f90mr15606804ejc.27.1688481980507;
        Tue, 04 Jul 2023 07:46:20 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id a12-20020a1709064a4c00b009932337747esm4805726ejv.86.2023.07.04.07.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jul 2023 07:46:19 -0700 (PDT)
Date:   Tue, 4 Jul 2023 16:46:18 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Yong-Xuan Wang <yongxuan.wang@sifive.com>
Cc:     qemu-devel@nongnu.org, qemu-riscv@nongnu.org, rkanwal@rivosinc.com,
        anup@brainfault.org, dbarboza@ventanamicro.com,
        atishp@atishpatra.org, vincent.chen@sifive.com,
        greentime.hu@sifive.com, frank.chang@sifive.com,
        jim.shu@sifive.com, Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v4 3/6] target/riscv: check the in-kernel irqchip support
Message-ID: <20230704-27481846a2cab7364d040a19@orel>
References: <20230621145500.25624-1-yongxuan.wang@sifive.com>
 <20230621145500.25624-4-yongxuan.wang@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230621145500.25624-4-yongxuan.wang@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 21, 2023 at 02:54:53PM +0000, Yong-Xuan Wang wrote:
> We check the in-kernel irqchip support when using KVM acceleration.
> 
> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> Reviewed-by: Jim Shu <jim.shu@sifive.com>
> Reviewed-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
> ---
>  target/riscv/kvm.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
> index 0f932a5b96..eb469e8ca5 100644
> --- a/target/riscv/kvm.c
> +++ b/target/riscv/kvm.c
> @@ -433,7 +433,18 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>  
>  int kvm_arch_irqchip_create(KVMState *s)
>  {
> -    return 0;
> +    if (kvm_kernel_irqchip_split()) {
> +        error_report("-machine kernel_irqchip=split is not supported "
> +                     "on RISC-V.");

It's best to not split error messages across lines. We can go to 90 chars
before checkpatch considers it an error, and I'd still consider it worse
to split an error message than to ignore checkpatch and exceed 90 chars.

> +        exit(1);
> +    }
> +
> +    /*
> +     * If we can create the VAIA using the newer device control API, we
> +     * let the device do this when it initializes itself, otherwise we
> +     * fall back to the old API

This comment appears lifted from arm, but the "fall back to the old API"
doesn't apply to riscv since riscv doesn't support KVM_CREATE_IRQCHIP.

> +     */
> +    return kvm_check_extension(s, KVM_CAP_DEVICE_CTRL);
>  }
>  
>  int kvm_arch_process_async_events(CPUState *cs)
> -- 
> 2.17.1
> 
>

Thanks,
drew
