Return-Path: <kvm+bounces-16395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 495338B9572
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 09:44:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 41874B21893
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 07:44:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BB98288DB;
	Thu,  2 May 2024 07:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qoKIHPj5"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E962869A
	for <kvm@vger.kernel.org>; Thu,  2 May 2024 07:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714635823; cv=none; b=l2kFTgxzTjsrYAyx2/scJPflYZ+vCCr6Ys2teY4+++vG2elkdSVrcyILjhtxSd5FYGinJnoWBa35UsCNlht81F5m6xPijE8wxMF5e0pJFrS9hPztisxrO8xJmAx3QnTI1Lya4iFBw4d3nIFNpOJ0NmUIzy/oi5P7hVbkmWN0e18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714635823; c=relaxed/simple;
	bh=pl7dl4fpQpA/07CXpebrIaa3E9KHNYYNcnKo/7dutQA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CdAI9keZmWxfhrv2pYNTL12fT9WTHGNaPGOs1xMwfrvGLRIwySdpNli/bDBI/vc5GSABB+C+g90k7HIK7ctyT96EOhFJsRyqlLE5qSnlNOQug5SLi/NiN+41R9Qp4cT/JR5+uxO4DEihFVhGiqku/8IdHIl9yu/tRB001Aax3ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qoKIHPj5; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 2 May 2024 07:43:35 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714635820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Wb0qMqHur0MeK2tbrAWY56qpmaZa0FxwEh56nkpjEMo=;
	b=qoKIHPj59UqcYEEBUZLNMN+R4lV9Sv+8HpfVONNy9hKIFSJiq2wWah/4SryMF9+M8HKOjE
	NSVBPlx0+Ie1dOjdEuSO8ISDT0n4qMLsyUw/otS/t2/bz1EElGcuG59L5ObGu8/EbIzouN
	KOIkrytRbjEc3eTIWvVxUx8C88lZfp4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH] arm64: Default to 4K translation granule
Message-ID: <ZjNEJ93_IJpHMLJx@linux.dev>
References: <20240502073917.1343986-2-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240502073917.1343986-2-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT

disregard -- forgot I didn't have my subject prefix config set on this
machine.

On Thu, May 02, 2024 at 07:39:18AM +0000, Oliver Upton wrote:
> Some arm64 implementations in the wild, like the Apple parts, do not
> support the 64K translation granule. This can be a bit annoying when
> running with the defaults on such hardware, as every test fails
> before getting the MMU turned on.
> 
> Switch the default page size to 4K with the intention of having the
> default setting be the most widely applicable one.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  configure | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/configure b/configure
> index 49f047cb2d7d..4ac2ff3e6106 100755
> --- a/configure
> +++ b/configure
> @@ -75,7 +75,7 @@ usage() {
>  	                           (s390x only)
>  	    --page-size=PAGE_SIZE
>  	                           Specify the page size (translation granule) (4k, 16k or
> -	                           64k, default is 64k, arm64 only)
> +	                           64k, default is 4k, arm64 only)
>  	    --earlycon=EARLYCON
>  	                           Specify the UART name, type and address (optional, arm and
>  	                           arm64 only). The specified address will overwrite the UART
> @@ -243,11 +243,7 @@ if [ "$efi" ] && [ "$arch" = "riscv64" ] && [ -z "$efi_direct" ]; then
>  fi
>  
>  if [ -z "$page_size" ]; then
> -    if [ "$efi" = 'y' ] && [ "$arch" = "arm64" ]; then
> -        page_size="4096"
> -    elif [ "$arch" = "arm64" ]; then
> -        page_size="65536"
> -    elif [ "$arch" = "arm" ]; then
> +    if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
>          page_size="4096"
>      fi
>  else
> -- 
> 2.45.0.rc1.225.g2a3ae87e7f-goog
> 

-- 
Thanks,
Oliver

