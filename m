Return-Path: <kvm+bounces-12771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AC4F888D958
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 09:42:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 27A711F283AC
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 08:42:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B344364B1;
	Wed, 27 Mar 2024 08:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WMUkGM5X"
X-Original-To: kvm@vger.kernel.org
Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736661BF54
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 08:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711528967; cv=none; b=W6WPJ5+IGiukBMcxhh3Qx8fpoZpZoUr/Orkw37HQDVVBTe/4OK3OH6VruloMQ6dQS1iSl993NQ195deErsfUJ7m59xjutNUi3b0rS1VkMSFmohxrky+6xCHcT/K1Jvp2jeDXdyrxnQWJ9gnDsFo1PnM6glTvvAcShf7TlAd6QH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711528967; c=relaxed/simple;
	bh=vBKpCiqb6J7MNL9ZJVRZd0RDtk+cHmKYrFWu4sfxcJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G5yBcVP9RUTRp8g7Knru7AS865K5fJU5mUiYKfZWQj+GRJJ5QD2lYll+838T/0j8g4EZ8HtJOrH37/EYL0le4K/D/bcfdgkoNQUjOfzQFt5sfFPW4rtQYdis+hGJW1IGE7XQRlkl1++0eMr/edus4diMV60X7gKiNj2Sm9jhRqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WMUkGM5X; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 27 Mar 2024 09:42:40 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1711528962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hyY2NEdeWUWqFD+kKJX7ndDI63UrZ2KcbPDBwJ+VKvI=;
	b=WMUkGM5X0tBAR17Aj2V5a2BpzegCN+W6QYXVPt3F+h7CemU7PfT6yUMU6ZFkaKCw+QK8hK
	+VE9pdcL9y4UA/SWQz7eMylwe3jL4T9D16WU+IxTouqMzYVlBk2S9g/sLKwXt40AuKgw1k
	GzLftCb3jNqFE+fzOkpW8lC/GUl7gRU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Pavan Kumar Paluri <papaluri@amd.com>
Cc: kvm@vger.kernel.org, thomas.lendacky@amd.com, michael.roth@amd.com, 
	amit.shah@amd.com
Subject: Re: [kvm-unit-tests PATCH v2 2/4] x86/efi: Retry call to efi exit
 boot services
Message-ID: <20240327-c80e0a0ef306b5190f84f918@orel>
References: <20240326173400.773733-1-papaluri@amd.com>
 <20240326173400.773733-2-papaluri@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240326173400.773733-2-papaluri@amd.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 26, 2024 at 12:33:58PM -0500, Pavan Kumar Paluri wrote:
> In some cases, KUT guest might fail to exit boot services due to a
> possible memory map update that might have taken place between
> efi_get_memory_map() and efi_exit_boot_services() calls. As per UEFI
> spec 2.10 (Section 7.4.6 EFI_BOOT_SERVICES.ExitBootServices()), we need
> to keep trying to update the memory map and calls to exit boot
> services as long as case status is EFI_INVALID_PARAMETER.
> 
> Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
> ---
>  lib/efi.c | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/efi.c b/lib/efi.c
> index 8a74a22834a4..c98bc5c0a022 100644
> --- a/lib/efi.c
> +++ b/lib/efi.c
> @@ -461,16 +461,35 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
>  	}
>  #endif
>  
> -	/* 
> +	/*
>  	 * Exit EFI boot services, let kvm-unit-tests take full control of the
>  	 * guest
>  	 */
>  	status = efi_exit_boot_services(handle, &efi_bootinfo.mem_map);
> -	if (status != EFI_SUCCESS) {
> +	if (status != EFI_SUCCESS && status != EFI_INVALID_PARAMETER) {
>  		printf("Failed to exit boot services\n");
>  		goto efi_main_error;
>  	}
>  
> +	/*
> +	 * There is a possibility that memory map might have changed
> +	 * between efi_get_memory_map() and efi_exit_boot_services in

nit: Either add the () to all function names or to none.

> +	 * which case status is EFI_INVALID_PARAMETER. As per UEFI spec
> +	 * 2.10, we need to get the updated memory map and keep trying

Even older specs have this, but calling out 2.10 makes it sound like it's
something from 2.10. It's probably not worth looking for when it first
appeared, but normally we'd want to reference the oldest version. If you
don't want to dig that up, then I'm fine with just dropping the number,
or even the whole comment.

> +	 * until status is not EFI_INVALID_PARAMETER.
> +	 */
> +	while (status == EFI_INVALID_PARAMETER) {
> +		efi_get_memory_map(&efi_bootinfo.mem_map);
> +
> +		status = efi_exit_boot_services(handle,
> +						&efi_bootinfo.mem_map);
> +		if (status != EFI_SUCCESS &&
> +		    status != EFI_INVALID_PARAMETER) {
> +			printf("Failed to exit boot services\n");
> +			goto efi_main_error;
> +		}
> +	}
> +
>  	/* Set up arch-specific resources */
>  	status = setup_efi(&efi_bootinfo);
>  	if (status != EFI_SUCCESS) {
> -- 
> 2.34.1
>

We're leaking the old maps when we need to try again. Also, I see
another issue (which I introduced with efi_get_boot_hartid()) which is
to have a call between getting the memory map and exiting boot services,
which the spec recommends not doing. I think for this patch we should
do something like below (which is untested).

Thanks,
drew

diff --git a/lib/efi.c b/lib/efi.c
index dfbadea60411..d876afefc614 100644
--- a/lib/efi.c
+++ b/lib/efi.c
@@ -404,8 +404,8 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
        efi_system_table = sys_tab;

        /* Memory map struct values */
-       efi_memory_desc_t *map = NULL;
-       unsigned long map_size = 0, desc_size = 0, key = 0, buff_size = 0;
+       efi_memory_desc_t *map;
+       unsigned long map_size, desc_size, key, buff_size;
        u32 desc_ver;

        /* Helper variables needed to get the cmdline */
@@ -444,13 +444,6 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
        efi_bootinfo.mem_map.key_ptr = &key;
        efi_bootinfo.mem_map.buff_size = &buff_size;

-       /* Get EFI memory map */
-       status = efi_get_memory_map(&efi_bootinfo.mem_map);
-       if (status != EFI_SUCCESS) {
-               printf("Failed to get memory map\n");
-               goto efi_main_error;
-       }
-
 #ifdef __riscv
        status = efi_get_boot_hartid();
        if (status != EFI_SUCCESS) {
@@ -463,7 +456,18 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
         * Exit EFI boot services, let kvm-unit-tests take full control of the
         * guest
         */
-       status = efi_exit_boot_services(handle, &efi_bootinfo.mem_map);
+       status = EFI_INVALID_PARAMETER;
+       while (status == EFI_INVALID_PARAMETER) {
+               status = efi_get_memory_map(&efi_bootinfo.mem_map);
+               if (status != EFI_SUCCESS) {
+                       printf("Failed to get memory map\n");
+                       goto efi_main_error;
+               }
+
+               status = efi_exit_boot_services(handle, &efi_bootinfo.mem_map);
+               if (status == EFI_INVALID_PARAMETER)
+                       efi_free_pool(*efi_bootinfo.mem_map.map);
+       }
        if (status != EFI_SUCCESS) {
                printf("Failed to exit boot services\n");
                goto efi_main_error;

