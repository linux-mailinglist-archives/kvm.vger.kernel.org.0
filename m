Return-Path: <kvm+bounces-36134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CE7FA18174
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 16:56:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D91081887204
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 15:56:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 288181F471C;
	Tue, 21 Jan 2025 15:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jLVi0j66"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4011F2C57
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 15:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737474960; cv=none; b=rG7suNnv8UMttP+rsGXSM1fC0lFT/bVVEWGxiDE8JvLQptqHm0eLbXIY6ZDuB+tZdC1k4VCzxnj8YmtzZ2/xnoRKUJGNt1PtX4v4y2taWnOXzxXKOH4EgcABD7+vSsOr/pQ2ZSOOGxK8+bwAsezcp6ouDyAmiudrquLzTE2+m8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737474960; c=relaxed/simple;
	bh=vV8a59PAiRq7s+DZzmR4ZFPv7EkWYe5x4h3O07wsp58=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Un6BJ+Qsnzk1Gx0XnAJzUa8hJnghz1aU9aL2mLIAnfUdICYOvyFvLCgzlaomrRO8mM0Tjj7Rhn1V4XmzeCF835C/6oITyUwg0tmxqikCSKe4F8MEA9F5Gnavyt+FKEvE/xxXobpsxDkPFJhfVwCBoTeH4u2MHrU1OtA4NYy17zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jLVi0j66; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 21 Jan 2025 16:55:48 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1737474951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kHTOuyrf6b476FzSvoIER5fEZhvPhJ7qECQ1yaBVPL8=;
	b=jLVi0j6635xXGMEyTSFWna0XxMzqF2D1nptRyo0YaJbkTHBxTdhT3652Yr2iFc0Y5suHsA
	4Ei5OyRalZhl/ixQe29WtwJT80HAtPxSaIE95vxNxB08Xo3+igSKAk/Wjly3kv8oY4/7bI
	ptincaA2GFFdsPAgDVzzEIUHWHkOFaM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com, david@redhat.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org, 
	oliver.upton@linux.dev, suzuki.poulose@arm.com, yuzenghui@huawei.com, joey.gouly@arm.com, 
	andre.przywara@arm.com, Alexandru Elisei <alexandru.elisei@gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 05/18] scripts: Rename run_qemu_status
 -> run_test_status
Message-ID: <20250121-566d55e720f59e93c88af5e4@orel>
References: <20250120164316.31473-1-alexandru.elisei@arm.com>
 <20250120164316.31473-6-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250120164316.31473-6-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 20, 2025 at 04:43:03PM +0000, Alexandru Elisei wrote:
> From: Alexandru Elisei <alexandru.elisei@gmail.com>
> 
> For the arm/arm64 architectures, kvm-unit-tests can also be run using the
> kvmtool virtual machine manager. Rename run_qemu_status to run_test_status
> to make it more generic, in preparation to add support for kvmtool.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/run               | 4 ++--
>  powerpc/run           | 2 +-
>  riscv/run             | 4 ++--
>  s390x/run             | 2 +-
>  scripts/arch-run.bash | 2 +-
>  5 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arm/run b/arm/run
> index 6db32cf09c88..9b11feafffdd 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -85,9 +85,9 @@ command+=" -display none -serial stdio"
>  command="$(migration_cmd) $(timeout_cmd) $command"
>  
>  if [ "$UEFI_SHELL_RUN" = "y" ]; then
> -	ENVIRON_DEFAULT=n run_qemu_status $command "$@"
> +	ENVIRON_DEFAULT=n run_test_status $command "$@"
>  elif [ "$EFI_USE_ACPI" = "y" ]; then
> -	run_qemu_status $command -kernel "$@"
> +	run_test_status $command -kernel "$@"
>  else
>  	run_qemu $command -kernel "$@"
>  fi
> diff --git a/powerpc/run b/powerpc/run
> index 27abf1ef6a4d..9b5fbc1197ed 100755
> --- a/powerpc/run
> +++ b/powerpc/run
> @@ -63,4 +63,4 @@ command="$(migration_cmd) $(timeout_cmd) $command"
>  # to fixup the fixup below by parsing the true exit code from the output.
>  # The second fixup is also a FIXME, because once we add chr-testdev
>  # support for powerpc, we won't need the second fixup.
> -run_qemu_status $command "$@"
> +run_test_status $command "$@"
> diff --git a/riscv/run b/riscv/run
> index 73f2bf54dc32..2a846d361a4d 100755
> --- a/riscv/run
> +++ b/riscv/run
> @@ -34,8 +34,8 @@ command+=" $mach $acc $firmware -cpu $processor "
>  command="$(migration_cmd) $(timeout_cmd) $command"
>  
>  if [ "$UEFI_SHELL_RUN" = "y" ]; then
> -	ENVIRON_DEFAULT=n run_qemu_status $command "$@"
> +	ENVIRON_DEFAULT=n run_test_status $command "$@"
>  else
>  	# We return the exit code via stdout, not via the QEMU return code
> -	run_qemu_status $command -kernel "$@"
> +	run_test_status $command -kernel "$@"
>  fi
> diff --git a/s390x/run b/s390x/run
> index 34552c2747d4..9ecfaf983a3d 100755
> --- a/s390x/run
> +++ b/s390x/run
> @@ -47,4 +47,4 @@ command+=" -kernel"
>  command="$(panic_cmd) $(migration_cmd) $(timeout_cmd) $command"
>  
>  # We return the exit code via stdout, not via the QEMU return code
> -run_qemu_status $command "$@"
> +run_test_status $command "$@"
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 8643bab3b252..d6eaf0ee5f09 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -75,7 +75,7 @@ run_qemu ()
>  	return $ret
>  }
>  
> -run_qemu_status ()
> +run_test_status ()
>  {
>  	local stdout ret
>  
> -- 
> 2.47.1

Hmm, run_qemu_status() wraps run_qemu() so it seems appropriately named,
especially since the return value of run_qemu() has had QEMU-specific
return codes considered. It seems we should first decouple
run_qemu_status() from run_qemu() or to sanitize run_qemu() of anything
QEMU-specific and rename it to run_test() at the same time.

Thanks,
drew

