Return-Path: <kvm+bounces-51255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A27DAF0ABB
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 07:31:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ED39E7A79F8
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 05:29:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B0CA1EBFE0;
	Wed,  2 Jul 2025 05:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dobh5mio"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6779A60B8A
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 05:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751434275; cv=none; b=ktvAQ1DactP5SJUXRx8hcUkS+fk47jcwEXMmDF589yvC/r3IcRsHM9h9u4GNa5QahtfFXEn9xaufIE1Vx/zAdrw4s4EJLtK7FzgUwxUWgNuZZa7RC29vtkJv7XipYAsu2KGDVUr25W6S9qD0PUXmAm2dv1iw3twsoWh8rdMP9xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751434275; c=relaxed/simple;
	bh=wmb7fyJuILH5pksG+hlA/BUwVrAifChyZtCLI4i1pLY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jV/FZM9d4JmIwajxUdb4Ul+lqv89xqp5dM1KHpwyI3FRMJNq4pLsrzP4J0lyecHujBxIt+9tHwmNlFNbzkYaTouKlM3Mm2AXtTTtDgd7Z1RcxqWZpNP4+YX8KuYMowOsYS3VL+O1AspjOn1HTpGoIiKMc0GhbQLj44HqZRW01tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dobh5mio; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751434273; x=1782970273;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wmb7fyJuILH5pksG+hlA/BUwVrAifChyZtCLI4i1pLY=;
  b=Dobh5miojoHWUTnbapjOkFcZfPMw5qdaKFXzWsssPYz8ZIWdT9rc+Owt
   B1qkEuFymveqOIMSMqMaHpUCsqhNnzBeZAOa0QnL29jdgdFDhnZln1oZP
   7hckh81pV44bDz8Xdtlo6Ww/WFyad/kKBtgFrmAOyJH9wNN1l7S4gYn9S
   4KkRHJhDuhNDt8rinbhQt24a+BUheCuyICywn9em01nx1T7o9eLWs2hY5
   K0Qz7ZJodJjYeNWhXsoFh2hAzqrBTFZQGmjja0+RCwhCBsQcBlm6rTUHH
   rW+uhpb4vnjWuUOGbKKvgLc/PneALMwmegojj0mIi9zknETYwm+SaJ0nH
   Q==;
X-CSE-ConnectionGUID: LPa3IvTaSM+bgmek+2qFzw==
X-CSE-MsgGUID: CyHH/zupRdCGmw52lyoNdg==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="53827486"
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="53827486"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 22:31:12 -0700
X-CSE-ConnectionGUID: p0RHtcEzQZ6GGSNqEsQxlg==
X-CSE-MsgGUID: 2qgDZNU0QDmDzRf8UViSrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="154059786"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 22:31:02 -0700
Message-ID: <f1d53417-4dce-43e8-a647-74fbc5c378cb@intel.com>
Date: Wed, 2 Jul 2025 13:30:58 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] i386/cpu: ARCH_CAPABILITIES should not be advertised on
 AMD
To: Zhao Liu <zhao1.liu@intel.com>, Igor Mammedov <imammedo@redhat.com>,
 Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Alexandre Chartre <alexandre.chartre@oracle.com>, qemu-devel@nongnu.org,
 pbonzini@redhat.com, qemu-stable@nongnu.org, boris.ostrovsky@oracle.com,
 maciej.szmigiero@oracle.com, Sean Christopherson <seanjc@google.com>,
 kvm@vger.kernel.org
References: <20250630133025.4189544-1-alexandre.chartre@oracle.com>
 <aGO3vOfHUfjgvBQ9@intel.com> <c6a79077-024f-4d2f-897c-118ac8bb9b58@intel.com>
 <aGPWW/joFfohy05y@intel.com> <20250701150500.3a4001e9@fedora>
 <aGQ-ke-pZhzLnr8t@char.us.oracle.com> <aGS9E6pT0I57gn+e@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aGS9E6pT0I57gn+e@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/2/2025 1:01 PM, Zhao Liu wrote:
> Thanks Igor for looking here and thanks Konrad's explanation.
> 
>>>>> On 7/1/2025 6:26 PM, Zhao Liu wrote:
>>>>>>> unless it was explicitly requested by the user.
>>>>>> But this could still break Windows, just like issue #3001, which enables
>>>>>> arch-capabilities for EPYC-Genoa. This fact shows that even explicitly
>>>>>> turning on arch-capabilities in AMD Guest and utilizing KVM's emulated
>>>>>> value would even break something.
>>>>>>
>>>>>> So even for named CPUs, arch-capabilities=on doesn't reflect the fact
>>>>>> that it is purely emulated, and is (maybe?) harmful.
>>>>>
>>>>> It is because Windows adds wrong code. So it breaks itself and it's just the
>>>>> regression of Windows.
>>>>
>>>> Could you please tell me what the Windows's wrong code is? And what's
>>>> wrong when someone is following the hardware spec?
>>>
>>> the reason is that it's reserved on AMD hence software shouldn't even try
>>> to use it or make any decisions based on that.
>>>
>>>
>>> PS:
>>> on contrary, doing such ad-hoc 'cleanups' for the sake of misbehaving
>>> guest would actually complicate QEMU for no big reason.
>>
>> The guest is not misbehaving. It is following the spec.
> 
> (That's my thinking, and please feel free to correct me.)

I think we need firstly aligned on what the behavior of the Windows that 
hit "unsupported processor" is.

My understanding is, the Windows is doing something like

	if (is_AMD && CPUID(arch_capabilities))
		error(unsupported processor)

And I think this behavior is not correct.

However, it seems not the behavior of the Windows from your 
understanding. So what's the behavior in you mind?

> I had the same thought. Windows guys could also say they didn't access
> the reserved MSR unconditionally, and they followed the CPUID feature
> bit to access that MSR. When CPUID is set, it indicates that feature is
> implemented.
> 
> At least I think it makes sense to rely on the CPUID to access the MSR.
> Just as an example, it's unlikely that after the software finds a CPUID
> of 1, it still need to download the latest spec version to confirm
> whether the feature is actually implemented or reserved.
> 
> Based on the above point, this CPUID feature bit is set to 1 in KVM and
> KVM also adds emulation (as a fix) specifically for this MSR. This means
> that Guest is considered to have valid access to this feature MSR,
> except that if Guest doesn't get what it wants, then it is reasonable
> for Guest to assume that the current (v)CPU lacks hardware support and
> mark it as "unsupported processor".
> 
> As Konrad's mentioned, there's the previous explanation about why KVM
> sets this feature bit (it started with a little accident):
> 
> https://lore.kernel.org/kvm/CALMp9eRjDczhSirSismObZnzimxq4m+3s6Ka7OxwPj5Qj6X=BA@mail.gmail.com/#t
> 
> So I think the question is where this fix should be applied (KVM or
> QEMU) or if it should be applied at all, rather than whether Windows has
> the bug.

If we are agreed it's the bug of Windows, then no fix in QEMU/KVM at all.

> But I do agree, such "cleanups" would complicate QEMU, as I listed
> Eduardo as having done similar workaround six years ago:
> 
> https://lore.kernel.org/qemu-devel/20190125220606.4864-1-ehabkost@redhat.com/
> 
> Complexity and technical debt is an important consideration, and another
> consideration is the impact of this issue. Luckily, newer versions of
> Windows are actively compatible with KVM + QEMU:
> 
> https://blogs.windows.com/windows-insider/2025/06/23/announcing-windows-11-insider-preview-build-26120-4452-beta-channel/
> 
> But it's also hard to say if such a problem will happen again.
> Especially if the software works fine on real hardware but fails in
> "-host cpu" (which is supposed synchronized with host as much as
> possible).

work fine on real hardware but have issue with virtualization doesn't 
mean it is the problem of virtualization unless we figure out the 
root-cause and prove that software/OS's behavior is correct.

If the problem is due to the wrong behavior of guest OS, then it has 
nothing to do QEMU/KVM and QEMU/KVM cannot avoid such problem.


