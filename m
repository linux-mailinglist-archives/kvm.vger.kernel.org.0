Return-Path: <kvm+bounces-10785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B86086FDDB
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 10:43:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E058C1F23054
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 09:43:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6848C219FF;
	Mon,  4 Mar 2024 09:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bTXPuOYN"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CEA1B7F3
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 09:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709545416; cv=none; b=SaviAESNbjcBodoXSGH1qBcBOG+788XI2iS2lH16Pneorg12V71x+DWo4S9ibeVzSItoctKORJgjrDVJqLHY57/1xPUMZPzUA9PcgEJxnZMRQ5Q/UqrmNWnXz/jCKu+0JVZLpRBJz/tPzG4n6gvn/DA/Icr6uGNkL1kKytw3Mbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709545416; c=relaxed/simple;
	bh=4Lr3N9S/wXkia10zTPT1kANluV4/r0gq1VLGBHzdciI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CSP/wb5ORciKasIWcxZXLHLJYbqpQUBfDaZIoOhrW+noizGYHahy5p8jgCOy9CuOE2qcmpNgGeVXcnXpnc09NabPwVQLhcrWlY4EMFr4n45WzVMQ/pLvePM57TEQXxZxd8tDw856HvXcS9ejhzdIVmtEVAfD5O6lTe8H1h7V1Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bTXPuOYN; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 4 Mar 2024 10:43:29 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709545412;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qh5vTGaSlMQO1egzl1AdseTXmFMlI0RLPYwIDvBw8eM=;
	b=bTXPuOYNmHvl3Rce9VwSYn7DioKRGt9O4ynCx+i2fNCEFB6HPX4PLHM7XRwWU3Jv2lTe1f
	f0OWU8YzpftTWEjAADF5XMzlbjXeQHUXOaBldlzQrVHNi59r1cAzXeMoSuxbORU6Ow+ecH
	sN57f2MO1/lldS5lQwNPngMvX9ZmESg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, alexandru.elisei@arm.com, 
	eric.auger@redhat.com, shahuang@redhat.com, pbonzini@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 10/18] arm64: efi: Allow running tests
 directly
Message-ID: <20240304-af482ba06a722ff434d07d3e@orel>
References: <20240227192109.487402-20-andrew.jones@linux.dev>
 <20240227192109.487402-30-andrew.jones@linux.dev>
 <801c7883-2e16-4830-83bd-f8c2c67f4d2e@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <801c7883-2e16-4830-83bd-f8c2c67f4d2e@arm.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 04, 2024 at 07:52:40AM +0000, Nikos Nikoleris wrote:
> On 27/02/2024 19:21, Andrew Jones wrote:
> > Since it's possible to run tests with UEFI and the QEMU -kernel
> > option (and now the DTB will be found and even the environ will
> > be set up from an initrd if given with the -initrd option), then
> > we can skip the loading of EFI tests into a file system and booting
> > to the shell to run them. Just run them directly. Running directly
> > is waaaaaay faster than booting the shell first. We keep the UEFI
> > shell as the default behavior, though, and provide a new configure
> > option to enable the direct running.
> > 
> > Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> 
> Just a minor nit, see below, but in any case:
> 
> Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> 
> > ---
> >   arm/efi/run | 17 +++++++++++++++--
> >   arm/run     |  4 +++-
> >   configure   | 17 +++++++++++++++++
> >   3 files changed, 35 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arm/efi/run b/arm/efi/run
> > index b7a8418a07f8..af7b593c2bb8 100755
> > --- a/arm/efi/run
> > +++ b/arm/efi/run
> > @@ -18,10 +18,12 @@ elif [ -f /usr/share/edk2/aarch64/QEMU_EFI.silent.fd ]; then
> >   	DEFAULT_UEFI=/usr/share/edk2/aarch64/QEMU_EFI.silent.fd
> >   fi
> > +KERNEL_NAME=$1
> > +
> >   : "${EFI_SRC:=$TEST_DIR}"
> >   : "${EFI_UEFI:=$DEFAULT_UEFI}"
> >   : "${EFI_TEST:=efi-tests}"
> > -: "${EFI_CASE:=$(basename $1 .efi)}"
> > +: "${EFI_CASE:=$(basename $KERNEL_NAME .efi)}"
> >   : "${EFI_TESTNAME:=$TESTNAME}"
> >   : "${EFI_TESTNAME:=$EFI_CASE}"
> >   : "${EFI_CASE_DIR:="$EFI_TEST/$EFI_TESTNAME"}"
> > @@ -80,4 +82,15 @@ uefi_shell_run()
> >   		"${qemu_args[@]}"
> >   }
> > -uefi_shell_run
> > +if [ "$EFI_DIRECT" = "y" ]; then
> > +	if [ "$EFI_USE_ACPI" != "y" ]; then
> > +		qemu_args+=(-machine acpi=off)
> > +	fi
> 
> The if statement above is common for the efi and efi_direct paths. You could
> also move it above to avoid the code replication.

Will do.

Thanks,
drew

