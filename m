Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFAE6FD4EF
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 06:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbjEJEHM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 00:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235595AbjEJEGY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 00:06:24 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A46BD5BBB;
        Tue,  9 May 2023 21:04:29 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.120])
        by gateway (Coremail) with SMTP id _____8BxrOo7FltkTT8HAA--.12344S3;
        Wed, 10 May 2023 11:57:48 +0800 (CST)
Received: from [10.20.42.120] (unknown [10.20.42.120])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8BxkrA5FltkDYRTAA--.18626S3;
        Wed, 10 May 2023 11:57:45 +0800 (CST)
Subject: Re: [PATCH v9 00/30] Add KVM LoongArch support
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>
References: <20230509075346.1023386-1-zhaotianrui@loongson.cn>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
Message-ID: <05a85d35-41f5-ad1b-5798-8b76423e9218@loongson.cn>
Date:   Wed, 10 May 2023 11:57:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <20230509075346.1023386-1-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8BxkrA5FltkDYRTAA--.18626S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoW3KF47Ar4fGF1rCFykZw1fJFb_yoWkXF4kpF
        W7urn8Grs5Gr4Sqws3t3s7ur98XFyxGrWaq3Wa9348CrW2qrykZrykKr9FyF9rZ3yrJr10
        qr1rKw1ag3WUAaDanT9S1TB71UUUU87qnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bqAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s
        1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84
        ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr0_Cr1U
        M2kKe7AKxVW8ZVWrXwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zV
        CFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2
        z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2
        IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E
        4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_GFv_Wrylx2IqxVAqx4xG67AKxVWUJVWUGw
        C20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48J
        MIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMI
        IF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E
        87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUD4lkDUUUU
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi everyone,

I am very grateful for your carefully reviewing on our LoongArch KVM 
patches, and give us many efficient suggestions to make the code better.
Could you please send me a ACKed flag on the patches if you have no 
further advice anymore. Thanks very much.

Thanks
Tianrui Zhao
在 2023年05月09日 15:53, Tianrui Zhao 写道:
> This series adds KVM LoongArch support. Loongson 3A5000 supports hardware
> assisted virtualization. With cpu virtualization, there are separate
> hw-supported user mode and kernel mode in guest mode. With memory
> virtualization, there are two-level hw mmu table for guest mode and host
> mode. Also there is separate hw cpu timer with consant frequency in
> guest mode, so that vm can migrate between hosts with different freq.
> Currently, we are able to boot LoongArch Linux Guests.
>
> Few key aspects of KVM LoongArch added by this series are:
> 1. Enable kvm hardware function when kvm module is loaded.
> 2. Implement VM and vcpu related ioctl interface such as vcpu create,
>     vcpu run etc. GET_ONE_REG/SET_ONE_REG ioctl commands are use to
>     get general registers one by one.
> 3. Hardware access about MMU, timer and csr are emulated in kernel.
> 4. Hardwares such as mmio and iocsr device are emulated in user space
>     such as APIC, IPI, pci devices etc.
>
> The running environment of LoongArch virt machine:
> 1. Cross tools to build kernel and uefi:
>     $ wget https://github.com/loongson/build-tools/releases/download/2022.09.06/loongarch64-clfs-6.3-cross-tools-gcc-glibc.tar.xz
>     tar -vxf loongarch64-clfs-6.3-cross-tools-gcc-glibc.tar.xz  -C /opt
>     export PATH=/opt/cross-tools/bin:$PATH
>     export LD_LIBRARY_PATH=/opt/cross-tools/lib:$LD_LIBRARY_PATH
>     export LD_LIBRARY_PATH=/opt/cross-tools/loongarch64-unknown-linux-gnu/lib/:$LD_LIBRARY_PATH
> 2. This series is based on the linux source code:
>     https://github.com/loongson/linux-loongarch-kvm
>     Build command:
>     git checkout kvm-loongarch
>     make ARCH=loongarch CROSS_COMPILE=loongarch64-unknown-linux-gnu- loongson3_defconfig
>     make ARCH=loongarch CROSS_COMPILE=loongarch64-unknown-linux-gnu-
> 3. QEMU hypervisor with LoongArch supported:
>     https://github.com/loongson/qemu
>     Build command:
>     git checkout kvm-loongarch
>     ./configure --target-list="loongarch64-softmmu"  --enable-kvm
>     make
> 4. Uefi bios of LoongArch virt machine:
>     Link: https://github.com/tianocore/edk2-platforms/tree/master/Platform/Loongson/LoongArchQemuPkg#readme
> 5. you can also access the binary files we have already build:
>     https://github.com/yangxiaojuan-loongson/qemu-binary
> The command to boot loongarch virt machine:
>     $ qemu-system-loongarch64 -machine virt -m 4G -cpu la464 \
>     -smp 1 -bios QEMU_EFI.fd -kernel vmlinuz.efi -initrd ramdisk \
>     -serial stdio   -monitor telnet:localhost:4495,server,nowait \
>     -append "root=/dev/ram rdinit=/sbin/init console=ttyS0,115200" \
>     --nographic
>
> Changes for v9:
> 1. Apply the new defined interrupt number macros in loongarch.h to kvm,
> such as INT_SWI0, INT_HWI0, INT_TI, INT_IPI, etc. And remove the
> previous unused macros.
> 2. Remove unused variables in kvm_vcpu_arch, and reorder the variables
> to make them more standard.
>
> Changes for v8:
> 1. Adjust the cpu_data.guest.options structure, add the ases flag into
> it, and remove the previous guest.ases. We do this to keep consistent
> with host cpu_data.options structure.
> 2. Remove the "#include <asm/kvm_host.h>" in some files which also
> include the "<linux/kvm_host.h>". As linux/kvm_host.h already include
> the asm/kvm_host.h.
> 3. Fix some unstandard spelling and grammar errors in comments, and
> improve a little code format to make it easier and standard.
>
> Changes for v7:
> 1. Fix the kvm_save/restore_hw_gcsr compiling warnings reported by
> kernel test robot. The report link is:
> https://lore.kernel.org/oe-kbuild-all/202304131526.iXfLaVZc-lkp@intel.com/
> 2. Fix loongarch kvm trace related compiling problems.
>
> Changes for v6:
> 1. Fix the Documentation/virt/kvm/api.rst compile warning about
> loongarch parts.
>
> Changes for v5:
> 1. Implement get/set mp_state ioctl interface, and only the
> KVM_MP_STATE_RUNNABLE state is supported now, and other states
> will be completed in the future. The state is also used when vcpu
> run idle instruction, if vcpu state is changed to RUNNABLE, the
> vcpu will have the possibility to be woken up.
> 2. Supplement kvm document about loongarch-specific part, such as add
> api introduction for GET/SET_ONE_REG, GET/SET_FPU, GET/SET_MP_STATE,
> etc.
> 3. Improve the kvm_switch_to_guest function in switch.S, remove the
> previous tmp,tmp1 arguments and replace it with t0,t1 reg.
>
> Changes for v4:
> 1. Add a csr_need_update flag in _vcpu_put, as most csr registers keep
> unchanged during process context switch, so we need not to update it
> every time. We can do this only if the soft csr is different form hardware.
> That is to say all of csrs should update after vcpu enter guest, as for
> set_csr_ioctl, we have written soft csr to keep consistent with hardware.
> 2. Improve get/set_csr_ioctl interface, we set SW or HW or INVALID flag
> for all csrs according to it's features when kvm init. In get/set_csr_ioctl,
> if csr is HW, we use gcsrrd/ gcsrwr instruction to access it, else if csr is
> SW, we use software to emulate it, and others return false.
> 3. Add set_hw_gcsr function in csr_ops.S, and it is used in set_csr_ioctl.
> We have splited hw gcsr into three parts, so we can calculate the code offset
> by gcsrid and jump here to run the gcsrwr instruction. We use this function to
> make the code easier and avoid to use the previous SET_HW_GCSR(XXX) interface.
> 4. Improve kvm mmu functions, such as flush page table and make clean page table
> interface.
>
> Changes for v3:
> 1. Remove the vpid array list in kvm_vcpu_arch and use a vpid variable here,
> because a vpid will never be recycled if a vCPU migrates from physical CPU A
> to B and back to A.
> 2. Make some constant variables in kvm_context to global such as vpid_mask,
> guest_eentry, enter_guest, etc.
> 3. Add some new tracepoints, such as kvm_trace_idle, kvm_trace_cache,
> kvm_trace_gspr, etc.
> 4. There are some duplicate codes in kvm_handle_exit and kvm_vcpu_run,
> so we move it to a new function kvm_pre_enter_guest.
> 5. Change the RESUME_HOST, RESUME_GUEST value, return 1 for resume guest
> and "<= 0" for resume host.
> 6. Fcsr and fpu registers are saved/restored together.
>
> Changes for v2:
> 1. Seprate the original patch-01 and patch-03 into small patches, and the
> patches mainly contain kvm module init, module exit, vcpu create, vcpu run,
> etc.
> 2. Remove the original KVM_{GET,SET}_CSRS ioctl in the kvm uapi header,
> and we use the common KVM_{GET,SET}_ONE_REG to access register.
> 3. Use BIT(x) to replace the "1 << n_bits" statement.
>
> Tianrui Zhao (30):
>    LoongArch: KVM: Add kvm related header files
>    LoongArch: KVM: Implement kvm module related interface
>    LoongArch: KVM: Implement kvm hardware enable, disable interface
>    LoongArch: KVM: Implement VM related functions
>    LoongArch: KVM: Add vcpu related header files
>    LoongArch: KVM: Implement vcpu create and destroy interface
>    LoongArch: KVM: Implement vcpu run interface
>    LoongArch: KVM: Implement vcpu handle exit interface
>    LoongArch: KVM: Implement vcpu get, vcpu set registers
>    LoongArch: KVM: Implement vcpu ENABLE_CAP ioctl interface
>    LoongArch: KVM: Implement fpu related operations for vcpu
>    LoongArch: KVM: Implement vcpu interrupt operations
>    LoongArch: KVM: Implement misc vcpu related interfaces
>    LoongArch: KVM: Implement vcpu load and vcpu put operations
>    LoongArch: KVM: Implement vcpu status description
>    LoongArch: KVM: Implement update VM id function
>    LoongArch: KVM: Implement virtual machine tlb operations
>    LoongArch: KVM: Implement vcpu timer operations
>    LoongArch: KVM: Implement kvm mmu operations
>    LoongArch: KVM: Implement handle csr excption
>    LoongArch: KVM: Implement handle iocsr exception
>    LoongArch: KVM: Implement handle idle exception
>    LoongArch: KVM: Implement handle gspr exception
>    LoongArch: KVM: Implement handle mmio exception
>    LoongArch: KVM: Implement handle fpu exception
>    LoongArch: KVM: Implement kvm exception vector
>    LoongArch: KVM: Implement vcpu world switch
>    LoongArch: KVM: Implement probe virtualization when LoongArch cpu init
>    LoongArch: KVM: Enable kvm config and add the makefile
>    LoongArch: KVM: Supplement kvm document about LoongArch-specific part
>
>   Documentation/virt/kvm/api.rst             |  71 +-
>   arch/loongarch/Kbuild                      |   1 +
>   arch/loongarch/Kconfig                     |   2 +
>   arch/loongarch/configs/loongson3_defconfig |   2 +
>   arch/loongarch/include/asm/cpu-features.h  |  22 +
>   arch/loongarch/include/asm/cpu-info.h      |  10 +
>   arch/loongarch/include/asm/inst.h          |  16 +
>   arch/loongarch/include/asm/kvm_csr.h       |  57 ++
>   arch/loongarch/include/asm/kvm_host.h      | 252 ++++++
>   arch/loongarch/include/asm/kvm_types.h     |  11 +
>   arch/loongarch/include/asm/kvm_vcpu.h      |  97 +++
>   arch/loongarch/include/asm/loongarch.h     | 211 ++++-
>   arch/loongarch/include/uapi/asm/kvm.h      | 107 +++
>   arch/loongarch/kernel/asm-offsets.c        |  32 +
>   arch/loongarch/kernel/cpu-probe.c          |  53 ++
>   arch/loongarch/kvm/Kconfig                 |  38 +
>   arch/loongarch/kvm/Makefile                |  22 +
>   arch/loongarch/kvm/csr_ops.S               |  76 ++
>   arch/loongarch/kvm/exit.c                  | 707 +++++++++++++++++
>   arch/loongarch/kvm/interrupt.c             | 126 +++
>   arch/loongarch/kvm/main.c                  | 339 ++++++++
>   arch/loongarch/kvm/mmu.c                   | 729 +++++++++++++++++
>   arch/loongarch/kvm/switch.S                | 301 +++++++
>   arch/loongarch/kvm/timer.c                 | 266 +++++++
>   arch/loongarch/kvm/tlb.c                   |  31 +
>   arch/loongarch/kvm/trace.h                 | 168 ++++
>   arch/loongarch/kvm/vcpu.c                  | 881 +++++++++++++++++++++
>   arch/loongarch/kvm/vm.c                    |  78 ++
>   arch/loongarch/kvm/vmid.c                  |  64 ++
>   include/uapi/linux/kvm.h                   |   9 +
>   30 files changed, 4765 insertions(+), 14 deletions(-)
>   create mode 100644 arch/loongarch/include/asm/kvm_csr.h
>   create mode 100644 arch/loongarch/include/asm/kvm_host.h
>   create mode 100644 arch/loongarch/include/asm/kvm_types.h
>   create mode 100644 arch/loongarch/include/asm/kvm_vcpu.h
>   create mode 100644 arch/loongarch/include/uapi/asm/kvm.h
>   create mode 100644 arch/loongarch/kvm/Kconfig
>   create mode 100644 arch/loongarch/kvm/Makefile
>   create mode 100644 arch/loongarch/kvm/csr_ops.S
>   create mode 100644 arch/loongarch/kvm/exit.c
>   create mode 100644 arch/loongarch/kvm/interrupt.c
>   create mode 100644 arch/loongarch/kvm/main.c
>   create mode 100644 arch/loongarch/kvm/mmu.c
>   create mode 100644 arch/loongarch/kvm/switch.S
>   create mode 100644 arch/loongarch/kvm/timer.c
>   create mode 100644 arch/loongarch/kvm/tlb.c
>   create mode 100644 arch/loongarch/kvm/trace.h
>   create mode 100644 arch/loongarch/kvm/vcpu.c
>   create mode 100644 arch/loongarch/kvm/vm.c
>   create mode 100644 arch/loongarch/kvm/vmid.c
>

