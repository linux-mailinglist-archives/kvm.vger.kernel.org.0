Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C9D3A1965
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 17:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236082AbhFIP06 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 11:26:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25468 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235397AbhFIP05 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 11:26:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623252303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=45evuK65yCNrp+U7R4sBiNRjQAaI/1aj6wt5ojrV/8Q=;
        b=aq94f6ZFv+knix5qtzjJwY2zfI3OXWQa50hrUxV0obs95ZYMxPJGJ74JxMlGNh3YUKZAMi
        paJbtVl/KMYw4CyyxFeDLFt2IojBzvzklx/iCFtRCKxdXLD9ojzcY8Rbd8uceEi/LRdTl4
        2Idyi6n3o/diYYM8ibPnAU7B88way7s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-Ng2t_B11PT2rvKAo_NxKDQ-1; Wed, 09 Jun 2021 11:25:00 -0400
X-MC-Unique: Ng2t_B11PT2rvKAo_NxKDQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E8EE8015A4;
        Wed,  9 Jun 2021 15:24:59 +0000 (UTC)
Received: from [10.36.112.148] (ovpn-112-148.ams2.redhat.com [10.36.112.148])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3CE0F1656A;
        Wed,  9 Jun 2021 15:24:53 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 4/7] arm: unify header guards
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
 <20210609143712.60933-5-cohuck@redhat.com>
From:   Laurent Vivier <lvivier@redhat.com>
Message-ID: <8399161a-ef26-7d4f-19fb-c54ca40fe6c3@redhat.com>
Date:   Wed, 9 Jun 2021 17:24:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609143712.60933-5-cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/06/2021 16:37, Cornelia Huck wrote:
> The assembler.h files were the only ones not already following
> the convention.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  lib/arm/asm/assembler.h   | 6 +++---
>  lib/arm64/asm/assembler.h | 6 +++---
>  2 files changed, 6 insertions(+), 6 deletions(-)

What about lib/arm/io.h?

I think you can remove the guard from

lib/arm/asm/memory_areas.h

as the other files including directly a header doesn't guard it.

Missing lib/arm/asm/mmu-api.h, lib/arm/asm/mmu.h, lib/arm64/asm/mmu.h

Thanks,
Laurent

> 
> diff --git a/lib/arm/asm/assembler.h b/lib/arm/asm/assembler.h
> index dfd3c51bf6ad..4200252dd14d 100644
> --- a/lib/arm/asm/assembler.h
> +++ b/lib/arm/asm/assembler.h
> @@ -8,8 +8,8 @@
>  #error "Only include this from assembly code"
>  #endif
>  
> -#ifndef __ASM_ASSEMBLER_H
> -#define __ASM_ASSEMBLER_H
> +#ifndef _ASMARM_ASSEMBLER_H_
> +#define _ASMARM_ASSEMBLER_H_
>  
>  /*
>   * dcache_line_size - get the minimum D-cache line size from the CTR register
> @@ -50,4 +50,4 @@
>  	dsb	\domain
>  	.endm
>  
> -#endif	/* __ASM_ASSEMBLER_H */
> +#endif	/* _ASMARM_ASSEMBLER_H_ */
> diff --git a/lib/arm64/asm/assembler.h b/lib/arm64/asm/assembler.h
> index 0a6ab9720bdd..a271e4ceefe6 100644
> --- a/lib/arm64/asm/assembler.h
> +++ b/lib/arm64/asm/assembler.h
> @@ -12,8 +12,8 @@
>  #error "Only include this from assembly code"
>  #endif
>  
> -#ifndef __ASM_ASSEMBLER_H
> -#define __ASM_ASSEMBLER_H
> +#ifndef _ASMARM64_ASSEMBLER_H_
> +#define _ASMARM64_ASSEMBLER_H_
>  
>  /*
>   * raw_dcache_line_size - get the minimum D-cache line size on this CPU
> @@ -51,4 +51,4 @@
>  	dsb	\domain
>  	.endm
>  
> -#endif	/* __ASM_ASSEMBLER_H */
> +#endif	/* _ASMARM64_ASSEMBLER_H_ */
> 

