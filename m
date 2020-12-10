Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 436132D61A0
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 17:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388953AbgLJQV6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 11:21:58 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32706 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728600AbgLJQVa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Dec 2020 11:21:30 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BAG1pPY004810;
        Thu, 10 Dec 2020 11:20:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=QI6WgobRtAOYtCB2uHmWNDTdbXFxs8fRI6Ia/ZgwSRE=;
 b=W55VuoC6GErSEjIfuyvp7+IFNLb1ZUBim6Nfsb+a/xWg49blxV1tLDeL2+dbZdU99i++
 5tK4hZUpfc0HGAhhM1s4e57YPA8szc7sTICi1RZPKrL+8qL8OUeZ7yMbwsx+nuRIQUWk
 LovUTARN5PskE4RJB26RnxJo3k5rcVli5EzH8KScWNR8+0nfeK8ixEPY68zvXvp12M7k
 0XUXSFvEmen/k4FpEfEdFX8YI9vu3kmbSt/I+GCfHp/zyVCq7dY1es+XToW2gXUgHB0D
 rC9dSh+JiqHCb0UTurt/uD3Nlx/L8HsbE2hbu9KfkSb+Bcn1lfQVPczDlAeF5ROLvs6T nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35bpq995bc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 11:20:48 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BAG349i011538;
        Thu, 10 Dec 2020 11:20:48 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35bpq995ak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 11:20:48 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BAGItit025806;
        Thu, 10 Dec 2020 16:20:46 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 35958q26db-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 16:20:46 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BAGKhcU27787534
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Dec 2020 16:20:43 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B306D42042;
        Thu, 10 Dec 2020 16:20:42 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64A3A42068;
        Thu, 10 Dec 2020 16:20:42 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.153.118])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Dec 2020 16:20:42 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 2/2] s390x: lib: Move to GPL 2 and SPDX
 license identifiers
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20201208150902.32383-1-frankja@linux.ibm.com>
 <20201208150902.32383-3-frankja@linux.ibm.com>
 <c236052c-598b-0d88-c80b-4bb2a999ec46@redhat.com>
 <c08d511f-f9c0-5087-4e08-0c4ccbc4ebbf@linux.ibm.com>
 <bbc41642-028e-aae7-225d-a52eda54add1@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <72e727b2-1373-64f5-d1cc-c21c36a0eb64@linux.ibm.com>
Date:   Thu, 10 Dec 2020 17:20:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <bbc41642-028e-aae7-225d-a52eda54add1@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-10_06:2020-12-09,2020-12-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012100099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/10/20 5:15 PM, David Hildenbrand wrote:
> On 09.12.20 10:46, Janosch Frank wrote:
>> On 12/9/20 10:15 AM, David Hildenbrand wrote:
>>> On 08.12.20 16:09, Janosch Frank wrote:
>>>> In the past we had some issues when developers wanted to use code
>>>> snippets or constants from the kernel in a test or in the library. To
>>>> remedy that the s390x maintainers decided to move all files to GPL 2
>>>> (if possible).
>>>>
>>>> At the same time let's move to SPDX identifiers as they are much nicer
>>>> to read.
>>>>
>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>> ---
>>>>  lib/s390x/asm-offsets.c     | 4 +---
>>>>  lib/s390x/asm/arch_def.h    | 4 +---
>>>>  lib/s390x/asm/asm-offsets.h | 4 +---
>>>>  lib/s390x/asm/barrier.h     | 4 +---
>>>>  lib/s390x/asm/cpacf.h       | 1 +
>>>>  lib/s390x/asm/facility.h    | 4 +---
>>>>  lib/s390x/asm/float.h       | 4 +---
>>>>  lib/s390x/asm/interrupt.h   | 4 +---
>>>>  lib/s390x/asm/io.h          | 4 +---
>>>>  lib/s390x/asm/mem.h         | 4 +---
>>>>  lib/s390x/asm/page.h        | 4 +---
>>>>  lib/s390x/asm/pgtable.h     | 4 +---
>>>>  lib/s390x/asm/sigp.h        | 4 +---
>>>>  lib/s390x/asm/spinlock.h    | 4 +---
>>>>  lib/s390x/asm/stack.h       | 4 +---
>>>>  lib/s390x/asm/time.h        | 4 +---
>>>>  lib/s390x/css.h             | 4 +---
>>>>  lib/s390x/css_dump.c        | 4 +---
>>>>  lib/s390x/css_lib.c         | 4 +---
>>>>  lib/s390x/interrupt.c       | 4 +---
>>>>  lib/s390x/io.c              | 4 +---
>>>>  lib/s390x/mmu.c             | 4 +---
>>>>  lib/s390x/mmu.h             | 4 +---
>>>>  lib/s390x/sclp-console.c    | 5 +----
>>>>  lib/s390x/sclp.c            | 4 +---
>>>>  lib/s390x/sclp.h            | 5 +----
>>>>  lib/s390x/smp.c             | 4 +---
>>>>  lib/s390x/smp.h             | 4 +---
>>>>  lib/s390x/stack.c           | 4 +---
>>>>  lib/s390x/vm.c              | 3 +--
>>>>  lib/s390x/vm.h              | 3 +--
>>>>  31 files changed, 31 insertions(+), 90 deletions(-)
>>>>
>>>> diff --git a/lib/s390x/asm-offsets.c b/lib/s390x/asm-offsets.c
>>>> index 61d2658..ee94ed3 100644
>>>> --- a/lib/s390x/asm-offsets.c
>>>> +++ b/lib/s390x/asm-offsets.c
>>>> @@ -1,11 +1,9 @@
>>>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>>>  /*
>>>>   * Copyright (c) 2017 Red Hat Inc
>>>>   *
>>>>   * Authors:
>>>>   *  David Hildenbrand <david@redhat.com>
>>>> - *
>>>> - * This code is free software; you can redistribute it and/or modify it
>>>> - * under the terms of the GNU Library General Public License version 2.
>>>>   */
>>>>  #include <libcflat.h>
>>>>  #include <kbuild.h>
>>>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>>>> index edc06ef..f3ab830 100644
>>>> --- a/lib/s390x/asm/arch_def.h
>>>> +++ b/lib/s390x/asm/arch_def.h
>>>> @@ -1,11 +1,9 @@
>>>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>>>  /*
>>>>   * Copyright (c) 2017 Red Hat Inc
>>>>   *
>>>>   * Authors:
>>>>   *  David Hildenbrand <david@redhat.com>
>>>> - *
>>>> - * This code is free software; you can redistribute it and/or modify it
>>>> - * under the terms of the GNU Library General Public License version 2.
>>>>   */
>>>>  #ifndef _ASM_S390X_ARCH_DEF_H_
>>>>  #define _ASM_S390X_ARCH_DEF_H_
>>>> diff --git a/lib/s390x/asm/asm-offsets.h b/lib/s390x/asm/asm-offsets.h
>>>> index a6d7af8..bed7f8e 100644
>>>> --- a/lib/s390x/asm/asm-offsets.h
>>>> +++ b/lib/s390x/asm/asm-offsets.h
>>>> @@ -1,10 +1,8 @@
>>>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>>>  /*
>>>>   * Copyright (c) 2017 Red Hat Inc
>>>>   *
>>>>   * Authors:
>>>>   *  David Hildenbrand <david@redhat.com>
>>>> - *
>>>> - * This code is free software; you can redistribute it and/or modify it
>>>> - * under the terms of the GNU Library General Public License version 2.
>>>>   */
>>>>  #include <generated/asm-offsets.h>
>>>> diff --git a/lib/s390x/asm/barrier.h b/lib/s390x/asm/barrier.h
>>>> index d862e78..8e2fd6d 100644
>>>> --- a/lib/s390x/asm/barrier.h
>>>> +++ b/lib/s390x/asm/barrier.h
>>>> @@ -1,12 +1,10 @@
>>>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>>>  /*
>>>>   * Copyright (c) 2017 Red Hat Inc
>>>>   *
>>>>   * Authors:
>>>>   *  Thomas Huth <thuth@redhat.com>
>>>>   *  David Hildenbrand <david@redhat.com>
>>>> - *
>>>> - * This code is free software; you can redistribute it and/or modify it
>>>> - * under the terms of the GNU Library General Public License version 2.
>>>>   */
>>>>  #ifndef _ASM_S390X_BARRIER_H_
>>>>  #define _ASM_S390X_BARRIER_H_
>>>> diff --git a/lib/s390x/asm/cpacf.h b/lib/s390x/asm/cpacf.h
>>>> index 2146a01..805fcf1 100644
>>>> --- a/lib/s390x/asm/cpacf.h
>>>> +++ b/lib/s390x/asm/cpacf.h
>>>> @@ -1,3 +1,4 @@
>>>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>>>  /*
>>>>   * CP Assist for Cryptographic Functions (CPACF)
>>>>   *
>>>
>>> This file was originally copied from Linux v4.13. So I'm wondering if
>>> this should be
>>>
>>> SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
>>>
>>> instead. Doesn't make a real difference in practice I guess?
>>>
>> Linux's arch/s390/include/asm/cpacf.h has the GPL-2.0 identifier, so why
>> do you want the syscall note?
> 
> When we copied it in v4.13, there was no such identifier.
> 
> The tag was added in v4.14
> 
> commit b24413180f5600bcb3bb70fbed5cf186b60864bd
> Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date:   Wed Nov 1 15:07:57 2017 +0100
> 
>     License cleanup: add SPDX GPL-2.0 license identifier to files with
> no license
> 
> 
> So naive me checked COPYING and COPYING.new in v4.13 and spotted
> 
> The Linux Kernel is provided under:
> 	SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
> 
> 
> But as the tag was added in v4.14, GPL-2.0-only seems to be the right
> thing to do I assume.

It's a bit sad that this is so complicated.
Thanks for looking

> 
> Acked-by: David Hildenbrand <david@redhat.com>
> 

Great, now we have all Acks together

