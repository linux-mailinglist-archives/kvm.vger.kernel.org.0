Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587D230A381
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 09:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbhBAIor (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 03:44:47 -0500
Received: from mga18.intel.com ([134.134.136.126]:60925 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229558AbhBAIop (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 03:44:45 -0500
IronPort-SDR: MjZpA7Mm8v4RkzjnqTSnDrX2KNGwJnmgHrexlBzFmaSUuy57KZCEjpUHbAcLaOWEAOb0O4Uoq/
 HMa45b069TlA==
X-IronPort-AV: E=McAfee;i="6000,8403,9881"; a="168335246"
X-IronPort-AV: E=Sophos;i="5.79,392,1602572400"; 
   d="scan'208";a="168335246"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 00:44:04 -0800
IronPort-SDR: vbviZhVOw4HX8Yv2mHRTxHfIDdYc8cZQgkshTmWaUMp2YqVXZXf0cmD81SuNCkZgaV4vMkJRiF
 on6Nb0qvfRoA==
X-IronPort-AV: E=Sophos;i="5.79,392,1602572400"; 
   d="scan'208";a="390810543"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 00:44:02 -0800
Subject: Re: [PATCH v3 00/17] KVM: x86/pmu: Add support to enable Guest PEBS
 via DS
To:     "Liuxiangdong (Aven, Cloud Infrastructure Service Product Dept.)" 
        <liuxiangdong5@huawei.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Xiexiangyou <xiexiangyou@huawei.com>,
        Wei Wang <wei.w.wang@intel.com>, kvm <kvm@vger.kernel.org>,
        Like Xu <like.xu@linux.intel.com>,
        "Fangyi (Eric)" <eric.fangyi@huawei.com>
References: <EEC2A80E7137D84ABF791B01D40FA9A601EC200E@DGGEMM506-MBX.china.huawei.com>
 <584b4e9a-37e7-1f2a-0a67-42034329a9dc@linux.intel.com>
 <600ED9F7.1060503@huawei.com>
 <f4dcb068-2ddf-428f-50ad-39f65cad3710@intel.com>
 <6013787F.2080405@huawei.com>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <062d042b-624f-c761-fe3d-7a7395ca8812@intel.com>
Date:   Mon, 1 Feb 2021 16:43:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <6013787F.2080405@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/1/29 10:52, Liuxiangdong (Aven, Cloud Infrastructure Service 
Product Dept.) wrote:
>
>
> On 2021/1/26 15:08, Xu, Like wrote:
>> On 2021/1/25 22:47, Liuxiangdong (Aven, Cloud Infrastructure Service
>> Product Dept.) wrote:
>>> Thanks for replying,
>>>
>>> On 2021/1/25 10:41, Like Xu wrote:
>>>> + kvm@vger.kernel.org
>>>>
>>>> Hi Liuxiangdong,
>>>>
>>>> On 2021/1/22 18:02, Liuxiangdong (Aven, Cloud Infrastructure Service
>>>> Product Dept.) wrote:
>>>>> Hi Like,
>>>>>
>>>>> Some questions about
>>>>> https://lore.kernel.org/kvm/20210104131542.495413-1-like.xu@linux.intel.com/ 
>>>>>
>>>>> <https://lore.kernel.org/kvm/20210104131542.495413-1-like.xu@linux.intel.com/> 
>>>>>
>>>>>
>>>> Thanks for trying the PEBS feature in the guest,
>>>> and I assume you have correctly applied the QEMU patches for guest PEBS.
>>>>
>>> Is there any other patch that needs to be apply? I use qemu 5.2.0.
>>> (download from github on January 14th)
>> Two qemu patches are attached against qemu tree
>> (commit 31ee895047bdcf7387e3570cbd2a473c6f744b08)
>> and then run the guest with "-cpu,pebs=true".
>>
>> Note, this two patch are just for test and not finalized for qemu upstream.
> Yes, we can use pebs in IceLake when qemu patches applied.
> Thanks very much!

Thanks for your verification on this earlier version.

>>>>> 1)Test in IceLake
>>>> In the [PATCH v3 10/17] KVM: x86/pmu: Expose CPUIDs feature bits PDCM,
>>>> DS, DTES64, we only support Ice Lake with the following x86_model(s):
>>>>
>>>> #define INTEL_FAM6_ICELAKE_X        0x6A
>>>> #define INTEL_FAM6_ICELAKE_D        0x6C
>>>>
>>>> you can check the eax output of "cpuid -l 1 -1 -r",
>>>> for example "0x000606a4" meets this requirement.
>>> It's INTEL_FAM6_ICELAKE_X
>> Yes, it's the target hardware.
>>
>>> cpuid -l 1 -1 -r
>>>
>>> CPU:
>>>     0x00000001 0x00: eax=0x000606a6 ebx=0xb4800800 ecx=0x7ffefbf7
>>> edx=0xbfebfbff
>>>
>>>>> HOST:
>>>>>
>>>>> CPU family:                      6
>>>>>
>>>>> Model:                           106
>>>>>
>>>>> Model name:                      Intel(R) Xeon(R) Platinum 8378A CPU 
>>>>> $@ $@
>>>>>
>>>>> microcode: sig=0x606a6, pf=0x1, revision=0xd000122
>>>> As long as you get the latest BIOS from the provider,
>>>> you may check 'cat /proc/cpuinfo | grep code | uniq' with the latest one.
>>> OK. I'll do it later.
>>>>> Guest:  linux kernel 5.11.0-rc2
>>>> I assume it's the "upstream tag v5.11-rc2" which is fine.
>>> Yes.
>>>>> We can find pebs/intel_pt flag in guest cpuinfo, but there still exists
>>>>> error when we use perf
>>>> Just a note, intel_pt and pebs are two features and we can write
>>>> pebs records to intel_pt buffer with extra hardware support.
>>>> (by default, pebs records are written to the pebs buffer)
>>>>
>>>> You may check the output of "dmesg | grep PEBS" in the guest
>>>> to see if the guest PEBS cpuinfo is exposed and use "perf record
>>>> –e cycles:pp" to see if PEBS feature actually  works in the guest.
>>> I apply only pebs patch set to linux kernel 5.11.0-rc2, test perf in
>>> guest and dump stack when return -EOPNOTSUPP
>> Yes, you may apply the qemu patches and try it again.
>>
>>> (1)
>>> # perf record -e instructions:pp
>>> Error:
>>> instructions:pp: PMU Hardware doesn't support
>>> sampling/overflow-interrupts. Try 'perf stat'
>>>
>>> [  117.793266] Call Trace:
>>> [  117.793270]  dump_stack+0x57/0x6a
>>> [  117.793275]  intel_pmu_setup_lbr_filter+0x137/0x190
>>> [  117.793280]  intel_pmu_hw_config+0x18b/0x320
>>> [  117.793288]  hsw_hw_config+0xe/0xa0
>>> [  117.793290]  x86_pmu_event_init+0x8e/0x210
>>> [  117.793293]  perf_try_init_event+0x40/0x130
>>> [  117.793297]  perf_event_alloc.part.22+0x611/0xde0
>>> [  117.793299]  ? alloc_fd+0xba/0x180
>>> [  117.793302]  __do_sys_perf_event_open+0x1bd/0xd90
>>> [  117.793305]  do_syscall_64+0x33/0x40
>>> [  117.793308]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>>
>>> Do we need lbr when we use pebs?
>> No, lbr ane pebs are two features and we enable it separately.
>>
>>> I tried to apply lbr patch
>>> set(https://lore.kernel.org/kvm/911adb63-ba05-ea93-c038-1c09cff15eda@intel.com/) 
>>>
>>> to kernel and qemu, but there is still other problem.
>>> Error:
>>> The sys_perf_event_open() syscall returned with 22 (Invalid argument) for
>>> event
>>> ...
>> We don't need that patch for PEBS feature.
>>
>>> (2)
>>> # perf record -e instructions:ppp
>>> Error:
>>> instructions:ppp: PMU Hardware doesn't support
>>> sampling/overflow-interrupts. Try 'perf stat'
>>>
>>> [  115.188498] Call Trace:
>>> [  115.188503]  dump_stack+0x57/0x6a
>>> [  115.188509]  x86_pmu_hw_config+0x1eb/0x220
>>> [  115.188515]  intel_pmu_hw_config+0x13/0x320
>>> [  115.188519]  hsw_hw_config+0xe/0xa0
>>> [  115.188521]  x86_pmu_event_init+0x8e/0x210
>>> [  115.188524]  perf_try_init_event+0x40/0x130
>>> [  115.188528]  perf_event_alloc.part.22+0x611/0xde0
>>> [  115.188530]  ? alloc_fd+0xba/0x180
>>> [  115.188534]  __do_sys_perf_event_open+0x1bd/0xd90
>>> [  115.188538]  do_syscall_64+0x33/0x40
>>> [  115.188541]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>>
>>> This is beacuse x86_pmu.intel_cap.pebs_format is always 0 in
>>> x86_pmu_max_precise().
>>>
>>> We rdmsr MSR_IA32_PERF_CAPABILITIES(0x00000345)  from HOST, it's f4c5.
>>>  From guest, it's 2000
>>>
>>>>> # perf record –e cycles:pp
>>>>>
>>>>> Error:
>>>>>
>>>>> cycles:pp: PMU Hardware doesn’t support sampling/overflow-interrupts.
>>>>> Try ‘perf stat’
>>>>>
>>>>> Could you give some advice?
>>>> If you have more specific comments or any concerns, just let me know.
>>>>
>>>>> 2)Test in Skylake
>>>>>
>>>>> HOST:
>>>>>
>>>>> CPU family:                      6
>>>>>
>>>>> Model:                           85
>>>>>
>>>>> Model name:                      Intel(R) Xeon(R) Gold 6146 CPU @
>>>>>
>>>>>                                     3.20GHz
>>>>>
>>>>> microcode        : 0x2000064
>>>>>
>>>>> Guest: linux 4.18
>>>>>
>>>>> we cannot find intel_pt flag in guest cpuinfo because
>>>>> cpu_has_vmx_intel_pt() return false.
>>>> You may check vmx_pebs_supported().
>>> It's true.
>>>>> SECONDARY_EXEC_PT_USE_GPA/VM_EXIT_CLEAR_IA32_RTIT_CTL/VM_ENTRY_LOAD_IA32_RTIT_CTL 
>>>>>
>>>>> are both disable.
>>>>>
>>>>> Is it because microcode is not supported?
>>>>>
>>>>> And, isthere a new macrocode which can support these bits? How can we
>>>>> get this?
>>>> Currently, this patch set doesn't support guest PEBS on the Skylake
>>>> platforms, and if we choose to support it, we will let you know.
>>>>
>>> And now, we want to use pebs in skylake. If we develop based on pebs
>>> patch set, do you have any suggestions?
>> - At least you need to pin guest memory such as "-overcommit mem-lock=true"
>> for qemu
>> - You may rewrite the patches 13 - 17 for Skylake specific because the
>> records format is different with Ice Lake.
> OK. So, is there anything else we need to pay attention to except record 
> format when used for Skylake?

You may need:
- remove x86_match_cpu check in the vmx_pebs_supported()
- add intel_pmu_handle_guest_pebs() to the intel_pmu_drain_pebs_nhm()

I suggest that you may pick up the one-one mapping patch from the v1
so that you can get avoid of patches 13 - 17.

>>> I think microcode requirements need to be satisfied.  Can we use
>>> https://github.com/intel/Intel-Linux-Processor-Microcode-Data-Files ?
>> You may try it at your risk and again,
>> this patch set doesn't support guest PEBS on the Skylake platforms 
>> currently.
>>
>>>> ---
>>>> thx,likexu
>>>>
>>>>> Thanks,
>>>>>
>>>>> Liuxiangdong
>>>>>
>>> Thanks. Liuxiangdong
>>>
>

