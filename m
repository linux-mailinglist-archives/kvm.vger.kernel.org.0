Return-Path: <kvm+bounces-41582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BF34A6AB9A
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 18:00:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8CD591887A67
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 16:59:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 320A1223311;
	Thu, 20 Mar 2025 16:59:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 144671E25EB
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 16:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742489940; cv=none; b=MYgC7zsRpmHnhaJehpGKURVwN+LNbEBGoOpZzP62B9NtcAAR1Qh65CfydMCjPbvjHyU3LWCGMv0Cw9gc657M2ZCtHQwhuMKy6BSPnYAnDAL9Xj13eBG6kIVsZvLOiZX+ZfOrW2dkAu++g15Be+dbAqBBM+o/KNCAwIohKJ/P6Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742489940; c=relaxed/simple;
	bh=PC20kkYy5oBft7eQoQ2A3mtQbuM39LN8zulNHXEYwek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YVKn0e85e9wmQpiwlLpCMDBz04GoVURqd31TNITGqQm7si8XVtqwqI8JZYXke9iplNeFw+jy7c5h1f4KvnEKfuQpopT9uo8VA1g+kLC/i439xic9cqubY3Ok+3301gNx3yH8WixyFFNslBWxi+kZBFDVOfBwMyXga3Bqtj4ZQtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D91D2113E;
	Thu, 20 Mar 2025 09:59:04 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3ABAF3F673;
	Thu, 20 Mar 2025 09:58:56 -0700 (PDT)
Date: Thu, 20 Mar 2025 16:58:53 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [RFC kvmtool 1/9] Drop support for 32-bit arm
Message-ID: <Z9xJTZeXnkfWcWNl@raptor>
References: <20250314222516.1302429-1-oliver.upton@linux.dev>
 <20250314222516.1302429-2-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250314222516.1302429-2-oliver.upton@linux.dev>

Hi Oliver,

I tried to apply the patch on top of e48563f5c4a48fe6a6bc2a98a9a7c84a10f043be,
which is the base commit from the cover letter, and I got these errors:

Applying: Drop support for 32-bit arm
error: removal patch leaves file contents
error: arm/aarch32/arm-cpu.c: patch does not apply
error: removal patch leaves file contents
error: arm/aarch32/include/asm/kernel.h: patch does not apply
error: removal patch leaves file contents
error: arm/aarch32/include/asm/kvm.h: patch does not apply
error: removal patch leaves file contents
error: arm/aarch32/include/kvm/barrier.h: patch does not apply
error: removal patch leaves file contents
error: arm/aarch32/include/kvm/fdt-arch.h: patch does not apply
error: removal patch leaves file contents
error: arm/aarch32/include/kvm/kvm-arch.h: patch does not apply
error: removal patch leaves file contents
error: arm/aarch32/include/kvm/kvm-config-arch.h: patch does not apply
error: removal patch leaves file contents
error: arm/aarch32/include/kvm/kvm-cpu-arch.h: patch does not apply
error: removal patch leaves file contents
error: arm/aarch32/kvm-cpu.c: patch does not apply
error: removal patch leaves file contents
error: arm/aarch32/kvm.c: patch does not apply

When I delete the files manually, the resulting commit has diffs like this for
the deleted files:

diff --git a/arm/aarch32/arm-cpu.c b/arm/aarch32/arm-cpu.c
deleted file mode 100644
index 16bba5524caf..000000000000
--- a/arm/aarch32/arm-cpu.c
+++ /dev/null
@@ -1,50 +0,0 @@
-#include "kvm/kvm.h"
-#include "kvm/kvm-cpu.h"
-#include "kvm/util.h"
-
-#include "arm-common/gic.h"
-#include "arm-common/timer.h"
[..]

.. and so on.

Am I missing a knob for applying the patch? FYI, this happens for all the
patches in this series with files deleted.

One more comment below.

On Fri, Mar 14, 2025 at 03:25:08PM -0700, Oliver Upton wrote:
> Linux dropped support for KVM in 32-bit arm kernels almost 5 years ago
> in the 5.7 kernel release. In addition to that KVM/arm64 never had
> 32-bit compat support, so it is a safe assumption that usage of 32-bit
> kvmtool is pretty much dead at this point.
> 
> Do not despair -- 32-bit guests are still supported with a 64-bit
> userspace.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  INSTALL                                   |   9 +-
>  Makefile                                  |  31 +--
>  arm/aarch32/arm-cpu.c                     |  50 ----
>  arm/aarch32/include/asm/kernel.h          |   8 -
>  arm/aarch32/include/asm/kvm.h             | 311 ----------------------
>  arm/aarch32/include/kvm/barrier.h         |  10 -
>  arm/aarch32/include/kvm/fdt-arch.h        |   6 -
>  arm/aarch32/include/kvm/kvm-arch.h        |  18 --
>  arm/aarch32/include/kvm/kvm-config-arch.h |   8 -
>  arm/aarch32/include/kvm/kvm-cpu-arch.h    |  24 --
>  arm/aarch32/kvm-cpu.c                     | 132 ---------
>  arm/aarch32/kvm.c                         |  14 -
>  12 files changed, 14 insertions(+), 607 deletions(-)
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
> 
> diff --git a/INSTALL b/INSTALL
> index 2a65735..0e1e63e 100644
> --- a/INSTALL
> +++ b/INSTALL
> @@ -26,7 +26,7 @@ For Fedora based systems:
>  For OpenSUSE based systems:
>  	# zypper install glibc-devel-static
>  
> -Architectures which require device tree (PowerPC, ARM, ARM64, RISC-V) also
> +Architectures which require device tree (PowerPC, ARM64, RISC-V) also
>  require libfdt.
>  	deb: $ sudo apt-get install libfdt-dev
>  	Fedora: # yum install libfdt-devel
> @@ -61,16 +61,15 @@ to the Linux name of the architecture. Architectures supported:
>  - i386
>  - x86_64
>  - powerpc
> -- arm
>  - arm64
>  - mips
>  - riscv
>  If ARCH is not provided, the target architecture will be automatically
>  determined by running "uname -m" on your host, resulting in a native build.
>  
> -To cross-compile to ARM for instance, install a cross-compiler, put the
> +To cross-compile to arm64 for instance, install a cross-compiler, put the
>  required libraries in the cross-compiler's SYSROOT and type:
> -$ make CROSS_COMPILE=arm-linux-gnueabihf- ARCH=arm
> +$ make CROSS_COMPILE=aarch64-linux-gnu- ARCH=arm64
>  
>  Missing libraries when cross-compiling
>  ---------------------------------------
> @@ -82,7 +81,7 @@ On multiarch system you should be able to install those be appending
>  the architecture name after the package (example for ARM64):
>  $ sudo apt-get install libfdt-dev:arm64
>  
> -PowerPC, ARM/ARM64 and RISC-V require libfdt to be installed. If you cannot use
> +PowerPC, ARM64 and RISC-V require libfdt to be installed. If you cannot use
>  precompiled mulitarch packages, you could either copy the required header and
>  library files from an installed target system into the SYSROOT (you will need
>  /usr/include/*fdt*.h and /usr/lib64/libfdt-v.v.v.so and its symlinks), or you
> diff --git a/Makefile b/Makefile
> index d84dc8e..462659b 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -166,35 +166,24 @@ ifeq ($(ARCH), powerpc)
>  	ARCH_WANT_LIBFDT := y
>  endif
>  
> -# ARM
> -OBJS_ARM_COMMON		:= arm/fdt.o arm/gic.o arm/gicv2m.o arm/ioport.o \
> -			   arm/kvm.o arm/kvm-cpu.o arm/pci.o arm/timer.o \
> -			   hw/serial.o
> -HDRS_ARM_COMMON		:= arm/include
> -ifeq ($(ARCH), arm)
> -	DEFINES		+= -DCONFIG_ARM

Found a couple of instances of CONFIG_ARM using grep.

There also one instance of the architecture name ARM in a comment in
hw/cfi_flash.c, I think that was a typo and it was meant to say ARM64.

Other than that, looks good.

Thanks,
Alex

> -	OBJS		+= $(OBJS_ARM_COMMON)
> -	OBJS		+= arm/aarch32/arm-cpu.o
> -	OBJS		+= arm/aarch32/kvm-cpu.o
> -	OBJS		+= arm/aarch32/kvm.o
> -	ARCH_INCLUDE	:= $(HDRS_ARM_COMMON)
> -	ARCH_INCLUDE	+= -Iarm/aarch32/include
> -	CFLAGS		+= -march=armv7-a
> -
> -	ARCH_WANT_LIBFDT := y
> -	ARCH_HAS_FLASH_MEM := y
> -endif
> -
>  # ARM64
>  ifeq ($(ARCH), arm64)
>  	DEFINES		+= -DCONFIG_ARM64
> -	OBJS		+= $(OBJS_ARM_COMMON)
> +	OBJS		+= arm/fdt.o
> +	OBJS		+= arm/gic.o
> +	OBJS		+= arm/gicv2m.o
> +	OBJS		+= arm/ioport.o
> +	OBJS		+= arm/kvm.o
> +	OBJS		+= arm/kvm-cpu.o
> +	OBJS		+= arm/pci.o
> +	OBJS		+= arm/timer.o
> +	OBJS		+= hw/serial.o
>  	OBJS		+= arm/aarch64/arm-cpu.o
>  	OBJS		+= arm/aarch64/kvm-cpu.o
>  	OBJS		+= arm/aarch64/kvm.o
>  	OBJS		+= arm/aarch64/pvtime.o
>  	OBJS		+= arm/aarch64/pmu.o
> -	ARCH_INCLUDE	:= $(HDRS_ARM_COMMON)
> +	ARCH_INCLUDE	:= arm/include
>  	ARCH_INCLUDE	+= -Iarm/aarch64/include
>  
>  	ARCH_WANT_LIBFDT := y
> diff --git a/arm/aarch32/arm-cpu.c b/arm/aarch32/arm-cpu.c
> deleted file mode 100644
> index 16bba55..0000000
> diff --git a/arm/aarch32/include/asm/kernel.h b/arm/aarch32/include/asm/kernel.h
> deleted file mode 100644
> index 6129609..0000000
> diff --git a/arm/aarch32/include/asm/kvm.h b/arm/aarch32/include/asm/kvm.h
> deleted file mode 100644
> index a4217c1..0000000
> diff --git a/arm/aarch32/include/kvm/barrier.h b/arm/aarch32/include/kvm/barrier.h
> deleted file mode 100644
> index 94913a9..0000000
> diff --git a/arm/aarch32/include/kvm/fdt-arch.h b/arm/aarch32/include/kvm/fdt-arch.h
> deleted file mode 100644
> index e448bf1..0000000
> diff --git a/arm/aarch32/include/kvm/kvm-arch.h b/arm/aarch32/include/kvm/kvm-arch.h
> deleted file mode 100644
> index 0333cf4..0000000
> diff --git a/arm/aarch32/include/kvm/kvm-config-arch.h b/arm/aarch32/include/kvm/kvm-config-arch.h
> deleted file mode 100644
> index acf0d23..0000000
> diff --git a/arm/aarch32/include/kvm/kvm-cpu-arch.h b/arm/aarch32/include/kvm/kvm-cpu-arch.h
> deleted file mode 100644
> index fd0b387..0000000
> diff --git a/arm/aarch32/kvm-cpu.c b/arm/aarch32/kvm-cpu.c
> deleted file mode 100644
> index 95fb1da..0000000
> diff --git a/arm/aarch32/kvm.c b/arm/aarch32/kvm.c
> deleted file mode 100644
> index 768a56b..0000000
> -- 
> 2.39.5
> 
> 

