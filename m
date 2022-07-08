Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3A8B56B0A2
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 04:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236703AbiGHCag (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 22:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiGHCaf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 22:30:35 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962DA7435B;
        Thu,  7 Jul 2022 19:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657247434; x=1688783434;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Qfe0hwBtuYqnedT3Jb3c7TgFpVkkn5l3WYf0C+Aib0Q=;
  b=DeMPWcREkEL5cMy6V0QknTMDku48mvVA6dbCE4quxcOrNUayV9YsMrID
   pk2I2FEWs4jdWbyBOjmQP3c4T2z2BnGKsEUXMNEy00JMu/LrEWfkQy+ph
   KrpLAZYm96sUrA4kcefxYiTItJ3ddL1Np+LdtsQz3kklOo68N7mwa8ESO
   7KDXsFfw6FweiOWTRinYuLRdfjb+Ym782OvhM7p6DTXTpKFqM4hS21MH0
   rTjBD+16+wAxAA2kcWNRxV1HFTdr04SeQ6iNsvtMNw46+bus4Wcf4H5+X
   Grpz9TqBmn1y+4MoOCojuWRs3v3nwun/e1k5oM43u/PKUqujRsuThtkr2
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10401"; a="267201899"
X-IronPort-AV: E=Sophos;i="5.92,254,1650956400"; 
   d="scan'208";a="267201899"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 19:30:32 -0700
X-IronPort-AV: E=Sophos;i="5.92,254,1650956400"; 
   d="scan'208";a="683514184"
Received: from pantones-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.54.208])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 19:30:30 -0700
Message-ID: <e3a689cfb487ca27ebdab681341c7af01b4132df.camel@intel.com>
Subject: Re: [PATCH v7 048/102] KVM: x86/mmu: Disallow dirty logging for x86
 TDX
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Date:   Fri, 08 Jul 2022 14:30:28 +1200
In-Reply-To: <eb806a989cd77021f38bb83fdb8c081d1379c9e5.1656366338.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <eb806a989cd77021f38bb83fdb8c081d1379c9e5.1656366338.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
> TDX doesn't support dirty logging.  Report dirty logging isn't supported =
so
> that device model, for example qemu, can properly handle it.
>=20
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>

Xiaoyao's SoB looks weird.

> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c       |  5 +++++
>  include/linux/kvm_host.h |  1 +
>  virt/kvm/kvm_main.c      | 15 ++++++++++++---
>  3 files changed, 18 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4309ef0ade21..dcd1f5e2ba05 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13164,6 +13164,11 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, =
unsigned int size,
>  }
>  EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
> =20
> +bool kvm_arch_dirty_log_supported(struct kvm *kvm)
> +{
> +	return kvm->arch.vm_type !=3D KVM_X86_TDX_VM;
> +}
> +
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 79a4988fd51f..6fd8ec297236 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1452,6 +1452,7 @@ bool kvm_arch_dy_has_pending_interrupt(struct kvm_v=
cpu *vcpu);
>  int kvm_arch_post_init_vm(struct kvm *kvm);
>  void kvm_arch_pre_destroy_vm(struct kvm *kvm);
>  int kvm_arch_create_vm_debugfs(struct kvm *kvm);
> +bool kvm_arch_dirty_log_supported(struct kvm *kvm);
> =20
>  #ifndef __KVM_HAVE_ARCH_VM_ALLOC
>  /*
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 7a5261eb7eb8..703c1d0c98da 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1467,9 +1467,18 @@ static void kvm_replace_memslot(struct kvm *kvm,
>  	}
>  }
> =20
> -static int check_memory_region_flags(const struct kvm_userspace_memory_r=
egion *mem)
> +bool __weak kvm_arch_dirty_log_supported(struct kvm *kvm)
>  {
> -	u32 valid_flags =3D KVM_MEM_LOG_DIRTY_PAGES;
> +	return true;
> +}
> +
> +static int check_memory_region_flags(struct kvm *kvm,
> +				     const struct kvm_userspace_memory_region *mem)
> +{
> +	u32 valid_flags =3D 0;
> +
> +	if (kvm_arch_dirty_log_supported(kvm))
> +		valid_flags |=3D KVM_MEM_LOG_DIRTY_PAGES;
> =20
>  #ifdef __KVM_HAVE_READONLY_MEM
>  	valid_flags |=3D KVM_MEM_READONLY;
> @@ -1871,7 +1880,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  	int as_id, id;
>  	int r;
> =20
> -	r =3D check_memory_region_flags(mem);
> +	r =3D check_memory_region_flags(kvm, mem);
>  	if (r)
>  		return r;
> =20

