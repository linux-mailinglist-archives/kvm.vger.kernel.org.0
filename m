Return-Path: <kvm+bounces-48718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BC6DAD188A
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 08:22:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B9BAD1889732
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 06:22:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC2EB27FB16;
	Mon,  9 Jun 2025 06:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="epwYzFII"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C46616EB42
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 06:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749450148; cv=none; b=PkdRIsyowy98UVCWoPt6S78C2AYVTF2cwyXgGlgHe0LnVrr6pu94//fC/50vSmouVoPlPQX8oKY7AHzdga9cie6btzL58UA9nHOBGhvMHACGlxB84ZbueOzGd8Fsj5lx1rsI4Xr6/G84QfYRmclQjVKJci3Mgk78FzOj0hnOHHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749450148; c=relaxed/simple;
	bh=F0j4QZJ2agjYoXCHQslgBtBSUnP57/L8vGrvTYzTcso=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tNxO/RA/+noGgNQbvYVy2jc6z9OXrlk0ehJ7v9sBnyUOUtQNAaJIOppl3ibz7su1CewPP9DLX+f5KckTqDSFHPbNxHQZrqBaN6cvOAfmQfWMc5yzIH/3NpE1Xfenwh9FP4w0KC63uGSlF0hA57gLce9t0OFbqxzbMo0YSTq2OeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=epwYzFII; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749450146; x=1780986146;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=F0j4QZJ2agjYoXCHQslgBtBSUnP57/L8vGrvTYzTcso=;
  b=epwYzFIIJQUl/4BWo+ZlTfHtgQyrPLuMFHWFfaQkjfAelNRYDWzUkJgl
   cvzdb0Be9Nl+SFbf4mPrmZ8BePt2Xiz/uJC/CZGRknCTyuAhJdeZfcXiW
   1cfCWFi4HU14hDhbRNrfCmH2+r1ab2wMKAWE2vQN/WUqfnaK5AFPhRc7N
   n3fWcEmNZZNXWuc+sj0QGkvElMtEbElUpsf9yAbcNDRZWPHaWdZwjR1ap
   Rw6sorDb5yC6YMzIxPzr1i2OZs+gYwrOvYQ8d5AYdCV0sYlCvtV/Ny+40
   uQGZI0Grs9stoRPmK4WJfESar093+Z8K39puVsPmLN/IeNbuPvgQLjKys
   w==;
X-CSE-ConnectionGUID: BmIT4e66RoGVJ8D0dzKJ3Q==
X-CSE-MsgGUID: 2J7bKe2LSm+DfVKynjv19g==
X-IronPort-AV: E=McAfee;i="6800,10657,11458"; a="62168193"
X-IronPort-AV: E=Sophos;i="6.16,221,1744095600"; 
   d="scan'208";a="62168193"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2025 23:22:21 -0700
X-CSE-ConnectionGUID: goCBc2jYSROKWSC68BrEJw==
X-CSE-MsgGUID: oIW4oqS6Q46hBYSppit7YQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,221,1744095600"; 
   d="scan'208";a="183608136"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.144]) ([10.124.245.144])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2025 23:22:15 -0700
Message-ID: <937c0e55-d2c4-44c1-9142-30cdb21c4f01@linux.intel.com>
Date: Mon, 9 Jun 2025 14:22:10 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 5/8] x86: nVMX: Use set_bit() instead of
 test_and_set_bit() when return is ignored
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
References: <20250605192226.532654-1-seanjc@google.com>
 <20250605192226.532654-6-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250605192226.532654-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/6/2025 3:22 AM, Sean Christopherson wrote:
> Use set_bit() in vmx_posted_interrupts_test_worker(), as the usage doesn't
> actually look at the original value.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  x86/vmx_tests.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 2f178227..53706000 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -11122,8 +11122,8 @@ static void vmx_posted_interrupts_test_worker(void *data)
>  	while (!args->in_guest)
>  		pause();
>  
> -	test_and_set_bit(args->nr, args->pi_desc);
> -	test_and_set_bit(256, args->pi_desc);
> +	set_bit(args->nr, args->pi_desc);
> +	set_bit(256, args->pi_desc);
>  	apic_icr_write(PI_VECTOR, args->dest);
>  }
>  

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



