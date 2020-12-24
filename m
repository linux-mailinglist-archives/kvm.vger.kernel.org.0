Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 193542E2885
	for <lists+kvm@lfdr.de>; Thu, 24 Dec 2020 19:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbgLXSRx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Dec 2020 13:17:53 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44364 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727184AbgLXSRx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Dec 2020 13:17:53 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BOI8jho109347;
        Thu, 24 Dec 2020 18:17:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=g1lod/25dIDnq8LSppFwKzQfifCZwNasGjcWyimSDgU=;
 b=MCj66WwspsGUGKqRR2NPxvkm5qtsmcZxxK0v25VwwkSQdBILgusCk200u8z08PlfLQm7
 v1tR5mvecNqrYB2Qwl0qd1y02/V8/018c/cmUEJ41T8juIfEJNOggCwyRy/9I/FV7ryF
 a8B3p9wy/mWPwMQrxeoGdXm//gwi73YkgpSPTMpBlKbdffpJNfzaLfysq/Qj7nz1KGxj
 fu9pajLBpjDwSAS3nWPH7u4hGoN0XNl6qU6tGhR+XoULk6lp/JnPcxyd+yWmEQFHB+H5
 /T30L3DvTYw+xTM1dWCyyHSgBX8Y74cS/LjKL1tRvkvW3ZjVGhap+CGDV1tnig6GtTnF kg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 35ku8dxjf7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Dec 2020 18:17:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BOIBjtg019749;
        Thu, 24 Dec 2020 18:17:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 35k0eb8uw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Dec 2020 18:17:03 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BOIH2Bd006632;
        Thu, 24 Dec 2020 18:17:02 GMT
Received: from localhost.localdomain (/10.159.237.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Dec 2020 10:17:01 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [kvm-unit-tests PATCH v1 04/12] lib/asm: Fix definitions of
 memory areas
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        pbonzini@redhat.com, cohuck@redhat.com, lvivier@redhat.com,
        nadav.amit@gmail.com
References: <20201216201200.255172-1-imbrenda@linux.ibm.com>
 <20201216201200.255172-5-imbrenda@linux.ibm.com>
Message-ID: <e4cc5a3f-9d8e-c574-9854-db5af169b237@oracle.com>
Date:   Thu, 24 Dec 2020 10:17:00 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201216201200.255172-5-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9845 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012240115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9845 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 phishscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 spamscore=0 clxscore=1011
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012240115
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/16/20 12:11 PM, Claudio Imbrenda wrote:
> Fix the definitions of the memory areas.
>
> Bring the headers in line with the rest of the asm headers, by having the
> appropriate #ifdef _ASM$ARCH_ guarding the headers.


Should we mention MAX_AREAS that the patch adds in each arch-specific 
header ?

> Fixes: d74708246bd9 ("lib/asm: Add definitions of memory areas")
>
> Signed-off-by: Claudio Imbrenda<imbrenda@linux.ibm.com>
> ---
>   lib/asm-generic/memory_areas.h |  9 ++++-----
>   lib/arm/asm/memory_areas.h     | 11 +++--------
>   lib/arm64/asm/memory_areas.h   | 11 +++--------
>   lib/powerpc/asm/memory_areas.h | 11 +++--------
>   lib/ppc64/asm/memory_areas.h   | 11 +++--------
>   lib/s390x/asm/memory_areas.h   | 13 ++++++-------
>   lib/x86/asm/memory_areas.h     | 27 ++++++++++++++++-----------
>   lib/alloc_page.h               |  3 +++
>   lib/alloc_page.c               |  4 +---
>   9 files changed, 42 insertions(+), 58 deletions(-)
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
>   #define AREA_NORMAL_PFN 0
>   #define AREA_NORMAL_NUMBER 0
> -#define AREA_NORMAL 1
> +#define AREA_NORMAL (1 << AREA_NORMAL_NUMBER)
>   
> -#define AREA_ANY -1
> -#define AREA_ANY_NUMBER 0xff
> +#define MAX_AREAS 1
>   
>   #endif
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
>   #endif
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
>   #endif
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
>   #endif
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
>   #endif
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
>   #define AREA_NORMAL_NUMBER 0
> -#define AREA_NORMAL 1
> +#define AREA_NORMAL (1 << AREA_NORMAL_NUMBER)
>   
>   #define AREA_LOW_PFN 0
>   #define AREA_LOW_NUMBER 1
> -#define AREA_LOW 2
> +#define AREA_LOW (1 << AREA_LOW_NUMBER)
>   
> -#define AREA_ANY -1
> -#define AREA_ANY_NUMBER 0xff
> +#define MAX_AREAS 2
>   
>   #define AREA_DMA31 AREA_LOW
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
>   #define AREA_NORMAL_PFN BIT(36-12)
>   #define AREA_NORMAL_NUMBER 0
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
>   #define AREA_LOW_NUMBER 2
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
>   #endif
> diff --git a/lib/alloc_page.h b/lib/alloc_page.h
> index 816ff5d..b6aace5 100644
> --- a/lib/alloc_page.h
> +++ b/lib/alloc_page.h
> @@ -10,6 +10,9 @@
>   
>   #include <asm/memory_areas.h>
>   
> +#define AREA_ANY -1
> +#define AREA_ANY_NUMBER 0xff
> +
>   /* Returns true if the page allocator has been initialized */
>   bool page_alloc_initialized(void);
>   
> diff --git a/lib/alloc_page.c b/lib/alloc_page.c
> index 685ab1e..ed0ff02 100644
> --- a/lib/alloc_page.c
> +++ b/lib/alloc_page.c
> @@ -19,8 +19,6 @@
>   #define NLISTS ((BITS_PER_LONG) - (PAGE_SHIFT))
>   #define PFN(x) ((uintptr_t)(x) >> PAGE_SHIFT)
>   
> -#define MAX_AREAS	6
> -
>   #define ORDER_MASK	0x3f
>   #define ALLOC_MASK	0x40
>   #define SPECIAL_MASK	0x80
> @@ -509,7 +507,7 @@ void page_alloc_init_area(u8 n, uintptr_t base_pfn, uintptr_t top_pfn)
>   		return;
>   	}
>   #ifdef AREA_HIGH_PFN
> -	__page_alloc_init_area(AREA_HIGH_NUMBER, AREA_HIGH_PFN), base_pfn, &top_pfn);
> +	__page_alloc_init_area(AREA_HIGH_NUMBER, AREA_HIGH_PFN, base_pfn, &top_pfn);


Surprising that the compiler didn't complain !

>   #endif
>   	__page_alloc_init_area(AREA_NORMAL_NUMBER, AREA_NORMAL_PFN, base_pfn, &top_pfn);
>   #ifdef AREA_LOW_PFN
