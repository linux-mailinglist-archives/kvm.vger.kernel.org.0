Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17CD420CC9
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 15:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235766AbhJDNJ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 09:09:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34749 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235528AbhJDNIe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 09:08:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633352805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qnsTi4P2t5rHfDxTi+AL4MJi2UMQhITtd/TdiPxPp6M=;
        b=AjKMMcCZ1Rcpqd/rRDmKqb3L8InJDGTVCwf5N2r4ueHRm7vAZnCp3hja0erOWH6azH48e8
        ySsHbWt1tjUP10jo1hI/46EqwgxZDZOCnbVEQV7F/nmoopTAPX3BAxEF9aEW/xZdPaCIId
        Y8HG9jUeP9hrkRsro99QzJlds7u3qEY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-7ogIwmO3Pnq7bNTIUnOhtw-1; Mon, 04 Oct 2021 09:06:44 -0400
X-MC-Unique: 7ogIwmO3Pnq7bNTIUnOhtw-1
Received: by mail-wm1-f71.google.com with SMTP id x3-20020a05600c21c300b0030d2b0fb3b4so6677838wmj.5
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 06:06:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qnsTi4P2t5rHfDxTi+AL4MJi2UMQhITtd/TdiPxPp6M=;
        b=QgyETU0Nf+L78E/nHgxtsDpVA4mggcsy8YUhKfB0gVCDB+b52vJcuO+iIeXB4L2PjA
         fD/LvsgtUu0J0YJHcPxJAyTSujd6Q8IN5j4n6f5RwfrPflUS9DiihCSLqK3rUZCiVRa0
         pp+i49Mi13M8g+eWGW/YQOkRWUOQ1qf4e1pGQa/eaX0HNcXpS2oetiiTZBlodHCaaJUw
         z+WnFsNKSaASU+8ywe3FjfHKdyM6O2EW2QKzR24l+e2C4n1JhrvuP8ea40o48IbOlfS2
         Iqzn/uWR2YPal4oj6ouFh7cCkCV+Dg1R2FBSHqpjai+n6LEgckaGswkmi6jSkzfSSNFp
         NX8w==
X-Gm-Message-State: AOAM531A+Dklj/0vgf9SN6ahU+R7x+TQbwriXr/mIPzkQVkB+km+K7eI
        quBrL3FXKBvfjs1oTwUvfnlnWaTy4zwnGNKHi2GBFypNiihQRExBW+9rXgFnDTuL49c5NLCE1Ru
        OsLu6mcC2ck2x
X-Received: by 2002:a1c:7302:: with SMTP id d2mr18418029wmb.92.1633352802809;
        Mon, 04 Oct 2021 06:06:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx6u7rJm/o+gD8enNn0q92rYYJEBAp6xhJB/ng4gligUpFtM5bppXVK6re4lDc+7mt4vFH2sw==
X-Received: by 2002:a1c:7302:: with SMTP id d2mr18418000wmb.92.1633352802525;
        Mon, 04 Oct 2021 06:06:42 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id o7sm17031587wro.45.2021.10.04.06.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 06:06:42 -0700 (PDT)
Date:   Mon, 4 Oct 2021 15:06:40 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Zixuan Wang <zixuanwang@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, marcorr@google.com,
        baekhw@google.com, tmroeder@google.com, erdemaktas@google.com,
        rientjes@google.com, seanjc@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, varad.gautam@suse.com, jroedel@suse.de,
        bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v2 07/17] x86 UEFI: Set up memory allocator
Message-ID: <20211004130640.hdse6xkg4m6jx5c2@gator>
References: <20210827031222.2778522-1-zixuanwang@google.com>
 <20210827031222.2778522-8-zixuanwang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827031222.2778522-8-zixuanwang@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021 at 03:12:12AM +0000, Zixuan Wang wrote:
> KVM-Unit-Tests library implements a memory allocator which requires
> two arguments to set up (See `lib/alloc_phys.c:phys_alloc_init()` for
> more details):
>    1. A base (start) physical address
>    2. Size of available memory for allocation
> 
> To get this memory info, we scan all the memory regions returned by
> `LibMemoryMap()`, find out the largest free memory region and use it for
> memory allocation.
> 
> After retrieving this memory info, we call `ExitBootServices` so that
> KVM-Unit-Tests has full control of the machine, and UEFI will not touch
> the memory after this point.
> 
> Starting from this commit, `x86/hypercall.c` test case can run in UEFI
> and generates the same output as in Seabios.
> 
> Co-developed-by: Varad Gautam <varad.gautam@suse.com>
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> Signed-off-by: Zixuan Wang <zixuanwang@google.com>
> ---
>  lib/efi.c           | 28 +++++++++++++---
>  lib/efi.h           |  2 +-
>  lib/x86/asm/setup.h | 16 +++++++++-
>  lib/x86/setup.c     | 78 ++++++++++++++++++++++++++++++++++++++++++++-
>  4 files changed, 116 insertions(+), 8 deletions(-)
> 
> diff --git a/lib/efi.c b/lib/efi.c
> index 99307db..b7a69d3 100644
> --- a/lib/efi.c
> +++ b/lib/efi.c
> @@ -31,9 +31,10 @@ efi_status_t efi_get_memory_map(struct efi_boot_memmap *map)
>  	efi_memory_desc_t *m = NULL;
>  	efi_status_t status;
>  	unsigned long key = 0, map_size = 0, desc_size = 0;
> +	u32 desc_ver;
>  
>  	status = efi_bs_call(get_memory_map, &map_size,
> -			     NULL, &key, &desc_size, NULL);
> +			     NULL, &key, &desc_size, &desc_ver);
>  	if (status != EFI_BUFFER_TOO_SMALL || map_size == 0)
>  		goto out;
>  
> @@ -48,12 +49,13 @@ efi_status_t efi_get_memory_map(struct efi_boot_memmap *map)
>  
>  	/* Get the map. */
>  	status = efi_bs_call(get_memory_map, &map_size,
> -			     m, &key, &desc_size, NULL);
> +			     m, &key, &desc_size, &desc_ver);
>  	if (status != EFI_SUCCESS) {
>  		efi_free_pool(m);
>  		goto out;
>  	}
>  
> +	*map->desc_ver = desc_ver;
>  	*map->desc_size = desc_size;
>  	*map->map_size = map_size;
>  	*map->key_ptr = key;
> @@ -62,18 +64,34 @@ out:
>  	return status;
>  }
>  
> -efi_status_t efi_exit_boot_services(void *handle, struct efi_boot_memmap *map)
> +efi_status_t efi_exit_boot_services(void *handle, unsigned long mapkey)
>  {
> -	return efi_bs_call(exit_boot_services, handle, *map->key_ptr);
> +	return efi_bs_call(exit_boot_services, handle, mapkey);
>  }
>  
>  efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
>  {
>  	int ret;
> +	unsigned long mapkey = 0;
> +	efi_status_t status;
> +	efi_bootinfo_t efi_bootinfo;
>  
>  	efi_system_table = sys_tab;
>  
> -	setup_efi();
> +	setup_efi_bootinfo(&efi_bootinfo);
> +	status = setup_efi_pre_boot(&mapkey, &efi_bootinfo);
> +	if (status != EFI_SUCCESS) {
> +		printf("Failed to set up before ExitBootServices, exiting.\n");
> +		return status;
> +	}
> +
> +	status = efi_exit_boot_services(handle, mapkey);
> +	if (status != EFI_SUCCESS) {
> +		printf("Failed to exit boot services\n");
> +		return status;
> +	}
> +
> +	setup_efi(&efi_bootinfo);
>  	ret = main(__argc, __argv, __environ);
>  
>  	/* Shutdown the guest VM */
> diff --git a/lib/efi.h b/lib/efi.h
> index 60cdb6f..2d3772c 100644
> --- a/lib/efi.h
> +++ b/lib/efi.h
> @@ -11,7 +11,7 @@
>  
>  efi_status_t _relocate(long ldbase, Elf64_Dyn *dyn, efi_handle_t handle, efi_system_table_t *sys_tab);
>  efi_status_t efi_get_memory_map(struct efi_boot_memmap *map);
> -efi_status_t efi_exit_boot_services(void *handle, struct efi_boot_memmap *map);
> +efi_status_t efi_exit_boot_services(void *handle, unsigned long mapkey);
>  efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab);
>  
>  #endif /* _EFI_H_ */
> diff --git a/lib/x86/asm/setup.h b/lib/x86/asm/setup.h
> index eb1cf73..8ff31ef 100644
> --- a/lib/x86/asm/setup.h
> +++ b/lib/x86/asm/setup.h
> @@ -4,8 +4,22 @@
>  #ifdef TARGET_EFI
>  #include "x86/apic.h"
>  #include "x86/smp.h"
> +#include "efi.h"
>  
> -void setup_efi(void);
> +/*
> + * efi_bootinfo_t: stores EFI-related machine info retrieved by
> + * setup_efi_pre_boot(), and is then used by setup_efi(). setup_efi() cannot
> + * retrieve this info as it is called after ExitBootServices and thus some EFI
> + * resources are not available.
> + */
> +typedef struct {
> +	phys_addr_t free_mem_start;
> +	phys_addr_t free_mem_size;
> +} efi_bootinfo_t;
> +
> +void setup_efi_bootinfo(efi_bootinfo_t *efi_bootinfo);
> +void setup_efi(efi_bootinfo_t *efi_bootinfo);
> +efi_status_t setup_efi_pre_boot(unsigned long *mapkey, efi_bootinfo_t *efi_bootinfo);
>  #endif /* TARGET_EFI */
>  
>  #endif /* _X86_ASM_SETUP_H_ */
> diff --git a/lib/x86/setup.c b/lib/x86/setup.c
> index 0a065fe..a49e0d4 100644
> --- a/lib/x86/setup.c
> +++ b/lib/x86/setup.c
> @@ -131,6 +131,81 @@ extern phys_addr_t ring0stacktop;
>  extern gdt_entry_t gdt64[];
>  extern size_t ring0stacksize;
>  
> +void setup_efi_bootinfo(efi_bootinfo_t *efi_bootinfo)
> +{
> +	efi_bootinfo->free_mem_size = 0;
> +	efi_bootinfo->free_mem_start = 0;
> +}
> +
> +static efi_status_t setup_pre_boot_memory(unsigned long *mapkey, efi_bootinfo_t *efi_bootinfo)
> +{
> +	int i;
> +	unsigned long free_mem_total_pages;
> +	efi_status_t status;
> +	struct efi_boot_memmap map;
> +	efi_memory_desc_t *buffer, *d;
> +	unsigned long map_size, desc_size, buff_size;
> +	u32 desc_ver;
> +
> +	map.map = &buffer;
> +	map.map_size = &map_size;
> +	map.desc_size = &desc_size;
> +	map.desc_ver = &desc_ver;
> +	map.buff_size = &buff_size;
> +	map.key_ptr = mapkey;
> +
> +	status = efi_get_memory_map(&map);
> +	if (status != EFI_SUCCESS) {
> +		return status;
> +	}
> +
> +	/*
> +	 * The 'buffer' contains multiple descriptors that describe memory
> +	 * regions maintained by UEFI. This code records the largest free
> +	 * EFI_CONVENTIONAL_MEMORY region which will be used to set up the
> +	 * memory allocator, so that the memory allocator can work in the
> +	 * largest free continuous memory region.
> +	 */
> +	free_mem_total_pages = 0;
> +	for (i = 0; i < map_size; i += desc_size) {
> +		d = (efi_memory_desc_t *)(&((u8 *)buffer)[i]);
> +		if (d->type == EFI_CONVENTIONAL_MEMORY) {
> +			if (free_mem_total_pages < d->num_pages) {
> +				free_mem_total_pages = d->num_pages;
> +				efi_bootinfo->free_mem_size = free_mem_total_pages << EFI_PAGE_SHIFT;
> +				efi_bootinfo->free_mem_start = d->phys_addr;
> +			}
> +		}
> +	}
> +
> +	if (efi_bootinfo->free_mem_size == 0) {
> +		return EFI_OUT_OF_RESOURCES;
> +	}
> +
> +	return EFI_SUCCESS;
> +}
> +
> +efi_status_t setup_efi_pre_boot(unsigned long *mapkey, efi_bootinfo_t *efi_bootinfo)
> +{
> +	efi_status_t status;
> +
> +	status = setup_pre_boot_memory(mapkey, efi_bootinfo);
> +	if (status != EFI_SUCCESS) {
> +		printf("setup_pre_boot_memory() failed: ");
> +		switch (status) {
> +		case EFI_OUT_OF_RESOURCES:
> +			printf("No free memory region\n");
> +			break;
> +		default:
> +			printf("Unknown error\n");
> +			break;
> +		}
> +		return status;
> +	}
> +
> +	return EFI_SUCCESS;
> +}
> +
>  static void setup_gdt_tss(void)
>  {
>  	gdt_entry_t *tss_lo, *tss_hi;
> @@ -169,7 +244,7 @@ static void setup_gdt_tss(void)
>  	load_gdt_tss(tss_offset);
>  }
>  
> -void setup_efi(void)
> +void setup_efi(efi_bootinfo_t *efi_bootinfo)
>  {
>  	reset_apic();
>  	setup_gdt_tss();
> @@ -179,6 +254,7 @@ void setup_efi(void)
>  	enable_apic();
>  	enable_x2apic();
>  	smp_init();
> +	phys_alloc_init(efi_bootinfo->free_mem_start, efi_bootinfo->free_mem_size);
>  }
>  
>  #endif /* TARGET_EFI */
> -- 
> 2.33.0.259.gc128427fd7-goog
>

How about just getting the memory map (efi_boot_memmap) and then exiting
boot services in arch-neutral code and then have arch-specific code decide
what to do with the memory map?

Thanks,
drew

