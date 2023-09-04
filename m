Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA6E791903
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 15:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243929AbjIDNoH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 09:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233890AbjIDNoB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 09:44:01 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F9A41736
        for <kvm@vger.kernel.org>; Mon,  4 Sep 2023 06:43:32 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-991c786369cso228735066b.1
        for <kvm@vger.kernel.org>; Mon, 04 Sep 2023 06:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693835010; x=1694439810; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f5gJGVqrlSeBvbT8wDuFPneP9PS9Ap5c60pUdhWj/1g=;
        b=dQY1cv5qC5gvMLJXGwyW6gI3vUuu9jZ25Ie4PSYtXTQ3EXb7DChratXHCSlsoml8wa
         ssCAdcJB+ZTezTm4b0VlEPlTjqt+Q01gxqOh7/segKqfDP+okC+PsSgXEM179yVGqYVW
         LVuLaEP2Gq8hxEZyoKXkNfirDcVpxU4i0FS8cDBetVJ+3A24+ylYa4/yYr9Yv4/HKEfN
         B7KRVKhKOevFYo6TUTIVU0ZB5jp8f/yNUVjXnzxnPP1zbdIswQ7au7v65KJL+3mTUpGE
         v5MyRiUSWYEMUDk3ql0yN93Bv7Jcpb+gd911SPi/PiHkGm4JHfxEsNTTZqUVvEb01ETm
         USLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693835010; x=1694439810;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f5gJGVqrlSeBvbT8wDuFPneP9PS9Ap5c60pUdhWj/1g=;
        b=IU5RmyGK4HAk8BJsCDkbUQBHI2bLnSiM/rt2+7iNMpd6UI0URMb6vwvXszU4GL5VF5
         au9/qIvovU1L1SCfDyscNjTTIJa1BTpx7u6T/HywFGYVNO972f7pk9+JWiHQUxl0l5MF
         HQXigyuspgPI9GYh1SHIE0sdBPoefT7Q/lRzJng7GLLaYV0I/fa7RqXycHkQIRChbX0S
         148tUeCNsPl5GMhC8jw3jPipHUMXhTr/UPKIyYLLcwp/LZCS0AcceRbcxt0La3zWTea8
         w1P24OxYkItxrH56FF2KN63POvbGYtL/BjcMRSROmhmZJn1tGuQjv1eYHHt8gK5NLYnf
         QyBA==
X-Gm-Message-State: AOJu0YzyeLYJLltMG0s8KqxwmyBcQTTJw0y0Ak6nuS6N2ubxEh2Uw5m2
        c/daiybaakenqOe3WBvxm2HQaA==
X-Google-Smtp-Source: AGHT+IEayKzsFdONfTDgJQTz2lzK1Hv/KT4rI4AD4K19/V03MlRp8J8ARMaQnecpWTsfHk7ts1ZlVw==
X-Received: by 2002:a17:906:212:b0:9a1:f6e0:12f4 with SMTP id 18-20020a170906021200b009a1f6e012f4mr7867176ejd.15.1693835010245;
        Mon, 04 Sep 2023 06:43:30 -0700 (PDT)
Received: from [192.168.69.115] ([176.187.209.227])
        by smtp.gmail.com with ESMTPSA id j24-20020a170906051800b0099bcdfff7cbsm6148985eja.160.2023.09.04.06.43.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Sep 2023 06:43:29 -0700 (PDT)
Message-ID: <01d89654-99fe-8a14-e753-698f4025c106@linaro.org>
Date:   Mon, 4 Sep 2023 15:43:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH 07/13] target/i386: Allow elision of kvm_enable_x2apic()
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Peter Xu <peterx@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
References: <20230904124325.79040-1-philmd@linaro.org>
 <20230904124325.79040-8-philmd@linaro.org>
 <4b7bb33a-625d-5ad4-2110-c575b173aad9@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <4b7bb33a-625d-5ad4-2110-c575b173aad9@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/9/23 15:40, Paolo Bonzini wrote:
> On 9/4/23 14:43, Philippe Mathieu-Daudé wrote:
>> Call kvm_enabled() before kvm_enable_x2apic() to
>> let the compiler elide its call.
>>
>> Suggested-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---
>>   hw/i386/intel_iommu.c      | 2 +-
>>   hw/i386/x86.c              | 2 +-
>>   target/i386/kvm/kvm-stub.c | 7 -------
>>   3 files changed, 2 insertions(+), 9 deletions(-)


>> diff --git a/hw/i386/x86.c b/hw/i386/x86.c
>> index a88a126123..d2920af792 100644
>> --- a/hw/i386/x86.c
>> +++ b/hw/i386/x86.c
>> @@ -136,7 +136,7 @@ void x86_cpus_init(X86MachineState *x86ms, int 
>> default_cpu_version)
>>        * With KVM's in-kernel lapic: only if X2APIC API is enabled.
>>        */
>>       if (x86ms->apic_id_limit > 255 && !xen_enabled() &&
>> -        (!kvm_irqchip_in_kernel() || !kvm_enable_x2apic())) {
>> +        kvm_enabled() && (!kvm_irqchip_in_kernel() || 
>> !kvm_enable_x2apic())) {
> 
> This "!xen && kvm" expression can be simplified.
> 
> I am queuing the series with this squashed in:
> 
> diff --git a/hw/i386/x86.c b/hw/i386/x86.c
> index d2920af792d..3e86cf3060f 100644
> --- a/hw/i386/x86.c
> +++ b/hw/i386/x86.c
> @@ -129,14 +129,11 @@ void x86_cpus_init(X86MachineState *x86ms, int 
> default_cpu_version)
>                                                         ms->smp.max_cpus 
> - 1) + 1;
> 
>       /*
> -     * Can we support APIC ID 255 or higher?
> -     *
> -     * Under Xen: yes.
> -     * With userspace emulated lapic: no
> -     * With KVM's in-kernel lapic: only if X2APIC API is enabled.
> +     * Can we support APIC ID 255 or higher?  With KVM, that requires
> +     * both in-kernel lapic and X2APIC userspace API.
>        */
> -    if (x86ms->apic_id_limit > 255 && !xen_enabled() &&
> -        kvm_enabled() && (!kvm_irqchip_in_kernel() || 
> !kvm_enable_x2apic())) {
> +    if (x86ms->apic_id_limit > 255 && kvm_enabled() &&
> +        (!kvm_irqchip_in_kernel() || !kvm_enable_x2apic())) {
>           error_report("current -smp configuration requires kernel "
>                        "irqchip and X2APIC API support.");
>           exit(EXIT_FAILURE);
> 
> Paolo

Thank you!
