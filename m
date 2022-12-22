Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E91536545F2
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 19:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbiLVSZy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 13:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbiLVSZn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 13:25:43 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD09326;
        Thu, 22 Dec 2022 10:25:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1671733456; bh=3C//pPReD1huiKwB+HIgGP+aYEUDdZN5HiRsK7t6BqE=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=FIbEaueLWxPWU2nVI81X+aZBJqb7pGiKZdoKgG+U+/42wzeWTFzf6iHOLbjwRHbKS
         aMZzYGP8gHRMOKHvL1MBsPw9wQm7ScTzhLbqAW1IOwD6kJAt/sBzJJXkcro7xzTtFd
         2IKPtO3ztNsG868yBfXLbm6JnrU3PAYcrgydeAVD8/kiq7SqwykGc7pn8Ku0Q1Mm80
         0ko/EnwuL32ohUPiwG0c04Co75Liy1YpueJvj9rrltmRh0ZIwg/6S3bUW5rvzlD3mw
         S+3O/RlnmWoqSD1a5e6mTdikoi28Qy0hxvDowJ2Oh8g3xC6T10Zy/wLSvR/GdoQeT8
         ekEncX+m2UNyA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from localhost ([62.143.90.77]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Ma20k-1pKZqG2wdg-00Vvny; Thu, 22
 Dec 2022 19:24:16 +0100
Date:   Thu, 22 Dec 2022 19:24:02 +0100
From:   erbse.13@gmx.de
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        harald@profian.com, Nikunj A Dadhania <nikunj@amd.com>
Subject: Re: [PATCH RFC v7 11/64] KVM: SEV: Support private pages in
 LAUNCH_UPDATE_DATA
Message-ID: <Y6Sgwp/BofzCUrQe@notebook>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-12-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214194056.161492-12-michael.roth@amd.com>
X-Provags-ID: V03:K1:iVceB1ZaTzjhtQbFgMfH9Ymg2SVfhDV1qs8iVgziQpLZ9OiSFWI
 sN08JdZwg8iuA8yLBoaQVNwx8WhVzL/GntbJSgRtWdUJ+dV69YrUwD8vPGSvr+qBqI+rvM3
 7IQ605ZNfMYdkWFdgTDF8nA3LA0A96qzMWZ7ICA/7cCXnt3WtZsxm/sU/LXGtPEQxcfSpuL
 q4SEojyNdmQn9qUyq7hWw==
UI-OutboundReport: notjunk:1;M01:P0:mdELVBPtDLE=;IBvNb1Mqd/JKAyjgIXTx8Dll7mH
 ROU2y7XjKq0+oZ1bfY2w7dFcRtxeWQa8eVJ2+S0loCSdqt2xz8Hvg+ZagBUZLQg37Dt0Dc2ZD
 YF0+WtnJpmHVjBwzEd0AEULmciHzK5mHAvWPEBcUisv/SMfoPkzxQpq4TabH9ZbYJUgeHhr0F
 dzRTGl4HeUPmp9vWNwN1oDJMDdYEyqfffS/K0SaT68igm8SQdH7gjmL60nSab2fY8uxOTXklR
 4m5HEuR1zhTSNHp3Ztf27Z8gVKDQYlCQMHM4ERCmPTcC0Wca5TYHg+iclVpS6V5EaB4nk/N8u
 WIZA2Eeft+8wzqXUW18TV6CiRkp7oocNjB1NN50akqy7kGJ33YZTMKhBJsYeVGsx9oPn4jagA
 YzXPsqlwrP2kPPSUomkmnV+O7jtHtVnXTIAihl934kbl40IRHsk6yMKBb9iDfI9Lnj0sPMCjN
 /Tx8FgwNxQuHQoWlNrk1JGDKjn4Yg1A7dDY9IsHF8ejlyBZXDJK3JcnKjBa/5kJ4PbX9E8Ngc
 W4gBgYrVfxd260LRebdhVupfZcmgUa2LlWHR7BGYXu2uSBNw7gbwye+l9zhdd/KGml/y7OzbJ
 roxc6AF378FfsfxnPQjf43niz7yHhqz1r4DSzdNiuU1PHfB1J7F4RRCIxyzjnyelcSuBQGEZe
 dtJiFXcsivaiT4mRDDptAqQJEqxibD+KAUrnFQxt9J4/g/AWFksHi/jFd9ypkOx6ziR0qDASL
 Djfb3x4uOG88TKmbb22g+FrU3FJntg3/h5xGX094wlMHv6Sy+APV+7nZVOjHeK6kfAfm4q9C3
 qFawT+WGJ1h856OcOLx5qNe1MCyAq7QOPigBPzWfo3ic2vbEqs/yLTC6vZPGkyN8gd6Liti22
 Tte+ZHHryGvKmvcJfFOCNXgQNahqzo0yWT6RhyS0zGY0okNfvraWBasF4gDZmXLn7FhvKj7oS
 LCIiDaYU51jEQPEcd8umLujuT40=
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 14, 2022 at 01:40:03PM -0600, Michael Roth wrote:
> From: Nikunj A Dadhania <nikunj@amd.com>
>
> Pre-boot guest payload needs to be encrypted and VMM has copied it
> over to the private-fd. Add support to get the pfn from the memfile fd
> for encrypting the payload in-place.
>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 79 ++++++++++++++++++++++++++++++++++--------
>  1 file changed, 64 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index a7e4e3005786..ae4920aeb281 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -107,6 +107,11 @@ static inline bool is_mirroring_enc_context(struct =
kvm *kvm)
>  	return !!to_kvm_svm(kvm)->sev_info.enc_context_owner;
>  }
>
> +static bool kvm_is_upm_enabled(struct kvm *kvm)
> +{
> +	return kvm->arch.upm_mode;
> +}
> +
>  /* Must be called with the sev_bitmap_lock held */
>  static bool __sev_recycle_asids(int min_asid, int max_asid)
>  {
> @@ -382,6 +387,38 @@ static int sev_launch_start(struct kvm *kvm, struct=
 kvm_sev_cmd *argp)
>  	return ret;
>  }
>
> +static int sev_get_memfile_pfn_handler(struct kvm *kvm, struct kvm_gfn_=
range *range, void *data)
> +{
> +	struct kvm_memory_slot *memslot =3D range->slot;
> +	struct page **pages =3D data;
> +	int ret =3D 0, i =3D 0;
> +	kvm_pfn_t pfn;
> +	gfn_t gfn;
> +
> +	for (gfn =3D range->start; gfn < range->end; gfn++) {
> +		int order;
> +
> +		ret =3D kvm_restricted_mem_get_pfn(memslot, gfn, &pfn, &order);
> +		if (ret)
> +			return ret;
> +
> +		if (is_error_noslot_pfn(pfn))
> +			return -EFAULT;
> +
> +		pages[i++] =3D pfn_to_page(pfn);
> +	}
> +
> +	return ret;
> +}
> +
> +static int sev_get_memfile_pfn(struct kvm *kvm, unsigned long addr,
> +			       unsigned long size, unsigned long npages,
> +			       struct page **pages)
> +{
> +	return kvm_vm_do_hva_range_op(kvm, addr, size,
> +				      sev_get_memfile_pfn_handler, pages);
> +}

The third argument for the kvm_vm_do_hva_range_op call should be addr+size=
; the
function expects the end of the range not the size of the range.

> +
>  static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uadd=
r,
>  				    unsigned long ulen, unsigned long *n,
>  				    int write)
> @@ -424,16 +461,25 @@ static struct page **sev_pin_memory(struct kvm *kv=
m, unsigned long uaddr,
>  	if (!pages)
>  		return ERR_PTR(-ENOMEM);
>
> -	/* Pin the user virtual address. */
> -	npinned =3D pin_user_pages_fast(uaddr, npages, write ? FOLL_WRITE : 0,=
 pages);
> -	if (npinned !=3D npages) {
> -		pr_err("SEV: Failure locking %lu pages.\n", npages);
> -		ret =3D -ENOMEM;
> -		goto err;
> +	if (kvm_is_upm_enabled(kvm)) {
> +		/* Get the PFN from memfile */
> +		if (sev_get_memfile_pfn(kvm, uaddr, ulen, npages, pages)) {
> +			pr_err("%s: ERROR: unable to find slot for uaddr %lx", __func__, uad=
dr);
> +			ret =3D -ENOMEM;
> +			goto err;
> +		}

This branch doesn't initialize npinned. If sev_get_memfile_pfn fails, the =
code following the err
label passes the uninitialized value to unpin_user_pages.

> +	} else {
> +		/* Pin the user virtual address. */
> +		npinned =3D pin_user_pages_fast(uaddr, npages, write ? FOLL_WRITE : 0=
, pages);
> +		if (npinned !=3D npages) {
> +			pr_err("SEV: Failure locking %lu pages.\n", npages);
> +			ret =3D -ENOMEM;
> +			goto err;
> +		}
> +		sev->pages_locked =3D locked;
>  	}
>
>  	*n =3D npages;
> -	sev->pages_locked =3D locked;
>
>  	return pages;
>
> @@ -514,6 +560,7 @@ static int sev_launch_update_shared_gfn_handler(stru=
ct kvm *kvm,
>
>  	size =3D (range->end - range->start) << PAGE_SHIFT;
>  	vaddr_end =3D vaddr + size;
> +	WARN_ON(size < PAGE_SIZE);
>
>  	/* Lock the user memory. */
>  	inpages =3D sev_pin_memory(kvm, vaddr, size, &npages, 1);
> @@ -554,13 +601,16 @@ static int sev_launch_update_shared_gfn_handler(st=
ruct kvm *kvm,
>  	}
>
>  e_unpin:
> -	/* content of memory is updated, mark pages dirty */
> -	for (i =3D 0; i < npages; i++) {
> -		set_page_dirty_lock(inpages[i]);
> -		mark_page_accessed(inpages[i]);
> +	if (!kvm_is_upm_enabled(kvm)) {
> +		/* content of memory is updated, mark pages dirty */
> +		for (i =3D 0; i < npages; i++) {
> +			set_page_dirty_lock(inpages[i]);
> +			mark_page_accessed(inpages[i]);
> +		}
> +		/* unlock the user pages */
> +		sev_unpin_memory(kvm, inpages, npages);
>  	}
> -	/* unlock the user pages */
> -	sev_unpin_memory(kvm, inpages, npages);
> +
>  	return ret;
>  }
>
> @@ -609,9 +659,8 @@ static int sev_launch_update_priv_gfn_handler(struct=
 kvm *kvm,
>  			goto e_ret;
>  		kvm_release_pfn_clean(pfn);
>  	}
> -	kvm_vm_set_region_attr(kvm, range->start, range->end,
> -		true /* priv_attr */);
>
> +	kvm_vm_set_region_attr(kvm, range->start, range->end, KVM_MEMORY_ATTRI=
BUTE_PRIVATE);
>  e_ret:
>  	return ret;
>  }
> --
> 2.25.1
>

Regards, Tom
