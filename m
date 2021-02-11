Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D0A318843
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 11:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbhBKKfB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 05:35:01 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40250 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230111AbhBKKbh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Feb 2021 05:31:37 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11BAQDni114663;
        Thu, 11 Feb 2021 05:30:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=t2Mhjrpyu+KS/SL+ku/0ueOIwlA2bntJdrrxUBsN1ig=;
 b=kqMAIXv8FYqV7ICgI8WmWTNn8VsJeS5MXwzy5oaX9zEf3ha9FOQg85PM7U8KOhrrKZX4
 S7K/FE/OQhLYi+IPmIGv/ynwupYCQ3+4tTfGTZLXqqmiLN/IB7Mb+Fjy3QbZeKLQvv36
 hCQfZTZxFQ1kZxEbmCapwxK3lv1IMfI2BDAbgeGt3zUYW9eKHsuA5PRZC6Sj8tvfa34Q
 P+fx2Pt74bqDn6WElkLYiI12HYX9LF2ZaoqOhmLEc3jMj0VwptqwXDF6VGFEPlX9a2hD
 J+ONFcyZFGM/FRSMwwRD08N51oXDkI1WEq8FD68par/r8uSaQJQCKJ3GVFp4llV/j6RW Ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36n2tyg2cd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 05:30:50 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11BAR0jn116482;
        Thu, 11 Feb 2021 05:30:50 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36n2tyg2br-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 05:30:50 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11BARGpp031083;
        Thu, 11 Feb 2021 10:30:48 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 36hjr8dp9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 10:30:47 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11BAUYBE34734512
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 10:30:34 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3E5EAE058;
        Thu, 11 Feb 2021 10:30:44 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89F8DAE04D;
        Thu, 11 Feb 2021 10:30:44 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.1.216])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 11 Feb 2021 10:30:44 +0000 (GMT)
Date:   Thu, 11 Feb 2021 11:30:42 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        frankja@linux.ibm.com, cohuck@redhat.com, pmorel@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v1 3/4] s390x: mmu: add support for large
 pages
Message-ID: <20210211113042.73553215@ibm-vm>
In-Reply-To: <9d99a22d-5bcd-5544-a78e-4fe0e025f961@redhat.com>
References: <20210209143835.1031617-1-imbrenda@linux.ibm.com>
        <20210209143835.1031617-4-imbrenda@linux.ibm.com>
        <9d99a22d-5bcd-5544-a78e-4fe0e025f961@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_05:2021-02-10,2021-02-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 malwarescore=0 impostorscore=0 suspectscore=0 phishscore=0 mlxlogscore=999
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102110088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 11 Feb 2021 11:06:06 +0100
Thomas Huth <thuth@redhat.com> wrote:

> On 09/02/2021 15.38, Claudio Imbrenda wrote:
> > Add support for 1M and 2G pages.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >   lib/s390x/mmu.h |  73 +++++++++++++-
> >   lib/s390x/mmu.c | 246
> > +++++++++++++++++++++++++++++++++++++++++++----- 2 files changed,
> > 294 insertions(+), 25 deletions(-)  
> [...]
> > +/*
> > + * Get the pte (page) DAT table entry for the given address and
> > pmd,
> > + * allocating it if necessary.
> > + * The pmd must not be large.
> > + */
> > +static inline pte_t *get_pte(pmd_t *pmd, uintptr_t vaddr)
> > +{
> >   	pte_t *pte = pte_alloc(pmd, vaddr);
> >   
> > -	return &pte_val(*pte);
> > +	assert(!pmd_large(*pmd));
> > +	pte = pte_alloc(pmd, vaddr);  
> 
> Why is this function doing "pte = pte_alloc(pmd, vaddr)" twice now?

ooops! the first pte_alloc is not supposed to be there!
good catch - will fix

> > +	return pte;
> > +}  
> [...]
> > +	if ((level == 1) && !pgd_none(*(pgd_t *)ptr))
> > +		idte_pgdp(va, ptr);
> > +	else if ((level == 2) && !p4d_none(*(p4d_t *)ptr))
> > +		idte_p4dp(va, ptr);
> > +	else if ((level == 3) && !pud_none(*(pud_t *)ptr))
> > +		idte_pudp(va, ptr);
> > +	else if ((level == 4) && !pmd_none(*(pmd_t *)ptr))
> > +		idte_pmdp(va, ptr);
> > +	else if (!pte_none(*(pte_t *)ptr))
> > +		ipte(va, ptr);  
> 
> Meta-comment: Being someone who worked quite a bit with the page
> tables on s390x, but never really got in touch with the way it is
> handled in the Linux kernel, I'm always having a hard time to match
> all these TLAs to the PoP: pmd, pud, p4d ...
> Can we please have a proper place in the kvm-unit-tests sources
> somewhere (maybe at the beginning of mmu.c), where the TLAs are
> explained and how they map to the region and segment tables of the Z
> architecture? (I personally would prefer to completely switch to the
> Z arch naming instead, but I guess that's too much of a change right
> now)

makes sense, I can add that

>   Thomas
> 

