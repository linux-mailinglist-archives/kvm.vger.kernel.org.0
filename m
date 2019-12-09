Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5D511720F
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 17:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfLIQns (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 11:43:48 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6864 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726741AbfLIQns (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Dec 2019 11:43:48 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB9GMAKv075608
        for <kvm@vger.kernel.org>; Mon, 9 Dec 2019 11:43:47 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wsmft4pqa-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2019 11:43:46 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Mon, 9 Dec 2019 16:43:45 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 9 Dec 2019 16:43:42 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xB9Gh0T050266388
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Dec 2019 16:43:00 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E069CAE04D;
        Mon,  9 Dec 2019 16:43:41 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9EFAAE045;
        Mon,  9 Dec 2019 16:43:41 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.89])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Dec 2019 16:43:41 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 4/9] s390x: export the clock
 get_clock_ms() utility
To:     David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        cohuck@redhat.com
References: <1575649588-6127-1-git-send-email-pmorel@linux.ibm.com>
 <1575649588-6127-5-git-send-email-pmorel@linux.ibm.com>
 <fc6e103d-100b-151b-4a6e-359f3103d5fa@redhat.com>
 <94cfa43e-de04-c00b-4a07-28b72937e7fc@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Mon, 9 Dec 2019 17:43:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <94cfa43e-de04-c00b-4a07-28b72937e7fc@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19120916-0008-0000-0000-0000033F32BE
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19120916-0009-0000-0000-00004A5E60A0
Message-Id: <1ce56475-764e-22a1-7d08-646ec1d77543@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-09_04:2019-12-09,2019-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 adultscore=0
 malwarescore=0 priorityscore=1501 suspectscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1912090141
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019-12-09 12:49, David Hildenbrand wrote:
> On 09.12.19 12:42, Thomas Huth wrote:
>> On 06/12/2019 17.26, Pierre Morel wrote:
>>> To serve multiple times, the function get_clock_ms() is moved
>>> from intercept.c test to the new file asm/time.h.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> Reviewed-by: David Hildenbrand <david@redhat.com>
>>> ---
>>>   lib/s390x/asm/time.h | 27 +++++++++++++++++++++++++++
>>>   s390x/intercept.c    | 11 +----------
>>>   2 files changed, 28 insertions(+), 10 deletions(-)
>>>   create mode 100644 lib/s390x/asm/time.h
>>>
>>> diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
>>> new file mode 100644
>>> index 0000000..b07ccbd
>>> --- /dev/null
>>> +++ b/lib/s390x/asm/time.h
>>> @@ -0,0 +1,27 @@
>>> +/*
>>> + * Clock utilities for s390
>>> + *
>>> + * Authors:
>>> + *  Thomas Huth <thuth@redhat.com>
>>> + *
>>> + * Copied from the s390/intercept test by:
>>> + *  Pierre Morel <pmorel@linux.ibm.com>
>>> + *
>>> + * This code is free software; you can redistribute it and/or modify it
>>> + * under the terms of the GNU General Public License version 2.
>>> + */
>>> +#ifndef _ASM_S390X_TIME_H_
>>> +#define _ASM_S390X_TIME_H_
>>> +
>>> +static inline uint64_t get_clock_ms(void)
>>> +{
>>> +	uint64_t clk;
>>> +
>>> +	asm volatile(" stck %0 " : : "Q"(clk) : "memory");
>>> +
>>> +	/* Bit 51 is incrememented each microsecond */
>>> +	return (clk >> (63 - 51)) / 1000;
>>> +}
>>> +
>>> +
>>
>> Please remove one of the two empty lines.
>>
>> With that cosmetic nit fixed:
>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen

