Return-Path: <kvm+bounces-67081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B312CF5A23
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 22:16:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9CF5E30318F5
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 21:16:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A2F52BE051;
	Mon,  5 Jan 2026 21:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tL2I1+Nm"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B444A2D8379
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 21:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767647798; cv=none; b=j/kGETG0p7qdSYYTWCAxq/+XuCUofvqdAZDhA/mX+29l0b3jZNhC6HcQz+5V8CtgUaLo4jV6AuQwAacJVZYOlVhJzMC/5eRoYqG6DgZMGKAgHXjRnVv1Ej9L94HI1lIVKZ/76K+6I3+ekfQYF4XfD55SirYqeTLHuN1n/4NVkmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767647798; c=relaxed/simple;
	bh=9FD5nbNa3nKMcmRip7DcoOfGBdGtdIlZ2Z4beTHhMa4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VZ4IdeQNyTdqe0CjgdIMABZ5uHK8E4mPAoWH7UX990ygihNg68UHG81Vpee8u6/28ApjDVhrdDGGhhYTCIck0GQF5+EDhWBxvyUs8FHS4ZxEI0WHm/lyzXCJmKEDr0zcqQtu30Rg5wCIMKr3+XIN6Urv4HgOqQkiGfhEhfi+h8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tL2I1+Nm; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 5 Jan 2026 21:16:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767647783;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mv6h3guch/LgRZfi/ShLPc4l43coRaB9CbaSEPDURQM=;
	b=tL2I1+Nm4rL5CW5u+rm9XMnQ7g9jCXpNeHK+tCg94DWhYf/ElAfobyO65N5/LZIaFXlRyP
	xkdRNW1cy/+once5b3iiYRZyohZLXu7aCC9CSEb90EFyhctG51lbtQCyVF+f4FwPFcyFVL
	GwTiYOpQO247Ca5T2fQnvHajIn08ZyE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] x86: Increase the timeout for
 vmx_pf_{vpid/no_vpid/invvpid}_test
Message-ID: <q4ezq2eipk27fo5e33fqsmqqpluj35qquihw6tgcfpndzgggah@apfg6ncuvwix>
References: <20260102183039.496725-1-yosry.ahmed@linux.dev>
 <aVv6xaI0hYwgB0ce@google.com>
 <6fltlvsnlbqyw3sme2zamsxp2u54tkoauydeoq2v3rri6r2uja@lmxwn57ll5ta>
 <aVwOuUEeE5dm3cpF@google.com>
 <msxw2bnkbbhnk6cpzs36vs4gww6r2on25twxpridybcqiyb4b5@5i2mblpty3fa>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <msxw2bnkbbhnk6cpzs36vs4gww6r2on25twxpridybcqiyb4b5@5i2mblpty3fa>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 05, 2026 at 07:42:36PM +0000, Yosry Ahmed wrote:
> On Mon, Jan 05, 2026 at 11:19:21AM -0800, Sean Christopherson wrote:
> > On Mon, Jan 05, 2026, Yosry Ahmed wrote:
> > > On Mon, Jan 05, 2026 at 09:54:13AM -0800, Sean Christopherson wrote:
> > > > On Fri, Jan 02, 2026, Yosry Ahmed wrote:
> > > > > When running the tests on some older CPUs (e.g. Skylake) on a kernel
> > > > > with some debug config options enabled (e.g. CONFIG_DEBUG_VM,
> > > > > CONFIG_PROVE_LOCKING, ..), the tests timeout. In this specific setup,
> > > > > the tests take between 4 and 5 minutes, so pump the timeout from 4 to 6
> > > > > minutes.
> > > > 
> > > > Ugh.  Can anyone think of a not-insane way to skip these tests when running in
> > > > an environment that is going to be sloooooow?  Because (a) a 6 minute timeout
> > > > could very well hide _real_ KVM bugs, e.g. if is being too aggressive with TLB
> > > > flushes (speaking from experience) and (b) running a 5+ minute test is a likely
> > > > a waste of time/resources.
> > > 
> > > The definition of a slow enviroment is also very dynamic, I don't think
> > > we want to play whack-a-mole with config options or runtime knobs that
> > > would make the tests slow.
> > > 
> > > I don't like just increasing the timeout either, but the tests are slow
> > > even without these specific config options. They only make them a little
> > > bit slower, enough to consistently reproduce the timeout.
> > 
> > Heh, "little bit" is also subjective.  The tests _can_ run in less than 10
> > seconds:
> > 
> > $ time qemu --no-reboot -nodefaults -global kvm-pit.lost_tick_policy=discard
> >   -device pc-testdev -device isa-debug-exit,iobase=0xf4,iosize=0x4 -display none
> >   -serial stdio -device pci-testdev -machine accel=kvm,kernel_irqchip=split
> >   -kernel x86/vmx.flat -smp 1 -append vmx_pf_invvpid_test -cpu max,+vmx
> > 
> > 933897 tests, 0 failures
> > PASS: 4-level paging tests
> > filter = vmx_pf_invvpid_test, test = vmx_pf_vpid_test
> > filter = vmx_pf_invvpid_test, test = vmx_exception_test
> > filter = vmx_pf_invvpid_test, test = vmx_canonical_test
> > filter = vmx_pf_invvpid_test, test = vmx_cet_test
> > SUMMARY: 1867887 tests
> > Command exited with non-zero status 1
> > 3.69user 3.19system 0:06.90elapsed 99%CPU
> > 
> > > This is also acknowledged by commit ca785dae0dd3 ("vmx: separate VPID
> > > tests"), which introduced the separate targets to increase the timeout.
> > > It mentions the 3 tests taking 12m (so roughly 4m each). 
> > 
> > Because of debug kernels.  With a fully capable host+KVM and non-debug kernel,
> > the tests take ~50 seconds each.
> > 
> > Looking at why the tests can run in ~7 seconds, the key difference is that the
> > above run was done with ept=0, which culls the Protection Keys tests (KVM doesn't
> > support PKU when using shadow paging because it'd be insane to emulate correctly).
> > The PKU testcases increase the total number of testcases by 10x, which leads to
> > timeouts with debug kernels.
> > 
> > Rather than run with a rather absurd timeout, what if we disable PKU in the guest
> > for the tests?  Running all four tests completes in <20 seconds:
> 
> This looks good. On the Icelake machine they took around 1m 24s, and I
> suspect they will take a bit longer with all the debug options, so we'll
> still need a longer timeout than the default 90s (maybe 120s or 180s).

I tried with the debug kernel (including CONFIG_DEBUG_VM and others) on
both Skylake and Icelake. It timed out on both with the default 90s
timeout.

With 180s timeout, it took 1m40s and 1m37s on Icelake and Skylake
respecitvely. So I think if we keep them combined we should at least use
120s for the timeout.

or..

> 
> Alternatively, we can keep the targets separate if we want to keep the
> default timeout.

