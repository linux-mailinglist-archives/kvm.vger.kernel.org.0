Return-Path: <kvm+bounces-46834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F196FABA064
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 17:57:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 950E67ADDA5
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 15:56:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9686F1CAA76;
	Fri, 16 May 2025 15:57:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A6B31A256B;
	Fri, 16 May 2025 15:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747411042; cv=none; b=a2QVsf/FtHdgAAk+eGK9iTdq62GnaJVGfhzGeCrTk2m0xlKVSSRMShPAziKyBfsTy0ZnVhpaFmJkNT1jrUvBEmtb+EC7kz0l9ENGBQ8RdRMrHC66cj2cliAGhlb6NYxg3Nlmh2s8J0TGl9PuQjN/R5fpjJ2LQWfV95nghT+mVsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747411042; c=relaxed/simple;
	bh=PrB6OnVM/jT9TdAeEJ83sop1YH97w7DtAGGBKw9INMM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p7bVOohSTHDPizIOc/92ivrqkL69Dp2jy73Jb2qoXete4dLZuGIjVYgWBrTvkjUqvKFevZmbzRc9uUEfoFxxBolcwnOi7dUFCmBX3/mAqICfbYgswKKsDpvXEfB5brkBvGjUo929ZlX/O4ZZ2zk9B4Tx1f8RqaV6hq2kW5U6Fws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A6D93169C;
	Fri, 16 May 2025 08:57:07 -0700 (PDT)
Received: from [10.1.27.17] (e122027.cambridge.arm.com [10.1.27.17])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6A9013F63F;
	Fri, 16 May 2025 08:57:15 -0700 (PDT)
Message-ID: <76e6261d-7b94-45d5-94da-bb96e712b7ab@arm.com>
Date: Fri, 16 May 2025 16:57:13 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/43] arm64: Support for Arm CCA in KVM
To: "Emi Kisanuki (Fujitsu)" <fj0570is@fujitsu.com>,
 "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>,
 "'kvmarm@lists.linux.dev'" <kvmarm@lists.linux.dev>
Cc: 'Catalin Marinas' <catalin.marinas@arm.com>,
 'Marc Zyngier' <maz@kernel.org>, 'Will Deacon' <will@kernel.org>,
 'James Morse' <james.morse@arm.com>, 'Oliver Upton'
 <oliver.upton@linux.dev>, 'Suzuki K Poulose' <suzuki.poulose@arm.com>,
 'Zenghui Yu' <yuzenghui@huawei.com>,
 "'linux-arm-kernel@lists.infradead.org'"
 <linux-arm-kernel@lists.infradead.org>,
 "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
 'Joey Gouly' <joey.gouly@arm.com>,
 'Alexandru Elisei' <alexandru.elisei@arm.com>,
 'Christoffer Dall' <christoffer.dall@arm.com>,
 'Fuad Tabba' <tabba@google.com>,
 "'linux-coco@lists.linux.dev'" <linux-coco@lists.linux.dev>,
 'Ganapatrao Kulkarni' <gankulkarni@os.amperecomputing.com>,
 'Gavin Shan' <gshan@redhat.com>,
 'Shanker Donthineni' <sdonthineni@nvidia.com>,
 'Alper Gun' <alpergun@google.com>,
 "'Aneesh Kumar K . V'" <aneesh.kumar@kernel.org>
References: <20250416134208.383984-1-steven.price@arm.com>
 <TYCPR01MB11463F53A3487AF7C669A534EC390A@TYCPR01MB11463.jpnprd01.prod.outlook.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <TYCPR01MB11463F53A3487AF7C669A534EC390A@TYCPR01MB11463.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Emi,

On 15/05/2025 04:01, Emi Kisanuki (Fujitsu) wrote:
> We tested this patch in our internal simulator which is a hardware simulator for Fujitsu's next generation CPU known as Monaka. and it produced the expected results.
> 
> I have verified the following
> 1. Launching the realm VM using Internal simulator → Successfully launched by disabling MPAM support in the ID register.
> 2. Running kvm-unit-tests (with lkvm) → All tests passed except for PMU (as expected, since PMU is not supported by the Internal simulator).[1]
> 
> Tested-by: Emi Kisanuki <fj0570is@fujitsu.com> [1] https://gitlab.arm.com/linux-arm/kvm-unit-tests-cca cca/v3

Thanks for testing!

Regards,
Steve

> Best Regards,
> Emi Kisanuki
>> This series adds support for running protected VMs using KVM under the Arm
>> Confidential Compute Architecture (CCA).
>>
>> The related guest support was merged for v6.14-rc1 so you no longer need that
>> separately.
>>
>> There are a few changes since v7, many thanks for the review comments. The
>> highlights are below, and individual patches have a changelog.
>>
>>  * More documentation - the new ioctls and capabilties are now all
>>    documented.
>>
>>  * Initial patch adding "only_private"/"only_shared" to struct
>>    kvm_gfn_range replaced with already upstream "attr_filter".
>>
>>  * Improvement in variable naming and error codes, and some improved/new
>>    comments. All following valuable review feedback (thanks!).
>>
>>  * Drop the final WIP patch for enabling large PAGE_SIZE support. It's
>>    not ready for merging and I want to focus on landing the 4k support.
>>
>>  * Rebased onto v6.15-rc1.
>>
>> Things to note:
>>
>>  * The magic numbers for capabilities and ioctls have been updated. So
>>    you'll need to update your VMM. See below for update kvmtool branch.
>>
>>  * Patch 42 increases KVM_VCPU_MAX_FEATURES to expose the new feature.
>>    This also exposes the NV features (as they are currently numbered
>>    lower). This will resolve when Marc's NV series has landed, see [2].
>>
>>  * There are some conflicts with v6.15-rc2, mostly documentation, but
>>    also commit 26fbdf369227 ("KVM: arm64: Don't translate FAR if
>>    invalid/unsafe") 'hijacks' HPFAR_EL2_NS as a valid bit. This will
>>    require corresponding changes to the CCA code.
>>
>> The ABI to the RMM (the RMI) is based on RMM v1.0-rel0 specification[1].
>>
>> This series is based on v6.15-rc1. It is also available as a git
>> repository:
>>
>> https://gitlab.arm.com/linux-arm/linux-cca cca-host/v8
>>
>> Work in progress changes for kvmtool are available from the git repository below:
>>
>> https://gitlab.arm.com/linux-arm/kvmtool-cca cca/v6
>>
>> [1] https://developer.arm.com/documentation/den0137/1-0rel0/
>> [2] https://lore.kernel.org/r/20250408105225.4002637-17-maz%40kernel.org
>>
>> Jean-Philippe Brucker (7):
>>   arm64: RME: Propagate number of breakpoints and watchpoints to
>>     userspace
>>   arm64: RME: Set breakpoint parameters through SET_ONE_REG
>>   arm64: RME: Initialize PMCR.N with number counter supported by RMM
>>   arm64: RME: Propagate max SVE vector length from RMM
>>   arm64: RME: Configure max SVE vector length for a Realm
>>   arm64: RME: Provide register list for unfinalized RME RECs
>>   arm64: RME: Provide accurate register list
>>
>> Joey Gouly (2):
>>   arm64: RME: allow userspace to inject aborts
>>   arm64: RME: support RSI_HOST_CALL
>>
>> Steven Price (31):
>>   arm64: RME: Handle Granule Protection Faults (GPFs)
>>   arm64: RME: Add SMC definitions for calling the RMM
>>   arm64: RME: Add wrappers for RMI calls
>>   arm64: RME: Check for RME support at KVM init
>>   arm64: RME: Define the user ABI
>>   arm64: RME: ioctls to create and configure realms
>>   KVM: arm64: Allow passing machine type in KVM creation
>>   arm64: RME: RTT tear down
>>   arm64: RME: Allocate/free RECs to match vCPUs
>>   KVM: arm64: vgic: Provide helper for number of list registers
>>   arm64: RME: Support for the VGIC in realms
>>   KVM: arm64: Support timers in realm RECs
>>   arm64: RME: Allow VMM to set RIPAS
>>   arm64: RME: Handle realm enter/exit
>>   arm64: RME: Handle RMI_EXIT_RIPAS_CHANGE
>>   KVM: arm64: Handle realm MMIO emulation
>>   arm64: RME: Allow populating initial contents
>>   arm64: RME: Runtime faulting of memory
>>   KVM: arm64: Handle realm VCPU load
>>   KVM: arm64: Validate register access for a Realm VM
>>   KVM: arm64: Handle Realm PSCI requests
>>   KVM: arm64: WARN on injected undef exceptions
>>   arm64: Don't expose stolen time for realm guests
>>   arm64: RME: Always use 4k pages for realms
>>   arm64: RME: Prevent Device mappings for Realms
>>   arm_pmu: Provide a mechanism for disabling the physical IRQ
>>   arm64: RME: Enable PMU support with a realm guest
>>   arm64: RME: Hide KVM_CAP_READONLY_MEM for realm guests
>>   KVM: arm64: Expose support for private memory
>>   KVM: arm64: Expose KVM_ARM_VCPU_REC to user space
>>   KVM: arm64: Allow activating realms
>>
>> Suzuki K Poulose (3):
>>   kvm: arm64: Include kvm_emulate.h in kvm/arm_psci.h
>>   kvm: arm64: Don't expose debug capabilities for realm guests
>>   arm64: RME: Allow checking SVE on VM instance
>>
>>  Documentation/virt/kvm/api.rst       |   91 +-
>>  arch/arm64/include/asm/kvm_emulate.h |   40 +
>>  arch/arm64/include/asm/kvm_host.h    |   17 +-
>>  arch/arm64/include/asm/kvm_rme.h     |  137 +++
>>  arch/arm64/include/asm/rmi_cmds.h    |  508 ++++++++
>>  arch/arm64/include/asm/rmi_smc.h     |  259 ++++
>>  arch/arm64/include/asm/virt.h        |    1 +
>>  arch/arm64/include/uapi/asm/kvm.h    |   49 +
>>  arch/arm64/kvm/Kconfig               |    1 +
>>  arch/arm64/kvm/Makefile              |    3 +-
>>  arch/arm64/kvm/arch_timer.c          |   48 +-
>>  arch/arm64/kvm/arm.c                 |  160 ++-
>>  arch/arm64/kvm/guest.c               |  104 +-
>>  arch/arm64/kvm/hypercalls.c          |    4 +-
>>  arch/arm64/kvm/inject_fault.c        |    5 +-
>>  arch/arm64/kvm/mmio.c                |   16 +-
>>  arch/arm64/kvm/mmu.c                 |  201 ++-
>>  arch/arm64/kvm/pmu-emul.c            |    6 +
>>  arch/arm64/kvm/psci.c                |   30 +
>>  arch/arm64/kvm/reset.c               |   23 +-
>>  arch/arm64/kvm/rme-exit.c            |  199 +++
>>  arch/arm64/kvm/rme.c                 | 1708
>> ++++++++++++++++++++++++++
>>  arch/arm64/kvm/sys_regs.c            |   49 +-
>>  arch/arm64/kvm/vgic/vgic-init.c      |    2 +-
>>  arch/arm64/kvm/vgic/vgic-v3.c        |    6 +-
>>  arch/arm64/kvm/vgic/vgic.c           |   54 +-
>>  arch/arm64/mm/fault.c                |   31 +-
>>  drivers/perf/arm_pmu.c               |   15 +
>>  include/kvm/arm_arch_timer.h         |    2 +
>>  include/kvm/arm_pmu.h                |    4 +
>>  include/kvm/arm_psci.h               |    2 +
>>  include/linux/perf/arm_pmu.h         |    5 +
>>  include/uapi/linux/kvm.h             |   29 +-
>>  33 files changed, 3709 insertions(+), 100 deletions(-)  create mode 100644
>> arch/arm64/include/asm/kvm_rme.h  create mode 100644
>> arch/arm64/include/asm/rmi_cmds.h  create mode 100644
>> arch/arm64/include/asm/rmi_smc.h  create mode 100644
>> arch/arm64/kvm/rme-exit.c  create mode 100644 arch/arm64/kvm/rme.c
>>
>> --
>> 2.43.0


