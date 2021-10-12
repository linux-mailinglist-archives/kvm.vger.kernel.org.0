Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2DED429F1F
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 09:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234419AbhJLIAb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 04:00:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27294 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234071AbhJLIAa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Oct 2021 04:00:30 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19C7fpab013755;
        Tue, 12 Oct 2021 03:58:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=WhOiuqkez14noqL2urfK1tdHTWPWTd3N7Z5AJVJqfTU=;
 b=s0lObJrqzT6Rt4AW93wsawLrOF1EC5i0acyBndUDTJZCIgmW78v6xA4weacigtA2xttH
 6+pszTDasivlgWnwrmtoMC6eqFrbLbKLBJi4mmfglIdozys5P2k5bUIZZ58ROsSPIv20
 1M0NzY/obksHexT5nMv85h7+yQCelaveOx+2/x+yhEPdevlR1nDMjYLoqKWNlHxSgJMH
 shkvoc2oF8uj0IkKlHQU+sxTvoaa1dDAY8F9tNkxM4m45gdBdSjNRzj+QMAMbYIOjnrr
 mbCV51BNLwbQwXnFM70DzcIqVpTDHHG/y1EzSCuIiRkTnpUXQL5/wTcvxcElSnmrRaF7 LQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bn66qg9rk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 03:58:28 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19C7fjNK013508;
        Tue, 12 Oct 2021 03:58:27 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bn66qg9r8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 03:58:27 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19C7vsBH017056;
        Tue, 12 Oct 2021 07:58:26 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3bk2bj5xc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 07:58:25 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19C7wKFn66650604
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 07:58:20 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0BEBEA4051;
        Tue, 12 Oct 2021 07:58:20 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80059A405D;
        Tue, 12 Oct 2021 07:58:19 +0000 (GMT)
Received: from [9.145.20.44] (unknown [9.145.20.44])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Oct 2021 07:58:19 +0000 (GMT)
Message-ID: <bffbbef0-97b0-d620-d1ea-0acb4b9ba74e@linux.ibm.com>
Date:   Tue, 12 Oct 2021 09:58:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ulrich.Weigand@de.ibm.com
References: <20210920132502.36111-1-imbrenda@linux.ibm.com>
 <20210920132502.36111-6-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v5 05/14] KVM: s390: pv: leak the topmost page table when
 destroy fails
In-Reply-To: <20210920132502.36111-6-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ECK_yqpTWBJKXn9RsFTpNpCG0A0q9Ztk
X-Proofpoint-GUID: ApZGM9hKhR1SqJ4xZTlwAqaX_ajoBkbS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-12_01,2021-10-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 impostorscore=0 suspectscore=0 bulkscore=0 phishscore=0
 clxscore=1015 mlxlogscore=999 priorityscore=1501 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110120041
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/20/21 15:24, Claudio Imbrenda wrote:
> Each secure guest must have a unique address space control element and
> we must avoid that new guests use the same ASCE, to avoid errors.
> Since the ASCE mostly consists of the topmost page table address (and
> flags), we must not return that memory to the pool unless the ASCE is
> no longer in use.
> 
> Only a successful Destroy Secure Configuration UVC will make the ASCE
> reusable again. If the Destroy Configuration UVC fails, the ASCE
> cannot be reused for a secure guest (either for the ASCE or for other
> memory areas). To avoid a collision, it must not be used again.
> 
> This is a permanent error and the page becomes in practice unusable, so
> we set it aside and leak it. On failure we already leak other memory
> that belongs to the ultravisor (i.e. the variable and base storage for
> a guest) and not leaking the topmost page table was an oversight.
> 
> This error should not happen unless the hardware is broken or KVM has
> some unknown serious bug.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Fixes tag?

> ---
>   arch/s390/include/asm/gmap.h |  2 ++
>   arch/s390/kvm/pv.c           |  4 ++-
>   arch/s390/mm/gmap.c          | 55 ++++++++++++++++++++++++++++++++++++
>   3 files changed, 60 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
> index 40264f60b0da..746e18bf8984 100644
> --- a/arch/s390/include/asm/gmap.h
> +++ b/arch/s390/include/asm/gmap.h
> @@ -148,4 +148,6 @@ void gmap_sync_dirty_log_pmd(struct gmap *gmap, unsigned long dirty_bitmap[4],
>   			     unsigned long gaddr, unsigned long vmaddr);
>   int gmap_mark_unmergeable(void);
>   void s390_reset_acc(struct mm_struct *mm);
> +void s390_remove_old_asce(struct gmap *gmap);
> +int s390_replace_asce(struct gmap *gmap);
>   #endif /* _ASM_S390_GMAP_H */
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index 00d272d134c2..76b0d64ce8fa 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -168,9 +168,11 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>   	atomic_set(&kvm->mm->context.is_protected, 0);
>   	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", *rc, *rrc);
>   	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", *rc, *rrc);
> -	/* Inteded memory leak on "impossible" error */
> +	/* Intended memory leak on "impossible" error */

Rather unrelated

>   	if (!cc)
>   		kvm_s390_pv_dealloc_vm(kvm);
> +	else
> +		s390_replace_asce(kvm->arch.gmap);
>   	return cc ? -EIO : 0;

Might make more sense now to do an early return so we don't have the 
ternary if here.

>   }
>   
> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index 9bb2c7512cd5..5a138f6220c4 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -2706,3 +2706,58 @@ void s390_reset_acc(struct mm_struct *mm)
>   	mmput(mm);
>   }
>   EXPORT_SYMBOL_GPL(s390_reset_acc);
> +
> +/*
> + * Remove the topmost level of page tables from the list of page tables of
> + * the gmap.
> + * This means that it will not be freed when the VM is torn down, and needs
> + * to be handled separately by the caller, unless an intentional leak is
> + * intended.
> + */
> +void s390_remove_old_asce(struct gmap *gmap)
> +{
> +	struct page *old;
> +
> +	old = virt_to_page(gmap->table);
> +	spin_lock(&gmap->guest_table_lock);
> +	list_del(&old->lru);
> +	spin_unlock(&gmap->guest_table_lock);
> +	/* in case the ASCE needs to be "removed" multiple times */
> +	INIT_LIST_HEAD(&old->lru);
> +}
> +EXPORT_SYMBOL_GPL(s390_remove_old_asce);

Is this used anywhere else than below?
This can be static, no?

> +
> +/*
> + * Try to replace the current ASCE with another equivalent one.
> + * If the allocation of the new top level page table fails, the ASCE is not
> + * replaced.
> + * In any case, the old ASCE is removed from the list, therefore the caller
> + * has to make sure to save a pointer to it beforehands, unless an
> + * intentional leak is intended.
> + */
> +int s390_replace_asce(struct gmap *gmap)
> +{
> +	unsigned long asce;
> +	struct page *page;
> +	void *table;
> +
> +	s390_remove_old_asce(gmap);
> +
> +	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
> +	if (!page)
> +		return -ENOMEM;
> +	table = page_to_virt(page);
> +	memcpy(table, gmap->table, 1UL << (CRST_ALLOC_ORDER + PAGE_SHIFT));
> +
> +	spin_lock(&gmap->guest_table_lock);
> +	list_add(&page->lru, &gmap->crst_list);
> +	spin_unlock(&gmap->guest_table_lock);
> +
> +	asce = (gmap->asce & ~PAGE_MASK) | __pa(table);
> +	WRITE_ONCE(gmap->asce, asce);

Are you sure we don't need the mm in write lock?

> +	WRITE_ONCE(gmap->mm->context.gmap_asce, asce);

This is usually changed with the context lock held.

> +	WRITE_ONCE(gmap->table, table);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(s390_replace_asce);
> 

