Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63444429F2A
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 10:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234570AbhJLICC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 04:02:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49568 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232541AbhJLICB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Oct 2021 04:02:01 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19C7fgfC013201;
        Tue, 12 Oct 2021 03:59:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=wrVENqNRU25Q88pa8wtSKcLPj3NzanGtOG60FEay2AY=;
 b=seOtrbXYYpl6dhJjpkv2nSSCqb6WoC25J93sh4xf1tTlRNiowlkJcCXyvnKSU7ACJwqR
 h8uCPAIE/suVl/3JoI4Tj2Esn+aDxqNvKMMZYV8VxsXwL0xvGi6chehViO3n4UupK+9G
 SOoqWziy6rjmdGG08iTFy+h36kjfygOnyP5B8sDVyoPD/yuqyIPALXnycHXaVGSgV1ZS
 F8Qpnnewt68LgOiq3KfBNpAQq6+fAvBQ1nBrJhpyaDqUsMYwpwNjqJi/HUaKhu3P5p5A
 xcMBF2kyem3tw6htn1i9utMituvPC4XVcxln2JgQh5Jb1pOnU6FQy/Wx4jsOMlwOEKcv /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bn66qgaku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 03:59:59 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19C7hs6m021288;
        Tue, 12 Oct 2021 03:59:58 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bn66qgakf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 03:59:58 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19C7vNoV002477;
        Tue, 12 Oct 2021 07:59:57 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3bk2q9ws42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 07:59:56 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19C7xp8166257176
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 07:59:51 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C831A4059;
        Tue, 12 Oct 2021 07:59:51 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF300A4055;
        Tue, 12 Oct 2021 07:59:50 +0000 (GMT)
Received: from [9.145.20.44] (unknown [9.145.20.44])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Oct 2021 07:59:50 +0000 (GMT)
Message-ID: <0da85285-3624-5a41-2f0e-1c462ee72d1a@linux.ibm.com>
Date:   Tue, 12 Oct 2021 09:59:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v5 06/14] KVM: s390: pv: properly handle page flags for
 protected guests
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ulrich.Weigand@de.ibm.com
References: <20210920132502.36111-1-imbrenda@linux.ibm.com>
 <20210920132502.36111-7-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20210920132502.36111-7-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4PJL1rj-imEYZ6aGo0Wc9BMFgAhT0ZMY
X-Proofpoint-GUID: fb71DUZLzzGKY0bYoYff2bfbfd0YBVO7
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
> Introduce variants of the convert and destroy page functions that also
> clear the PG_arch_1 bit used to mark them as secure pages.
> 
> The PG_arch_1 flag is always allowed to overindicate; using the new
> functions introduced here allows to reduce the extent of overindication
> and thus improve performance.
> 
> These new functions can only be called on pages for which a reference
> is already being held.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Acked-by: Janosch Frank <frankja@linux.ibm.com>

You can make this one a Reviewed-by

> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>   arch/s390/include/asm/pgtable.h |  9 ++++++---
>   arch/s390/include/asm/uv.h      | 10 ++++++++--
>   arch/s390/kernel/uv.c           | 34 ++++++++++++++++++++++++++++++++-
>   arch/s390/mm/gmap.c             |  4 +++-
>   4 files changed, 50 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
> index dcac7b2df72c..0f1af2232ebe 100644
> --- a/arch/s390/include/asm/pgtable.h
> +++ b/arch/s390/include/asm/pgtable.h
> @@ -1074,8 +1074,9 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
>   	pte_t res;
>   
>   	res = ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
> +	/* At this point the reference through the mapping is still present */
>   	if (mm_is_protected(mm) && pte_present(res))
> -		uv_convert_from_secure(pte_val(res) & PAGE_MASK);
> +		uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
>   	return res;
>   }
>   
> @@ -1091,8 +1092,9 @@ static inline pte_t ptep_clear_flush(struct vm_area_struct *vma,
>   	pte_t res;
>   
>   	res = ptep_xchg_direct(vma->vm_mm, addr, ptep, __pte(_PAGE_INVALID));
> +	/* At this point the reference through the mapping is still present */
>   	if (mm_is_protected(vma->vm_mm) && pte_present(res))
> -		uv_convert_from_secure(pte_val(res) & PAGE_MASK);
> +		uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
>   	return res;
>   }
>   
> @@ -1116,8 +1118,9 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
>   	} else {
>   		res = ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
>   	}
> +	/* At this point the reference through the mapping is still present */
>   	if (mm_is_protected(mm) && pte_present(res))
> -		uv_convert_from_secure(pte_val(res) & PAGE_MASK);
> +		uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
>   	return res;
>   }
>   
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index b35add51b967..3236293d5a31 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -356,8 +356,9 @@ static inline int is_prot_virt_host(void)
>   }
>   
>   int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb);
> -int uv_destroy_page(unsigned long paddr);
> +int uv_destroy_owned_page(unsigned long paddr);
>   int uv_convert_from_secure(unsigned long paddr);
> +int uv_convert_owned_from_secure(unsigned long paddr);
>   int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr);
>   
>   void setup_uv(void);
> @@ -367,7 +368,7 @@ void adjust_to_uv_max(unsigned long *vmax);
>   static inline void setup_uv(void) {}
>   static inline void adjust_to_uv_max(unsigned long *vmax) {}
>   
> -static inline int uv_destroy_page(unsigned long paddr)
> +static inline int uv_destroy_owned_page(unsigned long paddr)
>   {
>   	return 0;
>   }
> @@ -376,6 +377,11 @@ static inline int uv_convert_from_secure(unsigned long paddr)
>   {
>   	return 0;
>   }
> +
> +static inline int uv_convert_owned_from_secure(unsigned long paddr)
> +{
> +	return 0;
> +}
>   #endif
>   
>   #if defined(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) || IS_ENABLED(CONFIG_KVM)
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index 68a8fbafcb9c..05f8bf61d20a 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -115,7 +115,7 @@ static int uv_pin_shared(unsigned long paddr)
>    *
>    * @paddr: Absolute host address of page to be destroyed
>    */
> -int uv_destroy_page(unsigned long paddr)
> +static int uv_destroy_page(unsigned long paddr)
>   {
>   	struct uv_cb_cfs uvcb = {
>   		.header.cmd = UVC_CMD_DESTR_SEC_STOR,
> @@ -135,6 +135,22 @@ int uv_destroy_page(unsigned long paddr)
>   	return 0;
>   }
>   
> +/*
> + * The caller must already hold a reference to the page
> + */
> +int uv_destroy_owned_page(unsigned long paddr)
> +{
> +	struct page *page = phys_to_page(paddr);
> +	int rc;
> +
> +	get_page(page);
> +	rc = uv_destroy_page(paddr);
> +	if (!rc)
> +		clear_bit(PG_arch_1, &page->flags);
> +	put_page(page);
> +	return rc;
> +}
> +
>   /*
>    * Requests the Ultravisor to encrypt a guest page and make it
>    * accessible to the host for paging (export).
> @@ -154,6 +170,22 @@ int uv_convert_from_secure(unsigned long paddr)
>   	return 0;
>   }
>   
> +/*
> + * The caller must already hold a reference to the page
> + */
> +int uv_convert_owned_from_secure(unsigned long paddr)
> +{
> +	struct page *page = phys_to_page(paddr);
> +	int rc;
> +
> +	get_page(page);
> +	rc = uv_convert_from_secure(paddr);
> +	if (!rc)
> +		clear_bit(PG_arch_1, &page->flags);
> +	put_page(page);
> +	return rc;
> +}
> +
>   /*
>    * Calculate the expected ref_count for a page that would otherwise have no
>    * further pins. This was cribbed from similar functions in other places in
> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index 5a138f6220c4..38b792ab57f7 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -2678,8 +2678,10 @@ static int __s390_reset_acc(pte_t *ptep, unsigned long addr,
>   {
>   	pte_t pte = READ_ONCE(*ptep);
>   
> +	/* There is a reference through the mapping */
>   	if (pte_present(pte))
> -		WARN_ON_ONCE(uv_destroy_page(pte_val(pte) & PAGE_MASK));
> +		WARN_ON_ONCE(uv_destroy_owned_page(pte_val(pte) & PAGE_MASK));
> +
>   	return 0;
>   }
>   
> 

