Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17BF446B66
	for <lists+kvm@lfdr.de>; Sat,  6 Nov 2021 00:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbhKFABn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 20:01:43 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:4775 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbhKFABm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Nov 2021 20:01:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636156740; x=1667692740;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=99tlQEW6k3Si5SmCi7kC9BJb5Z29vH7T9LwAGl2NsGA=;
  b=TNzYxJLymz+dQU54aQ7dEL7wxUlc90yPp/p3/sdynWwSCLaLrRbgc5Nl
   vTYYm6M94070Rb6UibXDL1WJgf/TkiG/IoVaHlDOnfR3aHlNB8rOfVYPB
   SHv4kIr+g0TqmMoS4zkGRjiqqtXY8vbsqykdrwHAdf9LZdQDV8xwl61Xx
   Zsfvl1HwjepShNkEG9pY/GLZVkvdZP4+oe8gnhWaIpQv9sIwZyqxJ13G8
   FARAf+X5qcT+7y3FvH+bOpO51v9ezSsA4mTJrTkvaBFey02cZPVajoEQa
   IkUWcj+WVz55bbhTkBz1hV5jUl0h9da5+b7rg9ChJzd0xLgDZNRE8VAzi
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,212,1631548800"; 
   d="scan'208";a="189637757"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Nov 2021 07:58:59 +0800
IronPort-SDR: tpPdT7I7QRjQCapy5EBR/qH5XrGutVGU9/oMVnsZFeTjiNCx/MYsLx3u8qicwIPI+ke+KzO+s2
 bGxot8Nsk/L6L/M1av8/61L8xkZYvMCk+H/FbInmKUjkKZGTAXZcN2/2CX0lIeffbHIxOo19Qr
 xtRz+fXGCoR1S9gqYZyZIdem4gFgX+V3aXsySAhQ9E8I8HYaaJHjuPw+XJdJtoEHsdrrRDkxsX
 VEk5zxOx27gd/ObWX6ALG9hdZwtE2cBxpaBnus6WUzXMOA2JoyBbKm5phxCgPQikpcpMf6pBeJ
 SbgFzkMYiMwpHylTADgosUHi
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2021 16:32:45 -0700
IronPort-SDR: Mp7jK/DwqabApqMFT4YQ7uvsQsRaOpx8l+aziVIk3tgrEOjpwBNQRlOwK1xks2tETfJheuqooL
 ijNN7igjkGgsosM5ZsHurYMnUSeepWtvRpHvt6E8b3qf6y49Ibxn2F9bhvZUJo2KyMH7pPikYi
 yOdTIGXQ73LfH2/w6z3zXS4S5mFU9dtstzhu0tgZnkiWYpbHUDOdh9xG9pXI3An40sXrvnT3sa
 Jua4FPQUjNqLzEPG0iDM7TdAqzI+JD716RII9ttKBG7jnB3xGkL4BvJ25nX40vfTXrepP8dtPq
 bPk=
WDCIronportException: Internal
Received: from unknown (HELO hulk.wdc.com) ([10.225.167.48])
  by uls-op-cesaip02.wdc.com with ESMTP; 05 Nov 2021 16:59:01 -0700
From:   Atish Patra <atish.patra@wdc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atish.patra@wdc.com>, Anup Patel <anup.patel@wdc.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Vincent Chen <vincent.chen@sifive.com>, pbonzini@redhat.com,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH v4 0/5] Add SBI v0.2 support for KVM
Date:   Fri,  5 Nov 2021 16:58:47 -0700
Message-Id: <20211105235852.3011900-1-atish.patra@wdc.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Supervisor Binary Interface(SBI) specification[1] now defines a
base extension that provides extendability to add future extensions
while maintaining backward compatibility with previous versions.
The new version is defined as 0.2 and older version is marked as 0.1.

This series adds following features to RISC-V Linux KVM.
1. Adds support for SBI v0.2 in KVM
2. SBI Hart state management extension (HSM) in KVM
3. Ordered booting of guest vcpus in guest Linux

This series is based on base KVM series which is already part of the kvm-next[2]. 

Guest kernel needs to also support SBI v0.2 and HSM extension in Kernel
to boot multiple vcpus. Linux kernel supports both starting v5.7.
In absense of that, guest can only boot 1 vcpu.

Changes from v3->v4:
1. Fixed the commit text title.
2. Removed a redundant memory barrier from patch 4.
3. Replaced preempt_enable/disable with get_cpu/put_cpu.
4. Renamed the exixting implementation as v01 instead of legacy.

Changes from v2->v3:
1. Rebased on the latest merged kvm series.
2. Dropped the reset extension patch because reset extension is not merged in kernel. 
However, my tree[3] still contains it in case anybody wants to test it.

Changes from v1->v2:
1. Sent the patch 1 separately as it can merged independently.
2. Added Reset extension functionality.

Tested on Qemu and Rocket core FPGA.

[1] https://github.com/riscv/riscv-sbi-doc/blob/master/riscv-sbi.adoc
[3] https://github.com/atishp04/linux/tree/kvm_sbi_v03_reset
[4] https://github.com/atishp04/linux/tree/kvm_sbi_v03

Atish Patra (5):
RISC-V: KVM: Mark the existing SBI implementation as v01
RISC-V: KVM: Reorganize SBI code by moving SBI v0.1 to its own file
RISC-V: KVM: Add SBI v0.2 base extension
RISC-V: KVM: Add v0.1 replacement SBI extensions defined in v02
RISC-V: KVM: Add SBI HSM extension in KVM

arch/riscv/include/asm/kvm_vcpu_sbi.h |  33 +++++
arch/riscv/include/asm/sbi.h          |   9 ++
arch/riscv/kvm/Makefile               |   4 +
arch/riscv/kvm/vcpu.c                 |  23 +++
arch/riscv/kvm/vcpu_sbi.c             | 206 ++++++++++++--------------
arch/riscv/kvm/vcpu_sbi_base.c        |  73 +++++++++
arch/riscv/kvm/vcpu_sbi_hsm.c         | 107 +++++++++++++
arch/riscv/kvm/vcpu_sbi_replace.c     | 136 +++++++++++++++++
arch/riscv/kvm/vcpu_sbi_v01.c         | 129 ++++++++++++++++
9 files changed, 609 insertions(+), 111 deletions(-)
create mode 100644 arch/riscv/include/asm/kvm_vcpu_sbi.h
create mode 100644 arch/riscv/kvm/vcpu_sbi_base.c
create mode 100644 arch/riscv/kvm/vcpu_sbi_hsm.c
create mode 100644 arch/riscv/kvm/vcpu_sbi_replace.c
create mode 100644 arch/riscv/kvm/vcpu_sbi_v01.c

--
2.31.1

