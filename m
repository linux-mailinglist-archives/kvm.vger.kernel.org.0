Return-Path: <kvm+bounces-37689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F666A2E9CA
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 11:42:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D943167BA3
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 10:42:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 306131CCEE7;
	Mon, 10 Feb 2025 10:42:09 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3235D1CAA9E;
	Mon, 10 Feb 2025 10:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739184128; cv=none; b=fsCLLsbPbSP5gctjQI2t3/bIBYCfab7qdYihg6pMG1bprYh4dl+a61Yb17WcIDmbr497+F02ceqKXGDd08iXhtwHesE9CA8EhberYHktfzJZrP+sBtDc2mCvKE3TMR8sEoJoafAltkcqGr7IRiWA7vxhL4nxfm67dV85q/c921k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739184128; c=relaxed/simple;
	bh=jq/HIHgfHgdifwYmPIbidSugf6VXqeVQV7y6gzurIYg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f/jeY5ayqCsUy+BShejtWzsQJJexGYXT3UOo7MzIkRY/cM17c3itL/+GCVYIa7tcn4mUEOCFI8p8db20jkmuDjNL3MsPqEx3pC88zt/a3wxpBOuSFC+9xFzu5J+sUJm6Aov0i19ftlVJkEkAbEHKDxiacu1QVJWARh0is3r+Hn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 35AA11BA8;
	Mon, 10 Feb 2025 02:42:27 -0800 (PST)
Received: from arm.com (unknown [10.57.76.200])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 510A33F58B;
	Mon, 10 Feb 2025 02:41:58 -0800 (PST)
Date: Mon, 10 Feb 2025 10:41:53 +0000
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
Message-ID: <Z6nX8YC8ZX9jFiLb@arm.com>
References: <20250120164316.31473-1-alexandru.elisei@arm.com>
 <20250120164316.31473-4-alexandru.elisei@arm.com>
 <20250121-45faf6a9a9681c7c9ece5f44@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250121-45faf6a9a9681c7c9ece5f44@orel>

Hi Drew,

On Tue, Jan 21, 2025 at 03:48:55PM +0100, Andrew Jones wrote:
> On Mon, Jan 20, 2025 at 04:43:01PM +0000, Alexandru Elisei wrote:
<snip>
> > ---
> >  arm/efi/run             | 8 ++++++++
> >  arm/run                 | 9 +++++++++
> >  run_tests.sh            | 8 ++++++++
> >  scripts/mkstandalone.sh | 8 ++++++++
> >  4 files changed, 33 insertions(+)
<snip>
> > +case "$TARGET" in
> > +qemu)
> > +    ;;
> > +*)
> > +    echo "'$TARGET' not supported for standlone tests"
> > +    exit 2
> > +esac
> 
> I think we could put the check in a function in scripts/arch-run.bash and
> just use the same error message for all cases.

Coming back to the series.

arm/efi/run and arm/run source scripts/arch-run.bash; run_tests.sh and
scripts/mkstandalone.sh don't source scripts/arch-run.bash. There doesn't
seem to be a common file that is sourced by all of them.

How about creating a new file in scripts (vmm.bash?) with only this
function?

Thanks,
Alex

> 
> Thanks,
> drew
> 
> > 
> > -- 
> > kvm-riscv mailing list
> > kvm-riscv@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/kvm-riscv

