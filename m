Return-Path: <kvm+bounces-41493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EE36A68EE6
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 15:22:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59F3E171451
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 14:18:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A98A1ACEAC;
	Wed, 19 Mar 2025 14:18:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5B6E192D87
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 14:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742393890; cv=none; b=WN+urZCDCpaRK0SVqCMzduR33KXIF0Wyc+9fvMAuMfYdSkYXjKLG+NlnxQItd+wi1hcwJrhRD+1oUtvdyDHnGXq4SzaBEoVfI342R6NOGBGSVbCF64VKiIoakhdW9D11TdJrbPqVAOkH0jikWAjEQ8murDau41U/egj6vM8j0qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742393890; c=relaxed/simple;
	bh=jUrl/975ZQ3roXkjiImKd9VAkQ3S8ElhujNTuWjlkNA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K8IPt/1AnzVNHqjwATjdoddqaEAg/cU4QmzNZ2vuCWO86AxljxYF6HI8z8JcfLXOP6LJaj6NKnEBh/R153m9nRe37JXtiKILJbp3JC/a3zNhhiihZvlZUdDsGIxxBYELrDtCAXVzSmjN7h+do0yuPxxeB/qbERKdmei+yqvFXFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 49AAB113E;
	Wed, 19 Mar 2025 07:18:16 -0700 (PDT)
Received: from donnerap.manchester.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 06A7A3F673;
	Wed, 19 Mar 2025 07:18:06 -0700 (PDT)
Date: Wed, 19 Mar 2025 14:18:04 +0000
From: Andre Przywara <andre.przywara@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, <kvmarm@lists.linux.dev>,
 <kvm@vger.kernel.org>, Will Deacon <will@kernel.org>, Julien Thierry
 <julien.thierry.kdev@gmail.com>, <maz@kernel.org>,
 <jean-philippe@linaro.org>
Subject: Re: [RFC kvmtool 0/9] arm: Drop support for 32-bit kvmtool
Message-ID: <20250319141804.4fee5f5f@donnerap.manchester.arm.com>
In-Reply-To: <Z9f78K-m9h7YlzUr@raptor>
References: <20250314222516.1302429-1-oliver.upton@linux.dev>
	<Z9f78K-m9h7YlzUr@raptor>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 17 Mar 2025 10:39:44 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi,

> Hi Oliver,
> 
> I'm CC'ing Marc and Andre (Andre is the only person that I know for a fact
> that ran 32 bit kvmtool).
> 
> Haven't looked at the patches in detail, but as someone who ocassionally
> contributes to kvmtool, I have to say it's always nice to have fewer things
> to worry about. I, for one, never used 32 bit kvmtool, I just compiled for
> 32 bit arm to make sure it doesn't break.

Well, it's of course always easier to just remove code and features,
especially if one doesn't have a use for this feature in the first place.

But I clearly see that 32-bit host support is *very* niche today,
especially with dropped host kernel support, and that new features like NV
and RME don't apply for that anyway, and are far more important, so I am
fine with letting it go. So long, and thanks for all the fish!

Cheers,
Andre

> If nobody objects to dropping support for 32 bit kvmtool, I'm planning to
> review the patches.
> 
> Thanks,
> Alex
> 
> On Fri, Mar 14, 2025 at 03:25:07PM -0700, Oliver Upton wrote:
> > The last stable kernel to support 32-bit KVM/arm is 5.4, which is on
> > track for EOL at the end of this year. Considering this, and the fact
> > that 32-bit KVM never saw much usage in the first place, it is probably
> > time to toss out the coprolite.
> > 
> > Of course, this has no effect on the support for 32-bit guests on 64-bit
> > KVM.
> > 
> > Oliver Upton (9):
> >   Drop support for 32-bit arm
> >   arm64: Move arm64-only features into main directory
> >   arm64: Combine kvm.c
> >   arm64: Merge kvm-cpu.c
> >   arm64: Combine kvm-config-arch.h
> >   arm64: Move remaining kvm/* headers
> >   arm64: Move asm headers
> >   arm64: Rename top-level directory
> >   arm64: Get rid of the 'arm-common' include directory
> > 
> >  INSTALL                                       |   9 +-
> >  Makefile                                      |  40 +--
> >  arm/aarch32/arm-cpu.c                         |  50 ---
> >  arm/aarch32/include/asm/kernel.h              |   8 -
> >  arm/aarch32/include/asm/kvm.h                 | 311 ------------------
> >  arm/aarch32/include/kvm/barrier.h             |  10 -
> >  arm/aarch32/include/kvm/fdt-arch.h            |   6 -
> >  arm/aarch32/include/kvm/kvm-arch.h            |  18 -
> >  arm/aarch32/include/kvm/kvm-config-arch.h     |   8 -
> >  arm/aarch32/include/kvm/kvm-cpu-arch.h        |  24 --
> >  arm/aarch32/kvm-cpu.c                         | 132 --------
> >  arm/aarch32/kvm.c                             |  14 -
> >  arm/aarch64/include/kvm/fdt-arch.h            |   6 -
> >  arm/aarch64/include/kvm/kvm-arch.h            |  22 --
> >  arm/aarch64/include/kvm/kvm-config-arch.h     |  29 --
> >  arm/aarch64/include/kvm/kvm-cpu-arch.h        |  19 --
> >  arm/aarch64/kvm.c                             | 212 ------------
> >  arm/kvm-cpu.c                                 | 153 ---------
> >  {arm/aarch64 => arm64}/arm-cpu.c              |   4 +-
> >  {arm => arm64}/fdt.c                          |   4 +-
> >  {arm => arm64}/gic.c                          |   2 +-
> >  {arm => arm64}/gicv2m.c                       |   2 +-
> >  {arm/aarch64 => arm64}/include/asm/image.h    |   0
> >  {arm/aarch64 => arm64}/include/asm/kernel.h   |   0
> >  {arm/aarch64 => arm64}/include/asm/kvm.h      |   0
> >  {arm/aarch64 => arm64}/include/asm/pmu.h      |   0
> >  .../include/asm/sve_context.h                 |   0
> >  .../arm-common => arm64/include}/gic.h        |   0
> >  {arm/aarch64 => arm64}/include/kvm/barrier.h  |   0
> >  .../include/kvm}/fdt-arch.h                   |   0
> >  .../include/kvm}/kvm-arch.h                   |   6 +-
> >  .../include/kvm}/kvm-config-arch.h            |  24 +-
> >  .../include/kvm}/kvm-cpu-arch.h               |  10 +-
> >  .../arm-common => arm64/include}/pci.h        |   0
> >  .../arm-common => arm64/include}/timer.h      |   0
> >  {arm => arm64}/ioport.c                       |   0
> >  {arm/aarch64 => arm64}/kvm-cpu.c              | 289 ++++++++++++----
> >  {arm => arm64}/kvm.c                          | 212 +++++++++++-
> >  {arm => arm64}/pci.c                          |   4 +-
> >  {arm/aarch64 => arm64}/pmu.c                  |   2 +-
> >  {arm/aarch64 => arm64}/pvtime.c               |   0
> >  {arm => arm64}/timer.c                        |   4 +-
> >  42 files changed, 495 insertions(+), 1139 deletions(-)
> >  delete mode 100644 arm/aarch32/arm-cpu.c
> >  delete mode 100644 arm/aarch32/include/asm/kernel.h
> >  delete mode 100644 arm/aarch32/include/asm/kvm.h
> >  delete mode 100644 arm/aarch32/include/kvm/barrier.h
> >  delete mode 100644 arm/aarch32/include/kvm/fdt-arch.h
> >  delete mode 100644 arm/aarch32/include/kvm/kvm-arch.h
> >  delete mode 100644 arm/aarch32/include/kvm/kvm-config-arch.h
> >  delete mode 100644 arm/aarch32/include/kvm/kvm-cpu-arch.h
> >  delete mode 100644 arm/aarch32/kvm-cpu.c
> >  delete mode 100644 arm/aarch32/kvm.c
> >  delete mode 100644 arm/aarch64/include/kvm/fdt-arch.h
> >  delete mode 100644 arm/aarch64/include/kvm/kvm-arch.h
> >  delete mode 100644 arm/aarch64/include/kvm/kvm-config-arch.h
> >  delete mode 100644 arm/aarch64/include/kvm/kvm-cpu-arch.h
> >  delete mode 100644 arm/aarch64/kvm.c
> >  delete mode 100644 arm/kvm-cpu.c
> >  rename {arm/aarch64 => arm64}/arm-cpu.c (96%)
> >  rename {arm => arm64}/fdt.c (99%)
> >  rename {arm => arm64}/gic.c (99%)
> >  rename {arm => arm64}/gicv2m.c (99%)
> >  rename {arm/aarch64 => arm64}/include/asm/image.h (100%)
> >  rename {arm/aarch64 => arm64}/include/asm/kernel.h (100%)
> >  rename {arm/aarch64 => arm64}/include/asm/kvm.h (100%)
> >  rename {arm/aarch64 => arm64}/include/asm/pmu.h (100%)
> >  rename {arm/aarch64 => arm64}/include/asm/sve_context.h (100%)
> >  rename {arm/include/arm-common => arm64/include}/gic.h (100%)
> >  rename {arm/aarch64 => arm64}/include/kvm/barrier.h (100%)
> >  rename {arm/include/arm-common => arm64/include/kvm}/fdt-arch.h (100%)
> >  rename {arm/include/arm-common => arm64/include/kvm}/kvm-arch.h (97%)
> >  rename {arm/include/arm-common => arm64/include/kvm}/kvm-config-arch.h (54%)
> >  rename {arm/include/arm-common => arm64/include/kvm}/kvm-cpu-arch.h (82%)
> >  rename {arm/include/arm-common => arm64/include}/pci.h (100%)
> >  rename {arm/include/arm-common => arm64/include}/timer.h (100%)
> >  rename {arm => arm64}/ioport.c (100%)
> >  rename {arm/aarch64 => arm64}/kvm-cpu.c (70%)
> >  rename {arm => arm64}/kvm.c (59%)
> >  rename {arm => arm64}/pci.c (98%)
> >  rename {arm/aarch64 => arm64}/pmu.c (99%)
> >  rename {arm/aarch64 => arm64}/pvtime.c (100%)
> >  rename {arm => arm64}/timer.c (95%)
> > 
> > 
> > base-commit: e48563f5c4a48fe6a6bc2a98a9a7c84a10f043be
> > -- 
> > 2.39.5
> > 
> >   


