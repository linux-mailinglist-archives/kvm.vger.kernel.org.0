Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4480B300786
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 16:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729090AbhAVPjq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 10:39:46 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21572 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728950AbhAVPja (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Jan 2021 10:39:30 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10MFXpKs032178;
        Fri, 22 Jan 2021 10:38:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=BViOkhT24fcMoq9i4atPZi78BRmgxileOKWVfl4QPVg=;
 b=o3i57lXjMo3upd1BuHOrQOhcrelnHwpy6m4zsbvqr4ExhwlWaWTPc4rPX5DNaGoYoyHp
 m3NpC513qUZ0N4H06JOEa1EL7Wcm8tCifaccPXj7ok8p0fmhu5m9JinM1TuL2LPRImQd
 sFJtJnnMvi444yYX3jJDfMGHITHOt3IDOk4lZukuTvUhYgj3k1vwd6lUbrhQ7ENHI7D4
 ksZRsw1RLSp05gWnJfLfK2MqH8oE+e0Viezcq9Xe7RVS1b/nY5oZoi2TckwdCdWc9R8h
 pym8G/hP1ttTyJJuJQ1rt1qbJMzsP6m7dE5MeZ84ztkb5FMRXaLNlMP8KMMNxKD4gjmG Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 367yd8ckcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 10:38:38 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10MFaKj7048422;
        Fri, 22 Jan 2021 10:38:38 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 367yd8ckbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 10:38:37 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10MFWwQ8004227;
        Fri, 22 Jan 2021 15:38:35 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 367k0p0ps3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 15:38:35 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10MFcQZc34406744
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 15:38:26 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A003511C052;
        Fri, 22 Jan 2021 15:38:32 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3269D11C05B;
        Fri, 22 Jan 2021 15:38:32 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.82.252])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Jan 2021 15:38:32 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v5 2/3] s390x: define UV compatible I/O
 allocation
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com, drjones@redhat.com,
        pbonzini@redhat.com
References: <1611322060-1972-1-git-send-email-pmorel@linux.ibm.com>
 <1611322060-1972-3-git-send-email-pmorel@linux.ibm.com>
 <fcb7e165-d1a6-9d0b-a8e8-e91f39e2e0f7@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <a692e401-874a-5d20-7f78-d0024ca57583@linux.ibm.com>
Date:   Fri, 22 Jan 2021 16:38:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <fcb7e165-d1a6-9d0b-a8e8-e91f39e2e0f7@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-22_11:2021-01-22,2021-01-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 impostorscore=0 mlxscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101220087
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/22/21 2:57 PM, Janosch Frank wrote:
> On 1/22/21 2:27 PM, Pierre Morel wrote:
>> To centralize the memory allocation for I/O we define
>> the alloc_io_mem/free_io_mem functions which share the I/O
>> memory with the host in case the guest runs with
>> protected virtualization.
>>
>> These functions allocate on a page integral granularity to
>> ensure a dedicated sharing of the allocated objects.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> 
> Acked-by: Janosch Frank <frankja@de.ibm.com>
> 
>> ---
>>   lib/s390x/malloc_io.c | 71 +++++++++++++++++++++++++++++++++++++++++++
>>   lib/s390x/malloc_io.h | 45 +++++++++++++++++++++++++++
>>   s390x/Makefile        |  1 +
>>   3 files changed, 117 insertions(+)
>>   create mode 100644 lib/s390x/malloc_io.c
>>   create mode 100644 lib/s390x/malloc_io.h
>>
>> diff --git a/lib/s390x/malloc_io.c b/lib/s390x/malloc_io.c
>> new file mode 100644
>> index 0000000..b01222e
>> --- /dev/null
>> +++ b/lib/s390x/malloc_io.c
>> @@ -0,0 +1,71 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * I/O page allocation
>> + *
>> + * Copyright (c) 2021 IBM Corp
>> + *
>> + * Authors:
>> + *  Pierre Morel <pmorel@linux.ibm.com>
>> + *
>> + * Using this interface provide host access to the allocated pages in
>> + * case the guest is a secure guest.
> 
> s/secure/protected/

OK

> 
>> + * This is needed for I/O buffers.
>> + *
>> + */
>> +#include <libcflat.h>
>> +#include <asm/page.h>
>> +#include <asm/uv.h>
>> +#include <malloc_io.h>
>> +#include <alloc_page.h>
>> +#include <asm/facility.h>
>> +#include <bitops.h>
>> +
>> +static int share_pages(void *p, int count)
>> +{
>> +	int i = 0;
>> +
>> +	for (i = 0; i < count; i++, p += PAGE_SIZE)
>> +		if (uv_set_shared((unsigned long)p))
>> +			break;
>> +	return i;
>> +}
>> +
>> +static void unshare_pages(void *p, int count)
>> +{
>> +	int i;
>> +
>> +	for (i = count; i > 0; i--, p += PAGE_SIZE)
>> +		uv_remove_shared((unsigned long)p);
>> +}
>> +
>> +void *alloc_io_mem(int size, int flags)
>> +{
>> +	int order = get_order(size >> PAGE_SHIFT);
>> +	void *p;
>> +	int n;
>> +
>> +	assert(size);
>> +
>> +	p = alloc_pages_flags(order, AREA_DMA31 | flags);
> 
> Pardon my lack of IO knowledge but do we also need to restrict the data
> to below 2g or only the IO control structures?
> 
> Not that it currently matters much for a unit test with 256mb of memory...

it depends, if you know how work most scatter-gather it is easy:

INSTR-> ORB -> CCW -> DATA

first level metadata: yes
- Intruction point with 31bit to ORB
- ORB point with 31b to CCW
- CCW point with 31b to data

first level of data, the one pointed by the CCW: yes

This is all what is used in this patch.

To be developed in the future:

INSTR-> ORB -> CCW -> [M]IDA -> DATA

second level metadata:
they are pointed to by CCW...
- IDA : yes
- MIDA: yes

second level data (indirect buffering)
- IDA format 1: 31b address: yes
- IDA format 2: 64b address: no
- MIDA        : 64b address: no

Or to sum up only data accessed with indirect addressing by IDA format 2 
and MIDA can be anywhere.

> 
>> +	if (!p || !test_facility(158))
>> +		return p;
>> +
>> +	n = share_pages(p, 1 << order);
>> +	if (n == 1 << order)
>> +		return p;
>> +
>> +	unshare_pages(p, n);
>> +	free_pages(p);
>> +	return NULL;
>> +}
>> +
>> +void free_io_mem(void *p, int size)
>> +{
>> +	int order = get_order(size >> PAGE_SHIFT);
>> +
>> +	assert(IS_ALIGNED((uintptr_t)p, PAGE_SIZE));
>> +
>> +	if (test_facility(158))
>> +		unshare_pages(p, 1 << order);
>> +	free_pages(p);
>> +}
>> diff --git a/lib/s390x/malloc_io.h b/lib/s390x/malloc_io.h
>> new file mode 100644
>> index 0000000..cc5fad7
>> --- /dev/null
>> +++ b/lib/s390x/malloc_io.h
>> @@ -0,0 +1,45 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * I/O allocations
>> + *
>> + * Copyright (c) 2021 IBM Corp
>> + *
>> + * Authors:
>> + *  Pierre Morel <pmorel@linux.ibm.com>
>> + *
>> + */
>> +#ifndef _S390X_MALLOC_IO_H_
>> +#define _S390X_MALLOC_IO_H_
>> +
>> +/*
>> + * Allocates a page aligned page bound range of contiguous real or
>> + * absolute memory in the DMA31 region large enough to contain size
>> + * bytes.
>> + * If Protected Virtualisation facility is present, shares the pages
> 
> s/Virtualisation/Virtualization/
> 
> But I can fix this and the nitpick above up when picking.

:) Thomas made me change this in the last round.

As far as I know "z" is used in the uS ans "s" in England (and France).

regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
