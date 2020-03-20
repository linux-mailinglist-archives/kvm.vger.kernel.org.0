Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F78E18D648
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 18:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgCTRyf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 13:54:35 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:54686 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726801AbgCTRyf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 13:54:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584726874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B7pBoiCHAs8bcJTkEMMi143lyjjU81buEh22ZNHuEI4=;
        b=esef4ct7Er2s2aolX4cehy7LlAO46ei+oH6I8H4StqJuYIwiqkYLsI8zlgAzIaArHBtj+L
        vg5lqcVJAVUUvkNGv7Wkn0qAN7BsCf2ttsh3wGUFxlfL0owszdizla0mBH4CDhJav6YNdN
        dttrJ9REbTmt795i6b+kDfG9/24795Y=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-QtD8dI07Ne6GmMjWRKfgkQ-1; Fri, 20 Mar 2020 13:54:32 -0400
X-MC-Unique: QtD8dI07Ne6GmMjWRKfgkQ-1
Received: by mail-wm1-f70.google.com with SMTP id g26so2660047wmk.6
        for <kvm@vger.kernel.org>; Fri, 20 Mar 2020 10:54:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B7pBoiCHAs8bcJTkEMMi143lyjjU81buEh22ZNHuEI4=;
        b=RqSb7GS/mRNNtTfGa5c/tlso8aNXLVR/NVRZB2P4W2nWvR/u8/odnpqElEoVRBfw5M
         OjjiiovOqD59CCR07Hz2fAV+XfdKdlH0yV9thsTbN2FFI7hgEXiGHzjbvOFg1bikAG1X
         JtYZfBzE3BxWaqVyNaEOeNdUwR8gPYuZ1KtxtZrRTNCXupEYmtksrizuqwKVZucuhhnp
         wq/fhkn8xfPq6nTe1YjGqy0ld2vGqM6CtP7hxo9UVB7Rsr2HUSyP8gYPFGVieffo2VIH
         WSeN5u7a1VmX69GQ1J+ckfnrZXcDaAwl4aJr0I5duEuJCu7PxT7thx7k4RR8waorHDEx
         BCwg==
X-Gm-Message-State: ANhLgQ1c4/5fXY3BfrUrCJ6eLV0OD2P/P+PAaQiUKkB6PElg4qQ1pOx6
        6JAcygRT3oML5QtvTW2t+Juwgw4eal+tScS+aVQebMWTixKAmXVQ8bdf1SGTjcgvL0l350p4JFp
        6dyaof1o5v/MG
X-Received: by 2002:a7b:c005:: with SMTP id c5mr11557245wmb.170.1584726871124;
        Fri, 20 Mar 2020 10:54:31 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vs44QQWTWk7W3M5U1BvlqlzDCUzcc3qbLd7ulidyTIpxhd4cCtMJeyFTUB5e02d20yLjGlVrA==
X-Received: by 2002:a7b:c005:: with SMTP id c5mr11557223wmb.170.1584726870839;
        Fri, 20 Mar 2020 10:54:30 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.15.43])
        by smtp.gmail.com with ESMTPSA id f15sm8603592wmj.25.2020.03.20.10.54.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2020 10:54:29 -0700 (PDT)
Subject: Re: [PATCH] KVM: let declaration of kvm_get_running_vcpus match
 implementation
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, arc Zyngier <maz@kernel.org>
References: <20200228084941.9362-1-borntraeger@de.ibm.com>
 <8c3e2a26-c04d-338e-16c6-39bb13c715af@redhat.com>
 <758621ef-0ca1-d040-0979-c6359a3532d2@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <17304566-fd9c-420d-17fe-89ef822362f6@redhat.com>
Date:   Fri, 20 Mar 2020 18:54:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <758621ef-0ca1-d040-0979-c6359a3532d2@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/03/20 15:29, Christian Borntraeger wrote:
> 
> 
> On 28.02.20 10:34, Paolo Bonzini wrote:
>> On 28/02/20 09:49, Christian Borntraeger wrote:
>>> Sparse notices that declaration and implementation do not match:
>>> arch/s390/kvm/../../../virt/kvm/kvm_main.c:4435:17: warning: incorrect type in return expression (different address spaces)
>>> arch/s390/kvm/../../../virt/kvm/kvm_main.c:4435:17:    expected struct kvm_vcpu [noderef] <asn:3> **
>>> arch/s390/kvm/../../../virt/kvm/kvm_main.c:4435:17:    got struct kvm_vcpu *[noderef] <asn:3> *
>>>
>>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>>> ---
>>>  include/linux/kvm_host.h | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>>> index 7944ad6ac10b..bcb9b2ac0791 100644
>>> --- a/include/linux/kvm_host.h
>>> +++ b/include/linux/kvm_host.h
>>> @@ -1344,7 +1344,7 @@ static inline void kvm_vcpu_set_dy_eligible(struct kvm_vcpu *vcpu, bool val)
>>>  #endif /* CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT */
>>>  
>>>  struct kvm_vcpu *kvm_get_running_vcpu(void);
>>> -struct kvm_vcpu __percpu **kvm_get_running_vcpus(void);
>>> +struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void);
>>>  
>>>  #ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
>>>  bool kvm_arch_has_irq_bypass(void);
>>>
>>
>> Queued, thanks.
> 
> Ping. I cant find this in kvm/next.
> 

It's in 5.6-rc4.

Paolo

