Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8799C7BCD8F
	for <lists+kvm@lfdr.de>; Sun,  8 Oct 2023 11:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344568AbjJHJhu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Oct 2023 05:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbjJHJht (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Oct 2023 05:37:49 -0400
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21144B6;
        Sun,  8 Oct 2023 02:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696757867; x=1728293867;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pZl858y3jcWEECXn8DCK3d9ymq7qvurpMSIhAHEG+Ws=;
  b=Hul6q5fIpFVoCdtSOGj6LhsGsY027gVvz5kgWWDI1z45uRBaRhw6aAGa
   Lr9EADwAFweZfvqIt91+7NvhJFGo8a2fqRIdMn0yB8MXZ31NOQejg/nKQ
   pG8xqlSIsvwR168xEPJM8U3xwxhwWv7hfUSZ/Gvih7paL/9iaYDmmahti
   Ua2qDLLZl+upToNWKzwKuv4Q1TScfCqRK8Q/3Pqi43oRiIea7p5b/3zIh
   Dn8vPejBuoLW5MzjSR5lawsGky6ZInQOWMn5SXOzNT7R1V1QNOv7Lb7Ex
   oZ4USezCUx2uX0ieBHU4UG9P/9WjFCRiG95gSTY6Wjojrk9n1OX5F3Far
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10856"; a="2591576"
X-IronPort-AV: E=Sophos;i="6.03,207,1694761200"; 
   d="scan'208";a="2591576"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2023 02:37:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10856"; a="823023975"
X-IronPort-AV: E=Sophos;i="6.03,207,1694761200"; 
   d="scan'208";a="823023975"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.93.2.44]) ([10.93.2.44])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2023 02:37:44 -0700
Message-ID: <46b73aa3-4776-8d95-b3f4-c2ddf4f0696c@linux.intel.com>
Date:   Sun, 8 Oct 2023 17:37:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v11 00/16] LAM and LASS KVM Enabling
To:     seanjc@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        David.Laight@ACULAB.COM, robert.hu@linux.intel.com,
        guang.zeng@intel.com
References: <20230913124227.12574-1-binbin.wu@linux.intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230913124227.12574-1-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

Does this version of LAM patch set have the chance to be pulled for 6.7?


On 9/13/2023 8:42 PM, Binbin Wu wrote:
> This patch series includes KVM enabling patches for Linear-address masking
> (LAM) v11 and Linear Address Space Separation (LASS) v3 since the two features
> have overlapping prep work and concepts. Sent as a single series to reduce the
> probability of conflicts.
>
> The patch series is organized as follows:
> - Patch 1-4: Common prep work for both LAM and LASS.
> - Patch 5-13: LAM part.
> - Patch 14-16: LASS part.
>
> Dependency:
> - LAM has no other dependency.
> - LASS patches depends on LASS kernel enabling patches, which are not merged yet.
>    https://lore.kernel.org/all/20230609183632.48706-1-alexander.shishkin@linux.intel.com/
>
>
> ==== LAM v11 ====
>
> Linear-address masking (LAM) [1], modifies the checking that is applied to
> *64-bit* linear addresses, allowing software to use of the untranslated
> address bits for metadata and masks the metadata bits before using them as
> linear addresses to access memory.
>
> When the feature is virtualized and exposed to guest, it can be used for
> efficient address sanitizers (ASAN) implementation and for optimizations in
> JITs and virtual machines.
>
> The patch series brings LAM virtualization support in KVM.
>
> Please review and consider applying.
>
> LAM QEMU patch:
> https://lists.gnu.org/archive/html/qemu-devel/2023-07/msg04160.html
>
> LAM kvm-unit-tests patch:
> https://lore.kernel.org/kvm/20230530024356.24870-1-binbin.wu@linux.intel.com/
>
> --- Test ---
> 1. Add test cases in kvm-unit-test for LAM [2], including LAM_SUP and LAM_{U57,U48}.
>     For supervisor pointers, the test covers CR4 LAM_SUP bits toggle, Memory/MMIO
>     access with tagged pointer, and some special instructions (INVLPG, INVPCID,
>     INVVPID), INVVPID cases also used to cover VMX instruction VMExit path.
>     For user pointers, the test covers CR3 LAM bits toggle, Memory/MMIO access with
>     tagged pointer.
>     MMIO cases are used to trigger instruction emulation path.
>     Run the unit test with both LAM feature on/off (i.e. including negative cases).
>     Run the unit test in L1 guest with both LAM feature on/off.
> 2. Run Kernel LAM kselftests in guest, with both EPT=Y/N.
> 3. Launch a nested guest and run tests listed in 1 & 2.
>
> All tests have passed on real machine supporting LAM.
>
> [1] Intel ISE https://cdrdv2.intel.com/v1/dl/getContent/671368
>      Chapter Linear Address Masking (LAM)
> [2] https://lore.kernel.org/kvm/20230530024356.24870-1-binbin.wu@linux.intel.com/
>
> ----------
> Changelog
>
> v11:
> - A separate patch to drop non-PA bits when getting GFN for guest's PGD [Sean]
> - Add a patch to remove kvm_vcpu_is_illegal_gpa() [Isaku]
> - Squash CR4 LAM bit handling with the address untag for supervisor pointers. [Sean]
> - Squash CR3 LAM bits handling with the address untag for user pointers. [Sean]
> - Adopt KVM-governed feature framework to track "LAM enabled" as a separate
>    optimization patch, and add the reason in patch change log. [Sean, Kai]
> - Some comment modifications/additions according to reviews [Sean]
>
> v10:
> https://lore.kernel.org/kvm/20230719144131.29052-1-binbin.wu@linux.intel.com/
>
>
> ==== LASS v3 ====
>
> Linear Address Space Separation (LASS)[1] is a new mechanism that
> enforces the same mode-based protections as paging, i.e. SMAP/SMEP
> but without traversing the paging structures. Because the protections
> enforced by LASS are applied before paging, "probes" by malicious
> software will provide no paging-based timing information.
>
> This patch series provide a LASS KVM solution and depends on kernel
> enabling that can be found at [2].
>
> --- Test ---
> 1. Test the basic function of LASS virtualization including LASS
> enumeration and enabling in guest and nested environment.
> 2. Run selftest with following cases:
>    - data access to user address space in supervisor mode
>    - data access to supervisor address space in user mode
>    - data access to linear address across space boundary
>    - Using KVM FEP mechanism to run test cases above
>    - VMX instruction execution with VMCS structure in user
>      address space
>    - instruction fetch from user address space in supervisor mode
>    - instruction fetch from supervisor address space in user mode
>
> All tests have passed on real machine supporting LASS.
>
> [1] Intel ISE spec https://cdrdv2.intel.com/v1/dl/getContent/671368
> Chapter Linear Address Space Separation (LASS)
>
> [2] LASS kernel patch series
> https://lore.kernel.org/all/20230609183632.48706-1-alexander.shishkin@linux.intel.com/
>
> ----------
> Change log
>
> v3:
> 1. Refine commit message [Sean/Chao Gao]
> 2. Enhance the implementation of LASS violation check [Sean]
> 3. Re-organize patch as Sean's suggestion [Sean]
>
> v2:
>     https://lore.kernel.org/all/20230719024558.8539-1-guang.zeng@intel.com/
>
>
> Binbin Wu (10):
>    KVM: x86: Consolidate flags for __linearize()
>    KVM: x86: Use a new flag for branch targets
>    KVM: x86: Add an emulation flag for implicit system access
>    KVM: x86: Add X86EMUL_F_INVLPG and pass it in em_invlpg()
>    KVM: x86/mmu: Drop non-PA bits when getting GFN for guest's PGD
>    KVM: x86: Add & use kvm_vcpu_is_legal_cr3() to check CR3's legality
>    KVM: x86: Remove kvm_vcpu_is_illegal_gpa()
>    KVM: x86: Introduce get_untagged_addr() in kvm_x86_ops and call it in
>      emulator
>    KVM: x86: Untag address for vmexit handlers when LAM applicable
>    KVM: x86: Use KVM-governed feature framework to track "LAM enabled"
>
> Robert Hoo (3):
>    KVM: x86: Virtualize LAM for supervisor pointer
>    KVM: x86: Virtualize LAM for user pointer
>    KVM: x86: Advertise and enable LAM (user and supervisor)
>
> Zeng Guang (3):
>    KVM: emulator: Add emulation of LASS violation checks on linear
>      address
>    KVM: VMX: Virtualize LASS
>    KVM: x86: Advertise LASS CPUID to user space
>
>   arch/x86/include/asm/kvm-x86-ops.h |   4 +-
>   arch/x86/include/asm/kvm_host.h    |   8 ++-
>   arch/x86/kvm/cpuid.c               |   4 +-
>   arch/x86/kvm/cpuid.h               |  13 ++--
>   arch/x86/kvm/emulate.c             |  39 +++++++----
>   arch/x86/kvm/governed_features.h   |   1 +
>   arch/x86/kvm/kvm_emulate.h         |  13 ++++
>   arch/x86/kvm/mmu.h                 |   8 +++
>   arch/x86/kvm/mmu/mmu.c             |   2 +-
>   arch/x86/kvm/mmu/mmu_internal.h    |   1 +
>   arch/x86/kvm/mmu/paging_tmpl.h     |   2 +-
>   arch/x86/kvm/svm/nested.c          |   4 +-
>   arch/x86/kvm/vmx/nested.c          |  14 ++--
>   arch/x86/kvm/vmx/sgx.c             |   4 +-
>   arch/x86/kvm/vmx/vmx.c             | 106 ++++++++++++++++++++++++++++-
>   arch/x86/kvm/vmx/vmx.h             |   5 ++
>   arch/x86/kvm/x86.c                 |  28 +++++++-
>   arch/x86/kvm/x86.h                 |   4 ++
>   18 files changed, 226 insertions(+), 34 deletions(-)
>
>
> base-commit: 0bb80ecc33a8fb5a682236443c1e740d5c917d1d
> prerequisite-patch-id: 51db36ad7156234d05f8c4004ec6a31ef609b81a

