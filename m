Return-Path: <kvm+bounces-14081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D532A89ED4E
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 10:12:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A6E41F220AD
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 08:12:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEFD613D60C;
	Wed, 10 Apr 2024 08:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vkZm2CRw"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42F213D298
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 08:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712736704; cv=none; b=et1UpPoMiaZXk4WP+yAfMzyNO0ocDm/eFggmXxgUF6buMhTOqAh4geWTmPcuJkgnToUoJ5hVLMoq2VOPWD9wiusVI+Avzh/oHiXT3mgLy82lJyMYVOdf2krioRv+JBHRIWE3hTpPhaeK2i3QhCtLCfNXA63rImMIJUth9zHv894=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712736704; c=relaxed/simple;
	bh=GOzZ6X/HYQ1eZaNshrT11xHS6UYFRNWDZLU6gEM73qk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qSZhJ9a2iHT9D84P9J8QggdmCn7mgoLNHIodUzJAOE16+FeyVOuWW556Gd07s/TgWEptnskDIHOu8MCgIT2/i92fc+wVney3ZCBwu5b0l0CleQi1WFR37BSvAP/HbIU+F3RuLSp4IiW7qqbMaqG2rSv21H1g1nB+qFqsBYGimyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vkZm2CRw; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 10 Apr 2024 10:11:30 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712736699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K6UZpJAAoxm0V+W88rk7hWZch4WtPB4n4IjoKLTTSM4=;
	b=vkZm2CRwyZxbYJVTJLoLGih+ynp3rA/V/gAqTr00gIy04RCuxTJqLv5ImE4hDitS5f9yjc
	aFA2CDVwPh04BFIyUWtpRPLzj0l8OAkI9z/gvUGd818XRhfwqjUkAgo9wqQTP4n36ga54+
	FuyJokMs4sCOS5Q84A974Ty+gfisB90=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: vsntk18@gmail.com
Cc: kvm@vger.kernel.org, papaluri@amd.com, 
	Vasant Karasulli <vkarasulli@suse.de>
Subject: Re: [kvm-unit-tests PATCH v1] efi: include libfdt header only for
 aarch64 and riscv
Message-ID: <20240410-4c58656920c71b44fc6ed38b@orel>
References: <20240410075358.6763-1-vsntk18@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240410075358.6763-1-vsntk18@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Apr 10, 2024 at 09:53:58AM +0200, vsntk18@gmail.com wrote:
> From: Vasant Karasulli <vkarasulli@suse.de>
> 
> For x86, preprocessor fails to locate headers included by lib/libfdt.h
> as they are missing from the include path.
> 
> Fixes: 9632ce446b8f ("arm64: efi: Improve device tree discovery")
> Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
> ---
>  lib/efi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/efi.c b/lib/efi.c
> index 44337837..f396bd71 100644
> --- a/lib/efi.c
> +++ b/lib/efi.c
> @@ -12,7 +12,6 @@
>  #include <stdlib.h>
>  #include <asm/setup.h>
>  #include "efi.h"
> -#include "libfdt/libfdt.h"
> 
>  /* From each arch */
>  extern char *initrd;
> @@ -205,6 +204,7 @@ static char *efi_convert_cmdline(struct efi_loaded_image_64 *image, int *cmd_lin
>  }
> 
>  #if defined(__aarch64__) || defined(__riscv)
> +#include "libfdt/libfdt.h"
>  /*
>   * Open the file and read it into a buffer.
>   */
> 
> base-commit: 9f993e210064ba9f444b752f56a85bdafdb1780e
> --
> 2.34.1
>

I wasn't able to get an x86-efi compile to fail without this, but the fix
looks good.

Merged.

Thanks,
drew

