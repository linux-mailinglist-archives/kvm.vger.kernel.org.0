Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6065D657263
	for <lists+kvm@lfdr.de>; Wed, 28 Dec 2022 04:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiL1Dhi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Dec 2022 22:37:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiL1Dhg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Dec 2022 22:37:36 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC8F64EF
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 19:37:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672198655; x=1703734655;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=4hQcUXsiViRjod30lQOD13w+C/qGkkiQKki5wyj2xyE=;
  b=YvGxMpWpfKKFSFhrWh/+XSR3vdedTFIIFHYQuCS1tPxYBjiffLt3piNi
   9pdtLTByXHBl3wdcKYdmnzDjad6WruJYTdxR7bZfnVroNZl00EfHGCFub
   +PHv5nlX4P8Q77lkqtRF2uIkCwXbUpC0BUk0QNssk+8cNT1HHeLSppSYj
   O1hTA/VFIQyBmAxCmSXp4wg15azbC9+VkLlkHoG59zgpbVFPvIT4OGGdr
   N72wAuY1+cUKBatmTkNlz8C6SU3P/RZakAteCC7gukbhNHRLBbhwnX7wG
   S9bdSzjXC4+o8rdVFat0ssLwTxLGJpSGm4IWp2ln3AlAF6NMgPWaowRNQ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10573"; a="300490663"
X-IronPort-AV: E=Sophos;i="5.96,280,1665471600"; 
   d="scan'208";a="300490663"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2022 19:37:30 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10573"; a="898549909"
X-IronPort-AV: E=Sophos;i="5.96,280,1665471600"; 
   d="scan'208";a="898549909"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.255.28.140]) ([10.255.28.140])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2022 19:37:29 -0800
Message-ID: <2e395a24-ee7b-e31e-981c-b83e80ac5be1@linux.intel.com>
Date:   Wed, 28 Dec 2022 11:37:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 1/9] KVM: x86: Rename cr4_reserved/rsvd_* variables to
 be more readable
To:     Robert Hoo <robert.hu@linux.intel.com>, pbonzini@redhat.com,
        seanjc@google.com, kirill.shutemov@linux.intel.com,
        kvm@vger.kernel.org
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
 <20221209044557.1496580-2-robert.hu@linux.intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20221209044557.1496580-2-robert.hu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/9/2022 12:45 PM, Robert Hoo wrote:
> kvm_vcpu_arch::cr4_guest_owned_bits and kvm_vcpu_arch::cr4_guest_rsvd_bits
> looks confusing. Rename latter to cr4_host_rsvd_bits, because it in fact
> decribes the effective host reserved cr4 bits from the vcpu's perspective.

IMO, the current name cr4_guest_rsvd_bits is OK becuase it shows that 
these bits are reserved bits from the pointview of guest.

Change to *host* is OK, but seems not easier to understand.


>
> Meanwhile, rename other related variables/macros to be better descriptive:
> * CR4_RESERVED_BITS --> CR4_HOST_RESERVED_BITS, which describes host bare
> metal CR4 reserved bits.
>
> * cr4_reserved_bits --> cr4_kvm_reserved_bits, which describes
> CR4_HOST_RESERVED_BITS + !kvm_cap_has() = kvm level cr4 reserved bits.
>
> * __cr4_reserved_bits() --> __cr4_calc_reserved_bits(), which to calc
> effective cr4 reserved bits for kvm or vm level, by corresponding
> x_cpu_has() input.
>
> Thus, by these renames, the hierarchical relations of those reserved CR4
> bits is more clear.
>
> Just renames, no functional changes intended.
>
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  4 ++--
>   arch/x86/kvm/cpuid.c            |  4 ++--
>   arch/x86/kvm/vmx/vmx.c          |  2 +-
>   arch/x86/kvm/x86.c              | 12 ++++++------
>   arch/x86/kvm/x86.h              |  4 ++--
>   5 files changed, 13 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f05ebaa26f0f..3c736e00b6b1 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -114,7 +114,7 @@
>   			  | X86_CR0_ET | X86_CR0_NE | X86_CR0_WP | X86_CR0_AM \
>   			  | X86_CR0_NW | X86_CR0_CD | X86_CR0_PG))
>   
> -#define CR4_RESERVED_BITS                                               \
> +#define CR4_HOST_RESERVED_BITS                                               \
>   	(~(unsigned long)(X86_CR4_VME | X86_CR4_PVI | X86_CR4_TSD | X86_CR4_DE\
>   			  | X86_CR4_PSE | X86_CR4_PAE | X86_CR4_MCE     \
>   			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
> @@ -671,7 +671,7 @@ struct kvm_vcpu_arch {
>   	unsigned long cr3;
>   	unsigned long cr4;
>   	unsigned long cr4_guest_owned_bits;
> -	unsigned long cr4_guest_rsvd_bits;
> +	unsigned long cr4_host_rsvd_bits;
>   	unsigned long cr8;
>   	u32 host_pkru;
>   	u32 pkru;
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index c92c49a0b35b..01e2b93ef563 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -352,8 +352,8 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
>   
>   	kvm_pmu_refresh(vcpu);
> -	vcpu->arch.cr4_guest_rsvd_bits =
> -	    __cr4_reserved_bits(guest_cpuid_has, vcpu);
> +	vcpu->arch.cr4_host_rsvd_bits =
> +	    __cr4_calc_reserved_bits(guest_cpuid_has, vcpu);
>   
>   	kvm_hv_set_cpuid(vcpu, kvm_cpuid_has_hyperv(vcpu->arch.cpuid_entries,
>   						    vcpu->arch.cpuid_nent));
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 63247c57c72c..cfa06c7c062e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4250,7 +4250,7 @@ void set_cr4_guest_host_mask(struct vcpu_vmx *vmx)
>   	struct kvm_vcpu *vcpu = &vmx->vcpu;
>   
>   	vcpu->arch.cr4_guest_owned_bits = KVM_POSSIBLE_CR4_GUEST_BITS &
> -					  ~vcpu->arch.cr4_guest_rsvd_bits;
> +					  ~vcpu->arch.cr4_host_rsvd_bits;
>   	if (!enable_ept) {
>   		vcpu->arch.cr4_guest_owned_bits &= ~X86_CR4_TLBFLUSH_BITS;
>   		vcpu->arch.cr4_guest_owned_bits &= ~X86_CR4_PDPTR_BITS;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 69227f77b201..eb1f2c20e19e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -108,7 +108,7 @@ u64 __read_mostly efer_reserved_bits = ~((u64)(EFER_SCE | EFER_LME | EFER_LMA));
>   static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
>   #endif
>   
> -static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
> +static u64 __read_mostly cr4_kvm_reserved_bits = CR4_HOST_RESERVED_BITS;
>   
>   #define KVM_EXIT_HYPERCALL_VALID_MASK (1 << KVM_HC_MAP_GPA_RANGE)
>   
> @@ -1102,10 +1102,10 @@ EXPORT_SYMBOL_GPL(kvm_emulate_xsetbv);
>   
>   bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>   {
> -	if (cr4 & cr4_reserved_bits)
> +	if (cr4 & cr4_kvm_reserved_bits)
>   		return false;
>   
> -	if (cr4 & vcpu->arch.cr4_guest_rsvd_bits)
> +	if (cr4 & vcpu->arch.cr4_host_rsvd_bits)
>   		return false;
>   
>   	return true;
> @@ -12290,7 +12290,7 @@ int kvm_arch_hardware_setup(void *opaque)
>   		kvm_caps.supported_xss = 0;
>   
>   #define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
> -	cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
> +	cr4_kvm_reserved_bits = __cr4_calc_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
>   #undef __kvm_cpu_cap_has
>   
>   	if (kvm_caps.has_tsc_control) {
> @@ -12323,8 +12323,8 @@ int kvm_arch_check_processor_compat(void *opaque)
>   
>   	WARN_ON(!irqs_disabled());
>   
> -	if (__cr4_reserved_bits(cpu_has, c) !=
> -	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
> +	if (__cr4_calc_reserved_bits(cpu_has, c) !=
> +	    __cr4_calc_reserved_bits(cpu_has, &boot_cpu_data))
>   		return -EIO;
>   
>   	return ops->check_processor_compatibility();
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 829d3134c1eb..d92e580768e5 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -452,9 +452,9 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
>   #define  KVM_MSR_RET_INVALID	2	/* in-kernel MSR emulation #GP condition */
>   #define  KVM_MSR_RET_FILTERED	3	/* #GP due to userspace MSR filter */
>   
> -#define __cr4_reserved_bits(__cpu_has, __c)             \
> +#define __cr4_calc_reserved_bits(__cpu_has, __c)             \
>   ({                                                      \
> -	u64 __reserved_bits = CR4_RESERVED_BITS;        \
> +	u64 __reserved_bits = CR4_HOST_RESERVED_BITS;        \
>                                                           \
>   	if (!__cpu_has(__c, X86_FEATURE_XSAVE))         \
>   		__reserved_bits |= X86_CR4_OSXSAVE;     \
