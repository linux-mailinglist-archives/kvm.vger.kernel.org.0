Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC98B2DD410
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 16:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbgLQPXQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 10:23:16 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63820 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727660AbgLQPXK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Dec 2020 10:23:10 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BHF4YUk053875;
        Thu, 17 Dec 2020 10:22:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bmL7bCFaAzT3jIiq+4dXJEEOEdKqThx8q0/0h5VoeME=;
 b=S3kz+zzDPMXvNWJuUTtu9Iehuu1I8P/4RG+yxmFRCAk6wa6cEeXX87umGIRPXDUoUm3F
 /RpwGgaYW0QLuq06yzlkWShuyhmx7vBeprKbvx0uD2U2xfakNUmWRmu4vAX4WEXq+HIh
 KHKa7YObrQ4cHTWrRPpBD4mlpf81Bh/JrCR8pfC2ox6qyedNjEwluEsH5BOTHxzXhJRc
 b4t3hsyaoFcBkSNe/5otZZe4h0B2NZxZCzmFRHnh+gX03Z6hZoAgLBSlU7psWDYg6aRA
 GWxmPGo6VRH454wKW37zyvFFZhZ+6WBnv6A0yyLkpnEtS4c8fsRFQTjTNiU8lqr0SBhG BQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35g8x8sqj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 10:22:27 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BHF4gE9054203;
        Thu, 17 Dec 2020 10:22:25 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35g8x8sqhg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 10:22:25 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BHF7pEl015459;
        Thu, 17 Dec 2020 15:22:23 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 35cng85g6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 15:22:23 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BHFMKCf38273410
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 15:22:20 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71F9642047;
        Thu, 17 Dec 2020 15:22:20 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19AE542049;
        Thu, 17 Dec 2020 15:22:20 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.181.71])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Dec 2020 15:22:20 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 4/8] s390x: Split assembly and move to
 s390x/asm/
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
References: <20201211100039.63597-1-frankja@linux.ibm.com>
 <20201211100039.63597-5-frankja@linux.ibm.com>
 <20201217141421.7179e19d@ibm-vm>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <514a4281-1c71-29aa-0fe7-a7ae5889dddf@linux.ibm.com>
Date:   Thu, 17 Dec 2020 16:22:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201217141421.7179e19d@ibm-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-17_10:2020-12-15,2020-12-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 adultscore=0 priorityscore=1501 spamscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012170106
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/17/20 2:14 PM, Claudio Imbrenda wrote:
> On Fri, 11 Dec 2020 05:00:35 -0500
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> I've added too much to cstart64.S which is not start related
>> already. Now that I want to add even more code it's time to split
>> cstart64.S. lib.S has functions that are used in tests. macros.S
>> contains macros which are used in cstart64.S and lib.S
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  s390x/Makefile             |   8 +--
>>  s390x/{ => asm}/cstart64.S | 119
>> ++----------------------------------- s390x/asm/lib.S            |
>> 65 ++++++++++++++++++++ s390x/asm/macros.S         |  77
>> ++++++++++++++++++++++++ 4 files changed, 150 insertions(+), 119
>> deletions(-) rename s390x/{ => asm}/cstart64.S (50%)
>>  create mode 100644 s390x/asm/lib.S
>>  create mode 100644 s390x/asm/macros.S 
> 
> [...]
> 
>> diff --git a/s390x/cstart64.S b/s390x/asm/cstart64.S
>> similarity index 50%
>> rename from s390x/cstart64.S
>> rename to s390x/asm/cstart64.S
>> index cc86fc7..ace0c0d 100644
>> --- a/s390x/cstart64.S
>> +++ b/s390x/asm/cstart64.S
>> @@ -3,14 +3,17 @@
>>   * s390x startup code
>>   *
>>   * Copyright (c) 2017 Red Hat Inc
>> + * Copyright (c) 2019 IBM Corp.
> 
> 2020 ?

Moving stuff changes the copyright?

> 
>>   *
>>   * Authors:
>>   *  Thomas Huth <thuth@redhat.com>
>>   *  David Hildenbrand <david@redhat.com>
>> + *  Janosch Frank <frankja@linux.ibm.com>
>>   */
>>  #include <asm/asm-offsets.h>
>>  #include <asm/sigp.h>
> 
> [...]
> 
>> diff --git a/s390x/asm/lib.S b/s390x/asm/lib.S
>> new file mode 100644
>> index 0000000..4d78ec6
>> --- /dev/null
>> +++ b/s390x/asm/lib.S
>> @@ -0,0 +1,65 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * s390x assembly library
>> + *
>> + * Copyright (c) 2019 IBM Corp.
> 
> also 2020?
> 
>> + *
>> + * Authors:
>> + *    Janosch Frank <frankja@linux.ibm.com>
>> + */
>> +#include <asm/asm-offsets.h>
>> +#include <asm/sigp.h>
>> +
>> +#include "macros.S"
>> +
>> +/*
>> + * load_reset calling convention:
>> + * %r2 subcode (0 or 1)
>> + */
>> +.globl diag308_load_reset
>> +diag308_load_reset:
>> +	SAVE_REGS
>> +	/* Backup current PSW mask, as we have to restore it on
>> success */
>> +	epsw	%r0, %r1
>> +	st	%r0, GEN_LC_SW_INT_PSW
>> +	st	%r1, GEN_LC_SW_INT_PSW + 4
>> +	/* Load reset psw mask (short psw, 64 bit) */
>> +	lg	%r0, reset_psw
>> +	/* Load the success label address */
>> +	larl    %r1, 0f
>> +	/* Or it to the mask */
>> +	ogr	%r0, %r1
>> +	/* Store it at the reset PSW location (real 0x0) */
>> +	stg	%r0, 0
>> +	/* Do the reset */
>> +	diag    %r0,%r2,0x308
>> +	/* Failure path */
>> +	xgr	%r2, %r2
>> +	br	%r14
>> +	/* Success path */
>> +	/* load a cr0 that has the AFP control bit which enables all
>> FPRs */ +0:	larl	%r1, initial_cr0
>> +	lctlg	%c0, %c0, 0(%r1)
>> +	RESTORE_REGS
>> +	lhi	%r2, 1
>> +	larl	%r0, 1f
>> +	stg	%r0, GEN_LC_SW_INT_PSW + 8
>> +	lpswe	GEN_LC_SW_INT_PSW
>> +1:	br	%r14
>> +
>> +/* Sets up general registers and cr0 when a new cpu is brought
>> online. */ +.globl smp_cpu_setup_state
>> +smp_cpu_setup_state:
>> +	xgr	%r1, %r1
>> +	lmg     %r0, %r15, GEN_LC_SW_INT_GRS
>> +	lctlg   %c0, %c0, GEN_LC_SW_INT_CRS
>> +	/* We should only go once through cpu setup and not for
>> every restart */
>> +	stg	%r14, GEN_LC_RESTART_NEW_PSW + 8
>> +	larl	%r14, 0f
>> +	lpswe	GEN_LC_SW_INT_PSW
>> +	/* If the function returns, just loop here */
>> +0:	j	0
>> +
>> +	.align	8
>> +reset_psw:
>> +	.quad	0x0008000180000000
>> diff --git a/s390x/asm/macros.S b/s390x/asm/macros.S
>> new file mode 100644
>> index 0000000..37a6a63
>> --- /dev/null
>> +++ b/s390x/asm/macros.S
>> @@ -0,0 +1,77 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * s390x assembly macros
>> + *
>> + * Copyright (c) 2017 Red Hat Inc
>> + * Copyright (c) 2020 IBM Corp.
>> + *
>> + * Authors:
>> + *  Pierre Morel <pmorel@linux.ibm.com>
>> + *  David Hildenbrand <david@redhat.com>
>> + */
>> +#include <asm/asm-offsets.h>
>> +	.macro SAVE_REGS
>> +	/* save grs 0-15 */
>> +	stmg	%r0, %r15, GEN_LC_SW_INT_GRS
>> +	/* save crs 0-15 */
>> +	stctg	%c0, %c15, GEN_LC_SW_INT_CRS
>> +	/* load a cr0 that has the AFP control bit which enables all
>> FPRs */
>> +	larl	%r1, initial_cr0
>> +	lctlg	%c0, %c0, 0(%r1)
>> +	/* save fprs 0-15 + fpc */
>> +	la	%r1, GEN_LC_SW_INT_FPRS
>> +	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
>> +	std	\i, \i * 8(%r1)
>> +	.endr
>> +	stfpc	GEN_LC_SW_INT_FPC
>> +	.endm
>> +
>> +	.macro RESTORE_REGS
>> +	/* restore fprs 0-15 + fpc */
>> +	la	%r1, GEN_LC_SW_INT_FPRS
>> +	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
>> +	ld	\i, \i * 8(%r1)
>> +	.endr
>> +	lfpc	GEN_LC_SW_INT_FPC
>> +	/* restore crs 0-15 */
>> +	lctlg	%c0, %c15, GEN_LC_SW_INT_CRS
>> +	/* restore grs 0-15 */
>> +	lmg	%r0, %r15, GEN_LC_SW_INT_GRS
>> +	.endm
>> +
>> +/* Save registers on the stack (r15), so we can have stacked
>> interrupts. */
>> +	.macro SAVE_REGS_STACK
>> +	/* Allocate a stack frame for 15 general registers */
>> +	slgfi   %r15, 15 * 8
>> +	/* Store registers r0 to r14 on the stack */
>> +	stmg    %r0, %r14, 0(%r15)
>> +	/* Allocate a stack frame for 16 floating point registers */
>> +	/* The size of a FP register is the size of an double word */
>> +	slgfi   %r15, 16 * 8
>> +	/* Save fp register on stack: offset to SP is multiple of
>> reg number */
>> +	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
>> +	std	\i, \i * 8(%r15)
>> +	.endr
>> +	/* Save fpc, but keep stack aligned on 64bits */
>> +	slgfi   %r15, 8
>> +	efpc	%r0
>> +	stg	%r0, 0(%r15)
>> +	.endm
>> +
>> +/* Restore the register in reverse order */
>> +	.macro RESTORE_REGS_STACK
>> +	/* Restore fpc */
>> +	lfpc	0(%r15)
>> +	algfi	%r15, 8
>> +	/* Restore fp register from stack: SP still where it was
>> left */
>> +	/* and offset to SP is a multiple of reg number */
>> +	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
>> +	ld	\i, \i * 8(%r15)
>> +	.endr
>> +	/* Now that we're done, rewind the stack pointer by 16
>> double word */
>> +	algfi   %r15, 16 * 8
>> +	/* Load the registers from stack */
>> +	lmg     %r0, %r14, 0(%r15)
>> +	/* Rewind the stack by 15 double word */
>> +	algfi   %r15, 15 * 8
>> +	.endm
> 

