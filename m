Return-Path: <kvm+bounces-41756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CBCECA6C9E7
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 12:28:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 30750189F9A8
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 11:28:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61C641FC7F0;
	Sat, 22 Mar 2025 11:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TX2eRdgq"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A264FAD27
	for <kvm@vger.kernel.org>; Sat, 22 Mar 2025 11:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742642883; cv=none; b=lqcfoUhdOdv7nng6nonFebybr/veotGFjfvICcQY2Ox2+xec31Ynod+acbg+kyJA+AaZvvI8Z7vvW+gqxsoEZox0QqBK+KdYXpcgaxbPDFojBbsXbQczipx2huNqthXkzULwRmX7bFvOjIe2lgqbS5ZAdwtjhXFP0HtmeUszOq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742642883; c=relaxed/simple;
	bh=0Pgi3i8yV0h20KBVFyzaF5PYmWazpZcpnf0txiuiGVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qQ7L3rt3kDzPs70+4Pnc1WW1l6PLvBnVe/1HHgLDosIVU0sk+gff7IQty3lIGM96PIUjru1kDzU0I7Y0N6PokYtX3FBSHjEpPmHQ03znR960egRwQutBoIg1VywvjuYEg5z6CPJzsMYVONM+ESm8WvwhW3nc9BMjQx5DfWI3WA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TX2eRdgq; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Sat, 22 Mar 2025 12:27:56 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742642879;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OIOHPwdS2grkXZETZCyBEn9eNoWFlgKvyBxcmW/d7eY=;
	b=TX2eRdgq+l0TsCN5s39NiZc06KTANgjhVcFJedxZSWkLsjpBI7ng69B4RjPhLemSC6oa9l
	OviWqHItjrA9wlDiIuL0YbNkI2mH+Ohrb/VbShzMx3QBsyND9yaZzCaHRglAobvTe6IerF
	nZ/rEzmt49Ge/AV9brs1ZqMIV3xxhto=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	vladimir.murzin@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 5/5] arm64: Use -cpu max as the default
 for TCG
Message-ID: <20250322-c669034d2100a75ab6e53882@orel>
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
 <20250314154904.3946484-7-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250314154904.3946484-7-jean-philippe@linaro.org>
X-Migadu-Flow: FLOW_OUT

On Fri, Mar 14, 2025 at 03:49:05PM +0000, Jean-Philippe Brucker wrote:
> In order to test all the latest features, default to "max" as the QEMU
> CPU type on arm64.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>  arm/run | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arm/run b/arm/run
> index 561bafab..84232e28 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -45,7 +45,7 @@ if [ -z "$qemu_cpu" ]; then
>  			qemu_cpu+=",aarch64=off"
>  		fi
>  	elif [ "$ARCH" = "arm64" ]; then
> -		qemu_cpu="cortex-a57"
> +		qemu_cpu="max"
>  	else
>  		qemu_cpu="cortex-a15"

arm should also be able to default to 'max', right?

Thanks,
drew

>  	fi
> -- 
> 2.48.1
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

