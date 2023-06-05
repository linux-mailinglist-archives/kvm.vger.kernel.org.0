Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99987722EEA
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 20:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbjFESr0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 14:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbjFESrY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 14:47:24 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B7CCD
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 11:47:24 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id 5614622812f47-392116ae103so3504990b6e.0
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 11:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1685990843; x=1688582843;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k1Kg1wIo2iyavH4s8HpoaY6EzhUcDlXe84Pa6j9p1cE=;
        b=YtC+NNgE3CElzt9CkB/sbJ4biwdC4bWHyk21lpIun5XmOTB5+aNIhamP7iDECe/swU
         RzAA+9SXvphdX0dadqvJsOdo2a/PI4+OAr8/pW19+sAc29lyAyJNF59pjmhRhTVQeVGN
         b6Gz4VS+2NKMLCFWd2V058NLLTZ9w3bTD4R+yHRuPoioX0Ct+CJOJebKylF3b2R2A0YE
         3UYyt0r3YEv6dlUpPnHtkZI8vAUOiAgmMIDLs7dQgLE1B6zpTLcD8UjMB8KcxX93C2Xn
         F5MeqUDKHKIAHLMhn8JaLzkF/wyURs5+hR0J6XD3XALXDEdLXuODIVyz5yTkeUFtRo70
         pyLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685990843; x=1688582843;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k1Kg1wIo2iyavH4s8HpoaY6EzhUcDlXe84Pa6j9p1cE=;
        b=aw3ThfBZn/BgxkHpGi5rt3Z7T1dLB3JdYPlbGgpu3YhLNFyWnRL5gLFKNgkfTc+EPM
         Fk9OEcyO4U1+MPBUdIdNps7mpbuluirE6LLhAdjZCbT8ITYA7qBd/Na0aUTWc1LP1AQX
         4UDeOOriAnwnb3StP5fqEZdZG4ksHWWAfXNmiABzRk7IPyR0S8dkNYFZHKccsNv89NLb
         YUJCrIanQUw3zzxEjNqskSPg/UYFTMZvME+XSgdCev8a0B3hHMYwQTtrYHqzyEmYINQB
         Kolou+aYu+2gMLo3UEMVBvK4lJq9WXxAgbiVQYCOQZR2gIhPvZv4+DAb13NIZLCCX161
         7VSw==
X-Gm-Message-State: AC+VfDymXX5ixzAez84jHefs7Ohrt795+7d5w96yuptJPOChwjuNHaQ2
        A2GOpI8U56mk1B3uXcXZrAlgIw==
X-Google-Smtp-Source: ACHHUZ4mFsJjGwJnmczcu4jXVsnwWgG2CwbMbNXTwqXSMV0yBJBslVJi5AiDRhXrKE3vjXUA7/iwdw==
X-Received: by 2002:a05:6808:2:b0:396:fa0:f580 with SMTP id u2-20020a056808000200b003960fa0f580mr5151359oic.59.1685990843476;
        Mon, 05 Jun 2023 11:47:23 -0700 (PDT)
Received: from [192.168.68.107] ([177.170.117.52])
        by smtp.gmail.com with ESMTPSA id v5-20020acade05000000b0039a016ec102sm3790313oig.15.2023.06.05.11.47.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jun 2023 11:47:23 -0700 (PDT)
Message-ID: <2a3c6c6d-e37c-83cc-ea32-5f341ee1e24c@ventanamicro.com>
Date:   Mon, 5 Jun 2023 15:47:16 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3 3/6] target/riscv: check the in-kernel irqchip support
Content-Language: en-US
To:     Yong-Xuan Wang <yongxuan.wang@sifive.com>, qemu-devel@nongnu.org,
        qemu-riscv@nongnu.org, rkanwal@rivosinc.com, anup@brainfault.org,
        atishp@atishpatra.org, vincent.chen@sifive.com,
        greentime.hu@sifive.com, frank.chang@sifive.com, jim.shu@sifive.com
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20230526062509.31682-1-yongxuan.wang@sifive.com>
 <20230526062509.31682-4-yongxuan.wang@sifive.com>
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
In-Reply-To: <20230526062509.31682-4-yongxuan.wang@sifive.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/26/23 03:25, Yong-Xuan Wang wrote:
> We check the in-kernel irqchip support when using KVM acceleration.
> 
> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> Reviewed-by: Jim Shu <jim.shu@sifive.com>
> ---

Reviewed-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>

>   target/riscv/kvm.c | 13 ++++++++++++-
>   1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
> index 0f932a5b96..eb469e8ca5 100644
> --- a/target/riscv/kvm.c
> +++ b/target/riscv/kvm.c
> @@ -433,7 +433,18 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>   
>   int kvm_arch_irqchip_create(KVMState *s)
>   {
> -    return 0;
> +    if (kvm_kernel_irqchip_split()) {
> +        error_report("-machine kernel_irqchip=split is not supported "
> +                     "on RISC-V.");
> +        exit(1);
> +    }
> +
> +    /*
> +     * If we can create the VAIA using the newer device control API, we
> +     * let the device do this when it initializes itself, otherwise we
> +     * fall back to the old API
> +     */
> +    return kvm_check_extension(s, KVM_CAP_DEVICE_CTRL);
>   }
>   
>   int kvm_arch_process_async_events(CPUState *cs)
