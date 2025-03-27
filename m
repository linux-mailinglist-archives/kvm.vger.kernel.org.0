Return-Path: <kvm+bounces-42127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B219A736E0
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 17:32:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 302C61899D0A
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 16:33:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C45E41A3159;
	Thu, 27 Mar 2025 16:32:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 458221991BF
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 16:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743093166; cv=none; b=H3H7y5eQ/+dmfk6m4I19fbWaQ0QGUrfnuXDjrpL//kAx1lIKFwGmeC+dvfaifMuURoGNF0XH70rR0t6iW4S3r4sCHwQKbY0Tv0wO9jmQYCP3ywDttaVVy7PjIA3dbnJTbP89a18YxHvrlzpWmYVImjlR/E1TeLpTdRziH380S5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743093166; c=relaxed/simple;
	bh=k6iaCCqNNChhLDgPe+S8eDgu4mP4JE7l1YkeGpB1AW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vAvXFlLILTwN+uO/q4GACAiWiBIyujN7ZD2p973Hayk/TejQrVE741r27OOI+Bg9hda6HGv6T4i8zPkTfqaG/W2AVGFO+Jxi8mkCRikjXpgUekwSP1steVdhmdIVbiMj40hNXSLcFqDVzdaHapXk7AAoaT3cyRy41sg/IAObOOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B76001063;
	Thu, 27 Mar 2025 09:32:48 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 582F43F63F;
	Thu, 27 Mar 2025 09:32:42 -0700 (PDT)
Date: Thu, 27 Mar 2025 16:32:39 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH kvmtool 0/9] arm: Drop support for 32-bit kvmtool
Message-ID: <Z-V9p1DWZPlDlYYU@raptor>
References: <20250325213939.2414498-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250325213939.2414498-1-oliver.upton@linux.dev>

Hi Oliver,

On Tue, Mar 25, 2025 at 02:39:30PM -0700, Oliver Upton wrote:
> The last stable kernel to support 32-bit KVM/arm is 5.4, which is on
> track for EOL at the end of this year. Considering this, and the fact
> that 32-bit KVM never saw much usage in the first place, it is probably
> time to toss out the coprolite.
> 
> Of course, this has no effect on the support for 32-bit guests on 64-bit
> KVM.
> 
> RFC: https://lore.kernel.org/kvmarm/20250314222516.1302429-1-oliver.upton@linux.dev/
> 
> RFC -> v1:
>  - Collected Marc's Acks
>  - Cleaned up some forgotten references to CONFIG_ARM (Alex)
>  - Minor nits on includes, defines (Alex)

I see that you've kept gic.h, pci.h and timer.h in arm64/include.

The series looks good to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

I've also did some light testing by building kvmtool from each patch in the
series and booting a Linux guest.

Thanks,
Alex

> 
> Oliver Upton (9):
>   Drop support for 32-bit arm
>   arm64: Move arm64-only features into main directory
>   arm64: Combine kvm.c
>   arm64: Merge kvm-cpu.c
>   arm64: Combine kvm-config-arch.h
>   arm64: Move remaining kvm/* headers
>   arm64: Move asm headers
>   arm64: Rename top-level directory
>   arm64: Get rid of the 'arm-common' include directory
> 
>  INSTALL                                       |   9 +-
>  Makefile                                      |  40 +--
>  arm/aarch32/arm-cpu.c                         |  50 ---
>  arm/aarch32/include/asm/kernel.h              |   8 -
>  arm/aarch32/include/asm/kvm.h                 | 311 ------------------
>  arm/aarch32/include/kvm/barrier.h             |  10 -
>  arm/aarch32/include/kvm/fdt-arch.h            |   6 -
>  arm/aarch32/include/kvm/kvm-arch.h            |  18 -
>  arm/aarch32/include/kvm/kvm-config-arch.h     |   8 -
>  arm/aarch32/include/kvm/kvm-cpu-arch.h        |  24 --
>  arm/aarch32/kvm-cpu.c                         | 132 --------
>  arm/aarch32/kvm.c                             |  14 -
>  arm/aarch64/include/kvm/fdt-arch.h            |   6 -
>  arm/aarch64/include/kvm/kvm-arch.h            |  22 --
>  arm/aarch64/include/kvm/kvm-config-arch.h     |  29 --
>  arm/aarch64/include/kvm/kvm-cpu-arch.h        |  19 --
>  arm/aarch64/kvm.c                             | 212 ------------
>  arm/kvm-cpu.c                                 | 153 ---------
>  {arm/aarch64 => arm64}/arm-cpu.c              |   4 +-
>  {arm => arm64}/fdt.c                          |   4 +-
>  {arm => arm64}/gic.c                          |   2 +-
>  {arm => arm64}/gicv2m.c                       |   2 +-
>  {arm/aarch64 => arm64}/include/asm/image.h    |   0
>  {arm/aarch64 => arm64}/include/asm/kernel.h   |   0
>  {arm/aarch64 => arm64}/include/asm/kvm.h      |   0
>  {arm/aarch64 => arm64}/include/asm/pmu.h      |   0
>  .../include/asm/sve_context.h                 |   0
>  .../arm-common => arm64/include}/gic.h        |   0
>  {arm/aarch64 => arm64}/include/kvm/barrier.h  |   0
>  .../include/kvm}/fdt-arch.h                   |   0
>  .../include/kvm}/kvm-arch.h                   |   8 +-
>  .../include/kvm}/kvm-config-arch.h            |  24 +-
>  .../include/kvm}/kvm-cpu-arch.h               |  10 +-
>  .../arm-common => arm64/include}/pci.h        |   0
>  .../arm-common => arm64/include}/timer.h      |   0
>  {arm => arm64}/ioport.c                       |   0
>  {arm/aarch64 => arm64}/kvm-cpu.c              | 289 ++++++++++++----
>  {arm => arm64}/kvm.c                          | 209 +++++++++++-
>  {arm => arm64}/pci.c                          |   4 +-
>  {arm/aarch64 => arm64}/pmu.c                  |   2 +-
>  {arm/aarch64 => arm64}/pvtime.c               |   0
>  {arm => arm64}/timer.c                        |   4 +-
>  builtin-run.c                                 |   2 +-
>  hw/cfi_flash.c                                |   2 +-
>  hw/rtc.c                                      |   2 +-
>  hw/serial.c                                   |   2 +-
>  virtio/core.c                                 |   2 +-
>  47 files changed, 498 insertions(+), 1145 deletions(-)
>  delete mode 100644 arm/aarch32/arm-cpu.c
>  delete mode 100644 arm/aarch32/include/asm/kernel.h
>  delete mode 100644 arm/aarch32/include/asm/kvm.h
>  delete mode 100644 arm/aarch32/include/kvm/barrier.h
>  delete mode 100644 arm/aarch32/include/kvm/fdt-arch.h
>  delete mode 100644 arm/aarch32/include/kvm/kvm-arch.h
>  delete mode 100644 arm/aarch32/include/kvm/kvm-config-arch.h
>  delete mode 100644 arm/aarch32/include/kvm/kvm-cpu-arch.h
>  delete mode 100644 arm/aarch32/kvm-cpu.c
>  delete mode 100644 arm/aarch32/kvm.c
>  delete mode 100644 arm/aarch64/include/kvm/fdt-arch.h
>  delete mode 100644 arm/aarch64/include/kvm/kvm-arch.h
>  delete mode 100644 arm/aarch64/include/kvm/kvm-config-arch.h
>  delete mode 100644 arm/aarch64/include/kvm/kvm-cpu-arch.h
>  delete mode 100644 arm/aarch64/kvm.c
>  delete mode 100644 arm/kvm-cpu.c
>  rename {arm/aarch64 => arm64}/arm-cpu.c (96%)
>  rename {arm => arm64}/fdt.c (99%)
>  rename {arm => arm64}/gic.c (99%)
>  rename {arm => arm64}/gicv2m.c (99%)
>  rename {arm/aarch64 => arm64}/include/asm/image.h (100%)
>  rename {arm/aarch64 => arm64}/include/asm/kernel.h (100%)
>  rename {arm/aarch64 => arm64}/include/asm/kvm.h (100%)
>  rename {arm/aarch64 => arm64}/include/asm/pmu.h (100%)
>  rename {arm/aarch64 => arm64}/include/asm/sve_context.h (100%)
>  rename {arm/include/arm-common => arm64/include}/gic.h (100%)
>  rename {arm/aarch64 => arm64}/include/kvm/barrier.h (100%)
>  rename {arm/include/arm-common => arm64/include/kvm}/fdt-arch.h (100%)
>  rename {arm/include/arm-common => arm64/include/kvm}/kvm-arch.h (96%)
>  rename {arm/include/arm-common => arm64/include/kvm}/kvm-config-arch.h (54%)
>  rename {arm/include/arm-common => arm64/include/kvm}/kvm-cpu-arch.h (82%)
>  rename {arm/include/arm-common => arm64/include}/pci.h (100%)
>  rename {arm/include/arm-common => arm64/include}/timer.h (100%)
>  rename {arm => arm64}/ioport.c (100%)
>  rename {arm/aarch64 => arm64}/kvm-cpu.c (70%)
>  rename {arm => arm64}/kvm.c (59%)
>  rename {arm => arm64}/pci.c (98%)
>  rename {arm/aarch64 => arm64}/pmu.c (99%)
>  rename {arm/aarch64 => arm64}/pvtime.c (100%)
>  rename {arm => arm64}/timer.c (95%)
> 
> 
> base-commit: e48563f5c4a48fe6a6bc2a98a9a7c84a10f043be
> -- 
> 2.39.5
> 

