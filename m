Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72325495347
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 18:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbiATRa6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 12:30:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:27666 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229629AbiATRa4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Jan 2022 12:30:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642699855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IkB7CPai7zRAUS8eDOWK08l8atesFAKaxR0i6utoTbY=;
        b=Uly3hkGlqawKPP+BJJyBirNPA5fMAfISNohXouSgMr100cqJjcAP+5RGjI1PzD9sDqV4NC
        N1TIPBUgo6Dbx9xUE7fx5efmphRUdfBHCPN3i+FD0GcpDtxkNOaCpo1m5xdEngJSMse+sM
        VI6UCuP5nOepkgf8Zm03DVee5laQvd4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-DZC96hXcOEKNNrSwlL6juA-1; Thu, 20 Jan 2022 12:30:52 -0500
X-MC-Unique: DZC96hXcOEKNNrSwlL6juA-1
Received: by mail-wm1-f70.google.com with SMTP id c16-20020a1c9a10000000b0034dd409329eso3415415wme.3
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 09:30:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IkB7CPai7zRAUS8eDOWK08l8atesFAKaxR0i6utoTbY=;
        b=dsFHt0nmTUfEH8suKGRgcpPfzkkV1ZyGHTAJCkICt6s3qzfu8v/i34AlE4c0Hr76/c
         aVf1ZFbJunppIPx+Jcn+y33Xnob856Z6QUQ3AIzuuWMWsRB7guAPdZ1+AjMoZ/JCxfAR
         b0sQDByMYMAd7Lp9Kau9qUSnOh5EleOtIoxfX/9FpsZ5ePiUUfDvBoGMHgRIETYPWDgC
         MQxvSqM/hxhD2kz+A9cImZc8wqT6R97ElJXP0a7OXMYTZ/pFq7cJ77eS0ttX82nauNwx
         lTfauYGirE8uZ36S38Aq4CtbccC0hcc2Nqj+KnZc4cmOJ3pjGlXV+kAo7mUleWluX2fs
         ZtiA==
X-Gm-Message-State: AOAM533RirwV77SbaD6piRGXBEeXqM4kUL5UaG30xnihdsGcW8LyH0N/
        +hSvTwhyRW16soYfsrK+54M7COsxySsozGRP5eXEj4FQQ/zZTu9vvI23clVNBgtUyLGzGpZgEoj
        7h0pqTbdABbJ1
X-Received: by 2002:a05:600c:34c8:: with SMTP id d8mr1816376wmq.58.1642699850888;
        Thu, 20 Jan 2022 09:30:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzaAloDx5Ujs8JM+35z4bke2PrhPJ06Dstg8FVhriZ/XlBW+3rMS3WGo2RxRIruQw3FHef8JQ==
X-Received: by 2002:a05:600c:34c8:: with SMTP id d8mr1816344wmq.58.1642699850648;
        Thu, 20 Jan 2022 09:30:50 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id i94sm3293051wri.21.2022.01.20.09.30.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jan 2022 09:30:50 -0800 (PST)
Message-ID: <8affded4-e2ab-c523-4812-de63fd079906@redhat.com>
Date:   Thu, 20 Jan 2022 18:30:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2] KVM: VMX: Dont' send posted IRQ if vCPU == this vCPU
 and vCPU is IN_GUEST_MODE
Content-Language: en-US
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1641609762-39471-1-git-send-email-wanpengli@tencent.com>
 <CANRm+Cx_CQ_SgpT3QvptRy2HZeQEyDkM7Uzh4keJ1XfT6gwX6w@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CANRm+Cx_CQ_SgpT3QvptRy2HZeQEyDkM7Uzh4keJ1XfT6gwX6w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/19/22 08:11, Wanpeng Li wrote:
> kindly ping, :)

Will look at it next week for 5.18.

Paolo

> On Sat, 8 Jan 2022 at 10:43, Wanpeng Li <kernellwp@gmail.com> wrote:
>>
>> From: Wanpeng Li <wanpengli@tencent.com>
>>
>> When delivering a virtual interrupt, don't actually send a posted interrupt
>> if the target vCPU is also the currently running vCPU and is IN_GUEST_MODE,
>> in which case the interrupt is being sent from a VM-Exit fastpath and the
>> core run loop in vcpu_enter_guest() will manually move the interrupt from
>> the PIR to vmcs.GUEST_RVI.  IRQs are disabled while IN_GUEST_MODE, thus
>> there's no possibility of the virtual interrupt being sent from anything
>> other than KVM, i.e. KVM won't suppress a wake event from an IRQ handler
>> (see commit fdba608f15e2, "KVM: VMX: Wake vCPU when delivering posted IRQ
>> even if vCPU == this vCPU").
>>
>> Eliding the posted interrupt restores the performance provided by the
>> combination of commits 379a3c8ee444 ("KVM: VMX: Optimize posted-interrupt
>> delivery for timer fastpath") and 26efe2fd92e5 ("KVM: VMX: Handle
>> preemption timer fastpath").
>>
>> Thanks Sean for better comments.
>>
>> Suggested-by: Chao Gao <chao.gao@intel.com>
>> Reviewed-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
>> ---
>>   arch/x86/kvm/vmx/vmx.c | 40 +++++++++++++++++++++-------------------
>>   1 file changed, 21 insertions(+), 19 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index fe06b02994e6..e06377c9a4cf 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -3908,31 +3908,33 @@ static inline void kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
>>   #ifdef CONFIG_SMP
>>          if (vcpu->mode == IN_GUEST_MODE) {
>>                  /*
>> -                * The vector of interrupt to be delivered to vcpu had
>> -                * been set in PIR before this function.
>> +                * The vector of the virtual has already been set in the PIR.
>> +                * Send a notification event to deliver the virtual interrupt
>> +                * unless the vCPU is the currently running vCPU, i.e. the
>> +                * event is being sent from a fastpath VM-Exit handler, in
>> +                * which case the PIR will be synced to the vIRR before
>> +                * re-entering the guest.
>>                   *
>> -                * Following cases will be reached in this block, and
>> -                * we always send a notification event in all cases as
>> -                * explained below.
>> +                * When the target is not the running vCPU, the following
>> +                * possibilities emerge:
>>                   *
>> -                * Case 1: vcpu keeps in non-root mode. Sending a
>> -                * notification event posts the interrupt to vcpu.
>> +                * Case 1: vCPU stays in non-root mode. Sending a notification
>> +                * event posts the interrupt to the vCPU.
>>                   *
>> -                * Case 2: vcpu exits to root mode and is still
>> -                * runnable. PIR will be synced to vIRR before the
>> -                * next vcpu entry. Sending a notification event in
>> -                * this case has no effect, as vcpu is not in root
>> -                * mode.
>> +                * Case 2: vCPU exits to root mode and is still runnable. The
>> +                * PIR will be synced to the vIRR before re-entering the guest.
>> +                * Sending a notification event is ok as the host IRQ handler
>> +                * will ignore the spurious event.
>>                   *
>> -                * Case 3: vcpu exits to root mode and is blocked.
>> -                * vcpu_block() has already synced PIR to vIRR and
>> -                * never blocks vcpu if vIRR is not cleared. Therefore,
>> -                * a blocked vcpu here does not wait for any requested
>> -                * interrupts in PIR, and sending a notification event
>> -                * which has no effect is safe here.
>> +                * Case 3: vCPU exits to root mode and is blocked. vcpu_block()
>> +                * has already synced PIR to vIRR and never blocks the vCPU if
>> +                * the vIRR is not empty. Therefore, a blocked vCPU here does
>> +                * not wait for any requested interrupts in PIR, and sending a
>> +                * notification event also results in a benign, spurious event.
>>                   */
>>
>> -               apic->send_IPI_mask(get_cpu_mask(vcpu->cpu), pi_vec);
>> +               if (vcpu != kvm_get_running_vcpu())
>> +                       apic->send_IPI_mask(get_cpu_mask(vcpu->cpu), pi_vec);
>>                  return;
>>          }
>>   #endif
>> --
>> 2.25.1
>>
> 

