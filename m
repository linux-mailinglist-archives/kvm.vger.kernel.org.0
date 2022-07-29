Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCC15854FD
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 20:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237315AbiG2S2I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 14:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbiG2S2G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 14:28:06 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7662E6BD66
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 11:28:05 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id bf13so4609608pgb.11
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 11:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0EZkxS7nvpWAzwN5vYWDWRFT8Tn5/5KW+sdHzKZHyh8=;
        b=QnLrxGTVsSg281e0ZalQoV1m2Kd3owXkKvNwd4ZdKsD10Zyo/QAHY3l/oZLtYLwRph
         MdMG14kIxL1EqKpEAvkY4R3ybibPxKT/bzarO8tNG2uFmAXs4jj7B86dtpu3O2GcMhU1
         xdBXEBD4q+rY4FWkx8kvj9/+PADqAEYrDwXoU8lcCpf16Ht+MaY1bcR/Uxs6ahpNNImv
         PbIw2jxvL8JiP4kUYGjGsNYP2L4F8VYto22PxZm5McN+GDhfqztgiZb90oEsGtuZ6DU/
         iPcF1SMG+41FhDVV+JJnr/EamDwicom5b8fj6O36dRSXQzRrrbKDTY9wJr6ihQ/vCA/q
         9Ibw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0EZkxS7nvpWAzwN5vYWDWRFT8Tn5/5KW+sdHzKZHyh8=;
        b=HvKjZrYwVcCn7n4qOcJiKEAtMWLydBLU6Pt7UO62uLY7bxWyovxX9gMOMGvGvL+RBZ
         n9KnOpXTc4Jgh7mUJ5CVZmmRaFcIwyAkmuASQ2b4OU0WaBHQxCkcDEAuhxKWZLVc3Vto
         8OpjP22y+jbhJkx1nKnVkTSEH/VBQvLsGwl04yf5sHbTyh0QztLeDtPlR8aaqUkLmfoB
         qjmYDo6F0ulMi79RG9vZ7NNPNqh6Km8Z2NMJeKLEgRkZ6NRByjhB4VykWkusIeVGOjc8
         3FiX6jcf1W8UgsK0HOqtPOrFskQX6uFo777qvfOYVmK5mp+ATuEZCcdAlbpofQOWwHXm
         C1Mg==
X-Gm-Message-State: ACgBeo0Zenu5DhFyblGTdAALX9Mvlop6nUj7Ja4Gog6rTzypk63Ktx82
        PEvrF+gHN4/SFN2ZUYnfTd4w+Q==
X-Google-Smtp-Source: AA6agR7SG375KRcIPpsw/6KkL8V4kUwH59K0Apo3F4YyqYnSlvDxuTMw7uCuMvryeq/kN0O0hQKlNg==
X-Received: by 2002:a63:3545:0:b0:41b:b5e3:550b with SMTP id c66-20020a633545000000b0041bb5e3550bmr683385pga.551.1659119284721;
        Fri, 29 Jul 2022 11:28:04 -0700 (PDT)
Received: from ?IPV6:2600:1700:38d4:55df:70e9:57a7:80c3:84be? ([2600:1700:38d4:55df:70e9:57a7:80c3:84be])
        by smtp.gmail.com with ESMTPSA id c7-20020a170903234700b0016c28a68ad0sm111060plh.253.2022.07.29.11.28.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 11:28:04 -0700 (PDT)
Message-ID: <3ba4d61c-f01c-e740-1045-994788da66b1@google.com>
Date:   Fri, 29 Jul 2022 11:28:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] kvm: x86: Do proper cleanup if kvm_x86_ops->vm_init()
 fails
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, dmatlack@google.com,
        jmattson@google.com
References: <20220729031108.3929138-1-junaids@google.com>
 <YuPwhWi1xWgAwmK4@google.com>
From:   Junaid Shahid <junaids@google.com>
In-Reply-To: <YuPwhWi1xWgAwmK4@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/29/22 07:36, Sean Christopherson wrote:
> On Thu, Jul 28, 2022, Junaid Shahid wrote:
>> If vm_init() fails [which can happen, for instance, if a memory
>> allocation fails during avic_vm_init()], we need to cleanup some
>> state in order to avoid resource leaks.
>>
>> Signed-off-by: Junaid Shahid <junaids@google.com>
>> ---
>>   arch/x86/kvm/x86.c | 8 +++++++-
>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index f389691d8c04..ef5fd2f05c79 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -12064,8 +12064,14 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>>   	kvm_hv_init_vm(kvm);
>>   	kvm_xen_init_vm(kvm);
>>   
>> -	return static_call(kvm_x86_vm_init)(kvm);
>> +	ret = static_call(kvm_x86_vm_init)(kvm);
>> +	if (ret)
>> +		goto out_uninit_mmu;
>>   
>> +	return 0;
>> +
>> +out_uninit_mmu:
>> +	kvm_mmu_uninit_vm(kvm);
> 
> Hrm, this works for now (I think), but I really don't like that kvm_apicv_init(),
> kvm_hv_init_vm(), and kvm_xen_init_vm() all do something without that something
> being unwound on failure.  E.g. both Hyper-V and Xen have a paired "destroy"
> function, it just so happens that their destroy paths are guaranteed nops in this
> case.
> 
> AFAICT, there are no dependencies on doing vendor init at the end, so what if we
> hoist it up so that all paths that can fail are at the top?
> 

Ack. I'll move the vendor init call up. I think I'll skip breaking out a 
separate kvm_x86_op for apicv_init() for now.

Thanks,
Junaid
