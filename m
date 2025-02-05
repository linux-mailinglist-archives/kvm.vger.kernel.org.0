Return-Path: <kvm+bounces-37323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA7B5A28803
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 11:30:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 434D97A86BD
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 10:29:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F81022B5A5;
	Wed,  5 Feb 2025 10:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UQuHoV2P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EC422B5AC
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 10:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738751360; cv=none; b=sdvB/+4qrwuWub2erb83jdYUyOS8HKo3gQCTh56NkJgQA407tKSA9sus5bTJmPUanf6Evu43zakB90wHl4vI5u9SkUwBUm1w9JXS6XWBAbcAwWvjsddopfgTtieMtE1FLD5OpuKfEjKsjqoFUsDUr5+RlMN/qQd20NvZySUZNQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738751360; c=relaxed/simple;
	bh=334KkDC7EyuQcwN7ovyQW7RvcYBsNBgMLnTEYSz5aYc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bm0yOxPAiySkNcnMZ0PczRhqVIArw0ePPTfVNKYXQLAmON6GOctO0VN+5zJE3aNGLgmjv3cKccQvG8PTtzV1Zmpd9klNuIOZgmNP1vWzAF5WuWE1tAVVhZ+RNX/xEgYf+cn8MQwcAtzEs9EDnCZFMwJZY1O3iBL/c9cR2rfMpwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UQuHoV2P; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738751358; x=1770287358;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=334KkDC7EyuQcwN7ovyQW7RvcYBsNBgMLnTEYSz5aYc=;
  b=UQuHoV2PGeMU8DtgU0nxLlsOP4PE14QpwqPuUqEERDetaMDnQur8lvqX
   VLWXgVPbpEwfcoT+aBoBszB1nSEdpER1mlTsbJQYgYg3WbUuEItADVh6H
   GZRVtpXAFnPcieFFnKYlTlh4UE23Gu7B6ZaTW4j4Iy5iRe1t3jfS1gcn3
   HThL54Mn2NaRmHSL0sUG0CSKEMR9wQZgosSbylu+IL3sqsoMC6Y52YBXX
   3r5Wn38MfnQJkzcpbnupqk0rGcR/+Edle93V8T4jAV8Ljc0p6tDMmD3nB
   Hs5F86gTAMinNX+41ui22K1mB5V/8SH1LLO39n18zVSRkjGpfhq3IM94V
   A==;
X-CSE-ConnectionGUID: GQ0KL7jxS72TqRMpUwAAcA==
X-CSE-MsgGUID: vT/Dqw0ASLi2wKWTjicXLw==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="49561776"
X-IronPort-AV: E=Sophos;i="6.13,261,1732608000"; 
   d="scan'208";a="49561776"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2025 02:29:18 -0800
X-CSE-ConnectionGUID: o2XfOx7NSpW4ShZBReTJZw==
X-CSE-MsgGUID: JhG4VD9PTDa2CLDctdCpBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,261,1732608000"; 
   d="scan'208";a="110758692"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2025 02:29:14 -0800
Message-ID: <931df5b6-beeb-49dc-9f3f-c8a06522d632@intel.com>
Date: Wed, 5 Feb 2025 18:29:11 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 12/52] i386/tdx: Validate TD attributes
To: Markus Armbruster <armbru@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Igor Mammedov <imammedo@redhat.com>, Zhao Liu <zhao1.liu@intel.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Eric Blake <eblake@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>,
 Marcelo Tosatti <mtosatti@redhat.com>, Huacai Chen <chenhuacai@kernel.org>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Francesco Lavra <francescolavra.fl@gmail.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
 <20250124132048.3229049-13-xiaoyao.li@intel.com>
 <878qqk4v6i.fsf@pond.sub.org>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <878qqk4v6i.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/5/2025 5:06 PM, Markus Armbruster wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
>> Validate TD attributes with tdx_caps that only supported bits arer
>> allowed by KVM.
>>
>> Besides, sanity check the attribute bits that have not been supported by
>> QEMU yet. e.g., debug bit, it will be allowed in the future when debug
>> TD support lands in QEMU.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
>> ---
>> Changes in v7:
>> - Define TDX_SUPPORTED_TD_ATTRS as QEMU supported mask, to validates
>>    user's request. (Rick)
>>
>> Changes in v3:
>> - using error_setg() for error report; (Daniel)
>> ---
>>   qapi/qom.json         |  16 +++++-
>>   target/i386/kvm/tdx.c | 118 +++++++++++++++++++++++++++++++++++++++++-
>>   target/i386/kvm/tdx.h |   3 ++
>>   3 files changed, 134 insertions(+), 3 deletions(-)
>>
>> diff --git a/qapi/qom.json b/qapi/qom.json
>> index 8740626c4ee6..a53000ca6fb4 100644
>> --- a/qapi/qom.json
>> +++ b/qapi/qom.json
>> @@ -1060,11 +1060,25 @@
>>   #     pages.  Some guest OS (e.g., Linux TD guest) may require this to
>>   #     be set, otherwise they refuse to boot.
>>   #
>> +# @mrconfigid: ID for non-owner-defined configuration of the guest TD,
>> +#     e.g., run-time or OS configuration (base64 encoded SHA384 digest).
>> +#     Defaults to all zeros.
>> +#
>> +# @mrowner: ID for the guest TD’s owner (base64 encoded SHA384 digest).
>> +#     Defaults to all zeros.
>> +#
>> +# @mrownerconfig: ID for owner-defined configuration of the guest TD,
>> +#     e.g., specific to the workload rather than the run-time or OS
>> +#     (base64 encoded SHA384 digest).  Defaults to all zeros.
> 
> All three members are IDs, but only the first one has "id" in its name.
> Odd.  Any particular reason for that?
> 
>> +#
>>   # Since: 10.0
>>   ##
>>   { 'struct': 'TdxGuestProperties',
>>     'data': { '*attributes': 'uint64',
>> -            '*sept-ve-disable': 'bool' } }
>> +            '*sept-ve-disable': 'bool',
>> +            '*mrconfigid': 'str',
>> +            '*mrowner': 'str',
>> +            '*mrownerconfig': 'str' } }
> 
> The member names are abbreviations all run together, wheras QAPI/QMP
> favors words-separated-with-dashes.  If you invented them, please change
> them to QAPI/QMP style.  If they are established TDX terminology, keep
> them as they are, but please show us your evidence.

The names are defined in TDX spec. Table 3.13 "TD_PARAMS definition" in 
TDX Module ABI spec[1]. And they are used for attestation, please refer 
to section 12 "Measurement and Attestation" in TDX Module Base spec[2].

[1] https://cdrdv2.intel.com/v1/dl/getContent/733579
[2] https://cdrdv2.intel.com/v1/dl/getContent/733575


>>   
>>   ##
>>   # @ThreadContextProperties:
> 
> [...]
> 


