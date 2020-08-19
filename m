Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1378E24A339
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 17:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728619AbgHSPgs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 11:36:48 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8882 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726792AbgHSPgr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Aug 2020 11:36:47 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07JFWVN1105412
        for <kvm@vger.kernel.org>; Wed, 19 Aug 2020 11:36:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type; s=pp1; bh=yXeIBudJK6eEXb9u+JItUx00iD8CRF1r4POh5wI6D04=;
 b=leEzN7/TInQZBHOTUmcR2FoxprLfwSgppL7YfX65m0E3wu/tOFhru36r31znx9gFpv84
 xDhEO/sWt3rDh1EtSAk+JbKmkQhxjTNX7ZGo78rLV90drO5CRpSO2xdVxsfs9TioCr10
 uw3fgS02nMoN6Vh4xxQqrtzzf7g0XdqWhJZ+6uBm9PvvuzBEHNiW9Y0mbE61ANHKKc/D
 Pi9hwkzCtio8AXKiitd77J76zfyH9+bS2iLO1KzsIVNonyHHNLn4QP8VfRtjJ3CvOh+Q
 XPh6pyLhjuwSurJVrTMoMFjGzliXc5om0NxhdUA2WIZaLxkFj6WRVkNvQ+BSv5SSKvpr 5w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3314mw59dy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 19 Aug 2020 11:36:44 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07JFXcHn110359
        for <kvm@vger.kernel.org>; Wed, 19 Aug 2020 11:36:44 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3314mw59cw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 11:36:44 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07JFaGTm030106;
        Wed, 19 Aug 2020 15:36:41 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3304tr98ce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 15:36:41 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07JFadDI31457618
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Aug 2020 15:36:39 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F02852052;
        Wed, 19 Aug 2020 15:36:39 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.70.234])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id BE80252051;
        Wed, 19 Aug 2020 15:36:38 +0000 (GMT)
Subject: Re: [kvm-unit-tests RFC v1 1/5] lib/vmalloc: vmalloc support for
 handling allocation metadata
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com, lvivier@redhat.com
References: <20200814151009.55845-1-imbrenda@linux.ibm.com>
 <20200814151009.55845-2-imbrenda@linux.ibm.com>
 <a0d00459-cc91-b87d-5fae-063a4967e29f@linux.ibm.com>
 <20200819173124.1b293ab5@ibm-vm>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <780a8a77-6893-ed42-f1e5-c6d7ba133067@linux.ibm.com>
Date:   Wed, 19 Aug 2020 17:36:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200819173124.1b293ab5@ibm-vm>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="pLPwJoiuUTwOGMIIZ3Devm81SMVuhmAiL"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_08:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 adultscore=0 spamscore=0
 impostorscore=0 suspectscore=2 phishscore=0 clxscore=1015 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190131
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pLPwJoiuUTwOGMIIZ3Devm81SMVuhmAiL
Content-Type: multipart/mixed; boundary="mFkAvL4NDbLEaHt6e7vFew6lMpCqiGtQi"

--mFkAvL4NDbLEaHt6e7vFew6lMpCqiGtQi
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/19/20 5:31 PM, Claudio Imbrenda wrote:
> On Wed, 19 Aug 2020 16:36:07 +0200
> Janosch Frank <frankja@linux.ibm.com> wrote:
>=20
>> On 8/14/20 5:10 PM, Claudio Imbrenda wrote:
>>
>> LGTM, some smaller nits/questions below:
>>
>> Commit message?
>=20
> oops! I'll fix it
>=20
>>
>>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>> ---
>>>  lib/vmalloc.c | 105
>>> +++++++++++++++++++++++++++++++++++++++++++++----- 1 file changed,
>>> 95 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/lib/vmalloc.c b/lib/vmalloc.c
>>> index e0c7b6b..aca0876 100644
>>> --- a/lib/vmalloc.c
>>> +++ b/lib/vmalloc.c
>>> @@ -15,6 +15,13 @@
>>>  #include <bitops.h>
>>>  #include "vmalloc.h"
>>> =20
>>> +#define VM_MAGIC 0x7E57C0DE
>>> +
>>> +struct metadata {
>>> +	unsigned long npages;
>>> +	unsigned long magic;
>>> +};
>>> +
>>>  static struct spinlock lock;
>>>  static void *vfree_top =3D 0;
>>>  static void *page_root;
>>> @@ -25,8 +32,14 @@ static void *page_root;
>>>   *
>>>   * nr is the number of pages to allocate
>>>   * alignment_pages is the alignment of the allocation *in pages*
>>> + * metadata indicates whether an extra (unaligned) page needs to
>>> be allocated
>>> + * right before the main (aligned) allocation.
>>> + *
>>> + * The return value points to the first allocated virtual page,
>>> which will
>>> + * be the (potentially unaligned) metadata page if the metadata
>>> flag is
>>> + * specified.
>>>   */
>>> -void *alloc_vpages_aligned(ulong nr, unsigned int align_order)
>>> +static void *do_alloc_vpages(ulong nr, unsigned int align_order,
>>> bool metadata) {
>>>  	uintptr_t ptr;
>>> =20
>>> @@ -34,6 +47,8 @@ void *alloc_vpages_aligned(ulong nr, unsigned int
>>> align_order) ptr =3D (uintptr_t)vfree_top;
>>>  	ptr -=3D PAGE_SIZE * nr;
>>>  	ptr &=3D GENMASK_ULL(63, PAGE_SHIFT + align_order);
>>> +	if (metadata)
>>> +		ptr -=3D PAGE_SIZE;
>>>  	vfree_top =3D (void *)ptr;
>>>  	spin_unlock(&lock);
>>> =20
>>> @@ -41,6 +56,11 @@ void *alloc_vpages_aligned(ulong nr, unsigned
>>> int align_order) return (void *)ptr;
>>>  }
>>> =20
>>> +void *alloc_vpages_aligned(ulong nr, unsigned int align_order)
>>> +{
>>> +	return do_alloc_vpages(nr, align_order, false);
>>> +}
>>> +
>>>  void *alloc_vpages(ulong nr)
>>>  {
>>>  	return alloc_vpages_aligned(nr, 0);
>>> @@ -69,35 +89,100 @@ void *vmap(phys_addr_t phys, size_t size)
>>>  	return mem;
>>>  }
>>> =20
>>> +/*
>>> + * Allocate one page, for an object with specified alignment.
>>> + * The resulting pointer will be aligned to the required
>>> alignment, but
>>> + * intentionally not page-aligned.
>>> + */
>>> +static void *vm_alloc_one_page(size_t alignment)
>>> +{
>>> +	void *p;
>>> +
>>> +	assert(alignment >=3D sizeof(uintptr_t));
>>> +	assert(alignment < PAGE_SIZE);
>>> +	p =3D alloc_vpage();
>>> +	install_page(page_root, virt_to_phys(alloc_page()), p);
>>> +	/* write the magic at the beginning of the page */
>>> +	*(uintptr_t *)p =3D VM_MAGIC;
>>> +	return (void*)((uintptr_t)p + alignment); =20
>>
>> s/(void*)/(void *)/
>=20
> will be fixed
>=20
>>> +}
>>> +
>>> +static struct metadata *get_metadata(void *p)
>>> +{
>>> +	struct metadata *m =3D p;
>>> +
>>> +	return m - 1;
>>> +} =20
>>
>> So the metadata is not at the start of the metadata page, but at the
>> end? We have it at the beginning for the one page case and at the end
>> for the multi page case with metadata on an extra page.
>=20
> correct. it doesn't make a huge difference in the end where the
> metadata is, as long as it is somewhere. Probably putting it always
> right before the start of the memory is better, in order to catch
> accidental off-by-one writes (as they would corrupt the magic value)> p=
lease note that the metadata for a single page is just the magic value


I assumed you'd write the struct in both cases, should've looked closer.

>=20
>>> +
>>>  /*
>>>   * Allocate virtual memory, with the specified minimum alignment.
>>> + * If the allocation fits in one page, only one page is allocated.
>>> Otherwise
>>> + * enough pages are allocated for the object, plus one to keep
>>> metadata
>>> + * information about the allocation.
>>>   */
>>>  static void *vm_memalign(size_t alignment, size_t size)
>>>  {
>>> +	struct metadata *m;
>>>  	phys_addr_t pa;
>>> -	void *mem, *p;
>>> +	uintptr_t p;
>>> +	void *mem;
>>> +	size_t i;
>>> =20
>>> +	if (!size)
>>> +		return NULL;
>>>  	assert(is_power_of_2(alignment));
>>> =20
>>> +	if (alignment < sizeof(uintptr_t))
>>> +		alignment =3D sizeof(uintptr_t);
>=20
>                             ^^^^^^^^^^^^^^^^^
>=20
>>> +	/* it fits in one page, allocate only one page */
>>> +	if (alignment + size <=3D PAGE_SIZE)
>>> +		return vm_alloc_one_page(alignment); =20
>>
>> Don't we also need to take the metadata into account in any size
>> calculation for one page?
>=20
> kinda... we guarantee a minimum alignment, which is enough to fit the
> magic value, which is the only metadata item for single pages (see
> above)

Ah, right

>=20
>>>  	size =3D PAGE_ALIGN(size) / PAGE_SIZE;
>>>  	alignment =3D get_order(PAGE_ALIGN(alignment) / PAGE_SIZE);
>>> -	mem =3D p =3D alloc_vpages_aligned(size, alignment);
>>> -	while (size--) {
>>> +	mem =3D do_alloc_vpages(size, alignment, true);
>>> +	p =3D (uintptr_t)mem;
>>> +	/* skip the metadata page */
>>> +	mem =3D (void *)(p + PAGE_SIZE);
>>> +	/*
>>> +	 * time to actually allocate the physical pages to back
>>> our virtual
>>> +	 * allocation; note that we need to allocate one extra
>>> page (for the
>>> +	 * metadata), hence the <=3D
>>> +	 */
>>> +	for (i =3D 0; i <=3D size; i++, p +=3D PAGE_SIZE) {
>>>  		pa =3D virt_to_phys(alloc_page());
>>>  		assert(pa);
>>> -		install_page(page_root, pa, p);
>>> -		p +=3D PAGE_SIZE;
>>> +		install_page(page_root, pa, (void *)p);
>>>  	}
>>> +	m =3D get_metadata(mem);
>>> +	m->npages =3D size;
>>> +	m->magic =3D VM_MAGIC;
>>>  	return mem;
>>>  }
>>> =20
>>>  static void vm_free(void *mem, size_t size)
>>>  {
>>> -	while (size) {
>>> -		free_page(phys_to_virt(virt_to_pte_phys(page_root,
>>> mem)));
>>> -		mem +=3D PAGE_SIZE;
>>> -		size -=3D PAGE_SIZE;
>>> +	struct metadata *m;
>>> +	uintptr_t ptr, end;
>>> +
>>> +	/* the pointer is not page-aligned, it was a single-page
>>> allocation */
>>> +	if (!IS_ALIGNED((uintptr_t)mem, PAGE_SIZE)) {
>>> +		ptr =3D virt_to_pte_phys(page_root, mem) & PAGE_MASK;
>>> +		assert(*(uintptr_t *)ptr =3D=3D VM_MAGIC);
>>> +		free_page(phys_to_virt(ptr));
>>> +		return;
>>>  	}
>>> +
>>> +	/* the pointer is page-aligned, it was a multi-page
>>> allocation */
>>> +	m =3D get_metadata(mem);
>>> +	assert(m->magic =3D=3D VM_MAGIC);
>>> +	assert(m->npages > 0);
>>> +	/* free all the pages including the metadata page */
>>> +	ptr =3D (uintptr_t)mem - PAGE_SIZE;
>>> +	end =3D ptr + m->npages * PAGE_SIZE;
>>> +	for ( ; ptr < end; ptr +=3D PAGE_SIZE)
>>> +		free_page(phys_to_virt(virt_to_pte_phys(page_root,
>>> (void *)ptr)));
>>> +	/* free the last one separately to avoid overflow issues */
>>> +	free_page(phys_to_virt(virt_to_pte_phys(page_root, (void
>>> *)ptr))); }
>>> =20
>>>  static struct alloc_ops vmalloc_ops =3D {
>>>  =20
>>
>>
>=20



--mFkAvL4NDbLEaHt6e7vFew6lMpCqiGtQi--

--pLPwJoiuUTwOGMIIZ3Devm81SMVuhmAiL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl89RwYACgkQ41TmuOI4
ufg+QxAAo7XUUSWRDcB8TwtJPtEH8qO0o4uzxuwGBT0jK9jNrCxZRlTBXCA7Yr0d
DqQA8gX63SngBW3V2Wkvlex/nRLnW4NDCbwAWtxmO5JFKNmaZMRdzNHrPFldishI
WJHd2FmcrQLO7w1hCPhGVFsesU9cuAo/hAZkhIOWRIJ9mrt8qw/W/ozSleXuMhth
ryH/v7WDOQddcFmDzUkltZNE4Klz30ZY4Hxq2Z9LgPTI/GAm+V6PzqJLipTjcbWU
UJQvMro8z/lGdD5rRyzhvBx/abDXZOLy0sORw71b1SkPIxfF4AFzUv85Nkha3pmS
OHMkUwP4/9hdxANmMZgmDwVy0TyNSk7FGoZGPN+Celpc9TuFdWAuVPa0PyMl3dev
h0hJ45hUKKkJKzLUycdxNHaiGQHjF9TDUH2i8dNBFJhX+yqYVwdznVzWiy41xcm5
uZqBGgaKqUKyRkUDjYKaVC3dStIrFBJLiCrcO95sRhqz8OKF2+/xulPBkzsdR3Be
dZLrq57u8Z72OiIcSu+wRfTHZmXC7Hv6WnOFZd2x/WmtdQxV2q/QeeOfj2qCZdE2
LJGkrbuF85SAlZz+BG5eP9oh1DtZT+iBN8+MDx5/Y0Vfu4v8LsGu7BOrIciMF7Pn
0zZY3m7OqclNUK0ejm9R7JlUtCN+E35JALwCXTdYsm07V+8Adu4=
=14Oq
-----END PGP SIGNATURE-----

--pLPwJoiuUTwOGMIIZ3Devm81SMVuhmAiL--

