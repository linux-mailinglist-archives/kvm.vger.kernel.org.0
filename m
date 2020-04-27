Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7C01BA1B4
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 12:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgD0Ku7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 06:50:59 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55652 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726881AbgD0Ku6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Apr 2020 06:50:58 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03RAWJps128097
        for <kvm@vger.kernel.org>; Mon, 27 Apr 2020 06:50:58 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mh9m84wy-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 27 Apr 2020 06:50:57 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Mon, 27 Apr 2020 11:50:14 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 27 Apr 2020 11:50:11 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03RAopDP37486812
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 10:50:52 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2749AE04D;
        Mon, 27 Apr 2020 10:50:51 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98534AE045;
        Mon, 27 Apr 2020 10:50:51 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.191.241])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Apr 2020 10:50:51 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v6 01/10] s390x: saving regs for interrupts
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        thuth@redhat.com, cohuck@redhat.com
References: <1587725152-25569-1-git-send-email-pmorel@linux.ibm.com>
 <1587725152-25569-2-git-send-email-pmorel@linux.ibm.com>
 <6b8e4ce5-0c9c-6111-98e8-1c9e392d0a73@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Mon, 27 Apr 2020 12:50:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <6b8e4ce5-0c9c-6111-98e8-1c9e392d0a73@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20042710-0008-0000-0000-000003779D93
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042710-0009-0000-0000-00004A9973B2
Message-Id: <1945d109-e854-bdc4-4d95-147245a47abd@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_05:2020-04-24,2020-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 spamscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 mlxscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270091
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-04-27 10:59, David Hildenbrand wrote:
> On 24.04.20 12:45, Pierre Morel wrote:
>> If we use multiple source of interrupts, for example, using SCLP
>> console to print information while using I/O interrupts, we need
>> to have a re-entrant register saving interruption handling.
> 
> So the primary reason is to print during I/O interrupts (which we
> already do, but usually never trigger - handle_io_int())
> 
>>
>> Instead of saving at a static memory address, let's save the base
>> registers and the floating point registers on the stack.
> 
> ".. in case of I/O interrupts".

OK

> 
>>
>> Note that we keep the static register saving to recover from the
>> RESET tests.
> 
> and for all other types of interrupts.

OK

> 
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   s390x/cstart64.S | 34 ++++++++++++++++++++++++++++++++--
>>   1 file changed, 32 insertions(+), 2 deletions(-)
>>
>> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
>> index 9af6bb3..ba2e67c 100644
>> --- a/s390x/cstart64.S
>> +++ b/s390x/cstart64.S
>> @@ -118,6 +118,36 @@ memsetxc:
>>   	lmg	%r0, %r15, GEN_LC_SW_INT_GRS
>>   	.endm
>>   
>> +/* Save registers on the stack (r15), so we can have stacked interrupts. */
>> +	.macro SAVE_IRQ_REGS
> 
> s/SAVE_IRQ_REGS/SAVE_REGS_STACK/ ?
> 
> Same for the other macro.

OK

> 
>> +	/* Allocate a stack frame for 15 integer registers */
> 
> not integers. sizeof(int) == 4.

hum, yes, I just do not know from where I took the word "integer" here!.

> 
> "doublewords" should be the right s390x speak.

in fact they are named general registers in the POP.
(which indeed are doublewords :) )


> 
>> +	slgfi   %r15, 15 * 8
>> +	/* Store all registers from r0 to r14 on the stack */
>> +	stmg    %r0, %r14, 0(%r15)
>> +	/* Allocate a stack frame for 16 floating point registers */
>> +	/* The size of a FP register is the size of an integer */
>> +	slgfi   %r15, 16 * 8
>> +	/* Save fp register on stack: offset to SP is multiple of reg number */
>> +	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
>> +	std	\i, \i * 8(%r15)
>> +	.endr
>> +	.endm
> 
> What about the FPC?

Seems I forgot it.
I will update.
Thanks.

Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen

