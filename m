Return-Path: <kvm+bounces-20935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A53A926E3C
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 06:10:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE70F1F2363C
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 04:10:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAB591C68D;
	Thu,  4 Jul 2024 04:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j9bhDnL0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC8C1B960
	for <kvm@vger.kernel.org>; Thu,  4 Jul 2024 04:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720066194; cv=none; b=UhVddhag8fS1C+Fss4+TotV0qDvcn8Mxn2hJhdEhTQ0vjnQyHcBNC+6wdDMWEDokh/TpLF8OFbVbZwTQn2qdiD/yVMTJ7soapQyFLlOJKZEwgw+aMd2Vq49g7wjwvzqUIxREJQbPTcBJxMYu68m56fFVmyV3ZHfjXz/6yREp9N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720066194; c=relaxed/simple;
	bh=vPfv98N33pPnna36PiJA/F9cC9nEMA5OavXDbU2b7Iw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GlQI64k0WPtHUt+dD1Q4KIyCXdPNnqGme9Sk4oB3y+g4NCe68BX/2ZBoE446oQJLgrSj5+NwAfK6nkIbwz5qgIc5j9oHIPuoGN791sR4LUvHlm8/06md52qapMp0JXR/JqxKzTU4Pc0+oq92meOg5uNnv5DgAsDDon/BLgNX6Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j9bhDnL0; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720066193; x=1751602193;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vPfv98N33pPnna36PiJA/F9cC9nEMA5OavXDbU2b7Iw=;
  b=j9bhDnL0MkWQVukN0YSYtpaaRE+YofZs6al1zn6Jv7D8csW6xN2jrLur
   FZtWkYJm8l5GTByzviGYSPubTOEhiZupURsXVv6INjZGMbbzlRzWs3eOE
   6gJFXEL9A+DJXExTqJa5HRtFo6z+JFi8LXu9Nb5OazWG3S2xINcPsWxGn
   EcMWNr5bnuCZk79hHDS9g7IcFVen58FW0bTqEhVAu+UE/NIfqe4Ic3htF
   gayfETB0svRdL8sYuOLOfCik6s3Ec/y0UY6XeFXIfiArMomzGcIbFF72w
   q7GKBGH+0R3U05iIZv8dsysFR+wYMy+hvZx7qLuYCnXN1RE9ZBcsxl8HH
   Q==;
X-CSE-ConnectionGUID: hC2lK5QeQcCQBDroUDVNaQ==
X-CSE-MsgGUID: nP7fzulCRbS/2uvWVKwMsA==
X-IronPort-AV: E=McAfee;i="6700,10204,11122"; a="21195171"
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="21195171"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2024 21:09:52 -0700
X-CSE-ConnectionGUID: geRWiIKuQAehZqJYaC3G0g==
X-CSE-MsgGUID: 8gcTW4u+SQK0aH2QY11Lqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="84008243"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.26]) ([10.124.240.26])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2024 21:09:49 -0700
Message-ID: <213b9762-205e-4d48-b7f7-1948d0f3b0d9@intel.com>
Date: Thu, 4 Jul 2024 12:09:45 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 20/31] i386/sev: Add support for SNP CPUID validation
To: Michael Roth <michael.roth@amd.com>
Cc: Pankaj Gupta <pankaj.gupta@amd.com>, qemu-devel@nongnu.org,
 brijesh.singh@amd.com, dovmurik@linux.ibm.com, armbru@redhat.com,
 pbonzini@redhat.com, thomas.lendacky@amd.com, isaku.yamahata@intel.com,
 berrange@redhat.com, kvm@vger.kernel.org, anisinha@redhat.com
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
 <20240530111643.1091816-21-pankaj.gupta@amd.com>
 <ce80850a-fbd1-4e14-8107-47c7423fa204@intel.com>
 <20240704003406.6tduun5n25kgtojf@amd.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240704003406.6tduun5n25kgtojf@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/4/2024 8:34 AM, Michael Roth wrote:
> On Tue, Jul 02, 2024 at 11:07:18AM +0800, Xiaoyao Li wrote:
>> On 5/30/2024 7:16 PM, Pankaj Gupta wrote:
>>> From: Michael Roth <michael.roth@amd.com>
>>>
>>> SEV-SNP firmware allows a special guest page to be populated with a
>>> table of guest CPUID values so that they can be validated through
>>> firmware before being loaded into encrypted guest memory where they can
>>> be used in place of hypervisor-provided values[1].
>>>
>>> As part of SEV-SNP guest initialization, use this interface to validate
>>> the CPUID entries reported by KVM_GET_CPUID2 prior to initial guest
>>> start and populate the CPUID page reserved by OVMF with the resulting
>>> encrypted data.
>>
>> How is KVM CPUIDs (leaf 0x40000001) validated?
>>
>> I suppose not all KVM_FEATURE_XXX are supported for SNP guest. And SNP
>> firmware doesn't validate such CPUID range. So how does them get validated?
> 
> This rules for CPUID enforcement are documented in the PPR for each AMD
> CPU model in Chapter 2, section "CPUID Policy Enforcement". For the
> situation you mentioned, it's stated there that:
> 
>    The PSP enforces the following policy:
>    - If the CPUID function is not in the standard range (Fn00000000 through
>      Fn0000FFFF) or the extended range
>      (Fn8000_0000 through Fn8000_FFFF), the function output check is
>      UnChecked.
>    - If the CPUID function is in the standard or extended range and the
>      function is not listed in SEV-SNP CPUID
>      Policy table, then the output check is Strict and required to be 0. Note
>      that if the CPUID function does not depend
>      on ECX and/or XCR0, then the PSP policy ignores those inputs,
>      respectively.
>    - Otherwise, the check is defined according to the values listed in
>      SEV-SNP CPUID Policy table.
> 
> So there are specific ranges that are checked, mainly ones where there
> is potential for guests to misbehave if they are being lied to. But
> hypervisor-ranges are paravirtual in a sense so there's no assumptions
> being made about what the underlying hardware is doing, so the checks
> are needed as much in those cases.

I'm a little confused. Per your reference above, hypervisor-ranges is 
unchecked because it's not in the standard range nor the extended range.

And your last sentence said "so the checks are needed as much in those 
cases". So how does hypervisor-ranges get checked?

> -Mike
> 
>>
>>> [1] SEV SNP Firmware ABI Specification, Rev. 0.8, 8.13.2.6
>>>
>>


