Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B230715F141
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 19:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387871AbgBNSAN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 13:00:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42310 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390732AbgBNSAK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 13:00:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581703208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=OuDO+sSywNgXzlWY3guw8t9e6po0cdRyDcCwaceV5Yk=;
        b=DTPw04yMw8r7RN0zpbwcCrnbdaBUPDmCQknsPYWsX7UhK8EGrWmyxkL8nr6V82ou1+1qWs
        RxNScL2xgwiw3VWoqaRTPSjDe1JlSj1R1dSSsFj9szrsvQxSHftEI9+tAkMTqPHXQch3QK
        Vp3N4E7z+MyIO+38V/xLrigc3/1hU2Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-ytRYOxW3PDOllMc1JQYSEQ-1; Fri, 14 Feb 2020 13:00:00 -0500
X-MC-Unique: ytRYOxW3PDOllMc1JQYSEQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE468800D53;
        Fri, 14 Feb 2020 17:59:58 +0000 (UTC)
Received: from [10.36.118.137] (unknown [10.36.118.137])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 07B0B1001B2C;
        Fri, 14 Feb 2020 17:59:55 +0000 (UTC)
Subject: Re: [PATCH 05/35] s390/mm: provide memory management functions for
 protected KVM guests
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
 <20200207113958.7320-6-borntraeger@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <1fb4da22-bab4-abe3-847b-5a7d79d84774@redhat.com>
Date:   Fri, 14 Feb 2020 18:59:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200207113958.7320-6-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> =20
>  /*
> @@ -1086,12 +1106,16 @@ static inline pte_t ptep_get_and_clear_full(str=
uct mm_struct *mm,
>  					    unsigned long addr,
>  					    pte_t *ptep, int full)
>  {
> +	pte_t res;

Empty line missing.

>  	if (full) {
> -		pte_t pte =3D *ptep;
> +		res =3D *ptep;
>  		*ptep =3D __pte(_PAGE_INVALID);
> -		return pte;
> +	} else {
> +		res =3D ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
>  	}
> -	return ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
> +	if (mm_is_protected(mm) && pte_present(res))
> +		uv_convert_from_secure(pte_val(res) & PAGE_MASK);
> +	return res;
>  }

[...]

> +int uv_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)=
;
> +int uv_convert_from_secure(unsigned long paddr);
> +
> +static inline int uv_convert_to_secure(struct gmap *gmap, unsigned lon=
g gaddr)
> +{
> +	struct uv_cb_cts uvcb =3D {
> +		.header.cmd =3D UVC_CMD_CONV_TO_SEC_STOR,
> +		.header.len =3D sizeof(uvcb),
> +		.guest_handle =3D gmap->guest_handle,
> +		.gaddr =3D gaddr,
> +	};
> +
> +	return uv_make_secure(gmap, gaddr, &uvcb);
> +}

I'd actually suggest to name everything that eats a gmap "gmap_",

e.g., "gmap_make_secure()"

[...]

> =20
>  #if defined(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) ||                 =
         \
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index a06a628a88da..15ac598a3d8d 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -9,6 +9,8 @@
>  #include <linux/sizes.h>
>  #include <linux/bitmap.h>
>  #include <linux/memblock.h>
> +#include <linux/pagemap.h>
> +#include <linux/swap.h>
>  #include <asm/facility.h>
>  #include <asm/sections.h>
>  #include <asm/uv.h>
> @@ -99,4 +101,174 @@ void adjust_to_uv_max(unsigned long *vmax)
>  	if (prot_virt_host && *vmax > uv_info.max_sec_stor_addr)
>  		*vmax =3D uv_info.max_sec_stor_addr;
>  }
> +
> +static int __uv_pin_shared(unsigned long paddr)
> +{
> +	struct uv_cb_cfs uvcb =3D {
> +		.header.cmd	=3D UVC_CMD_PIN_PAGE_SHARED,
> +		.header.len	=3D sizeof(uvcb),
> +		.paddr		=3D paddr,

please drop all the superfluous spaces (just as in the other uv calls).

> +	};
> +
> +	if (uv_call(0, (u64)&uvcb))
> +		return -EINVAL;
> +	return 0;
> +}

[...]

> +static int make_secure_pte(pte_t *ptep, unsigned long addr, void *data=
)
> +{
> +	struct conv_params *params =3D data;
> +	pte_t entry =3D READ_ONCE(*ptep);
> +	struct page *page;
> +	int expected, rc =3D 0;
> +
> +	if (!pte_present(entry))
> +		return -ENXIO;
> +	if (pte_val(entry) & (_PAGE_INVALID | _PAGE_PROTECT))
> +		return -ENXIO;
> +
> +	page =3D pte_page(entry);
> +	if (page !=3D params->page)
> +		return -ENXIO;
> +
> +	if (PageWriteback(page))
> +		return -EAGAIN;
> +	expected =3D expected_page_refs(page);

I do wonder if we could factor out expected_page_refs() and reuse from
other sources ...

I do wonder about huge page backing of guests, and especially
hpage_nr_pages(page) used in mm/migrate.c:expected_page_refs(). But I
can spot some hugepage exclusion below ... This needs comments.

> +	if (!page_ref_freeze(page, expected))
> +		return -EBUSY;
> +	set_bit(PG_arch_1, &page->flags);

Can we please document somewhere how PG_arch_1 is used on s390x? (page)

"The generic code guarantees that this bit is cleared for a page when it
first is entered into the page cache" - should not be an issue, right?

> +	rc =3D uv_call(0, (u64)params->uvcb);
> +	page_ref_unfreeze(page, expected);
> +	if (rc)
> +		rc =3D (params->uvcb->rc =3D=3D 0x10a) ? -ENXIO : -EINVAL;
> +	return rc;
> +}
> +
> +/*
> + * Requests the Ultravisor to make a page accessible to a guest.
> + * If it's brought in the first time, it will be cleared. If
> + * it has been exported before, it will be decrypted and integrity
> + * checked.
> + *
> + * @gmap: Guest mapping
> + * @gaddr: Guest 2 absolute address to be imported

I'd just drop the the (incomplete) parameter documentation, everybody
reaching this point should now what a gmap and what a gaddr is ...

> + */
> +int uv_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
> +{
> +	struct conv_params params =3D { .uvcb =3D uvcb };
> +	struct vm_area_struct *vma;
> +	unsigned long uaddr;
> +	int rc, local_drain =3D 0;
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
> +	if (is_vm_hugetlb_page(vma))
> +		goto out;

Hah there it is! How is it enforced on upper layers/excluded? Will
hpage=3Dtrue fail with prot virt? What if a guest is not a protected gues=
t
but wants to sue huge pages? This needs comments/patch description.

> +
> +	rc =3D -ENXIO;
> +	params.page =3D follow_page(vma, uaddr, FOLL_WRITE | FOLL_NOWAIT);
> +	if (IS_ERR_OR_NULL(params.page))
> +		goto out;
> +
> +	lock_page(params.page);
> +	rc =3D apply_to_page_range(gmap->mm, uaddr, PAGE_SIZE, make_secure_pt=
e, &params);

Ehm, isn't it just always a single page?

> +	unlock_page(params.page);
> +out:
> +	up_read(&gmap->mm->mmap_sem);
> +
> +	if (rc =3D=3D -EBUSY) {
> +		if (local_drain) {
> +			lru_add_drain_all();
> +			return -EAGAIN;
> +		}
> +		lru_add_drain();

comments please why that is performed.

> +		local_drain =3D 1;
> +		goto again;

Could we end up in an endless loop?

> +	} else if (rc =3D=3D -ENXIO) {
> +		if (gmap_fault(gmap, gaddr, FAULT_FLAG_WRITE))
> +			return -EFAULT;
> +		return -EAGAIN;
> +	}
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(uv_make_secure);
> +
> +/**
> + * To be called with the page locked or with an extra reference!
> + */
> +int arch_make_page_accessible(struct page *page)
> +{
> +	int rc =3D 0;
> +
> +	if (PageHuge(page))
> +		return 0;

Ah, another instance. Comment please why

> +
> +	if (!test_bit(PG_arch_1, &page->flags))
> +		return 0;

"Can you describe the meaning of this bit with three words"? Or a couple
more? :D

"once upon a time, the page was secure and still might be" ?
"the page is secure and therefore inaccessible" ?

> +
> +	rc =3D __uv_pin_shared(page_to_phys(page));
> +	if (!rc) {
> +		clear_bit(PG_arch_1, &page->flags);
> +		return 0;
> +	}
> +
> +	rc =3D uv_convert_from_secure(page_to_phys(page));
> +	if (!rc) {
> +		clear_bit(PG_arch_1, &page->flags);
> +		return 0;
> +	}
> +
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(arch_make_page_accessible);
> +
>  #endif
>=20

More code comments would be highly appreciated!

--=20
Thanks,

David / dhildenb

