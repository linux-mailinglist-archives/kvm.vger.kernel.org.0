Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E673F393EED
	for <lists+kvm@lfdr.de>; Fri, 28 May 2021 10:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234786AbhE1IqN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 May 2021 04:46:13 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52970 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229950AbhE1IqN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 May 2021 04:46:13 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14S8Wmmx005468;
        Fri, 28 May 2021 04:44:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : subject : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=wMppRQYJE7ZUvGYNBkA87k0HI0zkhoEIyDLCTOErjRU=;
 b=Nyvh0xRz1CyV4mOL1Pw9UdkLKtJHkApBR6WHp3jnEE2ESgUK1LWzsS3n/ZG3rZWrk6eQ
 +I4iZWqXtwI0Kv3sPtlg+2zu6PDaSEweEyKL3FI93VlWDKukYtNnDPctgeP7L0gjnzFA
 FXSNiFp0gjTtPzV+iNMx7j1+XvwRfvpfY9jCRr03y/sAw76ijo7QzHyEP0WuAY8x9pIi
 qWcfxG56LT+nGQdfhJ0dRfp86yTazy/grI7mno0RIzI46DF17TVpYUwtxB0z2xLkBHaE
 vngZMe2bx2t9c6tq6YBK3pkkJkH5dJjk20+338czLDEgLPx5nxTVZP8QfvZ897z57ZHe RA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38tu4dv46u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 May 2021 04:44:38 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14S8XYpX007280;
        Fri, 28 May 2021 04:44:38 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38tu4dv45u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 May 2021 04:44:38 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14S8gV0u014066;
        Fri, 28 May 2021 08:44:36 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 38s1r49nen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 May 2021 08:44:35 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14S8iXv332178456
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 May 2021 08:44:33 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE9414C040;
        Fri, 28 May 2021 08:44:33 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D4C64C04A;
        Fri, 28 May 2021 08:44:33 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.69.40])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 28 May 2021 08:44:33 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v4 6/7] s390x: mmu: add support for large
 pages
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
References: <20210526134245.138906-1-imbrenda@linux.ibm.com>
 <20210526134245.138906-7-imbrenda@linux.ibm.com>
Message-ID: <23d596c4-331f-088c-8373-74df78568e8a@linux.ibm.com>
Date:   Fri, 28 May 2021 10:44:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210526134245.138906-7-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WnCFt4xQ1sjcLQRMsRDqlh9_b7qd33Je
X-Proofpoint-GUID: UOD47vThhlm40tStLlDXvp7aJ5F7wZ5t
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-28_04:2021-05-27,2021-05-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 priorityscore=1501 spamscore=0
 mlxlogscore=999 phishscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105280055
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/26/21 3:42 PM, Claudio Imbrenda wrote:
> Add support for 1M and 2G pages.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/s390x/mmu.h |  73 +++++++++++++-
>  lib/s390x/mmu.c | 260 +++++++++++++++++++++++++++++++++++++++++++-----
>  2 files changed, 307 insertions(+), 26 deletions(-)
> 
> diff --git a/lib/s390x/mmu.h b/lib/s390x/mmu.h
> index 603f289e..93208467 100644
> --- a/lib/s390x/mmu.h
> +++ b/lib/s390x/mmu.h
> @@ -10,9 +10,78 @@
>  #ifndef _ASMS390X_MMU_H_
>  #define _ASMS390X_MMU_H_
>  
> -void protect_page(void *vaddr, unsigned long prot);
> +/*
> + * Splits the pagetables down to the given DAT tables level.
> + * Returns a pointer to the DAT table entry of the given level.
> + * @pgtable root of the page table tree
> + * @vaddr address whose page tables are to split
> + * @level 3 (for 2GB pud), 4 (for 1 MB pmd) or 5 (for 4KB pages)
> + */
> +void *split_page(pgd_t *pgtable, void *vaddr, unsigned int level);
> +
> +/*
> + * Applies the given protection bits to the given DAT tables level,
> + * splitting if necessary.
> + * @pgtable root of the page table tree
> + * @vaddr address whose protection bits are to be changed
> + * @prot the protection bits to set
> + * @level 3 (for 2GB pud), 4 (for 1MB pmd) or 5 (for 4KB pages)
> + */
> +void protect_dat_entry(void *vaddr, unsigned long prot, unsigned int level);
> +/*
> + * Clears the given protection bits from the given DAT tables level,
> + * splitting if necessary.
> + * @pgtable root of the page table tree
> + * @vaddr address whose protection bits are to be changed
> + * @prot the protection bits to clear
> + * @level 3 (for 2GB pud), 4 (for 1MB pmd) or 5 (for 4kB pages)
> + */
> +void unprotect_dat_entry(void *vaddr, unsigned long prot, unsigned int level);
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
> +	protect_dat_entry(vaddr, prot, 5);
> +}
> +
> +static inline void unprotect_page(void *vaddr, unsigned long prot)
> +{
> +	unprotect_dat_entry(vaddr, prot, 5);
> +}

\n

> +void *get_dat_entry(pgd_t *pgtable, void *vaddr, unsigned int level);
> +
>  #endif /* _ASMS390X_MMU_H_ */
> diff --git a/lib/s390x/mmu.c b/lib/s390x/mmu.c
> index 5c517366..def91334 100644
> --- a/lib/s390x/mmu.c
> +++ b/lib/s390x/mmu.c
> @@ -15,6 +15,18 @@
>  #include <vmalloc.h>
>  #include "mmu.h"
>  
> +/*
> + * The naming convention used here is the same as used in the Linux kernel,
> + * and this is the corrispondence between the s390x architectural names and

corresponds

> + * the Linux ones:
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
> @@ -46,54 +58,254 @@ static void mmu_enable(pgd_t *pgtable)
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

Don't we have the *_alloc_map() functions in the kernel whic either map
or allocate? I'd prefer that naming over *_alloc() if you also map if
already allocated.

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
> +	unsigned long i;
> +	pte_t *pte;
> +
> +	assert(pmd_large(*pmd));
> +	pte = alloc_pages(PAGE_TABLE_ORDER);
> +	for (i = 0; i < PAGE_TABLE_ENTRIES; i++)
> +		pte_val(pte[i]) =  pa | PAGE_SIZE * i;
> +	idte_pmdp(va, &pmd_val(*pmd));
> +	pmd_val(*pmd) = __pa(pte) | SEGMENT_ENTRY_TT_SEGMENT;

Equivalent would mean we carry over protection, no?

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
> +	unsigned long i;
> +	pmd_t *pmd;
> +
> +	assert(pud_huge(*pud));
> +	pmd = alloc_pages(SEGMENT_TABLE_ORDER);
> +	for (i = 0; i < SEGMENT_TABLE_ENTRIES; i++)
> +		pmd_val(pmd[i]) =  pa | SZ_1M * i | SEGMENT_ENTRY_FC | SEGMENT_ENTRY_TT_SEGMENT;
> +	idte_pudp(va, &pud_val(*pud));
> +	pud_val(*pud) = __pa(pmd) | REGION_ENTRY_TT_REGION3 | REGION_TABLE_LENGTH;
> +}
