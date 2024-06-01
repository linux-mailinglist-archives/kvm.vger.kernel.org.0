Return-Path: <kvm+bounces-18577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C8478D7143
	for <lists+kvm@lfdr.de>; Sat,  1 Jun 2024 18:58:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A8392826E6
	for <lists+kvm@lfdr.de>; Sat,  1 Jun 2024 16:58:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15F4B15442B;
	Sat,  1 Jun 2024 16:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LH4oHneY"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791FC1527A0
	for <kvm@vger.kernel.org>; Sat,  1 Jun 2024 16:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717261064; cv=none; b=MgvEhm3l++rDBj99DBTrtttnBAP4MQqxeURoI4W7gBY8UctrqAavAJWMSwQgj6vupKKsPdm/FWyTWtsyQra1mfuqCG3DL7aw00rF5hukoemn0iUIcgyQnIxnV1QiYVJz0dDgAkO+NoAi/aPB80LKiXrTVJ9OtU8AwRO6cJPHmmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717261064; c=relaxed/simple;
	bh=wVotdO9j7tE4AWW7SQJUOkpiSWjoHozRLSzU4NvGP0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SWzS1iDgIx23WpBY73D1f5zM0J6Az/Ui0+rfgghgpdGnO3QD/rq5hJdXDO8kMbkl9bGJOF3nmtUdHVQ0op9nAyfm20AtRlVWkV2tX6l4X75WAOE97ZiK3kBxouPAulCfYwljUsBSnskIbGJ54xV3zFXwsNhEn9V8hrkYwPSAJP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LH4oHneY; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: maz@kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717261059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Eu63+ui3NCNu/cbwzFZGKRgGHoolaynM1Ff68oWiYRs=;
	b=LH4oHneYCEKESsjPUtWSAEG6b6cW49IqWf/sdyIQXyJ5cXUSHuNCVOCJ4CfFKB2qKsRSCx
	etXHC+W4DQ90aQ8iL4O75p5dvTrgo31uwVu3Iv6C9WjR9ZJN3a7Vb2leugU2k+xLutKRw6
	fJL0kYbBCEITF12vafrBWJ326x5zaoA=
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
Date: Sat, 1 Jun 2024 09:57:31 -0700
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 00/11] KVM: arm64: nv: FPSIMD/SVE support
Message-ID: <ZltS-7c4cSBdMqfh@linux.dev>
References: <20240531231358.1000039-1-oliver.upton@linux.dev>
 <87jzj92c5q.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87jzj92c5q.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Jun 01, 2024 at 11:24:49AM +0100, Marc Zyngier wrote:
> On Sat, 01 Jun 2024 00:13:47 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > Hey!
> > 
> > I've decided to start messing around with nested and have SVE support
> > working for a nested guest. For the sake of landing a semi-complete
> > feature upstream, I've also picked up the FPSIMD patches from the NV
> > series Marc is carrying.
> > 
> > The most annoying part about this series (IMO) is that ZCR_EL2 traps
> > behave differently from what needs to be virtualized for the guest when
> > HCR_EL2.NV = 1, as it takes a sysreg trap (EC = 0x18) instead of an SVE
> > trap (EC = 0x19). So, we need to synthesize the ESR value when
> > reflecting back into the guest hypervisor.
> 
> That's unfortunately not a unique case. The ERETAx emulation already
> requires us to synthesise the ESR on PAC check failure, and I'm afraid
> ZCR_EL2 might not be the last case.
> 
> In general, we'll see this problem for any instruction or sysreg that
> can generate multiple exception classes.

Right, I didn't have a good feel yet for whether or not we could add
some generalized infrastructure for 'remapping' ESR values for the guest
hypervisor. Of course, not needed for this, but cooking up an ISS is
likely to require a bit of manual intervention.

> > Otherwise, some care is required to slap the guest hypervisor's ZCR_EL2
> > into the right place depending on whether or not the vCPU is in a hyp
> > context, since it affects the hyp's usage of SVE in addition to the VM.
> > 
> > There's more work to be done for honoring the L1's CPTR traps, as this
> > series only focuses on getting SVE and FPSIMD traps right. We'll get
> > there one day.
> 
> I have patches for that in my NV series, which would take the place of
> patches 9 and 10 in your series (or supplement them, depending on how
> we want to slice this).

That'd be great, I just wanted to post something focused on FP/SVE to
start but...

> > 
> > I tested this using a mix of the fpsimd-test and sve-test selftests
> > running at L0, L1, and L2 concurrently on Neoverse V2.
> 
> Thanks a lot for tackling this. It'd be good to put together a series
> that has the EL2 sysreg save/restore patches as a prefix of this, plus
> the CPTR_EL2 changes. That way, we'd have something that can be merged
> as a consistent set.

I'd be happy to stitch together something like this to round out the
feature. I deliberately left out the handling of vEL2 registers because
of the CPACR_EL1 v. CPTR_EL2 mess, but we may as well sort that out.

Did you want to post your CPTR bits when you have a chance?

-- 
Thanks,
Oliver

