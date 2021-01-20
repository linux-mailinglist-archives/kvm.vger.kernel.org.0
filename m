Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E1D2FD0C9
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 13:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731731AbhATMwY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 07:52:24 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2880 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389909AbhATMmi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Jan 2021 07:42:38 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10KCWB9W143136;
        Wed, 20 Jan 2021 07:41:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3GgH8ECm6TfRD0oUuT53c1k+/uYapvUY4+hBWZMSd54=;
 b=rxYHE+scGPPzDSxzxWJsEb0Zia33TB4im4IhOIXPAlfDwivmihOhsFGeohqHfeTBX97e
 14KWP28FmfCbSekWyDzufVRTToDxH2LLDDkIMUpD5r+NTtaKxCKHwdEOHF87xbzcpNhc
 Gr+A3PJWMYccklMDaJe6BiqXmxbWy6IGxDB/R2EHQNMKVF4AYkUQ06YDrFy35ozQXKWe
 //jTqcv0RALmYYknzO5hAGz5bJ+eP82qtBQWwbkotjj7U8eyF0/Y8aB4MXpBoWzTcEgD
 yzG1ssYiY+kb5dkPNBMTrZlNKzneemf3HHCOgl73AqcduJP7RZcT5yFYCyQI/sgkLGnu dQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 366kepa4yw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 07:41:54 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10KCWaG9145401;
        Wed, 20 Jan 2021 07:41:52 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 366kepa4wg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 07:41:52 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10KCch9r001146;
        Wed, 20 Jan 2021 12:41:48 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3668nwrk6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 12:41:48 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10KCfjnd18088404
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jan 2021 12:41:45 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66B754C059;
        Wed, 20 Jan 2021 12:41:45 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05FE44C05E;
        Wed, 20 Jan 2021 12:41:45 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.39.155])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Jan 2021 12:41:44 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 2/3] s390x: define UV compatible I/O
 allocation
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, drjones@redhat.com, pbonzini@redhat.com
References: <1611085944-21609-1-git-send-email-pmorel@linux.ibm.com>
 <1611085944-21609-3-git-send-email-pmorel@linux.ibm.com>
 <20210120132539.236dd224@ibm-vm>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <a3ecb6af-d4b9-0f28-c574-bfaf8354b50a@linux.ibm.com>
Date:   Wed, 20 Jan 2021 13:41:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210120132539.236dd224@ibm-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-20_05:2021-01-18,2021-01-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 impostorscore=0 phishscore=0 suspectscore=0 mlxscore=0 adultscore=0
 spamscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101200072
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/20/21 1:25 PM, Claudio Imbrenda wrote:
> On Tue, 19 Jan 2021 20:52:23 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> To centralize the memory allocation for I/O we define
>> the alloc_io_page/free_io_page functions which share the I/O
>> memory with the host in case the guest runs with
>> protected virtualization.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/malloc_io.c | 50
>> +++++++++++++++++++++++++++++++++++++++++++ lib/s390x/malloc_io.h |
>> 18 ++++++++++++++++ s390x/Makefile        |  1 +
>>   3 files changed, 69 insertions(+)
>>   create mode 100644 lib/s390x/malloc_io.c
>>   create mode 100644 lib/s390x/malloc_io.h
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
>> + *  Pierre Morel <pmorel@linux.ibm.com>
>> + *
>> + * This code is free software; you can redistribute it and/or modify
>> it
>> + * under the terms of the GNU General Public License version 2.
>> + *
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
>> +	void *p;
>> +
>> +	assert(size <= PAGE_SIZE);
> 
> I agree with Thomas here, remove size, or use it as a page count or
> page order.
> 
>> +	p = alloc_pages_flags(1, AREA_DMA31);
> 
> you are allocating 2 pages here...

humm, yes, forgot to change this as I changed to your interface.

Thanks for the reviewing,
Pierre



-- 
Pierre Morel
IBM Lab Boeblingen
