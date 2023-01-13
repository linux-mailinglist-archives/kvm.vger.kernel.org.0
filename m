Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2596D66972F
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 13:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241343AbjAMMeW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 07:34:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241359AbjAMMc2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 07:32:28 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F096DF7;
        Fri, 13 Jan 2023 04:32:02 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id bf43so32930903lfb.6;
        Fri, 13 Jan 2023 04:32:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XOgXDU+sHcMgYO1LMEdMpweA+Tux0A7aMScAVKQhHEU=;
        b=o66J6PJSMzM+tgK7YfNlpO5IrrEsq25AeqvE/gU2AT5KCaDQJ1vyhuRAT6qb3wbc1K
         aClBa6ISvdn5+xKYEK5rjmHt4UF6yIIFDm9V6tdDlFy3DmN1Ng6PllOS6BI3ADdEOUxt
         ItpUAmN364gAB5gOqw5tfLvF7XYYglkLgOmu2r+9GgFbJSNIsHyC2m4s5KWFoOyC504u
         q8CV2hdJb2pi5eb/yBfmilhzFedO7/jXk8IQZXueLOf48MdH51YnRL7PGF80/mJJ2746
         OUdytYpJubB93XsAj1gYlt7JQFGwUXvacg2ikR+4vSv4LmCbSnNGrpzy2dwl2CWA4IkE
         N6fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XOgXDU+sHcMgYO1LMEdMpweA+Tux0A7aMScAVKQhHEU=;
        b=boYqV8Xse+hfI8ANNfg/V7Tk7o2opdHLkyRlFkGFxgbiJUb+nWY0iohwy1Tn8m7n9t
         x4YVoPXdwE7uQEjCYcE0K1/BkOZr4b+d4nJJZ9YrYQstoiaoxwgn/KwM2ZqupjRSx+oQ
         2jb880a6wo5T/zrAsRR4dw3wXizmYULKmGYpQtJYI9igD5qTJ8I4ollvZcXAgP7auPjk
         OqFC0JRlsMKmwiun7ns/NIhoCvln6oMDStxxtHITggKK62keJV0IBqAN5cIpzITMNtq3
         eRXJG48JHK426D6lSytjxVcoE88smQ8sbEM4eEjKtD6qxzCGyy/9bQASxOD3dktb5SUs
         ARzA==
X-Gm-Message-State: AFqh2kobWcWlkzmIf0DRROhuBPjloif792ZNYmxCv/e1ReIMYjkjhK8K
        1jv5s9M8SHOfwXwinvZRHVg=
X-Google-Smtp-Source: AMrXdXsuzBsv1KzpxBcNlAM2+V7RGH6XhifqV6BwmXVacZhUnICO6vz0bs9BupERItG8lhmqQii78g==
X-Received: by 2002:a19:5517:0:b0:4b5:a7c7:9dc4 with SMTP id n23-20020a195517000000b004b5a7c79dc4mr5068279lfe.3.1673613120892;
        Fri, 13 Jan 2023 04:32:00 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id p36-20020a05651213a400b00492b494c4e8sm3818467lfa.298.2023.01.13.04.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 04:32:00 -0800 (PST)
Date:   Fri, 13 Jan 2023 14:31:58 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v11 004/113] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Message-ID: <20230113143158.00006ca5@gmail.com>
In-Reply-To: <60c842f347eaecdd0673bdc63acd95b82eeeda9c.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
        <60c842f347eaecdd0673bdc63acd95b82eeeda9c.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Jan 2023 08:31:12 -0800
isaku.yamahata@intel.com wrote:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> TDX requires several initialization steps for KVM to create guest TDs.
> Detect CPU feature, enable VMX (TDX is based on VMX), detect the TDX
> module availability, and initialize it.  This patch implements those
> steps.
> 
> There are several options on when to initialize the TDX module.  A.)
> kernel module loading time, B.) the first guest TD creation time.  A.)
> was chosen. With B.), a user may hit an error of the TDX initialization
> when trying to create the first guest TD.  The machine that fails to
> initialize the TDX module can't boot any guest TD further.  Such failure
> is undesirable and a surprise because the user expects that the machine
> can accommodate guest TD, but actually not.  So A.) is better than B.).
> 
> Introduce a module parameter, enable_tdx, to explicitly enable TDX KVM
> support.  It's off by default to keep same behavior for those who don't
> use TDX.  Implement hardware_setup method to detect TDX feature of CPU.
> Because TDX requires all present CPUs to enable VMX (VMXON).  The x86
> specific kvm_arch_post_hardware_enable_setup overrides the existing weak
> symbol of kvm_arch_post_hardware_enable_setup which is called at the KVM
> module initialization.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/Makefile      |  1 +
>  arch/x86/kvm/vmx/main.c    | 33 +++++++++++++++++++++++-----
>  arch/x86/kvm/vmx/tdx.c     | 44 ++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/vmx.c     | 39 +++++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/x86_ops.h | 10 +++++++++
>  5 files changed, 122 insertions(+), 5 deletions(-)
>  create mode 100644 arch/x86/kvm/vmx/tdx.c
> 
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index 0e894ae23cbc..4b01ab842ab7 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -25,6 +25,7 @@ kvm-$(CONFIG_KVM_SMM)	+= smm.o
>  kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o
> vmx/vmcs12.o \ vmx/hyperv.o vmx/nested.o vmx/posted_intr.o vmx/main.o
>  kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
> +kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx.o
>  
>  kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o
> svm/nested.o svm/avic.o \ svm/sev.o svm/hyperv.o
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 18f659d1d456..f5d1166d2718 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -7,6 +7,22 @@
>  #include "pmu.h"
>  #include "tdx.h"
>  
> +static bool enable_tdx __ro_after_init =
> IS_ENABLED(CONFIG_INTEL_TDX_HOST); +module_param_named(tdx, enable_tdx,
> bool, 0444); +

The comments says "TDX is off by default". It seems default on/off is controlled
by the kernel configuration here.

> +static __init int vt_hardware_setup(void)
> +{
> +	int ret;
> +
> +	ret = vmx_hardware_setup();
> +	if (ret)
> +		return ret;
> +
> +	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
> +
> +	return 0;
> +}
> +
>  struct kvm_x86_ops vt_x86_ops __initdata = {
>  	.name = KBUILD_MODNAME,
>  
> @@ -149,7 +165,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>  };
>  
>  struct kvm_x86_init_ops vt_init_ops __initdata = {
> -	.hardware_setup = vmx_hardware_setup,
> +	.hardware_setup = vt_hardware_setup,
>  	.handle_intel_pt_intr = NULL,
>  
>  	.runtime_ops = &vt_x86_ops,
> @@ -182,10 +198,17 @@ static int __init vt_init(void)
>  	 * Common KVM initialization _must_ come last, after this,
> /dev/kvm is
>  	 * exposed to userspace!
>  	 */
> -	vt_x86_ops.vm_size = max(sizeof(struct kvm_vmx), sizeof(struct
> kvm_tdx));
> -	vcpu_size = max(sizeof(struct vcpu_vmx), sizeof(struct
> vcpu_tdx));
> -	vcpu_align = max(__alignof__(struct vcpu_vmx),
> -			 __alignof__(struct vcpu_tdx));
> +	vt_x86_ops.vm_size = sizeof(struct kvm_vmx);
> +	vcpu_size = sizeof(struct vcpu_vmx);
> +	vcpu_align = __alignof__(struct vcpu_vmx);
> +	if (enable_tdx) {
> +		vt_x86_ops.vm_size = max_t(unsigned int,
> vt_x86_ops.vm_size,
> +					   sizeof(struct kvm_tdx));
> +		vcpu_size = max_t(unsigned int, vcpu_size,
> +				  sizeof(struct vcpu_tdx));
> +		vcpu_align = max_t(unsigned int, vcpu_align,
> +				   __alignof__(struct vcpu_tdx));
> +	}
>  	r = kvm_init(vcpu_size, vcpu_align, THIS_MODULE);
>  	if (r)
>  		goto err_kvm_init;
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> new file mode 100644
> index 000000000000..d7a276118940
> --- /dev/null
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -0,0 +1,44 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/cpu.h>
> +
> +#include <asm/tdx.h>
> +
> +#include "capabilities.h"
> +#include "x86_ops.h"
> +#include "tdx.h"
> +#include "x86.h"
> +
> +#undef pr_fmt
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +static int __init tdx_module_setup(void)
> +{
> +	int ret;
> +

Better mention the tdx_enable() is implemented in another patch? But I guess
we need a wrapper here so that the compilation would succeed.

> +	ret = tdx_enable();
> +	if (ret) {
> +		pr_info("Failed to initialize TDX module.\n");
> +		return ret;
> +	}
> +
> +	pr_info("TDX is supported.\n");
> +	return 0;
> +}
> +
> +int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
> +{
> +	int r;
> +
> +	if (!enable_ept) {
> +		pr_warn("Cannot enable TDX with EPT disabled\n");
> +		return -EINVAL;
> +	}
> +
> +	/* TDX requires VMX. */
> +	r = vmxon_all();
> +	if (!r)
> +		r = tdx_module_setup();
> +	vmxoff_all();
> +
> +	return r;
> +}
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 5de1792c9902..5dc7687dcf16 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8147,6 +8147,45 @@ static unsigned int vmx_handle_intel_pt_intr(void)
>  	return 1;
>  }
>  
> +static __init void vmxon(void *arg)
> +{
> +	int cpu = raw_smp_processor_id();
> +	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
> +	atomic_t *failed = arg;
> +	int r;
> +
> +	if (cr4_read_shadow() & X86_CR4_VMXE) {
> +		r = -EBUSY;
> +		goto out;
> +	}
> +
> +	r = kvm_cpu_vmxon(phys_addr);
> +out:
> +	if (r)
> +		atomic_inc(failed);
> +}
> +
> +__init int vmxon_all(void)
> +{
> +	atomic_t failed = ATOMIC_INIT(0);
> +
> +	on_each_cpu(vmxon, &failed, 1);
> +
> +	if (atomic_read(&failed))
> +		return -EBUSY;
> +	return 0;
> +}
> +
> +static __init void vmxoff(void *junk)
> +{
> +	cpu_vmxoff();
> +}
> +
> +__init void vmxoff_all(void)
> +{
> +	on_each_cpu(vmxoff, NULL, 1);
> +}
> +
>  static __init void vmx_setup_user_return_msrs(void)
>  {
>  
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 051b5c4b5c2f..fbc57fcbdd21 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -20,6 +20,10 @@ bool kvm_is_vmx_supported(void);
>  int __init vmx_init(void);
>  void vmx_exit(void);
>  
> +__init int vmxon_all(void);
> +__init void vmxoff_all(void);
> +__init int vmx_hardware_setup(void);
> +
>  extern struct kvm_x86_ops vt_x86_ops __initdata;
>  extern struct kvm_x86_init_ops vt_init_ops __initdata;
>  
> @@ -133,4 +137,10 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
>  #endif
>  void vmx_setup_mce(struct kvm_vcpu *vcpu);
>  
> +#ifdef CONFIG_INTEL_TDX_HOST
> +int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
> +#else
> +static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) {
> return 0; } +#endif
> +
>  #endif /* __KVM_X86_VMX_X86_OPS_H */

