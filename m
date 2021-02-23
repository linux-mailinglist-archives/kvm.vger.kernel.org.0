Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00BEA322D68
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 16:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233212AbhBWPXs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 10:23:48 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40046 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233209AbhBWPXb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 10:23:31 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11NF47so025196;
        Tue, 23 Feb 2021 10:22:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=O2l4vL/PUetezLSw4Fx6MnyYM6DtzDbI7CHe/wIckFM=;
 b=Mb4Ope33c2ZAtG27jrn5SZLSTP/c9Un8yXiHtOKF8ze6sn0wcVoOgVQLEvhwEcXiW9Y+
 vtwNrE5846OvfS8CyEkE4X3z9DoaVEE+pHkfhTmVzvKdwT2U7eDTk9yoP0b9Aocsl8vb
 8YiQnRJW+vtW6fS3T6hhJfxa41/Ycss0823OTgRj8lWYhuCnZ6EQ/Qi9CMWCntfOKwJD
 +wa6wulg0w7KtWjpIJ79QD/tYpVekWe4a0sAvotx5wPetPJ5BQa0cN9Mm/BQhL6zMbd/
 ZdXJ2XFPffaZS20HXeoaggqrC7TSByCwvr+jB/R6U99qCf7yp8cmMRHdqMvbkRkJG6gS dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36vwmpdx71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 10:22:47 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11NF46JN024923;
        Tue, 23 Feb 2021 10:22:46 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36vwmpdx5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 10:22:46 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11NFMEGX022749;
        Tue, 23 Feb 2021 15:22:44 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 36tsph2qm8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 15:22:43 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11NFMSRu24248794
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 15:22:28 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F945A4054;
        Tue, 23 Feb 2021 15:22:41 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A07B5A405B;
        Tue, 23 Feb 2021 15:22:40 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.5.213])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Feb 2021 15:22:40 +0000 (GMT)
Date:   Tue, 23 Feb 2021 16:21:16 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com, pmorel@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 2/5] s390x: lib: fix pgtable.h
Message-ID: <20210223162116.12fbd4ad@ibm-vm>
In-Reply-To: <518e0f86-bbba-bd52-3962-2816b2f8ccf6@linux.ibm.com>
References: <20210223140759.255670-1-imbrenda@linux.ibm.com>
        <20210223140759.255670-3-imbrenda@linux.ibm.com>
        <518e0f86-bbba-bd52-3962-2816b2f8ccf6@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-23_08:2021-02-23,2021-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 spamscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230129
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Feb 2021 15:31:06 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 2/23/21 3:07 PM, Claudio Imbrenda wrote:
> > Fix pgtable.h:
> > 
> > * SEGMENT_ENTRY_SFAA had one extra bit set
> > * pmd entries don't have a length
> > * ipte does not need to clear the lower bits
> > * pud entries should use SEGMENT_TABLE_LENGTH, as they point to
> > segment tables
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  lib/s390x/asm/pgtable.h | 9 ++++-----
> >  1 file changed, 4 insertions(+), 5 deletions(-)
> > 
> > diff --git a/lib/s390x/asm/pgtable.h b/lib/s390x/asm/pgtable.h
> > index 277f3480..a2ff2d4e 100644
> > --- a/lib/s390x/asm/pgtable.h
> > +++ b/lib/s390x/asm/pgtable.h
> > @@ -60,7 +60,7 @@
> >  #define SEGMENT_SHIFT			20
> >  
> >  #define SEGMENT_ENTRY_ORIGIN		0xfffffffffffff800UL
> > -#define SEGMENT_ENTRY_SFAA		0xfffffffffff80000UL
> > +#define SEGMENT_ENTRY_SFAA		0xfffffffffff00000UL
> >  #define SEGMENT_ENTRY_AV		0x0000000000010000UL
> >  #define SEGMENT_ENTRY_ACC		0x000000000000f000UL
> >  #define SEGMENT_ENTRY_F			0x0000000000000800UL
> > @@ -183,7 +183,7 @@ static inline pmd_t *pmd_alloc(pud_t *pud,
> > unsigned long addr) if (pud_none(*pud)) {
> >  		pmd_t *pmd = pmd_alloc_one();
> >  		pud_val(*pud) = __pa(pmd) |
> > REGION_ENTRY_TT_REGION3 |
> > -				REGION_TABLE_LENGTH;
> > +				SEGMENT_TABLE_LENGTH;  
> 
> @David: I'd much rather have REGION_ENTRY_LENGTH instead of
> REGION_TABLE_LENGTH and SEGMENT_TABLE_LENGTH.

I'm weakly against it

> My argument is that this is not really an attribute of the table and

it actually is an attribute of the table. the *_TABLE_LENGTH fields
tell how long the _table pointed to_ is. we always allocate the full 4
pages, so in our case it will always be 0x3.

segment table entries don't have a length because they point to page
tables. region3 table entries point to segment tables, so they have
SEGMENT_TABLE_LENGTH in their length field.

> very much specific to the format of the (region table) entry. We
> already have the table order as a length anyway...
> 
> Could you tell me what you had in mind when splitting this?
> 
> >  	}
> >  	return pmd_offset(pud, addr);
> >  }
> > @@ -202,15 +202,14 @@ static inline pte_t *pte_alloc(pmd_t *pmd,
> > unsigned long addr) {
> >  	if (pmd_none(*pmd)) {
> >  		pte_t *pte = pte_alloc_one();
> > -		pmd_val(*pmd) = __pa(pte) |
> > SEGMENT_ENTRY_TT_SEGMENT |
> > -				SEGMENT_TABLE_LENGTH;
> > +		pmd_val(*pmd) = __pa(pte) |
> > SEGMENT_ENTRY_TT_SEGMENT;  
> 
> Uhhhh good catch!
> 
> >  	}
> >  	return pte_offset(pmd, addr);
> >  }
> >  
> >  static inline void ipte(unsigned long vaddr, pteval_t *p_pte)
> >  {
> > -	unsigned long table_origin = (unsigned long)p_pte &
> > PAGE_MASK;
> > +	unsigned long table_origin = (unsigned long)p_pte;
> >  
> >  	asm volatile(
> >  		"	ipte %0,%1\n"
> >   
> 
> IPTE ignores that data but having the page mask also doesn't hurt so
> generally this is not a fix, right?

apart from avoiding an unnecessary operation, there is a small nit:
IPTE wants the address of the page table, ignoring the rightmost _11_
bits. with PAGE_MASK we ignore the rightmost _12_ bits instead.
it's not an issue in practice, because we allocate one page table per
page anyway, wasting the second half of the page, so in our case that
stray bit will always be 0. but in case we decide to allocate the page
tables more tightly, or in case some testcase wants to manually play
tricks with the page tables, there might be the risk that IPTE would
target the wrong page table.

by not clearing the lower 12 bits we not only save an unnecessary
operation, but we are actually more architecturally correct.


