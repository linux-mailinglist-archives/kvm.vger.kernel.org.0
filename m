Return-Path: <kvm+bounces-12671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E0E6688BCD1
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 09:51:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7FBF01F3B8B6
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 08:51:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A46518E10;
	Tue, 26 Mar 2024 08:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tx8p0GFt"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2327317722
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 08:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711443092; cv=none; b=dbS0j80cosvThW3XsHBEqNi3FaIcyiieTWzNneAhTi8/SFfIrPUikoVBUdTzN5vtmv8kl7JGdQzJMoLwy4gS92AaHSas5yN0ZHRGeuD7yshaXMYNLArMuqrZyWNe7KIHL6fAoJxuUhCK16P80HIVmQ+7tq/55YncrIZFjOrp6xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711443092; c=relaxed/simple;
	bh=x3j3ASsaNJKvJgVOz5PhjLTryTPuiGxYCymQSsKSpjY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kwJecfDtDISEg5SrUoKotgzUPlPiZBi9M9eksNT7RXPltKt8k4/0wqDDLhlCh+0a88ZKnjWm1nNY75yK+FFr9zOdbmvbqgLjDY5Yy2cgUMI9xalvQyRrXWJRJAvWGqDkYTwLgNoStq+Cijf3VeoLgWdXOYB5MYgV4sDWTracApU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tx8p0GFt; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 26 Mar 2024 09:51:25 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1711443088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cZ0W1vc5CoMYLqnQ1vE/8VN3DrpyI+i3su1ZtOs0aVY=;
	b=tx8p0GFtRV5hClIcFkvh6xqr5Zos3GOmXkK9PZS0IXnJkjIIwM6r+RZDNKU0arPC0b7QL1
	zCBOdKBXreVBE7WixM9NwIs5anCEaEt0WplaCiy+QnGfdzBUKGrYOzaGzBlP0gy2uGIxu3
	x7ZUIk1tabB1KB97AQ7E0Pmd6KDmmL8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Pavan Kumar Paluri <papaluri@amd.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, nikos.nikoleris@arm.com, 
	thomas.lendacky@amd.com, michael.roth@amd.com, amit.shah@amd.com
Subject: Re: [kvm-unit-tests RFC PATCH 1/3] x86 EFI: Bypass call to
 fdt_check_header()
Message-ID: <20240326-663042e3295513fb8814f80d@orel>
References: <20240325213623.747590-1-papaluri@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240325213623.747590-1-papaluri@amd.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 25, 2024 at 04:36:21PM -0500, Pavan Kumar Paluri wrote:
> Issuing a call to fdt_check_header() prevents running any of x86 UEFI
> enabled tests. Bypass this call for x86 in order to enable UEFI
> supported tests for KUT x86 arch.

Ouch! Sorry about that. I think I prefer something like below, though.

Thanks,
drew

diff --git a/lib/efi.c b/lib/efi.c
index 5314eaa81e66..335b66d26092 100644
--- a/lib/efi.c
+++ b/lib/efi.c
@@ -312,6 +312,7 @@ static void* efi_get_var(efi_handle_t handle, struct efi_loaded_image_64 *image,
        return val;
 }
 
+#if defined(__aarch64__) || defined(__riscv)
 static void *efi_get_fdt(efi_handle_t handle, struct efi_loaded_image_64 *image)
 {
        efi_char16_t var[] = ENV_VARNAME_DTBFILE;
@@ -330,6 +331,12 @@ static void *efi_get_fdt(efi_handle_t handle, struct efi_loaded_image_64 *image)
 
        return fdt_check_header(fdt) == 0 ? fdt : NULL;
 }
+#else
+static void *efi_get_fdt(efi_handle_t handle, struct efi_loaded_image_64 *image)
+{
+       return NULL;
+}
+#endif
 
 static const struct {
        struct efi_vendor_dev_path      vendor;

> 
> Fixes: 9632ce446b8f ("arm64: efi: Improve device tree discovery")
> Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
> ---
>  lib/efi.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/lib/efi.c b/lib/efi.c
> index 5314eaa81e66..124e77685230 100644
> --- a/lib/efi.c
> +++ b/lib/efi.c
> @@ -328,6 +328,10 @@ static void *efi_get_fdt(efi_handle_t handle, struct efi_loaded_image_64 *image)
>  		return NULL;
>  	}
>  
> +#ifdef __x86_64__
> +	return fdt;
> +#endif
> +
>  	return fdt_check_header(fdt) == 0 ? fdt : NULL;
>  }
>  
> -- 
> 2.34.1
> 

