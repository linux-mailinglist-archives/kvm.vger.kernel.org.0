Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB6D25CF2B
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 03:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729318AbgIDB5w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 21:57:52 -0400
Received: from mga12.intel.com ([192.55.52.136]:25205 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728484AbgIDB5v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Sep 2020 21:57:51 -0400
IronPort-SDR: Vch5F0pNReBAOgQTHei/snMIA7X/Wg90206vxFwZRkP830cL46HWAWGHO3MYyc5gl+9nf65nMW
 8NE4Yn0/X/dw==
X-IronPort-AV: E=McAfee;i="6000,8403,9733"; a="137202445"
X-IronPort-AV: E=Sophos;i="5.76,387,1592895600"; 
   d="scan'208";a="137202445"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2020 18:57:50 -0700
IronPort-SDR: gTyN4VMmZz9V1s1j6AMZApLUZNlaun6tcWZBe70QEXN29wYdu6ppqk3WmfYmq9gboDKJMjUbEU
 ygAm323bzgEQ==
X-IronPort-AV: E=Sophos;i="5.76,387,1592895600"; 
   d="scan'208";a="478274625"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.128]) ([10.238.4.128])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2020 18:57:48 -0700
Reply-To: like.xu@intel.com
Subject: Re: [PATCH v13 00/10] Guest Last Branch Recording Enabling (KVM part)
To:     Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Wei Wang <wei.w.wang@intel.com>
References: <20200726153229.27149-1-like.xu@linux.intel.com>
 <6d4d7b00-cbca-9875-24bd-e6c4efaf0586@intel.com>
From:   "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <1bd46904-5620-5395-ff89-5176c16c477e@intel.com>
Date:   Fri, 4 Sep 2020 09:57:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <6d4d7b00-cbca-9875-24bd-e6c4efaf0586@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Do you have time or plan to review this patch series in this kernel cycle
since we have merged perf patches in the upstream to make it happen ?

Thanks,
Like Xu

On 2020/8/14 16:48, Xu, Like wrote:
> Are there no interested reviewers or users?
>
> Just a kindly ping.
>
> On 2020/7/26 23:32, Like Xu wrote:
>> Hi Paolo,
>>
>> Please review this new version for the Kernel 5.9 release, and
>> Sean may not review them as he said in the previous email
>> https://lore.kernel.org/kvm/20200710162819.GF1749@linux.intel.com/
>>
>> You may cherry-pick the perf patches "3cb9d5464c1c..e1ad1ac2deb8"
>> from the branch "tip/perf/core" of scm/linux/kernel/git/tip/tip.git
>> as PeterZ said in the previous email
>> https://lore.kernel.org/kvm/20200703075646.GJ117543@hirez.programming.kicks-ass.net/ 
>>
>>
>> We may also apply the qemu-devel patch to the upstream qemu and try
>> the QEMU command lines with '-cpu host' or '-cpu host,pmu=true,lbr=true'.
>>
>> The following error will be gone forever with the patchset:
>>
>>    $ perf record -b lbr ${WORKLOAD}
>>    or $ perf record --call-graph lbr ${WORKLOAD}
>>    Error:
>>    cycles: PMU Hardware doesn't support sampling/overflow-interrupts. 
>> Try 'perf stat'
>>
>> Please check more details in each commit and feel free to test.
>>
>> v12->v13 Changelog:
>> - remove perf patches since they're queued in the tip/perf/core;
>> - add a minor patch to refactor MSR_IA32_DEBUGCTLMSR set/get handler;
>> - add a minor patch to expose vmx_set_intercept_for_msr();
>> - add a minor patch to initialize perf_capabilities in the 
>> intel_pmu_init();
>> - spilt the big patch to three pieces (0004-0006) for better 
>> understanding and review
>> - make the LBR_FMT exposure patch as the last step to enable guest LBR;
>>
>> Previous:
>> https://lore.kernel.org/kvm/20200613080958.132489-1-like.xu@linux.intel.com/ 
>>
>>
>> ---
>>
>> The last branch recording (LBR) is a performance monitor unit (PMU)
>> feature on Intel processors that records a running trace of the most
>> recent branches taken by the processor in the LBR stack. This patch
>> series is going to enable this feature for plenty of KVM guests.
>>
>> The user space could configure whether it's enabled or not for each
>> guest via MSR_IA32_PERF_CAPABILITIES msr. As a first step, a guest
>> could only enable LBR feature if its cpu model is the same as the
>> host since the LBR feature is still one of model specific features.
>>
>> If it's enabled on the guest, the guest LBR driver would accesses the
>> LBR MSR (including IA32_DEBUGCTLMSR and records MSRs) as host does.
>> The first guest access on the LBR related MSRs is always interceptible.
>> The KVM trap would create a special LBR event (called guest LBR event)
>> which enables the callstack mode and none of hardware counter is assigned.
>> The host perf would enable and schedule this event as usual.
>>
>> Guest's first access to a LBR registers gets trapped to KVM, which
>> creates a guest LBR perf event. It's a regular LBR perf event which gets
>> the LBR facility assigned from the perf subsystem. Once that succeeds,
>> the LBR stack msrs are passed through to the guest for efficient accesses.
>> However, if another host LBR event comes in and takes over the LBR
>> facility, the LBR msrs will be made interceptible, and guest following
>> accesses to the LBR msrs will be trapped and meaningless.
>>
>> Because saving/restoring tens of LBR MSRs (e.g. 32 LBR stack entries) in
>> VMX transition brings too excessive overhead to frequent vmx transition
>> itself, the guest LBR event would help save/restore the LBR stack msrs
>> during the context switching with the help of native LBR event callstack
>> mechanism, including LBR_SELECT msr.
>>
>> If the guest no longer accesses the LBR-related MSRs within a scheduling
>> time slice and the LBR enable bit is unset, vPMU would release its guest
>> LBR event as a normal event of a unused vPMC and the pass-through
>> state of the LBR stack msrs would be canceled.
>>
>> ---
>>
>> LBR testcase:
>> echo 1 > /proc/sys/kernel/watchdog
>> echo 25 > /proc/sys/kernel/perf_cpu_time_max_percent
>> echo 5000 > /proc/sys/kernel/perf_event_max_sample_rate
>> echo 0 > /proc/sys/kernel/perf_cpu_time_max_percent
>> ./perf record -b ./br_instr a
>>
>> - Perf report on the host:
>> Samples: 72K of event 'cycles', Event count (approx.): 72512
>> Overhead  Command   Source Shared Object           Source 
>> Symbol                           Target Symbol                           
>> Basic Block Cycles
>>    12.12%  br_instr  br_instr                       [.] 
>> cmp_end                             [.] 
>> lfsr_cond                           1
>>    11.05%  br_instr  br_instr                       [.] 
>> lfsr_cond                           [.] 
>> cmp_end                             5
>>     8.81%  br_instr  br_instr                       [.] 
>> lfsr_cond                           [.] 
>> cmp_end                             4
>>     5.04%  br_instr  br_instr                       [.] 
>> cmp_end                             [.] 
>> lfsr_cond                           20
>>     4.92%  br_instr  br_instr                       [.] 
>> lfsr_cond                           [.] 
>> cmp_end                             6
>>     4.88%  br_instr  br_instr                       [.] 
>> cmp_end                             [.] 
>> lfsr_cond                           6
>>     4.58%  br_instr  br_instr                       [.] 
>> cmp_end                             [.] 
>> lfsr_cond                           5
>>
>> - Perf report on the guest:
>> Samples: 92K of event 'cycles', Event count (approx.): 92544
>> Overhead  Command   Source Shared Object  Source 
>> Symbol                                   Target 
>> Symbol                                   Basic Block Cycles
>>    12.03%  br_instr  br_instr              [.] 
>> cmp_end                                     [.] 
>> lfsr_cond                                   1
>>    11.09%  br_instr  br_instr              [.] 
>> lfsr_cond                                   [.] 
>> cmp_end                                     5
>>     8.57%  br_instr  br_instr              [.] 
>> lfsr_cond                                   [.] 
>> cmp_end                                     4
>>     5.08%  br_instr  br_instr              [.] 
>> lfsr_cond                                   [.] 
>> cmp_end                                     6
>>     5.06%  br_instr  br_instr              [.] 
>> cmp_end                                     [.] 
>> lfsr_cond                                   20
>>     4.87%  br_instr  br_instr              [.] 
>> cmp_end                                     [.] 
>> lfsr_cond                                   6
>>     4.70%  br_instr  br_instr              [.] 
>> cmp_end                                     [.] 
>> lfsr_cond                                   5
>>
>> Conclusion: the profiling results on the guest are similar to that on 
>> the host.
>>
>> Like Xu (10):
>>    KVM: x86: Move common set/get handler of MSR_IA32_DEBUGCTLMSR to VMX
>>    KVM: x86/vmx: Make vmx_set_intercept_for_msr() non-static and expose it
>>    KVM: vmx/pmu: Initialize vcpu perf_capabilities once in intel_pmu_init()
>>    KVM: vmx/pmu: Clear PMU_CAP_LBR_FMT when guest LBR is disabled
>>    KVM: vmx/pmu: Create a guest LBR event when vcpu sets DEBUGCTLMSR_LBR
>>    KVM: vmx/pmu: Pass-through LBR msrs to when the guest LBR event is 
>> ACTIVE
>>    KVM: vmx/pmu: Reduce the overhead of LBR pass-through or cancellation
>>    KVM: vmx/pmu: Emulate legacy freezing LBRs on virtual PMI
>>    KVM: vmx/pmu: Expose LBR_FMT in the MSR_IA32_PERF_CAPABILITIES
>>    KVM: vmx/pmu: Release guest LBR event via lazy release mechanism
>>
>>   arch/x86/kvm/pmu.c              |  12 +-
>>   arch/x86/kvm/pmu.h              |   5 +
>>   arch/x86/kvm/vmx/capabilities.h |  22 ++-
>>   arch/x86/kvm/vmx/pmu_intel.c    | 296 +++++++++++++++++++++++++++++++-
>>   arch/x86/kvm/vmx/vmx.c          |  44 ++++-
>>   arch/x86/kvm/vmx/vmx.h          |  28 +++
>>   arch/x86/kvm/x86.c              |  15 +-
>>   7 files changed, 395 insertions(+), 27 deletions(-)
>>
>

