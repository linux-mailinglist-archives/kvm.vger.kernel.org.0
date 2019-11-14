Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22349FC1B8
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 09:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbfKNIkq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 03:40:46 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43642 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726378AbfKNIkq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 03:40:46 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAE8btka095527
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 03:40:44 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w91npksps-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 03:40:44 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Thu, 14 Nov 2019 08:40:41 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 08:40:39 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAE8ecX049348756
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 08:40:38 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B513211C04C;
        Thu, 14 Nov 2019 08:40:38 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 801A611C04A;
        Thu, 14 Nov 2019 08:40:38 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.27])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Nov 2019 08:40:38 +0000 (GMT)
Subject: Re: [PATCH v1 2/4] s390x: Define the PSW bits
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
References: <1573647799-30584-1-git-send-email-pmorel@linux.ibm.com>
 <1573647799-30584-3-git-send-email-pmorel@linux.ibm.com>
 <5796f620-7ee6-6333-e4f4-5e904284a331@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Thu, 14 Nov 2019 09:40:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <5796f620-7ee6-6333-e4f4-5e904284a331@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19111408-0008-0000-0000-0000032EE8D6
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111408-0009-0000-0000-00004A4DF639
Message-Id: <189f8129-86c5-8761-fdfe-d08c34fb1f18@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-14_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911140082
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019-11-13 17:05, Janosch Frank wrote:
> On 11/13/19 1:23 PM, Pierre Morel wrote:
>> Instead of assigning obfuscated masks to the PSW dedicated to the
>> exceptions, let's define the masks explicitely, it will clarify the
> s/explicitely/explicitly/
> Try to break that up into sentences.
OK thx
>
>> usage.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/asm/arch_bits.h | 32 ++++++++++++++++++++++++++++++++
>>   lib/s390x/asm/arch_def.h  |  6 ++----
>>   s390x/cstart64.S          | 13 +++++++------
>>   3 files changed, 41 insertions(+), 10 deletions(-)
>>   create mode 100644 lib/s390x/asm/arch_bits.h
>>
>> diff --git a/lib/s390x/asm/arch_bits.h b/lib/s390x/asm/arch_bits.h
>> new file mode 100644
>> index 0000000..0521125
>> --- /dev/null
>> +++ b/lib/s390x/asm/arch_bits.h
>> @@ -0,0 +1,32 @@
>> +
>> +/*
>> + * Copyright (c) 2019 IBM Corp
>> + *
>> + * Authors:
>> + *  Pierre Morel <pmorel@linux.ibm.com>
>> + *
>> + * This code is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU Library General Public License version 2.
>> + */
>> +#ifndef _ASM_S390X_ARCH_BITS_H_
>> +#define _ASM_S390X_ARCH_BITS_H_
>> +
>> +#define PSW_MASK_PER		0x4000000000000000
>> +#define PSW_MASK_DAT		0x0400000000000000
>> +#define PSW_MASK_IO		0x0200000000000000
>> +#define PSW_MASK_EXT		0x0100000000000000
>> +#define PSW_MASK_BASE		0x0000000000000000
>> +#define PSW_MASK_KEY		0x00F0000000000000
>> +#define PSW_MASK_MCHECK		0x0004000000000000
>> +#define PSW_MASK_WAIT		0x0002000000000000
>> +#define PSW_MASK_PSTATE		0x0001000000000000
>> +#define PSW_MASK_ASC		0x0000C00000000000
>> +#define PSW_MASK_CC		0x0000300000000000
>> +#define PSW_MASK_PM		0x00000F0000000000
>> +#define PSW_MASK_RI		0x0000008000000000
>> +#define PSW_MASK_EA		0x0000000100000000
>> +#define PSW_MASK_BA		0x0000000080000000
> a-f should be lower case in hex values.
> Also, do we need all of them?
> I'd like to keep it as small as poss
>
>
>>> +
>>> +#endif
>>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>>> index 96cca2e..34c1188 100644
>>> --- a/lib/s390x/asm/arch_def.h
>>> +++ b/lib/s390x/asm/arch_def.h
>>> @@ -10,15 +10,13 @@
>>>   #ifndef _ASM_S390X_ARCH_DEF_H_
>>>   #define _ASM_S390X_ARCH_DEF_H_
>>>   
>>> +#include <asm/arch_bits.h>
>>> +
>>>   struct psw {
>>>   	uint64_t	mask;
>>>   	uint64_t	addr;
>>>   };
>>>   
>>> -#define PSW_MASK_EXT			0x0100000000000000UL
>>> -#define PSW_MASK_DAT			0x0400000000000000UL
>>> -#define PSW_MASK_PSTATE			0x0001000000000000UL
>>> -
>>>   #define CR0_EXTM_SCLP			0X0000000000000200UL
>>>   #define CR0_EXTM_EXTC			0X0000000000002000UL
>>>   #define CR0_EXTM_EMGC			0X0000000000004000UL
>>> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
>>> index eaff481..7475f32 100644
>>> --- a/s390x/cstart64.S
>>> +++ b/s390x/cstart64.S
>>> @@ -11,6 +11,7 @@
>>>    * under the terms of the GNU Library General Public License version 2.
>>>    */
>>>   #include <asm/asm-offsets.h>
>>> +#include <asm/arch_bits.h>
>>>   #include <asm/sigp.h>
>>>   
>>>   .section .init
>>> @@ -196,17 +197,17 @@ svc_int:
>>>   
>>>   	.align	8
>>>   initial_psw:
>>> -	.quad	0x0000000180000000, clear_bss_start
>>> +	.quad	PSW_EXCEPTION_MASK, clear_bss_start
>>>   pgm_int_psw:
>>> -	.quad	0x0000000180000000, pgm_int
>>> +	.quad	PSW_EXCEPTION_MASK, pgm_int
>>>   ext_int_psw:
>>> -	.quad	0x0000000180000000, ext_int
>>> +	.quad	PSW_EXCEPTION_MASK, ext_int
>>>   mcck_int_psw:
>>> -	.quad	0x0000000180000000, mcck_int
>>> +	.quad	PSW_EXCEPTION_MASK, mcck_int
>>>   io_int_psw:
>>> -	.quad	0x0000000180000000, io_int
>>> +	.quad	PSW_EXCEPTION_MASK, io_int
>>>   svc_int_psw:
>>> -	.quad	0x0000000180000000, svc_int
>>> +	.quad	PSW_EXCEPTION_MASK, svc_int
>>>   initial_cr0:
>>>   	/* enable AFP-register control, so FP regs (+BFP instr) can be used */
>>>   	.quad	0x0000000000040000
>>>
> ible.

OK


>
>> +
>> +#define PSW_EXCEPTION_MASK (PSW_MASK_EA|PSW_MASK_BA)
> That's not a bit anymore, shouldn't that be in arch_def.h?
> Also please add a comment, that this is 64 bit addressing.


Don't we use the 64bit architecture only?

Regards,

Pierre


-- 
Pierre Morel
IBM Lab Boeblingen

