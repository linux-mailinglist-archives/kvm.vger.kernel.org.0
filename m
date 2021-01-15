Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECE62F6F8E
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 01:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731328AbhAOAdS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 19:33:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731209AbhAOAdQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 19:33:16 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E6EC061757
        for <kvm@vger.kernel.org>; Thu, 14 Jan 2021 16:32:36 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id u17so15049571iow.1
        for <kvm@vger.kernel.org>; Thu, 14 Jan 2021 16:32:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VOQ/AhgJ3E0EhA15ZI14xotoZTAklFRTxP5RiI0pr4w=;
        b=ZKqirSc1RXxGZk9m5C1Q/rMeYrWTjUtba1m3HeBthnH0Q+DkrD/47pIHau7E42QcG0
         QlHkz/g7VIe6SAqB7J4f2opMv3QT5kSoqCxxCcWR/pv9KOyrtrqvotn63RsCS7DpyDkH
         nbmJPf1tn6pkcO2yIqk4rvEX91Zp9+iBKf1uFwKuz+w6NFs5U0owMt4o9Rn2jfVpGVQ9
         MMmfSi0SacqZMIU07He0glcF8l+in5ianV+FHe+F6kRz17NYwXcGFIAGvBWLQ6TxOb7s
         Xpg2OT2vsqbXYIGXZzP1ZpUNxv6A6pkMhSf5cepMH0caIl7QocPIyQ+3Zu0tcz4r04ZD
         T7qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VOQ/AhgJ3E0EhA15ZI14xotoZTAklFRTxP5RiI0pr4w=;
        b=Y8PDNi3SLcD13wVmLg52Ij16vi1YWkiS9btpk74tRYWKCMKL9gUVy/JL1Bj2XN6CjQ
         GW9I1GwYBHD4bzQVoKAvTg5lFS3mucDCXR/4psN11uw94GXZDdYGXLSI96kP7t5tjVm4
         0e0xYEyM8txpAwGKDje9gQX94dvWcou5mH59183/cVITcqdVekMOEPKN8h6galqFov+7
         8iJ+oZMdAYL73ywkGBeOpTl9O7gh2kOeOqycEFXIkvXvHT4c/eeK0kOfProlpTq0IGGw
         r2sJNqOVDWVA6jx/LcQlz0lla03Yh9uSHkcV75L8wW/UsA4a6AK4k4sC9ZeJdjPUv7y1
         feoA==
X-Gm-Message-State: AOAM5327HdnfWbBZGUzfOEfcXSp9JYj42s5A2XdlLXzNa3zNP/HOY/gz
        QdgHImt2xAzr972khK3fwIL42Wx8YZqGno2CfG9sQQ==
X-Google-Smtp-Source: ABdhPJxbNAzWVOVJfbEBY8T6GsiM6dkRxLPzdspE3E1+d0gUbNlqrmg6Px5WqEFTvbpRjjACRkEjKVw73nzyq7Vc/Yo=
X-Received: by 2002:a02:4b42:: with SMTP id q63mr8126963jaa.77.1610670755423;
 Thu, 14 Jan 2021 16:32:35 -0800 (PST)
MIME-Version: 1.0
References: <cover.1607460588.git.ashish.kalra@amd.com>
In-Reply-To: <cover.1607460588.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Thu, 14 Jan 2021 16:31:59 -0800
Message-ID: <CABayD+e+_ye9s-toCFwfaZkTbhM0=pMuyt5dtjmZJpmf3OT5mg@mail.gmail.com>
Subject: Re: [PATCH v9 00/18] Add AMD SEV guest live migration support
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Forgot to ask this: is there an intention to support SEND_CANCEL in a
follow up patch?


On Tue, Dec 8, 2020 at 2:03 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
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
> The patch adds new ioctls KVM_{SET,GET}_PAGE_ENC_BITMAP. The ioctl can be used
> by the qemu to get the page encrypted bitmap. Qemu can consult this bitmap
> during the migration to know whether the page is encrypted.
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
> again writing to the custom MSR. The host returns error as part of
> SET_PAGE_ENC_BITMAP ioctl if guest has not enabled live migration.
>
> A branch containing these patches is available here:
> https://github.com/AMDESE/linux/tree/sev-migration-v9
>
> [1] https://developer.amd.com/wp-content/resources/55766.PDF
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
> Ashish Kalra (7):
>   KVM: SVM: Add support for static allocation of unified Page Encryption
>     Bitmap.
>   KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION feature &
>     Custom MSR.
>   EFI: Introduce the new AMD Memory Encryption GUID.
>   KVM: x86: Add guest support for detecting and enabling SEV Live
>     Migration feature.
>   KVM: x86: Mark _bss_decrypted section variables as decrypted in page
>     encryption bitmap.
>   KVM: x86: Add kexec support for SEV Live Migration.
>   KVM: SVM: Enable SEV live migration feature implicitly on Incoming
>     VM(s).
>
> Brijesh Singh (11):
>   KVM: SVM: Add KVM_SEV SEND_START command
>   KVM: SVM: Add KVM_SEND_UPDATE_DATA command
>   KVM: SVM: Add KVM_SEV_SEND_FINISH command
>   KVM: SVM: Add support for KVM_SEV_RECEIVE_START command
>   KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command
>   KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
>   KVM: x86: Add AMD SEV specific Hypercall3
>   KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
>   KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP ioctl
>   mm: x86: Invoke hypercall when page encryption status is changed
>   KVM: x86: Introduce KVM_SET_PAGE_ENC_BITMAP ioctl
>
> Ashish Kalra (7):
>   KVM: SVM: Add support for static allocation of unified Page Encryption
>     Bitmap.
>   KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION feature &
>     Custom MSR.
>   EFI: Introduce the new AMD Memory Encryption GUID.
>   KVM: x86: Add guest support for detecting and enabling SEV Live
>     Migration feature.
>   KVM: x86: Mark _bss_decrypted section variables as decrypted in page
>     encryption bitmap.
>   KVM: x86: Add kexec support for SEV Live Migration.
>   KVM: SVM: Bypass DBG_DECRYPT API calls for unecrypted guest memory.
>
> Brijesh Singh (11):
>   KVM: SVM: Add KVM_SEV SEND_START command
>   KVM: SVM: Add KVM_SEND_UPDATE_DATA command
>   KVM: SVM: Add KVM_SEV_SEND_FINISH command
>   KVM: SVM: Add support for KVM_SEV_RECEIVE_START command
>   KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command
>   KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
>   KVM: x86: Add AMD SEV specific Hypercall3
>   KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
>   KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP ioctl
>   mm: x86: Invoke hypercall when page encryption status is changed
>   KVM: x86: Introduce KVM_SET_PAGE_ENC_BITMAP ioctl
>
>  .../virt/kvm/amd-memory-encryption.rst        | 120 +++
>  Documentation/virt/kvm/api.rst                |  71 ++
>  Documentation/virt/kvm/cpuid.rst              |   5 +
>  Documentation/virt/kvm/hypercalls.rst         |  15 +
>  Documentation/virt/kvm/msr.rst                |  16 +
>  arch/x86/include/asm/kvm_host.h               |   7 +
>  arch/x86/include/asm/kvm_para.h               |  12 +
>  arch/x86/include/asm/mem_encrypt.h            |  11 +
>  arch/x86/include/asm/paravirt.h               |  10 +
>  arch/x86/include/asm/paravirt_types.h         |   2 +
>  arch/x86/include/uapi/asm/kvm_para.h          |   5 +
>  arch/x86/kernel/kvm.c                         |  90 ++
>  arch/x86/kernel/kvmclock.c                    |  12 +
>  arch/x86/kernel/paravirt.c                    |   1 +
>  arch/x86/kvm/svm/sev.c                        | 790 ++++++++++++++++++
>  arch/x86/kvm/svm/svm.c                        |  21 +
>  arch/x86/kvm/svm/svm.h                        |   9 +
>  arch/x86/kvm/vmx/vmx.c                        |   1 +
>  arch/x86/kvm/x86.c                            |  35 +
>  arch/x86/mm/mem_encrypt.c                     |  68 +-
>  arch/x86/mm/pat/set_memory.c                  |   7 +
>  include/linux/efi.h                           |   1 +
>  include/linux/psp-sev.h                       |   8 +-
>  include/uapi/linux/kvm.h                      |  52 ++
>  include/uapi/linux/kvm_para.h                 |   1 +
>  25 files changed, 1365 insertions(+), 5 deletions(-)
>
> --
> 2.17.1
>
