Return-Path: <kvm+bounces-10237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7058686AE99
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 13:01:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BBF52988B2
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 12:01:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0EDA73525;
	Wed, 28 Feb 2024 12:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="m6Bp7Imm"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814DB73507
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 12:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709121687; cv=none; b=GEBwWSUlJoeH+f/6O6pllczNkDiPyvsgZrcT7ogtKD/KkFzVbPpLaxCLvioCvprEAFLg9k0ZdCqmwCtjXUpHWflaI6pEmZU3VoELey+pLu6muI4BxdIhBACkoY0uH/EXqyVriD5lI4sgt9q742i336MATZXUHVXCESEcUVXFZKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709121687; c=relaxed/simple;
	bh=C0aG7MOv4zWWLSb6+RPlPRsrd1kK/KMvGLcCOHA5GiI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q2Vs42Vcz26oRwkJPMtDt7WaKFQ9Sighg/dRDCoWm073yy/N55QebAbEb+v2s580aDwbHrBOk9hViUZn6wiq1fP2eystxedDyF9+mAxrqGksYBaRafosz7dnJDC6ptHpiNDOu/Kv/PXFfKmovnxeT9mkTekiIgRKMmWkLiBfYMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=m6Bp7Imm; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 28 Feb 2024 13:01:17 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709121683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cAhfOZzzV795zNV/l+orcHsw+Rajd2KabiCK5LjHC6U=;
	b=m6Bp7ImmtEOAPAaPq1QK2BT0pA6Kwr8DADKq+fxL7F1AiVBmTU4DeKxQa6+plByhzZjfnX
	M76yDJuKBXe43fxbQsygE0xWGLLS4NnzQqqvIpKzSVdhJmlT0NIQ5PxaX8fTWCGTN8Equ3
	f4whZKNYfWbyuVrgp+a0pXaPx2uHX1A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joel Stanley <joel@jms.id.au>, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 23/32] powerpc: Add MMU support
Message-ID: <20240228-af96de74f45c3fca418b8928@orel>
References: <20240226101218.1472843-1-npiggin@gmail.com>
 <20240226101218.1472843-24-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226101218.1472843-24-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Feb 26, 2024 at 08:12:09PM +1000, Nicholas Piggin wrote:
> Add support for radix MMU, 4kB and 64kB pages.
> 
> This also adds MMU interrupt test cases, and runs the interrupts
> test entirely with MMU enabled if it is available (aside from
> machine check tests).
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  configure                     |  39 +++--
>  lib/powerpc/asm/hcall.h       |   6 +
>  lib/powerpc/asm/processor.h   |   1 +
>  lib/powerpc/asm/reg.h         |   3 +
>  lib/powerpc/asm/smp.h         |   2 +
>  lib/powerpc/processor.c       |   9 ++
>  lib/powerpc/setup.c           |   4 +
>  lib/ppc64/asm/mmu.h           |  11 ++
>  lib/ppc64/asm/page.h          |  67 ++++++++-
>  lib/ppc64/asm/pgtable-hwdef.h |  67 +++++++++
>  lib/ppc64/asm/pgtable.h       | 126 ++++++++++++++++
>  lib/ppc64/mmu.c               | 273 ++++++++++++++++++++++++++++++++++
>  lib/ppc64/opal-calls.S        |   4 +-
>  powerpc/Makefile.common       |   2 +
>  powerpc/Makefile.ppc64        |   1 +
>  powerpc/interrupts.c          |  96 ++++++++++--
>  16 files changed, 684 insertions(+), 27 deletions(-)
>  create mode 100644 lib/ppc64/asm/mmu.h
>  create mode 100644 lib/ppc64/asm/pgtable-hwdef.h
>  create mode 100644 lib/ppc64/asm/pgtable.h
>  create mode 100644 lib/ppc64/mmu.c
> 
> diff --git a/configure b/configure
> index 05e6702ea..6907ccbbb 100755
> --- a/configure
> +++ b/configure
> @@ -222,29 +222,35 @@ fi
>  if [ -z "$page_size" ]; then
>      if [ "$efi" = 'y' ] && [ "$arch" = "arm64" ]; then
>          page_size="4096"
> -    elif [ "$arch" = "arm64" ]; then
> +    elif [ "$arch" = "arm64" ] || [ "$arch" = "ppc64" ]; then
>          page_size="65536"
>      elif [ "$arch" = "arm" ]; then
>          page_size="4096"
>      fi
>  else
> -    if [ "$arch" != "arm64" ]; then
> -        echo "--page-size is not supported for $arch"
> -        usage
> -    fi
> -
>      if [ "${page_size: -1}" = "K" ] || [ "${page_size: -1}" = "k" ]; then
>          page_size=$(( ${page_size%?} * 1024 ))
>      fi
> -    if [ "$page_size" != "4096" ] && [ "$page_size" != "16384" ] &&
> -           [ "$page_size" != "65536" ]; then
> -        echo "arm64 doesn't support page size of $page_size"
> +
> +    if [ "$arch" = "arm64" ]; then
> +        if [ "$page_size" != "4096" ] && [ "$page_size" != "16384" ] &&
> +               [ "$page_size" != "65536" ]; then
> +            echo "arm64 doesn't support page size of $page_size"
> +            usage
> +        fi
> +        if [ "$efi" = 'y' ] && [ "$page_size" != "4096" ]; then
> +            echo "efi must use 4K pages"
> +            exit 1
> +        fi
> +    elif [ "$arch" = "ppc64" ]; then
> +        if [ "$page_size" != "4096" ] && [ "$page_size" != "65536" ]; then
> +            echo "ppc64 doesn't support page size of $page_size"
> +            usage
> +        fi
> +    else
> +        echo "--page-size is not supported for $arch"
>          usage
>      fi
> -    if [ "$efi" = 'y' ] && [ "$page_size" != "4096" ]; then
> -        echo "efi must use 4K pages"
> -        exit 1
> -    fi
>  fi
>  
>  [ -z "$processor" ] && processor="$arch"
> @@ -444,6 +450,13 @@ cat <<EOF >> lib/config.h
>  
>  #define CONFIG_UART_EARLY_BASE ${arm_uart_early_addr}
>  #define CONFIG_ERRATA_FORCE ${errata_force}
> +
> +EOF
> +fi
> +
> +if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ] || [ "$arch" = "ppc64" ]; then
> +cat <<EOF >> lib/config.h
> +
>  #define CONFIG_PAGE_SIZE _AC(${page_size}, UL)
>  
>  EOF

Ack for the configure changes.

Thanks,
drew

