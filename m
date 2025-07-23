Return-Path: <kvm+bounces-53194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B0DCB0EDA3
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 10:50:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F206188C254
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 08:50:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E67FE27F75F;
	Wed, 23 Jul 2025 08:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P2tiBWHt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C0C26B09F
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 08:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753260633; cv=none; b=l1qFgKkZW06M2egMIlSuOsIHFlzIEJOfTKcBkFENYJHE1ghHDkOmimgS+zC3/z06/dHihNP/aMbaX0o7VA0Fwysm2edVdDptSTSqWj26rSd60qjKKLaXJC/LvCilX3qi2UA/ejLkLGj3BtX7OmesdkxbGkL1GVoM1k4Coif+pjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753260633; c=relaxed/simple;
	bh=TK8DYv1PHjhFjScJ5kLfKZ8i0nW2pZl+oHS3/788X54=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=EmrzLoqtxGsMbYQG363gO5vNpJktTFBce3e8/HY51Vtnnw57S08QVlj1numkT+7XFEUtQ8zw7MiaC9l9N0IhNLDxpxPPWHo0wXhm++qajh97BIzwrv9f3eGylun+9EQwLRjOeTfI9Kxoxii29dWIOTd/qbUIIkkTNRhDVOhI7eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P2tiBWHt; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753260631; x=1784796631;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=TK8DYv1PHjhFjScJ5kLfKZ8i0nW2pZl+oHS3/788X54=;
  b=P2tiBWHtWTyOGZEGFadoQlp8K8Ncwt6Z7vakcxl+udFlJNc5ZGvq8rhH
   +irITRuaHF5GE+OF0pZZ15w1qOltKvVWKzzeSFlpgpmVhAnf4KtUnPYs7
   hU46E/bvVMByuLCHiJeVvzQr937ir/trqVMb7fjEbiVwXpIIXaAj0Lik3
   i7P0vr34wg7ZLehScaftYogGQ/WfRDptNmqfXNzsEbAUBd8NfkoQwblzS
   sb7QjFnylCx710H462wH118wRWApeZb8oA1qQs5FykZ5TyCwHsJ9LWzli
   CK/qIQWFhEeQ9BugRVjeT7ZeBy2bVv427XT7D/s9W5yWXJT3AGXc3Pjnz
   g==;
X-CSE-ConnectionGUID: VvzoJs8TQKGZapsdq323xg==
X-CSE-MsgGUID: 6wx4plZoQrmzcqS2BNX2rg==
X-IronPort-AV: E=McAfee;i="6800,10657,11500"; a="59335277"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="59335277"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 01:50:31 -0700
X-CSE-ConnectionGUID: 1s2nVqlOQtCqcn9JBNMT0w==
X-CSE-MsgGUID: ipSRNVPtSJu4rgY2T5akTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="163646079"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 01:50:29 -0700
Message-ID: <c787981c-dc21-4b74-b219-03255781f927@intel.com>
Date: Wed, 23 Jul 2025 16:50:26 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] i386/kvm: Disable hypercall patching quirk by default
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Mathias Krause <minipli@grsecurity.net>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
 Oliver Upton <oliver.upton@linux.dev>,
 Sean Christopherson <seanjc@google.com>
References: <20250722204316.1186096-1-minipli@grsecurity.net>
 <206a04b9-91cb-41e4-b762-92201c659d78@intel.com>
 <ebbb7c3c-b8cb-49b6-a029-e291105300fd@grsecurity.net>
 <fbd47fb6-838e-47bf-a344-f90be06eed99@intel.com>
Content-Language: en-US
In-Reply-To: <fbd47fb6-838e-47bf-a344-f90be06eed99@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/23/2025 4:42 PM, Xiaoyao Li wrote:
> On 7/23/2025 3:53 PM, Mathias Krause wrote:
>>> I would leave it to Paolo to decide whether a compat property is needed
>>> to disable the hypercall patching by default for newer machine, and keep
>>> the old machine with old behavior (hypercall patching is enabled) by
>>> default.
>> Bleh, I just noticed that there are KUT tests that actually rely on the
>> feature[1]. I'll fix these but, looks like, we need to default on for
>> the feature -- at least for existing machine definitions 🙁
> 
> You reminds me.
> 
> There is also even a specific KUT hypercall.c, and default off fails it 
> as well.
> 
> enabling apic
> smp: waiting for 0 APs
> Hypercall via VMCALL: OK
> Unhandled exception 6 #UD at ip 00000000004003dd
> error_code=0000      rflags=00010002      cs=00000008
> rax=00000000ffffffff rcx=00000000000003fd rdx=00000000000003f8 
> rbx=0000000000000001
> rbp=0000000000710ff0 rsi=00000000007107b1 rdi=000000000000000a
>   r8=00000000007107b1  r9=00000000000003f8 r10=000000000000000d 
> r11=0000000000000020
> r12=0000000000000001 r13=0000000000000000 r14=0000000000000000 
> r15=0000000000000000
> cr0=0000000080000011 cr2=0000000000000000 cr3=000000000040c000 
> cr4=0000000000000020
> cr8=0000000000000000
>      STACK: @4003dd 4001ad

>> Looks like I have to go the compat property route.

BTW, the compat property doesn't fix KUT issues actually.

Since KUT doesn't use versioned machine, instead of it always uses the 
latest machine.

>>
>> [1]
>> https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/blob/master/x86/ 
>> vmexit.c?ref_type=heads#L36
> 
> 


