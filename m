Return-Path: <kvm+bounces-64011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 21AA9C76B32
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 01:06:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2BFD34E2A87
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:06:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD9984594A;
	Fri, 21 Nov 2025 00:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TZTxKBO/"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97382836F
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 00:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763683565; cv=none; b=n2k1QiwlKHS0/ZI/kTP3Zcum3xZlTDQc27zFkJI8T2IEYdePa4Kys3LEbF0UcxXwnJ8yLrq8EpJ7i6COnuRNiOfGKtU/DATQ251vyhnfv62lfY2QWMXRJS30pt7Efol3E5B6dYTIza6yqWyktIhKzunPKugvdr1Bbd8h7PJKn+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763683565; c=relaxed/simple;
	bh=430b95yRyvb50wlNpQU7yV7tyMObW876uGOPFdvZXPs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qHU6AECySBpgNKBK+SHwfRznslxC/qrh5gj79RGZSTMz9j3FGBwg66g6Vyq0/FMDwdyLDuS3YFDBnPEZYr6q+I7r3brwwkM/a8NGApgecVf+1DYvGqUeArDnS1uhh9eUgPcnXtcSLPIE1WEJu7gDPUn/jeRfby3l5EBLWkpuh8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TZTxKBO/; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 21 Nov 2025 00:05:56 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763683560;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qET4RgkjJ1pWg5gBvL/kpUbwvWulAlD6gPf7AoE0kWY=;
	b=TZTxKBO/r85uDp6a4HdmXVGPh9YD2t4ohH9Lm0byLTaJ/XpLaZX7f/1B5euuIBqbOj4I0C
	7S+vKbRCkvQUdaT0CZbIlvqjZ74LPxiOoKEMGDu0iePA+LeDdaWn5a9C8aJ1vzf5Yesyx+
	daDJJJWYwH9klw6julOpcfm++axX5es=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/23] Extend test coverage for nested SVM
Message-ID: <t4modyzuwzmlmu4hcwpxzsbprhebjwuz3uc2doc6nauepruczw@vray2facmzks>
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
 <aR-pMqVqhgzsERaj@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aR-pMqVqhgzsERaj@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 20, 2025 at 03:50:10PM -0800, Sean Christopherson wrote:
> On Tue, Oct 21, 2025, Yosry Ahmed wrote:
> > There are multiple selftests exercising nested VMX that are not specific
> > to VMX (at least not anymore). Extend their coverage to nested SVM.
> > 
> > This version is significantly different (and longer) than v1 [1], mainly
> > due to the change of direction to reuse __virt_pg_map() for nested EPT/NPT
> > mappings instead of extending the existing nested EPT infrastructure. It
> > also has a lot more fixups and cleanups.
> > 
> > This series depends on two other series:
> > - "KVM: SVM: GIF and EFER.SVME are independent" [2]
> > - "KVM: selftests: Add test of SET_NESTED_STATE with 48-bit L2 on 57-bit L1" [3]
> > 
> > The dependency on the former is because set_nested_state_test is now
> > also a regression test for that fix.
> 
> Uh, then the selftest change absolutely should be sent at the same time as the
> KVM change.  One of the big benefits of selftests over KUT is that selftests are
> in the same repo as KVM.  We should almost never have to coordinate selftests
> chagnes against KVM changes across different series.

Yeah that didn't work out well. I saw Jim's fixes as I was working on
that test and thought might as well test for Jim's changes. In
retrospect I should have split this into two patches.

> 
> > The dependency on the latter is purely to avoid conflicts.
> 
> Similar to my feedback on your mega-series for KUT, don't bundle unrelated patches
> without good reason (and no reason _NOT_ to bundle them).

Noted.

> 
> I want to immediate take the patches that aren't related to the paging API changes,
> but that's proving to be difficult because there are superficial dependencies on
> Jim's LA57 changes, and I need to drop the vmx_set_nested_state_test changes because
> they belong elsewhere.
> 
> Bundling these is fine since they're thematically related and do generate superficial
> conflicts, though even then I would be a-ok with splitting these up (superficial
> conflicts are trivial to resolve (knock wood), and avoiding such conflicts isn't
> a good reason to bundle unrelated things).
> 
>   KVM: selftests: Extend vmx_tsc_adjust_test to cover SVM
>   KVM: selftests: Extend nested_invalid_cr3_test to cover SVM
>   KVM: selftests: Move nested invalid CR3 check to its own test
>   KVM: selftests: Extend vmx_nested_tsc_scaling_test to cover SVM
>   KVM: selftests: Extend vmx_close_while_nested_test to cover SVM

Not sure I understand how you to proceed. Do you want me to respin these
patches separately (as series A), on top of kvm-x86/next, and then
respin the rest of the series separately (as series B, with your struct
kvm_mmu suggestion)?

As for set_nested_state, if you plan to pickup Jim's EFER fixes I can
just include it as-is in series (A). If not, I can include
generalization of the test, and send covering Jim's fix separately.

Series B will still need to depend on Jim's selftests changes, if you're
planning to pick those up soon I can base my changes on whatever branch
you'll use. Otherwise I can resend both together, maybe?


