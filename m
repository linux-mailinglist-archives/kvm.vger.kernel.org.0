Return-Path: <kvm+bounces-40384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 168A5A570B7
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:39:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D5B117706A
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 18:39:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D51F242913;
	Fri,  7 Mar 2025 18:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dNBq7+OZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D742417D3;
	Fri,  7 Mar 2025 18:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741372766; cv=none; b=fI8HQt9Rsd2KXBYqI2Ox30SPY5IEuyOUQye63k1wutQSzTa5i3z8NW9VXJnqvQs2BjfOKQbqlDKpfrkLPbMFOanLeByr/XwSfvlNtgUhsou3DR1m7SBDK67B1ahHETUhYNg05AVjhvB/6gKD3ftxloSdG+HAh4+y3ybk/PkUIjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741372766; c=relaxed/simple;
	bh=qU6KijlFXoR98S5pulEIQzkadZEZV8Z0TBnXBxmBuu8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IgV+KN2iAESctAHW+qDFC3Yjr1ZzBDQX6gsTRAVIQX8yXUTRuydljmHJa1j2MmU3v6CQZBZrUyuMDWrUWHysKVAEylb8ZN/BBcqKgPmaVLwwR8CqZRNvuKPgJpygvKg1aqIOndrFPp9uswcQ+a1qtewlYxZDJ6I0tkCLFtwpWfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dNBq7+OZ; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741372765; x=1772908765;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qU6KijlFXoR98S5pulEIQzkadZEZV8Z0TBnXBxmBuu8=;
  b=dNBq7+OZ/aPY5ZgOnocmF7ofJKWF8u7TmfWH5gF/ISrz/M1mSdwkaQNf
   oTsAX4VKqUEFF55T5kkpM0lDPRUlOYw9mDVglz9m2CsGJRDp1/1MZMZ53
   0HezCm0Oql6YUWaIZR0Prdz1zLRKD/PB1QtURBeiFfArR9tDCokpztlVP
   8QeNLrYuUvfBW3mGJJn6KvPQN84fZsE0/Lci92ebQI7/zMFz3Z2dFtz/g
   bRKgrIhS8vSAWP6v2Na7RK9MaepPWWG+DzjKt8lDFwp6SyhIgaD879PAo
   g5+iREEKz9JRRj66rWpI5+f00M2/Q5lvzIAiw2o9aL1J/bbU6mATziE/Z
   Q==;
X-CSE-ConnectionGUID: 58uY+RgmSY+3YcsTvpqJbg==
X-CSE-MsgGUID: NEOs++VwQs2qo0McxQ53UA==
X-IronPort-AV: E=McAfee;i="6700,10204,11365"; a="53072692"
X-IronPort-AV: E=Sophos;i="6.14,229,1736841600"; 
   d="scan'208";a="53072692"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 10:39:24 -0800
X-CSE-ConnectionGUID: ru1BalfMQ0ue0IcmsKwSpw==
X-CSE-MsgGUID: QlkwuRuuT3+yDy+4eLZTEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,229,1736841600"; 
   d="scan'208";a="124317362"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.110.132]) ([10.125.110.132])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 10:39:23 -0800
Message-ID: <74e49413-dd1a-4577-818f-b5b21b2a2b7e@intel.com>
Date: Fri, 7 Mar 2025 10:39:47 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/10] x86/fpu/xstate: Add CET supervisor xfeature
 support
To: Chao Gao <chao.gao@intel.com>, tglx@linutronix.de, x86@kernel.org,
 seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: peterz@infradead.org, rick.p.edgecombe@intel.com,
 weijiang.yang@intel.com, john.allen@amd.com, bp@alien8.de,
 Maxim Levitsky <mlevitsk@redhat.com>
References: <20250307164123.1613414-1-chao.gao@intel.com>
 <20250307164123.1613414-9-chao.gao@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20250307164123.1613414-9-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/7/25 08:41, Chao Gao wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
> To support CET virtualization, KVM needs the kernel to save/restore CET
> supervisor xstate in guest FPUs when switching between guest and host
> FPUs.
> 
> Add CET supervisor xstate (i.e., XFEATURE_CET_KERNEL) support. Both the
> guest FPU and the kernel FPU will allocate memory for the new xstate.
> For the guest FPU, the xstate remains unused until the upcoming CET
> virtualization is added to KVM. For the kernel FPU, the xstate is unused
> until CET_S is enabled within the kernel.
> 
> Note CET_S may or may not be enabled within the kernel, so always
> allocating memory for XFEATURE_CET_KERNEL could potentially waste some
> XSAVE buffer space. If necessary, this issue can be addressed by making
> XFEATURE_CET_KERNEL a guest-only feature.

I feel like these changelogs are long but say very little.

This patch *WASTES* resources. Granted, it's only for a single patch,
but it's totally not obvious.

Could you work on tightening down the changelog, please?

> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -55,7 +55,7 @@ static const char *xfeature_names[] =
>  	"Protection Keys User registers",
>  	"PASID state",
>  	"Control-flow User registers",
> -	"Control-flow Kernel registers (unused)",
> +	"Control-flow Kernel registers",

This should probably be:

> +	"Control-flow Kernel registers (KVM only)",

or something similar for now. XFEATURE_CET_KERNEL is *VERY* different
from all of the other features and it's silly to pretend that it's the same.

