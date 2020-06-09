Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED2D51F3597
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 09:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgFIHy0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 03:54:26 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30728 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726404AbgFIHy0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Jun 2020 03:54:26 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0597WvgY093517;
        Tue, 9 Jun 2020 03:54:25 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31g7n8qpn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Jun 2020 03:54:25 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0597X8LV094517;
        Tue, 9 Jun 2020 03:54:25 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31g7n8qphp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Jun 2020 03:54:24 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0597kFxq012884;
        Tue, 9 Jun 2020 07:54:17 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 31g2s827cj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Jun 2020 07:54:16 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0597sETg44761410
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Jun 2020 07:54:14 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A43A14C040;
        Tue,  9 Jun 2020 07:54:14 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 585974C044;
        Tue,  9 Jun 2020 07:54:14 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.16.61])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  9 Jun 2020 07:54:14 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v8 07/12] s390x: define function to wait
 for interrupt
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1591603981-16879-1-git-send-email-pmorel@linux.ibm.com>
 <1591603981-16879-8-git-send-email-pmorel@linux.ibm.com>
 <0005ec91-d4ac-2892-a800-76c96e7b34a0@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <c9dd11b7-ad84-ff7f-9703-d736e68ea87e@linux.ibm.com>
Date:   Tue, 9 Jun 2020 09:54:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <0005ec91-d4ac-2892-a800-76c96e7b34a0@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-09_02:2020-06-08,2020-06-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 priorityscore=1501 clxscore=1015 adultscore=0 lowpriorityscore=0
 mlxscore=0 malwarescore=0 impostorscore=0 phishscore=0 mlxlogscore=972
 suspectscore=0 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006090056
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-06-09 07:07, Thomas Huth wrote:
> On 08/06/2020 10.12, Pierre Morel wrote:
>> Allow the program to wait for an interrupt.
>>
>> The interrupt handler is in charge to remove the WAIT bit
>> when it finished handling the interrupt.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>   lib/s390x/asm/arch_def.h | 14 ++++++++++++++
>>   1 file changed, 14 insertions(+)
>>
>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>> index 12045ff..e0ced12 100644
>> --- a/lib/s390x/asm/arch_def.h
>> +++ b/lib/s390x/asm/arch_def.h
>> @@ -10,9 +10,11 @@
>>   #ifndef _ASM_S390X_ARCH_DEF_H_
>>   #define _ASM_S390X_ARCH_DEF_H_
>>   
>> +#define PSW_MASK_IO			0x0200000000000000UL
>>   #define PSW_MASK_EXT			0x0100000000000000UL
>>   #define PSW_MASK_DAT			0x0400000000000000UL
>>   #define PSW_MASK_SHORT_PSW		0x0008000000000000UL
>> +#define PSW_MASK_WAIT			0x0002000000000000UL
>>   #define PSW_MASK_PSTATE			0x0001000000000000UL
>>   #define PSW_MASK_BA			0x0000000080000000UL
>>   #define PSW_MASK_EA			0x0000000100000000UL
>> @@ -253,6 +255,18 @@ static inline void load_psw_mask(uint64_t mask)
>>   		: "+r" (tmp) :  "a" (&psw) : "memory", "cc" );
>>   }
>>   
>> +static inline void wait_for_interrupt(uint64_t irq_mask)
>> +{
>> +	uint64_t psw_mask = extract_psw_mask();
>> +
>> +	load_psw_mask(psw_mask | irq_mask | PSW_MASK_WAIT);
>> +	/*
>> +	 * After being woken and having processed the interrupt, let's restore
>> +	 * the PSW mask.
>> +	 */
>> +	load_psw_mask(psw_mask);
>> +}
>> +
>>   static inline void enter_pstate(void)
>>   {
>>   	uint64_t mask;
>>
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 
Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
