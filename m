Return-Path: <kvm+bounces-58447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CD5C5B94298
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 05:59:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D6BD318A6E87
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 03:59:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE9B526F2BE;
	Tue, 23 Sep 2025 03:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IXVptUzE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A66D1B040B;
	Tue, 23 Sep 2025 03:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758599942; cv=none; b=UJyEyLLTc8ESf1W8UvVdQpqEmbKzMSkzUERQQEfhbcMxQFR1T0IjciwhE9Goqvck21g051369spPwZJWX0I8qh0hQH1namS7/zv+Ed1pPbgaEWAtI5EmYsO7AGnMcg0eoR8l8QyeYZKxKleAv2yWtRwP3tXD9Pp+HQD4RCTmNX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758599942; c=relaxed/simple;
	bh=pA57IBzvDw/balxYWpPYDXyB2BeYxA6lGokFTJCmhbw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pcBPuKC5lSQ8Y0+TO29zG9amxdcsLJ6c3wCLVoZk9QL+t57aiQIEcT5FAvc6uuDbhQoGrGN2au+SFtpqbkmlGspdC6RrMM7ldznM4SE2zPuCCAUmmp7tehofknsz1F9ZXcw5QHeUR5PuXA4FDa3fI6j13pObdvIHmjC9eiuykiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IXVptUzE; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758599940; x=1790135940;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pA57IBzvDw/balxYWpPYDXyB2BeYxA6lGokFTJCmhbw=;
  b=IXVptUzEyHw6Rs8Avm++1L77vGBflo4EysLD0WLqLO1MTxyZMjbwfaGY
   Nl7ChXg/3VTzexLhIu4ju1snXCjTFZ/UrJYw8AIW39Gh9Vjt4yR4kHEz7
   uS3ujEGAXs5qNnuBNbakkBxITHW5rcp/0PxBpXazcn+JGudh9/I0fI255
   SMpC0e+Dp8pwZSRuYvVF8sTutP4tYu+Ch+yvGz5zjyiTu04onGOZvv5WZ
   aBDNboZwd1XLdaL4relCnMv2LOWmGfbxRZnmt7njY9llAz1D+EmCXgqtR
   ShU4y0urG24+Djri958r59M7NpyE05SAYGxhFPze81jh1DUOZxSchKiZz
   g==;
X-CSE-ConnectionGUID: K/fD0biTQG+BQT5ehCYSyQ==
X-CSE-MsgGUID: RgLmVzZLQS6JMAqOG0ambw==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="60760060"
X-IronPort-AV: E=Sophos;i="6.18,286,1751266800"; 
   d="scan'208";a="60760060"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 20:59:00 -0700
X-CSE-ConnectionGUID: mR1wRD7/SCKJRQ2OddijQA==
X-CSE-MsgGUID: jfLdrXLIQPCwjrHzpAriiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,286,1751266800"; 
   d="scan'208";a="176234743"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 20:58:59 -0700
Message-ID: <064c1240-e7f0-4061-a43a-9d05a46953a0@intel.com>
Date: Tue, 23 Sep 2025 11:58:55 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] KVM: x86: Add helper to retrieve current value of
 user return MSR
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hou Wenlong <houwenlong.hwl@antgroup.com>,
 Lai Jiangshan <jiangshan.ljs@antgroup.com>
References: <20250919213806.1582673-1-seanjc@google.com>
 <20250919213806.1582673-2-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250919213806.1582673-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/20/2025 5:38 AM, Sean Christopherson wrote:
> From: Hou Wenlong <houwenlong.hwl@antgroup.com>
> 
> In the user return MSR support, the cached value is always the hardware
> value of the specific MSR. Therefore, add a helper to retrieve the
> cached value, which can replace the need for RDMSR, for example, to
> allow SEV-ES guests to restore the correct host hardware value without
> using RDMSR.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> [sean: drop "cache" from the name, make it a one-liner, tag for stable]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

