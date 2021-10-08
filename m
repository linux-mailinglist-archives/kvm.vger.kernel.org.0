Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631234262DA
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 05:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236304AbhJHDWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 23:22:40 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:10087 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236409AbhJHDWg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Oct 2021 23:22:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1633663241; x=1665199241;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=r5rxc6zMPQ2DYaQEjqFn2bycJ2e7Cu+Jo2WU4mJ233A=;
  b=i1ztuj4YI5wTZgazNluIMWqzOzmEz/IxMgMwxTfuBtpTHhZR6y/PeyM/
   nt3jw1CDUvipc00zc7EBhGlWfltcOl7SJjWvpH5+T4zIYRU6SvlF7zlaL
   JApV2FnXSYeEEJ2qN2dQQw4DLNA12RwOMvuo5v3uNByukDgmE9KdWqDA9
   Zz6OWfL2ScJli+8D6lu71WA/F7zCUIDq3bUip8ut0CYnqpw8DsRQ9l7pp
   YeztF5/Pr3v7XeBZiuAeFcsdtaB37wmAgGpUOahoqKS2thjlyMZbo9dkp
   1x1qFvYJo2125xoOgL0GZvYOlx2oinnUs4LqLm/MvR9xf2bAu/XMWuVTJ
   A==;
X-IronPort-AV: E=Sophos;i="5.85,356,1624291200"; 
   d="scan'208";a="182972378"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 08 Oct 2021 11:20:39 +0800
IronPort-SDR: CAcdaqfH0E9b3ipvcn/E4lg7PuDpbfiI5XNZ9KRxe+YJ+xFiYcKglhKsNjN5Wx6vpOqS24WT8j
 HR+JBaqI0OzZnxdu9YeW8Ln0U8EIIUfKB6qnJbb6PLEWcynOsDYRosffxk9r1MKya6L0enYxlp
 1jCMY2rplN24LA0QsCcv1ZQ1V35IJ8kWZb0KU/dGMm3ceBTMTk8CTfdbjyQ2X96Rjbrjk5QT+w
 q4QhcA2Bw36l9bVl0Bn7YKJxmiYLn5MY0iHA0iaFMCPZVUVjhEqNaIgutOgbHRtT9rvozyKxWM
 1ngt22FXBGFKujOsbhlTNG0B
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 19:56:32 -0700
IronPort-SDR: ZtCQf6or+fC78Z8QZyBs2K0CO7y3mLxtVHF9x5BnCMI3DlUT1RwacAAl+r7LdltpsHJ5znnwtm
 FfzQYGfAj314iIzIKa8g/A+mV5TquECZkTe5UzqpjpLEvLdoVmGCcMP65Dlb4q8Rm6WNRI6dRm
 /TOCGV80jcIKPRHKpvjDzIJxTLUSugb4jrFMGOuul/0NXcVN5Zebmlyhwqzi55s9tbouyOPEdT
 i/nNtgHEJUNa6jIiOA3SoC/CSfkExJc5XI6wHbQP54nWqbSrt0VZbR3nJS0G8N/Fi8YYS6XzY5
 7yY=
WDCIronportException: Internal
Received: from unknown (HELO hulk.wdc.com) ([10.225.167.125])
  by uls-op-cesaip02.wdc.com with ESMTP; 07 Oct 2021 20:20:39 -0700
From:   Atish Patra <atish.patra@wdc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atish.patra@wdc.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anup Patel <anup.patel@wdc.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Vincent Chen <vincent.chen@sifive.com>
Subject: [PATCH v3 0/5] Add SBI v0.2 support for KVM
Date:   Thu,  7 Oct 2021 20:20:31 -0700
Message-Id: <20211008032036.2201971-1-atish.patra@wdc.com>
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

Changes from v2->v3:
1. Rebased on the latest merged kvm series.
2. Dropped the reset extension patch because reset extension is not merged in kernel. 
However, my tree[3] still contains it in case anybody wants to test it.

Changes from v1->v2:
1. Sent the patch 1 separately as it can merged independently.
2. Added Reset extension functionality.

Tested on Qemu and Rocket core FPGA.

[1] https://github.com/riscv/riscv-sbi-doc/blob/master/riscv-sbi.adoc
[2] https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=next
[3] https://github.com/atishp04/linux/tree/kvm_next_sbi_v02_reset
[4] https://github.com/atishp04/linux/tree/kvm_next_sbi_v02

Atish Patra (5):
RISC-V: Mark the existing SBI v0.1 implementation as legacy
RISC-V: Reorganize SBI code by moving legacy SBI to its own file
RISC-V: Add SBI v0.2 base extension
RISC-V: Add v0.1 replacement SBI extensions defined in v02
RISC-V: Add SBI HSM extension in KVM

arch/riscv/include/asm/kvm_vcpu_sbi.h |  33 ++++
arch/riscv/include/asm/sbi.h          |   9 ++
arch/riscv/kvm/Makefile               |   4 +
arch/riscv/kvm/vcpu.c                 |  19 +++
arch/riscv/kvm/vcpu_sbi.c             | 208 ++++++++++++--------------
arch/riscv/kvm/vcpu_sbi_base.c        |  73 +++++++++
arch/riscv/kvm/vcpu_sbi_hsm.c         | 109 ++++++++++++++
arch/riscv/kvm/vcpu_sbi_legacy.c      | 129 ++++++++++++++++
arch/riscv/kvm/vcpu_sbi_replace.c     | 136 +++++++++++++++++
9 files changed, 608 insertions(+), 112 deletions(-)
create mode 100644 arch/riscv/include/asm/kvm_vcpu_sbi.h
create mode 100644 arch/riscv/kvm/vcpu_sbi_base.c
create mode 100644 arch/riscv/kvm/vcpu_sbi_hsm.c
create mode 100644 arch/riscv/kvm/vcpu_sbi_legacy.c
create mode 100644 arch/riscv/kvm/vcpu_sbi_replace.c

--
2.31.1

