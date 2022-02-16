Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C104B81B6
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 08:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbiBPHha (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 02:37:30 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:45550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiBPHh2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 02:37:28 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FCA8172245;
        Tue, 15 Feb 2022 23:37:03 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id y5so1487142pfe.4;
        Tue, 15 Feb 2022 23:37:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=f/G+kYI2OuePvFBo1DtcigDSjDvYkrk+4RWm2cD8DXA=;
        b=OxkO/SRkZ6TDPnVy4Ui8dfo/jiWtfA7IxZbePmC2i3gBL15DNDAhlkCctCqfaCkY4P
         kwal+kjAf54UxJ1H/7+gMgN0M7SUHkmiJFrMLINSfBe/YYB5ba+1yFTTtRw5WUh6m9kO
         8fgDmHeOcplQgV8VyalghErNS277EIMl8mTJaD6LHpXxgmXu6Cs72cC4lABiI9Q6dIK7
         mYTmvHU+A94sIUwYlccLYhRjaKxLdc1hkiprtVe0XM+SxxNT0qGMuCjCBsuIf+tgVMZe
         P5QQBmQsGbkaQ8Z0DpIX6z3By+GfMYLmb4a1udp87Sb+PrD/Np88SXsup87NtZMkL4qP
         v82w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=f/G+kYI2OuePvFBo1DtcigDSjDvYkrk+4RWm2cD8DXA=;
        b=paUd87LxSauiGmzuslxz1+UFjI9998WIuNjhKH3kjQQipZRBopamwCVm0RJs/lyVo3
         YuWujvCUSUuLTlYGHKkijqhrlTZg6NLOcFnHSPgTIJz6qpVCqsYMEVso1Died7xIuFys
         xKijYeXg7MiFG2IeVBxjVWGR4Y2lxnD2w4QMMIP6CH/C8LrjQ+SYfuaY6Gi7edhct7v3
         1oYbgOeEYjlaTDO5l3jfQ23bxYdZjpmhgx5P1bm5mVXL17g0OKzG4HovqfC1UGPEhVuy
         9Ow/JRN4iZWcJHgaWT6yyzHJMjVj+EJLJx5mJd+P+K/4dfz+CP8Sg6Y4sl7RY/tvo/aP
         yJ4g==
X-Gm-Message-State: AOAM5310PYKhKSrJc03PoZ/qCpw0k9rzeFdRk1AeV6ASACGQhI50nz1G
        eTZq0bXEU7pcFCbbSwIkdCY=
X-Google-Smtp-Source: ABdhPJz6zV5nextbckSU6TqcYcbY2yenjIeRUfN9K9qVjjDrKvT+TnZvo4fbLx6HM5u9QuUsdTIA1A==
X-Received: by 2002:a62:63c2:0:b0:4e1:604:f07 with SMTP id x185-20020a6263c2000000b004e106040f07mr1691503pfb.56.1644997012214;
        Tue, 15 Feb 2022 23:36:52 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id my18sm19889970pjb.57.2022.02.15.23.36.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 23:36:51 -0800 (PST)
Message-ID: <31cd6e81-fd74-daa1-8518-8a8dfc6174d0@gmail.com>
Date:   Wed, 16 Feb 2022 15:36:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH kvm/queue v2 2/3] perf: x86/core: Add interface to query
 perfmon_event_map[] directly
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        "Liang, Kan" <kan.liang@linux.intel.com>
Cc:     David Dunn <daviddunn@google.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Stephane Eranian <eranian@google.com>
References: <20220117085307.93030-1-likexu@tencent.com>
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
 <2180ea93-5f05-b1c1-7253-e3707da29f8c@linux.intel.com>
 <CALMp9eQiaXtF3S0QZ=2_SWavFnv6zFHqf_zFXBrxXb9pVYh0nQ@mail.gmail.com>
 <8d9149b5-e56f-b397-1527-9f21a26ad95b@linux.intel.com>
 <CALMp9eTqNyG-ke1Aq72hn0CVXER63SgVPamzXria76PmqiZvJQ@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <CALMp9eTqNyG-ke1Aq72hn0CVXER63SgVPamzXria76PmqiZvJQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/2/2022 6:55 am, Jim Mattson wrote:
> On Mon, Feb 14, 2022 at 1:55 PM Liang, Kan <kan.liang@linux.intel.com> wrote:
>>
>>
>>
>> On 2/12/2022 6:31 PM, Jim Mattson wrote:
>>> On Fri, Feb 11, 2022 at 1:47 PM Liang, Kan <kan.liang@linux.intel.com> wrote:
>>>>
>>>>
>>>>
>>>> On 2/11/2022 1:08 PM, Jim Mattson wrote:
>>>>> On Fri, Feb 11, 2022 at 6:11 AM Liang, Kan <kan.liang@linux.intel.com> wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>> On 2/10/2022 2:55 PM, David Dunn wrote:
>>>>>>> Kan,
>>>>>>>
>>>>>>> On Thu, Feb 10, 2022 at 11:46 AM Liang, Kan <kan.liang@linux.intel.com> wrote:
>>>>>>>
>>>>>>>> No, we don't, at least for Linux. Because the host own everything. It
>>>>>>>> doesn't need the MSR to tell which one is in use. We track it in an SW way.
>>>>>>>>
>>>>>>>> For the new request from the guest to own a counter, I guess maybe it is
>>>>>>>> worth implementing it. But yes, the existing/legacy guest never check
>>>>>>>> the MSR.
>>>>>>>
>>>>>>> This is the expectation of all software that uses the PMU in every
>>>>>>> guest.  It isn't just the Linux perf system.

Hardware resources will always be limited (the good news is that
the number of counters will increase in the future), and when we have
a common need for the same hardware, we should prioritize overall
fairness over a GUEST-first strategy.

>>>>>>>
>>>>>>> The KVM vPMU model we have today results in the PMU utilizing software
>>>>>>> simply not working properly in a guest.  The only case that can
>>>>>>> consistently "work" today is not giving the guest a PMU at all.

Actually I'd be more interested to check the exact "not working properly" usage.

>>>>>>>
>>>>>>> And that's why you are hearing requests to gift the entire PMU to the
>>>>>>> guest while it is running. All existing PMU software knows about the
>>>>>>> various constraints on exactly how each MSR must be used to get sane
>>>>>>> data.  And by gifting the entire PMU it allows that software to work
>>>>>>> properly.  But that has to be controlled by policy at host level such
>>>>>>> that the owner of the host knows that they are not going to have PMU
>>>>>>> visibility into guests that have control of PMU.

Don't forget that the perf subsystem manages uncore-pmu and
other profiling resources as well. Making host perf visible to some
resources and invisible to others would require big effort and it
would be very unmaintainable as the pmu hardware resources
become more and more numerous.

IMO, there is no future in having host perf get special for KVM.

>>>>>>>
>>>>>>
>>>>>> I think here is how a guest event works today with KVM and perf subsystem.
>>>>>>         - Guest create an event A
>>>>>>         - The guest kernel assigns a guest counter M to event A, and config
>>>>>> the related MSRs of the guest counter M.
>>>>>>         - KVM intercepts the MSR access and create a host event B. (The
>>>>>> host event B is based on the settings of the guest counter M. As I said,
>>>>>> at least for Linux, some SW config impacts the counter assignment. KVM
>>>>>> never knows it. Event B can only be a similar event to A.)
>>>>>>         - Linux perf subsystem assigns a physical counter N to a host event
>>>>>> B according to event B's constraint. (N may not be the same as M,
>>>>>> because A and B may have different event constraints)

There is also the priority availability of previous scheduling policies.
This cross-mapping is relatively common and normal in the real world.

>>>>>>
>>>>>> As you can see, even the entire PMU is given to the guest, we still
>>>>>> cannot guarantee that the physical counter M can be assigned to the
>>>>>> guest event A.
>>>>>
>>>>> All we know about the guest is that it has programmed virtual counter
>>>>> M. It seems obvious to me that we can satisfy that request by giving
>>>>> it physical counter M. If, for whatever reason, we give it physical
>>>>> counter N isntead, and M and N are not completely fungible, then we
>>>>> have failed.

Only host perf has the global perspective to derive interchangeability,
which is a reasonable and flexible design.

>>>>>
>>>>>> How to fix it? The only thing I can imagine is "passthrough". Let KVM
>>>>>> directly assign the counter M to guest. So, to me, this policy sounds
>>>>>> like let KVM replace the perf to control the whole PMU resources, and we
>>>>>> will handover them to our guest then. Is it what we want?

I would prefer to see more code on this idea, as I am very unsure
of my code practice based on the current hardware interface, and
the TDX PMU enablement work might be a good starting point.

>>>>>
>>>>> We want PMU virtualization to work. There are at least two ways of doing that:
>>>>> 1) Cede the entire PMU to the guest while it's running.
>>>>
>>>> So the guest will take over the control of the entire PMUs while it's
>>>> running. I know someone wants to do system-wide monitoring. This case
>>>> will be failed.

I think from the vm-entry/exit level of granularity, we can do it
even if someone wants to do system-wide monitoring, and the
hard part is the sharing, synchronization and filtering of perf data.

>>>
>>> We have system-wide monitoring for fleet efficiency, but since there's
>>> nothing we can do about the efficiency of the guest (and those cycles
>>> are paid for by the customer, anyway), I don't think our efficiency
>>> experts lose any important insights if guest cycles are a blind spot.

Visibility of (non-tdx/sev) guest performance data helps with global optimal
solutions, such as memory migration and malicious attack detection, and
there are too many other PMU use cases that ignore the vm-entry boundary.

>>
>> Others, e.g., NMI watchdog, also occupy a performance counter. I think
>> the NMI watchdog is enabled by default at least for the current Linux
>> kernel. You have to disable all such cases in the host when the guest is
>> running.
> 
> It doesn't actually make any sense to run the NMI watchdog while in
> the guest, does it?

I wouldn't think so, AFAI a lot of guest vendor images run the NMI watchdog.

> 
>>>
>>>> I'm not sure whether you can fully trust the guest. If malware runs in
>>>> the guest, I don't know whether it will harm the entire system. I'm not
>>>> a security expert, but it sounds dangerous.
>>>> Hope the administrators know what they are doing when choosing this policy.

We always consider the security attack surface when choosing which
pmu features can be virtualized. Until someone gives us a negative answer,
then we quietly and urgently fix it. We already have the module parameter
for vPMU, and the per-vm parameters are in the air.

>>>
>>> Virtual machines are inherently dangerous. :-)

Without a specific context, any hardware or software stack is inherently dangerous.

>>>
>>> Despite our concerns about PMU side-channels, Intel is constantly
>>> reminding us that no such attacks are yet known. We would probably
>>> restrict some events to guests that occupy an entire socket, just to
>>> be safe.

The socket level performance data should not be available for current guests.

>>>
>>> Note that on the flip side, TDX and SEV are all about catering to
>>> guests that don't trust the host. Those customers probably don't want
>>> the host to be able to use the PMU to snoop on guest activity.

Of course, for non-tdx/sev guests, we (upstream) should not prevent the PMU
from being used to snoop on guest activity. How it is used is a matter for
the administrators, but usability or feasibility is a technical consideration.

>>>
>>>>> 2) Introduce a new "ultimate" priority level in the host perf
>>>>> subsystem. Only KVM can request events at the ultimate priority, and
>>>>> these requests supersede any other requests.
>>>>
>>>> The "ultimate" priority level doesn't help in the above case. The
>>>> counter M may not bring the precise which guest requests. I remember you
>>>> called it "broken".
>>>
>>> Ideally, ultimate priority also comes with the ability to request
>>> specific counters.

We need to relay the vcpu's specific needs for counters of different
capabilities to the host perf so that it can make the right decisions.

>>>
>>>> KVM can fails the case, but KVM cannot notify the guest. The guest still
>>>> see wrong result.

Indeed, the pain point is "KVM cannot notify the guest.", or we need to
remove all the "reasons for notification" one by one.

>>>>
>>>>>
>>>>> Other solutions are welcome.
>>>>
>>>> I don't have a perfect solution to achieve all your requirements. Based
>>>> on my understanding, the guest has to be compromised by either
>>>> tolerating some errors or dropping some features (e.g., some special
>>>> events). With that, we may consider the above "ultimate" priority level
>>>> policy. The default policy would be the same as the current
>>>> implementation, where the host perf treats all the users, including the
>>>> guest, equally. The administrators can set the "ultimate" priority level
>>>> policy, which may let the KVM/guest pin/own some regular counters via
>>>> perf subsystem. That's just my personal opinion for your reference.
>>>
>>> I disagree. The guest does not have to be compromised. For a proof of
>>> concept, see VMware ESXi. Probably Microsoft Hyper-V as well, though I
>>> haven't checked.
>>
>> As far as I know, VMware ESXi has its own VMkernel, which can owns the
>> entire HW PMUs.  The KVM is part of the Linux kernel. The HW PMUs should
>> be shared among components/users. I think the cases are different.
> 
> Architecturally, ESXi is not very different from Linux. The VMkernel
> is a posix-compliant kernel, and VMware's "vmm" is comparable to kvm.
> 
>> Also, from what I searched on the VMware website, they still encounter
>> the case that a guest VM may not get a performance monitoring counter.
>> It looks like their solution is to let guest OS check the availability
>> of the counter, which is similar to the solution I mentioned (Use
>> GLOBAL_INUSE MSR).
>>
>> "If an ESXi host's BIOS uses a performance counter or if Fault Tolerance
>> is enabled, some virtual performance counters might not be available for
>> the virtual machine to use."
> 
> I'm perfectly happy to give up PMCs on Linux under those same conditions.
> 
>> https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.vsphere.vm_admin.doc/GUID-F920A3C7-3B42-4E78-8EA7-961E49AF479D.html
>>
>> "In general, if a physical CPU PMC is in use, the corresponding virtual
>> CPU PMC is not functional and is unavailable for use by the guest. Guest
>> OS software detects unavailable general purpose PMCs by checking for a
>> non-zero event select MSR value when a virtual machine powers on."
>>
>> https://kb.vmware.com/s/article/2030221
>>
> Linux, at least, doesn't do that. Maybe Windows does.
> 
>> Thanks,
>> Kan
>>
