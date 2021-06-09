Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C873A17B1
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 16:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238103AbhFIOsB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 10:48:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35577 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238093AbhFIOr6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 10:47:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623249962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AAU1zAInzx6+HrQSFp6ko34nkWsZXJD3O7CzG1wYgc4=;
        b=BaLli2xsTL61SXwhaHsYQrEuJvzImpbjwbn0J+PzqEx+KmMEvPmvQeGoiQ44eotfMybBFD
        WW6eQXOervh7oCXp+EXi4GDkdvHCjE4+Q8IwZuYhQG6a40q5YDkPyll+Ii0ONtalXsAtVH
        0mC/0tOi2ZXi5vMNvpKBM/dsuaugGRY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-eH_fzojIOwmrhwiesc6-Wg-1; Wed, 09 Jun 2021 10:46:01 -0400
X-MC-Unique: eH_fzojIOwmrhwiesc6-Wg-1
Received: by mail-wm1-f70.google.com with SMTP id n8-20020a05600c3b88b02901b6e5bcd841so507153wms.9
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 07:46:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=AAU1zAInzx6+HrQSFp6ko34nkWsZXJD3O7CzG1wYgc4=;
        b=Mydl5xpWm00vK8CSDu62yYhWGOVRLhpCmISWpRinWd1EYQd1UxJ5dFOW4jgGkmhQWu
         cQsRGlcGf8Gc4hBZYHiAhwp51Mv/ZVEQSoBrS3gs/YPE8+yRyhqjGmZ4f2EDGBdnofoa
         eSngp02DzQ98YVcFtsTLENFmr4r/fpd8Uz9gUX6v7PsYp1+/EinpxAEViN34ydj01jU2
         Kg5iy4Vm/0F9OCDECkwzKHginOV0HoBW5pCzXl9TkkvZ2eJx2MSM6ATVFbE9WlQKVEAn
         /2Iwt5fPlgRjomcRyRf6fN3GmvrT3cdYwP6BZzi10rdOn/9HKw/K52Zy/NJh/Qw2dElT
         EErA==
X-Gm-Message-State: AOAM533d2Bwc1inCIpakZZi651fAtyRCQqOis4wJUG3S1l7b6Wu9751k
        0XxhFDUSF8Kn5WXfcdXePNsz4+r7JIx9qhHr7Bh3yUJx6FLp3aP1+v8I3kta9/MUAzmVFK6PKC7
        7846qeOKn/PAx
X-Received: by 2002:adf:e907:: with SMTP id f7mr212944wrm.112.1623249960210;
        Wed, 09 Jun 2021 07:46:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw8wWl9iBsdp8NJzL7GA3JhN3F5793eKjJk9isccJu44zxan/zDVm9zk47iipTv1xUXcvDIKg==
X-Received: by 2002:adf:e907:: with SMTP id f7mr212915wrm.112.1623249959932;
        Wed, 09 Jun 2021 07:45:59 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c611d.dip0.t-ipconnect.de. [91.12.97.29])
        by smtp.gmail.com with ESMTPSA id u15sm6321326wmq.48.2021.06.09.07.45.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 07:45:59 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 2/7] lib: unify header guards
To:     Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        kvmarm@lists.cs.columbia.edu, kvm-ppc@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20210609143712.60933-1-cohuck@redhat.com>
 <20210609143712.60933-3-cohuck@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <42e29a14-3870-5289-9067-5c9c1284e7dd@redhat.com>
Date:   Wed, 9 Jun 2021 16:45:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609143712.60933-3-cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09.06.21 16:37, Cornelia Huck wrote:
> Standardize header guards to _LIB_HEADER_H_.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>   lib/alloc_page.h       | 4 ++--
>   lib/libcflat.h         | 4 ++--
>   lib/list.h             | 4 ++--
>   lib/pci-edu.h          | 4 ++--
>   lib/pci-host-generic.h | 4 ++--
>   lib/setjmp.h           | 4 ++--
>   lib/string.h           | 6 +++---
>   lib/vmalloc.h          | 4 ++--
>   8 files changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/lib/alloc_page.h b/lib/alloc_page.h
> index 1af1419d49b6..eed2ba06eeaf 100644
> --- a/lib/alloc_page.h
> +++ b/lib/alloc_page.h
> @@ -5,8 +5,8 @@
>    * with byte granularity.
>    */
>   
> -#ifndef ALLOC_PAGE_H
> -#define ALLOC_PAGE_H 1
> +#ifndef _ALLOC_PAGE_H_
> +#define _ALLOC_PAGE_H_
>   
>   #include <stdbool.h>
>   #include <asm/memory_areas.h>
> diff --git a/lib/libcflat.h b/lib/libcflat.h
> index 460a1234ea6a..f40b431d1550 100644
> --- a/lib/libcflat.h
> +++ b/lib/libcflat.h
> @@ -17,8 +17,8 @@
>    * Authors: Hollis Blanchard <hollisb@us.ibm.com>
>    */
>   
> -#ifndef __LIBCFLAT_H
> -#define __LIBCFLAT_H
> +#ifndef _LIBCFLAT_H_
> +#define _LIBCFLAT_H_
>   
>   #ifndef __ASSEMBLY__
>   
> diff --git a/lib/list.h b/lib/list.h
> index 7f9717ef6258..ed3e52b40075 100644
> --- a/lib/list.h
> +++ b/lib/list.h
> @@ -1,5 +1,5 @@
> -#ifndef LIST_H
> -#define LIST_H
> +#ifndef _LIST_H_
> +#define _LIST_H_
>   
>   #include <stdbool.h>
>   
> diff --git a/lib/pci-edu.h b/lib/pci-edu.h
> index 44b4ba168768..9db94aec0bc7 100644
> --- a/lib/pci-edu.h
> +++ b/lib/pci-edu.h
> @@ -12,8 +12,8 @@
>    * Edu device is a virtualized device in QEMU. Please refer to
>    * docs/specs/edu.txt in QEMU repository for EDU device manual.
>    */
> -#ifndef __PCI_EDU_H__
> -#define __PCI_EDU_H__
> +#ifndef _PCI_EDU_H_
> +#define _PCI_EDU_H_
>   
>   #include "pci.h"
>   #include "asm/io.h"
> diff --git a/lib/pci-host-generic.h b/lib/pci-host-generic.h
> index 0ffe6380ec8f..3020ee22c837 100644
> --- a/lib/pci-host-generic.h
> +++ b/lib/pci-host-generic.h
> @@ -1,5 +1,5 @@
> -#ifndef PCI_HOST_GENERIC_H
> -#define PCI_HOST_GENERIC_H
> +#ifndef _PCI_HOST_GENERIC_H_
> +#define _PCI_HOST_GENERIC_H_
>   /*
>    * PCI host bridge supporting structures and constants
>    *
> diff --git a/lib/setjmp.h b/lib/setjmp.h
> index 2c56b4c68aaa..6afdf665681a 100644
> --- a/lib/setjmp.h
> +++ b/lib/setjmp.h
> @@ -4,8 +4,8 @@
>    * This code is free software; you can redistribute it and/or modify it
>    * under the terms of the GNU Library General Public License version 2.
>    */
> -#ifndef LIBCFLAT_SETJMP_H
> -#define LIBCFLAT_SETJMP_H 1
> +#ifndef _LIBCFLAT_SETJMP_H_
> +#define _LIBCFLAT_SETJMP_H_
>   
>   typedef struct jmp_buf_tag {
>   	long int regs[8];
> diff --git a/lib/string.h b/lib/string.h
> index e1febfed7fb2..b07763eaef10 100644
> --- a/lib/string.h
> +++ b/lib/string.h
> @@ -4,8 +4,8 @@
>    * This code is free software; you can redistribute it and/or modify it
>    * under the terms of the GNU Library General Public License version 2.
>    */
> -#ifndef __STRING_H
> -#define __STRING_H
> +#ifndef _STRING_H_
> +#define _STRING_H_
>   
>   extern size_t strlen(const char *buf);
>   extern size_t strnlen(const char *buf, size_t maxlen);
> @@ -23,4 +23,4 @@ extern int memcmp(const void *s1, const void *s2, size_t n);
>   extern void *memmove(void *dest, const void *src, size_t n);
>   extern void *memchr(const void *s, int c, size_t n);
>   
> -#endif /* _STRING_H */
> +#endif /* _STRING_H_ */
> diff --git a/lib/vmalloc.h b/lib/vmalloc.h
> index 8b158f591d75..346f94f198c5 100644
> --- a/lib/vmalloc.h
> +++ b/lib/vmalloc.h
> @@ -1,5 +1,5 @@
> -#ifndef VMALLOC_H
> -#define VMALLOC_H 1
> +#ifndef _VMALLOC_H_
> +#define _VMALLOC_H_
>   
>   #include <asm/page.h>
>   
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

