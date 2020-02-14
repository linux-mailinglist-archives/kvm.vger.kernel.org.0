Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13D3E15F89C
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 22:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389465AbgBNVRP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 16:17:15 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34916 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387988AbgBNVRP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 16:17:15 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01ELAPhM001309
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 16:17:13 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y4j895yfk-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 16:17:13 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Fri, 14 Feb 2020 21:17:11 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 14 Feb 2020 21:17:08 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01ELH78p48890018
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Feb 2020 21:17:07 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38ECBA404D;
        Fri, 14 Feb 2020 21:17:07 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71EFBA4053;
        Fri, 14 Feb 2020 21:17:06 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.191.169])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Feb 2020 21:17:06 +0000 (GMT)
Subject: Re: [PATCH 05/35] s390/mm: provide memory management functions for
 protected KVM guests
To:     David Hildenbrand <david@redhat.com>,
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
 <1fb4da22-bab4-abe3-847b-5a7d79d84774@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Fri, 14 Feb 2020 22:17:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1fb4da22-bab4-abe3-847b-5a7d79d84774@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20021421-4275-0000-0000-000003A21141
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021421-4276-0000-0000-000038B611E8
Message-Id: <deb3faec-f05c-4fb0-9a4a-e38ee58a637d@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_07:2020-02-14,2020-02-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=839
 impostorscore=0 priorityscore=1501 spamscore=0 adultscore=0 mlxscore=0
 malwarescore=0 phishscore=0 clxscore=1015 lowpriorityscore=0
 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002140156
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In general this patch has changed a lot, but several comments still apply

On 14.02.20 18:59, David Hildenbrand wrote:
>>  
>>  /*
>> @@ -1086,12 +1106,16 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
>>  					    unsigned long addr,
>>  					    pte_t *ptep, int full)
>>  {
>> +	pte_t res;
> 
> Empty line missing.

ack

> 
>>  	if (full) {
>> -		pte_t pte = *ptep;
>> +		res = *ptep;
>>  		*ptep = __pte(_PAGE_INVALID);
>> -		return pte;
>> +	} else {
>> +		res = ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
>>  	}
>> -	return ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
>> +	if (mm_is_protected(mm) && pte_present(res))
>> +		uv_convert_from_secure(pte_val(res) & PAGE_MASK);
>> +	return res;
>>  }
> 
> [...]
> 
>> +int uv_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb);
>> +int uv_convert_from_secure(unsigned long paddr);
>> +
>> +static inline int uv_convert_to_secure(struct gmap *gmap, unsigned long gaddr)
>> +{
>> +	struct uv_cb_cts uvcb = {
>> +		.header.cmd = UVC_CMD_CONV_TO_SEC_STOR,
>> +		.header.len = sizeof(uvcb),
>> +		.guest_handle = gmap->guest_handle,
>> +		.gaddr = gaddr,
>> +	};
>> +
>> +	return uv_make_secure(gmap, gaddr, &uvcb);
>> +}
> 
> I'd actually suggest to name everything that eats a gmap "gmap_",
> 
> e.g., "gmap_make_secure()"
> 
> [...]

ack.

> 
>>  
>>  #if defined(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) ||                          \
>> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
>> index a06a628a88da..15ac598a3d8d 100644
>> --- a/arch/s390/kernel/uv.c
>> +++ b/arch/s390/kernel/uv.c
>> @@ -9,6 +9,8 @@
>>  #include <linux/sizes.h>
>>  #include <linux/bitmap.h>
>>  #include <linux/memblock.h>
>> +#include <linux/pagemap.h>
>> +#include <linux/swap.h>
>>  #include <asm/facility.h>
>>  #include <asm/sections.h>
>>  #include <asm/uv.h>
>> @@ -99,4 +101,174 @@ void adjust_to_uv_max(unsigned long *vmax)
>>  	if (prot_virt_host && *vmax > uv_info.max_sec_stor_addr)
>>  		*vmax = uv_info.max_sec_stor_addr;
>>  }
>> +
>> +static int __uv_pin_shared(unsigned long paddr)
>> +{
>> +	struct uv_cb_cfs uvcb = {
>> +		.header.cmd	= UVC_CMD_PIN_PAGE_SHARED,
>> +		.header.len	= sizeof(uvcb),
>> +		.paddr		= paddr,
> 
> please drop all the superfluous spaces (just as in the other uv calls).

ack

> 
>> +	};
>> +
>> +	if (uv_call(0, (u64)&uvcb))
>> +		return -EINVAL;
>> +	return 0;
>> +}
> 
> [...]
> 
>> +static int make_secure_pte(pte_t *ptep, unsigned long addr, void *data)
>> +{
>> +	struct conv_params *params = data;
>> +	pte_t entry = READ_ONCE(*ptep);
>> +	struct page *page;
>> +	int expected, rc = 0;
>> +
>> +	if (!pte_present(entry))
>> +		return -ENXIO;
>> +	if (pte_val(entry) & (_PAGE_INVALID | _PAGE_PROTECT))
>> +		return -ENXIO;
>> +
>> +	page = pte_page(entry);
>> +	if (page != params->page)
>> +		return -ENXIO;
>> +
>> +	if (PageWriteback(page))
>> +		return -EAGAIN;
>> +	expected = expected_page_refs(page);
> 
> I do wonder if we could factor out expected_page_refs() and reuse from
> other sources ...
> 
> I do wonder about huge page backing of guests, and especially
> hpage_nr_pages(page) used in mm/migrate.c:expected_page_refs(). But I
> can spot some hugepage exclusion below ... This needs comments.

Yes, we looked into several places and ALL places do their own math with their
own side conditions. There is no single function that accounts all possible
conditions and I am not going to start that now given the review bandwidth of
the mm tree.

I will add:
/*
 * Calculate the expected ref_count for a page that would otherwise have no
 * further pins. This was cribbed from similar functions in other places in
 * the kernel, but with some slight modifications. We know that a secure
 * page can not be a huge page for example.
 */
to expected page count

and something to the hugetlb check.




> 
>> +	if (!page_ref_freeze(page, expected))
>> +		return -EBUSY;
>> +	set_bit(PG_arch_1, &page->flags);
> 
> Can we please document somewhere how PG_arch_1 is used on s390x? (page)
> 
> "The generic code guarantees that this bit is cleared for a page when it
> first is entered into the page cache" - should not be an issue, right?

Right
> 
>> +	rc = uv_call(0, (u64)params->uvcb);
>> +	page_ref_unfreeze(page, expected);
>> +	if (rc)
>> +		rc = (params->uvcb->rc == 0x10a) ? -ENXIO : -EINVAL;
>> +	return rc;
>> +}
>> +
>> +/*
>> + * Requests the Ultravisor to make a page accessible to a guest.
>> + * If it's brought in the first time, it will be cleared. If
>> + * it has been exported before, it will be decrypted and integrity
>> + * checked.
>> + *
>> + * @gmap: Guest mapping
>> + * @gaddr: Guest 2 absolute address to be imported
> 
> I'd just drop the the (incomplete) parameter documentation, everybody
> reaching this point should now what a gmap and what a gaddr is ...

ack.
> 
>> + */
>> +int uv_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
>> +{
>> +	struct conv_params params = { .uvcb = uvcb };
>> +	struct vm_area_struct *vma;
>> +	unsigned long uaddr;
>> +	int rc, local_drain = 0;
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
>> +	if (is_vm_hugetlb_page(vma))
>> +		goto out;
> 
> Hah there it is! How is it enforced on upper layers/excluded? Will
> hpage=true fail with prot virt? What if a guest is not a protected guest
> but wants to sue huge pages? This needs comments/patch description.

will add

        /*
         * Secure pages cannot be huge and userspace should not combine both.
         * In case userspace does it anyway this will result in an -EFAULT for
         * the unpack. The guest is thus never reaching secure mode. If
         * userspace is playing dirty tricky with mapping huge pages later
         * on this will result in a segmenation fault.
         */


> 
>> +
>> +	rc = -ENXIO;
>> +	params.page = follow_page(vma, uaddr, FOLL_WRITE | FOLL_NOWAIT);
>> +	if (IS_ERR_OR_NULL(params.page))
>> +		goto out;
>> +
>> +	lock_page(params.page);
>> +	rc = apply_to_page_range(gmap->mm, uaddr, PAGE_SIZE, make_secure_pte, &params);
> 
> Ehm, isn't it just always a single page?

Yes, already fixed.

> 
>> +	unlock_page(params.page);
>> +out:
>> +	up_read(&gmap->mm->mmap_sem);
>> +
>> +	if (rc == -EBUSY) {
>> +		if (local_drain) {
>> +			lru_add_drain_all();
>> +			return -EAGAIN;
>> +		}
>> +		lru_add_drain();
> 
> comments please why that is performed.

done

> 
>> +		local_drain = 1;
[..]

>> +
>> +	if (PageHuge(page))
>> +		return 0;
> 
> Ah, another instance. Comment please why
> 
>> +
>> +	if (!test_bit(PG_arch_1, &page->flags))
>> +		return 0;
> 
> "Can you describe the meaning of this bit with three words"? Or a couple
> more? :D
> 
> "once upon a time, the page was secure and still might be" ?
> "the page is secure and therefore inaccessible" ?


        /*
         * PG_arch_1 is used in 3 places:
         * 1. for kernel page tables during early boot
         * 2. for storage keys of huge pages and KVM
         * 3. As an indication that this page might be secure. This can
         *    overindicate, e.g. we set the bit before calling
         *    convert_to_secure.
         * As secure pages are never huge, all 3 variants can co-exists.
         */

> 
>> +
>> +	rc = __uv_pin_shared(page_to_phys(page));
>> +	if (!rc) {
>> +		clear_bit(PG_arch_1, &page->flags);
>> +		return 0;
>> +	}
>> +
>> +	rc = uv_convert_from_secure(page_to_phys(page));
>> +	if (!rc) {
>> +		clear_bit(PG_arch_1, &page->flags);
>> +		return 0;
>> +	}
>> +
>> +	return rc;
>> +}
>> +EXPORT_SYMBOL_GPL(arch_make_page_accessible);
>> +
>>  #endif
>>
> 
> More code comments would be highly appreciated!
> 
done

