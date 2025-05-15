Return-Path: <kvm+bounces-46645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 23789AB7E3A
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 08:43:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9DB6A4C4A6F
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 06:43:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA786296FB2;
	Thu, 15 May 2025 06:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YbcJd+AR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2539D2628D
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 06:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747291416; cv=none; b=heqc8hJUmi0aiOdr4rYuc3uSFEccF85AxOcXVW9ozJVDbCSrZmtu4CFbkMSklZ0IRcfBLMr4pt3dyW4t6NH+ytsjn5E4NomlRLU02Ram7Pt8tjB/jX/Gtqaoyo5Cl8J2IGQtAmCbJabuyx1hn5qiy7/FQRLG2CZDcc+duloxfy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747291416; c=relaxed/simple;
	bh=I09ea2kKf9RnKIED493f/5AWWrQRUzEO3KzDsvyoMOY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lEnwIyG4xiin6ad1JvReGiqmsQXrlbMo0bh8D/8UVNDi2FSMbtBvVHndNI09hdjpuGd3yB+DXPCp8Yygu6iYPEySDd2SV/TW8Sscy79hoSr78c4NKghJiCMtl9N1lpPk/IhsdBCZHuGE5OvWXtN0+oTxGPHLg+QAj9Mhx6a9700=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YbcJd+AR; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747291415; x=1778827415;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=I09ea2kKf9RnKIED493f/5AWWrQRUzEO3KzDsvyoMOY=;
  b=YbcJd+ARShscU7PZA6hD4Qlgn96mxQD6O//m8CuwHtjW2GywQkLdMGTo
   XLHkPJAdTaSDRoQ0abYlmHGCXwrA9K6HFRtg8sIRS53mBo/nGEqFBWPKz
   KkMqs+nDQr1hEGVcLXcQiokoA+nXnw8Z82pEv1w3xz9sUuuhGHqZzwpLU
   7NY271mkhzVQ7L80RDb5mt1Cg4phnDGX86hO32v4MarA0bbP5QQxcy7Dv
   lfGRajFsCz0T/rkXqyi7Q0FitlQ+X9qydf9jNvFWAm+o+jgJd9RjR+8RD
   fw2RXlatDY+4+5nMHydylCcyh0Uloc1H3Zp0MSNIXPJCcIxXO+kTQooSE
   A==;
X-CSE-ConnectionGUID: BW9Y/DffRTCr/P1tlcLiVg==
X-CSE-MsgGUID: Bu92vIJATw2Xxpd9leDN9A==
X-IronPort-AV: E=McAfee;i="6700,10204,11433"; a="60222684"
X-IronPort-AV: E=Sophos;i="6.15,290,1739865600"; 
   d="scan'208";a="60222684"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2025 23:43:34 -0700
X-CSE-ConnectionGUID: OyFXNiyCS+KrRiFuXOWz3w==
X-CSE-MsgGUID: kg+8aFfdQHadJbEhcLz3nw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,290,1739865600"; 
   d="scan'208";a="143153675"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2025 23:43:30 -0700
Message-ID: <f825c105-9a19-4b17-9798-57d6cff76f95@intel.com>
Date: Thu, 15 May 2025 14:43:27 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 06/10] i386/cpu: Introduce enable_cpuid_0x1f to force
 exposing CPUID 0x1f
To: Zhao Liu <zhao1.liu@intel.com>, Igor Mammedov <imammedo@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Babu Moger <babu.moger@amd.com>,
 Ewan Hai <ewanhai-oc@zhaoxin.com>, Tejus GK <tejus.gk@nutanix.com>,
 Jason Zeng <jason.zeng@intel.com>, Manish Mishra
 <manish.mishra@nutanix.com>, Tao Su <tao1.su@intel.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20250423114702.1529340-1-zhao1.liu@intel.com>
 <20250423114702.1529340-7-zhao1.liu@intel.com>
 <20250513144515.37615651@imammedo.users.ipa.redhat.com>
 <aCS1XVotdnLw+kqX@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aCS1XVotdnLw+kqX@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/14/2025 11:23 PM, Zhao Liu wrote:
> Hi Igor, thanks for your review!
> 
> On Tue, May 13, 2025 at 02:45:15PM +0200, Igor Mammedov wrote:
>> Date: Tue, 13 May 2025 14:45:15 +0200
>> From: Igor Mammedov <imammedo@redhat.com>
>> Subject: Re: [RFC 06/10] i386/cpu: Introduce enable_cpuid_0x1f to force
>>   exposing CPUID 0x1f
>> X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
>>
>> On Wed, 23 Apr 2025 19:46:58 +0800
>> Zhao Liu <zhao1.liu@intel.com> wrote:
>>
>>> From: Xiaoyao Li <xiaoyao.li@intel.com>
>>>
>>> Currently, QEMU exposes CPUID 0x1f to guest only when necessary, i.e.,
>>> when topology level that cannot be enumerated by leaf 0xB, e.g., die or
>>> module level, are configured for the guest, e.g., -smp xx,dies=2.
>>>
>>> However, TDX architecture forces to require CPUID 0x1f to configure CPU
>>> topology.
>>>
>>> Introduce a bool flag, enable_cpuid_0x1f, in CPU for the case that
>>> requires CPUID leaf 0x1f to be exposed to guest.
>>>
>>> Introduce a new function x86_has_cpuid_0x1f(), which is the warpper of
>>> cpu->enable_cpuid_0x1f and x86_has_extended_topo() to check if it needs
>>> to enable cpuid leaf 0x1f for the guest.
>>
>> that reminds me about recent attempt to remove enable_cpuid_0xb,
>>
>> So is enable_cpuid_0x1f inteded to be used by external users or
>> it's internal only knob for TDX sake?
> 
> TDX needs this and I also try to apply this to named CPU models. For
> max/host CPUs, there are no explicit use cases. I think it's enough to
> make named CPU models have 0x1f.
> 
> Then this should be only used internally.
> 
>> I'd push for it being marked as internal|unstable with the means
>> we currently have (i.e. adding 'x-' prefix)
> 
> Sure, 'x-' is good. (If there is the internal property in the future,
> I can also convert this unsatble property into internal one.)
> 
> This patch is picked from the TDX series, and in this patch Xiaoyao
> doesn't make 0x1f enabling as property. In the next patch (RFC patch 7),
> I add the "cpuid-0x1f" property. I'll rename that property as
> "x-cpuid-0x1f".
> 
>> and also enable_ is not right here, the leaf is enabled when
>> topology requires it.
>> perhaps s/enable_/force_/
> 
> Thanks, I agree force_cpuid_0x1f is a better name.
> 
> @Xiaoyao, do you agree with this idea?
> 
> But probably TDX won't have v10 though, I can rename the field in my v2
> after TDX.

I'm OK with it.

The TDX series won't be merged by Paolo soon. It has to be after the KVM 
part being in linux v6.16-rc1, i.e., about one month later.

And there are rebase conflicts when I rebase the TDX-QEMU series against 
upstream QEMU master daily. It seems to have a newer version of TDX-QEMU 
when it's going to be picked up by Paolo for Paolo's convenience. If a 
v10 needed, I can rename in it.

Let's see how it goes.

> Regards,
> Zhao
> 


