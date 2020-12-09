Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 970FF2D3F16
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 10:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729460AbgLIJr1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 04:47:27 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61842 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728962AbgLIJr0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Dec 2020 04:47:26 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B99WWPg090166;
        Wed, 9 Dec 2020 04:46:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=83esXZvMHHmub3Jg9FBQyXedb41Fgxy4gfpr0HuEvIM=;
 b=idwOXvC35eDh4pbRNYcgGgcQmXFZyH+91V5E0Zz346rmIjNk+sqN3Y+bbRpe4MiOmMw6
 jRVXhdz0tbWhO8XLmEDTLAOs6NaXh6s3tBxeL6HS5TN0FZ36ZrZ3s90yd+0+WAkSbQgA
 XtBQzisLR4Ll/cJ+Ya/NHJB0zdseuY1loLrd5H5hADRJQzJpHljXKL5zEsysTU6F1TyS
 iZp3hy342fAJNSrNRvP9cZk8TepX22hPU0pB/dODyp1YgKvfRzmZcY1RAoO1wQwv44qH
 +YqPZdkBkpuLaoQjuUFnpNQ0gXiY5FO2Jke7dfoAdX3rVJNmHCgGUKh59UHBtNKLaeML 6A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35appd0nwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 04:46:45 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B99XmaF095059;
        Wed, 9 Dec 2020 04:46:44 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35appd0nwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 04:46:44 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B99XXHb001257;
        Wed, 9 Dec 2020 09:46:42 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3581fhj9jx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 09:46:42 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B99ke0g23003460
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Dec 2020 09:46:40 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2992BA405F;
        Wed,  9 Dec 2020 09:46:40 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7210A405C;
        Wed,  9 Dec 2020 09:46:39 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.43.26])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Dec 2020 09:46:39 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 2/2] s390x: lib: Move to GPL 2 and SPDX
 license identifiers
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20201208150902.32383-1-frankja@linux.ibm.com>
 <20201208150902.32383-3-frankja@linux.ibm.com>
 <c236052c-598b-0d88-c80b-4bb2a999ec46@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <c08d511f-f9c0-5087-4e08-0c4ccbc4ebbf@linux.ibm.com>
Date:   Wed, 9 Dec 2020 10:46:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <c236052c-598b-0d88-c80b-4bb2a999ec46@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-09_07:2020-12-08,2020-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 clxscore=1015 priorityscore=1501 malwarescore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 impostorscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090064
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/9/20 10:15 AM, David Hildenbrand wrote:
> On 08.12.20 16:09, Janosch Frank wrote:
>> In the past we had some issues when developers wanted to use code
>> snippets or constants from the kernel in a test or in the library. To
>> remedy that the s390x maintainers decided to move all files to GPL 2
>> (if possible).
>>
>> At the same time let's move to SPDX identifiers as they are much nicer
>> to read.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  lib/s390x/asm-offsets.c     | 4 +---
>>  lib/s390x/asm/arch_def.h    | 4 +---
>>  lib/s390x/asm/asm-offsets.h | 4 +---
>>  lib/s390x/asm/barrier.h     | 4 +---
>>  lib/s390x/asm/cpacf.h       | 1 +
>>  lib/s390x/asm/facility.h    | 4 +---
>>  lib/s390x/asm/float.h       | 4 +---
>>  lib/s390x/asm/interrupt.h   | 4 +---
>>  lib/s390x/asm/io.h          | 4 +---
>>  lib/s390x/asm/mem.h         | 4 +---
>>  lib/s390x/asm/page.h        | 4 +---
>>  lib/s390x/asm/pgtable.h     | 4 +---
>>  lib/s390x/asm/sigp.h        | 4 +---
>>  lib/s390x/asm/spinlock.h    | 4 +---
>>  lib/s390x/asm/stack.h       | 4 +---
>>  lib/s390x/asm/time.h        | 4 +---
>>  lib/s390x/css.h             | 4 +---
>>  lib/s390x/css_dump.c        | 4 +---
>>  lib/s390x/css_lib.c         | 4 +---
>>  lib/s390x/interrupt.c       | 4 +---
>>  lib/s390x/io.c              | 4 +---
>>  lib/s390x/mmu.c             | 4 +---
>>  lib/s390x/mmu.h             | 4 +---
>>  lib/s390x/sclp-console.c    | 5 +----
>>  lib/s390x/sclp.c            | 4 +---
>>  lib/s390x/sclp.h            | 5 +----
>>  lib/s390x/smp.c             | 4 +---
>>  lib/s390x/smp.h             | 4 +---
>>  lib/s390x/stack.c           | 4 +---
>>  lib/s390x/vm.c              | 3 +--
>>  lib/s390x/vm.h              | 3 +--
>>  31 files changed, 31 insertions(+), 90 deletions(-)
>>
>> diff --git a/lib/s390x/asm-offsets.c b/lib/s390x/asm-offsets.c
>> index 61d2658..ee94ed3 100644
>> --- a/lib/s390x/asm-offsets.c
>> +++ b/lib/s390x/asm-offsets.c
>> @@ -1,11 +1,9 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>  /*
>>   * Copyright (c) 2017 Red Hat Inc
>>   *
>>   * Authors:
>>   *  David Hildenbrand <david@redhat.com>
>> - *
>> - * This code is free software; you can redistribute it and/or modify it
>> - * under the terms of the GNU Library General Public License version 2.
>>   */
>>  #include <libcflat.h>
>>  #include <kbuild.h>
>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>> index edc06ef..f3ab830 100644
>> --- a/lib/s390x/asm/arch_def.h
>> +++ b/lib/s390x/asm/arch_def.h
>> @@ -1,11 +1,9 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>  /*
>>   * Copyright (c) 2017 Red Hat Inc
>>   *
>>   * Authors:
>>   *  David Hildenbrand <david@redhat.com>
>> - *
>> - * This code is free software; you can redistribute it and/or modify it
>> - * under the terms of the GNU Library General Public License version 2.
>>   */
>>  #ifndef _ASM_S390X_ARCH_DEF_H_
>>  #define _ASM_S390X_ARCH_DEF_H_
>> diff --git a/lib/s390x/asm/asm-offsets.h b/lib/s390x/asm/asm-offsets.h
>> index a6d7af8..bed7f8e 100644
>> --- a/lib/s390x/asm/asm-offsets.h
>> +++ b/lib/s390x/asm/asm-offsets.h
>> @@ -1,10 +1,8 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>  /*
>>   * Copyright (c) 2017 Red Hat Inc
>>   *
>>   * Authors:
>>   *  David Hildenbrand <david@redhat.com>
>> - *
>> - * This code is free software; you can redistribute it and/or modify it
>> - * under the terms of the GNU Library General Public License version 2.
>>   */
>>  #include <generated/asm-offsets.h>
>> diff --git a/lib/s390x/asm/barrier.h b/lib/s390x/asm/barrier.h
>> index d862e78..8e2fd6d 100644
>> --- a/lib/s390x/asm/barrier.h
>> +++ b/lib/s390x/asm/barrier.h
>> @@ -1,12 +1,10 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>  /*
>>   * Copyright (c) 2017 Red Hat Inc
>>   *
>>   * Authors:
>>   *  Thomas Huth <thuth@redhat.com>
>>   *  David Hildenbrand <david@redhat.com>
>> - *
>> - * This code is free software; you can redistribute it and/or modify it
>> - * under the terms of the GNU Library General Public License version 2.
>>   */
>>  #ifndef _ASM_S390X_BARRIER_H_
>>  #define _ASM_S390X_BARRIER_H_
>> diff --git a/lib/s390x/asm/cpacf.h b/lib/s390x/asm/cpacf.h
>> index 2146a01..805fcf1 100644
>> --- a/lib/s390x/asm/cpacf.h
>> +++ b/lib/s390x/asm/cpacf.h
>> @@ -1,3 +1,4 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>  /*
>>   * CP Assist for Cryptographic Functions (CPACF)
>>   *
> 
> This file was originally copied from Linux v4.13. So I'm wondering if
> this should be
> 
> SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
> 
> instead. Doesn't make a real difference in practice I guess?
> 
Linux's arch/s390/include/asm/cpacf.h has the GPL-2.0 identifier, so why
do you want the syscall note?


