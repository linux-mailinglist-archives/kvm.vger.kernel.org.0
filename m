Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41EDE79A22B
	for <lists+kvm@lfdr.de>; Mon, 11 Sep 2023 06:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbjIKEDu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 00:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233655AbjIKEDS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 00:03:18 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562E819C;
        Sun, 10 Sep 2023 21:03:12 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06A2C433C7;
        Mon, 11 Sep 2023 04:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694404992;
        bh=92EpCwDEyHeWViedvJ9pBTItHlypPHOPTESLZtTS2Wk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=QTH03VIp70gv1XO7kDapQVr1MF/gj62q5li0jwVEi5XCUPkieEMXU5K+RsXxYe4GB
         0XGuRI/pHs+brKnvAecIDIVH5FfacOv6OxKxsIDXxYDRTOdyAG0S+CkYYm4wKzoPkC
         M9zw7Ft3fomWJsp3dxXpa4yDs44hWGyp0QB3ToPlAqFz4JnZzfNbvB+77A5JLBwlnk
         ISopdxP+brdgckUPF5rOV2mmp3brcekla1jXiRuzmEBOgzv/O6FY5sZ73DUS5/bUsS
         XKWH/Ti1vMkWVHk8ia7KiZ2clA4WboeDHYN9n6Lqp3OarV0iTo0DFxBCiAaUsrwGG8
         XqF2RInSXBEzQ==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-99bed101b70so493375766b.3;
        Sun, 10 Sep 2023 21:03:11 -0700 (PDT)
X-Gm-Message-State: AOJu0YzyfIm9l85uRtDq+0HHYt2blzF4XbnFw9BkdStyX8DChlZQ/5s3
        ZAX0ynTopxcDy5E2ntQ4wkEnNXPGEpXNSxMHLVM=
X-Google-Smtp-Source: AGHT+IGIQz9UD2kElek9xWFcunN865uMllVDHT6TdxiyvqwcT8s80reUGfGzxP3VM47hyzrhTlRyGsXOURyPRkZqvME=
X-Received: by 2002:a17:906:cc45:b0:9a1:debe:6b9b with SMTP id
 mm5-20020a170906cc4500b009a1debe6b9bmr6771517ejb.35.1694404990204; Sun, 10
 Sep 2023 21:03:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230831083020.2187109-1-zhaotianrui@loongson.cn>
In-Reply-To: <20230831083020.2187109-1-zhaotianrui@loongson.cn>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Mon, 11 Sep 2023 12:02:57 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5SQWAGvc2gmH1eapm7DeNvYN9YrRzUFJfUZiV5NFGbNg@mail.gmail.com>
Message-ID: <CAAhV-H5SQWAGvc2gmH1eapm7DeNvYN9YrRzUFJfUZiV5NFGbNg@mail.gmail.com>
Subject: Re: [PATCH v20 00/30] Add KVM LoongArch support
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Tianrui,

I hope this can be the last review and the next version can get upstreamed.=
 :)


On Thu, Aug 31, 2023 at 4:30=E2=80=AFPM Tianrui Zhao <zhaotianrui@loongson.=
cn> wrote:
>
> From: zhaotianrui <zhaotianrui@loongson.cn>
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
> 1. Cross tools to build kernel and uefi:
>    $ wget https://github.com/loongson/build-tools/releases/download/2022.=
09.06/loongarch64-clfs-6.3-cross-tools-gcc-glibc.tar.xz
The cross tools should be updated to the latest one, because we need
binutils 2.41 now.

>    tar -vxf loongarch64-clfs-6.3-cross-tools-gcc-glibc.tar.xz  -C /opt
>    export PATH=3D/opt/cross-tools/bin:$PATH
>    export LD_LIBRARY_PATH=3D/opt/cross-tools/lib:$LD_LIBRARY_PATH
>    export LD_LIBRARY_PATH=3D/opt/cross-tools/loongarch64-unknown-linux-gn=
u/lib/:$LD_LIBRARY_PATH
> 2. This series is based on the linux source code:
>    https://github.com/loongson/linux-loongarch-kvm
Please update the base to at least v6.6-rc1.

>    Build command:
>    git checkout kvm-loongarch
>    make ARCH=3Dloongarch CROSS_COMPILE=3Dloongarch64-unknown-linux-gnu- l=
oongson3_defconfig
>    make ARCH=3Dloongarch CROSS_COMPILE=3Dloongarch64-unknown-linux-gnu-
> 3. QEMU hypervisor with LoongArch supported:
>    https://github.com/loongson/qemu
QEMU base should also be updated.

>    Build command:
>    git checkout kvm-loongarch
>    ./configure --target-list=3D"loongarch64-softmmu"  --enable-kvm
>    make
> 4. Uefi bios of LoongArch virt machine:
>    Link: https://github.com/tianocore/edk2-platforms/tree/master/Platform=
/Loongson/LoongArchQemuPkg#readme
> 5. you can also access the binary files we have already build:
>    https://github.com/yangxiaojuan-loongson/qemu-binary
Update any binaries if needed, too.

I will do a full test after v21 of this series, and I hope this can
move things forwards.


Huacai

> The command to boot loongarch virt machine:
>    $ qemu-system-loongarch64 -machine virt -m 4G -cpu la464 \
>    -smp 1 -bios QEMU_EFI.fd -kernel vmlinuz.efi -initrd ramdisk \
>    -serial stdio   -monitor telnet:localhost:4495,server,nowait \
>    -append "root=3D/dev/ram rdinit=3D/sbin/init console=3DttyS0,115200" \
>    --nographic
>
> changes for v20:
> 1. Remove the binary codes of virtualization instructions in
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
> Tianrui Zhao (30):
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
>   LoongArch: KVM: Implement update VM id function
>   LoongArch: KVM: Implement virtual machine tlb operations
>   LoongArch: KVM: Implement vcpu timer operations
>   LoongArch: KVM: Implement kvm mmu operations
>   LoongArch: KVM: Implement handle csr excption
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
>  arch/loongarch/include/asm/kvm_csr.h       | 222 +++++
>  arch/loongarch/include/asm/kvm_host.h      | 238 ++++++
>  arch/loongarch/include/asm/kvm_types.h     |  11 +
>  arch/loongarch/include/asm/kvm_vcpu.h      |  95 +++
>  arch/loongarch/include/asm/loongarch.h     |  19 +-
>  arch/loongarch/include/uapi/asm/kvm.h      | 101 +++
>  arch/loongarch/kernel/asm-offsets.c        |  32 +
>  arch/loongarch/kvm/Kconfig                 |  45 ++
>  arch/loongarch/kvm/Makefile                |  22 +
>  arch/loongarch/kvm/csr_ops.S               |  67 ++
>  arch/loongarch/kvm/exit.c                  | 702 ++++++++++++++++
>  arch/loongarch/kvm/interrupt.c             | 113 +++
>  arch/loongarch/kvm/main.c                  | 361 +++++++++
>  arch/loongarch/kvm/mmu.c                   | 678 ++++++++++++++++
>  arch/loongarch/kvm/switch.S                | 255 ++++++
>  arch/loongarch/kvm/timer.c                 | 200 +++++
>  arch/loongarch/kvm/tlb.c                   |  34 +
>  arch/loongarch/kvm/trace.h                 | 168 ++++
>  arch/loongarch/kvm/vcpu.c                  | 898 +++++++++++++++++++++
>  arch/loongarch/kvm/vm.c                    |  76 ++
>  arch/loongarch/kvm/vmid.c                  |  66 ++
>  include/uapi/linux/kvm.h                   |   9 +
>  28 files changed, 4502 insertions(+), 14 deletions(-)
>  create mode 100644 arch/loongarch/include/asm/kvm_csr.h
>  create mode 100644 arch/loongarch/include/asm/kvm_host.h
>  create mode 100644 arch/loongarch/include/asm/kvm_types.h
>  create mode 100644 arch/loongarch/include/asm/kvm_vcpu.h
>  create mode 100644 arch/loongarch/include/uapi/asm/kvm.h
>  create mode 100644 arch/loongarch/kvm/Kconfig
>  create mode 100644 arch/loongarch/kvm/Makefile
>  create mode 100644 arch/loongarch/kvm/csr_ops.S
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
>  create mode 100644 arch/loongarch/kvm/vmid.c
>
> --
> 2.27.0
>
