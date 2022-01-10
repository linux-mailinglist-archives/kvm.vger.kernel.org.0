Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0FE489BE1
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 16:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235967AbiAJPKn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 10:10:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24804 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235938AbiAJPKl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Jan 2022 10:10:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641827441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SLM8O5I4XsqQfDouqPjuMZjGtdO2q2woR6k0IW1Zlz0=;
        b=JWjBDonM0TRGQK/do2Y8QMBF6jktYxECPGBxrK79IpaDEqPhJ6CFY+27fl8oYPAZDMDF6z
        AXIbup85MwOghAeKDVecoliObLoqcuIKmMUrrg+kSE6DIHbLdT7MzY3k2i2iAoq1fWLRPn
        +pRzVeATm9+mR09sp2lfIvoX9bchvvg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-270-vK33Hy8gPX-hRwXZocfnvg-1; Mon, 10 Jan 2022 10:10:40 -0500
X-MC-Unique: vK33Hy8gPX-hRwXZocfnvg-1
Received: by mail-ed1-f72.google.com with SMTP id y10-20020a056402358a00b003f88b132849so10418465edc.0
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 07:10:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=SLM8O5I4XsqQfDouqPjuMZjGtdO2q2woR6k0IW1Zlz0=;
        b=Jy6nGBc5fUD+cqMylgg/dRoBxlrDfZwZQEJfMiQ5/tYwt9Nj1LtSSNSCXPNB017cR5
         ywIKQvX4AFJtnM4UeG0igALzmxTVGoPGdgLfL/HCvR+wk17rQVnTRG65ar7SAAetSlI0
         EFCLKS4At9K3iuF35FT1gq+SzBC4q5psbgoLNhvuRK/Gbpzv9JeWhYJ/WbFWVSnhXiyW
         1FtvnWXlN9667xeATkx28XWrB2KJTm96JCzS1PE2rS2JO86Js52qGDm+BziZGVfgCu9/
         H7ZzbEms+KPEwk+NbtCBqWlNeS6Lcn12Xpyawe5/N3WrjahJP/7M7EDbKpIZHK7ANHEj
         wXlA==
X-Gm-Message-State: AOAM531N76CbYnK7WfI/GyMEsul1QxKWilocWgv6FLxeal99mZafBbr8
        TGiqm0UPmeJ55K0SOuaWcOrch2K9i0uhsBiMmz6imP4ZfvSmX8hi6Rx3FUZ9rGRGdGHh4+dRAJ7
        IW3eXYOWkQrMK
X-Received: by 2002:a05:6402:4405:: with SMTP id y5mr77639eda.179.1641827438904;
        Mon, 10 Jan 2022 07:10:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxLT9e9aX5TGQJz8YqtpWsu2Vw3N+FjhJS/2z70PRmbztYPVe7+65DOq7V5OVNzyG+IRRJnsw==
X-Received: by 2002:a05:6402:4405:: with SMTP id y5mr77607eda.179.1641827438687;
        Mon, 10 Jan 2022 07:10:38 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id g3sm2561967ejo.147.2022.01.10.07.10.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 07:10:38 -0800 (PST)
Message-ID: <c17fb7b3-d7cc-e2e6-dce8-c27d19f5fe00@redhat.com>
Date:   Mon, 10 Jan 2022 16:10:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 3/5] KVM: SVM: fix race between interrupt delivery and
 AVIC inhibition
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>
References: <20211213104634.199141-1-mlevitsk@redhat.com>
 <20211213104634.199141-4-mlevitsk@redhat.com> <YdTPvdY6ysjXMpAU@google.com>
 <628ac6d9b16c6b3a2573f717df0d2417df7caddb.camel@redhat.com>
 <6a11edec-c29a-95df-393e-363e1af46257@redhat.com>
 <YdjPyCRwZDoV11ox@google.com>
Content-Language: en-US
In-Reply-To: <YdjPyCRwZDoV11ox@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/8/22 00:42, Sean Christopherson wrote:
> Yeah, I don't disagree, but the flip side is that without the early check, it's
> not all that obvious that SVM must not return -1.

But that's what the comment is about.

> And when AVIC isn't supported
> or is disabled at the module level, flowing into AVIC "specific" IRR logic is
> a bit weird.  And the LAPIC code effectively becomes Intel-only.

Yeah, I agree that this particular aspect is a bit weird at first.  But 
it is also natural if you consider how IRR is implemented for AVIC vs. 
APICv, especially with respect to incomplete IPIs.  And the LAPIC code 
becomes a blueprint for AVIC's, i.e. you can see that the AVIC code 
effectively becomes the one in lapic.c when you have either 
!vcpu->arch.apicv_active or an incomplete IPI.

I don't hate the code below, it does lose a bit of expressiveness of the 
LAPIC code but I guess it's a good middle ground.

Paolo

> To make everyone happy, and fix the tracepoint issue, what about moving delivery
> into vendor code?  E.g. the below (incomplete), with SVM functions renamed so that
> anything that isn't guaranteed to be AVIC specific uses svm_ instead of avic_.
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index baca9fa37a91..a9ac724c6305 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1096,14 +1096,7 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
>                                                         apic->regs + APIC_TMR);
>                  }
> 
> -               if (static_call(kvm_x86_deliver_posted_interrupt)(vcpu, vector)) {
> -                       kvm_lapic_set_irr(vector, apic);
> -                       kvm_make_request(KVM_REQ_EVENT, vcpu);
> -                       kvm_vcpu_kick(vcpu);
> -               } else {
> -                       trace_kvm_apicv_accept_irq(vcpu->vcpu_id, delivery_mode,
> -                                                  trig_mode, vector);
> -               }
> +               static_call(kvm_x86_deliver_interrupt)(vcpu, vector);
>                  break;
> 
>          case APIC_DM_REMRD:
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index fe06b02994e6..1fadd14ea884 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4012,6 +4012,18 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
>          return 0;
>   }
> 
> +static void vmx_deliver_interrupt(struct kvm_vcpu *vcpu, int vector)
> +{
> +       if (vmx_deliver_posted_interrupt(vcpu, vector)) {
> +               kvm_lapic_set_irr(vector, apic);
> +               kvm_make_request(KVM_REQ_EVENT, vcpu);
> +               kvm_vcpu_kick(vcpu);
> +       } else {
> +               trace_kvm_apicv_accept_irq(vcpu->vcpu_id, delivery_mode,
> +                                          trig_mode, vector);
> +       }
> +}
> +
>   /*
>    * Set up the vmcs's constant host-state fields, i.e., host-state fields that
>    * will not change in the lifetime of the guest.
> @@ -7651,7 +7663,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>          .hwapic_isr_update = vmx_hwapic_isr_update,
>          .guest_apic_has_interrupt = vmx_guest_apic_has_interrupt,
>          .sync_pir_to_irr = vmx_sync_pir_to_irr,
> -       .deliver_posted_interrupt = vmx_deliver_posted_interrupt,
> +       .deliver_interrupt = vmx_deliver_interrupt,
>          .dy_apicv_has_pending_interrupt = pi_has_pending_interrupt,
> 
>          .set_tss_addr = vmx_set_tss_addr,
> 

