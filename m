Return-Path: <kvm+bounces-44240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DA7AA9BBB0
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 02:17:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4CD637A9E15
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 00:16:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36B664A0C;
	Fri, 25 Apr 2025 00:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HAwHIjtn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5902382;
	Fri, 25 Apr 2025 00:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745540264; cv=none; b=Ue3zQ+AUAStcHEN2Jz9KxC6nO+8tuXc/t/3OP5Zwgxe1ES7tr8bM3oun+5GphKY1G5btFeASClihl/ezEp7vHJhKs7PRJIEysSw1QoBqfi/f92LL4RTbK0uQZQgIhMIro8JvIhS8phlJHkzoO7f9iSAqAy67gyi9ctt2tuP8RlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745540264; c=relaxed/simple;
	bh=hBejx/ayd+GyQ+0SkZMatW7XvWQxt2+ga5tDFrKq55Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nWxeJIN6FQgG2b2wrnTMBfp/IU/xGiKo/lADDGOm324jEkIOMnIWWna8lw+LkdfOlEEfO9F0cmKjOq+0yqdMaGSf5e2ePjKUqCwHJK1jG8znImCnmpv8BSRG1Kl/Qlble+OoVWnLG4NuFmmmKG0RWNNzk2qA0IBCgEiHl4IyGDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HAwHIjtn; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745540263; x=1777076263;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hBejx/ayd+GyQ+0SkZMatW7XvWQxt2+ga5tDFrKq55Q=;
  b=HAwHIjtnoEEeyygPoH0U0vRrxpIYdr0PVVLMu3BiSUl5pTYfwi9Fm3gY
   5Ri2hC8lPkb9ta8jCrZuSbrQRfMWO4geG89NDqAHSEDVznn+tmRapAopm
   UggXO1XFbD6MbWhycsEIskZyXV37fAn5s4pWwZ1dpokcof8CjSZWTlUe+
   JA5Z8HfB4BWdhe33kjsekJ6EbmWWw0YkZEq5HlNvasgSHZxm0SqlD0MFO
   76VXX+az7iQvSBH7CMAY4A+29J8K/OQhyR8qHT5FysRBOWTOffHeoEwph
   7o5WyzK/sTrcxtfKyP/wHMblclhYwfHetjd/2x7AXhmrkfX21DYmFng6i
   g==;
X-CSE-ConnectionGUID: +iYAUrizRo+tboUd3xdLNA==
X-CSE-MsgGUID: 6McV+jX2QRGI8mPVZTyzFA==
X-IronPort-AV: E=McAfee;i="6700,10204,11413"; a="64612561"
X-IronPort-AV: E=Sophos;i="6.15,237,1739865600"; 
   d="scan'208";a="64612561"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 17:17:41 -0700
X-CSE-ConnectionGUID: PJfJ+tfnQl+P6lFjPBpldQ==
X-CSE-MsgGUID: 26kbLsDHTNGSalFA9BBFUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,237,1739865600"; 
   d="scan'208";a="163815423"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 17:17:38 -0700
Message-ID: <1fd8dd31-faf4-4657-ab06-ccba3e790d01@linux.intel.com>
Date: Fri, 25 Apr 2025 08:17:34 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: kvm guests crash when running "perf kvm top"
To: Sean Christopherson <seanjc@google.com>
Cc: Seth Forshee <sforshee@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
 linux-perf-users@vger.kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <Z_VUswFkWiTYI0eD@do-x1carbon>
 <27175b8e-144d-42cb-b149-04031e9aa698@linux.intel.com>
 <aAo445Nzi5DuAQAR@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <aAo445Nzi5DuAQAR@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 4/24/2025 9:13 PM, Sean Christopherson wrote:
> On Thu, Apr 24, 2025, Dapeng Mi wrote:
>> Is the command "perf kvm top" executed in host or guest when you see guest
>> crash? Is it easy to be reproduced? Could you please provide the detailed
>> steps to reproduce the issue with 6.15-rc1 kernel?
> Host.  I already have a fix, I'll get it posted today.
>
> https://lore.kernel.org/all/Z_aovIbwdKIIBMuq@google.com

Thumbs up! Glad to see it has been root caused. Thanks.



