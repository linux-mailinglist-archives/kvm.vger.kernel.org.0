Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0BC44DC03
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 20:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbhKKTSU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 14:18:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:36796 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229785AbhKKTST (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 14:18:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636658129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=riKfQQQpM4ghSmJeiSjTJit9lHx9GeUkvkeDWUci8pc=;
        b=CFXdGvEqzAP9iG0ZmRqDpqXq0Ti1dTqbivDFfH5mCvIqpBgPAO7xn2e4VUSwZxkFQYf5tO
        7rRI/qdceEfWT09Y8Okikwt8xPRhyQatpIIFVBXCDycRB47LAQsjX/nsIsUf8wwmXL7V8S
        p9mWDeUVIrTTKpXODMCka25C782Ukmw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-5TYpaFQlO0u13akHwI5GJw-1; Thu, 11 Nov 2021 14:15:28 -0500
X-MC-Unique: 5TYpaFQlO0u13akHwI5GJw-1
Received: by mail-wm1-f71.google.com with SMTP id 145-20020a1c0197000000b0032efc3eb9bcso5221364wmb.0
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 11:15:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=riKfQQQpM4ghSmJeiSjTJit9lHx9GeUkvkeDWUci8pc=;
        b=YTVeuyE60Fd1uEVdp+AKPeN7o1IR9dGLu44wOsKnYLXLNFIEzuLUbjHGbOQ/bjDJ3w
         TB2xS5FUkdmXdmZ0PRySsVZ5Q7NPSvwfNZip+a9CTPLK+Bgr4so90TEeGtUSfxkRszDZ
         wUg9iqovVELOU7oA6Dxaft/r5jnOvvjSXOns7IIfN4QGcS2A+QAOgDMs2sHPgB0fwLab
         aVM4wcYoYGUoUZ95n02VbDzHaky/gEX2mmJxVPfuYPWRnJXLBJp6Jkl6byOnROG4yGLI
         QHP8Bxed4b3lTlVSIgJQNBqklBHLe7QEJbufwuM+MERw3GAWr6l6e4ivkEFtQaKjGR1i
         Tz7w==
X-Gm-Message-State: AOAM532KAmnxtjBaYzYG/gGz27EBKPREnOFivAG+engTD9Zp/x8g4aPr
        LmsPeL+WTHPBvwpINDsH0d3PeuWxWYS9+bWtFD3oe3Bk9rVYRfWiTtTz10/shfgF7Dg3ySqHywU
        OTQuIOgk/wFzz
X-Received: by 2002:a1c:4d0b:: with SMTP id o11mr10736071wmh.68.1636658127287;
        Thu, 11 Nov 2021 11:15:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzvf9ABSy07X2z7J4xpAUg7WVFGmI4AFIyT084UBZRuKJMLU3ioM9o7iaIYgLk6i6S0Q3ywDQ==
X-Received: by 2002:a1c:4d0b:: with SMTP id o11mr10736038wmh.68.1636658127014;
        Thu, 11 Nov 2021 11:15:27 -0800 (PST)
Received: from [192.168.3.132] (p4ff23ee8.dip0.t-ipconnect.de. [79.242.62.232])
        by smtp.gmail.com with ESMTPSA id t8sm4705546wmq.32.2021.11.11.11.15.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 11:15:26 -0800 (PST)
Message-ID: <ff344676-0c37-610b-eafb-b1477db0f6a1@redhat.com>
Date:   Thu, 11 Nov 2021 20:15:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH v3 2/2] KVM: s390: Extend the USER_SIGP capability
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20211110203322.1374925-1-farman@linux.ibm.com>
 <20211110203322.1374925-3-farman@linux.ibm.com>
 <dd8a8b49-da6d-0ab8-dc47-b24f5604767f@redhat.com>
 <ab82e68051674ea771e2cb5371ca2a204effab40.camel@linux.ibm.com>
 <32836eb5-532f-962d-161a-faa2213a0691@linux.ibm.com>
 <b116e738d8f9b185867ab28395012aaddd58af31.camel@linux.ibm.com>
 <85ba9fa3-ca25-b598-aecd-5e0c6a0308f2@redhat.com>
 <19a2543b24015873db736bddb14d0e4d97712086.camel@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <19a2543b24015873db736bddb14d0e4d97712086.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11.11.21 20:05, Eric Farman wrote:
> On Thu, 2021-11-11 at 19:29 +0100, David Hildenbrand wrote:
>> On 11.11.21 18:48, Eric Farman wrote:
>>> On Thu, 2021-11-11 at 17:13 +0100, Janosch Frank wrote:
>>>> On 11/11/21 16:03, Eric Farman wrote:
>>>>> On Thu, 2021-11-11 at 10:15 +0100, David Hildenbrand wrote:
>>>>>> On 10.11.21 21:33, Eric Farman wrote:
>>>>>>> With commit 2444b352c3ac ("KVM: s390: forward most SIGP
>>>>>>> orders
>>>>>>> to
>>>>>>> user
>>>>>>> space") we have a capability that allows the "fast" SIGP
>>>>>>> orders
>>>>>>> (as
>>>>>>> defined by the Programming Notes for the SIGNAL PROCESSOR
>>>>>>> instruction in
>>>>>>> the Principles of Operation) to be handled in-kernel, while
>>>>>>> all
>>>>>>> others are
>>>>>>> sent to userspace for processing.
>>>>>>>
>>>>>>> This works fine but it creates a situation when, for
>>>>>>> example, a
>>>>>>> SIGP SENSE
>>>>>>> might return CC1 (STATUS STORED, and status bits indicating
>>>>>>> the
>>>>>>> vcpu is
>>>>>>> stopped), when in actuality userspace is still processing a
>>>>>>> SIGP
>>>>>>> STOP AND
>>>>>>> STORE STATUS order, and the vcpu is not yet actually
>>>>>>> stopped.
>>>>>>> Thus,
>>>>>>> the
>>>>>>> SIGP SENSE should actually be returning CC2 (busy) instead
>>>>>>> of
>>>>>>> CC1.
>>>>>>>
>>>>>>> To fix this, add another CPU capability, dependent on the
>>>>>>> USER_SIGP
>>>>>>> one,
>>>>>>> and two associated IOCTLs. One IOCTL will be used by
>>>>>>> userspace
>>>>>>> to
>>>>>>> mark a
>>>>>>> vcpu "busy" processing a SIGP order, and cause concurrent
>>>>>>> orders
>>>>>>> handled
>>>>>>> in-kernel to be returned with CC2 (busy). Another IOCTL
>>>>>>> will be
>>>>>>> used by
>>>>>>> userspace to mark the SIGP "finished", and the vcpu free to
>>>>>>> process
>>>>>>> additional orders.
>>>>>>>
>>>>>>
>>>>>> This looks much cleaner to me, thanks!
>>>>>>
>>>>>> [...]
>>>>>>
>>>>>>> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-
>>>>>>> s390.h
>>>>>>> index c07a050d757d..54371cede485 100644
>>>>>>> --- a/arch/s390/kvm/kvm-s390.h
>>>>>>> +++ b/arch/s390/kvm/kvm-s390.h
>>>>>>> @@ -82,6 +82,22 @@ static inline int is_vcpu_idle(struct
>>>>>>> kvm_vcpu
>>>>>>> *vcpu)
>>>>>>>   	return test_bit(vcpu->vcpu_idx, vcpu->kvm-
>>>>>>>> arch.idle_mask);
>>>>>>>   }
>>>>>>>   
>>>>>>> +static inline bool kvm_s390_vcpu_is_sigp_busy(struct
>>>>>>> kvm_vcpu
>>>>>>> *vcpu)
>>>>>>> +{
>>>>>>> +	return (atomic_read(&vcpu->arch.sigp_busy) == 1);
>>>>>>
>>>>>> You can drop ()
>>>>>>
>>>>>>> +}
>>>>>>> +
>>>>>>> +static inline bool kvm_s390_vcpu_set_sigp_busy(struct
>>>>>>> kvm_vcpu
>>>>>>> *vcpu)
>>>>>>> +{
>>>>>>> +	/* Return zero for success, or -EBUSY if another vcpu
>>>>>>> won */
>>>>>>> +	return (atomic_cmpxchg(&vcpu->arch.sigp_busy, 0, 1) ==
>>>>>>> 0) ? 0 :
>>>>>>> -EBUSY;
>>>>>>
>>>>>> You can drop () as well.
>>>>>>
>>>>>> We might not need the -EBUSY semantics after all. User space
>>>>>> can
>>>>>> just
>>>>>> track if it was set, because it's in charge of setting it.
>>>>>
>>>>> Hrm, I added this to distinguish a newer kernel with an older
>>>>> QEMU,
>>>>> but
>>>>> of course an older QEMU won't know the difference either. I'll
>>>>> doublecheck that this is works fine in the different
>>>>> permutations.
>>>>>
>>>>>>> +}
>>>>>>> +
>>>>>>> +static inline void kvm_s390_vcpu_clear_sigp_busy(struct
>>>>>>> kvm_vcpu
>>>>>>> *vcpu)
>>>>>>> +{
>>>>>>> +	atomic_set(&vcpu->arch.sigp_busy, 0);
>>>>>>> +}
>>>>>>> +
>>>>>>>   static inline int kvm_is_ucontrol(struct kvm *kvm)
>>>>>>>   {
>>>>>>>   #ifdef CONFIG_KVM_S390_UCONTROL
>>>>>>> diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
>>>>>>> index 5ad3fb4619f1..a37496ea6dfa 100644
>>>>>>> --- a/arch/s390/kvm/sigp.c
>>>>>>> +++ b/arch/s390/kvm/sigp.c
>>>>>>> @@ -276,6 +276,10 @@ static int handle_sigp_dst(struct
>>>>>>> kvm_vcpu
>>>>>>> *vcpu, u8 order_code,
>>>>>>>   	if (!dst_vcpu)
>>>>>>>   		return SIGP_CC_NOT_OPERATIONAL;
>>>>>>>   
>>>>>>> +	if (kvm_s390_vcpu_is_sigp_busy(dst_vcpu)) {
>>>>>>> +		return SIGP_CC_BUSY;
>>>>>>> +	}
>>>>>>
>>>>>> You can drop {}
>>>>>
>>>>> Arg, I had some debug in there which needed the braces, and of
>>>>> course
>>>>> it's unnecessary now. Thanks.
>>>>>
>>>>>>> +
>>>>>>>   	switch (order_code) {
>>>>>>>   	case SIGP_SENSE:
>>>>>>>   		vcpu->stat.instruction_sigp_sense++;
>>>>>>> @@ -411,6 +415,12 @@ int kvm_s390_handle_sigp(struct
>>>>>>> kvm_vcpu
>>>>>>> *vcpu)
>>>>>>>   	if (handle_sigp_order_in_user_space(vcpu, order_code,
>>>>>>> cpu_addr))
>>>>>>>   		return -EOPNOTSUPP;
>>>>>>>   
>>>>>>> +	/* Check the current vcpu, if it was a target from
>>>>>>> another vcpu
>>>>>>> */
>>>>>>> +	if (kvm_s390_vcpu_is_sigp_busy(vcpu)) {
>>>>>>> +		kvm_s390_set_psw_cc(vcpu, SIGP_CC_BUSY);
>>>>>>> +		return 0;
>>>>>>> +	}
>>>>>>
>>>>>> I don't think we need this. I think the above (checking the
>>>>>> target of
>>>>>> a
>>>>>> SIGP order) is sufficient. Or which situation do you have in
>>>>>> mind?
>>>>>>
>>>>>
>>>>> Hrm... I think you're right. I was thinking of this:
>>>>>
>>>>> VCPU 1 - SIGP STOP CPU 2
>>>>> VCPU 2 - SIGP SENSE CPU 1
>>>>>
>>>>> But of course either CPU2 is going to be marked "busy" first,
>>>>> and
>>>>> the
>>>>> sense doesn't get processed until it's reset, or the sense
>>>>> arrives
>>>>> first, and the busy/notbusy doesn't matter. Let me doublecheck
>>>>> my
>>>>> tests
>>>>> for the non-RFC version.
>>>>>
>>>>>> I do wonder if we want to make this a kvm_arch_vcpu_ioctl()
>>>>>> instead,
>>>>>
>>>>> In one of my original attempts between v1 and v2, I had put
>>>>> this
>>>>> there.
>>>>> This reliably deadlocks my guest, because the caller
>>>>> (kvm_vcpu_ioctl())
>>>>> tries to acquire vcpu->mutex, and racing SIGPs (via KVM_RUN)
>>>>> might
>>>>> already be holding it. Thus, it's an async ioctl. I could fold
>>>>> it
>>>>> into
>>>>> the existing interrupt ioctl, but as those are architected
>>>>> structs
>>>>> it
>>>>> seems more natural do it this way. Or I have mis-understood
>>>>> something
>>>>> along the way?
>>>>>
>>>>>> essentially just providing a KVM_S390_SET_SIGP_BUSY *and*
>>>>>> providing
>>>>>> the
>>>>>> order. "order == 0" sets it to !busy.
>>>>>
>>>>> I'd tried this too, since it provided some nice debug-ability.
>>>>> Unfortunately, I have a testcase (which I'll eventually get
>>>>> folded
>>>>> into
>>>>> kvm-unit-tests :)) that picks a random order between 0-255,
>>>>> knowing
>>>>> that there's only a couple handfuls of valid orders, to check
>>>>> the
>>>>> response. Zero is valid architecturally (POPS figure 4-29),
>>>>> even if
>>>>> it's unassigned. The likelihood of it becoming assigned is
>>>>> probably
>>>>> quite low, but I'm not sure that I like special-casing an order
>>>>> of
>>>>> zero
>>>>> in this way.
>>>>>
>>>>
>>>> Looking at the API I'd like to avoid having two IOCTLs 
>>>
>>> Since the order is a single byte, we could have the payload of an
>>> ioctl
>>> say "0-255 is an order that we're busy processing, anything higher
>>> than
>>> that resets the busy" or something. That would remove the need for
>>> a
>>> second IOCTL.
>>
>> Maybe just pass an int and treat a negative (or just -1) value as
>> clearing the order.
>>
> 
> Right, that's exactly what I had at one point. I thought it was too
> cumbersome, but maybe not. Will dust it off, pending my question to
> Janosch about 0-vs-1 IOCTLs.

As we really only care about the SIGP STOP case, you could theoretically
bury it into kvm_arch_vcpu_ioctl_set_mpstate(), using a new state
"KVM_MP_STATE_STOPPING".

-- 
Thanks,

David / dhildenb

