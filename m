Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9092FED86
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 15:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731961AbhAUOxO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 09:53:14 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5644 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732414AbhAUNei (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 08:34:38 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10LDXdmb147293;
        Thu, 21 Jan 2021 08:33:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=LPSQJvWH3bs44OCEEUo84jCsk8gwznJnmfXwr6cLVns=;
 b=rIeq0zEhc+vzMvyRoc2lxzcRdigBNApwRpCF1+imHpj/dBbGN6RJZqlERgN0mcboPofv
 2m36Vh6pjnIKXnFT+/s6eYw6yyGnNvDhC/iW7BPVY/QJXK7jy4buAFE2e30oqgfDOYvq
 /6fPFZ4Wz/nGEJNz0Qh9CYEZzBl5QyNFE0QHh5UaLO34kKTi2Fw+I1lO7++gRXNpJZYY
 RsP6p79xwoPBtBOHgGkbI3CdaQ4FwUSzwV7ZhrOR/QnNsQ1aBHfiy7AUq9+tg7yktTy7
 wZ3Xq4aaP+xfSudWvW7RVU74Mjeyk1mhjSGNZYViRQ3xPuMuoP5gTMNHaoH/UPwoZEyb cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 367a0jscyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 08:33:57 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10LDXv2r149227;
        Thu, 21 Jan 2021 08:33:57 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 367a0jscxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 08:33:57 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10LDVdAD021436;
        Thu, 21 Jan 2021 13:33:54 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3668paspjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 13:33:54 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10LDXp0b41484736
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 13:33:51 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56BF5A404D;
        Thu, 21 Jan 2021 13:33:51 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8A38A4040;
        Thu, 21 Jan 2021 13:33:50 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.36.14])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jan 2021 13:33:50 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 2/3] s390x: define UV compatible I/O
 allocation
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com, drjones@redhat.com,
        pbonzini@redhat.com
References: <1611220392-22628-1-git-send-email-pmorel@linux.ibm.com>
 <1611220392-22628-3-git-send-email-pmorel@linux.ibm.com>
 <6c232520-dbd1-80e4-e3a3-949964df7403@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <835c66a3-b25e-c4d3-7ae2-dc075091e5b4@linux.ibm.com>
Date:   Thu, 21 Jan 2021 14:33:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <6c232520-dbd1-80e4-e3a3-949964df7403@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_06:2021-01-21,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 mlxscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101210074
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/21/21 10:46 AM, Janosch Frank wrote:
> On 1/21/21 10:13 AM, Pierre Morel wrote:
>> To centralize the memory allocation for I/O we define
>> the alloc_io_page/free_io_page functions which share the I/O
>> memory with the host in case the guest runs with
>> protected virtualization.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   MAINTAINERS           |  1 +
>>   lib/s390x/malloc_io.c | 70 +++++++++++++++++++++++++++++++++++++++++++
>>   lib/s390x/malloc_io.h | 45 ++++++++++++++++++++++++++++
>>   s390x/Makefile        |  1 +
>>   4 files changed, 117 insertions(+)
>>   create mode 100644 lib/s390x/malloc_io.c
>>   create mode 100644 lib/s390x/malloc_io.h
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 54124f6..89cb01e 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -82,6 +82,7 @@ M: Thomas Huth <thuth@redhat.com>
>>   M: David Hildenbrand <david@redhat.com>
>>   M: Janosch Frank <frankja@linux.ibm.com>
>>   R: Cornelia Huck <cohuck@redhat.com>
>> +R: Pierre Morel <pmorel@linux.ibm.com>
> 
> If you're ok with the amount of mails you'll get then go ahead.
> But I think maintainer file changes should always be in a separate patch.
> 
>>   L: kvm@vger.kernel.org
>>   L: linux-s390@vger.kernel.org
>>   F: s390x/*
>> diff --git a/lib/s390x/malloc_io.c b/lib/s390x/malloc_io.c
>> new file mode 100644
>> index 0000000..bfe8c6a
>> --- /dev/null
>> +++ b/lib/s390x/malloc_io.c
>> @@ -0,0 +1,70 @@
>> +// SPDX-License-Identifier: GPL-2.0
> 
> I think we wanted to use:
> /* SPDX-License-Identifier: GPL-2.0-or-later */
> 
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
>> +static int share_pages(void *p, int count)
>> +{
>> +	int i = 0;
>> +
>> +	for (i = 0; i < count; i++, p += PAGE_SIZE)
>> +		if (uv_set_shared((unsigned long)p))
>> +			return i;
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
>> +void *alloc_io_pages(int size, int flags)
>> +{
>> +	int order = (size >> PAGE_SHIFT);
>> +	void *p;
>> +	int n;
>> +
>> +	assert(size);
>> +
>> +	p = alloc_pages_flags(order, AREA_DMA31 | flags);
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
>> +void free_io_pages(void *p, int size)
>> +{
>> +	int order = size >> PAGE_SHIFT;
>> +
>> +	assert(IS_ALIGNED((uintptr_t)p, PAGE_SIZE));
>> +
>> +	if (test_facility(158))
>> +		unshare_pages(p, 1 << order);
> 
> I have a lib file in the making that will let you check UV features like
> test_facility(). When that's ready I'm gonna check for unshare here.

OK.
On share_pages the rc is enough I suppose.


-- 
Pierre Morel
IBM Lab Boeblingen
