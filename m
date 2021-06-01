Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460313977FC
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 18:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbhFAQ1f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 12:27:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40770 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233657AbhFAQ1e (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Jun 2021 12:27:34 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 151G2kwp029167;
        Tue, 1 Jun 2021 12:25:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=pdHJbs0c5h784RvYWk3N9apBVj1wWseQQTt11FFBkfo=;
 b=RJsdTg39KvgzMIgUnhTXlYu3zuu5hMriVq9XX9TSUqNvjMkN2qWHknKCoQtByoChJ9YH
 QJNND+CS0FEI0pM/dxy1YwnJ6YhZaGCtzQYF5WRdTeralHD3MI7t9XG15fQCSP9j94WG
 6iXR4MztwLAyCk1PfenEf2yJOB1aVQOicx7MG82AQrF3CWqLArmVyiksq7PDQ2Zw/6H2
 RBRItSVjBBnl0+ry/U8XOe558rYnfbC3RghNh74G2aK3RWPN6M8etHIiQexM45sggbu8
 tTvptI7JnWb5sA6FlwYdPw5f9MO0wAAs9EheycMwBol6YCNFN0lC2Zonx2Fu1C44wBGy 1A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38wqxcs018-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Jun 2021 12:25:51 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 151G2p7A029797;
        Tue, 1 Jun 2021 12:25:51 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38wqxcs00p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Jun 2021 12:25:51 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 151GCAQD018731;
        Tue, 1 Jun 2021 16:25:49 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 38ud889uce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Jun 2021 16:25:49 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 151GPlMl9634194
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Jun 2021 16:25:47 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B9DA52057;
        Tue,  1 Jun 2021 16:25:47 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.6.60])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2FF5D52050;
        Tue,  1 Jun 2021 16:25:47 +0000 (GMT)
Date:   Tue, 1 Jun 2021 18:25:45 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] s390x: unify header guards
Message-ID: <20210601182545.36acdc98@ibm-vm>
In-Reply-To: <20210601161525.462315-1-cohuck@redhat.com>
References: <20210601161525.462315-1-cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nBd1sBpX9W4_X7E4hqGZhCIUixUT3QCT
X-Proofpoint-GUID: kO_Q-W3CSImWAmA-TyVxrAEYUrXTWfYp
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-01_08:2021-06-01,2021-06-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 clxscore=1015 adultscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106010109
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  1 Jun 2021 18:15:25 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> Let's unify the header guards to _ASM_S390X_FILE_H_ respectively
> _S390X_FILE_H_. This makes it more obvious what the file is
> about, and avoids possible name space collisions.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>

LGTM, but... what about the other architectures? I think we should 
try to standardize more generally

> ---
> 
> Only did s390x for now; the other archs seem to be inconsistent in
> places as well, and I can also try to tackle them if it makes sense.
> 
> ---
>  lib/s390x/asm/bitops.h       | 4 ++--
>  lib/s390x/asm/cpacf.h        | 6 +++---
>  lib/s390x/asm/interrupt.h    | 4 ++--
>  lib/s390x/asm/io.h           | 4 ++--
>  lib/s390x/asm/mem.h          | 4 ++--
>  lib/s390x/asm/memory_areas.h | 4 ++--
>  lib/s390x/asm/page.h         | 4 ++--
>  lib/s390x/asm/pgtable.h      | 6 +++---
>  lib/s390x/asm/sigp.h         | 6 +++---
>  lib/s390x/asm/spinlock.h     | 4 ++--
>  lib/s390x/asm/stack.h        | 4 ++--
>  lib/s390x/asm/time.h         | 4 ++--
>  lib/s390x/asm/uv.h           | 4 ++--
>  lib/s390x/css.h              | 4 ++--
>  lib/s390x/interrupt.h        | 6 +++---
>  lib/s390x/mmu.h              | 6 +++---
>  lib/s390x/sclp.h             | 6 +++---
>  lib/s390x/sie.h              | 6 +++---
>  lib/s390x/smp.h              | 4 ++--
>  lib/s390x/uv.h               | 6 +++---
>  lib/s390x/vm.h               | 6 +++---
>  s390x/sthyi.h                | 4 ++--
>  22 files changed, 53 insertions(+), 53 deletions(-)
> 
> diff --git a/lib/s390x/asm/bitops.h b/lib/s390x/asm/bitops.h
> index 792881ec3249..61cd38fd36b7 100644
> --- a/lib/s390x/asm/bitops.h
> +++ b/lib/s390x/asm/bitops.h
> @@ -8,8 +8,8 @@
>   *    Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>,
>   *
>   */
> -#ifndef _ASMS390X_BITOPS_H_
> -#define _ASMS390X_BITOPS_H_
> +#ifndef _ASM_S390X_BITOPS_H_
> +#define _ASM_S390X_BITOPS_H_
>  
>  #ifndef _BITOPS_H_
>  #error only <bitops.h> can be included directly
> diff --git a/lib/s390x/asm/cpacf.h b/lib/s390x/asm/cpacf.h
> index 805fcf1a2d71..8e9b8d754c92 100644
> --- a/lib/s390x/asm/cpacf.h
> +++ b/lib/s390x/asm/cpacf.h
> @@ -8,8 +8,8 @@
>   *	      Harald Freudenberger (freude@de.ibm.com)
>   *	      Martin Schwidefsky <schwidefsky@de.ibm.com>
>   */
> -#ifndef _ASM_S390_CPACF_H
> -#define _ASM_S390_CPACF_H
> +#ifndef _ASM_S390X_CPACF_H_
> +#define _ASM_S390X_CPACF_H_
>  
>  #include <asm/facility.h>
>  #include <linux/compiler.h>
> @@ -471,4 +471,4 @@ static inline void cpacf_pckmo(long func, void
> *param) : "cc", "memory");
>  }
>  
> -#endif	/* _ASM_S390_CPACF_H */
> +#endif	/* _ASM_S390X_CPACF_H_ */
> diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
> index 31e4766d23d5..c095a76f1e7d 100644
> --- a/lib/s390x/asm/interrupt.h
> +++ b/lib/s390x/asm/interrupt.h
> @@ -5,8 +5,8 @@
>   * Authors:
>   *  David Hildenbrand <david@redhat.com>
>   */
> -#ifndef _ASMS390X_IRQ_H_
> -#define _ASMS390X_IRQ_H_
> +#ifndef _ASM_S390X_IRQ_H_
> +#define _ASM_S390X_IRQ_H_
>  #include <asm/arch_def.h>
>  
>  #define EXT_IRQ_EMERGENCY_SIG	0x1201
> diff --git a/lib/s390x/asm/io.h b/lib/s390x/asm/io.h
> index 1dc6283b641f..8b602ca70075 100644
> --- a/lib/s390x/asm/io.h
> +++ b/lib/s390x/asm/io.h
> @@ -6,8 +6,8 @@
>   *  Thomas Huth <thuth@redhat.com>
>   *  David Hildenbrand <david@redhat.com>
>   */
> -#ifndef _ASMS390X_IO_H_
> -#define _ASMS390X_IO_H_
> +#ifndef _ASM_S390X_IO_H_
> +#define _ASM_S390X_IO_H_
>  
>  #define __iomem
>  
> diff --git a/lib/s390x/asm/mem.h b/lib/s390x/asm/mem.h
> index 281390ebd816..082655759d54 100644
> --- a/lib/s390x/asm/mem.h
> +++ b/lib/s390x/asm/mem.h
> @@ -5,8 +5,8 @@
>   * Copyright IBM Corp. 2018
>   * Author(s): Janosch Frank <frankja@de.ibm.com>
>   */
> -#ifndef _ASM_S390_MEM_H
> -#define _ASM_S390_MEM_H
> +#ifndef _ASM_S390X_MEM_H_
> +#define _ASM_S390X_MEM_H_
>  
>  #define SKEY_ACC	0xf0
>  #define SKEY_FP		0x08
> diff --git a/lib/s390x/asm/memory_areas.h
> b/lib/s390x/asm/memory_areas.h index 827bfb356007..c368bbb5dc5e 100644
> --- a/lib/s390x/asm/memory_areas.h
> +++ b/lib/s390x/asm/memory_areas.h
> @@ -1,5 +1,5 @@
> -#ifndef _ASMS390X_MEMORY_AREAS_H_
> -#define _ASMS390X_MEMORY_AREAS_H_
> +#ifndef _ASM_S390X_MEMORY_AREAS_H_
> +#define _ASM_S390X_MEMORY_AREAS_H_
>  
>  #define AREA_NORMAL_PFN (1 << 19)
>  #define AREA_NORMAL_NUMBER 0
> diff --git a/lib/s390x/asm/page.h b/lib/s390x/asm/page.h
> index f130f936c5da..c22c089c13e4 100644
> --- a/lib/s390x/asm/page.h
> +++ b/lib/s390x/asm/page.h
> @@ -6,8 +6,8 @@
>   *  Thomas Huth <thuth@redhat.com>
>   *  David Hildenbrand <david@redhat.com>
>   */
> -#ifndef _ASMS390X_PAGE_H_
> -#define _ASMS390X_PAGE_H_
> +#ifndef _ASM_S390X_PAGE_H_
> +#define _ASM_S390X_PAGE_H_
>  
>  #include <asm-generic/page.h>
>  
> diff --git a/lib/s390x/asm/pgtable.h b/lib/s390x/asm/pgtable.h
> index 277f34801460..210d6ab398e2 100644
> --- a/lib/s390x/asm/pgtable.h
> +++ b/lib/s390x/asm/pgtable.h
> @@ -7,8 +7,8 @@
>   * Authors:
>   *  David Hildenbrand <david@redhat.com>
>   */
> -#ifndef _ASMS390X_PGTABLE_H_
> -#define _ASMS390X_PGTABLE_H_
> +#ifndef _ASM_S390X_PGTABLE_H_
> +#define _ASM_S390X_PGTABLE_H_
>  
>  #include <asm/page.h>
>  #include <alloc_page.h>
> @@ -219,4 +219,4 @@ static inline void ipte(unsigned long vaddr,
> pteval_t *p_pte) 
>  void configure_dat(int enable);
>  
> -#endif /* _ASMS390X_PGTABLE_H_ */
> +#endif /* _ASM_S390X_PGTABLE_H_ */
> diff --git a/lib/s390x/asm/sigp.h b/lib/s390x/asm/sigp.h
> index 00844d26d15a..b3bf7e9cb50c 100644
> --- a/lib/s390x/asm/sigp.h
> +++ b/lib/s390x/asm/sigp.h
> @@ -5,8 +5,8 @@
>   * Copied from the Linux kernel file arch/s390/include/asm/sigp.h
>   */
>  
> -#ifndef ASM_S390X_SIGP_H
> -#define ASM_S390X_SIGP_H
> +#ifndef _ASM_S390X_SIGP_H_
> +#define _ASM_S390X_SIGP_H_
>  
>  /* SIGP order codes */
>  #define SIGP_SENSE			1
> @@ -73,4 +73,4 @@ static inline int sigp_retry(uint16_t addr, uint8_t
> order, unsigned long parm, }
>  
>  #endif /* __ASSEMBLER__ */
> -#endif /* ASM_S390X_SIGP_H */
> +#endif /* _ASM_S390X_SIGP_H_ */
> diff --git a/lib/s390x/asm/spinlock.h b/lib/s390x/asm/spinlock.h
> index 677d2cd6e287..ca9bf8616749 100644
> --- a/lib/s390x/asm/spinlock.h
> +++ b/lib/s390x/asm/spinlock.h
> @@ -6,8 +6,8 @@
>   *  Thomas Huth <thuth@redhat.com>
>   *  David Hildenbrand <david@redhat.com>
>   */
> -#ifndef __ASMS390X_SPINLOCK_H
> -#define __ASMS390X_SPINLOCK_H
> +#ifndef _ASM_S390X_SPINLOCK_H_
> +#define _ASM_S390X_SPINLOCK_H_
>  
>  #include <asm-generic/spinlock.h>
>  
> diff --git a/lib/s390x/asm/stack.h b/lib/s390x/asm/stack.h
> index 909da36dce47..b49978051d88 100644
> --- a/lib/s390x/asm/stack.h
> +++ b/lib/s390x/asm/stack.h
> @@ -6,8 +6,8 @@
>   *  Thomas Huth <thuth@redhat.com>
>   *  David Hildenbrand <david@redhat.com>
>   */
> -#ifndef _ASMS390X_STACK_H_
> -#define _ASMS390X_STACK_H_
> +#ifndef _ASM_S390X_STACK_H_
> +#define _ASM_S390X_STACK_H_
>  
>  #ifndef _STACK_H_
>  #error Do not directly include <asm/stack.h>. Just use <stack.h>.
> diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
> index 0d67f7231992..72a43228d73d 100644
> --- a/lib/s390x/asm/time.h
> +++ b/lib/s390x/asm/time.h
> @@ -8,8 +8,8 @@
>   * Copied from the s390/intercept test by:
>   *  Pierre Morel <pmorel@linux.ibm.com>
>   */
> -#ifndef ASM_S390X_TIME_H
> -#define ASM_S390X_TIME_H
> +#ifndef _ASM_S390X_TIME_H_
> +#define _ASM_S390X_TIME_H_
>  
>  #define STCK_SHIFT_US	(63 - 51)
>  #define STCK_MAX	((1UL << 52) - 1)
> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
> index b22cbaa87109..12c4fdcce669 100644
> --- a/lib/s390x/asm/uv.h
> +++ b/lib/s390x/asm/uv.h
> @@ -9,8 +9,8 @@
>   * This code is free software; you can redistribute it and/or modify
> it
>   * under the terms of the GNU General Public License version 2.
>   */
> -#ifndef ASM_S390X_UV_H
> -#define ASM_S390X_UV_H
> +#ifndef _ASM_S390X_UV_H_
> +#define _ASM_S390X_UV_H_
>  
>  #define UVC_RC_EXECUTED		0x0001
>  #define UVC_RC_INV_CMD		0x0002
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index 7e3d2613402e..d644971fb2b7 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -6,8 +6,8 @@
>   * Author: Pierre Morel <pmorel@linux.ibm.com>
>   */
>  
> -#ifndef CSS_H
> -#define CSS_H
> +#ifndef _S390X_CSS_H_
> +#define _S390X_CSS_H_
>  
>  #define lowcore_ptr ((struct lowcore *)0x0)
>  
> diff --git a/lib/s390x/interrupt.h b/lib/s390x/interrupt.h
> index 1973d267c2f1..48d90cec1f23 100644
> --- a/lib/s390x/interrupt.h
> +++ b/lib/s390x/interrupt.h
> @@ -1,8 +1,8 @@
> -#ifndef INTERRUPT_H
> -#define INTERRUPT_H
> +#ifndef _S390X_INTERRUPT_H_
> +#define _S390X_INTERRUPT_H_
>  #include <asm/interrupt.h>
>  
>  int register_io_int_func(void (*f)(void));
>  int unregister_io_int_func(void (*f)(void));
>  
> -#endif /* INTERRUPT_H */
> +#endif /* _S390X_INTERRUPT_H_ */
> diff --git a/lib/s390x/mmu.h b/lib/s390x/mmu.h
> index 603f289e8e00..328a25513aae 100644
> --- a/lib/s390x/mmu.h
> +++ b/lib/s390x/mmu.h
> @@ -7,12 +7,12 @@
>   * Authors:
>   *	Janosch Frank <frankja@de.ibm.com>
>   */
> -#ifndef _ASMS390X_MMU_H_
> -#define _ASMS390X_MMU_H_
> +#ifndef _S390X_MMU_H_
> +#define _S390X_MMU_H_
>  
>  void protect_page(void *vaddr, unsigned long prot);
>  void protect_range(void *start, unsigned long len, unsigned long
> prot); void unprotect_page(void *vaddr, unsigned long prot);
>  void unprotect_range(void *start, unsigned long len, unsigned long
> prot); 
> -#endif /* _ASMS390X_MMU_H_ */
> +#endif /* _S390X_MMU_H_ */
> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
> index 7abf1038f5ee..28e526e2c915 100644
> --- a/lib/s390x/sclp.h
> +++ b/lib/s390x/sclp.h
> @@ -10,8 +10,8 @@
>   * Author: Christian Borntraeger <borntraeger@de.ibm.com>
>   */
>  
> -#ifndef SCLP_H
> -#define SCLP_H
> +#ifndef _S390X_SCLP_H_
> +#define _S390X_SCLP_H_
>  
>  #define SCLP_CMD_CODE_MASK                      0xffff00ff
>  
> @@ -329,4 +329,4 @@ void sclp_memory_setup(void);
>  uint64_t get_ram_size(void);
>  uint64_t get_max_ram_size(void);
>  
> -#endif /* SCLP_H */
> +#endif /* _S390X_SCLP_H_ */
> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
> index 518613baf1fa..db30d6164ab6 100644
> --- a/lib/s390x/sie.h
> +++ b/lib/s390x/sie.h
> @@ -1,6 +1,6 @@
>  /* SPDX-License-Identifier: GPL-2.0-or-later */
> -#ifndef SIE_H
> -#define SIE_H
> +#ifndef _S390X_SIE_H_
> +#define _S390X_SIE_H_
>  
>  #define CPUSTAT_STOPPED    0x80000000
>  #define CPUSTAT_WAIT       0x10000000
> @@ -195,4 +195,4 @@ extern void sie_entry(void);
>  extern void sie_exit(void);
>  extern void sie64a(struct kvm_s390_sie_block *sblk, struct
> vm_save_area *save_area); 
> -#endif /* SIE_H */
> +#endif /* _S390X_SIE_H_ */
> diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
> index 67ff16ca3c52..d99f9fc6cced 100644
> --- a/lib/s390x/smp.h
> +++ b/lib/s390x/smp.h
> @@ -7,8 +7,8 @@
>   * Authors:
>   *  Janosch Frank <frankja@linux.ibm.com>
>   */
> -#ifndef SMP_H
> -#define SMP_H
> +#ifndef _S390_SMP_H_
> +#define _S390_SMP_H_
>  
>  #include <asm/arch_def.h>
>  
> diff --git a/lib/s390x/uv.h b/lib/s390x/uv.h
> index 42608a967a03..96257851b1d4 100644
> --- a/lib/s390x/uv.h
> +++ b/lib/s390x/uv.h
> @@ -1,10 +1,10 @@
>  /* SPDX-License-Identifier: GPL-2.0-or-later */
> -#ifndef UV_H
> -#define UV_H
> +#ifndef _S390X_UV_H_
> +#define _S390X_UV_H_
>  
>  bool uv_os_is_guest(void);
>  bool uv_os_is_host(void);
>  bool uv_query_test_call(unsigned int nr);
>  int uv_setup(void);
>  
> -#endif /* UV_H */
> +#endif /* _S390X_UV_H_ */
> diff --git a/lib/s390x/vm.h b/lib/s390x/vm.h
> index 16722760cb46..7abba0ccae3d 100644
> --- a/lib/s390x/vm.h
> +++ b/lib/s390x/vm.h
> @@ -5,9 +5,9 @@
>   * Copyright (c) 2020 Red Hat Inc
>   */
>  
> -#ifndef S390X_VM_H
> -#define S390X_VM_H
> +#ifndef _S390X_VM_H_
> +#define _S390X_VM_H_
>  
>  bool vm_is_tcg(void);
>  
> -#endif  /* S390X_VM_H */
> +#endif  /* _S390X_VM_H_ */
> diff --git a/s390x/sthyi.h b/s390x/sthyi.h
> index bbd74c6197c3..eb92fdd2f2b2 100644
> --- a/s390x/sthyi.h
> +++ b/s390x/sthyi.h
> @@ -7,8 +7,8 @@
>   * Authors:
>   *    Janosch Frank <frankja@linux.vnet.ibm.com>
>   */
> -#ifndef _STHYI_H_
> -#define _STHYI_H_
> +#ifndef _S390X_STHYI_H_
> +#define _S390X_STHYI_H_
>  
>  #include <stdint.h>
>  

