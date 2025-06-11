Return-Path: <kvm+bounces-48944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E50AAD4831
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 03:48:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 90148189F288
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:48:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4753719EEBF;
	Wed, 11 Jun 2025 01:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="axUAmMAk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7330190696;
	Wed, 11 Jun 2025 01:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749606430; cv=none; b=OTUlcPL9WVZxV3gESmiVLzBnIQ0Tgxp/KWmDyFyC1raNoNUdTjO5rh6Sn+ePqZCdXsnqPRVVgxCpeJyrTkqcoeQWeAiq2wMdhEXnXOlL9of2itCfe+A8/4LhVH6dWycMvoKLUlDSu3z5AZiqk0FFPCxfRYtvuC/NaitK3xNYBrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749606430; c=relaxed/simple;
	bh=Vz3tyYbLL715NajQX5ascY0JphbQ9TleSKtDEjg0kIE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FgT6bdBEOIb5KjbHKJtjqenykiUaNt2DsCi0ZIk6uMialc+XSNnKFRWDNlYZep+S43aSlI6NIYVRNgwL3bLbhVBhR6KmruscwEf4EH+VwUkSHkIU05sALts1XoJu5iTnOzxiV+YNdRVWWiJ0DZFO9OVa4ct2H1EJ3EYU2juI7AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=axUAmMAk; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749606429; x=1781142429;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Vz3tyYbLL715NajQX5ascY0JphbQ9TleSKtDEjg0kIE=;
  b=axUAmMAkbMKs4VW7nZVrjFmXRm57yXfGAwUTb93WfU0GOzRR+sLdcfQx
   dBadiQil8S7kunDcS2LV/vMMR1/7WNhEdS6B0e8LyXJyv8SnkXt9WGY0p
   FTZBhtmX9Wo3cWIEj34/YwKtOqkfJCn2lhSsOfgKT6i44nlr5Bme/Hjht
   rkBqmDLFU73R6J7jZ03A0RAhjPyt4WO8t8DiAIuFjZPG0hm6R7A/vCW5J
   W23UJ/o5B5oCliXktDZWGQxiJ90h+uoTEXw6WyFsk+KWZA7BMLpr2rSYW
   X89Fu6QmpQPtV5GXKi7WKHbMznOqlI2GBAc16Wp6p8TG39/cwLFZ3fiIj
   g==;
X-CSE-ConnectionGUID: S59wtTKNS2OsaPQNJtKn5A==
X-CSE-MsgGUID: mys51MRNR8qVSlOxUFN3HA==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="62389632"
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="62389632"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 18:47:08 -0700
X-CSE-ConnectionGUID: 6gwus4kvSGacmOojacMNRw==
X-CSE-MsgGUID: VU9FL7jQRqS5iyaLT+Db2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="177952016"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.144]) ([10.124.245.144])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 18:47:06 -0700
Message-ID: <2e32978a-25c4-45a9-bdff-3097bb3abcdd@linux.intel.com>
Date: Wed, 11 Jun 2025 09:47:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] KVM: selftests: Test behavior of
 KVM_X86_DISABLE_EXITS_APERFMPERF
To: Jim Mattson <jmattson@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20250530185239.2335185-1-jmattson@google.com>
 <20250530185239.2335185-4-jmattson@google.com>
 <574f8adc-6aea-4460-9211-685091a30f5e@linux.intel.com>
 <CALMp9eSS09bzdUs2JPnaQKM6ALWjxJNqWTsNYM5LOnSJjyRanQ@mail.gmail.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <CALMp9eSS09bzdUs2JPnaQKM6ALWjxJNqWTsNYM5LOnSJjyRanQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 6/11/2025 12:59 AM, Jim Mattson wrote:
> On Tue, Jun 10, 2025 at 1:42 AM Mi, Dapeng <dapeng1.mi@linux.intel.com> wrote:
>>
>> On 5/31/2025 2:52 AM, Jim Mattson wrote:
>>> For a VCPU thread pinned to a single LPU, verify that interleaved host
>>> and guest reads of IA32_[AM]PERF return strictly increasing values when
>>> APERFMPERF exiting is disabled.
>> Should we consider the possible overflow case of these 2 MSRs although it
>> could be extremely rare? Thanks.
> Unless someone moves the MSRs forward, at current frequencies, the
> machine will have to be up for more than 100 years. I'll be long dead
> by then.

😂


>
> Note that frequency invariant scheduling doesn't accommodate overflow
> either. If the MSRs overflow, frequency invariant scheduling is
> disabled.
Agree.



