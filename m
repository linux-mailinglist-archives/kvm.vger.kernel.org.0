Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 087D13BD874
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 16:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbhGFOmC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 10:42:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28976 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232538AbhGFOmB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 10:42:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625582362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FVD9TqsR7wtGDSSt+t/Z7VBCz1UEwKOtSU1PtxApYio=;
        b=K/vbmkpDwm/BalC7v5xzYLGF7v+TkdhoQOX6mjkTwwCHe6iX/5Sm5M3FvaJsGDmECpAWJS
        F7YWELq6c7qvGkAPfrR1W1Od5Vtqw+lc5DzhgjRgQOP1iXJEhK+MUGJ5z2Q0tIOJAuGdVH
        iHK9NJlUe3h3RA9HYglhKXKS5raSSmI=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-m7YR8WQZMh2MdFGqdNUB-w-1; Tue, 06 Jul 2021 09:49:10 -0400
X-MC-Unique: m7YR8WQZMh2MdFGqdNUB-w-1
Received: by mail-ej1-f70.google.com with SMTP id hy7-20020a1709068a67b02904cdf8737a75so5006234ejc.9
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 06:49:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FVD9TqsR7wtGDSSt+t/Z7VBCz1UEwKOtSU1PtxApYio=;
        b=qqR9+hRqXIjy2ltqZSc6q7iyC1j5CyxJ7UwkwM0QyNI/HTObhwBRTyVQa/wds7OlH+
         vFC6tLe1u8jki9SO8e4HKnMPNkwqdIx2ocAbfbqmz71eU+xiX9dlLqmf6Iasr0VhQM4r
         ev5n2evHl3BprNKEVV16ln09QQuuewjIAm7kB6WJP6FSLkjnIoz/dquOGNaYwZt9ICtr
         IHzb5Z/UjM0YrM75p0gDHcKFuHqCX6qA1R69fOlgnNRi0WASMnpREgVLmiiv/HgYM7iQ
         5mpHBjpf9kM1V9jAYj0ljvjLB4AQCQIcHcFNMFD/ArSj4yMZTd3mq9IcWp41yAqB+4Tl
         avCQ==
X-Gm-Message-State: AOAM533qWlOnFNcZ7/yDBDmk5WzFIFpG+pFZGXcgUYZzCcK1blKtaco+
        ujxvVYCObqKsdZigyaNQWYvehCMdreWuzrOKU7SYeA63xj+Vn5aJM7er+aO7+t/Wn+GwrRMofpx
        pArfdWZi+UepI
X-Received: by 2002:aa7:c352:: with SMTP id j18mr23030787edr.67.1625579349198;
        Tue, 06 Jul 2021 06:49:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxVIRP6ue1K57TsRTQJSKe9wx0COm06+wt55p48m0rGCp8nMOwTch6OatisHhgPcK2HEdUxjQ==
X-Received: by 2002:aa7:c352:: with SMTP id j18mr23030760edr.67.1625579349029;
        Tue, 06 Jul 2021 06:49:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id ak16sm4357263ejc.17.2021.07.06.06.49.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 06:49:08 -0700 (PDT)
Subject: Re: [RFC PATCH v2 21/69] KVM: Add max_vcpus field in common 'struct
 kvm'
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
Cc:     isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <bf7685a4665a4f70259b0cd5f7d11a162753278c.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b6323953-1766-ff6a-2b3c-428606144e5f@redhat.com>
Date:   Tue, 6 Jul 2021 15:49:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <bf7685a4665a4f70259b0cd5f7d11a162753278c.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please replace "Add" with "Move" and add a couple lines to the commit 
message.

Paolo

On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/arm64/include/asm/kvm_host.h | 3 ---
>   arch/arm64/kvm/arm.c              | 7 ++-----
>   arch/arm64/kvm/vgic/vgic-init.c   | 6 +++---
>   include/linux/kvm_host.h          | 1 +
>   virt/kvm/kvm_main.c               | 3 ++-
>   5 files changed, 8 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 7cd7d5c8c4bc..96a0dc3a8780 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -106,9 +106,6 @@ struct kvm_arch {
>   	/* VTCR_EL2 value for this VM */
>   	u64    vtcr;
>   
> -	/* The maximum number of vCPUs depends on the used GIC model */
> -	int max_vcpus;
> -
>   	/* Interrupt controller */
>   	struct vgic_dist	vgic;
>   
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index e720148232a0..a46306cf3106 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -145,7 +145,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	kvm_vgic_early_init(kvm);
>   
>   	/* The maximum number of VCPUs is limited by the host's GIC model */
> -	kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
> +	kvm->max_vcpus = kvm_arm_default_max_vcpus();
>   
>   	set_default_spectre(kvm);
>   
> @@ -220,7 +220,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_MAX_VCPUS:
>   	case KVM_CAP_MAX_VCPU_ID:
>   		if (kvm)
> -			r = kvm->arch.max_vcpus;
> +			r = kvm->max_vcpus;
>   		else
>   			r = kvm_arm_default_max_vcpus();
>   		break;
> @@ -299,9 +299,6 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
>   	if (irqchip_in_kernel(kvm) && vgic_initialized(kvm))
>   		return -EBUSY;
>   
> -	if (id >= kvm->arch.max_vcpus)
> -		return -EINVAL;
> -
>   	return 0;
>   }
>   
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index 58cbda00e56d..089ac00c55d7 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -97,11 +97,11 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
>   	ret = 0;
>   
>   	if (type == KVM_DEV_TYPE_ARM_VGIC_V2)
> -		kvm->arch.max_vcpus = VGIC_V2_MAX_CPUS;
> +		kvm->max_vcpus = VGIC_V2_MAX_CPUS;
>   	else
> -		kvm->arch.max_vcpus = VGIC_V3_MAX_CPUS;
> +		kvm->max_vcpus = VGIC_V3_MAX_CPUS;
>   
> -	if (atomic_read(&kvm->online_vcpus) > kvm->arch.max_vcpus) {
> +	if (atomic_read(&kvm->online_vcpus) > kvm->max_vcpus) {
>   		ret = -E2BIG;
>   		goto out_unlock;
>   	}
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index e87f07c5c601..ddd4d0f68cdf 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -544,6 +544,7 @@ struct kvm {
>   	 * and is accessed atomically.
>   	 */
>   	atomic_t online_vcpus;
> +	int max_vcpus;
>   	int created_vcpus;
>   	int last_boosted_vcpu;
>   	struct list_head vm_list;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index dc752d0bd3ec..52d40ea75749 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -910,6 +910,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
>   	mutex_init(&kvm->irq_lock);
>   	mutex_init(&kvm->slots_lock);
>   	INIT_LIST_HEAD(&kvm->devices);
> +	kvm->max_vcpus = KVM_MAX_VCPUS;
>   
>   	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
>   
> @@ -3329,7 +3330,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>   		return -EINVAL;
>   
>   	mutex_lock(&kvm->lock);
> -	if (kvm->created_vcpus == KVM_MAX_VCPUS) {
> +	if (kvm->created_vcpus >= kvm->max_vcpus) {
>   		mutex_unlock(&kvm->lock);
>   		return -EINVAL;
>   	}
> 

