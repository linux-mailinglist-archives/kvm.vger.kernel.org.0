Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5776B160FD4
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 11:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbgBQKWA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 05:22:00 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33598 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729142AbgBQKWA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Feb 2020 05:22:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581934918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=VrgVyJ+tJIJgafivxeVgCktrUYbOjjFTO1NCGrJVUG4=;
        b=Iz6RFNXBo+IsPUOB7v267aJeQMMv+WEIaIVLTg3p1Uq5wvDpXXKkGMdBqIf/UsWeF+e8fj
        hkffh726hQJFzlWrWI8OfME/wZ1w0MFWs8MHVEZVYe6zKFcXiubNbO8unHCLGEi8qzH2Ut
        mv9If8+jN1YkNeq4n2BnNISfH+pdXis=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-KeRGx3kiNfyD-68imKku1g-1; Mon, 17 Feb 2020 05:21:53 -0500
X-MC-Unique: KeRGx3kiNfyD-68imKku1g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C0A428017DF;
        Mon, 17 Feb 2020 10:21:51 +0000 (UTC)
Received: from [10.36.117.64] (ovpn-117-64.ams2.redhat.com [10.36.117.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F8348681F;
        Mon, 17 Feb 2020 10:21:46 +0000 (UTC)
Subject: Re: [PATCH v2 05/42] s390/mm: provide memory management functions for
 protected KVM guests
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org
References: <20200214222658.12946-1-borntraeger@de.ibm.com>
 <20200214222658.12946-6-borntraeger@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <f5523486-ee76-e6c1-9563-658bca7f3b0d@redhat.com>
Date:   Mon, 17 Feb 2020 11:21:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200214222658.12946-6-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.=
h
> index 85e944f04c70..4ebcf891ff3c 100644
> --- a/arch/s390/include/asm/page.h
> +++ b/arch/s390/include/asm/page.h
> @@ -153,6 +153,11 @@ static inline int devmem_is_allowed(unsigned long =
pfn)
>  #define HAVE_ARCH_FREE_PAGE
>  #define HAVE_ARCH_ALLOC_PAGE
> =20
> +#if IS_ENABLED(CONFIG_PGSTE)
> +int arch_make_page_accessible(struct page *page);
> +#define HAVE_ARCH_MAKE_PAGE_ACCESSIBLE
> +#endif
> +

Feels like this should have been one of the (CONFIG_)ARCH_HAVE_XXX
thingies defined via kconfig instead.

E.g., like (CONFIG_)HAVE_ARCH_TRANSPARENT_HUGEPAGE

[...]

> +
> +/*
> + * Requests the Ultravisor to encrypt a guest page and make it
> + * accessible to the host for paging (export).
> + *
> + * @paddr: Absolute host address of page to be exported
> + */
> +int uv_convert_from_secure(unsigned long paddr)
> +{
> +	struct uv_cb_cfs uvcb =3D {
> +		.header.cmd =3D UVC_CMD_CONV_FROM_SEC_STOR,
> +		.header.len =3D sizeof(uvcb),
> +		.paddr =3D paddr
> +	};
> +
> +	if (uv_call(0, (u64)&uvcb))
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +/*
> + * Calculate the expected ref_count for a page that would otherwise ha=
ve no
> + * further pins. This was cribbed from similar functions in other plac=
es in
> + * the kernel, but with some slight modifications. We know that a secu=
re
> + * page can not be a huge page for example.

s/ca not cannot/

> + */
> +static int expected_page_refs(struct page *page)
> +{
> +	int res;
> +
> +	res =3D page_mapcount(page);
> +	if (PageSwapCache(page)) {
> +		res++;
> +	} else if (page_mapping(page)) {
> +		res++;
> +		if (page_has_private(page))
> +			res++;
> +	}
> +	return res;
> +}
> +
> +static int make_secure_pte(pte_t *ptep, unsigned long addr,
> +			   struct page *exp_page, struct uv_cb_header *uvcb)
> +{
> +	pte_t entry =3D READ_ONCE(*ptep);
> +	struct page *page;
> +	int expected, rc =3D 0;
> +
> +	if (!pte_present(entry))
> +		return -ENXIO;
> +	if (pte_val(entry) & _PAGE_INVALID)
> +		return -ENXIO;
> +
> +	page =3D pte_page(entry);
> +	if (page !=3D exp_page)
> +		return -ENXIO;
> +	if (PageWriteback(page))
> +		return -EAGAIN;
> +	expected =3D expected_page_refs(page);
> +	if (!page_ref_freeze(page, expected))
> +		return -EBUSY;
> +	set_bit(PG_arch_1, &page->flags);
> +	rc =3D uv_call(0, (u64)uvcb);
> +	page_ref_unfreeze(page, expected);
> +	/* Return -ENXIO if the page was not mapped, -EINVAL otherwise */
> +	if (rc)
> +		rc =3D uvcb->rc =3D=3D 0x10a ? -ENXIO : -EINVAL;
> +	return rc;
> +}
> +
> +/*
> + * Requests the Ultravisor to make a page accessible to a guest.
> + * If it's brought in the first time, it will be cleared. If
> + * it has been exported before, it will be decrypted and integrity
> + * checked.
> + */
> +int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvc=
b)
> +{
> +	struct vm_area_struct *vma;
> +	unsigned long uaddr;
> +	struct page *page;
> +	int rc, local_drain =3D 0;

local_drain could have been a bool.

> +	spinlock_t *ptelock;
> +	pte_t *ptep;
> +
> +again:
> +	rc =3D -EFAULT;
> +	down_read(&gmap->mm->mmap_sem);
> +
> +	uaddr =3D __gmap_translate(gmap, gaddr);
> +	if (IS_ERR_VALUE(uaddr))
> +		goto out;
> +	vma =3D find_vma(gmap->mm, uaddr);
> +	if (!vma)
> +		goto out;
> +	/*
> +	 * Secure pages cannot be huge and userspace should not combine both.
> +	 * In case userspace does it anyway this will result in an -EFAULT fo=
r
> +	 * the unpack. The guest is thus never reaching secure mode. If
> +	 * userspace is playing dirty tricky with mapping huge pages later
> +	 * on this will result in a segmenation fault.

s/segmenation/segmentation/

> +	 */
> +	if (is_vm_hugetlb_page(vma))
> +		goto out;
> +
> +	rc =3D -ENXIO;
> +	page =3D follow_page(vma, uaddr, FOLL_WRITE);
> +	if (IS_ERR_OR_NULL(page))
> +		goto out;
> +
> +	lock_page(page);
> +	ptep =3D get_locked_pte(gmap->mm, uaddr, &ptelock);
> +	rc =3D make_secure_pte(ptep, uaddr, page, uvcb);
> +	pte_unmap_unlock(ptep, ptelock);
> +	unlock_page(page);
> +out:
> +	up_read(&gmap->mm->mmap_sem);
> +
> +	if (rc =3D=3D -EAGAIN) {
> +		wait_on_page_writeback(page);
> +	} else if (rc =3D=3D -EBUSY) {
> +		/*
> +		 * If we have tried a local drain and the page refcount
> +		 * still does not match our expected safe value, try with a
> +		 * system wide drain. This is needed if the pagevecs holding
> +		 * the page are on a different CPU.
> +		 */
> +		if (local_drain) {
> +			lru_add_drain_all();

I do wonder if that is valid to be called with all the locks at this poin=
t.

> +			/* We give up here, and let the caller try again */
> +			return -EAGAIN;
> +		}
> +		/*
> +		 * We are here if the page refcount does not match the
> +		 * expected safe value. The main culprits are usually
> +		 * pagevecs. With lru_add_drain() we drain the pagevecs
> +		 * on the local CPU so that hopefully the refcount will
> +		 * reach the expected safe value.
> +		 */
> +		lru_add_drain();

dito ...

> +		local_drain =3D 1;
> +		/* And now we try again immediately after draining */
> +		goto again;
> +	} else if (rc =3D=3D -ENXIO) {
> +		if (gmap_fault(gmap, gaddr, FAULT_FLAG_WRITE))
> +			return -EFAULT;
> +		return -EAGAIN;
> +	}
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(gmap_make_secure);
> +
> +int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr)
> +{
> +	struct uv_cb_cts uvcb =3D {
> +		.header.cmd =3D UVC_CMD_CONV_TO_SEC_STOR,
> +		.header.len =3D sizeof(uvcb),
> +		.guest_handle =3D gmap->guest_handle,
> +		.gaddr =3D gaddr,
> +	};
> +
> +	return gmap_make_secure(gmap, gaddr, &uvcb);
> +}
> +EXPORT_SYMBOL_GPL(gmap_convert_to_secure);
> +
> +/**
> + * To be called with the page locked or with an extra reference!

Can we have races here? (IOW, two callers concurrently for the same page)

> + */
> +int arch_make_page_accessible(struct page *page)
> +{
> +	int rc =3D 0;
> +
> +	/* Hugepage cannot be protected, so nothing to do */
> +	if (PageHuge(page))
> +		return 0;
> +
> +	/*
> +	 * PG_arch_1 is used in 3 places:
> +	 * 1. for kernel page tables during early boot
> +	 * 2. for storage keys of huge pages and KVM
> +	 * 3. As an indication that this page might be secure. This can
> +	 *    overindicate, e.g. we set the bit before calling
> +	 *    convert_to_secure.
> +	 * As secure pages are never huge, all 3 variants can co-exists.
> +	 */
> +	if (!test_bit(PG_arch_1, &page->flags))
> +		return 0;
> +
> +	rc =3D uv_pin_shared(page_to_phys(page));
> +	if (!rc) {
> +		clear_bit(PG_arch_1, &page->flags);
> +		return 0;
> +	}

Overall, looks sane to me. (I am mostly concerned about possible races,
e.g., when two gmaps would be created for a single VM and nasty stuff be
done with them). But yeah, I guess you guys thought about this ;)

--=20
Thanks,

David / dhildenb

