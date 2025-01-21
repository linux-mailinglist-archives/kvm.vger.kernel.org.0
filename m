Return-Path: <kvm+bounces-36147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E6E3A181F0
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 17:24:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB5851670EA
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 16:24:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC2171F4730;
	Tue, 21 Jan 2025 16:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MRTrxH9c"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C250A5028C;
	Tue, 21 Jan 2025 16:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737476672; cv=none; b=XJfcHvH7jK7vy8atMqZyIKlymDfxapyr5LXCMmRVOaEnsW64gbSDRZbo4PVGy9lfE3BvqleaxvAQoX6AeGarhwsvJGGHUZ8jo7QLA8mT424gwfaPJ10D2zJQ/mNL2aI+UJvC98TdzjsO1rFypveg5buU7m76+XbtgWnyWFMjsBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737476672; c=relaxed/simple;
	bh=ModynsT2PhawoYM1QantEi1haH7A1vxEmaQQhlROGSY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZvymJJMMjBEIZRefX4lS8+eX/j/3n/ZsFo9qRdNRkAIPAbCa1H2dcLCJNR5WM2eV4zZ+BB0dGwUvnjn/b+gsU8aglHFf4Rv9enJ0gzgiHsTlVzCSdgh+DhTIAHBwpY1c8UD2ju0PwOeBs4KdLGJuNJ0yIUAAmGAHoOa28Sf31d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MRTrxH9c; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 21 Jan 2025 17:24:23 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1737476668;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H6pzkPiNgYGUEzo0pWRd1g0zmrJRFWgoHspDsCsXeo0=;
	b=MRTrxH9cLSMxf51WTQhkuQO65jTuw3qwoo1tjBxJihfQOf2x5FOyehb8UWzv4SKKAzuQB5
	rD44pG5X2+C1NjVUsr6PuOMEbUBG2/znpG7wMaPh1mM8cfAAAKGU2jRnsPvWkdT0tjU6Ya
	UDXoiEOzDjdymvmiH/k00tiHzEWuDh8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com, david@redhat.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org, 
	oliver.upton@linux.dev, suzuki.poulose@arm.com, yuzenghui@huawei.com, joey.gouly@arm.com, 
	andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 07/18] scripts: Introduce kvmtool_opts
Message-ID: <20250121-9bef2681da529d9d41f524d3@orel>
References: <20250120164316.31473-1-alexandru.elisei@arm.com>
 <20250120164316.31473-8-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250120164316.31473-8-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 20, 2025 at 04:43:05PM +0000, Alexandru Elisei wrote:
> In preparation for supporting kvmtool, create and pass the variable
> 'kvmtool_opts' to the arch run script $RUNTIME_arch_run.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  scripts/common.bash  |  6 ++++--
>  scripts/runtime.bash | 14 +++++++++++---
>  2 files changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/scripts/common.bash b/scripts/common.bash
> index a40c28121b6a..1b5e0d667841 100644
> --- a/scripts/common.bash
> +++ b/scripts/common.bash
> @@ -37,6 +37,7 @@ function for_each_unittest()
>  	local check
>  	local accel
>  	local timeout
> +	local kvmtool_opts
>  	local rematch
>  
>  	exec {fd}<"$unittests"
> @@ -45,7 +46,7 @@ function for_each_unittest()
>  		if [[ "$line" =~ ^\[(.*)\]$ ]]; then
>  			rematch=${BASH_REMATCH[1]}
>  			if [ -n "${testname}" ]; then
> -				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$qemu_opts" "$arch" "$machine" "$check" "$accel" "$timeout"
> +				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$qemu_opts" "$arch" "$machine" "$check" "$accel" "$timeout" "$kvmtool_opts"

It looks odd to have both qemu_opts and kvmtool_opts at the same time.

>  			fi
>  			testname=$rematch
>  			smp=1
> @@ -57,6 +58,7 @@ function for_each_unittest()
>  			check=""
>  			accel=""
>  			timeout=""
> +			kvmtool_opts=""
>  		elif [[ $line =~ ^file\ *=\ *(.*)$ ]]; then
>  			kernel=$TEST_DIR/${BASH_REMATCH[1]}
>  		elif [[ $line =~ ^smp\ *=\ *(.*)$ ]]; then
> @@ -80,7 +82,7 @@ function for_each_unittest()
>  		fi
>  	done
>  	if [ -n "${testname}" ]; then
> -		$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$qemu_opts" "$arch" "$machine" "$check" "$accel" "$timeout"
> +		$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$qemu_opts" "$arch" "$machine" "$check" "$accel" "$timeout" "$kvmtool_opts"
>  	fi
>  	exec {fd}<&-
>  }
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index a89f2d10ab78..451b5585f010 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -35,7 +35,7 @@ get_cmdline()
>  {
>      local kernel=$1
>  
> -    echo "TESTNAME=$testname TIMEOUT=$timeout MACHINE=$machine ACCEL=$accel $RUNTIME_arch_run $kernel $qemu_opts"
> +    echo "TESTNAME=$testname TIMEOUT=$timeout MACHINE=$machine ACCEL=$accel $RUNTIME_arch_run $kernel $opts"
>  }
>  
>  skip_nodefault()
> @@ -87,8 +87,16 @@ function run()
>      local check="${CHECK:-$8}"
>      local accel="$9"
>      local timeout="${10:-$TIMEOUT}" # unittests.cfg overrides the default
> -
> -    qemu_opts="-smp $smp $qemu_opts"
> +    local kvmtool_opts="${11}"
> +
> +    case "$TARGET" in
> +    qemu)
> +        opts="-smp $smp $qemu_opts"
> +        ;;
> +    kvmtool)
> +        opts="--cpus $smp $kvmtool_opts"
> +        ;;
> +    esac

This is similar to what I was proposing with the associative array, but
we'll only need to set a $vmm variable once with the array. If parsing
command lines is different between the vmms then we can even add
functions to the table

vmm_opts[qemu,func]=qemu_func
vmm_opts[kvmtool,func]=kvmtool_func

eval ${vmm_opts[$vmm,func]} ...

Thanks,
drew

>  
>      if [ "${CONFIG_EFI}" == "y" ]; then
>          kernel=${kernel/%.flat/.efi}
> -- 
> 2.47.1
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

