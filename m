Return-Path: <kvm+bounces-1451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 971BA7E7915
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 07:17:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CEE5EB21012
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 06:17:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FF5B6121;
	Fri, 10 Nov 2023 06:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="jPWd1wPt"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC165682
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 06:17:15 +0000 (UTC)
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392AE5BB8;
	Thu,  9 Nov 2023 22:17:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1699596544;
	bh=5G9rtOiPMLhKQC5AIoNpGhSA0wYcSeHiXqfSAm3ZoEA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=jPWd1wPtNR/qo1bW493+Y7HQLJJGTd8Ft9ERkOPvVPie4/IBDR0Ph0z8yv6UbMWoe
	 2easmJmn0g37TC1QS3WnUf5N0Xteevrdtjq3mnKYcSHXbgTbeNc+Z0iBU8bcp2wdZa
	 iiEnHEo+GmvMi8nSVeZTwRMl9BoaS3HWGA252ZrquAXlRkgOZZXDfXoEylN+JwuMoy
	 rKrTqdOqHLvXUTkdJY5exTmN2E7S41FmYxNmFrWLyQ/4Y71WnjUFmubxy1ghF2XNLj
	 Z3suZ1pGDoaPy4ESbv+ZjYw5vibsZ+V9WAItUVYtJGqQ0Ke4jdre6OK1T+RYsV2fbU
	 PwnMp45Q/XGlA==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4SRT0r49trz4xPQ;
	Fri, 10 Nov 2023 17:09:00 +1100 (AEDT)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Borislav Petkov <bp@alien8.de>, Catalin
 Marinas <catalin.marinas@arm.com>, Christophe Leroy
 <christophe.leroy@csgroup.eu>, Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, Janosch Frank
 <frankja@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens
 <hca@linux.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>, James Morse <james.morse@arm.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, Marc Zyngier <maz@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Nicholas Piggin <npiggin@gmail.com>, Oliver Upton
 <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, Sven
 Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Will
 Deacon <will@kernel.org>, x86@kernel.org, Zenghui Yu
 <yuzenghui@huawei.com>
Subject: Ping? Re: [PATCH rc] kvm: Prevent compiling virt/kvm/vfio.c unless
 VFIO is selected
In-Reply-To: <0-v1-08396538817d+13c5-vfio_kvm_kconfig_jgg@nvidia.com>
References: <0-v1-08396538817d+13c5-vfio_kvm_kconfig_jgg@nvidia.com>
Date: Fri, 10 Nov 2023 17:08:55 +1100
Message-ID: <87edgy87ig.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Jason Gunthorpe <jgg@nvidia.com> writes:
> There are a bunch of reported randconfig failures now because of this,
> something like:
>
>>> arch/powerpc/kvm/../../../virt/kvm/vfio.c:89:7: warning: attribute declaration must precede definition [-Wignored-attributes]
>            fn = symbol_get(vfio_file_iommu_group);
>                 ^
>    include/linux/module.h:805:60: note: expanded from macro 'symbol_get'
>    #define symbol_get(x) ({ extern typeof(x) x __attribute__((weak,visibility("hidden"))); &(x); })
>
> It happens because the arch forces KVM_VFIO without knowing if VFIO is
> even enabled.

This is still breaking some builds. Can we get this fix in please?

cheers

> Split the kconfig so the arch selects the usual HAVE_KVM_ARCH_VFIO and
> then KVM_VFIO is only enabled if the arch wants it and VFIO is turned on.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202308251949.5IiaV0sz-lkp@intel.com/
> Closes: https://lore.kernel.org/oe-kbuild-all/202309030741.82aLACDG-lkp@intel.com/
> Closes: https://lore.kernel.org/oe-kbuild-all/202309110914.QLH0LU6L-lkp@intel.com/
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Fixes: c1cce6d079b8 ("vfio: Compile vfio_group infrastructure optionally")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  arch/arm64/kvm/Kconfig   | 2 +-
>  arch/powerpc/kvm/Kconfig | 2 +-
>  arch/s390/kvm/Kconfig    | 2 +-
>  arch/x86/kvm/Kconfig     | 2 +-
>  virt/kvm/Kconfig         | 7 ++++++-
>  5 files changed, 10 insertions(+), 5 deletions(-)
>
> Sean's large series will also address this:
>
> https://lore.kernel.org/kvm/20230916003118.2540661-7-seanjc@google.com/
>
> I don't know if it is sever enough to fix in the rc cycle, but here is the
> patch.
>
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 83c1e09be42e5b..7c43eaea51ce05 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -28,7 +28,7 @@ menuconfig KVM
>  	select KVM_MMIO
>  	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
>  	select KVM_XFER_TO_GUEST_WORK
> -	select KVM_VFIO
> +	select HAVE_KVM_ARCH_VFIO
>  	select HAVE_KVM_EVENTFD
>  	select HAVE_KVM_IRQFD
>  	select HAVE_KVM_DIRTY_RING_ACQ_REL
> diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
> index 902611954200df..b64824e4cbc1eb 100644
> --- a/arch/powerpc/kvm/Kconfig
> +++ b/arch/powerpc/kvm/Kconfig
> @@ -22,7 +22,7 @@ config KVM
>  	select PREEMPT_NOTIFIERS
>  	select HAVE_KVM_EVENTFD
>  	select HAVE_KVM_VCPU_ASYNC_IOCTL
> -	select KVM_VFIO
> +	select HAVE_KVM_ARCH_VFIO
>  	select IRQ_BYPASS_MANAGER
>  	select HAVE_KVM_IRQ_BYPASS
>  	select INTERVAL_TREE
> diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
> index 45fdf2a9b2e326..d206ad3a777d5d 100644
> --- a/arch/s390/kvm/Kconfig
> +++ b/arch/s390/kvm/Kconfig
> @@ -31,7 +31,7 @@ config KVM
>  	select HAVE_KVM_IRQ_ROUTING
>  	select HAVE_KVM_INVALID_WAKEUPS
>  	select HAVE_KVM_NO_POLL
> -	select KVM_VFIO
> +	select HAVE_KVM_ARCH_VFIO
>  	select INTERVAL_TREE
>  	select MMU_NOTIFIER
>  	help
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index ed90f148140dfe..8e70e693f90e30 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -45,7 +45,7 @@ config KVM
>  	select HAVE_KVM_NO_POLL
>  	select KVM_XFER_TO_GUEST_WORK
>  	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
> -	select KVM_VFIO
> +	select HAVE_KVM_ARCH_VFIO
>  	select INTERVAL_TREE
>  	select HAVE_KVM_PM_NOTIFIER if PM
>  	select KVM_GENERIC_HARDWARE_ENABLING
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 484d0873061ca5..0bf34809e1bbfe 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -59,9 +59,14 @@ config HAVE_KVM_MSI
>  config HAVE_KVM_CPU_RELAX_INTERCEPT
>         bool
>  
> -config KVM_VFIO
> +config HAVE_KVM_ARCH_VFIO
>         bool
>  
> +config KVM_VFIO
> +       def_bool y
> +       depends on HAVE_KVM_ARCH_VFIO
> +       depends on VFIO
> +
>  config HAVE_KVM_INVALID_WAKEUPS
>         bool
>  
>
> base-commit: 0bb80ecc33a8fb5a682236443c1e740d5c917d1d
> -- 
> 2.42.0

