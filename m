Return-Path: <kvm+bounces-36146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 37F17A181EC
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 17:21:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E601B188B57C
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 16:21:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 112781F4E21;
	Tue, 21 Jan 2025 16:21:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAEF01F470A;
	Tue, 21 Jan 2025 16:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737476463; cv=none; b=iOSbKI9W0vCKx8XXPKJreh2TZ2tUf2u7XO3Z3Ls8mzpWMABt3PDRoIESY69HxxSjTz2TMBt9W53ecgssmkJodCvO16lIxEMyPi3h+CJH87qUS6vnPaWGcJzNgw5Fmdi1zRlickts8ppsoiTkveqfI2LQeih/jrs2/3hp45qXWyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737476463; c=relaxed/simple;
	bh=ROtIQ8u3GuBK/uJn7uqD5tIKIlyFZnf0aLf9S7bCHoE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ITlf0c8++t6GmAgIYBFh6GbYeaGr3jRpVSsBRt5bWBeUMambsZ7oQupwC3NSmcJBRtQMajrXIjUUUbHpdqd5ELJaVqLu1La3SR3fv9Pl9KWIaiyD6F5OPtqSsJaVwXWYlBMOT2ei+wSGPEwSgRzJX0BygRtt3Yz4ZRarxm2omYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7A531106F;
	Tue, 21 Jan 2025 08:21:27 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BFD103F738;
	Tue, 21 Jan 2025 08:20:55 -0800 (PST)
Date: Tue, 21 Jan 2025 16:20:53 +0000
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
Message-ID: <Z4_JZUYtQciBnnzd@raptor>
References: <20250120164316.31473-1-alexandru.elisei@arm.com>
 <20250120164316.31473-4-alexandru.elisei@arm.com>
 <20250121-45faf6a9a9681c7c9ece5f44@orel>
 <Z4_DKTMeDQqsqV_6@raptor>
 <20250121-c7f5ba2a25ccbfe793da07f6@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250121-c7f5ba2a25ccbfe793da07f6@orel>

Hi Drew,

On Tue, Jan 21, 2025 at 05:17:22PM +0100, Andrew Jones wrote:
> On Tue, Jan 21, 2025 at 03:54:17PM +0000, Alexandru Elisei wrote:
> > Hi Drew,
> > 
> > On Tue, Jan 21, 2025 at 03:48:55PM +0100, Andrew Jones wrote:
> > > On Mon, Jan 20, 2025 at 04:43:01PM +0000, Alexandru Elisei wrote:
> > > > Arm and arm64 support running the tests under kvmtool. Unsurprisingly,
> > > > kvmtool and qemu have a different command line syntax for configuring and
> > > > running a virtual machine.
> > > > 
> > > > On top of that, when kvm-unit-tests has been configured to run under
> > > > kvmtool (via ./configure --target=kvmtool), the early UART address changes,
> > > > and if then the tests are run with qemu, this warning is displayed:
> > > > 
> > > > WARNING: early print support may not work. Found uart at 0x9000000, but early base is 0x1000000.
> > > > 
> > > > At the moment, the only way to run a test under kvmtool is manually, as no
> > > > script has any knowledge of how to invoke kvmtool. Also, unless one looks
> > > > at the logs, it's not obvious that the test runner is using qemu to run the
> > > > tests, and not kvmtool.
> > > > 
> > > > To avoid any confusion for unsuspecting users, refuse to run a test via the
> > > > testing scripts when kvm-unit-tests has been configured for kvmtool.
> > > > 
> > > > There are four different ways to run a test using the test infrastructure:
> > > > with run_tests.sh, by invoking arm/run or arm/efi/run with the correct
> > > > parameters (only the arm directory is mentioned here because the tests can
> > > > be configured for kvmtool only on arm and arm64), and by creating
> > > > standalone tests. Add a check in each of these locations for the supported
> > > > virtual machine manager.
> > > > 
> > > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > > > ---
> > > >  arm/efi/run             | 8 ++++++++
> > > >  arm/run                 | 9 +++++++++
> > > >  run_tests.sh            | 8 ++++++++
> > > >  scripts/mkstandalone.sh | 8 ++++++++
> > > >  4 files changed, 33 insertions(+)
> > > > 
> > > > diff --git a/arm/efi/run b/arm/efi/run
> > > > index 8f41fc02df31..916f4c4deef6 100755
> > > > --- a/arm/efi/run
> > > > +++ b/arm/efi/run
> > > > @@ -12,6 +12,14 @@ fi
> > > >  source config.mak
> > > >  source scripts/arch-run.bash
> > > >  
> > > > +case "$TARGET" in
> > > > +qemu)
> > > > +    ;;
> > > > +*)
> > > > +    echo "$0 does not support '$TARGET'"
> > > > +    exit 2
> > > > +esac
> > > > +
> > > >  if [ -f /usr/share/qemu-efi-aarch64/QEMU_EFI.fd ]; then
> > > >  	DEFAULT_UEFI=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd
> > > >  elif [ -f /usr/share/edk2/aarch64/QEMU_EFI.silent.fd ]; then
> > > > diff --git a/arm/run b/arm/run
> > > > index efdd44ce86a7..6db32cf09c88 100755
> > > > --- a/arm/run
> > > > +++ b/arm/run
> > > > @@ -8,6 +8,15 @@ if [ -z "$KUT_STANDALONE" ]; then
> > > >  	source config.mak
> > > >  	source scripts/arch-run.bash
> > > >  fi
> > > > +
> > > > +case "$TARGET" in
> > > > +qemu)
> > > > +    ;;
> > > > +*)
> > > > +   echo "'$TARGET' not supported"
> > > > +   exit 3
> > > 
> > > I think we want exit code 2 here.
> > 
> > Exit code 2 is already in use in arm/run. Now that I'm looking more closely
> > at it, exit code 2 is already in use in run_tests.sh, same for
> > mkstandalone.sh and arm/efi/run.
> > 
> > How about using 3 everywhere as the exit code?
> >
> 
> In kvm-unit-tests, exit code 2 is what we use for "most likely a run
> script failed" (see the comment above run_qemu() in
> scripts/arch-run.bash). We don't try to create a new error code for each
> type of error, but we do have the error message as well. So if there's a
> higher level runner, which runs this runner, it only needs to learn that
> 2 is likely a script failure and that an error message will hopefully
> point the way to the problem.
> 

I see, I missed the comment. Will change so it returns 2 everywhere.

Thanks,
Alex

