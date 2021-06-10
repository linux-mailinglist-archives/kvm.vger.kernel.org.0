Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7F73A2E29
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 16:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhFJObM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 10:31:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23292 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230153AbhFJObM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 10:31:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623335355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t1hQMrijpRgHftZ417h7zHkFgo5qZsUpu+n36cFGj2Y=;
        b=fhpA6MqeEFN1H1bCjuCo9M1D8/KR/fI4hwewUqV6BK2qfsrDFimxlnk06jkvVE2o973Lkh
        uENoVBwN5M3uhP+xl+4AcUaPqno4nBvUIS6KvPngdNoiW1Ee/ikPgXaYKwn1auYbg0tpn7
        hA/X1Y5/oBXk/oD6vLUeYfqT/3CC20M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-OpRGnpxMP-mfn_AENiZ1wA-1; Thu, 10 Jun 2021 10:29:14 -0400
X-MC-Unique: OpRGnpxMP-mfn_AENiZ1wA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F8CCCC625
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 14:29:13 +0000 (UTC)
Received: from [10.36.114.17] (ovpn-114-17.ams2.redhat.com [10.36.114.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E9B360C04;
        Thu, 10 Jun 2021 14:29:12 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 1/2] header guards: clean up some
 stragglers
To:     Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20210610135937.94375-1-cohuck@redhat.com>
 <20210610135937.94375-2-cohuck@redhat.com>
From:   Laurent Vivier <lvivier@redhat.com>
Message-ID: <a172c7d1-4de7-619f-95ee-c8d507f7b812@redhat.com>
Date:   Thu, 10 Jun 2021 16:29:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210610135937.94375-2-cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/06/2021 15:59, Cornelia Huck wrote:
> Some headers had been missed during the initial header guard
> standardization.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  configure             | 4 ++--
>  lib/arm/asm/mmu-api.h | 4 ++--
>  lib/arm/asm/mmu.h     | 6 +++---
>  lib/arm64/asm/mmu.h   | 6 +++---
>  lib/pci.h             | 6 +++---
>  5 files changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/configure b/configure
> index 4ad5a4bcd782..b8442d61fb60 100755
> --- a/configure
> +++ b/configure
> @@ -332,8 +332,8 @@ if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
>  fi
>  
>  cat <<EOF > lib/config.h
> -#ifndef CONFIG_H
> -#define CONFIG_H 1
> +#ifndef _CONFIG_H_
> +#define _CONFIG_H_
>  /*
>   * Generated file. DO NOT MODIFY.
>   *
> diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
> index 05fc12b5afb8..3d77cbfd8b24 100644
> --- a/lib/arm/asm/mmu-api.h
> +++ b/lib/arm/asm/mmu-api.h
> @@ -1,5 +1,5 @@
> -#ifndef __ASMARM_MMU_API_H_
> -#define __ASMARM_MMU_API_H_
> +#ifndef _ASMARM_MMU_API_H_
> +#define _ASMARM_MMU_API_H_
>  
>  #include <asm/page.h>
>  #include <stdbool.h>
> diff --git a/lib/arm/asm/mmu.h b/lib/arm/asm/mmu.h
> index 94e70f0a84bf..b24b97e554e2 100644
> --- a/lib/arm/asm/mmu.h
> +++ b/lib/arm/asm/mmu.h
> @@ -1,5 +1,5 @@
> -#ifndef __ASMARM_MMU_H_
> -#define __ASMARM_MMU_H_
> +#ifndef _ASMARM_MMU_H_
> +#define _ASMARM_MMU_H_
>  /*
>   * Copyright (C) 2014, Red Hat Inc, Andrew Jones <drjones@redhat.com>
>   *
> @@ -53,4 +53,4 @@ static inline void flush_dcache_addr(unsigned long vaddr)
>  
>  #include <asm/mmu-api.h>
>  
> -#endif /* __ASMARM_MMU_H_ */
> +#endif /* _ASMARM_MMU_H_ */
> diff --git a/lib/arm64/asm/mmu.h b/lib/arm64/asm/mmu.h
> index 72371b2d9fe3..5c27edb24d2e 100644
> --- a/lib/arm64/asm/mmu.h
> +++ b/lib/arm64/asm/mmu.h
> @@ -1,5 +1,5 @@
> -#ifndef __ASMARM64_MMU_H_
> -#define __ASMARM64_MMU_H_
> +#ifndef _ASMARM64_MMU_H_
> +#define _ASMARM64_MMU_H_
>  /*
>   * Copyright (C) 2014, Red Hat Inc, Andrew Jones <drjones@redhat.com>
>   *
> @@ -35,4 +35,4 @@ static inline void flush_dcache_addr(unsigned long vaddr)
>  
>  #include <asm/mmu-api.h>
>  
> -#endif /* __ASMARM64_MMU_H_ */
> +#endif /* _ASMARM64_MMU_H_ */
> diff --git a/lib/pci.h b/lib/pci.h
> index 689f03ca7647..e201711dfe18 100644
> --- a/lib/pci.h
> +++ b/lib/pci.h
> @@ -1,5 +1,5 @@
> -#ifndef PCI_H
> -#define PCI_H
> +#ifndef _PCI_H_
> +#define _PCI_H_
>  /*
>   * API for scanning a PCI bus for a given device, as well to access
>   * BAR registers.
> @@ -102,4 +102,4 @@ struct pci_test_dev_hdr {
>  
>  #define  PCI_HEADER_TYPE_MASK		0x7f
>  
> -#endif /* PCI_H */
> +#endif /* _PCI_H_ */
> 

Reviewed-by: Laurent Vivier <lvivier@redhat.com>

