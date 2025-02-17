Return-Path: <kvm+bounces-37974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EAF09A32BF2
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 17:38:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D31CB3A6AB1
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 16:36:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3453E2566CA;
	Wed, 12 Feb 2025 16:34:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F822212FB3;
	Wed, 12 Feb 2025 16:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739378092; cv=none; b=r2l8OAqZBN6xoT0Tox5oX5NnIOU16bqGiAPYgKHX6n2BNhIQ4r/Vb8c3KCzh6j2mynQfHXho5TicfXG4piMMA/gkYjkQAUiAmGlqKo5D00UOWqRZcR6efEF2Q9lfP/uvGjsa7/gJybLkTkNthDqOvPzGFYzW2Zv/oSo20+p2y2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739378092; c=relaxed/simple;
	bh=TvtA1d1cT7/MZgNwAvM5eJcnU3L6rwnf2MzymgjvGVY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZOhCh0VujeHlsueKDasE9B+tXCkX2/a9u+PSc0oIyIzV+ogaGP9wbIrlmMLxXnlwKPFP+4qStEU65Peyb9TGLqBVX+JgtvjpCac5ogCT3iuygndVVIxUQEojMcRvKId/ikkkHboCwLbF2z6qTm37gCe7rBGtFf4SMdH+PvHgNMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DC21912FC;
	Wed, 12 Feb 2025 08:35:10 -0800 (PST)
Received: from arm.com (e134078.arm.com [10.1.26.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C7C1F3F6A8;
	Wed, 12 Feb 2025 08:34:46 -0800 (PST)
Date: Wed, 12 Feb 2025 16:34:44 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com,
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
	david@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
	oliver.upton@linux.dev, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joey.gouly@arm.com, andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 15/18] Add kvmtool_params to test
 specification
Message-ID: <Z6zNpF6mi5GgeDFE@arm.com>
References: <20250120164316.31473-1-alexandru.elisei@arm.com>
 <20250120164316.31473-16-alexandru.elisei@arm.com>
 <20250123-bbd289cfd7abfd93e9b67eef@orel>
 <Z6tmrX8/+wzeFL1P@arm.com>
 <20250212-77a312138f8b5931553ece38@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250212-77a312138f8b5931553ece38@orel>

Hi Drew,

On Wed, Feb 12, 2025 at 04:56:42PM +0100, Andrew Jones wrote:
> On Tue, Feb 11, 2025 at 03:03:09PM +0000, Alexandru Elisei wrote:
> > Hi Drew,
> > 
> > On Thu, Jan 23, 2025 at 04:53:29PM +0100, Andrew Jones wrote:
> > > On Mon, Jan 20, 2025 at 04:43:13PM +0000, Alexandru Elisei wrote:
> > > > arm/arm64 supports running tests under kvmtool, but kvmtool's syntax for
> > > > running a virtual machine is different than qemu's. To run tests using the
> > > > automated test infrastructure, add a new test parameter, kvmtool_params.
> > > > The parameter serves the exact purpose as qemu_params/extra_params, but using
> > > > kvmtool's syntax.
> > > 
> > > The need for qemu_params and kvmtool_params makes more sense to me now
> > > that I see the use in unittests.cfg (I wonder if we can't rearrange this
> > > series to help understand these things up front?). There's a lot of
> > 
> > Certainly, I'll move it closer to the beginning of the series.
> > 
> > > duplication, though, with having two sets of params since the test-
> > > specific inputs always have to be duplicated. To avoid the duplication
> > > I think we can use extra_params for '-append' and '--params' by
> > > parametrizing the option name for "params" (-append / --params) and then
> > > create qemu_opts and kvmtool_opts for extra options like --pmu, --mem,
> > > and irqchip.
> > 
> > How about something like this (I am using selftest-setup as an example, all the
> > other test definitions would be similarly modified):
> > 
> > diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> > index 2bdad67d5693..3009305ba2d3 100644
> > --- a/arm/unittests.cfg
> > +++ b/arm/unittests.cfg
> > @@ -15,7 +15,9 @@
> >  [selftest-setup]
> >  file = selftest.flat
> >  smp = 2
> > -extra_params = -m 256 -append 'setup smp=2 mem=256'
> > +test_args = setup smp=2 mem=256
> > +qemu_params = -m 256
> > +kvmtool_params = --mem 256
> >  groups = selftest
> > 
> > I was thinking about using 'test_args' instead of 'extra_params' to avoid any
> > confusion between the two, and to match how they are passed to a test
> > - they are in the argv main's argument.
> 
> Yes, this looks good and test_args is better than my suggestion in the
> other mail of 'cmdline_options' since "cmdline" would be ambiguous with
> the test's cmdline and the vmm's cmdline.
> 
> > 
> > Also, should I change the test definitions for all the other architectures?
> > It's not going to be possible for me to test all the changes.
> 
> We should be safe with an s/extra_params/qemu_params/ change for all
> architectures and CI is pretty good, so we'd have good confidence
> if it passes, but, I think we should keep extra_params as a qemu_params
> alias anyway since it's possible that people have wrapped kvm-unit-tests
> in test harnesses which generate unittests.cfg files.

Sounds good, split extra_params into test_args and qemu_params in all
unittests.cfg files, and keep extra_params as an alias for qemu_params.

I was thinking that maybe I should send that as a separate patch, to make
sure it gets the visibility it deserves from the other maintainers, instead
of it being buried in a 18 patch series. What do you think?

Thanks,
Alex

