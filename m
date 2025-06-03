Return-Path: <kvm+bounces-48343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BBF5ACCF68
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 23:54:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 95F3618913F3
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 21:54:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 851C724DD05;
	Tue,  3 Jun 2025 21:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EY7WQ6Ux"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF761C3BEB;
	Tue,  3 Jun 2025 21:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748987647; cv=none; b=JzUJp2/S0UfMPVeXl9JHolXXvyp5A1qB6NNkcAxjSfbqNufK4F8IOnFd3jzshGtyQnzS9LsE4Ukw0lt2vWpUR1vaFb8aWFzkDeJTqP9EBcBR8sUAOFfrSPJh8eDe4lX6Rs32WZ73bLvuiLBzvxJ3XUqHO32vAKs9KzaUGa5VV/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748987647; c=relaxed/simple;
	bh=r3bIn50CZlFg0yKKfQuYn8XClw3UnJCKvqITw9wTRWU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qTAIHEF71ee9OP8K/bLjlc4u8g53KnYmmaDlq3zaC5qG6zPv9iu+xVjKW2K53pg8JWmNnTzK92WIvNoo8evsegubngoi5Uo0XPOVSYMpA504nnw5k5oWj5rch7740RiXldJwd1kROkGfBOOusz8+gFxhX0ZlNSWR29Vn25BKCM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EY7WQ6Ux; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748987647; x=1780523647;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=r3bIn50CZlFg0yKKfQuYn8XClw3UnJCKvqITw9wTRWU=;
  b=EY7WQ6UxllJfZ635kB8k8/Ioz1IP8ZHVvvPUR9KYqut3G/w+T9ezhF9j
   MOfQd8jdYo2DGJH68dWTXo7irblpmfaXmy8Ccy9PbJXUoAzdmLxk2wxHK
   2NmuTrx5f3VM2EhGL4AyZUF9TMIuO3wMzq3HQlB+92+IbJrKJF4L0ffWP
   yxEvjZt2xoWYbUx5DMqqOmbg3Dcx58Q2PP2v8Ei/CYbWHOhb07+bMu3eO
   9YSfty4eaJHRQgYrG+RwHhkFXfOSgMltjJJPUWq9j6xelaqrYVbouV1GX
   CrpbbsW1Axahss0PUFZXzJATzFTel13IYz8pF31SLYYk2VZ1xt3YJm1Wr
   A==;
X-CSE-ConnectionGUID: qNJkiQBsTDuqa4WqFSakcg==
X-CSE-MsgGUID: xfIcJXWWTH6asACVyeniMA==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="61312773"
X-IronPort-AV: E=Sophos;i="6.16,207,1744095600"; 
   d="scan'208";a="61312773"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 14:54:06 -0700
X-CSE-ConnectionGUID: UEci+pVFSu+y+DJb8D1Vqg==
X-CSE-MsgGUID: Z+6iJUqGSZaKwEs2b41ixw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,207,1744095600"; 
   d="scan'208";a="145307933"
Received: from tjmaciei-mobl5.ger.corp.intel.com (HELO [10.125.110.192]) ([10.125.110.192])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 14:54:04 -0700
Message-ID: <58556be3-0516-4204-b19d-11cba7b21423@intel.com>
Date: Tue, 3 Jun 2025 14:54:03 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/9] x86/nmi: Assign and register NMI-source vectors
To: Sohil Mehta <sohil.mehta@intel.com>, x86@kernel.org,
 linux-kernel@vger.kernel.org
Cc: Xin Li <xin@zytor.com>, "H . Peter Anvin" <hpa@zytor.com>,
 Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Sean Christopherson <seanjc@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 Kan Liang <kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
 Zhang Rui <rui.zhang@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
 Andrew Cooper <andrew.cooper3@citrix.com>,
 "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
 Jacob Pan <jacob.pan@linux.microsoft.com>, Andi Kleen <ak@linux.intel.com>,
 Kai Huang <kai.huang@intel.com>, Sandipan Das <sandipan.das@amd.com>,
 linux-perf-users@vger.kernel.org, linux-edac@vger.kernel.org,
 kvm@vger.kernel.org, linux-pm@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <20250513203803.2636561-1-sohil.mehta@intel.com>
 <20250513203803.2636561-5-sohil.mehta@intel.com>
 <e978e1fb-d88e-4789-bd33-367281dfa0ad@intel.com>
 <67683e00-48fa-4aa8-91ff-8726a5374675@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <67683e00-48fa-4aa8-91ff-8726a5374675@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/3/25 13:22, Sohil Mehta wrote:
> With an enum, it's harder to figure out the exact sources when let's say
> the source bitmap is printed as 0x0090.

Uhh, then don't print a bitmap. ;)

/proc/cpuinfo doesn't print out CPUID leaves, it prints out bits mapped
to strings.

Look at the kmalloc trace points:

            Xorg-4589    [003] ..... 1568557.823993: kmalloc: ...
gfp_flags=GFP_KERNEL
            Xorg-4589    [003] ..... 1568557.823993: kmalloc: ...
gfp_flags=GFP_KERNEL

gfp_flags are a bitmap, yet they're mapped out with strings and symbolic
names.

