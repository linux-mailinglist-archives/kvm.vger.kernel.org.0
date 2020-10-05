Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A07B283D31
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 19:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbgJERS1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 13:18:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6222 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725973AbgJERS1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Oct 2020 13:18:27 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 095H3Mv1101235
        for <kvm@vger.kernel.org>; Mon, 5 Oct 2020 13:18:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=pj7s95GBXG1ukwR6eNtYDj7xL8+qGJrzKXb+oxGc8bw=;
 b=CmvaXvMdIvtH1oPsobdTiv7FyC/a/6q1khgkRg0wbxBnq0izZS91+ZWmf2cLi2q7Rduz
 90T8bKa724x/nSKcPxCB9sXc+jtYDQzklWkqdttTB1C6Cq6wyBI78sqlY1ra5SnMuXwO
 GNdVEYTsvOy+yiVm4IVBQ3rKlI4L3RQ09pZ2lzgJi9mQkASrWkUjXT1cKwBf/xaap+cm
 zXeUJYGVaylSL6R5nkdEcUQWVoa1DkmGjkuopv5DHmT4MaW7477t0iXFXtOAb6FNR5NB
 inwEDoOAT/Sj+xR7WiBM0Q8Oi95BF2QhDCdNb4H3MAxMN/S0p5NmKOqlFjK7b/OaDqIQ NQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3407bt8vhu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 05 Oct 2020 13:18:25 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 095H4iNR112314
        for <kvm@vger.kernel.org>; Mon, 5 Oct 2020 13:18:25 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3407bt8vgu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 13:18:25 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 095HEHsU012477;
        Mon, 5 Oct 2020 17:18:23 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 33xgx8182y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 17:18:23 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 095HILIa26083760
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Oct 2020 17:18:21 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C5464C058;
        Mon,  5 Oct 2020 17:18:21 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A2784C040;
        Mon,  5 Oct 2020 17:18:20 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.2.175])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  5 Oct 2020 17:18:20 +0000 (GMT)
Date:   Mon, 5 Oct 2020 19:18:17 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        lvivier@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 4/7] lib/alloc_page: complete rewrite
 of the page allocator
Message-ID: <20201005191817.608eb451@ibm-vm>
In-Reply-To: <20201005165311.w37u3b2fpuqvf2ob@kamzik.brq.redhat.com>
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
        <20201002154420.292134-5-imbrenda@linux.ibm.com>
        <20201005124039.sf6mbytv5da3hxed@kamzik.brq.redhat.com>
        <20201005175613.1215b61e@ibm-vm>
        <20201005165311.w37u3b2fpuqvf2ob@kamzik.brq.redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-05_12:2020-10-05,2020-10-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 impostorscore=0 spamscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 suspectscore=2 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010050126
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 5 Oct 2020 18:53:11 +0200
Andrew Jones <drjones@redhat.com> wrote:

> On Mon, Oct 05, 2020 at 05:56:13PM +0200, Claudio Imbrenda wrote:
> > On Mon, 5 Oct 2020 14:40:39 +0200
> > Andrew Jones <drjones@redhat.com> wrote:
> >   
> > > On Fri, Oct 02, 2020 at 05:44:17PM +0200, Claudio Imbrenda wrote:
> > >  
> > > >  {
> > > > -	void *old_freelist;
> > > > -	void *end;
> > > > +	return (pfn >= PFN(a->page_states)) && (pfn < a->top);
> > > >    
> > > 
> > > Why are we comparing an input pfn with the page_states virtual
> > > pfn? I guess you want 'pfn >= base' ?  
> > 
> > no, I want to see if the address overlaps the start of the metadata,
> > which is placed immediately before the usable range. it is used in
> > one place below, unfortunately below the point at which you gave up
> > reading  
> 
> But we're mixing and matching virtual and physical addresses. I assume

the page allocator should work with physical pages and addresses, since
it works at a lower level than virtual addresses. 

> pfn is the physical frame number, thus physical. a->top should also
> be physical, but PFN(a->page_states) is virtual. Now that I understand
> what this function does, I think you want something like
> 
>   meta_start = PFN(virt_to_phys(a->page_states));
>   meta_end = PFN(virt_to_phys(&a->page_states[block_size]));
> 
>   (pfn >= meta_start && pfn < meta_end) || (pfn >= a->base && pfn <
> a->top)
> 
> There's also another metadata page to consider though, right? The one
> where the page_states pointer is stored.

no, that's a small static array, it's not stored inside the area
 
> > > > + *
> > > > + * The function depends on the following assumptions:
> > > > + * - The allocator must have been initialized
> > > > + * - the block must be within the memory area
> > > > + * - all pages in the block must be free and not special
> > > > + * - the pointer must point to the start of the block
> > > > + * - all pages in the block must have the same block size.    
> > > 
> > > pages should all have the same page size, no? How does a
> > > page have a block size?  
> > 
> > no, a page belongs to a power-of-two aligned block of pages, in the
> > worst case it's an order 0 block (so one page), but in most cases it
> > will belong to a larger block.  
> 
> So the comment should be "all blocks in the memory area must have
> the same block size" ?

no, all pages belonging to the block must have the same block size.
it's a basic sanity check. if a block of order e.g. 5 has some pages
marked with a different oder, then something went terribly wrong.

> > 
> > this is basically where we store the size of an allocation so we
> > don't have to provide it back again when freeing
> >   
> > > > + * - the block size must be greater than 0
> > > > + * - the block size must be smaller than the maximum allowed
> > > > + * - the block must be in a free list
> > > > + * - the function is called with the lock held
> > > > + */
> > > > +static void split(struct mem_area *a, void *addr)
> > > > +{
> > > > +	uintptr_t pfn = PFN(addr);    
> > > 
> > > addr appears to be virtual, since it's a 'void *', not a
> > > phys_addr_t.  
> > 
> > it's a pointer, doesn't mean it's virtual. In fact it will be
> > physical, since the page allocator only works with physical
> > addresses.  
> 
> That won't work for 32-bit processors that support physical addresses
> that are larger than 32-bits - if the target has more than 4G and the
> unit test wants to access that high memory. Using phys_addr_t
> everywhere you want a physical address avoids that problem.

no it doesn't. you can't even handle the freelist if it's in high
memory. consider that the current allocator also does not handle high
memory. and there is no infrastructure to shortly map high memory.

if a 32 bit test wants to access high memory, it will have to manage it
manually

> > 
> > if the MMU has been activated and all of memory is virtual but
> > identity mapped, it does not make any difference.  
> 
> True for 64-bit targets, not possible for targets than can't address
> all memory. Also, I don't think we should write general code that
> assumes we have an identity map, or that the current virtual mapping
> we're using is the identity mapping. It's best to be explicit with 
> 
>  phys_addr_t paddr = virt_to_phys(vaddr);
> 
> and then use paddr wherever a physical address is expected, not a
> pointer.

this means adding a lot of complexity to the infrastructure

> > 
> > the addresses do not belong to the vmalloc range
> >   
> > > PFN() only does a shift, so that's the virtual PFN. However we're
> > >  
> > 
> > again, it's just a PFN
> >   
> > > comparing that with memory area pfn's, which are supposed to be
> > > physical frame numbers, at least according to the comments in the
> > >  
> > 
> > correct. we are comparing physical PFNs with other physical PFNs  
> 
> Maybe. But that's not obvious from the code.
> 
> >   
> > > struct.
> > >   
> > > > +	struct linked_list *p;
> > > > +	uintptr_t i, idx;
> > > > +	u8 order;
> > > >  
> > > > -	assert_msg(size == 0 || (uintptr_t)mem == -size ||
> > > > -		   (uintptr_t)mem + size > (uintptr_t)mem,
> > > > -		   "mem + size overflow: %p + %#zx", mem,
> > > > size);
> > > > +	assert(a && area_contains(a, pfn));
> > > > +	idx = pfn - a->base;
> > > > +	order = a->page_states[idx];    
> > > 
> > > pfn - a->base could potentially be huge, so we can't be using that
> > > as an array index.  
> > 
> > this is exactly what we are doing. we need the index of the page in
> > the per-page metadata array.  
> 
> Ah right, one byte per page. That's indeed going to be a large array.
> 
> > 
> > from the array we get the order of the block the page belongs to.
> >    
> > > I think what you want is something like
> > > 
> > >  pfn = PFN(virt_to_phys(addr));
> > >  order = ffs(pfn) - 1;
> > >  if (pfn != order)
> > >    order <<= 1;
> > > 
> > > Then you have order and can use it as a index into an array if
> > > necessary.  
> > 
> > now this does not make any sense  
> 
> I was thinking we wanted the order of the address, not of some block
> the address is somehow associated with and mapped to by this byte.
> 
> >   
> > > > +	assert(!(order & ~ORDER_MASK) && order && (order <
> > > > NLISTS));    
> > > 
> > > What's wrong with order==0? What is ORDER_MASK good for?  
> > 
> > as written in the comment in the struct, the metadata contains the
> > order and a bit to mark when a page is allocated. ORDER_MASK is
> > used to extract the order part.
> > 
> > a block with order 0 is a single page. you cannot split a page.
> > that's why order 0 is bad.
> > 
> > split takes a pointer to a free block and splits the block in two
> > blocks of half the size each. this is needed when there are no free
> > blocks of the suitable size, but there are bigger free blocks
> >   
> > > > +	assert(IS_ALIGNED_ORDER(pfn, order));    
> > > 
> > > I'm getting the feeling that split() shouldn't operate on an
> > > addr, but rather some internal index of a block list or
> > > something. There are just too many requirements as to what addr
> > > is supposed to be.  
> > 
> > split is an internal function, it's static for a reason. basically
> > there is exactly one spot where it should be used, and that is the
> > one where it is used.
> >    
> > > > +	assert(area_contains(a, pfn + BIT(order) - 1));
> > > >  
> > > > -	if (size == 0) {
> > > > -		freelist = NULL;
> > > > -		return;
> > > > -	}
> > > > +	/* Remove the block from its free list */
> > > > +	p = list_remove(addr);    
> > > 
> > > So addr is a pointer to a linked_list object? I'm getting really
> > > confused.  
> > 
> > it's literally a free list; the beginning of each free block of
> > memory contains the pointers so that it can be handled using list
> > operations  
> 
> Using a list member for list operations and container_of() to get
> back to the object would help readability.

except that the "object" is the block of free memory, and the only
thing inside it is the list object at the very beginning. I think it's
overkill to use container_of in that case, since the only thing is the
list itself, and it's at the beginning of the free block.

> >   
> > > My editor says I'm only 30% of my way through this patch, so I
> > > don't think I'm going to have time to look at the rest. I think
> > > this patch is trying to do too much at once. IMO, we need to
> > > implement a single  
> > 
> > this patch is implementing the page allocator; it is a single new
> > feature.
> >   
> > > new feature at a time. Possibly starting with some cleanup patches
> > > for the current code first.  
> > 
> > there is no way to split this any further, I need to break some
> > interfaces, so I need to do it all at once.  
> 
> You can always build up a new implementation with a series of patches
> that don't wire up to anything. A final patch can simply wire up the
> new and delete the old.
> 
> Thanks,
> drew

so what I gather at the end is that I have to write a physical memory
allocator for a complex OS that has to seamlessly access high memory.

I'll try to come up with something
