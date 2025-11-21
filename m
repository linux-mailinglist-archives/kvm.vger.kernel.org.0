Return-Path: <kvm+bounces-64022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E6FBDC76C6E
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 01:30:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id F02CD2AACE
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:30:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 169AE1BCA1C;
	Fri, 21 Nov 2025 00:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X8mQaEgd"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F057F17E4
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 00:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763685044; cv=none; b=UaXdr2tQu5iBIh/9jDhSKNpz28ZoptZVWez3FfzJI5rGdJ3DfcrKe63n4ylcstzFXn9Tp3MZNstO+ZVC7Nzicdl1niD53Gg6GWJLFpJiddwbBRJUOMf7f9ycT2mLM/yWfa4khw0VfkY521q4nYKc+YFbr1gxVYxHB++tdqYizdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763685044; c=relaxed/simple;
	bh=+HlOZLaFYExjHizWpe0HMobVC/i7yy3fyk1ny6u4PNU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RUZct/0FcxwiXXA8QtyxazX7FGu1VmW6x5Q4m1MbolXQVfED/McsEWbkEhErhE5CtDRAj0AguNHYEDEurDJY/GLM5b+/U8VHu2Drz985gEf7vvr+YsCoo8XfJjArvHK277Hqiv165o9mUPQrjzaLtV5XjtyJtBi5PPHsgVLDs6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X8mQaEgd; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 21 Nov 2025 00:30:35 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763685039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9OvifxekvGheYbevIVJXGiCFhjcYqYtx3Tr1KYlqAnk=;
	b=X8mQaEgd8GyF+X9bkLfDZevAdICHASYniS4EyZwFqPBhTBMzoFbXwf3vEhiy3k+Jdh4TFX
	qf+KYkwKVt6qDoQWNX5OgWzhog/4edhQ4DO2bjRPS0xjh3UnCE6NymqIYqVV2hlpUWlWPn
	Rl71LFIkCsXdIohITDMBJhqPgbGnhyo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/23] Extend test coverage for nested SVM
Message-ID: <vgbuzefu4w5mc7cvqv4xzgqycv4qa46s6wolhau4nc65fgsajx@tzbsrlhu4ltr>
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
 <aR-pMqVqhgzsERaj@google.com>
 <t4modyzuwzmlmu4hcwpxzsbprhebjwuz3uc2doc6nauepruczw@vray2facmzks>
 <aR-xNA0l2ybr0UqC@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aR-xNA0l2ybr0UqC@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 20, 2025 at 04:24:20PM -0800, Sean Christopherson wrote:
> On Fri, Nov 21, 2025, Yosry Ahmed wrote:
> > On Thu, Nov 20, 2025 at 03:50:10PM -0800, Sean Christopherson wrote:
> > >   KVM: selftests: Extend vmx_tsc_adjust_test to cover SVM
> > >   KVM: selftests: Extend nested_invalid_cr3_test to cover SVM
> > >   KVM: selftests: Move nested invalid CR3 check to its own test
> > >   KVM: selftests: Extend vmx_nested_tsc_scaling_test to cover SVM
> > >   KVM: selftests: Extend vmx_close_while_nested_test to cover SVM
> > 
> > Not sure I understand how you to proceed. Do you want me to respin these
> > patches separately (as series A), on top of kvm-x86/next, and then
> > respin the rest of the series separately (as series B, with your struct
> > kvm_mmu suggestion)?
> 
> I'm going to apply a subset "soon", hopefully they'll show up in kvm-x86/next
> tomorrow.  I think it's patches 3-9?

I think 10 and 11 should also be good to go, unless you have reason to
think otherwise.

> 
> > As for set_nested_state, if you plan to pickup Jim's EFER fixes I can
> > just include it as-is in series (A). If not, I can include
> > generalization of the test, and send covering Jim's fix separately.
> 
> We're likely going to need a v3 of Jim's GIF series no matter what, so let's plan
> on bundling patches 1-2 with v3 of that series.
> 
> That leaves the paging patches.  Unless you're super duper speedy, I should get
> patches 3-9 and Jim's LA57 changes+test pushed to kvm-x86 before you're ready to
> post the next version of those patches.
> 
> So:
>   Fold 1-2 into Jim's GIF series.
>   Do nothing for 3-9.
>   Spin a new version of 10+ (the paging patches) after kvm-x86/next is refreshed

Makes sense, I will coordinate with Jim. Thanks!

