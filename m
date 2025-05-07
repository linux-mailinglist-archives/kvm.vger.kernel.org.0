Return-Path: <kvm+bounces-45736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CD77AAE5CA
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 18:02:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C76DB3B1983
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 15:58:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1B2B28B7C2;
	Wed,  7 May 2025 15:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YqX9hj+3"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F405F233D92
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 15:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746633540; cv=none; b=ZLqqnWcKuW/l5etysjKVVb0X+B/bsta/b3Y327oC+y+gmP4qRga5PQLeQhQyBNkAh4cDySWlJdBA/WaPWkZTX1eCEusbupDN99vinW3wtJbH46qdF78yVaOhNtus9p+fCj4G8BuIyv1skraEaWYcMS+vXFyUugfuX00KotwuIuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746633540; c=relaxed/simple;
	bh=6O7L9ofUKt8/FouBRu1JfGIBnjjqfLnMjvQmIrxnWBs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NM0PvDrr1G4RR4FsGBWTtGkYImQUoWPsqSZ90tWMREIk7m/X53GjS5gCqOUzMVkAmmrHlW6zB1G6r15+9sH/8RnDx+jEuiu4QacaEcSevp7UdVN8lSZdOVtFZeohvXXYIWFc+fXEp3qkDkY3PQfui91TvOxm9TAQ8erbZgubhH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YqX9hj+3; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 7 May 2025 17:58:43 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746633526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ekBedcL1Lp3vekEN23FbKEi/Hlbj3mFx+ToO6OvQpxE=;
	b=YqX9hj+38OgRaOntcA9ClHnRF+VTU38CY8ZCoMRLgScpfivUKP9WCJ4xsKAseKQga5btxN
	Tb2wAbshPyrW/hSI9N1ZLIMfMRx5Y/iFtyG9WWcerzHCSD6BqjiZBSwZSWZcWv/stA71rB
	NXJTOMGyrWuIEx7Qo5bthakJ/oyO3MQ=
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
Subject: Re: [kvm-unit-tests PATCH v3 02/16] scripts: Add 'test_args' test
 definition parameter
Message-ID: <20250507-d69f4d5ffe44cedee80dad11@orel>
References: <20250507151256.167769-1-alexandru.elisei@arm.com>
 <20250507151256.167769-3-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507151256.167769-3-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT

On Wed, May 07, 2025 at 04:12:42PM +0100, Alexandru Elisei wrote:
...
>  # FPU/SIMD test
> @@ -276,17 +291,20 @@ arch = arm64
>  [mte-sync]
>  file = mte.flat
>  groups = mte
> -qemu_params = -machine mte=on -append 'sync'
> +test_args=sync

add spaces around =

> +qemu_params = -machine mte=on
>  arch = arm64
>  
>  [mte-async]
>  file = mte.flat
>  groups = mte
> -qemu_params = -machine mte=on -append 'async'
> +test_args=async

spaces

> +qemu_params = -machine mte=on
>  arch = arm64
>  
>  [mte-asymm]
>  file = mte.flat
>  groups = mte
> -qemu_params = -machine mte=on -append 'asymm'
> +test_args=asymm

spaces

...
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 400e8a082528..06cc58e79b69 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -80,12 +80,18 @@ function run()
>      local groups="$2"
>      local smp="$3"
>      local kernel="$4"
> -    local opts="$5"
> -    local arch="$6"
> -    local machine="$7"
> -    local check="${CHECK:-$8}"
> -    local accel="$9"
> -    local timeout="${10:-$TIMEOUT}" # unittests.cfg overrides the default
> +    local test_args="$5"
> +    local opts="$6"
> +    local arch="$7"
> +    local machine="$8"
> +    local check="${CHECK:-$9}"
> +    local accel="${10}"
> +    local timeout="${11:-$TIMEOUT}" # unittests.cfg overrides the default
> +
> +    # If $test_args is empty, qemu will interpret the first option after -append
> +    # as a kernel parameter instead of a qemu option, so make sure the -append
> +    # option is used only if $test_args is not empy.

                                                  ^ empty

Otherwise,

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

