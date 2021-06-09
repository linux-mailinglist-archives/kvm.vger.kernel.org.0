Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912893A18ED
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 17:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbhFIPRZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 11:17:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22041 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229517AbhFIPRV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 11:17:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623251726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YoyJlzd3DZII0wVHUo0HEeGrTKL6o7G0YweYY2FMpM8=;
        b=dx1mKvQZphQ6j16UXQyaBGlVBeBespToOw+TEurS/jXlBlNkerIu96DdtR4S/E7xilwPK1
        KJo8aCZ7SkLY64gmd2QCqvbmNHkIhxYA+gcBId9Le1SFEiaIaKfXgeFvcyJw3icz6VIyLf
        r/0XrY1Th9AnIunOB3KrSYHvkpH4g3U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-_fT5BZ2gPw-qzAPUfJvDUg-1; Wed, 09 Jun 2021 11:15:25 -0400
X-MC-Unique: _fT5BZ2gPw-qzAPUfJvDUg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 50962802690;
        Wed,  9 Jun 2021 15:15:24 +0000 (UTC)
Received: from [10.36.112.148] (ovpn-112-148.ams2.redhat.com [10.36.112.148])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E66B560C04;
        Wed,  9 Jun 2021 15:15:18 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 3/7] asm-generic: unify header guards
To:     Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        kvmarm@lists.cs.columbia.edu, kvm-ppc@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20210609143712.60933-1-cohuck@redhat.com>
 <20210609143712.60933-4-cohuck@redhat.com>
From:   Laurent Vivier <lvivier@redhat.com>
Message-ID: <c58b6fce-b7a5-9aec-dfe4-fec2ad7f6f50@redhat.com>
Date:   Wed, 9 Jun 2021 17:15:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609143712.60933-4-cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/06/2021 16:37, Cornelia Huck wrote:
> Standardize header guards to _ASM_GENERIC_HEADER_H_.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  lib/asm-generic/atomic.h          | 4 ++--
>  lib/asm-generic/barrier.h         | 6 +++---
>  lib/asm-generic/memory_areas.h    | 4 ++--
>  lib/asm-generic/pci-host-bridge.h | 4 ++--
>  4 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/lib/asm-generic/atomic.h b/lib/asm-generic/atomic.h
> index 26b645a7cc18..b09ce95053e7 100644
> --- a/lib/asm-generic/atomic.h
> +++ b/lib/asm-generic/atomic.h
> @@ -1,5 +1,5 @@
> -#ifndef __ASM_GENERIC_ATOMIC_H__
> -#define __ASM_GENERIC_ATOMIC_H__
> +#ifndef _ASM_GENERIC_ATOMIC_H_
> +#define _ASM_GENERIC_ATOMIC_H_
>  
>  /* From QEMU include/qemu/atomic.h */
>  #define atomic_fetch_inc(ptr)  __sync_fetch_and_add(ptr, 1)
> diff --git a/lib/asm-generic/barrier.h b/lib/asm-generic/barrier.h
> index 6a990ff8d5a5..5499a5664d4d 100644
> --- a/lib/asm-generic/barrier.h
> +++ b/lib/asm-generic/barrier.h
> @@ -1,5 +1,5 @@
> -#ifndef _ASM_BARRIER_H_
> -#define _ASM_BARRIER_H_
> +#ifndef _ASM_GENERIC_BARRIER_H_
> +#define _ASM_GENERIC_BARRIER_H_
>  /*
>   * asm-generic/barrier.h
>   *
> @@ -32,4 +32,4 @@
>  #define cpu_relax()	asm volatile ("":::"memory")
>  #endif
>  
> -#endif /* _ASM_BARRIER_H_ */
> +#endif /* _ASM_GENERIC_BARRIER_H_ */
> diff --git a/lib/asm-generic/memory_areas.h b/lib/asm-generic/memory_areas.h
> index 3074afe23393..c86db255ecee 100644
> --- a/lib/asm-generic/memory_areas.h
> +++ b/lib/asm-generic/memory_areas.h
> @@ -1,5 +1,5 @@
> -#ifndef __ASM_GENERIC_MEMORY_AREAS_H__
> -#define __ASM_GENERIC_MEMORY_AREAS_H__
> +#ifndef _ASM_GENERIC_MEMORY_AREAS_H_
> +#define _ASM_GENERIC_MEMORY_AREAS_H_
>  
>  #define AREA_NORMAL_PFN 0
>  #define AREA_NORMAL_NUMBER 0
> diff --git a/lib/asm-generic/pci-host-bridge.h b/lib/asm-generic/pci-host-bridge.h
> index 9e91499b9446..174ff341dd0d 100644
> --- a/lib/asm-generic/pci-host-bridge.h
> +++ b/lib/asm-generic/pci-host-bridge.h
> @@ -1,5 +1,5 @@
> -#ifndef _ASM_PCI_HOST_BRIDGE_H_
> -#define _ASM_PCI_HOST_BRIDGE_H_
> +#ifndef _ASM_GENERIC_PCI_HOST_BRIDGE_H_
> +#define _ASM_GENERIC_PCI_HOST_BRIDGE_H_
>  /*
>   * Copyright (C) 2016, Red Hat Inc, Alexander Gordeev <agordeev@redhat.com>
>   *
> 

Reviewed-by: Laurent Vivier <lvivier@redhat.com>

