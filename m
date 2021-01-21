Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC862FDEF6
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 02:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392420AbhAUBnN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 20:43:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392512AbhAUBYm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 20:24:42 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E530C0613ED
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 17:24:01 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id o17so262157lfg.4
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 17:24:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DSUnYV+9bGnDv6yNhky6g8SzcPwuYg7j13sT/BEDdTM=;
        b=Dcn0jBglxGRD11rFu/GjLjr6Nfdo8D1umvyjjGkZVucnX+55c4wrpQSAYOjq+UB3Fr
         SrOY4+BUk5hmXeOaTvICbeYzju82kNL5fGkVNKXgdfxaJYChynoxAfNku1Kal9ryEiBI
         xSDzYzFkN6QKt24ILxGz2N+v5Sjkm/UxdzHw5LPYwAA+/eV6bXCEu9+a4iwWFgKP7Pmm
         pjUgQpwikxurlgLXHMLDgmLErz16l878u6P+7rEwMW+rUD/RS665pGBpW5SXZN/bIYli
         8lr4AW0fIn/PeW8dVt2oxAfmQe7vDxZSxUQ8qSODUtku924oWpoFo+fS7KL97nFaYVVv
         t3DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DSUnYV+9bGnDv6yNhky6g8SzcPwuYg7j13sT/BEDdTM=;
        b=JNJBj3U83gXuuZvj3imCvSZ1cuXiuNvWGPoWN6x/QDj5lKwy/acfV3NaJjbigO7hs3
         5sTCSV2Ko3n25d4RBoVKfcZRbds/Zyy+HiCa52JBvQxUFtsv4HrKLjZcAFgb8HsS8rVZ
         DBDIUQMfQD7+/pWKueuKnpTna+pv4WbjfxAxP4T9X4w6sHShPTtcgiJFz5KB4BGuMiKJ
         r8LjAu9Fo6df2KUE6xD9AavsO9nxUz6ZaK2JTC6BwYqI9qrtt8Z3UV72N3qpBGlAG5HC
         k9BpW570jPmPAdyoI4JXPF1DVWcm9Ge26ngGuTmU938+XpkSdtun+y4ycubrcNGziDa9
         LG7w==
X-Gm-Message-State: AOAM532AGdzxLfCAv/UE9ll4dGa70dTc1YZSR/0vxp6CJnQau2+ZPmlJ
        r72Gps24VgR07hYPK/s34smJs8E3I+J7AsWNglz8Cg==
X-Google-Smtp-Source: ABdhPJyyPFQ+InDb162SOAxhrxzyYW+ZTj5MC1NnHhnMeDXQ7g6P38rpknwqGMz8D+gMelqyejxXZsCPt5/oAUh7rXY=
X-Received: by 2002:a19:8b8b:: with SMTP id n133mr5381297lfd.278.1611192239644;
 Wed, 20 Jan 2021 17:23:59 -0800 (PST)
MIME-Version: 1.0
References: <20210115123730.381612-1-imbrenda@linux.ibm.com> <20210115123730.381612-5-imbrenda@linux.ibm.com>
In-Reply-To: <20210115123730.381612-5-imbrenda@linux.ibm.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 20 Jan 2021 17:23:33 -0800
Message-ID: <CALzav=ehg9zWe2POxKg0FDciyfT7QsWRDDNqZ7_WRqtdWMEtaA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 04/11] lib/asm: Fix definitions of
 memory areas
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm list <kvm@vger.kernel.org>, frankja@linux.ibm.com,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, cohuck@redhat.com,
        Laurent Vivier <lvivier@redhat.com>, nadav.amit@gmail.com,
        krish.sadhukhan@oracle.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Claudio,

On Fri, Jan 15, 2021 at 8:07 AM Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:
>
> Fix the definitions of the memory areas.

The test x86/smat.flat started falling for me at this commit. I'm
testing on Linux 5.7.17.

Here are the logs:

timeout -k 1s --foreground 90s /usr/bin/qemu-system-x86_64 --no-reboot
-nodefaults -device pc-testdev -device
isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc none -serial stdio -device
pci-testdev -machine accel=kvm -kernel x86/smap.flat -smp 1 -cpu host
# -initrd /tmp/tmp.s4WKgsHkOh
enabling apic
paging enabled
cr0 = 80010011
cr3 = 1007000
cr4 = 20
testing without INVLPG
PASS: write to supervisor page
PASS: read from user page with AC=1
PASS: read from user page with AC=0
FAIL: write to user page with AC=1
FAIL: read from user page with AC=0
FAIL: write to user stack with AC=1
FAIL: write to user stack with AC=0
Unhandled exception 6 #UD at ip 0000000001800003
error_code=0000      rflags=00010082      cs=00000008
rax=000000000000000a rcx=00000000000003fd rdx=00000000000003f8
rbx=0000000000000000
rbp=0000000000517700 rsi=0000000000416422 rdi=0000000000000000
 r8=0000000000416422  r9=00000000000003f8 r10=000000000000000d
r11=000ffffffffff000
r12=0000000000000000 r13=0000000001418700 r14=0000000000000000
r15=0000000000000000
cr0=0000000080010011 cr2=00000000015176d8 cr3=0000000001007000
cr4=0000000000200020
cr8=0000000000000000
STACK: @1800003 400368
b'0x0000000001800003: ?? ??:0'



>
> Bring the headers in line with the rest of the asm headers, by having the
> appropriate #ifdef _ASM$ARCH_ guarding the headers.
>
> Fixes: d74708246bd9 ("lib/asm: Add definitions of memory areas")
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
>  lib/asm-generic/memory_areas.h |  9 ++++-----
>  lib/arm/asm/memory_areas.h     | 11 +++--------
>  lib/arm64/asm/memory_areas.h   | 11 +++--------
>  lib/powerpc/asm/memory_areas.h | 11 +++--------
>  lib/ppc64/asm/memory_areas.h   | 11 +++--------
>  lib/s390x/asm/memory_areas.h   | 13 ++++++-------
>  lib/x86/asm/memory_areas.h     | 27 ++++++++++++++++-----------
>  lib/alloc_page.h               |  3 +++
>  lib/alloc_page.c               |  4 +---
>  9 files changed, 42 insertions(+), 58 deletions(-)
>
> diff --git a/lib/asm-generic/memory_areas.h b/lib/asm-generic/memory_areas.h
> index 927baa7..3074afe 100644
> --- a/lib/asm-generic/memory_areas.h
> +++ b/lib/asm-generic/memory_areas.h
> @@ -1,11 +1,10 @@
> -#ifndef MEMORY_AREAS_H
> -#define MEMORY_AREAS_H
> +#ifndef __ASM_GENERIC_MEMORY_AREAS_H__
> +#define __ASM_GENERIC_MEMORY_AREAS_H__
>
>  #define AREA_NORMAL_PFN 0
>  #define AREA_NORMAL_NUMBER 0
> -#define AREA_NORMAL 1
> +#define AREA_NORMAL (1 << AREA_NORMAL_NUMBER)
>
> -#define AREA_ANY -1
> -#define AREA_ANY_NUMBER 0xff
> +#define MAX_AREAS 1
>
>  #endif
> diff --git a/lib/arm/asm/memory_areas.h b/lib/arm/asm/memory_areas.h
> index 927baa7..c723310 100644
> --- a/lib/arm/asm/memory_areas.h
> +++ b/lib/arm/asm/memory_areas.h
> @@ -1,11 +1,6 @@
> -#ifndef MEMORY_AREAS_H
> -#define MEMORY_AREAS_H
> +#ifndef _ASMARM_MEMORY_AREAS_H_
> +#define _ASMARM_MEMORY_AREAS_H_
>
> -#define AREA_NORMAL_PFN 0
> -#define AREA_NORMAL_NUMBER 0
> -#define AREA_NORMAL 1
> -
> -#define AREA_ANY -1
> -#define AREA_ANY_NUMBER 0xff
> +#include <asm-generic/memory_areas.h>
>
>  #endif
> diff --git a/lib/arm64/asm/memory_areas.h b/lib/arm64/asm/memory_areas.h
> index 927baa7..18e8ca8 100644
> --- a/lib/arm64/asm/memory_areas.h
> +++ b/lib/arm64/asm/memory_areas.h
> @@ -1,11 +1,6 @@
> -#ifndef MEMORY_AREAS_H
> -#define MEMORY_AREAS_H
> +#ifndef _ASMARM64_MEMORY_AREAS_H_
> +#define _ASMARM64_MEMORY_AREAS_H_
>
> -#define AREA_NORMAL_PFN 0
> -#define AREA_NORMAL_NUMBER 0
> -#define AREA_NORMAL 1
> -
> -#define AREA_ANY -1
> -#define AREA_ANY_NUMBER 0xff
> +#include <asm-generic/memory_areas.h>
>
>  #endif
> diff --git a/lib/powerpc/asm/memory_areas.h b/lib/powerpc/asm/memory_areas.h
> index 927baa7..76d1738 100644
> --- a/lib/powerpc/asm/memory_areas.h
> +++ b/lib/powerpc/asm/memory_areas.h
> @@ -1,11 +1,6 @@
> -#ifndef MEMORY_AREAS_H
> -#define MEMORY_AREAS_H
> +#ifndef _ASMPOWERPC_MEMORY_AREAS_H_
> +#define _ASMPOWERPC_MEMORY_AREAS_H_
>
> -#define AREA_NORMAL_PFN 0
> -#define AREA_NORMAL_NUMBER 0
> -#define AREA_NORMAL 1
> -
> -#define AREA_ANY -1
> -#define AREA_ANY_NUMBER 0xff
> +#include <asm-generic/memory_areas.h>
>
>  #endif
> diff --git a/lib/ppc64/asm/memory_areas.h b/lib/ppc64/asm/memory_areas.h
> index 927baa7..b9fd46b 100644
> --- a/lib/ppc64/asm/memory_areas.h
> +++ b/lib/ppc64/asm/memory_areas.h
> @@ -1,11 +1,6 @@
> -#ifndef MEMORY_AREAS_H
> -#define MEMORY_AREAS_H
> +#ifndef _ASMPPC64_MEMORY_AREAS_H_
> +#define _ASMPPC64_MEMORY_AREAS_H_
>
> -#define AREA_NORMAL_PFN 0
> -#define AREA_NORMAL_NUMBER 0
> -#define AREA_NORMAL 1
> -
> -#define AREA_ANY -1
> -#define AREA_ANY_NUMBER 0xff
> +#include <asm-generic/memory_areas.h>
>
>  #endif
> diff --git a/lib/s390x/asm/memory_areas.h b/lib/s390x/asm/memory_areas.h
> index 4856a27..827bfb3 100644
> --- a/lib/s390x/asm/memory_areas.h
> +++ b/lib/s390x/asm/memory_areas.h
> @@ -1,16 +1,15 @@
> -#ifndef MEMORY_AREAS_H
> -#define MEMORY_AREAS_H
> +#ifndef _ASMS390X_MEMORY_AREAS_H_
> +#define _ASMS390X_MEMORY_AREAS_H_
>
> -#define AREA_NORMAL_PFN BIT(31-12)
> +#define AREA_NORMAL_PFN (1 << 19)
>  #define AREA_NORMAL_NUMBER 0
> -#define AREA_NORMAL 1
> +#define AREA_NORMAL (1 << AREA_NORMAL_NUMBER)
>
>  #define AREA_LOW_PFN 0
>  #define AREA_LOW_NUMBER 1
> -#define AREA_LOW 2
> +#define AREA_LOW (1 << AREA_LOW_NUMBER)
>
> -#define AREA_ANY -1
> -#define AREA_ANY_NUMBER 0xff
> +#define MAX_AREAS 2
>
>  #define AREA_DMA31 AREA_LOW
>
> diff --git a/lib/x86/asm/memory_areas.h b/lib/x86/asm/memory_areas.h
> index 952f5bd..e84016f 100644
> --- a/lib/x86/asm/memory_areas.h
> +++ b/lib/x86/asm/memory_areas.h
> @@ -1,21 +1,26 @@
> -#ifndef MEMORY_AREAS_H
> -#define MEMORY_AREAS_H
> +#ifndef _ASM_X86_MEMORY_AREAS_H_
> +#define _ASM_X86_MEMORY_AREAS_H_
>
>  #define AREA_NORMAL_PFN BIT(36-12)
>  #define AREA_NORMAL_NUMBER 0
> -#define AREA_NORMAL 1
> +#define AREA_NORMAL (1 << AREA_NORMAL_NUMBER)
>
> -#define AREA_PAE_HIGH_PFN BIT(32-12)
> -#define AREA_PAE_HIGH_NUMBER 1
> -#define AREA_PAE_HIGH 2
> +#define AREA_HIGH_PFN BIT(32-12)
> +#define AREA_HIGH_NUMBER 1
> +#define AREA_HIGH (1 << AREA_HIGH_NUMBER)
>
> -#define AREA_LOW_PFN 0
> +#define AREA_LOW_PFN BIT(24-12)
>  #define AREA_LOW_NUMBER 2
> -#define AREA_LOW 4
> +#define AREA_LOW (1 << AREA_LOW_NUMBER)
>
> -#define AREA_PAE (AREA_PAE | AREA_LOW)
> +#define AREA_LOWEST_PFN 0
> +#define AREA_LOWEST_NUMBER 3
> +#define AREA_LOWEST (1 << AREA_LOWEST_NUMBER)
>
> -#define AREA_ANY -1
> -#define AREA_ANY_NUMBER 0xff
> +#define MAX_AREAS 4
> +
> +#define AREA_DMA24 AREA_LOWEST
> +#define AREA_DMA32 (AREA_LOWEST | AREA_LOW)
> +#define AREA_PAE36 (AREA_LOWEST | AREA_LOW | AREA_HIGH)
>
>  #endif
> diff --git a/lib/alloc_page.h b/lib/alloc_page.h
> index 816ff5d..b6aace5 100644
> --- a/lib/alloc_page.h
> +++ b/lib/alloc_page.h
> @@ -10,6 +10,9 @@
>
>  #include <asm/memory_areas.h>
>
> +#define AREA_ANY -1
> +#define AREA_ANY_NUMBER 0xff
> +
>  /* Returns true if the page allocator has been initialized */
>  bool page_alloc_initialized(void);
>
> diff --git a/lib/alloc_page.c b/lib/alloc_page.c
> index 685ab1e..ed0ff02 100644
> --- a/lib/alloc_page.c
> +++ b/lib/alloc_page.c
> @@ -19,8 +19,6 @@
>  #define NLISTS ((BITS_PER_LONG) - (PAGE_SHIFT))
>  #define PFN(x) ((uintptr_t)(x) >> PAGE_SHIFT)
>
> -#define MAX_AREAS      6
> -
>  #define ORDER_MASK     0x3f
>  #define ALLOC_MASK     0x40
>  #define SPECIAL_MASK   0x80
> @@ -509,7 +507,7 @@ void page_alloc_init_area(u8 n, uintptr_t base_pfn, uintptr_t top_pfn)
>                 return;
>         }
>  #ifdef AREA_HIGH_PFN
> -       __page_alloc_init_area(AREA_HIGH_NUMBER, AREA_HIGH_PFN), base_pfn, &top_pfn);
> +       __page_alloc_init_area(AREA_HIGH_NUMBER, AREA_HIGH_PFN, base_pfn, &top_pfn);
>  #endif
>         __page_alloc_init_area(AREA_NORMAL_NUMBER, AREA_NORMAL_PFN, base_pfn, &top_pfn);
>  #ifdef AREA_LOW_PFN
> --
> 2.26.2
>
