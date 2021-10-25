Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5388F4397E8
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 15:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbhJYN4P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 09:56:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46919 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232823AbhJYN4M (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Oct 2021 09:56:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635170029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ldvB0XPe33TqQvODn/mAyWJW6RTodpHfwe2FHTdvAFU=;
        b=GXXFhEzliPEcJLvvZzh2shwmCdmugPPyjAFuSYTsiTvYCYYFX5h8IzKurdQ7NgbL/4jHE+
        6uCNHLVbNt2NQZGVgXIKUvUW9VOM34Qlyq+qWvr6sPqANxm3NfqJ8FkrSUJSNBzcVur770
        t1Z1Mf6r6cH5IQWNHrvwOQLEtF9w8lM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-l52MN4lJNuW49EsPqmkmiA-1; Mon, 25 Oct 2021 09:53:48 -0400
X-MC-Unique: l52MN4lJNuW49EsPqmkmiA-1
Received: by mail-wm1-f69.google.com with SMTP id k126-20020a1ca184000000b003231d0e329bso3531553wme.4
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 06:53:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ldvB0XPe33TqQvODn/mAyWJW6RTodpHfwe2FHTdvAFU=;
        b=Wkeq2zFJYRpQxLIu/W+Kka2eYUPE1EysKZ/jV2D07BBQSjMauo/WM7BQoTPkM4DQAl
         SlDhyUrMV6dXo9HVuywzkxBZXXIZ/KYedJnWQD679/KUgfQm9jpp+2qfOFCq8PrrJpdw
         bgnm4JIbZ6HMdWCfjyJMCiGP28CqB99XmtxC5jEGwDvNFg0f2UbXnc/uDChfcIY+AORW
         osoZ9Qss2VBooZYNe7ddGXj4O3MMI43x25GOXwEwU8QsRF9na32tl0U/8ZzXgfs6l4LE
         lW03DCGlO4cfuxbWGnzchkFSmBvrZyiZHhX1GM8fN1aclAm6K4G17kJg4ZGarIH6kXCC
         dadA==
X-Gm-Message-State: AOAM53356IGTgujFdYUgfqp8Pe+W2IPPzpGvQPZ682i/WOafdDxMYigC
        H2gYsNuE1OOYr22+sCzRg3GoL62Rajj1RlA9oaYHz5taPdg4+WW3UsAFkbLJ8ui1sHolQjtIdUM
        f77aPaqraFrsX
X-Received: by 2002:a5d:4a0a:: with SMTP id m10mr23196005wrq.8.1635170027188;
        Mon, 25 Oct 2021 06:53:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzEcYontEfeBK4K4y+WBxRPdIWb2mvxosMQ7CiN54IG+B17uliVNi9fSUiTsG9r0hC4umYIPQ==
X-Received: by 2002:a5d:4a0a:: with SMTP id m10mr23195965wrq.8.1635170026960;
        Mon, 25 Oct 2021 06:53:46 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l20sm21932937wmq.42.2021.10.25.06.53.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 06:53:46 -0700 (PDT)
Message-ID: <acfdf0f5-0a18-162a-c785-fa0a520e3364@redhat.com>
Date:   Mon, 25 Oct 2021 15:53:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 22/43] KVM: VMX: Drop unnecessary PI logic to handle
 impossible conditions
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-23-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211009021236.4122790-23-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/10/21 04:12, Sean Christopherson wrote:
> Drop sanity checks on the validity of the previous pCPU when handling
> vCPU block/unlock for posted interrupts.  Barring a code bug or memory
> corruption, the sanity checks will never fire, and any code bug that does
> trip the WARN is all but guaranteed to completely break posted interrupts,
> i.e. should never get anywhere near production.
> 
> This is the first of several steps toward eliminating kvm_vcpu.pre_cpu.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/posted_intr.c | 24 ++++++++++--------------
>   1 file changed, 10 insertions(+), 14 deletions(-)

The idea here is to avoid making things worse by not making the list 
inconsistent.  But that's impossible to do if pre_pcpu goes away, so 
fair enough.

Paolo

> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index 67cbe6ab8f66..6c2110d91b06 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -118,12 +118,10 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
>   	} while (cmpxchg64(&pi_desc->control, old.control,
>   			   new.control) != old.control);
>   
> -	if (!WARN_ON_ONCE(vcpu->pre_pcpu == -1)) {
> -		spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> -		list_del(&vcpu->blocked_vcpu_list);
> -		spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> -		vcpu->pre_pcpu = -1;
> -	}
> +	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> +	list_del(&vcpu->blocked_vcpu_list);
> +	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> +	vcpu->pre_pcpu = -1;
>   }
>   
>   /*
> @@ -153,14 +151,12 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
>   
>   	WARN_ON(irqs_disabled());
>   	local_irq_disable();
> -	if (!WARN_ON_ONCE(vcpu->pre_pcpu != -1)) {
> -		vcpu->pre_pcpu = vcpu->cpu;
> -		spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> -		list_add_tail(&vcpu->blocked_vcpu_list,
> -			      &per_cpu(blocked_vcpu_on_cpu,
> -				       vcpu->pre_pcpu));
> -		spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> -	}
> +
> +	vcpu->pre_pcpu = vcpu->cpu;
> +	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> +	list_add_tail(&vcpu->blocked_vcpu_list,
> +		      &per_cpu(blocked_vcpu_on_cpu, vcpu->pre_pcpu));
> +	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
>   
>   	WARN(pi_desc->sn == 1,
>   	     "Posted Interrupt Suppress Notification set before blocking");
> 

