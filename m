Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC2045A41B7
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 06:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiH2EID (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 00:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiH2EIC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 00:08:02 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F6630551;
        Sun, 28 Aug 2022 21:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661746080; x=1693282080;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=odVdWMd5ZcOUL1mRd/1FgqAmXMVitf72TPGRm2JESC4=;
  b=MHyvyOx+aonYohFunSaxBrHtVHHGwzykTWGAe31ZqITGR2TXKjDxvXVh
   rkTIAmphjAwFo/EqJMrgSfNyJpi5I8A3yV0okt612hGQglZmix7tIEsbW
   gwAVR6JR3RwwCNBQiHoIpbEwUhjcBWFkXbRJ4MINpSBDNXpVn1rA7N3Of
   O3S2Lef8+GqCG1aqaEVmONVQwgR5Vt7VlT0taUMj2X3p0sJJbn8/3Lu63
   PyO6x0wNx9A2DotU2bP3GRX7ZvCFVlMdP+ZjA8ZlvrJV2K2Ct8I1e5oAv
   d62Ohf5Y1G7WeTmh50CPioHb4uL4IR5KiczowhnQbXHmtSgpqPdU3Qo/L
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10453"; a="296077196"
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="296077196"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2022 21:07:59 -0700
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="672224124"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.0.236]) ([10.238.0.236])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2022 21:07:57 -0700
Message-ID: <25e3ecd2-7038-5e3b-b826-0366aea899c9@linux.intel.com>
Date:   Mon, 29 Aug 2022 12:07:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH v8 022/103] KVM: TDX: Add place holder for TDX VM specific
 mem_enc_op ioctl
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <2d65bd56a7ab8c0776f5c6b7c8481dd45ad96794.1659854790.git.isaku.yamahata@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <2d65bd56a7ab8c0776f5c6b7c8481dd45ad96794.1659854790.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2022/8/8 6:01, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Add a place holder function for TDX specific VM-scoped ioctl as mem_enc_op.
> TDX specific sub-commands will be added to retrieve/pass TDX specific
> parameters.
>
> KVM_MEMORY_ENCRYPT_OP was introduced for VM-scoped operations specific for
> guest state-protected VM.  It defined subcommands for technology-specific
> operations under KVM_MEMORY_ENCRYPT_OP.  Despite its name, the subcommands
> are not limited to memory encryption, but various technology-specific
> operations are defined.  It's natural to repurpose KVM_MEMORY_ENCRYPT_OP
> for TDX specific operations and define subcommands.
>
> TDX requires VM-scoped TDX-specific operations for device model, for
> example, qemu.  Getting system-wide parameters, TDX-specific VM
> initialization.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/main.c    |  9 +++++++++
>   arch/x86/kvm/vmx/tdx.c     | 26 ++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/x86_ops.h |  4 ++++
>   3 files changed, 39 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 7b497ed1f21c..067f5de56c53 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -73,6 +73,14 @@ static void vt_vm_free(struct kvm *kvm)
>   		return tdx_vm_free(kvm);
>   }
>   
> +static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
> +{
> +	if (!is_td(kvm))
> +		return -ENOTTY;
> +
> +	return tdx_vm_ioctl(kvm, argp);
> +}
> +
>   struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.name = "kvm_intel",
>   
> @@ -214,6 +222,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
>   
>   	.dev_mem_enc_ioctl = tdx_dev_ioctl,
> +	.mem_enc_ioctl = vt_mem_enc_ioctl,

suggeust to align the interafce/function name style with the scop.

patch 21 and 27 have the scope in interafce names(dev / vcpu), may be 
clearer to use  vcpu_mem_enc_ioctl?



>   };
>   
>   struct kvm_x86_init_ops vt_init_ops __initdata = {
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 16c6570dbe52..d3b9f653da4b 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -424,6 +424,32 @@ int tdx_dev_ioctl(void __user *argp)
>   	return 0;
>   }
>   
> +int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
> +{
> +	struct kvm_tdx_cmd tdx_cmd;
> +	int r;
> +
> +	if (copy_from_user(&tdx_cmd, argp, sizeof(struct kvm_tdx_cmd)))
> +		return -EFAULT;
> +	if (tdx_cmd.error || tdx_cmd.unused)
> +		return -EINVAL;
> +
> +	mutex_lock(&kvm->lock);
> +
> +	switch (tdx_cmd.id) {
> +	default:
> +		r = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (copy_to_user(argp, &tdx_cmd, sizeof(struct kvm_tdx_cmd)))
> +		r = -EFAULT;
> +
> +out:
> +	mutex_unlock(&kvm->lock);
> +	return r;
> +}
> +
>   int __init tdx_module_setup(void)
>   {
>   	const struct tdsysinfo_struct *tdsysinfo;
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 02490515d190..f0fe40c7ac34 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -137,6 +137,8 @@ int tdx_dev_ioctl(void __user *argp);
>   int tdx_vm_init(struct kvm *kvm);
>   void tdx_mmu_release_hkid(struct kvm *kvm);
>   void tdx_vm_free(struct kvm *kvm);
> +
> +int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>   #else
>   static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
>   static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
> @@ -147,6 +149,8 @@ static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
>   static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
>   static inline void tdx_flush_shadow_all_private(struct kvm *kvm) {}
>   static inline void tdx_vm_free(struct kvm *kvm) {}
> +
> +static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
>   #endif
>   
>   #endif /* __KVM_X86_VMX_X86_OPS_H */
