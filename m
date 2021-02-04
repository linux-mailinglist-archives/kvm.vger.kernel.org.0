Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A51230EC14
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 06:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbhBDFeC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 00:34:02 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:38827 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbhBDFd7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 00:33:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612416838; x=1643952838;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=20GUJPs0xyqN+1X8CUwsioLenuUNs3sUWwKF/m/Mk9Y=;
  b=p4yaqB2PxgzGYeWbUZxufrfBz7e1OeBZ9RJBJexX1wHnWGm/YYbeFScl
   d6F61RIIrSFciNdM6Qmx/f8urloQQKB4s7Z5PZw6+KlKfBacRC5Vh1788
   v+jvgFFGh6V6znBz2qsw75lfsM4dNOfJyRD3gV4hV2mNCnIl1lcwtz+fe
   0AANyQ3W1RS6NXZjECIL4i6EXdR+chgGUIcvEYTRa7bfy1AFkFZ5IUK1t
   w/ZapTXQfKH1DslkYFmXkRqHJ83UnorO+VM2p/z7sOeM0jVtCGcTsO1nr
   JuDdw3oP8P8ACIbddcfBqn0mzF1TWsuh6VpMiWmJy8FT8uiuaypPaif9w
   g==;
IronPort-SDR: seXQQEioeE7HRMTe6vg8MmP5TuN9qB8sRCqrHzhXOEeKKhek8gz6T9WccNDOFRWlA2gZomWTQS
 FE8wS4nzzPkDbjav87WRsdlR878ndj84OEiMjHlOHke4SFDKtqWA5R1y9TTmaS2WnwSgMQUR06
 36ShjSarMcGPHAsTA/d8TrDfT7CjyyEK+iIbDsDEmhDpEKN8fXjRunzsQStttaKuuCkYs2Br1C
 S44JPX4J/2bF39J2uvly7Imk00V1NiQFtTlvdtSKDwWmgWQR1CeJAmem46oXgw19epqtMJKQoy
 tlo=
X-IronPort-AV: E=Sophos;i="5.79,400,1602518400"; 
   d="scan'208";a="159086429"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2021 13:32:53 +0800
IronPort-SDR: 73oREEvUI6kSAfKFCfpaLH+9dS0vfMqpSFHJw6yYQauYgEaS5bvGbau9Ay01zs2y8r19rM1O9k
 ub9n4xYxB8xKHD1xsXaJaGtwrbfRemxISTjrMrz6yvwzkdA3TFLBZRUXBkcB8SGofqgx2k+Dm/
 vVlxF17t2ezOUABxdwokkJk1+6FRLP85oj3Ndt88eNokfJTjAv2hRbUbmxoFV/xu+3khIXJsDv
 TjrQ32t7cCth2+WlRVHcY7X8svnEhwOhbjSOUJelRTpQz+GIBljYrxznjE+xdddAcmeVyqgcWV
 qigmNXFp1xeFh5VsDdxNNH1Q
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 21:16:53 -0800
IronPort-SDR: /PPwS0VvJF+wkXfdg85sqhiMnov/J2WUM+ZcZeMpj7Oy/VR1taKs8zTdU2Zgkbp0Qpag7T8Efe
 /FCe9i/YXycJ9hbVk3o2oJsLfVpqZTukVrhD8tCO9JxVV42JfdN/FK/GmODHyqo97074r/3K2L
 qdRk2b0AEUEWkl7JUuNHSiHNjmPAG0bK5ucvPOIV1by4hoQkxyQzc73hN38QAob/H18LO1n8nb
 fNzv9cMCSTcaUSbVKmYCbm46fkqNhD4uJLR7UYrnOVF4F4RNo2aeJZwhHLc1/2ZYq17W/oR8+f
 RTY=
WDCIronportException: Internal
Received: from cnf008142.ad.shared (HELO jedi-01.hgst.com) ([10.86.63.165])
  by uls-op-cesaip02.wdc.com with ESMTP; 03 Feb 2021 21:32:53 -0800
From:   Atish Patra <atish.patra@wdc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atish.patra@wdc.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup.patel@wdc.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>
Subject: [PATCH v2 0/6] Add SBI v0.2 support for KVM
Date:   Wed,  3 Feb 2021 21:32:33 -0800
Message-Id: <20210204053239.1609558-1-atish.patra@wdc.com>
X-Mailer: git-send-email 2.25.1
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
4. SBI Reset extension in KVM

This series depends on the base kvm support series v16[2].

Guest kernel needs to also support SBI v0.2 and HSM extension in Kernel
to boot multiple vcpus. Linux kernel supports both starting v5.7.
In absense of that, guest can only boot 1 vcpu.

Changes from v1->v2:
1. Sent the patch 1 separately as it can merged independently.
2. Added Reset extension functionality.

Tested on Qemu and FPGA with Rocket core design.

[1] https://github.com/riscv/riscv-sbi-doc/blob/master/riscv-sbi.adoc
[2] http://lists.infradead.org/pipermail/linux-riscv/2021-January/004251.html

Atish Patra (6):
RISC-V: Mark the existing SBI v0.1 implementation as legacy
RISC-V: Reorganize SBI code by moving legacy SBI to its own file
RISC-V: Add SBI v0.2 base extension
RISC-V: Add v0.1 replacement SBI extensions defined in v02
RISC-V: Add SBI HSM extension in KVM
RISC-V: Add SBI RESET extension in KVM

arch/riscv/include/asm/kvm_vcpu_sbi.h |  33 +++++
arch/riscv/include/asm/sbi.h          |   9 ++
arch/riscv/kvm/Makefile               |   4 +-
arch/riscv/kvm/vcpu.c                 |  19 +++
arch/riscv/kvm/vcpu_sbi.c             | 189 +++++++++++++-------------
arch/riscv/kvm/vcpu_sbi_base.c        |  73 ++++++++++
arch/riscv/kvm/vcpu_sbi_hsm.c         | 109 +++++++++++++++
arch/riscv/kvm/vcpu_sbi_legacy.c      | 114 ++++++++++++++++
arch/riscv/kvm/vcpu_sbi_replace.c     | 180 ++++++++++++++++++++++++
9 files changed, 635 insertions(+), 95 deletions(-)
create mode 100644 arch/riscv/include/asm/kvm_vcpu_sbi.h
create mode 100644 arch/riscv/kvm/vcpu_sbi_base.c
create mode 100644 arch/riscv/kvm/vcpu_sbi_hsm.c
create mode 100644 arch/riscv/kvm/vcpu_sbi_legacy.c
create mode 100644 arch/riscv/kvm/vcpu_sbi_replace.c

--
2.25.1

