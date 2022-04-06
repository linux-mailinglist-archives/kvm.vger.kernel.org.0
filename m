Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5F704F6379
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 17:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236384AbiDFPgh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 11:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236395AbiDFPgL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 11:36:11 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D340421B2FA;
        Wed,  6 Apr 2022 05:50:23 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id n6so3961186ejc.13;
        Wed, 06 Apr 2022 05:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vTCOW92YtaWtP9gBOFJZ28SWmMr1HlrfPw92UcpoTtM=;
        b=oJp0ZgmWu05+xxMueBWXeBuXpPO+SG1WRlLhyswlkLfOPrM4cD/dmA6WSzXnn0MF6J
         vq2RyDk+4P8vJA08yr4pwE+bqaKKgO9OmQELo+bT9EyVfDB0PXQeD7IfzpHvMEGq9j0b
         9KDs0DoKUQaxsp29U+rh474lDCPn2/qmqtdkvxvS/e1351MYtPUOswi8jFkR6fBTOMj0
         IFyNdnOWvAV6PCOqZTx1dso1DrZ3+rjBZOsODwuuobtEMLcDQVWmKsuHYYXl8jd/SfHT
         EEsf2hNLGKOFqjKJATeY/ukCdoiEsFnC1/a4w3a4PKOSV4ODnqdbw73pWvbjPM/8l+9R
         tECA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vTCOW92YtaWtP9gBOFJZ28SWmMr1HlrfPw92UcpoTtM=;
        b=TKqEp2axS5Fo0Z0fg5otBQhyGWIFvgbPuKPkTijTXZMtZKBU/UpToEQpLZM5EC1Uwz
         mTj5BbEevJ+JI69vqJUY11uAVPAKi+Um/yit4USHWMtxwWpDsHEruj/P0RfwxVTjx2mh
         7UnT4o5DDkmJq8oBnYYphkxFPDc2EUhZy9M3iQJsvfbGwV95U6/HSaxsYN/DxbjK+720
         kQ0CNIo6fRtsLhJN6ktGU9J7hxs3/QDQ3rHakGEnTak7L31cOz3/M8ViDRiAYHpwkN1Y
         rx2Lv2kkk/Vsk44TNIGKkqPL9fo/5KE4VMKKN3ur1n4YDeGa4FtV9DqW7wzjaBSARvem
         IK5A==
X-Gm-Message-State: AOAM532mMSqI5KS+xvBfeVFw0JLEcL23b8YER4IxaixvhdHrKUDPrZKE
        EEKyZNRAYHVHiyBj0T+uT1g=
X-Google-Smtp-Source: ABdhPJzgMH6NrDoT1aKPmWrFFVbZZaFmYokcguSj87WGdCrEY2ls4P+N/suRm0Xdg3YZDE6pJwjRWw==
X-Received: by 2002:a17:906:144e:b0:6ce:6126:6a6d with SMTP id q14-20020a170906144e00b006ce61266a6dmr8014240ejc.662.1649249388742;
        Wed, 06 Apr 2022 05:49:48 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id q22-20020a170906771600b006cf8a37ebf5sm6587882ejm.103.2022.04.06.05.49.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 05:49:48 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <afbb7b38-11d9-0cfb-2c7b-df17a9074e3b@redhat.com>
Date:   Wed, 6 Apr 2022 14:49:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 081/104] KVM: VMX: Modify NMI and INTR handlers to
 take intr_info as function argument
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <961a6534904cc8fd2ddd187ab0a930fbf00cc1ca.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <961a6534904cc8fd2ddd187ab0a930fbf00cc1ca.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> TDX uses different ABI to get information about VM exit.  Pass intr_info to
> the NMI and INTR handlers instead of pulling it from vcpu_vmx in
> preparation for sharing the bulk of the handlers with TDX.
> 
> When the guest TD exits to VMM, RAX holds status and exit reason, RCX holds
> exit qualification etc rather than the VMCS fields because VMM doesn't have
> access to the VMCS.  The eventual code will be
> 
> VMX:
>    - get exit reason, intr_info, exit_qualification, and etc from VMCS
>    - call NMI/INTR handlers (common code)
> 
> TDX:
>    - get exit reason, intr_info, exit_qualification, and etc from guest
>      registers
>    - call NMI/INTR handlers (common code)
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 17 ++++++++---------
>   1 file changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 4bd1e61b8d45..008400927144 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6442,28 +6442,27 @@ static void handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
>   		rdmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
>   }
>   
> -static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
> +static void handle_exception_nmi_irqoff(struct kvm_vcpu *vcpu, u32 intr_info)
>   {
>   	const unsigned long nmi_entry = (unsigned long)asm_exc_nmi_noist;
> -	u32 intr_info = vmx_get_intr_info(&vmx->vcpu);
>   
>   	/* if exit due to PF check for async PF */
>   	if (is_page_fault(intr_info))
> -		vmx->vcpu.arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
> +		vcpu->arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
>   	/* if exit due to NM, handle before interrupts are enabled */
>   	else if (is_nm_fault(intr_info))
> -		handle_nm_fault_irqoff(&vmx->vcpu);
> +		handle_nm_fault_irqoff(vcpu);
>   	/* Handle machine checks before interrupts are enabled */
>   	else if (is_machine_check(intr_info))
>   		kvm_machine_check();
>   	/* We need to handle NMIs before interrupts are enabled */
>   	else if (is_nmi(intr_info))
> -		handle_interrupt_nmi_irqoff(&vmx->vcpu, nmi_entry);
> +		handle_interrupt_nmi_irqoff(vcpu, nmi_entry);
>   }
>   
> -static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
> +static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu,
> +					     u32 intr_info)
>   {
> -	u32 intr_info = vmx_get_intr_info(vcpu);
>   	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
>   	gate_desc *desc = (gate_desc *)host_idt_base + vector;
>   
> @@ -6482,9 +6481,9 @@ void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
>   		return;
>   
>   	if (vmx->exit_reason.basic == EXIT_REASON_EXTERNAL_INTERRUPT)
> -		handle_external_interrupt_irqoff(vcpu);
> +		handle_external_interrupt_irqoff(vcpu, vmx_get_intr_info(vcpu));
>   	else if (vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI)
> -		handle_exception_nmi_irqoff(vmx);
> +		handle_exception_nmi_irqoff(vcpu, vmx_get_intr_info(vcpu));
>   }
>   
>   /*

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
