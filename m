Return-Path: <kvm+bounces-43208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 74361A8773B
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 07:32:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB5973A81E1
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 05:31:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9274C1A257D;
	Mon, 14 Apr 2025 05:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nguol5js"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88231E485;
	Mon, 14 Apr 2025 05:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744608711; cv=none; b=H7U7pf2Df/3ZB7CMcSHtRx+Ukq68Ui4iX18Aal9IaaIgj0ORKPLFgMYYddcLzwismocFPWp1aFkiLxXAG3hKXYK01lNF3kb33u7Vw0JN3xy0OgymK5hkm+OB8Qy9mYA7N9QtfDYxLcXpQc7/e/hP/8tUS6JUhkcwkg9obgtqLQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744608711; c=relaxed/simple;
	bh=yyNJl4g3bOgdii6aWvXqbkE/wzU/EU/wMK6naAzWIl0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qSDWZ7sniI/hFgrZYCYaymT9z5HMY0hJX6pV07B5K0T2nmix9xoVs+nVRaFFTOzfVu4Hrwr3AHv6ZpBCWeAalcOzzlv1cDvaAPUKySZd3Rin2aFGu1oJCaH/oO9K/020gp8XODr44dHo+XRxX4o/brwjjsgJpYNZ2LYhCIwaJnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nguol5js; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843C5C4CEE2;
	Mon, 14 Apr 2025 05:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744608711;
	bh=yyNJl4g3bOgdii6aWvXqbkE/wzU/EU/wMK6naAzWIl0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nguol5jsekueg+zeMBErNjyhxrkTAHJFo1t2GzJIr4L3HakW6qmn9c28tFrRoxRj2
	 3eEP3eSNLTRehb8QtJ9qSRiucEoB7o86bGQa8gALh6NRbKlGn7LB25fRKbLh4e6aBA
	 AHPRuZNehfcsa3BeiAkMmuJ7jGhRR9EVa9YuxqkaMjqQAb48TxxEdRyST7+wkZPORD
	 8eJxVsY6eybt1+dNRroMCqXKVKafMEJXeTzfZ7SjDIz2DbJos2ZZwoR2jWja+zjWlt
	 EX8qLmHpP6ybs5ba8F7qrdk/kZEXr58pfpTzrgzkNtlhmTIbrqFxH+m4rNg3Yxm1P/
	 B8Ktz7YMATMYA==
Date: Mon, 14 Apr 2025 07:31:45 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>, KVM <kvm@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: manual merge of the kvm tree with the tip tree
Message-ID: <Z_ydwZOWA9cXDqXd@gmail.com>
References: <20250414141411.469e897f@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250414141411.469e897f@canb.auug.org.au>


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> Today's linux-next merge of the kvm tree got a conflict in:
> 
>   arch/x86/kvm/vmx/vmx.c
> 
> between commits:
> 
>   c435e608cf59 ("x86/msr: Rename 'rdmsrl()' to 'rdmsrq()'")
>   78255eb23973 ("x86/msr: Rename 'wrmsrl()' to 'wrmsrq()'")
> 
> from the tip tree and commit:
> 
>   7172c753c26a ("KVM: VMX: Move common fields of struct vcpu_{vmx,tdx} to a struct")
> 
> from the kvm tree.
> 
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.

>  -	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
>  +	wrmsrq(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);

>  -	wrmsrl(MSR_KERNEL_GS_BASE, vmx->vt.msr_host_kernel_gs_base);
> ++	wrmsrq(MSR_KERNEL_GS_BASE, vmx->vt.msr_host_kernel_gs_base);

>  -		rdmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
>  +		rdmsrq(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);

>  -		wrmsrl(MSR_KERNEL_GS_BASE, data);
>  +		wrmsrq(MSR_KERNEL_GS_BASE, data);

Looks good, thanks!

	Ingo

