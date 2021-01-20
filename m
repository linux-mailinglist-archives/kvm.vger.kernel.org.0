Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81FBB2FC626
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 01:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731016AbhATAxP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 19:53:15 -0500
Received: from mga11.intel.com ([192.55.52.93]:34296 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730094AbhATAxJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 19:53:09 -0500
IronPort-SDR: ac8YxxlBhvzpqNwapI1ifzY0qpo51PAfspuc/mK7qN79OT0Nf/9gi69ZD8qOopFEcBo3c9PKqM
 5jNEyBU9NNDw==
X-IronPort-AV: E=McAfee;i="6000,8403,9869"; a="175518409"
X-IronPort-AV: E=Sophos;i="5.79,359,1602572400"; 
   d="scan'208";a="175518409"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2021 16:52:40 -0800
IronPort-SDR: UvIn2VYeTqbjYQOmeZzRHjZQwZbHBF1mJsB5CKAhzYg7yoqDPFJZ05Yjfoem4Gq+oPachTBNlX
 zNt5wC3eVPfw==
X-IronPort-AV: E=Sophos;i="5.79,359,1602572400"; 
   d="scan'208";a="384154193"
Received: from hzhan36-mobl.amr.corp.intel.com ([10.251.22.237])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2021 16:52:35 -0800
Message-ID: <0adf45fae5207ed3d788bbb7260425f8da7aff43.camel@intel.com>
Subject: Re: [RFC PATCH v2 00/26] KVM SGX virtualization support
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de, jmattson@google.com,
        joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com,
        corbet@lwn.net
Date:   Wed, 20 Jan 2021 13:52:32 +1300
In-Reply-To: <YAaW5FIkRrLGncT5@kernel.org>
References: <cover.1610935432.git.kai.huang@intel.com>
         <YAaW5FIkRrLGncT5@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-01-19 at 10:23 +0200, Jarkko Sakkinen wrote:
> Can you send a new version that applies:
> 
> $ git pw series apply 416463
> Applying: x86/cpufeatures: Add SGX1 and SGX2 sub-features
> Applying: x86/sgx: Remove a warn from sgx_free_epc_page()
> Applying: x86/sgx: Wipe out EREMOVE from sgx_free_epc_page()
> Applying: x86/sgx: Add SGX_CHILD_PRESENT hardware error code
> Applying: x86/sgx: Introduce virtual EPC for use by KVM guests
> Applying: x86/cpu/intel: Allow SGX virtualization without Launch Control support
> Applying: x86/sgx: Initialize virtual EPC driver even when SGX driver is disabled
> error: sha1 information is lacking or useless (arch/x86/kernel/cpu/sgx/main.c).
> error: could not build fake ancestor
> hint: Use 'git am --show-current-patch=diff' to see the failed patch
> Patch failed at 0007 x86/sgx: Initialize virtual EPC driver even when SGX driver is disabled
> When you have resolved this problem, run "git am --continue".
> If you prefer to skip this patch, run "git am --skip" instead.
> To restore the original branch and stop patching, run "git am --abort".

Could you let me know which branch should I rebase to? It appears your linux-sgx tree
next branch?

And I don't think it is good to resend for this series at this moment, due to: 1)
people have already started to comment; 2) The two patches from you don't have your
name on your SoB, so has to fix anyway. It would be more appropriate to rebase to
your tree in next version, if required. And I can prepare a separate branch for you
(after resolving the merge conflict with sgx_init() in your tree) at the same time.

And Boris, Paolo, Sean, Jarkko, and other maintainers,

I'd like to take this chance to ask: when this series is ready to be merged, what is
the properly way to merge? This series has x86 non-sgx (cpufeature, feat_ctl) and sgx
changes, and it obviously has KVM changes too. So instance, who should be the one to
take this series? And which tree and branch should I rebase to in next version?

Thanks for all your feedback.

> 
> Thanks.
> 
> /Jarkko
> 
> On Mon, Jan 18, 2021 at 04:26:21PM +1300, Kai Huang wrote:
> > --- Disclaimer ---
> > 
> > These patches were originally written by Sean Christopherson while at Intel.
> > Now that Sean has left Intel, I (Kai) have taken over getting them upstream.
> > This series needs more review before it can be merged.  It is being posted
> > publicly and under RFC so Sean and others can review it. Maintainers are safe
> > ignoring it for now.
> > 
> > ------------------
> > 
> > Hi all,
> > 
> > This series adds KVM SGX virtualization support. The first 14 patches starting
> > with x86/sgx or x86/cpu.. are necessary changes to x86 and SGX core/driver to
> > support KVM SGX virtualization, while the rest are patches to KVM subsystem.
> > 
> > Please help to review this series. Also I'd like to hear what is the proper
> > way to merge this series, since it contains change to both x86/SGX and KVM
> > subsystem. Any feedback is highly appreciated. And please let me know if I
> > forgot to CC anyone, or anyone wants to be removed from CC. Thanks in advance!
> > 
> > This series is based against upstream v5.11-rc3. You can also get the code from
> > upstream branch of kvm-sgx repo on github:
> > 
> >         https://github.com/intel/kvm-sgx.git upstream
> > 
> > It also requires Qemu changes to create VM with SGX support. You can find Qemu
> > repo here:
> > 
> > 	https://github.com/intel/qemu-sgx.git next
> > 
> > Please refer to README.md of above qemu-sgx repo for detail on how to create
> > guest with SGX support. At meantime, for your quick reference you can use below
> > command to create SGX guest:
> > 
> > 	#qemu-system-x86_64 -smp 4 -m 2G -drive file=<your_vm_image>,if=virtio \
> > 		-cpu host,+sgx_provisionkey \
> > 		-sgx-epc id=epc1,memdev=mem1 \
> > 		-object memory-backend-epc,id=mem1,size=64M,prealloc
> > 
> > Please note that the SGX relevant part is:
> > 
> > 		-cpu host,+sgx_provisionkey \
> > 		-sgx-epc id=epc1,memdev=mem1 \
> > 		-object memory-backend-epc,id=mem1,size=64M,prealloc
> > 
> > And you can change other parameters of your qemu command based on your needs.
> > 
> > =========
> > Changelog:
> > 
> > (Changelog here is for global changes. Please see each patch's changelog for
> >  changes made to specific patch.)
> > 
> > v1->v2:
> > 
> >  - Refined this cover letter by addressing comments from Dave and Jarkko.
> >  - The original patch which introduced new X86_FEATURE_SGX1/SGX2 were replaced
> >    by 3 new patches from Sean, following Boris and Sean's discussion.
> >        [RFC PATCH v2 01/26] x86/cpufeatures: Add SGX1 and SGX2 sub-features
> >        [RFC PATCH v2 18/26] KVM: x86: Add support for reverse CPUID lookup of scattered features
> >        [RFC PATCH v2 19/26] KVM: x86: Add reverse-CPUID lookup support for scattered SGX features
> >  - The original patch 1
> >        x86/sgx: Split out adding EPC page to free list to separate helper
> >    was replaced with 2 new patches from Jarkko
> >        [RFC PATCH v2 02/26] x86/sgx: Remove a warn from sgx_free_epc_page()
> >        [RFC PATCH v2 03/26] x86/sgx: Wipe out EREMOVE from sgx_free_epc_page()
> >    addressing Jarkko's comments.
> >  - Moved modifying sgx_init() to always initialize sgx_virt_epc_init() out of
> >    patch
> >        x86/sgx: Introduce virtual EPC for use by KVM guests
> >    to a separate patch:
> >        [RFC PATCH v2 07/26] x86/sgx: Initialize virtual EPC driver even when SGX driver is disabled
> >    to address Dave's comment that patch ordering can be improved due to before
> >    patch "Allow SGX virtualization without Launch Control support", all SGX,
> >    including SGX virtualization, is actually disabled when SGX LC is not
> >    present.
> > 
> > KVM part patches are not changed comparing to v1 (except changes due to
> > X86_FEATURE_SGX1/2 patches). For changes to each x86 patch, please see changelog
> > in each indudival patch. If no changelog, then no change was made to it.
> > 
> > =========
> > KVM SGX virtualization Overview
> > 
> > - Virtual EPC
> > 
> > SGX enclave memory is special and is reserved specifically for enclave use.
> > In bare-metal SGX enclaves, the kernel allocates enclave pages, copies data
> > into the pages with privileged instructions, then allows the enclave to start.
> > In this scenario, only initialized pages already assigned to an enclave are
> > mapped to userspace.
> > 
> > In virtualized environments, the hypervisor still needs to do the physical
> > enclave page allocation.  The guest kernel is responsible for the data copying
> > (among other things).  This means that the job of starting an enclave is now
> > split between hypervisor and guest.
> > 
> > This series introduces a new misc device: /dev/sgx_virt_epc.  This device
> > allows the host to map *uninitialized* enclave memory into userspace, which
> > can then be passed into a guest.
> > 
> > While it might be *possible* to start a host-side enclave with /dev/sgx_enclave
> > and pass its memory into a guest, it would be wasteful and convoluted.
> > 
> > Implement the *raw* EPC allocation in the x86 core-SGX subsystem via
> > /dev/sgx_virt_epc rather than in KVM.  Doing so has two major advantages:
> > 
> >   - Does not require changes to KVM's uAPI, e.g. EPC gets handled as
> >     just another memory backend for guests.
> > 
> >   - EPC management is wholly contained in the SGX subsystem, e.g. SGX
> >     does not have to export any symbols, changes to reclaim flows don't
> >     need to be routed through KVM, SGX's dirty laundry doesn't have to
> >     get aired out for the world to see, and so on and so forth.
> > 
> > The virtual EPC pages allocated to guests are currently not reclaimable.
> > Reclaiming EPC page used by enclave requires a special reclaim mechanism
> > separate from normal page reclaim, and that mechanism is not supported
> > for virutal EPC pages.  Due to the complications of handling reclaim
> > conflicts between guest and host, reclaiming virtual EPC pages is 
> > significantly more complex than basic support for SGX virtualization.
> > 
> > - Support SGX virtualization without SGX Flexible Launch Control
> > 
> > SGX hardware supports two "launch control" modes to limit which enclaves can
> > run.  In the "locked" mode, the hardware prevents enclaves from running unless
> > they are blessed by a third party.  In the unlocked mode, the kernel is in
> > full control of which enclaves can run.  The bare-metal SGX code refuses to
> > launch enclaves unless it is in the unlocked mode.
> > 
> > This sgx_virt_epc driver does not have such a restriction.  This allows guests
> > which are OK with the locked mode to use SGX, even if the host kernel refuses
> > to.
> > 
> > - Support exposing SGX2
> > 
> > Due to the same reason above, SGX2 feature detection is added to core SGX code
> > to allow KVM to expose SGX2 to guest, even currently SGX driver doesn't support
> > SGX2, because SGX2 can work just fine in guest w/o any interaction to host SGX
> > driver.
> > 
> > - Restricit SGX guest access to provisioning key
> > 
> > To grant guest being able to fully use SGX, guest needs to be able to access
> > provisioning key.  The provisioning key is sensitive, and accessing to it should
> > be restricted. In bare-metal driver, allowing enclave to access provisioning key
> > is restricted by being able to open /dev/sgx_provision.
> > 
> > Add a new KVM_CAP_SGX_ATTRIBUTE to KVM uAPI to extend above mechanism to KVM
> > guests as well.  When userspace hypervisor creates a new VM, the new cap is only
> > added to VM when userspace hypervisior is able to open /dev/sgx_provision,
> > following the same role as in bare-metal driver.  KVM then traps ECREATE from
> > guest, and only allows ECREATE with provisioning key bit to run when guest
> > supports KVM_CAP_SGX_ATTRIBUTE.
> > 
> > 
> > 
> > Kai Huang (2):
> >   x86/sgx: Initialize virtual EPC driver even when SGX driver is
> >     disabled
> >   x86/sgx: Add helper to update SGX_LEPUBKEYHASHn MSRs
> > 
> > Sean Christopherson (22):
> >   x86/cpufeatures: Add SGX1 and SGX2 sub-features
> >   x86/sgx: Add SGX_CHILD_PRESENT hardware error code
> >   x86/sgx: Introduce virtual EPC for use by KVM guests
> >   x86/cpu/intel: Allow SGX virtualization without Launch Control support
> >   x86/sgx: Expose SGX architectural definitions to the kernel
> >   x86/sgx: Move ENCLS leaf definitions to sgx_arch.h
> >   x86/sgx: Add SGX2 ENCLS leaf definitions (EAUG, EMODPR and EMODT)
> >   x86/sgx: Add encls_faulted() helper
> >   x86/sgx: Add helpers to expose ECREATE and EINIT to KVM
> >   x86/sgx: Move provisioning device creation out of SGX driver
> >   KVM: VMX: Convert vcpu_vmx.exit_reason to a union
> >   KVM: x86: Export kvm_mmu_gva_to_gpa_{read,write}() for SGX (VMX)
> >   KVM: x86: Define new #PF SGX error code bit
> >   KVM: x86: Add support for reverse CPUID lookup of scattered features
> >   KVM: x86: Add reverse-CPUID lookup support for scattered SGX features
> >   KVM: VMX: Add basic handling of VM-Exit from SGX enclave
> >   KVM: VMX: Frame in ENCLS handler for SGX virtualization
> >   KVM: VMX: Add SGX ENCLS[ECREATE] handler to enforce CPUID restrictions
> >   KVM: VMX: Add emulation of SGX Launch Control LE hash MSRs
> >   KVM: VMX: Add ENCLS[EINIT] handler to support SGX Launch Control (LC)
> >   KVM: VMX: Enable SGX virtualization for SGX1, SGX2 and LC
> >   KVM: x86: Add capability to grant VM access to privileged SGX
> >     attribute
> > 
> > jarkko@kernel.org (2):
> >   x86/sgx: Remove a warn from sgx_free_epc_page()
> >   x86/sgx: Wipe out EREMOVE from sgx_free_epc_page()
> > 
> >  Documentation/virt/kvm/api.rst                |  23 +
> >  arch/x86/Kconfig                              |  12 +
> >  arch/x86/include/asm/cpufeatures.h            |   2 +
> >  arch/x86/include/asm/kvm_host.h               |   5 +
> >  arch/x86/include/asm/sgx.h                    |  19 +
> >  .../cpu/sgx/arch.h => include/asm/sgx_arch.h} |  20 +
> >  arch/x86/include/asm/vmx.h                    |   1 +
> >  arch/x86/include/uapi/asm/vmx.h               |   1 +
> >  arch/x86/kernel/cpu/cpuid-deps.c              |   3 +
> >  arch/x86/kernel/cpu/feat_ctl.c                |  63 ++-
> >  arch/x86/kernel/cpu/scattered.c               |   2 +
> >  arch/x86/kernel/cpu/sgx/Makefile              |   1 +
> >  arch/x86/kernel/cpu/sgx/driver.c              |  17 -
> >  arch/x86/kernel/cpu/sgx/encl.c                |  15 +-
> >  arch/x86/kernel/cpu/sgx/encls.h               |  29 +-
> >  arch/x86/kernel/cpu/sgx/ioctl.c               |  23 +-
> >  arch/x86/kernel/cpu/sgx/main.c                |  67 ++-
> >  arch/x86/kernel/cpu/sgx/sgx.h                 |   4 +-
> >  arch/x86/kernel/cpu/sgx/virt.c                | 316 ++++++++++++
> >  arch/x86/kernel/cpu/sgx/virt.h                |  14 +
> >  arch/x86/kvm/Makefile                         |   2 +
> >  arch/x86/kvm/cpuid.c                          |  89 +++-
> >  arch/x86/kvm/cpuid.h                          |  50 +-
> >  arch/x86/kvm/vmx/nested.c                     |  70 ++-
> >  arch/x86/kvm/vmx/nested.h                     |   5 +
> >  arch/x86/kvm/vmx/sgx.c                        | 462 ++++++++++++++++++
> >  arch/x86/kvm/vmx/sgx.h                        |  34 ++
> >  arch/x86/kvm/vmx/vmcs12.c                     |   1 +
> >  arch/x86/kvm/vmx/vmcs12.h                     |   4 +-
> >  arch/x86/kvm/vmx/vmx.c                        | 171 +++++--
> >  arch/x86/kvm/vmx/vmx.h                        |  27 +-
> >  arch/x86/kvm/x86.c                            |  24 +
> >  include/uapi/linux/kvm.h                      |   1 +
> >  tools/testing/selftests/sgx/defines.h         |   2 +-
> >  34 files changed, 1432 insertions(+), 147 deletions(-)
> >  create mode 100644 arch/x86/include/asm/sgx.h
> >  rename arch/x86/{kernel/cpu/sgx/arch.h => include/asm/sgx_arch.h} (96%)
> >  create mode 100644 arch/x86/kernel/cpu/sgx/virt.c
> >  create mode 100644 arch/x86/kernel/cpu/sgx/virt.h
> >  create mode 100644 arch/x86/kvm/vmx/sgx.c
> >  create mode 100644 arch/x86/kvm/vmx/sgx.h
> > 
> > -- 
> > 2.29.2
> > 
> > 


