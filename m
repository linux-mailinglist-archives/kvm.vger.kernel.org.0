Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24CE7559E56
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 18:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbiFXQIu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 12:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbiFXQIt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 12:08:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5A7A149914
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 09:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656086927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=be1w3XMJSjWVaoG29km4VcWhwBK4h/2G5veMS+PhA+U=;
        b=Ztyk2YBYOJpCxfBhkwHHVjQcBsU+vU7TcpCibwldws4AIYdvI75q52NrIu9vqUA1+tWys1
        UKybsJxuCPhKjnx33MFEWRHzAaMBHO21WB6C8USPmd+Hcn/iFP/g4W9tMxRFQyOjaBwoP9
        oweCBfrNAxIkijEICDQ7T6AsCqMSgzg=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-sYt8NrPWNEe1NY3dM1RWzQ-1; Fri, 24 Jun 2022 12:08:46 -0400
X-MC-Unique: sYt8NrPWNEe1NY3dM1RWzQ-1
Received: by mail-ed1-f70.google.com with SMTP id s15-20020a056402520f00b004327f126170so2181759edd.7
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 09:08:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=be1w3XMJSjWVaoG29km4VcWhwBK4h/2G5veMS+PhA+U=;
        b=nzJhmniBP2kx9oXKS8S8Y9sYTHY/fyyuckcI2xYNY6C4nV41WjJe8zB4UiDdiS85js
         JHyY/EFDtlG1ronPz+XZbKCoebdqPpup9T2JoYYFbJF2Or826EIfqZ5pxMIwC2OM7WZy
         kYQh7b+9YmhIGpZYxJzmtoyZFfqWzGvR1Ss3mw5PUV4+13jjgz6G3txUVZFiRHPHJ9lb
         E63R1VFGGhAe/sIolkM+uBu5YrfSBpmFlmkC0V1P4c3K94ASqPYi5NTmahSavyxkLHQS
         4weGQBbvZEt5OavcIsW833NzVBhPfeb7KubL6ZuELYPN0/D0A+uEnPQn6oFkMnOQrLDF
         V/xQ==
X-Gm-Message-State: AJIora9L0xXSl+hW2bkQQEQ/Ie2/MZEdNrzuEVUTA18AA9KgfX2ONBzG
        y0Ecxe3eLV+3S7ABivSGfW7GWDzJrPMXlajydjLshk+yuGF1345RDb//Qt2Kp+0+MHw4z0xv3CG
        hwV9qtIjTlCcH
X-Received: by 2002:a05:6402:3224:b0:435:80fd:333 with SMTP id g36-20020a056402322400b0043580fd0333mr18771655eda.76.1656086925299;
        Fri, 24 Jun 2022 09:08:45 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uXYghp9ZnBSEx33GwyKSaey/8LMSpKuk8zD0DPQx/yJyCXPb5SDkZZNyvT+OS3Uqu+7N1/Iw==
X-Received: by 2002:a05:6402:3224:b0:435:80fd:333 with SMTP id g36-20020a056402322400b0043580fd0333mr18771627eda.76.1656086925038;
        Fri, 24 Jun 2022 09:08:45 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id q4-20020a1709064cc400b006fec4ee28d0sm1334565ejt.189.2022.06.24.09.08.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jun 2022 09:08:44 -0700 (PDT)
Message-ID: <4cd170cb-4c1d-8532-22ac-fcee6b7d33bb@redhat.com>
Date:   Fri, 24 Jun 2022 18:08:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v6 02/17] KVM: x86: lapic: Rename
 [GET/SET]_APIC_DEST_FIELD to [GET/SET]_XAPIC_DEST_FIELD
Content-Language: en-US
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com,
        Pankaj Gupta <pankaj.gupta@amd.com>
References: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
 <20220519102709.24125-3-suravee.suthikulpanit@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220519102709.24125-3-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/19/22 12:26, Suravee Suthikulpanit wrote:
> To signify that the macros only support 8-bit xAPIC destination ID.
> 
> Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>   arch/x86/hyperv/hv_apic.c      | 2 +-
>   arch/x86/include/asm/apicdef.h | 4 ++--
>   arch/x86/kernel/apic/apic.c    | 2 +-
>   arch/x86/kernel/apic/ipi.c     | 2 +-
>   arch/x86/kvm/lapic.c           | 2 +-
>   arch/x86/kvm/svm/avic.c        | 4 ++--
>   6 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/hyperv/hv_apic.c b/arch/x86/hyperv/hv_apic.c
> index db2d92fb44da..fb8b2c088681 100644
> --- a/arch/x86/hyperv/hv_apic.c
> +++ b/arch/x86/hyperv/hv_apic.c
> @@ -46,7 +46,7 @@ static void hv_apic_icr_write(u32 low, u32 id)
>   {
>   	u64 reg_val;
>   
> -	reg_val = SET_APIC_DEST_FIELD(id);
> +	reg_val = SET_XAPIC_DEST_FIELD(id);
>   	reg_val = reg_val << 32;
>   	reg_val |= low;
>   
> diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
> index 5716f22f81ac..863c2cad5872 100644
> --- a/arch/x86/include/asm/apicdef.h
> +++ b/arch/x86/include/asm/apicdef.h
> @@ -89,8 +89,8 @@
>   #define		APIC_DM_EXTINT		0x00700
>   #define		APIC_VECTOR_MASK	0x000FF
>   #define	APIC_ICR2	0x310
> -#define		GET_APIC_DEST_FIELD(x)	(((x) >> 24) & 0xFF)
> -#define		SET_APIC_DEST_FIELD(x)	((x) << 24)
> +#define		GET_XAPIC_DEST_FIELD(x)	(((x) >> 24) & 0xFF)
> +#define		SET_XAPIC_DEST_FIELD(x)	((x) << 24)
>   #define	APIC_LVTT	0x320
>   #define	APIC_LVTTHMR	0x330
>   #define	APIC_LVTPC	0x340
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index b70344bf6600..e6b754e43ed7 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -275,7 +275,7 @@ void native_apic_icr_write(u32 low, u32 id)
>   	unsigned long flags;
>   
>   	local_irq_save(flags);
> -	apic_write(APIC_ICR2, SET_APIC_DEST_FIELD(id));
> +	apic_write(APIC_ICR2, SET_XAPIC_DEST_FIELD(id));
>   	apic_write(APIC_ICR, low);
>   	local_irq_restore(flags);
>   }
> diff --git a/arch/x86/kernel/apic/ipi.c b/arch/x86/kernel/apic/ipi.c
> index d1fb874fbe64..2a6509e8c840 100644
> --- a/arch/x86/kernel/apic/ipi.c
> +++ b/arch/x86/kernel/apic/ipi.c
> @@ -99,7 +99,7 @@ void native_send_call_func_ipi(const struct cpumask *mask)
>   
>   static inline int __prepare_ICR2(unsigned int mask)
>   {
> -	return SET_APIC_DEST_FIELD(mask);
> +	return SET_XAPIC_DEST_FIELD(mask);
>   }
>   
>   static inline void __xapic_wait_icr_idle(void)
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 137c3a2f5180..8b8c4a905976 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1326,7 +1326,7 @@ void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
>   	if (apic_x2apic_mode(apic))
>   		irq.dest_id = icr_high;
>   	else
> -		irq.dest_id = GET_APIC_DEST_FIELD(icr_high);
> +		irq.dest_id = GET_XAPIC_DEST_FIELD(icr_high);
>   
>   	trace_kvm_apic_ipi(icr_low, irq.dest_id);
>   
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 54fe03714f8a..a8f514212b87 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -328,7 +328,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
>   	if (apic_x2apic_mode(vcpu->arch.apic))
>   		dest = icrh;
>   	else
> -		dest = GET_APIC_DEST_FIELD(icrh);
> +		dest = GET_XAPIC_DEST_FIELD(icrh);
>   
>   	/*
>   	 * Try matching the destination APIC ID with the vCPU.
> @@ -364,7 +364,7 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
>   	 */
>   	kvm_for_each_vcpu(i, vcpu, kvm) {
>   		if (kvm_apic_match_dest(vcpu, source, icrl & APIC_SHORT_MASK,
> -					GET_APIC_DEST_FIELD(icrh),
> +					GET_XAPIC_DEST_FIELD(icrh),
>   					icrl & APIC_DEST_MASK)) {
>   			vcpu->arch.apic->irr_pending = true;
>   			svm_complete_interrupt_delivery(vcpu,

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

