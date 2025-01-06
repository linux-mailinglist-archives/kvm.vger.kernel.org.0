Return-Path: <kvm+bounces-34572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AC9FA01D18
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 02:46:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A90C07A169A
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 01:46:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 044F182D98;
	Mon,  6 Jan 2025 01:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="joAW3Inu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A225F78F5D;
	Mon,  6 Jan 2025 01:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736127981; cv=none; b=jhecFWQcTwdna0q1N6sIuOtlYZYBvG417QJBdWfgPhlAO2dbmQZ6kY8+KGoevrSaXFmi+rZVz45ydiroJBv6NqiQ5W8KGjjJdFw5D2F8P9xUKJ2Fy7Af/hBrRMM9R82yhrqMbJ215hfZIcQs0ebto1+zkDbXuT9mCSyI4U+HhDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736127981; c=relaxed/simple;
	bh=tnz17dAtahKXWac/b6u2llXxMbK/9NIYhqczyce3OLo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MrO3HWQm1ncHeOhc6EDhipqUjxCUydLvPAwbk3Z2VyDZosmZBcuZYCGGjnC+STzBbRg0a2usHGHPXVm+709i+DM0BXDO75fqn2z2bwWeO2Q+pgKp/MBVWUEOJTs3oiJxqd1CRSSFwOOyR6yp4sJ+mLDL6ieLnVrAjKfr3VNusPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=joAW3Inu; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736127980; x=1767663980;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tnz17dAtahKXWac/b6u2llXxMbK/9NIYhqczyce3OLo=;
  b=joAW3InuELB8HO76KqYPYIV75VfJRafwBu5WHOtHMb2UCHcc4JJ8cn/d
   KX6vyHpaPO8gcyIYsgnRrHvUokj/O8sG+B2vhjFIVo0vYuZRuB35znPn1
   6V0zhWNc8Uek7bDSLTtBX4mQBN7zSzueLHnFcohyBAuO5e6XEEQMYYa6B
   5Hq0QsJZUPXyVo8Hnc+esCv7hF1I87gE697CTNF0urTWLoXy2sQ4PKJTM
   XcyfF37t6IfjDRusbOXCzzio5wief/GcD+mp3svdr3i8RLk1pn0j80shT
   6mgZbYuPrYZhlejm2MTw+pfnIIyHCusMRfh6fstIV53k0ap3I8DOY7NHP
   Q==;
X-CSE-ConnectionGUID: T3HQiGetTryGHWvFS56aYA==
X-CSE-MsgGUID: R5uF+jlERHKKKRHrw7eqbg==
X-IronPort-AV: E=McAfee;i="6700,10204,11306"; a="47689184"
X-IronPort-AV: E=Sophos;i="6.12,291,1728975600"; 
   d="scan'208";a="47689184"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2025 17:46:19 -0800
X-CSE-ConnectionGUID: cogdm6AqSQaVw1krgfM2EQ==
X-CSE-MsgGUID: zxGiEHEyTW+52aWkpmzV2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,291,1728975600"; 
   d="scan'208";a="107276708"
Received: from unknown (HELO [10.238.1.62]) ([10.238.1.62])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2025 17:46:15 -0800
Message-ID: <fc6294b7-f648-4daa-842d-0b74211f8c3a@linux.intel.com>
Date: Mon, 6 Jan 2025 09:46:12 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/16] KVM: TDX: Inhibit APICv for TDX guest
To: Vishal Annapurve <vannapurve@google.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, isaku.yamahata@intel.com,
 yan.y.zhao@intel.com, chao.gao@intel.com, linux-kernel@vger.kernel.org,
 Binbin Wu <binbin.wu@linux.intel.com>
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
 <20241209010734.3543481-13-binbin.wu@linux.intel.com>
 <CAGtprH9UBZe64zay0HjZRg5f--xM85Yt+jYijKZw=sfxRH=2Ow@mail.gmail.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <CAGtprH9UBZe64zay0HjZRg5f--xM85Yt+jYijKZw=sfxRH=2Ow@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 1/4/2025 5:59 AM, Vishal Annapurve wrote:
> On Sun, Dec 8, 2024 at 5:11 PM Binbin Wu <binbin.wu@linux.intel.com> wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> Inhibit APICv for TDX guest in KVM since TDX doesn't support APICv accesses
>> from host VMM.
>>
>> Follow how SEV inhibits APICv.  I.e, define a new inhibit reason for TDX, set
>> it on TD initialization, and add the flag to kvm_x86_ops.required_apicv_inhibits.
>>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>> ---
>> TDX interrupts breakout:
>> - Removed WARN_ON_ONCE(kvm_apicv_activated(vcpu->kvm)) in
>>    tdx_td_vcpu_init(). (Rick)
>> - Change APICV -> APICv in changelog for consistency.
>> - Split the changelog to 2 paragraphs.
>> ---
>>   arch/x86/include/asm/kvm_host.h | 12 +++++++++++-
>>   arch/x86/kvm/vmx/main.c         |  3 ++-
>>   arch/x86/kvm/vmx/tdx.c          |  3 +++
>>   3 files changed, 16 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 32c7d58a5d68..df535f08e004 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1281,6 +1281,15 @@ enum kvm_apicv_inhibit {
>>           */
>>          APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED,
>>
>> +       /*********************************************************/
>> +       /* INHIBITs that are relevant only to the Intel's APICv. */
>> +       /*********************************************************/
>> +
>> +       /*
>> +        * APICv is disabled because TDX doesn't support it.
>> +        */
>> +       APICV_INHIBIT_REASON_TDX,
>> +
>>          NR_APICV_INHIBIT_REASONS,
>>   };
>>
>> @@ -1299,7 +1308,8 @@ enum kvm_apicv_inhibit {
>>          __APICV_INHIBIT_REASON(IRQWIN),                 \
>>          __APICV_INHIBIT_REASON(PIT_REINJ),              \
>>          __APICV_INHIBIT_REASON(SEV),                    \
>> -       __APICV_INHIBIT_REASON(LOGICAL_ID_ALIASED)
>> +       __APICV_INHIBIT_REASON(LOGICAL_ID_ALIASED),     \
>> +       __APICV_INHIBIT_REASON(TDX)
>>
>>   struct kvm_arch {
>>          unsigned long n_used_mmu_pages;
>> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
>> index 7f933f821188..13a0ab0a520c 100644
>> --- a/arch/x86/kvm/vmx/main.c
>> +++ b/arch/x86/kvm/vmx/main.c
>> @@ -445,7 +445,8 @@ static int vt_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
>>           BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |                   \
>>           BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |        \
>>           BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |           \
>> -        BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED))
>> +        BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |         \
>> +        BIT(APICV_INHIBIT_REASON_TDX))
>>
>>   struct kvm_x86_ops vt_x86_ops __initdata = {
>>          .name = KBUILD_MODNAME,
>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>> index b0f525069ebd..b51d2416acfb 100644
>> --- a/arch/x86/kvm/vmx/tdx.c
>> +++ b/arch/x86/kvm/vmx/tdx.c
>> @@ -2143,6 +2143,8 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
>>                  goto teardown;
>>          }
>>
>> +       kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_TDX);
>> +
>>          return 0;
>>
>>          /*
>> @@ -2528,6 +2530,7 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
>>                  return -EIO;
>>          }
>>
>> +       vcpu->arch.apic->apicv_active = false;
> With this setting, apic_timer_expired[1] will always cause timer
> interrupts to be pending without injecting them right away. Injecting
> it after VM exit [2] could cause unbounded delays to timer interrupt
> injection.

When apic->apicv_active is false, it will fallback to increasing the
apic->lapic_timer.pending and request KVM_REQ_UNBLOCK.
If apic_timer_expired() is called from timer function, the target vCPU
will be kicked out immediately.
So there is no unbounded delay to timer interrupt injection.

In a previous PUCK session, Sean suggested apic->apicv_active should be
set to true to align with the hardware setting because TDX module always
enables apicv for TDX guests.
Will send a write up about changing apicv to active later.

>
> [1] https://git.kernel.org/pub/scm/virt/kvm/kvm.git/tree/arch/x86/kvm/lapic.c?h=kvm-coco-queue#n1922
> [2] https://git.kernel.org/pub/scm/virt/kvm/kvm.git/tree/arch/x86/kvm/x86.c?h=kvm-coco-queue#n11263
>
>>          vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
>>
>>          return 0;
>> --
>> 2.46.0
>>
>>


