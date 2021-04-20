Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 949853656E9
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 12:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbhDTKxf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 06:53:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54647 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231532AbhDTKxd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 06:53:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618915981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S27AwgKlv+iaMTT9DUQIVOBnDUO++jFCerhn1E2ub9I=;
        b=W8/SYmorXwzQ7no5e6QVNd7vt/RJu8sXCa+e/XEEIElz0UJE2fmBgo4j1SwJGne3O3K0pR
        q+ZMAYYkpt7swplpbW7OYWFv6gByNcUbdPofHfo9xWy9DhzV8Fa70zieoAPVRXQxH8Kfcz
        8ITUcgKHcdRrkQ7B6xbQH2zUd7KVzRo=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-qfMCK60YMcWweO-HkVsNKQ-1; Tue, 20 Apr 2021 06:53:00 -0400
X-MC-Unique: qfMCK60YMcWweO-HkVsNKQ-1
Received: by mail-ed1-f72.google.com with SMTP id bf25-20020a0564021a59b0290385169cebf8so5500369edb.8
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 03:52:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S27AwgKlv+iaMTT9DUQIVOBnDUO++jFCerhn1E2ub9I=;
        b=IFMmQV5OIveZXr1M8ky6c78FeyrA0PmE4s+UHnQ5LUcwVXz771YRr7Xs/WQYSUVnFX
         q1L+0R/4CCCAcxKlZv1Nc+xQjhRO2GVBdThcMS6RszoGy5fi3Ft+O4XlImqlFHQu7vsU
         hEa0ylxaH7IiW6clUb1cG6/ghFGm6QpvsB+gllV5ZPQVPL9YYcjeFkj6lk6Tkl0wEtYw
         zvRUwn3ST3UXgpB4Ro2CWoJoq6DYtKBLZ5teM1bovT6WXlbzhB5VGEO/x+fzwst1LPt6
         0mElTQykLUQi26z4ldpDlvWI2hLvIjevlLNehIayju8pBz+qUfYgT+93479uFGWePwZL
         kURw==
X-Gm-Message-State: AOAM5318EEmnevfBiC6olFAvJ9Yx1Fk7dTm4Xrqsko2oRGZraIn8yzRy
        6kow8+V4Hdu0ldwZLyUidFfYe5Rl4PAxs+BdDupdPZxkopXkIApiz5e8kLwfBngfdXeI1B3dbBv
        h2eOGNPa7P28q
X-Received: by 2002:a17:907:7051:: with SMTP id ws17mr27034383ejb.498.1618915978982;
        Tue, 20 Apr 2021 03:52:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxnAg4Y/B7vNqk/lIdyUrklowjyBOdLGuy6H/Q+NJlu7PWdgLsntyBDOwwNTeJbdATZVY+h5A==
X-Received: by 2002:a17:907:7051:: with SMTP id ws17mr27034361ejb.498.1618915978718;
        Tue, 20 Apr 2021 03:52:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g11sm15883017edt.35.2021.04.20.03.52.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 03:52:58 -0700 (PDT)
Subject: Re: [PATCH v13 12/12] x86/kvm: Add guest support for detecting and
 enabling SEV Live Migration feature.
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com,
        kexec@lists.infradead.org
References: <cover.1618498113.git.ashish.kalra@amd.com>
 <ffd67dbc1ae6d3505d844e65928a7248ebaebdcc.1618498113.git.ashish.kalra@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a5694bf9-a02c-9169-dbaa-fecd8587d52a@redhat.com>
Date:   Tue, 20 Apr 2021 12:52:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <ffd67dbc1ae6d3505d844e65928a7248ebaebdcc.1618498113.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/04/21 18:01, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> The guest support for detecting and enabling SEV Live migration
> feature uses the following logic :
> 
>   - kvm_init_plaform() invokes check_kvm_sev_migration() which
>     checks if its booted under the EFI
> 
>     - If not EFI,
> 
>       i) check for the KVM_FEATURE_CPUID
> 
>       ii) if CPUID reports that migration is supported, issue a wrmsrl()
>           to enable the SEV live migration support
> 
>     - If EFI,
> 
>       i) check for the KVM_FEATURE_CPUID
> 
>       ii) If CPUID reports that migration is supported, read the UEFI variable which
>           indicates OVMF support for live migration
> 
>       iii) the variable indicates live migration is supported, issue a wrmsrl() to
>            enable the SEV live migration support
> 
> The EFI live migration check is done using a late_initcall() callback.
> 
> Also, ensure that _bss_decrypted section is marked as decrypted in the
> shared pages list.
> 
> Also adds kexec support for SEV Live Migration.
> 
> Reset the host's shared pages list related to kernel
> specific page encryption status settings before we load a
> new kernel by kexec. We cannot reset the complete
> shared pages list here as we need to retain the
> UEFI/OVMF firmware specific settings.
> 
> The host's shared pages list is maintained for the
> guest to keep track of all unencrypted guest memory regions,
> therefore we need to explicitly mark all shared pages as
> encrypted again before rebooting into the new guest kernel.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Boris, this one needs an ACK as well.

Paolo

> ---
>   arch/x86/include/asm/mem_encrypt.h |  8 ++++
>   arch/x86/kernel/kvm.c              | 55 +++++++++++++++++++++++++
>   arch/x86/mm/mem_encrypt.c          | 64 ++++++++++++++++++++++++++++++
>   3 files changed, 127 insertions(+)
> 
> diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
> index 31c4df123aa0..19b77f3a62dc 100644
> --- a/arch/x86/include/asm/mem_encrypt.h
> +++ b/arch/x86/include/asm/mem_encrypt.h
> @@ -21,6 +21,7 @@
>   extern u64 sme_me_mask;
>   extern u64 sev_status;
>   extern bool sev_enabled;
> +extern bool sev_live_migration_enabled;
>   
>   void sme_encrypt_execute(unsigned long encrypted_kernel_vaddr,
>   			 unsigned long decrypted_kernel_vaddr,
> @@ -44,8 +45,11 @@ void __init sme_enable(struct boot_params *bp);
>   
>   int __init early_set_memory_decrypted(unsigned long vaddr, unsigned long size);
>   int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size);
> +void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages,
> +					    bool enc);
>   
>   void __init mem_encrypt_free_decrypted_mem(void);
> +void __init check_kvm_sev_migration(void);
>   
>   /* Architecture __weak replacement functions */
>   void __init mem_encrypt_init(void);
> @@ -60,6 +64,7 @@ bool sev_es_active(void);
>   #else	/* !CONFIG_AMD_MEM_ENCRYPT */
>   
>   #define sme_me_mask	0ULL
> +#define sev_live_migration_enabled	false
>   
>   static inline void __init sme_early_encrypt(resource_size_t paddr,
>   					    unsigned long size) { }
> @@ -84,8 +89,11 @@ static inline int __init
>   early_set_memory_decrypted(unsigned long vaddr, unsigned long size) { return 0; }
>   static inline int __init
>   early_set_memory_encrypted(unsigned long vaddr, unsigned long size) { return 0; }
> +static inline void __init
> +early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages, bool enc) {}
>   
>   static inline void mem_encrypt_free_decrypted_mem(void) { }
> +static inline void check_kvm_sev_migration(void) { }
>   
>   #define __bss_decrypted
>   
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 78bb0fae3982..94ef16d263a7 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -26,6 +26,7 @@
>   #include <linux/kprobes.h>
>   #include <linux/nmi.h>
>   #include <linux/swait.h>
> +#include <linux/efi.h>
>   #include <asm/timer.h>
>   #include <asm/cpu.h>
>   #include <asm/traps.h>
> @@ -429,6 +430,59 @@ static inline void __set_percpu_decrypted(void *ptr, unsigned long size)
>   	early_set_memory_decrypted((unsigned long) ptr, size);
>   }
>   
> +static int __init setup_kvm_sev_migration(void)
> +{
> +	efi_char16_t efi_sev_live_migration_enabled[] = L"SevLiveMigrationEnabled";
> +	efi_guid_t efi_variable_guid = MEM_ENCRYPT_GUID;
> +	efi_status_t status;
> +	unsigned long size;
> +	bool enabled;
> +
> +	/*
> +	 * check_kvm_sev_migration() invoked via kvm_init_platform() before
> +	 * this callback would have setup the indicator that live migration
> +	 * feature is supported/enabled.
> +	 */
> +	if (!sev_live_migration_enabled)
> +		return 0;
> +
> +	if (!efi_enabled(EFI_BOOT))
> +		return 0;
> +
> +	if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
> +		pr_info("%s : EFI runtime services are not enabled\n", __func__);
> +		return 0;
> +	}
> +
> +	size = sizeof(enabled);
> +
> +	/* Get variable contents into buffer */
> +	status = efi.get_variable(efi_sev_live_migration_enabled,
> +				  &efi_variable_guid, NULL, &size, &enabled);
> +
> +	if (status == EFI_NOT_FOUND) {
> +		pr_info("%s : EFI live migration variable not found\n", __func__);
> +		return 0;
> +	}
> +
> +	if (status != EFI_SUCCESS) {
> +		pr_info("%s : EFI variable retrieval failed\n", __func__);
> +		return 0;
> +	}
> +
> +	if (enabled == 0) {
> +		pr_info("%s: live migration disabled in EFI\n", __func__);
> +		return 0;
> +	}
> +
> +	pr_info("%s : live migration enabled in EFI\n", __func__);
> +	wrmsrl(MSR_KVM_SEV_LIVE_MIGRATION, KVM_SEV_LIVE_MIGRATION_ENABLED);
> +
> +	return true;
> +}
> +
> +late_initcall(setup_kvm_sev_migration);
> +
>   /*
>    * Iterate through all possible CPUs and map the memory region pointed
>    * by apf_reason, steal_time and kvm_apic_eoi as decrypted at once.
> @@ -747,6 +801,7 @@ static bool __init kvm_msi_ext_dest_id(void)
>   
>   static void __init kvm_init_platform(void)
>   {
> +	check_kvm_sev_migration();
>   	kvmclock_init();
>   	x86_platform.apic_post_init = kvm_apic_init;
>   }
> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index fae9ccbd0da7..382d1d4f00f5 100644
> --- a/arch/x86/mm/mem_encrypt.c
> +++ b/arch/x86/mm/mem_encrypt.c
> @@ -20,6 +20,7 @@
>   #include <linux/bitops.h>
>   #include <linux/dma-mapping.h>
>   #include <linux/kvm_para.h>
> +#include <linux/efi.h>
>   
>   #include <asm/tlbflush.h>
>   #include <asm/fixmap.h>
> @@ -31,6 +32,7 @@
>   #include <asm/msr.h>
>   #include <asm/cmdline.h>
>   #include <asm/kvm_para.h>
> +#include <asm/e820/api.h>
>   
>   #include "mm_internal.h"
>   
> @@ -48,6 +50,8 @@ EXPORT_SYMBOL_GPL(sev_enable_key);
>   
>   bool sev_enabled __section(".data");
>   
> +bool sev_live_migration_enabled __section(".data");
> +
>   /* Buffer used for early in-place encryption by BSP, no locking needed */
>   static char sme_early_buffer[PAGE_SIZE] __initdata __aligned(PAGE_SIZE);
>   
> @@ -237,6 +241,9 @@ static void set_memory_enc_dec_hypercall(unsigned long vaddr, int npages,
>   	unsigned long sz = npages << PAGE_SHIFT;
>   	unsigned long vaddr_end, vaddr_next;
>   
> +	if (!sev_live_migration_enabled)
> +		return;
> +
>   	vaddr_end = vaddr + sz;
>   
>   	for (; vaddr < vaddr_end; vaddr = vaddr_next) {
> @@ -407,6 +414,12 @@ int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size)
>   	return early_set_memory_enc_dec(vaddr, size, true);
>   }
>   
> +void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages,
> +					bool enc)
> +{
> +	set_memory_enc_dec_hypercall(vaddr, npages, enc);
> +}
> +
>   /*
>    * SME and SEV are very similar but they are not the same, so there are
>    * times that the kernel will need to distinguish between SME and SEV. The
> @@ -462,6 +475,57 @@ bool force_dma_unencrypted(struct device *dev)
>   	return false;
>   }
>   
> +void __init check_kvm_sev_migration(void)
> +{
> +	if (sev_active() &&
> +	    kvm_para_has_feature(KVM_FEATURE_SEV_LIVE_MIGRATION)) {
> +		unsigned long nr_pages;
> +		int i;
> +
> +		pr_info("KVM enable live migration\n");
> +		WRITE_ONCE(sev_live_migration_enabled, true);
> +
> +		/*
> +		 * Reset the host's shared pages list related to kernel
> +		 * specific page encryption status settings before we load a
> +		 * new kernel by kexec. Reset the page encryption status
> +		 * during early boot intead of just before kexec to avoid SMP
> +		 * races during kvm_pv_guest_cpu_reboot().
> +		 * NOTE: We cannot reset the complete shared pages list
> +		 * here as we need to retain the UEFI/OVMF firmware
> +		 * specific settings.
> +		 */
> +
> +		for (i = 0; i < e820_table->nr_entries; i++) {
> +			struct e820_entry *entry = &e820_table->entries[i];
> +
> +			if (entry->type != E820_TYPE_RAM)
> +				continue;
> +
> +			nr_pages = DIV_ROUND_UP(entry->size, PAGE_SIZE);
> +
> +			kvm_sev_hypercall3(KVM_HC_PAGE_ENC_STATUS, entry->addr,
> +					   nr_pages, 1);
> +		}
> +
> +		/*
> +		 * Ensure that _bss_decrypted section is marked as decrypted in the
> +		 * shared pages list.
> +		 */
> +		nr_pages = DIV_ROUND_UP(__end_bss_decrypted - __start_bss_decrypted,
> +					PAGE_SIZE);
> +		early_set_mem_enc_dec_hypercall((unsigned long)__start_bss_decrypted,
> +						nr_pages, 0);
> +
> +		/*
> +		 * If not booted using EFI, enable Live migration support.
> +		 */
> +		if (!efi_enabled(EFI_BOOT))
> +			wrmsrl(MSR_KVM_SEV_LIVE_MIGRATION,
> +			       KVM_SEV_LIVE_MIGRATION_ENABLED);
> +	}
> +}
> +
>   void __init mem_encrypt_free_decrypted_mem(void)
>   {
>   	unsigned long vaddr, vaddr_end, npages;
> 

