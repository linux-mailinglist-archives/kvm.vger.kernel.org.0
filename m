Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9DF3BD844
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 16:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbhGFOfy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 10:35:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23054 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232320AbhGFOfr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 10:35:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625581693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3GEYToz9UGkj5qm0ImJKs8heV1zy8ZipitXq+LmQpYg=;
        b=WMYOqxdPlT1ilxIBj5HaoCO58ptSkA7zTwUUyNBGupE+z0llsTxvDbObIA6v47G92n85xb
        51Y510MyxgPs9nqxH/q7hroHiSukTKaAiJh5A91a8EXjufw97fmKdd8YJ1CP4IGdeuzRZe
        BkLUGZFmxWLRl2MOknNnUJfUQUm2agM=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-81-3UWaJXrfPzGlCFvN6r2tZg-1; Tue, 06 Jul 2021 10:22:08 -0400
X-MC-Unique: 3UWaJXrfPzGlCFvN6r2tZg-1
Received: by mail-ej1-f70.google.com with SMTP id d2-20020a1709072722b02904c99c7e6ddfso5870194ejl.15
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 07:22:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3GEYToz9UGkj5qm0ImJKs8heV1zy8ZipitXq+LmQpYg=;
        b=IaWKju1hX/1b+8yl6ohXWnU0udL5lEaCeDvmoTavJWqZNe5W3w/NssT0yIj4e6SeJ1
         vgkyaVGyas+qaZZuMntvPQGMCj+8s16YXR7Qgc+sguUmOewqKq/0CcE86vE0q3CkYcJz
         FasrAMYLUGkqFg4sSV044VQ9kTgfVF2YFBIaj0ZmGN7sd1DoXBBlttqiWUUqiZBGU5ui
         PEl4ScfppAXoseg91L3CZUPEn1ezh3fl4/Bqn6sHEhGGiRkt6IYGOHp0hsluG5XbX+ZZ
         ooVL36QZI1Uh2DxyF2SDyadlmqtOIk90vezOk10zLfSNRK08SnCGehVKxXQS7s6R4qKQ
         qdmg==
X-Gm-Message-State: AOAM532zumKhUuRZE3ViFAJB8qtyZ8KYtMX0xfyVB7GHraCvRfdJUbab
        oomA3kr7SAeLgG66AipVF9h9ppbcnJU4FF1mua/wikG+tyNw6k3nr90Brnsk8l9AD49f/W/hsMc
        ymEuKTG4QLCoT
X-Received: by 2002:a17:906:4fce:: with SMTP id i14mr8816402ejw.231.1625581326916;
        Tue, 06 Jul 2021 07:22:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyPVTyy71iN1zsNglx8JRKhOkl4/84YFu6o8CZLhwV75mwOcTtwqWL/Rh/ITsWYsdP7hQ/jBQ==
X-Received: by 2002:a17:906:4fce:: with SMTP id i14mr8816367ejw.231.1625581326738;
        Tue, 06 Jul 2021 07:22:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s3sm5816276ejm.49.2021.07.06.07.22.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 07:22:05 -0700 (PDT)
Subject: Re: [RFC PATCH v2 65/69] KVM: X86: Introduce initial_tsc_khz in
 struct kvm_arch
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Xiaoyao Li <xiaoyao.li@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <5f87f0b888555b52041a0fe32280adee0d563e63.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <792040b0-4463-d805-d14e-ba264a3f8bbf@redhat.com>
Date:   Tue, 6 Jul 2021 16:22:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <5f87f0b888555b52041a0fe32280adee0d563e63.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:05, isaku.yamahata@intel.com wrote:
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> Introduce a per-vm variable initial_tsc_khz to hold the default tsc_khz
> for kvm_arch_vcpu_create().
> 
> This field is going to be used by TDX since TSC frequency for TD guest
> is configured at TD VM initialization phase.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 1 +
>   arch/x86/kvm/x86.c              | 3 ++-
>   2 files changed, 3 insertions(+), 1 deletion(-)

So this means disabling TSC frequency scaling on TDX.  Would it make 
sense to delay VM creation to a separate ioctl, similar to 
KVM_ARM_VCPU_FINALIZE (KVM_VM_FINALIZE)?

Paolo

> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index a47e17892258..ae8b96e15e71 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1030,6 +1030,7 @@ struct kvm_arch {
>   	u64 last_tsc_nsec;
>   	u64 last_tsc_write;
>   	u32 last_tsc_khz;
> +	u32 initial_tsc_khz;
>   	u64 cur_tsc_nsec;
>   	u64 cur_tsc_write;
>   	u64 cur_tsc_offset;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a8299add443f..d3ebed784eac 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10441,7 +10441,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>   	else
>   		vcpu->arch.mp_state = KVM_MP_STATE_UNINITIALIZED;
>   
> -	kvm_set_tsc_khz(vcpu, max_tsc_khz);
> +	kvm_set_tsc_khz(vcpu, vcpu->kvm->arch.initial_tsc_khz);
>   
>   	r = kvm_mmu_create(vcpu);
>   	if (r < 0)
> @@ -10894,6 +10894,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	pvclock_update_vm_gtod_copy(kvm);
>   
>   	kvm->arch.guest_can_read_msr_platform_info = true;
> +	kvm->arch.initial_tsc_khz = max_tsc_khz;
>   
>   	INIT_DELAYED_WORK(&kvm->arch.kvmclock_update_work, kvmclock_update_fn);
>   	INIT_DELAYED_WORK(&kvm->arch.kvmclock_sync_work, kvmclock_sync_fn);
> 

