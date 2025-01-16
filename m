Return-Path: <kvm+bounces-35633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DD98A135E2
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 09:54:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 528711635CE
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 08:54:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38C1A1D63E6;
	Thu, 16 Jan 2025 08:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qy0ceT0X"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C851A26AF6
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 08:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737017642; cv=none; b=EK6Si/xOgj+41F2EVm/1E9Q+eG1eZtTpdM2tbRwg8SsBLEE5TbEzFXiTnDGrkjnLhlzDK6G+cZ+y0yr/daLSxLd6j81WcSnaeO5FLYCHENDmqExW8OGnWBuInD9DQdJL7xlH15aTU8fKGYRA/Wy3oP5RMiCw8KSWxmZ1/Atc5ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737017642; c=relaxed/simple;
	bh=yZw1YWix7/0v17N1NyNVK3/J2P5q4Pb8NI/rZF51DAI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Dv/t3dmicSaMichXUpjwWllJJKECnUmyRfDPU9yMIhVoGDmNgAiXtth/nwuIDzYTOFrKsVkumI/m8BAhZYS46Z2CweNFkf2b6jdP3P9Dp0t4CX9C+9K4CEtBSvXYPK5RQ0xCwbsNhKjhoAf3gt4R/g9KIYitqCyzyb3YnBZlFkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qy0ceT0X; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737017641; x=1768553641;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yZw1YWix7/0v17N1NyNVK3/J2P5q4Pb8NI/rZF51DAI=;
  b=Qy0ceT0Xm5bzlUzb7x5FthKLFLOwWP60OBaR1xvsozyrcvb/4DzbPVs1
   TwXmn7r5PYRjaUh20aPtuBEoFIG2fMDYBTKNXHQjBKMGlAI3bvcq1AivS
   iTN6fdCSqJ6x4gPm60fRcfNHc5hyi3Vm0A3XmGSLHCmGi3no6KJ/wIm7a
   e+IQllK0VqD6+wz5pBKCkiKVZBXNR4T4dOGRbknzdp2lPh4GFE0mArR/X
   8IGXbMxXQTzbXcF6p5fTIGK3fDge619dcBwJDOhSBeYrAa+cs6JzKJstJ
   HI7vTYOVR9Jhy1ppdZqD9vnTMRSPoPD3n7i8gzrQVjH3NlrC79Slh0agM
   g==;
X-CSE-ConnectionGUID: 106tcQ+QRY22mgclXDgY2g==
X-CSE-MsgGUID: Z99RUZGhSJegLnA/YB2mWA==
X-IronPort-AV: E=McAfee;i="6700,10204,11316"; a="41069500"
X-IronPort-AV: E=Sophos;i="6.13,208,1732608000"; 
   d="scan'208";a="41069500"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2025 00:54:01 -0800
X-CSE-ConnectionGUID: JcpwkuKERM6AP3SrjlcAZA==
X-CSE-MsgGUID: wvbgJKILTuSSIhHdUD1R+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,208,1732608000"; 
   d="scan'208";a="105471015"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2025 00:53:55 -0800
Message-ID: <3345330e-c111-4d08-9852-9dede46957d2@intel.com>
Date: Thu, 16 Jan 2025 16:53:51 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 56/60] i386/tdx: Don't treat SYSCALL as unavailable
To: Paolo Bonzini <pbonzini@redhat.com>, Riku Voipio <riku.voipio@iki.fi>,
 Richard Henderson <richard.henderson@linaro.org>,
 Zhao Liu <zhao1.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Igor Mammedov <imammedo@redhat.com>, Ani Sinha <anisinha@redhat.com>
Cc: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com,
 kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-57-xiaoyao.li@intel.com>
 <f1c7bba2-7b21-4e10-a245-36673e93f8b7@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <f1c7bba2-7b21-4e10-a245-36673e93f8b7@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/5/2024 5:59 PM, Paolo Bonzini wrote:
> On 11/5/24 07:24, Xiaoyao Li wrote:
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   target/i386/kvm/tdx.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>> index 9cb099e160e4..05475edf72bd 100644
>> --- a/target/i386/kvm/tdx.c
>> +++ b/target/i386/kvm/tdx.c
>> @@ -734,6 +734,13 @@ static int 
>> tdx_check_features(X86ConfidentialGuest *cg, CPUState *cs)
>>           requested = env->features[w];
>>           unavailable = requested & ~actual;
>> +        /*
>> +         * Intel enumerates SYSCALL bit as 1 only when processor in 
>> 64-bit
>> +         * mode and before vcpu running it's not in 64-bit mode.
>> +         */
>> +        if (w == FEAT_8000_0001_EDX && unavailable & 
>> CPUID_EXT2_SYSCALL) {
>> +            unavailable &= ~CPUID_EXT2_SYSCALL;
>> +        }
>>           mark_unavailable_features(cpu, w, unavailable, unav_prefix);
>>           if (unavailable) {
>>               mismatch = true;
> 
> This seems like a TDX module bug?  

I don't think so. The value of CPUID_EXT2_SYSCALL depends on the mode of 
the vcpu. Per SDM, it's 0 outside 64-bit mode.

The initial state of TDX vcpu is 32-bit protected mode. At the time of 
calling KVM_TDX_GET_CPUID, vcpu hasn't started running. So the value 
should be 0.

There indeed is a TDX module. After vcpu starts running and TD guest 
switches to 64-bit mode. The value of this bit returned by TDX module 
via global metadata CPUID value still remains 0.

Off the topic, for me, it's really a bad API to return TDX's CPUID value 
via TD-scope metadata. It fits better with TD VCPU scope metadata.

> It's the kind of thing that I guess 
> could be worked around in KVM.
> 
> If we do it in QEMU, I'd rather see it as
> 
>              actual = cpuid_entry_get_reg(entry, wi->cpuid.reg);
>              switch (w) {
>              case FEAT_8000_0001_EDX:
>                  actual |= CPUID_EXT2_SYSCALL;
>                  break;
>              }
>              break;

I'll change to this way.


> Paolo
> 


