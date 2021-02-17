Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5654631DDBB
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 17:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234301AbhBQQzm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 11:55:42 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8536 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234295AbhBQQzW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Feb 2021 11:55:22 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11HGXPx3151751;
        Wed, 17 Feb 2021 11:54:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=KkJnK7zScpiaGUaDLPE8lcA/hm9eFLtZafdRMso+fgY=;
 b=NGqyLoXQOw++YaeUSQy5RXSR77pn07tpbC7D8jhrY8fmPevOoHhScqu6T5HV0KAy1Tuf
 Jq02jmVGo8HJEdjowRzgcawlAPJk+aWQ6Dkfg39qWWyNu7ZNNYRHQtk4rv9CJaws5cuf
 fTiqw2M+Q+fTeTJZfK2BY/9HQQDeIrRT4ULAsPBabzSOxsX1LZSqX97VNJR5IlR7bC6u
 0EFohKB5PoRfeNmO3geFS0iLeOnIgyAVR7EU7MoZgesD5Q2o8MTF38TOxocuURLwIJW1
 9fC79VfTfmoNI2HW26tg7LXM2AipDZF/ZfzKUzu4TIEMwOw1O4Xk0ldxjAfGsmzG8q6b ZA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36s5rfb249-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 11:54:41 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11HGZ0XS157109;
        Wed, 17 Feb 2021 11:54:41 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36s5rfb233-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 11:54:40 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11HGkh0W017182;
        Wed, 17 Feb 2021 16:54:38 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 36p6d8j12q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 16:54:38 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11HGsZNI51118474
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 16:54:35 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A697D52050;
        Wed, 17 Feb 2021 16:54:35 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.1.64])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 4F9595204E;
        Wed, 17 Feb 2021 16:54:35 +0000 (GMT)
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        pmorel@linux.ibm.com, david@redhat.com
References: <20210217144116.3368-1-frankja@linux.ibm.com>
 <20210217144116.3368-3-frankja@linux.ibm.com>
 <338944d9-9135-185e-829f-4f202b632a5b@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 2/8] s390x: Fully commit to stack save
 area for exceptions
Message-ID: <e1029f47-8728-0145-335a-335cfd389d56@linux.ibm.com>
Date:   Wed, 17 Feb 2021 17:54:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <338944d9-9135-185e-829f-4f202b632a5b@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-17_13:2021-02-16,2021-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 adultscore=0 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0
 mlxscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170124
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/17/21 4:35 PM, Thomas Huth wrote:
> On 17/02/2021 15.41, Janosch Frank wrote:
>> Having two sets of macros for saving registers on exceptions makes
>> maintaining harder. Also we have limited space in the lowcore to save
>> stuff and by using the stack as a save area, we can stack exceptions.
>>
>> So let's use the SAVE/RESTORE_REGS_STACK as the default. When we also
>> move the diag308 macro over we can remove the old SAVE/RESTORE_REGS
>> macros.
> [...]
>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>> index 9c4e330a..31c2fc66 100644
>> --- a/lib/s390x/asm/arch_def.h
>> +++ b/lib/s390x/asm/arch_def.h
>> @@ -8,13 +8,30 @@
>>   #ifndef _ASM_S390X_ARCH_DEF_H_
>>   #define _ASM_S390X_ARCH_DEF_H_
>>   
>> -/*
>> - * We currently only specify the stack frame members needed for the
>> - * SIE library code.
>> - */
>>   struct stack_frame {
>> -	unsigned long back_chain;
>> -	unsigned long empty1[5];
>> +	struct stack_frame *back_chain;
>> +	u64 reserved;
>> +	/* GRs 2 - 5 */
>> +	unsigned long argument_area[4];
>> +	/* GRs 6 - 15 */
>> +	unsigned long grs[10];
>> +	/* FPRs 0, 2, 4, 6 */
>> +	s64  fprs[4];
>> +};
> 
> For consistency, could you please replace the "unsigned long" with u64, or 
> even switch to uint64_t completely?
> 
> Currently, we have:
> 
> $ grep -r u64 lib/s390x/ | wc -l
> 8
> $ grep -r uint64 lib/s390x/ | wc -l
> 94
> 
> ... so uint64_t seems to be the better choice.

Hmm, I like the short kernel types, but okay I'll bow to the majority. :)

> 
>> +struct stack_frame_int {
>> +	struct stack_frame *back_chain;
>> +	u64 reserved;
>> +	/*
>> +	 * The GRs are offset compatible with struct stack_frame so we
>> +	 * can easily fetch GR14 for backtraces.
>> +	 */
>> +	u64 grs0[14];
>> +	u64 grs1[2];
> 
> Which registers go into grs0 and which ones into grs1? And why is there a 
> split at all? A comment would be really helpful!

I've added two comments one for each struct member.

> 
>> +	u32 res;
> 
> res = reserved? Please add a comment.

Yes
It's now 'reserved1'

> 
>> +	u32 fpc;
>> +	u64 fprs[16];
>> +	u64 crs[16];
>>   };
> 
> Similar, switch to uint32_t and uint64_t ?

Will do

> 
>> diff --git a/s390x/macros.S b/s390x/macros.S
>> index e51a557a..d7eeeb55 100644
>> --- a/s390x/macros.S
>> +++ b/s390x/macros.S
>> @@ -3,9 +3,10 @@
>>    * s390x assembly macros
>>    *
>>    * Copyright (c) 2017 Red Hat Inc
>> - * Copyright (c) 2020 IBM Corp.
>> + * Copyright (c) 2020, 2021 IBM Corp.
>>    *
>>    * Authors:
>> + *  Janosch Frank <frankja@linux.ibm.com>
>>    *  Pierre Morel <pmorel@linux.ibm.com>
>>    *  David Hildenbrand <david@redhat.com>
>>    */
>> @@ -41,36 +42,45 @@
>>   
>>   /* Save registers on the stack (r15), so we can have stacked interrupts. */
>>   	.macro SAVE_REGS_STACK
>> -	/* Allocate a stack frame for 15 general registers */
>> -	slgfi   %r15, 15 * 8
>> +	/* Allocate a full stack frame */
>> +	slgfi   %r15, 32 * 8 + 4 * 8
> 
> How did you come up with that number? That does neither match stack 
> stack_frame nor stack_frame_int, if I got this right. Please add a comment 
> to the code to explain the numbers.
> 
>>   	/* Store registers r0 to r14 on the stack */
>> -	stmg    %r0, %r14, 0(%r15)
>> -	/* Allocate a stack frame for 16 floating point registers */
>> -	/* The size of a FP register is the size of an double word */
>> -	slgfi   %r15, 16 * 8
>> +	stmg    %r2, %r15, STACK_FRAME_INT_GRS0(%r15)
> 
> Storing up to r14 should be sufficent since you store r15 again below?

Yes, but it also doesn't hurt.

> 
>> +	stg     %r0, STACK_FRAME_INT_GRS1(%r15)
>> +	stg     %r1, STACK_FRAME_INT_GRS1 + 8(%r15)
>> +	/* Store the gr15 value before we allocated the new stack */
>> +	lgr     %r0, %r15
>> +	algfi   %r0, 32 * 8 + 4 * 8
>> +	stg     %r0, 13 * 8 + STACK_FRAME_INT_GRS0(%r15)
>> +	stg     %r0, STACK_FRAME_INT_BACKCHAIN(%r15)
>> +	/*
>> +	 * Store CR0 and load initial CR0 so AFP is active and we can
>> +	 * access all fprs to save them.
>> +	 */
>> +	stctg   %c0,%c15,STACK_FRAME_INT_CRS(%r15)
>> +	larl	%r1, initial_cr0
>> +	lctlg	%c0, %c0, 0(%r1)
>>   	/* Save fp register on stack: offset to SP is multiple of reg number */
>>   	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
>> -	std	\i, \i * 8(%r15)
>> +	std	\i, \i * 8 + STACK_FRAME_INT_FPRS(%r15)
>>   	.endr
> 
> So you saved 16 GRs, 16 CRs and 16 FPRs onto the stack, that's at least 16 * 
> 3 * 8 = 48 * 8 bytes ... but you only decreased the stack by 32 * 8 + 4 * 8 
> bytes initially ... is this a bug, or do I miss something?
> 
>   Thomas
> 

After I fixed the CR problem I didn't touch this anymore and the offset
macro overwrote it anyway and fixed the problem so it still worked on tests.


I've squashed the next patch into this one so we should be fine.
