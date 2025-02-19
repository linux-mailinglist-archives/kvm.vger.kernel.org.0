Return-Path: <kvm+bounces-38558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 14411A3BA4B
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 10:41:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A7DAE4218FF
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 09:35:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B41561E98F4;
	Wed, 19 Feb 2025 09:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NR2wALds"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD081DEFCC
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 09:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957512; cv=none; b=kcyx0PS/Z6mJs5tPykxyIBXr9Y7GUfWetcGWJFKf1SLz2NHLKlJqXX10o85pIijQFmkUY3L6FHwlQNKkTRLP5wJdq8iCdEboSoFQ+uJyzoJaUOZDCHQIz9zy/iLh1iyLRMIsL9OGy1GRteTKGfWhMwu3s6SEbSaY+LGH2i8mO8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957512; c=relaxed/simple;
	bh=O1nZ6znw2pfB0Q6xofGAKzsm9No5q8rzOly25kVSfpk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WlI3dWSRat+I31BwX49Vt76g6Ig0kzqhA0iyjixWJNeUQHpRhyatK6/j0YKohDZ2vdA2r2lsYHafaAkGHd9X0ma3hb5gRqiiml6jBcNXzSoSKqf0UAgGfjjxpyNX4RRcX91GYhfZ/pGvJyPS8PTofpzA4WF7Sc9V0VmSzx262EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NR2wALds; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739957512; x=1771493512;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=O1nZ6znw2pfB0Q6xofGAKzsm9No5q8rzOly25kVSfpk=;
  b=NR2wALdsZE1x6l1y2SF2itF4w2QnzJ3hA3nVY7Qh+rS25wbdQKoM5+MO
   M9VcZUyH2sXmxqYfwq2jrYMWZ6jeZUHGJtePi6wsXmqYIgvIBRufwuqYN
   8yCotZuaRjEOerH8FSyZnN0egjVJv0rg7EKfyFBpD8tAqxG+/nACLloR3
   QP5scoOcST7nA/0oQ6P/+xfrVjfw22kC2A/xJ2inLdH686XDM7G+wZ5Yr
   dYjWbf2+owqHkMnL/fksaW0c1NDF3QfqbOFC4TCsn4s0+CIEVa1zUhJnW
   sly5wGfdStJ+iCv+INaa83AFOpE0GMm3n8vhONkLjT9n+Io6bxk5px/Uv
   A==;
X-CSE-ConnectionGUID: E/Vab0N7RCyjbbWluNyfwQ==
X-CSE-MsgGUID: VJyTM1bxTBaoGjI9YQDrXg==
X-IronPort-AV: E=McAfee;i="6700,10204,11348"; a="58091470"
X-IronPort-AV: E=Sophos;i="6.13,298,1732608000"; 
   d="scan'208";a="58091470"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2025 01:31:51 -0800
X-CSE-ConnectionGUID: MjV/xQvtS9qPRNuxOobxWQ==
X-CSE-MsgGUID: lMqxebZrRkmE2kL1TXsecw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="119600407"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2025 01:31:48 -0800
Message-ID: <586414bd-0b9e-4750-8bbc-b617c59d4fbd@linux.intel.com>
Date: Wed, 19 Feb 2025 17:31:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v7 00/18] x86/pmu: Fixes and improvements
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
 Xiong Zhang <xiong.y.zhang@intel.com>, Mingwei Zhang <mizhang@google.com>
References: <20250215013636.1214612-1-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250215013636.1214612-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Test this patch series on Sapphire Rapids and Granite Rapids against
perf-based vPMU and  mediated vPMU. No failure is found. Thanks.


On 2/15/2025 9:36 AM, Sean Christopherson wrote:
> v7 of Dapeng's PMU fixes/cleanups series.  FWIW, I haven't gone through the
> changes all that carefully, I mostly focused on the high level "what" and the
> style.
>
> This blows up without the per-CPU fixes:
> https://lore.kernel.org/all/20250215012032.1206409-1-seanjc@google.com
>
> v7:
>  - Rewrite the changelog for the patch that shrinks the size of pmu_counter_t.
>  - Cosmetic changes.
>
> v6: https://lore.kernel.org/all/20240914101728.33148-1-dapeng1.mi@linux.intel.com
>
> Dapeng Mi (17):
>   x86: pmu: Remove blank line and redundant space
>   x86: pmu: Refine fixed_events[] names
>   x86: pmu: Align fields in pmu_counter_t to better pack the struct
>   x86: pmu: Enlarge cnt[] length to 48 in check_counters_many()
>   x86: pmu: Print measured event count if test fails
>   x86: pmu: Fix potential out of bound access for fixed events
>   x86: pmu: Fix cycles event validation failure
>   x86: pmu: Use macro to replace hard-coded branches event index
>   x86: pmu: Use macro to replace hard-coded ref-cycles event index
>   x86: pmu: Use macro to replace hard-coded instructions event index
>   x86: pmu: Enable and disable PMCs in loop() asm blob
>   x86: pmu: Improve instruction and branches events verification
>   x86: pmu: Improve LLC misses event verification
>   x86: pmu: Adjust lower boundary of llc-misses event to 0 for legacy
>     CPUs
>   x86: pmu: Add IBPB indirect jump asm blob
>   x86: pmu: Adjust lower boundary of branch-misses event
>   x86: pmu: Optimize emulated instruction validation
>
> Xiong Zhang (1):
>   x86: pmu: Remove duplicate code in pmu_init()
>
>  lib/x86/pmu.c |   5 -
>  x86/pmu.c     | 423 ++++++++++++++++++++++++++++++++++++++++----------
>  2 files changed, 342 insertions(+), 86 deletions(-)
>
>
> base-commit: f77fb696cfd0e4a5562cdca189be557946bf522f

