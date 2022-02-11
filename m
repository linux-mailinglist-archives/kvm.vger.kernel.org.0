Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 748BA4B2FC9
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 22:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346840AbiBKVrt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 16:47:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236253AbiBKVrs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 16:47:48 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2C3C66;
        Fri, 11 Feb 2022 13:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644616066; x=1676152066;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=u7EIF+a4I0IMIwS5pqBWwTCH7GokA9uoakQvkYt7jwo=;
  b=AzTnjMwpFck0/qoL5yEg9WXgZV7oPIZFE7NxrWTSNVjnLDsogoyxNGQJ
   xmg4ubPi891D1m4rJ9++gx0rJIuTjoN1z+71Nx6Fz8rPV71qUpSumYeK7
   gQLCpTR83tLnvpVQiif5OTAadesmsH7c3CnDhlmuvwPZwlEu1HyaPRgWT
   z0a0NPxDDGZqqVSHdFjPSK4QiQpG0B7nQvdeQTE+KnqB5ZKPH6nBISiFu
   slTeojFo2W+2aDSNsowI8077bK50K/VfOCjb+nsh+L8ujDULAnz6Xla0q
   +N3LmAbixKvwLjWdx6f2YUnPP/WlfwCw2HYbBz1xcGVbse/OnpjJQhrAu
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10255"; a="233369108"
X-IronPort-AV: E=Sophos;i="5.88,361,1635231600"; 
   d="scan'208";a="233369108"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 13:47:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,361,1635231600"; 
   d="scan'208";a="602488917"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga004.fm.intel.com with ESMTP; 11 Feb 2022 13:47:44 -0800
Received: from [10.212.150.232] (kliang2-MOBL.ccr.corp.intel.com [10.212.150.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 7A29A58092F;
        Fri, 11 Feb 2022 13:47:43 -0800 (PST)
Message-ID: <2180ea93-5f05-b1c1-7253-e3707da29f8c@linux.intel.com>
Date:   Fri, 11 Feb 2022 16:47:42 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH kvm/queue v2 2/3] perf: x86/core: Add interface to query
 perfmon_event_map[] directly
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     David Dunn <daviddunn@google.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Stephane Eranian <eranian@google.com>
References: <20220117085307.93030-1-likexu@tencent.com>
 <20220202144308.GB20638@worktop.programming.kicks-ass.net>
 <CALMp9eRBOmwz=mspp0m5Q093K3rMUeAsF3vEL39MGV5Br9wEQQ@mail.gmail.com>
 <YgO/3usazae9rCEh@hirez.programming.kicks-ass.net>
 <69c0fc41-a5bd-fea9-43f6-4724368baf66@intel.com>
 <CALMp9eS=1U7T39L-vL_cTXTNN2Li8epjtAPoP_+Hwefe9d+teQ@mail.gmail.com>
 <67a731dd-53ba-0eb8-377f-9707e5c9be1b@intel.com>
 <CABOYuvbPL0DeEgV4gsC+v786xfBAo3T6+7XQr7cVVzbaoFoEAg@mail.gmail.com>
 <7b5012d8-6ae1-7cde-a381-e82685dfed4f@linux.intel.com>
 <CALMp9eTOaWxQPfdwMSAn-OYAHKPLcuCyse7BpsSOM35vg5d0Jg@mail.gmail.com>
 <e06db1a5-1b67-28ac-ee4c-34ece5857b1f@linux.intel.com>
 <CALMp9eSjDro169JjTXyCZn=Rf3PT0uHhdNXEifiXGYQK-Zn8LA@mail.gmail.com>
 <d86ba87b-d98a-53a0-b2cd-5bf77b97b592@linux.intel.com>
 <CABOYuvZ9SZAWeRkrhhhpMM4XwzMzXv9A1WDpc6z8SUBquf0SFQ@mail.gmail.com>
 <6afcec02-fb44-7b72-e527-6517a94855d4@linux.intel.com>
 <CALMp9eQ79Cnh1aqNGLR8n5MQuHTwuf=DMjJ2cTb9uXu94GGhEA@mail.gmail.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <CALMp9eQ79Cnh1aqNGLR8n5MQuHTwuf=DMjJ2cTb9uXu94GGhEA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/11/2022 1:08 PM, Jim Mattson wrote:
> On Fri, Feb 11, 2022 at 6:11 AM Liang, Kan <kan.liang@linux.intel.com> wrote:
>>
>>
>>
>> On 2/10/2022 2:55 PM, David Dunn wrote:
>>> Kan,
>>>
>>> On Thu, Feb 10, 2022 at 11:46 AM Liang, Kan <kan.liang@linux.intel.com> wrote:
>>>
>>>> No, we don't, at least for Linux. Because the host own everything. It
>>>> doesn't need the MSR to tell which one is in use. We track it in an SW way.
>>>>
>>>> For the new request from the guest to own a counter, I guess maybe it is
>>>> worth implementing it. But yes, the existing/legacy guest never check
>>>> the MSR.
>>>
>>> This is the expectation of all software that uses the PMU in every
>>> guest.  It isn't just the Linux perf system.
>>>
>>> The KVM vPMU model we have today results in the PMU utilizing software
>>> simply not working properly in a guest.  The only case that can
>>> consistently "work" today is not giving the guest a PMU at all.
>>>
>>> And that's why you are hearing requests to gift the entire PMU to the
>>> guest while it is running. All existing PMU software knows about the
>>> various constraints on exactly how each MSR must be used to get sane
>>> data.  And by gifting the entire PMU it allows that software to work
>>> properly.  But that has to be controlled by policy at host level such
>>> that the owner of the host knows that they are not going to have PMU
>>> visibility into guests that have control of PMU.
>>>
>>
>> I think here is how a guest event works today with KVM and perf subsystem.
>>       - Guest create an event A
>>       - The guest kernel assigns a guest counter M to event A, and config
>> the related MSRs of the guest counter M.
>>       - KVM intercepts the MSR access and create a host event B. (The
>> host event B is based on the settings of the guest counter M. As I said,
>> at least for Linux, some SW config impacts the counter assignment. KVM
>> never knows it. Event B can only be a similar event to A.)
>>       - Linux perf subsystem assigns a physical counter N to a host event
>> B according to event B's constraint. (N may not be the same as M,
>> because A and B may have different event constraints)
>>
>> As you can see, even the entire PMU is given to the guest, we still
>> cannot guarantee that the physical counter M can be assigned to the
>> guest event A.
> 
> All we know about the guest is that it has programmed virtual counter
> M. It seems obvious to me that we can satisfy that request by giving
> it physical counter M. If, for whatever reason, we give it physical
> counter N isntead, and M and N are not completely fungible, then we
> have failed.
> 
>> How to fix it? The only thing I can imagine is "passthrough". Let KVM
>> directly assign the counter M to guest. So, to me, this policy sounds
>> like let KVM replace the perf to control the whole PMU resources, and we
>> will handover them to our guest then. Is it what we want?
> 
> We want PMU virtualization to work. There are at least two ways of doing that:
> 1) Cede the entire PMU to the guest while it's running.

So the guest will take over the control of the entire PMUs while it's 
running. I know someone wants to do system-wide monitoring. This case 
will be failed.

I'm not sure whether you can fully trust the guest. If malware runs in 
the guest, I don't know whether it will harm the entire system. I'm not 
a security expert, but it sounds dangerous.
Hope the administrators know what they are doing when choosing this policy.

> 2) Introduce a new "ultimate" priority level in the host perf
> subsystem. Only KVM can request events at the ultimate priority, and
> these requests supersede any other requests.

The "ultimate" priority level doesn't help in the above case. The 
counter M may not bring the precise which guest requests. I remember you 
called it "broken".

KVM can fails the case, but KVM cannot notify the guest. The guest still 
see wrong result.

> 
> Other solutions are welcome.

I don't have a perfect solution to achieve all your requirements. Based 
on my understanding, the guest has to be compromised by either 
tolerating some errors or dropping some features (e.g., some special 
events). With that, we may consider the above "ultimate" priority level 
policy. The default policy would be the same as the current 
implementation, where the host perf treats all the users, including the 
guest, equally. The administrators can set the "ultimate" priority level 
policy, which may let the KVM/guest pin/own some regular counters via 
perf subsystem. That's just my personal opinion for your reference.

Thanks,
Kan
