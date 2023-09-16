Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E61647A2D9B
	for <lists+kvm@lfdr.de>; Sat, 16 Sep 2023 05:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238126AbjIPDRp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 23:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237962AbjIPDRi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 23:17:38 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811E8FB;
        Fri, 15 Sep 2023 20:17:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F20E4C433CC;
        Sat, 16 Sep 2023 03:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694834252;
        bh=vBD4G1FO5TN6W0hWcfIL/vbLK/VN3eBR0AlAZ8bCqng=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=h65aslw8ZSLmUcSFJIiKRAGbRmUb/urPWMsiV94Hg+/eajDBCa8i3Q+fXxvShH+fS
         0afc6qozqNGQkVDPwz2ywKcB6TsMWnj76tnLgAR+GPk5dzuc/+MirqLgKjQdB39siT
         /GccJNfq7mGzPhOhHGwuFLtTBDJxO9Wa/KJFkXIt+WWLt0U51aSTwkmgYxFT5Ln8cO
         Hz06uTkSIjPfQ3Vycd6XLCJZTNDKVa2UuDWMJyAsr+5Fj8JzUgkI8WRa0ho2zHE505
         U6RnYL/9VSsLyNziow4PfWrUy1GuUCzdrOBOMzjqzCjGW/2x18zNOv9514uh/ZLpuk
         gelHF6QnaWL3Q==
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-401b5516104so29953355e9.2;
        Fri, 15 Sep 2023 20:17:31 -0700 (PDT)
X-Gm-Message-State: AOJu0YylZNwMC7Bj2yWjYOA8TMl0Ht0ssDimIdKw9Wuhk3/Ze4qexnjj
        86DHNDWbyolwXfDRKGNHxFBSt1PYvTHLahANSUs=
X-Google-Smtp-Source: AGHT+IGfFcHJkLFZctPcaxDW73NfrcsgyMVsMItDYGy1fZsjH3hL7i69c73rcMSUJzC5l173qqq3aEU9q32rMcE5CNg=
X-Received: by 2002:adf:ce87:0:b0:31f:8a6d:e527 with SMTP id
 r7-20020adfce87000000b0031f8a6de527mr2457662wrn.45.1694834250293; Fri, 15 Sep
 2023 20:17:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230915014949.1222777-1-zhaotianrui@loongson.cn>
 <CAAhV-H5fbyoMk9XWsejU0zVg4jPq_t2PT3ODKiAnc1LNARpBzA@mail.gmail.com>
 <fed0bbb0-9c94-7dac-4956-f6c9b231fc0d@loongson.cn> <CAAhV-H5_KwmkEczws2diHpk5gDUZSAmy_7Zgi=CowhGZN9_d_A@mail.gmail.com>
 <e53a4428-7533-61cd-81c5-0a65877041fd@loongson.cn>
In-Reply-To: <e53a4428-7533-61cd-81c5-0a65877041fd@loongson.cn>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Sat, 16 Sep 2023 11:17:17 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7QKBEV_dSfX8nprZ838HRCcDt8cziPip4UdSMuYvERzQ@mail.gmail.com>
Message-ID: <CAAhV-H7QKBEV_dSfX8nprZ838HRCcDt8cziPip4UdSMuYvERzQ@mail.gmail.com>
Subject: Re: [PATCH v21 00/29] Add KVM LoongArch support
To:     zhaotianrui <zhaotianrui@loongson.cn>
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

On Fri, Sep 15, 2023 at 3:53=E2=80=AFPM zhaotianrui <zhaotianrui@loongson.c=
n> wrote:
>
>
> =E5=9C=A8 2023/9/15 =E4=B8=8B=E5=8D=883:10, Huacai Chen =E5=86=99=E9=81=
=93:
> > Hi, Tianrui,
> >
> > On Fri, Sep 15, 2023 at 2:58=E2=80=AFPM zhaotianrui <zhaotianrui@loongs=
on.cn> wrote:
> >>
> >> =E5=9C=A8 2023/9/15 =E4=B8=8B=E5=8D=8812:11, Huacai Chen =E5=86=99=E9=
=81=93:
> >>> Hi, Tianrui,
> >>>
> >>> On Fri, Sep 15, 2023 at 9:50=E2=80=AFAM Tianrui Zhao <zhaotianrui@loo=
ngson.cn> wrote:
> >>>> This series adds KVM LoongArch support. Loongson 3A5000 supports har=
dware
> >>>> assisted virtualization. With cpu virtualization, there are separate
> >>>> hw-supported user mode and kernel mode in guest mode. With memory
> >>>> virtualization, there are two-level hw mmu table for guest mode and =
host
> >>>> mode. Also there is separate hw cpu timer with consant frequency in
> >>>> guest mode, so that vm can migrate between hosts with different freq=
.
> >>>> Currently, we are able to boot LoongArch Linux Guests.
> >>>>
> >>>> Few key aspects of KVM LoongArch added by this series are:
> >>>> 1. Enable kvm hardware function when kvm module is loaded.
> >>>> 2. Implement VM and vcpu related ioctl interface such as vcpu create=
,
> >>>>      vcpu run etc. GET_ONE_REG/SET_ONE_REG ioctl commands are use to
> >>>>      get general registers one by one.
> >>>> 3. Hardware access about MMU, timer and csr are emulated in kernel.
> >>>> 4. Hardwares such as mmio and iocsr device are emulated in user spac=
e
> >>>>      such as APIC, IPI, pci devices etc.
> >>>>
> >>>> The running environment of LoongArch virt machine:
> >>>> 1. Cross tools for building kernel and uefi:
> >>>>      https://github.com/loongson/build-tools
> >>>> 2. This series is based on the linux source code:
> >>>>      https://github.com/loongson/linux-loongarch-kvm
> >>>>      Build command:
> >>>>      git checkout kvm-loongarch
> >>>>      make ARCH=3Dloongarch CROSS_COMPILE=3Dloongarch64-unknown-linux=
-gnu- loongson3_defconfig
> >>>>      make ARCH=3Dloongarch CROSS_COMPILE=3Dloongarch64-unknown-linux=
-gnu-
> >>>> 3. QEMU hypervisor with LoongArch supported:
> >>>>      https://github.com/loongson/qemu
> >>>>      Build command:
> >>>>      git checkout kvm-loongarch
> >>>>      ./configure --target-list=3D"loongarch64-softmmu"  --enable-kvm
> >>>>      make
> >>> When I build qemu, I get:
> >>> [3/964] Compiling C object
> >>> libqemu-loongarch64-softmmu.fa.p/target_loongarch_loongarch-qmp-cmds.=
c.o
> >>> FAILED: libqemu-loongarch64-softmmu.fa.p/target_loongarch_loongarch-q=
mp-cmds.c.o
> >>> cc -Ilibqemu-loongarch64-softmmu.fa.p -I. -I.. -Itarget/loongarch
> >>> -I../target/loongarch -Isubprojects/dtc/libfdt
> >>> -I../subprojects/dtc/libfdt -Iqapi -Itrace c
> >>> In file included from ../target/loongarch/loongarch-qmp-cmds.c:11:
> >>> ../target/loongarch/cpu.h:351:14: error: duplicate member 'CSR_CPUID'
> >>>     351 |     uint64_t CSR_CPUID;
> >>>         |              ^~~~~~~~~
> >>> ninja: build stopped: subcommand failed.
> >>> make[1]: *** [Makefile:162: run-ninja] Error 1
> >>> make[1]: Leaving directory '/root/qemu/build'
> >>> make: *** [GNUmakefile:11: all] Error 2
> >>>
> >>> Huacai
> >> Sorry, I have submitted patch to fix this error, you could git pull to
> >> update it.
> > After git pull, I get a new error:
> > [70/912] Compiling C object
> > libqemu-loongarch64-softmmu.fa.p/accel_tcg_tcg-accel-ops-icount.c.o
> > [71/912] Compiling C object
> > libqemu-loongarch64-softmmu.fa.p/accel_tcg_tcg-accel-ops-rr.c.o
> > [72/912] Linking target qemu-system-loongarch64
> > FAILED: qemu-system-loongarch64
> > cc  -o qemu-system-loongarch64 libcommon.fa.p/hw_core_cpu-common.c.o
> > libcommon.fa.p/hw_core_machine-smp.c.o
> > libcommon.fa.p/gdbstub_syscalls.c.o libcommon.fap
> > /usr/bin/ld: libqemu-loongarch64-softmmu.fa.p/accel_kvm_kvm-all.c.o:
> > in function `kvm_init':
> > /root/qemu/build/../accel/kvm/kvm-all.c:2525:(.text+0x66f4): undefined
> > reference to `kvm_arch_get_default_type'
> > collect2: error: ld returned 1 exit status
> > ninja: build stopped: subcommand failed.
> > make[1]: *** [Makefile:162: run-ninja] Error 1
> > make[1]: Leaving directory '/root/qemu/build'
> > make: *** [GNUmakefile:11: all] Error 2
> >
> > Huacai
> Sorry, I have resolved this mistake and submit to the source, you could
> update it.
I can test now, during my tests I may ask some other questions about
your patches. You just need to answer my questions and I will adjust
the code myself if needed. After that I will give you a final version
with Tested-by and you can simply send that as V22.

Huacai

>
> Thanks
> Tianrui Zhao
> >
> >> Thanks
> >> Tianrui Zhao
> >>>> 4. Uefi bios of LoongArch virt machine:
> >>>>      Link: https://github.com/tianocore/edk2-platforms/tree/master/P=
latform/Loongson/LoongArchQemuPkg#readme
> >>>> 5. you can also access the binary files we have already build:
> >>>>      https://github.com/yangxiaojuan-loongson/qemu-binary
> >>>> The command to boot loongarch virt machine:
> >>>>      $ qemu-system-loongarch64 -machine virt -m 4G -cpu la464 \
> >>>>      -smp 1 -bios QEMU_EFI.fd -kernel vmlinuz.efi -initrd ramdisk \
> >>>>      -serial stdio   -monitor telnet:localhost:4495,server,nowait \
> >>>>      -append "root=3D/dev/ram rdinit=3D/sbin/init console=3DttyS0,11=
5200" \
> >>>>      --nographic
> >>>>
> >>>> Changes for v21:
> >>>> 1. Remove unnecessary prefix '_' in some kvm function names.
> >>>> 2. Replace check_vmid with check_vpid, and move the functions
> >>>> to main.c.
> >>>> 3. Re-order the file names and config names by alphabetical
> >>>> in KVM makefile and Kconfig.
> >>>> 4. Code clean up for KVM mmu and get,set gcsr and vcpu_arch
> >>>> ioctl functions.
> >>>>
> >>>> changes for v20:
> >>>> 1. Remove the binary code of virtualization instructions in
> >>>> insn_def.h and csr_ops.S and directly use the default csrrd,
> >>>> csrwr,csrxchg instructions. And let CONFIG_KVM depends on the
> >>>> AS_HAS_LVZ_EXTENSION, so we should use the binutils that have
> >>>> already supported them to compile the KVM. This can make our
> >>>> LoongArch KVM codes more maintainable and easier.
> >>>>
> >>>> changes for v19:
> >>>> 1. Use the common interface xfer_to_guest_mode_handle_work to
> >>>> Check conditions before entering the guest.
> >>>> 2. Add vcpu dirty ring support.
> >>>>
> >>>> changes for v18:
> >>>> 1. Code cleanup for vcpu timer: remove unnecessary timer_period_ns,
> >>>> timer_bias, timer_dyn_bias variables in kvm_vcpu_arch and rename
> >>>> the stable_ktime_saved variable to expire.
> >>>> 2. Change the value of KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE to 40.
> >>>>
> >>>> changes for v17:
> >>>> 1. Add CONFIG_AS_HAS_LVZ_EXTENSION config option which depends on
> >>>> binutils that support LVZ assemble instruction.
> >>>> 2. Change kvm mmu related functions, such as rename level2_ptw_pgd
> >>>> to kvm_ptw_pgd, replace kvm_flush_range with kvm_ptw_pgd pagewalk
> >>>> framework, replace kvm_arch.gpa_mm with kvm_arch.pgd, set
> >>>> mark_page_dirty/kvm_set_pfn_dirty out of mmu_lock in kvm page fault
> >>>> handling.
> >>>> 3. Replace kvm_loongarch_interrupt with standard kvm_interrupt
> >>>> when injecting IRQ.
> >>>> 4. Replace vcpu_arch.last_exec_cpu with existing vcpu.cpu, remove
> >>>> kvm_arch.online_vcpus and kvm_arch.is_migrating,
> >>>> 5. Remove EXCCODE_TLBNR and EXCCODE_TLBNX in kvm exception table,
> >>>> since NR/NX bit is not set in kvm page fault handling.
> >>>>
> >>>> Changes for v16:
> >>>> 1. Free allocated memory of vmcs,kvm_loongarch_ops in kvm module ini=
t,
> >>>> exit to avoid memory leak problem.
> >>>> 2. Simplify some assemble codes in switch.S which are necessary to b=
e
> >>>> replaced with pseudo-instructions. And any other instructions do not=
 need
> >>>> to be replaced anymore.
> >>>> 3. Add kvm_{save,restore}_guest_gprs macros to replace these ld.d,st=
.d
> >>>> guest regs instructions when vcpu world switch.
> >>>> 4. It is more secure to disable irq when flush guest tlb by gpa, so =
replace
> >>>> preempt_disable with loacl_irq_save in kvm_flush_tlb_gpa.
> >>>>
> >>>> Changes for v15:
> >>>> 1. Re-order some macros and variables in LoongArch kvm headers, put =
them
> >>>> together which have the same meaning.
> >>>> 2. Make some function definitions in one line, as it is not needed t=
o split
> >>>> them.
> >>>> 3. Re-name some macros such as KVM_REG_LOONGARCH_GPR.
> >>>>
> >>>> Changes for v14:
> >>>> 1. Remove the macro CONFIG_KVM_GENERIC_HARDWARE_ENABLING in
> >>>> loongarch/kvm/main.c, as it is not useful.
> >>>> 2. Add select KVM_GENERIC_HARDWARE_ENABLING in loongarch/kvm/Kconfig=
,
> >>>> as it is used by virt/kvm.
> >>>> 3. Fix the LoongArch KVM source link in MAINTAINERS.
> >>>> 4. Improve LoongArch KVM documentation, such as add comment for
> >>>> LoongArch kvm_regs.
> >>>>
> >>>> Changes for v13:
> >>>> 1. Remove patch-28 "Implement probe virtualization when cpu init", a=
s the
> >>>> virtualization information about FPU,PMP,LSX in guest.options,option=
s_dyn
> >>>> is not used and the gcfg reg value can be read in kvm_hardware_enabl=
e, so
> >>>> remove the previous cpu_probe_lvz function.
> >>>> 2. Fix vcpu_enable_cap interface, it should return -EINVAL directly,=
 as
> >>>> FPU cap is enable by default, and do not support any other caps now.
> >>>> 3. Simplify the jirl instruction with jr when without return addr,
> >>>> simplify case HW0 ... HW7 statment in interrupt.c
> >>>> 4. Rename host_stack,host_gp in kvm_vcpu_arch to host_sp,host_tp.
> >>>> 5. Remove 'cpu' parameter in _kvm_check_requests, as 'cpu' is not us=
ed,
> >>>> and remove 'cpu' parameter in kvm_check_vmid function, as it can get
> >>>> cpu number by itself.
> >>>>
> >>>> Changes for v12:
> >>>> 1. Improve the gcsr write/read/xchg interface to avoid the previous
> >>>> instruction statment like parse_r and make the code easy understandi=
ng,
> >>>> they are implemented in asm/insn-def.h and the instructions consiste=
nt
> >>>> of "opcode" "rj" "rd" "simm14" arguments.
> >>>> 2. Fix the maintainers list of LoongArch KVM.
> >>>>
> >>>> Changes for v11:
> >>>> 1. Add maintainers for LoongArch KVM.
> >>>>
> >>>> Changes for v10:
> >>>> 1. Fix grammatical problems in LoongArch documentation.
> >>>> 2. It is not necessary to save or restore the LOONGARCH_CSR_PGD when
> >>>> vcpu put and vcpu load, so we remove it.
> >>>>
> >>>> Changes for v9:
> >>>> 1. Apply the new defined interrupt number macros in loongarch.h to k=
vm,
> >>>> such as INT_SWI0, INT_HWI0, INT_TI, INT_IPI, etc. And remove the
> >>>> previous unused macros.
> >>>> 2. Remove unused variables in kvm_vcpu_arch, and reorder the variabl=
es
> >>>> to make them more standard.
> >>>>
> >>>> Changes for v8:
> >>>> 1. Adjust the cpu_data.guest.options structure, add the ases flag in=
to
> >>>> it, and remove the previous guest.ases. We do this to keep consisten=
t
> >>>> with host cpu_data.options structure.
> >>>> 2. Remove the "#include <asm/kvm_host.h>" in some files which also
> >>>> include the "<linux/kvm_host.h>". As linux/kvm_host.h already includ=
e
> >>>> the asm/kvm_host.h.
> >>>> 3. Fix some unstandard spelling and grammar errors in comments, and
> >>>> improve a little code format to make it easier and standard.
> >>>>
> >>>> Changes for v7:
> >>>> 1. Fix the kvm_save/restore_hw_gcsr compiling warnings reported by
> >>>> kernel test robot. The report link is:
> >>>> https://lore.kernel.org/oe-kbuild-all/202304131526.iXfLaVZc-lkp@inte=
l.com/
> >>>> 2. Fix loongarch kvm trace related compiling problems.
> >>>>
> >>>> Changes for v6:
> >>>> 1. Fix the Documentation/virt/kvm/api.rst compile warning about
> >>>> loongarch parts.
> >>>>
> >>>> Changes for v5:
> >>>> 1. Implement get/set mp_state ioctl interface, and only the
> >>>> KVM_MP_STATE_RUNNABLE state is supported now, and other states
> >>>> will be completed in the future. The state is also used when vcpu
> >>>> run idle instruction, if vcpu state is changed to RUNNABLE, the
> >>>> vcpu will have the possibility to be woken up.
> >>>> 2. Supplement kvm document about loongarch-specific part, such as ad=
d
> >>>> api introduction for GET/SET_ONE_REG, GET/SET_FPU, GET/SET_MP_STATE,
> >>>> etc.
> >>>> 3. Improve the kvm_switch_to_guest function in switch.S, remove the
> >>>> previous tmp,tmp1 arguments and replace it with t0,t1 reg.
> >>>>
> >>>> Changes for v4:
> >>>> 1. Add a csr_need_update flag in _vcpu_put, as most csr registers ke=
ep
> >>>> unchanged during process context switch, so we need not to update it
> >>>> every time. We can do this only if the soft csr is different form ha=
rdware.
> >>>> That is to say all of csrs should update after vcpu enter guest, as =
for
> >>>> set_csr_ioctl, we have written soft csr to keep consistent with hard=
ware.
> >>>> 2. Improve get/set_csr_ioctl interface, we set SW or HW or INVALID f=
lag
> >>>> for all csrs according to it's features when kvm init. In get/set_cs=
r_ioctl,
> >>>> if csr is HW, we use gcsrrd/ gcsrwr instruction to access it, else i=
f csr is
> >>>> SW, we use software to emulate it, and others return false.
> >>>> 3. Add set_hw_gcsr function in csr_ops.S, and it is used in set_csr_=
ioctl.
> >>>> We have splited hw gcsr into three parts, so we can calculate the co=
de offset
> >>>> by gcsrid and jump here to run the gcsrwr instruction. We use this f=
unction to
> >>>> make the code easier and avoid to use the previous SET_HW_GCSR(XXX) =
interface.
> >>>> 4. Improve kvm mmu functions, such as flush page table and make clea=
n page table
> >>>> interface.
> >>>>
> >>>> Changes for v3:
> >>>> 1. Remove the vpid array list in kvm_vcpu_arch and use a vpid variab=
le here,
> >>>> because a vpid will never be recycled if a vCPU migrates from physic=
al CPU A
> >>>> to B and back to A.
> >>>> 2. Make some constant variables in kvm_context to global such as vpi=
d_mask,
> >>>> guest_eentry, enter_guest, etc.
> >>>> 3. Add some new tracepoints, such as kvm_trace_idle, kvm_trace_cache=
,
> >>>> kvm_trace_gspr, etc.
> >>>> 4. There are some duplicate codes in kvm_handle_exit and kvm_vcpu_ru=
n,
> >>>> so we move it to a new function kvm_pre_enter_guest.
> >>>> 5. Change the RESUME_HOST, RESUME_GUEST value, return 1 for resume g=
uest
> >>>> and "<=3D 0" for resume host.
> >>>> 6. Fcsr and fpu registers are saved/restored together.
> >>>>
> >>>> Changes for v2:
> >>>> 1. Seprate the original patch-01 and patch-03 into small patches, an=
d the
> >>>> patches mainly contain kvm module init, module exit, vcpu create, vc=
pu run,
> >>>> etc.
> >>>> 2. Remove the original KVM_{GET,SET}_CSRS ioctl in the kvm uapi head=
er,
> >>>> and we use the common KVM_{GET,SET}_ONE_REG to access register.
> >>>> 3. Use BIT(x) to replace the "1 << n_bits" statement.
> >>>>
> >>>> Tianrui Zhao (29):
> >>>>     LoongArch: KVM: Add kvm related header files
> >>>>     LoongArch: KVM: Implement kvm module related interface
> >>>>     LoongArch: KVM: Implement kvm hardware enable, disable interface
> >>>>     LoongArch: KVM: Implement VM related functions
> >>>>     LoongArch: KVM: Add vcpu related header files
> >>>>     LoongArch: KVM: Implement vcpu create and destroy interface
> >>>>     LoongArch: KVM: Implement vcpu run interface
> >>>>     LoongArch: KVM: Implement vcpu handle exit interface
> >>>>     LoongArch: KVM: Implement vcpu get, vcpu set registers
> >>>>     LoongArch: KVM: Implement vcpu ENABLE_CAP ioctl interface
> >>>>     LoongArch: KVM: Implement fpu related operations for vcpu
> >>>>     LoongArch: KVM: Implement vcpu interrupt operations
> >>>>     LoongArch: KVM: Implement misc vcpu related interfaces
> >>>>     LoongArch: KVM: Implement vcpu load and vcpu put operations
> >>>>     LoongArch: KVM: Implement vcpu status description
> >>>>     LoongArch: KVM: Implement virtual machine tlb operations
> >>>>     LoongArch: KVM: Implement vcpu timer operations
> >>>>     LoongArch: KVM: Implement kvm mmu operations
> >>>>     LoongArch: KVM: Implement handle csr exception
> >>>>     LoongArch: KVM: Implement handle iocsr exception
> >>>>     LoongArch: KVM: Implement handle idle exception
> >>>>     LoongArch: KVM: Implement handle gspr exception
> >>>>     LoongArch: KVM: Implement handle mmio exception
> >>>>     LoongArch: KVM: Implement handle fpu exception
> >>>>     LoongArch: KVM: Implement kvm exception vector
> >>>>     LoongArch: KVM: Implement vcpu world switch
> >>>>     LoongArch: KVM: Enable kvm config and add the makefile
> >>>>     LoongArch: KVM: Supplement kvm document about LoongArch-specific=
 part
> >>>>     LoongArch: KVM: Add maintainers for LoongArch KVM
> >>>>
> >>>>    Documentation/virt/kvm/api.rst             |  70 +-
> >>>>    MAINTAINERS                                |  12 +
> >>>>    arch/loongarch/Kbuild                      |   1 +
> >>>>    arch/loongarch/Kconfig                     |   3 +
> >>>>    arch/loongarch/configs/loongson3_defconfig |   2 +
> >>>>    arch/loongarch/include/asm/inst.h          |  16 +
> >>>>    arch/loongarch/include/asm/kvm_csr.h       | 221 +++++
> >>>>    arch/loongarch/include/asm/kvm_host.h      | 245 ++++++
> >>>>    arch/loongarch/include/asm/kvm_mmu.h       | 138 +++
> >>>>    arch/loongarch/include/asm/kvm_types.h     |  11 +
> >>>>    arch/loongarch/include/asm/kvm_vcpu.h      | 107 +++
> >>>>    arch/loongarch/include/asm/loongarch.h     |  19 +-
> >>>>    arch/loongarch/include/uapi/asm/kvm.h      | 108 +++
> >>>>    arch/loongarch/kernel/asm-offsets.c        |  32 +
> >>>>    arch/loongarch/kvm/Kconfig                 |  45 +
> >>>>    arch/loongarch/kvm/Makefile                |  20 +
> >>>>    arch/loongarch/kvm/exit.c                  | 711 ++++++++++++++++
> >>>>    arch/loongarch/kvm/interrupt.c             | 185 ++++
> >>>>    arch/loongarch/kvm/main.c                  | 429 ++++++++++
> >>>>    arch/loongarch/kvm/mmu.c                   | 922 ++++++++++++++++=
++++
> >>>>    arch/loongarch/kvm/switch.S                | 255 ++++++
> >>>>    arch/loongarch/kvm/timer.c                 | 200 +++++
> >>>>    arch/loongarch/kvm/tlb.c                   |  34 +
> >>>>    arch/loongarch/kvm/trace.h                 | 166 ++++
> >>>>    arch/loongarch/kvm/vcpu.c                  | 940 ++++++++++++++++=
+++++
> >>>>    arch/loongarch/kvm/vm.c                    |  92 ++
> >>>>    include/uapi/linux/kvm.h                   |   9 +
> >>>>    27 files changed, 4979 insertions(+), 14 deletions(-)
> >>>>    create mode 100644 arch/loongarch/include/asm/kvm_csr.h
> >>>>    create mode 100644 arch/loongarch/include/asm/kvm_host.h
> >>>>    create mode 100644 arch/loongarch/include/asm/kvm_mmu.h
> >>>>    create mode 100644 arch/loongarch/include/asm/kvm_types.h
> >>>>    create mode 100644 arch/loongarch/include/asm/kvm_vcpu.h
> >>>>    create mode 100644 arch/loongarch/include/uapi/asm/kvm.h
> >>>>    create mode 100644 arch/loongarch/kvm/Kconfig
> >>>>    create mode 100644 arch/loongarch/kvm/Makefile
> >>>>    create mode 100644 arch/loongarch/kvm/exit.c
> >>>>    create mode 100644 arch/loongarch/kvm/interrupt.c
> >>>>    create mode 100644 arch/loongarch/kvm/main.c
> >>>>    create mode 100644 arch/loongarch/kvm/mmu.c
> >>>>    create mode 100644 arch/loongarch/kvm/switch.S
> >>>>    create mode 100644 arch/loongarch/kvm/timer.c
> >>>>    create mode 100644 arch/loongarch/kvm/tlb.c
> >>>>    create mode 100644 arch/loongarch/kvm/trace.h
> >>>>    create mode 100644 arch/loongarch/kvm/vcpu.c
> >>>>    create mode 100644 arch/loongarch/kvm/vm.c
> >>>>
> >>>> --
> >>>> 2.39.1
> >>>>
>
