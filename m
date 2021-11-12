Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C27A44EAC0
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 16:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234496AbhKLPqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 10:46:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233551AbhKLPq2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 10:46:28 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC796C0613F5
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 07:43:36 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id 13so19292444ljj.11
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 07:43:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uYii4K2YH5djqKGK5adbE/sm1hAFMBBprNlHTABn6Pc=;
        b=kxZefhQBnG4H+BwZC4L49iVMEcmf6eJrzmxWibpvGcSN4o5NtFs3BQPJriFbSSj8ii
         wvEVDpveRYYpnSzVeQXZfF+j2kZjbPNP9NbufMcSwkXNUACfAXkQAZVMlCqdBAUs0BSx
         6uoSh4JQJYW0O3maihI6SuWIoS6c4sVUfhVIm/rJfibfwAI9XHDgj01qbqnrqibafTJS
         5V4yq9ejuBO9ri8GUfCidaRUm3Ldgnn1zbU7Qc7pBebsldfq3Uv0b8oF8ZXfhddmXVgZ
         3DXhMqnabAVj+rrEzXAjCYk6XuPoXIQ02dIeH9e+Kcq/K1s0+Wm6BUDLeyYSvJprMcM9
         9QZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uYii4K2YH5djqKGK5adbE/sm1hAFMBBprNlHTABn6Pc=;
        b=3pbJIlUqs8FPYp+jUouItdGm82RR1IIR7TMV4AqGcxZmErzz+TgCov16AwalzNmTWL
         YUoAcDteJTtm5z8DUeuzODc7qGPZC7rUXxQhd09pJQpfNfEf75JGiewUrsG4WzrQgejD
         AYrMUnAOtReGVxQWZP2J5vI89aR9TiAbfIONFNZAXMbjQybo0c0foD7KYA9BIvZeYHbL
         hdsG5S9fzDfGhqHdOlmIDsh3+zsRpST+3kixOokFOSTjT+cd5Iw51yO6ZfNVB6ZIke6D
         J5PEZaqnIgBF20X5To9FTxGJGvv21aUyKeuSKJmOsuLmsB2tHN4K1UN7jMsQaNq35NWE
         ESxg==
X-Gm-Message-State: AOAM533MOOr6ku49ineGRAeDZSrUpLGljOJicifw0SEHw5GJb5OPTFEa
        LKhTbyitvfcA13XpwQWJCUjUUqj9kVZeYSeON98y2w==
X-Google-Smtp-Source: ABdhPJxsvwZkYAJ6dywXETP7lROD6GLBQbOTmgFW7y2bkRBmKHtRAZ3FciqmYeg9vuoxvJ+QEskhXo8WHfwozFtam8s=
X-Received: by 2002:a05:651c:1035:: with SMTP id w21mr15474627ljm.278.1636731814652;
 Fri, 12 Nov 2021 07:43:34 -0800 (PST)
MIME-Version: 1.0
References: <20210820155918.7518-1-brijesh.singh@amd.com>
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 12 Nov 2021 08:43:22 -0700
Message-ID: <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Brijesh,,

One high level discussion I'd like to have on these SNP KVM patches.

In these patches (V5) if a host userspace process writes a guest
private page a SIGBUS is issued to that process. If the kernel writes
a guest private page then the kernel panics due to the unhandled RMP
fault page fault. This is an issue because not all writes into guest
memory may come from a bug in the host. For instance a malicious or
even buggy guest could easily point the host to writing a private page
during the emulation of many virtual devices (virtio, NVMe, etc). For
example if a well behaved guests behavior is to: start up a driver,
select some pages to share with the guest, ask the host to convert
them to shared, then use those pages for virtual device DMA, if a
buggy guest forget the step to request the pages be converted to
shared its easy to see how the host could rightfully write to private
memory. I think we can better guarantee host reliability when running
SNP guests without changing SNP=E2=80=99s security properties.

Here is an alternative to the current approach: On RMP violation (host
or userspace) the page fault handler converts the page from private to
shared to allow the write to continue. This pulls from s390=E2=80=99s error
handling which does exactly this. See =E2=80=98arch_make_page_accessible()=
=E2=80=99.
Additionally it adds less complexity to the SNP kernel patches, and
requires no new ABI.

In the current (V5) KVM implementation if a userspace process
generates an RMP violation (writes to guest private memory) the
process receives a SIGBUS. At first glance, it would appear that
user-space shouldn=E2=80=99t write to private memory. However, guaranteeing
this in a generic fashion requires locking the RMP entries (via locks
external to the RMP). Otherwise, a user-space process emulating a
guest device IO may be vulnerable to having the guest memory
(maliciously or by guest bug) converted to private while user-space
emulation is happening. This results in a well behaved userspace
process receiving a SIGBUS.

This proposal allows buggy and malicious guests to run under SNP
without jeopardizing the reliability / safety of host processes. This
is very important to a cloud service provider (CSP) since it=E2=80=99s comm=
on
to have host wide daemons that write/read all guests, i.e. a single
process could manage the networking for all VMs on the host. Crashing
that singleton process kills networking for all VMs on the system.

This proposal also allows for minimal changes to the kexec flow and
kdump. The new kexec kernel can simply update private pages to shared
as it encounters them during their boot. This avoids needing to
propagate the RMP state from kernel to kernel. Of course this doesn=E2=80=
=99t
preserve any running VMs but is still useful for kdump crash dumps or
quicker rekerneling for development with kexec.

This proposal does cause guest memory corruption for some bugs but one
of SEV-SNP=E2=80=99s goals extended from SEV-ES=E2=80=99s goals is for gues=
t=E2=80=99s to be
able to detect when its memory has been corrupted / replayed by the
host. So SNP already has features for allowing guests to detect this
kind of memory corruption. Additionally this is very similar to a page
of memory generating a machine check because of 2-bit memory
corruption. In other words SNP guests must be enlightened and ready
for these kinds of errors.

For an SNP guest running under this proposal the flow would look like this:
* Host gets a #PF because its trying to write to a private page.
* Host #PF handler updates the page to shared.
* Write continues normally.
* Guest accesses memory (r/w).
* Guest gets a #VC error because the page is not PVALIDATED
* Guest is now in control. Guest can terminate because its memory has
been corrupted. Guest could try and continue to log the error to its
owner.

A similar approach was introduced in the SNP patches V1 and V2 for
kernel page fault handling. The pushback around this convert to shared
approach was largely focused around the idea that the kernel has all
the information about which pages are shared vs private so it should
be able to check shared status before write to pages. After V2 the
patches were updated to not have a kernel page fault handler for RMP
violations (other than dumping state during a panic). The current
patches protect the host with new post_{map,unmap}_gfn() function that
checks if a page is shared before mapping it, then locks the page
shared until unmapped. Given the discussions on =E2=80=98[Part2,v5,39/45] K=
VM:
SVM: Introduce ops for the post gfn map and unmap=E2=80=99 building a solut=
ion
to do this is non trivial and adds new overheads to KVM. Additionally
the current solution is local to the kernel. So a new ABI just now be
created to allow the userspace VMM to access the kernel-side locks for
this to work generically for the whole host. This is more complicated
than this proposal and adding more lock holders seems like it could
reduce performance further.

There are a couple corner cases with this approach. Under SNP guests
can request their memory be changed into a VMSA. This VMSA page cannot
be changed to shared while the vCPU associated with it is running. So
KVM + the #PF handler will need something to kick vCPUs from running.
Joerg believes that a possible fix for this could be a new MMU
notifier in the kernel, then on the #PF we can go through the rmp and
execute this vCPU kick callback.

Another corner case is the RMPUPDATE instruction is not guaranteed to
succeed on first iteration. As noted above if the page is a VMSA it
cannot be updated while the vCPU is running. Another issue is if the
guest is running a RMPADJUST on a page it cannot be RMPUPDATED at that
time. There is a lock for each RMP Entry so there is a race for these
instructions. The vCPU kicking can solve this issue to be kicking all
guest vCPUs which removes the chance for the race.

Since this proposal probably results in SNP guests terminating due to
a page unexpectedly needing PVALIDATE. The approach could be
simplified to just the KVM killing the guest. I think it's nicer to
users to instead of unilaterally killing the guest allowing the
unvalidated #VC exception to allow users to collect some additional
debug information and any additional clean up work they would like to
perform.

Thanks
Peter

On Fri, Aug 20, 2021 at 9:59 AM Brijesh Singh <brijesh.singh@amd.com> wrote=
:
>
> This part of the Secure Encrypted Paging (SEV-SNP) series focuses on the
> changes required in a host OS for SEV-SNP support. The series builds upon
> SEV-SNP Part-1.
>
> This series provides the basic building blocks to support booting the SEV=
-SNP
> VMs, it does not cover all the security enhancement introduced by the SEV=
-SNP
> such as interrupt protection.
>
> The CCP driver is enhanced to provide new APIs that use the SEV-SNP
> specific commands defined in the SEV-SNP firmware specification. The KVM
> driver uses those APIs to create and managed the SEV-SNP guests.
>
> The GHCB specification version 2 introduces new set of NAE's that is
> used by the SEV-SNP guest to communicate with the hypervisor. The series
> provides support to handle the following new NAE events:
> - Register GHCB GPA
> - Page State Change Request
> - Hypevisor feature
> - Guest message request
>
> The RMP check is enforced as soon as SEV-SNP is enabled. Not every memory
> access requires an RMP check. In particular, the read accesses from the
> hypervisor do not require RMP checks because the data confidentiality is
> already protected via memory encryption. When hardware encounters an RMP
> checks failure, it raises a page-fault exception. If RMP check failure
> is due to the page-size mismatch, then split the large page to resolve
> the fault.
>
> The series does not provide support for the interrupt security and migrat=
ion
> and those feature will be added after the base support.
>
> The series is based on the commit:
>  SNP part1 commit and
>  fa7a549d321a (kvm/next, next) KVM: x86: accept userspace interrupt only =
if no event is injected
>
> TODO:
>   * Add support for command to ratelimit the guest message request.
>
> Changes since v4:
>  * Move the RMP entry definition to x86 specific header file.
>  * Move the dump RMP entry function to SEV specific file.
>  * Use BIT_ULL while defining the #PF bit fields.
>  * Add helper function to check the IOMMU support for SEV-SNP feature.
>  * Add helper functions for the page state transition.
>  * Map and unmap the pages from the direct map after page is added or
>    removed in RMP table.
>  * Enforce the minimum SEV-SNP firmware version.
>  * Extend the LAUNCH_UPDATE to accept the base_gfn and remove the
>    logic to calculate the gfn from the hva.
>  * Add a check in LAUNCH_UPDATE to ensure that all the pages are
>    shared before calling the PSP.
>  * Mark the memory failure when failing to remove the page from the
>    RMP table or clearing the immutable bit.
>  * Exclude the encrypted hva range from the KSM.
>  * Remove the gfn tracking during the kvm_gfn_map() and use SRCU to
>    syncronize the PSC and gfn mapping.
>  * Allow PSC on the registered hva range only.
>  * Add support for the Preferred GPA VMGEXIT.
>  * Simplify the PSC handling routines.
>  * Use the static_call() for the newly added kvm_x86_ops.
>  * Remove the long-lived GHCB map.
>  * Move the snp enable module parameter to the end of the file.
>  * Remove the kvm_x86_op for the RMP fault handling. Call the
>    fault handler directly from the #NPF interception.
>
> Changes since v3:
>  * Add support for extended guest message request.
>  * Add ioctl to query the SNP Platform status.
>  * Add ioctl to get and set the SNP config.
>  * Add check to verify that memory reserved for the RMP covers the full s=
ystem RAM.
>  * Start the SNP specific commands from 256 instead of 255.
>  * Multiple cleanup and fixes based on the review feedback.
>
> Changes since v2:
>  * Add AP creation support.
>  * Drop the patch to handle the RMP fault for the kernel address.
>  * Add functions to track the write access from the hypervisor.
>  * Do not enable the SNP feature when IOMMU is disabled or is in passthro=
ugh mode.
>  * Dump the RMP entry on RMP violation for the debug.
>  * Shorten the GHCB macro names.
>  * Start the SNP_INIT command id from 255 to give some gap for the legacy=
 SEV.
>  * Sync the header with the latest 0.9 SNP spec.
>
> Changes since v1:
>  * Add AP reset MSR protocol VMGEXIT NAE.
>  * Add Hypervisor features VMGEXIT NAE.
>  * Move the RMP table initialization and RMPUPDATE/PSMASH helper in
>    arch/x86/kernel/sev.c.
>  * Add support to map/unmap SEV legacy command buffer to firmware state w=
hen
>    SNP is active.
>  * Enhance PSP driver to provide helper to allocate/free memory used for =
the
>    firmware context page.
>  * Add support to handle RMP fault for the kernel address.
>  * Add support to handle GUEST_REQUEST NAE event for attestation.
>  * Rename RMP table lookup helper.
>  * Drop typedef from rmpentry struct definition.
>  * Drop SNP static key and use cpu_feature_enabled() to check whether SEV=
-SNP
>    is active.
>  * Multiple cleanup/fixes to address Boris review feedback.
>
> Brijesh Singh (40):
>   x86/cpufeatures: Add SEV-SNP CPU feature
>   iommu/amd: Introduce function to check SEV-SNP support
>   x86/sev: Add the host SEV-SNP initialization support
>   x86/sev: Add RMP entry lookup helpers
>   x86/sev: Add helper functions for RMPUPDATE and PSMASH instruction
>   x86/sev: Invalid pages from direct map when adding it to RMP table
>   x86/traps: Define RMP violation #PF error code
>   x86/fault: Add support to handle the RMP fault for user address
>   x86/fault: Add support to dump RMP entry on fault
>   crypto: ccp: shutdown SEV firmware on kexec
>   crypto:ccp: Define the SEV-SNP commands
>   crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP
>   crypto:ccp: Provide APIs to issue SEV-SNP commands
>   crypto: ccp: Handle the legacy TMR allocation when SNP is enabled
>   crypto: ccp: Handle the legacy SEV command when SNP is enabled
>   crypto: ccp: Add the SNP_PLATFORM_STATUS command
>   crypto: ccp: Add the SNP_{SET,GET}_EXT_CONFIG command
>   crypto: ccp: Provide APIs to query extended attestation report
>   KVM: SVM: Provide the Hypervisor Feature support VMGEXIT
>   KVM: SVM: Make AVIC backing, VMSA and VMCB memory allocation SNP safe
>   KVM: SVM: Add initial SEV-SNP support
>   KVM: SVM: Add KVM_SNP_INIT command
>   KVM: SVM: Add KVM_SEV_SNP_LAUNCH_START command
>   KVM: SVM: Add KVM_SEV_SNP_LAUNCH_UPDATE command
>   KVM: SVM: Mark the private vma unmerable for SEV-SNP guests
>   KVM: SVM: Add KVM_SEV_SNP_LAUNCH_FINISH command
>   KVM: X86: Keep the NPT and RMP page level in sync
>   KVM: x86: Introduce kvm_mmu_get_tdp_walk() for SEV-SNP use
>   KVM: x86: Define RMP page fault error bits for #NPF
>   KVM: x86: Update page-fault trace to log full 64-bit error code
>   KVM: SVM: Do not use long-lived GHCB map while setting scratch area
>   KVM: SVM: Remove the long-lived GHCB host map
>   KVM: SVM: Add support to handle GHCB GPA register VMGEXIT
>   KVM: SVM: Add support to handle MSR based Page State Change VMGEXIT
>   KVM: SVM: Add support to handle Page State Change VMGEXIT
>   KVM: SVM: Introduce ops for the post gfn map and unmap
>   KVM: x86: Export the kvm_zap_gfn_range() for the SNP use
>   KVM: SVM: Add support to handle the RMP nested page fault
>   KVM: SVM: Provide support for SNP_GUEST_REQUEST NAE event
>   KVM: SVM: Add module parameter to enable the SEV-SNP
>
> Sean Christopherson (2):
>   KVM: x86/mmu: Move 'pfn' variable to caller of direct_page_fault()
>   KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by TDX and SNP
>
> Tom Lendacky (3):
>   KVM: SVM: Add support to handle AP reset MSR protocol
>   KVM: SVM: Use a VMSA physical address variable for populating VMCB
>   KVM: SVM: Support SEV-SNP AP Creation NAE event
>
>  Documentation/virt/coco/sevguest.rst          |   55 +
>  .../virt/kvm/amd-memory-encryption.rst        |  102 +
>  arch/x86/include/asm/cpufeatures.h            |    1 +
>  arch/x86/include/asm/disabled-features.h      |    8 +-
>  arch/x86/include/asm/kvm-x86-ops.h            |    5 +
>  arch/x86/include/asm/kvm_host.h               |   20 +
>  arch/x86/include/asm/msr-index.h              |    6 +
>  arch/x86/include/asm/sev-common.h             |   28 +
>  arch/x86/include/asm/sev.h                    |   45 +
>  arch/x86/include/asm/svm.h                    |    7 +
>  arch/x86/include/asm/trap_pf.h                |   18 +-
>  arch/x86/kernel/cpu/amd.c                     |    3 +-
>  arch/x86/kernel/sev.c                         |  361 ++++
>  arch/x86/kvm/lapic.c                          |    5 +-
>  arch/x86/kvm/mmu.h                            |    7 +-
>  arch/x86/kvm/mmu/mmu.c                        |   84 +-
>  arch/x86/kvm/svm/sev.c                        | 1676 ++++++++++++++++-
>  arch/x86/kvm/svm/svm.c                        |   62 +-
>  arch/x86/kvm/svm/svm.h                        |   74 +-
>  arch/x86/kvm/trace.h                          |   40 +-
>  arch/x86/kvm/x86.c                            |   92 +-
>  arch/x86/mm/fault.c                           |   84 +-
>  drivers/crypto/ccp/sev-dev.c                  |  924 ++++++++-
>  drivers/crypto/ccp/sev-dev.h                  |   17 +
>  drivers/crypto/ccp/sp-pci.c                   |   12 +
>  drivers/iommu/amd/init.c                      |   30 +
>  include/linux/iommu.h                         |    9 +
>  include/linux/mm.h                            |    6 +-
>  include/linux/psp-sev.h                       |  346 ++++
>  include/linux/sev.h                           |   32 +
>  include/uapi/linux/kvm.h                      |   56 +
>  include/uapi/linux/psp-sev.h                  |   60 +
>  mm/memory.c                                   |   13 +
>  tools/arch/x86/include/asm/cpufeatures.h      |    1 +
>  34 files changed, 4088 insertions(+), 201 deletions(-)
>  create mode 100644 include/linux/sev.h
>
> --
> 2.17.1
>
