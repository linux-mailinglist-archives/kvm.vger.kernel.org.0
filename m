Return-Path: <kvm+bounces-68234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DACED27986
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 19:34:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id AF91430B481A
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 18:19:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E3113B8D5F;
	Thu, 15 Jan 2026 18:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JPkpOxWZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC9022E3E7;
	Thu, 15 Jan 2026 18:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768501150; cv=none; b=mFqZZ01y7svyckbyrGLc7HmroE5P4Xxs5x+paJOK29qzVzFihpqGL8Axx+IZhKAKB9yuPaQZvhjKD4zoCvpAvXz5nrqNXtZubvSBfuKW70SXX+ixbAB6BFe44pOwuG9Vq4fpGEUwQ+9SxZSGr09KLym1iijCPl2G1Klk2PWD6Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768501150; c=relaxed/simple;
	bh=Tl77+ilpEwZ50+49EdkTr7t/MOwSAVmPOeknVpPoaFw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rAo7A0Q7JqwmeiSlZWwBvKTXov4JjthHRErCOxZXSV6SDz6u2XSTCMFgVRgmOnsk9HVj/8cIaDzX17CcV3zsRPxGHIMLC4rEjYyxX4sGjSnymvJ2O2OOzdmUTU4Ko9YfW8G8p1Vx3NAQt4PKuGFLURVRzgmhYlU8lFuB13DAoog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JPkpOxWZ; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768501149; x=1800037149;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Tl77+ilpEwZ50+49EdkTr7t/MOwSAVmPOeknVpPoaFw=;
  b=JPkpOxWZQL4zxR7wostiDtEX0Vmq8YupyOUiGWuik/p32/Rfob9GQM/c
   tZrYsLPdYYAPdx0EEslmOp6GBtREbuIJZF2YWkvwFnptllfebT//zQmJv
   f4nf45CAnvcle1Bslvz51Lbpf1nxqRUshiwUR/QdSbaVTc2y+K60Mu+VY
   Vtp1mC5ZYmGOmdBhf4y0L+RaHfS73uZRX9g56OBtzJokSKKSfTOAv7xWx
   4yWAxsK3V7pwIIq14oizHHvaC4ck3yzhkSbEyEmaghFqtBP3bGKaDPjvb
   WsFWbcULiMhf0gKtnU2K81hInls38IW7DkAgrjcYu1PfAVqVQMz+XsKiF
   w==;
X-CSE-ConnectionGUID: hy4pUwlBT9esX8hP6OkVjA==
X-CSE-MsgGUID: CQWPrFSKRpSlYc9u9+ZjiQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="69906153"
X-IronPort-AV: E=Sophos;i="6.21,228,1763452800"; 
   d="scan'208";a="69906153"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 10:19:08 -0800
X-CSE-ConnectionGUID: TRe12CtfRnevVzEsD6osKw==
X-CSE-MsgGUID: H9j2mRMjTpOzJYEl/2immQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,228,1763452800"; 
   d="scan'208";a="204161726"
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.111.74]) ([10.125.111.74])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 10:19:08 -0800
Message-ID: <f130ac18-708a-4074-b031-9599006786d3@intel.com>
Date: Thu, 15 Jan 2026 10:19:07 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] x86/fpu: Clear XSTATE_BV[i] in save state whenever
 XFD[i]=1
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: seanjc@google.com, x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
 Borislav Petkov <bp@alien8.de>, "Bae, Chang Seok" <chang.seok.bae@intel.com>
References: <20260101090516.316883-1-pbonzini@redhat.com>
 <20260101090516.316883-2-pbonzini@redhat.com>
 <cd6721c7-0963-4f4f-89d9-6634b8b559ae@intel.com>
 <8ee84cb9-ef6d-43ac-b9d0-9c22e7d1ecd8@redhat.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <8ee84cb9-ef6d-43ac-b9d0-9c22e7d1ecd8@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 1/15/26 08:22, Paolo Bonzini wrote:
> 
>   Guest running with MSR_IA32_XFD = 0
>     WRMSR(MSR_IA32_XFD)
>     vmexit
>   Host:
>     enable IRQ
>     interrupt handler
>       kernel_fpu_begin() -> sets TIF_NEED_FPU_LOAD
>         XSAVE -> stores XINUSE[18] = 1
>         ...
>       kernel_fpu_end()
>     handle vmexit
>       fpu_update_guest_xfd() -> XFD[18] = 1
>     reenter guest
>       fpu_swap_kvm_fpstate()
>         XRSTOR -> XINUSE[18] = 1 && XFD[18] = 1 -> #NM and boom
> 
> With the patch, fpu_update_guest_xfd() sees TIF_NEED_FPU_LOAD set and
> clears the bit from xinuse.

Paolo, thanks for clarifying that!

Abbreviated, that's just:

	XFD[18]=0
	...
	# Interrupt (that does XSAVE)
	XFD[18]=1
	XRSTOR => #NM

Is there anything preventing the kernel_fpu_begin() interrupt from
happening a little later, say:

	XFD[18]=0
	...
	XFD[18]=1
	# Interrupt (that does XSAVE)
	XRSTOR (no #NM)
	
In that case, the XSAVE in kernel_fpu_begin() "operates as if XINUSE[i]
= 0" and would set XFEATURES[18]=0; it would save the component as being
in its init state. The later XRSTOR would obviously restore state 18 to
its init state.

Without involving SMIs, I think it lands feature 18 in its init state as
well. The state is _already_ being destroyed in the existing code
without anything exotic needing to happen.

That's a long-winded way of saying I think I agree with the patch. It
destroys the state a bit more aggressively but it doesn't do anything _new_.

What would folks think about making the SDM language stronger, or at
least explicitly adding the language that setting XFD[i]=1 can lead to
XINUSE[i] going from 1=>0. Kinda like the language that's already in
"XRSTOR and the Init and Modified Optimizations", but specific to XFD:

	If XFD[i] = 1 and XINUSE[i] = 1, state component i may be
	tracked as init; XINUSE[i] may be set to 0.

That would make it consistent with the KVM behavior. It might also give
the CPU folks some additional wiggle room for new behavior.

