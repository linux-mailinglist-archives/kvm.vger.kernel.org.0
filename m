Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25EF732D73D
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 16:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236079AbhCDP6N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 10:58:13 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10204 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236069AbhCDP56 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Mar 2021 10:57:58 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 124FYouP068636;
        Thu, 4 Mar 2021 10:57:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=AKqoZtsDoQGQTBosfrW0wdrcw9zm6T5fsz25Clb2/vU=;
 b=fI8FU3LhiEMe/75HqYCySaiKO2xbUbG1MVF/0SLUN4yUHJszkxeS+ayk9KbpQakbttOZ
 RsjFonaHAKdeR5z2FrxqvmiqtnqgxgSRB0eJ2NzhODkDVejfy2lNkHFPJdr5H3vz719P
 02FclyXORtNuleufx6aX4ho40HmIOjtSf2YBWjNAqO9Z7oXCQfWJhi43ZNlpoJ1YUSIR
 Ak8+dDiKEv0F+Vjpj+of+W0kE76H8gdGamYBZUHNPjysvVfqV3Egly/18GmCmUJZ+mSi
 +rXzXhgxgL1Lunr+ERoKmnuceJw/zhru0elAISO2akWI7lCqTldt+fve3gcSlR/L2mSP eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37328tsn8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Mar 2021 10:57:18 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 124FYvjq069218;
        Thu, 4 Mar 2021 10:57:17 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37328tsn6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Mar 2021 10:57:17 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 124Fpc40026790;
        Thu, 4 Mar 2021 15:57:15 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3712fmjwav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Mar 2021 15:57:15 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 124FvCXA51183950
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Mar 2021 15:57:12 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F446AE05A;
        Thu,  4 Mar 2021 15:57:12 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F320AAE057;
        Thu,  4 Mar 2021 15:57:11 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.34.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  4 Mar 2021 15:57:11 +0000 (GMT)
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        pmorel@linux.ibm.com, david@redhat.com
References: <20210222085756.14396-1-frankja@linux.ibm.com>
 <20210222085756.14396-3-frankja@linux.ibm.com>
 <b1ecb478-e559-bb3d-b69f-3f2b4f72ddee@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 2/7] s390x: Fully commit to stack save
 area for exceptions
Message-ID: <d52c945c-b634-4f8b-9264-d63595eb6c5c@linux.ibm.com>
Date:   Thu, 4 Mar 2021 16:57:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <b1ecb478-e559-bb3d-b69f-3f2b4f72ddee@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-04_05:2021-03-03,2021-03-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 priorityscore=1501
 malwarescore=0 clxscore=1015 bulkscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103040075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/21 12:37 PM, Thomas Huth wrote:
> On 22/02/2021 09.57, Janosch Frank wrote:
>> Having two sets of macros for saving registers on exceptions makes
>> maintaining harder. Also we have limited space in the lowcore to save
>> stuff and by using the stack as a save area, we can stack exceptions.
>>
>> So let's use the SAVE/RESTORE_REGS_STACK as the default. When we also
>> move the diag308 macro over we can remove the old SAVE/RESTORE_REGS
>> macros.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>> ---
> [...]
>> diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
>> index 1a2e2cd8..31e4766d 100644
>> --- a/lib/s390x/asm/interrupt.h
>> +++ b/lib/s390x/asm/interrupt.h
>> @@ -14,8 +14,8 @@
>>   #define EXT_IRQ_SERVICE_SIG	0x2401
>>   
>>   void register_pgm_cleanup_func(void (*f)(void));
>> -void handle_pgm_int(void);
>> -void handle_ext_int(void);
>> +void handle_pgm_int(struct stack_frame_int *stack);
>> +void handle_ext_int(struct stack_frame_int *stack);
>>   void handle_mcck_int(void);
>>   void handle_io_int(void);
> 
> So handle_io_int() does not get a *stack parameter here...
> 
>>   void handle_svc_int(void);
>> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
>> index 1ce36073..a59df80e 100644
>> --- a/lib/s390x/interrupt.c
>> +++ b/lib/s390x/interrupt.c
>> @@ -56,7 +56,7 @@ void register_pgm_cleanup_func(void (*f)(void))
>>   	pgm_cleanup_func = f;
>>   }
>>   
>> -static void fixup_pgm_int(void)
>> +static void fixup_pgm_int(struct stack_frame_int *stack)
>>   {
>>   	/* If we have an error on SIE we directly move to sie_exit */
>>   	if (lc->pgm_old_psw.addr >= (uint64_t)&sie_entry &&
>> @@ -76,7 +76,7 @@ static void fixup_pgm_int(void)
>>   		/* Handling for iep.c test case. */
>>   		if (lc->trans_exc_id & 0x80UL && lc->trans_exc_id & 0x04UL &&
>>   		    !(lc->trans_exc_id & 0x08UL))
>> -			lc->pgm_old_psw.addr = lc->sw_int_grs[14];
>> +			lc->pgm_old_psw.addr = stack->grs0[12];
> 
> I'd maybe put a "/* GR14 */" comment at the end of the line, to make it more 
> obvious which register we're aiming here at.

Will do although I'd like to extend it a bit:

/*



* We branched to the instruction that caused



* the exception so we can use the return



* address in GR14 to jump back and continue



* executing test code.



*/

> 
>>   		break;
>>   	case PGM_INT_CODE_SEGMENT_TRANSLATION:
>>   	case PGM_INT_CODE_PAGE_TRANSLATION:
>> @@ -115,7 +115,7 @@ static void fixup_pgm_int(void)
>>   	/* suppressed/terminated/completed point already at the next address */
>>   }
>>   
>> -void handle_pgm_int(void)
>> +void handle_pgm_int(struct stack_frame_int *stack)
>>   {
>>   	if (!pgm_int_expected) {
>>   		/* Force sclp_busy to false, otherwise we will loop forever */
>> @@ -130,10 +130,10 @@ void handle_pgm_int(void)
>>   	if (pgm_cleanup_func)
>>   		(*pgm_cleanup_func)();
>>   	else
>> -		fixup_pgm_int();
>> +		fixup_pgm_int(stack);
>>   }
>>   
>> -void handle_ext_int(void)
>> +void handle_ext_int(struct stack_frame_int *stack)
>>   {
>>   	if (!ext_int_expected &&
>>   	    lc->ext_int_code != EXT_IRQ_SERVICE_SIG) {
>> @@ -143,13 +143,13 @@ void handle_ext_int(void)
>>   	}
>>   
>>   	if (lc->ext_int_code == EXT_IRQ_SERVICE_SIG) {
>> -		lc->sw_int_crs[0] &= ~(1UL << 9);
>> +		stack->crs[0] &= ~(1UL << 9);
>>   		sclp_handle_ext();
>>   	} else {
>>   		ext_int_expected = false;
>>   	}
>>   
>> -	if (!(lc->sw_int_crs[0] & CR0_EXTM_MASK))
>> +	if (!(stack->crs[0] & CR0_EXTM_MASK))
>>   		lc->ext_old_psw.mask &= ~PSW_MASK_EXT;
>>   }
>>   
>> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
>> index ace0c0d9..35d20293 100644
>> --- a/s390x/cstart64.S
>> +++ b/s390x/cstart64.S
>> @@ -92,33 +92,36 @@ memsetxc:
>>   
>>   .section .text
>>   pgm_int:
>> -	SAVE_REGS
>> +	SAVE_REGS_STACK
>> +	lgr     %r2, %r15
>>   	brasl	%r14, handle_pgm_int
>> -	RESTORE_REGS
>> +	RESTORE_REGS_STACK
>>   	lpswe	GEN_LC_PGM_OLD_PSW
>>   
>>   ext_int:
>> -	SAVE_REGS
>> +	SAVE_REGS_STACK
>> +	lgr     %r2, %r15
>>   	brasl	%r14, handle_ext_int
>> -	RESTORE_REGS
>> +	RESTORE_REGS_STACK
>>   	lpswe	GEN_LC_EXT_OLD_PSW
>>   
>>   mcck_int:
>> -	SAVE_REGS
>> +	SAVE_REGS_STACK
>>   	brasl	%r14, handle_mcck_int
>> -	RESTORE_REGS
>> +	RESTORE_REGS_STACK
>>   	lpswe	GEN_LC_MCCK_OLD_PSW
>>   
>>   io_int:
>>   	SAVE_REGS_STACK
>> +	lgr     %r2, %r15
> 
> ... and here you're passing the stack pointer as a parameter, though 
> handle_io_int() does not use it... well, ok, it gets reworked again in the 
> next patch, but maybe you could still remove the above line when picking up 
> the patch?

Sure, I just fixed that up

> 
> Anyway:
> Acked-by: Thomas Huth <thuth@redhat.com>
> 
Thanks!
