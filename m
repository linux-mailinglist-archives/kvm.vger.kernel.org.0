Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6832731E848
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 10:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbhBRJiz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 04:38:55 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30430 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231681AbhBRJRM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Feb 2021 04:17:12 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11I90c4b021082;
        Thu, 18 Feb 2021 04:16:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=dxmvx7YuWtrUEiTgdTg0V3r4mxxeH28zSHx5em9VkJY=;
 b=agq6ydc0fCS5auFqTDo5qcmpsWs8YnAODYANBtsP/Qx81PGXGgS65yLlL9jMd/MLMdis
 iDDj6A476hrprN3k8tkFqql4l9Ke1p3APQHEaceQUWr6Qcc0dw2sVsgfZzAlpg3v0+Lz
 ldIhtFT+5SwCBv4mSjiDZX/CoiQUgdPebBL1xNP96Z7xn5VirwLMjcSGJBYZtWffaU9L
 n0x9yUAuOYnl8RmVqBGmxVpYPImYzw25tpaJt+Q6KAwskO6IfTY5OHsE0TcRJ7wRjdsv
 nizb6Vtpg/QGroD0GEof5ZRAFpEwNCAmuPHB/4WqUOGhyjqQdKMo/gcYSqd2ph3U7v/P mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36smxnh1hu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Feb 2021 04:16:10 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11I90flX021444;
        Thu, 18 Feb 2021 04:16:10 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36smxnh1h7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Feb 2021 04:16:10 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11I9CSU0002639;
        Thu, 18 Feb 2021 09:16:08 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 36p6d8aadd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Feb 2021 09:16:08 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11I9G5v216712154
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Feb 2021 09:16:05 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C3F311C06C;
        Thu, 18 Feb 2021 09:16:04 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 546E511C052;
        Thu, 18 Feb 2021 09:16:04 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.170.241])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Feb 2021 09:16:04 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 4/8] s390x: Introduce and use
 CALL_INT_HANDLER macro
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        pmorel@linux.ibm.com, david@redhat.com
References: <20210217144116.3368-1-frankja@linux.ibm.com>
 <20210217144116.3368-5-frankja@linux.ibm.com>
 <313546fb-35df-22ab-79f8-d5b49286058f@redhat.com>
 <8f95d948-a814-92ab-91f5-52424a53a28b@linux.ibm.com>
 <bf4f49dd-5255-91c6-5a65-4d346d7d2701@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <1ff30077-ec0c-7bee-3770-d0ff0f4593a9@linux.ibm.com>
Date:   Thu, 18 Feb 2021 10:16:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <bf4f49dd-5255-91c6-5a65-4d346d7d2701@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-18_03:2021-02-18,2021-02-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180071
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/17/21 6:03 PM, Thomas Huth wrote:
> On 17/02/2021 17.22, Janosch Frank wrote:
>> On 2/17/21 4:55 PM, Thomas Huth wrote:
>>> On 17/02/2021 15.41, Janosch Frank wrote:
>>>> The ELF ABI dictates that we need to allocate 160 bytes of stack space
>>>> for the C functions we're calling. Since we would need to do that for
>>>> every interruption handler which, combined with the new stack argument
>>>> being saved in GR2, makes cstart64.S look a bit messy.
>>>>
>>>> So let's introduce the CALL_INT_HANDLER macro that handles all of
>>>> that, calls the C interrupt handler and handles cleanup afterwards.
>>>>
>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>> ---
>>>>    s390x/cstart64.S | 28 +++++-----------------------
>>>>    s390x/macros.S   | 17 +++++++++++++++++
>>>>    2 files changed, 22 insertions(+), 23 deletions(-)
>>>>
>>>> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
>>>> index 35d20293..666a9567 100644
>>>> --- a/s390x/cstart64.S
>>>> +++ b/s390x/cstart64.S
>>>> @@ -92,37 +92,19 @@ memsetxc:
>>>>    
>>>>    .section .text
>>>>    pgm_int:
>>>> -	SAVE_REGS_STACK
>>>> -	lgr     %r2, %r15
>>>> -	brasl	%r14, handle_pgm_int
>>>> -	RESTORE_REGS_STACK
>>>> -	lpswe	GEN_LC_PGM_OLD_PSW
>>>> +	CALL_INT_HANDLER handle_pgm_int, GEN_LC_PGM_OLD_PSW
>>>>    
>>>>    ext_int:
>>>> -	SAVE_REGS_STACK
>>>> -	lgr     %r2, %r15
>>>> -	brasl	%r14, handle_ext_int
>>>> -	RESTORE_REGS_STACK
>>>> -	lpswe	GEN_LC_EXT_OLD_PSW
>>>> +	CALL_INT_HANDLER handle_ext_int, GEN_LC_EXT_OLD_PSW
>>>>    
>>>>    mcck_int:
>>>> -	SAVE_REGS_STACK
>>>> -	brasl	%r14, handle_mcck_int
>>>> -	RESTORE_REGS_STACK
>>>> -	lpswe	GEN_LC_MCCK_OLD_PSW
>>>> +	CALL_INT_HANDLER handle_mcck_int, GEN_LC_MCCK_OLD_PSW
>>>>    
>>>>    io_int:
>>>> -	SAVE_REGS_STACK
>>>> -	lgr     %r2, %r15
>>>> -	brasl	%r14, handle_io_int
>>>> -	RESTORE_REGS_STACK
>>>> -	lpswe	GEN_LC_IO_OLD_PSW
>>>> +	CALL_INT_HANDLER handle_io_int, GEN_LC_IO_OLD_PSW
>>>>    
>>>>    svc_int:
>>>> -	SAVE_REGS_STACK
>>>> -	brasl	%r14, handle_svc_int
>>>> -	RESTORE_REGS_STACK
>>>> -	lpswe	GEN_LC_SVC_OLD_PSW
>>>> +	CALL_INT_HANDLER handle_svc_int, GEN_LC_SVC_OLD_PSW
>>>>    
>>>>    	.align	8
>>>>    initial_psw:
>>>> diff --git a/s390x/macros.S b/s390x/macros.S
>>>> index a7d62c6f..212a3823 100644
>>>> --- a/s390x/macros.S
>>>> +++ b/s390x/macros.S
>>>> @@ -11,6 +11,23 @@
>>>>     *  David Hildenbrand <david@redhat.com>
>>>>     */
>>>>    #include <asm/asm-offsets.h>
>>>> +/*
>>>> + * Exception handler macro that saves registers on the stack,
>>>> + * allocates stack space and calls the C handler function. Afterwards
>>>> + * we re-load the registers and load the old PSW.
>>>> + */
>>>> +	.macro CALL_INT_HANDLER c_func, old_psw
>>>> +	SAVE_REGS_STACK
>>>> +	/* Save the stack address in GR2 which is the first function argument */
>>>> +	lgr     %r2, %r15
>>>> +	/* Allocate stack pace for called C function, as specified in s390 ELF ABI */
>>>> +	slgfi   %r15, 160
>>>
>>> By the way, don't you have to store a back chain pointer at the bottom of
>>> that area, too, if you want to use -mbackchoin in the next patch?
>>
>> Don't I already do that in #2?
> 
> You do it in the SAVE_REGS_STACK patch, yes. But not on the bottom of the 
> new 160 bytes stack frame that you've added here. But I guess it doesn't 
> really matter for your back traces, since you load %r2 with %r15 before 
> decrementing the stack by 160, so this new stack frame simply gets ignored 
> anyway.
> 
>   Thomas
> 

Right, I'm currently fixing that up for the next version.

diff --git i/s390x/macros.S w/s390x/macros.S
index b4275c77..13cff299 100644
--- i/s390x/macros.S
+++ w/s390x/macros.S
@@ -22,6 +22,11 @@
        lgr     %r2, %r15
        /* Allocate stack space for called C function, as specified in
s390 ELF ABI */
        slgfi   %r15, 160
+       /*
+        * Save the address of the interrupt stack into the back chain
+        * of the called function.
+        */
+       stg     %r2, STACK_FRAME_INT_BACKCHAIN(%r15)
        brasl   %r14, \c_func
        algfi   %r15, 160
        RESTORE_REGS_STACK

