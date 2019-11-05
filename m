Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9470EF32D
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 03:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729967AbfKECDE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 21:03:04 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:57972 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729428AbfKECDE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 21:03:04 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA51xIR0152653;
        Tue, 5 Nov 2019 02:02:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=4qBStdgRL0xiXQEEeE1k+jSq4+HxPdlQr7tsBPnj3pY=;
 b=jD0lJaLWboCUPWPaqSU9bGelZKQTsIHbS9Vx8iEndT08L16PVpDB6jhD7Rl97sSMAFNv
 DLB7N2tOXkm1ujW7S56lymnU7CpoJZjlHF/zYIVY8p/wgBkZJYoAyjdQeSr6GBEF2qZy
 cB+JIZzBHSFNybZ/6D0c+nowDjz1QWz5sZBPlLxreYgbDClVebxFYD32KTR3R4OeBzKG
 KrzkTstDclvA5vhl08xjeAYK4nDnU8fbjDloCFAH21+Nbs48pqtCWLSXCih1gtCNYHHK
 9jDDs1ZnWV5W5RHrBni2bGVKGOMhoF3f7C0JF2trYSS1Jpap+WRr3DfyAsgWr/JJu6Vf wQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2w12er2x16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 02:02:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA51xNAU011448;
        Tue, 5 Nov 2019 02:02:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2w1kxndsnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 02:02:57 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA522vb3013152;
        Tue, 5 Nov 2019 02:02:57 GMT
Received: from dhcp-10-132-95-157.usdhcp.oraclecorp.com (/10.132.95.157)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 18:02:57 -0800
Subject: Re: [PATCH] kvm: cpuid: Expose leaves 0x80000005 and 0x80000006 to
 the guest
To:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20191022213349.54734-1-jmattson@google.com>
 <CALMp9eR7temnM2XssLbRF0Op+=t0f-vwY-Pn4XgZ4uEaTW57Yw@mail.gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <6e847c96-46f7-bd60-1b0f-2b6cdb5d4bca@oracle.com>
Date:   Mon, 4 Nov 2019 18:02:56 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eR7temnM2XssLbRF0Op+=t0f-vwY-Pn4XgZ4uEaTW57Yw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911050014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911050014
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/04/2019 12:49 PM, Jim Mattson wrote:
> On Tue, Oct 22, 2019 at 2:33 PM Jim Mattson <jmattson@google.com> wrote:
>> Leaf 0x80000005 is "L1 Cache and TLB Information." Leaf 0x80000006 is
>> "L2 Cache and TLB and L3 Cache Information." Include these leaves in
>> the array returned by KVM_GET_SUPPORTED_CPUID.
>>
>> Signed-off-by: Jim Mattson <jmattson@google.com>
>> ---
>>   arch/x86/kvm/cpuid.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 9c5029cf6f3f..1b40d8277b84 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -730,6 +730,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>>                  entry->ecx &= kvm_cpuid_8000_0001_ecx_x86_features;
>>                  cpuid_mask(&entry->ecx, CPUID_8000_0001_ECX);
>>                  break;
>> +       case 0x80000005:
>> +       case 0x80000006:
>> +               break;
>>          case 0x80000007: /* Advanced power management */
>>                  /* invariant TSC is CPUID.80000007H:EDX[8] */
>>                  entry->edx &= (1 << 8);
>> --
>> 2.23.0.866.gb869b98d4c-goog
>>
> Ping.

Just curious about where we are actually setting the information for 
these two leaves. I don't see it either in __do_cpuid_func() or in 
kvm_x86_ops->set_supported_cpuid().
