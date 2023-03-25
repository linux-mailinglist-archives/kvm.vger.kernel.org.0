Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F82A6C8FFB
	for <lists+kvm@lfdr.de>; Sat, 25 Mar 2023 19:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbjCYSNd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Mar 2023 14:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCYSNb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Mar 2023 14:13:31 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E845065AA;
        Sat, 25 Mar 2023 11:13:29 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id br6so6220393lfb.11;
        Sat, 25 Mar 2023 11:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679768008; x=1682360008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q4sgD633/XKVIu4wOHdK77j3lhKJ91hQ1ENdK+FT2gk=;
        b=GfyPczZ56tAbiEhu/2XYiBynOFykhRzjxa9/c4+sx22oiPc4Dnw21EBYRozQ5q87kr
         XZJm+gy709qnmuOmOuXWDVDs0Kquklxf0CdXUCQfyLV0JQbHTiNVxjJTf+iBVIMWMXkS
         GrOynzL1yl3yl7cQGNUD9BRv61qS6qg0WF+aP2T1WtCfa421Lr8te9pZkA4Ie/n9/RfO
         eHxZnZWKz4GT8PV07M+icTYdcLloES8zv3kJzT6gZLkKCKWovOrxyEaJbU3ZWjJV2Is5
         YcMU3llwQeFU04dMFMZC2FvGbm4uoW2VtdmT7lOzzEGuyJDbqvWUdrL+Yu56/eDlvPJ+
         WbLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679768008; x=1682360008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q4sgD633/XKVIu4wOHdK77j3lhKJ91hQ1ENdK+FT2gk=;
        b=IprwfvGUVnoXAXyJEdpE7vCuBYrRBieP+psW0JvKmrkujA0+mTrkLX9C+s/DH4iTgU
         bPiOnY772rgnAbls6i6ud4kiJQl63whSmlYQQBfNCF5/s4FRTt5fw9SdFt+7WrEJ8cgD
         o29+q433vpfiZv/k/i260aclUlLgNaEfZ0oJ8tSTJMkzJPtXcve7uApfHOE/5fp7KAYM
         LYDxVVG07DgNLGZO2ricnvR6PPxBaChz4m3dmWqtPiZCtVzsjKl5rQnaGVCn0iMyN+jr
         ms+3AS7VGgnGDHsXeDjy6EqAvdNCZNp/CDycAFSIDf3LjOAXlDyY4sgth3j6/rdx3axq
         7SmQ==
X-Gm-Message-State: AAQBX9fGJxu8u950WGU2cQHSlai0ReBuGtGrfHNa3VkMcASGlWhE+6XU
        5AoITlDOn+zGyzPEnP4yddM=
X-Google-Smtp-Source: AKy350YKmSzNz4WLA4wnX8rx7R3oR81XTUjSonTsp1IGqyV9n+TMMlC06WOCxqoIkfmTq2mp5kbAmA==
X-Received: by 2002:ac2:5989:0:b0:4dd:a025:d87 with SMTP id w9-20020ac25989000000b004dda0250d87mr1624882lfn.0.1679768007996;
        Sat, 25 Mar 2023 11:13:27 -0700 (PDT)
Received: from localhost (88-113-32-99.elisa-laajakaista.fi. [88.113.32.99])
        by smtp.gmail.com with ESMTPSA id b25-20020ac24119000000b004db266f3978sm3899743lfi.174.2023.03.25.11.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Mar 2023 11:13:27 -0700 (PDT)
Date:   Sat, 25 Mar 2023 20:13:26 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v13 018/113] KVM: x86, tdx: Make KVM_CAP_MAX_VCPUS
 backend specific
Message-ID: <20230325201326.00002d4d@gmail.com>
In-Reply-To: <87f6baf8419103077f0a42859a0a847c695f5f59.1678643052.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
        <87f6baf8419103077f0a42859a0a847c695f5f59.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 12 Mar 2023 10:55:42 -0700
isaku.yamahata@intel.com wrote:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> TDX has its own limitation on the maximum number of vcpus that the guest
> can accommodate.  Allow x86 kvm backend to implement its own KVM_ENABLE_CAP
> handler and implement TDX backend for KVM_CAP_MAX_VCPUS.  user space VMM,
> e.g. qemu, can specify its value instead of KVM_MAX_VCPUS.
> 

I think enabling the cap here is actually "configuring the cap". KVM_CAP_MAX
_VCPUS is actually always enabled whether userspace enables it or not. It
would be nice to configure of the max VCPUS in kvm_arch_vm_ioctl() where
routines of configuring a VM should belong. E.g. KVM_SET_MAX_VCPUS.

> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  2 ++
>  arch/x86/include/asm/kvm_host.h    |  2 ++
>  arch/x86/kvm/vmx/main.c            | 22 ++++++++++++++++++++++
>  arch/x86/kvm/vmx/tdx.c             | 30 ++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/tdx.h             |  3 +++
>  arch/x86/kvm/vmx/x86_ops.h         |  2 ++
>  arch/x86/kvm/x86.c                 |  4 ++++
>  7 files changed, 65 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 58fbaa05fc8c..7522c193f2b4 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -21,6 +21,8 @@ KVM_X86_OP(hardware_unsetup)
>  KVM_X86_OP(has_emulated_msr)
>  KVM_X86_OP(vcpu_after_set_cpuid)
>  KVM_X86_OP(is_vm_type_supported)
> +KVM_X86_OP_OPTIONAL(max_vcpus);
> +KVM_X86_OP_OPTIONAL(vm_enable_cap)
>  KVM_X86_OP(vm_init)
>  KVM_X86_OP_OPTIONAL(vm_destroy)
>  KVM_X86_OP_OPTIONAL_RET0(vcpu_precreate)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 49e3ca89aced..d98d61e5213d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1562,7 +1562,9 @@ struct kvm_x86_ops {
>  	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
>  
>  	bool (*is_vm_type_supported)(unsigned long vm_type);
> +	int (*max_vcpus)(struct kvm *kvm);
>  	unsigned int vm_size;
> +	int (*vm_enable_cap)(struct kvm *kvm, struct kvm_enable_cap *cap);
>  	int (*vm_init)(struct kvm *kvm);
>  	void (*vm_destroy)(struct kvm *kvm);
>  
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 8ddd263eeabc..68bb320d0b6d 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -6,6 +6,7 @@
>  #include "nested.h"
>  #include "pmu.h"
>  #include "tdx.h"
> +#include "tdx_arch.h"
>  
>  static bool enable_tdx __ro_after_init;
>  module_param_named(tdx, enable_tdx, bool, 0444);
> @@ -29,6 +30,17 @@ static bool vt_is_vm_type_supported(unsigned long type)
>  		(enable_tdx && tdx_is_vm_type_supported(type));
>  }
>  
> +static int vt_max_vcpus(struct kvm *kvm)
> +{
> +	if (!kvm)
> +		return KVM_MAX_VCPUS;
> +
> +	if (is_td(kvm))
> +		return min3(kvm->max_vcpus, KVM_MAX_VCPUS, TDX_MAX_VCPUS);
> +
> +	return kvm->max_vcpus;
> +}
> +
>  static __init int vt_hardware_setup(void)
>  {
>  	int ret;
> @@ -42,6 +54,14 @@ static __init int vt_hardware_setup(void)
>  	return 0;
>  }
>  
> +static int vt_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
> +{
> +	if (is_td(kvm))
> +		return tdx_vm_enable_cap(kvm, cap);
> +
> +	return -EINVAL;
> +}
> +
>  static int vt_vm_init(struct kvm *kvm)
>  {
>  	if (is_td(kvm))
> @@ -81,7 +101,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>  	.has_emulated_msr = vmx_has_emulated_msr,
>  
>  	.is_vm_type_supported = vt_is_vm_type_supported,
> +	.max_vcpus = vt_max_vcpus,
>  	.vm_size = sizeof(struct kvm_vmx),
> +	.vm_enable_cap = vt_vm_enable_cap,
>  	.vm_init = vt_vm_init,
>  	.vm_destroy = vmx_vm_destroy,
>  
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index d759028a698e..8b02e605cfb5 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -16,6 +16,36 @@
>  		offsetof(struct tdsysinfo_struct, cpuid_configs))	\
>  		/ sizeof(struct tdx_cpuid_config))
>  
> +int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
> +{
> +	int r;
> +
> +	switch (cap->cap) {
> +	case KVM_CAP_MAX_VCPUS: {
> +		if (cap->flags || cap->args[0] == 0)
> +			return -EINVAL;
> +		if (cap->args[0] > KVM_MAX_VCPUS)
> +			return -E2BIG;
> +		if (cap->args[0] > TDX_MAX_VCPUS)
> +			return -E2BIG;
> +
> +		mutex_lock(&kvm->lock);
> +		if (kvm->created_vcpus)
> +			r = -EBUSY;
> +		else {
> +			kvm->max_vcpus = cap->args[0];
> +			r = 0;
> +		}
> +		mutex_unlock(&kvm->lock);
> +		break;
> +	}
> +	default:
> +		r = -EINVAL;
> +		break;
> +	}
> +	return r;
> +}
> +
>  int tdx_hardware_enable(void)
>  {
>  	return tdx_cpu_enable();
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 2210c8c1e893..3860aa351bd9 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -3,6 +3,9 @@
>  #define __KVM_X86_TDX_H
>  
>  #ifdef CONFIG_INTEL_TDX_HOST
> +
> +#include "tdx_ops.h"
> +
>  struct kvm_tdx {
>  	struct kvm kvm;
>  	/* TDX specific members follow. */
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index c70749114e9e..8118647aa8ca 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -143,6 +143,7 @@ int tdx_hardware_enable(void);
>  bool tdx_is_vm_type_supported(unsigned long type);
>  int tdx_dev_ioctl(void __user *argp);
>  
> +int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
>  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>  #else
>  static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -ENOSYS; }
> @@ -150,6 +151,7 @@ static inline int tdx_hardware_enable(void) { return -EOPNOTSUPP; }
>  static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
>  static inline int tdx_dev_ioctl(void __user *argp) { return -EOPNOTSUPP; };
>  
> +static inline int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap) { return -EINVAL; };
>  static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
>  #endif
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8687623929c3..7b02dd40ef21 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4500,6 +4500,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		break;
>  	case KVM_CAP_MAX_VCPUS:
>  		r = KVM_MAX_VCPUS;
> +		if (kvm_x86_ops.max_vcpus)
> +			r = static_call(kvm_x86_max_vcpus)(kvm);
>  		break;
>  	case KVM_CAP_MAX_VCPU_ID:
>  		r = KVM_MAX_VCPU_IDS;
> @@ -6439,6 +6441,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		break;
>  	default:
>  		r = -EINVAL;
> +		if (kvm_x86_ops.vm_enable_cap)
> +			r = static_call(kvm_x86_vm_enable_cap)(kvm, cap);
>  		break;
>  	}
>  	return r;

