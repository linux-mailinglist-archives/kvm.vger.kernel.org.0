Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8102840B565
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 18:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbhINQzp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 12:55:45 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33052 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229379AbhINQzo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 12:55:44 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18EF0PWU022777;
        Tue, 14 Sep 2021 12:54:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=73/yF8qJa5IPr9xMYnEnMsOamnvp/yB6LaoON90q+f0=;
 b=cbQEEGNC3wO/BkHO3edcQk6zrgiew0qA3ciITkxDD7TLN5jjawB3B673KZCLYd3/nzVt
 +/RNLTreMnXuwjBnGz76uuLSVGh6GxX30fPar93sMmetVMVvBoOjdpJ5LjKP/nVgVZDF
 76+oKEujgCzdyuV/MWjXNeyMlRL83qEmTVMA9NQnJAjAdQlydPS4A7henF5CEkg3UvBz
 Qu2VKSmRUNnXE5LmnAVwDO39HBdSL4QGdiroEWQB/XBPL40qstHVqxaZPam2+gLScYDz
 qqDwBoiLoutDiYxHtVFCMqoXsnT36q7wxYRHfu/tksGyWOwONqZznP/z++VRdqwXnWl/ +Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b2x0gjv4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 12:54:25 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18EF1dpL027113;
        Tue, 14 Sep 2021 12:54:25 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b2x0gjv49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 12:54:25 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18EGrXeN006066;
        Tue, 14 Sep 2021 16:54:22 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3b0m39eask-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 16:54:22 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18EGsIvJ51773704
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 16:54:18 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B057AE045;
        Tue, 14 Sep 2021 16:54:18 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4077AE04D;
        Tue, 14 Sep 2021 16:54:17 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.12])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Sep 2021 16:54:17 +0000 (GMT)
Date:   Tue, 14 Sep 2021 18:54:14 +0200
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
Subject: Re: [PATCH resend RFC 3/9] s390/mm: validate VMA in PGSTE
 manipulation functions
Message-ID: <20210914185414.26f65820@p-imbrenda>
In-Reply-To: <20210909162248.14969-4-david@redhat.com>
References: <20210909162248.14969-1-david@redhat.com>
 <20210909162248.14969-4-david@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tqYN2y3K_NxPEw0U1MTAAvkg_BLKP3NY
X-Proofpoint-ORIG-GUID: bEH58kYp0SpU0cD0jNgyhjQPsbTXahgd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 phishscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109140081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  9 Sep 2021 18:22:42 +0200
David Hildenbrand <david@redhat.com> wrote:

> We should not walk/touch page tables outside of VMA boundaries when
> holding only the mmap sem in read mode. Evil user space can modify the
> VMA layout just before this function runs and e.g., trigger races with
> page table removal code since commit dd2283f2605e ("mm: mmap: zap pages
> with read mmap_sem in munmap"). gfn_to_hva() will only translate using
> KVM memory regions, but won't validate the VMA.
> 
> Further, we should not allocate page tables outside of VMA boundaries: if
> evil user space decides to map hugetlbfs to these ranges, bad things will
> happen because we suddenly have PTE or PMD page tables where we
> shouldn't have them.
> 
> Similarly, we have to check if we suddenly find a hugetlbfs VMA, before
> calling get_locked_pte().
> 
> Fixes: 2d42f9477320 ("s390/kvm: Add PGSTE manipulation functions")
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/mm/pgtable.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
> index eec3a9d7176e..54969e0f3a94 100644
> --- a/arch/s390/mm/pgtable.c
> +++ b/arch/s390/mm/pgtable.c
> @@ -988,6 +988,7 @@ EXPORT_SYMBOL(get_guest_storage_key);
>  int pgste_perform_essa(struct mm_struct *mm, unsigned long hva, int orc,
>  			unsigned long *oldpte, unsigned long *oldpgste)
>  {
> +	struct vm_area_struct *vma;
>  	unsigned long pgstev;
>  	spinlock_t *ptl;
>  	pgste_t pgste;
> @@ -997,6 +998,10 @@ int pgste_perform_essa(struct mm_struct *mm, unsigned long hva, int orc,
>  	WARN_ON_ONCE(orc > ESSA_MAX);
>  	if (unlikely(orc > ESSA_MAX))
>  		return -EINVAL;
> +
> +	vma = vma_lookup(mm, hva);
> +	if (!vma || is_vm_hugetlb_page(vma))
> +		return -EFAULT;
>  	ptep = get_locked_pte(mm, hva, &ptl);
>  	if (unlikely(!ptep))
>  		return -EFAULT;
> @@ -1089,10 +1094,14 @@ EXPORT_SYMBOL(pgste_perform_essa);
>  int set_pgste_bits(struct mm_struct *mm, unsigned long hva,
>  			unsigned long bits, unsigned long value)
>  {
> +	struct vm_area_struct *vma;
>  	spinlock_t *ptl;
>  	pgste_t new;
>  	pte_t *ptep;
>  
> +	vma = vma_lookup(mm, hva);
> +	if (!vma || is_vm_hugetlb_page(vma))
> +		return -EFAULT;
>  	ptep = get_locked_pte(mm, hva, &ptl);
>  	if (unlikely(!ptep))
>  		return -EFAULT;
> @@ -1117,9 +1126,13 @@ EXPORT_SYMBOL(set_pgste_bits);
>   */
>  int get_pgste(struct mm_struct *mm, unsigned long hva, unsigned long *pgstep)
>  {
> +	struct vm_area_struct *vma;
>  	spinlock_t *ptl;
>  	pte_t *ptep;
>  
> +	vma = vma_lookup(mm, hva);
> +	if (!vma || is_vm_hugetlb_page(vma))
> +		return -EFAULT;
>  	ptep = get_locked_pte(mm, hva, &ptl);
>  	if (unlikely(!ptep))
>  		return -EFAULT;

