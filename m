Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFCC44D7591
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 14:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbiCMNz2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 09:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiCMNz1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 09:55:27 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863F731207;
        Sun, 13 Mar 2022 06:54:18 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id bg31-20020a05600c3c9f00b00381590dbb33so8065330wmb.3;
        Sun, 13 Mar 2022 06:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=znNe9soEQ7eI1KS+sUMdfzuE9wnqU0OeB5IQG7hvRYY=;
        b=qZf1UPVJvCajwApb7Ocv1qNi0lSmWZGZrLOUr96XeDzjHrWkOhpqiesPTR/U6xgEJt
         dnEjkEiGlno7K5Ivx4D+oVO0ZaIIsSFaGyT6LqKMnSK7hodGvg6XY46Sxq2piV7g7ORa
         yicRAbSqBhyrjEYd+6BogaO73gMaIP2hoSv6sOvm/Uao6K1vtBd2298Cz5yFLEV4T8VS
         2dZFYpEGl0Ssei/RHa+9o/emU224trfMdAwwgsFCF7hr3Tp2JNvDIo0OhlvajGZ1CDKZ
         6ykJ5sW8A9HnBulpU/crQu6bSs9liOCDBWJmMI1Vye8Qpyrfp+hqroWwR1zqP63ww95S
         FR/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=znNe9soEQ7eI1KS+sUMdfzuE9wnqU0OeB5IQG7hvRYY=;
        b=xCVXGr8BAesvVDHaHlZg4gX2i1/1niNzqdo6easSinexb1O8Gr0KcOni1GkYp/Vdfx
         BUR396FJoklFvpaGO5eL93aRh+/EHDZLFM+B/7CdEt+bXIoICop4DnBmpNMzgErmnMir
         Q8GuXXLmn9CBaImItSKvUtk54dWnVlzI9BYzIsSlQoyZ/DQygDK++H77XfTNIVv4iTNm
         Agdp7dTIihIeNVyUUGud8LyX53uVhOw/5g+i67gaOkVKa6MvyJb0wiIHCql9+cNicomz
         xB9/WnWPH/e34X9UlmzTRKPKfc5R1taTwVRJGpWd9rpwg+7EbMxkye+yn+fp5lvMkESk
         tIDA==
X-Gm-Message-State: AOAM532gM9/kPx/9Pomk6xTZNWtQOhzMvMx9JBy1APSOoiWuhAX5djZL
        Tg8b5aX4Cz97MJ1DssMSV5kgVfoIS/E=
X-Google-Smtp-Source: ABdhPJwllde4zOH9NjS1TpyaoWRnorYljK4DhKcNw5rz/FlWGIMjMdKeaTwoIflxWxDuO4IjiHmCWA==
X-Received: by 2002:a1c:7c06:0:b0:389:7fd0:f6ec with SMTP id x6-20020a1c7c06000000b003897fd0f6ecmr22019640wmc.44.1647179656967;
        Sun, 13 Mar 2022 06:54:16 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id p16-20020adff210000000b001f062b80091sm10788010wro.34.2022.03.13.06.54.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Mar 2022 06:54:16 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <d1c7ee86-8093-d04f-747d-aabbc1452801@redhat.com>
Date:   Sun, 13 Mar 2022 14:54:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH v5 005/104] KVM: x86: Refactor KVM VMX module
 init/exit functions
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <8a8ec76f1700114d739623b2860630eacd277ab6.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <8a8ec76f1700114d739623b2860630eacd277ab6.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Currently, KVM VMX module initialization/exit functions are a single
> function each.  Refactor KVM VMX module initialization functions into KVM
> common part and VMX part so that TDX specific part can be added cleanly.
> Opportunistically refactor module exit function as well.
> 
> The current module initialization flow is, 1.) calculate the sizes of VMX
> kvm structure and VMX vcpu structure, 2.) report those sizes to the KVM
> common layer and KVM common initialization, and 3.) VMX specific
> system-wide initialization.
> 
> Refactor the KVM VMX module initialization function into functions with a
> wrapper function to separate VMX logic in vmx.c from a file, main.c, common
> among VMX and TDX.  We have a wrapper function,
> "vt_init() {vmx_pre_kvm_init(); kvm_init(); vmx_init(); }" in main.c, and
> vmx_pre_kvm_init() and vmx_init() in vmx.c.  vmx_pre_kvm_init() calculates
> the sizes of VMX kvm structure and KVM vcpu structure, kvm_init() does
> system-wide initialization of the KVM common layer, and vmx_init() does
> system-wide VMX initialization.
> 
> The KVM architecture common layer allocates struct kvm with reported size
> for architecture-specific code.  The KVM VMX module defines its structure
> as struct vmx_kvm { struct kvm; VMX specific members;} and uses it as
> struct vmx kvm.  Similar for vcpu structure. TDX KVM patches will define
> TDX specific kvm and vcpu structures, add tdx_pre_kvm_init() to report the
> sizes of them to the KVM common layer.
> 
> The current module exit function is also a single function, a combination
> of VMX specific logic and common KVM logic.  Refactor it into VMX specific
> logic and KVM common logic.  This is just refactoring to keep the VMX
> specific logic in vmx.c from main.c.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/main.c    | 33 +++++++++++++
>   arch/x86/kvm/vmx/vmx.c     | 97 +++++++++++++++++++-------------------
>   arch/x86/kvm/vmx/x86_ops.h |  5 +-
>   3 files changed, 86 insertions(+), 49 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index b79fcc8d81dd..8ff13c7881f2 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -165,3 +165,36 @@ struct kvm_x86_init_ops vt_init_ops __initdata = {
>   
>   	.runtime_ops = &vt_x86_ops,
>   };
> +
> +static int __init vt_init(void)
> +{
> +	unsigned int vcpu_size = 0, vcpu_align = 0;
> +	int r;
> +
> +	vmx_pre_kvm_init(&vcpu_size, &vcpu_align);
> +
> +	r = kvm_init(&vt_init_ops, vcpu_size, vcpu_align, THIS_MODULE);
> +	if (r)
> +		goto err_vmx_post_exit;
> +
> +	r = vmx_init();
> +	if (r)
> +		goto err_kvm_exit;
> +
> +	return 0;
> +
> +err_kvm_exit:
> +	kvm_exit();
> +err_vmx_post_exit:
> +	vmx_post_kvm_exit();
> +	return r;
> +}
> +module_init(vt_init);
> +
> +static void vt_exit(void)
> +{
> +	vmx_exit();
> +	kvm_exit();
> +	vmx_post_kvm_exit();
> +}
> +module_exit(vt_exit);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index f6f5d0dac579..7838cd177f0e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7929,47 +7929,12 @@ static void vmx_cleanup_l1d_flush(void)
>   	l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_AUTO;
>   }
>   
> -static void vmx_exit(void)
> +void __init vmx_pre_kvm_init(unsigned int *vcpu_size, unsigned int *vcpu_align)
>   {
> -#ifdef CONFIG_KEXEC_CORE
> -	RCU_INIT_POINTER(crash_vmclear_loaded_vmcss, NULL);
> -	synchronize_rcu();
> -#endif
> -
> -	kvm_exit();
> -
> -#if IS_ENABLED(CONFIG_HYPERV)
> -	if (static_branch_unlikely(&enable_evmcs)) {
> -		int cpu;
> -		struct hv_vp_assist_page *vp_ap;
> -		/*
> -		 * Reset everything to support using non-enlightened VMCS
> -		 * access later (e.g. when we reload the module with
> -		 * enlightened_vmcs=0)
> -		 */
> -		for_each_online_cpu(cpu) {
> -			vp_ap =	hv_get_vp_assist_page(cpu);
> -
> -			if (!vp_ap)
> -				continue;
> -
> -			vp_ap->nested_control.features.directhypercall = 0;
> -			vp_ap->current_nested_vmcs = 0;
> -			vp_ap->enlighten_vmentry = 0;
> -		}
> -
> -		static_branch_disable(&enable_evmcs);
> -	}
> -#endif
> -	vmx_cleanup_l1d_flush();
> -
> -	allow_smaller_maxphyaddr = false;
> -}
> -module_exit(vmx_exit);
> -
> -static int __init vmx_init(void)
> -{
> -	int r, cpu;
> +	if (sizeof(struct vcpu_vmx) > *vcpu_size)
> +		*vcpu_size = sizeof(struct vcpu_vmx);
> +	if (__alignof__(struct vcpu_vmx) > *vcpu_align)
> +		*vcpu_align = __alignof__(struct vcpu_vmx);

Please keep these four lines in vt_init, and rename the rest of 
vmx_pre_kvm_init to hv_vp_assist_page_init.  Likewise, rename 
vmx_post_kvm_exit to hv_vp_assist_page_exit.

Adjusting the vcpu_size and vcpu_align for TDX (I guess) can be added 
later when TDX ops are introduced.

Paolo

>   
>   #if IS_ENABLED(CONFIG_HYPERV)
>   	/*
> @@ -8004,11 +7969,38 @@ static int __init vmx_init(void)
>   		enlightened_vmcs = false;
>   	}
>   #endif
> +}
>   
> -	r = kvm_init(&vt_init_ops, sizeof(struct vcpu_vmx),
> -		__alignof__(struct vcpu_vmx), THIS_MODULE);
> -	if (r)
> -		return r;
> +void vmx_post_kvm_exit(void)
> +{
> +#if IS_ENABLED(CONFIG_HYPERV)
> +	if (static_branch_unlikely(&enable_evmcs)) {
> +		int cpu;
> +		struct hv_vp_assist_page *vp_ap;
> +		/*
> +		 * Reset everything to support using non-enlightened VMCS
> +		 * access later (e.g. when we reload the module with
> +		 * enlightened_vmcs=0)
> +		 */
> +		for_each_online_cpu(cpu) {
> +			vp_ap =	hv_get_vp_assist_page(cpu);
> +
> +			if (!vp_ap)
> +				continue;
> +
> +			vp_ap->nested_control.features.directhypercall = 0;
> +			vp_ap->current_nested_vmcs = 0;
> +			vp_ap->enlighten_vmentry = 0;
> +		}
> +
> +		static_branch_disable(&enable_evmcs);
> +	}
> +#endif
> +}
> +
> +int __init vmx_init(void)
> +{
> +	int r, cpu;
>   
>   	/*
>   	 * Must be called after kvm_init() so enable_ept is properly set
> @@ -8018,10 +8010,8 @@ static int __init vmx_init(void)
>   	 * mitigation mode.
>   	 */
>   	r = vmx_setup_l1d_flush(vmentry_l1d_flush_param);
> -	if (r) {
> -		vmx_exit();
> +	if (r)
>   		return r;
> -	}
>   
>   	for_each_possible_cpu(cpu) {
>   		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
> @@ -8045,4 +8035,15 @@ static int __init vmx_init(void)
>   
>   	return 0;
>   }
> -module_init(vmx_init);
> +
> +void vmx_exit(void)
> +{
> +#ifdef CONFIG_KEXEC_CORE
> +	RCU_INIT_POINTER(crash_vmclear_loaded_vmcss, NULL);
> +	synchronize_rcu();
> +#endif
> +
> +	vmx_cleanup_l1d_flush();
> +
> +	allow_smaller_maxphyaddr = false;
> +}
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index ccf98e79d8c3..7da541e1c468 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -8,7 +8,10 @@
>   
>   #include "x86.h"
>   
> -extern struct kvm_x86_init_ops vt_init_ops __initdata;
> +void __init vmx_pre_kvm_init(unsigned int *vcpu_size, unsigned int *vcpu_align);
> +int __init vmx_init(void);
> +void vmx_exit(void);
> +void vmx_post_kvm_exit(void);
>   
>   __init int vmx_cpu_has_kvm_support(void);
>   __init int vmx_disabled_by_bios(void);

