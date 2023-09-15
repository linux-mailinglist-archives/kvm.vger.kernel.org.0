Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5767A14AF
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 06:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbjIOELh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 00:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjIOELf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 00:11:35 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC4C2703;
        Thu, 14 Sep 2023 21:11:29 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7599C433CB;
        Fri, 15 Sep 2023 04:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694751088;
        bh=5Ps2FVTE2mylcJx01wPaCUuqJyY1dpwRnqLVbGvr/Nw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dLFL54/NIvZI5G9jF6Ca6VAHodnEm31uC+uVZ5vR6E128IbvMfAbL/AMy7uoY7zfB
         CroOrYF4P+9zvIFB3oDR9nZSfjqyr2NCVrNvll+OCU5Qn2oqlw/eBuZWrgHoFFic3H
         0T8zIRMzTJ+V4RyTbVKVzxAdafCU5VBaN5EmRubPIdYQK6fwq8Yrwbj8GyE1u54Okk
         +gWL98Ug264CH5UCmrl5cEX8DB/QkrP4I+RaU+YzgptxJbUwiDAOzPtOe1LKvSpcNn
         cNOk9njdwZvMB93lEmFXFiaLqzAr9rwLeNU0aqQnxOgv5lavsEMVJkig8mdMr9zRk/
         tXXgWNydvgQ2Q==
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-31c6d17aec4so1529524f8f.1;
        Thu, 14 Sep 2023 21:11:28 -0700 (PDT)
X-Gm-Message-State: AOJu0YzpVgUvegAyosriQ6TjkoVxLi5Zl3FXVSaGqwata0xm6yC+QYke
        cc3AxlBqvWt2zhsWG8dzlu2yUj7EUhAZZi6LtsI=
X-Google-Smtp-Source: AGHT+IGFEKaKvc0vaB/FiivAW2j3vGzHM4uXJXLj8ZbtDkk8nwt5fPG+If7JfmmQPtms3zLZIwP3EK1ZcLZx7d1A9p4=
X-Received: by 2002:a5d:6b85:0:b0:317:69d2:35c2 with SMTP id
 n5-20020a5d6b85000000b0031769d235c2mr374824wrx.2.1694751087250; Thu, 14 Sep
 2023 21:11:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230915014949.1222777-1-zhaotianrui@loongson.cn>
In-Reply-To: <20230915014949.1222777-1-zhaotianrui@loongson.cn>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Fri, 15 Sep 2023 12:11:14 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5fbyoMk9XWsejU0zVg4jPq_t2PT3ODKiAnc1LNARpBzA@mail.gmail.com>
Message-ID: <CAAhV-H5fbyoMk9XWsejU0zVg4jPq_t2PT3ODKiAnc1LNARpBzA@mail.gmail.com>
Subject: Re: [PATCH v21 00/29] Add KVM LoongArch support
To:     Tianrui Zhao <zhaotianrui@loongson.cn>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Tianrui,

On Fri, Sep 15, 2023 at 9:50=E2=80=AFAM Tianrui Zhao <zhaotianrui@loongson.=
cn> wrote:
>
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
>    vcpu run etc. GET_ONE_REG/SET_ONE_REG ioctl commands are use to
>    get general registers one by one.
> 3. Hardware access about MMU, timer and csr are emulated in kernel.
> 4. Hardwares such as mmio and iocsr device are emulated in user space
>    such as APIC, IPI, pci devices etc.
>
> The running environment of LoongArch virt machine:
> 1. Cross tools for building kernel and uefi:
>    https://github.com/loongson/build-tools
> 2. This series is based on the linux source code:
>    https://github.com/loongson/linux-loongarch-kvm
>    Build command:
>    git checkout kvm-loongarch
>    make ARCH=3Dloongarch CROSS_COMPILE=3Dloongarch64-unknown-linux-gnu- l=
oongson3_defconfig
>    make ARCH=3Dloongarch CROSS_COMPILE=3Dloongarch64-unknown-linux-gnu-
> 3. QEMU hypervisor with LoongArch supported:
>    https://github.com/loongson/qemu
>    Build command:
>    git checkout kvm-loongarch
>    ./configure --target-list=3D"loongarch64-softmmu"  --enable-kvm
>    make
When I build qemu, I get:
[3/964] Compiling C object
libqemu-loongarch64-softmmu.fa.p/target_loongarch_loongarch-qmp-cmds.c.o
FAILED: libqemu-loongarch64-softmmu.fa.p/target_loongarch_loongarch-qmp-cmd=
s.c.o
cc -Ilibqemu-loongarch64-softmmu.fa.p -I. -I.. -Itarget/loongarch
-I../target/loongarch -Isubprojects/dtc/libfdt
-I../subprojects/dtc/libfdt -Iqapi -Itrace c
In file included from ../target/loongarch/loongarch-qmp-cmds.c:11:
../target/loongarch/cpu.h:351:14: error: duplicate member 'CSR_CPUID'
  351 |     uint64_t CSR_CPUID;
      |              ^~~~~~~~~
ninja: build stopped: subcommand failed.
make[1]: *** [Makefile:162: run-ninja] Error 1
make[1]: Leaving directory '/root/qemu/build'
make: *** [GNUmakefile:11: all] Error 2

Huacai

> 4. Uefi bios of LoongArch virt machine:
>    Link: https://github.com/tianocore/edk2-platforms/tree/master/Platform=
/Loongson/LoongArchQemuPkg#readme
> 5. you can also access the binary files we have already build:
>    https://github.com/yangxiaojuan-loongson/qemu-binary
> The command to boot loongarch virt machine:
>    $ qemu-system-loongarch64 -machine virt -m 4G -cpu la464 \
>    -smp 1 -bios QEMU_EFI.fd -kernel vmlinuz.efi -initrd ramdisk \
>    -serial stdio   -monitor telnet:localhost:4495,server,nowait \
>    -append "root=3D/dev/ram rdinit=3D/sbin/init console=3DttyS0,115200" \
>    --nographic
>
> Changes for v21:
> 1. Remove unnecessary prefix '_' in some kvm function names.
> 2. Replace check_vmid with check_vpid, and move the functions
> to main.c.
> 3. Re-order the file names and config names by alphabetical
> in KVM makefile and Kconfig.
> 4. Code clean up for KVM mmu and get,set gcsr and vcpu_arch
> ioctl functions.
>
> changes for v20:
> 1. Remove the binary code of virtualization instructions in
> insn_def.h and csr_ops.S and directly use the default csrrd,
> csrwr,csrxchg instructions. And let CONFIG_KVM depends on the
> AS_HAS_LVZ_EXTENSION, so we should use the binutils that have
> already supported them to compile the KVM. This can make our
> LoongArch KVM codes more maintainable and easier.
>
> changes for v19:
> 1. Use the common interface xfer_to_guest_mode_handle_work to
> Check conditions before entering the guest.
> 2. Add vcpu dirty ring support.
>
> changes for v18:
> 1. Code cleanup for vcpu timer: remove unnecessary timer_period_ns,
> timer_bias, timer_dyn_bias variables in kvm_vcpu_arch and rename
> the stable_ktime_saved variable to expire.
> 2. Change the value of KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE to 40.
>
> changes for v17:
> 1. Add CONFIG_AS_HAS_LVZ_EXTENSION config option which depends on
> binutils that support LVZ assemble instruction.
> 2. Change kvm mmu related functions, such as rename level2_ptw_pgd
> to kvm_ptw_pgd, replace kvm_flush_range with kvm_ptw_pgd pagewalk
> framework, replace kvm_arch.gpa_mm with kvm_arch.pgd, set
> mark_page_dirty/kvm_set_pfn_dirty out of mmu_lock in kvm page fault
> handling.
> 3. Replace kvm_loongarch_interrupt with standard kvm_interrupt
> when injecting IRQ.
> 4. Replace vcpu_arch.last_exec_cpu with existing vcpu.cpu, remove
> kvm_arch.online_vcpus and kvm_arch.is_migrating,
> 5. Remove EXCCODE_TLBNR and EXCCODE_TLBNX in kvm exception table,
> since NR/NX bit is not set in kvm page fault handling.
>
> Changes for v16:
> 1. Free allocated memory of vmcs,kvm_loongarch_ops in kvm module init,
> exit to avoid memory leak problem.
> 2. Simplify some assemble codes in switch.S which are necessary to be
> replaced with pseudo-instructions. And any other instructions do not need
> to be replaced anymore.
> 3. Add kvm_{save,restore}_guest_gprs macros to replace these ld.d,st.d
> guest regs instructions when vcpu world switch.
> 4. It is more secure to disable irq when flush guest tlb by gpa, so repla=
ce
> preempt_disable with loacl_irq_save in kvm_flush_tlb_gpa.
>
> Changes for v15:
> 1. Re-order some macros and variables in LoongArch kvm headers, put them
> together which have the same meaning.
> 2. Make some function definitions in one line, as it is not needed to spl=
it
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
> https://lore.kernel.org/oe-kbuild-all/202304131526.iXfLaVZc-lkp@intel.com=
/
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
> every time. We can do this only if the soft csr is different form hardwar=
e.
> That is to say all of csrs should update after vcpu enter guest, as for
> set_csr_ioctl, we have written soft csr to keep consistent with hardware.
> 2. Improve get/set_csr_ioctl interface, we set SW or HW or INVALID flag
> for all csrs according to it's features when kvm init. In get/set_csr_ioc=
tl,
> if csr is HW, we use gcsrrd/ gcsrwr instruction to access it, else if csr=
 is
> SW, we use software to emulate it, and others return false.
> 3. Add set_hw_gcsr function in csr_ops.S, and it is used in set_csr_ioctl=
.
> We have splited hw gcsr into three parts, so we can calculate the code of=
fset
> by gcsrid and jump here to run the gcsrwr instruction. We use this functi=
on to
> make the code easier and avoid to use the previous SET_HW_GCSR(XXX) inter=
face.
> 4. Improve kvm mmu functions, such as flush page table and make clean pag=
e table
> interface.
>
> Changes for v3:
> 1. Remove the vpid array list in kvm_vcpu_arch and use a vpid variable he=
re,
> because a vpid will never be recycled if a vCPU migrates from physical CP=
U A
> to B and back to A.
> 2. Make some constant variables in kvm_context to global such as vpid_mas=
k,
> guest_eentry, enter_guest, etc.
> 3. Add some new tracepoints, such as kvm_trace_idle, kvm_trace_cache,
> kvm_trace_gspr, etc.
> 4. There are some duplicate codes in kvm_handle_exit and kvm_vcpu_run,
> so we move it to a new function kvm_pre_enter_guest.
> 5. Change the RESUME_HOST, RESUME_GUEST value, return 1 for resume guest
> and "<=3D 0" for resume host.
> 6. Fcsr and fpu registers are saved/restored together.
>
> Changes for v2:
> 1. Seprate the original patch-01 and patch-03 into small patches, and the
> patches mainly contain kvm module init, module exit, vcpu create, vcpu ru=
n,
> etc.
> 2. Remove the original KVM_{GET,SET}_CSRS ioctl in the kvm uapi header,
> and we use the common KVM_{GET,SET}_ONE_REG to access register.
> 3. Use BIT(x) to replace the "1 << n_bits" statement.
>
> Tianrui Zhao (29):
>   LoongArch: KVM: Add kvm related header files
>   LoongArch: KVM: Implement kvm module related interface
>   LoongArch: KVM: Implement kvm hardware enable, disable interface
>   LoongArch: KVM: Implement VM related functions
>   LoongArch: KVM: Add vcpu related header files
>   LoongArch: KVM: Implement vcpu create and destroy interface
>   LoongArch: KVM: Implement vcpu run interface
>   LoongArch: KVM: Implement vcpu handle exit interface
>   LoongArch: KVM: Implement vcpu get, vcpu set registers
>   LoongArch: KVM: Implement vcpu ENABLE_CAP ioctl interface
>   LoongArch: KVM: Implement fpu related operations for vcpu
>   LoongArch: KVM: Implement vcpu interrupt operations
>   LoongArch: KVM: Implement misc vcpu related interfaces
>   LoongArch: KVM: Implement vcpu load and vcpu put operations
>   LoongArch: KVM: Implement vcpu status description
>   LoongArch: KVM: Implement virtual machine tlb operations
>   LoongArch: KVM: Implement vcpu timer operations
>   LoongArch: KVM: Implement kvm mmu operations
>   LoongArch: KVM: Implement handle csr exception
>   LoongArch: KVM: Implement handle iocsr exception
>   LoongArch: KVM: Implement handle idle exception
>   LoongArch: KVM: Implement handle gspr exception
>   LoongArch: KVM: Implement handle mmio exception
>   LoongArch: KVM: Implement handle fpu exception
>   LoongArch: KVM: Implement kvm exception vector
>   LoongArch: KVM: Implement vcpu world switch
>   LoongArch: KVM: Enable kvm config and add the makefile
>   LoongArch: KVM: Supplement kvm document about LoongArch-specific part
>   LoongArch: KVM: Add maintainers for LoongArch KVM
>
>  Documentation/virt/kvm/api.rst             |  70 +-
>  MAINTAINERS                                |  12 +
>  arch/loongarch/Kbuild                      |   1 +
>  arch/loongarch/Kconfig                     |   3 +
>  arch/loongarch/configs/loongson3_defconfig |   2 +
>  arch/loongarch/include/asm/inst.h          |  16 +
>  arch/loongarch/include/asm/kvm_csr.h       | 221 +++++
>  arch/loongarch/include/asm/kvm_host.h      | 245 ++++++
>  arch/loongarch/include/asm/kvm_mmu.h       | 138 +++
>  arch/loongarch/include/asm/kvm_types.h     |  11 +
>  arch/loongarch/include/asm/kvm_vcpu.h      | 107 +++
>  arch/loongarch/include/asm/loongarch.h     |  19 +-
>  arch/loongarch/include/uapi/asm/kvm.h      | 108 +++
>  arch/loongarch/kernel/asm-offsets.c        |  32 +
>  arch/loongarch/kvm/Kconfig                 |  45 +
>  arch/loongarch/kvm/Makefile                |  20 +
>  arch/loongarch/kvm/exit.c                  | 711 ++++++++++++++++
>  arch/loongarch/kvm/interrupt.c             | 185 ++++
>  arch/loongarch/kvm/main.c                  | 429 ++++++++++
>  arch/loongarch/kvm/mmu.c                   | 922 ++++++++++++++++++++
>  arch/loongarch/kvm/switch.S                | 255 ++++++
>  arch/loongarch/kvm/timer.c                 | 200 +++++
>  arch/loongarch/kvm/tlb.c                   |  34 +
>  arch/loongarch/kvm/trace.h                 | 166 ++++
>  arch/loongarch/kvm/vcpu.c                  | 940 +++++++++++++++++++++
>  arch/loongarch/kvm/vm.c                    |  92 ++
>  include/uapi/linux/kvm.h                   |   9 +
>  27 files changed, 4979 insertions(+), 14 deletions(-)
>  create mode 100644 arch/loongarch/include/asm/kvm_csr.h
>  create mode 100644 arch/loongarch/include/asm/kvm_host.h
>  create mode 100644 arch/loongarch/include/asm/kvm_mmu.h
>  create mode 100644 arch/loongarch/include/asm/kvm_types.h
>  create mode 100644 arch/loongarch/include/asm/kvm_vcpu.h
>  create mode 100644 arch/loongarch/include/uapi/asm/kvm.h
>  create mode 100644 arch/loongarch/kvm/Kconfig
>  create mode 100644 arch/loongarch/kvm/Makefile
>  create mode 100644 arch/loongarch/kvm/exit.c
>  create mode 100644 arch/loongarch/kvm/interrupt.c
>  create mode 100644 arch/loongarch/kvm/main.c
>  create mode 100644 arch/loongarch/kvm/mmu.c
>  create mode 100644 arch/loongarch/kvm/switch.S
>  create mode 100644 arch/loongarch/kvm/timer.c
>  create mode 100644 arch/loongarch/kvm/tlb.c
>  create mode 100644 arch/loongarch/kvm/trace.h
>  create mode 100644 arch/loongarch/kvm/vcpu.c
>  create mode 100644 arch/loongarch/kvm/vm.c
>
> --
> 2.39.1
>
