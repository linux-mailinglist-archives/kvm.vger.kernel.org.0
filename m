Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077231EAFE8
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 22:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgFAUDC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 16:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727096AbgFAUDB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 16:03:01 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F8EC03E96F
        for <kvm@vger.kernel.org>; Mon,  1 Jun 2020 13:03:01 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id z2so2335570ilq.0
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 13:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0RgPdItwsLx2ENgRWmM+I0DxA4JUI54nkgZSWg+4IKw=;
        b=h8PZ9lof6sMcO2/7rPs/OIVhlHdKkwbIp+KcoFG2U9FcujmvUtVI1LIfwzbsszHDSU
         RQViT7DQyAHiIX94j4unM3JBl09U96/gA7djvcgiq2e6fjnMgr+V4IbSy9EhqukPsmna
         LwrArK6OuNlCunmYpqVCPtR0nqbOSuEiKBuBwdvu2+1Iqpz7IBfUHwKRhJiliCTya//6
         EvyiY/ivi3cvndMVoCkgdkMg4Fg3HBE96kls3ZhgyI+icgN2VAHkhFnbiOxMq2GuSH+j
         Dnoxfo1C7hqWXxTQ6+HuOjQgC9Ndj12olICCzzi8CLYamh2a19RsTPYLN+AF7lnSrMUQ
         KnOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0RgPdItwsLx2ENgRWmM+I0DxA4JUI54nkgZSWg+4IKw=;
        b=ms9sZVhz+nxuj0qQ/cPZz5cTuXYhg9NS6OctmQ8KvbK5ljW6lMrgdr0f2yl+tJfEHI
         XrUfklqAGP/IfraPICtTuz4j/BPKqtrPEWmjwVExsaLZoSl7tlA0TLcoap60sURuk6Jp
         nTYGvxCHzM0Whn7XPxeoz929mLZyiYFT786eg/j4M40jjBzdbEvIxlfRg5YYrE5VnlQz
         n19jOKKta15AJy8yBFn9UkGg07vMMNQIFzHMt+xbcq33cptD+1yW/iGzpYEt1x7ePEiF
         UlO60OYR9o2HluUpTE8XZ+ygokcddTMhFQNB0gH/CqD023u7NIVgSFfyjK8hpNkWIFUP
         T0Zw==
X-Gm-Message-State: AOAM533nkwvgXeNSwHmEN5E8ZIDm93+aq6+f5fZrSvlWGEVcCtChfU89
        1CnMbTGwUfMH0Ps0yBS7OacNAHtPoy25s/JCJGlpTA==
X-Google-Smtp-Source: ABdhPJygpNA4HhXnSf3TuMaun/tTILi+nQjQURhz6vLaIllBPB1hwybVnPHh1Ni2qe3mkhWpV+fbnCISsIdsMrqMWIw=
X-Received: by 2002:a92:914d:: with SMTP id t74mr21414360ild.182.1591041779963;
 Mon, 01 Jun 2020 13:02:59 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1588711355.git.ashish.kalra@amd.com> <20200518190708.GA7929@ashkalra_ubuntu_server>
In-Reply-To: <20200518190708.GA7929@ashkalra_ubuntu_server>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 1 Jun 2020 13:02:23 -0700
Message-ID: <CABayD+eJm43rc0Db1aATXut_kpRwKjsOCkZ_Q+NteFnP7d25hg@mail.gmail.com>
Subject: Re: [PATCH v8 00/18] Add AMD SEV guest live migration support
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 18, 2020 at 12:07 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
>
> Hello All,
>
> Any other feedback, review or comments on this patch-set ?
>
> Thanks,
> Ashish
>
> On Tue, May 05, 2020 at 09:13:49PM +0000, Ashish Kalra wrote:
> > From: Ashish Kalra <ashish.kalra@amd.com>
> >
> > The series add support for AMD SEV guest live migration commands. To protect the
> > confidentiality of an SEV protected guest memory while in transit we need to
> > use the SEV commands defined in SEV API spec [1].
> >
> > SEV guest VMs have the concept of private and shared memory. Private memory
> > is encrypted with the guest-specific key, while shared memory may be encrypted
> > with hypervisor key. The commands provided by the SEV FW are meant to be used
> > for the private memory only. The patch series introduces a new hypercall.
> > The guest OS can use this hypercall to notify the page encryption status.
> > If the page is encrypted with guest specific-key then we use SEV command during
> > the migration. If page is not encrypted then fallback to default.
> >
> > The patch adds new ioctls KVM_{SET,GET}_PAGE_ENC_BITMAP. The ioctl can be used
> > by the qemu to get the page encrypted bitmap. Qemu can consult this bitmap
> > during the migration to know whether the page is encrypted.
> >
> > This section descibes how the SEV live migration feature is negotiated
> > between the host and guest, the host indicates this feature support via
> > KVM_FEATURE_CPUID. The guest firmware (OVMF) detects this feature and
> > sets a UEFI enviroment variable indicating OVMF support for live
> > migration, the guest kernel also detects the host support for this
> > feature via cpuid and in case of an EFI boot verifies if OVMF also
> > supports this feature by getting the UEFI enviroment variable and if it
> > set then enables live migration feature on host by writing to a custom
> > MSR, if not booted under EFI, then it simply enables the feature by
> > again writing to the custom MSR. The host returns error as part of
> > SET_PAGE_ENC_BITMAP ioctl if guest has not enabled live migration.
> >
> > A branch containing these patches is available here:
> > https://github.com/AMDESE/linux/tree/sev-migration-v8
> >
> > [1] https://developer.amd.com/wp-content/resources/55766.PDF
> >
> > Changes since v7:
> > - Removed the hypervisor specific hypercall/paravirt callback for
> >   SEV live migration and moved back to calling kvm_sev_hypercall3
> >   directly.
> > - Fix build errors as
> >   Reported-by: kbuild test robot <lkp@intel.com>, specifically fixed
> >   build error when CONFIG_HYPERVISOR_GUEST=y and
> >   CONFIG_AMD_MEM_ENCRYPT=n.
> > - Implicitly enabled live migration for incoming VM(s) to handle
> >   A->B->C->... VM migrations.
> > - Fixed Documentation as per comments on v6 patches.
> > - Fixed error return path in sev_send_update_data() as per comments
> >   on v6 patches.
> >
> > Changes since v6:
> > - Rebasing to mainline and refactoring to the new split SVM
> >   infrastructre.
> > - Move to static allocation of the unified Page Encryption bitmap
> >   instead of the dynamic resizing of the bitmap, the static allocation
> >   is done implicitly by extending kvm_arch_commit_memory_region() callack
> >   to add svm specific x86_ops which can read the userspace provided memory
> >   region/memslots and calculate the amount of guest RAM managed by the KVM
> >   and grow the bitmap.
> > - Fixed KVM_SET_PAGE_ENC_BITMAP ioctl to set the whole bitmap instead
> >   of simply clearing specific bits.
> > - Removed KVM_PAGE_ENC_BITMAP_RESET ioctl, which is now performed using
> >   KVM_SET_PAGE_ENC_BITMAP.
> > - Extended guest support for enabling Live Migration feature by adding a
> >   check for UEFI environment variable indicating OVMF support for Live
> >   Migration feature and additionally checking for KVM capability for the
> >   same feature. If not booted under EFI, then we simply check for KVM
> >   capability.
> > - Add hypervisor specific hypercall for SEV live migration by adding
> >   a new paravirt callback as part of x86_hyper_runtime.
> >   (x86 hypervisor specific runtime callbacks)
> > - Moving MSR handling for MSR_KVM_SEV_LIVE_MIG_EN into svm/sev code
> >   and adding check for SEV live migration enabled by guest in the
> >   KVM_GET_PAGE_ENC_BITMAP ioctl.
> > - Instead of the complete __bss_decrypted section, only specific variables
> >   such as hv_clock_boot and wall_clock are marked as decrypted in the
> >   page encryption bitmap
> >
> > Changes since v5:
> > - Fix build errors as
> >   Reported-by: kbuild test robot <lkp@intel.com>
> >
> > Changes since v4:
> > - Host support has been added to extend KVM capabilities/feature bits to
> >   include a new KVM_FEATURE_SEV_LIVE_MIGRATION, which the guest can
> >   query for host-side support for SEV live migration and a new custom MSR
> >   MSR_KVM_SEV_LIVE_MIG_EN is added for guest to enable the SEV live
> >   migration feature.
> > - Ensure that _bss_decrypted section is marked as decrypted in the
> >   page encryption bitmap.
> > - Fixing KVM_GET_PAGE_ENC_BITMAP ioctl to return the correct bitmap
> >   as per the number of pages being requested by the user. Ensure that
> >   we only copy bmap->num_pages bytes in the userspace buffer, if
> >   bmap->num_pages is not byte aligned we read the trailing bits
> >   from the userspace and copy those bits as is. This fixes guest
> >   page(s) corruption issues observed after migration completion.
> > - Add kexec support for SEV Live Migration to reset the host's
> >   page encryption bitmap related to kernel specific page encryption
> >   status settings before we load a new kernel by kexec. We cannot
> >   reset the complete page encryption bitmap here as we need to
> >   retain the UEFI/OVMF firmware specific settings.
> >
> > Changes since v3:
> > - Rebasing to mainline and testing.
> > - Adding a new KVM_PAGE_ENC_BITMAP_RESET ioctl, which resets the
> >   page encryption bitmap on a guest reboot event.
> > - Adding a more reliable sanity check for GPA range being passed to
> >   the hypercall to ensure that guest MMIO ranges are also marked
> >   in the page encryption bitmap.
> >
> > Changes since v2:
> >  - reset the page encryption bitmap on vcpu reboot
> >
> > Changes since v1:
> >  - Add support to share the page encryption between the source and target
> >    machine.
> >  - Fix review feedbacks from Tom Lendacky.
> >  - Add check to limit the session blob length.
> >  - Update KVM_GET_PAGE_ENC_BITMAP icotl to use the base_gfn instead of
> >    the memory slot when querying the bitmap.
> >
> > Ashish Kalra (7):
> >   KVM: SVM: Add support for static allocation of unified Page Encryption
> >     Bitmap.
> >   KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION feature &
> >     Custom MSR.
> >   EFI: Introduce the new AMD Memory Encryption GUID.
> >   KVM: x86: Add guest support for detecting and enabling SEV Live
> >     Migration feature.
> >   KVM: x86: Mark _bss_decrypted section variables as decrypted in page
> >     encryption bitmap.
> >   KVM: x86: Add kexec support for SEV Live Migration.
> >   KVM: SVM: Enable SEV live migration feature implicitly on Incoming
> >     VM(s).
> >
> > Brijesh Singh (11):
> >   KVM: SVM: Add KVM_SEV SEND_START command
> >   KVM: SVM: Add KVM_SEND_UPDATE_DATA command
> >   KVM: SVM: Add KVM_SEV_SEND_FINISH command
> >   KVM: SVM: Add support for KVM_SEV_RECEIVE_START command
> >   KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command
> >   KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
> >   KVM: x86: Add AMD SEV specific Hypercall3
> >   KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
> >   KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP ioctl
> >   mm: x86: Invoke hypercall when page encryption status is changed
> >   KVM: x86: Introduce KVM_SET_PAGE_ENC_BITMAP ioctl
> >
> >  .../virt/kvm/amd-memory-encryption.rst        | 120 +++
> >  Documentation/virt/kvm/api.rst                |  71 ++
> >  Documentation/virt/kvm/cpuid.rst              |   5 +
> >  Documentation/virt/kvm/hypercalls.rst         |  15 +
> >  Documentation/virt/kvm/msr.rst                |  10 +
> >  arch/x86/include/asm/kvm_host.h               |   7 +
> >  arch/x86/include/asm/kvm_para.h               |  12 +
> >  arch/x86/include/asm/mem_encrypt.h            |  11 +
> >  arch/x86/include/asm/paravirt.h               |  10 +
> >  arch/x86/include/asm/paravirt_types.h         |   2 +
> >  arch/x86/include/uapi/asm/kvm_para.h          |   5 +
> >  arch/x86/kernel/kvm.c                         |  90 +++
> >  arch/x86/kernel/kvmclock.c                    |  12 +
> >  arch/x86/kernel/paravirt.c                    |   1 +
> >  arch/x86/kvm/svm/sev.c                        | 732 +++++++++++++++++-
> >  arch/x86/kvm/svm/svm.c                        |  21 +
> >  arch/x86/kvm/svm/svm.h                        |   9 +
> >  arch/x86/kvm/vmx/vmx.c                        |   1 +
> >  arch/x86/kvm/x86.c                            |  35 +
> >  arch/x86/mm/mem_encrypt.c                     |  68 +-
> >  arch/x86/mm/pat/set_memory.c                  |   7 +
> >  include/linux/efi.h                           |   1 +
> >  include/linux/psp-sev.h                       |   8 +-
> >  include/uapi/linux/kvm.h                      |  52 ++
> >  include/uapi/linux/kvm_para.h                 |   1 +
> >  25 files changed, 1297 insertions(+), 9 deletions(-)
> >
> > --
> > 2.17.1
> >

Hey all,
These patches look pretty reasonable at this point. What's the next
step for getting them merged?

Thanks,
Steve
