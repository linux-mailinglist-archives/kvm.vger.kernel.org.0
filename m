Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A7B1F1CD1
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 18:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730399AbgFHQFR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 12:05:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50498 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730333AbgFHQFP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Jun 2020 12:05:15 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 058G4nGU019559;
        Mon, 8 Jun 2020 12:05:13 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31hrbggady-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 12:05:08 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 058G51SF020821;
        Mon, 8 Jun 2020 12:05:05 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31hrbgga0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 12:05:05 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 058FpXiB025497;
        Mon, 8 Jun 2020 16:03:08 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 31g2s7v9rg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 16:03:08 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 058G36eP53739620
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Jun 2020 16:03:06 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 175FB42045;
        Mon,  8 Jun 2020 16:03:06 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BAA494203F;
        Mon,  8 Jun 2020 16:03:05 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.43.245])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Jun 2020 16:03:05 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v8 03/12] s390x: saving regs for interrupts
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1591603981-16879-1-git-send-email-pmorel@linux.ibm.com>
 <1591603981-16879-4-git-send-email-pmorel@linux.ibm.com>
 <d4f1167c-5e44-f69c-8aac-f792a2a50ca7@redhat.com>
 <cde77b21-7fbb-bd09-bd3d-f77c5bd2a088@linux.ibm.com>
 <dc936814-13b3-c310-f0b1-1bec47c042b2@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <489ec992-0fa9-031e-746b-f213daecf0c1@linux.ibm.com>
Date:   Mon, 8 Jun 2020 18:03:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <dc936814-13b3-c310-f0b1-1bec47c042b2@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-08_14:2020-06-08,2020-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 suspectscore=0 phishscore=0 cotscore=-2147483648 lowpriorityscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 impostorscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006080115
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-06-08 17:29, Thomas Huth wrote:
> On 08/06/2020 16.24, Pierre Morel wrote:
>>
>>
>> On 2020-06-08 11:05, Thomas Huth wrote:
>>> On 08/06/2020 10.12, Pierre Morel wrote:
>>>> If we use multiple source of interrupts, for example, using SCLP
>>>> console to print information while using I/O interrupts, we need
>>>> to have a re-entrant register saving interruption handling.
>>>>
>>>> Instead of saving at a static memory address, let's save the base
>>>> registers, the floating point registers and the floating point
>>>> control register on the stack in case of I/O interrupts
>>>>
>>>> Note that we keep the static register saving to recover from the
>>>> RESET tests.
>>>>
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> Acked-by: Janosch Frank <frankja@linux.ibm.com>
>>>> ---
>>>>    s390x/cstart64.S | 41 +++++++++++++++++++++++++++++++++++++++--
>>>>    1 file changed, 39 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
>>>> index b50c42c..a9d8223 100644
>>>> --- a/s390x/cstart64.S
>>>> +++ b/s390x/cstart64.S
>>>> @@ -119,6 +119,43 @@ memsetxc:
>>>>        lmg    %r0, %r15, GEN_LC_SW_INT_GRS
>>>>        .endm
>>>>    +/* Save registers on the stack (r15), so we can have stacked
>>>> interrupts. */
>>>> +    .macro SAVE_REGS_STACK
>>>> +    /* Allocate a stack frame for 15 general registers */
>>>> +    slgfi   %r15, 15 * 8
>>>> +    /* Store registers r0 to r14 on the stack */
>>>> +    stmg    %r0, %r14, 0(%r15)
>>>> +    /* Allocate a stack frame for 16 floating point registers */
>>>> +    /* The size of a FP register is the size of an double word */
>>>> +    slgfi   %r15, 16 * 8
>>>> +    /* Save fp register on stack: offset to SP is multiple of reg
>>>> number */
>>>> +    .irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
>>>> +    std    \i, \i * 8(%r15)
>>>> +    .endr
>>>> +    /* Save fpc, but keep stack aligned on 64bits */
>>>> +    slgfi   %r15, 8
>>>> +    efpc    %r0
>>>> +    stg    %r0, 0(%r15)
>>>> +    .endm
>>>
>>> I wonder whether it would be sufficient to only save the registers here
>>> that are "volatile" according to the ELF ABI? ... that would save quite
>>> some space on the stack, I think... OTOH, the old code was also saving
>>> all registers, so maybe that's something for a separate patch later...
>>
>> I don't think so for the general registers
>> The "volatile" registers are lost during a C call, so it is the duty of
>> the caller to save them before the call, if he wants, and this is
>> possible for the programmer or the compiler to arrange that.
>>
>> For interruptions, we steal the CPU with all the registers from the
>> program without warning, the program has no possibility to save them.
>> So we must save all registers for him.
> 
> We certainly have to save the registers that are marked as "volatile" in
> the ELF ABI, no discussion. But what about the others? If we do not
> touch them in the assembler code, and just jump to a C function, the C
> function will save them before changing them, and restore the old value
> before returning. So when the interrupt is done, the registers should
> contain their original values again, shouldn't they?

Sorry, did not read correctly.
Yes you are right, saving the "volatile" registers would be enough for 
the general and the FP registers.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
