Return-Path: <kvm+bounces-41584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A949AA6AB9D
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 18:01:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C08D017F07D
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 17:01:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E7C722259C;
	Thu, 20 Mar 2025 17:01:17 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66EBA1E9915
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 17:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742490076; cv=none; b=uieERK3AICpsOklWNMSEXGiIESmTagrUPG5yM9TxnU6eRQ67kn56sO5agCzDDCGZfNToDo0hWW3UeRKNHFSt+FG0N8GZCZjmqeo1MspJfJdtt6uOTdFeMJopTaVlIOtyMdnFMT3KAdd3lgwEO9d/jm88t29mhUq/Usi5n1MUnls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742490076; c=relaxed/simple;
	bh=oABQ/XlPnfJxcgBcgYWcylpoHsrcIZqcWf6P95xFp2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i806t7g+p2ltC/OlLdwVm6TCPgINl/Yg0LM7zGe7ZetuzzVE3tsspzC58Lj9249xRhFOEPHVZ/x87XsOjL6RiodWot2bPQluYTzZjZYAtxM2H2PmtPiyoav2lLPFrCFzbtjfKdY6Fdh1unbmmd0zXtgk5wEgSK1NwPSBf621gFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 64DCC1424;
	Thu, 20 Mar 2025 10:01:22 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B79A53F673;
	Thu, 20 Mar 2025 10:01:13 -0700 (PDT)
Date: Thu, 20 Mar 2025 17:01:11 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [RFC kvmtool 9/9] arm64: Get rid of the 'arm-common' include
 directory
Message-ID: <Z9xJ10c4pwJ-TF3o@raptor>
References: <20250314222516.1302429-1-oliver.upton@linux.dev>
 <20250314222516.1302429-10-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250314222516.1302429-10-oliver.upton@linux.dev>

Hi Oliver,

On Fri, Mar 14, 2025 at 03:25:16PM -0700, Oliver Upton wrote:
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arm64/arm-cpu.c                        | 4 ++--
>  arm64/fdt.c                            | 4 ++--
>  arm64/gic.c                            | 2 +-
>  arm64/gicv2m.c                         | 2 +-
>  arm64/include/{arm-common => }/gic.h   | 0
>  arm64/include/kvm/kvm-arch.h           | 2 +-
>  arm64/include/{arm-common => }/pci.h   | 0
>  arm64/include/{arm-common => }/timer.h | 0

Looking at x86 and riscv, the pattern is to have the header files in
<arch>/include/kvm, even if they're only used by the arch code.

Do we care about following this pattern?

Thanks,
Alex

>  arm64/kvm.c                            | 2 +-
>  arm64/pci.c                            | 4 ++--
>  arm64/pmu.c                            | 2 +-
>  arm64/timer.c                          | 4 ++--
>  12 files changed, 13 insertions(+), 13 deletions(-)
>  rename arm64/include/{arm-common => }/gic.h (100%)
>  rename arm64/include/{arm-common => }/pci.h (100%)
>  rename arm64/include/{arm-common => }/timer.h (100%)
> 
> diff --git a/arm64/arm-cpu.c b/arm64/arm-cpu.c
> index f5c8e1e..b9ca814 100644
> --- a/arm64/arm-cpu.c
> +++ b/arm64/arm-cpu.c
> @@ -3,8 +3,8 @@
>  #include "kvm/kvm-cpu.h"
>  #include "kvm/util.h"
>  
> -#include "arm-common/gic.h"
> -#include "arm-common/timer.h"
> +#include "gic.h"
> +#include "timer.h"
>  
>  #include "asm/pmu.h"
>  
> diff --git a/arm64/fdt.c b/arm64/fdt.c
> index 286ccad..9d93551 100644
> --- a/arm64/fdt.c
> +++ b/arm64/fdt.c
> @@ -4,8 +4,8 @@
>  #include "kvm/kvm-cpu.h"
>  #include "kvm/virtio-mmio.h"
>  
> -#include "arm-common/gic.h"
> -#include "arm-common/pci.h"
> +#include "gic.h"
> +#include "pci.h"
>  
>  #include <stdbool.h>
>  
> diff --git a/arm64/gic.c b/arm64/gic.c
> index 0795e95..d0d8543 100644
> --- a/arm64/gic.c
> +++ b/arm64/gic.c
> @@ -3,7 +3,7 @@
>  #include "kvm/kvm.h"
>  #include "kvm/virtio.h"
>  
> -#include "arm-common/gic.h"
> +#include "gic.h"
>  
>  #include <linux/byteorder.h>
>  #include <linux/kernel.h>
> diff --git a/arm64/gicv2m.c b/arm64/gicv2m.c
> index b47ada8..e4e7dc8 100644
> --- a/arm64/gicv2m.c
> +++ b/arm64/gicv2m.c
> @@ -5,7 +5,7 @@
>  #include "kvm/kvm.h"
>  #include "kvm/util.h"
>  
> -#include "arm-common/gic.h"
> +#include "gic.h"
>  
>  #define GICV2M_MSI_TYPER	0x008
>  #define GICV2M_MSI_SETSPI	0x040
> diff --git a/arm64/include/arm-common/gic.h b/arm64/include/gic.h
> similarity index 100%
> rename from arm64/include/arm-common/gic.h
> rename to arm64/include/gic.h
> diff --git a/arm64/include/kvm/kvm-arch.h b/arm64/include/kvm/kvm-arch.h
> index b55b3bf..a9872a8 100644
> --- a/arm64/include/kvm/kvm-arch.h
> +++ b/arm64/include/kvm/kvm-arch.h
> @@ -10,7 +10,7 @@
>  #include <linux/const.h>
>  #include <linux/types.h>
>  
> -#include "arm-common/gic.h"
> +#include "gic.h"
>  
>  /*
>   * The memory map used for ARM guests (not to scale):
> diff --git a/arm64/include/arm-common/pci.h b/arm64/include/pci.h
> similarity index 100%
> rename from arm64/include/arm-common/pci.h
> rename to arm64/include/pci.h
> diff --git a/arm64/include/arm-common/timer.h b/arm64/include/timer.h
> similarity index 100%
> rename from arm64/include/arm-common/timer.h
> rename to arm64/include/timer.h
> diff --git a/arm64/kvm.c b/arm64/kvm.c
> index 5e7fe77..6ee4c1d 100644
> --- a/arm64/kvm.c
> +++ b/arm64/kvm.c
> @@ -5,7 +5,7 @@
>  #include "kvm/virtio-console.h"
>  #include "kvm/fdt.h"
>  
> -#include "arm-common/gic.h"
> +#include "gic.h"
>  
>  #include <linux/byteorder.h>
>  #include <linux/cpumask.h>
> diff --git a/arm64/pci.c b/arm64/pci.c
> index 5bd82d4..99bf887 100644
> --- a/arm64/pci.c
> +++ b/arm64/pci.c
> @@ -5,8 +5,8 @@
>  #include "kvm/pci.h"
>  #include "kvm/util.h"
>  
> -#include "arm-common/pci.h"
> -#include "arm-common/gic.h"
> +#include "pci.h"
> +#include "gic.h"
>  
>  /*
>   * An entry in the interrupt-map table looks like:
> diff --git a/arm64/pmu.c b/arm64/pmu.c
> index 5ed4979..52f4256 100644
> --- a/arm64/pmu.c
> +++ b/arm64/pmu.c
> @@ -9,7 +9,7 @@
>  #include "kvm/kvm-cpu.h"
>  #include "kvm/util.h"
>  
> -#include "arm-common/gic.h"
> +#include "gic.h"
>  
>  #include "asm/pmu.h"
>  
> diff --git a/arm64/timer.c b/arm64/timer.c
> index 6acc50e..b3164f8 100644
> --- a/arm64/timer.c
> +++ b/arm64/timer.c
> @@ -3,8 +3,8 @@
>  #include "kvm/kvm-cpu.h"
>  #include "kvm/util.h"
>  
> -#include "arm-common/gic.h"
> -#include "arm-common/timer.h"
> +#include "gic.h"
> +#include "timer.h"
>  
>  void timer__generate_fdt_nodes(void *fdt, struct kvm *kvm, int *irqs)
>  {
> -- 
> 2.39.5
> 
> 

