Return-Path: <kvm+bounces-668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EF3707E1F30
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:03:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6809AB20B10
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:03:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CE461A58A;
	Mon,  6 Nov 2023 11:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cuabuBTi"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058E7199A1
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:03:43 +0000 (UTC)
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F05FBB
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:03:41 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-507e85ebf50so5315980e87.1
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:03:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268619; x=1699873419; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=s2ZTAIZ3EcP2rWfDpzhdpbAQPKF0BMVTmUIclEXcHBw=;
        b=cuabuBTidQJ1RADeG8blCRV3Zqd3OSs16QbShXgA2rn9CKJEzqz7QO3ka/As0NyVsj
         J6leJ2R+CUymhZheJT2g3aNOr1ogLz18O3rkTq31UF2os0yl1mBYRpdtTqlZLFxjhB/Q
         hJC8rjfn+cGLr1H+oVttYGtG1ZfBc0qOs1cnZ/ghySU8sIae29zySs6ZGML36elzXAMd
         szP7eI7p4nIofl5BS4zYXF93ImVnN2UE19y1DFThPClXGjwJiYtN/b7EUr+qsFktBuZj
         bB5fvVZQIgyY2k2j3X8yIeEP3Tc29DNHIBgKbrihsL9ogBhEAPlPzu8v2b5Ca1IbkM7Y
         Mw3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268619; x=1699873419;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s2ZTAIZ3EcP2rWfDpzhdpbAQPKF0BMVTmUIclEXcHBw=;
        b=EwJXgQNxFItbZ9VxaefwefZcTNKCYIQMph/MNz4PFwAScDGzvH/J7OYmBkkfW0bmtO
         s8YuAD6A7pMIOzbeLDhiD9cn3AfnjOfbCAZ0mk1aX34iibzChwdUJ9Gi54bEqHxX0IRP
         IsgGxYMQdxHJOOnoDmKrJDH+Nwt9RIwWHd7iEZAV40G77AQVKUqv7nWB/7OItlyAX+S+
         yln6x09o7+Xr8T1CybVWw0rSipXtYhUodr8F1xfAHatisnRV0agJAqNW3jwB2LcgL8ju
         CyfnPtXpv20wADDAl4uSBKplKaHzbpUCKLc1Lp/HGpUaMIvn0TuuBbdfe22JrRovF+Ee
         n+KQ==
X-Gm-Message-State: AOJu0YyMfSHp6TS1TKwPYtlO28B7qn+L/AMhdE6tDO+f9+PznsUnRqoF
	HYPtMwCo+Fs9A6Qozl1LUc4/T2CSv0rBJ7t9PvQ=
X-Google-Smtp-Source: AGHT+IGNzLYMSLsslMQga51M3r9N5uuOrws0qA3e9rqVKRKRadV9n0aLe1jaAtSMePpczmUtzjFbew==
X-Received: by 2002:a05:6512:2810:b0:504:30eb:f2ac with SMTP id cf16-20020a056512281000b0050430ebf2acmr25611384lfb.68.1699268619393;
        Mon, 06 Nov 2023 03:03:39 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id j17-20020a056000125100b0032db4e660d9sm9168557wrx.56.2023.11.06.03.03.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:03:39 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-s390x@nongnu.org,
	qemu-block@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PULL 00/60] Misc HW/UI patches for 2023-11-06
Date: Mon,  6 Nov 2023 12:02:32 +0100
Message-ID: <20231106110336.358-1-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

The following changes since commit d762bf97931b58839316b68a570eecc6143c9e3e:

  Merge tag 'pull-target-arm-20231102' of https://git.linaro.org/people/pmaydell/qemu-arm into staging (2023-11-03 10:04:12 +0800)

are available in the Git repository at:

  https://github.com/philmd/qemu.git tags/misc-cpus-20231106

for you to fetch changes up to a81b438ac3933419910cbdf2e2e8d87681de611e:

  ui/sdl2: use correct key names in win title on mac (2023-11-06 11:07:32 +0100)

Few checkpatch warnings in target/i386/hvf/x86_emu.c are deliberately ignored.
----------------------------------------------------------------
Misc hardware patch queue

HW emulation:
- PMBus fixes and tests (Titus)
- IDE fixes and tests (Fiona)
- New ADM1266 sensor (Titus)
- Better error propagation in PCI-ISA i82378 (Philippe)

Topology:
- Fix CPUState::nr_cores calculation (Zhuocheng Ding and Zhao Liu)

Monitor:
- Synchronize CPU state in 'info lapic' (Dongli Zhang)

QOM:
- Have 'cpu-qom.h' target-agnostic (Philippe)
- Call object_class_is_abstract once in cpu_class_by_name (Philippe)

UI:
- Use correct key names in titles on MacOS / SDL2 (Adrian)

MIPS:
- Fix MSA BZ/BNZ and TX79 LQ/SQ opcodes (Philippe)

Nios2:
- Create IRQs *after* vCPU is realized (Philippe)

PPC:
- Restrict KVM objects to system emulation (Philippe)

X86:
- HVF & KVM cleanups (Philippe)

Various targets:
- Use env_archcpu() to optimize (Philippe)

Misc:
- Few global variable shadowing removed (Philippe)
- Introduce cpu_exec_reset_hold and factor tcg_cpu_reset_hold out (Philippe)
- Remove few more 'softmmu' mentions (Philippe)
- Fix and cleanup in vl.c (Akihiko & Marc-André)
- MAINTAINERS updates (Thomas, Daniel)

----------------------------------------------------------------

Adrian Wowk (1):
  ui/sdl2: use correct key names in win title on mac

Akihiko Odaki (1):
  vl: Free machine list

Daniel P. Berrangé (1):
  MAINTAINERS: update libvirt devel mailing list address

Dongli Zhang (1):
  target/i386/monitor: synchronize cpu state for lapic info

Fiona Ebner (2):
  hw/ide: reset: cancel async DMA operation before resetting state
  tests/qtest: ahci-test: add test exposing reset issue with pending
    callback

Marc-André Lureau (1):
  vl: constify default_list

Philippe Mathieu-Daudé (39):
  tests/vm/ubuntu.aarch64: Correct comment about TCG specific delay
  tests/unit/test-seccomp: Remove mentions of softmmu in test names
  accel/tcg: Declare tcg_flush_jmp_cache() in 'exec/tb-flush.h'
  accel: Introduce cpu_exec_reset_hold()
  accel/tcg: Factor tcg_cpu_reset_hold() out
  target: Unify QOM style
  target: Mention 'cpu-qom.h' is target agnostic
  target/arm: Move internal declarations from 'cpu-qom.h' to 'cpu.h'
  target/ppc: Remove CPU_RESOLVING_TYPE from 'cpu-qom.h'
  target/riscv: Remove CPU_RESOLVING_TYPE from 'cpu-qom.h'
  target: Declare FOO_CPU_TYPE_NAME/SUFFIX in 'cpu-qom.h'
  target/hexagon: Declare QOM definitions in 'cpu-qom.h'
  target/loongarch: Declare QOM definitions in 'cpu-qom.h'
  target/nios2: Declare QOM definitions in 'cpu-qom.h'
  target/openrisc: Declare QOM definitions in 'cpu-qom.h'
  target/riscv: Move TYPE_RISCV_CPU_BASE definition to 'cpu.h'
  target/ppc: Use env_archcpu() in helper_book3s_msgsndp()
  target/riscv: Use env_archcpu() in [check_]nanbox()
  target/s390x: Use env_archcpu() in handle_diag_308()
  target/xtensa: Use env_archcpu() in update_c[compare|count]()
  target/i386/hvf: Use x86_cpu in simulate_[rdmsr|wrmsr]()
  target/i386/hvf: Use env_archcpu() in simulate_[rdmsr/wrmsr]()
  target/i386/hvf: Use CPUState typedef
  target/i386/hvf: Rename 'CPUState *cpu' variable as 'cs'
  target/i386/hvf: Rename 'X86CPU *x86_cpu' variable as 'cpu'
  target/i386/kvm: Correct comment in kvm_cpu_realize()
  target/mips: Fix MSA BZ/BNZ opcodes displacement
  target/mips: Fix TX79 LQ/SQ opcodes
  sysemu/kvm: Restrict kvmppc_get_radix_page_info() to ppc targets
  hw/ppc/e500: Restrict ppce500_init_mpic_kvm() to KVM
  target/ppc: Restrict KVM objects to system emulation
  target/ppc: Prohibit target specific KVM prototypes on user emulation
  target/nios2: Create IRQs *after* accelerator vCPU is realized
  target/alpha: Tidy up alpha_cpu_class_by_name()
  hw/cpu: Call object_class_is_abstract() once in cpu_class_by_name()
  exec/cpu: Have cpu_exec_realize() return a boolean
  hw/cpu: Clean up global variable shadowing
  hw/loader: Clean up global variable shadowing in rom_add_file()
  hw/isa/i82378: Propagate error if PC_SPEAKER device creation failed

Thomas Huth (2):
  MAINTAINERS: Add include/hw/timer/tmu012.h to the SH4 R2D section
  MAINTAINERS: Add the CAN documentation file to the CAN section

Zhao Liu (3):
  hw/i386: Fix comment style in topology.h
  tests/unit: Rename test-x86-cpuid.c to test-x86-topo.c
  hw/cpu: Update the comments of nr_cores and nr_dies

Zhuocheng Ding (1):
  system/cpus: Fix CPUState.nr_cores' calculation

titusr@google.com (8):
  hw/i2c: pmbus add support for block receive
  hw/i2c: pmbus: add vout mode bitfields
  hw/i2c: pmbus: add fan support
  hw/i2c: pmbus: add VCAP register
  hw/sensor: add ADM1266 device model
  tests/qtest: add tests for ADM1266
  hw/i2c: pmbus: immediately clear faults on request
  hw/i2c: pmbus: reset page register for out of range reads

 MAINTAINERS                                   |   8 +-
 include/exec/cpu-common.h                     |   3 -
 include/exec/tb-flush.h                       |   2 +
 include/hw/core/cpu.h                         |  20 +-
 include/hw/i2c/pmbus_device.h                 |  17 ++
 include/hw/i386/topology.h                    |  33 +--
 include/hw/loader.h                           |   2 +-
 include/sysemu/accel-ops.h                    |   1 +
 include/sysemu/kvm.h                          |   1 -
 target/alpha/cpu-qom.h                        |   7 +-
 target/alpha/cpu.h                            |   4 -
 target/arm/cpu-qom.h                          |  34 +--
 target/arm/cpu.h                              |  24 +-
 target/arm/internals.h                        |   6 +
 target/avr/cpu-qom.h                          |   8 +-
 target/avr/cpu.h                              |   4 -
 target/cris/cpu-qom.h                         |   7 +-
 target/cris/cpu.h                             |   4 -
 target/hexagon/cpu-qom.h                      |  28 ++
 target/hexagon/cpu.h                          |  20 +-
 target/hppa/cpu-qom.h                         |   4 +-
 target/hppa/cpu.h                             |   2 -
 target/i386/cpu-qom.h                         |   5 +-
 target/i386/cpu.h                             |   5 +-
 target/i386/hvf/x86_emu.h                     |   4 +-
 target/loongarch/cpu-qom.h                    |  24 ++
 target/loongarch/cpu.h                        |  14 +-
 target/m68k/cpu-qom.h                         |   7 +-
 target/m68k/cpu.h                             |   4 -
 target/microblaze/cpu-qom.h                   |   4 +-
 target/microblaze/cpu.h                       |   2 -
 target/mips/cpu-qom.h                         |   5 +-
 target/mips/cpu.h                             |   4 -
 target/nios2/cpu-qom.h                        |  19 ++
 target/nios2/cpu.h                            |  11 +-
 target/openrisc/cpu-qom.h                     |  22 ++
 target/openrisc/cpu.h                         |  14 +-
 target/ppc/cpu-qom.h                          |   3 +-
 target/ppc/cpu.h                              |   4 +-
 target/ppc/kvm_ppc.h                          |   4 +
 target/riscv/cpu-qom.h                        |  12 +-
 target/riscv/cpu.h                            |  10 +-
 target/riscv/internals.h                      |   8 +-
 target/rx/cpu-qom.h                           |   7 +-
 target/rx/cpu.h                               |   4 -
 target/s390x/cpu-qom.h                        |   8 +-
 target/s390x/cpu.h                            |   4 -
 target/sh4/cpu-qom.h                          |   7 +-
 target/sh4/cpu.h                              |   4 -
 target/sparc/cpu-qom.h                        |   7 +-
 target/sparc/cpu.h                            |   4 -
 target/tricore/cpu-qom.h                      |   7 +-
 target/tricore/cpu.h                          |   4 -
 target/xtensa/cpu-qom.h                       |   7 +-
 target/xtensa/cpu.h                           |   4 -
 target/mips/tcg/msa.decode                    |   4 +-
 target/mips/tcg/tx79.decode                   |   2 +-
 accel/stubs/tcg-stub.c                        |   4 -
 accel/tcg/cputlb.c                            |   1 +
 accel/tcg/tcg-accel-ops.c                     |   9 +
 accel/tcg/translate-all.c                     |   8 -
 accel/tcg/user-exec-stub.c                    |   4 +
 cpu-common.c                                  |   6 +-
 cpu-target.c                                  |   6 +-
 hw/core/cpu-common.c                          |  19 +-
 hw/core/loader.c                              |   4 +-
 hw/i2c/pmbus_device.c                         | 237 +++++++++++++++-
 hw/ide/core.c                                 |  14 +-
 hw/isa/i82378.c                               |   4 +-
 hw/ppc/e500.c                                 |   4 +
 hw/sensor/adm1266.c                           | 254 ++++++++++++++++++
 linux-user/main.c                             |   2 +-
 plugins/core.c                                |   1 -
 system/cpus.c                                 |   9 +-
 system/vl.c                                   |   5 +-
 target/alpha/cpu.c                            |  10 +-
 target/arm/cpu.c                              |   3 +-
 target/avr/cpu.c                              |   3 +-
 target/cris/cpu.c                             |   3 +-
 target/hexagon/cpu.c                          |   3 +-
 target/i386/cpu.c                             |   9 +-
 target/i386/hvf/hvf.c                         |   4 +-
 target/i386/hvf/x86_emu.c                     | 111 ++++----
 target/i386/kvm/kvm-cpu.c                     |   1 +
 target/i386/monitor.c                         |   5 +
 target/loongarch/cpu.c                        |   3 +-
 target/m68k/cpu.c                             |   3 +-
 target/nios2/cpu.c                            |  16 +-
 target/openrisc/cpu.c                         |   3 +-
 target/ppc/excp_helper.c                      |   2 +-
 target/ppc/kvm-stub.c                         |  19 --
 target/ppc/kvm.c                              |   4 +-
 target/riscv/cpu.c                            |   3 +-
 target/rx/cpu.c                               |   6 +-
 target/s390x/cpu_models.c                     |   2 +-
 target/s390x/diag.c                           |   2 +-
 target/sh4/cpu.c                              |   3 -
 target/tricore/cpu.c                          |   3 +-
 target/xtensa/cpu.c                           |   3 +-
 target/xtensa/op_helper.c                     |   4 +-
 tests/qtest/adm1266-test.c                    | 122 +++++++++
 tests/qtest/ahci-test.c                       |  86 +++++-
 tests/qtest/max34451-test.c                   |  24 ++
 tests/unit/test-seccomp.c                     |  24 +-
 .../{test-x86-cpuid.c => test-x86-topo.c}     |   2 +-
 ui/sdl2.c                                     |   8 +
 hw/arm/Kconfig                                |   1 +
 hw/sensor/Kconfig                             |   5 +
 hw/sensor/meson.build                         |   1 +
 target/ppc/meson.build                        |   2 +-
 tests/qtest/meson.build                       |   1 +
 tests/unit/meson.build                        |   4 +-
 tests/vm/ubuntu.aarch64                       |   2 +-
 113 files changed, 1162 insertions(+), 436 deletions(-)
 create mode 100644 target/hexagon/cpu-qom.h
 create mode 100644 target/loongarch/cpu-qom.h
 create mode 100644 target/nios2/cpu-qom.h
 create mode 100644 target/openrisc/cpu-qom.h
 create mode 100644 hw/sensor/adm1266.c
 delete mode 100644 target/ppc/kvm-stub.c
 create mode 100644 tests/qtest/adm1266-test.c
 rename tests/unit/{test-x86-cpuid.c => test-x86-topo.c} (99%)

-- 
2.41.0


