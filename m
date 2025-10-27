Return-Path: <kvm+bounces-61159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 3377DC0D60E
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 13:03:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D157B34A62A
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 12:03:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F9602F7AD6;
	Mon, 27 Oct 2025 12:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LkKsvDud"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1290136E37
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 12:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761566589; cv=none; b=QAlAq2BG+7enZoLxYn/RI0NrULsnL03wXAz+G3uTp+U1T821DpFbwcEHCM/Wh4fl+wXnRX7x25ey896KLqxM1cK24nPAwCpFE+ZcYS6ZN4PrVC59LEVhigW4P6UqEIep61mcdSdS/J7/62NV+jzj06jD2dyxYM14Ao5jXpHTRXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761566589; c=relaxed/simple;
	bh=6LCxF2jA+tRNbEsvz636k3v92U5z6MVr9ifOurEWXoI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r/XIoqOmqzVNQR2ixLdXPNNdi58XK6I4bsI37zwh73hEqydj22CCdP/qvWHpnYP7jiOWqk81Tb0Z/F0HKyP5HK6OoxDo9EphwR4uJTZsmgdHTGRrSiN3gSlwm2vjSVq4wQQygsTZAJcW2a+MMZeJV50qIkdPsxjDvE+K4LbuHE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LkKsvDud; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761566587; x=1793102587;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6LCxF2jA+tRNbEsvz636k3v92U5z6MVr9ifOurEWXoI=;
  b=LkKsvDudsWI5rMGoHCiOTW7APhcbyy5HcKi5VyjTTKeYo+d8p6zOkNQ/
   YvZiAU0+XgtsL1SNMReppboi1tlb+pWjJm5U2hnnbdjdDiOK78KB7YkwQ
   4WWwilsXx3MeeAIl+IXe9eAydlil4dWuYl7sZaOpplB2ymmgFz1AaRXgc
   gMyQ7qZzFA0TrNaGmlIn+p5uVYml8G923VD5/rvWVJ19LJ3mTsPB/CbgN
   TOKucAoSVZoI8rJzCzfhQx+RXHNQHaJoEeQ+7flVgS6hqgiIEH9yjtZn0
   b6GlDUxYGsuPBzpOVC6uR1QY0LbQq7oW795qHxBO3ZSbKUu+yhFUJWAAQ
   A==;
X-CSE-ConnectionGUID: iAznEdUdT6ak77uKGpLdLQ==
X-CSE-MsgGUID: xWTSOjrzQjyvYkskIAyniQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="73930315"
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="73930315"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 05:03:04 -0700
X-CSE-ConnectionGUID: N+Q9za3bSYybuKHJA7IsZQ==
X-CSE-MsgGUID: 0kPqkZuySniQb1bI7Vwfaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="184648115"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 05:03:01 -0700
Message-ID: <308bcfcd-6c43-4530-8ba7-8a2d8a7b0c8f@intel.com>
Date: Mon, 27 Oct 2025 20:02:58 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/20] i386/cpu: Add missing migratable xsave features
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
 John Allen <john.allen@amd.com>, Babu Moger <babu.moger@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, Dapeng Mi <dapeng1.mi@intel.com>,
 Zide Chen <zide.chen@intel.com>, Chenyi Qiang <chenyi.qiang@intel.com>,
 Farrah Chen <farrah.chen@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-11-zhao1.liu@intel.com>
 <0dc79cc8-f932-4025-aff3-b1d5b56cb654@intel.com> <aP9HPKwHPcOlBTwm@intel.com>
 <aP9VF7FkfGeY6B+Q@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aP9VF7FkfGeY6B+Q@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/27/2025 7:18 PM, Zhao Liu wrote:
> On Mon, Oct 27, 2025 at 06:19:40PM +0800, Zhao Liu wrote:
>> Date: Mon, 27 Oct 2025 18:19:40 +0800
>> From: Zhao Liu <zhao1.liu@intel.com>
>> Subject: Re: [PATCH v3 10/20] i386/cpu: Add missing migratable xsave
>>   features
>>
>>> Though the feature expansion in x86_cpu_expand_features() under
>>>
>>> 	if (xcc->max_features) {
>>> 		...
>>> 	}
>>>
>>> only enables migratable features when cpu->migratable is true,
>>> x86_cpu_enable_xsave_components() overwrite the value later.
>>
>> I have not changed the related logic, and this was intentional...too,
>> which is planed to be cleaned up after CET.
> 
> There's only 1 use case of migratable_flags, so I would try to drop
> it directly.
> 
> The xsave-managed/enabled feature is not suitable as the configurable
> feature. Therefore, it is best to keep it non-configurable as it is
> currently.
> 
> At least with this fix, the support for the new xsave feature —
> including APX next — will not be broken, 

can you elaborate what will be broken without the patch?

As I see, we can drop the .migratable_flags directly.

migrable_flags is only used in x86_cpu_get_migratable_flags(), which is 
only called by x86_cpu_get_supported_feature_word() when passed @cpu is 
not null and cpu->migratable is true. So it only affects the case of

   x86_cpu_expand_features()
     -> x86_cpu_get_supported_feature_word()

And only FEAT_XSAVE_XCR0_LO defines .migratable_flags

As I commented earlier, though the .migrable_flags determines the return 
value of x86_cpu_get_supported_feature_word() for 
features[FEAT_XSAVE_XCR0_LO] in x86_cpu_expand_features(), eventually 
the x86_cpu_enable_xsave_components() overwrites 
features[FEAT_XSAVE_XCR0_LO]. So even we set the migratable_flags to 0 
for FEAT_XSAVE_XCR0_LO, it doesn't have any issue.

So I think we can remove migratable_flags totally.

> and the migratable flag
> refactoring will become a separate RFC.
> 
> Regards,
> Zhao
> 


