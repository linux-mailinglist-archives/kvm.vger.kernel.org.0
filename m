Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5C22186EF
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 14:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgGHMIZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 08:08:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53063 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728637AbgGHMIZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 08:08:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594210103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LgCGV9UQsMIs0HezRCCnnS+bW56cFI4HntGamwUOC9k=;
        b=YFTDcKMg2VyeMoPUSgOjtUZCcLzPekha3YW/p9Elv+Ts8qGp6e7J7hDFCDFjHzN/y+cYhd
        BnR0PkmU22zTLHhLkuvoYmwBXbxQAnZmU1bQjgle7ioRD3Y2/lFozmYUEWgjb+NWv+CzHd
        Vq1N5iLCwDBdDuq6ThaLvVA6w4rfV4U=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-5oIEpht9Ph-wg9y4LZa0NQ-1; Wed, 08 Jul 2020 08:08:22 -0400
X-MC-Unique: 5oIEpht9Ph-wg9y4LZa0NQ-1
Received: by mail-wr1-f69.google.com with SMTP id b14so51944469wrp.0
        for <kvm@vger.kernel.org>; Wed, 08 Jul 2020 05:08:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LgCGV9UQsMIs0HezRCCnnS+bW56cFI4HntGamwUOC9k=;
        b=q/LsSITofPeawmC+bwWEBnxO4BCkeXCTEMm+/C1xQ8y2+nHHWDtDvquj6Qj2/22FwJ
         sYTOargV9nKQ81954JcSbGUb/Re9ukcCfTVGrDm4KekdHLkv6otXP0DwO/X/AxOUqYkb
         PpOSaGxSp7u5K87dJ1UWJvSuaNKmyHcpnIu+64I2kRFqrW3XtiRe4GSjx73+RH0yZV7M
         qVdsO73ajb/m3XGYOQ/w4PjuImx2mZdy5epoFUp9cvgUSBku/sS5lt/zTlxXsySaWqjk
         JN5UiayeYHlUUQfsRxfgJcCTWyuKVvYaKJDLdjrHcTGVEzhkP+Arxg3Sq4GFmC98IniT
         10pQ==
X-Gm-Message-State: AOAM533Zfh8KW7LIef3WJUeL/dvYMOt0oeU3fAwhiF6zcoWYzatHOQ7F
        RQVjQb5Cq8YnrFgDIAIclYx8vsRtfXh9mqAuNh/tdLHASU+j/i0WmMZKS4wBN25AcnoHQooxqJk
        9FJaOgQnHwOMI
X-Received: by 2002:a7b:c2f7:: with SMTP id e23mr8983708wmk.175.1594210100770;
        Wed, 08 Jul 2020 05:08:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx8TzlN5z0gOlf031ceUJoPlaYBeIvnWySmGs4nfTmzVvjRJvMC3luiOKvJTX8B6tbrH0d7eQ==
X-Received: by 2002:a7b:c2f7:: with SMTP id e23mr8983678wmk.175.1594210100489;
        Wed, 08 Jul 2020 05:08:20 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id e5sm5647570wrs.33.2020.07.08.05.08.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 05:08:19 -0700 (PDT)
Subject: Re: [PATCH v3 5/8] KVM: X86: Rename cpuid_update() to
 update_vcpu_model()
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20200708065054.19713-1-xiaoyao.li@intel.com>
 <20200708065054.19713-6-xiaoyao.li@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f4003675-105e-6574-fe46-50995ec69358@redhat.com>
Date:   Wed, 8 Jul 2020 14:08:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200708065054.19713-6-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/07/20 08:50, Xiaoyao Li wrote:
> The name of callback cpuid_update() is misleading that it's not about
> updating CPUID settings of vcpu but updating the configurations of vcpu
> based on the CPUIDs. So rename it to update_vcpu_model().
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>

With the change suggested in the previous patch, this one becomes
unnecessary (or you can rename it to update_cpuid).  While you're at it,
you could also move the call in kvm_update_cpuid.

Paolo

> ---
>  arch/x86/include/asm/kvm_host.h | 2 +-
>  arch/x86/kvm/cpuid.c            | 4 ++--
>  arch/x86/kvm/svm/svm.c          | 4 ++--
>  arch/x86/kvm/vmx/nested.c       | 2 +-
>  arch/x86/kvm/vmx/vmx.c          | 4 ++--
>  5 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 97cb005c7aa7..c35d14b257c9 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1051,7 +1051,7 @@ struct kvm_x86_ops {
>  	void (*hardware_unsetup)(void);
>  	bool (*cpu_has_accelerated_tpr)(void);
>  	bool (*has_emulated_msr)(u32 index);
> -	void (*cpuid_update)(struct kvm_vcpu *vcpu);
> +	void (*update_vcpu_model)(struct kvm_vcpu *vcpu);
>  
>  	unsigned int vm_size;
>  	int (*vm_init)(struct kvm *kvm);
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 001f5a94880e..d2f93823f9fd 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -224,7 +224,7 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
>  
>  	cpuid_fix_nx_cap(vcpu);
>  	kvm_apic_set_version(vcpu);
> -	kvm_x86_ops.cpuid_update(vcpu);
> +	kvm_x86_ops.update_vcpu_model(vcpu);
>  	kvm_update_cpuid(vcpu);
>  	kvm_update_vcpu_model(vcpu);
>  
> @@ -254,7 +254,7 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
>  	}
>  
>  	kvm_apic_set_version(vcpu);
> -	kvm_x86_ops.cpuid_update(vcpu);
> +	kvm_x86_ops.update_vcpu_model(vcpu);
>  	kvm_update_cpuid(vcpu);
>  	kvm_update_vcpu_model(vcpu);
>  out:
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 74096aa72ad9..01f359e590d5 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3550,7 +3550,7 @@ static u64 svm_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
>  	return 0;
>  }
>  
> -static void svm_cpuid_update(struct kvm_vcpu *vcpu)
> +static void svm_update_vcpu_model(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> @@ -4050,7 +4050,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  
>  	.get_exit_info = svm_get_exit_info,
>  
> -	.cpuid_update = svm_cpuid_update,
> +	.update_vcpu_model = svm_update_vcpu_model,
>  
>  	.has_wbinvd_exit = svm_has_wbinvd_exit,
>  
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index b627c5f36b9e..85080a5b8d3c 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -6354,7 +6354,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>  
>  	/*
>  	 * secondary cpu-based controls.  Do not include those that
> -	 * depend on CPUID bits, they are added later by vmx_cpuid_update.
> +	 * depend on CPUID bits, they are added later by vmx_update_vcpu_model.
>  	 */
>  	if (msrs->procbased_ctls_high & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS)
>  		rdmsr(MSR_IA32_VMX_PROCBASED_CTLS2,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 8187ca152ad2..4673c84b54ac 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7257,7 +7257,7 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
>  		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
>  }
>  
> -static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
> +static void vmx_update_vcpu_model(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  
> @@ -7915,7 +7915,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>  
>  	.get_exit_info = vmx_get_exit_info,
>  
> -	.cpuid_update = vmx_cpuid_update,
> +	.update_vcpu_model = vmx_update_vcpu_model,
>  
>  	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
>  
> 

