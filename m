Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306DA4A5BF4
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 13:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237860AbiBAMMF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 07:12:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:58120 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237867AbiBAMMD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Feb 2022 07:12:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643717523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2CxPyuHcSSMfylbMraAFLznZLkw0l2GAqkTDlOgQsho=;
        b=Ky1Nq/9180lqha6dIvdc3w9JpCEnBT7YwLYCNti5hopmmMVG3gL5WPpZKOKXgqFFk4gacS
        YO8kLALXm5W65v2QMRWF+BPQzCAmkEYb0wDhFrg1REUDkEUl22qxpUPG0pQ3xRkYwG+vDb
        SDBGKAQ2fSvrleF1OYev3+FurTUQbhI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-505-BwxSzanHPhOtyU5S-9S1Aw-1; Tue, 01 Feb 2022 07:12:02 -0500
X-MC-Unique: BwxSzanHPhOtyU5S-9S1Aw-1
Received: by mail-ed1-f69.google.com with SMTP id bc24-20020a056402205800b00407cf07b2e0so8619926edb.8
        for <kvm@vger.kernel.org>; Tue, 01 Feb 2022 04:12:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2CxPyuHcSSMfylbMraAFLznZLkw0l2GAqkTDlOgQsho=;
        b=XbZx757fBcm6pUzZvocJ73XcBnoxpYq4ZtIX/9HHSg79iCPM28B2zeSRZrWxvd+uGe
         VaFna3JNVFX+kfPbpYCU6lBxuKgcp96XWiK6z//0h4+oYU0GrlkZEkYClubwrdzbyAE3
         yyMMzrS/jgVX3L2o0yW+AijWHX+BkJpcI6JqmQERxiJs7DBbeRGUFhOquNaQsOlwqocT
         B/2ehMpXUyMAdR50oR3t2u6IBKi50w14WMhxv9B+VUnBJnhq2RhfHrDT7Du3AakBSC1n
         dOujNJn7RZV9O5gV0bUGiz8dcVX3rZx0N3+2h9+b8yANbbtIdtulFdqHUCi9KmgX5Xfz
         91Ow==
X-Gm-Message-State: AOAM531TLq6QDCVXpXDNrqy/Wh7t+9QUb7MgJY60SCLJIL1bAcw55/7a
        MTXyUEnSl3vTpVET9Ctzx9C8pi9Mcup6h8B8blqOgqYkPnupW6l/a+gdC7cDPvQ/8uQcNXvCb+u
        4HInueRtkeLbx
X-Received: by 2002:a05:6402:2688:: with SMTP id w8mr24569146edd.393.1643717520905;
        Tue, 01 Feb 2022 04:12:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyC1pnh27oYwvF+9hq/zLGRDe9+J3vYXiCA9VPB+SkOVhI51PZeXci7q2hk7BuWi9N/7Y2xzQ==
X-Received: by 2002:a05:6402:2688:: with SMTP id w8mr24569133edd.393.1643717520681;
        Tue, 01 Feb 2022 04:12:00 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id gr24sm14313941ejb.185.2022.02.01.04.11.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Feb 2022 04:12:00 -0800 (PST)
Message-ID: <ac5ff45b-ba7d-6548-e133-a3c77ea7c713@redhat.com>
Date:   Tue, 1 Feb 2022 13:11:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH RESEND v2] KVM: VMX: Dont' send posted IRQ if vCPU == this
 vCPU and vCPU is IN_GUEST_MODE
Content-Language: en-US
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1643111979-36447-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <1643111979-36447-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/25/22 12:59, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> When delivering a virtual interrupt, don't actually send a posted interrupt
> if the target vCPU is also the currently running vCPU and is IN_GUEST_MODE,
> in which case the interrupt is being sent from a VM-Exit fastpath and the
> core run loop in vcpu_enter_guest() will manually move the interrupt from
> the PIR to vmcs.GUEST_RVI.  IRQs are disabled while IN_GUEST_MODE, thus
> there's no possibility of the virtual interrupt being sent from anything
> other than KVM, i.e. KVM won't suppress a wake event from an IRQ handler
> (see commit fdba608f15e2, "KVM: VMX: Wake vCPU when delivering posted IRQ
> even if vCPU == this vCPU").
> 
> Eliding the posted interrupt restores the performance provided by the
> combination of commits 379a3c8ee444 ("KVM: VMX: Optimize posted-interrupt
> delivery for timer fastpath") and 26efe2fd92e5 ("KVM: VMX: Handle
> preemption timer fastpath").
> 
> Thanks Sean for better comments.
> 
> Suggested-by: Chao Gao <chao.gao@intel.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 40 +++++++++++++++++++++-------------------
>   1 file changed, 21 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index fe06b02994e6..e06377c9a4cf 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3908,31 +3908,33 @@ static inline void kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
>   #ifdef CONFIG_SMP
>   	if (vcpu->mode == IN_GUEST_MODE) {
>   		/*
> -		 * The vector of interrupt to be delivered to vcpu had
> -		 * been set in PIR before this function.
> +		 * The vector of the virtual has already been set in the PIR.
> +		 * Send a notification event to deliver the virtual interrupt
> +		 * unless the vCPU is the currently running vCPU, i.e. the
> +		 * event is being sent from a fastpath VM-Exit handler, in
> +		 * which case the PIR will be synced to the vIRR before
> +		 * re-entering the guest.
>   		 *
> -		 * Following cases will be reached in this block, and
> -		 * we always send a notification event in all cases as
> -		 * explained below.
> +		 * When the target is not the running vCPU, the following
> +		 * possibilities emerge:
>   		 *
> -		 * Case 1: vcpu keeps in non-root mode. Sending a
> -		 * notification event posts the interrupt to vcpu.
> +		 * Case 1: vCPU stays in non-root mode. Sending a notification
> +		 * event posts the interrupt to the vCPU.
>   		 *
> -		 * Case 2: vcpu exits to root mode and is still
> -		 * runnable. PIR will be synced to vIRR before the
> -		 * next vcpu entry. Sending a notification event in
> -		 * this case has no effect, as vcpu is not in root
> -		 * mode.
> +		 * Case 2: vCPU exits to root mode and is still runnable. The
> +		 * PIR will be synced to the vIRR before re-entering the guest.
> +		 * Sending a notification event is ok as the host IRQ handler
> +		 * will ignore the spurious event.
>   		 *
> -		 * Case 3: vcpu exits to root mode and is blocked.
> -		 * vcpu_block() has already synced PIR to vIRR and
> -		 * never blocks vcpu if vIRR is not cleared. Therefore,
> -		 * a blocked vcpu here does not wait for any requested
> -		 * interrupts in PIR, and sending a notification event
> -		 * which has no effect is safe here.
> +		 * Case 3: vCPU exits to root mode and is blocked. vcpu_block()
> +		 * has already synced PIR to vIRR and never blocks the vCPU if
> +		 * the vIRR is not empty. Therefore, a blocked vCPU here does
> +		 * not wait for any requested interrupts in PIR, and sending a
> +		 * notification event also results in a benign, spurious event.
>   		 */
>   
> -		apic->send_IPI_mask(get_cpu_mask(vcpu->cpu), pi_vec);
> +		if (vcpu != kvm_get_running_vcpu())
> +			apic->send_IPI_mask(get_cpu_mask(vcpu->cpu), pi_vec);
>   		return;
>   	}
>   #endif

Queued, thanks.

Paolo

