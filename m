Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC93266278
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 17:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgIKPsa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 11:48:30 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:58198 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726170AbgIKPni (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Sep 2020 11:43:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599838984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FVvWuDRuisEBX+0Zn/CcIYXbEBhRKURBa9x/u41gEYU=;
        b=S7JctqrnNb2MHei0bPE98FGNA5byrVWo/LDlf+LIBiZ2JlZv0wCE2q1H4ajh7fmh7rt9iz
        tkF7xhvV9lq/xt0wR2CbwoQumdeAxQym4Ja7/Fp7PmWjRHdGbfskaP2mLQPJpcc0X3Kl5z
        jZf5M3tB302rsxo5GvyEi6Y0VfiP78Q=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-7YAs6linPLOKpX90W3IsWA-1; Fri, 11 Sep 2020 11:43:00 -0400
X-MC-Unique: 7YAs6linPLOKpX90W3IsWA-1
Received: by mail-wm1-f69.google.com with SMTP id m25so1091207wmi.0
        for <kvm@vger.kernel.org>; Fri, 11 Sep 2020 08:43:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FVvWuDRuisEBX+0Zn/CcIYXbEBhRKURBa9x/u41gEYU=;
        b=pGX+DUTucefWXZtyZVvpwqoriFSThR82a7Y3WsDmyngUr9YssAR/+VycFQPunRzmjs
         06UHfRZ6idT7qWUbhQNXxmjA2UqNdf0A1Bx66CDICt7iJCnhBdzptmG4GnFiXJRkoIEV
         BYMELuph/5AOjPx5zdmUQNirgKiyqEoNqIGbf4Ntuix2LoaFS81Qy98SM4wSk1F/WB0m
         XEuiazX12Bkn1pmRy/SVlJ6Yvsl8JhrLxJRTlAC+vRSw6q8x/gHkiO69c5ZR4lAZNInt
         PwE+QeII8IRp8b/ZpJuaM6Z+HJIhJaa5peR+c41s0w6EgaaGXigGvegwJbihCi1VRki2
         0ftA==
X-Gm-Message-State: AOAM532flBwqbY2HLP92cTcvGSOVNIVss6YIUA4Z/Zv/5brqxrtXLghE
        8Vg8pggINyvMCLPxJrxbxu60eR/NlFOWZntIGPdPfhuWiD06dcr1uhuJo2t21JuYzJosriF/MwD
        3QV+0Ipv3S79/
X-Received: by 2002:a05:6000:124d:: with SMTP id j13mr2866221wrx.182.1599838979663;
        Fri, 11 Sep 2020 08:42:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwH4jkVUD6E8IpA1UAChk652kXQGIgRngAJxmNyGQnsNw/F6wpulBuvJswNO1yaVHdkevNdqg==
X-Received: by 2002:a05:6000:124d:: with SMTP id j13mr2866196wrx.182.1599838979395;
        Fri, 11 Sep 2020 08:42:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5568:7f99:4893:a5b6? ([2001:b07:6468:f312:5568:7f99:4893:a5b6])
        by smtp.gmail.com with ESMTPSA id v9sm5288411wru.37.2020.09.11.08.42.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 08:42:58 -0700 (PDT)
Subject: Re: [PATCH] KVM: Check the allocation of pv cpu mask
To:     Haiwei Li <lihaiwei.kernel@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Cc:     "hpa@zytor.com" <hpa@zytor.com>, "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>, tglx@linutronix.de,
        joro@8bytes.org, jmattson@google.com,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        vkuznets@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <d59f05df-e6d3-3d31-a036-cc25a2b2f33f@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0617b9ae-8ddb-dcb7-a345-9d629916d20d@redhat.com>
Date:   Fri, 11 Sep 2020 17:42:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <d59f05df-e6d3-3d31-a036-cc25a2b2f33f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/09/20 13:41, Haiwei Li wrote:
> From: Haiwei Li <lihaiwei@tencent.com>
> 
> check the allocation of per-cpu __pv_cpu_mask. Initialize ops only when
> successful.
> 
> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
> ---
>  arch/x86/kernel/kvm.c | 23 +++++++++++++++++++----
>  1 file changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 08320b0b2b27..a64b894eaac0 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -555,7 +555,6 @@ static void kvm_send_ipi_mask_allbutself(const
> struct cpumask *mask, int vector)
>  static void kvm_setup_pv_ipi(void)
>  {
>      apic->send_IPI_mask = kvm_send_ipi_mask;
> -    apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
>      pr_info("setup PV IPIs\n");
>  }
> 
> @@ -654,7 +653,6 @@ static void __init kvm_guest_init(void)
>      }
> 
>      if (pv_tlb_flush_supported()) {
> -        pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
>          pv_ops.mmu.tlb_remove_table = tlb_remove_table;
>          pr_info("KVM setup pv remote TLB flush\n");
>      }
> @@ -767,6 +765,14 @@ static __init int activate_jump_labels(void)
>  }
>  arch_initcall(activate_jump_labels);
> 
> +static void kvm_free_pv_cpu_mask(void)
> +{
> +    unsigned int cpu;
> +
> +    for_each_possible_cpu(cpu)
> +        free_cpumask_var(per_cpu(__pv_cpu_mask, cpu));
> +}
> +
>  static __init int kvm_alloc_cpumask(void)
>  {
>      int cpu;
> @@ -785,11 +791,20 @@ static __init int kvm_alloc_cpumask(void)
> 
>      if (alloc)
>          for_each_possible_cpu(cpu) {
> -            zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
> -                GFP_KERNEL, cpu_to_node(cpu));
> +            if (!zalloc_cpumask_var_node(
> +                per_cpu_ptr(&__pv_cpu_mask, cpu),
> +                GFP_KERNEL, cpu_to_node(cpu))) {
> +                goto zalloc_cpumask_fail;
> +            }
>          }
> 
> +    apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
> +    pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
>      return 0;
> +
> +zalloc_cpumask_fail:
> +    kvm_free_pv_cpu_mask();
> +    return -ENOMEM;
>  }
>  arch_initcall(kvm_alloc_cpumask);
> 
> -- 
> 2.18.4
> 

Queued, thanks.

I am currently on leave so I am going through the patches and queuing
them, but I will only push kvm/next and kvm/queue next week.  kvm/master
patches will be sent to Linus for the next -rc though.

Paolo

