Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4030335433F
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 17:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241469AbhDEPR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 11:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236175AbhDEPR1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 11:17:27 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE35DC061788
        for <kvm@vger.kernel.org>; Mon,  5 Apr 2021 08:17:20 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id n138so17945282lfa.3
        for <kvm@vger.kernel.org>; Mon, 05 Apr 2021 08:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C3QO+bH7E/csLRTMnxswL/elOdiJao9hLznrXmJU3bY=;
        b=jBZEGsqR+InnFmQEUxbDKG5+XzvgVOQhnL2wJ+brGyM6wEa8Ml6IkJiQ9Bi65WG+Hu
         9rdxBvFMq7P4ra4C2wopJ4wOk4EbJouMUYq3Puz6s4k8if+cgQ61VV8QioO1CA5fkiVR
         iEB11M5BUgGK801aXEV/FSwAg9wK3pKaL/EWirQunmjkyq4kYN3Ldqm/aEBAauAE11N+
         bwmNKGEKe1gv7kUIL88LK0A63lGURjco7oTZZXQZxAa85JUqC89sGIvyWkFwLqPdJ0c1
         LB3I4qGQTtxuTL5L4anFp5WJOD81yWB2QntEnSg2q3q2sQWYDrgKWn2coqhIT1zv9duL
         1bxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C3QO+bH7E/csLRTMnxswL/elOdiJao9hLznrXmJU3bY=;
        b=qYw5zKY6Yj6zvati+3/Z8aKVuG2nqZTz4IuAf+W9vthNADN9/K9e6aeIdWFOsoUc8v
         mKmSH3syZ+ZZCKoN3X1CMNjDeKgC1wziSZScxQFbBEQ1bZa7YiqdRLpOzHa7YQu9naIu
         UnZXISdTbukRC0h61tjvnS6S/5/Cq26LlgnFwfe9kYqCb7LV/u7WK+mzzY/YeCKc2M7I
         GNRwWX7tx39/B5vthdFI6oHjGZZPQZ4LyD6L415vj9newt31D/DuPoWQ20Yo/QNuO2gG
         UTaNm6HGuXa+U/KG6Hgzpr+hFleaa7LoYOVQRox5QJoUvt6/BDFLhVLuLSDKkyLpI+1L
         BQ9A==
X-Gm-Message-State: AOAM532iHFQglzjg3UrOz6VmHnfkZ6cfIRsuyT+JyD3zY0kseK3ik5tp
        iW9yAgp4Zrrf0qEYUe/aAmk5QzoB248dVH6RT3AV0g==
X-Google-Smtp-Source: ABdhPJxPahXDEXG4lKP3sShBIFSh3aFuhTfYw58Ix0jHyItMy1XLP19yJ1vqAzKsabJVHivTtwsZhsiQZrtRGZ1KNhs=
X-Received: by 2002:ac2:4a70:: with SMTP id q16mr18355641lfp.455.1617635838988;
 Mon, 05 Apr 2021 08:17:18 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1617302792.git.ashish.kalra@amd.com>
In-Reply-To: <cover.1617302792.git.ashish.kalra@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Mon, 5 Apr 2021 09:17:07 -0600
Message-ID: <CAMkAt6oWF23YFiOGW_h+iyhjkaAp6uaMNjYKDXNxvNCWR=vyWw@mail.gmail.com>
Subject: Re: [PATCH v11 00/13] Add AMD SEV guest live migration support
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>, x86@kernel.org,
        kvm list <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Steve Rutherford <srutherford@google.com>,
        Sean Christopherson <seanjc@google.com>,
        venu.busireddy@oracle.com, "Singh, Brijesh" <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Could this patch set include support for the SEND_CANCEL command?

On Mon, Apr 5, 2021 at 8:20 AM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> The series add support for AMD SEV guest live migration commands. To protect the
> confidentiality of an SEV protected guest memory while in transit we need to
> use the SEV commands defined in SEV API spec [1].
>
> SEV guest VMs have the concept of private and shared memory. Private memory
> is encrypted with the guest-specific key, while shared memory may be encrypted
> with hypervisor key. The commands provided by the SEV FW are meant to be used
> for the private memory only. The patch series introduces a new hypercall.
> The guest OS can use this hypercall to notify the page encryption status.
> If the page is encrypted with guest specific-key then we use SEV command during
> the migration. If page is not encrypted then fallback to default.
>
> The patch adds new KVM_EXIT_DMA_SHARE/KVM_EXIT_DMA_UNSHARE hypercall to
> userspace exit functionality as a common interface from the guest back to the
> VMM and passing on the guest shared/unencrypted page information to the
> userspace VMM/Qemu. Qemu can consult this information during migration to know
> whether the page is encrypted.
>
> This section descibes how the SEV live migration feature is negotiated
> between the host and guest, the host indicates this feature support via
> KVM_FEATURE_CPUID. The guest firmware (OVMF) detects this feature and
> sets a UEFI enviroment variable indicating OVMF support for live
> migration, the guest kernel also detects the host support for this
> feature via cpuid and in case of an EFI boot verifies if OVMF also
> supports this feature by getting the UEFI enviroment variable and if it
> set then enables live migration feature on host by writing to a custom
> MSR, if not booted under EFI, then it simply enables the feature by
> again writing to the custom MSR. The MSR is also handled by the
> userspace VMM/Qemu.
>
> A branch containing these patches is available here:
> https://github.com/AMDESE/linux/tree/sev-migration-v11
>
> [1] https://developer.amd.com/wp-content/resources/55766.PDF
>
> Changes since v10:
> - Adds new KVM_EXIT_DMA_SHARE/KVM_EXIT_DMA_UNSHARE hypercall to
>   userspace exit functionality as a common interface from the guest back to the
>   KVM and passing on the guest shared/unencrypted region information to the
>   userspace VMM/Qemu. KVM/host kernel does not maintain the guest shared
>   memory regions information anymore.
> - Remove implicit enabling of SEV live migration feature for an SEV
>   guest, now this is explicitly in control of the userspace VMM/Qemu.
> - Custom MSR handling is also now moved into userspace VMM/Qemu.
> - As KVM does not maintain the guest shared memory region information
>   anymore, sev_dbg_crypt() cannot bypass unencrypted guest memory
>   regions without support from userspace VMM/Qemu.
>
> Changes since v9:
> - Transitioning from page encryption bitmap to the shared pages list
>   to keep track of guest's shared/unencrypted memory regions.
> - Move back to marking the complete _bss_decrypted section as
>   decrypted in the shared pages list.
> - Invoke a new function check_kvm_sev_migration() via kvm_init_platform()
>   for guest to query for host-side support for SEV live migration
>   and to enable the SEV live migration feature, to avoid
>   #ifdefs in code
> - Rename MSR_KVM_SEV_LIVE_MIG_EN to MSR_KVM_SEV_LIVE_MIGRATION.
> - Invoke a new function handle_unencrypted_region() from
>   sev_dbg_crypt() to bypass unencrypted guest memory regions.
>
> Changes since v8:
> - Rebasing to kvm next branch.
> - Fixed and added comments as per review feedback on v8 patches.
> - Removed implicitly enabling live migration for incoming VMs in
>   in KVM_SET_PAGE_ENC_BITMAP, it is now done via KVM_SET_MSR ioctl.
> - Adds support for bypassing unencrypted guest memory regions for
>   DBG_DECRYPT API calls, guest memory region encryption status in
>   sev_dbg_decrypt() is referenced using the page encryption bitmap.
>
> Changes since v7:
> - Removed the hypervisor specific hypercall/paravirt callback for
>   SEV live migration and moved back to calling kvm_sev_hypercall3
>   directly.
> - Fix build errors as
>   Reported-by: kbuild test robot <lkp@intel.com>, specifically fixed
>   build error when CONFIG_HYPERVISOR_GUEST=y and
>   CONFIG_AMD_MEM_ENCRYPT=n.
> - Implicitly enabled live migration for incoming VM(s) to handle
>   A->B->C->... VM migrations.
> - Fixed Documentation as per comments on v6 patches.
> - Fixed error return path in sev_send_update_data() as per comments
>   on v6 patches.
>
> Changes since v6:
> - Rebasing to mainline and refactoring to the new split SVM
>   infrastructre.
> - Move to static allocation of the unified Page Encryption bitmap
>   instead of the dynamic resizing of the bitmap, the static allocation
>   is done implicitly by extending kvm_arch_commit_memory_region() callack
>   to add svm specific x86_ops which can read the userspace provided memory
>   region/memslots and calculate the amount of guest RAM managed by the KVM
>   and grow the bitmap.
> - Fixed KVM_SET_PAGE_ENC_BITMAP ioctl to set the whole bitmap instead
>   of simply clearing specific bits.
> - Removed KVM_PAGE_ENC_BITMAP_RESET ioctl, which is now performed using
>   KVM_SET_PAGE_ENC_BITMAP.
> - Extended guest support for enabling Live Migration feature by adding a
>   check for UEFI environment variable indicating OVMF support for Live
>   Migration feature and additionally checking for KVM capability for the
>   same feature. If not booted under EFI, then we simply check for KVM
>   capability.
> - Add hypervisor specific hypercall for SEV live migration by adding
>   a new paravirt callback as part of x86_hyper_runtime.
>   (x86 hypervisor specific runtime callbacks)
> - Moving MSR handling for MSR_KVM_SEV_LIVE_MIG_EN into svm/sev code
>   and adding check for SEV live migration enabled by guest in the
>   KVM_GET_PAGE_ENC_BITMAP ioctl.
> - Instead of the complete __bss_decrypted section, only specific variables
>   such as hv_clock_boot and wall_clock are marked as decrypted in the
>   page encryption bitmap
>
> Changes since v5:
> - Fix build errors as
>   Reported-by: kbuild test robot <lkp@intel.com>
>
> Changes since v4:
> - Host support has been added to extend KVM capabilities/feature bits to
>   include a new KVM_FEATURE_SEV_LIVE_MIGRATION, which the guest can
>   query for host-side support for SEV live migration and a new custom MSR
>   MSR_KVM_SEV_LIVE_MIG_EN is added for guest to enable the SEV live
>   migration feature.
> - Ensure that _bss_decrypted section is marked as decrypted in the
>   page encryption bitmap.
> - Fixing KVM_GET_PAGE_ENC_BITMAP ioctl to return the correct bitmap
>   as per the number of pages being requested by the user. Ensure that
>   we only copy bmap->num_pages bytes in the userspace buffer, if
>   bmap->num_pages is not byte aligned we read the trailing bits
>   from the userspace and copy those bits as is. This fixes guest
>   page(s) corruption issues observed after migration completion.
> - Add kexec support for SEV Live Migration to reset the host's
>   page encryption bitmap related to kernel specific page encryption
>   status settings before we load a new kernel by kexec. We cannot
>   reset the complete page encryption bitmap here as we need to
>   retain the UEFI/OVMF firmware specific settings.
>
> Changes since v3:
> - Rebasing to mainline and testing.
> - Adding a new KVM_PAGE_ENC_BITMAP_RESET ioctl, which resets the
>   page encryption bitmap on a guest reboot event.
> - Adding a more reliable sanity check for GPA range being passed to
>   the hypercall to ensure that guest MMIO ranges are also marked
>   in the page encryption bitmap.
>
> Changes since v2:
>  - reset the page encryption bitmap on vcpu reboot
>
> Changes since v1:
>  - Add support to share the page encryption between the source and target
>    machine.
>  - Fix review feedbacks from Tom Lendacky.
>  - Add check to limit the session blob length.
>  - Update KVM_GET_PAGE_ENC_BITMAP icotl to use the base_gfn instead of
>    the memory slot when querying the bitmap.
>
> Ashish Kalra (5):
>   KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
>   KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION feature &
>     Custom MSR.
>   EFI: Introduce the new AMD Memory Encryption GUID.
>   x86/kvm: Add guest support for detecting and enabling SEV Live
>     Migration feature.
>   x86/kvm: Add kexec support for SEV Live Migration.
>
> Brijesh Singh (8):
>   KVM: SVM: Add KVM_SEV SEND_START command
>   KVM: SVM: Add KVM_SEND_UPDATE_DATA command
>   KVM: SVM: Add KVM_SEV_SEND_FINISH command
>   KVM: SVM: Add support for KVM_SEV_RECEIVE_START command
>   KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command
>   KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
>   KVM: x86: Add AMD SEV specific Hypercall3
>   mm: x86: Invoke hypercall when page encryption status is changed
>
>  .../virt/kvm/amd-memory-encryption.rst        | 120 ++++
>  Documentation/virt/kvm/api.rst                |  18 +
>  Documentation/virt/kvm/cpuid.rst              |   5 +
>  Documentation/virt/kvm/hypercalls.rst         |  15 +
>  Documentation/virt/kvm/msr.rst                |  12 +
>  arch/x86/include/asm/kvm_host.h               |   2 +
>  arch/x86/include/asm/kvm_para.h               |  12 +
>  arch/x86/include/asm/mem_encrypt.h            |   8 +
>  arch/x86/include/asm/paravirt.h               |  10 +
>  arch/x86/include/asm/paravirt_types.h         |   2 +
>  arch/x86/include/uapi/asm/kvm_para.h          |   4 +
>  arch/x86/kernel/kvm.c                         |  76 +++
>  arch/x86/kernel/paravirt.c                    |   1 +
>  arch/x86/kvm/cpuid.c                          |   3 +-
>  arch/x86/kvm/svm/sev.c                        | 514 ++++++++++++++++++
>  arch/x86/kvm/svm/svm.c                        |  24 +
>  arch/x86/kvm/svm/svm.h                        |   2 +
>  arch/x86/kvm/vmx/vmx.c                        |   1 +
>  arch/x86/kvm/x86.c                            |  12 +
>  arch/x86/mm/mem_encrypt.c                     |  98 +++-
>  arch/x86/mm/pat/set_memory.c                  |   7 +
>  include/linux/efi.h                           |   1 +
>  include/linux/psp-sev.h                       |   8 +-
>  include/uapi/linux/kvm.h                      |  47 ++
>  include/uapi/linux/kvm_para.h                 |   1 +
>  25 files changed, 997 insertions(+), 6 deletions(-)
>
> --
> 2.17.1
>
