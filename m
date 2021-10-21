Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A70F436B6D
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 21:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbhJUTo2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 15:44:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50944 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230020AbhJUTo1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 15:44:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634845331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+PE1iw76fpgd7k5mzhy+7WUE7z5G7jGgoVGB0YGadFg=;
        b=XyiUdTtsKaU/Y3YDPO/ZBsSNu8dVCrXGr6/eAw2AEqZwJZYKbMxnzc2N3wEDc56j7JmLDf
        uxb3D/2s1nEWcFn+eXAwJWLzwVxHlsmkXFIbv5T7ZuXICi+0XmzICf7op1MhKScuixzyTE
        KKIrZUAK1kb/iRhU6BALTGc4dxMte2c=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-aV6aTanGPJerndLxYr31hg-1; Thu, 21 Oct 2021 15:42:09 -0400
X-MC-Unique: aV6aTanGPJerndLxYr31hg-1
Received: by mail-ed1-f72.google.com with SMTP id r25-20020a05640216d900b003dca3501ab4so1416862edx.15
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 12:42:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+PE1iw76fpgd7k5mzhy+7WUE7z5G7jGgoVGB0YGadFg=;
        b=fDtGRleludP1weGYG/SEaO+5yGfgKtrm1+M9W0WmLuXONHxddEIprDGzuQL54xkqHL
         K0SwW+9JEEVdjPIH7/lGwoQWwIpbZ6OIV5j++PSPal7sHYrt2L+lB8bPBEuR9zAsr3E9
         k/pcuMpcJ2oSno76mi7RfzWeQ0UIdGc7rsGUdDn1pYQlJhtkRUDE9pBmyOqaozM8p0Um
         dg/mI+hVof3X8FrfzGX+wuMbLB1Ogbq4OI7f/KrzZGCaSPfzbHc/yFV+jtiQaov/i8EB
         TZZccntxV+Ekv1ey1yOPBfSCHQKsq9twvaXZiUl82qNaG2KRiEdYdv9hz2pZEFuxgGaw
         nIVQ==
X-Gm-Message-State: AOAM5319MqAwbYozW+uG/pSfcIFu3e0HlKrW9bkVdrgmyZUUYR2QILe2
        iJfxvbmQl/ixpRrWH4qCD/hBbLENTkoFcE03HY4LT4HkKVPVeO+T/r7EAXbstb7YHU54sHSq5NP
        KrLWcEj+/eZFQ
X-Received: by 2002:a17:906:58cd:: with SMTP id e13mr9555794ejs.471.1634845328570;
        Thu, 21 Oct 2021 12:42:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxkhtkMDDa9zrkMtWuE5+6ImzZy3evY5sti0zbjdLlQ3iuMsB1tu7TxMepuAyVc7Meq/WzVAQ==
X-Received: by 2002:a17:906:58cd:: with SMTP id e13mr9555765ejs.471.1634845328270;
        Thu, 21 Oct 2021 12:42:08 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id x26sm2896967ejf.103.2021.10.21.12.42.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 12:42:07 -0700 (PDT)
Message-ID: <48666e5a-1137-dbc4-7ccc-8d6b9c893944@redhat.com>
Date:   Thu, 21 Oct 2021 21:42:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 3/4] x86/irq: KVM: Harden posted interrupt
 (un)registration paths
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20211009001107.3936588-1-seanjc@google.com>
 <20211009001107.3936588-4-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211009001107.3936588-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/10/21 02:11, Sean Christopherson wrote:
> Split the register and unregister paths for the posted interrupt wakeup
> handler, and WARN on conditions that are blatant bugs, e.g. attempting to
> overwrite an existing handler, unregistering the wrong handler, etc...
> This is very much a "low hanging fruit" hardening, e.g. a broken module
> could foul things up by doing concurrent registration from multiple CPUs.
> 
> Drop the use of a dummy handler so that the rejection logic can use a
> simple NULL check.  There is zero benefit to blindly calling into a dummy
> handler.
> 
> Note, the registration path doesn't require synchronization, as it's the
> caller's responsibility to not generate interrupts it cares about until
> after its handler is registered, i.e. there can't be a relevant in-flight
> interrupt.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Seems a bit overengineered, considering there are just two callers.  Doing

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 20773d315308..766ffe3ba313 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -291,9 +291,10 @@ void kvm_set_posted_intr_wakeup_handler(void (*handler)(void))
  {
  	if (handler)
  		kvm_posted_intr_wakeup_handler = handler;
-	else
+	else {
  		kvm_posted_intr_wakeup_handler = dummy_handler;
-	synchronize_rcu();
+		synchronize_rcu();
+	}
  }
  EXPORT_SYMBOL_GPL(kvm_set_posted_intr_wakeup_handler);
  

on top of path 1 ensures that the synchronization is only done on the
unregistration path.

Paolo

> -- 
>   arch/x86/include/asm/irq.h |  3 ++-
>   arch/x86/kernel/irq.c      | 29 ++++++++++++++++++++---------
>   arch/x86/kvm/vmx/vmx.c     |  4 ++--
>   3 files changed, 24 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
> index 768aa234cbb4..c79014c2443d 100644
> --- a/arch/x86/include/asm/irq.h
> +++ b/arch/x86/include/asm/irq.h
> @@ -30,7 +30,8 @@ struct irq_desc;
>   extern void fixup_irqs(void);
>   
>   #ifdef CONFIG_HAVE_KVM
> -extern void kvm_set_posted_intr_wakeup_handler(void (*handler)(void));
> +extern void kvm_register_posted_intr_wakeup_handler(void (*handler)(void));
> +extern void kvm_unregister_posted_intr_wakeup_handler(void (*handler)(void));
>   #endif
>   
>   extern void (*x86_platform_ipi_callback)(void);
> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> index 20773d315308..97f452cc84be 100644
> --- a/arch/x86/kernel/irq.c
> +++ b/arch/x86/kernel/irq.c
> @@ -284,18 +284,26 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_x86_platform_ipi)
>   #endif
>   
>   #ifdef CONFIG_HAVE_KVM
> -static void dummy_handler(void) {}
> -static void (*kvm_posted_intr_wakeup_handler)(void) = dummy_handler;
> +static void (*kvm_posted_intr_wakeup_handler)(void);
>   
> -void kvm_set_posted_intr_wakeup_handler(void (*handler)(void))
> +void kvm_register_posted_intr_wakeup_handler(void (*handler)(void))
>   {
> -	if (handler)
> -		kvm_posted_intr_wakeup_handler = handler;
> -	else
> -		kvm_posted_intr_wakeup_handler = dummy_handler;
> +	if (WARN_ON_ONCE(!handler || kvm_posted_intr_wakeup_handler))
> +		return;
> +
> +	WRITE_ONCE(kvm_posted_intr_wakeup_handler, handler);
> +}
> +EXPORT_SYMBOL_GPL(kvm_register_posted_intr_wakeup_handler);
> +
> +void kvm_unregister_posted_intr_wakeup_handler(void (*handler)(void))
> +{
> +	if (WARN_ON_ONCE(!handler || handler != kvm_posted_intr_wakeup_handler))
> +		return;
> +
> +	WRITE_ONCE(kvm_posted_intr_wakeup_handler, NULL);
>   	synchronize_rcu();
>   }
> -EXPORT_SYMBOL_GPL(kvm_set_posted_intr_wakeup_handler);
> +EXPORT_SYMBOL_GPL(kvm_unregister_posted_intr_wakeup_handler);
>   
>   /*
>    * Handler for POSTED_INTERRUPT_VECTOR.
> @@ -311,9 +319,12 @@ DEFINE_IDTENTRY_SYSVEC_SIMPLE(sysvec_kvm_posted_intr_ipi)
>    */
>   DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_posted_intr_wakeup_ipi)
>   {
> +	void (*handler)(void) = READ_ONCE(kvm_posted_intr_wakeup_handler);
> +
>   	ack_APIC_irq();
>   	inc_irq_stat(kvm_posted_intr_wakeup_ipis);
> -	kvm_posted_intr_wakeup_handler();
> +	if (handler)
> +		handler();
>   }
>   
>   /*
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index bfdcdb399212..9164f1870d49 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7553,7 +7553,7 @@ static void vmx_migrate_timers(struct kvm_vcpu *vcpu)
>   
>   static void hardware_unsetup(void)
>   {
> -	kvm_set_posted_intr_wakeup_handler(NULL);
> +	kvm_unregister_posted_intr_wakeup_handler(pi_wakeup_handler);
>   
>   	if (nested)
>   		nested_vmx_hardware_unsetup();
> @@ -7907,7 +7907,7 @@ static __init int hardware_setup(void)
>   	if (r)
>   		nested_vmx_hardware_unsetup();
>   
> -	kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
> +	kvm_register_posted_intr_wakeup_handler(pi_wakeup_handler);
>   
>   	return r;
>   }
> 

