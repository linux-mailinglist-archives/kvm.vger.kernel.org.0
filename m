Return-Path: <kvm+bounces-36485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 952B4A1B6E0
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:37:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D026C16CFC1
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:37:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3187B38FB9;
	Fri, 24 Jan 2025 13:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nqLsVPrO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F246200CB
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725824; cv=none; b=OGgExaaPt9RWM6gK/lova9NQXRJy+pFUB9HmBIyCWyEJ/ERm5XJpxJTmY5vt+Xmyl8axFn7EPlk9chAmI33iov/Kt4K/PxSS6OwTbYsoaq8SmEXEnPJYi9hiAp7V64/fA8kub3Gqaa4PeVS61e2OxYh31KGvGafoo6bFsJEazwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725824; c=relaxed/simple;
	bh=af0DaxV6gEg0cz4KoUno4KNU4bEqf0Z7gl2SqxN9zGQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=t3TAB8ysaQhJWYBzdubfPEsDlqeWLKBFugYKgGn8fySf7by20M6fE/V346L2D0qTO0MbS3rYOJZBjkKMFvR6SZO80vG8AmSMsBq3iwW9dHaEryiN+KmCGu/3CUAWzXri8iyxmJq13PQsBHT6WAFL5PWILHEnobtvcXjTb/pg1bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nqLsVPrO; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725823; x=1769261823;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=af0DaxV6gEg0cz4KoUno4KNU4bEqf0Z7gl2SqxN9zGQ=;
  b=nqLsVPrOq+8NFi5FtW5e88cJkCTzPl6f96OElVY6AXS44AVNvoE9f35S
   z/wh01Vv1h6k+8JDO93Cw7dVMxxp3UZ4Re/TlcvG5Wqf9HpEpbepgS8j6
   g8q0Cdzc6NN4XshtmKTUnUm7j25jILjhy6sr07glWNY2/9IZCO5Hzlv6r
   dN/Rft4jivHd5/uI+vE7xF4hph6ohNJ7ASirRu/lEO//DYdvQ0lq3RdrL
   Fm6JmWOHfzdBs5MzIIhyUdwuvnIgS1fGJIoSC5cUX+7dJ2i3cJ6tV/Ou4
   8TBUsMQs8SGDI4WgsfW+29T6YML4wEZMsVLU4FmN2f+SzXZhMHURDv+5H
   A==;
X-CSE-ConnectionGUID: /jbZFH8VSj2KOSb2hMnqyQ==
X-CSE-MsgGUID: YldXA/PmRB66wE1MvMe1Bg==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246166"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246166"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:37:02 -0800
X-CSE-ConnectionGUID: m1YELRpEQyCroeMZVOOfMg==
X-CSE-MsgGUID: +wRgE7xvQeC2aFaSV889oA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804081"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:36:58 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	xiaoyao.li@intel.com,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH v7 00/52] QEMU TDX support
Date: Fri, 24 Jan 2025 08:19:56 -0500
Message-Id: <20250124132048.3229049-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the v7 series of TDX QEMU enabling. The series is also available
in github:
https://github.com/intel-staging/qemu-tdx/tree/tdx-qemu-upstream-v7

To boot TD guest, please always use the latest TDX module (1.5) and OVMF
available.

Note, this series has a dependency on
https://lore.kernel.org/qemu-devel/20241217123932.948789-1-xiaoyao.li@intel.com/

=== future work ===
- CPU model

  It now only supports booting TD VM with "-cpu host". It is the only
  case that not supposed to hit any warning/error.

  When using named CPU model, even the same model as host, it likely
  hits warning like some feature not supported or some feature enforced
  on. It's a future work to decide if needs to introduce TDX specific
  named CPU models.

- Attestation support

  Attestation support is dropped in this version becuase KVM side remove
  the support of the related user exit. Atttestation support will be
  submitted separately when KVM regain the support.

- gdb support

  gdb support to debug a TD in off-debug mode is left as future work.

=== Changes in v7 ===
 - Remove patch 40 and 41. Need to re-think on it and will submit them
   later.
 - Patch 44 in v6 is replaced by patch 38 in v7;
 - Patch 45 in v6 is replaced by patch 39 in v7;
 - Drop patch 58 and 59 in v6, since the variant of them is merged
   already;
 - squash some patches into their user patch;
 - For other, please see individual patch for change history;

v6:
https://lore.kernel.org/qemu-devel/20241105062408.3533704-1-xiaoyao.li@intel.com/

Chao Peng (1):
  i386/tdx: load TDVF for TD guest

Isaku Yamahata (4):
  i386/tdx: Make sept_ve_disable set by default
  i386/tdvf: Introduce function to parse TDVF metadata
  i386/tdx: Add TDVF memory via KVM_TDX_INIT_MEM_REGION
  i386/tdx: Don't synchronize guest tsc for TDs

Xiaoyao Li (47):
  *** HACK *** linux-headers: Update headers to pull in TDX API changes
  i386: Introduce tdx-guest object
  i386/tdx: Implement tdx_kvm_type() for TDX
  i386/tdx: Implement tdx_kvm_init() to initialize TDX VM context
  i386/tdx: Get tdx_capabilities via KVM_TDX_CAPABILITIES
  i386/tdx: Introduce is_tdx_vm() helper and cache tdx_guest object
  kvm: Introduce kvm_arch_pre_create_vcpu()
  i386/tdx: Initialize TDX before creating TD vcpus
  i386/tdx: Add property sept-ve-disable for tdx-guest object
  i386/tdx: Wire CPU features up with attributes of TD guest
  i386/tdx: Validate TD attributes
  i386/tdx: Set APIC bus rate to match with what TDX module enforces
  i386/tdx: Implement user specified tsc frequency
  i386/tdx: Parse TDVF metadata for TDX VM
  i386/tdx: Don't initialize pc.rom for TDX VMs
  i386/tdx: Track mem_ptr for each firmware entry of TDVF
  i386/tdx: Track RAM entries for TDX VM
  headers: Add definitions from UEFI spec for volumes, resources, etc...
  i386/tdx: Setup the TD HOB list
  i386/tdx: Call KVM_TDX_INIT_VCPU to initialize TDX vcpu
  i386/tdx: Finalize TDX VM
  i386/tdx: Enable user exit on KVM_HC_MAP_GPA_RANGE
  i386/tdx: Handle KVM_SYSTEM_EVENT_TDX_FATAL
  i386/tdx: Wire TDX_REPORT_FATAL_ERROR with GuestPanic facility
  i386/cpu: introduce x86_confidential_guest_cpu_instance_init()
  i386/tdx: implement tdx_cpu_instance_init()
  i386/cpu: Introduce enable_cpuid_0x1f to force exposing CPUID 0x1f
  i386/tdx: Force exposing CPUID 0x1f
  i386/tdx: Set kvm_readonly_mem_enabled to false for TDX VM
  i386/tdx: Disable SMM for TDX VMs
  i386/tdx: Disable PIC for TDX VMs
  i386/tdx: Only configure MSR_IA32_UCODE_REV in kvm_init_msrs() for TDs
  i386/apic: Skip kvm_apic_put() for TDX
  cpu: Don't set vcpu_dirty when guest_state_protected
  i386/cgs: Rename *mask_cpuid_features() to *adjust_cpuid_features()
  i386/tdx: Implement adjust_cpuid_features() for TDX
  i386/tdx: Apply TDX fixed0 and fixed1 information to supported CPUIDs
  i386/tdx: Mask off CPUID bits by unsupported TD Attributes
  i386/cpu: Move CPUID_XSTATE_XSS_MASK to header file and introduce
    CPUID_XSTATE_MASK
  i386/tdx: Mask off CPUID bits by unsupported XFAM
  i386/tdx: Mark the configurable bit not reported by KVM as unsupported
  i386/cgs: Introduce x86_confidential_guest_check_features()
  i386/tdx: Fetch and validate CPUID of TD guest
  i386/tdx: Don't treat SYSCALL as unavailable
  i386/tdx: Make invtsc default on
  i386/tdx: Validate phys_bits against host value
  docs: Add TDX documentation

 accel/kvm/kvm-all.c                        |   17 +-
 configs/devices/i386-softmmu/default.mak   |    1 +
 docs/system/confidential-guest-support.rst |    1 +
 docs/system/i386/tdx.rst                   |  156 +++
 docs/system/target-i386.rst                |    1 +
 hw/i386/Kconfig                            |    6 +
 hw/i386/kvm/apic.c                         |    5 +
 hw/i386/meson.build                        |    1 +
 hw/i386/pc.c                               |   29 +-
 hw/i386/pc_sysfw.c                         |    7 +
 hw/i386/tdvf-hob.c                         |  130 +++
 hw/i386/tdvf-hob.h                         |   26 +
 hw/i386/tdvf.c                             |  187 +++
 hw/i386/x86-common.c                       |    6 +-
 include/hw/i386/tdvf.h                     |   45 +
 include/standard-headers/uefi/uefi.h       |  187 +++
 include/system/kvm.h                       |    1 +
 linux-headers/asm-x86/kvm.h                |   70 ++
 linux-headers/linux/kvm.h                  |    1 +
 qapi/qom.json                              |   35 +
 qapi/run-state.json                        |   31 +-
 system/runstate.c                          |   67 ++
 target/arm/kvm.c                           |    5 +
 target/i386/confidential-guest.h           |   44 +-
 target/i386/cpu.c                          |   50 +-
 target/i386/cpu.h                          |   27 +
 target/i386/host-cpu.c                     |    2 +-
 target/i386/host-cpu.h                     |    1 +
 target/i386/kvm/kvm.c                      |  114 +-
 target/i386/kvm/kvm_i386.h                 |   15 +
 target/i386/kvm/meson.build                |    2 +
 target/i386/kvm/tdx-stub.c                 |   20 +
 target/i386/kvm/tdx.c                      | 1213 ++++++++++++++++++++
 target/i386/kvm/tdx.h                      |   65 ++
 target/i386/sev.c                          |    9 +-
 target/loongarch/kvm/kvm.c                 |    5 +
 target/mips/kvm.c                          |    5 +
 target/ppc/kvm.c                           |    5 +
 target/riscv/kvm/kvm-cpu.c                 |    5 +
 target/s390x/kvm/kvm.c                     |    5 +
 40 files changed, 2517 insertions(+), 85 deletions(-)
 create mode 100644 docs/system/i386/tdx.rst
 create mode 100644 hw/i386/tdvf-hob.c
 create mode 100644 hw/i386/tdvf-hob.h
 create mode 100644 hw/i386/tdvf.c
 create mode 100644 include/hw/i386/tdvf.h
 create mode 100644 include/standard-headers/uefi/uefi.h
 create mode 100644 target/i386/kvm/tdx-stub.c
 create mode 100644 target/i386/kvm/tdx.c
 create mode 100644 target/i386/kvm/tdx.h

-- 
2.34.1


