Return-Path: <kvm+bounces-9380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E33E085F693
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 12:11:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1AC7D1C22671
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 11:11:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D526841232;
	Thu, 22 Feb 2024 11:11:38 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9391C182D2;
	Thu, 22 Feb 2024 11:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708600298; cv=none; b=ApqqNi0ZlzvezPuCJxMdC5xXXr+yfA0yKEOK0kBnpYXptKPeszY+28uGd9pxJrAuliYSTumpShgaSioMrxenXoCnhCM2OO4m1dlUbXw8CwhptS7ngikqRSHKKttI00fIb/NHOO1ViDlXpdXaCLD79H2/rKt9dy4Ab9ssdWP8pKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708600298; c=relaxed/simple;
	bh=Tec7Nco+P+UIw3l5ulA/FSj9KnCgvAvY+cEhEynMvgU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HlltaALqyzkqzNGRh2ZW/02PSqRqG+QWtu4Xq8iV6MvEyrefebvf6jIK5zM9w7QsK5wtvE+TrxLvOB4FlflvnD1I8pxKcjHo33ewuwVOieOqs53kGkBBdrYGAw06MHZHJDxvuu39EO6yw1OoJnWvPASzEq61UutW81MusgCfp90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5A1951007;
	Thu, 22 Feb 2024 03:12:14 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0268B3F73F;
	Thu, 22 Feb 2024 03:11:34 -0800 (PST)
Date: Thu, 22 Feb 2024 11:11:29 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Christoffer Dall <cdall@cs.columbia.edu>,
	Marc Zyngier <maz@kernel.org>, KVM <kvm@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the kvm-arm tree
Message-ID: <20240222111129.GA946362@e124191.cambridge.arm.com>
References: <20240222220349.1889c728@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240222220349.1889c728@canb.auug.org.au>

On Thu, Feb 22, 2024 at 10:03:49PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the kvm tree, today's linux-next build (arm64 defconfig)
> failed like this:
> 
> In file included from <command-line>:
> In function 'check_res_bits',
>     inlined from 'kvm_sys_reg_table_init' at arch/arm64/kvm/sys_regs.c:4109:2:
> include/linux/compiler_types.h:449:45: error: call to '__compiletime_assert_591' declared with attribute error: BUILD_BUG_ON failed: ID_AA64DFR1_EL1_RES0 != (GENMASK_ULL(63, 0))
>   449 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>       |                                             ^
> include/linux/compiler_types.h:430:25: note: in definition of macro '__compiletime_assert'
>   430 |                         prefix ## suffix();                             \
>       |                         ^~~~~~
> include/linux/compiler_types.h:449:9: note: in expansion of macro '_compiletime_assert'
>   449 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>       |         ^~~~~~~~~~~~~~~~~~~
> include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
>    39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>       |                                     ^~~~~~~~~~~~~~~~~~
> include/linux/build_bug.h:50:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
>    50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
>       |         ^~~~~~~~~~~~~~~~
> arch/arm64/kvm/check-res-bits.h:58:9: note: in expansion of macro 'BUILD_BUG_ON'
>    58 |         BUILD_BUG_ON(ID_AA64DFR1_EL1_RES0       != (GENMASK_ULL(63, 0)));
>       |         ^~~~~~~~~~~~
> 
> I bisected this to the merge of the kvm-arm tree into linux-next but I
> could not figure out why it fails :-(
> 
> -- 
> Cheers,
> Stephen Rothwell

This fails because https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/commit/?id=fdd867fe9b32
added new fields to that register (ID_AA64DFR1_EL1)

and commit b80b701d5a6 ("KVM: arm64: Snapshot all non-zero RES0/RES1 sysreg fields for later checking")
took a snapshot of the fields, so the RES0 (reserved 0) bits don't match anymore.

Not sure how to resolve it in the git branches though.

Thanks,
Joey


