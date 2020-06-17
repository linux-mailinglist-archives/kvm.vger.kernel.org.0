Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAE9B1FCBEE
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 13:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgFQLNg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 07:13:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62272 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725894AbgFQLNg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Jun 2020 07:13:36 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05HB2GJq163478;
        Wed, 17 Jun 2020 07:13:35 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31q8nj0a9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 07:13:35 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05HB350d169904;
        Wed, 17 Jun 2020 07:13:35 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31q8nj0a8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 07:13:35 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05HB9n7l011039;
        Wed, 17 Jun 2020 11:13:32 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 31q6ch8wjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 11:13:32 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05HBDUpS60358790
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jun 2020 11:13:30 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6757D52052;
        Wed, 17 Jun 2020 11:13:30 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.6.17])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 0916852051;
        Wed, 17 Jun 2020 11:13:29 +0000 (GMT)
Subject: Re: [PATCH] KVM: s390: reduce number of IO pins to 1
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20200617083620.5409-1-borntraeger@de.ibm.com>
 <d17de7d7-6cca-672a-5519-c67fc147f6a5@redhat.com>
 <6953c580-9b99-1c76-b6eb-510dcb70894c@de.ibm.com>
 <20200617131101.36d2475e.cohuck@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Message-ID: <a73f2316-e5d1-692d-2e08-51f3a2d7d26c@de.ibm.com>
Date:   Wed, 17 Jun 2020 13:13:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200617131101.36d2475e.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-17_03:2020-06-17,2020-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=2
 impostorscore=0 priorityscore=1501 mlxlogscore=999 mlxscore=0 bulkscore=0
 cotscore=-2147483648 lowpriorityscore=0 spamscore=0 malwarescore=0
 clxscore=1015 phishscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006170083
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 17.06.20 13:11, Cornelia Huck wrote:
> On Wed, 17 Jun 2020 13:04:52 +0200
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
>> On 17.06.20 12:19, David Hildenbrand wrote:
>>> On 17.06.20 10:36, Christian Borntraeger wrote:  
>>>> The current number of KVM_IRQCHIP_NUM_PINS results in an order 3
>>>> allocation (32kb) for each guest start/restart. This can result in OOM
>>>> killer activity even with free swap when the memory is fragmented
>>>> enough:
>>>>
>>>> kernel: qemu-system-s39 invoked oom-killer: gfp_mask=0x440dc0(GFP_KERNEL_ACCOUNT|__GFP_COMP|__GFP_ZERO), order=3, oom_score_adj=0
>>>> kernel: CPU: 1 PID: 357274 Comm: qemu-system-s39 Kdump: loaded Not tainted 5.4.0-29-generic #33-Ubuntu
>>>> kernel: Hardware name: IBM 8562 T02 Z06 (LPAR)
>>>> kernel: Call Trace:
>>>> kernel: ([<00000001f848fe2a>] show_stack+0x7a/0xc0)
>>>> kernel:  [<00000001f8d3437a>] dump_stack+0x8a/0xc0
>>>> kernel:  [<00000001f8687032>] dump_header+0x62/0x258
>>>> kernel:  [<00000001f8686122>] oom_kill_process+0x172/0x180
>>>> kernel:  [<00000001f8686abe>] out_of_memory+0xee/0x580
>>>> kernel:  [<00000001f86e66b8>] __alloc_pages_slowpath+0xd18/0xe90
>>>> kernel:  [<00000001f86e6ad4>] __alloc_pages_nodemask+0x2a4/0x320
>>>> kernel:  [<00000001f86b1ab4>] kmalloc_order+0x34/0xb0
>>>> kernel:  [<00000001f86b1b62>] kmalloc_order_trace+0x32/0xe0
>>>> kernel:  [<00000001f84bb806>] kvm_set_irq_routing+0xa6/0x2e0
>>>> kernel:  [<00000001f84c99a4>] kvm_arch_vm_ioctl+0x544/0x9e0
>>>> kernel:  [<00000001f84b8936>] kvm_vm_ioctl+0x396/0x760
>>>> kernel:  [<00000001f875df66>] do_vfs_ioctl+0x376/0x690
>>>> kernel:  [<00000001f875e304>] ksys_ioctl+0x84/0xb0
>>>> kernel:  [<00000001f875e39a>] __s390x_sys_ioctl+0x2a/0x40
>>>> kernel:  [<00000001f8d55424>] system_call+0xd8/0x2c8
>>>>
>>>> As far as I can tell s390x does not use the iopins as we bail our for
>>>> anything other than KVM_IRQ_ROUTING_S390_ADAPTER and the chip/pin is
>>>> only used for KVM_IRQ_ROUTING_IRQCHIP. So let us use a small number to
>>>> reduce the memory footprint.
>>>>
>>>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>>>> ---
>>>>  arch/s390/include/asm/kvm_host.h | 8 ++++----
>>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
>>>> index cee3cb6455a2..6ea0820e7c7f 100644
>>>> --- a/arch/s390/include/asm/kvm_host.h
>>>> +++ b/arch/s390/include/asm/kvm_host.h
>>>> @@ -31,12 +31,12 @@
>>>>  #define KVM_USER_MEM_SLOTS 32
>>>>  
>>>>  /*
>>>> - * These seem to be used for allocating ->chip in the routing table,
>>>> - * which we don't use. 4096 is an out-of-thin-air value. If we need
>>>> - * to look at ->chip later on, we'll need to revisit this.
>>>> + * These seem to be used for allocating ->chip in the routing table, which we
>>>> + * don't use. 1 is as small as we can get to reduce the needed memory. If we
>>>> + * need to look at ->chip later on, we'll need to revisit this.
>>>>   */
>>>>  #define KVM_NR_IRQCHIPS 1
>>>> -#define KVM_IRQCHIP_NUM_PINS 4096
>>>> +#define KVM_IRQCHIP_NUM_PINS 1
>>>>  #define KVM_HALT_POLL_NS_DEFAULT 50000
>>>>  
>>>>  /* s390-specific vcpu->requests bit members */
>>>>  
>>>
>>> Guess it doesn't make sense to wrap all the "->chip" handling in a
>>> separate set of defines.
>>>
>>> Reviewed-by: David Hildenbrand <david@redhat.com>  
>>
>> I guess this is just the most simple solution. I am asking myself if I should add
>> cc stable of Fixes as I was able to trigger this by having several guests with a
>> reboot loop and several guests that trigger memory overcommitment.
>>
> 
> Not sure if I would count this as a real bug -- it's mostly just that a
> large enough memory allocation may fail or draw the wrath of the oom
> killer. It still sucks; but I'm wondering why we trigger this after
> seven years.

I think it is just that every kernel has a different threshold regarding "did
I made forward progress in freeing enough memory before I trigger the OOM killer"
I had to make it run very long with heavy overcommitment. 
