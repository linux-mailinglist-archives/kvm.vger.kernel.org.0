Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0923A3416
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 21:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbhFJTfK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 15:35:10 -0400
Received: from mail-lf1-f53.google.com ([209.85.167.53]:42821 "EHLO
        mail-lf1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhFJTfI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 15:35:08 -0400
Received: by mail-lf1-f53.google.com with SMTP id j2so4953630lfg.9;
        Thu, 10 Jun 2021 12:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ceEFCfaWcCIy0ElzDio4qVx5/HAKi3T4+rWQRTQywmk=;
        b=uTMmqKV1/EHV2IkJR+zozPe+lbZxHXntZRGKJ8BGJXBWDl7IfUoj83QbMq9vsWP9iL
         B8CLwVHTKzMobvTu9QYxYVCXWgiHZJlepd5QN95Ca3q2eChFOGqEjTtaYpR6xS8T/31e
         Bks6kNrS5X2KFxZJDsY2HobnnexCzqbw58fOXFxmNIX+2cmTyDZbKmsvCPaAHwi2UZkw
         BgFuBFqAMuK5oTkaomSeXQ0KclouWjis7nD/on4oIigkf6RZpNXP8QaCg/RewiTR/bi9
         gXc6aptsZOYJtSJ4xNwNbKZZHkoTOptEO1thdiSFc8efeFUPzRDVhkkXAv2xmxOP/dAo
         Xsjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ceEFCfaWcCIy0ElzDio4qVx5/HAKi3T4+rWQRTQywmk=;
        b=WqAlebruaHJkEhlwDhknkSDNb1/MujS4zQsYtJRl8zU2R15myWO2qLhmz5e0j86J+e
         vAvhOVBMl6g7vfg05A2nH99qWDb2YfUbywX7T2MZ3Fhrlm0QZzA3/oqYpkX4koXKMkdX
         uCMgjUL2UaegKF9qF2Jogpbk+5JCNxxd56u8n8whvjMq0hZr2KGNi6yUiDGySrmUsOAL
         Ac3V0uZf+RQdVtDf8cIinnYUmjt4yT9rHa9B5yUB7i/SB/RskpErwQ5RYr7rNMlLeg4Z
         tngavS2XjTFbJPLdE6iSl+XQYlVeDU0h+eZp6f68Rp9YLQHmYdc+JdjAVjLr1um7FB/6
         p3GA==
X-Gm-Message-State: AOAM531AaGVZvFbdayYzng7yrXf5n3pH6Om6/KEs1jeVHb4VZTweUpKW
        NpyWGt1HbM4/vZj4GxSOfE4=
X-Google-Smtp-Source: ABdhPJzeKGA5ayEBXmZhKvS0JSerAdTETjvEF7FnTPCA+SF5O5wL34fvbQ+0BOjnrh5IGR0T0Yj+Ew==
X-Received: by 2002:ac2:5a4b:: with SMTP id r11mr259219lfn.338.1623353518654;
        Thu, 10 Jun 2021 12:31:58 -0700 (PDT)
Received: from pc638.lan (h5ef52e3d.seluork.dyn.perspektivbredband.net. [94.245.46.61])
        by smtp.gmail.com with ESMTPSA id s12sm270903lfg.44.2021.06.10.12.31.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 12:31:57 -0700 (PDT)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc638.lan>
Date:   Thu, 10 Jun 2021 21:31:55 +0200
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, david@redhat.com,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 1/2] mm/vmalloc: add vmalloc_no_huge
Message-ID: <20210610193155.GA1854@pc638.lan>
References: <20210610154220.529122-1-imbrenda@linux.ibm.com>
 <20210610154220.529122-2-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610154220.529122-2-imbrenda@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello.

See below a small nit:

> The recent patches to add support for hugepage vmalloc mappings added a
> flag for __vmalloc_node_range to allow to request small pages.
> This flag is not accessible when calling vmalloc, the only option is to
> call directly __vmalloc_node_range, which is not exported.
> 
> This means that a module can't vmalloc memory with small pages.
> 
> Case in point: KVM on s390x needs to vmalloc a large area, and it needs
> to be mapped with small pages, because of a hardware limitation.
> 
> This patch adds the function vmalloc_no_huge, which works like vmalloc,
> but it is guaranteed to always back the mapping using small pages. This
> function is exported, therefore it is usable by modules.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> ---
>  include/linux/vmalloc.h |  1 +
>  mm/vmalloc.c            | 16 ++++++++++++++++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> index 4d668abb6391..bfaaf0b6fa76 100644
> --- a/include/linux/vmalloc.h
> +++ b/include/linux/vmalloc.h
> @@ -135,6 +135,7 @@ extern void *__vmalloc_node_range(unsigned long size, unsigned long align,
>  			const void *caller);
>  void *__vmalloc_node(unsigned long size, unsigned long align, gfp_t gfp_mask,
>  		int node, const void *caller);
> +void *vmalloc_no_huge(unsigned long size);
>  
>  extern void vfree(const void *addr);
>  extern void vfree_atomic(const void *addr);
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index a13ac524f6ff..296a2fcc3fbe 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2998,6 +2998,22 @@ void *vmalloc(unsigned long size)
>  }
>  EXPORT_SYMBOL(vmalloc);
>  
> +/**
> + * vmalloc_no_huge - allocate virtually contiguous memory using small pages
> + * @size:    allocation size
> + *
You state that it allocates using "small pages". I think it might be confused 
for people because of that vague meaning. The comment should be improved, imho,
saying rather about order-0 pages what we call "small pages".

> + * Allocate enough non-huge pages to cover @size from the page level
> + * allocator and map them into contiguous kernel virtual space.
> + *
> + * Return: pointer to the allocated memory or %NULL on error
> + */
> +void *vmalloc_no_huge(unsigned long size)
> +{
> +	return __vmalloc_node_range(size, 1, VMALLOC_START, VMALLOC_END, GFP_KERNEL, PAGE_KERNEL,
> +				    VM_NO_HUGE_VMAP, NUMA_NO_NODE, __builtin_return_address(0));
> +}
> +EXPORT_SYMBOL(vmalloc_no_huge);
> +
>  /**
>   * vzalloc - allocate virtually contiguous memory with zero fill
>   * @size:    allocation size
> -- 
> 2.31.1
> 
anyone looks good to me, please use:

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

Thanks.

--
Vlad Rezki
