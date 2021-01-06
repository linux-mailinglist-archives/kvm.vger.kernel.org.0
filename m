Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3D82EC408
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 20:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbhAFTgY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 14:36:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:28620 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726948AbhAFTgY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 14:36:24 -0500
IronPort-SDR: 9YrBM8NuNINrlDldU/QYTTBbnqg8kYuK6CM7ifp9xp8cRSj12xocl4xdYHESirY5cc/KJ/ffCB
 M3A6gtK4T8hg==
X-IronPort-AV: E=McAfee;i="6000,8403,9856"; a="195876073"
X-IronPort-AV: E=Sophos;i="5.79,327,1602572400"; 
   d="scan'208";a="195876073"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 11:35:43 -0800
IronPort-SDR: xnvL6pKAge/ZJYz3mKnjHLQQiRp4SdwybjREDd1cfzvMrAfmH2WKsrjhYjAaIISE77U7RDGXKK
 OHksVEfYou5Q==
X-IronPort-AV: E=Sophos;i="5.79,327,1602572400"; 
   d="scan'208";a="422287140"
Received: from jmonroe1-mobl2.amr.corp.intel.com (HELO [10.212.12.85]) ([10.212.12.85])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 11:35:41 -0800
Subject: Re: [RFC PATCH 03/23] x86/sgx: Introduce virtual EPC for use by KVM
 guests
To:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
References: <cover.1609890536.git.kai.huang@intel.com>
 <ace9d4cb10318370f6145aaced0cfa73dda36477.1609890536.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
 z5cecg==
Message-ID: <2e424ff3-51cb-d6ed-6c5f-190e1d4fe21a@intel.com>
Date:   Wed, 6 Jan 2021 11:35:41 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ace9d4cb10318370f6145aaced0cfa73dda36477.1609890536.git.kai.huang@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/5/21 5:55 PM, Kai Huang wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Add a misc device /dev/sgx_virt_epc to allow userspace to allocate "raw"
> EPC without an associated enclave.  The intended and only known use case
> for raw EPC allocation is to expose EPC to a KVM guest, hence the
> virt_epc moniker, virt.{c,h} files and X86_SGX_VIRTUALIZATION Kconfig.
> 
> Modify sgx_init() to always try to initialize virtual EPC driver, even
> when SGX driver is disabled due to SGX Launch Control is in locked mode,
> or not present at all, since SGX virtualization allows to expose SGX to
> guests that support non-LC configurations.

The grammar here is a bit off.  Here's a rewrite:

Modify sgx_init() to always try to initialize the virtual EPC driver,
even if the bare-metal SGX driver is disabled.  The bare-metal driver
might be disabled if SGX Launch Control is in locked mode, or not
supported in the hardware at all.  This allows (non-Linux) guests that
support non-LC configurations to use SGX.


> diff --git a/arch/x86/kernel/cpu/sgx/Makefile b/arch/x86/kernel/cpu/sgx/Makefile
> index 91d3dc784a29..7a25bf63adfb 100644
> --- a/arch/x86/kernel/cpu/sgx/Makefile
> +++ b/arch/x86/kernel/cpu/sgx/Makefile
> @@ -3,3 +3,4 @@ obj-y += \
>  	encl.o \
>  	ioctl.o \
>  	main.o
> +obj-$(CONFIG_X86_SGX_VIRTUALIZATION)	+= virt.o
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 95aad183bb65..02993a327a1f 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -9,9 +9,11 @@
>  #include <linux/sched/mm.h>
>  #include <linux/sched/signal.h>
>  #include <linux/slab.h>
> +#include "arch.h"
>  #include "driver.h"
>  #include "encl.h"
>  #include "encls.h"
> +#include "virt.h"
>  
>  struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
>  static int sgx_nr_epc_sections;
> @@ -726,7 +728,8 @@ static void __init sgx_init(void)
>  	if (!sgx_page_reclaimer_init())
>  		goto err_page_cache;
>  
> -	ret = sgx_drv_init();
> +	/* Success if the native *or* virtual EPC driver initialized cleanly. */
> +	ret = !!sgx_drv_init() & !!sgx_virt_epc_init();
>  	if (ret)
>  		goto err_kthread;

FWIW, I hate that conditional.  But, I tried to write to to be something
more sane and failed.

> diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
> new file mode 100644
> index 000000000000..d625551ccf25
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/sgx/virt.c
> @@ -0,0 +1,263 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*  Copyright(c) 2016-20 Intel Corporation. */
> +
> +#include <linux/miscdevice.h>
> +#include <linux/mm.h>
> +#include <linux/mman.h>
> +#include <linux/sched/mm.h>
> +#include <linux/sched/signal.h>
> +#include <linux/slab.h>
> +#include <linux/xarray.h>
> +#include <asm/sgx.h>
> +#include <uapi/asm/sgx.h>
> +
> +#include "encls.h"
> +#include "sgx.h"
> +#include "virt.h"
> +
> +struct sgx_virt_epc {
> +	struct xarray page_array;
> +	struct mutex lock;
> +	struct mm_struct *mm;
> +};
> +
> +static struct mutex virt_epc_lock;
> +static struct list_head virt_epc_zombie_pages;

What does the lock protect?

What are zombie pages?

BTW, if zombies are SECS-only, shouldn't that be in the name rather than
"epc"?

> +static int __sgx_virt_epc_fault(struct sgx_virt_epc *epc,
> +				struct vm_area_struct *vma, unsigned long addr)
> +{
> +	struct sgx_epc_page *epc_page;
> +	unsigned long index, pfn;
> +	int ret;
> +
> +	/* epc->lock must already have been hold */

	/* epc->lock must already be held */

Wouldn't this be better as:

WARN_ON(!mutex_is_locked(&epc->lock));

?


> +	/* Calculate index of EPC page in virtual EPC's page_array */
> +	index = vma->vm_pgoff + PFN_DOWN(addr - vma->vm_start);
> +
> +	epc_page = xa_load(&epc->page_array, index);
> +	if (epc_page)
> +		return 0;
> +
> +	epc_page = sgx_alloc_epc_page(epc, false);
> +	if (IS_ERR(epc_page))
> +		return PTR_ERR(epc_page);
> +
> +	ret = xa_err(xa_store(&epc->page_array, index, epc_page, GFP_KERNEL));
> +	if (ret)
> +		goto err_free;
> +
> +	pfn = PFN_DOWN(sgx_get_epc_phys_addr(epc_page));
> +
> +	ret = vmf_insert_pfn(vma, addr, pfn);
> +	if (ret != VM_FAULT_NOPAGE) {
> +		ret = -EFAULT;
> +		goto err_delete;
> +	}
> +
> +	return 0;
> +
> +err_delete:
> +	xa_erase(&epc->page_array, index);
> +err_free:
> +	sgx_free_epc_page(epc_page);
> +	return ret;
> +}
> +
> +static vm_fault_t sgx_virt_epc_fault(struct vm_fault *vmf)
> +{
> +	struct vm_area_struct *vma = vmf->vma;
> +	struct sgx_virt_epc *epc = vma->vm_private_data;
> +	int ret;
> +
> +	mutex_lock(&epc->lock);
> +	ret = __sgx_virt_epc_fault(epc, vma, vmf->address);
> +	mutex_unlock(&epc->lock);
> +
> +	if (!ret)
> +		return VM_FAULT_NOPAGE;
> +
> +	if (ret == -EBUSY && (vmf->flags & FAULT_FLAG_ALLOW_RETRY)) {
> +		mmap_read_unlock(vma->vm_mm);
> +		return VM_FAULT_RETRY;
> +	}
> +
> +	return VM_FAULT_SIGBUS;
> +}
> +
> +const struct vm_operations_struct sgx_virt_epc_vm_ops = {
> +	.fault = sgx_virt_epc_fault,
> +};
> +
> +static int sgx_virt_epc_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct sgx_virt_epc *epc = file->private_data;
> +
> +	if (!(vma->vm_flags & VM_SHARED))
> +		return -EINVAL;
> +
> +	/*
> +	 * Don't allow mmap() from child after fork(), since child and parent
> +	 * cannot map to the same EPC.
> +	 */
> +	if (vma->vm_mm != epc->mm)
> +		return -EINVAL;

I mentioned this below, but I'm not buying this logic.  I know it would
be *bad*, but I don't see why the kernel needs to keep it from happening.

> +	vma->vm_ops = &sgx_virt_epc_vm_ops;
> +	/* Don't copy VMA in fork() */
> +	vma->vm_flags |= VM_PFNMAP | VM_IO | VM_DONTDUMP | VM_DONTCOPY;
> +	vma->vm_private_data = file->private_data;
> +
> +	return 0;
> +}
> +
> +static int sgx_virt_epc_free_page(struct sgx_epc_page *epc_page)
> +{
> +	int ret;
> +
> +	if (!epc_page)
> +		return 0;

I always worry about these.  Why is passing NULL around OK?

> +	/*
> +	 * Explicitly EREMOVE virtual EPC page. Virtual EPC is only used by
> +	 * guest, and in normal condition guest should have done EREMOVE for
> +	 * all EPC pages before they are freed here. But it's possible guest
> +	 * is killed or crashed unnormally in which case EREMOVE has not been
	
				"abnormally"

I don't think "unnormally" is a word.  Also, this isn't just about
crashing or being killed.  The guest could simply have a bug.

> +	 * done. Do EREMOVE unconditionally here to cover both cases, because
> +	 * it's not possible to tell whether guest has done EREMOVE, since
> +	 * virtual EPC page status is not tracked. And it is fine to EREMOVE
> +	 * EPC page multiple times.
> +	 */

Surprise!  I dislike this comment.

	/*
	 * Take a previously guest-owned EPC page and return it to the
	 * general EPC page pool.
	 *
	 * Guests can not be trusted to have left this page in a good
	 * state, so run EREMOVE on the page unconditionally.  In the
	 * case that a guest properly EREMOVE'd this page, a
	 * superfluous EREMOVE is harmless.
	 */

> +	ret = __eremove(sgx_get_epc_virt_addr(epc_page));
> +	if (ret) {
> +		/*
> +		 * Only SGX_CHILD_PRESENT is expected, which is because of
> +		 * EREMOVE-ing an SECS still with child, in which case it can
> +		 * be handled by EREMOVE-ing the SECS again after all pages in
> +		 * virtual EPC have been EREMOVE-ed. See comments in below in
> +		 * sgx_virt_epc_release().
> +		 */
> +		WARN_ON_ONCE(ret != SGX_CHILD_PRESENT);
> +		return ret;
> +	}

I find myself wondering what errors could cause the WARN_ON_ONCE() to be
hit.  The SDM indicates that it's only:

	SGX_ENCLAVE_ACT If there are still logical processors executing
			inside the enclave.

Should that be mentioned in the comment?

> +
> +	__sgx_free_epc_page(epc_page);
> +	return 0;
> +}
> +
> +static int sgx_virt_epc_release(struct inode *inode, struct file *file)
> +{
> +	struct sgx_virt_epc *epc = file->private_data;

FWIW, I hate the "struct sgx_virt_epc *epc" name.  "epc" here is really
an instance

> +	struct sgx_epc_page *epc_page, *tmp, *entry;
> +	unsigned long index;
> +
> +	LIST_HEAD(secs_pages);
> +
> +	mmdrop(epc->mm);
> +
> +	xa_for_each(&epc->page_array, index, entry) {
> +		/*
> +		 * Virtual EPC pages are not tracked, so it's possible for
> +		 * EREMOVE to fail due to, e.g. a SECS page still has children
> +		 * if guest was shutdown unexpectedly. If it is the case, leave
> +		 * it in the xarray and retry EREMOVE below later.
> +		 */

I don't know what it is about the comments, but I cringe every time I
see an "i.e." or "e.g.".

I'd rewrite the comment as:

	/*
	 * Remove all normal, child pages.  sgx_virt_epc_free_page()
	 * will fail if EREMOVE fails, but this is OK and expected on
	 * SECS pages.  Those can only be EREMOVE'd *after* all their
	 * child pages. Retries below will clean them up.
 	 */

> +		if (sgx_virt_epc_free_page(entry))
> +			continue;
> +
> +		xa_erase(&epc->page_array, index);
> +	}
> +
> +	/*
> +	 * Retry all failed pages after iterating through the entire tree, at
> +	 * which point all children should be removed and the SECS pages can be
> +	 * nuked as well...unless userspace has exposed multiple instance of
> +	 * virtual EPC to a single VM.
> +	 */

I'm just a comment grouch today I guess.  That's a horrible run-on
sentence.  Let's just state the goal of the loop in the comment above it:

	Retry EREMOVE'ing pages.  This will clean up any SECS pages that
	only had children in this 'epc' area.

> +	xa_for_each(&epc->page_array, index, entry) {
> +		epc_page = entry;

Then, talk about the error condition here:

> +		/*
> +		 * Error here means that EREMOVE failed due to a SECS page
> +		 * still has child on *another* EPC instance.  Put it to a
> +		 * temporary SECS list which will be spliced to 'zombie page
> +		 * list' and will be EREMOVE-ed again when freeing another
> +		 * virtual EPC instance.
> +		 */

Surprise, I've got another rewrite:

		/*
		 * An EREMOVE failure here means that the SECS page
		 * still has children.  But, since all children in this
		 * 'sgx_virt_epc' have been removed, the SECS page must
		 * have a child on another instance.
		 */

> +		if (sgx_virt_epc_free_page(epc_page))
> +			list_add_tail(&epc_page->list, &secs_pages);

Why move these over to &secs_list here?  I think it's to avoid another
xa_for_each() below, but it's not clear.

> +		xa_erase(&epc->page_array, index);
> +	}
> +
> +	/*
> +	 * Third time's a charm.

This is confusing.  This section is *NOT* retrying a third time.  This
is a cute comment, but it's actually, logically different from the two
tries above.  I say remove it.  In fact, I'd even concentrate the
comment here to explain that this is a logically *TOALLY* disconnected
from what happened above.

>		  Try to EREMOVE zombie SECS pages from virtual
> +	 * EPC instances that were previously released, i.e. free SECS pages
> +	 * that were in limbo due to having children in *this* EPC instance.
> +	 */

This is as close as this code gets to telling me what a zombie page is.
 I don't think it gets close enough, or does it in the right spot.

I think it probably needs explicit discussion in the changelog.  I think
Sean explained this to me once, but I've forgotten by now.  The code
needs to be understandable without getting Sean on the phone anyway. :)

I'd probably just say:

	/*
	 * SECS pages are "pinned" by child pages, an unpinned once all
	 * children have been EREMOVE'd.  A child page in this instance
	 * may have pinned an SECS page encountered in an earlier
	 * release(), creating a zombie.  Since some children  were
	 * EREMOVE'd above, try to EREMOVE all zombies in the hopes that
	 * one was unpinned.
	 */

	
> +	mutex_lock(&virt_epc_lock);
> +	list_for_each_entry_safe(epc_page, tmp, &virt_epc_zombie_pages, list) {
> +		/*
> +		 * Speculatively remove the page from the list of zombies, if
> +		 * the page is successfully EREMOVE it will be added to the
> +		 * list of free pages.  If EREMOVE fails, throw the page on the
> +		 * local list, which will be spliced on at the end.
> +		 */
> +		list_del(&epc_page->list);
> +
> +		if (sgx_virt_epc_free_page(epc_page))
> +			list_add_tail(&epc_page->list, &secs_pages);

I don't get this.  Couldn't you do without the unconditional list_del()
and instead just do:

		if (!sgx_virt_epc_free_page(epc_page))
			list_del(&epc_page->list);

Or does the free() code clobber the list_head?  If that's the case,
maybe you should say that explicitly.

> +	}
> +
> +	if (!list_empty(&secs_pages))
> +		list_splice_tail(&secs_pages, &virt_epc_zombie_pages);
> +	mutex_unlock(&virt_epc_lock);
> +
> +	kfree(epc);
> +
> +	return 0;
> +}
> +
> +static int sgx_virt_epc_open(struct inode *inode, struct file *file)
> +{
> +	struct sgx_virt_epc *epc;
> +
> +	epc = kzalloc(sizeof(struct sgx_virt_epc), GFP_KERNEL);
> +	if (!epc)
> +		return -ENOMEM;
> +	/*
> +	 * Keep the current->mm to virtual EPC. It will be checked in
> +	 * sgx_virt_epc_mmap() to prevent, in case of fork, child being
> +	 * able to mmap() to the same virtual EPC pages.
> +	 */
> +	mmgrab(current->mm);
> +	epc->mm = current->mm;
> +	mutex_init(&epc->lock);
> +	xa_init(&epc->page_array);
> +
> +	file->private_data = epc;
> +
> +	return 0;
> +}

I understand why this made sense for regular enclaves, but I'm having a
harder time here.  If you mmap(fd, MAP_SHARED), fork(), and then pass
that mapping through to two different guests, you get to hold the
pieces, just like if you did the same with normal memory.

Why does the kernel need to enforce this policy?
