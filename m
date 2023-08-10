Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 218DE77745A
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 11:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbjHJJW1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 05:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234949AbjHJJV4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 05:21:56 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A765D47DD
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 02:21:04 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 38308e7fff4ca-2b9b9f0387dso10389631fa.0
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 02:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1691659263; x=1692264063;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wAGRahBwpiagiszDDcvDgRWO7a+yNxGSUwvwQuKCeaY=;
        b=bg/eGuc6Astpeu+qMEd+ZFDHBJkGCckQKSGVlCi4yBZ+wxzfxUcoAwZRbjLqsDNM/Q
         WFQDEmf4FCss/+dp2wn1nf8xqZpg0ewBOZ6bEdvlSfxRLF/bbHNWoumwKxGJSDmSKYkP
         uHKqqOeUP6qRK0giM3hpO8Oe3hhlEWsaHgbFahEmq1p6xBogdLEeyrXaYj3TplhTOUN/
         qwt4mmdOLm+MeHhQLz3HbBBTnJK3LjYoYPG9nfj/koXGPKkHY+nbJGMcC1XbobllZKyW
         KMSg3CgdWrbIsFb8SSI/LbFDXc3zsYqw77A3odz1SHj6OjSbrBHo6Nm8In1zfCuzjdKL
         6d2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691659263; x=1692264063;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wAGRahBwpiagiszDDcvDgRWO7a+yNxGSUwvwQuKCeaY=;
        b=RDmX2rkNkj05Td2IP+EaUpUikLXfj2yR72vG1unNCZjDnnLMfKidE8vFEvSoL9/S2g
         lVrG2EjgoCga3xRI192Mr63LCxeCWoKNtJUH2TCi3Wiypc5pjEAwitdIx2Y6WznWthge
         pJFv+Yucstz9h2yTOfRUe4ybVlWk1NyMoCjXzxQZFia3ephcdw+SB90nf5CG+7cpACR8
         1qBZu8le35gWdoOY1whfyBZyFMBNJ9e5PA0sBtXfa2BTxPYy3jZ9f10C4SrDcCYUnlFB
         QMemMDqtMl0EvELPhp3vUMcYAybIp8lD81sZLWfMB3NW67ggdVsKR9ktbywIcp4KPqvu
         P+Dg==
X-Gm-Message-State: AOJu0Yx17aFKyOAN6Cl/U7aTVgm8T+sh82m87OJI2elXNBrWejxdv6UF
        X/MyvYIb16uuOoJ1U6CS3+j3rg==
X-Google-Smtp-Source: AGHT+IEAbUHatMKZjJb3Q29oge/qO2UaymAKxvrWbdQriKD29gG30Wfx9yi0YCaT7iTKlR8etCp+gA==
X-Received: by 2002:a2e:9cd5:0:b0:2b6:9fdf:d8f4 with SMTP id g21-20020a2e9cd5000000b002b69fdfd8f4mr1385560ljj.29.1691659262860;
        Thu, 10 Aug 2023 02:21:02 -0700 (PDT)
Received: from [192.168.69.115] ([176.176.158.65])
        by smtp.gmail.com with ESMTPSA id h14-20020a05600c260e00b003fa8dbb7b5dsm1514313wma.25.2023.08.10.02.21.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 02:21:02 -0700 (PDT)
Message-ID: <2039f2b3-e916-411e-1987-fa15a03144b7@linaro.org>
Date:   Thu, 10 Aug 2023 11:21:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [PATCH v5 1/6] kvm: Introduce kvm_arch_get_default_type hook
Content-Language: en-US
To:     Peter Maydell <peter.maydell@linaro.org>,
        Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>
References: <20230727073134.134102-1-akihiko.odaki@daynix.com>
 <20230727073134.134102-2-akihiko.odaki@daynix.com>
 <CAFEAcA_26e2G_qLA8DEcv74MADgquhiVkWEZkh_wL0+JxAf91Q@mail.gmail.com>
 <CAFEAcA9gkKy=GBXNw0rRLeN80ekFY5JQB1Jn2b+F70oC1C5uxg@mail.gmail.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <CAFEAcA9gkKy=GBXNw0rRLeN80ekFY5JQB1Jn2b+F70oC1C5uxg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/8/23 19:38, Peter Maydell wrote:
> On Fri, 4 Aug 2023 at 18:26, Peter Maydell <peter.maydell@linaro.org> wrote:
>>
>> On Thu, 27 Jul 2023 at 08:31, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>>
>>> kvm_arch_get_default_type() returns the default KVM type. This hook is
>>> particularly useful to derive a KVM type that is valid for "none"
>>> machine model, which is used by libvirt to probe the availability of
>>> KVM.
>>>
>>> For MIPS, the existing mips_kvm_type() is reused. This function ensures
>>> the availability of VZ which is mandatory to use KVM on the current
>>> QEMU.
>>>
>>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
>>> ---
>>>   include/sysemu/kvm.h     | 2 ++
>>>   target/mips/kvm_mips.h   | 9 ---------
>>>   accel/kvm/kvm-all.c      | 4 +++-
>>>   hw/mips/loongson3_virt.c | 2 --
>>>   target/arm/kvm.c         | 5 +++++
>>>   target/i386/kvm/kvm.c    | 5 +++++
>>>   target/mips/kvm.c        | 2 +-
>>>   target/ppc/kvm.c         | 5 +++++
>>>   target/riscv/kvm.c       | 5 +++++
>>>   target/s390x/kvm/kvm.c   | 5 +++++
>>>   10 files changed, 31 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
>>> index 115f0cca79..ccaf55caf7 100644
>>> --- a/include/sysemu/kvm.h
>>> +++ b/include/sysemu/kvm.h
>>> @@ -369,6 +369,8 @@ int kvm_arch_get_registers(CPUState *cpu);
>>>
>>>   int kvm_arch_put_registers(CPUState *cpu, int level);
>>>
>>> +int kvm_arch_get_default_type(MachineState *ms);
>>> +
>>
>> New global functions should have a doc comment that explains
>> what they do, what their API is, etc. For instance, is
>> this allowed to return an error, and if so, how ?
> 
> Looks like this was the only issue with this patchset. So
> I propose to take this into my target-arm queue for 8.2,
> with the following doc comment added:
> 
> /**
>   * kvm_arch_get_default_type: Return default KVM type
>   * @ms: MachineState of the VM being created
>   *
>   * Return the default type argument to use in the
>   * KVM_CREATE_VM ioctl when creating the VM. This will
>   * only be used when the machine model did not specify a
>   * type to use via the MachineClass::kvm_type method.
>   *
>   * Returns: type to use, or a negative value on error.
>   */

Thank you.

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

