Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC31B16111B
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 12:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbgBQL3I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 06:29:08 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23050 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726558AbgBQL3I (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Feb 2020 06:29:08 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01HBNpj5180273
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2020 06:29:06 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y6cu1k5ka-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2020 06:29:06 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 17 Feb 2020 11:29:04 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 17 Feb 2020 11:29:00 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01HBSxco45088942
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Feb 2020 11:28:59 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EBD4052052;
        Mon, 17 Feb 2020 11:28:58 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.152.224.211])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9BE655205F;
        Mon, 17 Feb 2020 11:28:58 +0000 (GMT)
Subject: Re: [PATCH v2 05/42] s390/mm: provide memory management functions for
 protected KVM guests
To:     David Hildenbrand <david@redhat.com>,
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
 <f5523486-ee76-e6c1-9563-658bca7f3b0d@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Mon, 17 Feb 2020 12:28:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <f5523486-ee76-e6c1-9563-658bca7f3b0d@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20021711-0028-0000-0000-000003DBBCE5
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021711-0029-0000-0000-000024A0C284
Message-Id: <87742e00-9a8d-b7b4-ab96-05e8c9d39534@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-17_05:2020-02-17,2020-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 mlxscore=0 suspectscore=2 bulkscore=0 spamscore=0
 lowpriorityscore=0 impostorscore=0 adultscore=0 clxscore=1015
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2002170098
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 17.02.20 11:21, David Hildenbrand wrote:
>> diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
>> index 85e944f04c70..4ebcf891ff3c 100644
>> --- a/arch/s390/include/asm/page.h
>> +++ b/arch/s390/include/asm/page.h
>> @@ -153,6 +153,11 @@ static inline int devmem_is_allowed(unsigned long pfn)
>>  #define HAVE_ARCH_FREE_PAGE
>>  #define HAVE_ARCH_ALLOC_PAGE
>>  
>> +#if IS_ENABLED(CONFIG_PGSTE)
>> +int arch_make_page_accessible(struct page *page);
>> +#define HAVE_ARCH_MAKE_PAGE_ACCESSIBLE
>> +#endif
>> +
> 
> Feels like this should have been one of the (CONFIG_)ARCH_HAVE_XXX
> thingies defined via kconfig instead.
> 
> E.g., like (CONFIG_)HAVE_ARCH_TRANSPARENT_HUGEPAGE
> 
> [...]

This looks more or less like HAVE_ARCH_ALLOC_PAGE. You will find both
variants.
I think I will leave it that way for now until we need it to be a config
or the mm maintainers have a preference.


> 
>> +
>> +/*
>> + * Requests the Ultravisor to encrypt a guest page and make it
>> + * accessible to the host for paging (export).
>> + *
>> + * @paddr: Absolute host address of page to be exported
>> + */
>> +int uv_convert_from_secure(unsigned long paddr)
>> +{
>> +	struct uv_cb_cfs uvcb = {
>> +		.header.cmd = UVC_CMD_CONV_FROM_SEC_STOR,
>> +		.header.len = sizeof(uvcb),
>> +		.paddr = paddr
>> +	};
>> +
>> +	if (uv_call(0, (u64)&uvcb))
>> +		return -EINVAL;
>> +	return 0;
>> +}
>> +
>> +/*
>> + * Calculate the expected ref_count for a page that would otherwise have no
>> + * further pins. This was cribbed from similar functions in other places in
>> + * the kernel, but with some slight modifications. We know that a secure
>> + * page can not be a huge page for example.
> 
> s/ca not cannot/

ack.


> 
>> + */
>> +static int expected_page_refs(struct page *page)
>> +{
>> +	int res;
>> +
>> +	res = page_mapcount(page);
>> +	if (PageSwapCache(page)) {
>> +		res++;
>> +	} else if (page_mapping(page)) {
>> +		res++;
>> +		if (page_has_private(page))
>> +			res++;
>> +	}
>> +	return res;
>> +}
>> +
>> +static int make_secure_pte(pte_t *ptep, unsigned long addr,
>> +			   struct page *exp_page, struct uv_cb_header *uvcb)
>> +{
>> +	pte_t entry = READ_ONCE(*ptep);
>> +	struct page *page;
>> +	int expected, rc = 0;
>> +
>> +	if (!pte_present(entry))
>> +		return -ENXIO;
>> +	if (pte_val(entry) & _PAGE_INVALID)
>> +		return -ENXIO;
>> +
>> +	page = pte_page(entry);
>> +	if (page != exp_page)
>> +		return -ENXIO;
>> +	if (PageWriteback(page))
>> +		return -EAGAIN;
>> +	expected = expected_page_refs(page);
>> +	if (!page_ref_freeze(page, expected))
>> +		return -EBUSY;
>> +	set_bit(PG_arch_1, &page->flags);
>> +	rc = uv_call(0, (u64)uvcb);
>> +	page_ref_unfreeze(page, expected);
>> +	/* Return -ENXIO if the page was not mapped, -EINVAL otherwise */
>> +	if (rc)
>> +		rc = uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
>> +	return rc;
>> +}
>> +
>> +/*
>> + * Requests the Ultravisor to make a page accessible to a guest.
>> + * If it's brought in the first time, it will be cleared. If
>> + * it has been exported before, it will be decrypted and integrity
>> + * checked.
>> + */
>> +int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
>> +{
>> +	struct vm_area_struct *vma;
>> +	unsigned long uaddr;
>> +	struct page *page;
>> +	int rc, local_drain = 0;
> 
> local_drain could have been a bool.

ack
> 
>> +	spinlock_t *ptelock;
>> +	pte_t *ptep;
>> +
>> +again:
>> +	rc = -EFAULT;
>> +	down_read(&gmap->mm->mmap_sem);
>> +
>> +	uaddr = __gmap_translate(gmap, gaddr);
>> +	if (IS_ERR_VALUE(uaddr))
>> +		goto out;
>> +	vma = find_vma(gmap->mm, uaddr);
>> +	if (!vma)
>> +		goto out;
>> +	/*
>> +	 * Secure pages cannot be huge and userspace should not combine both.
>> +	 * In case userspace does it anyway this will result in an -EFAULT for
>> +	 * the unpack. The guest is thus never reaching secure mode. If
>> +	 * userspace is playing dirty tricky with mapping huge pages later
>> +	 * on this will result in a segmenation fault.
> 
> s/segmenation/segmentation/

ack.
> 
>> +	 */
>> +	if (is_vm_hugetlb_page(vma))
>> +		goto out;
>> +
>> +	rc = -ENXIO;
>> +	page = follow_page(vma, uaddr, FOLL_WRITE);
>> +	if (IS_ERR_OR_NULL(page))
>> +		goto out;
>> +
>> +	lock_page(page);
>> +	ptep = get_locked_pte(gmap->mm, uaddr, &ptelock);
>> +	rc = make_secure_pte(ptep, uaddr, page, uvcb);
>> +	pte_unmap_unlock(ptep, ptelock);
>> +	unlock_page(page);
>> +out:
>> +	up_read(&gmap->mm->mmap_sem);
>> +
>> +	if (rc == -EAGAIN) {
>> +		wait_on_page_writeback(page);
>> +	} else if (rc == -EBUSY) {
>> +		/*
>> +		 * If we have tried a local drain and the page refcount
>> +		 * still does not match our expected safe value, try with a
>> +		 * system wide drain. This is needed if the pagevecs holding
>> +		 * the page are on a different CPU.
>> +		 */
>> +		if (local_drain) {
>> +			lru_add_drain_all();
> 
> I do wonder if that is valid to be called with all the locks at this point.

This function uses per cpu workers and needs no other locks. Also verified 
with lockdep. 

> 
>> +			/* We give up here, and let the caller try again */
>> +			return -EAGAIN;
>> +		}
>> +		/*
>> +		 * We are here if the page refcount does not match the
>> +		 * expected safe value. The main culprits are usually
>> +		 * pagevecs. With lru_add_drain() we drain the pagevecs
>> +		 * on the local CPU so that hopefully the refcount will
>> +		 * reach the expected safe value.
>> +		 */
>> +		lru_add_drain();
> 
> dito ...

dito. 

> 
>> +		local_drain = 1;
>> +		/* And now we try again immediately after draining */
>> +		goto again;
>> +	} else if (rc == -ENXIO) {
>> +		if (gmap_fault(gmap, gaddr, FAULT_FLAG_WRITE))
>> +			return -EFAULT;
>> +		return -EAGAIN;
>> +	}
>> +	return rc;
>> +}
>> +EXPORT_SYMBOL_GPL(gmap_make_secure);
>> +
>> +int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr)
>> +{
>> +	struct uv_cb_cts uvcb = {
>> +		.header.cmd = UVC_CMD_CONV_TO_SEC_STOR,
>> +		.header.len = sizeof(uvcb),
>> +		.guest_handle = gmap->guest_handle,
>> +		.gaddr = gaddr,
>> +	};
>> +
>> +	return gmap_make_secure(gmap, gaddr, &uvcb);
>> +}
>> +EXPORT_SYMBOL_GPL(gmap_convert_to_secure);
>> +
>> +/**
>> + * To be called with the page locked or with an extra reference!
> 
> Can we have races here? (IOW, two callers concurrently for the same page)

That would be fine and is part of the design. The ultravisor calls will
either make the page accessible or will be a (mostly) no-op.
In fact, we allow for slight over-indication of "needs to be exported"

What about:

/*
 * To be called with the page locked or with an extra reference! This will
 * prevent gmap_make_secure from touching the page concurrently. Having 2
 * parallel make_page_accessible is fine, as the UV calls will become a 
 * no-op if the page is already exported.
 */


> 
>> + */
>> +int arch_make_page_accessible(struct page *page)
>> +{
>> +	int rc = 0;
>> +
>> +	/* Hugepage cannot be protected, so nothing to do */
>> +	if (PageHuge(page))
>> +		return 0;
>> +
>> +	/*
>> +	 * PG_arch_1 is used in 3 places:
>> +	 * 1. for kernel page tables during early boot
>> +	 * 2. for storage keys of huge pages and KVM
>> +	 * 3. As an indication that this page might be secure. This can
>> +	 *    overindicate, e.g. we set the bit before calling
>> +	 *    convert_to_secure.
>> +	 * As secure pages are never huge, all 3 variants can co-exists.
>> +	 */
>> +	if (!test_bit(PG_arch_1, &page->flags))
>> +		return 0;
>> +
>> +	rc = uv_pin_shared(page_to_phys(page));
>> +	if (!rc) {
>> +		clear_bit(PG_arch_1, &page->flags);
>> +		return 0;
>> +	}
> 
> Overall, looks sane to me. (I am mostly concerned about possible races,
> e.g., when two gmaps would be created for a single VM and nasty stuff be
> done with them). But yeah, I guess you guys thought about this ;)


