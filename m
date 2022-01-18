Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E03E492361
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 10:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235180AbiARJ4U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 04:56:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56498 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233523AbiARJ4T (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 04:56:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642499779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qKzK39odYFdJD+xI9N6kBwoMHmsZC2eHCsEeCplafwA=;
        b=KuKOXo8RWjSLZ2FgPFUcIq59zyP3G2xTNgO2jkH18OFxZktCKDVIu5YMbHHNs0eBNNNb3U
        JGLJrqU/Lm4YfVXpA7shr8NfGGL5Dn10RTQyT29RHGKPVZj/F//kXjhjzgapUnzZjB8TIa
        33uMEzWfrkfg6QJ3KJKi1Q2epuQhBrg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-484-xjusj_pTPeikHpxK8_GjGw-1; Tue, 18 Jan 2022 04:56:17 -0500
X-MC-Unique: xjusj_pTPeikHpxK8_GjGw-1
Received: by mail-wm1-f70.google.com with SMTP id a3-20020a05600c348300b0034a0dfc86aaso1418750wmq.6
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 01:56:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qKzK39odYFdJD+xI9N6kBwoMHmsZC2eHCsEeCplafwA=;
        b=cyQzQcPZtDCc7qm2lkWkkQ4jObjqnoUPTPhy7JV9tPNjj1s8xizMGt0sQJ3QeemKwK
         tX8l7BPAZPIHKRZ/5+8EBOrQJYbS6tLLjv6JnNVREca7g7ExWziuxlE+1dpQalAj7RIN
         +WV0hWz1RTQsCJo6YiN0r1RVdN3/ylM8tBrh28YKZfukDjbu2AgNwIG0KO4tOL1uCZsF
         2rxwIDq6ggeI5s/a/Dl4mEgenMre+BGePhiHlWTVDQjRG6XdBe//mDnFqpV5C/8Y03Qb
         dLCU02+Hc6aiWbshcH9ofJyOIhJgYAOBh356Idp8Fz6Ty8pCjVwS2XlCke4fQ5vhCBHV
         Qk/A==
X-Gm-Message-State: AOAM532Ia/oeBnU/IWH6a29VGHrHDVFFBj0WcxijYtgv2XPjVGrhgA1E
        j3TI9/dilp3CdOPxrTcwkZJLrvw0iJ4E90H69sQn6tBcSbsp5PLmDhonrN2yYtfN5hzvkO8R0Fl
        P2nz7kmNObZzJ
X-Received: by 2002:a05:6000:2c8:: with SMTP id o8mr8766527wry.70.1642499776325;
        Tue, 18 Jan 2022 01:56:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx8I60iFzlLESpqY+8+ACbEVcKDA75j5FYhUxeWzn6Ajy+x559JWCSDzO9UkXCit4lspd3YCw==
X-Received: by 2002:a05:6000:2c8:: with SMTP id o8mr8766518wry.70.1642499776106;
        Tue, 18 Jan 2022 01:56:16 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id m5sm1829487wmq.6.2022.01.18.01.56.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 01:56:15 -0800 (PST)
Message-ID: <bf8f97ea-f953-3adc-8e67-bc5cd58ec1cc@redhat.com>
Date:   Tue, 18 Jan 2022 10:56:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] KVM: VMX: switch wakeup_vcpus_on_cpu_lock to raw spinlock
Content-Language: en-US
To:     Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20220107175114.GA261406@fuller.cnet>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220107175114.GA261406@fuller.cnet>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/7/22 18:51, Marcelo Tosatti wrote:
> 
> wakeup_vcpus_on_cpu_lock is taken from hard interrupt context
> (pi_wakeup_handler), therefore it cannot sleep.
> 
> Switch it to a raw spinlock.
> 
> Fixes:
> 
> [41297.066254] BUG: scheduling while atomic: CPU 0/KVM/635218/0x00010001
> [41297.066323] Preemption disabled at:
> [41297.066324] [<ffffffff902ee47f>] irq_enter_rcu+0xf/0x60
> [41297.066339] Call Trace:
> [41297.066342]  <IRQ>
> [41297.066346]  dump_stack_lvl+0x34/0x44
> [41297.066353]  ? irq_enter_rcu+0xf/0x60
> [41297.066356]  __schedule_bug.cold+0x7d/0x8b
> [41297.066361]  __schedule+0x439/0x5b0
> [41297.066365]  ? task_blocks_on_rt_mutex.constprop.0.isra.0+0x1b0/0x440
> [41297.066369]  schedule_rtlock+0x1e/0x40
> [41297.066371]  rtlock_slowlock_locked+0xf1/0x260
> [41297.066374]  rt_spin_lock+0x3b/0x60
> [41297.066378]  pi_wakeup_handler+0x31/0x90 [kvm_intel]
> [41297.066388]  sysvec_kvm_posted_intr_wakeup_ipi+0x9d/0xd0
> [41297.066392]  </IRQ>
> [41297.066392]  asm_sysvec_kvm_posted_intr_wakeup_ipi+0x12/0x20
> ...
> 
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> 
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index f4169c009400..aa1fe9085d77 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -27,7 +27,7 @@ static DEFINE_PER_CPU(struct list_head, wakeup_vcpus_on_cpu);
>    * CPU.  IRQs must be disabled when taking this lock, otherwise deadlock will
>    * occur if a wakeup IRQ arrives and attempts to acquire the lock.
>    */
> -static DEFINE_PER_CPU(spinlock_t, wakeup_vcpus_on_cpu_lock);
> +static DEFINE_PER_CPU(raw_spinlock_t, wakeup_vcpus_on_cpu_lock);
>   
>   static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
>   {
> @@ -87,9 +87,9 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
>   	 * current pCPU if the task was migrated.
>   	 */
>   	if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR) {
> -		spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> +		raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
>   		list_del(&vmx->pi_wakeup_list);
> -		spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> +		raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
>   	}
>   
>   	dest = cpu_physical_id(cpu);
> @@ -149,10 +149,10 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
>   
>   	local_irq_save(flags);
>   
> -	spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> +	raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
>   	list_add_tail(&vmx->pi_wakeup_list,
>   		      &per_cpu(wakeup_vcpus_on_cpu, vcpu->cpu));
> -	spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> +	raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
>   
>   	WARN(pi_desc->sn, "PI descriptor SN field set before blocking");
>   
> @@ -204,20 +204,20 @@ void pi_wakeup_handler(void)
>   	int cpu = smp_processor_id();
>   	struct vcpu_vmx *vmx;
>   
> -	spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
> +	raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
>   	list_for_each_entry(vmx, &per_cpu(wakeup_vcpus_on_cpu, cpu),
>   			    pi_wakeup_list) {
>   
>   		if (pi_test_on(&vmx->pi_desc))
>   			kvm_vcpu_wake_up(&vmx->vcpu);
>   	}
> -	spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
> +	raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
>   }
>   
>   void __init pi_init_cpu(int cpu)
>   {
>   	INIT_LIST_HEAD(&per_cpu(wakeup_vcpus_on_cpu, cpu));
> -	spin_lock_init(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
> +	raw_spin_lock_init(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
>   }
>   
>   bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu)
> 

Queued, thanks.

Paolo

