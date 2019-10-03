Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7ECC9C64
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 12:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729193AbfJCKd7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 06:33:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35660 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbfJCKd7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 06:33:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x93ATUCo083155;
        Thu, 3 Oct 2019 10:32:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=cZCgxtrTVQUR9UXEkShpmcGIZDAsL44okcToKuK+8qM=;
 b=mMT1BSH67l81mw8APcVvmvqvzBn4HaIUb8AwVq53W1eYXnWcYz7dP7BHkD5i2NhP0x6R
 e9in79ditV4+ijYCEPH/Sb5Zh8vKHLklp5h/9I29y7E7oxtpx/5K/Djtjx5Z22hwiXsk
 VI6BdfbL4I+iZpSsDf9mD7EPG1ZyiEPceNcBEnE2jEahYOJ29wAy+b7bvF5yg3Z8blfs
 qQIvdVBHgmSJrtF0xVs+iwrupa4y7qQwFrm9AoyWuEB8N9Zbpoz0nybas2tVU2TV+kZu
 sIhPhywcxLe6Sygjf0wFMj3jo5U9Emxy/gy/NboH/9oQwsDp9VrqxJEJ/HbIrRhTeJbx 1Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2v9xxv2ypf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Oct 2019 10:32:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x93ATMpA101354;
        Thu, 3 Oct 2019 10:32:13 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2vckyqj1gh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Oct 2019 10:32:13 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x93AWCCa030925;
        Thu, 3 Oct 2019 10:32:12 GMT
Received: from [10.191.0.240] (/10.191.0.240)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Oct 2019 03:32:12 -0700
Subject: Re: [PATCH v3 2/4] x86/kvm: Change print code to use pr_*() format
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <1569847479-13201-1-git-send-email-zhenzhong.duan@oracle.com>
 <1569847479-13201-3-git-send-email-zhenzhong.duan@oracle.com>
 <20191002171551.GC9615@linux.intel.com>
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
Organization: Oracle Corporation
Message-ID: <a7d2623a-c6a6-cd68-5b8e-ed37a0cc9178@oracle.com>
Date:   Thu, 3 Oct 2019 18:32:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191002171551.GC9615@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9398 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910030096
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9398 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910030096
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019/10/3 1:15, Sean Christopherson wrote:

> On Mon, Sep 30, 2019 at 08:44:37PM +0800, Zhenzhong Duan wrote:
>> pr_*() is preferred than printk(KERN_* ...), after change all the print
>> in arch/x86/kernel/kvm.c will have "KVM: xxx" style.
>>
>> No functional change.
>>
>> Suggested-by: Vitaly Kuznetsov<vkuznets@redhat.com>
> This wasn't really suggested by Vitaly, he just requested it be done in a
> separate patch.

Will fix.

>
>> Signed-off-by: Zhenzhong Duan<zhenzhong.duan@oracle.com>
>> Cc: Paolo Bonzini<pbonzini@redhat.com>
>> Cc: Radim Krcmar<rkrcmar@redhat.com>
>> Cc: Sean Christopherson<sean.j.christopherson@intel.com>
>> Cc: Vitaly Kuznetsov<vkuznets@redhat.com>
>> Cc: Wanpeng Li<wanpengli@tencent.com>
>> Cc: Jim Mattson<jmattson@google.com>
>> Cc: Joerg Roedel<joro@8bytes.org>
>> Cc: Thomas Gleixner<tglx@linutronix.de>
>> Cc: Ingo Molnar<mingo@redhat.com>
>> Cc: Borislav Petkov<bp@alien8.de>
>> Cc: "H. Peter Anvin"<hpa@zytor.com>
>> ---
>>   arch/x86/kernel/kvm.c | 24 ++++++++++++------------
>>   1 file changed, 12 insertions(+), 12 deletions(-)
>>
>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>> index a4f108d..ce4f578 100644
>> --- a/arch/x86/kernel/kvm.c
>> +++ b/arch/x86/kernel/kvm.c
>> @@ -7,6 +7,8 @@
>>    *   Authors: Anthony Liguori<aliguori@us.ibm.com>
>>    */
>>   
>> +#define pr_fmt(fmt) "KVM: " fmt
> Not a fan of "KVM" as the prefix as it's easily confused with KVM the
> hypervisor.  Maybe "kvm_guest"?

Yeah, looks better, will change to"kvm_guest". Thanks

Zhenzhong

