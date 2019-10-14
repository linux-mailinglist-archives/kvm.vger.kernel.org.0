Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCBAD5952
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 03:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729550AbfJNBk3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Oct 2019 21:40:29 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33860 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729180AbfJNBk3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Oct 2019 21:40:29 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9E1YAq2184216;
        Mon, 14 Oct 2019 01:38:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=J/Zx3AZCV+da8NwUd+JDUxFRe7ArKdBVUd37g3KWwJA=;
 b=VZlRGpq9Jf8Nhq5zfKVRYGLbsRxdwQcQhg04ZiFZlyPLwsJaRMyMnP0LIeH+p86xVuB7
 7nHd/ynn2l95uJWGKioQNC5eSW8vtc03K6o3bxqXXbYeoOR0YzgwDOWr7yHpIDgdI7g5
 Rlco6XAKYJn9bDc58L0P5kZwvBbb+5JeIT6hOtI5mfhrHo7R+apagP3jQd+ANmTF99Y2
 veFJajb/FdJRsL03x96esw9BTp5KwqX9Ma+xgePNCS2d9PYobNCInJtbXyfp8pa12N77
 oIQDzEa2vKEmCC6saspO99GeShqpON4PTWzbnTvKivNdIimoi3PqtlfCw1JJVgz5jHOy FA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2vk68u5g05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Oct 2019 01:38:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9E1bW2l012237;
        Mon, 14 Oct 2019 01:38:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2vkrbht66m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Oct 2019 01:38:26 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9E1cIgO025208;
        Mon, 14 Oct 2019 01:38:23 GMT
Received: from [10.191.5.73] (/10.191.5.73)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Oct 2019 01:38:18 +0000
Subject: Re: [PATCH v5 2/5] x86/kvm: Change print code to use pr_*() format
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org
Cc:     linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, peterz@infradead.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <1570439071-9814-1-git-send-email-zhenzhong.duan@oracle.com>
 <1570439071-9814-3-git-send-email-zhenzhong.duan@oracle.com>
 <87lftp5819.fsf@vitty.brq.redhat.com>
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
Organization: Oracle Corporation
Message-ID: <2fb950d0-7ffd-2e1c-9d92-bc76baa77fe4@oracle.com>
Date:   Mon, 14 Oct 2019 09:38:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <87lftp5819.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9409 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910140014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9409 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910140013
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019/10/13 17:06, Vitaly Kuznetsov wrote:
> Zhenzhong Duan <zhenzhong.duan@oracle.com> writes:
>
>> pr_*() is preferred than printk(KERN_* ...), after change all the print
>> in arch/x86/kernel/kvm.c will have "kvm_guest: xxx" style.
>>
>> No functional change.
>>
>> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
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
>> index 3bc6a266..ef836d6 100644
>> --- a/arch/x86/kernel/kvm.c
>> +++ b/arch/x86/kernel/kvm.c
>> @@ -7,6 +7,8 @@
>>    *   Authors: Anthony Liguori <aliguori@us.ibm.com>
>>    */
>>   
>> +#define pr_fmt(fmt) "kvm_guest: " fmt
>> +
>>   #include <linux/context_tracking.h>
>>   #include <linux/init.h>
>>   #include <linux/kernel.h>
>> @@ -286,8 +288,8 @@ static void kvm_register_steal_time(void)
>>   		return;
>>   
>>   	wrmsrl(MSR_KVM_STEAL_TIME, (slow_virt_to_phys(st) | KVM_MSR_ENABLED));
>> -	pr_info("kvm-stealtime: cpu %d, msr %llx\n",
>> -		cpu, (unsigned long long) slow_virt_to_phys(st));
>> +	pr_info("stealtime: cpu %d, msr %llx\n", cpu,
>> +		(unsigned long long) slow_virt_to_phys(st));
>>   }
>>   
>>   static DEFINE_PER_CPU_DECRYPTED(unsigned long, kvm_apic_eoi) = KVM_PV_EOI_DISABLED;
>> @@ -321,8 +323,7 @@ static void kvm_guest_cpu_init(void)
>>   
>>   		wrmsrl(MSR_KVM_ASYNC_PF_EN, pa);
>>   		__this_cpu_write(apf_reason.enabled, 1);
>> -		printk(KERN_INFO"KVM setup async PF for cpu %d\n",
>> -		       smp_processor_id());
>> +		pr_info("setup async PF for cpu %d\n", smp_processor_id());
>>   	}
>>   
>>   	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI)) {
>> @@ -347,8 +348,7 @@ static void kvm_pv_disable_apf(void)
>>   	wrmsrl(MSR_KVM_ASYNC_PF_EN, 0);
>>   	__this_cpu_write(apf_reason.enabled, 0);
>>   
>> -	printk(KERN_INFO"Unregister pv shared memory for cpu %d\n",
>> -	       smp_processor_id());
>> +	pr_info("Unregister pv shared memory for cpu %d\n", smp_processor_id());
>>   }
>>   
>>   static void kvm_pv_guest_cpu_reboot(void *unused)
>> @@ -469,7 +469,8 @@ static void __send_ipi_mask(const struct cpumask *mask, int vector)
>>   		} else {
>>   			ret = kvm_hypercall4(KVM_HC_SEND_IPI, (unsigned long)ipi_bitmap,
>>   				(unsigned long)(ipi_bitmap >> BITS_PER_LONG), min, icr);
>> -			WARN_ONCE(ret < 0, "KVM: failed to send PV IPI: %ld", ret);
>> +			WARN_ONCE(ret < 0, "kvm_guest: failed to send PV IPI: %ld",
>> +				  ret);
>>   			min = max = apic_id;
>>   			ipi_bitmap = 0;
>>   		}
>> @@ -479,7 +480,8 @@ static void __send_ipi_mask(const struct cpumask *mask, int vector)
>>   	if (ipi_bitmap) {
>>   		ret = kvm_hypercall4(KVM_HC_SEND_IPI, (unsigned long)ipi_bitmap,
>>   			(unsigned long)(ipi_bitmap >> BITS_PER_LONG), min, icr);
>> -		WARN_ONCE(ret < 0, "KVM: failed to send PV IPI: %ld", ret);
>> +		WARN_ONCE(ret < 0, "kvm_guest: failed to send PV IPI: %ld",
>> +			  ret);
>>   	}
>>   
>>   	local_irq_restore(flags);
>> @@ -509,7 +511,7 @@ static void kvm_setup_pv_ipi(void)
>>   {
>>   	apic->send_IPI_mask = kvm_send_ipi_mask;
>>   	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
>> -	pr_info("KVM setup pv IPIs\n");
>> +	pr_info("setup pv IPIs\n");
> Not your fault but in WARN_ONCE() above we use 'PV' capitalized so I'd
> suggest we converge on something: either capitalize them all or make
> them all lowercase.

Thanks for catching, will do with 'PV' for all print.

Zhenzhong

