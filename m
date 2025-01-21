Return-Path: <kvm+bounces-36142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DC28A181C6
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 17:13:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C688C188A2A7
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 16:13:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C2F31F470D;
	Tue, 21 Jan 2025 16:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Byr2Vvxi"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C0A1F3D4D
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 16:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737475992; cv=none; b=Z37hi59Gi7tACw+O/9jkYIX220ZUDa0I8iA/339xTlpJxJOO/rQFL3m4dHtAtzfXmVVeP77JFu5gKxX6H/L+MYnc7YVMHWLKZVB5KzF7+A4wAAW1UwFeBZgncno25ma6kQYcW0hUjvyeq/mVpgP2AHWfFw8tzUlvRsfVhk3M4og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737475992; c=relaxed/simple;
	bh=L/5/3bjEMyXzpJBosOjNQymlazXTMh854tD2CyB+CZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JTgxkOmswGoWJ+Hb1lcB+LgpvmZU1ZaQtTCwU15oJ5DHpczWwILugmm1PNVFODIdAYBSrKxyWH5+8Lq3KoOIb2y//wY1K5I5j3Tu1iaDtM/4kH1wR89ejlntjtLmRODV+rmRKxSq2r4Jb5K3rWkAnsO10ZlmeByG3rGmootE6yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Byr2Vvxi; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 21 Jan 2025 17:12:47 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1737475977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cyMTmEzB2/U6qcXH179gcIg8qFA+t5ge+uEkmTrIDFY=;
	b=Byr2VvxiU4c4qpp4KsGIfvIfoTPSZ94lhRmH+7449u1XN5es1s1AwV/ecHaLHam3bHowaF
	4hz5gb9XUH9F00XF8neP4/tNH54hlIET6NQYR94xWksNJuvAn8CNEebEkY4KDt+x/21bjR
	tbIQjxaL4tDARm9tN25cSgoF3rfVa+Q=
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
Subject: Re: [kvm-unit-tests PATCH v2 06/18] scripts: Merge the qemu
 parameter -smp into $qemu_opts
Message-ID: <20250121-293c6d322b91d5ff51291ad6@orel>
References: <20250120164316.31473-1-alexandru.elisei@arm.com>
 <20250120164316.31473-7-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250120164316.31473-7-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 20, 2025 at 04:43:04PM +0000, Alexandru Elisei wrote:
> kvmtool has a different command line parameter to specify the number of
> VCPUs (-c/--cpus). To make it easier to accommodate it, merge the qemu
> specific parameter -smp into $qemu_opts when passing it to the
> $RUNTIME_arch_run script.
> 
> This is safe to do because the $RUNTIME_arch_run script, on all
> architectures, passes the parameters right back to run_qemu() et co, and
> do not treat individual parameters separately.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  scripts/runtime.bash | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index e5d661684ceb..a89f2d10ab78 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -34,7 +34,8 @@ premature_failure()
>  get_cmdline()
>  {
>      local kernel=$1
> -    echo "TESTNAME=$testname TIMEOUT=$timeout MACHINE=$machine ACCEL=$accel $RUNTIME_arch_run $kernel -smp $smp $qemu_opts"
> +
> +    echo "TESTNAME=$testname TIMEOUT=$timeout MACHINE=$machine ACCEL=$accel $RUNTIME_arch_run $kernel $qemu_opts"
>  }
>  
>  skip_nodefault()
> @@ -87,6 +88,8 @@ function run()
>      local accel="$9"
>      local timeout="${10:-$TIMEOUT}" # unittests.cfg overrides the default
>  
> +    qemu_opts="-smp $smp $qemu_opts"
> +
>      if [ "${CONFIG_EFI}" == "y" ]; then
>          kernel=${kernel/%.flat/.efi}
>      fi
> -- 
> 2.47.1
>

This seems fine, but I still think we want qemu_opts to be opts and we can
parameterize the option names. So we could have a table of option names
that we use in places like this

declare -A vmm_opts

vmm_opts[qemu,nr_cpus]='-smp'
vmm_opts[qemu,another_option]='foo'

vmm_opts[kvmtool,nr_cpus]='-c'
vmm_opts[kvmtool,another_option]='bar'

# $vmm gets set to whatever vmm we're using, e.g. vmm=qemu

opts="${vmm_opts[$vmm,nr_cpus]} $smp $opts"

Thanks,
drew

