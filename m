Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E986151AED
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 14:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbgBDNFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 08:05:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57615 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727149AbgBDNFs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 08:05:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580821545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=sEpf/qKEN66HG2Yj5iWbTSi8VKQT6RBNq6+ZGqF+ais=;
        b=TIUER4qrwkhH9I/S70QFJ+WXLSmcJf+ukn0qQxswXGzzIp4eg2MLT1F0J7MrEERqHAasb+
        mq21myxQMFqBUDmOCX7Ywr3F8OLNxuh5+PV7qI/GlScKw5h+04Jkx/xgRlceM3QfWrNKzw
        Am9fXjzLIHo6n5oWrj1KZaNSLtNIaBY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-tpMExYwONIus7-GEXMP1FA-1; Tue, 04 Feb 2020 08:05:42 -0500
X-MC-Unique: tpMExYwONIus7-GEXMP1FA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD5E7800D54;
        Tue,  4 Feb 2020 13:05:40 +0000 (UTC)
Received: from [10.36.117.121] (ovpn-117-121.ams2.redhat.com [10.36.117.121])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D81961000322;
        Tue,  4 Feb 2020 13:05:38 +0000 (UTC)
Subject: Re: [PATCH v2 10/37] KVM: s390: protvirt: Secure memory is not
 mergeable
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Ulrich.Weigand@de.ibm.com, aarcange@redhat.com, cohuck@redhat.com,
        frankja@linux.vnet.ibm.com, imbrenda@linux.ibm.com,
        kvm@vger.kernel.org, thuth@redhat.com,
        Janosch Frank <frankja@linux.ibm.com>
References: <04c69c18-52e8-c09e-d93e-dbf2c006ac5e@redhat.com>
 <20200204130418.226980-1-borntraeger@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <849b4d84-0dc0-9691-f145-1bc0e6c2e20e@redhat.com>
Date:   Tue, 4 Feb 2020 14:05:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200204130418.226980-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.02.20 14:04, Christian Borntraeger wrote:
> From: Janosch Frank <frankja@linux.ibm.com>
> 
> KSM will not work on secure pages, because when the kernel reads a
> secure page, it will be encrypted and hence no two pages will look the
> same.
> 
> Let's mark the guest pages as unmergeable when we transition to secure
> mode.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>  arch/s390/include/asm/gmap.h |  1 +
>  arch/s390/kvm/kvm-s390.c     |  6 ++++++
>  arch/s390/mm/gmap.c          | 30 ++++++++++++++++++++----------
>  3 files changed, 27 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
> index e2d2f48c5c7c..e1f2cc0b2b00 100644
> --- a/arch/s390/include/asm/gmap.h
> +++ b/arch/s390/include/asm/gmap.h
> @@ -146,4 +146,5 @@ int gmap_mprotect_notify(struct gmap *, unsigned long start,
>  
>  void gmap_sync_dirty_log_pmd(struct gmap *gmap, unsigned long dirty_bitmap[4],
>  			     unsigned long gaddr, unsigned long vmaddr);
> +int gmap_mark_unmergeable(void);
>  #endif /* _ASM_S390_GMAP_H */
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 35f46404830f..741d81f57c3c 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2181,6 +2181,12 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>  		if (r)
>  			break;
>  
> +		down_write(&current->mm->mmap_sem);
> +		r = gmap_mark_unmergeable();
> +		up_write(&current->mm->mmap_sem);
> +		if (r)
> +			break;
> +
>  		mutex_lock(&kvm->lock);
>  		kvm_s390_vcpu_block_all(kvm);
>  		/* FMT 4 SIE needs esca */
> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index edcdca97e85e..7291452fe5f0 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -2548,6 +2548,22 @@ int s390_enable_sie(void)
>  }
>  EXPORT_SYMBOL_GPL(s390_enable_sie);
>  
> +int gmap_mark_unmergeable(void)
> +{
> +	struct mm_struct *mm = current->mm;
> +	struct vm_area_struct *vma;
> +
> +	for (vma = mm->mmap; vma; vma = vma->vm_next) {
> +		if (ksm_madvise(vma, vma->vm_start, vma->vm_end,
> +				MADV_UNMERGEABLE, &vma->vm_flags)) {
> +			return -ENOMEM;
> +		}
> +	}
> +	mm->def_flags &= ~VM_MERGEABLE;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(gmap_mark_unmergeable);
> +
>  /*
>   * Enable storage key handling from now on and initialize the storage
>   * keys with the default key.
> @@ -2593,7 +2609,6 @@ static const struct mm_walk_ops enable_skey_walk_ops = {
>  int s390_enable_skey(void)
>  {
>  	struct mm_struct *mm = current->mm;
> -	struct vm_area_struct *vma;
>  	int rc = 0;
>  
>  	down_write(&mm->mmap_sem);
> @@ -2601,16 +2616,11 @@ int s390_enable_skey(void)
>  		goto out_up;
>  
>  	mm->context.uses_skeys = 1;
> -	for (vma = mm->mmap; vma; vma = vma->vm_next) {
> -		if (ksm_madvise(vma, vma->vm_start, vma->vm_end,
> -				MADV_UNMERGEABLE, &vma->vm_flags)) {
> -			mm->context.uses_skeys = 0;
> -			rc = -ENOMEM;
> -			goto out_up;
> -		}
> +	rc = gmap_mark_unmergeable();
> +	if (rc) {
> +		mm->context.uses_skeys = 0;
> +		goto out_up;
>  	}
> -	mm->def_flags &= ~VM_MERGEABLE;
> -
>  	walk_page_range(mm, 0, TASK_SIZE, &enable_skey_walk_ops, NULL);
>  
>  out_up:
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

