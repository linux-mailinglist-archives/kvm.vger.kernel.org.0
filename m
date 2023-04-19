Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 648C46E757D
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 10:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbjDSIkX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 04:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232701AbjDSIkU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 04:40:20 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2F3D334;
        Wed, 19 Apr 2023 01:40:15 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id u3so27614583ejj.12;
        Wed, 19 Apr 2023 01:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681893614; x=1684485614;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=11sl8AqwZce1ertKq6Ztt8iuR+fB42Oex6pJ+U7xw2I=;
        b=DxJtLunx5h16pRRZ84LYqFPi6EJHNEhDJ/4M06dgxM2ur0kqsRc/6YtsMxfHQkzoDi
         ylakpROJRFG1jWkLkiLWH6m6zs8oZIVmbqf6QE9Rh/UhnpnDwyUZLPXmRvssJpYoZDq4
         dA3oUTNV0tBOII15372NBzNp9bOvYkzlTfEGJZxIKEZikoq9gVKGcJkNHYO6vsl30gna
         Gw8nQ26WHKu+rcmyKVnUkkkfKQfl1+bOO1WVUamcinpol0p8Vo9pbY75wEeWdU0DqoDB
         dgYTurZ1swwpQk3ZMlRno2Rs8y2I93xbBQuelN2GGxgHUd1i/SzDDEWa3kQT/R19xDwt
         vpiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681893614; x=1684485614;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=11sl8AqwZce1ertKq6Ztt8iuR+fB42Oex6pJ+U7xw2I=;
        b=VJek+dCecDi6MZ6wfuq+jTloHisdaMNTSpk7jE6lAISZIsjXpCRDhmLE2CVJ/6hteH
         vJxi7VHmi11WB43/FVO5GdYIAbu4P4YMprPWfXnaYNio0TWr3JpCLBEvWO2J8ZhFzu8X
         CS8xMpVakdDloJwXFJmpJPYeKK63Xcnq0ENvsjaQac49pZXl1TlDanXzsC6wg7Dd36xS
         WMobdf8zI0BmiQ5qkGuXxQt8glx5kvRw5X/A+3eWtGUcGfX/ryg5ZbcWh4kVQJO7XewH
         Xaynexr6BbU+Bcynee+AXC7bgIZ9lJE1yarCG8YowbeKnZHJq/C5yui9UzyM+kUTjB2f
         s3CA==
X-Gm-Message-State: AAQBX9fVcHT2+Vz96ZKJ3BNnFs37GKk2EAQoKyVbwtuhXsBcFAh6MNoq
        dIyfAClgcKMWslTzTYDN3mg=
X-Google-Smtp-Source: AKy350aFo85fWHrw1usKNUqmGwHdN9xEddgt1lB/ijvfifKCIrYYuxvdWJI7HS4UtLXKs9qddbPlAw==
X-Received: by 2002:a17:906:9153:b0:94e:6504:d134 with SMTP id y19-20020a170906915300b0094e6504d134mr13768717ejw.42.1681893613729;
        Wed, 19 Apr 2023 01:40:13 -0700 (PDT)
Received: from ?IPV6:2a02:908:1256:79a0:6273:6c76:9697:9b4c? ([2a02:908:1256:79a0:6273:6c76:9697:9b4c])
        by smtp.gmail.com with ESMTPSA id qm5-20020a170907674500b0094e3ddcf153sm8949825ejc.115.2023.04.19.01.40.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 01:40:13 -0700 (PDT)
Message-ID: <6703b9b2-539f-9a1b-82b8-244328472640@gmail.com>
Date:   Wed, 19 Apr 2023 10:40:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v4 1/6] mm/gup: remove unused vmas parameter from
 get_user_pages()
Content-Language: en-US
To:     Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Matthew Wilcox <willy@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Xinhui Pan <Xinhui.Pan@amd.com>, x86@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dri-devel@lists.freedesktop.org, Jason Gunthorpe <jgg@nvidia.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        amd-gfx@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Airlie <airlied@gmail.com>, linux-sgx@vger.kernel.org
References: <cover.1681831798.git.lstoakes@gmail.com>
 <cd05b41d6d15ee9ff94273bc116ed3db3f5125bf.1681831798.git.lstoakes@gmail.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
In-Reply-To: <cd05b41d6d15ee9ff94273bc116ed3db3f5125bf.1681831798.git.lstoakes@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 18.04.23 um 17:49 schrieb Lorenzo Stoakes:
> No invocation of get_user_pages() uses the vmas parameter, so remove
> it.
>
> The GUP API is confusing and caveated. Recent changes have done much to
> improve that, however there is more we can do. Exporting vmas is a prime
> target as the caller has to be extremely careful to preclude their use
> after the mmap_lock has expired or otherwise be left with dangling
> pointers.
>
> Removing the vmas parameter focuses the GUP functions upon their primary
> purpose - pinning (and outputting) pages as well as performing the actions
> implied by the input flags.
>
> This is part of a patch series aiming to remove the vmas parameter
> altogether.

Astonishing that there are so few users of the original get_user_pages() 
API left.

>
> Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>

Acked-by: Christian König <christian.koenig@amd.com> for the radeon parts.

Regards,
Christian.

> ---
>   arch/x86/kernel/cpu/sgx/ioctl.c     | 2 +-
>   drivers/gpu/drm/radeon/radeon_ttm.c | 2 +-
>   drivers/misc/sgi-gru/grufault.c     | 2 +-
>   include/linux/mm.h                  | 3 +--
>   mm/gup.c                            | 9 +++------
>   mm/gup_test.c                       | 5 ++---
>   virt/kvm/kvm_main.c                 | 2 +-
>   7 files changed, 10 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> index 21ca0a831b70..5d390df21440 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -214,7 +214,7 @@ static int __sgx_encl_add_page(struct sgx_encl *encl,
>   	if (!(vma->vm_flags & VM_MAYEXEC))
>   		return -EACCES;
>   
> -	ret = get_user_pages(src, 1, 0, &src_page, NULL);
> +	ret = get_user_pages(src, 1, 0, &src_page);
>   	if (ret < 1)
>   		return -EFAULT;
>   
> diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
> index 1e8e287e113c..0597540f0dde 100644
> --- a/drivers/gpu/drm/radeon/radeon_ttm.c
> +++ b/drivers/gpu/drm/radeon/radeon_ttm.c
> @@ -362,7 +362,7 @@ static int radeon_ttm_tt_pin_userptr(struct ttm_device *bdev, struct ttm_tt *ttm
>   		struct page **pages = ttm->pages + pinned;
>   
>   		r = get_user_pages(userptr, num_pages, write ? FOLL_WRITE : 0,
> -				   pages, NULL);
> +				   pages);
>   		if (r < 0)
>   			goto release_pages;
>   
> diff --git a/drivers/misc/sgi-gru/grufault.c b/drivers/misc/sgi-gru/grufault.c
> index b836936e9747..378cf02a2aa1 100644
> --- a/drivers/misc/sgi-gru/grufault.c
> +++ b/drivers/misc/sgi-gru/grufault.c
> @@ -185,7 +185,7 @@ static int non_atomic_pte_lookup(struct vm_area_struct *vma,
>   #else
>   	*pageshift = PAGE_SHIFT;
>   #endif
> -	if (get_user_pages(vaddr, 1, write ? FOLL_WRITE : 0, &page, NULL) <= 0)
> +	if (get_user_pages(vaddr, 1, write ? FOLL_WRITE : 0, &page) <= 0)
>   		return -EFAULT;
>   	*paddr = page_to_phys(page);
>   	put_page(page);
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 37554b08bb28..b14cc4972d0b 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2380,8 +2380,7 @@ long pin_user_pages_remote(struct mm_struct *mm,
>   			   unsigned int gup_flags, struct page **pages,
>   			   struct vm_area_struct **vmas, int *locked);
>   long get_user_pages(unsigned long start, unsigned long nr_pages,
> -			    unsigned int gup_flags, struct page **pages,
> -			    struct vm_area_struct **vmas);
> +		    unsigned int gup_flags, struct page **pages);
>   long pin_user_pages(unsigned long start, unsigned long nr_pages,
>   		    unsigned int gup_flags, struct page **pages,
>   		    struct vm_area_struct **vmas);
> diff --git a/mm/gup.c b/mm/gup.c
> index 1f72a717232b..7e454d6b157e 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2251,8 +2251,6 @@ long get_user_pages_remote(struct mm_struct *mm,
>    * @pages:      array that receives pointers to the pages pinned.
>    *              Should be at least nr_pages long. Or NULL, if caller
>    *              only intends to ensure the pages are faulted in.
> - * @vmas:       array of pointers to vmas corresponding to each page.
> - *              Or NULL if the caller does not require them.
>    *
>    * This is the same as get_user_pages_remote(), just with a less-flexible
>    * calling convention where we assume that the mm being operated on belongs to
> @@ -2260,16 +2258,15 @@ long get_user_pages_remote(struct mm_struct *mm,
>    * obviously don't pass FOLL_REMOTE in here.
>    */
>   long get_user_pages(unsigned long start, unsigned long nr_pages,
> -		unsigned int gup_flags, struct page **pages,
> -		struct vm_area_struct **vmas)
> +		    unsigned int gup_flags, struct page **pages)
>   {
>   	int locked = 1;
>   
> -	if (!is_valid_gup_args(pages, vmas, NULL, &gup_flags, FOLL_TOUCH))
> +	if (!is_valid_gup_args(pages, NULL, NULL, &gup_flags, FOLL_TOUCH))
>   		return -EINVAL;
>   
>   	return __get_user_pages_locked(current->mm, start, nr_pages, pages,
> -				       vmas, &locked, gup_flags);
> +				       NULL, &locked, gup_flags);
>   }
>   EXPORT_SYMBOL(get_user_pages);
>   
> diff --git a/mm/gup_test.c b/mm/gup_test.c
> index 8ae7307a1bb6..9ba8ea23f84e 100644
> --- a/mm/gup_test.c
> +++ b/mm/gup_test.c
> @@ -139,8 +139,7 @@ static int __gup_test_ioctl(unsigned int cmd,
>   						 pages + i);
>   			break;
>   		case GUP_BASIC_TEST:
> -			nr = get_user_pages(addr, nr, gup->gup_flags, pages + i,
> -					    NULL);
> +			nr = get_user_pages(addr, nr, gup->gup_flags, pages + i);
>   			break;
>   		case PIN_FAST_BENCHMARK:
>   			nr = pin_user_pages_fast(addr, nr, gup->gup_flags,
> @@ -161,7 +160,7 @@ static int __gup_test_ioctl(unsigned int cmd,
>   						    pages + i, NULL);
>   			else
>   				nr = get_user_pages(addr, nr, gup->gup_flags,
> -						    pages + i, NULL);
> +						    pages + i);
>   			break;
>   		default:
>   			ret = -EINVAL;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d255964ec331..7f31e0a4adb5 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2474,7 +2474,7 @@ static inline int check_user_page_hwpoison(unsigned long addr)
>   {
>   	int rc, flags = FOLL_HWPOISON | FOLL_WRITE;
>   
> -	rc = get_user_pages(addr, 1, flags, NULL, NULL);
> +	rc = get_user_pages(addr, 1, flags, NULL);
>   	return rc == -EHWPOISON;
>   }
>   

