Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99FA111CE66
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 14:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729484AbfLLNeN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 08:34:13 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25284 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729481AbfLLNeN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Dec 2019 08:34:13 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBCDWKIT059246
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2019 08:34:11 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wtf8k6htc-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2019 08:34:11 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Thu, 12 Dec 2019 13:34:09 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 12 Dec 2019 13:34:07 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBCDXOHd27394512
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 13:33:24 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5179CA4060;
        Thu, 12 Dec 2019 13:34:06 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12D87A405B;
        Thu, 12 Dec 2019 13:34:06 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.89])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 Dec 2019 13:34:06 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 2/9] s390x: Use PSW bits definitions in
 cstart
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
References: <1576079170-7244-1-git-send-email-pmorel@linux.ibm.com>
 <1576079170-7244-3-git-send-email-pmorel@linux.ibm.com>
 <41887741-3db0-5969-edb4-1f50e7b17da7@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Thu, 12 Dec 2019 14:34:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <41887741-3db0-5969-edb4-1f50e7b17da7@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19121213-0008-0000-0000-000003402435
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121213-0009-0000-0000-00004A60263B
Message-Id: <371eaf81-f433-e251-f69c-0ee3c404ffdb@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-12_03:2019-12-12,2019-12-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 phishscore=0
 mlxlogscore=999 impostorscore=0 mlxscore=0 spamscore=0 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912120103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019-12-12 10:31, Janosch Frank wrote:
> On 12/11/19 4:46 PM, Pierre Morel wrote:
>> This patch defines the PSW bits EA/BA used to initialize the PSW masks
>> for exceptions.
>>
>> Since some PSW mask definitions exist already in arch_def.h we add these
>> definitions there.
>> We move all PSW definitions together and protect assembler code against
>> C syntax.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/asm/arch_def.h | 16 ++++++++++++----
>>   s390x/cstart64.S         | 15 ++++++++-------
>>   2 files changed, 20 insertions(+), 11 deletions(-)
>>
>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>> index cf6e1ca..b6bb8c1 100644
>> --- a/lib/s390x/asm/arch_def.h
>> +++ b/lib/s390x/asm/arch_def.h
>> @@ -10,15 +10,22 @@
>>   #ifndef _ASM_S390X_ARCH_DEF_H_
>>   #define _ASM_S390X_ARCH_DEF_H_
>>   
>> +#define PSW_MASK_IO			0x0200000000000000UL
> 
> That's new and not used in this patch, please move it to the patch where
> it's needed.

OK, I can do this.

> 
>> +#define PSW_MASK_EXT			0x0100000000000000UL
>> +#define PSW_MASK_DAT			0x0400000000000000UL
>> +#define PSW_MASK_PSTATE			0x0001000000000000UL
>> +#define PSW_MASK_BA			0x0000000080000000UL
>> +#define PSW_MASK_EA			0x0000000100000000UL
>> +
>> +
>> +#define PSW_EXCEPTION_MASK (PSW_MASK_EA|PSW_MASK_BA)
>> +
>> +#ifndef __ASSEMBLER__
> 
> \n
> 

OK

>>   struct psw {
>>   	uint64_t	mask;
>>   	uint64_t	addr;
>>   };
>>   
>> -#define PSW_MASK_EXT			0x0100000000000000UL
>> -#define PSW_MASK_DAT			0x0400000000000000UL
>> -#define PSW_MASK_PSTATE			0x0001000000000000UL
>> -
>>   #define CR0_EXTM_SCLP			0X0000000000000200UL
>>   #define CR0_EXTM_EXTC			0X0000000000002000UL
>>   #define CR0_EXTM_EMGC			0X0000000000004000UL
>> @@ -272,3 +279,4 @@ static inline int stsi(void *addr, int fc, int sel1, int sel2)
>>   }
>>   
>>   #endif
>> +#endif
> 
> Please add a comment to which ifdef this endif belongs.
> 

OK

>> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
>> index ff05f9b..56a2045 100644
>> --- a/s390x/cstart64.S
>> +++ b/s390x/cstart64.S
>> @@ -12,6 +12,7 @@
>>    */
>>   #include <asm/asm-offsets.h>
>>   #include <asm/sigp.h>
>> +#include <asm/arch_def.h>
>>   
>>   .section .init
>>   
>> @@ -214,19 +215,19 @@ svc_int:
>>   
>>   	.align	8
>>   reset_psw:
>> -	.quad	0x0008000180000000
>> +	.quad	PSW_EXCEPTION_MASK
>>   initial_psw:
>> -	.quad	0x0000000180000000, clear_bss_start
>> +	.quad	PSW_EXCEPTION_MASK, clear_bss_start
>>   pgm_int_psw:
>> -	.quad	0x0000000180000000, pgm_int
>> +	.quad	PSW_EXCEPTION_MASK, pgm_int
>>   ext_int_psw:
>> -	.quad	0x0000000180000000, ext_int
>> +	.quad	PSW_EXCEPTION_MASK, ext_int
>>   mcck_int_psw:
>> -	.quad	0x0000000180000000, mcck_int
>> +	.quad	PSW_EXCEPTION_MASK, mcck_int
>>   io_int_psw:
>> -	.quad	0x0000000180000000, io_int
>> +	.quad	PSW_EXCEPTION_MASK, io_int
>>   svc_int_psw:
>> -	.quad	0x0000000180000000, svc_int
>> +	.quad	PSW_EXCEPTION_MASK, svc_int
> 
> 
>>   initial_cr0:
>>   	/* enable AFP-register control, so FP regs (+BFP instr) can be used */
>>   	.quad	0x0000000000040000
> 
> Could you maybe also fix that up in a separate patch and use the same
> constant in lib/s390x/smp.c

Yes, OK.

regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen

