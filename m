Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDF022200E
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 11:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgGPJ5Y convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 16 Jul 2020 05:57:24 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21306 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726075AbgGPJ5Y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Jul 2020 05:57:24 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06G9W9eS044695;
        Thu, 16 Jul 2020 05:57:22 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32afvm0v1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 05:57:21 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06G9pMqi097338;
        Thu, 16 Jul 2020 05:57:21 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32afvm0v0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 05:57:21 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06G9tZbF029699;
        Thu, 16 Jul 2020 09:57:19 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 327527wk69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 09:57:19 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06G9u2kJ40304868
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jul 2020 09:56:02 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03EDDA405C;
        Thu, 16 Jul 2020 09:56:02 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 656C6A405B;
        Thu, 16 Jul 2020 09:56:01 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.8.106])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 16 Jul 2020 09:56:01 +0000 (GMT)
Date:   Thu, 16 Jul 2020 11:55:59 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        frankja@linux.ibm.com, Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>, drjones@redhat.com,
        Jim Mattson <jmattson@google.com>
Subject: Re: [kvm-unit-tests PATCH v2 2/2] lib/alloc_page: Fix compilation
 issue on 32bit archs
Message-ID: <20200716115559.3b96bc86@ibm-vm>
In-Reply-To: <7F765FA6-FC63-4D82-BB13-00EF133CB031@gmail.com>
References: <20200714130030.56037-1-imbrenda@linux.ibm.com>
        <20200714130030.56037-3-imbrenda@linux.ibm.com>
        <7F765FA6-FC63-4D82-BB13-00EF133CB031@gmail.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-16_04:2020-07-16,2020-07-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 clxscore=1015 spamscore=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=2 malwarescore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007160072
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 16 Jul 2020 00:11:31 -0700
Nadav Amit <nadav.amit@gmail.com> wrote:

> > On Jul 14, 2020, at 6:00 AM, Claudio Imbrenda
> > <imbrenda@linux.ibm.com> wrote:
> > 
> > The assert in lib/alloc_page is hardcoded to long.
> > 
> > Use the z modifier instead, which is meant to be used for size_t.
> > 
> > Fixes: 73f4b202beb39 ("lib/alloc_page: change some parameter types")
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> > lib/alloc_page.c | 4 ++--
> > 1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/lib/alloc_page.c b/lib/alloc_page.c
> > index fa3c527..74fe726 100644
> > --- a/lib/alloc_page.c
> > +++ b/lib/alloc_page.c
> > @@ -29,11 +29,11 @@ void free_pages(void *mem, size_t size)
> > 	assert_msg((unsigned long) mem % PAGE_SIZE == 0,
> > 		   "mem not page aligned: %p", mem);
> > 
> > -	assert_msg(size % PAGE_SIZE == 0, "size not page aligned:
> > %#lx", size);
> > +	assert_msg(size % PAGE_SIZE == 0, "size not page aligned:
> > %#zx", size);
> > 
> > 	assert_msg(size == 0 || (uintptr_t)mem == -size ||
> > 		   (uintptr_t)mem + size > (uintptr_t)mem,
> > -		   "mem + size overflow: %p + %#lx", mem, size);
> > +		   "mem + size overflow: %p + %#zx", mem, size);
> > 
> > 	if (size == 0) {
> > 		freelist = NULL;
> > — 
> > 2.26.2  
> 
> Sean sent a different patch ("lib/alloc_page: Revert to 'unsigned
> long’ for @size params”) that changes size to unsigned long, so you
> really should synchronize.

I know, this is a (simpler) alternative to his patch.

