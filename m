Return-Path: <kvm+bounces-40000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BEFAA4D79A
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 10:12:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B0DE16317E
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 09:12:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C62491FCCF9;
	Tue,  4 Mar 2025 09:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sQPkZud9"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B951FC7F6
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 09:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741079562; cv=none; b=U1ypvh0MTewT61Xnw1gcM+Hb7OwmCpMyVWYqCrtn5RCfGKmnUVC5IEsR0r/2Pxenvg9s9YYNENmAIUQ47tqXH8ZcqiDhnFF1s4AyDNXSTvbGvW5oNY132U3KAGMZsG7TGfqSfBBFvOi91E7qiyzeoiA9S5BCpubD5gLxihCiAkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741079562; c=relaxed/simple;
	bh=XPRBYEJ9HrMmBJW36quaoU86TLjoYLweTXE4Fm9vuwc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L9teFWTl5In4KEi/q4wSc2nqeQT6xZ2VHYi+f34/TUax+y3d3496KdM8DsovGT3AsHOZl5l57t/311mbaJOnmeOnw0IbJn26z01SxkUlkXF1UBMn/ejF1d5ji4bVMlZttpYK50qAMRnRQB4NxfRh8Z7PWAR10WK9WluRG9PPMoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sQPkZud9; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 4 Mar 2025 10:12:30 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741079558;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yk65YCoknZT+htaDe9nqwacdmrTmjKV45m85/3fsFhE=;
	b=sQPkZud9kSyo2eP4UHsTl0mo8Gijg6SRFTEvSNzOPWxVZ19igT2P901QlPfY1Uc1Xu/aAm
	hmLNfw82SZlsDeYmKz/xB1QShkteULXP2sYggBN8gJfbIkYeaNr8A7a7Dv65HmgZ//hHTe
	8TmwryZlyMbq+tdY/72ICKmL89aUX34=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, atishp@rivosinc.com, 
	cleger@rivosinc.com, pbonzini@redhat.com, thuth@redhat.com, 
	Andrew Jones <ajones@ventanamicro.com>
Subject: Re: [kvm-unit-tests PATCH 1/2] configure: Allow earlycon for all
 architectures
Message-ID: <20250304-4e2ee456d30819f9a38239c8@orel>
References: <20250221162753.126290-4-andrew.jones@linux.dev>
 <20250221162753.126290-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250221162753.126290-5-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 21, 2025 at 05:27:55PM +0100, Andrew Jones wrote:
> From: Andrew Jones <ajones@ventanamicro.com>
> 
> earlycon could be used by any architecture so check it outside the
> arm block and apply it to riscv right away.
> 
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>  configure | 88 +++++++++++++++++++++++++++----------------------------
>  1 file changed, 43 insertions(+), 45 deletions(-)
> 
> diff --git a/configure b/configure
> index 86cf1da36467..7e462aaf1190 100755
> --- a/configure
> +++ b/configure
> @@ -78,10 +78,9 @@ usage() {
>  	                           4k [default], 16k, 64k for arm64.
>  	                           4k [default], 64k for ppc64.
>  	    --earlycon=EARLYCON
> -	                           Specify the UART name, type and address (optional, arm and
> -	                           arm64 only). The specified address will overwrite the UART
> -	                           address set by the --target option. EARLYCON can be one of
> -	                           (case sensitive):
> +				   Specify the UART name, type and address (optional).
> +	                           The specified address will overwrite the UART address set by
> +	                           the --target option. EARLYCON can be one of (case sensitive):

I'll add
                                   (arm/arm64 and riscv32/riscv64 only)

since no other architecture is paying attention to the parameter at this
time.

Thanks,
drew

>  	               uart[8250],mmio,ADDR
>  	                           Specify an 8250 compatible UART at address ADDR. Supported
>  	                           register stride is 8 bit only.
> @@ -283,6 +282,41 @@ else
>      fi
>  fi
>  
> +if [ "$earlycon" ]; then
> +    IFS=, read -r name type_addr addr <<<"$earlycon"
> +    if [ "$name" != "uart" ] && [ "$name" != "uart8250" ] && [ "$name" != "pl011" ]; then
> +        echo "unknown earlycon name: $name"
> +        usage
> +    fi
> +
> +    if [ "$name" = "pl011" ]; then
> +        if [ -z "$addr" ]; then
> +            addr=$type_addr
> +        else
> +            if [ "$type_addr" != "mmio32" ]; then
> +                echo "unknown $name earlycon type: $type_addr"
> +                usage
> +            fi
> +        fi
> +    else
> +        if [ "$type_addr" != "mmio" ]; then
> +            echo "unknown $name earlycon type: $type_addr"
> +            usage
> +        fi
> +    fi
> +
> +    if [ -z "$addr" ]; then
> +        echo "missing $name earlycon address"
> +        usage
> +    fi
> +    if [[ $addr =~ ^0(x|X)[0-9a-fA-F]+$ ]] || [[ $addr =~ ^[0-9]+$ ]]; then
> +        uart_early_addr=$addr
> +    else
> +        echo "invalid $name earlycon address: $addr"
> +        usage
> +    fi
> +fi
> +
>  [ -z "$processor" ] && processor="$arch"
>  
>  if [ "$processor" = "arm64" ]; then
> @@ -296,51 +330,14 @@ if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
>  elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
>      testdir=arm
>      if [ "$target" = "qemu" ]; then
> -        arm_uart_early_addr=0x09000000
> +        : "${uart_early_addr:=0x9000000}"
>      elif [ "$target" = "kvmtool" ]; then
> -        arm_uart_early_addr=0x1000000
> +        : "${uart_early_addr:=0x1000000}"
>          errata_force=1
>      else
>          echo "--target must be one of 'qemu' or 'kvmtool'!"
>          usage
>      fi
> -
> -    if [ "$earlycon" ]; then
> -        IFS=, read -r name type_addr addr <<<"$earlycon"
> -        if [ "$name" != "uart" ] && [ "$name" != "uart8250" ] &&
> -                [ "$name" != "pl011" ]; then
> -            echo "unknown earlycon name: $name"
> -            usage
> -        fi
> -
> -        if [ "$name" = "pl011" ]; then
> -            if [ -z "$addr" ]; then
> -                addr=$type_addr
> -            else
> -                if [ "$type_addr" != "mmio32" ]; then
> -                    echo "unknown $name earlycon type: $type_addr"
> -                    usage
> -                fi
> -            fi
> -        else
> -            if [ "$type_addr" != "mmio" ]; then
> -                echo "unknown $name earlycon type: $type_addr"
> -                usage
> -            fi
> -        fi
> -
> -        if [ -z "$addr" ]; then
> -            echo "missing $name earlycon address"
> -            usage
> -        fi
> -        if [[ $addr =~ ^0(x|X)[0-9a-fA-F]+$ ]] ||
> -                [[ $addr =~ ^[0-9]+$ ]]; then
> -            arm_uart_early_addr=$addr
> -        else
> -            echo "invalid $name earlycon address: $addr"
> -            usage
> -        fi
> -    fi
>  elif [ "$arch" = "ppc64" ]; then
>      testdir=powerpc
>      firmware="$testdir/boot_rom.bin"
> @@ -351,6 +348,7 @@ elif [ "$arch" = "ppc64" ]; then
>  elif [ "$arch" = "riscv32" ] || [ "$arch" = "riscv64" ]; then
>      testdir=riscv
>      arch_libdir=riscv
> +    : "${uart_early_addr:=0x10000000}"
>  elif [ "$arch" = "s390x" ]; then
>      testdir=s390x
>  else
> @@ -491,7 +489,7 @@ EOF
>  if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
>  cat <<EOF >> lib/config.h
>  
> -#define CONFIG_UART_EARLY_BASE ${arm_uart_early_addr}
> +#define CONFIG_UART_EARLY_BASE ${uart_early_addr}
>  #define CONFIG_ERRATA_FORCE ${errata_force}
>  
>  EOF
> @@ -506,7 +504,7 @@ EOF
>  elif [ "$arch" = "riscv32" ] || [ "$arch" = "riscv64" ]; then
>  cat <<EOF >> lib/config.h
>  
> -#define CONFIG_UART_EARLY_BASE 0x10000000
> +#define CONFIG_UART_EARLY_BASE ${uart_early_addr}
>  
>  EOF
>  fi
> -- 
> 2.48.1
> 

