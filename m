Return-Path: <kvm+bounces-38025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CEDEAA34151
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 15:07:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8362C3ADB76
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 14:04:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99D5B26EA07;
	Thu, 13 Feb 2025 13:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oxL4AOv2"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312E12659FF;
	Thu, 13 Feb 2025 13:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739455177; cv=none; b=bRfGVd3CsHypAikXCK8bKJVq4wnd3fznMBa/hK92HzoxfHCI7pdveoG7D0QgNlcTTBI+g9Lvqtl36A4GDpS26bhD6GXXCiFhXkkKD7KdGKwqu5trvErzNGSDuJ7h+sMBkTVjgiyQ+vRW16LZgop6v5Jybin7Wz1egtQsu3z+Mkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739455177; c=relaxed/simple;
	bh=cDbU7M3nb3YVSOukISqyiklXkeydmb+/cAbnL3ACgMM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n8RqLRTl/We/xLfL+YEi914WduYOIC/mbApVTA7p5Y8tVT69b2mfDOU2RsOtzMaUICcfKN0zrF+k/f8kw2ffk7B/kwpBe3VO9lqxcHUKYuWs0x0CxILvu66PIZX18+fzgbpcYh4GLj0FfG1yCXDUZ54HgkI3oe7hJ+mnj2tHkFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oxL4AOv2; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 13 Feb 2025 14:59:19 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739455163;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=quCNt3rENXxq12lVNZV7KFjjQFYvI9uo2HoGXNuB/os=;
	b=oxL4AOv2PByqQJRmy2LV/aaLcm7zlaNJBU3a6mZ4KiT1XwSVG9tf4Z3GzbapebfxcHiqJx
	A7DPMUZTuDaWda9Ms+5FMzarxZGNtmgIgBHFlsikf73RqRVlrke009F2yKj0xwukbdTbKX
	kTUfgGhAYWnCki1zK3SlWOvzxZvLrdU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com, david@redhat.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org, 
	oliver.upton@linux.dev, suzuki.poulose@arm.com, yuzenghui@huawei.com, joey.gouly@arm.com, 
	andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 15/18] Add kvmtool_params to test
 specification
Message-ID: <20250213-a6741ec8fd32c34500327176@orel>
References: <20250120164316.31473-1-alexandru.elisei@arm.com>
 <20250120164316.31473-16-alexandru.elisei@arm.com>
 <20250123-bbd289cfd7abfd93e9b67eef@orel>
 <Z6tmrX8/+wzeFL1P@arm.com>
 <20250212-77a312138f8b5931553ece38@orel>
 <Z6zNpF6mi5GgeDFE@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6zNpF6mi5GgeDFE@arm.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 12, 2025 at 04:34:44PM +0000, Alexandru Elisei wrote:
> Hi Drew,
> 
> On Wed, Feb 12, 2025 at 04:56:42PM +0100, Andrew Jones wrote:
> > On Tue, Feb 11, 2025 at 03:03:09PM +0000, Alexandru Elisei wrote:
> > > Hi Drew,
> > > 
> > > On Thu, Jan 23, 2025 at 04:53:29PM +0100, Andrew Jones wrote:
> > > > On Mon, Jan 20, 2025 at 04:43:13PM +0000, Alexandru Elisei wrote:
> > > > > arm/arm64 supports running tests under kvmtool, but kvmtool's syntax for
> > > > > running a virtual machine is different than qemu's. To run tests using the
> > > > > automated test infrastructure, add a new test parameter, kvmtool_params.
> > > > > The parameter serves the exact purpose as qemu_params/extra_params, but using
> > > > > kvmtool's syntax.
> > > > 
> > > > The need for qemu_params and kvmtool_params makes more sense to me now
> > > > that I see the use in unittests.cfg (I wonder if we can't rearrange this
> > > > series to help understand these things up front?). There's a lot of
> > > 
> > > Certainly, I'll move it closer to the beginning of the series.
> > > 
> > > > duplication, though, with having two sets of params since the test-
> > > > specific inputs always have to be duplicated. To avoid the duplication
> > > > I think we can use extra_params for '-append' and '--params' by
> > > > parametrizing the option name for "params" (-append / --params) and then
> > > > create qemu_opts and kvmtool_opts for extra options like --pmu, --mem,
> > > > and irqchip.
> > > 
> > > How about something like this (I am using selftest-setup as an example, all the
> > > other test definitions would be similarly modified):
> > > 
> > > diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> > > index 2bdad67d5693..3009305ba2d3 100644
> > > --- a/arm/unittests.cfg
> > > +++ b/arm/unittests.cfg
> > > @@ -15,7 +15,9 @@
> > >  [selftest-setup]
> > >  file = selftest.flat
> > >  smp = 2
> > > -extra_params = -m 256 -append 'setup smp=2 mem=256'
> > > +test_args = setup smp=2 mem=256
> > > +qemu_params = -m 256
> > > +kvmtool_params = --mem 256
> > >  groups = selftest
> > > 
> > > I was thinking about using 'test_args' instead of 'extra_params' to avoid any
> > > confusion between the two, and to match how they are passed to a test
> > > - they are in the argv main's argument.
> > 
> > Yes, this looks good and test_args is better than my suggestion in the
> > other mail of 'cmdline_options' since "cmdline" would be ambiguous with
> > the test's cmdline and the vmm's cmdline.
> > 
> > > 
> > > Also, should I change the test definitions for all the other architectures?
> > > It's not going to be possible for me to test all the changes.
> > 
> > We should be safe with an s/extra_params/qemu_params/ change for all
> > architectures and CI is pretty good, so we'd have good confidence
> > if it passes, but, I think we should keep extra_params as a qemu_params
> > alias anyway since it's possible that people have wrapped kvm-unit-tests
> > in test harnesses which generate unittests.cfg files.
> 
> Sounds good, split extra_params into test_args and qemu_params in all
> unittests.cfg files, and keep extra_params as an alias for qemu_params.
> 
> I was thinking that maybe I should send that as a separate patch, to make
> sure it gets the visibility it deserves from the other maintainers, instead
> of it being buried in a 18 patch series. What do you think?

Sounds good.

Thanks,
drew

