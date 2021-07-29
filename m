Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40AD43DA161
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 12:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236845AbhG2Klr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 06:41:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5240 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236472AbhG2KlQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 06:41:16 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16TAYXtX106634;
        Thu, 29 Jul 2021 06:41:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=P4nlcbha8dTdMecIbaR80SHCens3QyY3dDcPDl+TIhI=;
 b=Iesco2nhjGcKjdGl7cVHmO0Gcr+FXFDJJ9T9tKOIf9JTMLKWb0khnHzr35sgXV4d9QXm
 gE+acHhZdzC+qTYyh1sF0ODoYKu5e1yLsMkMjpT3HjvCstbtg4rU/iFKAt169H7cxGB8
 vYk5fQo/a75l9K2Lv3unr8St7XcFuUIPPmto0wkFkpL7MMMqUDA1yZhDejr7859GpT2t
 S4fu/p0x3cPuwo7G7VOhsKJMSCl3pnbGILxwriLfwaEEbEB5M6wvRyPrRtocMSrrVFEp
 97XHCnj9qcHsizAU+g6WtceMtQiXywtw4RdBxBkExoFj7eizW9pLwJ2dAXPdF8se1n51 Yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a3mm43kdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 06:41:12 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16TAYYMW106908;
        Thu, 29 Jul 2021 06:41:12 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a3mm43kbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 06:41:12 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16TAeNgn009499;
        Thu, 29 Jul 2021 10:41:10 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3a235ks2ht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 10:41:10 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16TAcMpw12321232
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 10:38:22 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6C2B11C086;
        Thu, 29 Jul 2021 10:41:06 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E44A11C07A;
        Thu, 29 Jul 2021 10:41:06 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.155.135])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 29 Jul 2021 10:41:06 +0000 (GMT)
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210728142631.41860-1-imbrenda@linux.ibm.com>
 <20210728142631.41860-3-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v2 02/13] KVM: s390: pv: leak the ASCE page when destroy
 fails
Message-ID: <21eb4861-f118-cf3b-409e-ea31694582a5@linux.ibm.com>
Date:   Thu, 29 Jul 2021 12:41:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210728142631.41860-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nKqI9UAJBKnoxS2EC2XuMcvZKomrfjQX
X-Proofpoint-ORIG-GUID: xCutagb2i20WU-FQFIbWoRci4TN_OIUn
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-29_09:2021-07-29,2021-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107290068
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/28/21 4:26 PM, Claudio Imbrenda wrote:
> When a protected VM is created, the topmost level of page tables of its
> ASCE is marked by the Ultravisor; any attempt to use that memory for
> protected virtualization will result in failure.
> 
> Only a successful Destroy Configuration UVC will remove the marking.
> 
> When the Destroy Configuration UVC fails, the topmost level of page
> tables of the VM does not get its marking cleared; to avoid issues it
> must not be used again.
> 
> Since the page becomes in practice unusable, we set it aside and leak it.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/kvm/pv.c | 53 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 52 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index e007df11a2fe..1ecdc1769ed9 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -155,6 +155,55 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
>  	return -ENOMEM;
>  }
>  
> +/*
> + * Remove the topmost level of page tables from the list of page tables of
> + * the gmap.
> + * This means that it will not be freed when the VM is torn down, and needs
> + * to be handled separately by the caller, unless an intentional leak is
> + * intended.
> + */
> +static void kvm_s390_pv_remove_old_asce(struct kvm *kvm)
> +{
> +	struct page *old;
> +
> +	old = virt_to_page(kvm->arch.gmap->table);
> +	list_del(&old->lru);
> +	/* in case the ASCE needs to be "removed" multiple times */
> +	INIT_LIST_HEAD(&old->lru);
> +}
> +
> +/*
> + * Try to replace the current ASCE with another equivalent one.
> + * If the allocation of the new top level page table fails, the ASCE is not
> + * replaced.
> + * In any case, the old ASCE is removed from the list, therefore the caller
> + * has to make sure to save a pointer to it beforehands, unless an
> + * intentional leak is intended.
> + */
> +static int kvm_s390_pv_replace_asce(struct kvm *kvm)
> +{
> +	unsigned long asce;
> +	struct page *page;
> +	void *table;
> +
> +	kvm_s390_pv_remove_old_asce(kvm);
> +
> +	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
> +	if (!page)
> +		return -ENOMEM;
> +	list_add(&page->lru, &kvm->arch.gmap->crst_list);
> +
> +	table = page_to_virt(page);
> +	memcpy(table, kvm->arch.gmap->table, 1UL << (CRST_ALLOC_ORDER + PAGE_SHIFT));

Don't we want to memcpy first and then add it to the list?
The gmap is still active per-se so I think we want to take the
guest_table_lock for the list_add here.

> +
> +	asce = (kvm->arch.gmap->asce & ~PAGE_MASK) | __pa(table);
> +	WRITE_ONCE(kvm->arch.gmap->asce, asce);
> +	WRITE_ONCE(kvm->mm->context.gmap_asce, asce);
> +	WRITE_ONCE(kvm->arch.gmap->table, table);

If I remember correctly those won't need locks but I'm not 100% sure so
please have a look at that.

> +
> +	return 0;
> +}

That should both be in gmap.c

> +
>  /* this should not fail, but if it does, we must not free the donated memory */
>  int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>  {
> @@ -169,9 +218,11 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>  	atomic_set(&kvm->mm->context.is_protected, 0);
>  	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", *rc, *rrc);
>  	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", *rc, *rrc);
> -	/* Inteded memory leak on "impossible" error */
> +	/* Intended memory leak on "impossible" error */
>  	if (!cc)
>  		kvm_s390_pv_dealloc_vm(kvm);
> +	else
> +		kvm_s390_pv_replace_asce(kvm);
>  	return cc ? -EIO : 0;
>  }
>  
> 

