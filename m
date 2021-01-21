Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951D52FE682
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 10:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728650AbhAUJaF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 04:30:05 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59594 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728771AbhAUJ27 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 04:28:59 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10L92Ddj009960;
        Thu, 21 Jan 2021 04:28:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=AICbmeDtImDcJb74RYcVQZWpZ5ZU8HwuTidsggWY9LM=;
 b=nQZ9N/DsNKCBrPW+Mp+uHNGch80kq5TexAdIT7JyxkzSWcHboXLbFhvnpGcQSAmdDlaq
 TDBnvnK3TmZmbkAVbN2e1vrYW6fCu+mVHUmyJN5dTqBXpkhxM8Ie32XUTDRso/zl3E6N
 jcEqbJl+qm1DaCsW4CkZRkN7hlJg6OLSDlErdTI2D8a0bD7fT5eeYZvIk4SJ11kweQuE
 TsT0e+v95tveG+1pMac+RHGgmYlnPQE3orlngq4Qgc7VwJqfcmau+nxsPKmV7rh92x0S
 DUGnKOf2BJyGdfIOmsrkbll7gSyTyxFDqtlU3uc1MxDEyTfGTABD3X3YoTUkZB3KdZE9 pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3676g510r3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 04:28:15 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10L92epC011716;
        Thu, 21 Jan 2021 04:28:15 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3676g510pw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 04:28:14 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10L9GccN022465;
        Thu, 21 Jan 2021 09:28:12 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3668nwsgd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 09:28:12 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10L9SAKP50332112
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 09:28:10 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72AB3A405B;
        Thu, 21 Jan 2021 09:28:10 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EDFEFA4054;
        Thu, 21 Jan 2021 09:28:09 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.4.167])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jan 2021 09:28:09 +0000 (GMT)
Date:   Thu, 21 Jan 2021 10:28:08 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, frankja@linux.ibm.com,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, cohuck@redhat.com,
        Laurent Vivier <lvivier@redhat.com>, nadav.amit@gmail.com,
        krish.sadhukhan@oracle.com
Subject: Re: [kvm-unit-tests PATCH v2 04/11] lib/asm: Fix definitions of
 memory areas
Message-ID: <20210121102808.21046c18@ibm-vm>
In-Reply-To: <CALzav=ehg9zWe2POxKg0FDciyfT7QsWRDDNqZ7_WRqtdWMEtaA@mail.gmail.com>
References: <20210115123730.381612-1-imbrenda@linux.ibm.com>
        <20210115123730.381612-5-imbrenda@linux.ibm.com>
        <CALzav=ehg9zWe2POxKg0FDciyfT7QsWRDDNqZ7_WRqtdWMEtaA@mail.gmail.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_03:2021-01-20,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 bulkscore=0 lowpriorityscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101210045
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 Jan 2021 17:23:33 -0800
David Matlack <dmatlack@google.com> wrote:

> Hi Claudio,
> 
> On Fri, Jan 15, 2021 at 8:07 AM Claudio Imbrenda
> <imbrenda@linux.ibm.com> wrote:
> >
> > Fix the definitions of the memory areas.  
> 
> The test x86/smat.flat started falling for me at this commit. I'm
> testing on Linux 5.7.17.
> 
> Here are the logs:

the test does not fail with the default configuration, maybe the
default configuration should be changed?

I would have noticed the issue otherwise.


after a quick look at the testcase itself, it's quite obvious to me
that it is broken, since it completely relied on the fact that the page
allocator would not touch memory above 16M.

this is not the case any more.

I have fixed the testcase, I'll post a patch


> timeout -k 1s --foreground 90s /usr/bin/qemu-system-x86_64 --no-reboot
> -nodefaults -device pc-testdev -device
> isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc none -serial stdio -device
> pci-testdev -machine accel=kvm -kernel x86/smap.flat -smp 1 -cpu host
> # -initrd /tmp/tmp.s4WKgsHkOh
> enabling apic
> paging enabled
> cr0 = 80010011
> cr3 = 1007000
> cr4 = 20
> testing without INVLPG
> PASS: write to supervisor page
> PASS: read from user page with AC=1
> PASS: read from user page with AC=0
> FAIL: write to user page with AC=1
> FAIL: read from user page with AC=0
> FAIL: write to user stack with AC=1
> FAIL: write to user stack with AC=0
> Unhandled exception 6 #UD at ip 0000000001800003
> error_code=0000      rflags=00010082      cs=00000008
> rax=000000000000000a rcx=00000000000003fd rdx=00000000000003f8
> rbx=0000000000000000
> rbp=0000000000517700 rsi=0000000000416422 rdi=0000000000000000
>  r8=0000000000416422  r9=00000000000003f8 r10=000000000000000d
> r11=000ffffffffff000
> r12=0000000000000000 r13=0000000001418700 r14=0000000000000000
> r15=0000000000000000
> cr0=0000000080010011 cr2=00000000015176d8 cr3=0000000001007000
> cr4=0000000000200020
> cr8=0000000000000000
> STACK: @1800003 400368
> b'0x0000000001800003: ?? ??:0'
> 
> 
> 
> >
> > Bring the headers in line with the rest of the asm headers, by
> > having the appropriate #ifdef _ASM$ARCH_ guarding the headers.
> >
> > Fixes: d74708246bd9 ("lib/asm: Add definitions of memory areas")
> >
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> > ---
> >  lib/asm-generic/memory_areas.h |  9 ++++-----
> >  lib/arm/asm/memory_areas.h     | 11 +++--------
> >  lib/arm64/asm/memory_areas.h   | 11 +++--------
> >  lib/powerpc/asm/memory_areas.h | 11 +++--------
> >  lib/ppc64/asm/memory_areas.h   | 11 +++--------
> >  lib/s390x/asm/memory_areas.h   | 13 ++++++-------
> >  lib/x86/asm/memory_areas.h     | 27 ++++++++++++++++-----------
> >  lib/alloc_page.h               |  3 +++
> >  lib/alloc_page.c               |  4 +---
> >  9 files changed, 42 insertions(+), 58 deletions(-)
> >
> > diff --git a/lib/asm-generic/memory_areas.h
> > b/lib/asm-generic/memory_areas.h index 927baa7..3074afe 100644
> > --- a/lib/asm-generic/memory_areas.h
> > +++ b/lib/asm-generic/memory_areas.h
> > @@ -1,11 +1,10 @@
> > -#ifndef MEMORY_AREAS_H
> > -#define MEMORY_AREAS_H
> > +#ifndef __ASM_GENERIC_MEMORY_AREAS_H__
> > +#define __ASM_GENERIC_MEMORY_AREAS_H__
> >
> >  #define AREA_NORMAL_PFN 0
> >  #define AREA_NORMAL_NUMBER 0
> > -#define AREA_NORMAL 1
> > +#define AREA_NORMAL (1 << AREA_NORMAL_NUMBER)
> >
> > -#define AREA_ANY -1
> > -#define AREA_ANY_NUMBER 0xff
> > +#define MAX_AREAS 1
> >
> >  #endif
> > diff --git a/lib/arm/asm/memory_areas.h b/lib/arm/asm/memory_areas.h
> > index 927baa7..c723310 100644
> > --- a/lib/arm/asm/memory_areas.h
> > +++ b/lib/arm/asm/memory_areas.h
> > @@ -1,11 +1,6 @@
> > -#ifndef MEMORY_AREAS_H
> > -#define MEMORY_AREAS_H
> > +#ifndef _ASMARM_MEMORY_AREAS_H_
> > +#define _ASMARM_MEMORY_AREAS_H_
> >
> > -#define AREA_NORMAL_PFN 0
> > -#define AREA_NORMAL_NUMBER 0
> > -#define AREA_NORMAL 1
> > -
> > -#define AREA_ANY -1
> > -#define AREA_ANY_NUMBER 0xff
> > +#include <asm-generic/memory_areas.h>
> >
> >  #endif
> > diff --git a/lib/arm64/asm/memory_areas.h
> > b/lib/arm64/asm/memory_areas.h index 927baa7..18e8ca8 100644
> > --- a/lib/arm64/asm/memory_areas.h
> > +++ b/lib/arm64/asm/memory_areas.h
> > @@ -1,11 +1,6 @@
> > -#ifndef MEMORY_AREAS_H
> > -#define MEMORY_AREAS_H
> > +#ifndef _ASMARM64_MEMORY_AREAS_H_
> > +#define _ASMARM64_MEMORY_AREAS_H_
> >
> > -#define AREA_NORMAL_PFN 0
> > -#define AREA_NORMAL_NUMBER 0
> > -#define AREA_NORMAL 1
> > -
> > -#define AREA_ANY -1
> > -#define AREA_ANY_NUMBER 0xff
> > +#include <asm-generic/memory_areas.h>
> >
> >  #endif
> > diff --git a/lib/powerpc/asm/memory_areas.h
> > b/lib/powerpc/asm/memory_areas.h index 927baa7..76d1738 100644
> > --- a/lib/powerpc/asm/memory_areas.h
> > +++ b/lib/powerpc/asm/memory_areas.h
> > @@ -1,11 +1,6 @@
> > -#ifndef MEMORY_AREAS_H
> > -#define MEMORY_AREAS_H
> > +#ifndef _ASMPOWERPC_MEMORY_AREAS_H_
> > +#define _ASMPOWERPC_MEMORY_AREAS_H_
> >
> > -#define AREA_NORMAL_PFN 0
> > -#define AREA_NORMAL_NUMBER 0
> > -#define AREA_NORMAL 1
> > -
> > -#define AREA_ANY -1
> > -#define AREA_ANY_NUMBER 0xff
> > +#include <asm-generic/memory_areas.h>
> >
> >  #endif
> > diff --git a/lib/ppc64/asm/memory_areas.h
> > b/lib/ppc64/asm/memory_areas.h index 927baa7..b9fd46b 100644
> > --- a/lib/ppc64/asm/memory_areas.h
> > +++ b/lib/ppc64/asm/memory_areas.h
> > @@ -1,11 +1,6 @@
> > -#ifndef MEMORY_AREAS_H
> > -#define MEMORY_AREAS_H
> > +#ifndef _ASMPPC64_MEMORY_AREAS_H_
> > +#define _ASMPPC64_MEMORY_AREAS_H_
> >
> > -#define AREA_NORMAL_PFN 0
> > -#define AREA_NORMAL_NUMBER 0
> > -#define AREA_NORMAL 1
> > -
> > -#define AREA_ANY -1
> > -#define AREA_ANY_NUMBER 0xff
> > +#include <asm-generic/memory_areas.h>
> >
> >  #endif
> > diff --git a/lib/s390x/asm/memory_areas.h
> > b/lib/s390x/asm/memory_areas.h index 4856a27..827bfb3 100644
> > --- a/lib/s390x/asm/memory_areas.h
> > +++ b/lib/s390x/asm/memory_areas.h
> > @@ -1,16 +1,15 @@
> > -#ifndef MEMORY_AREAS_H
> > -#define MEMORY_AREAS_H
> > +#ifndef _ASMS390X_MEMORY_AREAS_H_
> > +#define _ASMS390X_MEMORY_AREAS_H_
> >
> > -#define AREA_NORMAL_PFN BIT(31-12)
> > +#define AREA_NORMAL_PFN (1 << 19)
> >  #define AREA_NORMAL_NUMBER 0
> > -#define AREA_NORMAL 1
> > +#define AREA_NORMAL (1 << AREA_NORMAL_NUMBER)
> >
> >  #define AREA_LOW_PFN 0
> >  #define AREA_LOW_NUMBER 1
> > -#define AREA_LOW 2
> > +#define AREA_LOW (1 << AREA_LOW_NUMBER)
> >
> > -#define AREA_ANY -1
> > -#define AREA_ANY_NUMBER 0xff
> > +#define MAX_AREAS 2
> >
> >  #define AREA_DMA31 AREA_LOW
> >
> > diff --git a/lib/x86/asm/memory_areas.h b/lib/x86/asm/memory_areas.h
> > index 952f5bd..e84016f 100644
> > --- a/lib/x86/asm/memory_areas.h
> > +++ b/lib/x86/asm/memory_areas.h
> > @@ -1,21 +1,26 @@
> > -#ifndef MEMORY_AREAS_H
> > -#define MEMORY_AREAS_H
> > +#ifndef _ASM_X86_MEMORY_AREAS_H_
> > +#define _ASM_X86_MEMORY_AREAS_H_
> >
> >  #define AREA_NORMAL_PFN BIT(36-12)
> >  #define AREA_NORMAL_NUMBER 0
> > -#define AREA_NORMAL 1
> > +#define AREA_NORMAL (1 << AREA_NORMAL_NUMBER)
> >
> > -#define AREA_PAE_HIGH_PFN BIT(32-12)
> > -#define AREA_PAE_HIGH_NUMBER 1
> > -#define AREA_PAE_HIGH 2
> > +#define AREA_HIGH_PFN BIT(32-12)
> > +#define AREA_HIGH_NUMBER 1
> > +#define AREA_HIGH (1 << AREA_HIGH_NUMBER)
> >
> > -#define AREA_LOW_PFN 0
> > +#define AREA_LOW_PFN BIT(24-12)
> >  #define AREA_LOW_NUMBER 2
> > -#define AREA_LOW 4
> > +#define AREA_LOW (1 << AREA_LOW_NUMBER)
> >
> > -#define AREA_PAE (AREA_PAE | AREA_LOW)
> > +#define AREA_LOWEST_PFN 0
> > +#define AREA_LOWEST_NUMBER 3
> > +#define AREA_LOWEST (1 << AREA_LOWEST_NUMBER)
> >
> > -#define AREA_ANY -1
> > -#define AREA_ANY_NUMBER 0xff
> > +#define MAX_AREAS 4
> > +
> > +#define AREA_DMA24 AREA_LOWEST
> > +#define AREA_DMA32 (AREA_LOWEST | AREA_LOW)
> > +#define AREA_PAE36 (AREA_LOWEST | AREA_LOW | AREA_HIGH)
> >
> >  #endif
> > diff --git a/lib/alloc_page.h b/lib/alloc_page.h
> > index 816ff5d..b6aace5 100644
> > --- a/lib/alloc_page.h
> > +++ b/lib/alloc_page.h
> > @@ -10,6 +10,9 @@
> >
> >  #include <asm/memory_areas.h>
> >
> > +#define AREA_ANY -1
> > +#define AREA_ANY_NUMBER 0xff
> > +
> >  /* Returns true if the page allocator has been initialized */
> >  bool page_alloc_initialized(void);
> >
> > diff --git a/lib/alloc_page.c b/lib/alloc_page.c
> > index 685ab1e..ed0ff02 100644
> > --- a/lib/alloc_page.c
> > +++ b/lib/alloc_page.c
> > @@ -19,8 +19,6 @@
> >  #define NLISTS ((BITS_PER_LONG) - (PAGE_SHIFT))
> >  #define PFN(x) ((uintptr_t)(x) >> PAGE_SHIFT)
> >
> > -#define MAX_AREAS      6
> > -
> >  #define ORDER_MASK     0x3f
> >  #define ALLOC_MASK     0x40
> >  #define SPECIAL_MASK   0x80
> > @@ -509,7 +507,7 @@ void page_alloc_init_area(u8 n, uintptr_t
> > base_pfn, uintptr_t top_pfn) return;
> >         }
> >  #ifdef AREA_HIGH_PFN
> > -       __page_alloc_init_area(AREA_HIGH_NUMBER, AREA_HIGH_PFN),
> > base_pfn, &top_pfn);
> > +       __page_alloc_init_area(AREA_HIGH_NUMBER, AREA_HIGH_PFN,
> > base_pfn, &top_pfn); #endif
> >         __page_alloc_init_area(AREA_NORMAL_NUMBER, AREA_NORMAL_PFN,
> > base_pfn, &top_pfn); #ifdef AREA_LOW_PFN
> > --
> > 2.26.2
> >  

