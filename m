Return-Path: <kvm+bounces-35360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BDD6A10264
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 09:52:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 48DFF1887667
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 08:52:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83370284A75;
	Tue, 14 Jan 2025 08:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gHFPoLLg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D162338FA3
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 08:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736844759; cv=none; b=g1KrjzoSu7qW/iXKoQMQGkrCyAt6yKENLpZcYZrkFfh4ViDtZ4pqFht3jqN0t7J5PTdvpYCt1/uxpECrsyyRWT7r8RXvVMDZAU45bTyR93QuF71kW8PH4UoVPsORYcQhX01gDGn34APUgiBRuTv8MEWPr48JDhGdUetfLxdOGtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736844759; c=relaxed/simple;
	bh=f6usZVOc0+lmEHr0DktfiQxYv7Ud7H5qiOl4Zp/jjIM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cu6ru61QQQme0258ATYsOltW5GnTy7MKmG5uXw2DttY4Wuvw7bSb5CrCEKpgKJqdod1ZQ7nz+jjujA7+3F6/A71dBg+VUs/Arptmqz35gQDGYXeCOFqFbMn9pBMsE8EmkT6Om66f0I/SoXdiIXqBjZsl1e88AGSH5H9z0oLARd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gHFPoLLg; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736844758; x=1768380758;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=f6usZVOc0+lmEHr0DktfiQxYv7Ud7H5qiOl4Zp/jjIM=;
  b=gHFPoLLghsURE+ilxXoV27pFfghzN81kng2O7/P5tak/guq2sdT34lOA
   99iwz8++1zwqAHlMiEptJlFgbqx+taWMjQ2y8Hn0mP6lgqEcWHtUCXSQj
   ANgO+D4UBjcB/rWxMK3iGmxqiT4hqe5cIXd8sYnxj8h4H1ySKJysDjyu5
   F8j7DDxIFUgr5VrfLsdemK8VnlRoMjb3uA4nz9fTPYFxxALGtmZAywQhh
   +WR3bsSYcQpPgnaFJWfgZUIvCHeoVyJcvbSKyH07/TtgK8N/QZJdxKDT5
   WbrUhhrM1nYVfHp9lbRPRI3dTzXEzaghgyjF/jLG0E8GgGUOiGKMJbPMG
   Q==;
X-CSE-ConnectionGUID: LBCw2X4uR6OCegp+bxoaDA==
X-CSE-MsgGUID: jh5/gYIXThK8BQ6HIZeUZA==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="37046165"
X-IronPort-AV: E=Sophos;i="6.12,313,1728975600"; 
   d="scan'208";a="37046165"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 00:52:15 -0800
X-CSE-ConnectionGUID: eYxL9b7MTreBT5+XO3zGYg==
X-CSE-MsgGUID: nPLuQrqZR0aYhssEHp7RQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,313,1728975600"; 
   d="scan'208";a="104687300"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 00:52:09 -0800
Message-ID: <8d56ba39-ce9e-4afb-abd1-25cb393214a5@intel.com>
Date: Tue, 14 Jan 2025 16:52:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 34/60] i386/tdx: implement tdx_cpu_realizefn()
To: Ira Weiny <ira.weiny@intel.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Riku Voipio <riku.voipio@iki.fi>,
 Richard Henderson <richard.henderson@linaro.org>,
 Zhao Liu <zhao1.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Igor Mammedov <imammedo@redhat.com>, Ani Sinha <anisinha@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com,
 kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-35-xiaoyao.li@intel.com>
 <82b74218-f790-4300-ab3b-9c41de1f96b8@redhat.com>
 <2bedfcda-c2e7-4e5b-87a7-9352dfe28286@intel.com>
 <44627917-a848-4a86-bddb-20151ecfd39a@redhat.com>
 <Z1td_BZPlZ5G9Zaq@iweiny-mobl>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <Z1td_BZPlZ5G9Zaq@iweiny-mobl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/13/2024 6:04 AM, Ira Weiny wrote:
> On Tue, Nov 05, 2024 at 12:53:25PM +0100, Paolo Bonzini wrote:
>> On 11/5/24 12:38, Xiaoyao Li wrote:
>>> On 11/5/2024 6:06 PM, Paolo Bonzini wrote:
>>>> On 11/5/24 07:23, Xiaoyao Li wrote:
>>>>> +static void tdx_cpu_realizefn(X86ConfidentialGuest *cg, CPUState *cs,
>>>>> +                              Error **errp)
>>>>> +{
>>>>> +    X86CPU *cpu = X86_CPU(cs);
>>>>> +    uint32_t host_phys_bits = host_cpu_phys_bits();
>>>>> +
>>>>> +    if (!cpu->phys_bits) {
>>>>> +        cpu->phys_bits = host_phys_bits;
>>>>> +    } else if (cpu->phys_bits != host_phys_bits) {
>>>>> +        error_setg(errp, "TDX only supports host physical bits (%u)",
>>>>> +                   host_phys_bits);
>>>>> +    }
>>>>> +}
>>>>
>>>> This should be already handled by host_cpu_realizefn(), which is
>>>> reached via cpu_exec_realizefn().
>>>>
>>>> Why is it needed earlier, but not as early as instance_init?  If
>>>> absolutely needed I would do the assignment in patch 33, but I don't
>>>> understand why it's necessary.
>>>
>>> It's not called earlier but right after cpu_exec_realizefn().
>>>
>>> Patch 33 adds x86_confidenetial_guest_cpu_realizefn() right after
>>> ecpu_exec_realizefn(). This patch implements the callback and gets
>>> called in x86_confidenetial_guest_cpu_realizefn() so it's called after
>>> cpu_exec_realizefn().
>>>
>>> The reason why host_cpu_realizefn() cannot satisfy is that for normal
>>> VMs, the check in cpu_exec_realizefn() is just a warning and QEMU does
>>> allow the user to configure the physical address bit other than host's
>>> value, and the configured value will be seen inside guest. i.e., "-cpu
>>> phys-bits=xx" where xx != host_value works for normal VMs.
>>>
>>> But for TDX, KVM doesn't allow it and the value seen in TD guest is
>>> always the host value.  i.e., "-cpu phys-bits=xx" where xx != host_value
>>> doesn't work for TDX.
>>>
>>>> Either way, the check should be in tdx_check_features.
>>>
>>> Good idea. I will try to implement it in tdx_check_features()
> 
> Is there any reason the TDX code can't just force cpu->host_phys_bits to true?

That doesn't work for all the cases. e.g., when user set 
"host-phys-bits-limit" to a smaller value. For this case, QEMU still 
needs to validate the final cpu->phys_bits.

Of course, we can force host_phys_bits to true for TDX, and warn and 
exit when user set "host-phys-bits-limit" to a smaller value than host 
value.

But I prefer the current direction to check cpu->phys_bits directly, 
which is straightforward.

>>
>> Thanks, and I think there's no need to change cpu->phys_bits, either. So
>> x86_confidenetial_guest_cpu_realizefn() should not be necessary.
> 
> I was going to comment that patch 33 should be squashed here but better to just
> drop it.
> 
> Ira
> 
>>
>> Paolo
>>


