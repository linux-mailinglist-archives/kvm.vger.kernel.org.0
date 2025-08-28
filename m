Return-Path: <kvm+bounces-56121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 16A8FB3A30B
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 16:59:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E104B166490
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 14:55:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8CEE314A9F;
	Thu, 28 Aug 2025 14:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XTA0LTg8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E3A313544;
	Thu, 28 Aug 2025 14:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756392906; cv=none; b=UWGBRPmxDuXxPal8k6gAFnBW1mXEFxfsK0+MDCv/HbjyNt5Ulb5cfdJWTAOEReRfiSNcXcZ2oaCRmEjiI4yGv+xNY9enWoJNYl+BmBrwOaR8ZL/9PWe5YwLX6PAKrfJ0rJ9nMFDRrYwSpax1qP4Io82WnaoW78ndI69h6fH6NDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756392906; c=relaxed/simple;
	bh=d3tE7B5jxGTKVB3XmvI/JaTmtQGjGKp7fXnmMX1cJJ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IrU8JAOEj1PSmmy8EniNhl9IUBlCk4kvkSh3MPlAXcSQNQDa0FaKnzVLLFUfKJmbXaWmUingv8SCLhJaZ0+DcIZ6s+0eiaL3thi2XtIwnV72Sqh3yWHOqIW7cwv79ww6b2CJXdcpAHAB5gpEpoB1FByGDjN8AMK/Q3m5wVSfncg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XTA0LTg8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C95C4CEEB;
	Thu, 28 Aug 2025 14:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756392906;
	bh=d3tE7B5jxGTKVB3XmvI/JaTmtQGjGKp7fXnmMX1cJJ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XTA0LTg8oOTye1Dls1iuFoCzwMg2Ygx7Dg3GA6pxdF/spk5PY/0C3cneBfKp7555c
	 F3cashXKHe6gEn6AlYJrQulU3IIHRvE/nMVvl7ay7Bg3evYCpJTGk7XP2wRwJxrH5K
	 UXQLsNQ4PiGOpshL+kijSPKEQ7haBz5xSZdjun2QNstk18CEm+Praa7OmltY+7EgZw
	 SaWPNrB6CjVKKNi17ecN7k5+RGZT5Jqo2H7WAWimMOBL/SwKyvWDi5PHBZ7pbhcblo
	 ODf7z0Tb+z7NqOJFPURm5QIIy0b7j0jjY5AjTC9834cGC3pzHpHN5tMFC3c88pSyf1
	 2S6fZf47Ivnjw==
Date: Thu, 28 Aug 2025 17:54:56 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "david@redhat.com" <david@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"tabba@google.com" <tabba@google.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"will@kernel.org" <will@kernel.org>,
	"vbabka@suse.cz" <vbabka@suse.cz>,
	"Cali, Marco" <xmarcalx@amazon.co.uk>,
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"Thomson, Jack" <jackabt@amazon.co.uk>,
	"Manwaring, Derek" <derekmn@amazon.com>
Subject: Re: [PATCH v5 04/12] KVM: guest_memfd: Add flag to remove from
 direct map
Message-ID: <aLBtwIhQpX6AR2Z6@kernel.org>
References: <20250828093902.2719-1-roypat@amazon.co.uk>
 <20250828093902.2719-5-roypat@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828093902.2719-5-roypat@amazon.co.uk>

On Thu, Aug 28, 2025 at 09:39:21AM +0000, Roy, Patrick wrote:
> Add GUEST_MEMFD_FLAG_NO_DIRECT_MAP flag for KVM_CREATE_GUEST_MEMFD()
> ioctl. When set, guest_memfd folios will be removed from the direct map
> after preparation, with direct map entries only restored when the folios
> are freed.
> 
> To ensure these folios do not end up in places where the kernel cannot
> deal with them, set AS_NO_DIRECT_MAP on the guest_memfd's struct
> address_space if GUEST_MEMFD_FLAG_NO_DIRECT_MAP is requested.
> 
> Add KVM_CAP_GUEST_MEMFD_NO_DIRECT_MAP to let userspace discover whether
> guest_memfd supports GUEST_MEMFD_FLAG_NO_DIRECT_MAP. Support depends on
> guest_memfd itself being supported, but also on whether KVM can
> manipulate the direct map at page granularity at all (possible most of
> the time, just arm64 is a notable outlier where its impossible if the
> direct map has been setup using hugepages, as arm64 cannot break these
> apart due to break-before-make semantics).

There's also powerpc that does not select ARCH_HAS_SET_DIRECT_MAP
 
> Note that this flag causes removal of direct map entries for all
> guest_memfd folios independent of whether they are "shared" or "private"
> (although current guest_memfd only supports either all folios in the
> "shared" state, or all folios in the "private" state if
> GUEST_MEMFD_FLAG_MMAP is not set). The usecase for removing direct map
> entries of also the shared parts of guest_memfd are a special type of
> non-CoCo VM where, host userspace is trusted to have access to all of
> guest memory, but where Spectre-style transient execution attacks
> through the host kernel's direct map should still be mitigated.  In this
> setup, KVM retains access to guest memory via userspace mappings of
> guest_memfd, which are reflected back into KVM's memslots via
> userspace_addr. This is needed for things like MMIO emulation on x86_64
> to work.
> 
> Do not perform TLB flushes after direct map manipulations. This is
> because TLB flushes resulted in a up to 40x elongation of page faults in
> guest_memfd (scaling with the number of CPU cores), or a 5x elongation
> of memory population. TLB flushes are not needed for functional
> correctness (the virt->phys mapping technically stays "correct",  the
> kernel should simply to not it for a while). On the other hand, it means

                          ^ not use it?

> that the desired protection from Spectre-style attacks is not perfect,
> as an attacker could try to prevent a stale TLB entry from getting
> evicted, keeping it alive until the page it refers to is used by the
> guest for some sensitive data, and then targeting it using a
> spectre-gadget.
> 
> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
> ---
>  arch/arm64/include/asm/kvm_host.h | 12 ++++++++++++
>  include/linux/kvm_host.h          |  7 +++++++
>  include/uapi/linux/kvm.h          |  2 ++
>  virt/kvm/guest_memfd.c            | 29 +++++++++++++++++++++++++----
>  virt/kvm/kvm_main.c               |  5 +++++
>  5 files changed, 51 insertions(+), 4 deletions(-)

...
 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 9ec4c45e3cf2..e3696880405c 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -4,6 +4,7 @@
>  #include <linux/kvm_host.h>
>  #include <linux/pagemap.h>
>  #include <linux/anon_inodes.h>
> +#include <linux/set_memory.h>
>  
>  #include "kvm_mm.h"
>  
> @@ -42,8 +43,18 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
>  	return 0;
>  }
>  
> +static bool kvm_gmem_test_no_direct_map(struct inode *inode)
> +{
> +	return ((unsigned long) inode->i_private) & GUEST_MEMFD_FLAG_NO_DIRECT_MAP;
> +}
> +
>  static inline void kvm_gmem_mark_prepared(struct folio *folio)
>  {
> +	struct inode *inode = folio_inode(folio);
> +
> +	if (kvm_gmem_test_no_direct_map(inode))
> +		set_direct_map_valid_noflush(folio_page(folio, 0), folio_nr_pages(folio), false);

This may fail to split large mapping in the direct map. Why not move this
to kvm_gmem_prepare_folio() where you can handle returned error?

I think that using set_direct_map_invalid_noflush() here and
set_direct_map_default_noflush() in kvm_gmem_free_folio() better is
clearer and makes it more obvious that here the folio is removed from the
direct map and when freed it's direct mapping is restored.

This requires to export two symbols in patch 2, but I think it's worth it.

>  	folio_mark_uptodate(folio);
>  }
>  
> @@ -429,25 +440,29 @@ static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *fol
>  	return MF_DELAYED;
>  }
>  
> -#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
>  static void kvm_gmem_free_folio(struct address_space *mapping,
>  				struct folio *folio)
>  {
>  	struct page *page = folio_page(folio, 0);
> +
> +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
>  	kvm_pfn_t pfn = page_to_pfn(page);
>  	int order = folio_order(folio);
> +#endif
>  
> +	if (kvm_gmem_test_no_direct_map(mapping->host))
> +		WARN_ON_ONCE(set_direct_map_valid_noflush(page, folio_nr_pages(folio), true));

I don't think it can fail here. The direct map was split when you removed
the folio so here it will merely update the prot bits.

> +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
>  	kvm_arch_gmem_invalidate(pfn, pfn + (1ul << order));
> -}
>  #endif
> +}

Instead of moving #ifdefs into kvm_gmem_free_folio() it's better to add, say,
kvm_gmem_invalidate() and move ifdefery there or even better have a static
inline stub for !CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE case.

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 18f29ef93543..0dbfd17e1191 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -65,6 +65,7 @@
>  #include <trace/events/kvm.h>
>  
>  #include <linux/kvm_dirty_ring.h>
> +#include <linux/set_memory.h>
>  
>  
>  /* Worst case buffer size needed for holding an integer. */
> @@ -4916,6 +4917,10 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>  		return kvm_supported_mem_attributes(kvm);
>  #endif
>  #ifdef CONFIG_KVM_GUEST_MEMFD
> +	case KVM_CAP_GUEST_MEMFD_NO_DIRECT_MAP:
> +		if (!can_set_direct_map())

Shouldn't this check with kvm_arch_gmem_supports_no_direct_map()?

> +			return false;
> +		fallthrough;
>  	case KVM_CAP_GUEST_MEMFD:
>  		return 1;
>  	case KVM_CAP_GUEST_MEMFD_MMAP:
> -- 
> 2.50.1
> 

-- 
Sincerely yours,
Mike.

