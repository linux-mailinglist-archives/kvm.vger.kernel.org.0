Return-Path: <kvm+bounces-68214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7442AD26D9D
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 18:51:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 40C023088588
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 17:44:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3B7D2D9ECB;
	Thu, 15 Jan 2026 17:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NATUilqy"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF55143AA4
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 17:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499091; cv=none; b=LDkl/mA1bePj9mpmReZIyh2E6Sz+hLGWfRwiPacNH/mCBnqAfIbH9Zz9pgvWhLObKk3K8NaFDlPvFGYyI+312u5RPoL98dBX5IM+E8ad2eGA1JEI3pyELPQiCFZw9xoyjcGMQVZBrDXWsUICvePlJTOKiNSANhf/I0bed25vfgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499091; c=relaxed/simple;
	bh=P976BOHLnV6sVYTAnXc5kPCIkTAoCioEWsFNvBAlj10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F3mDYNiwcrAZTj1PoWMZg8WKRKkE2fEVsAw5PR2KWMf6gkr1b8dkUU3VsYVNLBGFFSFrpyXTL1G/jFITAEOLmJOkL9wgHbB31jExa9Wv/JaBxMq01Zc4QX4uXsiN7lUscuAcfS0+RNYQfwEgiQe1b3sq9pg45v+BRKKISyBIEbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NATUilqy; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 15 Jan 2026 11:44:31 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768499077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hePkjZ91yVumu/kAJG4D+Rdy/dn636U2VtRIR34dJkU=;
	b=NATUilqyzPOnnJkZfVvVbhGLAVXzARrX1e4ywPlO7n6m4OvbVDgjYZpC4m2TtqmHlnCIHQ
	/UVJD6lrk5qbRrJodjkadw0kbh0Zuelvnp0QuP+gYgabgfTpNeudiZd2HMwYD9gptEJJXY
	j5rDi+vFc5o4DZtO9/QBdYVcJSI4jtU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com, 
	maz@kernel.org, kvmarm@lists.linux.dev, Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v5 11/11] arm64: add EL2 environment
 variable
Message-ID: <2yzhh4aylpjmff4wlehzqsbmexdmphzvh3gdm34ygnoxrxljzw@emvamgbokscf>
References: <20260114115703.926685-1-joey.gouly@arm.com>
 <20260114115703.926685-12-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114115703.926685-12-joey.gouly@arm.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jan 14, 2026 at 11:57:03AM +0000, Joey Gouly wrote:
> This variable when set to y/Y/1 will cause QEMU/kvmtool to start at EL2.
> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Acked-by: Marc Zyngier <maz@kernel.org>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> ---
>  arm/run | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arm/run b/arm/run
> index 858333fc..266ed1cf 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -59,6 +59,10 @@ function arch_run_qemu()
>  		M+=",highmem=off"
>  	fi
>  
> +	if [ "$EL2" == "1" ] || [ "$EL2" = "Y" ] || [ "$EL2" = "y" ]; then
                    ^ == instead of = here. Same comment below.

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
> +	if [ "$EL2" == "1" ] || [ "$EL2" = "Y" ] || [ "$EL2" = "y" ]; then
> +		command+=" --nested"
> +	fi

Should use some blank lines here.

>  	if [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ]; then
>  		run_test_status $command --kernel "$@" --aarch32
>  	else
> -- 
> 2.25.1
>

I've made the above changes and also factored the checks out into a common
function

diff --git a/arm/run b/arm/run
index 858333fce465..2d5ee672ec13 100755
--- a/arm/run
+++ b/arm/run
@@ -59,6 +59,10 @@ function arch_run_qemu()
 		M+=",highmem=off"
 	fi
 
+	if is_enabled "$EL2"; then
+		M+=",virtualization=on"
+	fi
+
 	if ! $qemu $M -device '?' | grep -q virtconsole; then
 		echo "$qemu doesn't support virtio-console for chr-testdev. Exiting."
 		exit 2
@@ -116,6 +120,11 @@ function arch_run_kvmtool()
 	fi
 
 	command="$(timeout_cmd) $kvmtool run"
+
+	if is_enabled "$EL2"; then
+		command+=" --nested"
+	fi
+
 	if [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ]; then
 		run_test_status $command --kernel "$@" --aarch32
 	else
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 16417a1eba38..01cc1ff29728 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -596,3 +596,8 @@ set_qemu_accelerator ()
 
 	return 0
 }
+
+is_enabled ()
+{
+	[[ "$1" == 1 ]] || [[ "$1" == Y ]] || [[ "$1" == y ]]
+}
-- 
2.43.0

Thanks,
drew

