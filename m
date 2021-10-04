Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91EC1420E56
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 15:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236370AbhJDNYY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 09:24:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58612 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236562AbhJDNW6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 09:22:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633353668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QdXHrZbjlTX2hL2cnlXaGZH+zUybT9BUpsuwVSkETB4=;
        b=IfZt/vVTSMUsczgQ6LV7V8gNALtVTWD7LBzPbGNNqEmyctulMMM1oWq5Hxu2EfIl3jFI8J
        gEc68nXX2mFX/nINl/adyOgucRufnH03awPM+Y4pAtRX20RX4GIGoXhRrmqASYw7eq3mJC
        2DC2fcsct5zhFhAO04rsYoIzooLuM/A=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-o2DnSep6PWuLwRTM0a7ISw-1; Mon, 04 Oct 2021 09:21:06 -0400
X-MC-Unique: o2DnSep6PWuLwRTM0a7ISw-1
Received: by mail-wm1-f70.google.com with SMTP id 129-20020a1c0187000000b0030d4081c36cso4137389wmb.0
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 06:21:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QdXHrZbjlTX2hL2cnlXaGZH+zUybT9BUpsuwVSkETB4=;
        b=1HBmzpwy78XGkjUAgwr0mC8dqu9lJcio53Zs9po5Y1fLw3ohNp8qg9A36NQrTEbFmu
         UH9uSQsTjffdKJ0kdUEmcNcP+Cm7c0IDRjQj7GfB2fnZ5vo13f7u5Sz3NM1a32Dten8O
         qO5cpEPIV0kbm9TCb9jjdFuktLlLOthLs7n3UJX/YjcJ2diEh1cisLBSbAPNSrnZkhsG
         gfjVqSBU3wbP3TgHAslzJmwgL9+p5HSu2bGPu0YNkdEXZfeBAmKbbGBEtazeMY+Y+cOq
         inVSmxOEJEt3UqwPZ93aGUymK5/MUeQDDbhpadezHkeneQ+4uda4Svd9iOiZoVCxEOa5
         u6mA==
X-Gm-Message-State: AOAM531fot8+vpR46uYkz1hkvO9oW0/vrB1UwsTH0AMFiyx4UkBCVReF
        qkKKkel5Qr396ecN1qBazu5B+q+M8jmNjn0ibEZ8Zx+0cPAIMqWQezaO9Gb+hJg1VOxVZ7GKZrU
        qrL+9KPGzzx4O
X-Received: by 2002:a05:600c:aca:: with SMTP id c10mr18543224wmr.174.1633353664708;
        Mon, 04 Oct 2021 06:21:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPcKD/IpY0LxksqttMrmZjJvyb2fHofFaSH+a213V5yw7vUVGWDaTFym4PPHX5sWRZueV89g==
X-Received: by 2002:a05:600c:aca:: with SMTP id c10mr18543178wmr.174.1633353664387;
        Mon, 04 Oct 2021 06:21:04 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id a25sm16181381wmj.34.2021.10.04.06.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 06:21:04 -0700 (PDT)
Date:   Mon, 4 Oct 2021 15:21:02 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Zixuan Wang <zixuanwang@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, marcorr@google.com,
        baekhw@google.com, tmroeder@google.com, erdemaktas@google.com,
        rientjes@google.com, seanjc@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, varad.gautam@suse.com, jroedel@suse.de,
        bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v2 08/17] x86 UEFI: Set up RSDP after UEFI
 boot up
Message-ID: <20211004132102.lfsyabk2daeiejkx@gator>
References: <20210827031222.2778522-1-zixuanwang@google.com>
 <20210827031222.2778522-9-zixuanwang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827031222.2778522-9-zixuanwang@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021 at 03:12:13AM +0000, Zixuan Wang wrote:
> Root system description pointer (RSDP) is a data structure used in the
> ACPI programming interface. In BIOS, RSDP is located within a
> predefined memory area, so a program can scan the memory area and find
> RSDP. But in UEFI, RSDP may not appear in that memory area, instead, a
> program should find it in the EFI system table.
> 
> This commit provides RSDP set up code in UEFI:
>    1. Read RSDP from EFI system table
>    2. Pass RSDP pointer to find_acpi_table_attr() function
> 
> From this commit, the `x86/s3.c` test can run in UEFI and generates
> similar output as in Seabios, note that:
>    1. In its output, memory addresses are different than Seabios's, this
>       is because EFI application starts from a dynamic runtime address,
>       not a fixed predefined memory address
>    2. There is a short delay (~5 secs) after the test case prints "PM1a
>       event registers" line. This test case sleeps for a few seconds
>       and then wakes up, so give it a few seconds to run.
> 
> Signed-off-by: Zixuan Wang <zixuanwang@google.com>
> ---
>  lib/efi.c           | 15 +++++++++++++++
>  lib/efi.h           |  1 +
>  lib/linux/uefi.h    | 15 +++++++++++++++
>  lib/x86/acpi.c      | 38 +++++++++++++++++++++++++++++++-------
>  lib/x86/acpi.h      | 11 +++++++++++
>  lib/x86/asm/setup.h |  2 ++
>  lib/x86/setup.c     | 13 +++++++++++++
>  7 files changed, 88 insertions(+), 7 deletions(-)
> 
> diff --git a/lib/efi.c b/lib/efi.c
> index b7a69d3..a0d4476 100644
> --- a/lib/efi.c
> +++ b/lib/efi.c
> @@ -69,6 +69,21 @@ efi_status_t efi_exit_boot_services(void *handle, unsigned long mapkey)
>  	return efi_bs_call(exit_boot_services, handle, mapkey);
>  }
>  
> +efi_status_t efi_get_system_config_table(efi_guid_t table_guid, void **table)
> +{
> +	size_t i;
> +	efi_config_table_t *tables;
> +
> +	tables = (efi_config_table_t *)efi_system_table->tables;
> +	for (i = 0; i < efi_system_table->nr_tables; i++) {
> +		if (!memcmp(&table_guid, &tables[i].guid, sizeof(efi_guid_t))) {
> +			*table = tables[i].table;
> +			return EFI_SUCCESS;
> +		}
> +	}
> +	return EFI_NOT_FOUND;
> +}
> +
>  efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
>  {
>  	int ret;
> diff --git a/lib/efi.h b/lib/efi.h
> index 2d3772c..dbb8159 100644
> --- a/lib/efi.h
> +++ b/lib/efi.h
> @@ -12,6 +12,7 @@
>  efi_status_t _relocate(long ldbase, Elf64_Dyn *dyn, efi_handle_t handle, efi_system_table_t *sys_tab);
>  efi_status_t efi_get_memory_map(struct efi_boot_memmap *map);
>  efi_status_t efi_exit_boot_services(void *handle, unsigned long mapkey);
> +efi_status_t efi_get_system_config_table(efi_guid_t table_guid, void **table);
>  efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab);
>  
>  #endif /* _EFI_H_ */
> diff --git a/lib/linux/uefi.h b/lib/linux/uefi.h
> index 9adc7ab..d1d599f 100644
> --- a/lib/linux/uefi.h
> +++ b/lib/linux/uefi.h
> @@ -58,6 +58,21 @@ typedef guid_t efi_guid_t;
>  	(b) & 0xff, ((b) >> 8) & 0xff,						\
>  	(c) & 0xff, ((c) >> 8) & 0xff, d } }
>  
> +#define ACPI_TABLE_GUID EFI_GUID(0xeb9d2d30, 0x2d88, 0x11d3, 0x9a, 0x16, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
> +
> +typedef struct {
> +	efi_guid_t guid;
> +	u32 table;
> +} efi_config_table_32_t;
> +
> +typedef union {
> +	struct {
> +		efi_guid_t guid;
> +		void *table;
> +	};
> +	efi_config_table_32_t mixed_mode;

Can't we drop all the mixed_mode stuff? Or do we really want to support
32-bit UEFI kvm-unit-tests?

> +} efi_config_table_t;
> +
>  /*
>   * Generic EFI table header
>   */
> diff --git a/lib/x86/acpi.c b/lib/x86/acpi.c
> index 4373106..0f75d79 100644
> --- a/lib/x86/acpi.c
> +++ b/lib/x86/acpi.c
> @@ -1,9 +1,37 @@
>  #include "libcflat.h"
>  #include "acpi.h"
>  
> +#ifdef TARGET_EFI
> +struct rsdp_descriptor *efi_rsdp = NULL;
> +
> +void setup_efi_rsdp(struct rsdp_descriptor *rsdp) {
> +	efi_rsdp = rsdp;
> +}

{ on its own line please

> +
> +static struct rsdp_descriptor *get_rsdp(void) {
> +	if (efi_rsdp == NULL) {
> +		printf("Can't find RSDP from UEFI, maybe setup_efi_rsdp() was not called\n");
> +	}
> +	return efi_rsdp;
> +}
> +#else
> +static struct rsdp_descriptor *get_rsdp(void) {
> +    struct rsdp_descriptor *rsdp;
> +    unsigned long addr;
> +    for(addr = 0xf0000; addr < 0x100000; addr += 16) {
> +	rsdp = (void*)addr;
> +	if (rsdp->signature == RSDP_SIGNATURE_8BYTE)
> +          break;
> +    }

When moving code please take the opportunity to clean up its style.

> +    if (addr == 0x100000) {
> +        return NULL;
> +    }
> +    return rsdp;
> +}
> +#endif /* TARGET_EFI */
> +
>  void* find_acpi_table_addr(u32 sig)
>  {
> -    unsigned long addr;
>      struct rsdp_descriptor *rsdp;
>      struct rsdt_descriptor_rev1 *rsdt;
>      void *end;
> @@ -19,12 +47,8 @@ void* find_acpi_table_addr(u32 sig)
>          return (void*)(ulong)fadt->firmware_ctrl;
>      }
>  
> -    for(addr = 0xf0000; addr < 0x100000; addr += 16) {
> -	rsdp = (void*)addr;
> -	if (rsdp->signature == 0x2052545020445352LL)
> -          break;
> -    }
> -    if (addr == 0x100000) {
> +    rsdp = get_rsdp();
> +    if (rsdp == NULL) {
>          printf("Can't find RSDP\n");
>          return 0;
>      }
> diff --git a/lib/x86/acpi.h b/lib/x86/acpi.h
> index 1b80374..db8ee56 100644
> --- a/lib/x86/acpi.h
> +++ b/lib/x86/acpi.h
> @@ -11,6 +11,13 @@
>  #define FACP_SIGNATURE ACPI_SIGNATURE('F','A','C','P')
>  #define FACS_SIGNATURE ACPI_SIGNATURE('F','A','C','S')
>  
> +
> +#define ACPI_SIGNATURE_8BYTE(c1, c2, c3, c4, c5, c6, c7, c8) \
> +	((uint64_t)(ACPI_SIGNATURE(c1, c2, c3, c4))) |       \
> +	((uint64_t)(ACPI_SIGNATURE(c5, c6, c7, c8)) << 32)
> +
> +#define RSDP_SIGNATURE_8BYTE (ACPI_SIGNATURE_8BYTE('R', 'S', 'D', ' ', 'P', 'T', 'R', ' '))
> +
>  struct rsdp_descriptor {        /* Root System Descriptor Pointer */
>      u64 signature;              /* ACPI signature, contains "RSD PTR " */
>      u8  checksum;               /* To make sum of struct == 0 */
> @@ -101,4 +108,8 @@ struct facs_descriptor_rev1
>  
>  void* find_acpi_table_addr(u32 sig);
>  
> +#ifdef TARGET_EFI
> +void setup_efi_rsdp(struct rsdp_descriptor *rsdp);
> +#endif /* TARGET_EFI */

Unnecessary ifdef.

> +
>  #endif
> diff --git a/lib/x86/asm/setup.h b/lib/x86/asm/setup.h
> index 8ff31ef..40fd963 100644
> --- a/lib/x86/asm/setup.h
> +++ b/lib/x86/asm/setup.h
> @@ -2,6 +2,7 @@
>  #define _X86_ASM_SETUP_H_
>  
>  #ifdef TARGET_EFI
> +#include "x86/acpi.h"
>  #include "x86/apic.h"
>  #include "x86/smp.h"
>  #include "efi.h"
> @@ -15,6 +16,7 @@
>  typedef struct {
>  	phys_addr_t free_mem_start;
>  	phys_addr_t free_mem_size;
> +	struct rsdp_descriptor *rsdp;
>  } efi_bootinfo_t;
>  
>  void setup_efi_bootinfo(efi_bootinfo_t *efi_bootinfo);
> diff --git a/lib/x86/setup.c b/lib/x86/setup.c
> index a49e0d4..1ddfb8c 100644
> --- a/lib/x86/setup.c
> +++ b/lib/x86/setup.c
> @@ -135,6 +135,7 @@ void setup_efi_bootinfo(efi_bootinfo_t *efi_bootinfo)
>  {
>  	efi_bootinfo->free_mem_size = 0;
>  	efi_bootinfo->free_mem_start = 0;
> +	efi_bootinfo->rsdp = NULL;
>  }
>  
>  static efi_status_t setup_pre_boot_memory(unsigned long *mapkey, efi_bootinfo_t *efi_bootinfo)
> @@ -185,6 +186,11 @@ static efi_status_t setup_pre_boot_memory(unsigned long *mapkey, efi_bootinfo_t
>  	return EFI_SUCCESS;
>  }
>  
> +static efi_status_t setup_pre_boot_rsdp(efi_bootinfo_t *efi_bootinfo)
> +{
> +	return efi_get_system_config_table(ACPI_TABLE_GUID, (void **)&efi_bootinfo->rsdp);
> +}
> +
>  efi_status_t setup_efi_pre_boot(unsigned long *mapkey, efi_bootinfo_t *efi_bootinfo)
>  {
>  	efi_status_t status;
> @@ -203,6 +209,12 @@ efi_status_t setup_efi_pre_boot(unsigned long *mapkey, efi_bootinfo_t *efi_booti
>  		return status;
>  	}
>  
> +	status = setup_pre_boot_rsdp(efi_bootinfo);
> +	if (status != EFI_SUCCESS) {
> +		printf("Cannot find RSDP in EFI system table\n");
> +		return status;
> +	}
> +
>  	return EFI_SUCCESS;
>  }
>  
> @@ -255,6 +267,7 @@ void setup_efi(efi_bootinfo_t *efi_bootinfo)
>  	enable_x2apic();
>  	smp_init();
>  	phys_alloc_init(efi_bootinfo->free_mem_start, efi_bootinfo->free_mem_size);
> +	setup_efi_rsdp(efi_bootinfo->rsdp);

What memory region is this table in? We should make sure it's reserved or
copy the table out to somewhere that is reserved.

>  }
>  
>  #endif /* TARGET_EFI */
> -- 
> 2.33.0.259.gc128427fd7-goog
>

I'd much prefer we avoid too much of this split setup where we have a bit
of setup in a common efi lib and then an x86 specific part that populates
an x86 specific info structure before exiting boot services and then more
x86 specific setup that uses that later... 

Can't we do almost everything in lib/efi.c and only call out once into an
arch_efi_setup function after exiting boot services?

Thanks,
drew

