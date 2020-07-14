Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C59021EF8A
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 13:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgGNLld (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 07:41:33 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10970 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726748AbgGNLld (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Jul 2020 07:41:33 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06EBWvYM005525;
        Tue, 14 Jul 2020 07:41:30 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3279du4ugr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 07:41:30 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06EBZJbR010398;
        Tue, 14 Jul 2020 07:41:30 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3279du4ug7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 07:41:29 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06EBfSEb019938;
        Tue, 14 Jul 2020 11:41:28 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 327527u9m9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 11:41:27 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06EBe3mq20709778
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 11:40:03 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C5877A4059;
        Tue, 14 Jul 2020 11:41:25 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46874A404D;
        Tue, 14 Jul 2020 11:41:25 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.7.230])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Jul 2020 11:41:25 +0000 (GMT)
Date:   Tue, 14 Jul 2020 13:41:23 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, frankja@linux.ibm.com,
        david@redhat.com, drjones@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: Re: [kvm-unit-tests PATCH v1 2/2] lib/alloc_page: Fix compilation
 issue on 32bit archs
Message-ID: <20200714134123.022b3117@ibm-vm>
In-Reply-To: <866d79a4-0205-5d49-d407-4e3415b63762@redhat.com>
References: <20200714110919.50724-1-imbrenda@linux.ibm.com>
        <20200714110919.50724-3-imbrenda@linux.ibm.com>
        <866d79a4-0205-5d49-d407-4e3415b63762@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-14_02:2020-07-14,2020-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 clxscore=1015 phishscore=0 mlxscore=0 adultscore=0
 bulkscore=0 spamscore=0 malwarescore=0 priorityscore=1501 suspectscore=2
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140085
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 Jul 2020 13:20:16 +0200
Thomas Huth <thuth@redhat.com> wrote:

> On 14/07/2020 13.09, Claudio Imbrenda wrote:
> > The assert in lib/alloc_page is hardcoded to long, and size_t is
> > just an int on 32 bit architectures.
> > 
> > Adding a cast makes the compiler happy.
> > 
> > Fixes: 73f4b202beb39 ("lib/alloc_page: change some parameter types")
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  lib/alloc_page.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/lib/alloc_page.c b/lib/alloc_page.c
> > index fa3c527..617b003 100644
> > --- a/lib/alloc_page.c
> > +++ b/lib/alloc_page.c
> > @@ -29,11 +29,12 @@ void free_pages(void *mem, size_t size)
> >  	assert_msg((unsigned long) mem % PAGE_SIZE == 0,
> >  		   "mem not page aligned: %p", mem);
> >  
> > -	assert_msg(size % PAGE_SIZE == 0, "size not page aligned:
> > %#lx", size);
> > +	assert_msg(size % PAGE_SIZE == 0, "size not page aligned:
> > %#lx",
> > +		(unsigned long)size);
> >  
> >  	assert_msg(size == 0 || (uintptr_t)mem == -size ||
> >  		   (uintptr_t)mem + size > (uintptr_t)mem,
> > -		   "mem + size overflow: %p + %#lx", mem, size);
> > +		   "mem + size overflow: %p + %#lx", mem,
> > (unsigned long)size);  
> 
> Looking at lib/printf.c, it seems like it also supports %z ... have
> you tried?

no, but in hindsight I should have. It's probably a much cleaner
solution. I'll try and respin.

