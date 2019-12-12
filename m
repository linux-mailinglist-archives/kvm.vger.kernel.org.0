Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D60F311CE59
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 14:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729439AbfLLNcY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 08:32:24 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13948 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729302AbfLLNcY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Dec 2019 08:32:24 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBCDWJdC041270
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2019 08:32:23 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wthkk20rt-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2019 08:32:22 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Thu, 12 Dec 2019 13:32:19 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 12 Dec 2019 13:32:17 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBCDWGsl36110556
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 13:32:16 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66E8DA4062;
        Thu, 12 Dec 2019 13:32:16 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D988A405C;
        Thu, 12 Dec 2019 13:32:16 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.89])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 Dec 2019 13:32:16 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 1/9] s390x: saving regs for interrupts
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
References: <1576079170-7244-1-git-send-email-pmorel@linux.ibm.com>
 <1576079170-7244-2-git-send-email-pmorel@linux.ibm.com>
 <19f572f1-5855-154a-af2b-1273d485be51@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Thu, 12 Dec 2019 14:32:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <19f572f1-5855-154a-af2b-1273d485be51@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19121213-0020-0000-0000-0000039775DC
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121213-0021-0000-0000-000021EE7EE0
Message-Id: <eada4a92-afab-c6fa-a125-fdcc254643dd@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-12_03:2019-12-12,2019-12-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 mlxscore=0 suspectscore=0
 spamscore=0 mlxlogscore=764 bulkscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912120103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019-12-12 10:24, Janosch Frank wrote:
> On 12/11/19 4:46 PM, Pierre Morel wrote:
>> If we use multiple source of interrupts, for exemple, using SCLP
> 
> s/exemple/example/

OK, thanks

> 
>> console to print information while using I/O interrupts, we need
>> to have a re-entrant register saving interruption handling.
>>
>> Instead of saving at a static memory address, let's save the base
>> registers and the floating point registers on the stack.
>>
>> Note that we keep the static register saving to recover from the
>> RESET tests.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   s390x/cstart64.S | 25 +++++++++++++++++++++++--
>>   1 file changed, 23 insertions(+), 2 deletions(-)
>>
>> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
>> index 86dd4c4..ff05f9b 100644
>> --- a/s390x/cstart64.S
>> +++ b/s390x/cstart64.S
>> @@ -118,6 +118,25 @@ memsetxc:
>>   	lmg	%r0, %r15, GEN_LC_SW_INT_GRS
>>   	.endm
>>> +	.macro SAVE_IRQ_REGS
> 
> Maybe add comments to the start of the macros like:
> "Save registers on the stack, so we can have stacked interrupts."

OK.

> 
>> +	slgfi   %r15, 15 * 8
>> +	stmg    %r0, %r14, 0(%r15)
>> +	slgfi   %r15, 16 * 8
>> +	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
>> +	std	\i, \i * 8(%r15)
>> +	.endr
>> +	lgr     %r2, %r15
> 
> What's that doing?

Passing a parameter to the saved registers to the handler.
makes me think that since I reworked the interrupt handler to add 
registration the parameter disappeared...

I will remove this line and come back with a new series at the time we 
need to access the registers.

> 
>> +	.endm
>> +
>> +	.macro RESTORE_IRQ_REGS
>> +	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
>> +	ld	\i, \i * 8(%r15)
>> +	.endr
>> +	algfi   %r15, 16 * 8
>> +	lmg     %r0, %r14, 0(%r15)
>> +	algfi   %r15, 15 * 8
>> +	.endm
>> +
>>   .section .text
>>   /*
>>    * load_reset calling convention:
>> @@ -154,6 +173,8 @@ diag308_load_reset:
>>   	lpswe	GEN_LC_SW_INT_PSW
>>   1:	br	%r14
>>   
>> +
>> +
> 
> Still not fixed

sorry I did not see this

Thanks for review,
Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen

