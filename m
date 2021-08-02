Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B93B3DD028
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 07:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbhHBFzv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 01:55:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33753 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229495AbhHBFzv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Aug 2021 01:55:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627883742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ivPqFlYITqRUkuoXkFTKBay5LBYZ801aDo0Fz7/YC94=;
        b=IGT89iJTZ3oTzkvaGRjUqyqSPQD0oZLGChHHiIAkPNtdaUqRrKc6M12FU6K0BrUxHq6Wmt
        kDqcsl1tR3wg6oVcuOPvpxbwdCcWfUutzlxGQAR/1hNIY23nuxoQPx9ckx6IeGUnQRb9Qm
        uHogsQ/teNJZ0vK1ILWF9H0KozeTk3s=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-emqJwS2FMVauKu9RVNnpOQ-1; Mon, 02 Aug 2021 01:55:40 -0400
X-MC-Unique: emqJwS2FMVauKu9RVNnpOQ-1
Received: by mail-pj1-f71.google.com with SMTP id ep15-20020a17090ae64fb02901772983d308so16080375pjb.4
        for <kvm@vger.kernel.org>; Sun, 01 Aug 2021 22:55:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ivPqFlYITqRUkuoXkFTKBay5LBYZ801aDo0Fz7/YC94=;
        b=b8kQ0yqQ9bOXXYYXzghlDPMLaQfDfVR9JsJY9a+VSE4zqE6NAwwKV8dODOcAyW8Yiq
         iJ83MIU0a4rh7R+LkTbgMMv1jV8JOxX1thK20E1IldkQ6po8AAlQpRtyHzEMFI1lr8am
         AygUbsWu8wWHWkLptutr4/BxW3lcDDD35WLyhoKsN1xnqpFFmGNfwFovRX0/N6zB30bP
         yKi/TWI2mcvhhMyT7VD+6aKz4rS04HwLt96FrXxL8IoNRbjKXng50G+hoymb+BgHSzut
         vqmyOmX0Lftp38m1zkOjQZ5R91rrAv9E5lta0WEtFfmPYB/rOGekk4n/jnEeK218sJTP
         L2Lg==
X-Gm-Message-State: AOAM533il1wVclRtuVY/rAZc4KuqhRvSNDOPXA2LbMQz48ktWAbytltR
        tbwTUc8xA6ojcxQOJjk5x087CvWkQZ30i7OX9meZvOxXSMX8Zi/Ned27tjhVseOSpDgl9zh/o1S
        X4vowhkxNzxvw
X-Received: by 2002:a17:902:7889:b029:12b:cf54:4bf1 with SMTP id q9-20020a1709027889b029012bcf544bf1mr13203523pll.85.1627883739447;
        Sun, 01 Aug 2021 22:55:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwCymVYU/4mTuqAsIpJXfqohEsOKqh1rlQQr8yeuVnx7kilOyGUBZP3wg1qufTUzqmR/4n/Hw==
X-Received: by 2002:a17:902:7889:b029:12b:cf54:4bf1 with SMTP id q9-20020a1709027889b029012bcf544bf1mr13203506pll.85.1627883739140;
        Sun, 01 Aug 2021 22:55:39 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 136sm9275832pge.77.2021.08.01.22.55.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Aug 2021 22:55:38 -0700 (PDT)
Subject: Re: [PATCH] vdpa: Make use of PFN_PHYS/PFN_UP/PFN_DOWN helper macro
To:     Cai Huoqing <caihuoqing@baidu.com>, mst@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20210802013717.851-1-caihuoqing@baidu.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8ae935c5-27fd-ef96-94f1-6d935381ee18@redhat.com>
Date:   Mon, 2 Aug 2021 13:55:35 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210802013717.851-1-caihuoqing@baidu.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/8/2 ÉÏÎç9:37, Cai Huoqing Ð´µÀ:
> it's a nice refactor to make use of
> PFN_PHYS/PFN_UP/PFN_DOWN helper macro
>
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vhost/vdpa.c | 24 ++++++++++++------------
>   1 file changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 210ab35a7ebf..1f6dd6ad0f8b 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -507,15 +507,15 @@ static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v, u64 start, u64 last)
>   	unsigned long pfn, pinned;
>   
>   	while ((map = vhost_iotlb_itree_first(iotlb, start, last)) != NULL) {
> -		pinned = map->size >> PAGE_SHIFT;
> -		for (pfn = map->addr >> PAGE_SHIFT;
> +		pinned = PFN_DOWN(map->size);
> +		for (pfn = PFN_DOWN(map->addr);
>   		     pinned > 0; pfn++, pinned--) {
>   			page = pfn_to_page(pfn);
>   			if (map->perm & VHOST_ACCESS_WO)
>   				set_page_dirty_lock(page);
>   			unpin_user_page(page);
>   		}
> -		atomic64_sub(map->size >> PAGE_SHIFT, &dev->mm->pinned_vm);
> +		atomic64_sub(PFN_DOWN(map->size), &dev->mm->pinned_vm);
>   		vhost_iotlb_map_free(iotlb, map);
>   	}
>   }
> @@ -577,7 +577,7 @@ static int vhost_vdpa_map(struct vhost_vdpa *v,
>   	if (r)
>   		vhost_iotlb_del_range(dev->iotlb, iova, iova + size - 1);
>   	else
> -		atomic64_add(size >> PAGE_SHIFT, &dev->mm->pinned_vm);
> +		atomic64_add(PFN_DOWN(size), &dev->mm->pinned_vm);
>   
>   	return r;
>   }
> @@ -630,7 +630,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>   	if (msg->perm & VHOST_ACCESS_WO)
>   		gup_flags |= FOLL_WRITE;
>   
> -	npages = PAGE_ALIGN(msg->size + (iova & ~PAGE_MASK)) >> PAGE_SHIFT;
> +	npages = PFN_UP(msg->size + (iova & ~PAGE_MASK));
>   	if (!npages) {
>   		ret = -EINVAL;
>   		goto free;
> @@ -638,7 +638,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>   
>   	mmap_read_lock(dev->mm);
>   
> -	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> +	lock_limit = PFN_DOWN(rlimit(RLIMIT_MEMLOCK));
>   	if (npages + atomic64_read(&dev->mm->pinned_vm) > lock_limit) {
>   		ret = -ENOMEM;
>   		goto unlock;
> @@ -672,9 +672,9 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>   
>   			if (last_pfn && (this_pfn != last_pfn + 1)) {
>   				/* Pin a contiguous chunk of memory */
> -				csize = (last_pfn - map_pfn + 1) << PAGE_SHIFT;
> +				csize = PFN_PHYS(last_pfn - map_pfn + 1);
>   				ret = vhost_vdpa_map(v, iova, csize,
> -						     map_pfn << PAGE_SHIFT,
> +						     PFN_PHYS(map_pfn),
>   						     msg->perm);
>   				if (ret) {
>   					/*
> @@ -698,13 +698,13 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>   			last_pfn = this_pfn;
>   		}
>   
> -		cur_base += pinned << PAGE_SHIFT;
> +		cur_base += PFN_PHYS(pinned);
>   		npages -= pinned;
>   	}
>   
>   	/* Pin the rest chunk */
> -	ret = vhost_vdpa_map(v, iova, (last_pfn - map_pfn + 1) << PAGE_SHIFT,
> -			     map_pfn << PAGE_SHIFT, msg->perm);
> +	ret = vhost_vdpa_map(v, iova, PFN_PHYS(last_pfn - map_pfn + 1),
> +			     PFN_PHYS(map_pfn), msg->perm);
>   out:
>   	if (ret) {
>   		if (nchunks) {
> @@ -944,7 +944,7 @@ static vm_fault_t vhost_vdpa_fault(struct vm_fault *vmf)
>   
>   	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>   	if (remap_pfn_range(vma, vmf->address & PAGE_MASK,
> -			    notify.addr >> PAGE_SHIFT, PAGE_SIZE,
> +			    PFN_DOWN(notify.addr), PAGE_SIZE,
>   			    vma->vm_page_prot))
>   		return VM_FAULT_SIGBUS;
>   

