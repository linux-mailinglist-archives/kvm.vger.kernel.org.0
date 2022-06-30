Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A66E5561A4D
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 14:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbiF3M1b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 08:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234428AbiF3M13 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 08:27:29 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985472E093;
        Thu, 30 Jun 2022 05:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656592048; x=1688128048;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=xglr6z6rG58iyrwjggW9uB/gwlKhg1Fwzpc6u5yhoCk=;
  b=l0s3yoit+CIsC+f0sf85B/qbFjmPodTdWC3Pv9JoHk9KqZxIuGY2eNA/
   bnEI7f2NUhzVH43oEpiaAv1C/oht1jJoqEDk00fDS72wsIclyrbEMWvap
   PRszqIh+d3f5HeaRm9dnOd8qrA8ymol9908dp8hdXTbRG0nR63ZJZzbiN
   0g0lhTL5Chi7VIA7Hxvd27olmIR5zPHW0/aYNdb5gEodajGgDTr4Idc7O
   vFWYnXkKw/TQu+aNZYMcs81s7bhIR6I+kUi3LX0wGxHatrBnfdeiVxLcv
   SYxFZ3zjyjzq+bAjet0tdNw2OzL6hr1M+LZYg1TCq0PsOsPA8p+hSmXGS
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10393"; a="265367605"
X-IronPort-AV: E=Sophos;i="5.92,234,1650956400"; 
   d="scan'208";a="265367605"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 05:27:28 -0700
X-IronPort-AV: E=Sophos;i="5.92,234,1650956400"; 
   d="scan'208";a="565835847"
Received: from zhihuich-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.49.124])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 05:27:26 -0700
Message-ID: <8227079db11c0473f1c368b305e40a94a73fc109.camel@intel.com>
Subject: Re: [PATCH v7 039/102] KVM: x86/mmu: Allow per-VM override of the
 TDP max page level
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Date:   Fri, 01 Jul 2022 00:27:24 +1200
In-Reply-To: <e686602e7b57ed0c3600c663d03a9bf76190db0c.1656366338.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <e686602e7b57ed0c3600c663d03a9bf76190db0c.1656366338.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>=20
> TODO: This is a transient workaround patch until the large page support f=
or
> TDX is implemented.  Support large page for TDX and remove this patch.

I don't understand.  How does this patch have anything to do with what you =
are
talking about here?

If you want to remove this patch later, then why not just explain the reaso=
n to
remove when you actually have that patch?

>=20
> At this point, large page for TDX isn't supported, and need to allow gues=
t
> TD to work only with 4K pages.  On the other hand, conventional VMX VMs
> should continue to work with large page.  Allow per-VM override of the TD=
P
> max page level.

At which point/previous patch have you made/declared "large page for TDX is=
n't
supported"?

If you want to declare you don't want to support large page for TDX, IMHO j=
ust
declare it here, for instance:

"For simplicity, only support 4K page for TD guest."
 =20
>=20
> In the existing x86 KVM MMU code, there is already max_level member in
> struct kvm_page_fault with KVM_MAX_HUGEPAGE_LEVEL initial value.  The KVM
> page fault handler denies page size larger than max_level.
>=20
> Add per-VM member to indicate the allowed maximum page size with
> KVM_MAX_HUGEPAGE_LEVEL as default value and initialize max_level in struc=
t
> kvm_page_fault with it.  For the guest TD, the set per-VM value for allow=
s
> maximum page size to 4K page size.  Then only allowed page size is 4K.  I=
t
> means large page is disabled.

To me it's overcomplicated.  You just need simple sentences for such simple
infrastructural patch.  For instance:

"TDX requires special handling to support large private page.  For simplici=
ty,
only support 4K page for TD guest for now.  Add per-VM maximum page level
support to support different maximum page sizes for TD guest and convention=
al
VMX guest."

Just for your reference.

>=20
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/mmu/mmu.c          | 1 +
>  arch/x86/kvm/mmu/mmu_internal.h | 2 +-
>  3 files changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 39215daa8576..f4d4ed41641b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1146,6 +1146,7 @@ struct kvm_arch {
>  	unsigned long n_requested_mmu_pages;
>  	unsigned long n_max_mmu_pages;
>  	unsigned int indirect_shadow_pages;
> +	int tdp_max_page_level;
>  	u8 mmu_valid_gen;
>  	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
>  	struct list_head active_mmu_pages;
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e0aa5ad3931d..80d7c7709af3 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5878,6 +5878,7 @@ int kvm_mmu_init_vm(struct kvm *kvm)
>  	node->track_write =3D kvm_mmu_pte_write;
>  	node->track_flush_slot =3D kvm_mmu_invalidate_zap_pages_in_memslot;
>  	kvm_page_track_register_notifier(kvm, node);
> +	kvm->arch.tdp_max_page_level =3D KVM_MAX_HUGEPAGE_LEVEL;
>  	kvm_mmu_set_mmio_spte_mask(kvm, shadow_default_mmio_mask,
>  				   shadow_default_mmio_mask,
>  				   ACC_WRITE_MASK | ACC_USER_MASK);
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_inter=
nal.h
> index bd2a26897b97..44a04fad4bed 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -244,7 +244,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vc=
pu *vcpu, gpa_t cr2_or_gpa,
>  		.is_tdp =3D likely(vcpu->arch.mmu->page_fault =3D=3D kvm_tdp_page_faul=
t),
>  		.nx_huge_page_workaround_enabled =3D is_nx_huge_page_enabled(),
> =20
> -		.max_level =3D KVM_MAX_HUGEPAGE_LEVEL,
> +		.max_level =3D vcpu->kvm->arch.tdp_max_page_level,
>  		.req_level =3D PG_LEVEL_4K,
>  		.goal_level =3D PG_LEVEL_4K,
>  	};

