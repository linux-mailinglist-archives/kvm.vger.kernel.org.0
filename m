Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A97394095
	for <lists+kvm@lfdr.de>; Fri, 28 May 2021 12:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236395AbhE1KE6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 May 2021 06:04:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28426 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236203AbhE1KEt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 May 2021 06:04:49 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14SA2trl067418;
        Fri, 28 May 2021 06:03:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=s03VCbUyq4npk5awr3jvzJuqpz8UuKa9dzXECUCiQic=;
 b=m8ohn8NyLS/YZVgnk+GHcoisPK1jgnIVzfP/jBsaN+r6CL/KwF+i45pnULxOlIo65SUy
 jWRbJmHPFt1PJIgHNhCaD9yL6kNGXovwIesKYo3kzPILx+PAW2RofmMY8xyO/Wv+sPhf
 oNKlBP87HPcPsfVEcr+v5z6x4H4zvCh1t1BXvT+oezzC/ujsPyDoPP5J4oEoMwAF2L51
 1+uJtJ1PKLqsNIEebHWGaK1A4T6PqzyrhBhL3thfMnDpQMxt/Iv0uc4jrLEcbnM/Zty2
 9giEcwzrS5Ha3tswStARfhQLHUvJ+cB79gN2BvsuXaBpGO/LRKPruJf3vKrwPO4roif/ yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38tw29jusv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 May 2021 06:03:14 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14SA3DZv068958;
        Fri, 28 May 2021 06:03:13 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38tw29jusc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 May 2021 06:03:13 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14SA02vr012565;
        Fri, 28 May 2021 10:03:12 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 38s1r49pyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 May 2021 10:03:12 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14SA2eSv35782918
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 May 2021 10:02:40 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9740AAE053;
        Fri, 28 May 2021 10:03:09 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 381F2AE04D;
        Fri, 28 May 2021 10:03:09 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.7.194])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 28 May 2021 10:03:09 +0000 (GMT)
Date:   Fri, 28 May 2021 12:03:06 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 6/7] s390x: mmu: add support for large
 pages
Message-ID: <20210528120306.2ea079cf@ibm-vm>
In-Reply-To: <23d596c4-331f-088c-8373-74df78568e8a@linux.ibm.com>
References: <20210526134245.138906-1-imbrenda@linux.ibm.com>
        <20210526134245.138906-7-imbrenda@linux.ibm.com>
        <23d596c4-331f-088c-8373-74df78568e8a@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: b-JyX2ZpXWAOi4ZUrxij3Y92CYCKZDk_
X-Proofpoint-ORIG-GUID: uk7w_0R02-qjowF9AqeSpNSyPpvSsD5p
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-28_04:2021-05-27,2021-05-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0 mlxscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105280067
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 28 May 2021 10:44:32 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 5/26/21 3:42 PM, Claudio Imbrenda wrote:
> > Add support for 1M and 2G pages.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  lib/s390x/mmu.h |  73 +++++++++++++-
> >  lib/s390x/mmu.c | 260
> > +++++++++++++++++++++++++++++++++++++++++++----- 2 files changed,
> > 307 insertions(+), 26 deletions(-)
> > 
> > diff --git a/lib/s390x/mmu.h b/lib/s390x/mmu.h
> > index 603f289e..93208467 100644
> > --- a/lib/s390x/mmu.h
> > +++ b/lib/s390x/mmu.h
> > @@ -10,9 +10,78 @@
> >  #ifndef _ASMS390X_MMU_H_
> >  #define _ASMS390X_MMU_H_
> >  
> > -void protect_page(void *vaddr, unsigned long prot);
> > +/*
> > + * Splits the pagetables down to the given DAT tables level.
> > + * Returns a pointer to the DAT table entry of the given level.
> > + * @pgtable root of the page table tree
> > + * @vaddr address whose page tables are to split
> > + * @level 3 (for 2GB pud), 4 (for 1 MB pmd) or 5 (for 4KB pages)
> > + */
> > +void *split_page(pgd_t *pgtable, void *vaddr, unsigned int level);
> > +
> > +/*
> > + * Applies the given protection bits to the given DAT tables level,
> > + * splitting if necessary.
> > + * @pgtable root of the page table tree
> > + * @vaddr address whose protection bits are to be changed
> > + * @prot the protection bits to set
> > + * @level 3 (for 2GB pud), 4 (for 1MB pmd) or 5 (for 4KB pages)
> > + */
> > +void protect_dat_entry(void *vaddr, unsigned long prot, unsigned
> > int level); +/*
> > + * Clears the given protection bits from the given DAT tables
> > level,
> > + * splitting if necessary.
> > + * @pgtable root of the page table tree
> > + * @vaddr address whose protection bits are to be changed
> > + * @prot the protection bits to clear
> > + * @level 3 (for 2GB pud), 4 (for 1MB pmd) or 5 (for 4kB pages)
> > + */
> > +void unprotect_dat_entry(void *vaddr, unsigned long prot, unsigned
> > int level); +
> > +/*
> > + * Applies the given protection bits to the given 4kB pages range,
> > + * splitting if necessary.
> > + * @start starting address whose protection bits are to be changed
> > + * @len size in bytes
> > + * @prot the protection bits to set
> > + */
> >  void protect_range(void *start, unsigned long len, unsigned long
> > prot); -void unprotect_page(void *vaddr, unsigned long prot);
> > +/*
> > + * Clears the given protection bits from the given 4kB pages range,
> > + * splitting if necessary.
> > + * @start starting address whose protection bits are to be changed
> > + * @len size in bytes
> > + * @prot the protection bits to set
> > + */
> >  void unprotect_range(void *start, unsigned long len, unsigned long
> > prot); 
> > +/* Similar to install_page, maps the virtual address to the
> > physical address
> > + * for the given page tables, using 1MB large pages.
> > + * Returns a pointer to the DAT table entry.
> > + * @pgtable root of the page table tree
> > + * @phys physical address to map, must be 1MB aligned!
> > + * @vaddr virtual address to map, must be 1MB aligned!
> > + */
> > +pmdval_t *install_large_page(pgd_t *pgtable, phys_addr_t phys,
> > void *vaddr); +
> > +/* Similar to install_page, maps the virtual address to the
> > physical address
> > + * for the given page tables, using 2GB huge pages.
> > + * Returns a pointer to the DAT table entry.
> > + * @pgtable root of the page table tree
> > + * @phys physical address to map, must be 2GB aligned!
> > + * @vaddr virtual address to map, must be 2GB aligned!
> > + */
> > +pudval_t *install_huge_page(pgd_t *pgtable, phys_addr_t phys, void
> > *vaddr); +
> > +static inline void protect_page(void *vaddr, unsigned long prot)
> > +{
> > +	protect_dat_entry(vaddr, prot, 5);
> > +}
> > +
> > +static inline void unprotect_page(void *vaddr, unsigned long prot)
> > +{
> > +	unprotect_dat_entry(vaddr, prot, 5);
> > +}  
> 
> \n
> 
> > +void *get_dat_entry(pgd_t *pgtable, void *vaddr, unsigned int
> > level); +
> >  #endif /* _ASMS390X_MMU_H_ */
> > diff --git a/lib/s390x/mmu.c b/lib/s390x/mmu.c
> > index 5c517366..def91334 100644
> > --- a/lib/s390x/mmu.c
> > +++ b/lib/s390x/mmu.c
> > @@ -15,6 +15,18 @@
> >  #include <vmalloc.h>
> >  #include "mmu.h"
> >  
> > +/*
> > + * The naming convention used here is the same as used in the
> > Linux kernel,
> > + * and this is the corrispondence between the s390x architectural
> > names and  
> 
> corresponds

oops

> > + * the Linux ones:
> > + *
> > + * pgd - region 1 table entry
> > + * p4d - region 2 table entry
> > + * pud - region 3 table entry
> > + * pmd - segment table entry
> > + * pte - page table entry
> > + */
> > +
> >  static pgd_t *table_root;
> >  
> >  void configure_dat(int enable)
> > @@ -46,54 +58,254 @@ static void mmu_enable(pgd_t *pgtable)
> >  	lc->pgm_new_psw.mask |= PSW_MASK_DAT;
> >  }
> >  
> > -static pteval_t *get_pte(pgd_t *pgtable, uintptr_t vaddr)
> > +/*
> > + * Get the pud (region 3) DAT table entry for the given address
> > and root,
> > + * allocating it if necessary
> > + */
> > +static inline pud_t *get_pud(pgd_t *pgtable, uintptr_t vaddr)
> >  {
> >  	pgd_t *pgd = pgd_offset(pgtable, vaddr);
> >  	p4d_t *p4d = p4d_alloc(pgd, vaddr);
> >  	pud_t *pud = pud_alloc(p4d, vaddr);
> > -	pmd_t *pmd = pmd_alloc(pud, vaddr);
> > -	pte_t *pte = pte_alloc(pmd, vaddr);
> >  
> > -	return &pte_val(*pte);
> > +	return pud;
> > +}
> > +
> > +/*
> > + * Get the pmd (segment) DAT table entry for the given address and
> > pud,
> > + * allocating it if necessary.
> > + * The pud must not be huge.
> > + */
> > +static inline pmd_t *get_pmd(pud_t *pud, uintptr_t vaddr)
> > +{
> > +	pmd_t *pmd;
> > +
> > +	assert(!pud_huge(*pud));
> > +	pmd = pmd_alloc(pud, vaddr);  
> 
> Don't we have the *_alloc_map() functions in the kernel whic either
> map or allocate? I'd prefer that naming over *_alloc() if you also
> map if already allocated.

the functions existed already, I'm only reusing them.

> > +	return pmd;
> > +}
> > +
> > +/*
> > + * Get the pte (page) DAT table entry for the given address and
> > pmd,
> > + * allocating it if necessary.
> > + * The pmd must not be large.
> > + */
> > +static inline pte_t *get_pte(pmd_t *pmd, uintptr_t vaddr)
> > +{
> > +	pte_t *pte;
> > +
> > +	assert(!pmd_large(*pmd));
> > +	pte = pte_alloc(pmd, vaddr);
> > +	return pte;
> > +}
> > +
> > +/*
> > + * Splits a large pmd (segment) DAT table entry into equivalent
> > 4kB small
> > + * pages.
> > + * @pmd The pmd to split, it must be large.
> > + * @va the virtual address corresponding to this pmd.
> > + */
> > +static void split_pmd(pmd_t *pmd, uintptr_t va)
> > +{
> > +	phys_addr_t pa = pmd_val(*pmd) & SEGMENT_ENTRY_SFAA;
> > +	unsigned long i;
> > +	pte_t *pte;
> > +
> > +	assert(pmd_large(*pmd));
> > +	pte = alloc_pages(PAGE_TABLE_ORDER);
> > +	for (i = 0; i < PAGE_TABLE_ENTRIES; i++)
> > +		pte_val(pte[i]) =  pa | PAGE_SIZE * i;
> > +	idte_pmdp(va, &pmd_val(*pmd));
> > +	pmd_val(*pmd) = __pa(pte) | SEGMENT_ENTRY_TT_SEGMENT;  
> 
> Equivalent would mean we carry over protection, no?

that is a good point... I will need to fix it

> > +
> > +}
> > +
> > +/*
> > + * Splits a huge pud (region 3) DAT table entry into equivalent
> > 1MB large
> > + * pages.
> > + * @pud The pud to split, it must be huge.
> > + * @va the virtual address corresponding to this pud.
> > + */
> > +static void split_pud(pud_t *pud, uintptr_t va)
> > +{
> > +	phys_addr_t pa = pud_val(*pud) & REGION3_ENTRY_RFAA;
> > +	unsigned long i;
> > +	pmd_t *pmd;
> > +
> > +	assert(pud_huge(*pud));
> > +	pmd = alloc_pages(SEGMENT_TABLE_ORDER);
> > +	for (i = 0; i < SEGMENT_TABLE_ENTRIES; i++)
> > +		pmd_val(pmd[i]) =  pa | SZ_1M * i |
> > SEGMENT_ENTRY_FC | SEGMENT_ENTRY_TT_SEGMENT;
> > +	idte_pudp(va, &pud_val(*pud));
> > +	pud_val(*pud) = __pa(pmd) | REGION_ENTRY_TT_REGION3 |
> > REGION_TABLE_LENGTH; +}  

