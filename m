Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636111F1AF2
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 16:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729977AbgFHOZE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 10:25:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46108 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728472AbgFHOZD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Jun 2020 10:25:03 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 058EM386190809;
        Mon, 8 Jun 2020 10:25:02 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31g7a18arv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 10:25:02 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 058EMRYg192687;
        Mon, 8 Jun 2020 10:25:02 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31g7a18ant-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 10:25:00 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 058EH49F024375;
        Mon, 8 Jun 2020 14:24:58 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 31g2s7sp38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 14:24:57 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 058EOtwb53215314
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Jun 2020 14:24:55 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CC4142054;
        Mon,  8 Jun 2020 14:24:55 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B7054205F;
        Mon,  8 Jun 2020 14:24:55 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.43.245])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Jun 2020 14:24:55 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v8 03/12] s390x: saving regs for interrupts
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1591603981-16879-1-git-send-email-pmorel@linux.ibm.com>
 <1591603981-16879-4-git-send-email-pmorel@linux.ibm.com>
 <d4f1167c-5e44-f69c-8aac-f792a2a50ca7@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <cde77b21-7fbb-bd09-bd3d-f77c5bd2a088@linux.ibm.com>
Date:   Mon, 8 Jun 2020 16:24:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <d4f1167c-5e44-f69c-8aac-f792a2a50ca7@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-08_13:2020-06-08,2020-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 spamscore=0 cotscore=-2147483648
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 malwarescore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006080104
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-06-08 11:05, Thomas Huth wrote:
> On 08/06/2020 10.12, Pierre Morel wrote:
>> If we use multiple source of interrupts, for example, using SCLP
>> console to print information while using I/O interrupts, we need
>> to have a re-entrant register saving interruption handling.
>>
>> Instead of saving at a static memory address, let's save the base
>> registers, the floating point registers and the floating point
>> control register on the stack in case of I/O interrupts
>>
>> Note that we keep the static register saving to recover from the
>> RESET tests.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Acked-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   s390x/cstart64.S | 41 +++++++++++++++++++++++++++++++++++++++--
>>   1 file changed, 39 insertions(+), 2 deletions(-)
>>
>> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
>> index b50c42c..a9d8223 100644
>> --- a/s390x/cstart64.S
>> +++ b/s390x/cstart64.S
>> @@ -119,6 +119,43 @@ memsetxc:
>>   	lmg	%r0, %r15, GEN_LC_SW_INT_GRS
>>   	.endm
>>   
>> +/* Save registers on the stack (r15), so we can have stacked interrupts. */
>> +	.macro SAVE_REGS_STACK
>> +	/* Allocate a stack frame for 15 general registers */
>> +	slgfi   %r15, 15 * 8
>> +	/* Store registers r0 to r14 on the stack */
>> +	stmg    %r0, %r14, 0(%r15)
>> +	/* Allocate a stack frame for 16 floating point registers */
>> +	/* The size of a FP register is the size of an double word */
>> +	slgfi   %r15, 16 * 8
>> +	/* Save fp register on stack: offset to SP is multiple of reg number */
>> +	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
>> +	std	\i, \i * 8(%r15)
>> +	.endr
>> +	/* Save fpc, but keep stack aligned on 64bits */
>> +	slgfi   %r15, 8
>> +	efpc	%r0
>> +	stg	%r0, 0(%r15)
>> +	.endm
> 
> I wonder whether it would be sufficient to only save the registers here
> that are "volatile" according to the ELF ABI? ... that would save quite
> some space on the stack, I think... OTOH, the old code was also saving
> all registers, so maybe that's something for a separate patch later...

I don't think so for the general registers
The "volatile" registers are lost during a C call, so it is the duty of 
the caller to save them before the call, if he wants, and this is 
possible for the programmer or the compiler to arrange that.

For interruptions, we steal the CPU with all the registers from the 
program without warning, the program has no possibility to save them.
So we must save all registers for him.

For the FP registers, we surely can do something if we establish a usage 
convention on the floating point.
A few tests need hardware floating point.

If IRQ speed or stack size becomes an issue we can think about 
optimizing the floating point usage.

> 
> Acked-by: Thomas Huth <thuth@redhat.com>
> 

Thanks,

Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
