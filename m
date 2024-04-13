Return-Path: <kvm+bounces-14587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CC6878A3A64
	for <lists+kvm@lfdr.de>; Sat, 13 Apr 2024 04:11:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6987C1F210B8
	for <lists+kvm@lfdr.de>; Sat, 13 Apr 2024 02:11:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ED28168DA;
	Sat, 13 Apr 2024 02:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iZMNZ7mh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19521078B;
	Sat, 13 Apr 2024 02:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712974250; cv=none; b=eRHCiuqjY0VCnJ6uY2JFxwYWpIZ/2WV9sjRlW7CrgethhZ4RLXSVBR2n2MYC2cFWvTgL5HrRsH+WfpaWy3/SbrRNDjDeLnxDsYG+RSICq5unAFdr9Jbkvih7DvgAFIrSPwW4RGSAdcJoG+77YTjw2KgydG9DbDjSyd73PojSliQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712974250; c=relaxed/simple;
	bh=OHQ0j1BRVcloy4BuWZmIacv5fOSQtu9yvWGdKmWjE/I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B1xjxzULWubPxsdLUy59xkJK7TfFQPZuT45Cs0U98chR2zgUZZROQ5jBJgb/b8aTA1JgE34sq8q4wHalvRsbQfOCY/Ox2rRTewUYygt1rX8aYgkiYzHsfaSt9sHjxfAYuFrSDt4sLWzyzAFBCKMdnlybykbb8NuHI97O7ptWGlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iZMNZ7mh; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712974249; x=1744510249;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OHQ0j1BRVcloy4BuWZmIacv5fOSQtu9yvWGdKmWjE/I=;
  b=iZMNZ7mhFiUYhaNtKGkMHh9uwCwO4QeEsLTxn79Wnpp8ZxfzVhM0R5t7
   32Ra/po026vPmBYKfyVuigBx9hwGCY7VrIC2vlqFTEpBXPJ7WRyvWomdT
   GE0JHltpdWfReyJYv8FxFqPvtPiuepG5UZNDrKq/m0gZWBWZ6W+Mjc7rX
   l+OGqWf3F/izZWTdaOacN/R3n6lFyxzT4G8Er83QU1Rupnr/J5bsQjaOL
   8ljt5EBLlGp1ELY4xJE9VDeOf6am4y0GlIDkQ4VMr5UkZ1+ODwDiGlG4+
   zwx3yTGHV50Mg3O76zQtfXcrrU+GAKDgRJqdZU2scg6UjFyJ+pb8n8W0G
   w==;
X-CSE-ConnectionGUID: 4YxoRRvtTyavhzpdNLhK7A==
X-CSE-MsgGUID: IibtsFszTJ26sk2OF09IeA==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="25906697"
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="25906697"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 19:10:48 -0700
X-CSE-ConnectionGUID: yXK6+BCYQQ+PUdBBnj1Dtg==
X-CSE-MsgGUID: KQh4NgxVQPmCw9l2ry1y5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="21422397"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.225.92]) ([10.124.225.92])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 19:10:43 -0700
Message-ID: <cb2f02e3-2a18-4c3a-a017-58bcb2029b3e@linux.intel.com>
Date: Sat, 13 Apr 2024 10:10:40 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 15/41] KVM: x86/pmu: Manage MSR interception for
 IA32_PERF_GLOBAL_CTRL
To: Jim Mattson <jmattson@google.com>, Sean Christopherson <seanjc@google.com>
Cc: Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com,
 peterz@infradead.org, mizhang@google.com, kan.liang@intel.com,
 zhenyuw@linux.intel.com, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
 zhiyuan.lv@intel.com, eranian@google.com, irogers@google.com,
 samantha.alt@intel.com, like.xu.linux@gmail.com, chao.gao@intel.com,
 Xiong Zhang <xiong.y.zhang@intel.com>
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-16-xiong.y.zhang@linux.intel.com>
 <ZhhUZJ7rE0SbE6Vv@google.com>
 <CALMp9eQ01NJZKKYt8XhTbnu8rNpuhpk388ocvyPqWJiO+sov5g@mail.gmail.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <CALMp9eQ01NJZKKYt8XhTbnu8rNpuhpk388ocvyPqWJiO+sov5g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 4/12/2024 6:30 AM, Jim Mattson wrote:
> On Thu, Apr 11, 2024 at 2:21 PM Sean Christopherson <seanjc@google.com> wrote:
>> On Fri, Jan 26, 2024, Xiong Zhang wrote:
>>> +     if (is_passthrough_pmu_enabled(&vmx->vcpu)) {
>>> +             /*
>>> +              * Setup auto restore guest PERF_GLOBAL_CTRL MSR at vm entry.
>>> +              */
>>> +             if (vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
>>> +                     vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL, 0);
>>> +             else {
>>> +                     i = vmx_find_loadstore_msr_slot(&vmx->msr_autoload.guest,
>>> +                                                    MSR_CORE_PERF_GLOBAL_CTRL);
>>> +                     if (i < 0) {
>>> +                             i = vmx->msr_autoload.guest.nr++;
>>> +                             vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT,
>>> +                                          vmx->msr_autoload.guest.nr);
>>> +                     }
>>> +                     vmx->msr_autoload.guest.val[i].index = MSR_CORE_PERF_GLOBAL_CTRL;
>>> +                     vmx->msr_autoload.guest.val[i].value = 0;
>> Eww, no.   Just make cpu_has_load_perf_global_ctrl() and VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL
>> hard requirements for enabling passthrough mode.  And then have clear_atomic_switch_msr()
>> yell if KVM tries to disable loading MSR_CORE_PERF_GLOBAL_CTRL.
> Weren't you just complaining about the PMU version 4 constraint in
> another patch? And here, you are saying, "Don't support anything older
> than Sapphire Rapids."
>
> Sapphire Rapids has PMU version 4, so if we require
> VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL, PMU version 4 is irrelevant.

Just clarify Sapphire Rapids has PMU version 5 :).

[    2.687826] Performance Events: XSAVE Architectural LBR, PEBS 
fmt4+-baseline,  AnyThread deprecated, *Sapphire Rapids events*, 32-deep 
LBR, full-width counters, Intel PMU driver.
[    2.687925] ... version:                   5
[    2.687928] ... bit width:                 48
[    2.687929] ... generic counters:          8

>

