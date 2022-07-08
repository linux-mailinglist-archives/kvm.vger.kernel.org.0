Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7FD56B09B
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 04:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237047AbiGHCXv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 22:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236626AbiGHCXu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 22:23:50 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29CCB735BD;
        Thu,  7 Jul 2022 19:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657247029; x=1688783029;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=YqsqN2SrVfuv6H7JTipXfTopb95Qx4PZxJdW3rJY4X8=;
  b=BIx0f9QcjYMcAJYTJq9Eu5nmGGWxxQfZUXcsyIXKOkob3YyKGHVF0mku
   BN2X++5RhQHk+BTEsthYowvDchaj6R3nwqvpRrtBAmooPyoUGOnPVBZrJ
   GigF8mLUSJCVlTJIhRT02w/Hj3VDn/P2+w2xoIUh9feBJ9ofDmHHtiCo9
   5er8+N6MmT0KjPf5cnHMlXxDTz6qTtARrnc4CloTrTyk6Bt0MDHcIt836
   OivL/BU2PBd1/5hhVE1tp5gn7RNF0zYB4lwIc5c3gHf2+rU4WyKwN0E8X
   P4ZxmjNzJoILCi3fCtOkjpvT0FeweDeWjleGBWCK+F7pocfzyqDiBF1DQ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10401"; a="284192603"
X-IronPort-AV: E=Sophos;i="5.92,254,1650956400"; 
   d="scan'208";a="284192603"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 19:23:48 -0700
X-IronPort-AV: E=Sophos;i="5.92,254,1650956400"; 
   d="scan'208";a="770630670"
Received: from pantones-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.54.208])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 19:23:45 -0700
Message-ID: <52915310c9118a124da2380daf3d753a818de05e.camel@intel.com>
Subject: Re: [PATCH v7 041/102] KVM: VMX: Introduce test mode related to EPT
 violation VE
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>
Date:   Fri, 08 Jul 2022 14:23:43 +1200
In-Reply-To: <cadf3221e3f7b911c810f15cfe300dd5337a966d.1656366338.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <cadf3221e3f7b911c810f15cfe300dd5337a966d.1656366338.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>=20
> To support TDX, KVM is enhanced to operate with #VE.  For TDX, KVM progra=
ms
> to inject #VE conditionally and set #VE suppress bit in EPT entry.  For V=
MX
> case, #VE isn't used.  If #VE happens for VMX, it's a bug.  To be
> defensive (test that VMX case isn't broken), introduce option
> ept_violation_ve_test and when it's set, set error.

I don't see why we need this patch.  It may be helpful during your test, bu=
t why
do we need this patch for formal submission?

And for a normal guest, what prevents one vcpu from sending #VE IPI to anot=
her
vcpu?
=20
>=20
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/vmx.h | 12 +++++++
>  arch/x86/kvm/vmx/vmx.c     | 68 +++++++++++++++++++++++++++++++++++++-
>  arch/x86/kvm/vmx/vmx.h     |  3 ++
>  3 files changed, 82 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 6231ef005a50..f0f8eecf55ac 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -68,6 +68,7 @@
>  #define SECONDARY_EXEC_ENCLS_EXITING		VMCS_CONTROL_BIT(ENCLS_EXITING)
>  #define SECONDARY_EXEC_RDSEED_EXITING		VMCS_CONTROL_BIT(RDSEED_EXITING)
>  #define SECONDARY_EXEC_ENABLE_PML               VMCS_CONTROL_BIT(PAGE_MO=
D_LOGGING)
> +#define SECONDARY_EXEC_EPT_VIOLATION_VE		VMCS_CONTROL_BIT(EPT_VIOLATION_=
VE)
>  #define SECONDARY_EXEC_PT_CONCEAL_VMX		VMCS_CONTROL_BIT(PT_CONCEAL_VMX)
>  #define SECONDARY_EXEC_XSAVES			VMCS_CONTROL_BIT(XSAVES)
>  #define SECONDARY_EXEC_MODE_BASED_EPT_EXEC	VMCS_CONTROL_BIT(MODE_BASED_E=
PT_EXEC)
> @@ -223,6 +224,8 @@ enum vmcs_field {
>  	VMREAD_BITMAP_HIGH              =3D 0x00002027,
>  	VMWRITE_BITMAP                  =3D 0x00002028,
>  	VMWRITE_BITMAP_HIGH             =3D 0x00002029,
> +	VE_INFORMATION_ADDRESS		=3D 0x0000202A,
> +	VE_INFORMATION_ADDRESS_HIGH	=3D 0x0000202B,
>  	XSS_EXIT_BITMAP                 =3D 0x0000202C,
>  	XSS_EXIT_BITMAP_HIGH            =3D 0x0000202D,
>  	ENCLS_EXITING_BITMAP		=3D 0x0000202E,
> @@ -628,4 +631,13 @@ enum vmx_l1d_flush_state {
> =20
>  extern enum vmx_l1d_flush_state l1tf_vmx_mitigation;
> =20
> +struct vmx_ve_information {
> +	u32 exit_reason;
> +	u32 delivery;
> +	u64 exit_qualification;
> +	u64 guest_linear_address;
> +	u64 guest_physical_address;
> +	u16 eptp_index;
> +};
> +
>  #endif
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e2415ac55317..e3d304b14df0 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -126,6 +126,9 @@ module_param(error_on_inconsistent_vmcs_config, bool,=
 0444);
>  static bool __read_mostly dump_invalid_vmcs =3D 0;
>  module_param(dump_invalid_vmcs, bool, 0644);
> =20
> +static bool __read_mostly ept_violation_ve_test =3D 0;
> +module_param(ept_violation_ve_test, bool, 0444);
> +
>  #define MSR_BITMAP_MODE_X2APIC		1
>  #define MSR_BITMAP_MODE_X2APIC_APICV	2
> =20
> @@ -726,6 +729,13 @@ void vmx_update_exception_bitmap(struct kvm_vcpu *vc=
pu)
> =20
>  	eb =3D (1u << PF_VECTOR) | (1u << UD_VECTOR) | (1u << MC_VECTOR) |
>  	     (1u << DB_VECTOR) | (1u << AC_VECTOR);
> +	/*
> +	 * #VE isn't used for VMX, but for TDX.  To test against unexpected
> +	 * change related to #VE for VMX, intercept unexpected #VE and warn on
> +	 * it.
> +	 */
> +	if (ept_violation_ve_test)
> +		eb |=3D 1u << VE_VECTOR;
>  	/*
>  	 * Guest access to VMware backdoor ports could legitimately
>  	 * trigger #GP because of TSS I/O permission bitmap.
> @@ -2524,6 +2534,8 @@ static int setup_vmcs_config(struct vmcs_config *vm=
cs_conf,
>  			SECONDARY_EXEC_NOTIFY_VM_EXITING;
>  		if (cpu_has_sgx())
>  			opt2 |=3D SECONDARY_EXEC_ENCLS_EXITING;
> +		if (ept_violation_ve_test)
> +			opt2 |=3D SECONDARY_EXEC_EPT_VIOLATION_VE;
>  		if (adjust_vmx_controls(min2, opt2,
>  					MSR_IA32_VMX_PROCBASED_CTLS2,
>  					&_cpu_based_2nd_exec_control) < 0)
> @@ -2558,6 +2570,7 @@ static int setup_vmcs_config(struct vmcs_config *vm=
cs_conf,
>  			return -EIO;
> =20
>  		vmx_cap->ept =3D 0;
> +		_cpu_based_2nd_exec_control &=3D ~SECONDARY_EXEC_EPT_VIOLATION_VE;
>  	}
>  	if (!(_cpu_based_2nd_exec_control & SECONDARY_EXEC_ENABLE_VPID) &&
>  	    vmx_cap->vpid) {
> @@ -4390,6 +4403,7 @@ static u32 vmx_secondary_exec_control(struct vcpu_v=
mx *vmx)
>  		exec_control &=3D ~SECONDARY_EXEC_ENABLE_VPID;
>  	if (!enable_ept) {
>  		exec_control &=3D ~SECONDARY_EXEC_ENABLE_EPT;
> +		exec_control &=3D ~SECONDARY_EXEC_EPT_VIOLATION_VE;
>  		enable_unrestricted_guest =3D 0;
>  	}
>  	if (!enable_unrestricted_guest)
> @@ -4517,8 +4531,40 @@ static void init_vmcs(struct vcpu_vmx *vmx)
> =20
>  	exec_controls_set(vmx, vmx_exec_control(vmx));
> =20
> -	if (cpu_has_secondary_exec_ctrls())
> +	if (cpu_has_secondary_exec_ctrls()) {
>  		secondary_exec_controls_set(vmx, vmx_secondary_exec_control(vmx));
> +		if (secondary_exec_controls_get(vmx) &
> +		    SECONDARY_EXEC_EPT_VIOLATION_VE) {
> +			if (!vmx->ve_info) {
> +				/* ve_info must be page aligned. */
> +				struct page *page;
> +
> +				BUILD_BUG_ON(sizeof(*vmx->ve_info) > PAGE_SIZE);
> +				page =3D alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +				if (page)
> +					vmx->ve_info =3D page_to_virt(page);
> +			}
> +			if (vmx->ve_info) {
> +				/*
> +				 * Allow #VE delivery. CPU sets this field to
> +				 * 0xFFFFFFFF on #VE delivery.  Another #VE can
> +				 * occur only if software clears the field.
> +				 */
> +				vmx->ve_info->delivery =3D 0;
> +				vmcs_write64(VE_INFORMATION_ADDRESS,
> +					     __pa(vmx->ve_info));
> +			} else {
> +				/*
> +				 * Because SECONDARY_EXEC_EPT_VIOLATION_VE is
> +				 * used only when ept_violation_ve_test is true,
> +				 * it's okay to go with the bit disabled.
> +				 */
> +				pr_err("Failed to allocate ve_info. disabling EPT_VIOLATION_VE.\n");
> +				secondary_exec_controls_clearbit(
> +					vmx, SECONDARY_EXEC_EPT_VIOLATION_VE);
> +			}
> +		}
> +	}
> =20
>  	if (cpu_has_tertiary_exec_ctrls())
>  		tertiary_exec_controls_set(vmx, vmx_tertiary_exec_control(vmx));
> @@ -5116,7 +5162,14 @@ static int handle_exception_nmi(struct kvm_vcpu *v=
cpu)
>  		if (handle_guest_split_lock(kvm_rip_read(vcpu)))
>  			return 1;
>  		fallthrough;
> +	case VE_VECTOR:
>  	default:
> +		if (ept_violation_ve_test && ex_no =3D=3D VE_VECTOR) {
> +			pr_err("VMEXIT due to unexpected #VE.\n");
> +			secondary_exec_controls_clearbit(
> +				vmx, SECONDARY_EXEC_EPT_VIOLATION_VE);
> +			return 1;
> +		}
>  		kvm_run->exit_reason =3D KVM_EXIT_EXCEPTION;
>  		kvm_run->ex.exception =3D ex_no;
>  		kvm_run->ex.error_code =3D error_code;
> @@ -6182,6 +6235,17 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
>  	if (secondary_exec_control & SECONDARY_EXEC_ENABLE_VPID)
>  		pr_err("Virtual processor ID =3D 0x%04x\n",
>  		       vmcs_read16(VIRTUAL_PROCESSOR_ID));
> +	if (secondary_exec_control & SECONDARY_EXEC_EPT_VIOLATION_VE) {
> +		struct vmx_ve_information *ve_info;
> +		pr_err("VE info address =3D 0x%016llx\n",
> +		       vmcs_read64(VE_INFORMATION_ADDRESS));
> +		ve_info =3D __va(vmcs_read64(VE_INFORMATION_ADDRESS));
> +		pr_err("ve_info: 0x%08x 0x%08x 0x%016llx 0x%016llx 0x%016llx 0x%04x\n"=
,
> +		       ve_info->exit_reason, ve_info->delivery,
> +		       ve_info->exit_qualification,
> +		       ve_info->guest_linear_address,
> +		       ve_info->guest_physical_address, ve_info->eptp_index);
> +	}
>  }
> =20
>  /*
> @@ -7173,6 +7237,8 @@ void vmx_vcpu_free(struct kvm_vcpu *vcpu)
>  	free_vpid(vmx->vpid);
>  	nested_vmx_free_vcpu(vcpu);
>  	free_loaded_vmcs(vmx->loaded_vmcs);
> +	if (vmx->ve_info)
> +		free_page((unsigned long)vmx->ve_info);
>  }
> =20
>  int vmx_vcpu_create(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 9feb994e5ea2..60d93c38e014 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -338,6 +338,9 @@ struct vcpu_vmx {
>  		DECLARE_BITMAP(read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
>  		DECLARE_BITMAP(write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
>  	} shadow_msr_intercept;
> +
> +	/* ve_info must be page aligned. */
> +	struct vmx_ve_information *ve_info;
>  };
> =20
>  struct kvm_vmx {

