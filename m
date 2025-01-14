Return-Path: <kvm+bounces-35363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D7C12A102E5
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 10:21:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E56701684F8
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 09:21:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BE541C07DC;
	Tue, 14 Jan 2025 09:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="e2H+XIWW"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EEF22DC5B
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 09:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736846471; cv=none; b=c6i8if8gQl+qoxALHTpQ93mkQoiXciH4Ljw1oy7yXErEWgzJWLnt4qYiDKKOH7yqe9yJ6Ao0iFNdL9NIFIDL4Wx2Q8lEz3k+SizkEKtDMhtNjzMMlgFIq8Q3KDIaBT5BLXFDJUXsWkQLeiwI7yrfJMShTthlidcoGpb1OUS4uN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736846471; c=relaxed/simple;
	bh=9oAZXD3/7PWIdfudQHXuu4TBXO7gQxBOlaBt3H1WgPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ckFv7I2duFnXNBrUDqX/Bj6vnofUvZMeI/DsDkzQ+Y4hv8S1aBgm7lcQgojnfxBAsb5pGz3uq2vom5wtnVO7BVXr8G2qZ8te20WaunoFqM992txxpGFjljeblGnuBDFQF8x7ZPAlC/KUcsLf6fJsWcgXWTYpVRZnQ2XaTeHWfBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=e2H+XIWW; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 14 Jan 2025 10:20:52 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736846456;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bC5LAEj9vdeso+b9F/95zLGevwbLF2e12tr8g2iY4Vo=;
	b=e2H+XIWWtIh0UPwpjTED/no4d+apsSr1Qdwy+7mbM+WPJ0qOLdF36jo0mfn9GFE5wAsVYE
	ZnT5ulKmLHh7pO8rysCbghfdHdN7P+bmKnJfAX5Eb0e7qaa4W8xnhGw6ZT5auTNP8M2CG9
	xGivIi3fmZbBdhkOwutGgRBIkvBX4Og=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Jon Kohler <jon@nutanix.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, 
	Thomas Huth <thuth@redhat.com>, Nicholas Piggin <npiggin@gmail.com>, 
	Eric Auger <eric.auger@redhat.com>, Nina Schoetterl-Glausch <nsg@linux.ibm.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH] Makefile: add portable mode
Message-ID: <20250114-aa3c045d70769ae051f3b144@orel>
References: <20250105175723.2887586-1-jon@nutanix.com>
 <Z4UQKTLWpVs5RNbA@arm.com>
 <806860A3-4538-4BC3-B6B9-FA5118990D78@nutanix.com>
 <20250113-e645de551c7279ba77e4fb74@orel>
 <3F7065A3-DB24-48C5-BD5D-05D98AF8E3E4@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3F7065A3-DB24-48C5-BD5D-05D98AF8E3E4@nutanix.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 13, 2025 at 08:53:40PM +0000, Jon Kohler wrote:
> 
> 
> > On Jan 13, 2025, at 10:36 AM, Andrew Jones <andrew.jones@linux.dev> wrote:
> > 
> > !-------------------------------------------------------------------|
> >  CAUTION: External Email
> > 
> > |-------------------------------------------------------------------!
> > 
> > On Mon, Jan 13, 2025 at 02:49:11PM +0000, Jon Kohler wrote:
> >> 
> >> 
> >>> On Jan 13, 2025, at 8:07 AM, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> >>> 
> >>> !-------------------------------------------------------------------|
> >>> CAUTION: External Email
> >>> 
> >>> |-------------------------------------------------------------------!
> >>> 
> >>> Hi,
> >>> 
> >>> On Sun, Jan 05, 2025 at 10:57:23AM -0700, Jon Kohler wrote:
> >>>> Add a 'portable' mode that packages all relevant flat files and helper
> >>>> scripts into a tarball named 'kut-portable.tar.gz'.
> >>>> 
> >>>> This mode is useful for compiling tests on one machine and running them
> >>>> on another without needing to clone the entire repository. It allows
> >>>> the runner scripts and unit test configurations to remain local to the
> >>>> machine under test.
> >>> 
> >>> Have you tried make standalone? You can then copy the tests directory, or even a
> >>> particular test.
> >> 
> >> Yes, standalone does not work when copying tests from one host to another. The
> >> use case for portable mode is to be able to compile within one environment and
> >> test in completely separate environment. I was not able to accomplish that with
> >> standalone mode by itself.
> >> 
> > 
> > standalone scripts should be portable. If they're missing something, then
> > we should fix that. Also 'make install' should include everything
> > necessary, otherwise it should be fixed. Then, we could consider adding
> > another target like 'make package' which would do 'make install' to a
> > temporary directory and tar/gzip or whatever the installation into a
> > package.
> 
> Thanks, Drew. The standalone scripts are not portable in my experience, as
> in I can not just pick them up, copy them as is, and put them on another host
> with different directory layouts, etc (and importantly, no kvm-unit-tests repo
> whatsoever). 

They should work without a kvm-unit-tests repo (they used to anyway). If
they're not working when moved to a host that doesn't have anything except
bash and qemu, then we should fix them. Which architecture are you mainly
testing?

> 
> The make package idea is effectively what I’m doing here, but it happens to
> use the word portable instead of package (and not using make install to do
> the data movement).

I know, but I'm suggesting that we do use 'make install' rather than
introduce an independent target which should be 'make install' plus
packaging. We don't want to maintain multiple independent targets
which do almost the same thing.

> 
> That bit is important:
> The biggest tidbit is that things like the errata path is hard coded, so
> in my “make portable” it fixes those things to be not hard coded, and all is well
> after files are tar’d up and then untar'd later.

So let's fix 'make install' to make sure nothing installed has hard coded
paths (which standalone should do, since it should only depend on /tmp)

> 
> Also, in standalone mode, you’d be missing the runner scripts, etc, so it
> makes it harder to tweak and iterate locally on the system under test.

standalone scripts don't need the run_tests.sh since they include
everything from unittests.cfg already. It probably would make sense
to provide a script that allows running all or a subset of tests at
once, which would just be a for-loop, e.g.

  run_subset() { for t in ${tests}/${1} ${tests}/${1}_*; do [ -e $t ] && $t; done; }

Running tests with different parameters than what are specified in the
unittests.cfg file isn't currently possible, unless they're also
configurable with environment variables like MACHINE, ACCEL, TIMEOUT,
and MAX_SMP. If more configuration changes are necessary, then a make
target for packaging $TEST_DIR/run and the .flat files is probably the
right way to go, but it still isn't clear to me if that's what you're
trying to do.

> 
> Happy to take guidance if I’m missing something painfully obvious with the
> existing standalone setup (I felt this way when I started looking at this!) as it
> doesn’t do what I’d think it would do.

There's a good chance that standalone hasn't been maintained along with
the rest of the scripts, since we don't currently have a CI test for it.
But, unless you need to modify test parameters, then we should try to
fix it (and add CI for it).

Thanks,
drew

