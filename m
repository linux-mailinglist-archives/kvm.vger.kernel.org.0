Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C98A1743AF1
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 13:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbjF3LiM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 07:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjF3LiK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 07:38:10 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AEDA1FE4
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 04:38:09 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-1b06777596cso1623912fac.2
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 04:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1688125088; x=1690717088;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QNSDLMpqNgRHrErpjvOwJxdX/8ZBDXD/tjIE2wLFrwo=;
        b=n8xtPhG0P+DXLSTFY9xc468LDu+ZQckn+/Kl5N0nPUNdwsc1HBdKNYUKTlKBub47jP
         LtsKk4oOV/TRVPZjfaHx9wWXbA7tb/jzoJbaDr7MHcvn5Pwj6BuNXLKbTBjevnWFNaLM
         OaUBP3b2jVZfEq8bxfImS2b9gvxa155bf5/Am80zn0STGTEPHeT8JqMc5UfHt2++kRkD
         HPbJFeoAXqTgt3x4Ls5OUR00pVyjQY5cY8EjrJ7h0gIbP86rn2bEyg0ONus32tKpOWVO
         umfyYkHpTHQ9URtv+BSSb6tZxOrhLcCKsGbH4jpktEEJogr2CuKH5hPKui36eiEMvIvh
         Gp6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688125088; x=1690717088;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QNSDLMpqNgRHrErpjvOwJxdX/8ZBDXD/tjIE2wLFrwo=;
        b=lSGh8hJRgkyKRGDZt8gCAtw1by3KoyP5Cel2Ys4f7XoCvIwNF1twHXCvLqljGkvz2c
         VVz0bfsIo6B00mQSFwOWeyqYJimUvtcATuB1hoHaxgAWkdBGaBjaMWxAxuHvsereFm1O
         P5/rDjqgj43mkSL3d4S3CU0GHRaJAa1utagY+zCWfufjRv8AYcsnDuXNri0YRR1qYpCH
         YL+aGmZLb89i789oC0VEX3yOaeNNb7dkUr+06+fLr3SEBLGH/L6pjbCnrOjjYBGMN3zv
         VdqaLWNgvldyV6irTMOPM/4Nr6QrkVm2ErUrGC5uWckSBdwE4gfq3oDsotpqRpzghP1J
         Ut2A==
X-Gm-Message-State: AC+VfDz4TF9DD98pQwssXwrzBxiZ715K0WD2/hcB8KxNI4vRiFROyiQA
        2fGaALYf9UkY56IiT3cU8KFfoQ==
X-Google-Smtp-Source: APBJJlEA8S6sBDIVZ8QNlP9oBPkpbQcsagmQfZoaTHfjAyvvI/kHQhklkt+09qUy95TDBrcyGO490g==
X-Received: by 2002:a05:6870:170d:b0:1b0:6f63:736f with SMTP id h13-20020a056870170d00b001b06f63736fmr3723617oae.9.1688125088508;
        Fri, 30 Jun 2023 04:38:08 -0700 (PDT)
Received: from ?IPV6:2804:18:1005:1891:f8a0:1703:4d3b:4d5d? ([2804:18:1005:1891:f8a0:1703:4d3b:4d5d])
        by smtp.gmail.com with ESMTPSA id a11-20020a056870d60b00b001b0cad9f72esm1717043oaq.18.2023.06.30.04.38.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jun 2023 04:38:08 -0700 (PDT)
Message-ID: <23982ea3-dedb-5bef-fe50-7de45dd4df72@ventanamicro.com>
Date:   Fri, 30 Jun 2023 08:38:01 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] target/riscv: Remove unuseful KVM stubs
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Bin Meng <bin.meng@windriver.com>, qemu-riscv@nongnu.org,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, kvm@vger.kernel.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Alistair Francis <alistair.francis@wdc.com>
References: <20230620081611.88158-1-philmd@linaro.org>
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
In-Reply-To: <20230620081611.88158-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/20/23 05:16, Philippe Mathieu-Daudé wrote:
> Since we always check whether KVM is enabled before calling
> kvm_riscv_reset_vcpu() and kvm_riscv_set_irq(), their call
> is elided by the compiler when KVM is not available.

Had to google 'elided'. Nice touch.

> Therefore the stubs are not even linked. Remove them.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---

Tested with a simple KVM guest. Nothing bad happened.

Reviewed-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Tested-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>

>   target/riscv/kvm-stub.c  | 30 ------------------------------
>   target/riscv/kvm.c       |  4 +---
>   target/riscv/meson.build |  2 +-
>   3 files changed, 2 insertions(+), 34 deletions(-)
>   delete mode 100644 target/riscv/kvm-stub.c
> 
> diff --git a/target/riscv/kvm-stub.c b/target/riscv/kvm-stub.c
> deleted file mode 100644
> index 4e8fc31a21..0000000000
> --- a/target/riscv/kvm-stub.c
> +++ /dev/null
> @@ -1,30 +0,0 @@
> -/*
> - * QEMU KVM RISC-V specific function stubs
> - *
> - * Copyright (c) 2020 Huawei Technologies Co., Ltd
> - *
> - * This program is free software; you can redistribute it and/or modify it
> - * under the terms and conditions of the GNU General Public License,
> - * version 2 or later, as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope it will be useful, but WITHOUT
> - * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> - * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> - * more details.
> - *
> - * You should have received a copy of the GNU General Public License along with
> - * this program.  If not, see <http://www.gnu.org/licenses/>.
> - */
> -#include "qemu/osdep.h"
> -#include "cpu.h"
> -#include "kvm_riscv.h"
> -
> -void kvm_riscv_reset_vcpu(RISCVCPU *cpu)
> -{
> -    abort();
> -}
> -
> -void kvm_riscv_set_irq(RISCVCPU *cpu, int irq, int level)
> -{
> -    abort();
> -}
> diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
> index 0f932a5b96..52884bbe15 100644
> --- a/target/riscv/kvm.c
> +++ b/target/riscv/kvm.c
> @@ -503,9 +503,7 @@ void kvm_riscv_reset_vcpu(RISCVCPU *cpu)
>   {
>       CPURISCVState *env = &cpu->env;
>   
> -    if (!kvm_enabled()) {
> -        return;
> -    }
> +    assert(kvm_enabled());
>       env->pc = cpu->env.kernel_addr;
>       env->gpr[10] = kvm_arch_vcpu_id(CPU(cpu)); /* a0 */
>       env->gpr[11] = cpu->env.fdt_addr;          /* a1 */
> diff --git a/target/riscv/meson.build b/target/riscv/meson.build
> index e1ff6d9b95..37fc2cf487 100644
> --- a/target/riscv/meson.build
> +++ b/target/riscv/meson.build
> @@ -22,7 +22,7 @@ riscv_ss.add(files(
>     'crypto_helper.c',
>     'zce_helper.c'
>   ))
> -riscv_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'), if_false: files('kvm-stub.c'))
> +riscv_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'))
>   
>   riscv_softmmu_ss = ss.source_set()
>   riscv_softmmu_ss.add(files(
