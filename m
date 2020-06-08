Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC751F1AF4
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 16:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729992AbgFHOZV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 10:25:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23694 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729982AbgFHOZV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Jun 2020 10:25:21 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 058EM6KO112898;
        Mon, 8 Jun 2020 10:25:21 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31g5fc1b7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 10:25:21 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 058EN0Gu116090;
        Mon, 8 Jun 2020 10:25:20 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31g5fc1b6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 10:25:20 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 058EPBQj012449;
        Mon, 8 Jun 2020 14:25:18 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 31g2s7spdc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 14:25:18 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 058EPFiT30277666
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Jun 2020 14:25:15 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8107942084;
        Mon,  8 Jun 2020 14:25:14 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 345944205F;
        Mon,  8 Jun 2020 14:25:14 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.43.245])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Jun 2020 14:25:14 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v8 02/12] s390x: Move control register bit
 definitions and add AFP to them
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1591603981-16879-1-git-send-email-pmorel@linux.ibm.com>
 <1591603981-16879-3-git-send-email-pmorel@linux.ibm.com>
 <ac5e93fa-3b52-0f28-2c62-64c31b902c33@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <33625241-be13-f823-a3bb-27f7daca2934@linux.ibm.com>
Date:   Mon, 8 Jun 2020 16:25:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <ac5e93fa-3b52-0f28-2c62-64c31b902c33@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-08_13:2020-06-08,2020-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 cotscore=-2147483648
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006080104
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-06-08 10:45, Thomas Huth wrote:
> On 08/06/2020 10.12, Pierre Morel wrote:
>> While adding the definition for the AFP-Register control bit, move all
>> existing definitions for CR0 out of the C zone to the assmbler zone to
>> keep the definitions concerning CR0 together.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Reviewed-by: David Hildenbrand <david@redhat.com>
>> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>   lib/s390x/asm/arch_def.h | 11 ++++++-----
>>   s390x/cstart64.S         |  2 +-
>>   2 files changed, 7 insertions(+), 6 deletions(-)
>>
>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>> index 5388114..12045ff 100644
>> --- a/lib/s390x/asm/arch_def.h
>> +++ b/lib/s390x/asm/arch_def.h
>> @@ -19,17 +19,18 @@
>>   
>>   #define PSW_EXCEPTION_MASK	(PSW_MASK_EA | PSW_MASK_BA)
>>   
>> +#define CR0_EXTM_SCLP			0x0000000000000200UL
>> +#define CR0_EXTM_EXTC			0x0000000000002000UL
>> +#define CR0_EXTM_EMGC			0x0000000000004000UL
>> +#define CR0_EXTM_MASK			0x0000000000006200UL
>> +#define CR0_AFP_REG_CRTL		0x0000000000040000UL
>> +
>>   #ifndef __ASSEMBLER__
>>   struct psw {
>>   	uint64_t	mask;
>>   	uint64_t	addr;
>>   };
>>   
>> -#define CR0_EXTM_SCLP			0x0000000000000200UL
>> -#define CR0_EXTM_EXTC			0x0000000000002000UL
>> -#define CR0_EXTM_EMGC			0x0000000000004000UL
>> -#define CR0_EXTM_MASK			0x0000000000006200UL
>> -
>>   struct lowcore {
>>   	uint8_t		pad_0x0000[0x0080 - 0x0000];	/* 0x0000 */
>>   	uint32_t	ext_int_param;			/* 0x0080 */
>> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
>> index 6e85635..b50c42c 100644
>> --- a/s390x/cstart64.S
>> +++ b/s390x/cstart64.S
>> @@ -214,4 +214,4 @@ svc_int_psw:
>>   	.quad	PSW_EXCEPTION_MASK, svc_int
>>   initial_cr0:
>>   	/* enable AFP-register control, so FP regs (+BFP instr) can be used */
>> -	.quad	0x0000000000040000
>> +	.quad	CR0_AFP_REG_CRTL
>>
> 
> Acked-by: Thomas Huth <thuth@redhat.com>
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
