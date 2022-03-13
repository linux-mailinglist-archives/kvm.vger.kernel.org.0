Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A084D78AD
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 00:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235645AbiCMXKM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 19:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235527AbiCMXKM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 19:10:12 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC072DCA;
        Sun, 13 Mar 2022 16:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647212943; x=1678748943;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GagRgepCLuEWL5bHR27C4LgguPqs7AwWmg+BnQe5UFM=;
  b=hLx58L/u7JbT9OilYQkRulWe8RBlArOjHNe/ksXa7VTFf5nSS7kJru7/
   4VXpCBEaUZfsBwma5mCT0UPBSyc06KC9Vv9nnEVe321onF9hGSnyX7QtZ
   eTRrv2oz2xoF+kusjUjyEVnAyhxfaNI7/HdB0u4D7FbD+/dqjJDEnndIy
   eSygAJ4M9/bgPTD8kLxgh09X9Ft+oxiWMUGm9OjMJXVo1mgwRkSUUBkRK
   IhhS17j77GSbnf8BtZDNMXx4rLRkI1wwiTib7amzrVBrgiJ109jG8b7ny
   fz4F4S0QxFaQUyuON90CK7cQZNaERARCNgMzAZXzSEUhZxvA8DK4ZxJnK
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10285"; a="342330862"
X-IronPort-AV: E=Sophos;i="5.90,179,1643702400"; 
   d="scan'208";a="342330862"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 16:09:03 -0700
X-IronPort-AV: E=Sophos;i="5.90,179,1643702400"; 
   d="scan'208";a="782485839"
Received: from mvideche-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.130.249])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 16:09:01 -0700
Message-ID: <18a150fd2e0316b4bae283d244f856494e0dfefd.camel@intel.com>
Subject: Re: [RFC PATCH v5 010/104] KVM: TDX: Make TDX VM type supported
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Mon, 14 Mar 2022 12:08:59 +1300
In-Reply-To: <0596db2913da40660e87d5005167c623cee14765.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
         <0596db2913da40660e87d5005167c623cee14765.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-03-04 at 11:48 -0800, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> As first step TDX VM support, return that TDX VM type supported to device
> model, e.g. qemu.  The callback to create guest TD is vm_init callback for
> KVM_CREATE_VM.  Add a place holder function and call a function to
> initialize TDX module on demand because in that callback VMX is enabled by
> hardware_enable callback (vmx_hardware_enable).

Should we put this patch at the end of series until all changes required to run
TD are introduced?  This patch essentially tells userspace KVM is ready to
support a TD but actually it's not ready.  And this might also cause bisect
issue I suppose?

-- 
Thanks,
-Kai

> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/vmx/main.c    | 24 ++++++++++++++++++++++--
>  arch/x86/kvm/vmx/tdx.c     |  5 +++++
>  arch/x86/kvm/vmx/vmx.c     |  5 -----
>  arch/x86/kvm/vmx/x86_ops.h |  3 ++-
>  4 files changed, 29 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 77da926ee505..8103d1c32cc9 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -5,6 +5,12 @@
>  #include "vmx.h"
>  #include "nested.h"
>  #include "pmu.h"
> +#include "tdx.h"
> +
> +static bool vt_is_vm_type_supported(unsigned long type)
> +{
> +	return type == KVM_X86_DEFAULT_VM || tdx_is_vm_type_supported(type);
> +}
>  
>  static __init int vt_hardware_setup(void)
>  {
> @@ -19,6 +25,20 @@ static __init int vt_hardware_setup(void)
>  	return 0;
>  }
>  
> +static int vt_vm_init(struct kvm *kvm)
> +{
> +	int ret;
> +
> +	if (is_td(kvm)) {
> +		ret = tdx_module_setup();
> +		if (ret)
> +			return ret;
> +		return -EOPNOTSUPP;	/* Not ready to create guest TD yet. */
> +	}
> +
> +	return vmx_vm_init(kvm);
> +}
> +
>  struct kvm_x86_ops vt_x86_ops __initdata = {
>  	.name = "kvm_intel",
>  
> @@ -29,9 +49,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>  	.cpu_has_accelerated_tpr = report_flexpriority,
>  	.has_emulated_msr = vmx_has_emulated_msr,
>  
> -	.is_vm_type_supported = vmx_is_vm_type_supported,
> +	.is_vm_type_supported = vt_is_vm_type_supported,
>  	.vm_size = sizeof(struct kvm_vmx),
> -	.vm_init = vmx_vm_init,
> +	.vm_init = vt_vm_init,
>  
>  	.vcpu_create = vmx_vcpu_create,
>  	.vcpu_free = vmx_vcpu_free,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 8adc87ad1807..e8d293a3c11c 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -105,6 +105,11 @@ int tdx_module_setup(void)
>  	return ret;
>  }
>  
> +bool tdx_is_vm_type_supported(unsigned long type)
> +{
> +	return type == KVM_X86_TDX_VM && READ_ONCE(enable_tdx);
> +}
> +
>  static int __init __tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
>  {
>  	u32 max_pa;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 3c7b3f245fee..7838cd177f0e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7079,11 +7079,6 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
>  	return err;
>  }
>  
> -bool vmx_is_vm_type_supported(unsigned long type)
> -{
> -	return type == KVM_X86_DEFAULT_VM;
> -}
> -
>  #define L1TF_MSG_SMT "L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
>  #define L1TF_MSG_L1D "L1TF CPU bug present and virtualization mitigation disabled, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
>  
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index f7327bc73be0..78331dbc29f7 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -25,7 +25,6 @@ void vmx_hardware_unsetup(void);
>  int vmx_hardware_enable(void);
>  void vmx_hardware_disable(void);
>  bool report_flexpriority(void);
> -bool vmx_is_vm_type_supported(unsigned long type);
>  int vmx_vm_init(struct kvm *kvm);
>  int vmx_vcpu_create(struct kvm_vcpu *vcpu);
>  int vmx_vcpu_pre_run(struct kvm_vcpu *vcpu);
> @@ -130,10 +129,12 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
>  #ifdef CONFIG_INTEL_TDX_HOST
>  void __init tdx_pre_kvm_init(unsigned int *vcpu_size,
>  			unsigned int *vcpu_align, unsigned int *vm_size);
> +bool tdx_is_vm_type_supported(unsigned long type);
>  void __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
>  #else
>  static inline void tdx_pre_kvm_init(
>  	unsigned int *vcpu_size, unsigned int *vcpu_align, unsigned int *vm_size) {}
> +static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
>  static inline void tdx_hardware_setup(struct kvm_x86_ops *x86_ops) {}
>  #endif
>  


