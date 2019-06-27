Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF6E58DAF
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 00:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbfF0WKo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 18:10:44 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59490 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbfF0WKo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 18:10:44 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5RM9CWc195284;
        Thu, 27 Jun 2019 22:10:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=IMGnupGZz3Ly/LnCN3VqcXuO7zjZfouSSs+R1wUHExA=;
 b=PmDerQJlkn4rRoXpatjDECaD4GJNk5fmq6Nve4NFucZHeYMxuE/Hzf1/V8G+6YahUI5Z
 UgeHKu9QmlU9u/VQXw/FKqLt7GZr/pvFPqPwJJ/rSzerhww49hpj2bO2BoippOE4ToV3
 DfVKgkB9egFfrqg1E8QQMnj5f2sWTtXMFCXWSAb8gdi6RdDDbvFb4hACmte37rnK+my0
 BryWETNTedUjZ8URqrMR3RA9TehmCUXZCSWyoY4f3NnL24n3iOBHaT7Ga2pblXqElQSh
 iyUBkRX4V8WZ44JpiZeBm+IDo35/r8HC6OuwwiUZ6pawsy8q7olNALJfU0yCs0t/TFKl zA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2t9cyqtka5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 22:10:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5RM9ZPa164000;
        Thu, 27 Jun 2019 22:10:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2t9acdge1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 22:10:27 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5RMARZ7029555;
        Thu, 27 Jun 2019 22:10:27 GMT
Received: from dhcp-10-132-91-225.usdhcp.oraclecorp.com (/10.132.91.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Jun 2019 15:10:26 -0700
Subject: Re: [kvm-unit-tests PATCH] x86: Memory barrier before setting ICR
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20190625125836.9149-1-nadav.amit@gmail.com>
 <e7ff39ef-5d09-6aa0-a3ac-e23707355e99@oracle.com>
 <04225212-29F6-4C73-B5BF-B00C36D6B038@gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <e5a1867c-b855-1d7a-3925-8c1f57bc7f89@oracle.com>
Date:   Thu, 27 Jun 2019 15:10:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <04225212-29F6-4C73-B5BF-B00C36D6B038@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9301 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=929
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906270254
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9301 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=986 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906270254
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06/27/2019 10:44 AM, Nadav Amit wrote:
>> On Jun 26, 2019, at 6:07 PM, Krish Sadhukhan <krish.sadhukhan@oracle.com> wrote:
>>
>>
>> On 6/25/19 5:58 AM, Nadav Amit wrote:
>>> The wrmsr that is used in x2apic ICR programming does not behave as a
>>> memory barrier. There is a hidden assumption that it is. Add an explicit
>>> memory barrier for this reason.
>>>
>>> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
>>> ---
>>>   lib/x86/apic.c | 2 ++
>>>   1 file changed, 2 insertions(+)
>>>
>>> diff --git a/lib/x86/apic.c b/lib/x86/apic.c
>>> index bc2706e..1514730 100644
>>> --- a/lib/x86/apic.c
>>> +++ b/lib/x86/apic.c
>>> @@ -2,6 +2,7 @@
>>>   #include "apic.h"
>>>   #include "msr.h"
>>>   #include "processor.h"
>>> +#include "asm/barrier.h"
>>>     void *g_apic = (void *)0xfee00000;
>>>   void *g_ioapic = (void *)0xfec00000;
>>> @@ -71,6 +72,7 @@ static void x2apic_write(unsigned reg, u32 val)
>>>     static void x2apic_icr_write(u32 val, u32 dest)
>>>   {
>>> +    mb();
>>>       asm volatile ("wrmsr" : : "a"(val), "d"(dest),
>>>                     "c"(APIC_BASE_MSR + APIC_ICR/16));
>>>   }
>>
>> Regarding non-serializing forms, the SDM mentions,
>>
>>          "X2APIC MSRs (MSR indices 802H to 83FH)"
>>
>>
>> (APIC_BASE_MSR + APIC_ICR/16) is a different value. So I am wondering why we need a barrier here.
> What am I missing here?
>
> APIC_BASE_MSR = 0x800
> APIC_ICR = 0x300
>
> So 0x800 + (0x300 / 16) = 0x830 , and 0x802 <= 0x830 <= 0x83f
>
> Hence, writes to APIC_ICR do not seem to be serializing. No?

Sorry, my bad !  I missed the "to" in the quote from the SDM and thought 
only two MSRs were non-serializing.

Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
