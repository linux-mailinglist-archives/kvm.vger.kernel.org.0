Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FAE53EB494
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 13:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239482AbhHMLcR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 07:32:17 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43106 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238157AbhHMLcR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 07:32:17 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17DB5VEJ122600;
        Fri, 13 Aug 2021 07:31:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=rQnQoBzoYb8exGfq/T9enuokLNpt+ZHm5RZHLqySAdg=;
 b=LSKpCvP4MQgA9CltMwmP4jGt5GsTnqw6bWAOpiWX9eGV+C40YtEkMB8lPRr6QAf4n6Wd
 xCCFyIJJ1RLh6sSHBz5vE3YxE8KmEtIWIp+XJ3GrNkKD1R6qcO6bMsCnYjtnKDt9nHaf
 mJGwQBssYSxDeVW6DCJfco7YNTlPpaQAa1caYRTqQNnUvxdaXDitmxvhak7eJSIdV77J
 bqvsgJ7F26+aIXNCgy69OpzY961jbtJ4GDl8w9zO9G77FeTjc1p5zvPh/806LUZ/se7w
 Pl2bsxBb3mA4+g9ihNcisc3UHJbKpAYryOLFsorsqDc4gARsfu2KiBat1iy0ENWC1t3U Ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3acstprw3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 07:31:50 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17DBJJcP165782;
        Fri, 13 Aug 2021 07:31:50 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3acstprw31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 07:31:50 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17DBPK11010402;
        Fri, 13 Aug 2021 11:31:47 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3acf0kv1h4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 11:31:47 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17DBVjTe37880088
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 11:31:45 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21FA9A405C;
        Fri, 13 Aug 2021 11:31:45 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B89F6A405B;
        Fri, 13 Aug 2021 11:31:44 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.158.198])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 13 Aug 2021 11:31:44 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 1/8] s390x: lib: Extend bitops
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
References: <20210813073615.32837-1-frankja@linux.ibm.com>
 <20210813073615.32837-2-frankja@linux.ibm.com>
 <20210813103240.33710ea6@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <e0bcb199-7254-01bb-baee-7de83b62495a@linux.ibm.com>
Date:   Fri, 13 Aug 2021 13:31:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210813103240.33710ea6@p-imbrenda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IkNPUWOCH7zUPg5RAyclXD5KH1jxOx0E
X-Proofpoint-ORIG-GUID: Z15cqkjCovCf0BApV7NeosU2dY7WLMv4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-13_03:2021-08-12,2021-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 impostorscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130067
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/13/21 10:32 AM, Claudio Imbrenda wrote:
> On Fri, 13 Aug 2021 07:36:08 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> Bit setting and clearing is never bad to have.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  lib/s390x/asm/bitops.h | 102
>> +++++++++++++++++++++++++++++++++++++++++ 1 file changed, 102
>> insertions(+)
>>
>> diff --git a/lib/s390x/asm/bitops.h b/lib/s390x/asm/bitops.h
>> index 792881ec..f5612855 100644
>> --- a/lib/s390x/asm/bitops.h
>> +++ b/lib/s390x/asm/bitops.h
>> @@ -17,6 +17,78 @@
>>  
>>  #define BITS_PER_LONG	64
>>  
>> +static inline unsigned long *bitops_word(unsigned long nr,
>> +					 const volatile unsigned
>> long *ptr) +{
>> +	unsigned long addr;
>> +
>> +	addr = (unsigned long)ptr + ((nr ^ (nr & (BITS_PER_LONG -
>> 1))) >> 3);
>> +	return (unsigned long *)addr;
> 
> why not just 
> 
> return ptr + (nr / BITS_PER_LONG);
> 
>> +}
>> +
>> +static inline unsigned long bitops_mask(unsigned long nr)
>> +{
>> +	return 1UL << (nr & (BITS_PER_LONG - 1));
>> +}
>> +
>> +static inline uint64_t laog(volatile unsigned long *ptr, uint64_t
>> mask) +{
>> +	uint64_t old;
>> +
>> +	/* load and or 64bit concurrent and interlocked */
>> +	asm volatile(
>> +		"	laog	%[old],%[mask],%[ptr]\n"
>> +		: [old] "=d" (old), [ptr] "+Q" (*ptr)
>> +		: [mask] "d" (mask)
>> +		: "memory", "cc" );
>> +	return old;
>> +}
> 
> do we really need the artillery (asm) here?
> is there a reason why we can't do this in C?

Those are the interlocked/atomic instructions and even though we don't
exactly need them right now I wanted to add them for completeness.
We might be able to achieve the same via compiler functionality but this
is not my expertise. Maybe Thomas or David have a few pointers for me?

> 
>> +static inline uint64_t lang(volatile unsigned long *ptr, uint64_t
>> mask) +{
>> +	uint64_t old;
>> +
>> +	/* load and and 64bit concurrent and interlocked */
>> +	asm volatile(
>> +		"	lang	%[old],%[mask],%[ptr]\n"
>> +		: [old] "=d" (old), [ptr] "+Q" (*ptr)
>> +		: [mask] "d" (mask)
>> +		: "memory", "cc" );
>> +	return old;
>> +}
> 
> (same here as above)
> 
>> +
>> +static inline void set_bit(unsigned long nr,
>> +			   const volatile unsigned long *ptr)
>> +{
>> +	uint64_t mask = bitops_mask(nr);
>> +	uint64_t *addr = bitops_word(nr, ptr);
>> +
>> +	laog(addr, mask);
>> +}
>> +
>> +static inline void set_bit_inv(unsigned long nr,
>> +			       const volatile unsigned long *ptr)
>> +{
>> +	return set_bit(nr ^ (BITS_PER_LONG - 1), ptr);
>> +}
>> +
>> +static inline void clear_bit(unsigned long nr,
>> +			     const volatile unsigned long *ptr)
>> +{
>> +	uint64_t mask = bitops_mask(nr);
>> +	uint64_t *addr = bitops_word(nr, ptr);
>> +
>> +	lang(addr, ~mask);
>> +}
>> +
>> +static inline void clear_bit_inv(unsigned long nr,
>> +				 const volatile unsigned long *ptr)
>> +{
>> +	return clear_bit(nr ^ (BITS_PER_LONG - 1), ptr);
>> +}
>> +
>> +/* non-atomic bit manipulation functions */
>> +
>>  static inline bool test_bit(unsigned long nr,
>>  			    const volatile unsigned long *ptr)
>>  {
>> @@ -33,4 +105,34 @@ static inline bool test_bit_inv(unsigned long nr,
>>  	return test_bit(nr ^ (BITS_PER_LONG - 1), ptr);
>>  }
>>  
>> +static inline void __set_bit(unsigned long nr,
>> +			     const volatile unsigned long *ptr)
>> +{
>> +	uint64_t mask = bitops_mask(nr);
>> +	uint64_t *addr = bitops_word(nr, ptr);
>> +
>> +	*addr |= mask;
>> +}
>> +
>> +static inline void __set_bit_inv(unsigned long nr,
>> +				 const volatile unsigned long *ptr)
>> +{
>> +	return __set_bit(nr ^ (BITS_PER_LONG - 1), ptr);
>> +}
>> +
>> +static inline void __clear_bit(unsigned long nr,
>> +			       const volatile unsigned long *ptr)
>> +{
>> +	uint64_t mask = bitops_mask(nr);
>> +	uint64_t *addr = bitops_word(nr, ptr);
>> +
>> +	*addr &= ~mask;
>> +}
>> +
>> +static inline void __clear_bit_inv(unsigned long nr,
>> +				   const volatile unsigned long *ptr)
>> +{
>> +	return __clear_bit(nr ^ (BITS_PER_LONG - 1), ptr);
>> +}
>> +
>>  #endif
> 

