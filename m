Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A54213B58
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 15:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbgGCNtw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 09:49:52 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18920 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726272AbgGCNtv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Jul 2020 09:49:51 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 063DWF0U130793
        for <kvm@vger.kernel.org>; Fri, 3 Jul 2020 09:49:50 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 320yr6gkpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 03 Jul 2020 09:49:50 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 063DY8SD140662
        for <kvm@vger.kernel.org>; Fri, 3 Jul 2020 09:49:50 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 320yr6gkp2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 09:49:49 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 063Dl8M2027868;
        Fri, 3 Jul 2020 13:49:47 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 31wwr8bf3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 13:49:47 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 063Dnj3P49283170
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Jul 2020 13:49:45 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A3324C040;
        Fri,  3 Jul 2020 13:49:45 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EBCA24C046;
        Fri,  3 Jul 2020 13:49:44 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.9.164])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  3 Jul 2020 13:49:44 +0000 (GMT)
Date:   Fri, 3 Jul 2020 15:49:42 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, frankja@linux.ibm.com,
        thuth@redhat.com, david@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 4/4] lib/vmalloc: allow vm_memalign
 with alignment > PAGE_SIZE
Message-ID: <20200703154942.6a6513bc@ibm-vm>
In-Reply-To: <20200703123001.o7kbtfaeq3rml6zo@kamzik.brq.redhat.com>
References: <20200703115109.39139-1-imbrenda@linux.ibm.com>
        <20200703115109.39139-5-imbrenda@linux.ibm.com>
        <20200703123001.o7kbtfaeq3rml6zo@kamzik.brq.redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-03_09:2020-07-02,2020-07-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 cotscore=-2147483648 clxscore=1015 spamscore=0 suspectscore=0 adultscore=0
 phishscore=0 mlxlogscore=999 priorityscore=1501 bulkscore=0
 impostorscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007030091
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 3 Jul 2020 14:30:01 +0200
Andrew Jones <drjones@redhat.com> wrote:

[...]

> > -void *alloc_vpages(ulong nr)
> > +/*
> > + * Allocate a certain number of pages from the virtual address
> > space (without
> > + * physical backing).
> > + *
> > + * nr is the number of pages to allocate
> > + * alignment_pages is the alignment of the allocation *in pages*
> > + */
> > +static void *alloc_vpages_intern(ulong nr, unsigned int
> > alignment_pages)  
> 
> This helper function isn't necessary. Just introduce
> alloc_vpages_aligned() and then call alloc_vpages_aligned(nr, 1) from
> alloc_vpages().

the helper will actually be useful in future patches.

maybe I should have written that in the patch description.

I can respin without helper if you prefer (and introduce it when
needed) or simply update the patch description.

> >  {
> >  	uintptr_t ptr;
> >  
> >  	spin_lock(&lock);
> >  	ptr = (uintptr_t)vfree_top;
> >  	ptr -= PAGE_SIZE * nr;
> > +	ptr &= GENMASK_ULL(63, PAGE_SHIFT +
> > get_order(alignment_pages)); vfree_top = (void *)ptr;
> >  	spin_unlock(&lock);
> >  
> > @@ -32,6 +41,16 @@ void *alloc_vpages(ulong nr)
> >  	return (void *)ptr;
> >  }
> >  
> > +void *alloc_vpages(ulong nr)
> > +{
> > +	return alloc_vpages_intern(nr, 1);
> > +}
> > +
> > +void *alloc_vpages_aligned(ulong nr, unsigned int alignment_pages)
> > +{
> > +	return alloc_vpages_intern(nr, alignment_pages);
> > +}
> > +
> >  void *alloc_vpage(void)
> >  {
> >  	return alloc_vpages(1);
> > @@ -55,17 +74,22 @@ void *vmap(phys_addr_t phys, size_t size)
> >  	return mem;
> >  }
> >  
> > +/*
> > + * Allocate virtual memory, with the specified minimum alignment.
> > + */
> >  static void *vm_memalign(size_t alignment, size_t size)
> >  {
> > +	phys_addr_t pa;
> >  	void *mem, *p;
> > -	size_t pages;
> >  
> > -	assert(alignment <= PAGE_SIZE);
> > -	size = PAGE_ALIGN(size);
> > -	pages = size / PAGE_SIZE;
> > -	mem = p = alloc_vpages(pages);
> > -	while (pages--) {
> > -		phys_addr_t pa = virt_to_phys(alloc_page());
> > +	assert(is_power_of_2(alignment));
> > +
> > +	size = PAGE_ALIGN(size) / PAGE_SIZE;
> > +	alignment = PAGE_ALIGN(alignment) / PAGE_SIZE;
> > +	mem = p = alloc_vpages_intern(size, alignment);
> > +	while (size--) {
> > +		pa = virt_to_phys(alloc_page());
> > +		assert(pa);
> >  		install_page(page_root, pa, p);
> >  		p += PAGE_SIZE;
> >  	}
> > -- 
> > 2.26.2
> >  
> 
> Otherwise
> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> 
> Thanks,
> drew 
> 

