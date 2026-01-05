Return-Path: <kvm+bounces-67070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A6CB3CF53A4
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 19:25:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AA350302C9C6
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 18:25:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 698062C08AD;
	Mon,  5 Jan 2026 18:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="O1UxU7h7"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (unknown [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E022DECD2
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 18:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767637497; cv=none; b=pJg/jiowJ5NBkQsJ3nR7azQ8RTfgPyJb2h0jWlU/noj4U4J6QNZ4+o6qx6nEFKFzDVc7lKnc2oNlsO6uUge/q2fguOVW5B/OOlxKA19Ai5BfGNOtt9bP7CWSZvtG52PdD5Vkocm2xC3xNn/ADHD5zWJw7stbM8Z8mNN3+DJJEiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767637497; c=relaxed/simple;
	bh=29V3nPy6eJu/bhkMjbdH03w6SXwDnxJzaFIcAXMbrJI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ozce28olWLbCf1zNViWrH7qhn7ITY6dVGl2iatamwRnIR+x1pWRgNc6E3qlj8bYTFzBUF5AufFqKfSRaUm6+aO9p8BUzt4pahmtH2h0P368HNj1nAsbH5xCS9jcXcgaTuSsJb4Cpm8ed5apFFvgmnypKWvF4NDICZ2DjrWCyBO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 5 Jan 2026 18:23:41 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767637456;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YUU6nk2pVRwB0+dTQNl94WlC0B8Ka7nFN+gIz226+k8=;
	b=O1UxU7h7AtNcz7vnL3wMYZsYzkomreORbFiyGkGG/USwrfw1whwon5+8jGkFcGN1AtPHXB
	iEl7AL3MEt32YmWtM4wh2mgk9CB216tp/AeBwVg/i5ZslVJt/t5kxrDseoLvcBslAfvbHv
	th0x1hUPcPVLVGC23DuWV1KabApZFns=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] x86: Increase the timeout for
 vmx_pf_{vpid/no_vpid/invvpid}_test
Message-ID: <6fltlvsnlbqyw3sme2zamsxp2u54tkoauydeoq2v3rri6r2uja@lmxwn57ll5ta>
References: <20260102183039.496725-1-yosry.ahmed@linux.dev>
 <aVv6xaI0hYwgB0ce@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aVv6xaI0hYwgB0ce@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 05, 2026 at 09:54:13AM -0800, Sean Christopherson wrote:
> On Fri, Jan 02, 2026, Yosry Ahmed wrote:
> > When running the tests on some older CPUs (e.g. Skylake) on a kernel
> > with some debug config options enabled (e.g. CONFIG_DEBUG_VM,
> > CONFIG_PROVE_LOCKING, ..), the tests timeout. In this specific setup,
> > the tests take between 4 and 5 minutes, so pump the timeout from 4 to 6
> > minutes.
> 
> Ugh.  Can anyone think of a not-insane way to skip these tests when running in
> an environment that is going to be sloooooow?  Because (a) a 6 minute timeout
> could very well hide _real_ KVM bugs, e.g. if is being too aggressive with TLB
> flushes (speaking from experience) and (b) running a 5+ minute test is a likely
> a waste of time/resources.

The definition of a slow enviroment is also very dynamic, I don't think
we want to play whack-a-mole with config options or runtime knobs that
would make the tests slow.

I don't like just increasing the timeout either, but the tests are slow
even without these specific config options. They only make them a little
bit slower, enough to consistently reproduce the timeout.

I grabbed an Icelake machine With v6.18 (without the debug config
options mentioned above) and ran a couple of them (I still have some
debug config options enabled like CONFIG_SLUB_DEBUG, but I suspect some
of these are enabled by default):

# time ./vmx_pf_invvpid_test <<<y
...
PASS vmx_pf_invvpid_test (38338679 tests)

real	4m28.907s
user	2m40.198s
sys	1m47.991s

# time ./vmx_pf_vpid_test <<<y
...
PASS vmx_pf_vpid_test (38338679 tests)

real	4m21.043s
user	2m39.916s
sys	1m40.416s

This is also acknowledged by commit ca785dae0dd3 ("vmx: separate VPID
tests"), which introduced the separate targets to increase the timeout.
It mentions the 3 tests taking 12m (so roughly 4m each).  I think the
chosen 4m timeout just had very litle margin. We can make the timeout
5m, but I suspect we may still hit that on some setups (on Skylake with
the debug options, some of the tests take 4m 50s).

> 
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  x86/unittests.cfg | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> > index 522318d32bf6..bb2b9f033b11 100644
> > --- a/x86/unittests.cfg
> > +++ b/x86/unittests.cfg
> > @@ -427,7 +427,7 @@ test_args = "vmx_pf_vpid_test"
> >  qemu_params = -cpu max,+vmx
> >  arch = x86_64
> >  groups = vmx nested_exception nodefault
> > -timeout = 240
> > +timeout = 360
> >  
> >  [vmx_pf_invvpid_test]
> >  file = vmx.flat
> > @@ -435,7 +435,7 @@ test_args = "vmx_pf_invvpid_test"
> >  qemu_params = -cpu max,+vmx
> >  arch = x86_64
> >  groups = vmx nested_exception nodefault
> > -timeout = 240
> > +timeout = 360
> >  
> >  [vmx_pf_no_vpid_test]
> >  file = vmx.flat
> > @@ -443,7 +443,7 @@ test_args = "vmx_pf_no_vpid_test"
> >  qemu_params = -cpu max,+vmx
> >  arch = x86_64
> >  groups = vmx nested_exception nodefault
> > -timeout = 240
> > +timeout = 360
> >  
> >  [vmx_pf_exception_test_reduced_maxphyaddr]
> >  file = vmx.flat
> > -- 
> > 2.52.0.351.gbe84eed79e-goog
> > 

