Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AACA25F6A09
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 16:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiJFOu4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 10:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJFOuy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 10:50:54 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6DB38469
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 07:50:52 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 296EJI81028174;
        Thu, 6 Oct 2022 14:50:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=eBJPRGNF7Ffk/bTbBddIIeltiy/OQZSCWjz+FFs3SAA=;
 b=b7MFNZpp6NBtWshWsia0CLVW87K5y+w866KiJrTUXyHCaMv/sN7FPDpkW52ZMmv447zc
 ky6YAFFweRt9AzbDx+P0LHqtauOU4bnkrlpJmQoo5pBjqia7cnaP/VjaU0if9RAHk4on
 lxp8dVOItSyqD3ARvOr1DznXQ7+YstojVLu2tMHOj/2Wy1gBLQwvAamthnA/jEpqT2ud
 p9sxydJTRPCQggrOsK1soqQKr8aeK9kvYJcNr9uliIavXD15cBhp/TCX3M4K9uHEt4gl
 SE6kb4aO6lrSXzqBYts7T63I3e+wFqpK3/EW6rpA/+mYuN1qIAcG0sRha7cV+2m3XA/L Sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k20p80y1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Oct 2022 14:50:44 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 296ENxIL021223;
        Thu, 6 Oct 2022 14:50:44 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k20p80y0k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Oct 2022 14:50:44 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 296EZE3m021232;
        Thu, 6 Oct 2022 14:50:42 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3jxd68wbe8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Oct 2022 14:50:42 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 296EoeSQ54788436
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Oct 2022 14:50:40 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BFCF11C052;
        Thu,  6 Oct 2022 14:50:40 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E582111C04A;
        Thu,  6 Oct 2022 14:50:39 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.242])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  6 Oct 2022 14:50:39 +0000 (GMT)
Date:   Thu, 6 Oct 2022 16:50:37 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Laurent Vivier <lvivier@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 1/3] lib/vmalloc: Treat
 virt_to_pte_phys() as returning a physical address
Message-ID: <20221006165037.19b9488f@p-imbrenda>
In-Reply-To: <Yz7FZPWAsFV9Cwpv@monolith.localdoman>
References: <20221006111241.15083-1-alexandru.elisei@arm.com>
        <20221006111241.15083-2-alexandru.elisei@arm.com>
        <20221006133552.091bb41b@p-imbrenda>
        <Yz7FZPWAsFV9Cwpv@monolith.localdoman>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: S0daTmbDFxw4NvXwpfHRHmKDMNKlXnzO
X-Proofpoint-ORIG-GUID: 7oVn2xScM_2GcXOrVT_v4aI-kQqvqcTU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-06_02,2022-10-06_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 impostorscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210060085
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 6 Oct 2022 13:09:08 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> Hi,
> 
> On Thu, Oct 06, 2022 at 01:35:52PM +0200, Claudio Imbrenda wrote:
> > On Thu,  6 Oct 2022 12:12:39 +0100
> > Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> >   
> > > All architectures that implements virt_to_pte_phys() (s390x, x86,
> > > arm and arm64) return a physical address from the function. Teach
> > > vmalloc to treat it as such, instead of confusing the return
> > > value with a page table entry.  
> > 
> > I'm not sure I understand what you mean  
> 
> I thought that vmalloc uses PAGE_MASK because it expects
> virt_to_pte_phys() to return a pteval (because of the "pte' part in
> the virt_to_pte_phys()

I agree that the name of the function is confusing; there are comments
in lib/vmalloc.h and for virt_to_pte_phys it says:

/* Walk the page table and resolve the virtual address to a physical
address */

> function name), which might have the [PAGE_SHIFT-1:0] bits used to store
> page metadata by an architecture (like permissions), but like you've
> explained below it uses PAGE_MASK to align the page address (which is
> identically mapped) before passing it to the page allocator to be freed.
> 
> >   
> > > Changing things the other way around (having the function return a page
> > > table entry instead) is not feasible, because it is possible for an
> > > architecture to use the upper bits of the table entry to store metadata
> > > about the page.
> > > 
> > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > Cc: Thomas Huth <thuth@redhat.com>
> > > Cc: Andrew Jones <andrew.jones@linux.dev>
> > > Cc: Laurent Vivier <lvivier@redhat.com>
> > > Cc: Janosch Frank <frankja@linux.ibm.com>
> > > Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > > ---
> > >  lib/vmalloc.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/lib/vmalloc.c b/lib/vmalloc.c
> > > index 572682576cc3..0696b5da8190 100644
> > > --- a/lib/vmalloc.c
> > > +++ b/lib/vmalloc.c
> > > @@ -169,7 +169,7 @@ static void vm_free(void *mem)
> > >  	/* the pointer is not page-aligned, it was a single-page allocation */
> > >  	if (!IS_ALIGNED((uintptr_t)mem, PAGE_SIZE)) {
> > >  		assert(GET_MAGIC(mem) == VM_MAGIC);
> > > -		page = virt_to_pte_phys(page_root, mem) & PAGE_MASK;
> > > +		page = virt_to_pte_phys(page_root, mem);  
> > 
> > this will break things for small allocations, though. if the pointer is
> > not aligned, then the result of virt_to_pte_phys will also not be
> > aligned....  
> 
> I agree, I missed that part. Would be nice if it were written using
> PAGE_ALIGN to avoid mistakes like mine in the future, but that's

PAGE_ALIGN rounds UP, though, and we need to round down.

I think it's easier and more readable to & PAGE_MASK, instead of a more
cumbersome ALIGN_DOWN((thing), PAGE_SIZE)

> unimportant.
> 
> >   
> > >  		assert(page);
> > >  		free_page(phys_to_virt(page));  
> > 
> > ...and phys_to_virt will also return an unaligned address, and
> > free_page will complain about it.
> >   
> > >  		return;
> > > @@ -183,7 +183,7 @@ static void vm_free(void *mem)
> > >  	/* free all the pages including the metadata page */
> > >  	ptr = (uintptr_t)m & PAGE_MASK;  
> > 
> > ptr gets page aligned here
> >   
> > >  	for (i = 0 ; i < m->npages + 1; i++, ptr += PAGE_SIZE) {
> > > -		page = virt_to_pte_phys(page_root, (void *)ptr) & PAGE_MASK;
> > > +		page = virt_to_pte_phys(page_root, (void *)ptr);  
> > 
> > so virt_to_pte_phys will also return an aligned address;
> > I agree that & PAGE_MASK is redundant here  
> 
> You are correct, if we've ended up here it means that the pointer is
> already page aligned, and it will be incremented by PAGE_SIZE each
> iteration, hence the virt_to_pte_phys() will also be paged aligned.
> 
> I don't see much point in writing a patch just to remove the unnecessary
> alignment here, so I'll drop this patch entirely.
> 
> Thank you for the prompt explanation!

I'm glad things have been clarified :)

> 
> Alex
> 
> >   
> > >  		assert(page);
> > >  		free_page(phys_to_virt(page));
> > >  	}  
> >   

