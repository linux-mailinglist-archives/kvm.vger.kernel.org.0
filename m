Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28A9D6C8CBD
	for <lists+kvm@lfdr.de>; Sat, 25 Mar 2023 09:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbjCYInN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Mar 2023 04:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjCYInM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Mar 2023 04:43:12 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E6049E1;
        Sat, 25 Mar 2023 01:43:10 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id f16so3943429ljq.10;
        Sat, 25 Mar 2023 01:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679733788; x=1682325788;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9jv3VvZnU7w2nlR9bNM+GCMAVdcW1eyjXRIWESm7qpA=;
        b=cYt/+QKdRPxgmai3qQ7Z9DYbV+0GouKOWZ9bBlPaTDHy2/sMdJj2Z2Lrxb/FkHay6e
         1dfc/ydVWPHjBz8Z7olawvATXEbe/luJ3em8ID7ux5gShYbX44v/rXvjpT3tOJtrvdZJ
         MbVBWYkcTb9wOEuh2Og8MCgACVNZv7unExJrkybdhwlG8BXYR3DueQ/r7+Xvyu2x0DjW
         iVrae6dZiO05Vr+nQ7xbJkm5fGkwqmWNRgCUB0oe34oLDVA2lWLvXeaaZS9crdBVl6yw
         /OCDSAmuasFowr/83MC9TOSvgFHM5UjrMeIVnzlCsCi8cNW9tnuMqSgArA8Gf/dqMKi9
         NXUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679733788; x=1682325788;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9jv3VvZnU7w2nlR9bNM+GCMAVdcW1eyjXRIWESm7qpA=;
        b=zNQhc75U5Y9UOrwkoWE2pHjeQQBobOZ2QKwOCkCyyGrQ1vzS9Qq2Ta2ihRZjAvyMEB
         ZE6gOCksyG8GIRj0scnEEbA25NkizF0soEIGPhjRxgIzlL3lOxlEYg0PsrNPGWNqvxul
         Sk8AMFhXmuYQQzdNX2TFl5cfs3bioLn3V0G1TqGiSDkY8WlCMk2RDCIQDYAFsvCSny5G
         hX89QMeKKAN1RuyTSZvHaQjgu/5p6GehjXkGNLHGGYlcQc/KDvZsEqaHkG75fkDG5eBX
         EtmiNDI+p4V0TX/uFOuqz9Gu2hJvy5+B2RY/sduZFBPziTLWg1dStnpKCm9TlFqHD83L
         eNnw==
X-Gm-Message-State: AAQBX9eGQs5tpxcZjEIOXLBjC9NAhOlbGfyZoT5Er1+r786kBWtl6GXv
        V7Jn/lLRDRjn+O9TmN1qAbY=
X-Google-Smtp-Source: AKy350b/LDe3dr65putzORzBvJqfZ9vVcJ5/pleYaK8HgQvdWbR9LxB44CWCl1KZ/KHUcvLDaxwnJA==
X-Received: by 2002:a05:651c:b0b:b0:295:9c3f:e30c with SMTP id b11-20020a05651c0b0b00b002959c3fe30cmr1998595ljr.1.1679733787922;
        Sat, 25 Mar 2023 01:43:07 -0700 (PDT)
Received: from localhost (88-113-32-99.elisa-laajakaista.fi. [88.113.32.99])
        by smtp.gmail.com with ESMTPSA id p5-20020a2e8045000000b0029f7d27b78bsm1697425ljg.110.2023.03.25.01.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Mar 2023 01:43:07 -0700 (PDT)
Date:   Sat, 25 Mar 2023 10:43:06 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v13 016/113] KVM: TDX: x86: Add ioctl to get TDX
 systemwide parameters
Message-ID: <20230325104306.00004585@gmail.com>
In-Reply-To: <cb0ae8b4941aaa45e1e5856dde644f9b2f53d9a6.1678643052.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
        <cb0ae8b4941aaa45e1e5856dde644f9b2f53d9a6.1678643052.git.isaku.yamahata@intel.com>
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

On Sun, 12 Mar 2023 10:55:40 -0700
isaku.yamahata@intel.com wrote:

Does this have to be a new generic ioctl with a dedicated new x86_ops? SNP
does not use it at all and all the system-scoped ioctl of SNP going through
the CCP driver. So getting system-scope information of TDX/SNP will end up
differently.

Any thought, Sean? Moving getting SNP system-wide information to
KVM dev ioctl seems not ideal and TDX does not have a dedicated driver like
CCP. Maybe make this ioctl TDX-specific? KVM_TDX_DEV_OP?

> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Implement a system-scoped ioctl to get system-wide parameters for TDX.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h    |  1 +
>  arch/x86/include/asm/kvm_host.h       |  1 +
>  arch/x86/include/uapi/asm/kvm.h       | 48 +++++++++++++++++++++++++
>  arch/x86/kvm/vmx/main.c               |  2 ++
>  arch/x86/kvm/vmx/tdx.c                | 51 +++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/x86_ops.h            |  2 ++
>  arch/x86/kvm/x86.c                    |  6 ++++
>  tools/arch/x86/include/uapi/asm/kvm.h | 48 +++++++++++++++++++++++++
>  8 files changed, 159 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index eac4b65d1b01..b46dcac078b2 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -117,6 +117,7 @@ KVM_X86_OP(enter_smm)
>  KVM_X86_OP(leave_smm)
>  KVM_X86_OP(enable_smi_window)
>  #endif
> +KVM_X86_OP_OPTIONAL(dev_mem_enc_ioctl)
>  KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
>  KVM_X86_OP_OPTIONAL(mem_enc_register_region)
>  KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 00c25f6ab871..49e3ca89aced 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1719,6 +1719,7 @@ struct kvm_x86_ops {
>  	void (*enable_smi_window)(struct kvm_vcpu *vcpu);
>  #endif
>  
> +	int (*dev_mem_enc_ioctl)(void __user *argp);
>  	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
>  	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
>  	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 6afbfbb32d56..af4c5bd0af1c 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -562,4 +562,52 @@ struct kvm_pmu_event_filter {
>  #define KVM_X86_DEFAULT_VM	0
>  #define KVM_X86_PROTECTED_VM	1
>  
> +/* Trust Domain eXtension sub-ioctl() commands. */
> +enum kvm_tdx_cmd_id {
> +	KVM_TDX_CAPABILITIES = 0,
> +
> +	KVM_TDX_CMD_NR_MAX,
> +};
> +
> +struct kvm_tdx_cmd {
> +	/* enum kvm_tdx_cmd_id */
> +	__u32 id;
> +	/* flags for sub-commend. If sub-command doesn't use this, set zero. */
> +	__u32 flags;
> +	/*
> +	 * data for each sub-command. An immediate or a pointer to the actual
> +	 * data in process virtual address.  If sub-command doesn't use it,
> +	 * set zero.
> +	 */
> +	__u64 data;
> +	/*
> +	 * Auxiliary error code.  The sub-command may return TDX SEAMCALL
> +	 * status code in addition to -Exxx.
> +	 * Defined for consistency with struct kvm_sev_cmd.
> +	 */
> +	__u64 error;
> +	/* Reserved: Defined for consistency with struct kvm_sev_cmd. */
> +	__u64 unused;
> +};
> +
> +struct kvm_tdx_cpuid_config {
> +	__u32 leaf;
> +	__u32 sub_leaf;
> +	__u32 eax;
> +	__u32 ebx;
> +	__u32 ecx;
> +	__u32 edx;
> +};
> +
> +struct kvm_tdx_capabilities {
> +	__u64 attrs_fixed0;
> +	__u64 attrs_fixed1;
> +	__u64 xfam_fixed0;
> +	__u64 xfam_fixed1;
> +
> +	__u32 nr_cpuid_configs;
> +	__u32 padding;
> +	struct kvm_tdx_cpuid_config cpuid_configs[0];
> +};
> +
>  #endif /* _ASM_X86_KVM_H */
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index c8548004802a..6a5d0c7a2950 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -201,6 +201,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>  	.complete_emulated_msr = kvm_complete_insn_gp,
>  
>  	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
> +
> +	.dev_mem_enc_ioctl = tdx_dev_ioctl,
>  };
>  
>  struct kvm_x86_init_ops vt_init_ops __initdata = {
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index e9b7aa5654e9..b59d3081d061 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -21,6 +21,57 @@ int tdx_hardware_enable(void)
>  	return tdx_cpu_enable();
>  }
>  
> +int tdx_dev_ioctl(void __user *argp)
> +{
> +	struct kvm_tdx_capabilities __user *user_caps;
> +	const struct tdsysinfo_struct *tdsysinfo;
> +	struct kvm_tdx_capabilities caps;
> +	struct kvm_tdx_cmd cmd;
> +
> +	BUILD_BUG_ON(sizeof(struct kvm_tdx_cpuid_config) !=
> +		     sizeof(struct tdx_cpuid_config));
> +
> +	if (copy_from_user(&cmd, argp, sizeof(cmd)))
> +		return -EFAULT;
> +	if (cmd.flags || cmd.error || cmd.unused)
> +		return -EINVAL;
> +	/*
> +	 * Currently only KVM_TDX_CAPABILITIES is defined for system-scoped
> +	 * mem_enc_ioctl().
> +	 */
> +	if (cmd.id != KVM_TDX_CAPABILITIES)
> +		return -EINVAL;
> +
> +	tdsysinfo = tdx_get_sysinfo();
> +	if (!tdsysinfo)
> +		return -ENOTSUPP;
> +
> +	user_caps = (void __user *)cmd.data;
> +	if (copy_from_user(&caps, user_caps, sizeof(caps)))
> +		return -EFAULT;
> +
> +	if (caps.nr_cpuid_configs < tdsysinfo->num_cpuid_config)
> +		return -E2BIG;
> +
> +	caps = (struct kvm_tdx_capabilities) {
> +		.attrs_fixed0 = tdsysinfo->attributes_fixed0,
> +		.attrs_fixed1 = tdsysinfo->attributes_fixed1,
> +		.xfam_fixed0 = tdsysinfo->xfam_fixed0,
> +		.xfam_fixed1 = tdsysinfo->xfam_fixed1,
> +		.nr_cpuid_configs = tdsysinfo->num_cpuid_config,
> +		.padding = 0,
> +	};
> +
> +	if (copy_to_user(user_caps, &caps, sizeof(caps)))
> +		return -EFAULT;
> +	if (copy_to_user(user_caps->cpuid_configs, &tdsysinfo->cpuid_configs,
> +			 tdsysinfo->num_cpuid_config *
> +			 sizeof(struct tdx_cpuid_config)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
>  static int __init tdx_module_setup(void)
>  {
>  	const struct tdsysinfo_struct *tdsysinfo;
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index b2c74c1b5bbd..78c5537e23a1 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -141,10 +141,12 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
>  int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
>  int tdx_hardware_enable(void);
>  bool tdx_is_vm_type_supported(unsigned long type);
> +int tdx_dev_ioctl(void __user *argp);
>  #else
>  static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -ENOSYS; }
>  static inline int tdx_hardware_enable(void) { return -EOPNOTSUPP; }
>  static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
> +static inline int tdx_dev_ioctl(void __user *argp) { return -EOPNOTSUPP; };
>  #endif
>  
>  #endif /* __KVM_X86_VMX_X86_OPS_H */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 27ab684f8374..a3dc32e33aca 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4718,6 +4718,12 @@ long kvm_arch_dev_ioctl(struct file *filp,
>  		r = kvm_x86_dev_has_attr(&attr);
>  		break;
>  	}
> +	case KVM_MEMORY_ENCRYPT_OP:
> +		r = -EINVAL;
> +		if (!kvm_x86_ops.dev_mem_enc_ioctl)
> +			goto out;
> +		r = static_call(kvm_x86_dev_mem_enc_ioctl)(argp);
> +		break;
>  	default:
>  		r = -EINVAL;
>  		break;
> diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
> index 6afbfbb32d56..af4c5bd0af1c 100644
> --- a/tools/arch/x86/include/uapi/asm/kvm.h
> +++ b/tools/arch/x86/include/uapi/asm/kvm.h
> @@ -562,4 +562,52 @@ struct kvm_pmu_event_filter {
>  #define KVM_X86_DEFAULT_VM	0
>  #define KVM_X86_PROTECTED_VM	1
>  
> +/* Trust Domain eXtension sub-ioctl() commands. */
> +enum kvm_tdx_cmd_id {
> +	KVM_TDX_CAPABILITIES = 0,
> +
> +	KVM_TDX_CMD_NR_MAX,
> +};
> +
> +struct kvm_tdx_cmd {
> +	/* enum kvm_tdx_cmd_id */
> +	__u32 id;
> +	/* flags for sub-commend. If sub-command doesn't use this, set zero. */
> +	__u32 flags;
> +	/*
> +	 * data for each sub-command. An immediate or a pointer to the actual
> +	 * data in process virtual address.  If sub-command doesn't use it,
> +	 * set zero.
> +	 */
> +	__u64 data;
> +	/*
> +	 * Auxiliary error code.  The sub-command may return TDX SEAMCALL
> +	 * status code in addition to -Exxx.
> +	 * Defined for consistency with struct kvm_sev_cmd.
> +	 */
> +	__u64 error;
> +	/* Reserved: Defined for consistency with struct kvm_sev_cmd. */
> +	__u64 unused;
> +};
> +
> +struct kvm_tdx_cpuid_config {
> +	__u32 leaf;
> +	__u32 sub_leaf;
> +	__u32 eax;
> +	__u32 ebx;
> +	__u32 ecx;
> +	__u32 edx;
> +};
> +
> +struct kvm_tdx_capabilities {
> +	__u64 attrs_fixed0;
> +	__u64 attrs_fixed1;
> +	__u64 xfam_fixed0;
> +	__u64 xfam_fixed1;
> +
> +	__u32 nr_cpuid_configs;
> +	__u32 padding;
> +	struct kvm_tdx_cpuid_config cpuid_configs[0];
> +};
> +
>  #endif /* _ASM_X86_KVM_H */

