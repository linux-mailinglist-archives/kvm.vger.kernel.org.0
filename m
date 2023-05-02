Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64DE86F42A8
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 13:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233930AbjEBLYM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 07:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233957AbjEBLYI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 07:24:08 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6197D59F9
        for <kvm@vger.kernel.org>; Tue,  2 May 2023 04:24:05 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f1728c2a57so36391925e9.0
        for <kvm@vger.kernel.org>; Tue, 02 May 2023 04:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683026644; x=1685618644;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a5MA3rQRemK8vwB863cSKTIFHdK8lYr1gYMNYZeBKeI=;
        b=Bcbs8ecD/s8OWC21qQHCXgtIOtsz+e9N2pEuihhlSmtvkG35bJz9rt3nEdqA/AtGjk
         utncNU76BTjlSaS2PZUAxKc4rgDIoetgH+uJ78vG76+tMs4flN3NEUeUPHQohOkzqVrF
         QY46VQ95P1tdDKnjzJtzgYtjQwDwsZiAPjoL5pSYCeUTka2hvlf4xfa2M6GAseTV45Tw
         lFNBODkjg3LMdbtliqpXu6v40kWJwep2aRzm+bljEzEpw7Z7Kl0AsaZ8j/xeQbJpLpxI
         1poX83LTnlPRA/vlUlLjTIpPb7g6cbmpLP+sJvY3GbZLhv/aqOzQMem+iiNFvk18ffbL
         BN5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683026644; x=1685618644;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a5MA3rQRemK8vwB863cSKTIFHdK8lYr1gYMNYZeBKeI=;
        b=D0JTCuzc3WhVcVvqeCxgvfPcs0xYWBkpH4N8W8b7dGN7L3oHo2XQIFEa7wt/TF6cud
         1Wc3Dyfr3klv6L8RADkNMNMWURFp1kVlEi3RA9Hh2wqRU8fYrNy/dGwQaxHWVC1QAKrI
         sVLsMd7Y99EjZkclN1gN+QyLPY5tBZK1v0PEysXppl3JRy4IS1mi6BRBOrxWB6zGoD5c
         HTHB4kiLFyx/SDG2syMDb9ft9tH40hBL3iqpRzxaC7RgeI3VaHxQOkAEq421r5UqCSFg
         SwjNGdSYpU2+n/hy9g3hdHdpAsW276Akgw+8mZCBnpUxCJd+1v6r1gMGIC3R+1sVWrX3
         vD2A==
X-Gm-Message-State: AC+VfDyd8gbq+ZrP5lzfJhVi6usSNVm5cCgr4ItSiUc5zqrC2BN3Dvox
        81FZlir/w99PRnAuaxXp6DbCVQ==
X-Google-Smtp-Source: ACHHUZ7IUxz2XiSXh2Z7OVd+ZpYhhnpq0k/iIvRAzjGD5j9n/5HiUZGXvd1IXj2MvorQhMZXMD70QA==
X-Received: by 2002:a1c:7203:0:b0:3f1:7b8d:38ec with SMTP id n3-20020a1c7203000000b003f17b8d38ecmr11402774wmc.35.1683026643674;
        Tue, 02 May 2023 04:24:03 -0700 (PDT)
Received: from ?IPV6:2a02:c7c:74db:8d00:ad29:f02c:48a2:269c? ([2a02:c7c:74db:8d00:ad29:f02c:48a2:269c])
        by smtp.gmail.com with ESMTPSA id f12-20020a5d4dcc000000b0030630de6fbdsm3889044wru.13.2023.05.02.04.24.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 May 2023 04:24:03 -0700 (PDT)
Message-ID: <f56a6f93-c3ae-5d61-f6ab-bb1eee265197@linaro.org>
Date:   Tue, 2 May 2023 12:24:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH RFC v2 4/9] target/loongarch: Implement kvm get/set
 registers
Content-Language: en-US
To:     Tianrui Zhao <zhaotianrui@loongson.cn>, qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        gaosong@loongson.cn, "Michael S . Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, maobibo@loongson.cn,
        philmd@linaro.org, peter.maydell@linaro.org
References: <20230427072645.3368102-1-zhaotianrui@loongson.cn>
 <20230427072645.3368102-5-zhaotianrui@loongson.cn>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230427072645.3368102-5-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/27/23 08:26, Tianrui Zhao wrote:
> Implement kvm_arch_get/set_registers interfaces, many regs
> can be get/set in the function, such as core regs, csr regs,
> fpu regs, mp state, etc.
> 
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>   meson.build                   |   1 +
>   target/loongarch/kvm.c        | 356 +++++++++++++++++++++++++++++++++-
>   target/loongarch/trace-events |  11 ++
>   target/loongarch/trace.h      |   1 +
>   4 files changed, 367 insertions(+), 2 deletions(-)
>   create mode 100644 target/loongarch/trace-events
>   create mode 100644 target/loongarch/trace.h
> 
> diff --git a/meson.build b/meson.build
> index 29f8644d6d..b1b29299da 100644
> --- a/meson.build
> +++ b/meson.build
> @@ -3039,6 +3039,7 @@ if have_system or have_user
>       'target/s390x',
>       'target/s390x/kvm',
>       'target/sparc',
> +    'target/loongarch',
>     ]

Sort before mips to keep alphabetic ordering.

> +static int kvm_loongarch_get_regs_core(CPUState *cs)
> +{
> +    int ret = 0;
> +    int i;
> +    struct kvm_regs regs;
> +    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
> +    CPULoongArchState *env = &cpu->env;
> +
> +    /* Get the current register set as KVM seems it */
> +    ret = kvm_vcpu_ioctl(cs, KVM_GET_REGS, &regs);
> +    if (ret < 0) {
> +        trace_kvm_failed_get_regs_core(strerror(errno));
> +        return ret;
> +    }
> +
> +    for (i = 0; i < 32; i++) {
> +        env->gpr[i] = regs.gpr[i];

For i = 1; register 0 is 0...

> +static inline int kvm_larch_getq(CPUState *cs, uint64_t reg_id,
> +                                 uint64_t *addr)
> +{
> +    struct kvm_one_reg csrreg = {
> +        .id = reg_id,
> +        .addr = (uintptr_t)addr
> +    };
> +
> +    return kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &csrreg);
> +}

Drop inline marker and let the compiler choose.

> +static inline int kvm_larch_putq(CPUState *cs, uint64_t reg_id,
> +                                 uint64_t *addr)

Likewise.

Otherwise,
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~
