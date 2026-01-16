Return-Path: <kvm+bounces-68387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FD20D3863B
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 20:50:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A59903033F99
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 19:50:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E72D3A1E63;
	Fri, 16 Jan 2026 19:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MnQoWZhE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A13229A9C9;
	Fri, 16 Jan 2026 19:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768593007; cv=none; b=oSjLG5GJ1I+KBdsloe4XawSh9jrVASuDe9PJGT470QXMjVFk1QGipyIBu38CKTTYg/83YK0/ZEZYgYqIQ0RkJshYgEtEPYwY62MPmLiOEhsW43eGoMo7nUN6ziYOhn49ZZpNtoYLem88XTCZTRkINvd3umRHDMAMh41joVqe7EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768593007; c=relaxed/simple;
	bh=SDliI6SbgfaVR36PRPvKO1fNo6q+8jPmc/p3JwD/npw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eRRXUTLKEuX7XsO/aMxYS0XiLnvicF3cudEVhJ1ULNg8m4Oapi7onMyFNZ6ykAnOE14RNlcoAacTHF+Za0px9Ohft8AigV/GwSJloL3kozkSvlNHb3XDBwawZh4GxWS33vIwvemKKg/+dMwMMHY9qctSMk3xvVvAp2vzv37/AhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MnQoWZhE; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768593005; x=1800129005;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SDliI6SbgfaVR36PRPvKO1fNo6q+8jPmc/p3JwD/npw=;
  b=MnQoWZhEav3NvRblFqQ4YE09d5aODgyUpfLoOx5RO9PPvt9quid7CzbQ
   cZZOu3/ZtvEa86827r4yp7pMkrLhLTMTB1qYoBrJhMNkJihKq4Gz/vwpf
   lGIUzS2gKjpSdRs2akg9o9Jdes1qmhB2hl0SzYbsKPmHIV+f8axRr875j
   ZByacZbHDLMoInb+GIeZPPf4KhjVYm5RWGm1LAYUz7Rej0eaWC6L9uiiS
   xH8hqabITWg8h9XzJJ9NxuMlQJsSWE8wBO3Fmu3kb4tg77c6tZ+gC+GT5
   1Fyj4vH4n+IQQFx6L9Mkycj8fHPT3xceplY9N1axk9EHU9hShXEA2T7uI
   w==;
X-CSE-ConnectionGUID: znI0cZSkTrS8+psuDA6xkw==
X-CSE-MsgGUID: kFMrd8a2Tm+rY9NIg9Huiw==
X-IronPort-AV: E=McAfee;i="6800,10657,11673"; a="80551483"
X-IronPort-AV: E=Sophos;i="6.21,232,1763452800"; 
   d="scan'208";a="80551483"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 11:50:05 -0800
X-CSE-ConnectionGUID: 5EWABOIQSF+CRKRCNGqU3A==
X-CSE-MsgGUID: /3hpLGnDSGW7SWb9/+MYmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,232,1763452800"; 
   d="scan'208";a="204939094"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.111.136]) ([10.125.111.136])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 11:49:58 -0800
Message-ID: <d856b68d-3721-4d76-922b-4c98e2eb6c67@intel.com>
Date: Fri, 16 Jan 2026 11:49:53 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 08/22] KVM: VMX: Set FRED MSR intercepts
To: "Xin Li (Intel)" <xin@zytor.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org,
 peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
 hch@infradead.org, sohil.mehta@intel.com
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-9-xin@zytor.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20251026201911.505204-9-xin@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/26/25 13:18, Xin Li (Intel) wrote:
> Both MSR_IA32_FRED_RSP0 and MSR_IA32_FRED_SSP0 (aka MSR_IA32_PL0_SSP)
> are dedicated for userspace event delivery, IOW they are NOT used in
> any kernel event delivery and the execution of ERETS.  Thus KVM can
> run safely with guest values in the two MSRs.  As a result, save and
> restore of their guest values are deferred until vCPU context switch,
> Host MSR_IA32_FRED_RSP0 is restored upon returning to userspace, and
> Host MSR_IA32_PL0_SSP is managed with XRSTORS/XSAVES.

Is it worth making MSR_IA32_FRED_RSP0 special versus MSR_IA32_FRED_RSP[123]?

Is it needed because MSR_IA32_FRED_RSP0 is rewritten all the time as
CPUs switch between threads? But MSR_IA32_FRED_RSP[123] are not
frequently written?

I'd like to hear more about the motivation.

