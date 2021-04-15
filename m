Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4045336005E
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 05:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhDODYI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 23:24:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:48391 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229853AbhDODYG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 23:24:06 -0400
IronPort-SDR: iDoUQyd2cXMvY3qodPNaVvUwslDQ8IoH9TaNlL2Bk2KZWObw+ZFN/oCYHS9Q0iGMO+J9EiIWBL
 St2vP/QvOXBA==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="194889886"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="194889886"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 20:23:44 -0700
IronPort-SDR: nlm/WecwwNqgbtHsmzB33KM9/VNaHcu+Py3c0xb8JQFANHdm+fY67fvqqZ4G4Da6UYyf4t55S8
 QjnQBbrKmAsg==
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="425014595"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 20:23:41 -0700
Subject: Re: [PATCH v4 01/16] perf/x86/intel: Add x86_pmu.pebs_vmx for Ice
 Lake Servers
To:     Liuxiangdong <liuxiangdong5@huawei.com>
Cc:     andi@firstfloor.org, "Fangyi (Eric)" <eric.fangyi@huawei.com>,
        Xiexiangyou <xiexiangyou@huawei.com>, kan.liang@linux.intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        wei.w.wang@intel.com, x86@kernel.org,
        "Xu, Like" <like.xu@intel.com>
References: <20210329054137.120994-2-like.xu@linux.intel.com>
 <606BD46F.7050903@huawei.com>
 <18597e2b-3719-8d0d-9043-e9dbe39496a2@intel.com>
 <60701165.3060000@huawei.com>
 <1ba15937-ee3d-157a-e891-981fed8b414d@linux.intel.com>
 <607700F2.9080409@huawei.com>
 <76467c36-3399-a123-d582-92affadc4d73@intel.com>
 <6077A9AE.2090705@huawei.com>
From:   Like Xu <like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <de8cde39-f6d8-e3b9-427b-86f7e916d8a1@linux.intel.com>
Date:   Thu, 15 Apr 2021 11:23:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <6077A9AE.2090705@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/4/15 10:49, Liuxiangdong wrote:
> 
> 
> On 2021/4/15 9:38, Xu, Like wrote:
>> On 2021/4/14 22:49, Liuxiangdong wrote:
>>> Hi Like,
>>>
>>> On 2021/4/9 16:46, Like Xu wrote:
>>>> Hi Liuxiangdong,
>>>>
>>>> On 2021/4/9 16:33, Liuxiangdong (Aven, Cloud Infrastructure Service 
>>>> Product Dept.) wrote:
>>>>> Do you have any comments or ideas about it ?
>>>>>
>>>>> https://lore.kernel.org/kvm/606E5EF6.2060402@huawei.com/
>>>>
>>>> My expectation is that there may be many fewer PEBS samples
>>>> on Skylake without any soft lockup.
>>>>
>>>> You may need to confirm the statement
>>>>
>>>> "All that matters is that the EPT pages don't get
>>>> unmapped ever while PEBS is active"
>>>>
>>>> is true in the kernel level.
>>>>
>>>> Try "-overcommit mem-lock=on" for your qemu.
>>>>
>>>
>>> Sorry, in fact, I don't quite understand
>>> "My expectation is that there may be many fewer PEBS samples on Skylake 
>>> without any soft lockup. "
>>
>> For testcase: perf record -e instructions:pp ./workload
>>
>> We can get 2242 samples on the ICX guest, but
>> only 17 samples or less on the Skylake guest.
>>
>> In my testcase on Skylake, neither the host nor the guest triggered the 
>> soft lock.
>>
> 
> Thanks for your explanation！
> Could you please show your complete qemu command and qemu version used on 
> Skylake?
> I hope I can test it again according to your qemu cmd and version.

A new version is released and you may have a try.

qemu command: "-enable-kvm -cpu host,migratable=no"
qemu base commit: db55d2c9239d445cb7f1fa8ede8e42bd339058f4
kvm base commit: f96be2deac9bca3ef5a2b0b66b71fcef8bad586d

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 63c55f45ca92..727f55400eaf 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -5618,6 +5618,7 @@ __init int intel_pmu_init(void)
  	case INTEL_FAM6_KABYLAKE:
  	case INTEL_FAM6_COMETLAKE_L:
  	case INTEL_FAM6_COMETLAKE:
+		x86_pmu.pebs_vmx = 1;
  		x86_add_quirk(intel_pebs_isolation_quirk);
  		x86_pmu.late_ack = true;
  		memcpy(hw_cache_event_ids, skl_hw_cache_event_ids, 
sizeof(hw_cache_event_ids));
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 100a749251b8..9e37e3dbe3ae 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -150,9 +150,8 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, 
u32 type,
  		 * the accuracy of the PEBS profiling result, because the "event IP"
  		 * in the PEBS record is calibrated on the guest side.
  		 */
-		attr.precise_ip = 1;
-		if (x86_match_cpu(vmx_icl_pebs_cpu) && pmc->idx == 32)
-			attr.precise_ip = 3;
+		attr.precise_ip = x86_match_cpu(vmx_icl_pebs_cpu) ?
+			((pmc->idx == 32) ? 3 : 1) : ((pmc->idx == 1) ? 3 : 1);
  	}

  	event = perf_event_create_kernel_counter(&attr, -1, current,

> 
> 
>>>
>>> And, I have used "-overcommit mem-lock=on"  when soft lockup happens.
>>
>> I misunderstood the use of "mem-lock=on". It is not the same as the
>> guest mem pin and I believe more kernel patches are needed.
>>
>>>
>>>
>>> Now, I have tried to configure 1G-hugepages for 2G-mem vm. Each of guest 
>>> numa nodes has 1G mem.
>>> When I use pebs(perf record -e cycles:pp) in guest, there are successful 
>>> pebs samples just for a while and
>>> then I cannot get pebs samples. Host doesn't soft lockup in this process.
>>
>> In the worst case, no samples are expected.
>>
>>>
>>> Are there something wrong on skylake for we can only get a few samples? 
>>> IRQ?  Or using hugepage is not effecitve?
>>
>> The few samples comes from hardware limitation.
>> The Skylake doesn't have this "EPT-Friendly PEBS" capabilityand
>> some PEBS records will be lost when used by guests.
>>
>>>
>>> Thanks!
>>>
>>>>>
>>>>>
>>>>> On 2021/4/6 13:14, Xu, Like wrote:
>>>>>> Hi Xiangdong,
>>>>>>
>>>>>> On 2021/4/6 11:24, Liuxiangdong (Aven, Cloud Infrastructure Service 
>>>>>> Product Dept.) wrote:
>>>>>>> Hi，like.
>>>>>>> Some questions about this new pebs patches set：
>>>>>>> https://lore.kernel.org/kvm/20210329054137.120994-2-like.xu@linux.intel.com/ 
>>>>>>>
>>>>>>>
>>>>>>> The new hardware facility supporting guest PEBS is only available
>>>>>>> on Intel Ice Lake Server platforms for now.
>>>>>>
>>>>>> Yes, we have documented this "EPT-friendly PEBS" capability in the SDM
>>>>>> 18.3.10.1 Processor Event Based Sampling (PEBS) Facility
>>>>>>
>>>>>> And again, this patch set doesn't officially support guest PEBS on 
>>>>>> the Skylake.
>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> AFAIK， Icelake supports adaptive PEBS and extended PEBS which 
>>>>>>> Skylake doesn't.
>>>>>>> But we can still use IA32_PEBS_ENABLE MSR to indicate 
>>>>>>> general-purpose counter in Skylake.
>>>>>>
>>>>>> For Skylake, only the PMC0-PMC3 are valid for PEBS and you may
>>>>>> mask the other unsupported bits in the pmu->pebs_enable_mask.
>>>>>>
>>>>>>> Is there anything else that only Icelake supports in this patches set?
>>>>>>
>>>>>> The PDIR counter on the Ice Lake is the fixed counter 0
>>>>>> while the PDIR counter on the Sky Lake is the gp counter 1.
>>>>>>
>>>>>> You may also expose x86_pmu.pebs_vmx for Skylake in the 1st patch.
>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> Besides, we have tried this patches set in Icelake.  We can use 
>>>>>>> pebs(eg: "perf record -e cycles:pp")
>>>>>>> when guest is kernel-5.11, but can't when kernel-4.18. Is there a 
>>>>>>> minimum guest kernel version requirement?
>>>>>>
>>>>>> The Ice Lake CPU model has been added since v5.4.
>>>>>>
>>>>>> You may double check whether the stable tree(s) code has
>>>>>> INTEL_FAM6_ICELAKE in the arch/x86/include/asm/intel-family.h.
>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> Thanks,
>>>>>>> Xiangdong Liu
>>>>>>
>>>>>
>>>>
>>>
>>
> 

