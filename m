Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D41002A9685
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 13:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727251AbgKFM4L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 07:56:11 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41060 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726939AbgKFM4L (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Nov 2020 07:56:11 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A6CXv52006773
        for <kvm@vger.kernel.org>; Fri, 6 Nov 2020 07:56:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=/5yUdr594Vg6RACUIoLz75P7lFhk7zPZO1Jj/H9fTjU=;
 b=QnXMWaAtOdrs+qDBPVzQE8EpueEsf1UO6rgVhD7aj9E4b5Wn99s4MK5lAxXJFCyf5e+r
 yG5tysbEiKNPwMd3Q4d5/SuxbhVD42n7zAf7LLailM216vFaOJrxxuKlZVN7PrGPAx3o
 T77oY/5Z8+F6bQ1KRtJyAIqJsNwcuZyyo5TUSm92GdAEmCs3Ldod7JO7IQuMhx363Qd7
 9t0+F3HMhRvmqBlw/tCU19EI2vBBJjQCtgBzs2cQpSnOT0VAw8lTaENNQ2VSpRXHEY+7
 BAVUKteLElTulawLw9aea13Q8Joa2EvIKWmuN6GzeDsY6ADQfHGT3NFtfGqxNYnKq4xY xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34ms00f5q5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 06 Nov 2020 07:56:10 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0A6CYqHH009873
        for <kvm@vger.kernel.org>; Fri, 6 Nov 2020 07:56:09 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34ms00f5pk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Nov 2020 07:56:09 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A6CqcFk009444;
        Fri, 6 Nov 2020 12:56:07 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 34h01kkbj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Nov 2020 12:56:07 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A6Cu5rP56295840
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Nov 2020 12:56:05 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2628E42049;
        Fri,  6 Nov 2020 12:56:05 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7EF042042;
        Fri,  6 Nov 2020 12:56:04 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.1.188])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 Nov 2020 12:56:04 +0000 (GMT)
Date:   Fri, 6 Nov 2020 13:56:03 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com, lvivier@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 6/7] lib/alloc.h: remove align_min
 from struct alloc_ops
Message-ID: <20201106135603.15ae1ea3@ibm-vm>
In-Reply-To: <f353e392-7a19-4657-3ee5-b609624d751e@redhat.com>
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
        <20201002154420.292134-7-imbrenda@linux.ibm.com>
        <f353e392-7a19-4657-3ee5-b609624d751e@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-06_04:2020-11-05,2020-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 clxscore=1011 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 phishscore=0 malwarescore=0 spamscore=0 suspectscore=2 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011060088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 6 Nov 2020 12:35:31 +0100
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 02/10/20 17:44, Claudio Imbrenda wrote:
> > Remove align_min from struct alloc_ops.  
> 
> ... because? :)

because nobody is using it anymore at this point :)

> Paolo
> 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >   lib/alloc.h      | 1 -
> >   lib/alloc_page.c | 1 -
> >   lib/alloc_phys.c | 9 +++++----
> >   lib/vmalloc.c    | 1 -
> >   4 files changed, 5 insertions(+), 7 deletions(-)
> > 
> > diff --git a/lib/alloc.h b/lib/alloc.h
> > index 9b4b634..db90b01 100644
> > --- a/lib/alloc.h
> > +++ b/lib/alloc.h
> > @@ -25,7 +25,6 @@
> >   struct alloc_ops {
> >   	void *(*memalign)(size_t alignment, size_t size);
> >   	void (*free)(void *ptr);
> > -	size_t align_min;
> >   };
> >   
> >   extern struct alloc_ops *alloc_ops;
> > diff --git a/lib/alloc_page.c b/lib/alloc_page.c
> > index 046082a..3c6c4ee 100644
> > --- a/lib/alloc_page.c
> > +++ b/lib/alloc_page.c
> > @@ -320,7 +320,6 @@ void *alloc_page()
> >   static struct alloc_ops page_alloc_ops = {
> >   	.memalign = memalign_pages,
> >   	.free = free_pages,
> > -	.align_min = PAGE_SIZE,
> >   };
> >   
> >   /*
> > diff --git a/lib/alloc_phys.c b/lib/alloc_phys.c
> > index 72e20f7..a4d2bf2 100644
> > --- a/lib/alloc_phys.c
> > +++ b/lib/alloc_phys.c
> > @@ -29,8 +29,8 @@ static phys_addr_t base, top;
> >   static void *early_memalign(size_t alignment, size_t size);
> >   static struct alloc_ops early_alloc_ops = {
> >   	.memalign = early_memalign,
> > -	.align_min = DEFAULT_MINIMUM_ALIGNMENT
> >   };
> > +static size_t align_min;
> >   
> >   struct alloc_ops *alloc_ops = &early_alloc_ops;
> >   
> > @@ -39,8 +39,7 @@ void phys_alloc_show(void)
> >   	int i;
> >   
> >   	spin_lock(&lock);
> > -	printf("phys_alloc minimum alignment: %#" PRIx64 "\n",
> > -		(u64)early_alloc_ops.align_min);
> > +	printf("phys_alloc minimum alignment: %#" PRIx64 "\n",
> > (u64)align_min); for (i = 0; i < nr_regions; ++i)
> >   		printf("%016" PRIx64 "-%016" PRIx64 " [%s]\n",
> >   			(u64)regions[i].base,
> > @@ -64,7 +63,7 @@ void phys_alloc_set_minimum_alignment(phys_addr_t
> > align) {
> >   	assert(align && !(align & (align - 1)));
> >   	spin_lock(&lock);
> > -	early_alloc_ops.align_min = align;
> > +	align_min = align;
> >   	spin_unlock(&lock);
> >   }
> >   
> > @@ -83,6 +82,8 @@ static phys_addr_t
> > phys_alloc_aligned_safe(phys_addr_t size, top_safe = MIN(top_safe,
> > 1ULL << 32); 
> >   	assert(base < top_safe);
> > +	if (align < align_min)
> > +		align = align_min;
> >   
> >   	addr = ALIGN(base, align);
> >   	size += addr - base;
> > diff --git a/lib/vmalloc.c b/lib/vmalloc.c
> > index 986a34c..b28a390 100644
> > --- a/lib/vmalloc.c
> > +++ b/lib/vmalloc.c
> > @@ -188,7 +188,6 @@ static void vm_free(void *mem)
> >   static struct alloc_ops vmalloc_ops = {
> >   	.memalign = vm_memalign,
> >   	.free = vm_free,
> > -	.align_min = PAGE_SIZE,
> >   };
> >   
> >   void __attribute__((__weak__)) find_highmem(void)
> >   
> 

