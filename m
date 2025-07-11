Return-Path: <kvm+bounces-52108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F78AB016FF
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 10:57:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1AF551C23D68
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 08:57:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C1622192EE;
	Fri, 11 Jul 2025 08:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fWvrRbEM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF7F1F239B;
	Fri, 11 Jul 2025 08:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752224223; cv=none; b=Ho5KEb7Eyb55xSS5d1iGdw4hg/WTvPsCTZHmPcFprxSwHdZChxzMY7QvXRBdcehHSufVvzvSPzo8+gx8ZSOZ+S/gQQYoWfvZLxkHuf/4L7swDTztCOCA0WieQ72fKasPL9RCMh9qOeJIJ8ySKE2S6JF9EifdHLhb3C0gpucDXns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752224223; c=relaxed/simple;
	bh=zbfjWmjznnLXYocXOSEYiAaGJmiOgBuKAm4AEmaWrqU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rSc++YWc6Hg5M6avONvmqXoItHWaGnThE7p8YfMYto8jUrI5mPeP6YiaOuhpQ/OLEAhYfxkl1pzGdneFajWTlGQOHku6img+cjyPVMd23p0/bezGhetNHEAvNRx3j+rnW8YZoiCmsgS/x460fYIEYUZ3BWbE5G+jZZDJXmTM3Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fWvrRbEM; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752224221; x=1783760221;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zbfjWmjznnLXYocXOSEYiAaGJmiOgBuKAm4AEmaWrqU=;
  b=fWvrRbEMKWjiG5jUrfy3tCudMyZDg8U+8nvsE2zO6k/8taVTQsqE7Fn8
   kclu7E+ZuG3yKmZ+H8bKxSoB8bwySHLbrTm2HSguKRsBof92TYsxdfVxo
   ss/pOokh0LEbUq+SkU69melfaZ8h+xn8id552jLbUdtFVxkTlhcnVCeeu
   MuqIs/DGy390mDkzKmpos8Q+S2dPg240T0CKtX3Qm6WP/BvOCecB8VSol
   +TKzlh79lDEWHr/P1AQxc9yFMTXcZCDzmJcrVDr2WyOvaKUIjGgi45AJ6
   oQdMnprQtZ5NaHaOzsKko/Um0Rzu+BTa6bnZhRs7oDb5piC8FjYTw7l1/
   Q==;
X-CSE-ConnectionGUID: N0Z2+0mMTQWPHfHLfFLwXw==
X-CSE-MsgGUID: p0rNkwmtTuyL1lH/CzNegA==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="54373633"
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="54373633"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 01:55:53 -0700
X-CSE-ConnectionGUID: 0693nmyjRsWVDkocPJvbKA==
X-CSE-MsgGUID: muzAU0w6R1OFtDXsjkeJfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="155737088"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 01:55:50 -0700
Message-ID: <7103b312-b02d-440e-9fa6-ba219a510c2d@intel.com>
Date: Fri, 11 Jul 2025 16:55:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 0/1] KVM: TDX: Decrease TDX VM shutdown time
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
 Adrian Hunter <adrian.hunter@intel.com>
Cc: kvm@vger.kernel.org, rick.p.edgecombe@intel.com,
 kirill.shutemov@linux.intel.com, kai.huang@intel.com,
 reinette.chatre@intel.com, tony.lindgren@linux.intel.com,
 binbin.wu@linux.intel.com, isaku.yamahata@intel.com,
 linux-kernel@vger.kernel.org, yan.y.zhao@intel.com, chao.gao@intel.com
References: <20250611095158.19398-1-adrian.hunter@intel.com>
 <175088949072.720373.4112758062004721516.b4-ty@google.com>
 <aF1uNonhK1rQ8ViZ@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aF1uNonhK1rQ8ViZ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/26/2025 11:58 PM, Sean Christopherson wrote:
> On Wed, Jun 25, 2025, Sean Christopherson wrote:
>> On Wed, 11 Jun 2025 12:51:57 +0300, Adrian Hunter wrote:
>>> Changes in V4:
>>>
>>> 	Drop TDX_FLUSHVP_NOT_DONE change.  It will be done separately.
>>> 	Use KVM_BUG_ON() instead of WARN_ON().
>>> 	Correct kvm_trylock_all_vcpus() return value.
>>>
>>> Changes in V3:
>>> 	Refer:
>>>              https://lore.kernel.org/r/aAL4dT1pWG5dDDeo@google.com
>>>
>>> [...]
>>
>> Applied to kvm-x86 vmx, thanks!
>>
>> [1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
>>        https://github.com/kvm-x86/linux/commit/111a7311a016
> 
> Fixed up to address a docs goof[*], new hash:
> 
>        https://github.com/kvm-x86/linux/commit/e4775f57ad51
> 
> [*] https://lore.kernel.org/all/20250626171004.7a1a024b@canb.auug.org.au

Hi Sean,

I think it's targeted for v6.17, right?

If so, do we need the enumeration for the new TDX ioctl? Yes, the 
userspace could always try and ignore the failure. But since the ship 
has not sailed, I would like to report it and hear your opinion.

