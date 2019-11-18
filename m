Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDE0C100C02
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 20:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbfKRTIl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 14:08:41 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:44642 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbfKRTIk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Nov 2019 14:08:40 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAIJ4PBt057973;
        Mon, 18 Nov 2019 19:08:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=ooVljAxnOFvpDxTHab72/L9Lnr5egAf8LSHHqQBWv3c=;
 b=UiLWf2QnjjJIR3WLjxPIu0R1GNG6Jva3jAMHDxHUM1Kf+gpf2wKtb5VtAEfB59NKINmY
 B1zVzVQR4BYDEN3MFCG5bKHk1nMACc6f5UuC4vc3TvMtoCl71gETmnNqajwPNqpjctxA
 1rHXRyGb65wgCbDuiB3a68c22eihheceXuU6rG6p8h+T/QW/i2E+ek5KSG9OyLV8iGDi
 S86WNuY6xhqMKLHRmuk03ytWC7XhYOAfRGk08c2oRr2yi0ze2MgaS6X+iDNWbgI3i/Dl
 3wvYvZA2dV7hSO/dZ1gD38ZFs+wl6bmQWGuIlpeh+2KPwvcqdzioZlIXlSArCM3+3uG5 BQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2wa92pj8xj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Nov 2019 19:08:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAIJ8VQB149337;
        Mon, 18 Nov 2019 19:08:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2wbxm303pw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Nov 2019 19:08:35 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAIJ8Xmd019639;
        Mon, 18 Nov 2019 19:08:33 GMT
Received: from [10.159.244.44] (/10.159.244.44)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 Nov 2019 11:08:33 -0800
Subject: Re: [kvm-unit-tests PATCH] x86: Fix the register order to match
 struct regs
To:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20191025170056.109755-1-aaronlewis@google.com>
 <CAAAPnDFcS+SCrLK1wGGEiBBc+yy1bGOKsw4oKnXgXFwUb9p0CQ@mail.gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <03a2c4c5-d966-5a5b-dec5-c7eb9507f5ae@oracle.com>
Date:   Mon, 18 Nov 2019 11:08:31 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAAAPnDFcS+SCrLK1wGGEiBBc+yy1bGOKsw4oKnXgXFwUb9p0CQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911180162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911180162
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 11/15/19 6:27 AM, Aaron Lewis wrote:
> On Fri, Oct 25, 2019 at 10:01 AM Aaron Lewis <aaronlewis@google.com> wrote:
>> Fix the order the registers show up in SAVE_GPR and SAVE_GPR_C to ensure
>> the correct registers get the correct values.  Previously, the registers
>> were being written to (and read from) the wrong fields.
>>
>> Reviewed-by: Jim Mattson <jmattson@google.com>
>> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
>> ---
>>   x86/vmx.h | 12 ++++++------
>>   1 file changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/x86/vmx.h b/x86/vmx.h
>> index 8496be7..8527997 100644
>> --- a/x86/vmx.h
>> +++ b/x86/vmx.h
>> @@ -492,9 +492,9 @@ enum vm_instruction_error_number {
>>
>>   #define SAVE_GPR                               \
>>          "xchg %rax, regs\n\t"                   \
>> -       "xchg %rbx, regs+0x8\n\t"               \
>> -       "xchg %rcx, regs+0x10\n\t"              \
>> -       "xchg %rdx, regs+0x18\n\t"              \
>> +       "xchg %rcx, regs+0x8\n\t"               \
>> +       "xchg %rdx, regs+0x10\n\t"              \
>> +       "xchg %rbx, regs+0x18\n\t"              \
>>          "xchg %rbp, regs+0x28\n\t"              \
>>          "xchg %rsi, regs+0x30\n\t"              \
>>          "xchg %rdi, regs+0x38\n\t"              \
>> @@ -511,9 +511,9 @@ enum vm_instruction_error_number {
>>
>>   #define SAVE_GPR_C                             \
>>          "xchg %%rax, regs\n\t"                  \
>> -       "xchg %%rbx, regs+0x8\n\t"              \
>> -       "xchg %%rcx, regs+0x10\n\t"             \
>> -       "xchg %%rdx, regs+0x18\n\t"             \
>> +       "xchg %%rcx, regs+0x8\n\t"              \
>> +       "xchg %%rdx, regs+0x10\n\t"             \
>> +       "xchg %%rbx, regs+0x18\n\t"             \
>>          "xchg %%rbp, regs+0x28\n\t"             \
>>          "xchg %%rsi, regs+0x30\n\t"             \
>>          "xchg %%rdi, regs+0x38\n\t"             \
>> --
>> 2.24.0.rc0.303.g954a862665-goog
>>
> Ping.
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
