Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDBA42FD0C8
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 13:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731640AbhATMwX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 07:52:23 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40176 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726004AbhATMki (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Jan 2021 07:40:38 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10KCX5R9072101;
        Wed, 20 Jan 2021 07:39:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=GbuDgkZG9Glge2JT7vKunAz4vzW6n685cO+TjP4KGDU=;
 b=pcZsqs26TYCHr1/QuL440+GIObdHDw0jlX0dUFE8vS6q8iqePhlNiRKCmth1Xcu13tj1
 AVmE/aRMQ7eX3mjG4cj7SjHs/GaU/gcQTz1OR2M9lLYDpmhVbsqx82Iui9Gj7M99nfML
 kP9oWMuWpUPjn6i/9uJX0kWEfSU7INfcoqqk1RFaF9ScmarxZa2gf0oQ+7D6WZpHNHH2
 bIeGxwfbTQVevFnsSdLFXw9q2AU6H4uBU5kn9DbHpryeKblC5arB6B9e+PGKFP0f7Mey
 UMQS/t8fhA3sKqgLZ7Am8RoB5JqWCk3BkJzTeJdjZcCJx3hefSDsfwrds6IYyuwSULB+ qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 366k7t2gvr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 07:39:57 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10KCXnHE079173;
        Wed, 20 Jan 2021 07:39:56 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 366k7t2gv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 07:39:56 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10KCcZnE001095;
        Wed, 20 Jan 2021 12:39:55 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3668nwrk35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 12:39:55 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10KCdqxM39125258
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jan 2021 12:39:52 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62F844C046;
        Wed, 20 Jan 2021 12:39:52 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F32624C040;
        Wed, 20 Jan 2021 12:39:51 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.39.155])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Jan 2021 12:39:51 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 2/3] s390x: define UV compatible I/O
 allocation
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        drjones@redhat.com, pbonzini@redhat.com
References: <1611085944-21609-1-git-send-email-pmorel@linux.ibm.com>
 <1611085944-21609-3-git-send-email-pmorel@linux.ibm.com>
 <2558695f-4ab7-d6e9-c857-0e8473ada775@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <4a9ae9a8-892b-3456-526e-1a46bf2c85dc@linux.ibm.com>
Date:   Wed, 20 Jan 2021 13:39:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <2558695f-4ab7-d6e9-c857-0e8473ada775@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-20_05:2021-01-20,2021-01-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 mlxscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101200072
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/20/21 12:01 PM, Thomas Huth wrote:
> On 19/01/2021 20.52, Pierre Morel wrote:
>> To centralize the memory allocation for I/O we define
>> the alloc_io_page/free_io_page functions which share the I/O
>> memory with the host in case the guest runs with
>> protected virtualization.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/malloc_io.c | 50 +++++++++++++++++++++++++++++++++++++++++++
>>   lib/s390x/malloc_io.h | 18 ++++++++++++++++
>>   s390x/Makefile        |  1 +
>>   3 files changed, 69 insertions(+)
>>   create mode 100644 lib/s390x/malloc_io.c
>>   create mode 100644 lib/s390x/malloc_io.h
>>
>> diff --git a/lib/s390x/malloc_io.c b/lib/s390x/malloc_io.c
>> new file mode 100644
>> index 0000000..2a946e0
>> --- /dev/null
>> +++ b/lib/s390x/malloc_io.c
>> @@ -0,0 +1,50 @@
>> +/*
>> + * I/O page allocation
>> + *
>> + * Copyright (c) 2021 IBM Corp
>> + *
>> + * Authors:
>> + *  Pierre Morel <pmorel@linux.ibm.com>
>> + *
>> + * This code is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License version 2.
> 
> Janosch recently started to introduce SPDX identifieres to the s390x 
> code, so I think it would be good to use them here, too.
> 
>> + * Using this interface provide host access to the allocated pages in
>> + * case the guest is a secure guest.
>> + * This is needed for I/O buffers.
>> + *
>> + */
>> +#include <libcflat.h>
>> +#include <asm/page.h>
>> +#include <asm/uv.h>
>> +#include <malloc_io.h>
>> +#include <alloc_page.h>
>> +#include <asm/facility.h>
>> +
>> +void *alloc_io_page(int size)
>> +{
>> +    void *p;
>> +
>> +    assert(size <= PAGE_SIZE);
> 
> Apart from the assert() statement, the size parameter seems to be 
> completely unused. It's also weird to have the function named 

right.

> alloc_something_page() and then have a parameter that takes bytes. Thus 
> I'd suggest to either drop the size parameter completely, or to rename 
> the function to alloc_io_mem and then to alloc multiple pages below in 
> case the size is bigger than PAGE_SIZE. Or maybe even to name the 
> function alloc_io_pages and then use "int num_pages" as a parameter, 
> allowing to allocate multiple pages at once?

OK, may bet using order as with the alloc_pages_flags would be fine.
Then I will need a new flag in the pages.

> 
>> +
>> +    p = alloc_pages_flags(1, AREA_DMA31);

humm 0 here (Claudio)

>> +    if (!p)
>> +        return NULL;
>> +    memset(p, 0, PAGE_SIZE);
>> +
>> +    if (!test_facility(158))
>> +        return p;
>> +
>> +    if (uv_set_shared((unsigned long)p) == 0)
>> +        return p;
>> +
>> +    free_pages(p);
>> +    return NULL;
>> +}
>> +
>> +void free_io_page(void *p)
>> +{
>> +    if (test_facility(158))
>> +        uv_remove_shared((unsigned long)p);
>> +    free_pages(p);
>> +}
>> diff --git a/lib/s390x/malloc_io.h b/lib/s390x/malloc_io.h
>> new file mode 100644
>> index 0000000..f780191
>> --- /dev/null
>> +++ b/lib/s390x/malloc_io.h
>> @@ -0,0 +1,18 @@
>> +/*
>> + * I/O allocations
>> + *
>> + * Copyright (c) 2021 IBM Corp
>> + *
>> + * Authors:
>> + *  Pierre Morel <pmorel@linux.ibm.com>
>> + *
>> + * This code is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License version 2.
>> + */
> Please also add SPDX license information here.

Will do.

Thanks for reviewing,
Pierre

> 
>   Thomas
> 

-- 
Pierre Morel
IBM Lab Boeblingen
