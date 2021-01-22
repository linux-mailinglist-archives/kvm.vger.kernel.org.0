Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BED42FFDAF
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 08:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbhAVH4k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 02:56:40 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52728 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726485AbhAVH4g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Jan 2021 02:56:36 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10M7G0Rg083954;
        Fri, 22 Jan 2021 02:55:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=KvfEZdyuw4m9MoibtTM88SuJrnr14OJyRbDvUVEna44=;
 b=Dz+OHfqVI28xQrYlBPAjsVKSIWbhOTSpgB0NJghyOEDfXPzMKb2xJ17n+/XCoJSXl6tF
 cVVg5MJTwEN3KgEPasX71qaX/5T6wUAR7LkhTE6g10o1e1Y7RpQirHjR6vgvyFe1Qq9R
 jk4V9wVZvtydm1KMrPjeKANqjyUOtNW1f8581F/py7UussQNksI1x/bthZ2yYsGMs8xy
 GD7sZeEZW4Svx0ZW+hbu6j3o1RIdUirfuXbaBiMfuDyzFinP56b+yeYgioPV/30vOizu
 2LEd4KL84/TiKstgPlcn6WCMAZuaEo5obFgFkQU6gTkOq0P4G7Tt8gD6KoqjYNrAA5jM 2g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 367t5ugy83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 02:55:54 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10M7HOfM090604;
        Fri, 22 Jan 2021 02:55:54 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 367t5ugy78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 02:55:53 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10M7lP0d004343;
        Fri, 22 Jan 2021 07:55:52 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 367k0p0ay8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 07:55:52 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10M7tg3037093648
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 07:55:42 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 499E611C04C;
        Fri, 22 Jan 2021 07:55:49 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C910111C05B;
        Fri, 22 Jan 2021 07:55:48 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.14.230])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Jan 2021 07:55:48 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 2/3] s390x: define UV compatible I/O
 allocation
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        drjones@redhat.com, pbonzini@redhat.com
References: <1611220392-22628-1-git-send-email-pmorel@linux.ibm.com>
 <1611220392-22628-3-git-send-email-pmorel@linux.ibm.com>
 <a50c9d35-4a67-4adc-4647-98df14300ada@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <ff1f7e69-6962-5d1d-d7be-51089c735993@linux.ibm.com>
Date:   Fri, 22 Jan 2021 08:55:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <a50c9d35-4a67-4adc-4647-98df14300ada@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-22_03:2021-01-21,2021-01-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 clxscore=1015 mlxlogscore=999 malwarescore=0 suspectscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101220036
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/21/21 10:32 AM, Thomas Huth wrote:

...snip...

>> +#include <asm/facility.h>
>> +
>> +static int share_pages(void *p, int count)
>> +{
>> +    int i = 0;
>> +
>> +    for (i = 0; i < count; i++, p += PAGE_SIZE)
>> +        if (uv_set_shared((unsigned long)p))
>> +            return i;
> 
> Just a matter of taste, but you could replace the "return i" here also 
> with a "break" since you're returning i below anyway.

right a single out point is always better.

> 
>> +    return i;
>> +}
>> +
>> +static void unshare_pages(void *p, int count)
>> +{
>> +    int i;
>> +
>> +    for (i = count; i > 0; i--, p += PAGE_SIZE)
>> +        uv_remove_shared((unsigned long)p);
>> +}
>> +
>> +void *alloc_io_pages(int size, int flags)
> 
> I still think the naming or size parameter is confusing here. If I read 
> something like alloc_io_pages(), I'd expect a "num_pages" parameter. So 
> if you want to keep the "size" in bytes, I'd suggest to rename the 
> function to "alloc_io_mem" instead.

OK, I rename the function, allowing the user to keep a simple interface
without having to calculate the page order.

> 
>> +{
>> +    int order = (size >> PAGE_SHIFT);
> 
> I think this is wrong. According to the description of alloc_pages_flag, 
> it allocates "1ull << order" pages.
> So you likely want to do this instead here:
> 
>          int order = get_order(size >> PAGE_SHIFT);

you are absolutely right.

> 
>> +    void *p;
>> +    int n;
>> +
>> +    assert(size);
>> +
>> +    p = alloc_pages_flags(order, AREA_DMA31 | flags);
>> +    if (!p || !test_facility(158))
>> +        return p;
>> +
>> +    n = share_pages(p, 1 << order);
>> +    if (n == 1 << order)
>> +        return p;
>> +
>> +    unshare_pages(p, n);
>> +    free_pages(p);
>> +    return NULL;
>> +}
>> +
>> +void free_io_pages(void *p, int size)
>> +{
>> +    int order = size >> PAGE_SHIFT;
> 
> dito?

yes :(

> 
>> +    assert(IS_ALIGNED((uintptr_t)p, PAGE_SIZE));
>> +
>> +    if (test_facility(158))
>> +        unshare_pages(p, 1 << order);
>> +    free_pages(p);
>> +}
>> diff --git a/lib/s390x/malloc_io.h b/lib/s390x/malloc_io.h
>> new file mode 100644
>> index 0000000..494dfe9
>> --- /dev/null
>> +++ b/lib/s390x/malloc_io.h
>> @@ -0,0 +1,45 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
> 
> GPL-2.0-only please.

almmost... I use:
/* SPDX-License-Identifier: GPL-2.0-or-later */

as in other files updated by janosch if this is not a problem.

> 
>> +/*
>> + * I/O allocations
>> + *
>> + * Copyright (c) 2021 IBM Corp
>> + *
>> + * Authors:
>> + *  Pierre Morel <pmorel@linux.ibm.com>
>> + *
>> + */
>> +#ifndef _S390X_MALLOC_IO_H_
>> +#define _S390X_MALLOC_IO_H_
>> +
>> +/*
>> + * Allocates a page aligned page bound range of contiguous real or
>> + * absolute memory in the DMA31 region large enough to contain size
>> + * bytes.
>> + * If Protected Virtualization facility is present, shares the pages
>> + * with the host.
>> + * If all the pages for the specified size cannot be reserved,
>> + * the function rewinds the partial allocation and a NULL pointer
>> + * is returned.
>> + *
>> + * @size: the minimal size allocated in byte.
>> + * @flags: the flags used for the underlying page allocator.
>> + *
>> + * Errors:
>> + *   The allocation will assert the size parameter, will fail if the
>> + *   underlying page allocator fail or in the case of protected
>> + *   virtualisation if the sharing of the pages fails.
> 
> I think "virtualization" (with an z) is more common than "virtualisation".

OK


Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
