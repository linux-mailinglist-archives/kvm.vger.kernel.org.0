Return-Path: <kvm+bounces-38537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 92798A3AEFF
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 02:34:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 538E5172ADC
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 01:34:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 498B981724;
	Wed, 19 Feb 2025 01:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kna/X0XG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CEE14F70
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 01:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739928851; cv=none; b=VwA4VvPWtV6S/X6iX4dWoljMFMyAeS/rWnqgE7kfdK7gG4vJnXWDcw7C7yx1zaLP27m4wcfiuB6TKnmlqo+UdYPp2E6KcsPKD0Je7uH/HcL8NN5IiXZdQsuTq24bFESTAq5nEkLR6W8miKD64x8L43tpxR2P7TiB2jVeRVOJvOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739928851; c=relaxed/simple;
	bh=+kzT99sDnGnKSDFvFBmlvdr/GezvThj4SXyakNMPNGs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k/OgIyncsRKno1WD2lqW17tAr95Lce8gcmGulb9gu7kQi+IlYOpWJfcp+LlUjpMMEtehq5wTX4lbonvalLAcpHFLsqGIVk6Tpz4QR6yZNs/d6shYShzDUbbY0goZK6rfBGewRoAm/ATu3MZxehTEKwYBzZ6M4a1cAN4T5SR6XDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kna/X0XG; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739928849; x=1771464849;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+kzT99sDnGnKSDFvFBmlvdr/GezvThj4SXyakNMPNGs=;
  b=kna/X0XGECnEwRWr77SFwTrAu6fyqRhHCDV093jXQWdzCikHEJh3k8FK
   lWWPZve+ityWHXQyK5uNTsDPiod0yvq5HNNHzBBzqEA5claT+sqI42wON
   cO1EC75acyxNS65fewYy2XB8HH87o0uEY2PZ1e3VoCgMvho4jp3bGK7gH
   nGo3uYxyZqRU2wQ4y0O/zXjMXCY3LIBQU0J6zIW4bZFPgotogOMD1Sk4V
   J9r5KXZ71WfOQndNGaAozVrgpaFzjv6s7Fqi6XWfg69g68PMBoyr1vqrY
   thWa9jt9agyxm2MDuuIoQELJsThgGCuvPQ2pAIXOLuNzpjngf6WZ2FJZy
   Q==;
X-CSE-ConnectionGUID: u8dHpnflSmuCMAIqjMoGsw==
X-CSE-MsgGUID: 9L3tGhyWSRua1pe6v9S/BA==
X-IronPort-AV: E=McAfee;i="6700,10204,11348"; a="40906424"
X-IronPort-AV: E=Sophos;i="6.13,296,1732608000"; 
   d="scan'208";a="40906424"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 17:34:09 -0800
X-CSE-ConnectionGUID: 1BnorNp1Q5KzcqmudpjnXw==
X-CSE-MsgGUID: v4rLkhfdSmqtGMnQOlyFYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="119505621"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 17:34:06 -0800
Message-ID: <5a4fd78c-a3aa-41af-bf08-53e2a8b754f2@linux.intel.com>
Date: Wed, 19 Feb 2025 09:34:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v7 04/18] x86: pmu: Align fields in
 pmu_counter_t to better pack the struct
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
 Xiong Zhang <xiong.y.zhang@intel.com>, Mingwei Zhang <mizhang@google.com>
References: <20250215013636.1214612-1-seanjc@google.com>
 <20250215013636.1214612-5-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250215013636.1214612-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 2/15/2025 9:36 AM, Sean Christopherson wrote:
> From: Dapeng Mi <dapeng1.mi@linux.intel.com>
>
> Hoist "idx" up in the pmu_counter_t structure so that the structure is
> naturally packed for 64-bit builds.
>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Link: https://lore.kernel.org/r/20240914101728.33148-5-dapeng1.mi@linux.intel.com
> [sean: rewrite changelog]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Thanks for root causing the issue and rewriting the change log.


> ---
>  x86/pmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/x86/pmu.c b/x86/pmu.c
> index 60db8bdf..a0268db8 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -21,9 +21,9 @@
>  
>  typedef struct {
>  	uint32_t ctr;
> +	uint32_t idx;
>  	uint64_t config;
>  	uint64_t count;
> -	int idx;
>  } pmu_counter_t;
>  
>  struct pmu_event {

