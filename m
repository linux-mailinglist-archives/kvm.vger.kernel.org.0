Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 718FC749377
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 04:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbjGFCFR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 22:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232225AbjGFCFQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 22:05:16 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 744901FC1;
        Wed,  5 Jul 2023 19:04:43 -0700 (PDT)
Received: from loongson.cn (unknown [10.40.46.158])
        by gateway (Coremail) with SMTP id _____8BxY_A2IaZkgLEAAA--.3037S3;
        Thu, 06 Jul 2023 10:04:38 +0800 (CST)
Received: from [192.168.124.126] (unknown [10.40.46.158])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8AxjiMyIaZk2qQdAA--.48946S3;
        Thu, 06 Jul 2023 10:04:35 +0800 (CST)
Subject: Re: [PATCH v16 00/30] Add KVM LoongArch support
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, hejinyang@loongson.cn
References: <20230629075538.4063701-1-zhaotianrui@loongson.cn>
From:   zhaotianrui <zhaotianrui@loongson.cn>
Message-ID: <36784395-36b7-c96d-0034-be7e5e17b2c2@loongson.cn>
Date:   Thu, 6 Jul 2023 10:04:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20230629075538.4063701-1-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: AQAAf8AxjiMyIaZk2qQdAA--.48946S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj9fXoW3KF47Ar4fGF17XF1UtFW7Jrc_yoW8GrW8to
        WfAFWjqr40gr10k34v9ws0kFWjqryxGr4rZ3srZa98GF4rJ345KFy3Kw4Yya4avF95Wr1U
        G34UWw4DArZrJFn3l-sFpf9Il3svdjkaLaAFLSUrUUUUeb8apTn2vfkv8UJUUUU8wcxFpf
        9Il3svdxBIdaVrn0xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3
        UjIYCTnIWjp_UUUOb7kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI
        8IcIk0rVWrJVCq3wAFIxvE14AKwVWUXVWUAwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
        Y2AK021l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14
        v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
        6r4j6r4UJwAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0c
        Ia020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_
        Jw1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrw
        CYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48J
        MxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrVAFwI
        0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
        0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
        WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
        IxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUcbAwUUUUU
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping message.
Thanks for your reviewing. Could you please give us further suggestions 
about LoongArch KVM patch series if you have other good advice. Thanks 
very much.

Tianrui Zhao
ÔÚ 2023/6/29 ÏÂÎç3:55, Tianrui Zhao Ð´µÀ:
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
> Changes for v16:
> 1. Free allocated memory of vmcs,kvm_loongarch_ops in kvm module init,
> exit to avoid memory leak problem.
> 2. Simplify some assemble codes in switch.S which are necessary to be
> replaced with pseudo-instructions. And any other instructions do not need
> to be replaced anymore.
> 3. Add kvm_{save,restore}_guest_gprs macros to replace these ld.d,st.d
> guest regs instructions when vcpu world switch.
> 4. It is more secure to disable irq when flush guest tlb by gpa, so replace
> preempt_disable with loacl_irq_save in kvm_flush_tlb_gpa.
>
> Changes for v15:
> 1. Re-order some macros and variables in LoongArch kvm headers, put them
> together which have the same meaning.
> 2. Make some function definitions in one line, as it is not needed to split
> them.
> 3. Re-name some macros such as KVM_REG_LOONGARCH_GPR.
>
> Changes for v14:
> 1. Remove the macro CONFIG_KVM_GENERIC_HARDWARE_ENABLING in
> loongarch/kvm/main.c, as it is not useful.
> 2. Add select KVM_GENERIC_HARDWARE_ENABLING in loongarch/kvm/Kconfig,
> as it is used by virt/kvm.
> 3. Fix the LoongArch KVM source link in MAINTAINERS.
> 4. Improve LoongArch KVM documentation, such as add comment for
> LoongArch kvm_regs.
>
> Changes for v13:
> 1. Remove patch-28 "Implement probe virtualization when cpu init", as the
> virtualization information about FPU,PMP,LSX in guest.options,options_dyn
> is not used and the gcfg reg value can be read in kvm_hardware_enable, so
> remove the previous cpu_probe_lvz function.
> 2. Fix vcpu_enable_cap interface, it should return -EINVAL directly, as
> FPU cap is enable by default, and do not support any other caps now.
> 3. Simplify the jirl instruction with jr when without return addr,
> simplify case HW0 ... HW7 statment in interrupt.c
> 4. Rename host_stack,host_gp in kvm_vcpu_arch to host_sp,host_tp.
> 5. Remove 'cpu' parameter in _kvm_check_requests, as 'cpu' is not used,
> and remove 'cpu' parameter in kvm_check_vmid function, as it can get
> cpu number by itself.
>
> Changes for v12:
> 1. Improve the gcsr write/read/xchg interface to avoid the previous
> instruction statment like parse_r and make the code easy understanding,
> they are implemented in asm/insn-def.h and the instructions consistent
> of "opcode" "rj" "rd" "simm14" arguments.
> 2. Fix the maintainers list of LoongArch KVM.
>
> Changes for v11:
> 1. Add maintainers for LoongArch KVM.
>
> Changes for v10:
> 1. Fix grammatical problems in LoongArch documentation.
> 2. It is not necessary to save or restore the LOONGARCH_CSR_PGD when
> vcpu put and vcpu load, so we remove it.
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
>    LoongArch: KVM: Enable kvm config and add the makefile
>    LoongArch: KVM: Supplement kvm document about LoongArch-specific part
>    LoongArch: KVM: Add maintainers for LoongArch KVM
>
>   Documentation/virt/kvm/api.rst             |  70 +-
>   MAINTAINERS                                |  12 +
>   arch/loongarch/Kbuild                      |   1 +
>   arch/loongarch/Kconfig                     |   2 +
>   arch/loongarch/configs/loongson3_defconfig |   2 +
>   arch/loongarch/include/asm/insn-def.h      |  55 ++
>   arch/loongarch/include/asm/inst.h          |  16 +
>   arch/loongarch/include/asm/kvm_csr.h       | 231 ++++++
>   arch/loongarch/include/asm/kvm_host.h      | 251 ++++++
>   arch/loongarch/include/asm/kvm_types.h     |  11 +
>   arch/loongarch/include/asm/kvm_vcpu.h      |  97 +++
>   arch/loongarch/include/asm/loongarch.h     |  20 +-
>   arch/loongarch/include/uapi/asm/kvm.h      | 106 +++
>   arch/loongarch/kernel/asm-offsets.c        |  32 +
>   arch/loongarch/kvm/Kconfig                 |  39 +
>   arch/loongarch/kvm/Makefile                |  22 +
>   arch/loongarch/kvm/csr_ops.S               |  76 ++
>   arch/loongarch/kvm/exit.c                  | 707 +++++++++++++++++
>   arch/loongarch/kvm/interrupt.c             | 113 +++
>   arch/loongarch/kvm/main.c                  | 361 +++++++++
>   arch/loongarch/kvm/mmu.c                   | 725 +++++++++++++++++
>   arch/loongarch/kvm/switch.S                | 256 ++++++
>   arch/loongarch/kvm/timer.c                 | 266 +++++++
>   arch/loongarch/kvm/tlb.c                   |  34 +
>   arch/loongarch/kvm/trace.h                 | 168 ++++
>   arch/loongarch/kvm/vcpu.c                  | 866 +++++++++++++++++++++
>   arch/loongarch/kvm/vm.c                    |  76 ++
>   arch/loongarch/kvm/vmid.c                  |  66 ++
>   include/uapi/linux/kvm.h                   |   9 +
>   29 files changed, 4676 insertions(+), 14 deletions(-)
>   create mode 100644 arch/loongarch/include/asm/insn-def.h
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

