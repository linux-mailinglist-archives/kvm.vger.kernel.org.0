Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 043E84D758E
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 14:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233146AbiCMNvD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 09:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbiCMNvC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 09:51:02 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C166A2AE21;
        Sun, 13 Mar 2022 06:49:54 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id x15so19929025wru.13;
        Sun, 13 Mar 2022 06:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CM1/T75OeguTn9Im0a19n4bUzrsz5fbtlfPZIU/oauA=;
        b=Ym9Una/i8xZRZI8yIlTbX2l5nR+Mt3PhERrZGtBsd4vQx8oIb3dftS4KWi2sEfuo0j
         ipRrnfut8n4SR/9Esx3EwTB3qFdNBPJgxpjJsENfm+0E4cNc934u9Exk23dCE0A1EUzP
         y9XOzXkvjaKb93Tb0M6ni4x5Iun91gHgvC7EwwHSUOPqgQqdrXH+G4EtSCoQkrRghsGV
         xBdFcTYOz/ACZhV1ZRJzKBMCaGIPPDBxuNEOBsnrDCfyS68PE+vaAcrUqmgLvhQiPVF2
         uUzaGWuXQkCHgMkP3a0ysY1YEVCs1DtBF1YEPDW2+kRIgPIJJJdV5kZbct66MVSduJdt
         2xHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CM1/T75OeguTn9Im0a19n4bUzrsz5fbtlfPZIU/oauA=;
        b=D076tnQz4T45swdx8HXtQgADpnJxfiRnu7F/85fFF+8gbpaFyxCTcw3hWUGEfKkZJ+
         ybKK1h15ltdnirfjMWeLW/vq9I0AoIgDSRA+YvsOoSiX60Mnwh6QYeFQvzohVMKWTcw0
         n2zxoRGOiZb16m5b5XeiZKo3GO9ONgu9OKIFFAAoBNtklDpRuFdnIKJRaIN/q200xFo+
         3pGYuKTH+++NSa7VAcJ6i3irxQaBAkhMlm3vSAjbr7UJSKU1lFwXKa8TQVaRWVwFK/Fs
         zFIsFVNKn/8sCT60xvRXdtEwF4yCFAhQtvWpCiXfh0yt/E9D5x7PdWs7FCyrzDO1Zgtp
         T+2g==
X-Gm-Message-State: AOAM533GoLLKCiKeEPQEznmwBufmK1YExX3jxfxKai5opp5r2CMIMNti
        SGOwn0TX0uJI5VKvwlP17OM=
X-Google-Smtp-Source: ABdhPJzEn6m0e9x8SW3fedz63/jKcN+JtZjlqaERuKd0vKgdUXiVzuhvPV4e/jGKyOy/6xx3O5c38Q==
X-Received: by 2002:adf:fa45:0:b0:203:954d:d5e3 with SMTP id y5-20020adffa45000000b00203954dd5e3mr8516135wrr.533.1647179393288;
        Sun, 13 Mar 2022 06:49:53 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id u25-20020a05600c211900b00389d4bdb3d2sm17855561wml.36.2022.03.13.06.49.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Mar 2022 06:49:52 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <3443ca75-0b64-1b6b-1d1d-1cbca34d14cb@redhat.com>
Date:   Sun, 13 Mar 2022 14:49:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH v5 003/104] KVM: TDX: Detect CPU feature on kernel
 module initialization
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <70201fd686c6cc6e03f5af8a9f59af67bdc81194.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <70201fd686c6cc6e03f5af8a9f59af67bdc81194.1646422845.git.isaku.yamahata@intel.com>
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
> TDX requires several initialization steps for KVM to create guest TDs.
> Detect CPU feature, enable VMX (TDX is based on VMX), detect TDX module
> availability, and initialize TDX module.  This patch implements the first
> step to detect CPU feature.  Because VMX isn't enabled yet by VMXON
> instruction on KVM kernel module initialization, defer further
> initialization step until VMX is enabled by hardware_enable callback.
> 
> Introduce a module parameter, enable_tdx, to explicitly enable TDX KVM
> support.  It's off by default to keep same behavior for those who don't use
> TDX.  Implement CPU feature detection at KVM kernel module initialization
> as hardware_setup callback to check if CPU feature is available and get
> some CPU parameters.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/Makefile      |  1 +
>   arch/x86/kvm/vmx/main.c    | 15 ++++++++++-
>   arch/x86/kvm/vmx/tdx.c     | 53 ++++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/x86_ops.h |  6 +++++
>   4 files changed, 74 insertions(+), 1 deletion(-)
>   create mode 100644 arch/x86/kvm/vmx/tdx.c
> 
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index ee4d0999f20f..e2c05195cb95 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -24,6 +24,7 @@ kvm-$(CONFIG_KVM_XEN)	+= xen.o
>   kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
>   			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o vmx/main.o
>   kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
> +kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx.o
>   
>   kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o svm/sev.o
>   
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index b08ea9c42a11..b79fcc8d81dd 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -6,6 +6,19 @@
>   #include "nested.h"
>   #include "pmu.h"
>   
> +static __init int vt_hardware_setup(void)
> +{
> +	int ret;
> +
> +	ret = vmx_hardware_setup();
> +	if (ret)
> +		return ret;
> +
> +	tdx_hardware_setup(&vt_x86_ops);
> +
> +	return 0;
> +}
> +
>   struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.name = "kvm_intel",
>   
> @@ -147,7 +160,7 @@ struct kvm_x86_init_ops vt_init_ops __initdata = {
>   	.cpu_has_kvm_support = vmx_cpu_has_kvm_support,
>   	.disabled_by_bios = vmx_disabled_by_bios,
>   	.check_processor_compatibility = vmx_check_processor_compat,
> -	.hardware_setup = vmx_hardware_setup,
> +	.hardware_setup = vt_hardware_setup,
>   	.handle_intel_pt_intr = NULL,
>   
>   	.runtime_ops = &vt_x86_ops,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> new file mode 100644
> index 000000000000..1acf08c310c4
> --- /dev/null
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -0,0 +1,53 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/cpu.h>
> +
> +#include <asm/tdx.h>
> +
> +#include "capabilities.h"
> +#include "x86_ops.h"
> +
> +#undef pr_fmt
> +#define pr_fmt(fmt) "tdx: " fmt
> +
> +static bool __read_mostly enable_tdx = true;
> +module_param_named(tdx, enable_tdx, bool, 0644);
> +
> +static u64 hkid_mask __ro_after_init;
> +static u8 hkid_start_pos __ro_after_init;
> +
> +static int __init __tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
> +{
> +	u32 max_pa;
> +
> +	if (!enable_ept) {
> +		pr_warn("Cannot enable TDX with EPT disabled\n");
> +		return -EINVAL;
> +	}
> +
> +	if (!platform_has_tdx()) {
> +		pr_warn("Cannot enable TDX with SEAMRR disabled\n");
> +		return -ENODEV;
> +	}

This will cause a pr_warn in the logs on all machines that don't have 
TDX.  Perhaps you can restrict the pr_warn() to machines that have 
__seamrr_enabled() == true?

Paolo

> +	if (WARN_ON_ONCE(x86_ops->tlb_remote_flush))
> +		return -EIO;
> +
> +	max_pa = cpuid_eax(0x80000008) & 0xff;
> +	hkid_start_pos = boot_cpu_data.x86_phys_bits;
> +	hkid_mask = GENMASK_ULL(max_pa - 1, hkid_start_pos);
> +
> +	return 0;
> +}
> +
> +void __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
> +{
> +	/*
> +	 * This function is called at the initialization.  No need to protect
> +	 * enable_tdx.
> +	 */
> +	if (!enable_tdx)
> +		return;
> +
> +	if (__tdx_hardware_setup(&vt_x86_ops))
> +		enable_tdx = false;
> +}
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 40c64fb1f505..ccf98e79d8c3 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -123,4 +123,10 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
>   #endif
>   void vmx_setup_mce(struct kvm_vcpu *vcpu);
>   
> +#ifdef CONFIG_INTEL_TDX_HOST
> +void __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
> +#else
> +static inline void tdx_hardware_setup(struct kvm_x86_ops *x86_ops) {}
> +#endif
> +
>   #endif /* __KVM_X86_VMX_X86_OPS_H */

