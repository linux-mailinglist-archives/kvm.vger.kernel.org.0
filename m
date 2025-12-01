Return-Path: <kvm+bounces-65051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C4BCDC9998D
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 00:35:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 645F13A4441
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 23:35:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2732A28E571;
	Mon,  1 Dec 2025 23:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EZF+aHK2"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE5A192B75
	for <kvm@vger.kernel.org>; Mon,  1 Dec 2025 23:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764632119; cv=none; b=lf6yjR543zO11VmtKBC8JTzwETDXrTapAj48bLGS7Xcf+G867nda3sN1Cs0NnI4F6Pkg7RQrWYYyMr2gulpltypLZcLbwt4jan8UkKZ2LIbpITVIAubVEZX5b4s2huW6LiW6DUljlyd/pGiro5DAnN27TL91UeNVdd656VrLWyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764632119; c=relaxed/simple;
	bh=AuJGuGtsHdS3xk031eDwxs7JKAN6oFUvFUcxyqlE7tM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PCjWeMdnyAjTKZr5XwjUPrtcFZX3Fv8G4KL3026BXsPcw4tCdZxaMyOxCWLofwAWs43DlC55jnUYFlEmtiJvd1v6N1FAX/3hfKtBRHHfWA5IvJUEA/pqD9ANcrIh+tTWbZNV+cw/ZzfaEe9XJm5S3QdpH77Ldq5DizVBBpTQ8zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EZF+aHK2; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 1 Dec 2025 17:34:57 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764632105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DmR3Mr3V3KyKYyAMw2wPTB//qSQSjvj0UFM0Ln0Rpj4=;
	b=EZF+aHK2ZzhaIg8+8F7R0xsdgjVBtqOLFgamxmXhBMJOHN/FUg30MPZjmbWyEwZAAVGkv+
	i9bKdAjCaI3zvuwbc44LeFjNpa0FAd+THdRbviH/+gP9vQojz3OjR4EMwkE2pKOkflKUOb
	3HQzrOjMhZ4CaaJy0erxtdMnRtO0g9I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, kvmarm@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v3 10/10] arm64: add EL2 environment
 variable
Message-ID: <20251201-8bd3f30dc0e9b2378c27e6d9@orel>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <20250925141958.468311-11-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250925141958.468311-11-joey.gouly@arm.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Sep 25, 2025 at 03:19:58PM +0100, Joey Gouly wrote:
> This variable when set to 1 will cause QEMU/kvmtool to start at EL2.
> ---
>  arm/run | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arm/run b/arm/run
> index 858333fc..2a9c0de0 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -59,6 +59,10 @@ function arch_run_qemu()
>  		M+=",highmem=off"
>  	fi
>  
> +	if [ "$EL2" = "1" ]; then

Please also support 'y' and 'Y', e.g. 'EL2=y run_tests.sh -g ...'

Thanks,
drew

> +		M+=",virtualization=on"
> +	fi
> +
>  	if ! $qemu $M -device '?' | grep -q virtconsole; then
>  		echo "$qemu doesn't support virtio-console for chr-testdev. Exiting."
>  		exit 2
> @@ -116,6 +120,9 @@ function arch_run_kvmtool()
>  	fi
>  
>  	command="$(timeout_cmd) $kvmtool run"
> +	if [ "$EL2" = "1" ]; then
> +		command+=" --nested"
> +	fi
>  	if [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ]; then
>  		run_test_status $command --kernel "$@" --aarch32
>  	else
> -- 
> 2.25.1
> 

