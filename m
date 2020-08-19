Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F1124A327
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 17:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbgHSPcI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 11:32:08 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27482 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726854AbgHSPcI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Aug 2020 11:32:08 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07JFVw6k141213
        for <kvm@vger.kernel.org>; Wed, 19 Aug 2020 11:32:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=sKi1sjUIi53TTz6xJVfscGqGRHqK8JMNuirdtY/vmMM=;
 b=jvjY2COO5ario9Sh8cLrMj2etklaIUmCwyoQL2mp7ZmrLsQxprpRv8L3/tXk24+CQANt
 zdQX/Sr4iyPAkz6IPpbl4CTA2+B9IH4Kq6lDRdn0zmoRvCv+xKNuggVoL01atKN26cT5
 tuJsfqmrOFLVk7SbxLHtGNUFUhVJFBTnmwPAOZG6bXDQrLHHNMM1XOQNd2FD+qw8KUz7
 6Xym1XLNt/we8Cb/SUE8qVuhtww0jiQ/J+ZNBwnEBUo+c0HqA/TaD+MMYbbMt6bIfzOF
 Weh6RXf+u+vUKsIH25PZZ262NwuTV8FIHMLDPcYpBmj6fDYmcMe+eKliSHlMUxu5fgn4 dA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 330ycsy6wd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 19 Aug 2020 11:32:06 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07JFW5rs142045
        for <kvm@vger.kernel.org>; Wed, 19 Aug 2020 11:32:05 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 330ycsy6ky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 11:32:05 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07JFVKUt006051;
        Wed, 19 Aug 2020 15:31:29 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3304um21dm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 15:31:29 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07JFVR1C28901822
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Aug 2020 15:31:27 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A75C111C054;
        Wed, 19 Aug 2020 15:31:27 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3662011C058;
        Wed, 19 Aug 2020 15:31:27 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.6.45])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 Aug 2020 15:31:27 +0000 (GMT)
Date:   Wed, 19 Aug 2020 17:31:24 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com, lvivier@redhat.com
Subject: Re: [kvm-unit-tests RFC v1 1/5] lib/vmalloc: vmalloc support for
 handling allocation metadata
Message-ID: <20200819173124.1b293ab5@ibm-vm>
In-Reply-To: <a0d00459-cc91-b87d-5fae-063a4967e29f@linux.ibm.com>
References: <20200814151009.55845-1-imbrenda@linux.ibm.com>
        <20200814151009.55845-2-imbrenda@linux.ibm.com>
        <a0d00459-cc91-b87d-5fae-063a4967e29f@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_08:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 bulkscore=0 clxscore=1015 suspectscore=2
 priorityscore=1501 mlxscore=0 spamscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008190131
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 19 Aug 2020 16:36:07 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 8/14/20 5:10 PM, Claudio Imbrenda wrote:
> 
> LGTM, some smaller nits/questions below:
> 
> Commit message?

oops! I'll fix it

> 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  lib/vmalloc.c | 105
> > +++++++++++++++++++++++++++++++++++++++++++++----- 1 file changed,
> > 95 insertions(+), 10 deletions(-)
> > 
> > diff --git a/lib/vmalloc.c b/lib/vmalloc.c
> > index e0c7b6b..aca0876 100644
> > --- a/lib/vmalloc.c
> > +++ b/lib/vmalloc.c
> > @@ -15,6 +15,13 @@
> >  #include <bitops.h>
> >  #include "vmalloc.h"
> >  
> > +#define VM_MAGIC 0x7E57C0DE
> > +
> > +struct metadata {
> > +	unsigned long npages;
> > +	unsigned long magic;
> > +};
> > +
> >  static struct spinlock lock;
> >  static void *vfree_top = 0;
> >  static void *page_root;
> > @@ -25,8 +32,14 @@ static void *page_root;
> >   *
> >   * nr is the number of pages to allocate
> >   * alignment_pages is the alignment of the allocation *in pages*
> > + * metadata indicates whether an extra (unaligned) page needs to
> > be allocated
> > + * right before the main (aligned) allocation.
> > + *
> > + * The return value points to the first allocated virtual page,
> > which will
> > + * be the (potentially unaligned) metadata page if the metadata
> > flag is
> > + * specified.
> >   */
> > -void *alloc_vpages_aligned(ulong nr, unsigned int align_order)
> > +static void *do_alloc_vpages(ulong nr, unsigned int align_order,
> > bool metadata) {
> >  	uintptr_t ptr;
> >  
> > @@ -34,6 +47,8 @@ void *alloc_vpages_aligned(ulong nr, unsigned int
> > align_order) ptr = (uintptr_t)vfree_top;
> >  	ptr -= PAGE_SIZE * nr;
> >  	ptr &= GENMASK_ULL(63, PAGE_SHIFT + align_order);
> > +	if (metadata)
> > +		ptr -= PAGE_SIZE;
> >  	vfree_top = (void *)ptr;
> >  	spin_unlock(&lock);
> >  
> > @@ -41,6 +56,11 @@ void *alloc_vpages_aligned(ulong nr, unsigned
> > int align_order) return (void *)ptr;
> >  }
> >  
> > +void *alloc_vpages_aligned(ulong nr, unsigned int align_order)
> > +{
> > +	return do_alloc_vpages(nr, align_order, false);
> > +}
> > +
> >  void *alloc_vpages(ulong nr)
> >  {
> >  	return alloc_vpages_aligned(nr, 0);
> > @@ -69,35 +89,100 @@ void *vmap(phys_addr_t phys, size_t size)
> >  	return mem;
> >  }
> >  
> > +/*
> > + * Allocate one page, for an object with specified alignment.
> > + * The resulting pointer will be aligned to the required
> > alignment, but
> > + * intentionally not page-aligned.
> > + */
> > +static void *vm_alloc_one_page(size_t alignment)
> > +{
> > +	void *p;
> > +
> > +	assert(alignment >= sizeof(uintptr_t));
> > +	assert(alignment < PAGE_SIZE);
> > +	p = alloc_vpage();
> > +	install_page(page_root, virt_to_phys(alloc_page()), p);
> > +	/* write the magic at the beginning of the page */
> > +	*(uintptr_t *)p = VM_MAGIC;
> > +	return (void*)((uintptr_t)p + alignment);  
> 
> s/(void*)/(void *)/

will be fixed

> > +}
> > +
> > +static struct metadata *get_metadata(void *p)
> > +{
> > +	struct metadata *m = p;
> > +
> > +	return m - 1;
> > +}  
> 
> So the metadata is not at the start of the metadata page, but at the
> end? We have it at the beginning for the one page case and at the end
> for the multi page case with metadata on an extra page.

correct. it doesn't make a huge difference in the end where the
metadata is, as long as it is somewhere. Probably putting it always
right before the start of the memory is better, in order to catch
accidental off-by-one writes (as they would corrupt the magic value)

please note that the metadata for a single page is just the magic value

> > +
> >  /*
> >   * Allocate virtual memory, with the specified minimum alignment.
> > + * If the allocation fits in one page, only one page is allocated.
> > Otherwise
> > + * enough pages are allocated for the object, plus one to keep
> > metadata
> > + * information about the allocation.
> >   */
> >  static void *vm_memalign(size_t alignment, size_t size)
> >  {
> > +	struct metadata *m;
> >  	phys_addr_t pa;
> > -	void *mem, *p;
> > +	uintptr_t p;
> > +	void *mem;
> > +	size_t i;
> >  
> > +	if (!size)
> > +		return NULL;
> >  	assert(is_power_of_2(alignment));
> >  
> > +	if (alignment < sizeof(uintptr_t))
> > +		alignment = sizeof(uintptr_t);

                            ^^^^^^^^^^^^^^^^^

> > +	/* it fits in one page, allocate only one page */
> > +	if (alignment + size <= PAGE_SIZE)
> > +		return vm_alloc_one_page(alignment);  
> 
> Don't we also need to take the metadata into account in any size
> calculation for one page?

kinda... we guarantee a minimum alignment, which is enough to fit the
magic value, which is the only metadata item for single pages (see
above)

> >  	size = PAGE_ALIGN(size) / PAGE_SIZE;
> >  	alignment = get_order(PAGE_ALIGN(alignment) / PAGE_SIZE);
> > -	mem = p = alloc_vpages_aligned(size, alignment);
> > -	while (size--) {
> > +	mem = do_alloc_vpages(size, alignment, true);
> > +	p = (uintptr_t)mem;
> > +	/* skip the metadata page */
> > +	mem = (void *)(p + PAGE_SIZE);
> > +	/*
> > +	 * time to actually allocate the physical pages to back
> > our virtual
> > +	 * allocation; note that we need to allocate one extra
> > page (for the
> > +	 * metadata), hence the <=
> > +	 */
> > +	for (i = 0; i <= size; i++, p += PAGE_SIZE) {
> >  		pa = virt_to_phys(alloc_page());
> >  		assert(pa);
> > -		install_page(page_root, pa, p);
> > -		p += PAGE_SIZE;
> > +		install_page(page_root, pa, (void *)p);
> >  	}
> > +	m = get_metadata(mem);
> > +	m->npages = size;
> > +	m->magic = VM_MAGIC;
> >  	return mem;
> >  }
> >  
> >  static void vm_free(void *mem, size_t size)
> >  {
> > -	while (size) {
> > -		free_page(phys_to_virt(virt_to_pte_phys(page_root,
> > mem)));
> > -		mem += PAGE_SIZE;
> > -		size -= PAGE_SIZE;
> > +	struct metadata *m;
> > +	uintptr_t ptr, end;
> > +
> > +	/* the pointer is not page-aligned, it was a single-page
> > allocation */
> > +	if (!IS_ALIGNED((uintptr_t)mem, PAGE_SIZE)) {
> > +		ptr = virt_to_pte_phys(page_root, mem) & PAGE_MASK;
> > +		assert(*(uintptr_t *)ptr == VM_MAGIC);
> > +		free_page(phys_to_virt(ptr));
> > +		return;
> >  	}
> > +
> > +	/* the pointer is page-aligned, it was a multi-page
> > allocation */
> > +	m = get_metadata(mem);
> > +	assert(m->magic == VM_MAGIC);
> > +	assert(m->npages > 0);
> > +	/* free all the pages including the metadata page */
> > +	ptr = (uintptr_t)mem - PAGE_SIZE;
> > +	end = ptr + m->npages * PAGE_SIZE;
> > +	for ( ; ptr < end; ptr += PAGE_SIZE)
> > +		free_page(phys_to_virt(virt_to_pte_phys(page_root,
> > (void *)ptr)));
> > +	/* free the last one separately to avoid overflow issues */
> > +	free_page(phys_to_virt(virt_to_pte_phys(page_root, (void
> > *)ptr))); }
> >  
> >  static struct alloc_ops vmalloc_ops = {
> >   
> 
> 

