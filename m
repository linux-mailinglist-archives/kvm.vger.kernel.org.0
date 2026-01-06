Return-Path: <kvm+bounces-67180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 19C11CFB087
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 22:04:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1D259303178E
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 21:04:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1E2729BDBD;
	Tue,  6 Jan 2026 21:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iNdJ3R1Z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882B3200C2
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 21:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767733495; cv=none; b=TWN+/HndP8hrR9ulC/wq6wtwyDe+H0rrymK/v5lDDajKTwofCl+1qjZa5YU+QowFjNy82ImuZfYXj5cbU21QkPU3RGf4S2VPC8aeEMbuy9BkIzns6bePHTyu1k5A/IZWt6n6yV+nuAukFf4iBwWaaflv57nlPcM3bfJ0ARSN6UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767733495; c=relaxed/simple;
	bh=7FjH30EBifRZDfjY8+GQqpYxitypc9EU+MXhWqBXiss=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cctk+oJx7DQRLwoLh3Vw5PzCAqAJcsMGPxhgFw/7n5tez8cnYQRJVvp44W021jfzc+ARcGXmME8nVu0gwoybO7Avs4IJY7kTnzQGmEuAjrF3cFzf0DW//zs+1GWI8bRNPQNCal/7jZ7y/i8yEuOk4DRk4VXN8NREVMxS2nJbj9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iNdJ3R1Z; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767733493; x=1799269493;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7FjH30EBifRZDfjY8+GQqpYxitypc9EU+MXhWqBXiss=;
  b=iNdJ3R1Zqg9P05Jq3JeQdpGWM4/B3HQH2l5K4NGxNaLp2mse2Y2W3+6/
   tz4yhAhIHyAQrvcgcSFedy1bKK3vJEeoIyRWzqeex+qSYb30zNVkitZyh
   rvLw4t8RURzLMeKRaPIpc2+cEFNGZuIzUlKiwiajiO7SnhdOsR85H8sRR
   36hjNwNeOGqlacpW8S+BNFpTmvEaiE+Kfk2110MEGP5OK4Ec+wecaOEwi
   CW6Zcc/7L/B++jzOsVG1zdbURRkq7dOuH+d+zePhMOeFY7w72Qi6whVdg
   l1kBpwcDWoaW2Mr2MnJ2lxiQMaR02z1XCpK8IBlNdvmaEkWQQDh0Zx8Xx
   g==;
X-CSE-ConnectionGUID: 8mOmFtlIR3+kOdKvvrcHng==
X-CSE-MsgGUID: NoW5SXwDTd+T66GUF7ldaA==
X-IronPort-AV: E=McAfee;i="6800,10657,11663"; a="69179224"
X-IronPort-AV: E=Sophos;i="6.21,206,1763452800"; 
   d="scan'208";a="69179224"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 13:04:53 -0800
X-CSE-ConnectionGUID: 9jmfNKjOTNqq/qS0Ed1qnQ==
X-CSE-MsgGUID: TrDlblHGS/mgYUzshSfHpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,206,1763452800"; 
   d="scan'208";a="202651843"
Received: from unknown (HELO [10.241.241.119]) ([10.241.241.119])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 13:04:52 -0800
Message-ID: <d043ff42-9604-4acd-8341-830b30cba951@intel.com>
Date: Tue, 6 Jan 2026 13:04:52 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 7/7] target/i386/kvm: don't stop Intel PMU counters
To: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
 sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
 like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
 alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
 davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
 dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai-oc@zhaoxin.com,
 ewanhai@zhaoxin.com
References: <20251230074354.88958-1-dongli.zhang@oracle.com>
 <20251230074354.88958-8-dongli.zhang@oracle.com>
 <de20e04a-bfeb-4737-9e30-15d117e796e8@intel.com>
 <0f9f360c-b9a8-4379-9a02-c4b6dd5840a3@oracle.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <0f9f360c-b9a8-4379-9a02-c4b6dd5840a3@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 1/5/2026 12:24 PM, Dongli Zhang wrote:
> Hi Zide,
> 
> On 1/2/26 4:27 PM, Chen, Zide wrote:
>>
>>
>> On 12/29/2025 11:42 PM, Dongli Zhang wrote:
>>> PMU MSRs are set by QEMU only at levels >= KVM_PUT_RESET_STATE,
>>> excluding runtime. Therefore, updating these MSRs without stopping events
>>> should be acceptable.
>>
>> It seems preferable to keep the existing logic. The sequence of
>> disabling -> setting new counters -> re-enabling is complete and
>> reasonable. Re-enabling the PMU implicitly tell KVM to do whatever
>> actions are needed to make the new counters take effect.
>>
>> If the purpose of this patch to improve performance, given that this is
>> a non-critical path, trading this clear and robust logic for a minor
>> performance gain does not seem necessary.
>>
>>
>>> In addition, KVM creates kernel perf events with host mode excluded
>>> (exclude_host = 1). While the events remain active, they don't increment
>>> the counter during QEMU vCPU userspace mode.
>>>
>>> Finally, The kvm_put_msrs() sets the MSRs using KVM_SET_MSRS. The x86 KVM
>>> processes these MSRs one by one in a loop, only saving the config and
>>> triggering the KVM_REQ_PMU request. This approach does not immediately stop
>>> the event before updating PMC. This approach is true since Linux kernel
>>> commit 68fb4757e867 ("KVM: x86/pmu: Defer reprogram_counter() to
>>> kvm_pmu_handle_event"), that is, v6.2.
>>
>> This seems to assume KVM's internal behavior. While that is true today
>> (and possibly in the future), it’s not necessary for QEMU to  make such
>> assumptions, as that could unnecessarily limit KVM’s flexibility to
>> change its behavior later.
>>
> 
> To "assume KVM's internal behavior" is only one of the two reasons. The first
> reason is that QEMU controls the state of the vCPU to ensure this action only
> occurs when "levels >= KVM_PUT_RESET_STATE."
> 
> Thanks to "(level >= KVM_PUT_RESET_STATE)", QEMU is able to avoid unnecessary
> updates to many MSR registers during runtime.
> 
> 
> The main objective is to sync the implementation for Intel and AMD.
> 
> Both MSR_CORE_PERF_FIXED_CTR_CTRL and MSR_CORE_PERF_GLOBAL_CTRL are reset to
> zero only in the case where "has_pmu_version > 1." Otherwise, we may need to
> reset the MSR_P6_PERFCTR_N registers before writing to the counter registers.
> Without PATCH 7/7, an additional patch will be required to fix the workflow for
> handling PMU registers to reset control registers before counter registers.

I might be missing something here, but since this is not for runtime,
I don’t quite understand the need to reset the control registers.

> If the plan is to maintain the current logic, we may need to adjust the logic
> for the AMD registers as well. In PATCH 6/7, we never reset global registers
> before writing to control and counter registers.
> 
> Would you mine sharing your thoughts on it?

Personally, I would lean towards keeping the current logic and instead
adjusting patch 6/7 to reset the global registers.  This is just my
view, and please don’t feel obligated to follow it.


> Thank you very much!
> 
> Dongli Zhang


