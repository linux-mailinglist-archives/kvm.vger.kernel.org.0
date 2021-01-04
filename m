Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6EB2E9BF1
	for <lists+kvm@lfdr.de>; Mon,  4 Jan 2021 18:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbhADRY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 12:24:29 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41368 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725840AbhADRY2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Jan 2021 12:24:28 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 104GX7GP045514
        for <kvm@vger.kernel.org>; Mon, 4 Jan 2021 12:23:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=RNgcEfnjDE3GxYrNAJzc+JVsyHiPHrnUDvt3qjpmSrw=;
 b=obvjt6jFiPABxAbm7ZBol+55tCZBlEMDFBCwHS3i+8hZB4iRrxXa1gU9UmS4FuYmhK4Z
 e+ZNhPdRp6etP1pTbSMVhSb/ihOjcXdxJ+7wADEN55siJNJVhN3+b4ElOPz5gV2qcRtQ
 ZXkMusIs8o3p0M/1W81fzTAJnlZ+EsPT0xsY/7X7ea4pHJlQuVOH/TH4rY0SrV/PDxgG
 gAR0Q6BaGlpV9DBg9M8vCp3G8W/5Lr0W6mCgUPrK6n9FHI1DHz6KDPzjSjuO14unM1df
 pzf9M7GGm/OLljOTkvZiiWrThhIzH0VudKinnt58M31ee6SQHgbZ2PfEdXUgZDq5bYg7 Gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35v6gb9h0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 04 Jan 2021 12:23:48 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 104HNl9w070961
        for <kvm@vger.kernel.org>; Mon, 4 Jan 2021 12:23:47 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35v6gb9h02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jan 2021 12:23:47 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 104HM4eL025148;
        Mon, 4 Jan 2021 17:23:45 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 35tgf8931u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jan 2021 17:23:45 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 104HNhZl45089238
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Jan 2021 17:23:43 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 223F35204F;
        Mon,  4 Jan 2021 17:23:43 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.0.177])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9FD3B52050;
        Mon,  4 Jan 2021 17:23:42 +0000 (GMT)
Date:   Mon, 4 Jan 2021 18:23:41 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, pbonzini@redhat.com, cohuck@redhat.com,
        lvivier@redhat.com, nadav.amit@gmail.com
Subject: Re: [kvm-unit-tests PATCH v1 05/12] lib/alloc_page: fix and improve
 the page allocator
Message-ID: <20210104182341.00c82b55@ibm-vm>
In-Reply-To: <X+ozTlQD0wePcOXJ@google.com>
References: <20201216201200.255172-1-imbrenda@linux.ibm.com>
        <20201216201200.255172-6-imbrenda@linux.ibm.com>
        <X+ozTlQD0wePcOXJ@google.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-04_10:2021-01-04,2021-01-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0
 priorityscore=1501 adultscore=0 clxscore=1015 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101040107
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 28 Dec 2020 11:34:38 -0800
Sean Christopherson <seanjc@google.com> wrote:

> On Wed, Dec 16, 2020, Claudio Imbrenda wrote:
> >  /*
> > - * Allocates and reserves the specified memory range if possible.
> > - * Returns NULL in case of failure.
> > + * Allocates and reserves the specified physical memory range if
> > possible.
> > + * If the specified range cannot be reserved in its entirety, no
> > action is
> > + * performed and false is returned.
> > + *
> > + * Returns true in case of success, false otherwise.
> >   */
> > -void *alloc_pages_special(uintptr_t addr, size_t npages);
> > +bool alloc_pages_special(phys_addr_t addr, size_t npages);  
> 
> The boolean return is a bit awkward as kernel programmers will likely

do you prefer int, with 0 for success and -1 for failure?
that's surely not a problem

> expect a non-zero return to mean failure.  But, since there are no
> users, can we simply drop the entire *_pages_special() API?
> Allocating a specific PFN that isn't MMIO seems doomed to fail
> anyways; I'm having a hard time envisioning a test that would be able
> to use such an API without being horribly fragile.

I can. s390x can use this for some tests, where we need to allocate
memory at within or outside of specific areas, which might only be
known at run time (so we can't use the memory areas)

the alternative would be to allocate all the memory, take what is
needed, and then free the rest.... not very elegant

> >  
> >  /*
> >   * Frees a reserved memory range that had been reserved with
> > @@ -91,6 +110,6 @@ void *alloc_pages_special(uintptr_t addr, size_t
> > npages);
> >   * exactly, it can also be a subset, in which case only the
> > specified
> >   * pages will be freed and unreserved.
> >   */
> > -void free_pages_special(uintptr_t addr, size_t npages);
> > +void free_pages_special(phys_addr_t addr, size_t npages);  

