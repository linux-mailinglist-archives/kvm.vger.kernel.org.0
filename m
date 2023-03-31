Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70E356D2173
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 15:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbjCaN0q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 09:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjCaN0o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 09:26:44 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05791D2C6;
        Fri, 31 Mar 2023 06:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680269203; x=1711805203;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=aj9UVU10nk+SSrkG/0LsLStugM/6Ixl3SYYPuFOAiFI=;
  b=jsj3D8BmrpXw9cd09T6RNBDYNeZjhLrylyzyBljzVCg1PhAOB9LOFQco
   dQS3QqWpyh+QUiAWD41Q4+sb5QEF7CLSVpLYY+XSXBJEgKb4D4V9KfTgA
   VrBGDSVn0Ye2g1xDPG4d6kZa3l4k/t6gcgUtm9MKJNJtt12TPIS40lUEM
   EtzNrWoFYv7yFVm2RncRWWbyOXeuwCkyGkq1acHbk4aySlTuiZosUnUyW
   GBuJu+7J4z/Wy6EM0WAcXu+D2+BunPJv79VbwzvSahEMEFx0XGeM38MAT
   iD3Lvptm+pcHV8ds7JSTS+uuvpSuRchQbd+TAkU5peMAC2OkL/4ECNgW1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10666"; a="321839694"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="321839694"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2023 06:26:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10666"; a="685127540"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="685127540"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga002.jf.intel.com with ESMTP; 31 Mar 2023 06:26:41 -0700
Received: from [10.209.36.4] (kliang2-mobl1.ccr.corp.intel.com [10.209.36.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 6DEFD580D74;
        Fri, 31 Mar 2023 06:26:40 -0700 (PDT)
Message-ID: <9557fa1f-57f7-3114-5710-0600b1835db3@linux.intel.com>
Date:   Fri, 31 Mar 2023 09:26:39 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v3] perf/x86: use hexidecimal value for cpuid
Content-Language: en-US
To:     Zhenyu Wang <zhenyuw@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        CodyYao-oc <CodyYao-oc@zhaoxin.com>
References: <20230312132633.228006-1-zhenyuw@linux.intel.com>
 <20230322053746.4888-1-zhenyuw@linux.intel.com>
 <e60623a4-57e1-dde6-1c76-d9c7f956d3f1@linux.intel.com>
 <ZCYssdebU2L+f4YC@debian-scheme>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <ZCYssdebU2L+f4YC@debian-scheme>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2023-03-30 8:43 p.m., Zhenyu Wang wrote:
> 
> On 2023.03.24 09:33:19 -0400, Liang, Kan wrote:
>>
> 
> sorry that I missed this one in my inbox...
> 
>> On 2023-03-22 1:37 a.m., Zhenyu Wang wrote:
>>> It's easier to use hexidecimal value instead of decimal for reading
>>> and following with SDM doc, also align with other cpuid calls. As new
>>> cpuid leaf would be added in future, this tries to convert current
>>> forms and would take it as convention for new leaf definition.
>>>
>>> This changes name for both cpuid type and cpuid calls.
>>
>> It seems the patch touches 3 CPUIDs, 0xa, 0x1c and 0x14, right?
>> The patch also crosses several different subsystems and drivers.
>> I think it may be better to divide the patch by CPUID. Each patch to
>> handle one CPUID. It's easier for review.
> 
> ok, I can do that.
> 
>>
>> Also, can you please add a macro for the CPUID leaf number?
>> Please refer ARCH_PERFMON_EXT_LEAF (0x23).
>>
> 
> As originally the purpose of this change is to use hex value in cpuid
> call and struct name, good to see that use for 0x23.  If define every
> macro for these, e.g ARCH_PERFMON_LEAF(0xa), PT_LEAF(0x14),
> LBR_LEAF(0x1c), struct name needs change too?  As in context of what
> source file you're reading, you already get idea what these cpuid
> numbers are for what kind of leaf...
>

No, only the hex value is good enough for an union name.

What I want is a consistent style for the leaf definition of the entire
X86 perf code.
For a union, e.g., cpuid_$hex_eax
For the leaf, e.g., #define __meaning_name_macro	__hex

I think AMD has already done it. See EXT_PERFMON_DEBUG_FEATURES and
union cpuid_0x80000022_ebx.
If we have the same style, the code style will be consistent.

Thanks,
Kan

>>
>>>
>>> Cc: Peter Zijlstra <peterz@infradead.org>
>>> Cc: Ingo Molnar <mingo@redhat.com>
>>> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
>>> Cc: Mark Rutland <mark.rutland@arm.com>
>>> Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
>>> Cc: Jiri Olsa <jolsa@kernel.org>
>>> Cc: Namhyung Kim <namhyung@kernel.org>
>>> Cc: Kan Liang <kan.liang@linux.intel.com>
>>> Cc: CodyYao-oc <CodyYao-oc@zhaoxin.com>
>>> Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
>>> ---
>>> v3:
>>> - add more explanation in commit message for purpose of this
>>> - use lowercase number in call to align with current code
>>>
>>> v2:
>>> - rename in cpuid data type as well
>>>
>>>  arch/x86/events/intel/core.c      | 10 +++++-----
>>>  arch/x86/events/intel/lbr.c       |  8 ++++----
>>>  arch/x86/events/intel/pt.c        |  2 +-
>>>  arch/x86/events/zhaoxin/core.c    |  8 ++++----
>>>  arch/x86/include/asm/perf_event.h | 12 ++++++------
>>>  arch/x86/kvm/cpuid.c              |  4 ++--
>>>  arch/x86/kvm/vmx/pmu_intel.c      |  4 ++--
>>>  7 files changed, 24 insertions(+), 24 deletions(-)
>>>
>>> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
>>> index a3fb996a86a1..5487a39d4975 100644
>>> --- a/arch/x86/events/intel/core.c
>>> +++ b/arch/x86/events/intel/core.c
>>> @@ -5170,7 +5170,7 @@ static __init void intel_arch_events_quirk(void)
>>>  
>>>  static __init void intel_nehalem_quirk(void)
>>>  {
>>> -	union cpuid10_ebx ebx;
>>> +	union cpuid_0xa_ebx ebx;
>>>  
>>>  	ebx.full = x86_pmu.events_maskl;
>>>  	if (ebx.split.no_branch_misses_retired) {
>>> @@ -5878,9 +5878,9 @@ __init int intel_pmu_init(void)
>>>  	struct attribute **td_attr    = &empty_attrs;
>>>  	struct attribute **mem_attr   = &empty_attrs;
>>>  	struct attribute **tsx_attr   = &empty_attrs;
>>> -	union cpuid10_edx edx;
>>> -	union cpuid10_eax eax;
>>> -	union cpuid10_ebx ebx;
>>> +	union cpuid_0xa_edx edx;
>>> +	union cpuid_0xa_eax eax;
>>> +	union cpuid_0xa_ebx ebx;
>>>  	unsigned int fixed_mask;
>>>  	bool pmem = false;
>>>  	int version, i;
>>> @@ -5903,7 +5903,7 @@ __init int intel_pmu_init(void)
>>>  	 * Check whether the Architectural PerfMon supports
>>>  	 * Branch Misses Retired hw_event or not.
>>>  	 */
>>> -	cpuid(10, &eax.full, &ebx.full, &fixed_mask, &edx.full);
>>> +	cpuid(0xa, &eax.full, &ebx.full, &fixed_mask, &edx.full);
>>>  	if (eax.split.mask_length < ARCH_PERFMON_EVENTS_COUNT)
>>>  		return -ENODEV;
>>>  
>>> diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
>>> index c3b0d15a9841..616a6904af03 100644
>>> --- a/arch/x86/events/intel/lbr.c
>>> +++ b/arch/x86/events/intel/lbr.c
>>> @@ -1497,16 +1497,16 @@ static bool is_arch_lbr_xsave_available(void)
>>>  void __init intel_pmu_arch_lbr_init(void)
>>>  {
>>>  	struct pmu *pmu = x86_get_pmu(smp_processor_id());
>>> -	union cpuid28_eax eax;
>>> -	union cpuid28_ebx ebx;
>>> -	union cpuid28_ecx ecx;
>>> +	union cpuid_0x1c_eax eax;
>>> +	union cpuid_0x1c_ebx ebx;
>>> +	union cpuid_0x1c_ecx ecx;
>>>  	unsigned int unused_edx;
>>>  	bool arch_lbr_xsave;
>>>  	size_t size;
>>>  	u64 lbr_nr;
>>>  
>>>  	/* Arch LBR Capabilities */
>>> -	cpuid(28, &eax.full, &ebx.full, &ecx.full, &unused_edx);
>>> +	cpuid(0x1c, &eax.full, &ebx.full, &ecx.full, &unused_edx);
>>>  
>>>  	lbr_nr = fls(eax.split.lbr_depth_mask) * 8;
>>>  	if (!lbr_nr)
>>> diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
>>> index 42a55794004a..da3c5d748365 100644
>>> --- a/arch/x86/events/intel/pt.c
>>> +++ b/arch/x86/events/intel/pt.c
>>> @@ -235,7 +235,7 @@ static int __init pt_pmu_hw_init(void)
>>>  	}
>>>  
>>>  	for (i = 0; i < PT_CPUID_LEAVES; i++) {
>>> -		cpuid_count(20, i,
>>> +		cpuid_count(0x14, i,
>>>  			    &pt_pmu.caps[CPUID_EAX + i*PT_CPUID_REGS_NUM],
>>>  			    &pt_pmu.caps[CPUID_EBX + i*PT_CPUID_REGS_NUM],
>>>  			    &pt_pmu.caps[CPUID_ECX + i*PT_CPUID_REGS_NUM],
>>> diff --git a/arch/x86/events/zhaoxin/core.c b/arch/x86/events/zhaoxin/core.c
>>> index 3e9acdaeed1e..1d071974f4db 100644
>>> --- a/arch/x86/events/zhaoxin/core.c
>>> +++ b/arch/x86/events/zhaoxin/core.c
>>> @@ -504,9 +504,9 @@ static __init void zhaoxin_arch_events_quirk(void)
>>>  
>>>  __init int zhaoxin_pmu_init(void)
>>>  {
>>> -	union cpuid10_edx edx;
>>> -	union cpuid10_eax eax;
>>> -	union cpuid10_ebx ebx;
>>> +	union cpuid_0xa_edx edx;
>>> +	union cpuid_0xa_eax eax;
>>> +	union cpuid_0xa_ebx ebx;
>>>  	struct event_constraint *c;
>>>  	unsigned int unused;
>>>  	int version;
>>> @@ -517,7 +517,7 @@ __init int zhaoxin_pmu_init(void)
>>>  	 * Check whether the Architectural PerfMon supports
>>>  	 * hw_event or not.
>>>  	 */
>>> -	cpuid(10, &eax.full, &ebx.full, &unused, &edx.full);
>>> +	cpuid(0xa, &eax.full, &ebx.full, &unused, &edx.full);
>>>  
>>>  	if (eax.split.mask_length < ARCH_PERFMON_EVENTS_COUNT - 1)
>>>  		return -ENODEV;
>>> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
>>> index 8fc15ed5e60b..0d2d735c8167 100644
>>> --- a/arch/x86/include/asm/perf_event.h
>>> +++ b/arch/x86/include/asm/perf_event.h
>>> @@ -125,7 +125,7 @@
>>>   * Intel "Architectural Performance Monitoring" CPUID
>>>   * detection/enumeration details:
>>>   */
>>> -union cpuid10_eax {
>>> +union cpuid_0xa_eax {
>>>  	struct {
>>>  		unsigned int version_id:8;
>>>  		unsigned int num_counters:8;
>>> @@ -135,7 +135,7 @@ union cpuid10_eax {
>>>  	unsigned int full;
>>>  };
>>>  
>>> -union cpuid10_ebx {
>>> +union cpuid_0xa_ebx {
>>>  	struct {
>>>  		unsigned int no_unhalted_core_cycles:1;
>>>  		unsigned int no_instructions_retired:1;
>>> @@ -148,7 +148,7 @@ union cpuid10_ebx {
>>>  	unsigned int full;
>>>  };
>>>  
>>> -union cpuid10_edx {
>>> +union cpuid_0xa_edx {
>>>  	struct {
>>>  		unsigned int num_counters_fixed:5;
>>>  		unsigned int bit_width_fixed:8;
>>> @@ -170,7 +170,7 @@ union cpuid10_edx {
>>>  /*
>>>   * Intel Architectural LBR CPUID detection/enumeration details:
>>>   */
>>> -union cpuid28_eax {
>>> +union cpuid_0x1c_eax {
>>>  	struct {
>>>  		/* Supported LBR depth values */
>>>  		unsigned int	lbr_depth_mask:8;
>>> @@ -183,7 +183,7 @@ union cpuid28_eax {
>>>  	unsigned int		full;
>>>  };
>>>  
>>> -union cpuid28_ebx {
>>> +union cpuid_0x1c_ebx {
>>>  	struct {
>>>  		/* CPL Filtering Supported */
>>>  		unsigned int    lbr_cpl:1;
>>> @@ -195,7 +195,7 @@ union cpuid28_ebx {
>>>  	unsigned int            full;
>>>  };
>>>  
>>> -union cpuid28_ecx {
>>> +union cpuid_0x1c_ecx {
>>>  	struct {
>>>  		/* Mispredict Bit Supported */
>>>  		unsigned int    lbr_mispred:1;
>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>> index 599aebec2d52..57f43dc87538 100644
>>> --- a/arch/x86/kvm/cpuid.c
>>> +++ b/arch/x86/kvm/cpuid.c
>>> @@ -967,8 +967,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>>>  		}
>>>  		break;
>>>  	case 0xa: { /* Architectural Performance Monitoring */
>>> -		union cpuid10_eax eax;
>>> -		union cpuid10_edx edx;
>>> +		union cpuid_0xa_eax eax;
>>> +		union cpuid_0xa_edx edx;
>>>  
>>>  		if (!static_cpu_has(X86_FEATURE_ARCH_PERFMON)) {
>>>  			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
>>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>>> index e8a3be0b9df9..f4b165667ca9 100644
>>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>>> @@ -512,8 +512,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>>>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>>>  	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
>>>  	struct kvm_cpuid_entry2 *entry;
>>> -	union cpuid10_eax eax;
>>> -	union cpuid10_edx edx;
>>> +	union cpuid_0xa_eax eax;
>>> +	union cpuid_0xa_edx edx;
>>>  	u64 perf_capabilities;
>>>  	u64 counter_mask;
>>>  	int i;
