Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0EA121F38D
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 16:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbgGNOLn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 10:11:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45988 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725821AbgGNOLm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Jul 2020 10:11:42 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06EE27CF099445;
        Tue, 14 Jul 2020 10:11:40 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 329dhw1nff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 10:11:40 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06EE3WSJ105727;
        Tue, 14 Jul 2020 10:11:39 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 329dhw1nen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 10:11:39 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06EEBcCe004086;
        Tue, 14 Jul 2020 14:11:38 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 327527hqqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 14:11:38 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06EEBZG563242542
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 14:11:35 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ABD6942041;
        Tue, 14 Jul 2020 14:11:35 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22ED642068;
        Tue, 14 Jul 2020 14:11:35 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.7.230])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Jul 2020 14:11:35 +0000 (GMT)
Date:   Tue, 14 Jul 2020 16:11:33 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, frankja@linux.ibm.com, david@redhat.com,
        drjones@redhat.com, jmattson@google.com
Subject: Re: [kvm-unit-tests PATCH v1 2/2] lib/alloc_page: Fix compilation
 issue on 32bit archs
Message-ID: <20200714161133.32f4d1e7@ibm-vm>
In-Reply-To: <20200714140534.GB14404@linux.intel.com>
References: <20200714110919.50724-1-imbrenda@linux.ibm.com>
        <20200714110919.50724-3-imbrenda@linux.ibm.com>
        <866d79a4-0205-5d49-d407-4e3415b63762@redhat.com>
        <20200714134123.022b3117@ibm-vm>
        <20200714140534.GB14404@linux.intel.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-14_04:2020-07-14,2020-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 malwarescore=0 mlxscore=0 suspectscore=2 impostorscore=0 spamscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140104
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 Jul 2020 07:05:34 -0700
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> On Tue, Jul 14, 2020 at 01:41:23PM +0200, Claudio Imbrenda wrote:
> > On Tue, 14 Jul 2020 13:20:16 +0200
> > Thomas Huth <thuth@redhat.com> wrote:
> >   
> > > On 14/07/2020 13.09, Claudio Imbrenda wrote:  
> > > > The assert in lib/alloc_page is hardcoded to long, and size_t is
> > > > just an int on 32 bit architectures.
> > > > 
> > > > Adding a cast makes the compiler happy.
> > > > 
> > > > Fixes: 73f4b202beb39 ("lib/alloc_page: change some parameter
> > > > types") Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > > > ---
> > > >  lib/alloc_page.c | 5 +++--
> > > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/lib/alloc_page.c b/lib/alloc_page.c
> > > > index fa3c527..617b003 100644
> > > > --- a/lib/alloc_page.c
> > > > +++ b/lib/alloc_page.c
> > > > @@ -29,11 +29,12 @@ void free_pages(void *mem, size_t size)
> > > >  	assert_msg((unsigned long) mem % PAGE_SIZE == 0,
> > > >  		   "mem not page aligned: %p", mem);
> > > >  
> > > > -	assert_msg(size % PAGE_SIZE == 0, "size not page
> > > > aligned: %#lx", size);
> > > > +	assert_msg(size % PAGE_SIZE == 0, "size not page
> > > > aligned: %#lx",
> > > > +		(unsigned long)size);
> > > >  
> > > >  	assert_msg(size == 0 || (uintptr_t)mem == -size ||
> > > >  		   (uintptr_t)mem + size > (uintptr_t)mem,
> > > > -		   "mem + size overflow: %p + %#lx", mem,
> > > > size);
> > > > +		   "mem + size overflow: %p + %#lx", mem,
> > > > (unsigned long)size);    
> > > 
> > > Looking at lib/printf.c, it seems like it also supports %z ...
> > > have you tried?  
> > 
> > no, but in hindsight I should have. It's probably a much cleaner
> > solution. I'll try and respin.  
> 
> I'm not opposed to using size_t, but if we go that route then the
> entirety of alloc_page.c should be converted to size_t.  As is, there
> is code like:
> 
> 	void free_pages_by_order(void *mem, unsigned int order)
> 	{
>         	free_pages(mem, 1ul << (order + PAGE_SHIFT));
> 	}
> 
> and
> 
> 	void *alloc_pages(unsigned int order)
> 	{
> 		...
> 
> 		/* Looking for a run of length (1 << order). */
> 		unsigned long run = 0;
> 		const unsigned long n = 1ul << order;
> 		const unsigned long align_mask = (n << PAGE_SHIFT) -
> 1; void *run_start = NULL;
> 		void *run_prev = NULL;
> 		unsigned long run_next_pa = 0;
> 		unsigned long pa;
> 
> 		assert(order < sizeof(unsigned long) * 8);
> 
> 		...
> 	}
> 
> that very explicitly uses 'unsigned long' for the size.

don't worry, those won't stay there for long :)

once this patch series has stabilized, I'm going to send a more radical
rewrite of the allocators

