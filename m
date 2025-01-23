Return-Path: <kvm+bounces-36362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C76ABA1A572
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 15:07:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 51D087A085D
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 14:07:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90E9120FAB7;
	Thu, 23 Jan 2025 14:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="r41LZca+"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7A620F96B
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 14:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737641248; cv=none; b=uDMaF0Pz6DEi+3Lr6SQNbtDOQfr1p6CQK9dU178yyFnf06uarTcpU87l9pTnalq0x73y2/Z2nQS7agobS7DJuh1gxF/XPaWYD4PGmxkCstDX4lXrCETHvUQx+fm57mN8TnbaRq7sLmhZfp9WSOy+g/DRDUGY0I0i2ilVNB7MKB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737641248; c=relaxed/simple;
	bh=ZIwKFzk0Q/xzgIcE0IKnf1QwQMXGxdYsIcr/aL2YqZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SUzhBZazyqr9g8UEkcQMzj2pwxsnCtLIake3bzeXnz2aHclgxxdjW7M2Sjx2a5B+IkPmPN7K/APPhpSwsxZHCoH9DidoLDd/T5YDAS4ozryDSPa6AwnkUih72TNj2wSnJjLbk13Gq14FD0hO3E3BUaOAlq0uADBo9DZEwKXz+vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=r41LZca+; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 23 Jan 2025 15:07:18 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1737641243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wiYAC4Ucxcm7KuFAC5tUIQUTt4eAoBsu+z1SGcrkjzs=;
	b=r41LZca+Sg/9Rc14gHPNbCgZPgDw6X/CzWbgkYZYXTZWfG9IYDtoDglUvjOpuR+psOcRFP
	bVQkbsAuJLGvQhJcpWMAvbb5zRT6xkvAW9FFr+yMuz1EEAIFRpfQDHRFsRH80+9mTCqLQo
	Qh+GFBQVRggjkwqI0l6xn+R27U6C8Ro=
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
Subject: Re: [kvm-unit-tests PATCH v2 12/18] scripts/runtime: Add default
 arguments for kvmtool
Message-ID: <20250121-16510b161f5b92ce9c5ae4e1@orel>
References: <20250120164316.31473-1-alexandru.elisei@arm.com>
 <20250120164316.31473-13-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250120164316.31473-13-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 20, 2025 at 04:43:10PM +0000, Alexandru Elisei wrote:
> kvmtool, unless told otherwise, will do its best to make sure that a kernel
> successfully boots in a virtual machine. Among things like automatically
> creating a rootfs, it also adds extra parameters to the kernel command
> line. This is actively harmful to kvm-unit-tests, because some tests parse
> the kernel command line and they will fail if they encounter the options
> added by kvmtool.
> 
> Fortunately for us, kvmtool commit 5613ae26b998 ("Add --nodefaults command
> line argument") addded the --nodefaults kvmtool parameter which disables

added

> all the implicit virtual machine configuration that cannot be disabled by
> using other parameters, like modifying the kernel command line. Always use
> --nodefaults to allow a test to run.
> 
> kvmtool can be too verbose when running a virtual machine, and this is
> controlled with parameters. Add those to the default kvmtool command line
> to reduce this verbosity to a minimum.
> 
> Before:
> 
> $ vm run arm/selftest.flat --cpus 2 --mem 256 --params "setup smp=2 mem=256"
>   Info: # lkvm run -k arm/selftest.flat -m 256 -c 2 --name guest-5035
> Unknown subtest
> 
> EXIT: STATUS=127
>   Warning: KVM compatibility warning.
> 	virtio-9p device was not detected.
> 	While you have requested a virtio-9p device, the guest kernel did not initialize it.
> 	Please make sure that the guest kernel was compiled with CONFIG_NET_9P_VIRTIO=y enabled in .config.
>   Warning: KVM compatibility warning.
> 	virtio-net device was not detected.
> 	While you have requested a virtio-net device, the guest kernel did not initialize it.
> 	Please make sure that the guest kernel was compiled with CONFIG_VIRTIO_NET=y enabled in .config.
>   Info: KVM session ended normally.
> 
> After:
> 
> $ vm run arm/selftest.flat --nodefaults --network mode=none --loglevel=warning --cpus 2 --mem 256 --params "setup smp=2 mem=256"

On riscv I've noticed that with --nodefaults if I don't add parameters
with --params then kvmtool segfaults. I have to add --params "" to
avoid it. Does that also happen on arm? Anyway, that's something we
should fix in kvmtool rather than workaround it here.

> PASS: selftest: setup: smp: number of CPUs matches expectation
> INFO: selftest: setup: smp: found 2 CPUs
> PASS: selftest: setup: mem: memory size matches expectation
> INFO: selftest: setup: mem: found 256 MB
> SUMMARY: 2 tests
> 
> EXIT: STATUS=1
> 
> Note that KVMTOOL_DEFAULT_OPTS can be overwritten by an environment
> variable with the same name, but it's not documented in the help string for
> run_tests.sh. This has been done on purpose, since overwritting
> KVMTOOL_DEFAULT_OPTS should only be necessary for debugging or development
> purposes.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  scripts/runtime.bash | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 55d58eef9c7c..abfd1e67b2ef 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -2,6 +2,17 @@
>  : "${MAX_SMP:=$(getconf _NPROCESSORS_ONLN)}"
>  : "${TIMEOUT:=90s}"
>  
> +# The following parameters are enabled by default when running a test with
> +# kvmtool:
> +# --nodefaults: suppress VM configuration that cannot be disabled otherwise
> +#               (like modifying the supplied kernel command line). Tests that
> +#               use the command line will fail without this parameter.
> +# --network mode=none: do not create a network device. kvmtool tries to help the
> +#                user by automatically create one, and then prints a warning
> +#                when the VM terminates if the device hasn't been initialized.
> +# --loglevel=warning: reduce verbosity
> +: "${KVMTOOL_DEFAULT_OPTS:="--nodefaults --network mode=none --loglevel=warning"}"
> +
>  PASS() { echo -ne "\e[32mPASS\e[0m"; }
>  SKIP() { echo -ne "\e[33mSKIP\e[0m"; }
>  FAIL() { echo -ne "\e[31mFAIL\e[0m"; }
> @@ -103,7 +114,7 @@ function run()
>          opts="-smp $smp $qemu_opts"
>          ;;
>      kvmtool)
> -        opts="--cpus $smp $kvmtool_opts"
> +        opts="$KVMTOOL_DEFAULT_OPTS --cpus $smp $kvmtool_opts"
>          ;;
>      esac
>  
> -- 
> 2.47.1
>

Otherwise,

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

