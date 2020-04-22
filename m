Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C14E1B36FC
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 07:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgDVFxj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 01:53:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55634 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726033AbgDVFxi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Apr 2020 01:53:38 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03M5WEgT019620
        for <kvm@vger.kernel.org>; Wed, 22 Apr 2020 01:53:38 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gj24fewv-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 22 Apr 2020 01:53:38 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Wed, 22 Apr 2020 06:53:00 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 22 Apr 2020 06:52:56 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03M5rVU46750510
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 05:53:31 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33002A404D;
        Wed, 22 Apr 2020 05:53:31 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0F16A4040;
        Wed, 22 Apr 2020 05:53:30 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.55.142])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Apr 2020 05:53:30 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v5 02/10] s390x: Use PSW bits definitions
 in cstart
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        thuth@redhat.com, cohuck@redhat.com
References: <1582200043-21760-1-git-send-email-pmorel@linux.ibm.com>
 <1582200043-21760-3-git-send-email-pmorel@linux.ibm.com>
 <f8cb512c-8146-3777-13a8-5c06017334cf@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Wed, 22 Apr 2020 07:53:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <f8cb512c-8146-3777-13a8-5c06017334cf@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20042205-0008-0000-0000-0000037529EC
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042205-0009-0000-0000-00004A96F1C0
Message-Id: <2ca34025-a366-2431-daba-8b08bff84aad@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-21_10:2020-04-21,2020-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 mlxscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 phishscore=0 adultscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220041
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-04-21 18:16, David Hildenbrand wrote:
> On 20.02.20 13:00, Pierre Morel wrote:
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
>>   lib/s390x/asm/arch_def.h | 15 +++++++++++----
>>   s390x/cstart64.S         | 15 ++++++++-------
>>   2 files changed, 19 insertions(+), 11 deletions(-)
>>
>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>> index 15a4d49..69a8256 100644
>> --- a/lib/s390x/asm/arch_def.h
>> +++ b/lib/s390x/asm/arch_def.h
>> @@ -10,15 +10,21 @@
>>   #ifndef _ASM_S390X_ARCH_DEF_H_
>>   #define _ASM_S390X_ARCH_DEF_H_
>>   
>> +#define PSW_MASK_EXT			0x0100000000000000UL
>> +#define PSW_MASK_DAT			0x0400000000000000UL
>> +#define PSW_MASK_PSTATE			0x0001000000000000UL
>> +#define PSW_MASK_BA			0x0000000080000000UL
>> +#define PSW_MASK_EA			0x0000000100000000UL
>> +
>> +#define PSW_EXCEPTION_MASK (PSW_MASK_EA|PSW_MASK_BA)
>> +
>> +#ifndef __ASSEMBLER__
>> +
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
>> @@ -297,4 +303,5 @@ static inline uint32_t get_prefix(void)
>>   	return current_prefix;
>>   }
>>   
>> +#endif /* not __ASSEMBLER__ */
>>   #endif
>> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
>> index 45da523..2885a36 100644
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
>>   initial_cr0:
>>   	/* enable AFP-register control, so FP regs (+BFP instr) can be used */
>>   	.quad	0x0000000000040000
>>
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen

