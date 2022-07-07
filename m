Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B92E2569868
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 04:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234837AbiGGCzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 22:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234177AbiGGCzj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 22:55:39 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04D92E9FE;
        Wed,  6 Jul 2022 19:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657162537; x=1688698537;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OhSAiO9mbEhXvYhE0pGpnWKw0ZwQssOlGAsoAGUyDZs=;
  b=KHuOSALxenM0eGfZy+11RTiENZEBBpwhD9atpsiHKf2A98GSN/tLB7lw
   Ji8/S7/bGgKRYs1Spp+JgEvifHfuJAYrAh20aKmobzJePnsRfd3R3cM8S
   0eHznkdQoRDV4bsmEDQZzIxVeqkG0LzjuRYxJRyXs35DWbWG85Bc+hmAZ
   HXzcSfT02+0TlPyPO/TPDffenypAZw3f17XgKPtRUvV90OCUa0fDIezc0
   T49527q3jU1eo0JkVTfjBPXJPjw1dijfRwkeWUazMiE1VA2/KZA8DAUv5
   pKmSOzSkpkQsJaCm1Mu9PVbRPGTZMGUQ++OWPY39VJR5jyIuJe6vCNrrE
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10400"; a="266945500"
X-IronPort-AV: E=Sophos;i="5.92,251,1650956400"; 
   d="scan'208";a="266945500"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2022 19:55:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,251,1650956400"; 
   d="scan'208";a="591040884"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga007.jf.intel.com with ESMTP; 06 Jul 2022 19:55:35 -0700
Date:   Thu, 7 Jul 2022 10:55:35 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 013/102] KVM: TDX: Make TDX VM type supported
Message-ID: <20220707025535.7vn6ifx4wq52qwes@yy-desk-7060>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <038362fa9e89312ff72c01ab3ae3bbbf522c3592.1656366338.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <038362fa9e89312ff72c01ab3ae3bbbf522c3592.1656366338.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 27, 2022 at 02:53:05PM -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> NOTE: This patch is in position of the patch series for developers to be
> able to test codes during the middle of the patch series although this
> patch series doesn't provide functional features until the all the patches
> of this patch series.  When merging this patch series, this patch can be
> moved to the end.
>
> As first step TDX VM support, return that TDX VM type supported to device
> model, e.g. qemu.  The callback to create guest TD is vm_init callback for
> KVM_CREATE_VM.  Add a place holder function and call a function to
> initialize TDX module on demand because in that callback VMX is enabled by
> hardware_enable callback (vmx_hardware_enable).

if the "initialize TDX module on demand" means calling tdx_init() then
it's already done in kvm_init() ->
kvm_arch_post_hardware_enable_setup from patch 11, so may need commit
messsage update here.

>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/vmx/main.c    | 18 ++++++++++++++++--
>  arch/x86/kvm/vmx/tdx.c     |  6 ++++++
>  arch/x86/kvm/vmx/vmx.c     |  5 -----
>  arch/x86/kvm/vmx/x86_ops.h |  3 ++-
>  4 files changed, 24 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 7be4941e4c4d..47bfa94e538e 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -10,6 +10,12 @@
>  static bool __read_mostly enable_tdx = IS_ENABLED(CONFIG_INTEL_TDX_HOST);
>  module_param_named(tdx, enable_tdx, bool, 0444);
>
> +static bool vt_is_vm_type_supported(unsigned long type)
> +{
> +	return type == KVM_X86_DEFAULT_VM ||
> +		(enable_tdx && tdx_is_vm_type_supported(type));
> +}
> +
>  static __init int vt_hardware_setup(void)
>  {
>  	int ret;
> @@ -33,6 +39,14 @@ static int __init vt_post_hardware_enable_setup(void)
>  	return 0;
>  }
>
> +static int vt_vm_init(struct kvm *kvm)
> +{
> +	if (is_td(kvm))
> +		return -EOPNOTSUPP;	/* Not ready to create guest TD yet. */
> +
> +	return vmx_vm_init(kvm);
> +}
> +
>  struct kvm_x86_ops vt_x86_ops __initdata = {
>  	.name = "kvm_intel",
>
> @@ -43,9 +57,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>  	.hardware_disable = vmx_hardware_disable,
>  	.has_emulated_msr = vmx_has_emulated_msr,
>
> -	.is_vm_type_supported = vmx_is_vm_type_supported,
> +	.is_vm_type_supported = vt_is_vm_type_supported,
>  	.vm_size = sizeof(struct kvm_vmx),
> -	.vm_init = vmx_vm_init,
> +	.vm_init = vt_vm_init,
>  	.vm_destroy = vmx_vm_destroy,
>
>  	.vcpu_precreate = vmx_vcpu_precreate,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 9cb36716b0f3..3675f7de2735 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -73,6 +73,12 @@ int __init tdx_module_setup(void)
>  	return 0;
>  }
>
> +bool tdx_is_vm_type_supported(unsigned long type)
> +{
> +	/* enable_tdx check is done by the caller. */
> +	return type == KVM_X86_TDX_VM;
> +}
> +
>  int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
>  {
>  	u32 max_pa;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 5ba62f8b42ce..b30d73d28e75 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7281,11 +7281,6 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
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
> index a5e85eb4e183..dbfd0e43fd89 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -25,7 +25,6 @@ void vmx_hardware_unsetup(void);
>  int vmx_check_processor_compatibility(void);
>  int vmx_hardware_enable(void);
>  void vmx_hardware_disable(void);
> -bool vmx_is_vm_type_supported(unsigned long type);
>  int vmx_vm_init(struct kvm *kvm);
>  void vmx_vm_destroy(struct kvm *kvm);
>  int vmx_vcpu_precreate(struct kvm *kvm);
> @@ -131,8 +130,10 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
>
>  #ifdef CONFIG_INTEL_TDX_HOST
>  int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
> +bool tdx_is_vm_type_supported(unsigned long type);
>  #else
>  static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
> +static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
>  #endif
>
>  #endif /* __KVM_X86_VMX_X86_OPS_H */
> --
> 2.25.1
>
