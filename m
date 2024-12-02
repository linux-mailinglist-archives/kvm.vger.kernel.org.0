Return-Path: <kvm+bounces-32840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B60C99E0AF0
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 19:26:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76872163630
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 18:26:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 198261DDC3D;
	Mon,  2 Dec 2024 18:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k7E+WB7A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E1F70814;
	Mon,  2 Dec 2024 18:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733163962; cv=none; b=WRPAOeBDD0Q6mZFEfKgdSQCH/UWfTU4bnJ4/d53GLz5FhRTu6Q6OLYfeJFmCIPZGtKrAsnj6t8OfK4GtkEW9tktMZnZcPQx9qhzJHh/7ttFkIm3Lzxc+dte3EuboajD1+VAUx79O3UBj8ud0HNkAlvk9Srgou51T9myBD1BWNSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733163962; c=relaxed/simple;
	bh=H5AO8MJt0ELX49wvaVQzSbNB9d8/9j/vhIEEO4OHk+s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OeapRQsPP4TlG6MwC6LXBaf8Aay+LAjuEq7FVVFJ38fbpCrzvpxQwPbpdukp9QpiUSLqg8G41WZrLwedUHoKMrcQl71yAGYC73W9G3v8DycR17McMiarTA/ygZbph5TJvHHT2GC3oovC5PB76OCdFNWQ50MGwiFe4U/tdJA9QJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k7E+WB7A; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733163960; x=1764699960;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=H5AO8MJt0ELX49wvaVQzSbNB9d8/9j/vhIEEO4OHk+s=;
  b=k7E+WB7AASdDtp9LP1K5eiCKuCUDq1Xxe2bGtMW8BT84i8rnvoWaIVc2
   y2Xum9Ii/Onew57qrdVLI8GoX+WlSXbD8ikvhrN5qQAMbAQRa6NQGE3tQ
   0R98PVHAh1S/Oapr42P3lPqRxgoSqgBHVvgg/hcBZQIHCWCufn+pusdug
   Et/xnlzpnmIksanVVsHzG+rbpV2mICiHTz3nNpMt1pE9d6og13PdcAfro
   ISkYMVeuUhH2BM2HmGKLJgdOSLsIKvcvM8DXA4+VS56+tKOhYwhEQ8KuY
   nOU0vMgJ6znrqTFxKQFyB7wcmHOTNFfNCswXZDweRDrFG2dy0mqjFQyOY
   g==;
X-CSE-ConnectionGUID: L3BSsrluST+OEyQIGuL8rw==
X-CSE-MsgGUID: 3FoUr5XUStmNlaiL1yveFA==
X-IronPort-AV: E=McAfee;i="6700,10204,11274"; a="50871680"
X-IronPort-AV: E=Sophos;i="6.12,203,1728975600"; 
   d="scan'208";a="50871680"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2024 10:26:00 -0800
X-CSE-ConnectionGUID: MQn1YLgeQiK/g8AaLUe66w==
X-CSE-MsgGUID: C70GX1lbQ6igtxoNI2bmPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,203,1728975600"; 
   d="scan'208";a="92841382"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO [10.124.222.246]) ([10.124.222.246])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2024 10:25:58 -0800
Message-ID: <0dd91e39-c4b7-4740-b469-6f71e48b72de@intel.com>
Date: Mon, 2 Dec 2024 10:25:57 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 1/2] x86: cpu/bugs: add AMD ERAPS support; hardware
 flushes RSB
To: Amit Shah <amit@kernel.org>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org, linux-doc@vger.kernel.org
Cc: thomas.lendacky@amd.com, bp@alien8.de, tglx@linutronix.de,
 peterz@infradead.org, jpoimboe@kernel.org,
 pawan.kumar.gupta@linux.intel.com, corbet@lwn.net, mingo@redhat.com,
 dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
 pbonzini@redhat.com, daniel.sneddon@linux.intel.com, kai.huang@intel.com,
 sandipan.das@amd.com, boris.ostrovsky@oracle.com, Babu.Moger@amd.com,
 david.kaplan@amd.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com,
 Amit Shah <Amit.Shah@amd.com>
References: <cover.1732219175.git.jpoimboe@kernel.org>
 <20241128132834.15126-1-amit@kernel.org>
 <20241128132834.15126-2-amit@kernel.org>
 <7222b969-30a8-42de-b2ca-601f6d1b03cd@intel.com>
 <4601ca077c95393837eb40909c941a4d67bb04dd.camel@kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <4601ca077c95393837eb40909c941a4d67bb04dd.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/2/24 10:09, Amit Shah wrote:
> I can still include the summary of the discussion in this patch - I
> just feel it isn't necessary with the rework.

It's necessary.

There's a new hardware feature. You want it to replace a software
sequence in certain situations. You have to make an actual, coherent
argument argument as to why the hardware feature is a suitable replacement.

For instance (and I'm pretty sure we've gone over this more than once),
the changelog here still makes the claim that a "context switch" and a
"mov-to-CR3" are the same thing.

