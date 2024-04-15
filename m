Return-Path: <kvm+bounces-14607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 67D328A4670
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 03:07:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB3C61F215E7
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 01:07:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81157C8E1;
	Mon, 15 Apr 2024 01:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GFYRa/iS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB44134AC;
	Mon, 15 Apr 2024 01:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713143225; cv=none; b=ruw7+UFLXt97caJ2Ppdtcfqi1IBJNg6lZNgZ7Uv3TKyjw5/BZY4RR8flFT9iGJW01xPQ1JvgAmh+iJ0/d0XQ1v0XKRthalfe2UMoTV09YofybYlJ+u3p/3g/ZW5qdb7BeeUw9j3robRCobFWKl4IOeE6pf4va8JfDgXwCAqyaUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713143225; c=relaxed/simple;
	bh=bJNrSYB09b8z+tlGP3CjyvyKkpqB54wXqUvtpor+eRE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fab8r3aG2oSSAJNCT0ky10E/O+a4dondcvHcydSHrwitMVgeRbFRzkW/GAgRn/XkJeJhSXHew17yayLigW86QRFQbuBA1HaeraLe1/JprXcRcyC4VhJC7nkPZwyjRLZh2A8kBVBEsz9C4SA+QWwxTx1YTQn01LFWF85t/0qgmjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GFYRa/iS; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713143224; x=1744679224;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bJNrSYB09b8z+tlGP3CjyvyKkpqB54wXqUvtpor+eRE=;
  b=GFYRa/iSvrEJJg30AqDw5/TmoiR/fnClp2y8GRbBgtOHLi1JdFVYc5Nv
   84dcOsaF0OLl9s5BNOLaXJo2xMG3btIrndExF8BGxzo2scsxotdaRDjLk
   DvlLEVziLm4KdghgoixEoqeGBgc+nsO1Fi4vY0H3Musam8u9ZhwpnufIP
   m91aNThm7INy4KqVAsNJWzl6ihyG06L/aUT+ohnrAyeCEyn3dvpD9w5+R
   ZQKat0nqYqR+cffP0Y/hdIcn9gHgmWF1gIDguHjAApYxN2lXdU9KwvJex
   K342M90ge53BBVuUAiaNjcWd0NTBboSAltc2UKAXSVlHdMmSY1e6kGuHB
   w==;
X-CSE-ConnectionGUID: eS5frwSiTtO5yb7eqme1YQ==
X-CSE-MsgGUID: 0M0U979cSeOD7ZSQkpwVug==
X-IronPort-AV: E=McAfee;i="6600,9927,11044"; a="12294494"
X-IronPort-AV: E=Sophos;i="6.07,202,1708416000"; 
   d="scan'208";a="12294494"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2024 18:07:03 -0700
X-CSE-ConnectionGUID: B260IZR8SfOOnFPYEYIjdA==
X-CSE-MsgGUID: u+xe5U4QTd+frt1uiy8XBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,202,1708416000"; 
   d="scan'208";a="22333842"
Received: from xiongzha-mobl1.ccr.corp.intel.com (HELO [10.124.244.162]) ([10.124.244.162])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2024 18:06:59 -0700
Message-ID: <9469faf7-1659-4436-848f-53ec01d967f2@linux.intel.com>
Date: Mon, 15 Apr 2024 09:06:44 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/41] KVM: x86/pmu: Introduce passthrough vPM
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, peterz@infradead.org, mizhang@google.com,
 kan.liang@intel.com, zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com,
 jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com,
 irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com,
 chao.gao@intel.com
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <ZhgX6BStTh05OfEd@google.com>
 <f6f714ef-eb58-4aa9-9c4d-12bfe29c383b@linux.intel.com>
 <Zhl-JFk5hw-hlyGi@google.com>
Content-Language: en-US
From: "Zhang, Xiong Y" <xiong.y.zhang@linux.intel.com>
In-Reply-To: <Zhl-JFk5hw-hlyGi@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/13/2024 2:32 AM, Sean Christopherson wrote:
> On Fri, Apr 12, 2024, Xiong Y Zhang wrote:
>>>> 2. NMI watchdog
>>>>    the perf event for NMI watchdog is a system wide cpu pinned event, it
>>>>    will be stopped also during vm running, but it doesn't have
>>>>    attr.exclude_guest=1, we add it in this RFC. But this still means NMI
>>>>    watchdog loses function during VM running.
>>>>
>>>>    Two candidates exist for replacing perf event of NMI watchdog:
>>>>    a. Buddy hardlock detector[3] may be not reliable to replace perf event.
>>>>    b. HPET-based hardlock detector [4] isn't in the upstream kernel.
>>>
>>> I think the simplest solution is to allow mediated PMU usage if and only if
>>> the NMI watchdog is disabled.  Then whether or not the host replaces the NMI
>>> watchdog with something else becomes an orthogonal discussion, i.e. not KVM's
>>> problem to solve.
>> Make sense. KVM should not affect host high priority work.
>> NMI watchdog is a client of perf and is a system wide perf event, perf can't
>> distinguish a system wide perf event is NMI watchdog or others, so how about
>> we extend this suggestion to all the system wide perf events ?  mediated PMU
>> is only allowed when all system wide perf events are disabled or non-exist at
>> vm creation.
> 
> What other kernel-driven system wide perf events are there?
does "kernel-driven" mean perf events created through perf_event_create_kernel_counter() like nmi_watchdog and kvm perf events ?
User can create system wide perf event through "perf record -e {} -a" also, I call it as user-driven system wide perf events.
Perf subsystem doesn't distinguish "kernel-driven" and "user-driven" system wide perf events.
> 
>> but NMI watchdog is usually enabled, this will limit mediated PMU usage.
> 
> I don't think it is at all unreasonable to require users that want optimal PMU
> virtualization to adjust their environment.  And we can and should document the
> tradeoffs and alternatives, e.g. so that users that want better PMU results don't
> need to re-discover all the "gotchas" on their own.
> 
> This would even be one of the rare times where I would be ok with a dmesg log.
> E.g. if KVM is loaded with enable_mediated_pmu=true, but there are system wide
> perf events, pr_warn() to explain the conflict and direct the user at documentation
> explaining how to make their system compatible with mediate PMU usage.> 
>>>> 3. Dedicated kvm_pmi_vector
>>>>    In emulated vPMU, host PMI handler notify KVM to inject a virtual
>>>>    PMI into guest when physical PMI belongs to guest counter. If the
>>>>    same mechanism is used in passthrough vPMU and PMI skid exists
>>>>    which cause physical PMI belonging to guest happens after VM-exit,
>>>>    then the host PMI handler couldn't identify this PMI belongs to
>>>>    host or guest.
>>>>    So this RFC uses a dedicated kvm_pmi_vector, PMI belonging to guest
>>>>    has this vector only. The PMI belonging to host still has an NMI
>>>>    vector.
>>>>
>>>>    Without considering PMI skid especially for AMD, the host NMI vector
>>>>    could be used for guest PMI also, this method is simpler and doesn't
>>>
>>> I don't see how multiplexing NMIs between guest and host is simpler.  At best,
>>> the complexity is a wash, just in different locations, and I highly doubt it's
>>> a wash.  AFAIK, there is no way to precisely know that an NMI came in via the
>>> LVTPC.
>> when kvm_intel.pt_mode=PT_MODE_HOST_GUEST, guest PT's PMI is a multiplexing
>> NMI between guest and host, we could extend guest PT's PMI framework to
>> mediated PMU. so I think this is simpler.
> 
> Heh, what do you mean by "this"?  Using a dedicated IRQ vector, or extending the
> PT framework of multiplexing NMI?
here "this" means "extending the PT framework of multiplexing NMI".

thanks
> 

