Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 327EE7C4808
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 04:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344895AbjJKC4X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 22:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344865AbjJKC4W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 22:56:22 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0D292
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 19:56:20 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-9ba1eb73c27so495177366b.3
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 19:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696992979; x=1697597779; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Lfejmu0fed9jzJQJl9bYK7nnwauq98g5xtw+qWD1PB4=;
        b=QieBLwzTpN+kQOZiddRcMPtbjygEcI+/cjkViq+axoszrh+HnT5az8jazhgDVxl9e7
         cAPSaloTb9ODcbVsrI1/S6qE53PVxLHOhTqkoYfNtrNdZHE9SjtYWEghIv9UABXY6pMO
         /Gp5s4h6tbrQ6PgJcmXIPJkLcGX/I8kygQCp22JgVblktFGGNhUsNMx5BtFfQRTfKCIn
         igYYEPO2uleSowPTU/8EJa5oWWagnkkmNBrJYzWRKd/KCsz1SnMmsGsY8UiR+UAM7Q1i
         QufV3Zd0j72A3tvlcDqJaJYevNZ8RcLj3LTKceHtt1hopf+0+KCT+vj8msmCwlfDdgZL
         z3NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696992979; x=1697597779;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lfejmu0fed9jzJQJl9bYK7nnwauq98g5xtw+qWD1PB4=;
        b=IyCWSBXJXl37A2S1wfnKCWzSHxaT3XQEEFLsaG+VjOVWqeYAEQHlfQDvL1JWFfKPRt
         mFzBWuIBEelbgxdK6WlxhGwsa8hoIy1h3fI+OuJyBqFsYpGl8S465lNefpuLHIvd6+Md
         Gftz9uzgFStM38mdK7oxL2I53XQwQqB4ie+X3+EjLLOfRCe52hGQTnWc+Pu5nTR4yGep
         9xyuaUpYmWY45nu6T6mVGJ/nyVEal0RfR8uTVsHsR4Dw6w8vMRjXmyVMHyYyqFsd7iaC
         VSN+Imro5A5Ae7JN/kiOirNGNF2+EU36leZb2pHAZ/twqkcUzTN+xZ0jvljckhB8yEnh
         +r9A==
X-Gm-Message-State: AOJu0Yz0Kt7/k1TAM75j/BM1vn2SgWciCTx2XnPG4gbF8tgypKLf/al5
        B3PeBfMVw76cYFljJIvA4wNaSg==
X-Google-Smtp-Source: AGHT+IEUiOgBTZwsDp2qaWW9mB0p6/rF7r1VbnY60qxYtxdDpcO86CsSe1aSdzoojgJBUbOlxkKJkw==
X-Received: by 2002:a17:906:846c:b0:9b6:8155:cbf4 with SMTP id hx12-20020a170906846c00b009b68155cbf4mr17170768ejc.47.1696992979194;
        Tue, 10 Oct 2023 19:56:19 -0700 (PDT)
Received: from [192.168.69.115] (mdq11-h01-176-173-161-48.dsl.sta.abo.bbox.fr. [176.173.161.48])
        by smtp.gmail.com with ESMTPSA id si5-20020a170906cec500b009ae0042e48bsm9129261ejb.5.2023.10.10.19.56.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Oct 2023 19:56:18 -0700 (PDT)
Message-ID: <1f552f71-3b47-a2be-67c5-fdca86bf59f7@linaro.org>
Date:   Wed, 11 Oct 2023 04:56:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH RFC v4 4/9] target/loongarch: Implement kvm get/set
 registers
Content-Language: en-US
To:     xianglai li <lixianglai@loongson.cn>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc:     Tianrui Zhao <zhaotianrui@loongson.cn>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Bibo Mao <maobibo@loongson.cn>, Song Gao <gaosong@loongson.cn>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>
References: <cover.1696841645.git.lixianglai@loongson.cn>
 <f4399db694265f34dbe9aafd024c56470e8a0f54.1696841645.git.lixianglai@loongson.cn>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <f4399db694265f34dbe9aafd024c56470e8a0f54.1696841645.git.lixianglai@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Li and Zhao,

On 9/10/23 11:01, xianglai li wrote:
> From: Tianrui Zhao <zhaotianrui@loongson.cn>
> 
> Implement kvm_arch_get/set_registers interfaces, many regs
> can be get/set in the function, such as core regs, csr regs,
> fpu regs, mp state, etc.
> 
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: "Marc-André Lureau" <marcandre.lureau@redhat.com>
> Cc: "Daniel P. Berrangé" <berrange@redhat.com>
> Cc: Thomas Huth <thuth@redhat.com>
> Cc: "Philippe Mathieu-Daudé" <philmd@linaro.org>
> Cc: Richard Henderson <richard.henderson@linaro.org>
> Cc: Peter Maydell <peter.maydell@linaro.org>
> Cc: Bibo Mao <maobibo@loongson.cn>
> Cc: Song Gao <gaosong@loongson.cn>
> Cc: Xiaojuan Yang <yangxiaojuan@loongson.cn>
> Cc: Tianrui Zhao <zhaotianrui@loongson.cn>
> 
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> Signed-off-by: xianglai li <lixianglai@loongson.cn>
> ---
>   meson.build                   |   1 +
>   target/loongarch/cpu.c        |   3 +
>   target/loongarch/cpu.h        |   2 +
>   target/loongarch/kvm.c        | 406 +++++++++++++++++++++++++++++++++-
>   target/loongarch/trace-events |  13 ++
>   target/loongarch/trace.h      |   1 +
>   6 files changed, 424 insertions(+), 2 deletions(-)
>   create mode 100644 target/loongarch/trace-events
>   create mode 100644 target/loongarch/trace.h


> +static int kvm_larch_getq(CPUState *cs, uint64_t reg_id,
> +                                 uint64_t *addr)
> +{
> +    struct kvm_one_reg csrreg = {
> +        .id = reg_id,
> +        .addr = (uintptr_t)addr
> +    };
> +
> +    return kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &csrreg);
> +}

This is kvm_get_one_reg().

> +static int kvm_larch_putq(CPUState *cs, uint64_t reg_id,
> +                                 uint64_t *addr)
> +{
> +    struct kvm_one_reg csrreg = {
> +        .id = reg_id,
> +        .addr = (uintptr_t)addr
> +    };
> +
> +    return kvm_vcpu_ioctl(cs, KVM_SET_ONE_REG, &csrreg);
> +}

This is kvm_set_one_reg().

> +
> +#define KVM_GET_ONE_UREG64(cs, ret, regidx, addr)                 \
> +    ({                                                            \
> +        err = kvm_larch_getq(cs, KVM_IOC_CSRID(regidx), addr);    \
> +        if (err < 0) {                                            \
> +            ret = err;                                            \
> +            trace_kvm_failed_get_csr(regidx, strerror(errno));    \
> +        }                                                         \
> +    })
> +
> +#define KVM_PUT_ONE_UREG64(cs, ret, regidx, addr)                 \
> +    ({                                                            \
> +        err = kvm_larch_putq(cs, KVM_IOC_CSRID(regidx), addr);    \
> +        if (err < 0) {                                            \
> +            ret = err;                                            \
> +            trace_kvm_failed_put_csr(regidx, strerror(errno));    \
> +        }                                                         \
> +    })

