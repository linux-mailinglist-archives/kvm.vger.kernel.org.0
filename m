Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989F31C372C
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 12:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbgEDKtc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 06:49:32 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44446 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726445AbgEDKtb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 06:49:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588589370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nN1gwhKlafwwpra/2V+AF/XlCAPHGrwuEYLMMDNzEYY=;
        b=Z4ZK/dO4J99dtnzlsMwvQy6wURNiPFcg8dUsIs5/kQIqDwEJN86ZugqN4eiMBMLRT2Wljh
        eBw8gElBZ/S8mfRN5bfVQiq1aAxg9YXfBN/QZ0XNqCP2uVmzhSOHLAyg4so7aGlEbCNPnH
        d+P+LC+/EjnvBIehpaEH5reOfd7wchU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-7_n6BLT0NZekblGbwBI9Mw-1; Mon, 04 May 2020 06:49:28 -0400
X-MC-Unique: 7_n6BLT0NZekblGbwBI9Mw-1
Received: by mail-wm1-f72.google.com with SMTP id o26so3294447wmh.1
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 03:49:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nN1gwhKlafwwpra/2V+AF/XlCAPHGrwuEYLMMDNzEYY=;
        b=rPxro22z4K+cSy6XVErMs0UmfE2FKHrVCEQ8y7jR/f3pRm6EUpWCn3ROO9jyg+qy6w
         krrooBzKTNF3u11HZ0L6xp1093KdhjMk1vTW6d099pAWEazcDYJfxVkSzMGm/2A3ISOB
         nkf2X6ag5J9uL4QUhb3p++J67MYPAAG1N35wlev5tBeJX20rnH6kRkrETKHDWRqmiZuJ
         9Kxx/1j94Ts2Hc+xRaxEsGY+Ppv1QGYFFwY38W/7vvm5nwxTpCg5RVsJxJ952UnN1Dbf
         iaDneCHW9AQYRCZPWotgb6+5tn9ianfOBht10vJuqFYOu7xIf7sKdJF/PV2ndhOv32qY
         ofPA==
X-Gm-Message-State: AGi0Pub1k1F5WVTT6eS+gGJlLRo0NrWOIHEBYQot1s3y27lpVH/llbIQ
        Z79jhew+FOp6R26gHnlVcP1U85X1EnEPWfhu+lVYLZguRolEwhZTpsv44D4lphbfRBp1SAgv8uR
        ue+3x0b90hgG2
X-Received: by 2002:a05:6000:85:: with SMTP id m5mr8682231wrx.281.1588589367646;
        Mon, 04 May 2020 03:49:27 -0700 (PDT)
X-Google-Smtp-Source: APiQypI4AnYukL6qV6JNMQOaq0JC3/6Eejcrk8CKEDY1rfOogPDadeE86weQXuqNTyUYR9wxR9atsQ==
X-Received: by 2002:a05:6000:85:: with SMTP id m5mr8682203wrx.281.1588589367364;
        Mon, 04 May 2020 03:49:27 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id b66sm13671732wmh.12.2020.05.04.03.49.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 03:49:26 -0700 (PDT)
Subject: Re: AVIC related warning in enable_irq_window
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <9ce7bb5c4fb8bcc4ac21103f7534a6edfcbe195d.camel@redhat.com>
 <758b27a8-74c0-087d-d90b-d95faee2f561@redhat.com>
 <c5c32371-4b4e-1382-c616-3830ba46bf85@amd.com>
 <159382e7fdf0f9b50d79e29554842289e92e1ed7.camel@redhat.com>
 <d22d32de-5d91-662a-bf53-8cfb115dbe8d@redhat.com>
 <c81cf9bb-840a-d076-bc0e-496916621bdd@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <23b0dfe5-eba4-136b-0d4a-79f57f8a03ff@redhat.com>
Date:   Mon, 4 May 2020 12:49:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <c81cf9bb-840a-d076-bc0e-496916621bdd@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/05/20 12:37, Suravee Suthikulpanit wrote:
> Paolo / Maxim,
> 
> On 5/4/20 4:25 PM, Paolo Bonzini wrote:
>> On 04/05/20 11:13, Maxim Levitsky wrote:
>>> On Mon, 2020-05-04 at 15:46 +0700, Suravee Suthikulpanit wrote:
>>>> Paolo / Maxim,
>>>>
>>>> On 5/2/20 11:42 PM, Paolo Bonzini wrote:
>>>>> On 02/05/20 15:58, Maxim Levitsky wrote:
>>>>>> The AVIC is disabled by svm_toggle_avic_for_irq_window, which calls
>>>>>> kvm_request_apicv_update, which broadcasts the
>>>>>> KVM_REQ_APICV_UPDATE vcpu request,
>>>>>> however it doesn't broadcast it to CPU on which now we are
>>>>>> running, which seems OK,
>>>>>> because the code that handles that broadcast runs on each VCPU
>>>>>> entry, thus
>>>>>> when this CPU will enter guest mode it will notice and disable the
>>>>>> AVIC.
>>>>>>
>>>>>> However later in svm_enable_vintr, there is test
>>>>>> 'WARN_ON(kvm_vcpu_apicv_active(&svm->vcpu));'
>>>>>> which is still true on current CPU because of the above.
>>>>>
>>>>> Good point!  We can just remove the WARN_ON I think.  Can you send
>>>>> a patch?
>>>>
>>>> Instead, as an alternative to remove the WARN_ON(), would it be
>>>> better to just explicitly
>>>> calling kvm_vcpu_update_apicv(vcpu) to update the apicv_active flag
>>>> right after
>>>> kvm_request_apicv_update()?
>>>>
>>> This should work IMHO, other that the fact kvm_vcpu_update_apicv will
>>> be called again,
>>> when this vcpu is entered since the KVM_REQ_APICV_UPDATE will still
>>> be pending on it.
>>> It shoudn't be a problem, and we can even add a check to do nothing
>>> when it is called
>>> while avic is already in target enable state.
>>
>> I thought about that but I think it's a bit confusing.  If we want to
>> keep the WARN_ON, Maxim can add an equivalent one to svm_vcpu_run, which
>> is even better because the invariant is clearer.
>>
>> WARN_ON((vmcb->control.int_ctl & (AVIC_ENABLE_MASK | V_IRQ_MASK))
>>     == (AVIC_ENABLE_MASK | V_IRQ_MASK));
>>
>> Paolo
>>
> 
> Quick update. I tried your suggestion as following, and it's showing the
> warning still.
> I'll look further into this.

Ok, thanks.  By the way, there is another possible cleanup: the clearing
of V_IRQ_MASK can be removed from interrupt_window_interception since it
has already called svm_clear_vintr.

Paolo

>  arch/x86/kvm/svm/svm.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 2f379ba..142c4b9 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1368,9 +1368,6 @@ static inline void svm_enable_vintr(struct
> vcpu_svm *svm)
>  {
>         struct vmcb_control_area *control;
> 
> -       /* The following fields are ignored when AVIC is enabled */
> -       WARN_ON(kvm_vcpu_apicv_active(&svm->vcpu));
> -
>         /*
>          * This is just a dummy VINTR to actually cause a vmexit to happen.
>          * Actual injection of virtual interrupts happens through EVENTINJ.
> @@ -3322,6 +3319,11 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
>                 vcpu->arch.apic->lapic_timer.timer_advance_ns)
>                 kvm_wait_lapic_expire(vcpu);
> 
> +//SURAVEE
> +       WARN_ON((svm->vmcb->control.int_ctl &
> +                (AVIC_ENABLE_MASK | V_IRQ_MASK))
> +                == (AVIC_ENABLE_MASK | V_IRQ_MASK));
> +
> 
> Suravee
> 

