Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2195C2E961A
	for <lists+kvm@lfdr.de>; Mon,  4 Jan 2021 14:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbhADNeb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 08:34:31 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3130 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726189AbhADNeb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Jan 2021 08:34:31 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 104DVC8b125517;
        Mon, 4 Jan 2021 08:33:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=4NsaCC/d2ITN3XOxc6eydLmbyeHVHpIf6IXBy+QWhy4=;
 b=gL7T+3QZUUl99dkl6in0j14j2RMCwduKdwdmTay09Yx7sqH8uHSMFKLsVjeueSLj0aju
 UOXitPn6YOZqSr6dOBYWF/WLRUoNAr1uzWv2L+9TzARIvOGxO6o6gta5IzvuWtcjAvmd
 XsaFJhDM7p+1yLh6Sc3VIUDnFyLCLVKv67bLDOpSL5AxCMxgVxhDal1NJyT0fu1xpXWK
 Q5gu1iQyhL4idFosQo/1oKa/e1jCMNG0EgLZZ1St8qD+ppsiwjU3hhsXjmCK6HsIq8Q8
 tZ6CujkO8SrQGZlHqRgBfP4cCFrMVk5nWVuG2mtoG6fis7WewuntWEbXc+Eq01NikP/p Nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35v3ph0hsv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jan 2021 08:33:47 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 104DVB5u125470;
        Mon, 4 Jan 2021 08:33:47 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35v3ph0hrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jan 2021 08:33:47 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 104DXjKE010153;
        Mon, 4 Jan 2021 13:33:45 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 35tg3h9ww0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jan 2021 13:33:45 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 104DXghe39977268
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Jan 2021 13:33:43 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC2D742047;
        Mon,  4 Jan 2021 13:33:42 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E65B4203F;
        Mon,  4 Jan 2021 13:33:42 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.0.177])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 Jan 2021 13:33:42 +0000 (GMT)
Date:   Mon, 4 Jan 2021 14:32:57 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, pbonzini@redhat.com, cohuck@redhat.com,
        lvivier@redhat.com, nadav.amit@gmail.com
Subject: Re: [kvm-unit-tests PATCH v1 12/12] lib/alloc_page: default flags
 and zero pages by default
Message-ID: <20210104143257.31544269@ibm-vm>
In-Reply-To: <c61ee0fb-5d06-8c61-fa97-975c6a603599@oracle.com>
References: <20201216201200.255172-1-imbrenda@linux.ibm.com>
        <20201216201200.255172-13-imbrenda@linux.ibm.com>
        <c61ee0fb-5d06-8c61-fa97-975c6a603599@oracle.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-04_07:2021-01-04,2021-01-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 suspectscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101040084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Dec 2020 10:17:30 -0800
Krish Sadhukhan <krish.sadhukhan@oracle.com> wrote:

> On 12/16/20 12:12 PM, Claudio Imbrenda wrote:
> > The new function page_alloc_set_default_flags can be used to set the
> > default flags for allocations. The passed value will be ORed with
> > the flags argument passed to the allocator at each allocation.
> >
> > The default value for the default flags is FLAG_ZERO, which means
> > that by default all allocated memory is now zeroed, restoring the
> > default behaviour that had been accidentally removed by a previous
> > commit.
> >
> > If needed, a testcase can call page_alloc_set_default_flags(0) in
> > order to get non-zeroed pages from the allocator. For example, if
> > the testcase will need fresh memory, the zero flag should be
> > removed from the default.
> >
> > Fixes: 8131e91a4b61 ("lib/alloc_page: complete rewrite of the page
> > allocator") Reported-by: Nadav Amit<nadav.amit@gmail.com>
> >
> > Signed-off-by: Claudio Imbrenda<imbrenda@linux.ibm.com>
> > ---
> >   lib/alloc_page.h | 3 +++
> >   lib/alloc_page.c | 8 ++++++++
> >   2 files changed, 11 insertions(+)
> >
> > diff --git a/lib/alloc_page.h b/lib/alloc_page.h
> > index 1039814..8b53a58 100644
> > --- a/lib/alloc_page.h
> > +++ b/lib/alloc_page.h
> > @@ -22,6 +22,9 @@
> >   /* Returns true if the page allocator has been initialized */
> >   bool page_alloc_initialized(void);
> >   
> > +/* Sets the default flags for the page allocator, the default is
> > FLAG_ZERO */ +void page_alloc_set_default_flags(unsigned int flags);
> > +
> >   /*
> >    * Initializes a memory area.
> >    * n is the number of the area to initialize
> > diff --git a/lib/alloc_page.c b/lib/alloc_page.c
> > index 4d5722f..08e0d05 100644
> > --- a/lib/alloc_page.c
> > +++ b/lib/alloc_page.c
> > @@ -54,12 +54,19 @@ static struct mem_area areas[MAX_AREAS];
> >   static unsigned int areas_mask;
> >   /* Protects areas and areas mask */
> >   static struct spinlock lock;
> > +/* Default behaviour: zero allocated pages */
> > +static unsigned int default_flags = FLAG_ZERO;
> >   
> >   bool page_alloc_initialized(void)
> >   {
> >   	return areas_mask != 0;
> >   }
> >   
> > +void page_alloc_set_default_flags(unsigned int flags)
> > +{
> > +	default_flags = flags;  
> 
> 
> Who calls this functions ?

nobody yet, since I have just introduced them.

The idea is that a testcase should call this early on to set the default

> Just wondering if default flag should be a static set of flag values 
> which the caller can override based on needs rather than the caller 
> setting the default flag.

hmmmmm

I would only need to reverse the semantics of FLAG_ZERO, but then I can
get rid of this patch

I think I'll do it
 
> > +}
> > +
> >   /*
> >    * Each memory area contains an array of metadata entries at the
> > very
> >    * beginning. The usable memory follows immediately afterwards.
> > @@ -394,6 +401,7 @@ static void *page_memalign_order_flags(u8 ord,
> > u8 al, u32 flags) void *res = NULL;
> >   	int i, area, fresh;
> >   
> > +	flags |= default_flags;
> >   	fresh = !!(flags & FLAG_FRESH);
> >   	spin_lock(&lock);
> >   	area = (flags & AREA_MASK) ? flags & areas_mask :
> > areas_mask;  

