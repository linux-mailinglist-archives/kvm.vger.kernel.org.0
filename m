Return-Path: <kvm+bounces-57001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B8624B499A2
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 21:18:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 898521B25BB0
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 19:18:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 642E3246BCD;
	Mon,  8 Sep 2025 19:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fOlCq/hE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB1224677C;
	Mon,  8 Sep 2025 19:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757359081; cv=none; b=fEpuPayresNEjK8C24+kqZXIXXXrxZ8eJqaEoCxQbLNfTkpjHJBE6VatZVhtDMT4eg/BoyBl/z350SVz6URR6PlKpCKRQ+EWzYEBTY3v/UPHHUtJJ+lH25O7PJgUOD4jb13i3zhBW4QbPXKVWHsCt28CyueY9IHCA6nEH5SHo5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757359081; c=relaxed/simple;
	bh=9rFFDMf3SWKzaCoynfRVl2SzES0dgcHDJteqfi7/pFs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ovaUZOPcAJOWT15xB0eh8rToC/sUbTfTLfCPWgtiwwbpHPFTaYuIH3mhELtMc0GJRLI7L19t35TB8AMIbP1dSMGbI9Ldihy3kn9eAw+jgHjJ7qBvrDibezNeWwDE2xyvLsEBUIkiDBj4bEJMjosVnPkDMoXrVNQpaIGlsyJSL1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fOlCq/hE; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757359080; x=1788895080;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9rFFDMf3SWKzaCoynfRVl2SzES0dgcHDJteqfi7/pFs=;
  b=fOlCq/hEVI01W2/1WxZNd7dSMLsLaWs49w/iESFfqOVqgEYEJbn4XGuU
   g+rLnNqMdjKB42zA5OYdtG55ccQYjUKWH/YnqGJCjYq8JPp7vdNH76Lve
   SjjB6xhzB6gHzTza//Fbg7k+2o1pxGaL4FOC6LPl2WKOhsPPKBGzGT96V
   9Zh2RlxRJDb++y/XTXMiZDgvJcgECvEnY6k5r6mRfyY11ufjfbkgrji88
   pvjrpQVLiv++I954HThLLhk0a011+cdAWPwfOFgDZ8fNWPl4pk50yMHxW
   A+N4S4tujn5cWoAKBc91VP+H/35YLrWGnZaH5OuqeCzWX4w/aOtNZCsn0
   g==;
X-CSE-ConnectionGUID: baGHhDojR42CYg8nXXafFQ==
X-CSE-MsgGUID: DLc5ZGTVSYew21R5rpfSNg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="59695631"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="59695631"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2025 12:18:00 -0700
X-CSE-ConnectionGUID: ji+GsGFOScerA06nfEgEMQ==
X-CSE-MsgGUID: 9StBceinRn2gOqJ7EYj8GA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,249,1751266800"; 
   d="scan'208";a="173007504"
Received: from msatwood-mobl.amr.corp.intel.com (HELO [10.125.110.105]) ([10.125.110.105])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2025 12:17:59 -0700
Message-ID: <2537ad07-6e49-401b-9ffa-63a07740db4a@intel.com>
Date: Mon, 8 Sep 2025 12:17:58 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 pbonzini@redhat.com, seanjc@google.com, dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com, isaku.yamahata@intel.com,
 kai.huang@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, kvm@vger.kernel.org,
 x86@kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/9/25 12:13, Kirill A. Shutemov wrote:
> The exact size of the required PAMT memory is determined by the TDX
> module and may vary between TDX module versions, but currently it is
> approximately 0.4% of the system memory. This is a significant
> commitment, especially if it is not known upfront whether the machine
> will run any TDX guests.
> 
> The Dynamic PAMT feature reduces static PAMT allocations. PAMT_1G and
> PAMT_2M levels are still allocated on TDX module initialization, but the
> PAMT_4K level is allocated dynamically, reducing static allocations to
> approximately 0.004% of the system memory.

I'm beginning to think that this series is barking up the wrong tree.

>  18 files changed, 702 insertions(+), 108 deletions(-)

I totally agree that saving 0.4% of memory on a gagillion systems saves
a gagillion dollars.

But this series seems to be marching down the path that the savings
needs to be down at page granularity: If a 2M page doesn't need PAMT
then it strictly shouldn't have any PAMT. While that's certainly a
high-utiltiy tact, I can't help but think it may be over complicated.

What if we just focused on three states:

1. System boots, has no DPAMT.
2. First TD starts up, all DPAMT gets allocated
3. Last TD shuts down, all DPAMT gets freed

The cases that leaves behind are when the system has a small number of
TDs packed into a relatively small number of 2M pages. That occurs
either because they're backing with real huge pages or that they are
backed with 4k and nicely compacted because memory wasn't fragmented.

I know our uberscaler buddies are quite fond of those cases and want to
minimize memory use. But are you folks really going to have that many
systems which deploy a very small number of small TDs?

In other words, can we simplify this? Or at least _start_ simpler with v1?

