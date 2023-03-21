Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3C1D6C28B8
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 04:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjCUD5D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 23:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjCUD5A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 23:57:00 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D76E22E0D3;
        Mon, 20 Mar 2023 20:56:56 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8Axz_8HKxlk9TUPAA--.22743S3;
        Tue, 21 Mar 2023 11:56:55 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxD78EKxlkQB4IAA--.33942S2;
        Tue, 21 Mar 2023 11:56:52 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>
Subject: [PATCH v4 00/29] Add KVM LoongArch support
Date:   Tue, 21 Mar 2023 11:56:22 +0800
Message-Id: <20230321035651.598505-1-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8DxD78EKxlkQB4IAA--.33942S2
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoWxKFWkZFWrGr4kGry7Jr1DKFg_yoWfXry3pF
        W7urn8Gr4kGrWSq395t34kZ345XF18Gryag3WavFy8CrW2qry8ZrWvgr9FvF9rAaykJr10
        qr1rKw1ag3WUAaDanT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bcAFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6x
        kF7I0E14v26r4UJVWxJr1ln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l
        57IF6xkI12xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6x8ErcxFaV
        Av8VWrMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWU
        AVWUtwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26rWl4I8I3I0E4IkC6x0Yz7
        v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
        jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
        x0cI8IcVAFwI0_Xr0_Ar1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
        8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I
        0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvj4RKpBTUUUUU
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds KVM LoongArch support. Loongson 3A5000 supports hardware
assisted virtualization. With cpu virtualization, there are separate
hw-supported user mode and kernel mode in guest mode. With memory
virtualization, there are two-level hw mmu table for guest mode and host
mode. Also there is separate hw cpu timer with consant frequency in
guest mode, so that vm can migrate between hosts with different freq.
Currently, we are able to boot LoongArch Linux Guests.

Few key aspects of KVM LoongArch added by this series are:
1. Enable kvm hardware function when kvm module is loaded.
2. Implement VM and vcpu related ioctl interface such as vcpu create,
   vcpu run etc. GET_ONE_REG/SET_ONE_REG ioctl commands are use to
   get general registers one by one.
3. Hardware access about MMU, timer and csr are emulated in kernel.
4. Hardwares such as mmio and iocsr device are emulated in user space
   such as APIC, IPI, pci devices etc.

The running environment of LoongArch virt machine:
1. Cross tools to build kernel and uefi:
   $ wget https://github.com/loongson/build-tools/releases/download/2022.09.06/loongarch64-clfs-6.3-cross-tools-gcc-glibc.tar.xz
   tar -vxf loongarch64-clfs-6.3-cross-tools-gcc-glibc.tar.xz  -C /opt
   export PATH=/opt/cross-tools/bin:$PATH
   export LD_LIBRARY_PATH=/opt/cross-tools/lib:$LD_LIBRARY_PATH
   export LD_LIBRARY_PATH=/opt/cross-tools/loongarch64-unknown-linux-gnu/lib/:$LD_LIBRARY_PATH
2. This series is based on the linux source code:
   https://github.com/loongson/linux-loongarch-kvm
   Build command:
   git checkout kvm-loongarch
   make ARCH=loongarch CROSS_COMPILE=loongarch64-unknown-linux-gnu- loongson3_defconfig
   make ARCH=loongarch CROSS_COMPILE=loongarch64-unknown-linux-gnu-
3. QEMU hypervisor with LoongArch supported:
   https://github.com/loongson/qemu
   Build command:
   git checkout kvm-loongarch
   ./configure --target-list="loongarch64-softmmu"  --enable-kvm
   make
4. Uefi bios of LoongArch virt machine:
   Link: https://github.com/tianocore/edk2-platforms/tree/master/Platform/Loongson/LoongArchQemuPkg#readme
5. you can also access the binary files we have already build:
   https://github.com/yangxiaojuan-loongson/qemu-binary

The command to boot loongarch virt machine:
   $ qemu-system-loongarch64 -machine virt -m 4G -cpu la464 \
   -smp 1 -bios QEMU_EFI.fd -kernel vmlinuz.efi -initrd ramdisk \
   -serial stdio   -monitor telnet:localhost:4495,server,nowait \
   -append "root=/dev/ram rdinit=/sbin/init console=ttyS0,115200" \
   --nographic

Changes for v4:
1.Add a csr_need_update flag in _vcpu_put, as most csr registers keep
unchanged during process context switch, so we need not to update it
every time. We can do this only if the soft csr is different form hardware.
That is to say all of csrs should update after vcpu enter guest, as for
set_csr_ioctl, we have written soft csr to keep consistent with hardware.
2. Improve get/set_csr_ioctl interface, we set SW or HW or INVALID flag
for all csrs according to it's features when kvm init. In get/set_csr_ioctl,
if csr is HW, we use gcsrrd/ gcsrwr instruction to access it, else if csr is
SW, we use software to emulate it, and others return false.
3. Add set_hw_gcsr function in csr_ops.S, and it is used in set_csr_ioctl.
We have splited hw gcsr into three parts, so we can calculate the code offset
by gcsrid and jump here to run the gcsrwr instruction. We use this function to
make the code easier and avoid to use the previous SET_HW_GCSR(XXX) interface.
4. Improve kvm mmu functions, such as flush page table and make clean page table
interface.

Changes for v3:
1. Remove the vpid array list in kvm_vcpu_arch and use a vpid variable here,
because a vpid will never be recycled if a vCPU migrates from physical CPU A
to B and back to A.
2. Make some constant variables in kvm_context to global such as vpid_mask,
guest_eentry, enter_guest, etc.
3. Add some new tracepoints, such as kvm_trace_idle, kvm_trace_cache,
kvm_trace_gspr, etc.
4. There are some duplicate codes in kvm_handle_exit and kvm_vcpu_run,
so we move it to a new function kvm_pre_enter_guest.
5. Change the RESUME_HOST, RESUME_GUEST value, return 1 for resume guest
and "<= 0" for resume host.
6. Fcsr and fpu registers are saved/restored together.

Changes for v2:
1. Seprate the original patch-01 and patch-03 into small patches, and the
patches mainly contain kvm module init, module exit, vcpu create, vcpu run,
etc.
2. Remove the original KVM_{GET,SET}_CSRS ioctl in the kvm uapi header,
and we use the common KVM_{GET,SET}_ONE_REG to access register.
3. Use BIT(x) to replace the "1 << n_bits" statement.

Tianrui Zhao (29):
  LoongArch: KVM: Add kvm related header files
  LoongArch: KVM: Implement kvm module related interface
  LoongArch: KVM: Implement kvm hardware enable, disable interface
  LoongArch: KVM: Implement VM related functions
  LoongArch: KVM: Add vcpu related header files
  LoongArch: KVM: Implement vcpu create and destroy interface
  LoongArch: KVM: Implement vcpu run interface
  LoongArch: KVM: Implement vcpu handle exit interface
  LoongArch: KVM: Implement vcpu get, vcpu set registers
  LoongArch: KVM: Implement vcpu ENABLE_CAP ioctl interface
  LoongArch: KVM: Implement fpu related operations for vcpu
  LoongArch: KVM: Implement vcpu interrupt operations
  LoongArch: KVM: Implement misc vcpu related interfaces
  LoongArch: KVM: Implement vcpu load and vcpu put operations
  LoongArch: KVM: Implement vcpu status description
  LoongArch: KVM: Implement update VM id function
  LoongArch: KVM: Implement virtual machine tlb operations
  LoongArch: KVM: Implement vcpu timer operations
  LoongArch: KVM: Implement kvm mmu operations
  LoongArch: KVM: Implement handle csr excption
  LoongArch: KVM: Implement handle iocsr exception
  LoongArch: KVM: Implement handle idle exception
  LoongArch: KVM: Implement handle gspr exception
  LoongArch: KVM: Implement handle mmio exception
  LoongArch: KVM: Implement handle fpu exception
  LoongArch: KVM: Implement kvm exception vector
  LoongArch: KVM: Implement vcpu world switch
  LoongArch: KVM: Implement probe virtualization when loongarch cpu init
  LoongArch: KVM: Enable kvm config and add the makefile

 arch/loongarch/Kbuild                      |   1 +
 arch/loongarch/Kconfig                     |   2 +
 arch/loongarch/configs/loongson3_defconfig |   2 +
 arch/loongarch/include/asm/cpu-features.h  |  22 +
 arch/loongarch/include/asm/cpu-info.h      |  13 +
 arch/loongarch/include/asm/inst.h          |  16 +
 arch/loongarch/include/asm/kvm_csr.h       |  55 ++
 arch/loongarch/include/asm/kvm_host.h      | 266 ++++++
 arch/loongarch/include/asm/kvm_types.h     |  11 +
 arch/loongarch/include/asm/kvm_vcpu.h      | 114 +++
 arch/loongarch/include/asm/loongarch.h     | 209 ++++-
 arch/loongarch/include/uapi/asm/kvm.h      | 107 +++
 arch/loongarch/kernel/asm-offsets.c        |  32 +
 arch/loongarch/kernel/cpu-probe.c          |  53 ++
 arch/loongarch/kvm/Kconfig                 |  38 +
 arch/loongarch/kvm/Makefile                |  22 +
 arch/loongarch/kvm/csr_ops.S               |  76 ++
 arch/loongarch/kvm/exit.c                  | 701 ++++++++++++++++
 arch/loongarch/kvm/interrupt.c             | 126 +++
 arch/loongarch/kvm/main.c                  | 260 ++++++
 arch/loongarch/kvm/mmu.c                   | 730 +++++++++++++++++
 arch/loongarch/kvm/switch.S                | 303 +++++++
 arch/loongarch/kvm/timer.c                 | 266 ++++++
 arch/loongarch/kvm/tlb.c                   |  31 +
 arch/loongarch/kvm/trace.h                 | 169 ++++
 arch/loongarch/kvm/vcpu.c                  | 891 +++++++++++++++++++++
 arch/loongarch/kvm/vm.c                    |  78 ++
 arch/loongarch/kvm/vmid.c                  |  65 ++
 include/uapi/linux/kvm.h                   |   9 +
 29 files changed, 4662 insertions(+), 6 deletions(-)
 create mode 100644 arch/loongarch/include/asm/kvm_csr.h
 create mode 100644 arch/loongarch/include/asm/kvm_host.h
 create mode 100644 arch/loongarch/include/asm/kvm_types.h
 create mode 100644 arch/loongarch/include/asm/kvm_vcpu.h
 create mode 100644 arch/loongarch/include/uapi/asm/kvm.h
 create mode 100644 arch/loongarch/kvm/Kconfig
 create mode 100644 arch/loongarch/kvm/Makefile
 create mode 100644 arch/loongarch/kvm/csr_ops.S
 create mode 100644 arch/loongarch/kvm/exit.c
 create mode 100644 arch/loongarch/kvm/interrupt.c
 create mode 100644 arch/loongarch/kvm/main.c
 create mode 100644 arch/loongarch/kvm/mmu.c
 create mode 100644 arch/loongarch/kvm/switch.S
 create mode 100644 arch/loongarch/kvm/timer.c
 create mode 100644 arch/loongarch/kvm/tlb.c
 create mode 100644 arch/loongarch/kvm/trace.h
 create mode 100644 arch/loongarch/kvm/vcpu.c
 create mode 100644 arch/loongarch/kvm/vm.c
 create mode 100644 arch/loongarch/kvm/vmid.c

-- 
2.31.1

