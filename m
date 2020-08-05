Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D27B723CF03
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728915AbgHETMF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 15:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729252AbgHESaT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 14:30:19 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17608C06179E
        for <kvm@vger.kernel.org>; Wed,  5 Aug 2020 11:29:54 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id g14so9447926iom.0
        for <kvm@vger.kernel.org>; Wed, 05 Aug 2020 11:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SARuME9J10v3sen/Xni7v/xI7rOWv9gm7Kfl7nu9RLM=;
        b=WItl9UdE0b5ZGEHl6FjMKa0TRpIq4jGrjQhEgOYt0YHvs9S5QQiQGmiNiMibXYZytI
         GlLaeTtgReLvgxx7eFCaUDO97I7kX3GxfsEGfCW8jK1xTXKGGXoDchsKQXrHRm7zD97O
         FwrRkSbLKze3NLeC8B/aDYLbtdZxP39VNzEpqMAbIBPpVyzlsaej1GiNOGlMNZZvM1Nl
         5vtKO6OXlX4yDKKesarf6WlOoBq+mpke9JtvhHDVXX/wz1jOsLyf3tlHPUSt7WzUmSTA
         WuulOuN2AySeK690OH2U7Ya0L5v7hjAuauIfjr3AcMB+rgJWNEAn2oR4OwHP6ZVGxv3u
         Nq3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SARuME9J10v3sen/Xni7v/xI7rOWv9gm7Kfl7nu9RLM=;
        b=PCqLTRaUDYirbuVSYK23uGyDt9bK6rVrUbYCY4WQUV+3IByFKYC5GOWivnsdbfsnpe
         Ie93it5ud4IuTWuSNILXycixeBj6uGnxa1O8FRj8/mH4WL4xF4eCTsjgwo2cCzW6dmDJ
         E0qEZ91zIbpYgU+QZHP2IW4MkRksvKqbvcACrpSSVIBu0aOmVQBtuE/PY29VWD+QLer7
         ZatGffg4Wih4OkbEXwjZHjFolbbpQSzOMzVl27zlHf+fC7dAHCx+RVfoQOh6hSXVQgey
         dgCfhHxcO4Ws2fih9gzMETkPGfX/r6eFuOa+38vVM4dX7kQytwXBXcPJ++ZGbyPahYTd
         X0OA==
X-Gm-Message-State: AOAM530m87sxQ5RdTaEOFfxMJmIVEPKSnDJDa/0j+vSr/Qd++m60t8wl
        18VAlFFlBXCBm75wFux6yujV0Hpri7M25RVoHZmPAw==
X-Google-Smtp-Source: ABdhPJw1/ZX6Zxh2XqOSuKBSOqZgN3PrB8R6jBBj96SVyIceT6wdrGYeKyoldLvl1/EFlU0fL4yHu4e2fd8Q3Pyy6+I=
X-Received: by 2002:a6b:4e0e:: with SMTP id c14mr4490564iob.8.1596652193001;
 Wed, 05 Aug 2020 11:29:53 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1588711355.git.ashish.kalra@amd.com> <20200518190708.GA7929@ashkalra_ubuntu_server>
 <CABayD+eJm43rc0Db1aATXut_kpRwKjsOCkZ_Q+NteFnP7d25hg@mail.gmail.com> <20200603221428.GA6511@ashkalra_ubuntu_server>
In-Reply-To: <20200603221428.GA6511@ashkalra_ubuntu_server>
From:   Steve Rutherford <srutherford@google.com>
Date:   Wed, 5 Aug 2020 11:29:17 -0700
Message-ID: <CABayD+emF_kWf7UbvGhMmUpV9CAyPtEgFL9ocanumZu54aHSBQ@mail.gmail.com>
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
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Are these likely to get merged into 5.9?


On Wed, Jun 3, 2020 at 3:14 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
>
> Hello Steve,
>
> On Mon, Jun 01, 2020 at 01:02:23PM -0700, Steve Rutherford wrote:
> > On Mon, May 18, 2020 at 12:07 PM Ashish Kalra <ashish.kalra@amd.com> wr=
ote:
> > >
> > > Hello All,
> > >
> > > Any other feedback, review or comments on this patch-set ?
> > >
> > > Thanks,
> > > Ashish
> > >
> > > On Tue, May 05, 2020 at 09:13:49PM +0000, Ashish Kalra wrote:
> > > > From: Ashish Kalra <ashish.kalra@amd.com>
> > > >
> > > > The series add support for AMD SEV guest live migration commands. T=
o protect the
> > > > confidentiality of an SEV protected guest memory while in transit w=
e need to
> > > > use the SEV commands defined in SEV API spec [1].
> > > >
> > > > SEV guest VMs have the concept of private and shared memory. Privat=
e memory
> > > > is encrypted with the guest-specific key, while shared memory may b=
e encrypted
> > > > with hypervisor key. The commands provided by the SEV FW are meant =
to be used
> > > > for the private memory only. The patch series introduces a new hype=
rcall.
> > > > The guest OS can use this hypercall to notify the page encryption s=
tatus.
> > > > If the page is encrypted with guest specific-key then we use SEV co=
mmand during
> > > > the migration. If page is not encrypted then fallback to default.
> > > >
> > > > The patch adds new ioctls KVM_{SET,GET}_PAGE_ENC_BITMAP. The ioctl =
can be used
> > > > by the qemu to get the page encrypted bitmap. Qemu can consult this=
 bitmap
> > > > during the migration to know whether the page is encrypted.
> > > >
> > > > This section descibes how the SEV live migration feature is negotia=
ted
> > > > between the host and guest, the host indicates this feature support=
 via
> > > > KVM_FEATURE_CPUID. The guest firmware (OVMF) detects this feature a=
nd
> > > > sets a UEFI enviroment variable indicating OVMF support for live
> > > > migration, the guest kernel also detects the host support for this
> > > > feature via cpuid and in case of an EFI boot verifies if OVMF also
> > > > supports this feature by getting the UEFI enviroment variable and i=
f it
> > > > set then enables live migration feature on host by writing to a cus=
tom
> > > > MSR, if not booted under EFI, then it simply enables the feature by
> > > > again writing to the custom MSR. The host returns error as part of
> > > > SET_PAGE_ENC_BITMAP ioctl if guest has not enabled live migration.
> > > >
> > > > A branch containing these patches is available here:
> > > > https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2=
Fgithub.com%2FAMDESE%2Flinux%2Ftree%2Fsev-migration-v8&amp;data=3D02%7C01%7=
Cashish.kalra%40amd.com%7Cb7da54c6f7784a548ed208d80666c99b%7C3dd8961fe4884e=
608e11a82d994e183d%7C0%7C0%7C637266386411473155&amp;sdata=3DigztZXTZl1i18e5=
T4DTlNJw07h6z3aBNCAD6%2BE7r9Ik%3D&amp;reserved=3D0
> > > >
> > > > [1] https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%=
2F%2Fdeveloper.amd.com%2Fwp-content%2Fresources%2F55766.PDF&amp;data=3D02%7=
C01%7Cashish.kalra%40amd.com%7Cb7da54c6f7784a548ed208d80666c99b%7C3dd8961fe=
4884e608e11a82d994e183d%7C0%7C0%7C637266386411473155&amp;sdata=3DGBgV6HAd2A=
XZzjK3hp%2F396tDaHlYtN%2FL3Zfny3GaSoU%3D&amp;reserved=3D0
> > > >
> > > > Changes since v7:
> > > > - Removed the hypervisor specific hypercall/paravirt callback for
> > > >   SEV live migration and moved back to calling kvm_sev_hypercall3
> > > >   directly.
> > > > - Fix build errors as
> > > >   Reported-by: kbuild test robot <lkp@intel.com>, specifically fixe=
d
> > > >   build error when CONFIG_HYPERVISOR_GUEST=3Dy and
> > > >   CONFIG_AMD_MEM_ENCRYPT=3Dn.
> > > > - Implicitly enabled live migration for incoming VM(s) to handle
> > > >   A->B->C->... VM migrations.
> > > > - Fixed Documentation as per comments on v6 patches.
> > > > - Fixed error return path in sev_send_update_data() as per comments
> > > >   on v6 patches.
> > > >
> > > > Changes since v6:
> > > > - Rebasing to mainline and refactoring to the new split SVM
> > > >   infrastructre.
> > > > - Move to static allocation of the unified Page Encryption bitmap
> > > >   instead of the dynamic resizing of the bitmap, the static allocat=
ion
> > > >   is done implicitly by extending kvm_arch_commit_memory_region() c=
allack
> > > >   to add svm specific x86_ops which can read the userspace provided=
 memory
> > > >   region/memslots and calculate the amount of guest RAM managed by =
the KVM
> > > >   and grow the bitmap.
> > > > - Fixed KVM_SET_PAGE_ENC_BITMAP ioctl to set the whole bitmap inste=
ad
> > > >   of simply clearing specific bits.
> > > > - Removed KVM_PAGE_ENC_BITMAP_RESET ioctl, which is now performed u=
sing
> > > >   KVM_SET_PAGE_ENC_BITMAP.
> > > > - Extended guest support for enabling Live Migration feature by add=
ing a
> > > >   check for UEFI environment variable indicating OVMF support for L=
ive
> > > >   Migration feature and additionally checking for KVM capability fo=
r the
> > > >   same feature. If not booted under EFI, then we simply check for K=
VM
> > > >   capability.
> > > > - Add hypervisor specific hypercall for SEV live migration by addin=
g
> > > >   a new paravirt callback as part of x86_hyper_runtime.
> > > >   (x86 hypervisor specific runtime callbacks)
> > > > - Moving MSR handling for MSR_KVM_SEV_LIVE_MIG_EN into svm/sev code
> > > >   and adding check for SEV live migration enabled by guest in the
> > > >   KVM_GET_PAGE_ENC_BITMAP ioctl.
> > > > - Instead of the complete __bss_decrypted section, only specific va=
riables
> > > >   such as hv_clock_boot and wall_clock are marked as decrypted in t=
he
> > > >   page encryption bitmap
> > > >
> > > > Changes since v5:
> > > > - Fix build errors as
> > > >   Reported-by: kbuild test robot <lkp@intel.com>
> > > >
> > > > Changes since v4:
> > > > - Host support has been added to extend KVM capabilities/feature bi=
ts to
> > > >   include a new KVM_FEATURE_SEV_LIVE_MIGRATION, which the guest can
> > > >   query for host-side support for SEV live migration and a new cust=
om MSR
> > > >   MSR_KVM_SEV_LIVE_MIG_EN is added for guest to enable the SEV live
> > > >   migration feature.
> > > > - Ensure that _bss_decrypted section is marked as decrypted in the
> > > >   page encryption bitmap.
> > > > - Fixing KVM_GET_PAGE_ENC_BITMAP ioctl to return the correct bitmap
> > > >   as per the number of pages being requested by the user. Ensure th=
at
> > > >   we only copy bmap->num_pages bytes in the userspace buffer, if
> > > >   bmap->num_pages is not byte aligned we read the trailing bits
> > > >   from the userspace and copy those bits as is. This fixes guest
> > > >   page(s) corruption issues observed after migration completion.
> > > > - Add kexec support for SEV Live Migration to reset the host's
> > > >   page encryption bitmap related to kernel specific page encryption
> > > >   status settings before we load a new kernel by kexec. We cannot
> > > >   reset the complete page encryption bitmap here as we need to
> > > >   retain the UEFI/OVMF firmware specific settings.
> > > >
> > > > Changes since v3:
> > > > - Rebasing to mainline and testing.
> > > > - Adding a new KVM_PAGE_ENC_BITMAP_RESET ioctl, which resets the
> > > >   page encryption bitmap on a guest reboot event.
> > > > - Adding a more reliable sanity check for GPA range being passed to
> > > >   the hypercall to ensure that guest MMIO ranges are also marked
> > > >   in the page encryption bitmap.
> > > >
> > > > Changes since v2:
> > > >  - reset the page encryption bitmap on vcpu reboot
> > > >
> > > > Changes since v1:
> > > >  - Add support to share the page encryption between the source and =
target
> > > >    machine.
> > > >  - Fix review feedbacks from Tom Lendacky.
> > > >  - Add check to limit the session blob length.
> > > >  - Update KVM_GET_PAGE_ENC_BITMAP icotl to use the base_gfn instead=
 of
> > > >    the memory slot when querying the bitmap.
> > > >
> > > > Ashish Kalra (7):
> > > >   KVM: SVM: Add support for static allocation of unified Page Encry=
ption
> > > >     Bitmap.
> > > >   KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION feature &
> > > >     Custom MSR.
> > > >   EFI: Introduce the new AMD Memory Encryption GUID.
> > > >   KVM: x86: Add guest support for detecting and enabling SEV Live
> > > >     Migration feature.
> > > >   KVM: x86: Mark _bss_decrypted section variables as decrypted in p=
age
> > > >     encryption bitmap.
> > > >   KVM: x86: Add kexec support for SEV Live Migration.
> > > >   KVM: SVM: Enable SEV live migration feature implicitly on Incomin=
g
> > > >     VM(s).
> > > >
> > > > Brijesh Singh (11):
> > > >   KVM: SVM: Add KVM_SEV SEND_START command
> > > >   KVM: SVM: Add KVM_SEND_UPDATE_DATA command
> > > >   KVM: SVM: Add KVM_SEV_SEND_FINISH command
> > > >   KVM: SVM: Add support for KVM_SEV_RECEIVE_START command
> > > >   KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command
> > > >   KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
> > > >   KVM: x86: Add AMD SEV specific Hypercall3
> > > >   KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
> > > >   KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP ioctl
> > > >   mm: x86: Invoke hypercall when page encryption status is changed
> > > >   KVM: x86: Introduce KVM_SET_PAGE_ENC_BITMAP ioctl
> > > >
> > > >  .../virt/kvm/amd-memory-encryption.rst        | 120 +++
> > > >  Documentation/virt/kvm/api.rst                |  71 ++
> > > >  Documentation/virt/kvm/cpuid.rst              |   5 +
> > > >  Documentation/virt/kvm/hypercalls.rst         |  15 +
> > > >  Documentation/virt/kvm/msr.rst                |  10 +
> > > >  arch/x86/include/asm/kvm_host.h               |   7 +
> > > >  arch/x86/include/asm/kvm_para.h               |  12 +
> > > >  arch/x86/include/asm/mem_encrypt.h            |  11 +
> > > >  arch/x86/include/asm/paravirt.h               |  10 +
> > > >  arch/x86/include/asm/paravirt_types.h         |   2 +
> > > >  arch/x86/include/uapi/asm/kvm_para.h          |   5 +
> > > >  arch/x86/kernel/kvm.c                         |  90 +++
> > > >  arch/x86/kernel/kvmclock.c                    |  12 +
> > > >  arch/x86/kernel/paravirt.c                    |   1 +
> > > >  arch/x86/kvm/svm/sev.c                        | 732 ++++++++++++++=
+++-
> > > >  arch/x86/kvm/svm/svm.c                        |  21 +
> > > >  arch/x86/kvm/svm/svm.h                        |   9 +
> > > >  arch/x86/kvm/vmx/vmx.c                        |   1 +
> > > >  arch/x86/kvm/x86.c                            |  35 +
> > > >  arch/x86/mm/mem_encrypt.c                     |  68 +-
> > > >  arch/x86/mm/pat/set_memory.c                  |   7 +
> > > >  include/linux/efi.h                           |   1 +
> > > >  include/linux/psp-sev.h                       |   8 +-
> > > >  include/uapi/linux/kvm.h                      |  52 ++
> > > >  include/uapi/linux/kvm_para.h                 |   1 +
> > > >  25 files changed, 1297 insertions(+), 9 deletions(-)
> > > >
> > > > --
> > > > 2.17.1
> > > >
> >
> > Hey all,
> > These patches look pretty reasonable at this point. What's the next
> > step for getting them merged?
>
> I believe i have incorporated all your main comments and feedback, for
> example, no more dynamic resizing of the page encryption bitmap and
> static allocation of the same, fixing SET_PAGE_ENC_BITMAP ioctl to set
> the whole bitmap and also merging RESET_PAGE_ENC_BITMAP ioctl into it
> and other stuff like kexec support, etc.
>
> I know you have some additional comments and i am waiting for some more
> feedback and comments from others on the mailing list.
>
> But otherwise i believe these patches are fully ready to be merged at
> this point and i am looking forward to the same.
>
> Thanks,
> Ashish
>
> > Thanks,
> > Steve
