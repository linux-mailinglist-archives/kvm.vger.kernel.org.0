Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0A564F8C2
	for <lists+kvm@lfdr.de>; Sat, 17 Dec 2022 11:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbiLQKvA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Dec 2022 05:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbiLQKu5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Dec 2022 05:50:57 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD70E080
        for <kvm@vger.kernel.org>; Sat, 17 Dec 2022 02:50:56 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id n20so11718955ejh.0
        for <kvm@vger.kernel.org>; Sat, 17 Dec 2022 02:50:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IKYMj6XComyOgUWyrJRtyimJMGfAIFIVknJZ+SBM8kA=;
        b=gWWtF7AWMecLHRE5GepA/rf7em331XGVn55BcJqAGTQAY37tUIQ/GgkH50lWbk6R1k
         b05p2wPVC8KajE9PR/mPyRZQ7G15qK7tdHnFxrTkk5b5N/RDCu+031C0gwBgJ4Vaw/SZ
         bCxRCI1hiMY+GuERgXmHcq3+4sFFDE3nBLxhPu1BW89ZbvCXqbC0BKK+ne1x/1CVsBVX
         a5M+Ha5JJ4yMcAPhY7yaDPOAXtgF9HVrF5+bTfvZ1Kk0yuEeToJn7iAxtS1zM1aZd2ru
         WaYw16khkjzV28WSFZRnL3S5YH+D/u8I1Fwg1zzqNiCalwPWL3lrBrO0BJcpOJe8Ul81
         a4DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IKYMj6XComyOgUWyrJRtyimJMGfAIFIVknJZ+SBM8kA=;
        b=tEw4R0XSLS+Gl3mVjJlMB12UXK0O/G9zjOtKbzfK9D3IRHHfCPG8EypKWHeSs/VWuW
         owWjhnH3BhfDzn/e/zqkw3/KpQ+W8qVdZQAv0hJLoLQuKqsBb92Br1Up0R8ZaohAECWT
         MKDj3+nSoWta1cRUI7To/Rh/iUtjTSlO5wrVmaBaZlpWOso9PcFiLxgm/Ufq2TEpV0/Z
         E5Fnd6VTjwJxt9rPylJuieKKEx4t3hGiYrzNJ5QJ8z7JkONhaU5VN1zrZ/TA2SkiFtWa
         DZkw/4eJMTL2yGs6LgBy5AYQTasuorUkZuZtFqtPn6RsUmS6jzf6z+rGQRtVCmQPRIg3
         xgzg==
X-Gm-Message-State: ANoB5plakNQ59C+bPExwmoz90U4N/4rtCy5MiK4CgdTk3r+XO60oGQiP
        Lkr2x4TAmoLLAkPoQZMu/JakjQ==
X-Google-Smtp-Source: AA0mqf5ZckbIDKKz14HXdXg7BGJJEVT8dSA7KiDIWtsPM6SZv1sEcdgUphi49ew6Zb46ss5ySAaoaA==
X-Received: by 2002:a17:906:2693:b0:7ae:7e6:3a87 with SMTP id t19-20020a170906269300b007ae07e63a87mr27501429ejc.41.1671274254697;
        Sat, 17 Dec 2022 02:50:54 -0800 (PST)
Received: from [192.168.1.115] ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id ky22-20020a170907779600b0073c8d4c9f38sm1888107ejc.177.2022.12.17.02.50.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Dec 2022 02:50:54 -0800 (PST)
Message-ID: <29456501-4654-acd1-d407-adc806563b55@linaro.org>
Date:   Sat, 17 Dec 2022 11:50:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 2/2] sysemu/kvm: Reduce target-specific declarations
Content-Language: en-US
To:     Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Thomas Huth <thuth@redhat.com>
References: <20221216220738.7355-1-philmd@linaro.org>
 <20221216220738.7355-3-philmd@linaro.org>
 <b1317b71-d8a9-c04b-93db-12f24a35a09c@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <b1317b71-d8a9-c04b-93db-12f24a35a09c@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/12/22 01:28, Richard Henderson wrote:
> On 12/16/22 14:07, Philippe Mathieu-Daudé wrote:
>> Only the declarations using the target_ulong type are
>> target specific.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---
>>   include/sysemu/kvm.h | 25 ++++++++++++-------------
>>   1 file changed, 12 insertions(+), 13 deletions(-)
>>
>> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
>> index c8281c07a7..a53d6dab49 100644
>> --- a/include/sysemu/kvm.h
>> +++ b/include/sysemu/kvm.h
>> @@ -242,9 +242,6 @@ bool kvm_arm_supports_user_irq(void);
>>   int kvm_on_sigbus_vcpu(CPUState *cpu, int code, void *addr);
>>   int kvm_on_sigbus(int code, void *addr);
>> -#ifdef NEED_CPU_H
>> -#include "cpu.h"
>> -
>>   void kvm_flush_coalesced_mmio_buffer(void);
>>   /**
>> @@ -410,6 +407,9 @@ void kvm_get_apic_state(DeviceState *d, struct 
>> kvm_lapic_state *kapic);
>>   struct kvm_guest_debug;
>>   struct kvm_debug_exit_arch;
>> +#ifdef NEED_CPU_H
>> +#include "cpu.h"
>> +
>>   struct kvm_sw_breakpoint {
>>       target_ulong pc;
>>       target_ulong saved_insn;
>> @@ -436,6 +436,15 @@ void kvm_arch_update_guest_debug(CPUState *cpu, 
>> struct kvm_guest_debug *dbg);
>>   bool kvm_arch_stop_on_emulation_error(CPUState *cpu);
>> +uint32_t kvm_arch_get_supported_cpuid(KVMState *env, uint32_t function,
>> +                                      uint32_t index, int reg);
>> +uint64_t kvm_arch_get_supported_msr_feature(KVMState *s, uint32_t 
>> index);
>> +
>> +int kvm_physical_memory_addr_from_host(KVMState *s, void *ram_addr,
>> +                                       hwaddr *phys_addr);
> 
> Why did these need to move?

kvm_arch_get_XXX() don't need to move, but they are only called from
target-specific code, so there is no point in declaring them for
target-agnostic part; besides that helps catching unnecessary
target-specific stuff built within target-agnostic code.


Normally kvm_enabled() shouldn't be use by user-mode code; we could
poison it. In practice we have few common files calling it, so this
header is included, declaring kvm_physical_memory_addr_from_host()
which uses hwaddr. I'm trying to not define hwaddr in user-mode.

I thought this patch would be trivial :/ I'll split it with tiny /
better justified ones.

Thanks,

Phil.
