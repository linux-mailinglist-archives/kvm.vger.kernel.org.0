Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914C01F1D10
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 18:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730432AbgFHQQ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 12:16:56 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41788 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730267AbgFHQQ4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Jun 2020 12:16:56 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 058G35o6188936;
        Mon, 8 Jun 2020 12:16:55 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31g7a1c4kh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 12:16:55 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 058GAn1U030236;
        Mon, 8 Jun 2020 12:16:54 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31g7a1c4jk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 12:16:54 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 058GBDd1012097;
        Mon, 8 Jun 2020 16:16:52 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 31g2s7vaer-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 16:16:52 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 058GFYq764029160
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Jun 2020 16:15:34 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7A074204D;
        Mon,  8 Jun 2020 16:16:49 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A1C24204B;
        Mon,  8 Jun 2020 16:16:49 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.43.245])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Jun 2020 16:16:49 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v8 06/12] s390x: clock and delays
 caluculations
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1591603981-16879-1-git-send-email-pmorel@linux.ibm.com>
 <1591603981-16879-7-git-send-email-pmorel@linux.ibm.com>
 <2f449a7b-2701-abcc-42b7-5b7441c10761@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <77a4005a-4164-b871-02b4-314417ff11e4@linux.ibm.com>
Date:   Mon, 8 Jun 2020 18:16:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <2f449a7b-2701-abcc-42b7-5b7441c10761@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-08_14:2020-06-08,2020-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 spamscore=0 cotscore=-2147483648
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 malwarescore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006080115
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-06-08 17:55, Thomas Huth wrote:
> On 08/06/2020 10.12, Pierre Morel wrote:
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
>> index 1791380..eb15941 100644
>> --- a/lib/s390x/asm/time.h
>> +++ b/lib/s390x/asm/time.h
>> @@ -13,14 +13,39 @@
>>   #ifndef ASM_S390X_TIME_H
>>   #define ASM_S390X_TIME_H
>>   
>> -static inline uint64_t get_clock_ms(void)
>> +#define STCK_SHIFT	(63 - 51)
> 
> Could you maybe rather call this STCK_SHIFT_US instead, so that it is
> clear that we refer to the microsecond bit here?
> 
>> +#define STCK_MAX	((1 << (STCK_SHIFT + 1)) - 1)
> 
> Hmm, is that really right? Shouldn't that rather be
> 
>   ((1 << (51 + 1)) - 1)
> 
> instead?

:) ooops, right.

> 
> (you want to have a max. value for the 52 bits that count the
> microseconds, not a max value for the remainder bits, do you?)
> 
>> +static inline uint64_t get_clock_us(void)
>>   {
>>   	uint64_t clk;
>>   
>>   	asm volatile(" stck %0 " : : "Q"(clk) : "memory");
>>   
>>   	/* Bit 51 is incrememented each microsecond */
>> -	return (clk >> (63 - 51)) / 1000;
>> +	return clk >> STCK_SHIFT;
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
>> +	} while (c < (startclk + us));
> 
> You could omit the parentheses around "startclk + us" here.

OK

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
