Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0D23AC510
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 09:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbhFRHiY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 03:38:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14808 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229475AbhFRHiX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Jun 2021 03:38:23 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15I7YM6A112623;
        Fri, 18 Jun 2021 03:36:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ENgAy6c7Q4nwLIejbgYJZ3kIx2XE/zalP/iHD7x7nuE=;
 b=KCsVD3GeuEeL3PS2ZPA3zeSkRT6m262cfkwbwNk69tYDXbzcJHSK57MCHgeeBf+c3Ffl
 rLUTBkDsUDx2J0B6pX/Wh/fI4a0873LFzFVtUBzImBdirHY+ugyPBgvBMFrm+GgZh4nx
 gUH6W3puCZBfJ25u0u7uL1XEGMk60N0Frbyk0M73cNmSgOTnDkFRWaEjn0G2x+QLJZVG
 JXSRW1FZZniABSsFK02TdRYT2275f1GV8WMV0WUGk6MBFKXjqP54+JuxyCraJ23mshko
 zNmqWYet+MgbMYp6+ECGIM0tkAUg1cgqB32Hzwn5STEWk/thtSTXy11O4laeoj9koWkS fA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 398hn70pae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Jun 2021 03:36:14 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15I7aEMU122595;
        Fri, 18 Jun 2021 03:36:14 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 398hn70p8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Jun 2021 03:36:14 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15I7PLnT010199;
        Fri, 18 Jun 2021 07:36:11 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 394mj91r82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Jun 2021 07:36:11 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15I7a9LR24904112
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 07:36:09 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E037342042;
        Fri, 18 Jun 2021 07:36:08 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 821124203F;
        Fri, 18 Jun 2021 07:36:08 +0000 (GMT)
Received: from linux.fritz.box (unknown [9.145.172.21])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 18 Jun 2021 07:36:08 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v5 6/7] s390x: mmu: add support for large
 pages
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
References: <20210611140705.553307-1-imbrenda@linux.ibm.com>
 <20210611140705.553307-7-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <ac930fdd-53e9-cbc5-687d-8d99d968a3a1@linux.ibm.com>
Date:   Fri, 18 Jun 2021 09:36:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210611140705.553307-7-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: e-4xD15_wMfT6N_AVjG59iArqk2c9mx1
X-Proofpoint-GUID: uvN1FF6uSrz4Rpt3ohRJrZTrdN190y_I
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-17_17:2021-06-15,2021-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 mlxscore=0
 clxscore=1015 impostorscore=0 priorityscore=1501 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106180042
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/11/21 4:07 PM, Claudio Imbrenda wrote:
> Add support for 1M and 2G pages.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Acked-by: Janosch Frank <frankja@de.ibm.com>

> ---
>  lib/s390x/mmu.h |  84 +++++++++++++++-
>  lib/s390x/mmu.c | 262 +++++++++++++++++++++++++++++++++++++++++++-----
>  2 files changed, 320 insertions(+), 26 deletions(-)
> 
> diff --git a/lib/s390x/mmu.h b/lib/s390x/mmu.h
> index b995f85b..ab35d782 100644
> --- a/lib/s390x/mmu.h
> +++ b/lib/s390x/mmu.h
> @@ -10,9 +10,89 @@
>  #ifndef _S390X_MMU_H_
>  #define _S390X_MMU_H_
>  
> -void protect_page(void *vaddr, unsigned long prot);
> +enum pgt_level {
> +	pgtable_level_pgd = 1,
> +	pgtable_level_p4d,
> +	pgtable_level_pud,
> +	pgtable_level_pmd,
> +	pgtable_level_pte,
> +};
> +
> +/*
> + * Splits the pagetables down to the given DAT tables level.
> + * Returns a pointer to the DAT table entry of the given level.
> + * @pgtable root of the page table tree
> + * @vaddr address whose page tables are to split
> + * @level 3 (for 2GB pud), 4 (for 1 MB pmd) or 5 (for 4KB pages)
> + */
> +void *split_page(pgd_t *pgtable, void *vaddr, enum pgt_level level);
> +
> +/*
> + * Applies the given protection bits to the given DAT tables level,
> + * splitting if necessary.
> + * @pgtable root of the page table tree
> + * @vaddr address whose protection bits are to be changed
> + * @prot the protection bits to set
> + * @level 3 (for 2GB pud), 4 (for 1MB pmd) or 5 (for 4KB pages)
> + */
> +void protect_dat_entry(void *vaddr, unsigned long prot, enum pgt_level level);
> +
> +/*
> + * Clears the given protection bits from the given DAT tables level,
> + * splitting if necessary.
> + * @pgtable root of the page table tree
> + * @vaddr address whose protection bits are to be changed
> + * @prot the protection bits to clear
> + * @level 3 (for 2GB pud), 4 (for 1MB pmd) or 5 (for 4kB pages)
> + */
> +void unprotect_dat_entry(void *vaddr, unsigned long prot, enum pgt_level level);
> +
> +/*
> + * Applies the given protection bits to the given 4kB pages range,
> + * splitting if necessary.
> + * @start starting address whose protection bits are to be changed
> + * @len size in bytes
> + * @prot the protection bits to set
> + */
>  void protect_range(void *start, unsigned long len, unsigned long prot);
> -void unprotect_page(void *vaddr, unsigned long prot);
> +
> +/*
> + * Clears the given protection bits from the given 4kB pages range,
> + * splitting if necessary.
> + * @start starting address whose protection bits are to be changed
> + * @len size in bytes
> + * @prot the protection bits to set
> + */
>  void unprotect_range(void *start, unsigned long len, unsigned long prot);
>  
> +/* Similar to install_page, maps the virtual address to the physical address
> + * for the given page tables, using 1MB large pages.
> + * Returns a pointer to the DAT table entry.
> + * @pgtable root of the page table tree
> + * @phys physical address to map, must be 1MB aligned!
> + * @vaddr virtual address to map, must be 1MB aligned!
> + */
> +pmdval_t *install_large_page(pgd_t *pgtable, phys_addr_t phys, void *vaddr);
> +
> +/* Similar to install_page, maps the virtual address to the physical address
> + * for the given page tables, using 2GB huge pages.
> + * Returns a pointer to the DAT table entry.
> + * @pgtable root of the page table tree
> + * @phys physical address to map, must be 2GB aligned!
> + * @vaddr virtual address to map, must be 2GB aligned!
> + */
> +pudval_t *install_huge_page(pgd_t *pgtable, phys_addr_t phys, void *vaddr);
> +
> +static inline void protect_page(void *vaddr, unsigned long prot)
> +{
> +	protect_dat_entry(vaddr, prot, pgtable_level_pte);
> +}
> +
> +static inline void unprotect_page(void *vaddr, unsigned long prot)
> +{
> +	unprotect_dat_entry(vaddr, prot, pgtable_level_pte);
> +}
> +
> +void *get_dat_entry(pgd_t *pgtable, void *vaddr, unsigned int level);
> +
>  #endif /* _ASMS390X_MMU_H_ */
> diff --git a/lib/s390x/mmu.c b/lib/s390x/mmu.c
> index 5c517366..c973443b 100644
> --- a/lib/s390x/mmu.c
> +++ b/lib/s390x/mmu.c
> @@ -15,6 +15,18 @@
>  #include <vmalloc.h>
>  #include "mmu.h"
>  
> +/*
> + * The naming convention used here is the same as used in the Linux kernel;
> + * this is the correspondence between the s390x architectural names and the
> + * Linux ones:
> + *
> + * pgd - region 1 table entry
> + * p4d - region 2 table entry
> + * pud - region 3 table entry
> + * pmd - segment table entry
> + * pte - page table entry
> + */
> +
>  static pgd_t *table_root;
>  
>  void configure_dat(int enable)
> @@ -46,54 +58,256 @@ static void mmu_enable(pgd_t *pgtable)
>  	lc->pgm_new_psw.mask |= PSW_MASK_DAT;
>  }
>  
> -static pteval_t *get_pte(pgd_t *pgtable, uintptr_t vaddr)
> +/*
> + * Get the pud (region 3) DAT table entry for the given address and root,
> + * allocating it if necessary
> + */
> +static inline pud_t *get_pud(pgd_t *pgtable, uintptr_t vaddr)
>  {
>  	pgd_t *pgd = pgd_offset(pgtable, vaddr);
>  	p4d_t *p4d = p4d_alloc(pgd, vaddr);
>  	pud_t *pud = pud_alloc(p4d, vaddr);
> -	pmd_t *pmd = pmd_alloc(pud, vaddr);
> -	pte_t *pte = pte_alloc(pmd, vaddr);
>  
> -	return &pte_val(*pte);
> +	return pud;
> +}
> +
> +/*
> + * Get the pmd (segment) DAT table entry for the given address and pud,
> + * allocating it if necessary.
> + * The pud must not be huge.
> + */
> +static inline pmd_t *get_pmd(pud_t *pud, uintptr_t vaddr)
> +{
> +	pmd_t *pmd;
> +
> +	assert(!pud_huge(*pud));
> +	pmd = pmd_alloc(pud, vaddr);
> +	return pmd;
> +}
> +
> +/*
> + * Get the pte (page) DAT table entry for the given address and pmd,
> + * allocating it if necessary.
> + * The pmd must not be large.
> + */
> +static inline pte_t *get_pte(pmd_t *pmd, uintptr_t vaddr)
> +{
> +	pte_t *pte;
> +
> +	assert(!pmd_large(*pmd));
> +	pte = pte_alloc(pmd, vaddr);
> +	return pte;
> +}
> +
> +/*
> + * Splits a large pmd (segment) DAT table entry into equivalent 4kB small
> + * pages.
> + * @pmd The pmd to split, it must be large.
> + * @va the virtual address corresponding to this pmd.
> + */
> +static void split_pmd(pmd_t *pmd, uintptr_t va)
> +{
> +	phys_addr_t pa = pmd_val(*pmd) & SEGMENT_ENTRY_SFAA;
> +	unsigned long i, prot;
> +	pte_t *pte;
> +
> +	assert(pmd_large(*pmd));
> +	pte = alloc_pages(PAGE_TABLE_ORDER);
> +	prot = pmd_val(*pmd) & (SEGMENT_ENTRY_IEP | SEGMENT_ENTRY_P);
> +	for (i = 0; i < PAGE_TABLE_ENTRIES; i++)
> +		pte_val(pte[i]) =  pa | PAGE_SIZE * i | prot;
> +	idte_pmdp(va, &pmd_val(*pmd));
> +	pmd_val(*pmd) = __pa(pte) | SEGMENT_ENTRY_TT_SEGMENT;
> +
> +}
> +
> +/*
> + * Splits a huge pud (region 3) DAT table entry into equivalent 1MB large
> + * pages.
> + * @pud The pud to split, it must be huge.
> + * @va the virtual address corresponding to this pud.
> + */
> +static void split_pud(pud_t *pud, uintptr_t va)
> +{
> +	phys_addr_t pa = pud_val(*pud) & REGION3_ENTRY_RFAA;
> +	unsigned long i, prot;
> +	pmd_t *pmd;
> +
> +	assert(pud_huge(*pud));
> +	pmd = alloc_pages(SEGMENT_TABLE_ORDER);
> +	prot = pud_val(*pud) & (REGION3_ENTRY_IEP | REGION_ENTRY_P);
> +	for (i = 0; i < SEGMENT_TABLE_ENTRIES; i++)
> +		pmd_val(pmd[i]) =  pa | SZ_1M * i | prot | SEGMENT_ENTRY_FC | SEGMENT_ENTRY_TT_SEGMENT;
> +	idte_pudp(va, &pud_val(*pud));
> +	pud_val(*pud) = __pa(pmd) | REGION_ENTRY_TT_REGION3 | REGION_TABLE_LENGTH;
> +}
> +
> +void *get_dat_entry(pgd_t *pgtable, void *vaddr, enum pgt_level level)
> +{
> +	uintptr_t va = (uintptr_t)vaddr;
> +	pgd_t *pgd;
> +	p4d_t *p4d;
> +	pud_t *pud;
> +	pmd_t *pmd;
> +
> +	assert(level && (level <= 5));
> +	pgd = pgd_offset(pgtable, va);
> +	if (level == pgtable_level_pgd)
> +		return pgd;
> +	p4d = p4d_alloc(pgd, va);
> +	if (level == pgtable_level_p4d)
> +		return p4d;
> +	pud = pud_alloc(p4d, va);
> +
> +	if (level == pgtable_level_pud)
> +		return pud;
> +	if (!pud_none(*pud) && pud_huge(*pud))
> +		split_pud(pud, va);
> +	pmd = get_pmd(pud, va);
> +	if (level == pgtable_level_pmd)
> +		return pmd;
> +	if (!pmd_none(*pmd) && pmd_large(*pmd))
> +		split_pmd(pmd, va);
> +	return get_pte(pmd, va);
> +}
> +
> +void *split_page(pgd_t *pgtable, void *vaddr, enum pgt_level level)
> +{
> +	assert((level >= 3) && (level <= 5));
> +	return get_dat_entry(pgtable ? pgtable : table_root, vaddr, level);
>  }
>  
>  phys_addr_t virt_to_pte_phys(pgd_t *pgtable, void *vaddr)
>  {
> -	return (*get_pte(pgtable, (uintptr_t)vaddr) & PAGE_MASK) +
> -	       ((unsigned long)vaddr & ~PAGE_MASK);
> +	uintptr_t va = (uintptr_t)vaddr;
> +	pud_t *pud;
> +	pmd_t *pmd;
> +	pte_t *pte;
> +
> +	pud = get_pud(pgtable, va);
> +	if (pud_huge(*pud))
> +		return (pud_val(*pud) & REGION3_ENTRY_RFAA) | (va & ~REGION3_ENTRY_RFAA);
> +	pmd = get_pmd(pud, va);
> +	if (pmd_large(*pmd))
> +		return (pmd_val(*pmd) & SEGMENT_ENTRY_SFAA) | (va & ~SEGMENT_ENTRY_SFAA);
> +	pte = get_pte(pmd, va);
> +	return (pte_val(*pte) & PAGE_MASK) | (va & ~PAGE_MASK);
> +}
> +
> +/*
> + * Get the DAT table entry of the given level for the given address,
> + * splitting if necessary. If the entry was not invalid, invalidate it, and
> + * return the pointer to the entry and, if requested, its old value.
> + * @pgtable root of the page tables
> + * @vaddr virtual address
> + * @level 3 (for 2GB pud), 4 (for 1MB pmd) or 5 (for 4kB pages)
> + * @old if not NULL, will be written with the old value of the DAT table
> + * entry before invalidation
> + */
> +static void *dat_get_and_invalidate(pgd_t *pgtable, void *vaddr, enum pgt_level level, unsigned long *old)
> +{
> +	unsigned long va = (unsigned long)vaddr;
> +	void *ptr;
> +
> +	ptr = get_dat_entry(pgtable, vaddr, level);
> +	if (old)
> +		*old = *(unsigned long *)ptr;
> +	if ((level == pgtable_level_pgd) && !pgd_none(*(pgd_t *)ptr))
> +		idte_pgdp(va, ptr);
> +	else if ((level == pgtable_level_p4d) && !p4d_none(*(p4d_t *)ptr))
> +		idte_p4dp(va, ptr);
> +	else if ((level == pgtable_level_pud) && !pud_none(*(pud_t *)ptr))
> +		idte_pudp(va, ptr);
> +	else if ((level == pgtable_level_pmd) && !pmd_none(*(pmd_t *)ptr))
> +		idte_pmdp(va, ptr);
> +	else if (!pte_none(*(pte_t *)ptr))
> +		ipte(va, ptr);
> +	return ptr;
>  }
>  
> -static pteval_t *set_pte(pgd_t *pgtable, pteval_t val, void *vaddr)
> +static void cleanup_pmd(pmd_t *pmd)
>  {
> -	pteval_t *p_pte = get_pte(pgtable, (uintptr_t)vaddr);
> +	/* was invalid or large, nothing to do */
> +	if (pmd_none(*pmd) || pmd_large(*pmd))
> +		return;
> +	/* was not large, free the corresponding page table */
> +	free_pages((void *)(pmd_val(*pmd) & PAGE_MASK));
> +}
>  
> -	/* first flush the old entry (if we're replacing anything) */
> -	if (!(*p_pte & PAGE_ENTRY_I))
> -		ipte((uintptr_t)vaddr, p_pte);
> +static void cleanup_pud(pud_t *pud)
> +{
> +	unsigned long i;
> +	pmd_t *pmd;
>  
> -	*p_pte = val;
> -	return p_pte;
> +	/* was invalid or large, nothing to do */
> +	if (pud_none(*pud) || pud_huge(*pud))
> +		return;
> +	/* recursively clean up all pmds if needed */
> +	pmd = (pmd_t *)(pud_val(*pud) & PAGE_MASK);
> +	for (i = 0; i < SEGMENT_TABLE_ENTRIES; i++)
> +		cleanup_pmd(pmd + i);
> +	/* free the corresponding segment table */
> +	free_pages(pmd);
> +}
> +
> +/*
> + * Set the DAT entry for the given level of the given virtual address. If a
> + * mapping already existed, it is overwritten. If an existing mapping with
> + * smaller pages existed, all the lower tables are freed.
> + * Returns the pointer to the DAT table entry.
> + * @pgtable root of the page tables
> + * @val the new value for the DAT table entry
> + * @vaddr the virtual address
> + * @level 3 for pud (region 3), 4 for pmd (segment) and 5 for pte (pages)
> + */
> +static void *set_dat_entry(pgd_t *pgtable, unsigned long val, void *vaddr, enum pgt_level level)
> +{
> +	unsigned long old, *res;
> +
> +	res = dat_get_and_invalidate(pgtable, vaddr, level, &old);
> +	if (level == pgtable_level_pmd)
> +		cleanup_pmd((pmd_t *)&old);
> +	if (level == pgtable_level_pud)
> +		cleanup_pud((pud_t *)&old);
> +	*res = val;
> +	return res;
>  }
>  
>  pteval_t *install_page(pgd_t *pgtable, phys_addr_t phys, void *vaddr)
>  {
> -	return set_pte(pgtable, __pa(phys), vaddr);
> +	assert(IS_ALIGNED(phys, PAGE_SIZE));
> +	assert(IS_ALIGNED((uintptr_t)vaddr, PAGE_SIZE));
> +	return set_dat_entry(pgtable, phys, vaddr, pgtable_level_pte);
> +}
> +
> +pmdval_t *install_large_page(pgd_t *pgtable, phys_addr_t phys, void *vaddr)
> +{
> +	assert(IS_ALIGNED(phys, SZ_1M));
> +	assert(IS_ALIGNED((uintptr_t)vaddr, SZ_1M));
> +	return set_dat_entry(pgtable, phys | SEGMENT_ENTRY_FC, vaddr, pgtable_level_pmd);
> +}
> +
> +pudval_t *install_huge_page(pgd_t *pgtable, phys_addr_t phys, void *vaddr)
> +{
> +	assert(IS_ALIGNED(phys, SZ_2G));
> +	assert(IS_ALIGNED((uintptr_t)vaddr, SZ_2G));
> +	return set_dat_entry(pgtable, phys | REGION3_ENTRY_FC | REGION_ENTRY_TT_REGION3, vaddr, pgtable_level_pud);
>  }
>  
> -void protect_page(void *vaddr, unsigned long prot)
> +void protect_dat_entry(void *vaddr, unsigned long prot, enum pgt_level level)
>  {
> -	pteval_t *p_pte = get_pte(table_root, (uintptr_t)vaddr);
> -	pteval_t n_pte = *p_pte | prot;
> +	unsigned long old, *ptr;
>  
> -	set_pte(table_root, n_pte, vaddr);
> +	ptr = dat_get_and_invalidate(table_root, vaddr, level, &old);
> +	*ptr = old | prot;
>  }
>  
> -void unprotect_page(void *vaddr, unsigned long prot)
> +void unprotect_dat_entry(void *vaddr, unsigned long prot, enum pgt_level level)
>  {
> -	pteval_t *p_pte = get_pte(table_root, (uintptr_t)vaddr);
> -	pteval_t n_pte = *p_pte & ~prot;
> +	unsigned long old, *ptr;
>  
> -	set_pte(table_root, n_pte, vaddr);
> +	ptr = dat_get_and_invalidate(table_root, vaddr, level, &old);
> +	*ptr = old & ~prot;
>  }
>  
>  void protect_range(void *start, unsigned long len, unsigned long prot)
> @@ -102,7 +316,7 @@ void protect_range(void *start, unsigned long len, unsigned long prot)
>  
>  	len &= PAGE_MASK;
>  	for (; len; len -= PAGE_SIZE, curr += PAGE_SIZE)
> -		protect_page((void *)curr, prot);
> +		protect_dat_entry((void *)curr, prot, 5);
>  }
>  
>  void unprotect_range(void *start, unsigned long len, unsigned long prot)
> @@ -111,7 +325,7 @@ void unprotect_range(void *start, unsigned long len, unsigned long prot)
>  
>  	len &= PAGE_MASK;
>  	for (; len; len -= PAGE_SIZE, curr += PAGE_SIZE)
> -		unprotect_page((void *)curr, prot);
> +		unprotect_dat_entry((void *)curr, prot, 5);
>  }
>  
>  static void setup_identity(pgd_t *pgtable, phys_addr_t start_addr,
> 

