Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2B326E8E30
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 11:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234316AbjDTJgq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 05:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234174AbjDTJg2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 05:36:28 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3BD881707
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 02:36:08 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8AxrtqHB0FksHEfAA--.37262S3;
        Thu, 20 Apr 2023 17:36:07 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxwOSGB0FkUfEwAA--.29752S2;
        Thu, 20 Apr 2023 17:36:06 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, gaosong@loongson.cn
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, maobibo@loongson.cn,
        zhaotianrui@loongson.cn
Subject: [PATCH RFC v1 00/10] Add loongarch kvm accel support
Date:   Thu, 20 Apr 2023 17:35:56 +0800
Message-Id: <20230420093606.3366969-1-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8DxwOSGB0FkUfEwAA--.29752S2
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoWxXF4DZFykKFWxCF43uw45Wrg_yoW5WFy7pF
        W7uFn8Kr4rJ397Jws5Xas8Xr45Xr4xGr9Fv3WftryxCrZrArykZFyvk39IgFW7Aa4UJFy0
        qFy8Aw1UW3WUX3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        b0xFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
        0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xAC
        xx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6x8ErcxFaVAv8VWrMcvjeVCFs4IE7xkEbV
        WUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx2
        6rWl4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
        xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
        cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
        AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E
        14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvj4RC_MaUUUUU
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series add loongarch kvm support, mainly implement
some interfaces used by kvm such as kvm_arch_get/set_regs,
kvm_arch_handle_exit, kvm_loongarch_set_interrupt, etc.

Currently, we are able to boot LoongArch KVM Linux Guests.
In loongarch VM, mmio devices and iocsr devices are emulated
in user space such as APIC, IPI, pci devices, etc, other
hardwares such as MMU, timer and csr are emulated in kernel.

It is based on temporarily unaccepted linux kvm:
https://github.com/loongson/linux-loongarch-kvm
And We will remove the RFC flag until the linux kvm patches
are merged.

The running environment of LoongArch virt machine:
1. Get the linux source by the above mentioned link.
   git checkout kvm-loongarch
   make ARCH=loongarch CROSS_COMPILE=loongarch64-unknown-linux-gnu- loongson3_defconfig
   make ARCH=loongarch CROSS_COMPILE=loongarch64-unknown-linux-gnu-
2. Get the qemu source: https://github.com/loongson/qemu
   git checkout kvm-loongarch
   ./configure --target-list="loongarch64-softmmu"  --enable-kvm
   make
3. Get uefi bios of LoongArch virt machine:
   Link: https://github.com/tianocore/edk2-platforms/tree/master/Platform/Loongson/LoongArchQemuPkg#readme
4. Also you can access the binary files we have already build:
   https://github.com/yangxiaojuan-loongson/qemu-binary

The command to boot loongarch virt machine:
   $ qemu-system-loongarch64 -machine virt -m 4G -cpu la464 \
   -smp 1 -bios QEMU_EFI.fd -kernel vmlinuz.efi -initrd ramdisk \
   -serial stdio   -monitor telnet:localhost:4495,server,nowait \
   -append "root=/dev/ram rdinit=/sbin/init console=ttyS0,115200" \
   --nographic

Tianrui Zhao (10):
  linux-headers: Add KVM headers for loongarch
  target/loongarch: Define some kvm_arch interfaces
  target/loongarch: Supplement vcpu env initial when vcpu reset
  target/loongarch: Implement kvm get/set registers
  target/loongarch: Implement kvm_arch_init function
  target/loongarch: Implement kvm_arch_init_vcpu
  target/loongarch: Implement kvm_arch_handle_exit
  target/loongarch: Implement set vcpu intr for kvm
  target/loongarch: Add kvm-stub.c
  target/loongarch: Add kvm file into meson build

 linux-headers/asm-loongarch/kvm.h |  99 ++++++
 linux-headers/linux/kvm.h         |   9 +
 meson.build                       |   2 +
 target/loongarch/cpu.c            |  21 +-
 target/loongarch/cpu.h            |   3 +
 target/loongarch/kvm-stub.c       |  17 +
 target/loongarch/kvm.c            | 545 ++++++++++++++++++++++++++++++
 target/loongarch/kvm_loongarch.h  |  14 +
 target/loongarch/meson.build      |   1 +
 9 files changed, 706 insertions(+), 5 deletions(-)
 create mode 100644 linux-headers/asm-loongarch/kvm.h
 create mode 100644 target/loongarch/kvm-stub.c
 create mode 100644 target/loongarch/kvm.c
 create mode 100644 target/loongarch/kvm_loongarch.h

-- 
2.31.1

