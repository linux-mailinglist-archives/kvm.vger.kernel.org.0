Return-Path: <kvm+bounces-68105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 35589D21EFF
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 02:08:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5F1E93038F4D
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 01:08:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 867AC20E31C;
	Thu, 15 Jan 2026 01:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bm+6sK7A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9A1F9D9
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 01:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768439326; cv=none; b=RtTJjmm89leqr3pLT3bWy4uj8vKwwptdR+xPKpN2ntZpunPHZ6tuJehsSz8MBUpm1Evtr/zdyokkFgx1RA5fSdnfsFRiXqypZxrFQe6d53C4UEICdOd7l2G87d50tFWgFSt2jkoLJ7MXXH/0VXrl7E76exzHSJwR0CTmc4kpdwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768439326; c=relaxed/simple;
	bh=o5PtTJSEvpJXGgpc3pmgatc+2Pd70u0mxVJPqcWDYg0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SGzXpbJ0ielVBA34sJx2Xdbdp5r5giy9XXr3JC5jh8Y44O0ABbIpfMUvQwdG+7Bstff1QWc/aHluQqewQ2jZO3Y0KSdnUM79wM5+aFDAr0jF1QedF4ZPbzY1WmoNulkuj/PfDTkgIPWsrf4ef8x7qK1/SYpGbiCImMdXNlob110=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bm+6sK7A; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768439326; x=1799975326;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=o5PtTJSEvpJXGgpc3pmgatc+2Pd70u0mxVJPqcWDYg0=;
  b=bm+6sK7AJ/dTn6AhoubeVXMk9ufsOm/cjtR0vQhrSwaAnBgaPBp9f/dz
   1j9tNotPx+uP6iNoGjOMb4brkxA1GdbkntHIvs/ChIwfIl1lEqB66DGEV
   JQLBHdWoLDLRTZQGBkm3f4nPP1zfmDb8M7sQxbICDLQsMF/YqqTA1pcic
   DSpCr0pzVgbzCf3xsmLtceUK1cScgx4pc6opYXMKgHMAkOagn32mIEPLB
   z/UtXHtA1s7Vst3ugY13BRLVT6s6t1wNXBjDgaQ3dHbQGvmVMOfONcS6h
   RV7BhBZv3C0Ye7nwpk7DIbN2nyHFKbDHfV9aAWSg85GtBAdEaxzxKMK64
   Q==;
X-CSE-ConnectionGUID: w3Kb92w6TyiG2wRyYpWmNQ==
X-CSE-MsgGUID: vbDOxdUVQ3ieWG99A1b6ag==
X-IronPort-AV: E=McAfee;i="6800,10657,11671"; a="69481493"
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="69481493"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 17:08:46 -0800
X-CSE-ConnectionGUID: DN03NiI6SR2irFYJoMqVTA==
X-CSE-MsgGUID: ROvRXqaKQb2PITBLC98dGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="204614704"
Received: from fhuang-mobl1.amr.corp.intel.com (HELO [10.125.38.93]) ([10.125.38.93])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 17:08:45 -0800
Message-ID: <c952b8d7-d1f9-44cc-812d-1a6600b26709@intel.com>
Date: Wed, 14 Jan 2026 17:08:44 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/5] target/i386/kvm: extract unrelated code out of
 kvm_x86_build_cpuid()
To: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
 sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
 like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
 alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
 davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
 dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai-oc@zhaoxin.com,
 ewanhai@zhaoxin.com
References: <20260109075508.113097-1-dongli.zhang@oracle.com>
 <20260109075508.113097-3-dongli.zhang@oracle.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <20260109075508.113097-3-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/8/2026 11:53 PM, Dongli Zhang wrote:
> The initialization of 'has_architectural_pmu_version',
> 'num_architectural_pmu_gp_counters', and
> 'num_architectural_pmu_fixed_counters' is unrelated to the process of
> building the CPUID.
> 
> Extract them out of kvm_x86_build_cpuid().
> 
> In addition, use cpuid_find_entry() instead of cpu_x86_cpuid(), because
> CPUID has already been filled at this stage.
> 
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---

LGTM.
Reviewed-by: Zide Chen <zide.chen@intel.com>



