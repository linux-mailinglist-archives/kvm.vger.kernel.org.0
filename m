Return-Path: <kvm+bounces-57670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 561F7B58DD9
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 07:22:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFDA15238AA
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 05:22:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A70BE27FD59;
	Tue, 16 Sep 2025 05:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hUcl4Fz4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17640EACE;
	Tue, 16 Sep 2025 05:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758000143; cv=none; b=PSi0R1rekPQnIyBPGzRcfpyYjGxwS2u/yXJLyG6Z0Lvqoe78oBNjD+0RLP4SihWFqIvtnFeOCQI9aw7J5bAsvYQ/40FIaASWtXN5co8DKWCG8zYl3cvO5Hu75FALGdRExjYiJVVMt4xWWMla3mVldcvPWZR7ir+CwIu4OdwIROA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758000143; c=relaxed/simple;
	bh=tnoyNmAeyWG5O/mupRCJv7jZbAmNdMTcaRPwFreUPuY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mj4Fi192KDhDRvd2jHpA4KcZ9O2N4RQku4nRBoXPWOUynGzsVFINBbjXGTfWLQXFac9yAJKcNGxtQpP4VPLfX6LdLfDbbOqNpio4YkPBZi9t+bz0UhVzP6EmZ4nqCwxS4TyhCY7s1WJyzMg/1TV3ZR76ITD+qxdQVPkMzRHcp94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hUcl4Fz4; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758000142; x=1789536142;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tnoyNmAeyWG5O/mupRCJv7jZbAmNdMTcaRPwFreUPuY=;
  b=hUcl4Fz4XBlH7PabjXH2nWOAwZPRYk4HgclnNRh0B7+8n1CvjcAunygh
   XGXw548tDBoZa/oAtR665uTc2nWkwxkD+wUwINrCjuwm3m200t6Ka9QDc
   ooSsgqMj2Pyl3OPwvibQUp+CifLYqFhB02owez19DQrUOo/HRUBehxjFa
   qkb0St/d66NM5V+eFFCZOYla7tpXOrk+DrW3Sqjz8KaxFsGdzWyw+m1Hg
   ymCnzRwkyiz4Vql8lf+4rY4hjQMMp1FzpFNCJIlYC49T2EzPPSoR88M5h
   rDdYfx4oQOT8PiQhJJMRSTTEOUNfxCl2KlKqE/GF6VlV0pDwPyQLEvzxd
   Q==;
X-CSE-ConnectionGUID: RhNvOXs/SYCOfnoP3CInXA==
X-CSE-MsgGUID: Ozqu5UvcSfeoDQV14AkIwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11554"; a="70891144"
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="70891144"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 22:22:21 -0700
X-CSE-ConnectionGUID: nlHt6tNlRFar+WPoLtC2bQ==
X-CSE-MsgGUID: Vw/XemvLRGy9vdGHGfBOWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="175626177"
Received: from junlongf-mobl.ccr.corp.intel.com (HELO [10.238.1.52]) ([10.238.1.52])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 22:22:18 -0700
Message-ID: <2e0b5ee6-deae-4eba-89dc-4abfd63b1578@intel.com>
Date: Tue, 16 Sep 2025 13:22:16 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: TDX: Force split irqchip for TDX at irqchip
 creation time
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>, Ira Weiny <ira.weiny@intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Sagi Shahar <sagis@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
References: <20250827011726.2451115-1-sagis@google.com>
 <175798193779.623026.2646711972824495792.b4-ty@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <175798193779.623026.2646711972824495792.b4-ty@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/16/2025 8:25 AM, Sean Christopherson wrote:
> On Tue, 26 Aug 2025 18:17:26 -0700, Sagi Shahar wrote:
>> TDX module protects the EOI-bitmap which prevents the use of in-kernel
>> I/O APIC. See more details in the original patch [1]
>>
>> The current implementation already enforces the use of split irqchip for
>> TDX but it does so at the vCPU creation time which is generally to late
>> to fallback to split irqchip.
>>
>> [...]
> 
> Applied to kvm-x86 misc, thanks!

The latest one of this patch is v4:

https://lore.kernel.org/all/20250904062007.622530-1-sagis@google.com/

> [1/1] KVM: TDX: Force split irqchip for TDX at irqchip creation time
>        https://github.com/kvm-x86/linux/commit/2569c8c5767b

What got queued, added a superfluous new line in tdx_vm_init()

> --
> https://github.com/kvm-x86/linux/tree/next
> 


