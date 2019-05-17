Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFDC921323
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 06:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbfEQEc4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 May 2019 00:32:56 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:45716 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbfEQEc4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 May 2019 00:32:56 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4H4Sj70188098;
        Fri, 17 May 2019 04:32:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=nOKhMtl8ztBW14O8cXNb2dmbmY/cHyuONSYOR46kZk4=;
 b=G8hHkDGOQ2heyTdbE7B+2zix2NpC5ikq5w64NzIXpA27UbcTs1DKN2l7zhk6YF6ycZuS
 N+njV4nXF0WfaxSj8GABJCuNgR9llQkkEW/BZsbnS1/6SQXdr3uAtXyuW7O2NjgGxK2z
 9mt1+7lpyERnPBeQeEpjphf3T/Cz9613gkzXb/aVMZEiQP8wKaLnOVgXDjbyy1XGa1ME
 oSx5PZInonfbHrpCHNwCrvntEACFjQfrcHmyhuXU4wKYJ1RCg2eTYkWIz6oivrqxacPQ
 qypF8rlhQscwZVTGcQR/ZYhqfoCIaF87RJ8Io+ZECm9QbVILOIl8GY0JngaWnrR1R2OU yA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2sdkwe7fat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 May 2019 04:32:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4H4Vqcu039029;
        Fri, 17 May 2019 04:32:13 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2shh5gu9ym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 May 2019 04:32:12 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4H4WAkx021084;
        Fri, 17 May 2019 04:32:10 GMT
Received: from [192.168.0.110] (/70.36.60.91)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 May 2019 21:32:10 -0700
Subject: Re: [PATCH] sched: introduce configurable delay before entering idle
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>, kvm-devel <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Bandan Das <bsd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20190507185647.GA29409@amt.cnet>
 <CANRm+Cx8zCDG6Oz1m9eukkmx_uVFYcQOdMwZrHwsQcbLm_kuPA@mail.gmail.com>
 <20190514135022.GD4392@amt.cnet>
 <7e390fef-e0df-963f-4e18-e44ac2766be3@oracle.com>
 <20190515204356.GB31128@amt.cnet>
From:   Ankur Arora <ankur.a.arora@oracle.com>
Message-ID: <ee5656d7-3745-28c6-2021-adda0ed67240@oracle.com>
Date:   Thu, 16 May 2019 21:32:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190515204356.GB31128@amt.cnet>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9259 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905170028
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9259 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905170028
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019-05-15 1:43 p.m., Marcelo Tosatti wrote:
> On Wed, May 15, 2019 at 11:42:56AM -0700, Ankur Arora wrote:
>> On 5/14/19 6:50 AM, Marcelo Tosatti wrote:
>>> On Mon, May 13, 2019 at 05:20:37PM +0800, Wanpeng Li wrote:
>>>> On Wed, 8 May 2019 at 02:57, Marcelo Tosatti <mtosatti@redhat.com> wrote:
>>>>>
>>>>>
>>>>> Certain workloads perform poorly on KVM compared to baremetal
>>>>> due to baremetal's ability to perform mwait on NEED_RESCHED
>>>>> bit of task flags (therefore skipping the IPI).
>>>>
>>>> KVM supports expose mwait to the guest, if it can solve this?
>>>>
>>>> Regards,
>>>> Wanpeng Li
>>>
>>> Unfortunately mwait in guest is not feasible (uncompatible with multiple
>>> guests). Checking whether a paravirt solution is possible.
> 
> Hi Ankur,
> 
>>
>> Hi Marcelo,
>>
>> I was also looking at making MWAIT available to guests in a safe manner:
>> whether through emulation or a PV-MWAIT. My (unsolicited) thoughts
> 
> What use-case are you interested in?
Currently Oracle does not make MWAIT available to guests in cloud
environments. My interest is 1) allow guests to avoid the IPI and
2) allow the waiting to be in deeper C-states so that other cores
could get the benefit of turbo-boost etc.


> 
>>
>> We basically want to handle this sequence:
>>
>>      monitor(monitor_address);
>>      if (*monitor_address == base_value)
>>           mwaitx(max_delay);
>>
>> Emulation seems problematic because, AFAICS this would happen:
>>
>>      guest                                   hypervisor
>>      =====                                   ====
>>
>>      monitor(monitor_address);
>>          vmexit  ===>                        monitor(monitor_address)
>>      if (*monitor_address == base_value)
>>           mwait();
>>                vmexit    ====>               mwait()
>>
>> There's a context switch back to the guest in this sequence which seems
>> problematic. Both the AMD and Intel specs list system calls and
>> far calls as events which would lead to the MWAIT being woken up:
>> "Voluntary transitions due to fast system call and far calls
>> (occurring prior to issuing MWAIT but after setting the monitor)".
>>
>>
>> We could do this instead:
>>
>>      guest                                   hypervisor
>>      =====                                   ====
>>
>>      monitor(monitor_address);
>>          vmexit  ===>                        cache monitor_address
>>      if (*monitor_address == base_value)
>>           mwait();
>>                vmexit    ====>              monitor(monitor_address)
>>                                             mwait()
>>
>> But, this would miss the "if (*monitor_address == base_value)" check in
>> the host which is problematic if *monitor_address changed simultaneously
>> when monitor was executed.
>> (Similar problem if we cache both the monitor_address and
>> *monitor_address.)
>>
>>
>> So, AFAICS, the only thing that would work is the guest offloading the
>> whole PV-MWAIT operation.
>>
>> AFAICS, that could be a paravirt operation which needs three parameters:
>> (monitor_address, base_value, max_delay.)
>>
>> This would allow the guest to offload this whole operation to
>> the host:
>>      monitor(monitor_address);
>>      if (*monitor_address == base_value)
>>           mwaitx(max_delay);
>>
>> I'm guessing you are thinking on similar lines?
> 
> Sort of: only trying to avoid the IPI to wake a remote vCPU.
> 
> Problem is that MWAIT works only on a contiguous range
> of bits in memory (512 bits max on current CPUs).
> 
> So if you execute mwait on the host on behalf of the guest,
> the region of memory monitored must include both host
> and guest bits.
Yeah, an MWAITv would have come pretty handy here ;).

My idea of PV-MWAIT didn't include waiting on behalf of the host. I
was thinking of waiting in the host but exclusively on behalf of the
guest, until the guest is woken up or when it's time-quanta expires.

Waiting on behalf of both the guest and the host would clearly be better.

If we can do mwait for both the guest and host (say they share a 512
bit region), then the host will need some protection from the guest.
Maybe the waking guest-thread could just do a hypercall to wake up
the remote vCPU? Or maybe it could poke the monitored region,
but that is handled as a special page-fault?
The hypercall-to-wake would also allow us to move guest-threads across
CPUs. That said, I'm not sure how expensive either of these would be.

Assuming host/guest can share a monitored region safely, the host's
idle could monitor some region other than its &thread_info->flags.
Maybe we could setup a mwait notifier with a percpu waiting area which
could be registered by idle, guests etc.

Though on second thoughts, if the remote thread will do a
hypercall/page-fault then the handling could just as easily be: mark
the guest's remote thread runnable and set the resched bit.

> 
>>
>>
>> High level semantics: If the CPU doesn't have any runnable threads, then
>> we actually do this version of PV-MWAIT -- arming a timer if necessary
>> so we only sleep until the time-slice expires or the MWAIT max_delay does.
> 
> That would kill the sched_wake_idle_without_ipi optimization for the
> host.
Yeah, I was thinking in terms of the MWAIT being exclusively on behalf
of the guest so in a sense the guest was still scheduled just waiting.

Ankur

> 
>> If the CPU has any runnable threads then this could still finish its
>> time-quanta or we could just do a schedule-out.
>>
>>
>> So the semantics guaranteed to the host would be that PV-MWAIT
>> returns after >= max_delay OR with the *monitor_address changed.
>>
>>
>>
>> Ankur

