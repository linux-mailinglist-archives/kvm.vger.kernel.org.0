Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCFD55E35A
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244250AbiF1Ebm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 00:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244172AbiF1Ebl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 00:31:41 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030981CB1D;
        Mon, 27 Jun 2022 21:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656390700; x=1687926700;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=YGGo90DhtTDJVve0WHQzHk5lTDAaXWrnFTUpCmNzPZE=;
  b=LjugThi+MgBDfQ4FzvI5sjXF/ZRLaRZ1ufJ+qlrEAusX1s4vUhoaEcU2
   QW6emILjDGO4/nAJiKF4iac8hh7ny6h+ccuoVavhgyfeL8sYfb+WmS6jF
   0LoGEQQsTX777N4fEGuHKXFSqtbN9JXC2btkJ0I7GXaHQesIP4mLbiehc
   YzCd+CVZ6FnriPzKxaDx/POuZl0Z4XrNtQFpRmhXOJYNDs8M5dbEVBiHT
   RoqhegvzBkKrM2j1gLN9RKV/yTkPkZd9zFuWWGbXxbP0Uv6QgGyCPd157
   SFQNdsiun48JmehCCITWyzNr9gCvYCXrAWmEE0QiKSVHq/irq/t50/QRe
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="282365832"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="282365832"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 21:31:39 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="594606701"
Received: from nherzalx-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.96.221])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 21:31:37 -0700
Message-ID: <81ea5068b890400ca4064781f7d2221826701020.camel@intel.com>
Subject: Re: [PATCH v7 011/102] KVM: TDX: Initialize TDX module when loading
 kvm_intel.ko
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Tue, 28 Jun 2022 16:31:35 +1200
In-Reply-To: <d933e5f16ff8cb58020f1479b7af35196f0ef61e.1656366338.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <d933e5f16ff8cb58020f1479b7af35196f0ef61e.1656366338.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>=20
> To use TDX functionality, TDX module needs to be loaded and initialized.
> A TDX host patch series[1] implements the detection of the TDX module,
> tdx_detect() and its initialization, tdx_init().

"A TDX host patch series[1]" really isn't a commit message material.  You c=
an
put it to the cover letter, but not here.

Also tdx_detect() is removed in latest code.

>=20
> This patch is to call those functions, tdx_detect() and tdx_init(), when
> loading kvm_intel.ko.
>=20
> Add a hook, kvm_arch_post_hardware_enable_setup, to module initialization
> while hardware is enabled, i.e. after hardware_enable_all() and before
> hardware_disable_all().  Because TDX requires all present CPUs to enable
> VMX (VMXON).
>=20
> [1] https://lore.kernel.org/lkml/cover.1649219184.git.kai.huang@intel.com=
/
>=20
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/vmx/main.c         | 11 ++++++
>  arch/x86/kvm/vmx/tdx.c          | 60 +++++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/tdx.h          |  4 +++
>  arch/x86/kvm/x86.c              |  8 +++++
>  5 files changed, 84 insertions(+)
>=20
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 62dec97f6607..aa11525500d3 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1639,6 +1639,7 @@ struct kvm_x86_init_ops {
>  	int (*cpu_has_kvm_support)(void);
>  	int (*disabled_by_bios)(void);
>  	int (*hardware_setup)(void);
> +	int (*post_hardware_enable_setup)(void);
>  	unsigned int (*handle_intel_pt_intr)(void);
> =20
>  	struct kvm_x86_ops *runtime_ops;
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 349534412216..ac788af17d92 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -23,6 +23,16 @@ static __init int vt_hardware_setup(void)
>  	return 0;
>  }
> =20
> +static int __init vt_post_hardware_enable_setup(void)
> +{
> +	enable_tdx =3D enable_tdx && !tdx_module_setup();
> +	/*
> +	 * Even if it failed to initialize TDX module, conventional VMX is
> +	 * available.  Keep VMX usable.
> +	 */
> +	return 0;
> +}
> +
>  struct kvm_x86_ops vt_x86_ops __initdata =3D {
>  	.name =3D "kvm_intel",
> =20
> @@ -165,6 +175,7 @@ struct kvm_x86_init_ops vt_init_ops __initdata =3D {
>  	.cpu_has_kvm_support =3D vmx_cpu_has_kvm_support,
>  	.disabled_by_bios =3D vmx_disabled_by_bios,
>  	.hardware_setup =3D vt_hardware_setup,
> +	.post_hardware_enable_setup =3D vt_post_hardware_enable_setup,
>  	.handle_intel_pt_intr =3D NULL,
> =20
>  	.runtime_ops =3D &vt_x86_ops,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 2617389ef466..9cb36716b0f3 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -13,6 +13,66 @@
>  static u64 hkid_mask __ro_after_init;
>  static u8 hkid_start_pos __ro_after_init;
> =20
> +#define TDX_MAX_NR_CPUID_CONFIGS					\
> +	((sizeof(struct tdsysinfo_struct) -				\
> +		offsetof(struct tdsysinfo_struct, cpuid_configs))	\
> +		/ sizeof(struct tdx_cpuid_config))
> +
> +struct tdx_capabilities {
> +	u8 tdcs_nr_pages;
> +	u8 tdvpx_nr_pages;
> +
> +	u64 attrs_fixed0;
> +	u64 attrs_fixed1;
> +	u64 xfam_fixed0;
> +	u64 xfam_fixed1;
> +
> +	u32 nr_cpuid_configs;
> +	struct tdx_cpuid_config cpuid_configs[TDX_MAX_NR_CPUID_CONFIGS];
> +};
> +
> +/* Capabilities of KVM + the TDX module. */
> +static struct tdx_capabilities tdx_caps;
> +
> +int __init tdx_module_setup(void)
> +{
> +	const struct tdsysinfo_struct *tdsysinfo;
> +	int ret =3D 0;
> +
> +	BUILD_BUG_ON(sizeof(*tdsysinfo) !=3D 1024);
> +	BUILD_BUG_ON(TDX_MAX_NR_CPUID_CONFIGS !=3D 37);
> +
> +	ret =3D tdx_init();
> +	if (ret) {
> +		pr_info("Failed to initialize TDX module.\n");
> +		return ret;
> +	}
> +
> +	tdsysinfo =3D tdx_get_sysinfo();
> +	if (tdsysinfo->num_cpuid_config > TDX_MAX_NR_CPUID_CONFIGS)
> +		return -EIO;
> +
> +	tdx_caps =3D (struct tdx_capabilities) {
> +		.tdcs_nr_pages =3D tdsysinfo->tdcs_base_size / PAGE_SIZE,
> +		/*
> +		 * TDVPS =3D TDVPR(4K page) + TDVPX(multiple 4K pages).
> +		 * -1 for TDVPR.
> +		 */
> +		.tdvpx_nr_pages =3D tdsysinfo->tdvps_base_size / PAGE_SIZE - 1,
> +		.attrs_fixed0 =3D tdsysinfo->attributes_fixed0,
> +		.attrs_fixed1 =3D tdsysinfo->attributes_fixed1,
> +		.xfam_fixed0 =3D	tdsysinfo->xfam_fixed0,
> +		.xfam_fixed1 =3D tdsysinfo->xfam_fixed1,
> +		.nr_cpuid_configs =3D tdsysinfo->num_cpuid_config,
> +	};
> +	if (!memcpy(tdx_caps.cpuid_configs, tdsysinfo->cpuid_configs,
> +			tdsysinfo->num_cpuid_config *
> +			sizeof(struct tdx_cpuid_config)))
> +		return -EIO;
> +
> +	return 0;
> +}
> +
>  int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
>  {
>  	u32 max_pa;
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 060bf48ec3d6..54d7a26ed9ee 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -3,6 +3,8 @@
>  #define __KVM_X86_TDX_H
> =20
>  #ifdef CONFIG_INTEL_TDX_HOST
> +int tdx_module_setup(void);
> +
>  struct kvm_tdx {
>  	struct kvm kvm;
>  	/* TDX specific members follow. */
> @@ -37,6 +39,8 @@ static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *=
vcpu)
>  	return container_of(vcpu, struct vcpu_tdx, vcpu);
>  }
>  #else
> +static inline int tdx_module_setup(void) { return -ENODEV; };
> +
>  struct kvm_tdx {
>  	struct kvm kvm;
>  };
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 30af2bd0b4d5..fb7a33fbc136 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11792,6 +11792,14 @@ int kvm_arch_hardware_setup(void *opaque)
>  	return 0;
>  }
> =20
> +int kvm_arch_post_hardware_enable_setup(void *opaque)
> +{
> +	struct kvm_x86_init_ops *ops =3D opaque;
> +	if (ops->post_hardware_enable_setup)
> +		return ops->post_hardware_enable_setup();
> +	return 0;
> +}
> +

Where is this kvm_arch_post_hardware_enable_setup() called?

Shouldn't the code change which calls it be part of this patch?

>  void kvm_arch_hardware_unsetup(void)
>  {
>  	kvm_unregister_perf_callbacks();

