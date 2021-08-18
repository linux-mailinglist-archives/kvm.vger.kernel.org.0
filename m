Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686ED3EFF64
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 10:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239403AbhHRIkV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 04:40:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33226 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239262AbhHRIkU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 04:40:20 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17I8Z825053003;
        Wed, 18 Aug 2021 04:39:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Xjh3mS49uYp13VqBtZGnT/YIe7Zv3ESq/ZbEEjGl634=;
 b=YK3hXXOJeXAcZ1CwL35VXkFGoFo7Ko3FGZOTCen4DCoUM4pGxS9QcvU4JRnCruyZa1rC
 NFraeABfJRDGF3AGomAAhLwyPsR8L/HhV1tuMw7+IBd1S4MeMIyMN3yazAP8yE8wUub4
 mwUGsyC8PqRuW7tOMf0ORfhAYiIeGMpHxEc6w+g1WVCXrRr9rwmh+nptHOMtcwBZrTm4
 f9IBmFuje1OLrryM0PziQXnLLt5RJ6n2LBhXuRHIuq+HBZl8aYizi8xHrwKR4kXiliZq
 NUg2dHGc/kpJWRogz245T/qzINiwrQmMIMtVaZvAZPgjX9VxY5fN0VBQs8pzdb9siSdm Ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agcsqxae1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 04:39:45 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17I8aYN9056279;
        Wed, 18 Aug 2021 04:39:44 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agcsqxacx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 04:39:44 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17I8bCZc018509;
        Wed, 18 Aug 2021 08:39:42 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3ae53hx89e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 08:39:42 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17I8deNi52494602
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 08:39:40 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD0ACA4068;
        Wed, 18 Aug 2021 08:39:39 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B872A405F;
        Wed, 18 Aug 2021 08:39:39 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.174.181])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Aug 2021 08:39:39 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 1/8] s390x: lib: Extend bitops
To:     Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        cohuck@redhat.com
References: <20210813073615.32837-1-frankja@linux.ibm.com>
 <20210813073615.32837-2-frankja@linux.ibm.com>
 <20210813103240.33710ea6@p-imbrenda>
 <e0bcb199-7254-01bb-baee-7de83b62495a@linux.ibm.com>
 <de5b6d16-9ec1-5d77-00ac-61305d90851a@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <9d6730f4-21a2-d161-d609-557da2254909@linux.ibm.com>
Date:   Wed, 18 Aug 2021 10:39:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <de5b6d16-9ec1-5d77-00ac-61305d90851a@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2wQgfd5SsRYGqy1AYuTtp1SSKPLWyTqd
X-Proofpoint-GUID: eLKSAxk6gOl-KVcVjdtq8MrCX1I1V5NK
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-18_03:2021-08-17,2021-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 clxscore=1015 adultscore=0 impostorscore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108180050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/18/21 10:20 AM, Thomas Huth wrote:
> On 13/08/2021 13.31, Janosch Frank wrote:
>> On 8/13/21 10:32 AM, Claudio Imbrenda wrote:
>>> On Fri, 13 Aug 2021 07:36:08 +0000
>>> Janosch Frank <frankja@linux.ibm.com> wrote:
>>>
>>>> Bit setting and clearing is never bad to have.
>>>>
>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>> ---
>>>>   lib/s390x/asm/bitops.h | 102
>>>> +++++++++++++++++++++++++++++++++++++++++ 1 file changed, 102
>>>> insertions(+)
>>>>
>>>> diff --git a/lib/s390x/asm/bitops.h b/lib/s390x/asm/bitops.h
>>>> index 792881ec..f5612855 100644
>>>> --- a/lib/s390x/asm/bitops.h
>>>> +++ b/lib/s390x/asm/bitops.h
>>>> @@ -17,6 +17,78 @@
>>>>   
>>>>   #define BITS_PER_LONG	64
>>>>   
>>>> +static inline unsigned long *bitops_word(unsigned long nr,
>>>> +					 const volatile unsigned
>>>> long *ptr) +{
>>>> +	unsigned long addr;
>>>> +
>>>> +	addr = (unsigned long)ptr + ((nr ^ (nr & (BITS_PER_LONG -
>>>> 1))) >> 3);
>>>> +	return (unsigned long *)addr;
>>>
>>> why not just
>>>
>>> return ptr + (nr / BITS_PER_LONG);
>>>
>>>> +}
>>>> +
>>>> +static inline unsigned long bitops_mask(unsigned long nr)
>>>> +{
>>>> +	return 1UL << (nr & (BITS_PER_LONG - 1));
>>>> +}
>>>> +
>>>> +static inline uint64_t laog(volatile unsigned long *ptr, uint64_t
>>>> mask) +{
>>>> +	uint64_t old;
>>>> +
>>>> +	/* load and or 64bit concurrent and interlocked */
>>>> +	asm volatile(
>>>> +		"	laog	%[old],%[mask],%[ptr]\n"
>>>> +		: [old] "=d" (old), [ptr] "+Q" (*ptr)
>>>> +		: [mask] "d" (mask)
>>>> +		: "memory", "cc" );
>>>> +	return old;
>>>> +}
>>>
>>> do we really need the artillery (asm) here?
>>> is there a reason why we can't do this in C?
>>
>> Those are the interlocked/atomic instructions and even though we don't
>> exactly need them right now I wanted to add them for completeness.
> 
> I think I agree with Claudio - unless we really need them, we should not 
> clog the sources with arbitrary inline assembly functions.

Alright I can trim it down

> 
>> We might be able to achieve the same via compiler functionality but this
>> is not my expertise. Maybe Thomas or David have a few pointers for me?
> 
> I'm not an expert with atomic builtins either, but what's the point of this 
> at all? Loading a value and OR-ing something into the value in one go? 
> What's that good for?

Well it's a block-concurrent interlocked-update load, or and store.
I.e. it loads the data from the ptr and copies it into [old] then ors
the mask and stores it back to the ptr address.

The instruction name "load and or" does not represent the full actions
of the instruction.

> 
>   Thomas
> 

