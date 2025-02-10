Return-Path: <kvm+bounces-37706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A71C2A2F65A
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 19:05:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD0BF3A40A4
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 18:04:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64F96255E38;
	Mon, 10 Feb 2025 18:04:40 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD4AB24FC17;
	Mon, 10 Feb 2025 18:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739210679; cv=none; b=rX6pmaNkZg672zVEM4Bg80Ic7H7HidlrF26UcUcqjHAHWkdFqXvhiViWQALInPqWLRGmx9j/ghTmIqU6CRw68/upMR/2gmGtulpQUZwXItCcnHBxEJVPsVuYXBbVtukWE6NEPH3Ed6NKSvXFfrwyG9rEqooDfCSYiFUiubcg8E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739210679; c=relaxed/simple;
	bh=ksvS5XX7xX64IlxGvydgg2Jy1f9U1hAJdVFTbzlcyK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NFBUc/pzE+i/tALVvNI+EQWbVJZFQlFJ/BsniIBTCzX83LYy8xDpAWBWFXAOmwFLIvyKMR9SG2Pb7Xop0IQXHXQUGaWkS1gma9PXg8Mmi8VY6acyY3wqGBtdeysiClbfYWUGzLBA+ZunisjCpHHG7yUmPRhZjQcXn71jCCSIOuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D671B1477;
	Mon, 10 Feb 2025 10:04:58 -0800 (PST)
Received: from arm.com (e134078.arm.com [10.1.26.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 58DAB3F58B;
	Mon, 10 Feb 2025 10:04:32 -0800 (PST)
Date: Mon, 10 Feb 2025 18:04:29 +0000
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
Subject: Re: [kvm-unit-tests PATCH v2 03/18] scripts: Refuse to run the tests
 if not configured for qemu
Message-ID: <Z6o/rbweZttGReir@arm.com>
References: <20250120164316.31473-1-alexandru.elisei@arm.com>
 <20250120164316.31473-4-alexandru.elisei@arm.com>
 <20250121-45faf6a9a9681c7c9ece5f44@orel>
 <Z6nX8YC8ZX9jFiLb@arm.com>
 <20250210-640ff37c16a0dbccb69f08ea@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250210-640ff37c16a0dbccb69f08ea@orel>

Hi Drew,

On Mon, Feb 10, 2025 at 02:56:25PM +0100, Andrew Jones wrote:
> On Mon, Feb 10, 2025 at 10:41:53AM +0000, Alexandru Elisei wrote:
> > Hi Drew,
> > 
> > On Tue, Jan 21, 2025 at 03:48:55PM +0100, Andrew Jones wrote:
> > > On Mon, Jan 20, 2025 at 04:43:01PM +0000, Alexandru Elisei wrote:
> > <snip>
> > > > ---
> > > >  arm/efi/run             | 8 ++++++++
> > > >  arm/run                 | 9 +++++++++
> > > >  run_tests.sh            | 8 ++++++++
> > > >  scripts/mkstandalone.sh | 8 ++++++++
> > > >  4 files changed, 33 insertions(+)
> > <snip>
> > > > +case "$TARGET" in
> > > > +qemu)
> > > > +    ;;
> > > > +*)
> > > > +    echo "'$TARGET' not supported for standlone tests"
> > > > +    exit 2
> > > > +esac
> > > 
> > > I think we could put the check in a function in scripts/arch-run.bash and
> > > just use the same error message for all cases.
> > 
> > Coming back to the series.
> > 
> > arm/efi/run and arm/run source scripts/arch-run.bash; run_tests.sh and
> > scripts/mkstandalone.sh don't source scripts/arch-run.bash. There doesn't
> > seem to be a common file that is sourced by all of them.
> 
> scripts/mkstandalone.sh uses arch-run.bash, see generate_test().

Are you referring to this bit:

generate_test ()
{
	<snip>
        (echo "#!/usr/bin/env bash"
         cat scripts/arch-run.bash "$TEST_DIR/run")

I think scripts/arch-run.bash would need to be sourced for any functions defined
there to be usable in mkstandalone.sh.

What I was thinking is something like this:

if ! vmm_supported $TARGET; then
	echo "$0 does not support '$TARGET'"
	exit 2
fi

Were you thinking of something else?

I think mkstandalone should error at the top level (when you do make
standalone), and not rely on the individual scripts to error if the VMM is
not supported. That's because I think creating the test files, booting a
machine and copying the files only to find out that kvm-unit-tests was
misconfigured is a pretty suboptimal experience.

> run_tests.sh doesn't, but I'm not sure it needs to validate TARGET
> since it can leave that to the lower-level scripts.

I put the check in arm/run, and removed it from run_tests.sh, and this is
what I got:

$ ./run_tests.sh selftest-setup
SKIP selftest-setup (./arm/run does not supported 'kvmtool')

which looks good to me.

> 
> > 
> > How about creating a new file in scripts (vmm.bash?) with only this
> > function?
> 
> If we need a new file, then we can add one, but I'd try using
> arch-run.bash or common.bash first.

common.bash seems to work (and the name fits), so I'll give that a go.

Thanks,
Alex

