Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B52E62E961B
	for <lists+kvm@lfdr.de>; Mon,  4 Jan 2021 14:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbhADNec (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 08:34:32 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59980 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726246AbhADNeb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Jan 2021 08:34:31 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 104DXPh3109302;
        Mon, 4 Jan 2021 08:33:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=48KUqjHCl8A2/VTk6p+JSlntNuv00EXDQiCrBOQ5Kog=;
 b=lD6rGyd3gxsVfBjQhCvhnq5CS788Vea20h1/FvutTIBl/d123FMhncvqVt4+z8xrStJW
 vOJ/TRxHDyEcUVZPCmEe9wq7HU05jkYIwa1hBxjuqYqqT74Kq+5OtpCpN6ehGjlp7Q6P
 QESJlys2PG+ReVDW9+wb8ljRCAsZ8V//412ruVbRzryVD/49duKXIYFud2qgnFXwphJ4
 MZ2JyNEe0bFSZ3YUVzvWL4KIGKX7h1u6iTlSeyMF50eBZ+EyGTfbyhA8ADr2bdnfrIxm
 qjNhD3oiNHbbUc09cQ7etIm2qZfzeJEWzSWhBhkiApZI7OjC3FZDIoMjccR3McF/fR7Y hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35v3eyh2ca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jan 2021 08:33:44 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 104DXhDZ110958;
        Mon, 4 Jan 2021 08:33:43 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35v3eyh2aq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jan 2021 08:33:43 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 104DXgTt017011;
        Mon, 4 Jan 2021 13:33:42 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 35tgf88ypn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jan 2021 13:33:41 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 104DXdtO30343616
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Jan 2021 13:33:39 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3DFB42042;
        Mon,  4 Jan 2021 13:33:39 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 329A44203F;
        Mon,  4 Jan 2021 13:33:39 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.0.177])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 Jan 2021 13:33:39 +0000 (GMT)
Date:   Mon, 4 Jan 2021 14:05:10 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, pbonzini@redhat.com, cohuck@redhat.com,
        lvivier@redhat.com, nadav.amit@gmail.com
Subject: Re: [kvm-unit-tests PATCH v1 06/12] lib/alloc.h: remove align_min
 from struct alloc_ops
Message-ID: <20210104140510.25ee0c71@ibm-vm>
In-Reply-To: <efd03516-a0cc-b897-5b12-e25114103f71@oracle.com>
References: <20201216201200.255172-1-imbrenda@linux.ibm.com>
        <20201216201200.255172-7-imbrenda@linux.ibm.com>
        <efd03516-a0cc-b897-5b12-e25114103f71@oracle.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-04_08:2021-01-04,2021-01-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 adultscore=0 suspectscore=0 bulkscore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 phishscore=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101040087
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Dec 2020 10:17:20 -0800
Krish Sadhukhan <krish.sadhukhan@oracle.com> wrote:

> On 12/16/20 12:11 PM, Claudio Imbrenda wrote:
> > Remove align_min from struct alloc_ops, since it is no longer used.
> >
> > Signed-off-by: Claudio Imbrenda<imbrenda@linux.ibm.com>
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
> > index 8d2700d..b1cdf21 100644
> > --- a/lib/alloc_page.c
> > +++ b/lib/alloc_page.c
> > @@ -385,7 +385,6 @@ void *memalign_pages_area(unsigned int area,
> > size_t alignment, size_t size) static struct alloc_ops
> > page_alloc_ops = { .memalign = memalign_pages,
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
> 
> 
> I don't see any caller of phys_alloc_set_minimum_alignment(). So when 

lib/arm/setup.c:150
lib/powerpc/setup.c:150

> you are comparing against this variable in phys_alloc_aligned_safe() 
> below, you are comparing against zero. Is that what you is intended
> or should 'align_min' be set some default ?

if the architecture specific code did not specify anything better, 0 is
ok.
 
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
> > index 7a49adf..e146162 100644
> > --- a/lib/vmalloc.c
> > +++ b/lib/vmalloc.c
> > @@ -190,7 +190,6 @@ static void vm_free(void *mem)
> >   static struct alloc_ops vmalloc_ops = {
> >   	.memalign = vm_memalign,
> >   	.free = vm_free,
> > -	.align_min = PAGE_SIZE,
> >   };
> >   
> >   void __attribute__((__weak__)) find_highmem(void)  

