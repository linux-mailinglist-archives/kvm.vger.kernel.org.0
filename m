Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 065A02EE859
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728136AbhAGWXh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:23:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727888AbhAGWXh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:23:37 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE91FC0612F4
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:22:56 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id k10so6358049wmi.3
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:22:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CVOh3zHgwfBfd1YKdXDSVA4owP2D+qRdHedUeP9R50U=;
        b=j9p+gJSAIiUrYLg64VSGmdFyNxwbA5nXjEK0O1lI9b4hBwaeeTSvHT3i86e72dHpAi
         WKY+wFe5vPLnuz+y9Z3WOUfn3vZlBNtK3Hj2uCXFmHND6WS6AQ5M7gOauPDY9mA6tokJ
         N4mGOCo7WMeh6146OUhXLIgpYD78CPlL0Rx+Jvjw+Rf2q7DMGyBh4zkKn1CfSjMn0PXo
         NXjEbaZDHB4WVZzklgMPsK5DthHD5Ed4BdMF0BlkMasWkIXGxKbDSWfZqPFPTZbXLYn+
         rdIdrO/ZKfBfIW6It0Cbj7wvoMRb4q/lJJmk8ooflkpDK7oL2OrLVSsqRn3M8rSKlKjW
         JS4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=CVOh3zHgwfBfd1YKdXDSVA4owP2D+qRdHedUeP9R50U=;
        b=EzNeUj4pUXj7ZrYmRGJMIj93dUJwf2+NGNZ2ey/GtiCdFOh0A5iWG168boBB9B+27Y
         qY16/n+q8FKVaVFCB3Iz2YTMBbBf6ky4bJeH7Im7PxDs1YJfln2EgUb8BzrBzcmR14+J
         CVqTOEb42uRS083JgNL2f9IsagbdsW8cI84nHAy6ocHVARV3wFGVz0DD+N9vKv2EKmWR
         PjzEWGuD6xPqdRMQqVzZos7TyETKJdvGFgS8FrDfAK+LOzt4j5jvuVZ0HzG0kazZffFB
         lVnK5Sa4wLMZ8FoPLfxV1kwkKgpwntprFlWjWgH4bTz1IBskgVnLEOqeu5fISEziU/ez
         gK2g==
X-Gm-Message-State: AOAM533RAvZ1X/GLfJV9buGC8zLHfULJmz87wHIE2t1qbzpoixE+yhqo
        4Ek+COiDAY8O5Gz5Lk/0ojrnSw2g+LM=
X-Google-Smtp-Source: ABdhPJz9HrYiMVU3ybn2w0SEfyu/2liRpw1SQvQFcdd9PtavU0ZgtWeJ3iLLBv5u/q1xHkXrB8WXoA==
X-Received: by 2002:a1c:e0d4:: with SMTP id x203mr537320wmg.68.1610058175749;
        Thu, 07 Jan 2021 14:22:55 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id i16sm10175060wrx.89.2021.01.07.14.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:22:55 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     libvir-list@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>, kvm@vger.kernel.org,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paul Burton <paulburton@kernel.org>
Subject: [PULL 00/66] MIPS patches for 2021-01-07
Date:   Thu,  7 Jan 2021 23:21:47 +0100
Message-Id: <20210107222253.20382-1-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 470dd6bd360782f5137f7e3376af6a44658eb1d3=
:=0D
=0D
  Merge remote-tracking branch 'remotes/stsquad/tags/pull-testing-060121-4'=
 into staging (2021-01-06 22:18:36 +0000)=0D
=0D
are available in the Git repository at:=0D
=0D
  https://gitlab.com/philmd/qemu.git tags/mips-20210107=0D
=0D
for you to fetch changes up to f97d339d612b86d8d336a11f01719a10893d6707:=0D
=0D
  docs/system: Remove deprecated 'fulong2e' machine alias (2021-01-07 22:57=
:49 +0100)=0D
=0D
----------------------------------------------------------------=0D
MIPS patches queue=0D
=0D
- Simplify CPU/ISA definitions=0D
- Various maintenance code movements in translate.c=0D
- Convert part of the MSA ASE instructions to decodetree=0D
- Convert some instructions removed from Release 6 to decodetree=0D
- Remove deprecated 'fulong2e' machine alias=0D
=0D
----------------------------------------------------------------=0D
=0D
Jiaxun Yang (1):=0D
  target/mips/addr: Add translation helpers for KSEG1=0D
=0D
Philippe Mathieu-Daud=C3=A9 (65):=0D
  target/mips: Add CP0 Config0 register definitions for MIPS3 ISA=0D
  target/mips: Replace CP0_Config0 magic values by proper definitions=0D
  target/mips/mips-defs: Remove USE_HOST_FLOAT_REGS comment=0D
  target/mips/mips-defs: Reorder CPU_MIPS5 definition=0D
  target/mips/mips-defs: Rename CPU_MIPSxx Release 1 as CPU_MIPSxxR1=0D
  target/mips/mips-defs: Introduce CPU_MIPS64 and cpu_type_is_64bit()=0D
  hw/mips/boston: Check 64-bit support with cpu_type_is_64bit()=0D
  target/mips/mips-defs: Use ISA_MIPS32 definition to check Release 1=0D
  target/mips/mips-defs: Use ISA_MIPS32R2 definition to check Release 2=0D
  target/mips/mips-defs: Use ISA_MIPS32R3 definition to check Release 3=0D
  target/mips/mips-defs: Use ISA_MIPS32R5 definition to check Release 5=0D
  target/mips/mips-defs: Use ISA_MIPS32R6 definition to check Release 6=0D
  target/mips/mips-defs: Rename ISA_MIPS32 as ISA_MIPS_R1=0D
  target/mips/mips-defs: Rename ISA_MIPS32R2 as ISA_MIPS_R2=0D
  target/mips/mips-defs: Rename ISA_MIPS32R3 as ISA_MIPS_R3=0D
  target/mips/mips-defs: Rename ISA_MIPS32R5 as ISA_MIPS_R5=0D
  target/mips/mips-defs: Rename ISA_MIPS32R6 as ISA_MIPS_R6=0D
  target/mips: Inline cpu_state_reset() in mips_cpu_reset()=0D
  target/mips: Extract FPU helpers to 'fpu_helper.h'=0D
  target/mips: Add !CONFIG_USER_ONLY comment after #endif=0D
  target/mips: Remove consecutive CONFIG_USER_ONLY ifdefs=0D
  target/mips: Move common helpers from helper.c to cpu.c=0D
  target/mips: Rename helper.c as tlb_helper.c=0D
  target/mips: Fix code style for checkpatch.pl=0D
  target/mips: Move mmu_init() functions to tlb_helper.c=0D
  target/mips: Rename translate_init.c as cpu-defs.c=0D
  target/mips/translate: Extract DisasContext structure=0D
  target/mips/translate: Add declarations for generic code=0D
  target/mips: Replace gen_exception_err(err=3D0) by gen_exception_end()=0D
  target/mips: Replace gen_exception_end(EXCP_RI) by=0D
    gen_rsvd_instruction=0D
  target/mips: Declare generic FPU functions in 'translate.h'=0D
  target/mips: Extract FPU specific definitions to translate.h=0D
  target/mips: Only build TCG code when CONFIG_TCG is set=0D
  target/mips/translate: Extract decode_opc_legacy() from decode_opc()=0D
  target/mips/translate: Expose check_mips_64() to 32-bit mode=0D
  target/mips: Introduce ase_msa_available() helper=0D
  target/mips: Simplify msa_reset()=0D
  target/mips: Use CP0_Config3 to set MIPS_HFLAG_MSA=0D
  target/mips: Simplify MSA TCG logic=0D
  target/mips: Remove now unused ASE_MSA definition=0D
  target/mips: Alias MSA vector registers on FPU scalar registers=0D
  target/mips: Extract msa_translate_init() from mips_tcg_init()=0D
  target/mips: Remove CPUMIPSState* argument from gen_msa*() methods=0D
  target/mips: Explode gen_msa_branch() as gen_msa_BxZ_V/BxZ()=0D
  target/mips: Move msa_reset() to msa_helper.c=0D
  target/mips: Extract MSA helpers from op_helper.c=0D
  target/mips: Extract MSA helper definitions=0D
  target/mips: Declare gen_msa/_branch() in 'translate.h'=0D
  target/mips: Extract MSA translation routines=0D
  target/mips: Pass TCGCond argument to MSA gen_check_zero_element()=0D
  target/mips: Introduce decode tree bindings for MSA ASE=0D
  target/mips: Use decode_ase_msa() generated from decodetree=0D
  target/mips: Extract LSA/DLSA translation generators=0D
  target/mips: Introduce decodetree helpers for MSA LSA/DLSA opcodes=0D
  target/mips: Introduce decodetree helpers for Release6 LSA/DLSA=0D
    opcodes=0D
  target/mips: Remove now unreachable LSA/DLSA opcodes code=0D
  target/mips: Convert Rel6 Special2 opcode to decodetree=0D
  target/mips: Convert Rel6 COP1X opcode to decodetree=0D
  target/mips: Convert Rel6 CACHE/PREF opcodes to decodetree=0D
  target/mips: Convert Rel6 LWL/LWR/SWL/SWR opcodes to decodetree=0D
  target/mips: Convert Rel6 LWLE/LWRE/SWLE/SWRE opcodes to decodetree=0D
  target/mips: Convert Rel6 LDL/LDR/SDL/SDR opcodes to decodetree=0D
  target/mips: Convert Rel6 LLD/SCD opcodes to decodetree=0D
  target/mips: Convert Rel6 LL/SC opcodes to decodetree=0D
  docs/system: Remove deprecated 'fulong2e' machine alias=0D
=0D
 docs/system/deprecated.rst                    |    5 -=0D
 docs/system/removed-features.rst              |    5 +=0D
 target/mips/cpu.h                             |   23 +-=0D
 target/mips/fpu_helper.h                      |   59 +=0D
 target/mips/helper.h                          |  436 +-=0D
 target/mips/internal.h                        |   64 +-=0D
 target/mips/mips-defs.h                       |   47 +-=0D
 target/mips/translate.h                       |  168 +=0D
 target/mips/msa_helper.h.inc                  |  443 ++=0D
 target/mips/mips32r6.decode                   |   36 +=0D
 target/mips/mips64r6.decode                   |   26 +=0D
 target/mips/msa32.decode                      |   28 +=0D
 target/mips/msa64.decode                      |   17 +=0D
 hw/mips/boston.c                              |    6 +-=0D
 hw/mips/fuloong2e.c                           |    1 -=0D
 linux-user/mips/cpu_loop.c                    |    7 +-=0D
 target/mips/addr.c                            |   10 +=0D
 target/mips/cp0_helper.c                      |   18 +-=0D
 target/mips/cp0_timer.c                       |    4 +-=0D
 target/mips/cpu.c                             |  255 +-=0D
 target/mips/fpu_helper.c                      |    5 +-=0D
 target/mips/gdbstub.c                         |    1 +=0D
 target/mips/kvm.c                             |   13 +-=0D
 target/mips/machine.c                         |    1 +=0D
 target/mips/msa_helper.c                      |  430 ++=0D
 target/mips/msa_translate.c                   | 2286 ++++++++++=0D
 target/mips/op_helper.c                       |  396 +-=0D
 target/mips/rel6_translate.c                  |   44 +=0D
 target/mips/{helper.c =3D> tlb_helper.c}        |  266 +-=0D
 target/mips/translate.c                       | 3839 +++--------------=0D
 target/mips/translate_addr_const.c            |   61 +=0D
 .../{translate_init.c.inc =3D> cpu-defs.c.inc}  |  114 +-=0D
 target/mips/meson.build                       |   21 +-=0D
 33 files changed, 4727 insertions(+), 4408 deletions(-)=0D
 create mode 100644 target/mips/fpu_helper.h=0D
 create mode 100644 target/mips/translate.h=0D
 create mode 100644 target/mips/msa_helper.h.inc=0D
 create mode 100644 target/mips/mips32r6.decode=0D
 create mode 100644 target/mips/mips64r6.decode=0D
 create mode 100644 target/mips/msa32.decode=0D
 create mode 100644 target/mips/msa64.decode=0D
 create mode 100644 target/mips/msa_translate.c=0D
 create mode 100644 target/mips/rel6_translate.c=0D
 rename target/mips/{helper.c =3D> tlb_helper.c} (87%)=0D
 create mode 100644 target/mips/translate_addr_const.c=0D
 rename target/mips/{translate_init.c.inc =3D> cpu-defs.c.inc} (92%)=0D
=0D
-- =0D
2.26.2=0D
=0D
