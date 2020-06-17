Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65CBB1FCBB5
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 13:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgFQLFA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 07:05:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44886 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725554AbgFQLE7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Jun 2020 07:04:59 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05HB3UNq124165;
        Wed, 17 Jun 2020 07:04:59 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31q6j3j40q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 07:04:58 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05HB3qog126285;
        Wed, 17 Jun 2020 07:04:58 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31q6j3j3ym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 07:04:58 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05HAuMwX020812;
        Wed, 17 Jun 2020 11:04:56 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 31q6bs8wgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 11:04:55 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05HB4rwW63045856
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jun 2020 11:04:53 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDD0011C064;
        Wed, 17 Jun 2020 11:04:53 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59DF011C05C;
        Wed, 17 Jun 2020 11:04:53 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.186.32])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 17 Jun 2020 11:04:53 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v9 06/12] s390x: clock and delays
 caluculations
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
 <1592213521-19390-7-git-send-email-pmorel@linux.ibm.com>
 <20200617102704.7755e11a.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <89cdae3e-1f50-03c1-e8ef-1f6b87a22fa9@linux.ibm.com>
Date:   Wed, 17 Jun 2020 13:04:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200617102704.7755e11a.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-17_03:2020-06-17,2020-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 phishscore=0 clxscore=1015 cotscore=-2147483648
 suspectscore=0 spamscore=0 mlxscore=0 priorityscore=1501 bulkscore=0
 mlxlogscore=999 adultscore=0 impostorscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006170087
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-06-17 10:27, Cornelia Huck wrote:
> On Mon, 15 Jun 2020 11:31:55 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> The hardware gives us a good definition of the microsecond,
>> let's keep this information and let the routine accessing
>> the hardware keep all the information and return microseconds.
>>
>> Calculate delays in microseconds and take care about wrapping
>> around zero.
>>
>> Define values with macros and use inlines to keep the
>> milliseconds interface.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/asm/time.h | 29 +++++++++++++++++++++++++++--
>>   1 file changed, 27 insertions(+), 2 deletions(-)
>>
>> diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
>> index 1791380..7f1d891 100644
>> --- a/lib/s390x/asm/time.h
>> +++ b/lib/s390x/asm/time.h
>> @@ -13,14 +13,39 @@
>>   #ifndef ASM_S390X_TIME_H
>>   #define ASM_S390X_TIME_H
>>   
>> -static inline uint64_t get_clock_ms(void)
>> +#define STCK_SHIFT_US	(63 - 51)
>> +#define STCK_MAX	((1UL << 52) - 1)
>> +
>> +static inline uint64_t get_clock_us(void)
>>   {
>>   	uint64_t clk;
>>   
>>   	asm volatile(" stck %0 " : : "Q"(clk) : "memory");
>>   
>>   	/* Bit 51 is incrememented each microsecond */
> 
> That comment may now be a tad non-obvious, because the details are
> hidden behind the #define? Anyway, no strong opinion.

You are right.
I find the macro's name is explicit so I remove the comment.

> 
>> -	return (clk >> (63 - 51)) / 1000;
>> +	return clk >> STCK_SHIFT_US;
>> +}
>> +
>> +static inline void udelay(unsigned long us)
>> +{
>> +	unsigned long startclk = get_clock_us();
>> +	unsigned long c;
>> +
>> +	do {
>> +		c = get_clock_us();
>> +		if (c < startclk)
>> +			c += STCK_MAX;
>> +	} while (c < startclk + us);
>> +}
>> +
>> +static inline void mdelay(unsigned long ms)
>> +{
>> +	udelay(ms * 1000);
>> +}
>> +
>> +static inline uint64_t get_clock_ms(void)
>> +{
>> +	return get_clock_us() / 1000;
>>   }
>>   
>>   #endif
> 
> Acked-by: Cornelia Huck <cohuck@redhat.com>
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
