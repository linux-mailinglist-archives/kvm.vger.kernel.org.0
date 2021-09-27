Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B42AF419965
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 18:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235511AbhI0Qo0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 12:44:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9454 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235285AbhI0QoZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Sep 2021 12:44:25 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18RGCCps026560;
        Mon, 27 Sep 2021 12:42:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Ik82L4gs4fGKo0tIAY5sJou6J93LL2e9DyCug52HDtQ=;
 b=aUsnGyalfBe+/A1lb+VdtDp8/7GdtxXyVj6Smiz+J+T+NAi5puN6n1HdbvRm8GIHDZ+T
 EZqVk4Kpp0YSr9f0rH+QDIXIAJWqLfVzyZlYlzFSsY3k6ZxX2EgVfArUpLC2fbmKbkM9
 94cLgttk5MbsA8KwOdF8VhKgCQjcfspesifab/rsRLsimzIq6DmWwZ4+w7KOwctTtgp/
 Puxrrzw9EvWcvVKijpwlNCeVaXHcvAkYoR7Zx4JFb2KjVTi/WH0mi/9mcL4qvtzkvD4z
 qntXUFy7hPPwYSAsUKqQLj9+oZFYhGmAmEcHH4uZU6fZZk4NiJ1rlAUBcl3xmI73cME8 Nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bagn81h9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 12:42:45 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18RGAEu0018034;
        Mon, 27 Sep 2021 12:42:45 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bagn81h8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 12:42:44 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18RGXHRm001907;
        Mon, 27 Sep 2021 16:42:43 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3b9u1j6tvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 16:42:42 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18RGgceU44040580
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Sep 2021 16:42:38 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E26EAE053;
        Mon, 27 Sep 2021 16:42:38 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E71A2AE05D;
        Mon, 27 Sep 2021 16:42:37 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.4.56])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Sep 2021 16:42:37 +0000 (GMT)
Date:   Mon, 27 Sep 2021 18:37:59 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
Subject: Re: [PATCH resend RFC 4/9] s390/mm: fix VMA and page table handling
 code in storage key handling functions
Message-ID: <20210927183759.72a29645@p-imbrenda>
In-Reply-To: <20210909162248.14969-5-david@redhat.com>
References: <20210909162248.14969-1-david@redhat.com>
        <20210909162248.14969-5-david@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FutLHhDBqczWLv6LlQVKEkz3SP7MdMFn
X-Proofpoint-ORIG-GUID: jVBNTeQVpVPeTwEuk3kVKrujLqP1AQBd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-27_06,2021-09-24_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 spamscore=0 suspectscore=0 clxscore=1015 mlxscore=0
 bulkscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109270112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  9 Sep 2021 18:22:43 +0200
David Hildenbrand <david@redhat.com> wrote:

> There are multiple things broken about our storage key handling
> functions:
> 
> 1. We should not walk/touch page tables outside of VMA boundaries when
>    holding only the mmap sem in read mode. Evil user space can modify the
>    VMA layout just before this function runs and e.g., trigger races with
>    page table removal code since commit dd2283f2605e ("mm: mmap: zap pages
>    with read mmap_sem in munmap"). gfn_to_hva() will only translate using
>    KVM memory regions, but won't validate the VMA.
> 
> 2. We should not allocate page tables outside of VMA boundaries: if
>    evil user space decides to map hugetlbfs to these ranges, bad things
>    will happen because we suddenly have PTE or PMD page tables where we
>    shouldn't have them.
> 
> 3. We don't handle large PUDs that might suddenly appeared inside our page
>    table hierarchy.
> 
> Don't manually allocate page tables, properly validate that we have VMA and
> bail out on pud_large().
> 
> All callers of page table handling functions, except
> get_guest_storage_key(), call fixup_user_fault() in case they
> receive an -EFAULT and retry; this will allocate the necessary page tables
> if required.
> 
> To keep get_guest_storage_key() working as expected and not requiring
> kvm_s390_get_skeys() to call fixup_user_fault() distinguish between
> "there is simply no page table or huge page yet and the key is assumed
> to be 0" and "this is a fault to be reported".
> 
> Although commit 637ff9efe5ea ("s390/mm: Add huge pmd storage key handling")
> introduced most of the affected code, it was actually already broken
> before when using get_locked_pte() without any VMA checks.
> 
> Note: Ever since commit 637ff9efe5ea ("s390/mm: Add huge pmd storage key
> handling") we can no longer set a guest storage key (for example from
> QEMU during VM live migration) without actually resolving a fault.
> Although we would have created most page tables, we would choke on the
> !pmd_present(), requiring a call to fixup_user_fault(). I would
> have thought that this is problematic in combination with postcopy life
> migration ... but nobody noticed and this patch doesn't change the
> situation. So maybe it's just fine.
> 
> Fixes: 9fcf93b5de06 ("KVM: S390: Create helper function get_guest_storage_key")
> Fixes: 24d5dd0208ed ("s390/kvm: Provide function for setting the guest storage key")
> Fixes: a7e19ab55ffd ("KVM: s390: handle missing storage-key facility")
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/mm/pgtable.c | 57 +++++++++++++++++++++++++++++-------------
>  1 file changed, 39 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
> index 54969e0f3a94..5fb409ff7842 100644
> --- a/arch/s390/mm/pgtable.c
> +++ b/arch/s390/mm/pgtable.c
> @@ -429,22 +429,36 @@ static inline pmd_t pmdp_flush_lazy(struct mm_struct *mm,
>  }
>  
>  #ifdef CONFIG_PGSTE
> -static pmd_t *pmd_alloc_map(struct mm_struct *mm, unsigned long addr)
> +static int pmd_lookup(struct mm_struct *mm, unsigned long addr, pmd_t **pmdp)
>  {
> +	struct vm_area_struct *vma;
>  	pgd_t *pgd;
>  	p4d_t *p4d;
>  	pud_t *pud;
> -	pmd_t *pmd;
> +
> +	/* We need a valid VMA, otherwise this is clearly a fault. */
> +	vma = vma_lookup(mm, addr);
> +	if (!vma)
> +		return -EFAULT;
>  
>  	pgd = pgd_offset(mm, addr);
> -	p4d = p4d_alloc(mm, pgd, addr);
> -	if (!p4d)
> -		return NULL;
> -	pud = pud_alloc(mm, p4d, addr);
> -	if (!pud)
> -		return NULL;
> -	pmd = pmd_alloc(mm, pud, addr);
> -	return pmd;
> +	if (!pgd_present(*pgd))
> +		return -ENOENT;
> +
> +	p4d = p4d_offset(pgd, addr);
> +	if (!p4d_present(*p4d))
> +		return -ENOENT;
> +
> +	pud = pud_offset(p4d, addr);
> +	if (!pud_present(*pud))
> +		return -ENOENT;
> +
> +	/* Large PUDs are not supported yet. */
> +	if (pud_large(*pud))
> +		return -EFAULT;
> +
> +	*pmdp = pmd_offset(pud, addr);
> +	return 0;
>  }
>  #endif
>  
> @@ -778,8 +792,7 @@ int set_guest_storage_key(struct mm_struct *mm, unsigned long addr,
>  	pmd_t *pmdp;
>  	pte_t *ptep;
>  
> -	pmdp = pmd_alloc_map(mm, addr);
> -	if (unlikely(!pmdp))
> +	if (pmd_lookup(mm, addr, &pmdp))
>  		return -EFAULT;
>  
>  	ptl = pmd_lock(mm, pmdp);
> @@ -881,8 +894,7 @@ int reset_guest_reference_bit(struct mm_struct *mm, unsigned long addr)
>  	pte_t *ptep;
>  	int cc = 0;
>  
> -	pmdp = pmd_alloc_map(mm, addr);
> -	if (unlikely(!pmdp))
> +	if (pmd_lookup(mm, addr, &pmdp))
>  		return -EFAULT;
>  
>  	ptl = pmd_lock(mm, pmdp);
> @@ -935,15 +947,24 @@ int get_guest_storage_key(struct mm_struct *mm, unsigned long addr,
>  	pmd_t *pmdp;
>  	pte_t *ptep;
>  
> -	pmdp = pmd_alloc_map(mm, addr);
> -	if (unlikely(!pmdp))
> +	/*
> +	 * If we don't have a PTE table and if there is no huge page mapped,
> +	 * the storage key is 0.
> +	 */
> +	*key = 0;
> +
> +	switch (pmd_lookup(mm, addr, &pmdp)) {
> +	case -ENOENT:
> +		return 0;
> +	case 0:
> +		break;
> +	default:
>  		return -EFAULT;
> +	}
>  
>  	ptl = pmd_lock(mm, pmdp);
>  	if (!pmd_present(*pmdp)) {
> -		/* Not yet mapped memory has a zero key */
>  		spin_unlock(ptl);
> -		*key = 0;
>  		return 0;
>  	}
>  

