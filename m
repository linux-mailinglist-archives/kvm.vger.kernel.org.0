Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A39B64CA246
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 11:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241020AbiCBKfH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 05:35:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231735AbiCBKfG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 05:35:06 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9CE9B2A;
        Wed,  2 Mar 2022 02:34:22 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id 15-20020a17090a098f00b001bef0376d5cso1399078pjo.5;
        Wed, 02 Mar 2022 02:34:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:organization:in-reply-to
         :content-transfer-encoding;
        bh=pen159R+PS0cy5ON4aRofX0mHj7cRSRTBwXiGDW7eNo=;
        b=Zcn8xE6WLqIP6ffkUGHQT44C0f9n2hIL+M+anA6S+7Fy+h5KP4WMiaTLrrUcIDDusM
         O4rzhZseM7slUdkUZEhcWObUgV8BOny7I4CiDzUOj+DB3PJOyWgl+Tj2GdksWPjzq4O7
         lERO+DxsSZpZvw3m0NXV8LkXgVPx7BQEa+pMwE7Rqf2dSD0Rb7Hg1m1PsLqY8Zmx5+b5
         z0XLUKB68KCv1ElPensINNftvqpYZYAedO4TfXcYzOxa4x26QPqSR3XY9DYSMjolXu+8
         uPyg1TokZkAr+ohKivHPXXH1x+J085KRuLKDfTt9zZ0kJXXjh5/84xzEZYFyEqbITjG2
         iTRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:organization:in-reply-to
         :content-transfer-encoding;
        bh=pen159R+PS0cy5ON4aRofX0mHj7cRSRTBwXiGDW7eNo=;
        b=eepRpv7FAqM70cgAsNDdpj6fN/hh1Lli2+s9y67//UanglwvPbvImUkWFWozFyg9Fg
         mL22f4x+Tgo4ubZpZz2PfAFWJcXkfH+k5rVmRByF1ESeFsRw/8s/IkH8KMT0AMtuJ05b
         Cd/MLfU4AskFRZ/cRHL+rf4/H9ct/ZnXdlEWLvwZXdyjIzWmTaYB6AcnitjgxySTtauk
         CFuIQVyNiI6YhqKWtQvG2OET6a9RNJE/dQ8cXCGGxnb+7qBGAlnBZpnDeaM+gyRynPRk
         VsEQtoLZuJRyRr30I0QJyU4NQINR7QSv02OKkTFUVGsJiUcr6RcLj7mZOK9TeXZp0CJo
         kBQg==
X-Gm-Message-State: AOAM533nAHD8JqENbCThiEu7Ffvx8i0qu2jx+Pqxu6Lhy+rI+OdfYbCI
        fFHBoyKClLBfsBHka2yaSmsFwmjS5DwTLZea
X-Google-Smtp-Source: ABdhPJz9HN2yW3XrSR74+wiXZdwhWc+TmYp9R7/DyUroAk1DsZZpFw0tZ7icH4RPikiLjp1w1b6uTQ==
X-Received: by 2002:a17:90a:a58e:b0:1bd:4752:90cf with SMTP id b14-20020a17090aa58e00b001bd475290cfmr15527599pjq.54.1646217262179;
        Wed, 02 Mar 2022 02:34:22 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id go1-20020a17090b03c100b001bcb5ef0597sm4676873pjb.55.2022.03.02.02.34.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 02:34:21 -0800 (PST)
Message-ID: <3b41b508-cc40-9039-250d-0d29a78abbab@gmail.com>
Date:   Wed, 2 Mar 2022 18:34:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH] KVM: x86/cpuid: Stop exposing unknown AMX Tile Palettes
 and accelerator units
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220117065957.65335-1-likexu@tencent.com>
 <43e6dad3-dfdf-ba4a-cd95-99eca2538384@gmail.com>
Organization: Tencent
In-Reply-To: <43e6dad3-dfdf-ba4a-cd95-99eca2538384@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let me try pinging again until it times out or fails.

On 9/2/2022 5:29 pm, Like Xu wrote:
> Hi,
> 
> KVM does not have much filtering in exposing the host cpuid (at least for Intel 
> PT and AMX),
> and innocent user spaces could be corrupted when unknown new bits are 
> accidentally exposed.
> 
> Comments on code changes in this direction are welcome.
> 
> + https://lore.kernel.org/kvm/20220112041100.26769-1-likexu@tencent.com/
> 
> On 17/1/2022 2:59 pm, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>> Guest enablement of Intel AMX requires a good co-work from both host and
>> KVM, which means that KVM should take a more safer approach to avoid
>> the accidental inclusion of new unknown AMX features, even though it's
>> designed to be an extensible architecture.
>>
>> Per current spec, Intel CPUID Leaf 1EH sub-leaf 1 and above are reserved,
>> other bits in leaves 0x1d and 0x1e marked as "Reserved=0" shall be strictly
>> limited by definition for reporeted KVM_GET_SUPPORTED_CPUID.
>>
>> Fixes: 690a757d610e ("kvm: x86: Add CPUID support for Intel AMX")
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   arch/x86/kvm/cpuid.c | 12 ++++++++----
>>   1 file changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index c55e57b30e81..3fde6610d314 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -661,7 +661,6 @@ static struct kvm_cpuid_entry2 *do_host_cpuid(struct 
>> kvm_cpuid_array *array,
>>       case 0x17:
>>       case 0x18:
>>       case 0x1d:
>> -    case 0x1e:
>>       case 0x1f:
>>       case 0x8000001d:
>>           entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
>> @@ -936,21 +935,26 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array 
>> *array, u32 function)
>>           break;
>>       /* Intel AMX TILE */
>>       case 0x1d:
>> +        entry->ebx = entry->ecx = entry->edx = 0;
>>           if (!kvm_cpu_cap_has(X86_FEATURE_AMX_TILE)) {
>> -            entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
>> +            entry->eax = 0;
>>               break;
>>           }
>> +        entry->eax = min(entry->eax, 1u);
>>           for (i = 1, max_idx = entry->eax; i <= max_idx; ++i) {
>>               if (!do_host_cpuid(array, function, i))
>>                   goto out;
>>           }
>>           break;
>> -    case 0x1e: /* TMUL information */
>> +    /* TMUL Information */
>> +    case 0x1e:
>> +        entry->eax = entry->ecx = entry->edx = 0;
>>           if (!kvm_cpu_cap_has(X86_FEATURE_AMX_TILE)) {
>> -            entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
>> +            entry->ebx = 0;
>>               break;
>>           }
>> +        entry->ebx &= 0xffffffu;
>>           break;
>>       case KVM_CPUID_SIGNATURE: {
>>           const u32 *sigptr = (const u32 *)KVM_SIGNATURE;
