Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49378658871
	for <lists+kvm@lfdr.de>; Thu, 29 Dec 2022 02:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbiL2BmZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Dec 2022 20:42:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232846AbiL2BmN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Dec 2022 20:42:13 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF8CF030
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 17:42:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672278132; x=1703814132;
  h=message-id:subject:from:to:date:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=IU9xvRv2s3+FvQYQosh5SnMf9o5sKuj1hmUedpGz3dY=;
  b=GR8zld6s7fxT2GGbhiqv07ndCybwGNWFepic0OIDKfmH6sT/8icqe7ZC
   ea6Ih+o2IV8Io+7oKuEkSWLqr6HB3rTGlL207I51g5eKtokRYVWn0QagB
   h/wyIjLb8cyEhbPCPAA2Tko2nLDb3G84ExXx48M/6rSctH1P8+gxAQTwv
   WM+uEoI+dSNLTkTEJ25UHWpUMkLAIsPsjGmlZ5na9a4hlSJRPVd1w+a2h
   hFwsdcuNLv9TPdUWag7r6vTYpnnZNgpAomMS8F3yipZ1zz/2dhs6kfgR3
   9yq6Xadg0dU3SEJU9kTEZ1u+cbUeGdQ8l1V/pgnK1Sa4akaX6+Kx1K6IW
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10574"; a="383260805"
X-IronPort-AV: E=Sophos;i="5.96,282,1665471600"; 
   d="scan'208";a="383260805"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2022 17:42:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10574"; a="655461775"
X-IronPort-AV: E=Sophos;i="5.96,282,1665471600"; 
   d="scan'208";a="655461775"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga007.fm.intel.com with ESMTP; 28 Dec 2022 17:42:10 -0800
Message-ID: <b8f8f8acb6348ad5789fc1df6a6c18b0fa5f91ee.camel@linux.intel.com>
Subject: Re: [PATCH v3 1/9] KVM: x86: Rename cr4_reserved/rsvd_* variables
 to be more readable
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>, pbonzini@redhat.com,
        seanjc@google.com, kirill.shutemov@linux.intel.com,
        kvm@vger.kernel.org
Date:   Thu, 29 Dec 2022 09:42:09 +0800
In-Reply-To: <2e395a24-ee7b-e31e-981c-b83e80ac5be1@linux.intel.com>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
         <20221209044557.1496580-2-robert.hu@linux.intel.com>
         <2e395a24-ee7b-e31e-981c-b83e80ac5be1@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-12-28 at 11:37 +0800, Binbin Wu wrote:
> On 12/9/2022 12:45 PM, Robert Hoo wrote:
> > kvm_vcpu_arch::cr4_guest_owned_bits and
> > kvm_vcpu_arch::cr4_guest_rsvd_bits
> > looks confusing. Rename latter to cr4_host_rsvd_bits, because it in
> > fact
> > decribes the effective host reserved cr4 bits from the vcpu's
> > perspective.
> 
> IMO, the current name cr4_guest_rsvd_bits is OK becuase it shows
> that 
> these bits are reserved bits from the pointview of guest.

Actually, it's cr4_guest_owned_bits that from the perspective of guest.

> 
cr4_guest_owned_bits and cr4_guest_rsvd_bits together looks quite
confusing. The first looks like "guest owns these CR4 bits"; the latter
looks like "guest reserved these bits". My first response of the seeing
is: hey, what's difference between guest owns and guest reserves?

Then take a look at their calculations, we'll find that
cr4_guest_owned_bits comes from cr4_guest_rsvd_bits, and coarsely "~"
relationship.

vcpu->arch.cr4_guest_owned_bits = KVM_POSSIBLE_CR4_GUEST_BITS &
			~vcpu->arch.cr4_guest_rsvd_bits;

Those set bits in cr4_guest_owned_bits means guest owns;
Those set bits in cr4_guest_rsvd_bits means HOST owns. So the ~
calculation is naturally explained.

The more hierarchical relationships among these macros/structure
elements surrounding CR4 virtualization, can be found below.

(P.S. more story: this isn't the first time I dig into these code. I
had got clear on their relationship long ago, but when I come to it
this time, I got confused by the name again. Therefore, I would rather
cook this patch now to avoid next time;-))

> Change to *host* is OK, but seems not easier to understand.
> 
Perhaps "host_reserved" isn't the best name, welcome other suggestions.
But guest_own v.s. guest_rsvd, is really confusing, or even misleading.
> 
> > 
> > Meanwhile, rename other related variables/macros to be better
> > descriptive:
> > * CR4_RESERVED_BITS --> CR4_HOST_RESERVED_BITS, which describes
> > host bare
> > metal CR4 reserved bits.
> > 
> > * cr4_reserved_bits --> cr4_kvm_reserved_bits, which describes
> > CR4_HOST_RESERVED_BITS + !kvm_cap_has() = kvm level cr4 reserved
> > bits.
> > 
> > * __cr4_reserved_bits() --> __cr4_calc_reserved_bits(), which to
> > calc
> > effective cr4 reserved bits for kvm or vm level, by corresponding
> > x_cpu_has() input.
> > 
> > Thus, by these renames, the hierarchical relations of those
> > reserved CR4
> > bits is more clear.
> > 
> > Just renames, no functional changes intended.
> > 
> > Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> > ---
> >   arch/x86/include/asm/kvm_host.h |  4 ++--
> >   arch/x86/kvm/cpuid.c            |  4 ++--
> >   arch/x86/kvm/vmx/vmx.c          |  2 +-
> >   arch/x86/kvm/x86.c              | 12 ++++++------
> >   arch/x86/kvm/x86.h              |  4 ++--
> >   5 files changed, 13 insertions(+), 13 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h
> > b/arch/x86/include/asm/kvm_host.h
> > index f05ebaa26f0f..3c736e00b6b1 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -114,7 +114,7 @@
> >   			  | X86_CR0_ET | X86_CR0_NE | X86_CR0_WP |
> > X86_CR0_AM \
> >   			  | X86_CR0_NW | X86_CR0_CD | X86_CR0_PG))
> >   
> > -#define
> > CR4_RESERVED_BITS                                               \
> > +#define
> > CR4_HOST_RESERVED_BITS                                             
> >   \
> >   	(~(unsigned long)(X86_CR4_VME | X86_CR4_PVI | X86_CR4_TSD |
> > X86_CR4_DE\
> >   			  | X86_CR4_PSE | X86_CR4_PAE |
> > X86_CR4_MCE     \
> >   			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR
> > | X86_CR4_PCIDE \
> > @@ -671,7 +671,7 @@ struct kvm_vcpu_arch {
> >   	unsigned long cr3;
> >   	unsigned long cr4;
> >   	unsigned long cr4_guest_owned_bits;
> > -	unsigned long cr4_guest_rsvd_bits;
> > +	unsigned long cr4_host_rsvd_bits;
> >   	unsigned long cr8;
> >   	u32 host_pkru;
> >   	u32 pkru;
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index c92c49a0b35b..01e2b93ef563 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -352,8 +352,8 @@ static void kvm_vcpu_after_set_cpuid(struct
> > kvm_vcpu *vcpu)
> >   	vcpu->arch.reserved_gpa_bits =
> > kvm_vcpu_reserved_gpa_bits_raw(vcpu);
> >   
> >   	kvm_pmu_refresh(vcpu);
> > -	vcpu->arch.cr4_guest_rsvd_bits =
> > -	    __cr4_reserved_bits(guest_cpuid_has, vcpu);
> > +	vcpu->arch.cr4_host_rsvd_bits =
> > +	    __cr4_calc_reserved_bits(guest_cpuid_has, vcpu);
> >   
> >   	kvm_hv_set_cpuid(vcpu, kvm_cpuid_has_hyperv(vcpu-
> > >arch.cpuid_entries,
> >   						    vcpu-
> > >arch.cpuid_nent));
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 63247c57c72c..cfa06c7c062e 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -4250,7 +4250,7 @@ void set_cr4_guest_host_mask(struct vcpu_vmx
> > *vmx)
> >   	struct kvm_vcpu *vcpu = &vmx->vcpu;
> >   
> >   	vcpu->arch.cr4_guest_owned_bits = KVM_POSSIBLE_CR4_GUEST_BITS &
> > -					  ~vcpu-
> > >arch.cr4_guest_rsvd_bits;
> > +					  ~vcpu-
> > >arch.cr4_host_rsvd_bits;
> >   	if (!enable_ept) {
> >   		vcpu->arch.cr4_guest_owned_bits &=
> > ~X86_CR4_TLBFLUSH_BITS;
> >   		vcpu->arch.cr4_guest_owned_bits &= ~X86_CR4_PDPTR_BITS;
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 69227f77b201..eb1f2c20e19e 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -108,7 +108,7 @@ u64 __read_mostly efer_reserved_bits =
> > ~((u64)(EFER_SCE | EFER_LME | EFER_LMA));
> >   static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
> >   #endif
> >   
> > -static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
> > +static u64 __read_mostly cr4_kvm_reserved_bits =
> > CR4_HOST_RESERVED_BITS;
> >   
> >   #define KVM_EXIT_HYPERCALL_VALID_MASK (1 << KVM_HC_MAP_GPA_RANGE)
> >   
> > @@ -1102,10 +1102,10 @@ EXPORT_SYMBOL_GPL(kvm_emulate_xsetbv);
> >   
> >   bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
> >   {
> > -	if (cr4 & cr4_reserved_bits)
> > +	if (cr4 & cr4_kvm_reserved_bits)
> >   		return false;
> >   
> > -	if (cr4 & vcpu->arch.cr4_guest_rsvd_bits)
> > +	if (cr4 & vcpu->arch.cr4_host_rsvd_bits)
> >   		return false;
> >   
> >   	return true;
> > @@ -12290,7 +12290,7 @@ int kvm_arch_hardware_setup(void *opaque)
> >   		kvm_caps.supported_xss = 0;
> >   
> >   #define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
> > -	cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has,
> > UNUSED_);
> > +	cr4_kvm_reserved_bits =
> > __cr4_calc_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
> >   #undef __kvm_cpu_cap_has
> >   
> >   	if (kvm_caps.has_tsc_control) {
> > @@ -12323,8 +12323,8 @@ int kvm_arch_check_processor_compat(void
> > *opaque)
> >   
> >   	WARN_ON(!irqs_disabled());
> >   
> > -	if (__cr4_reserved_bits(cpu_has, c) !=
> > -	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
> > +	if (__cr4_calc_reserved_bits(cpu_has, c) !=
> > +	    __cr4_calc_reserved_bits(cpu_has, &boot_cpu_data))
> >   		return -EIO;
> >   
> >   	return ops->check_processor_compatibility();
> > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > index 829d3134c1eb..d92e580768e5 100644
> > --- a/arch/x86/kvm/x86.h
> > +++ b/arch/x86/kvm/x86.h
> > @@ -452,9 +452,9 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32
> > index, u32 type);
> >   #define  KVM_MSR_RET_INVALID	2	/* in-kernel MSR emulation
> > #GP condition */
> >   #define  KVM_MSR_RET_FILTERED	3	/* #GP due to userspace MSR
> > filter */
> >   
> > -#define __cr4_reserved_bits(__cpu_has, __c)             \
> > +#define __cr4_calc_reserved_bits(__cpu_has, __c)             \
> >   ({                                                      \
> > -	u64 __reserved_bits = CR4_RESERVED_BITS;        \
> > +	u64 __reserved_bits = CR4_HOST_RESERVED_BITS;        \
> >                                                           \
> >   	if (!__cpu_has(__c, X86_FEATURE_XSAVE))         \
> >   		__reserved_bits |= X86_CR4_OSXSAVE;     \

