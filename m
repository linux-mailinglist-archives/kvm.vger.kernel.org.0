Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6EAE1E92DD
	for <lists+kvm@lfdr.de>; Sat, 30 May 2020 19:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729094AbgE3R2m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 May 2020 13:28:42 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:45874 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729006AbgE3R2l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 May 2020 13:28:41 -0400
Received: by mail-lj1-f195.google.com with SMTP id z18so3063527lji.12;
        Sat, 30 May 2020 10:28:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=MsI/8DjbdmiBZOHVaVzMVv0Rpg6qwYeC9PZuxWpl1xY=;
        b=N9oL9zIKLV+pLjxHp9FQoHGFCbN3895p1i82JoTSHnAOHq8lXVkfNCkonmKkEW7O/1
         LXp3RSMwqKZrQ29KhHoSuBm2oMVFvUmo2bL/1gO7bZjSPuHhFAN5GUlYH97eEJvViusC
         L2U4LMPng6Y18E4xlfnv4ctVFsjSzGezxY/Wdq8cOda1chTnbSpN6GqbZj4xXTWlJ9kq
         sfbuUXtyjrFRqtz1TCiELOk/ta16lHH9BU4GeeG8p8joBPTj80DW7n5Gkqxyl0sKOXlM
         5XiVqyUF9C8ABN2YK2uMUQxC4FgKhKoBU/FYSmRZ9sY5Ec7oN3P7TgCqnNDsOf19s44l
         r3SQ==
X-Gm-Message-State: AOAM531d/nKa2x1ZPOaLAuTGPjlN1Qw0husdKg18lkJjW1JTs5MSDZow
        l/V89lVQjoHqBlybrLQulmO2fnT5
X-Google-Smtp-Source: ABdhPJx9k4UqhRNRDs3haWHLLkEihHhTPZMUtOP7GhLHa8khi0WZQO4VTcjr2WgF6bNyK4FZaJjaow==
X-Received: by 2002:a2e:81c5:: with SMTP id s5mr6383075ljg.372.1590859718887;
        Sat, 30 May 2020 10:28:38 -0700 (PDT)
Received: from [192.168.1.8] ([213.87.139.175])
        by smtp.gmail.com with ESMTPSA id w10sm2736259ljw.92.2020.05.30.10.28.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 10:28:38 -0700 (PDT)
Subject: Re: [PATCH] KVM: Use previously computed array_size()
To:     Joe Perches <joe@perches.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200530143558.321449-1-efremov@linux.com>
 <0c00d96c46d34d69f5f459baebf3c89a507730fc.camel@perches.com>
From:   Denis Efremov <efremov@linux.com>
Autocrypt: addr=efremov@linux.com; keydata=
 mQINBFsJUXwBEADDnzbOGE/X5ZdHqpK/kNmR7AY39b/rR+2Wm/VbQHV+jpGk8ZL07iOWnVe1
 ZInSp3Ze+scB4ZK+y48z0YDvKUU3L85Nb31UASB2bgWIV+8tmW4kV8a2PosqIc4wp4/Qa2A/
 Ip6q+bWurxOOjyJkfzt51p6Th4FTUsuoxINKRMjHrs/0y5oEc7Wt/1qk2ljmnSocg3fMxo8+
 y6IxmXt5tYvt+FfBqx/1XwXuOSd0WOku+/jscYmBPwyrLdk/pMSnnld6a2Fp1zxWIKz+4VJm
 QEIlCTe5SO3h5sozpXeWS916VwwCuf8oov6706yC4MlmAqsQpBdoihQEA7zgh+pk10sCvviX
 FYM4gIcoMkKRex/NSqmeh3VmvQunEv6P+hNMKnIlZ2eJGQpz/ezwqNtV/przO95FSMOQxvQY
 11TbyNxudW4FBx6K3fzKjw5dY2PrAUGfHbpI3wtVUNxSjcE6iaJHWUA+8R6FLnTXyEObRzTS
 fAjfiqcta+iLPdGGkYtmW1muy/v0juldH9uLfD9OfYODsWia2Ve79RB9cHSgRv4nZcGhQmP2
 wFpLqskh+qlibhAAqT3RQLRsGabiTjzUkdzO1gaNlwufwqMXjZNkLYu1KpTNUegx3MNEi2p9
 CmmDxWMBSMFofgrcy8PJ0jUnn9vWmtn3gz10FgTgqC7B3UvARQARAQABtCFEZW5pcyBFZnJl
 bW92IDxlZnJlbW92QGxpbnV4LmNvbT6JAlcEEwEIAEECGwMFCQPCZwAFCwkIBwIGFQoJCAsC
 BBYCAwECHgECF4AWIQR2VAM2ApQN8ZIP5AO1IpWwM1AwHwUCW3qdrQIZAQAKCRC1IpWwM1Aw
 HwF5D/sHp+jswevGj304qvG4vNnbZDr1H8VYlsDUt+Eygwdg9eAVSVZ8yr9CAu9xONr4Ilr1
 I1vZRCutdGl5sneXr3JBOJRoyH145ExDzQtHDjqJdoRHyI/QTY2l2YPqH/QY1hsLJr/GKuRi
 oqUJQoHhdvz/NitR4DciKl5HTQPbDYOpVfl46i0CNvDUsWX7GjMwFwLD77E+wfSeOyXpFc2b
 tlC9sVUKtkug1nAONEnP41BKZwJ/2D6z5bdVeLfykOAmHoqWitCiXgRPUg4Vzc/ysgK+uKQ8
 /S1RuUA83KnXp7z2JNJ6FEcivsbTZd7Ix6XZb9CwnuwiKDzNjffv5dmiM+m5RaUmLVVNgVCW
 wKQYeTVAspfdwJ5j2gICY+UshALCfRVBWlnGH7iZOfmiErnwcDL0hLEDlajvrnzWPM9953i6
 fF3+nr7Lol/behhdY8QdLLErckZBzh+tr0RMl5XKNoB/kEQZPUHK25b140NTSeuYGVxAZg3g
 4hobxbOGkzOtnA9gZVjEWxteLNuQ6rmxrvrQDTcLTLEjlTQvQ0uVK4ZeDxWxpECaU7T67khA
 ja2B8VusTTbvxlNYbLpGxYQmMFIUF5WBfc76ipedPYKJ+itCfZGeNWxjOzEld4/v2BTS0o02
 0iMx7FeQdG0fSzgoIVUFj6durkgch+N5P1G9oU+H3w==
Message-ID: <6088fa0f-668a-f221-515b-413ca8c0c363@linux.com>
Date:   Sat, 30 May 2020 20:28:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <0c00d96c46d34d69f5f459baebf3c89a507730fc.camel@perches.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/30/20 6:58 PM, Joe Perches wrote:
> On Sat, 2020-05-30 at 17:35 +0300, Denis Efremov wrote:
>> array_size() is used in alloc calls to compute the allocation
>> size. Next, "raw" multiplication is used to compute the size
>> for copy_from_user(). The patch removes duplicated computation
>> by saving the size in a var. No security concerns, just a small
>> optimization.
>>
>> Signed-off-by: Denis Efremov <efremov@linux.com>
> 
> Perhaps use vmemdup_user?

vmemdup_user() uses kvmalloc internally. I think it will also require
changing vfree to kvfree.

> 
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> []
>> @@ -184,14 +184,13 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
>>  		goto out;
>>  	r = -ENOMEM;
>>  	if (cpuid->nent) {
>> -		cpuid_entries =
>> -			vmalloc(array_size(sizeof(struct kvm_cpuid_entry),
>> -					   cpuid->nent));
>> +		const size_t size = array_size(sizeof(struct kvm_cpuid_entry),
>> +					       cpuid->nent);
>> +		cpuid_entries = vmalloc(size);
>>  		if (!cpuid_entries)
>>  			goto out;
>>  		r = -EFAULT;
>> -		if (copy_from_user(cpuid_entries, entries,
>> -				   cpuid->nent * sizeof(struct kvm_cpuid_entry)))
>> +		if (copy_from_user(cpuid_entries, entries, size))
> 
> 		cpuid_entries = vmemdup_user(entries,
> 					     array_size(sizeof(struct kvm_cpuid_entry), cpuid->nent));
> 		if (IS_ERR(cpuid_entries))
> 			...
> 
> etc...
> 
