Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2075101F6
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 17:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352363AbiDZPgr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 11:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348202AbiDZPgn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 11:36:43 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFFA158FA4;
        Tue, 26 Apr 2022 08:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650987215; x=1682523215;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=n0CWL4iSi+xWngs3tPTZP7bgCamLccuXKvBkrI0vxM0=;
  b=FvtObzUVIkJh2FHkWCEuQk4qlmBl/EJPxY7TW/gzbJzIuyxWEntWJx7i
   kPDNnPXvwnM+POitqMsUKoize9Ovh1wCr5joSIQcsNAW3nIGhU3kEot5b
   sZ0l5XwhRCl1V1+oE2JOZbPKnhoSaJtxHK0pTWKd7sL2JVD2Ul8WGUa4n
   nPjZfwp456IagL9TzIAdE1FuW+zIWKGCpLLyI9a6UYrL01jkcSOCNc1Ha
   /Zb+LYuThnGUN4qfS94wXbEf3/JrtK7fMGG3agX3QJv+xlt4975YzMMZT
   wFJgp9t+DE6wR9L9CchaFDeP0lLiINLmkuLSoTdB455Gam/CXo8KV2eL3
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10328"; a="247544503"
X-IronPort-AV: E=Sophos;i="5.90,291,1643702400"; 
   d="scan'208";a="247544503"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 08:31:15 -0700
X-IronPort-AV: E=Sophos;i="5.90,291,1643702400"; 
   d="scan'208";a="579965402"
Received: from baiyusun-mobl1.ccr.corp.intel.com (HELO [10.254.211.43]) ([10.254.211.43])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 08:31:09 -0700
Message-ID: <545ae1f7-cedd-dfe3-4b6d-436aba14da42@intel.com>
Date:   Tue, 26 Apr 2022 23:30:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v9 0/9] IPI virtualization support for VM
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>, guang.zeng@intel.com
References: <20220419153155.11504-1-guang.zeng@intel.com>
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <20220419153155.11504-1-guang.zeng@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kindly PING!

Thanks for your time.
BR,
Zeng Guang

On 4/19/2022 11:31 PM, Zeng, Guang wrote:
> Currently, issuing an IPI except self-ipi in guest on Intel CPU
> always causes a VM-exit. It can lead to non-negligible overhead
> to some workloads involving frequent IPIs when running in VMs.
>
> IPI virtualization is a new VT-x feature, targeting to eliminate
> VM-exits on source vCPUs when issuing unicast, physical-addressing
> IPIs. Once it is enabled, the processor virtualizes following kinds
> of operations that send IPIs without causing VM-exits:
> - Memory-mapped ICR writes
> - MSR-mapped ICR writes
> - SENDUIPI execution
>
> This patch series implements IPI virtualization support in KVM.
>
> Patches 1-4 add tertiary processor-based VM-execution support
> framework, which is used to enumerate IPI virtualization.
>
> Patch 5 handles APIC-write VM exit due to writes to ICR MSR when
> guest works in x2APIC mode. This is a new case introduced by
> Intel VT-x.
>
> Patch 6 cleanup code in vmx_refresh_apicv_exec_ctrl(). Prepare for
> IPIv status dynamical update along with APICv status change.
>
> Patch 7 move kvm_arch_vcpu_precreate() under kvm->lock protection.
> This patch is prepared for IPIv PID-table allocation prior to
> the creation of vCPUs.
>
> Patch 8 provide userspace capability to set maximum possible VCPU
> ID for current VM. IPIv can refer to this value to allocate memory
> for PID-pointer table.
>
> Patch 9 implements IPI virtualization related function including
> feature enabling through tertiary processor-based VM-execution in
> various scenarios of VMCS configuration, PID table setup in vCPU
> creation and vCPU block consideration.
>
> Document for IPI virtualization is now available at the latest "Intel
> Architecture Instruction Set Extensions Programming Reference".
>
> Document Link:
> https://software.intel.com/content/www/us/en/develop/download/intel-architecture-instruction-set-extensions-programming-reference.html
>
> We did experiment to measure average time sending IPI from source vCPU
> to the target vCPU completing the IPI handling by kvm unittest w/ and
> w/o IPI virtualization. When IPI virtualization enabled, it will reduce
> 22.21% and 15.98% cycles consuming in xAPIC mode and x2APIC mode
> respectively.
> --------------------------------------
> KVM unittest:vmexit/ipi
>
> 2 vCPU, AP was modified to run in idle loop instead of halt to ensure
> no VM exit impact on target vCPU.
>
>                  Cycles of IPI
>                  xAPIC mode              x2APIC mode
>          test    w/o IPIv  w/ IPIv       w/o IPIv  w/ IPIv
>          1       6106      4816          4265      3768
>          2       6244      4656          4404      3546
>          3       6165      4658          4233      3474
>          4       5992      4710          4363      3430
>          5       6083      4741          4215      3551
>          6       6238      4904          4304      3547
>          7       6164      4617          4263      3709
>          8       5984      4763          4518      3779
>          9       5931      4712          4645      3667
>          10      5955      4530          4332      3724
>          11      5897      4673          4283      3569
>          12      6140      4794          4178      3598
>          13      6183      4728          4363      3628
>          14      5991      4994          4509      3842
>          15      5866      4665          4520      3739
>          16      6032      4654          4229      3701
>          17      6050      4653          4185      3726
>          18      6004      4792          4319      3746
>          19      5961      4626          4196      3392
>          20      6194      4576          4433      3760
>
> Average cycles  6059      4713.1        4337.85   3644.8
> %Reduction                -22.21%                 -15.98%
>
> --------------------------------------
> IPI microbenchmark:
> (https://lore.kernel.org/kvm/20171219085010.4081-1-ynorov@caviumnetworks.com)
>
> 2 vCPUs, 1:1 pin vCPU to pCPU, guest VM runs with idle=poll, x2APIC mode
>
> Result with IPIv enabled:
>
> Dry-run:                         0,             272798 ns
> Self-IPI:                  5094123,           11114037 ns
> Normal IPI:              131697087,          173321200 ns
> Broadcast IPI:                   0,          155649075 ns
> Broadcast lock:                  0,          161518031 ns
>
> Result with IPIv disabled:
>
> Dry-run:                         0,             272766 ns
> Self-IPI:                  5091788,           11123699 ns
> Normal IPI:              145215772,          174558920 ns
> Broadcast IPI:                   0,          175785384 ns
> Broadcast lock:                  0,          149076195 ns
>
>
> As IPIv can benefit unicast IPI to other CPU, Normal IPI test case gain
> about 9.73% time saving on average out of 15 test runs when IPIv is
> enabled.
>
> Normal IPI statistics (unit:ns):
>          test    w/o IPIv        w/ IPIv
>          1       153346049       140907046
>          2       147218648       141660618
>          3       145215772       117890672
>          4       146621682       136430470
>          5       144821472       136199421
>          6       144704378       131676928
>          7       141403224       131697087
>          8       144775766       125476250
>          9       140658192       137263330
>          10      144768626       138593127
>          11      145166679       131946752
>          12      145020451       116852889
>          13      148161353       131406280
>          14      148378655       130174353
>          15      148903652       127969674
>
> Average time    145944306.6     131742993.1 ns
> %Reduction                      -9.73%
>
> --------------------------------------
> hackbench:
>
> 8 vCPUs, guest VM free run, x2APIC mode
> ./hackbench -p -l 100000
>
>                  w/o IPIv        w/ IPIv
> Time            91.887          74.605
> %Reduction                      -18.808%
>
> 96 vCPUs, guest VM fre run, x2APIC mode
> ./hackbench -p -l 1000000
>
>                  w/o IPIv        w/ IPIv
> Time            287.504         235.185
> %Reduction                      -18.198%
>
> --------------------------------------
> v8->v9:
> 1. Drop patch to forbid change of APIC ID.
> 2. Change max_vcpu_ids only set once
> 3. Refactor vCPU pre-creation code
>
> v7->v8:
> 1. Add trace in kvm_apic_write_nodecode() to track
> vICR Write in APIC Write VM-exit handling
> 2. Move IPIv PID table allocation done in the vCPU
> pre-creation (kvm_arch_vcpu_precreate()) protected
> by kvm->lock.
> 3. Misc code refine
>
> v6->v7:
> 1. Revise kvm_apic_write_nodecode() on dealing with
>     vICR busy bit in x2apic mode
> 2. Merge PID-table memory allocation with max_vcpu_id
>     into IPIv enabling patch
> 3. Change to allocate PID-table, setup vCPU's PID-table
>     entry and IPIv related VMCS fields once IPIv can
>     be enabled, which support runtime enabling IPIv.
>
> v5->v6:
> 1. Adapt kvm_apic_write_nodecode() implementation based
>     on Sean's fix of x2apic's ICR register process.
> 2. Drop the patch handling IPIv table entry setting in
>     case APIC ID changed, instead applying Levitsky's patch
>     to disallow setting APIC ID in any case.
> 3. Drop the patch resizing the PID-pointer table on demand.
>     Allow userspace to set maximum vcpu id at runtime that
>     IPIv can refer to the practical value to allocate memory
>     for PID-pointer table.
>
> v4 -> v5:
> 1. Deal with enable_ipiv parameter following current
>     vmcs configuration rule.
> 2. Allocate memory for PID-pointer table dynamically
> 3. Support guest runtime modify APIC ID in xAPIC mode
> 4. Helper to judge possibility to take PI block in IPIv case
>
> v3 -> v4:
> 1. Refine code style of patch 2
> 2. Move tertiary control shadow build into patch 3
> 3. Make vmx_tertiary_exec_control to be static function
>
> v2 -> v3:
> 1. Misc change on tertiary execution control
>     definition and capability setup
> 2. Alternative to get tertiary execution
>     control configuration
>
> v1 -> v2:
> 1. Refine the IPIv enabling logic for VM.
>     Remove ipiv_active definition per vCPU.
>
> --------------------------------------
>
> Chao Gao (1):
>    KVM: VMX: enable IPI virtualization
>
> Robert Hoo (4):
>    x86/cpu: Add new VMX feature, Tertiary VM-Execution control
>    KVM: VMX: Extend BUILD_CONTROLS_SHADOW macro to support 64-bit
>      variation
>    KVM: VMX: Detect Tertiary VM-Execution control when setup VMCS config
>    KVM: VMX: Report tertiary_exec_control field in dump_vmcs()
>
> Zeng Guang (4):
>    KVM: x86: Add support for vICR APIC-write VM-Exits in x2APIC mode
>    KVM: VMX: Clean up vmx_refresh_apicv_exec_ctrl()
>    KVM: Move kvm_arch_vcpu_precreate() under kvm->lock
>    KVM: x86: Allow userspace set maximum VCPU id for VM
>
>   Documentation/virt/kvm/api.rst     |  18 ++++
>   arch/s390/kvm/kvm-s390.c           |   2 -
>   arch/x86/include/asm/kvm-x86-ops.h |   1 +
>   arch/x86/include/asm/kvm_host.h    |   7 ++
>   arch/x86/include/asm/msr-index.h   |   1 +
>   arch/x86/include/asm/vmx.h         |  11 +++
>   arch/x86/include/asm/vmxfeatures.h |   5 +-
>   arch/x86/kernel/cpu/feat_ctl.c     |   9 +-
>   arch/x86/kvm/lapic.c               |  24 ++++-
>   arch/x86/kvm/vmx/capabilities.h    |  13 +++
>   arch/x86/kvm/vmx/evmcs.c           |   2 +
>   arch/x86/kvm/vmx/evmcs.h           |   1 +
>   arch/x86/kvm/vmx/posted_intr.c     |  15 +++-
>   arch/x86/kvm/vmx/posted_intr.h     |   2 +
>   arch/x86/kvm/vmx/vmcs.h            |   1 +
>   arch/x86/kvm/vmx/vmx.c             | 137 +++++++++++++++++++++++++----
>   arch/x86/kvm/vmx/vmx.h             |  64 ++++++++------
>   arch/x86/kvm/x86.c                 |  29 +++++-
>   virt/kvm/kvm_main.c                |  10 ++-
>   19 files changed, 294 insertions(+), 58 deletions(-)
>
