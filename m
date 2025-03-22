Return-Path: <kvm+bounces-41754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DDE7A6C9E5
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 12:25:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC4F24644D1
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 11:25:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00D491FC111;
	Sat, 22 Mar 2025 11:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="w8tD0vKS"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62BDAD27
	for <kvm@vger.kernel.org>; Sat, 22 Mar 2025 11:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742642717; cv=none; b=GgBPyCfG5YK8UoakMZli8Wx0vfSdT8e6ybX1BP8RGrQ7g9dgcZ4JMyuIzPfePJWtPt+u6e7oUPMf9IGUOHJQ9jSekIDyKlJEyKCmLFQmvEqAgOIyAVIdWAIBj9CZHukH3mgHUf4yB7o1v+QGROwgbjdKvDLViENEX1On3O0jl8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742642717; c=relaxed/simple;
	bh=tvjwqnEvt6QStVcfy4Rtfr52n68UsZuO9plyfyU7FrA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uk0ZStJDrZc9bKW0wZiCFQbNouwldjWXf/8F3E+417U0Yjkd94GKtExKFOnYC3om982jwOWEuIFVHBssYcJTQ91NlNp0wWq6vsJI8UyPTzLxXw6HqI8KnOj1JcqNq1ndfFzSIRlUsuTPDB9m5GiJkd8s+lWQIPFJ6SHvMIezw8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=w8tD0vKS; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Sat, 22 Mar 2025 12:25:02 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742642710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vkm0wuie4+J7Oy46hCMinD5wTVCsPYzKlHvlkij180U=;
	b=w8tD0vKSU1lQJ9NP40XB9yM0wVGnZ6HrC0Eolf/SvvqAyYTx585fgc/mUSp24IVCwCEJfb
	Vp/WCEYtHpAIMZ90MziuFkZJRN3151g4GRn0kALI3aQU4zeLGL5lKmJUuCUI3zmz7bk61e
	FqtAWwc9sypScHd0/FINLxpt3RfZuFU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>, 
	eric.auger@redhat.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, vladimir.murzin@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 4/5] configure: Add --qemu-cpu option
Message-ID: <20250322-f2d94472d7ebc003a54d7a9d@orel>
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
 <20250314154904.3946484-6-jean-philippe@linaro.org>
 <Z9wbKfRJ7P0tms6L@raptor>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9wbKfRJ7P0tms6L@raptor>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 20, 2025 at 01:42:01PM +0000, Alexandru Elisei wrote:
...
> >  mach=$MACHINE_OVERRIDE
> > -processor=$PROCESSOR_OVERRIDE
> > +qemu_cpu=$QEMU_CPU_OVERRIDE
> 
> The name QEMU_CPU_OVERRIDE makes more sense, but I think this will break
> existing setups where people use PROCESSOR_OVERRIDE to pass a particular
> -cpu value to qemu.
> 
> If I were to guess, the environment variable was added to pass a value to
> -cpu different than what it can be specified with ./configure --processor,
> which is exactly what --qemu-cpu does. But I'll let Drew comment on that.

Yeah, ideally we wouldn't rename environment variables, but I'll cross my
fingers that nobody will notice. Indeed, it was created to avoid needing
to reconfigure for experimenting with different QEMU cpu models, so, even
with --qemu-cpu we'll want something and the renaming here makes sense.

> 
> >  firmware=$FIRMWARE_OVERRIDE
> >  
> > -[ "$PROCESSOR" = "$ARCH" ] && PROCESSOR="max"
> > +[ -z "$QEMU_CPU" ] && QEMU_CPU="max"
> >  : "${mach:=virt}"
> > -: "${processor:=$PROCESSOR}"
> > +: "${qemu_cpu:=$QEMU_CPU}"
> >  : "${firmware:=$FIRMWARE}"
> >  [ "$firmware" ] && firmware="-bios $firmware"
> >  
> > @@ -32,7 +32,7 @@ fi
> >  mach="-machine $mach"
> >  
> >  command="$qemu -nodefaults -nographic -serial mon:stdio"
> > -command+=" $mach $acc $firmware -cpu $processor "
> > +command+=" $mach $acc $firmware -cpu $qemu_cpu "
> >  command="$(migration_cmd) $(timeout_cmd) $command"
> >  
> >  if [ "$UEFI_SHELL_RUN" = "y" ]; then
> > diff --git a/configure b/configure
> > index 5306bad3..d25bd23e 100755
> > --- a/configure
> > +++ b/configure
> > @@ -52,6 +52,7 @@ page_size=
> >  earlycon=
> >  efi=
> >  efi_direct=
> > +qemu_cpu=
> >  
> >  # Enable -Werror by default for git repositories only (i.e. developer builds)
> >  if [ -e "$srcdir"/.git ]; then
> > @@ -69,6 +70,8 @@ usage() {
> >  	    --arch=ARCH            architecture to compile for ($arch). ARCH can be one of:
> >  	                           arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
> >  	    --processor=PROCESSOR  processor to compile for ($processor)
> > +	    --qemu-cpu=CPU         the CPU model to run on. The default depends on
> > +	                           the configuration, usually it is "host" or "max".
> 
> Nitpick here, would you mind changing this to "The default value depends on
> the host system and the test configuration [..]", to make it clear that it also
> depends on the machine the tests are being run on?

I agree.

Thanks,
drew

