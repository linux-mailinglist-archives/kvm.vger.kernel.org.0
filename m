Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D33C86382D5
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 04:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiKYDtP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 22:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiKYDtO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 22:49:14 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F3226117;
        Thu, 24 Nov 2022 19:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669348152; x=1700884152;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DdI3J9u1+jNNNPApRaJ0V804yVB3jNrYwnK5UnOngyM=;
  b=OBT/0FNZ9yA7ds3xNl2nOGliuMxyd50F7S9QmwFoqNvr/UtP6opHdDlQ
   atvHtLExPTQw4uc1ui2rZWYShT8OY3x7/RBklpji5yyaesXKeQUsccy8/
   W0ErraZuzzvljK+TRMtOXSx7/ehJJJqwBSYRDIHh7umXCH9M9GPwe3zWb
   v2YPu3PU3swU6s1lvMFEhvaoYdGSDSZMVFg9XjwzD1uRoXL73QBiVQBKY
   rpkhAyX+HebA+BAcEXW8F1okhGPyQaLpVQ0k1L1NG6xlV3wp1UJGxpoyX
   fMY/PLtoYsRBvXXTCIbfA4tl/I6bHRp5Hyedb1kEc8ETGI7EixOiA7D9S
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="312039848"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="312039848"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 19:49:12 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="748442292"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="748442292"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.3.41]) ([10.238.3.41])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 19:49:10 -0800
Message-ID: <faf65da9-aeb4-d7b2-0e60-995848e47d14@linux.intel.com>
Date:   Fri, 25 Nov 2022 11:49:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v10 106/108] Documentation/virt/kvm: Document on Trust
 Domain Extensions(TDX)
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <fcf376f0f7703d06b6e7466e95cea624b58f746a.1667110240.git.isaku.yamahata@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <fcf376f0f7703d06b6e7466e95cea624b58f746a.1667110240.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/30/2022 2:23 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Add documentation to Intel Trusted Domain Extensions(TDX) support.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   Documentation/virt/kvm/api.rst       |   9 +-
>   Documentation/virt/kvm/index.rst     |   2 +
>   Documentation/virt/kvm/intel-tdx.rst | 345 +++++++++++++++++++++++++++
>   3 files changed, 355 insertions(+), 1 deletion(-)
>   create mode 100644 Documentation/virt/kvm/intel-tdx.rst
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index b6f08e8a8320..3d819b2ceb78 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1426,6 +1426,9 @@ It is recommended to use this API instead of the KVM_SET_MEMORY_REGION ioctl.
>   The KVM_SET_MEMORY_REGION does not allow fine grained control over memory
>   allocation and is deprecated.
>   
> +For TDX guest, deleting/moving memory region loses guest memory contents.
> +Read only region isn't supported.  Only as-id 0 is supported.
> +
>   
>   4.36 KVM_SET_TSS_ADDR
>   ---------------------
> @@ -4714,7 +4717,7 @@ H_GET_CPU_CHARACTERISTICS hypercall.
>   
>   :Capability: basic
>   :Architectures: x86
> -:Type: vm
> +:Type: vm ioctl, vcpu ioctl
>   :Parameters: an opaque platform specific structure (in/out)
>   :Returns: 0 on success; -1 on error
>   
> @@ -4726,6 +4729,10 @@ Currently, this ioctl is used for issuing Secure Encrypted Virtualization
>   (SEV) commands on AMD Processors. The SEV commands are defined in
>   Documentation/virt/kvm/x86/amd-memory-encryption.rst.
>   
> +Currently, this ioctl is used for issuing Trusted Domain Extensions
> +(TDX) commands on Intel Processors. The TDX commands are defined in
> +Documentation/virt/kvm/intel-tdx.rst.
> +
>   4.111 KVM_MEMORY_ENCRYPT_REG_REGION
>   -----------------------------------
>   
> diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/index.rst
> index e0a2c74e1043..cdb8b43ce797 100644
> --- a/Documentation/virt/kvm/index.rst
> +++ b/Documentation/virt/kvm/index.rst
> @@ -18,3 +18,5 @@ KVM
>      locking
>      vcpu-requests
>      review-checklist
> +
> +   intel-tdx
> diff --git a/Documentation/virt/kvm/intel-tdx.rst b/Documentation/virt/kvm/intel-tdx.rst
> new file mode 100644
> index 000000000000..6999b0f4f6c2
> --- /dev/null
> +++ b/Documentation/virt/kvm/intel-tdx.rst
> @@ -0,0 +1,345 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +===================================
> +Intel Trust Domain Extensions (TDX)
> +===================================
> +
> +Overview
> +========
> +TDX stands for Trust Domain Extensions which isolates VMs from
> +the virtual-machine manager (VMM)/hypervisor and any other software on
> +the platform. For details, see the specifications [1]_, whitepaper [2]_,
> +architectural extensions specification [3]_, module documentation [4]_,
> +loader interface specification [5]_, guest-hypervisor communication
> +interface [6]_, virtual firmware design guide [7]_, and other resources
> +([8]_, [9]_, [10]_, [11]_, and [12]_).
> +
> +
> +API description
> +===============
> +
> +KVM_MEMORY_ENCRYPT_OP
> +---------------------
> +:Type: vm ioctl, vcpu ioctl
> +
> +For TDX operations, KVM_MEMORY_ENCRYPT_OP is re-purposed to be generic
> +ioctl with TDX specific sub ioctl command.
> +
> +::
> +
> +  /* Trust Domain eXtension sub-ioctl() commands. */
> +  enum kvm_tdx_cmd_id {
> +          KVM_TDX_CAPABILITIES = 0,
> +          KVM_TDX_INIT_VM,
> +          KVM_TDX_INIT_VCPU,
> +          KVM_TDX_INIT_MEM_REGION,
> +          KVM_TDX_FINALIZE_VM,
> +
> +          KVM_TDX_CMD_NR_MAX,
> +  };
> +
> +  struct kvm_tdx_cmd {
> +        /* enum kvm_tdx_cmd_id */
> +        __u32 id;
> +        /* flags for sub-commend. If sub-command doesn't use this, set zero. */
> +        __u32 flags;
> +        /*
> +         * data for each sub-command. An immediate or a pointer to the actual
> +         * data in process virtual address.  If sub-command doesn't use it,
> +         * set zero.
> +         */
> +        __u64 data;
> +        /*
> +         * Auxiliary error code.  The sub-command may return TDX SEAMCALL
> +         * status code in addition to -Exxx.
> +         * Defined for consistency with struct kvm_sev_cmd.
> +         */
> +        __u64 error;
> +        /* Reserved: Defined for consistency with struct kvm_sev_cmd. */
> +        __u64 unused;
> +  };
> +
> +KVM_TDX_CAPABILITIES
> +--------------------
> +:Type: vm ioctl
> +
> +Subset of TDSYSINFO_STRCUCT retrieved by TDH.SYS.INFO TDX SEAM call will be
> +returned. Which describes about Intel TDX module.
> +
> +- id: KVM_TDX_CAPABILITIES
> +- flags: must be 0
> +- data: pointer to struct kvm_tdx_capabilities
> +- error: must be 0
> +- unused: must be 0
> +
> +::
> +
> +  struct kvm_tdx_cpuid_config {
> +          __u32 leaf;
> +          __u32 sub_leaf;
> +          __u32 eax;
> +          __u32 ebx;
> +          __u32 ecx;
> +          __u32 edx;
> +  };
> +
> +  struct kvm_tdx_capabilities {
> +          __u64 attrs_fixed0;
> +          __u64 attrs_fixed1;
> +          __u64 xfam_fixed0;
> +          __u64 xfam_fixed1;
> +
> +          __u32 nr_cpuid_configs;
> +          struct kvm_tdx_cpuid_config cpuid_configs[0];
> +  };
> +
> +
> +KVM_TDX_INIT_VM
> +---------------
> +:Type: vm ioctl
> +
> +Does additional VM initialization specific to TDX which corresponds to
> +TDH.MNG.INIT TDX SEAM call.
> +
> +- id: KVM_TDX_INIT_VM
> +- flags: must be 0
> +- data: pointer to struct kvm_tdx_init_vm
> +- error: must be 0
> +- unused: must be 0
> +
> +::
> +
> +  struct kvm_tdx_init_vm {
> +          __u32 max_vcpus;
> +          __u32 reserved;
> +          __u64 attributes;
> +          __u64 cpuid;  /* pointer to struct kvm_cpuid2 */
> +          __u64 mrconfigid[6];          /* sha384 digest */
> +          __u64 mrowner[6];             /* sha384 digest */
> +          __u64 mrownerconfig[6];       /* sha348 digest */
> +          __u64 reserved[43];           /* must be zero for future extensibility */
> +  };
> +
> +
> +KVM_TDX_INIT_VCPU
> +-----------------
> +:Type: vcpu ioctl
> +
> +Does additional VCPU initialization specific to TDX which corresponds to
> +TDH.VP.INIT TDX SEAM call.
> +
> +- id: KVM_TDX_INIT_VCPU
> +- flags: must be 0
> +- data: initial value of the guest TD VCPU RCX
> +- error: must be 0
> +- unused: must be 0
> +
> +KVM_TDX_INIT_MEM_REGION
> +-----------------------
> +:Type: vm ioctl
> +
> +Encrypt a memory continuous region which corresponding to TDH.MEM.PAGE.ADD
> +TDX SEAM call.
> +If KVM_TDX_MEASURE_MEMORY_REGION flag is specified, it also extends measurement
> +which corresponds to TDH.MR.EXTEND TDX SEAM call.
> +
> +- id: KVM_TDX_INIT_VCPU
> +- flags: flags
> +            currently only KVM_TDX_MEASURE_MEMORY_REGION is defined
> +- data: pointer to struct kvm_tdx_init_mem_region
> +- error: must be 0
> +- unused: must be 0
> +
> +::
> +
> +  #define KVM_TDX_MEASURE_MEMORY_REGION   (1UL << 0)
> +
> +  struct kvm_tdx_init_mem_region {
> +          __u64 source_addr;
> +          __u64 gpa;
> +          __u64 nr_pages;
> +  };
> +
> +
> +KVM_TDX_FINALIZE_VM
> +-------------------
> +:Type: vm ioctl
> +
> +Complete measurement of the initial TD contents and mark it ready to run
> +which corresponds to TDH.MR.FINALIZE
> +
> +- id: KVM_TDX_FINALIZE_VM
> +- flags: must be 0
> +- data: must be 0
> +- error: must be 0
> +- unused: must be 0
> +
> +KVM TDX creation flow
> +=====================
> +In addition to KVM normal flow, new TDX ioctls need to be called.  The control flow
> +looks like as follows.
> +
> +#. system wide capability check
> +
> +   * KVM_CAP_VM_TYPES: check if VM type is supported and if TDX_VM_TYPE is
> +     supported.
> +
> +#. creating VM
> +
> +   * KVM_CREATE_VM
> +   * KVM_TDX_CAPABILITIES: query if TDX is supported on the platform.
> +   * KVM_TDX_INIT_VM: pass TDX specific VM parameters.
> +
> +#. creating VCPU
> +
> +   * KVM_CREATE_VCPU
> +   * KVM_TDX_INIT_VCPU: pass TDX specific VCPU parameters.
> +
> +#. initializing guest memory
> +
> +   * allocate guest memory and initialize page same to normal KVM case
> +     In TDX case, parse and load TDVF into guest memory in addition.
> +   * KVM_TDX_INIT_MEM_REGION to add and measure guest pages.
> +     If the pages has contents above, those pages need to be added.
> +     Otherwise the contents will be lost and guest sees zero pages.
> +   * KVM_TDX_FINALIAZE_VM: Finalize VM and measurement
> +     This must be after KVM_TDX_INIT_MEM_REGION.
> +
> +#. run vcpu
> +
> +Design discussion
> +=================
> +
> +Coexistence of normal(VMX) VM and TD VM
> +---------------------------------------
> +It's required to allow both legacy(normal VMX) VMs and new TD VMs to
> +coexist. Otherwise the benefits of VM flexibility would be eliminated.
> +The main issue for it is that the logic of kvm_x86_ops callbacks for
> +TDX is different from VMX. On the other hand, the variable,
> +kvm_x86_ops, is global single variable. Not per-VM, not per-vcpu.
> +
> +Several points to be considered:
> +
> +  * No or minimal overhead when TDX is disabled(CONFIG_INTEL_TDX_HOST=n).
> +  * Avoid overhead of indirect call via function pointers.
> +  * Contain the changes under arch/x86/kvm/vmx directory and share logic
> +    with VMX for maintenance.
> +    Even though the ways to operation on VM (VMX instruction vs TDX
> +    SEAM call) is

are


> different, the basic idea remains same.

remains the same


> So, many
> +    logic can be shared.
> +  * Future maintenance
> +    The huge change of kvm_x86_ops in (near) future isn't expected.
> +    a centralized file is acceptable.
> +
> +- Wrapping kvm x86_ops: The current choice
> +
> +  Introduce dedicated file for arch/x86/kvm/vmx/main.c (the name,
> +  main.c, is just chosen to show main entry points for callbacks.) and
> +  wrapper functions around all the callbacks with
> +  "if (is-tdx) tdx-callback() else vmx-callback()".
> +
> +  Pros:
> +
> +  - No major change in common x86 KVM code. The change is (mostly)
> +    contained under arch/x86/kvm/vmx/.
> +  - When TDX is disabled(CONFIG_INTEL_TDX_HOST=n), the overhead is
> +    optimized out.
> +  - Micro optimization by avoiding function pointer.
> +
> +  Cons:
> +
> +  - Many boiler plates in arch/x86/kvm/vmx/main.c.
> +
> +KVM MMU Changes
> +---------------
> +KVM MMU needs to be enhanced to handle Secure/Shared-EPT. The
> +high-level execution flow is mostly same to normal EPT case.
> +EPT violation/misconfiguration -> invoke TDP fault handler ->
> +resolve TDP fault -> resume execution. (or emulate MMIO)
> +The difference is, that S-EPT is operated(read/write) via TDX SEAM
> +call which is expensive instead of direct read/write EPT entry.
> +One bit of GPA (51 or 47 bit) is repurposed so that it means shared
> +with host(if set to 1) or private to TD(if cleared to 0).
> +
> +- The current implementation
> +
> +  * Reuse the existing MMU code with minimal update.  Because the
> +    execution flow is mostly same. But additional operation, TDX call
> +    for S-EPT, is needed. So add hooks for it to kvm_x86_ops.
> +  * For performance, minimize TDX SEAM call to operate on S-EPT. When
> +    getting corresponding S-EPT pages/entry from faulting GPA, don't
> +    use TDX SEAM call to read S-EPT entry. Instead create shadow copy
> +    in host memory.
> +    Repurpose the existing kvm_mmu_page as shadow copy of S-EPT and
> +    associate S-EPT to it.
> +  * Treats share bit as attributes. mask/unmask the bit where
> +    necessary to keep the existing traversing code works.
> +    Introduce kvm.arch.gfn_shared_mask and use "if (gfn_share_mask)"
> +    for special case.
> +
> +    * 0 : for non-TDX case
> +    * 51 or 47 bit set for TDX case.
> +
> +  Pros:
> +
> +  - Large code reuse with minimal new hooks.
> +  - Execution path is same.
> +
> +  Cons:
> +
> +  - Complicates the existing code.
> +  - Repurpose kvm_mmu_page as shadow of Secure-EPT can be confusing.
> +
> +New KVM API, ioctl (sub)command, to manage TD VMs
> +-------------------------------------------------
> +Additional KVM API
API -> APIs
>   are needed to control TD VMs. The operations on TD
> +VMs are specific to TDX.
> +
> +- Piggyback and repurpose KVM_MEMORY_ENCRYPT_OP
> +
> +  Although not all operation isn't memory encryption,

How to understand it?


> repupose to get
> +  TDX specific ioctls.
> +
> +  Pros:
> +
> +  - No major change in common x86 KVM code.
> +
> +  Cons:
> +
> +  - The operations aren't actually memory encryption, but operations
> +    on TD VMs.
> +
> +References
> +==========
> +
> +.. [1] TDX specification
> +   https://software.intel.com/content/www/us/en/develop/articles/intel-trust-domain-extensions.html
> +.. [2] Intel Trust Domain Extensions (Intel TDX)
> +   https://software.intel.com/content/dam/develop/external/us/en/documents/tdx-whitepaper-final9-17.pdf
> +.. [3] Intel CPU Architectural Extensions Specification
> +   https://software.intel.com/content/dam/develop/external/us/en/documents/intel-tdx-cpu-architectural-specification.pdf
> +.. [4] Intel TDX Module 1.0 EAS
> +   https://software.intel.com/content/dam/develop/external/us/en/documents/intel-tdx-module-1eas.pdf
> +.. [5] Intel TDX Loader Interface Specification
> +   https://software.intel.com/content/dam/develop/external/us/en/documents/intel-tdx-seamldr-interface-specification.pdf
> +.. [6] Intel TDX Guest-Hypervisor Communication Interface
> +   https://software.intel.com/content/dam/develop/external/us/en/documents/intel-tdx-guest-hypervisor-communication-interface.pdf
> +.. [7] Intel TDX Virtual Firmware Design Guide
> +   https://software.intel.com/content/dam/develop/external/us/en/documents/tdx-virtual-firmware-design-guide-rev-1.
> +.. [8] intel public github
> +
> +   * kvm TDX branch: https://github.com/intel/tdx/tree/kvm
> +   * TDX guest branch: https://github.com/intel/tdx/tree/guest
> +
> +.. [9] tdvf
> +    https://github.com/tianocore/edk2-staging/tree/TDVF
> +.. [10] KVM forum 2020: Intel Virtualization Technology Extensions to
> +     Enable Hardware Isolated VMs
> +     https://osseu2020.sched.com/event/eDzm/intel-virtualization-technology-extensions-to-enable-hardware-isolated-vms-sean-christopherson-intel
> +.. [11] Linux Security Summit EU 2020:
> +     Architectural Extensions for Hardware Virtual Machine Isolation
> +     to Advance Confidential Computing in Public Clouds - Ravi Sahita
> +     & Jun Nakajima, Intel Corporation
> +     https://osseu2020.sched.com/event/eDOx/architectural-extensions-for-hardware-virtual-machine-isolation-to-advance-confidential-computing-in-public-clouds-ravi-sahita-jun-nakajima-intel-corporation
> +.. [12] [RFCv2,00/16] KVM protected memory extension
> +     https://lkml.org/lkml/2020/10/20/66
