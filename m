Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100092FBB4F
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 16:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390135AbhASPfO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 10:35:14 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22898 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391508AbhASPef (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 10:34:35 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10JFWvIH114199;
        Tue, 19 Jan 2021 10:33:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=v+PYTXQ7lGkTWrVW1gIufTBuzFxF8bd1fmSYdBAWDS4=;
 b=le2W2bPLdzMdTd+GJuaGPALAnr5kToBhNqQNkYQsCv6QoBEDhSdXlsZIi15kpsMkT10+
 yiaUDlqxPOhhHiGP7T6pAt9L7d2CaGUL8g90coIVScCANcYrapP6tBA4w8XWtGUut9kR
 KSRNfbA1x9y96SpcQIhzOkULebwCZ4aFunf+54aa6pNmYBXCCTU3+VlQw5oO61gVScyJ
 BeSJnKMG8hn4JAiNyKh2l/Wm7iiUTHxf+M253BP3+YtwZmto8Az4FHrsX6wLOvAC/1A8
 GQkziGyn41QmuwOxgj/8PAa9v8amSZtdJPqcP0pY+3i9Y4CqplRiN3dFex/aUsXM12YD aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36603ycepu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 10:33:35 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10JFXYdY117820;
        Tue, 19 Jan 2021 10:33:34 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36603ycent-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 10:33:34 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10JFHM1E015039;
        Tue, 19 Jan 2021 15:33:32 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 363qs89nme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 15:33:32 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10JFXOqO21168580
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 15:33:24 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 800145204E;
        Tue, 19 Jan 2021 15:33:30 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.160.34])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id D615352059;
        Tue, 19 Jan 2021 15:33:29 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 04/11] lib/asm: Fix definitions of
 memory areas
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, pbonzini@redhat.com,
        cohuck@redhat.com, lvivier@redhat.com, nadav.amit@gmail.com,
        krish.sadhukhan@oracle.com
References: <20210115123730.381612-1-imbrenda@linux.ibm.com>
 <20210115123730.381612-5-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <f482372d-1bc3-48bf-d1e0-01f1167f4a04@linux.ibm.com>
Date:   Tue, 19 Jan 2021 16:33:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210115123730.381612-5-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_05:2021-01-18,2021-01-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 spamscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=999 malwarescore=0 suspectscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101190092
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/15/21 1:37 PM, Claudio Imbrenda wrote:
> Fix the definitions of the memory areas.
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

This confuses the heck out of me.
The other things look ok to me though.

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
> -#define MAX_AREAS	6
> -
>  #define ORDER_MASK	0x3f
>  #define ALLOC_MASK	0x40
>  #define SPECIAL_MASK	0x80
> @@ -509,7 +507,7 @@ void page_alloc_init_area(u8 n, uintptr_t base_pfn, uintptr_t top_pfn)
>  		return;
>  	}
>  #ifdef AREA_HIGH_PFN
> -	__page_alloc_init_area(AREA_HIGH_NUMBER, AREA_HIGH_PFN), base_pfn, &top_pfn);
> +	__page_alloc_init_area(AREA_HIGH_NUMBER, AREA_HIGH_PFN, base_pfn, &top_pfn);
>  #endif
>  	__page_alloc_init_area(AREA_NORMAL_NUMBER, AREA_NORMAL_PFN, base_pfn, &top_pfn);
>  #ifdef AREA_LOW_PFN
> 

