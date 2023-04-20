Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8215D6E8ECF
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 12:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233952AbjDTKEG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 06:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjDTKEF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 06:04:05 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694F3C1
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 03:04:04 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id ay3-20020a05600c1e0300b003f17289710aso824913wmb.5
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 03:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681985043; x=1684577043;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OW9u69NgfoghJtPekxWhv6ZSbpygwiz3BCEEMJsPeyo=;
        b=lIhSpeijK9agANF+y803HeBcbIiAxijHKtU1tvW8GrtEUL1OdMTVXh5ANEZncqkLWg
         kQVFlb/gs3KiIfYM75DUbkPLnLez/UXpgPTu2xttY60q+Hmb5o+Nb5vtaRgjH1LV6MvY
         7UVk/SemqP/vPRbJYhGuuuQlCnyaqjokP16Ax6jTlJsP19Q3jSvlrksZNdE+brrO84dj
         zW6qXc7/QTsltAOPYGnHm+Hsrf0HIb07lebpfVPCgZcyAB+NcaYrcbC8D2u+y79PL+oN
         jL+Xa1FXK8cR4qKB/ehaV7zaJ2tZR9qRpfnznz1KEHTVDI02sWxGJNIovBOmFDDOb4I7
         BrWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681985043; x=1684577043;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OW9u69NgfoghJtPekxWhv6ZSbpygwiz3BCEEMJsPeyo=;
        b=dKLQdWGd/7DWIsWEReX5lI8FP88UG/omZSXW/l+hGF4FH8fLqWWJkMu5excOETGoJm
         P7JPeXaTUY68+bRnRbQikJQ51fIhSNkvDCCcDf0rU3gblbuTBXgGuhjcsqfBph6JW+oZ
         RSBZyvHJD3aS28exHCEme6cfSc5rDALSsBZbhuBfSr4AVWBW/bhP9XRQ/8c2EgLk3GwT
         AgIcNJ+E9W8mY5zzWr0WrMMKwtdO0ZhO3bCrIKIkCd4sCDO977w1a43CpNV4bgrIf7rg
         tWSaxtDt3pSWVJN8sqjyNHCXrh4kVc2nSZBKiRQoG4zkQyAS2Ws01g3cX3oAXs7fu/oH
         l3qQ==
X-Gm-Message-State: AAQBX9edvvWjKKeJ24bPSxjWZrdlZCFEaEJnOR0Ijc4NO7H/4Qs0DuFE
        CjpKP3SBfh9H66SF30Hd7Wf9TrjHThGH9HXTeYtxpg==
X-Google-Smtp-Source: AKy350Y0vzAbTTYdV3+M/1g7YAup2xR9RQTrz/3kqlaOCplr/2KZOndLM5NRiENhu8RQVOmgMUfMTA==
X-Received: by 2002:a05:600c:21a:b0:3ee:1acd:b039 with SMTP id 26-20020a05600c021a00b003ee1acdb039mr843685wmi.34.1681985042895;
        Thu, 20 Apr 2023 03:04:02 -0700 (PDT)
Received: from [192.168.30.216] ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id jb12-20020a05600c54ec00b003f17003e26esm4904795wmb.15.2023.04.20.03.04.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Apr 2023 03:04:02 -0700 (PDT)
Message-ID: <a315b56d-a331-5e85-ff55-4dca96088bb9@linaro.org>
Date:   Thu, 20 Apr 2023 12:04:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH RFC v1 09/10] target/loongarch: Add kvm-stub.c
Content-Language: en-US
To:     Tianrui Zhao <zhaotianrui@loongson.cn>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        gaosong@loongson.cn
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, maobibo@loongson.cn
References: <20230420093606.3366969-1-zhaotianrui@loongson.cn>
 <20230420093606.3366969-10-zhaotianrui@loongson.cn>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230420093606.3366969-10-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/4/23 11:36, Tianrui Zhao wrote:
> Add kvm-stub.c for loongarch, there are two stub functions:
> kvm_loongarch_reset_vcpu and kvm_loongarch_set_interrupt.
> 
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>   target/loongarch/kvm-stub.c      | 17 +++++++++++++++++
>   target/loongarch/kvm_loongarch.h |  1 +
>   2 files changed, 18 insertions(+)
>   create mode 100644 target/loongarch/kvm-stub.c
> 
> diff --git a/target/loongarch/kvm-stub.c b/target/loongarch/kvm-stub.c
> new file mode 100644
> index 0000000000..e28827ee07
> --- /dev/null
> +++ b/target/loongarch/kvm-stub.c
> @@ -0,0 +1,17 @@
> +/*
> + * QEMU KVM LoongArch specific function stubs
> + *
> + * Copyright (c) 2023 Loongson Technology Corporation Limited
> + */
> +#include "qemu/osdep.h"
> +#include "cpu.h"
> +
> +void kvm_loongarch_reset_vcpu(LoongArchCPU *cpu)

Where is kvm_loongarch_reset_vcpu() called?

> +{
> +    abort();
> +}
> +
> +void kvm_loongarch_set_interrupt(LoongArchCPU *cpu, int irq, int level)
> +{
> +    abort();

Please use g_assert_not_reached() which display more useful informations.

> +}

Add this stub in the previous patch "Implement set vcpu intr for kvm".

> diff --git a/target/loongarch/kvm_loongarch.h b/target/loongarch/kvm_loongarch.h
> index cdef980eec..c03f4bef0f 100644
> --- a/target/loongarch/kvm_loongarch.h
> +++ b/target/loongarch/kvm_loongarch.h
> @@ -8,6 +8,7 @@
>   #ifndef QEMU_KVM_LOONGARCH_H
>   #define QEMU_KVM_LOONGARCH_H
>   
> +void kvm_loongarch_reset_vcpu(LoongArchCPU *cpu);
>   int  kvm_loongarch_set_interrupt(LoongArchCPU *cpu, int irq, int level);
>   
>   #endif

