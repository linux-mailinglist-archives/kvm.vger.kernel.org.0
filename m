Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570FD36573A
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 13:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbhDTLMK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 07:12:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32369 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231655AbhDTLMJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 07:12:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618917098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8LUAbMij+bq8BEclnHrdbDTYNJ89Yzaa7j+6TnR+vVg=;
        b=dus+w+0ELx4hhx//Yt1/Mevt6D+ieBLsX/K12p7lNaHvdVxcryi8zoqN2ZNeNsKZKJ7ah+
        JqcQp0XvC0fnNH/Q8wVbButPIyrSpgH4hupm2zSQTe8wyHLTJKXs4FKyV6vLXxFPXS4Ka4
        /VZELZQ+HXEdTbyl8do69hpmReoEqNs=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-_vfgntLOOOmi8R1UD5ZuyQ-1; Tue, 20 Apr 2021 07:11:34 -0400
X-MC-Unique: _vfgntLOOOmi8R1UD5ZuyQ-1
Received: by mail-ed1-f72.google.com with SMTP id r14-20020a50d68e0000b0290385504d6e4eso2991191edi.7
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 04:11:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8LUAbMij+bq8BEclnHrdbDTYNJ89Yzaa7j+6TnR+vVg=;
        b=BlpvTUGgnt6tUJXxWxogKygK+scI2FpxttDrp1Ezpva5nNoYbeKtoJprrk1hnsei5U
         N6uEgh+rPJyMbjehKbXdkdkAbOxPbUnxiK1HiMtgzbVkZNvtaiqO/bRtgm0O8ClRwFlQ
         tcjKWJvxIiKowCGjMgJW7DQgZ/pRYzCn+oayDUMy6DB8k3yQ8tGBRXx80Kq61/mxqvZI
         KPbvqg4LCS+Y7N5JVSamCSxjHpbU0eLIkPatSV/vd94SrmI4e/0FNh/wAqVUqeZ/KmHQ
         vRfqXHWVI6x6XNP94XZWxLfZ7YLJgKXSONiWNX6Oe2JRcnPdjQezFMpt9GO7Y1mVop6g
         2spA==
X-Gm-Message-State: AOAM5326SjdEtbJksk2SxsttKOkmv97gvKB0rrb/ZgQXe/ipXOigA6fJ
        D3I0+vu2QCska/9Ty9sN2A49zf8I2CbxUnkvYGauJArL7XOGeec4GJuYPyukDr+GUedH/ScqEFn
        9TealEGC7GT4T
X-Received: by 2002:a05:6402:1a:: with SMTP id d26mr31573517edu.99.1618917093350;
        Tue, 20 Apr 2021 04:11:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzQLuC6VFZ1zOtaePYOk4wTLVahIrKYRZErwJqWp0EoHPUsPWs+uYjaDj5GKzrEA5HicabF2g==
X-Received: by 2002:a05:6402:1a:: with SMTP id d26mr31573477edu.99.1618917093083;
        Tue, 20 Apr 2021 04:11:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id dc24sm6047099ejb.123.2021.04.20.04.11.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 04:11:32 -0700 (PDT)
Subject: Re: [PATCH v13 00/12] Add AMD SEV guest live migration support
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
References: <cover.1618498113.git.ashish.kalra@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <65ebdd0c-3224-742b-d0dd-5003309d1d62@redhat.com>
Date:   Tue, 20 Apr 2021 13:11:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <cover.1618498113.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/04/21 17:52, Ashish Kalra wrote:
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
> The patch uses the KVM_EXIT_HYPERCALL exitcode and hypercall to
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
> https://github.com/AMDESE/linux/tree/sev-migration-v13
> 
> [1] https://developer.amd.com/wp-content/resources/55766.PDF

I have queued patches 1-6.

For patches 8 and 10 I will post my own version based on my review and 
feedback.

For guest patches, please repost separately so that x86 maintainers will 
notice them and ack them.

Paolo

> Changes since v12:
> - Reset page encryption status during early boot instead of just
>    before the kexec to avoid SMP races during kvm_pv_guest_cpu_reboot().
> - Remove incorrect log message in case of non-EFI boot and implicit
>    enabling of SEV live migration feature.
> 
> Changes since v11:
> - Clean up and remove kvm_x86_ops callback for page_enc_status_hc and
>    instead add a new per-VM flag to support/enable the page encryption
>    status hypercall.
> - Remove KVM_EXIT_DMA_SHARE/KVM_EXIT_DMA_UNSHARE exitcodes and instead
>    use the KVM_EXIT_HYPERCALL exitcode for page encryption status
>    hypercall to userspace functionality.
> 
> Changes since v10:
> - Adds new KVM_EXIT_DMA_SHARE/KVM_EXIT_DMA_UNSHARE hypercall to
>    userspace exit functionality as a common interface from the guest back to the
>    KVM and passing on the guest shared/unencrypted region information to the
>    userspace VMM/Qemu. KVM/host kernel does not maintain the guest shared
>    memory regions information anymore.
> - Remove implicit enabling of SEV live migration feature for an SEV
>    guest, now this is explicitly in control of the userspace VMM/Qemu.
> - Custom MSR handling is also now moved into userspace VMM/Qemu.
> - As KVM does not maintain the guest shared memory region information
>    anymore, sev_dbg_crypt() cannot bypass unencrypted guest memory
>    regions without support from userspace VMM/Qemu.
> 
> Changes since v9:
> - Transitioning from page encryption bitmap to the shared pages list
>    to keep track of guest's shared/unencrypted memory regions.
> - Move back to marking the complete _bss_decrypted section as
>    decrypted in the shared pages list.
> - Invoke a new function check_kvm_sev_migration() via kvm_init_platform()
>    for guest to query for host-side support for SEV live migration
>    and to enable the SEV live migration feature, to avoid
>    #ifdefs in code
> - Rename MSR_KVM_SEV_LIVE_MIG_EN to MSR_KVM_SEV_LIVE_MIGRATION.
> - Invoke a new function handle_unencrypted_region() from
>    sev_dbg_crypt() to bypass unencrypted guest memory regions.
> 
> Changes since v8:
> - Rebasing to kvm next branch.
> - Fixed and added comments as per review feedback on v8 patches.
> - Removed implicitly enabling live migration for incoming VMs in
>    in KVM_SET_PAGE_ENC_BITMAP, it is now done via KVM_SET_MSR ioctl.
> - Adds support for bypassing unencrypted guest memory regions for
>    DBG_DECRYPT API calls, guest memory region encryption status in
>    sev_dbg_decrypt() is referenced using the page encryption bitmap.
> 
> Changes since v7:
> - Removed the hypervisor specific hypercall/paravirt callback for
>    SEV live migration and moved back to calling kvm_sev_hypercall3
>    directly.
> - Fix build errors as
>    Reported-by: kbuild test robot <lkp@intel.com>, specifically fixed
>    build error when CONFIG_HYPERVISOR_GUEST=y and
>    CONFIG_AMD_MEM_ENCRYPT=n.
> - Implicitly enabled live migration for incoming VM(s) to handle
>    A->B->C->... VM migrations.
> - Fixed Documentation as per comments on v6 patches.
> - Fixed error return path in sev_send_update_data() as per comments
>    on v6 patches.
> 
> Changes since v6:
> - Rebasing to mainline and refactoring to the new split SVM
>    infrastructre.
> - Move to static allocation of the unified Page Encryption bitmap
>    instead of the dynamic resizing of the bitmap, the static allocation
>    is done implicitly by extending kvm_arch_commit_memory_region() callack
>    to add svm specific x86_ops which can read the userspace provided memory
>    region/memslots and calculate the amount of guest RAM managed by the KVM
>    and grow the bitmap.
> - Fixed KVM_SET_PAGE_ENC_BITMAP ioctl to set the whole bitmap instead
>    of simply clearing specific bits.
> - Removed KVM_PAGE_ENC_BITMAP_RESET ioctl, which is now performed using
>    KVM_SET_PAGE_ENC_BITMAP.
> - Extended guest support for enabling Live Migration feature by adding a
>    check for UEFI environment variable indicating OVMF support for Live
>    Migration feature and additionally checking for KVM capability for the
>    same feature. If not booted under EFI, then we simply check for KVM
>    capability.
> - Add hypervisor specific hypercall for SEV live migration by adding
>    a new paravirt callback as part of x86_hyper_runtime.
>    (x86 hypervisor specific runtime callbacks)
> - Moving MSR handling for MSR_KVM_SEV_LIVE_MIG_EN into svm/sev code
>    and adding check for SEV live migration enabled by guest in the
>    KVM_GET_PAGE_ENC_BITMAP ioctl.
> - Instead of the complete __bss_decrypted section, only specific variables
>    such as hv_clock_boot and wall_clock are marked as decrypted in the
>    page encryption bitmap
> 
> Changes since v5:
> - Fix build errors as
>    Reported-by: kbuild test robot <lkp@intel.com>
> 
> Changes since v4:
> - Host support has been added to extend KVM capabilities/feature bits to
>    include a new KVM_FEATURE_SEV_LIVE_MIGRATION, which the guest can
>    query for host-side support for SEV live migration and a new custom MSR
>    MSR_KVM_SEV_LIVE_MIG_EN is added for guest to enable the SEV live
>    migration feature.
> - Ensure that _bss_decrypted section is marked as decrypted in the
>    page encryption bitmap.
> - Fixing KVM_GET_PAGE_ENC_BITMAP ioctl to return the correct bitmap
>    as per the number of pages being requested by the user. Ensure that
>    we only copy bmap->num_pages bytes in the userspace buffer, if
>    bmap->num_pages is not byte aligned we read the trailing bits
>    from the userspace and copy those bits as is. This fixes guest
>    page(s) corruption issues observed after migration completion.
> - Add kexec support for SEV Live Migration to reset the host's
>    page encryption bitmap related to kernel specific page encryption
>    status settings before we load a new kernel by kexec. We cannot
>    reset the complete page encryption bitmap here as we need to
>    retain the UEFI/OVMF firmware specific settings.
> 
> Changes since v3:
> - Rebasing to mainline and testing.
> - Adding a new KVM_PAGE_ENC_BITMAP_RESET ioctl, which resets the
>    page encryption bitmap on a guest reboot event.
> - Adding a more reliable sanity check for GPA range being passed to
>    the hypercall to ensure that guest MMIO ranges are also marked
>    in the page encryption bitmap.
> 
> Changes since v2:
>   - reset the page encryption bitmap on vcpu reboot
> 
> Changes since v1:
>   - Add support to share the page encryption between the source and target
>     machine.
>   - Fix review feedbacks from Tom Lendacky.
>   - Add check to limit the session blob length.
>   - Update KVM_GET_PAGE_ENC_BITMAP icotl to use the base_gfn instead of
>     the memory slot when querying the bitmap.
> 
> Ashish Kalra (4):
>    KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
>    KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION feature &
>      Custom MSR.
>    EFI: Introduce the new AMD Memory Encryption GUID.
>    x86/kvm: Add guest support for detecting and enabling SEV Live
>      Migration feature.
> 
> Brijesh Singh (8):
>    KVM: SVM: Add KVM_SEV SEND_START command
>    KVM: SVM: Add KVM_SEND_UPDATE_DATA command
>    KVM: SVM: Add KVM_SEV_SEND_FINISH command
>    KVM: SVM: Add support for KVM_SEV_RECEIVE_START command
>    KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command
>    KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
>    KVM: x86: Add AMD SEV specific Hypercall3
>    mm: x86: Invoke hypercall when page encryption status is changed
> 
>   .../virt/kvm/amd-memory-encryption.rst        | 120 +++++
>   Documentation/virt/kvm/cpuid.rst              |   5 +
>   Documentation/virt/kvm/hypercalls.rst         |  15 +
>   Documentation/virt/kvm/msr.rst                |  12 +
>   arch/x86/include/asm/kvm_host.h               |   2 +
>   arch/x86/include/asm/kvm_para.h               |  12 +
>   arch/x86/include/asm/mem_encrypt.h            |   8 +
>   arch/x86/include/asm/paravirt.h               |  10 +
>   arch/x86/include/asm/paravirt_types.h         |   2 +
>   arch/x86/include/uapi/asm/kvm_para.h          |   4 +
>   arch/x86/kernel/kvm.c                         |  55 +++
>   arch/x86/kernel/paravirt.c                    |   1 +
>   arch/x86/kvm/cpuid.c                          |   3 +-
>   arch/x86/kvm/svm/sev.c                        | 454 ++++++++++++++++++
>   arch/x86/kvm/x86.c                            |  29 ++
>   arch/x86/mm/mem_encrypt.c                     | 121 ++++-
>   arch/x86/mm/pat/set_memory.c                  |   7 +
>   include/linux/efi.h                           |   1 +
>   include/linux/psp-sev.h                       |   8 +-
>   include/uapi/linux/kvm.h                      |  39 ++
>   include/uapi/linux/kvm_para.h                 |   1 +
>   21 files changed, 903 insertions(+), 6 deletions(-)
> 

