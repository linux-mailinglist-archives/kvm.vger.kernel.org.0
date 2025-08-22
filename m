Return-Path: <kvm+bounces-55441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2722EB30AF3
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 03:47:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C3E644E3B05
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 01:47:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38F881B4F0E;
	Fri, 22 Aug 2025 01:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I3C3sEON"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57656FC3;
	Fri, 22 Aug 2025 01:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755827221; cv=none; b=bNpPS0LZvOOgCmJOivJLIJhECIYCivZ4Q/Gqm/jGcrB2/JEO7GOnozHXdungzAn9YMhyG+3DVFkodiU2/BuKx+Ams57eCFOQwvIMrsbbO+tnOlysbF/lbDNiFtY1x/eDvYPeErzPM7ge8LAHm8zMQIhE8+Pu7Hokumpr8KKVqJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755827221; c=relaxed/simple;
	bh=dlNqS8GuyaD0jRtHmWGKX6D3RkxY5DYdizCYX+dXy5s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ilCGd0fdMs7pC13j/2YlyY8t8jKEt9L3W8Zuw46b2DQ9VcIK709E0gxTyxHCDaJ0ims3a95T850RRLjQG2pvWUfv7zCizqEPBeU8Djwb9C0Ps6LR6x7UxT/r1QcyUNSss7ehViODVQaZ9xjkxsnR6dvHBDd6tTtlcSarcx8MoCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I3C3sEON; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755827220; x=1787363220;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dlNqS8GuyaD0jRtHmWGKX6D3RkxY5DYdizCYX+dXy5s=;
  b=I3C3sEONN9SV32FuIS/2CFjgoywkO2m5t4ipUCjc8r49EIFCCGDW58nt
   6KZV8u+Dw1DAcStHe0rDadFoiSb2xokyrA/lNCICUYc1QxTzVFniLNB/t
   2eLABrnkUJBPHBZNd4A/+10Xhg2Q+P3ywm9b5b0/2wiE5G08QTXJLDlnO
   E6o0UXMXLmLqUA/njpHeAWppUkgJfEAB//F2LhV9QSD6WGAEA70a3yn0j
   7fpE+kO2B1PH1BRV8AnOuenTncVVszD0NAV2ZHzcD/uIcfQPhItXCuGFP
   DzsXkHX/j51Ic032xab/38StBHu2Eq5csP/fuTwkKK7H4ik5uwkJpHD9c
   Q==;
X-CSE-ConnectionGUID: 6iYUc/PSTh6MG2yfjFr6aA==
X-CSE-MsgGUID: b2bE0OkfQHeXCYJRlyp8xg==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="58199893"
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="58199893"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 18:46:59 -0700
X-CSE-ConnectionGUID: AZFJ9i6pRCaPCV9OGTd+yQ==
X-CSE-MsgGUID: COxnV628RZWhh4q30kM6AA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="173843816"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 18:46:51 -0700
Message-ID: <03ac8bac-c8d1-4a3b-a07f-2bbf04e726b6@intel.com>
Date: Fri, 22 Aug 2025 09:46:48 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/15] x86/cpu/intel: Bound the non-architectural
 constant_tsc model checks
To: Sohil Mehta <sohil.mehta@intel.com>, David Woodhouse
 <dwmw2@infradead.org>, x86@kernel.org,
 Dave Hansen <dave.hansen@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
 =?UTF-8?Q?J=C3=BCrgen_Gross?= <jgross@suse.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 xen-devel <xen-devel@lists.xenproject.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 Kan Liang <kan.liang@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
 Borislav Petkov <bp@alien8.de>, "H . Peter Anvin" <hpa@zytor.com>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>,
 Andy Lutomirski <luto@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>,
 Jean Delvare <jdelvare@suse.com>, Guenter Roeck <linux@roeck-us.net>,
 Zhang Rui <rui.zhang@intel.com>, Andrew Cooper <andrew.cooper3@citrix.com>,
 David Laight <david.laight.linux@gmail.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
 linux-pm@vger.kernel.org, kvm@vger.kernel.org, Xin Li <xin@zytor.com>
References: <20250219184133.816753-1-sohil.mehta@intel.com>
 <20250219184133.816753-14-sohil.mehta@intel.com>
 <6f05a6849fb7b22db35216dcf12bf537f8a43a92.camel@infradead.org>
 <968a179f-3da7-4c69-b798-357ea8d759eb@intel.com>
 <5f5f1230-f373-469c-b0d9-abc80199886e@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <5f5f1230-f373-469c-b0d9-abc80199886e@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/22/2025 3:43 AM, Sohil Mehta wrote:
> On 8/21/2025 12:34 PM, Sohil Mehta wrote:
>> On 8/21/2025 6:15 AM, David Woodhouse wrote:
>>
>>> Hm. My test host is INTEL_HASWELL_X (0x63f). For reasons which are
>>> unclear to me, QEMU doesn't set bit 8 of 0x80000007 EDX unless I
>>> explicitly append ',+invtsc' to the existing '-cpu host' on its command
>>> line. So now my guest doesn't think it has X86_FEATURE_CONSTANT_TSC.
>>>
>>
>> Haswell should have X86_FEATURE_CONSTANT_TSC, so I would have expected
>> the guest bit to be set. Until now, X86_FEATURE_CONSTANT_TSC was set
>> based on the Family-model instead of the CPUID enumeration which may
>> have hid the issue.
>>
> 
> Correction:
> s/instead/as well as
> 
>>  From my initial look at the QEMU implementation, this seems intentional.
>>
>> QEMU considers Invariant TSC as un-migratable which prevents it from
>> being exposed to migratable guests (default).
>> target/i386/cpu.c:
>> [FEAT_8000_0007_EDX]
>>           .unmigratable_flags = CPUID_APM_INVTSC,
>>
>> Can you please try '-cpu host,migratable=off'?
> 
> This is mainly to verify. If confirmed, I am not sure what the long term
> solution should be.

yeah. It's the intentional behavior of QEMU.

Invariant TSC is ummigratable unless users explicitly configures the TSC 
frequency, e.g., "-cpu host,tsc-frequency=xxx". Because the TSC 
frequency is by default the host's frequency if no "tsc-frequency" 
specified, and it will change when the VM is migrated to a host with a 
different TSC frequency.

It's the specific behavior/rule of QEMU. We just need to keep it in 
mind. If we want to expose invariant TSC to the guest with QEMU's "-cpu 
host", we can either:
1) explicitly configure the "tsc-frequency", or
2) explicitly turn off "migratable"

