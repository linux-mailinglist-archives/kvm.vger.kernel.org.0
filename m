Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5C83E0AB8
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 01:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbhHDXJT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 19:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbhHDXJT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 19:09:19 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2BD7C061798
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 16:09:04 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id x7so3211879ilh.10
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 16:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VmKoqPxtmz3LinXCEf4UyRiZ48LWiSjHFNY3pqfMWb8=;
        b=AMp1bXGXLQZPM2wpWLEIIsn32AZ8GvhBJ3McXvBCGs05CIh4f03DF4NZs4aCjauqBC
         N7LealoMadHUJNmfFW0YGrPYpyUSbSzl65iTLEzRB3FYtrtV+uXUJzIbCBygcoyxGX1D
         MPnUVrL5GlVrYCmi+HvkcFBUc1c3PHZUtQU7Cv6ie/ilJA5fl2fFPuqkXzrPEEsYKaID
         otSXSd33Bz98a4YN4b6Ol3p7VdvNRhoqwe7amc1TP6MMI0KlZGf6mZwLMJXDq//IGTBA
         te+RQzT2/mY1gIiyqB5KqP4qGmP8JFB+DOeTnKbcv4/GmyrWAQDCyxDiEqoXc+HAZqIn
         wEwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VmKoqPxtmz3LinXCEf4UyRiZ48LWiSjHFNY3pqfMWb8=;
        b=oZwGKWW0hQrVOjXwB8Pe++V6jG5JpSRMipVCe384KVV4gtjZSlMdHxfM67vB1YgN3G
         ESFim5NIhtzPgmq3T93mLxRzF6ogyaqtEJSyi5dGUUksTE/JxNz7r9WXeiJYLMR8Pcvl
         sNqscPVuo860W4AH8C/xwQqEfPZDL6+MxeGT2PeZgccRGh99WyojvOjQhf4nbkuRabYW
         bME9/Q6druQXBKwytiNB1g/xEG2Ylu+cr985vjqYwtm1tv4ZJLxwL7nE0LaEP1vqpx9v
         PJsMA8EPSUcHq7gkOb6jcnBGJZDp8801REqbJ3rs3PeZO4LNgSx7RdV/cS7JHUcD0E9T
         oXRQ==
X-Gm-Message-State: AOAM530QlIsuXOG7XfHkeqCbH6yyYz2l+CKINFw7vHMyDsgiw+cDtnpp
        kXnvtuRqXJkbmgOrWmnrWF6xykY9mxibUxmry4Wl4w==
X-Google-Smtp-Source: ABdhPJy5zY+8RsXLshA/zYIc0jaUMMx7hb2RAA2BxZDcBbhbnTlovLYnYbExpkI4IRPvNGO+GHk9E+FXK/rcQ5m0xjE=
X-Received: by 2002:a05:6e02:1073:: with SMTP id q19mr712026ilj.110.1628118544096;
 Wed, 04 Aug 2021 16:09:04 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1624978790.git.ashish.kalra@amd.com> <f987ecfce59e90f1b207a84715544799392bdd85.1624978790.git.ashish.kalra@amd.com>
In-Reply-To: <f987ecfce59e90f1b207a84715544799392bdd85.1624978790.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Wed, 4 Aug 2021 16:08:27 -0700
Message-ID: <CABayD+d2U4GX_azcQiWe5bHw+N4pPXcTnNH5-wop+5czO_engw@mail.gmail.com>
Subject: Re: [PATCH v5 5/6] x86/kvm: Add guest support for detecting and
 enabling SEV Live Migration feature.
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, joro@8bytes.org, bp@alien8.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, brijesh.singh@amd.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 29, 2021 at 8:12 AM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> The guest support for detecting and enabling SEV Live migration
> feature uses the following logic :
>
>  - kvm_init_plaform() checks if its booted under the EFI
>
>    - If not EFI,
>
>      i) if kvm_para_has_feature(KVM_FEATURE_MIGRATION_CONTROL), issue a wrmsrl()
>          to enable the SEV live migration support
>
>    - If EFI,
>
>      i) If kvm_para_has_feature(KVM_FEATURE_MIGRATION_CONTROL), read
>         the UEFI variable which indicates OVMF support for live migration
>
>      ii) the variable indicates live migration is supported, issue a wrmsrl() to
>           enable the SEV live migration support
>
> The EFI live migration check is done using a late_initcall() callback.
>
> Also, ensure that _bss_decrypted section is marked as decrypted in the
> shared pages list.
>
> v5 of this patch splits the guest kernel support for SEV live migration
> and kexec support for live migration into separate patches.
>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/include/asm/mem_encrypt.h |  4 ++
>  arch/x86/kernel/kvm.c              | 82 ++++++++++++++++++++++++++++++
>  arch/x86/mm/mem_encrypt.c          |  5 ++
>  3 files changed, 91 insertions(+)
>
> diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
> index 9c80c68d75b5..8dd373cc8b66 100644
> --- a/arch/x86/include/asm/mem_encrypt.h
> +++ b/arch/x86/include/asm/mem_encrypt.h
> @@ -43,6 +43,8 @@ void __init sme_enable(struct boot_params *bp);
>
>  int __init early_set_memory_decrypted(unsigned long vaddr, unsigned long size);
>  int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size);
> +void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages,
> +                                           bool enc);
>
>  void __init mem_encrypt_free_decrypted_mem(void);
>
> @@ -83,6 +85,8 @@ static inline int __init
>  early_set_memory_decrypted(unsigned long vaddr, unsigned long size) { return 0; }
>  static inline int __init
>  early_set_memory_encrypted(unsigned long vaddr, unsigned long size) { return 0; }
> +static inline void __init
> +early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages, bool enc) {}
>
>  static inline void mem_encrypt_free_decrypted_mem(void) { }
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index a26643dc6bd6..a014c9bb5066 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -27,6 +27,7 @@
>  #include <linux/nmi.h>
>  #include <linux/swait.h>
>  #include <linux/syscore_ops.h>
> +#include <linux/efi.h>
>  #include <asm/timer.h>
>  #include <asm/cpu.h>
>  #include <asm/traps.h>
> @@ -40,6 +41,7 @@
>  #include <asm/ptrace.h>
>  #include <asm/reboot.h>
>  #include <asm/svm.h>
> +#include <asm/e820/api.h>
>
>  DEFINE_STATIC_KEY_FALSE(kvm_async_pf_enabled);
>
> @@ -433,6 +435,8 @@ static void kvm_guest_cpu_offline(bool shutdown)
>         kvm_disable_steal_time();
>         if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
>                 wrmsrl(MSR_KVM_PV_EOI_EN, 0);
> +       if (kvm_para_has_feature(KVM_FEATURE_MIGRATION_CONTROL))
> +               wrmsrl(MSR_KVM_MIGRATION_CONTROL, 0);
>         kvm_pv_disable_apf();
>         if (!shutdown)
>                 apf_task_wake_all();
> @@ -547,6 +551,55 @@ static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int vector)
>         __send_ipi_mask(local_mask, vector);
>  }
>
> +static int __init setup_efi_kvm_sev_migration(void)
> +{
> +       efi_char16_t efi_sev_live_migration_enabled[] = L"SevLiveMigrationEnabled";
> +       efi_guid_t efi_variable_guid = AMD_SEV_MEM_ENCRYPT_GUID;
> +       efi_status_t status;
> +       unsigned long size;
> +       bool enabled;
> +
> +       if (!sev_active() ||
> +           !kvm_para_has_feature(KVM_FEATURE_MIGRATION_CONTROL))
> +               return 0;
> +
> +       if (!efi_enabled(EFI_BOOT))
> +               return 0;
> +
> +       if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
> +               pr_info("%s : EFI runtime services are not enabled\n", __func__);
> +               return 0;
> +       }
> +
> +       size = sizeof(enabled);
> +
> +       /* Get variable contents into buffer */
> +       status = efi.get_variable(efi_sev_live_migration_enabled,
> +                                 &efi_variable_guid, NULL, &size, &enabled);
> +
> +       if (status == EFI_NOT_FOUND) {
> +               pr_info("%s : EFI live migration variable not found\n", __func__);
> +               return 0;
> +       }
> +
> +       if (status != EFI_SUCCESS) {
> +               pr_info("%s : EFI variable retrieval failed\n", __func__);
> +               return 0;
> +       }
> +
> +       if (enabled == 0) {
> +               pr_info("%s: live migration disabled in EFI\n", __func__);
> +               return 0;
> +       }
> +
> +       pr_info("%s : live migration enabled in EFI\n", __func__);
> +       wrmsrl(MSR_KVM_MIGRATION_CONTROL, KVM_MIGRATION_READY);
> +
> +       return 1;
> +}
> +
> +late_initcall(setup_efi_kvm_sev_migration);
> +
>  /*
>   * Set the IPI entry points
>   */
> @@ -805,8 +858,37 @@ static bool __init kvm_msi_ext_dest_id(void)
>         return kvm_para_has_feature(KVM_FEATURE_MSI_EXT_DEST_ID);
>  }
>
> +static void kvm_sev_hc_page_enc_status(unsigned long pfn, int npages, bool enc)
> +{
> +       kvm_hypercall3(KVM_HC_MAP_GPA_RANGE, pfn << PAGE_SHIFT, npages,
> +                      KVM_MAP_GPA_RANGE_ENC_STAT(enc) | KVM_MAP_GPA_RANGE_PAGE_SZ_4K);
> +}
> +
>  static void __init kvm_init_platform(void)
>  {
> +       if (sev_active() &&
> +           kvm_para_has_feature(KVM_FEATURE_MIGRATION_CONTROL)) {
> +               unsigned long nr_pages;
> +
> +               pv_ops.mmu.notify_page_enc_status_changed =
> +                       kvm_sev_hc_page_enc_status;
> +
> +               /*
> +                * Ensure that _bss_decrypted section is marked as decrypted in the
> +                * shared pages list.
> +                */
> +               nr_pages = DIV_ROUND_UP(__end_bss_decrypted - __start_bss_decrypted,
> +                                       PAGE_SIZE);
> +               early_set_mem_enc_dec_hypercall((unsigned long)__start_bss_decrypted,
> +                                               nr_pages, 0);
> +
> +               /*
> +                * If not booted using EFI, enable Live migration support.
> +                */
> +               if (!efi_enabled(EFI_BOOT))
> +                       wrmsrl(MSR_KVM_MIGRATION_CONTROL,
> +                              KVM_MIGRATION_READY);
> +       }
>         kvmclock_init();
>         x86_platform.apic_post_init = kvm_apic_init;
>  }
> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index 455ac487cb9d..2673a89d17d9 100644
> --- a/arch/x86/mm/mem_encrypt.c
> +++ b/arch/x86/mm/mem_encrypt.c
> @@ -409,6 +409,11 @@ int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size)
>         return early_set_memory_enc_dec(vaddr, size, true);
>  }
>
> +void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages, bool enc)
> +{
> +       notify_range_enc_status_changed(vaddr, npages, enc);
> +}
> +
>  /*
>   * SME and SEV are very similar but they are not the same, so there are
>   * times that the kernel will need to distinguish between SME and SEV. The
> --
> 2.17.1
>

Reviewed-by: Steve Rutherford <srutherford@google.com>
