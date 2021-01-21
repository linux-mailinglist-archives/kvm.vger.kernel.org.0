Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87AC12FE6FC
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 11:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbhAUJ6l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 04:58:41 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20252 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728923AbhAUJ6U (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 04:58:20 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10L9hnSW126471;
        Thu, 21 Jan 2021 04:57:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=QBcg9b/b7eutu8gbVfkNnekB83AHRlfcCQjRAa7wTYA=;
 b=QHMSL7QHppjf9MjJGpiKxqL/y3q4Vp5yI0XTwPhQ4B8GU59zXAwvIZEaBvvGa+fvXJJz
 6fGqWL6xad6hSztscouO2nIyrUdOigoDk9ovljwz+jyNxQFwbOPqAPlQZPCL09YVRgZE
 Pnmy1Www34Y3UXrB4ZMmT3OhqBBZNFWiyanTEH4K8fG7bQCBKFhMV5J/pmuSMtxCVamM
 HYu9Vt9IXUNYFXYmj1sbw2mkR+tMK5amK1Vbspek2/aGsrGMCBMCOkACxKVCRlwxKSs5
 nL+PjWdoxUhaD2hcp24L3QX8eIUuBwV4jwEwcTibJcEhxydBBAUCfeE+AaIA2AucQuif +A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36777yrayc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 04:57:38 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10L9i4gO127735;
        Thu, 21 Jan 2021 04:57:38 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36777yray2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 04:57:38 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10L9bdLB031895;
        Thu, 21 Jan 2021 09:57:36 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3668p80sqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 09:57:36 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10L9vXvn19988750
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 09:57:33 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A986CA4040;
        Thu, 21 Jan 2021 09:57:33 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 450ACA405E;
        Thu, 21 Jan 2021 09:57:33 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.36.14])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jan 2021 09:57:33 +0000 (GMT)
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
Message-ID: <54e3ff71-073b-2c98-40b3-c5b575577cfc@linux.ibm.com>
Date:   Thu, 21 Jan 2021 10:57:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <6c232520-dbd1-80e4-e3a3-949964df7403@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_04:2021-01-20,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0 spamscore=0
 clxscore=1015 priorityscore=1501 impostorscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101210049
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

You are right it was more an attempts to bring the Linux checkpatch to 
be quiet but this would need more changes so.. we can discuss this in a 
separate patch.

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

yes


...snip...
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

OK

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
