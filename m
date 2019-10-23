Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F22FDE0FB3
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 03:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733192AbfJWBcB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 21:32:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41802 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732328AbfJWBcA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 21:32:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9N1TYmB187452;
        Wed, 23 Oct 2019 01:29:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=96W3FPDJhryM0Yu0bJqmJW04IGZAfZeRYhjGh2J58yk=;
 b=aAuGV7RIcAwioV8ozcoKQSHwwx8h7ou0osCQ5O/DEa+Io+3y2xmYwxFu4YwXRdPWk0m7
 xt7INVTs6i7sMUxhVsdpeve1cJPMiArdV1mMOltn53x3o8YZEBWNV7jhclYD7ZYz+m4R
 zGSeXEP6FMBPK+wrgCo4Wmv7AhiUO3fLC9EAXrQoTwV4eTcNqNOK2awevOZqGgD+ZECC
 dgROHQRTux3+aHsJGtRWdcBHnwWZw++tRNva/4AV9udSp9W9gj7PoTdkiq7fwv8WPQgm
 1mfZDP4WHzyeAD1dHcsDwmtnSjCxvAgXeQ4kLNK2ugRl+KyCnMs9yEsKLTCInaA0I0B7 GQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2vqu4qt15m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Oct 2019 01:29:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9N1STcp088658;
        Wed, 23 Oct 2019 01:29:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2vt2he7b79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Oct 2019 01:29:56 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9N1TsJI021366;
        Wed, 23 Oct 2019 01:29:54 GMT
Received: from [10.191.28.118] (/10.191.28.118)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 18:29:53 -0700
Subject: Re: [PATCH v7 2/5] x86/kvm: Change print code to use pr_*() format
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, pbonzini@redhat.com,
        rkrcmar@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, boris.ostrovsky@oracle.com,
        jgross@suse.com, peterz@infradead.org, will@kernel.org,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        mikelley@microsoft.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <1571649076-2421-1-git-send-email-zhenzhong.duan@oracle.com>
 <1571649076-2421-3-git-send-email-zhenzhong.duan@oracle.com>
 <20191022210120.GQ2343@linux.intel.com>
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
Organization: Oracle Corporation
Message-ID: <c72b01a4-f9a3-cc94-6e9a-3d7d576f232c@oracle.com>
Date:   Wed, 23 Oct 2019 09:29:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191022210120.GQ2343@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910230012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910230012
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019/10/23 5:01, Sean Christopherson wrote:
> On Mon, Oct 21, 2019 at 05:11:13PM +0800, Zhenzhong Duan wrote:
>> pr_*() is preferred than printk(KERN_* ...), after change all the print
>> in arch/x86/kernel/kvm.c will have "kvm_guest: xxx" style.
>>
>> No functional change.
>>
>> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
>> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: Radim Krcmar <rkrcmar@redhat.com>
>> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
>> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Cc: Wanpeng Li <wanpengli@tencent.com>
>> Cc: Jim Mattson <jmattson@google.com>
>> Cc: Joerg Roedel <joro@8bytes.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Borislav Petkov <bp@alien8.de>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> ---
>>   arch/x86/kernel/kvm.c | 30 ++++++++++++++++--------------
>>   1 file changed, 16 insertions(+), 14 deletions(-)
>>
>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>> index 3bc6a266..249f14a 100644
>> --- a/arch/x86/kernel/kvm.c
>> +++ b/arch/x86/kernel/kvm.c
>> @@ -7,6 +7,8 @@
>>    *   Authors: Anthony Liguori <aliguori@us.ibm.com>
>>    */
>>   
>> +#define pr_fmt(fmt) "kvm_guest: " fmt
> Sort of a silly nit, especially since I suggested kvm_guest...
>
> What about using kvm-guest instead of kvm_guest to be consistent with
> kvm-clock, the other prolific logger in a KVM guest.
>
> E.g.
>
>    kvm-clock: cpu 1, msr 551e041, secondary cpu clock
>    kvm-guest: setup async PF for cpu 1
>    kvm-guest: stealtime: cpu 1, msr 277695f40
>    kvm-clock: cpu 2, msr 551e081, secondary cpu clock
>    kvm-guest: setup async PF for cpu 2
>    kvm-guest: stealtime: cpu 2, msr 277715f40
>    kvm-clock: cpu 3, msr 551e0c1, secondary cpu clock
>    kvm-guest: setup async PF for cpu 3
>    kvm-guest: stealtime: cpu 3, msr 277795f40
>    kvm-clock: cpu 4, msr 551e101, secondary cpu clock
>    
> instead of
>
>    kvm-clock: cpu 1, msr 551e041, secondary cpu clock
>    kvm_guest: setup async PF for cpu 1
>    kvm_guest: stealtime: cpu 1, msr 277695f40
>    kvm-clock: cpu 2, msr 551e081, secondary cpu clock
>    kvm_guest: setup async PF for cpu 2
>    kvm_guest: stealtime: cpu 2, msr 277715f40
>    kvm-clock: cpu 3, msr 551e0c1, secondary cpu clock
>    kvm_guest: setup async PF for cpu 3
>    kvm_guest: stealtime: cpu 3, msr 277795f40
>    kvm-clock: cpu 4, msr 551e101, secondary cpu clock

Good suggestion, will do, thanks for point out.

Zhenzhong

