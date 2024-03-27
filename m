Return-Path: <kvm+bounces-12770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D667A88D86C
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 09:09:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F1E6C1C26390
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 08:09:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6CEB2EAE5;
	Wed, 27 Mar 2024 08:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="M3+bIE1z"
X-Original-To: kvm@vger.kernel.org
Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9416E2D611
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 08:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711526946; cv=none; b=LmfkI5Nr3smhGiRjm3DKw57hl51Q3A0FUg/4P9td2a9XeJXpmYO3vw6yw/HjbkX1IIw4j5q2gxpWEszlwYxmbcaHJLAaGDLWuJuU6A7FUbjfZi9bh4JNYxephi/LGfUvm+z96nUCVHXnBd0bZNrREt6gHNAiIlnG9Byd4JLp97M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711526946; c=relaxed/simple;
	bh=/eEPtZNUpJbYh0WVvBId4y6dyPu4Isu8dKCxUcbKjLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ob06WNu6yRR2Lt+Dcn84GhacNe5s4ooJ2txJEuIu996uJ/wMVZ5iN2zjv0jYixu0jiVhGVJ+m7cJkZPk0ssg7W1T5/vfqHw9i9x9HYZYmmh8uc4MomKPj+VSGsBWgJUtb1ZAjQ9dPFM2QjUY33AfypJcL4bKLfg3LBxzx1IRWu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=M3+bIE1z; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 27 Mar 2024 09:08:57 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1711526940;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=caRtNksN934uVLsk2lO7fMxGhd0kUaHPyyRm59LWDLQ=;
	b=M3+bIE1zVrMrmAgw0GHeGPrlSGcy8PK0hMHZa22TDmjb7sFTttwJUUCPcNduprOAumY2I/
	76dsClBG971poiRWSeMdfcEipCOrKDymXwdH04vx8AlJ1m0hrCwC6TlcexdUrtB1OxgbOJ
	M7OulgRLwd54DVDpr96xopsVNEjmSPo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Pavan Kumar Paluri <papaluri@amd.com>
Cc: kvm@vger.kernel.org, thomas.lendacky@amd.com, michael.roth@amd.com, 
	amit.shah@amd.com
Subject: Re: [kvm-unit-tests PATCH v2 1/4] x86 EFI: Bypass call to
 fdt_check_header()
Message-ID: <20240327-f360721c639c087d16444baf@orel>
References: <20240326173400.773733-1-papaluri@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240326173400.773733-1-papaluri@amd.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 26, 2024 at 12:33:57PM -0500, Pavan Kumar Paluri wrote:
> Issuing a call to fdt_check_header() prevents running any of x86 UEFI
> enabled tests. Bypass this call for x86 and also calls to
> efi_load_image(), efi_grow_buffer(), efi_get_var() in order to enable
> UEFI supported tests for KUT x86 arch.
> 
> Fixes: 9632ce446b8f ("arm64: efi: Improve device tree discovery")
> Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
> ---
>  lib/efi.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/lib/efi.c b/lib/efi.c
> index 5314eaa81e66..8a74a22834a4 100644
> --- a/lib/efi.c
> +++ b/lib/efi.c
> @@ -204,6 +204,7 @@ static char *efi_convert_cmdline(struct efi_loaded_image_64 *image, int *cmd_lin
>  	return (char *)cmdline_addr;
>  }
>  
> +#if defined(__aarch64__) || defined(__riscv)
>  /*
>   * Open the file and read it into a buffer.
>   */
> @@ -330,6 +331,12 @@ static void *efi_get_fdt(efi_handle_t handle, struct efi_loaded_image_64 *image)
>  
>  	return fdt_check_header(fdt) == 0 ? fdt : NULL;
>  }
> +#else
> +static void *efi_get_fdt(efi_handle_t handle, struct efi_loaded_image_64 *image)
> +{
> +	return NULL;
> +}
> +#endif
>  
>  static const struct {
>  	struct efi_vendor_dev_path	vendor;
> -- 
> 2.34.1
>

It's a pity that the suggestion I made (which I obviously hadn't even
compile tested...) isn't sufficient, because what I was going for was
a way to annotate that specifically efi_get_fdt() was for architectures
which use a DT (and link libfdt). It's not as nice to indicate that
the other functions also don't apply to x86 (x86 doesn't use them
now, but there's no reason it couldn't). With that in mind, I think I
like your original patch better, but with a tweak to ensure we don't
generate the undefined reference to fdt_check_header(),

diff --git a/lib/efi.c b/lib/efi.c
index 5314eaa81e66..dfbadea60411 100644
--- a/lib/efi.c
+++ b/lib/efi.c
@@ -328,7 +328,12 @@ static void *efi_get_fdt(efi_handle_t handle, struct efi_loaded_image_64 *image)
                return NULL;
        }

+#ifdef __x86_64__
+       /* x86 is ACPI-only */
+       return NULL;
+#else
        return fdt_check_header(fdt) == 0 ? fdt : NULL;
+#endif
 }

 static const struct {

That said, I could go either way, since it also makes sense to not
compile code for x86 that it doesn't currently use. So, unless you
need to respin for other reasons,

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

Thanks,
drew

