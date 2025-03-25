Return-Path: <kvm+bounces-41983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CEAB6A707BC
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 18:08:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F058816A37F
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 17:08:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A64125F988;
	Tue, 25 Mar 2025 17:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="c7AkGQC7"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57ABA2E339B
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 17:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742922517; cv=none; b=li+FanvwrF3kA7XmCdg9MsFoag0sBkxBW0RKmQPr7WQnzDAW4HESjYXDBTlA8Rp6yjYsASyzZ4oQYMlTQuxhsJy2gnjmi9ZQ81RJiJx5Iw7QNnliHafv+kFIZrGBkc6ENLg7PAhABk0302v6D3KfzHxh79ZLSOjORdEnJjuwWJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742922517; c=relaxed/simple;
	bh=HRDTYesKsRfr/gom0Pcb6ElVq/cXVLoFwtLvyA3v9hg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p1YQDHkLfAkRtcD9AdcKiKOJF8I5+XJeF4EtRhwdRfYSRnScstnPkd4tfz38F/J2qUUOzGZVpP/DeAwxjP/f4lKxmBOgxiEQTJLy+E8RA9MBgbUR4ATcPlHfzR5lwQirmPaUKmIDEIzfPoaBQQwi+bHCkf3PKrBVzFMsnbn5CNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=c7AkGQC7; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 25 Mar 2025 10:08:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742922513;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NH3DOv+4xtixxBXwX7i8LSGXK5i2rG9cRzsSJWEj7+k=;
	b=c7AkGQC7ik4xbFMhInqvSYp2Fu+F4krw29bLKhQOOFD7cf4sOXgTWTSDMozn7TmyuKCq3/
	aFw34bK+zl8kdvkM897hbtaDDZBBycA2IAevfxnm7B8aFR+cGIOQYi6m2+DzKPugrz7e5B
	VI5C3AtV2fEuOSNDGO3xQ8uzITLPJpU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [RFC kvmtool 1/9] Drop support for 32-bit arm
Message-ID: <Z-LjDDwhfre2YpMZ@linux.dev>
References: <20250314222516.1302429-1-oliver.upton@linux.dev>
 <20250314222516.1302429-2-oliver.upton@linux.dev>
 <Z9xJTZeXnkfWcWNl@raptor>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9xJTZeXnkfWcWNl@raptor>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 20, 2025 at 04:58:53PM +0000, Alexandru Elisei wrote:
> Hi Oliver,
> 
> I tried to apply the patch on top of e48563f5c4a48fe6a6bc2a98a9a7c84a10f043be,
> which is the base commit from the cover letter, and I got these errors:
> 
> Applying: Drop support for 32-bit arm
> error: removal patch leaves file contents
> error: arm/aarch32/arm-cpu.c: patch does not apply
> error: removal patch leaves file contents
> error: arm/aarch32/include/asm/kernel.h: patch does not apply
> error: removal patch leaves file contents
> error: arm/aarch32/include/asm/kvm.h: patch does not apply
> error: removal patch leaves file contents
> error: arm/aarch32/include/kvm/barrier.h: patch does not apply
> error: removal patch leaves file contents
> error: arm/aarch32/include/kvm/fdt-arch.h: patch does not apply
> error: removal patch leaves file contents
> error: arm/aarch32/include/kvm/kvm-arch.h: patch does not apply
> error: removal patch leaves file contents
> error: arm/aarch32/include/kvm/kvm-config-arch.h: patch does not apply
> error: removal patch leaves file contents
> error: arm/aarch32/include/kvm/kvm-cpu-arch.h: patch does not apply
> error: removal patch leaves file contents
> error: arm/aarch32/kvm-cpu.c: patch does not apply
> error: removal patch leaves file contents
> error: arm/aarch32/kvm.c: patch does not apply
> 
> When I delete the files manually, the resulting commit has diffs like this for
> the deleted files:
> 
> diff --git a/arm/aarch32/arm-cpu.c b/arm/aarch32/arm-cpu.c
> deleted file mode 100644
> index 16bba5524caf..000000000000
> --- a/arm/aarch32/arm-cpu.c
> +++ /dev/null
> @@ -1,50 +0,0 @@
> -#include "kvm/kvm.h"
> -#include "kvm/kvm-cpu.h"
> -#include "kvm/util.h"
> -
> -#include "arm-common/gic.h"
> -#include "arm-common/timer.h"
> [..]
> 
> .. and so on.
> 
> Am I missing a knob for applying the patch? FYI, this happens for all the
> patches in this series with files deleted.

That's on me, I did 'git format-patch -D' to keep the diffs smaller for
an RFC. I'll post patches that actually apply for v1.

> One more comment below.
> 
> On Fri, Mar 14, 2025 at 03:25:08PM -0700, Oliver Upton wrote:
> > Linux dropped support for KVM in 32-bit arm kernels almost 5 years ago
> > in the 5.7 kernel release. In addition to that KVM/arm64 never had
> > 32-bit compat support, so it is a safe assumption that usage of 32-bit
> > kvmtool is pretty much dead at this point.
> > 
> > Do not despair -- 32-bit guests are still supported with a 64-bit
> > userspace.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  INSTALL                                   |   9 +-
> >  Makefile                                  |  31 +--
> >  arm/aarch32/arm-cpu.c                     |  50 ----
> >  arm/aarch32/include/asm/kernel.h          |   8 -
> >  arm/aarch32/include/asm/kvm.h             | 311 ----------------------
> >  arm/aarch32/include/kvm/barrier.h         |  10 -
> >  arm/aarch32/include/kvm/fdt-arch.h        |   6 -
> >  arm/aarch32/include/kvm/kvm-arch.h        |  18 --
> >  arm/aarch32/include/kvm/kvm-config-arch.h |   8 -
> >  arm/aarch32/include/kvm/kvm-cpu-arch.h    |  24 --
> >  arm/aarch32/kvm-cpu.c                     | 132 ---------
> >  arm/aarch32/kvm.c                         |  14 -
> >  12 files changed, 14 insertions(+), 607 deletions(-)
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
> > 
> > diff --git a/INSTALL b/INSTALL
> > index 2a65735..0e1e63e 100644
> > --- a/INSTALL
> > +++ b/INSTALL
> > @@ -26,7 +26,7 @@ For Fedora based systems:
> >  For OpenSUSE based systems:
> >  	# zypper install glibc-devel-static
> >  
> > -Architectures which require device tree (PowerPC, ARM, ARM64, RISC-V) also
> > +Architectures which require device tree (PowerPC, ARM64, RISC-V) also
> >  require libfdt.
> >  	deb: $ sudo apt-get install libfdt-dev
> >  	Fedora: # yum install libfdt-devel
> > @@ -61,16 +61,15 @@ to the Linux name of the architecture. Architectures supported:
> >  - i386
> >  - x86_64
> >  - powerpc
> > -- arm
> >  - arm64
> >  - mips
> >  - riscv
> >  If ARCH is not provided, the target architecture will be automatically
> >  determined by running "uname -m" on your host, resulting in a native build.
> >  
> > -To cross-compile to ARM for instance, install a cross-compiler, put the
> > +To cross-compile to arm64 for instance, install a cross-compiler, put the
> >  required libraries in the cross-compiler's SYSROOT and type:
> > -$ make CROSS_COMPILE=arm-linux-gnueabihf- ARCH=arm
> > +$ make CROSS_COMPILE=aarch64-linux-gnu- ARCH=arm64
> >  
> >  Missing libraries when cross-compiling
> >  ---------------------------------------
> > @@ -82,7 +81,7 @@ On multiarch system you should be able to install those be appending
> >  the architecture name after the package (example for ARM64):
> >  $ sudo apt-get install libfdt-dev:arm64
> >  
> > -PowerPC, ARM/ARM64 and RISC-V require libfdt to be installed. If you cannot use
> > +PowerPC, ARM64 and RISC-V require libfdt to be installed. If you cannot use
> >  precompiled mulitarch packages, you could either copy the required header and
> >  library files from an installed target system into the SYSROOT (you will need
> >  /usr/include/*fdt*.h and /usr/lib64/libfdt-v.v.v.so and its symlinks), or you
> > diff --git a/Makefile b/Makefile
> > index d84dc8e..462659b 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -166,35 +166,24 @@ ifeq ($(ARCH), powerpc)
> >  	ARCH_WANT_LIBFDT := y
> >  endif
> >  
> > -# ARM
> > -OBJS_ARM_COMMON		:= arm/fdt.o arm/gic.o arm/gicv2m.o arm/ioport.o \
> > -			   arm/kvm.o arm/kvm-cpu.o arm/pci.o arm/timer.o \
> > -			   hw/serial.o
> > -HDRS_ARM_COMMON		:= arm/include
> > -ifeq ($(ARCH), arm)
> > -	DEFINES		+= -DCONFIG_ARM
> 
> Found a couple of instances of CONFIG_ARM using grep.
> 
> There also one instance of the architecture name ARM in a comment in
> hw/cfi_flash.c, I think that was a typo and it was meant to say ARM64.
> 
> Other than that, looks good.

Thanks for spotting those, will fix.

Thanks,
Oliver

