Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5AE2A9586
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 12:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgKFLfj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 06:35:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36408 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726708AbgKFLfi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Nov 2020 06:35:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604662536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fJHz2Dd3He80ZlbvVM+gJqtJxDfXM+0TYWHsYubqnHA=;
        b=gRkw0z34+V4AFyNC+P9DB1/iJk8lxizy1tHerml72yg39CurLmSfXsSPDqdZTyk1DKCRcH
        T7KGFy6ouOXsoPfhQlixtNrdlp34c1SFATVSfTDnxKRrRo+erjkDUfqDS0x2+H6tO6mulH
        uk8bNwxMI+kX/GGt3gfjBa7j15DdUb0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-Ohh90G7WNrKDz6cGUeGZ9g-1; Fri, 06 Nov 2020 06:35:35 -0500
X-MC-Unique: Ohh90G7WNrKDz6cGUeGZ9g-1
Received: by mail-wr1-f72.google.com with SMTP id i1so362218wrb.18
        for <kvm@vger.kernel.org>; Fri, 06 Nov 2020 03:35:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fJHz2Dd3He80ZlbvVM+gJqtJxDfXM+0TYWHsYubqnHA=;
        b=OoeHmVJWqrC70WFgzvKOlNJXGeO8jHRTvqjJKqhLc4wgEAnDWHup3sBbnaOxslRUo8
         5xAums+2QuToREhtZbdAdC3aSrCSULPthZxmhq81LOCcDN/MBMTzmM++poWwavDh2x4B
         6/7JFs43I6iYL5AD9rxb1BawmPOr2IKicQnM2opnZ/NBTxVWKzBmGCpZ3cdK+WKk6x2f
         FRCV9BUlJZ4sr5rmpeWFtXmQkKuPdjh9TsO0edfgsZRv4V/srTh877H+ztojmwgIySs7
         73p6hIzXU6t4CnDM7HmcAVRAomDOegUSdqLVpPET9KGkaffjqpKVwez0By6GERAiiKg3
         paJw==
X-Gm-Message-State: AOAM531f5WHueYRCw3RPW7g8raOTi+s2Ww7Msvi6eJDzOPkiLdTakaS/
        Q9QfGcdsavOv4APifKWgmrjY/EtFmvYDx2SVCyIn7nxT5Xcle/sSQq+/iOxv7QQUzGD1E7eiYZY
        a5egijGUfmwQo
X-Received: by 2002:a1c:6456:: with SMTP id y83mr2066694wmb.59.1604662534045;
        Fri, 06 Nov 2020 03:35:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwfj/1P0jxdaRxw0f6c5mSnMkNnkB+lFS+8Z56t3gCdkIUD8pP9pVTN5VWFIMOSQqQJS6t6SQ==
X-Received: by 2002:a1c:6456:: with SMTP id y83mr2066672wmb.59.1604662533858;
        Fri, 06 Nov 2020 03:35:33 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id v14sm1707985wrq.46.2020.11.06.03.35.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2020 03:35:33 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v2 6/7] lib/alloc.h: remove align_min from
 struct alloc_ops
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, lvivier@redhat.com
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
 <20201002154420.292134-7-imbrenda@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f353e392-7a19-4657-3ee5-b609624d751e@redhat.com>
Date:   Fri, 6 Nov 2020 12:35:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201002154420.292134-7-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/20 17:44, Claudio Imbrenda wrote:
> Remove align_min from struct alloc_ops.

... because? :)

Paolo

> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   lib/alloc.h      | 1 -
>   lib/alloc_page.c | 1 -
>   lib/alloc_phys.c | 9 +++++----
>   lib/vmalloc.c    | 1 -
>   4 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/lib/alloc.h b/lib/alloc.h
> index 9b4b634..db90b01 100644
> --- a/lib/alloc.h
> +++ b/lib/alloc.h
> @@ -25,7 +25,6 @@
>   struct alloc_ops {
>   	void *(*memalign)(size_t alignment, size_t size);
>   	void (*free)(void *ptr);
> -	size_t align_min;
>   };
>   
>   extern struct alloc_ops *alloc_ops;
> diff --git a/lib/alloc_page.c b/lib/alloc_page.c
> index 046082a..3c6c4ee 100644
> --- a/lib/alloc_page.c
> +++ b/lib/alloc_page.c
> @@ -320,7 +320,6 @@ void *alloc_page()
>   static struct alloc_ops page_alloc_ops = {
>   	.memalign = memalign_pages,
>   	.free = free_pages,
> -	.align_min = PAGE_SIZE,
>   };
>   
>   /*
> diff --git a/lib/alloc_phys.c b/lib/alloc_phys.c
> index 72e20f7..a4d2bf2 100644
> --- a/lib/alloc_phys.c
> +++ b/lib/alloc_phys.c
> @@ -29,8 +29,8 @@ static phys_addr_t base, top;
>   static void *early_memalign(size_t alignment, size_t size);
>   static struct alloc_ops early_alloc_ops = {
>   	.memalign = early_memalign,
> -	.align_min = DEFAULT_MINIMUM_ALIGNMENT
>   };
> +static size_t align_min;
>   
>   struct alloc_ops *alloc_ops = &early_alloc_ops;
>   
> @@ -39,8 +39,7 @@ void phys_alloc_show(void)
>   	int i;
>   
>   	spin_lock(&lock);
> -	printf("phys_alloc minimum alignment: %#" PRIx64 "\n",
> -		(u64)early_alloc_ops.align_min);
> +	printf("phys_alloc minimum alignment: %#" PRIx64 "\n", (u64)align_min);
>   	for (i = 0; i < nr_regions; ++i)
>   		printf("%016" PRIx64 "-%016" PRIx64 " [%s]\n",
>   			(u64)regions[i].base,
> @@ -64,7 +63,7 @@ void phys_alloc_set_minimum_alignment(phys_addr_t align)
>   {
>   	assert(align && !(align & (align - 1)));
>   	spin_lock(&lock);
> -	early_alloc_ops.align_min = align;
> +	align_min = align;
>   	spin_unlock(&lock);
>   }
>   
> @@ -83,6 +82,8 @@ static phys_addr_t phys_alloc_aligned_safe(phys_addr_t size,
>   		top_safe = MIN(top_safe, 1ULL << 32);
>   
>   	assert(base < top_safe);
> +	if (align < align_min)
> +		align = align_min;
>   
>   	addr = ALIGN(base, align);
>   	size += addr - base;
> diff --git a/lib/vmalloc.c b/lib/vmalloc.c
> index 986a34c..b28a390 100644
> --- a/lib/vmalloc.c
> +++ b/lib/vmalloc.c
> @@ -188,7 +188,6 @@ static void vm_free(void *mem)
>   static struct alloc_ops vmalloc_ops = {
>   	.memalign = vm_memalign,
>   	.free = vm_free,
> -	.align_min = PAGE_SIZE,
>   };
>   
>   void __attribute__((__weak__)) find_highmem(void)
> 

