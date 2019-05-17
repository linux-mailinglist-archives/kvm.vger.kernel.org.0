Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC2E211EE
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 04:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbfEQCHX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 May 2019 22:07:23 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56656 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfEQCHX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 May 2019 22:07:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4H24Q8R094195;
        Fri, 17 May 2019 02:06:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=bjnO+NM5dUe7lDVkmEEo2/UA5Dd+CKQDyT5gWb2FUlg=;
 b=Q5TIdiniRf8fc/yHXDkJogrqZIzx9dhnek7EvBstRbq2aQiOw5LLfdeYat2kamsLd6ss
 7slJaXwY14ANrAr+C6CsMVxq3lU+96gsQX2FNLAfL5UV8L3z5rei8lG3XV8o9hyWgR5o
 ovb1sLdGouSpMprxZbvgXuOSO2L5zJqR78YSZwMl1atytwUVVRPhYEHPGDRdv7e0G7UO
 +WiC7QqaBPAJAFDxGrCvBjLzM+SDgz6dHFPNIT/TxorhiMMlH7/fU9YD49Jo1g0IWbjQ
 CRDg090i7eF6rHr+gBrOI7DhCrPrm0FgTne/Nmy3q/J9iUjo8+ss96ab+sRAGK4iMQhW jw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2sdq1qxtf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 May 2019 02:06:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4H25SXB035632;
        Fri, 17 May 2019 02:06:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2sggeu154u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 May 2019 02:06:33 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4H26WY6014020;
        Fri, 17 May 2019 02:06:32 GMT
Received: from [192.168.0.110] (/70.36.60.91)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 May 2019 19:06:32 -0700
Subject: Re: [PATCH] sched: introduce configurable delay before entering idle
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
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
 <CANRm+CyrLneGkOXzEmGyB-Sr+DOqqDAF4eNB1YBpbhm3Edo3Gw@mail.gmail.com>
From:   Ankur Arora <ankur.a.arora@oracle.com>
Message-ID: <265675b1-07e2-f5dd-6de8-5e47fa91be32@oracle.com>
Date:   Thu, 16 May 2019 19:06:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CANRm+CyrLneGkOXzEmGyB-Sr+DOqqDAF4eNB1YBpbhm3Edo3Gw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9259 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905170011
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9259 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905170011
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019-05-15 6:07 p.m., Wanpeng Li wrote:
> On Thu, 16 May 2019 at 02:42, Ankur Arora <ankur.a.arora@oracle.com> wrote:
>>
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
>>
>> Hi Marcelo,
>>
>> I was also looking at making MWAIT available to guests in a safe manner:
>> whether through emulation or a PV-MWAIT. My (unsolicited) thoughts
> 
> MWAIT emulation is not simple, here is a research
> https://www.contrib.andrew.cmu.edu/~somlo/OSXKVM/mwait.html
Agreed. I had outlined my attempt to do that below and come
to the conclusion that we would need a PV-MWAIT.

Ankur

> 
> Regards,
> Wanpeng Li
> 
>> follow.
>>
>> We basically want to handle this sequence:
>>
>>       monitor(monitor_address);
>>       if (*monitor_address == base_value)
>>            mwaitx(max_delay);
>>
>> Emulation seems problematic because, AFAICS this would happen:
>>
>>       guest                                   hypervisor
>>       =====                                   ====
>>
>>       monitor(monitor_address);
>>           vmexit  ===>                        monitor(monitor_address)
>>       if (*monitor_address == base_value)
>>            mwait();
>>                 vmexit    ====>               mwait()
>>
>> There's a context switch back to the guest in this sequence which seems
>> problematic. Both the AMD and Intel specs list system calls and
>> far calls as events which would lead to the MWAIT being woken up:
>> "Voluntary transitions due to fast system call and far calls (occurring
>> prior to issuing MWAIT but after setting the monitor)".
>>
>>
>> We could do this instead:
>>
>>       guest                                   hypervisor
>>       =====                                   ====
>>
>>       monitor(monitor_address);
>>           vmexit  ===>                        cache monitor_address
>>       if (*monitor_address == base_value)
>>            mwait();
>>                 vmexit    ====>              monitor(monitor_address)
>>                                              mwait()
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
>>       monitor(monitor_address);
>>       if (*monitor_address == base_value)
>>            mwaitx(max_delay);
>>
>> I'm guessing you are thinking on similar lines?
>>
>>
>> High level semantics: If the CPU doesn't have any runnable threads, then
>> we actually do this version of PV-MWAIT -- arming a timer if necessary
>> so we only sleep until the time-slice expires or the MWAIT max_delay does.
>>
>> If the CPU has any runnable threads then this could still finish its
>> time-quanta or we could just do a schedule-out.
>>
>>
>> So the semantics guaranteed to the host would be that PV-MWAIT returns
>> after >= max_delay OR with the *monitor_address changed.
>>
>>
>>
>> Ankur

