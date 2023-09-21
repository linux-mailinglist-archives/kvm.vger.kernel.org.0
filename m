Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90B007A9754
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 19:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjIURWj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 13:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjIURW1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 13:22:27 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00EBD44F5A;
        Thu, 21 Sep 2023 10:13:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D35C433BD;
        Thu, 21 Sep 2023 07:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695280660;
        bh=iKCJ1zBZ10b3Kxv91JANLdPJVhzuMu9Nplu1UNbyuYo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=j9M/geeSaAfls4R7FLSbbRNPWvQie7hpgpPpbvItaarqcnycxA9Wiw49/23YFjzUj
         5cpAdY5EKGpYE3xfOmmZBD0k+VvaO0xQ6i3hGsEoKV1WGbIopwz4gO19ydQ+AxggIF
         M7fUuBXoiR80sJTJnQV1zGNBmXpkfAU21gkr0q2q4pcv8p64cyA2KWcn+bYWKUZE0E
         cT3lVroiKzyKa3ijdu86EhUKW8JkumLSFLUuMntwwSERjf6tMevs9xNkL8Ju0QbyBD
         ozuWtQut8+6YgljKWIOYo09gl7hsFFNL4GP4Zu8dATmize2dj8VZq15BAV0JL2Zfv6
         IB6n7FTqE+wqw==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-530e180ffcbso581376a12.1;
        Thu, 21 Sep 2023 00:17:39 -0700 (PDT)
X-Gm-Message-State: AOJu0YwOycyT0PeEThFud0mILUgM/qcC3DpaNBDQKCfcB6RsiYy7/JQm
        Xbnowg8GAS+l2XrnZDDxpwwsiLqhgn7GZxhSwpw=
X-Google-Smtp-Source: AGHT+IE/7qRZ6nt91U/OSRqKtDGtbLr1Uzw7z0y984LmeKwx5eLgyOapyA5naAL69AFUdluCLOEl3l4S9BJSogWK3SI=
X-Received: by 2002:aa7:c407:0:b0:530:a925:77a6 with SMTP id
 j7-20020aa7c407000000b00530a92577a6mr4528452edq.8.1695280658228; Thu, 21 Sep
 2023 00:17:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230915014949.1222777-1-zhaotianrui@loongson.cn>
 <CAAhV-H5fbyoMk9XWsejU0zVg4jPq_t2PT3ODKiAnc1LNARpBzA@mail.gmail.com>
 <fed0bbb0-9c94-7dac-4956-f6c9b231fc0d@loongson.cn> <CAAhV-H5_KwmkEczws2diHpk5gDUZSAmy_7Zgi=CowhGZN9_d_A@mail.gmail.com>
 <e53a4428-7533-61cd-81c5-0a65877041fd@loongson.cn> <CAAhV-H7QKBEV_dSfX8nprZ838HRCcDt8cziPip4UdSMuYvERzQ@mail.gmail.com>
 <1f13e290-4655-99c2-7edd-d62c71e13498@loongson.cn>
In-Reply-To: <1f13e290-4655-99c2-7edd-d62c71e13498@loongson.cn>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Thu, 21 Sep 2023 15:17:26 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6cCnvduCQiXGY=74YAKt1zLM9dBqMKUN6ELQ=4t3Fwqg@mail.gmail.com>
Message-ID: <CAAhV-H6cCnvduCQiXGY=74YAKt1zLM9dBqMKUN6ELQ=4t3Fwqg@mail.gmail.com>
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

On Sat, Sep 16, 2023 at 2:30=E2=80=AFPM zhaotianrui <zhaotianrui@loongson.c=
n> wrote:
>
>
> =E5=9C=A8 2023/9/16 =E4=B8=8A=E5=8D=8811:17, Huacai Chen =E5=86=99=E9=81=
=93:
> > Hi, Tianrui,
> >
> > On Fri, Sep 15, 2023 at 3:53=E2=80=AFPM zhaotianrui <zhaotianrui@loongs=
on.cn> wrote:
> >>
> >> =E5=9C=A8 2023/9/15 =E4=B8=8B=E5=8D=883:10, Huacai Chen =E5=86=99=E9=
=81=93:
> >>> Hi, Tianrui,
> >>>
> >>> On Fri, Sep 15, 2023 at 2:58=E2=80=AFPM zhaotianrui <zhaotianrui@loon=
gson.cn> wrote:
> >>>> =E5=9C=A8 2023/9/15 =E4=B8=8B=E5=8D=8812:11, Huacai Chen =E5=86=99=
=E9=81=93:
> >>>>> Hi, Tianrui,
> >>>>>
> >>>>> On Fri, Sep 15, 2023 at 9:50=E2=80=AFAM Tianrui Zhao <zhaotianrui@l=
oongson.cn> wrote:
> >>>>>> This series adds KVM LoongArch support. Loongson 3A5000 supports h=
ardware
> >>>>>> assisted virtualization. With cpu virtualization, there are separa=
te
> >>>>>> hw-supported user mode and kernel mode in guest mode. With memory
> >>>>>> virtualization, there are two-level hw mmu table for guest mode an=
d host
> >>>>>> mode. Also there is separate hw cpu timer with consant frequency i=
n
> >>>>>> guest mode, so that vm can migrate between hosts with different fr=
eq.
> >>>>>> Currently, we are able to boot LoongArch Linux Guests.
> >>>>>>
> >>>>>> Few key aspects of KVM LoongArch added by this series are:
> >>>>>> 1. Enable kvm hardware function when kvm module is loaded.
> >>>>>> 2. Implement VM and vcpu related ioctl interface such as vcpu crea=
te,
> >>>>>>       vcpu run etc. GET_ONE_REG/SET_ONE_REG ioctl commands are use=
 to
> >>>>>>       get general registers one by one.
> >>>>>> 3. Hardware access about MMU, timer and csr are emulated in kernel=
.
> >>>>>> 4. Hardwares such as mmio and iocsr device are emulated in user sp=
ace
> >>>>>>       such as APIC, IPI, pci devices etc.
> >>>>>>
> >>>>>> The running environment of LoongArch virt machine:
> >>>>>> 1. Cross tools for building kernel and uefi:
> >>>>>>       https://github.com/loongson/build-tools
> >>>>>> 2. This series is based on the linux source code:
> >>>>>>       https://github.com/loongson/linux-loongarch-kvm
> >>>>>>       Build command:
> >>>>>>       git checkout kvm-loongarch
> >>>>>>       make ARCH=3Dloongarch CROSS_COMPILE=3Dloongarch64-unknown-li=
nux-gnu- loongson3_defconfig
> >>>>>>       make ARCH=3Dloongarch CROSS_COMPILE=3Dloongarch64-unknown-li=
nux-gnu-
> >>>>>> 3. QEMU hypervisor with LoongArch supported:
> >>>>>>       https://github.com/loongson/qemu
> >>>>>>       Build command:
> >>>>>>       git checkout kvm-loongarch
> >>>>>>       ./configure --target-list=3D"loongarch64-softmmu"  --enable-=
kvm
> >>>>>>       make
> >>>>> When I build qemu, I get:
> >>>>> [3/964] Compiling C object
> >>>>> libqemu-loongarch64-softmmu.fa.p/target_loongarch_loongarch-qmp-cmd=
s.c.o
> >>>>> FAILED: libqemu-loongarch64-softmmu.fa.p/target_loongarch_loongarch=
-qmp-cmds.c.o
> >>>>> cc -Ilibqemu-loongarch64-softmmu.fa.p -I. -I.. -Itarget/loongarch
> >>>>> -I../target/loongarch -Isubprojects/dtc/libfdt
> >>>>> -I../subprojects/dtc/libfdt -Iqapi -Itrace c
> >>>>> In file included from ../target/loongarch/loongarch-qmp-cmds.c:11:
> >>>>> ../target/loongarch/cpu.h:351:14: error: duplicate member 'CSR_CPUI=
D'
> >>>>>      351 |     uint64_t CSR_CPUID;
> >>>>>          |              ^~~~~~~~~
> >>>>> ninja: build stopped: subcommand failed.
> >>>>> make[1]: *** [Makefile:162: run-ninja] Error 1
> >>>>> make[1]: Leaving directory '/root/qemu/build'
> >>>>> make: *** [GNUmakefile:11: all] Error 2
> >>>>>
> >>>>> Huacai
> >>>> Sorry, I have submitted patch to fix this error, you could git pull =
to
> >>>> update it.
> >>> After git pull, I get a new error:
> >>> [70/912] Compiling C object
> >>> libqemu-loongarch64-softmmu.fa.p/accel_tcg_tcg-accel-ops-icount.c.o
> >>> [71/912] Compiling C object
> >>> libqemu-loongarch64-softmmu.fa.p/accel_tcg_tcg-accel-ops-rr.c.o
> >>> [72/912] Linking target qemu-system-loongarch64
> >>> FAILED: qemu-system-loongarch64
> >>> cc  -o qemu-system-loongarch64 libcommon.fa.p/hw_core_cpu-common.c.o
> >>> libcommon.fa.p/hw_core_machine-smp.c.o
> >>> libcommon.fa.p/gdbstub_syscalls.c.o libcommon.fap
> >>> /usr/bin/ld: libqemu-loongarch64-softmmu.fa.p/accel_kvm_kvm-all.c.o:
> >>> in function `kvm_init':
> >>> /root/qemu/build/../accel/kvm/kvm-all.c:2525:(.text+0x66f4): undefine=
d
> >>> reference to `kvm_arch_get_default_type'
> >>> collect2: error: ld returned 1 exit status
> >>> ninja: build stopped: subcommand failed.
> >>> make[1]: *** [Makefile:162: run-ninja] Error 1
> >>> make[1]: Leaving directory '/root/qemu/build'
> >>> make: *** [GNUmakefile:11: all] Error 2
> >>>
> >>> Huacai
> >> Sorry, I have resolved this mistake and submit to the source, you coul=
d
> >> update it.
> > I can test now, during my tests I may ask some other questions about
> > your patches. You just need to answer my questions and I will adjust
> > the code myself if needed. After that I will give you a final version
> > with Tested-by and you can simply send that as V22.
> >
> > Huacai
> Ok, thanks for your reviewing carefully.

Now I complete my test and the final version is here:
https://github.com/chenhuacai/linux/commits/loongarch-next

You can pick the last 25 commits as v22. But please do a complete
testing before sending patches. And please contact with me if you have
any problems.

Changes for v22:
1. Combine very small patches.
2. Define KVM_REG_LOONGARCH_KVM registers begin with 1.
3. Remove unused KVM_LOONGSON_IRQ_* definitions.
4. Mark HW_GCSR/SW_GCSR correctly in kvm_init_gcsr_flag().
5. Make kvm_flush_tlb_gpa() be a void function, since it always return 0.
6. Rename KVM_REG_LOONGARCH_FPU to KVM_REG_LOONGARCH_FPSIMD which is
more accurate.
7. Rename KVM_LARCH_CSR to KVM_LARCH_SWCSR_LATEST, corresponding to
KVM_LARCH_HWCSR_USABLE.
8. Rename int_to_coreint to priority_to_irq, corresponding to the
defined varible names.
9. Replace if-else with switch-case in kvm_handle_csr().
10. Replace if-else with switch-case in
kvm_emu_mmio_read()/kvm_emu_mmio_write().
11. Remove ANON_INODES/SRCU in Kconfig since they are already selected
unconditinally.
12. Many coding style adjustment and typo fixes.



Huacai

>
> Thanks
> Tianrui Zhao
> >
> >> Thanks
> >> Tianrui Zhao
> >>>> Thanks
> >>>> Tianrui Zhao
> >>>>>> 4. Uefi bios of LoongArch virt machine:
> >>>>>>       Link: https://github.com/tianocore/edk2-platforms/tree/maste=
r/Platform/Loongson/LoongArchQemuPkg#readme
> >>>>>> 5. you can also access the binary files we have already build:
> >>>>>>       https://github.com/yangxiaojuan-loongson/qemu-binary
> >>>>>> The command to boot loongarch virt machine:
> >>>>>>       $ qemu-system-loongarch64 -machine virt -m 4G -cpu la464 \
> >>>>>>       -smp 1 -bios QEMU_EFI.fd -kernel vmlinuz.efi -initrd ramdisk=
 \
> >>>>>>       -serial stdio   -monitor telnet:localhost:4495,server,nowait=
 \
> >>>>>>       -append "root=3D/dev/ram rdinit=3D/sbin/init console=3DttyS0=
,115200" \
> >>>>>>       --nographic
> >>>>>>
> >>>>>> Changes for v21:
> >>>>>> 1. Remove unnecessary prefix '_' in some kvm function names.
> >>>>>> 2. Replace check_vmid with check_vpid, and move the functions
> >>>>>> to main.c.
> >>>>>> 3. Re-order the file names and config names by alphabetical
> >>>>>> in KVM makefile and Kconfig.
> >>>>>> 4. Code clean up for KVM mmu and get,set gcsr and vcpu_arch
> >>>>>> ioctl functions.
> >>>>>>
> >>>>>> changes for v20:
> >>>>>> 1. Remove the binary code of virtualization instructions in
> >>>>>> insn_def.h and csr_ops.S and directly use the default csrrd,
> >>>>>> csrwr,csrxchg instructions. And let CONFIG_KVM depends on the
> >>>>>> AS_HAS_LVZ_EXTENSION, so we should use the binutils that have
> >>>>>> already supported them to compile the KVM. This can make our
> >>>>>> LoongArch KVM codes more maintainable and easier.
> >>>>>>
> >>>>>> changes for v19:
> >>>>>> 1. Use the common interface xfer_to_guest_mode_handle_work to
> >>>>>> Check conditions before entering the guest.
> >>>>>> 2. Add vcpu dirty ring support.
> >>>>>>
> >>>>>> changes for v18:
> >>>>>> 1. Code cleanup for vcpu timer: remove unnecessary timer_period_ns=
,
> >>>>>> timer_bias, timer_dyn_bias variables in kvm_vcpu_arch and rename
> >>>>>> the stable_ktime_saved variable to expire.
> >>>>>> 2. Change the value of KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE to 40.
> >>>>>>
> >>>>>> changes for v17:
> >>>>>> 1. Add CONFIG_AS_HAS_LVZ_EXTENSION config option which depends on
> >>>>>> binutils that support LVZ assemble instruction.
> >>>>>> 2. Change kvm mmu related functions, such as rename level2_ptw_pgd
> >>>>>> to kvm_ptw_pgd, replace kvm_flush_range with kvm_ptw_pgd pagewalk
> >>>>>> framework, replace kvm_arch.gpa_mm with kvm_arch.pgd, set
> >>>>>> mark_page_dirty/kvm_set_pfn_dirty out of mmu_lock in kvm page faul=
t
> >>>>>> handling.
> >>>>>> 3. Replace kvm_loongarch_interrupt with standard kvm_interrupt
> >>>>>> when injecting IRQ.
> >>>>>> 4. Replace vcpu_arch.last_exec_cpu with existing vcpu.cpu, remove
> >>>>>> kvm_arch.online_vcpus and kvm_arch.is_migrating,
> >>>>>> 5. Remove EXCCODE_TLBNR and EXCCODE_TLBNX in kvm exception table,
> >>>>>> since NR/NX bit is not set in kvm page fault handling.
> >>>>>>
> >>>>>> Changes for v16:
> >>>>>> 1. Free allocated memory of vmcs,kvm_loongarch_ops in kvm module i=
nit,
> >>>>>> exit to avoid memory leak problem.
> >>>>>> 2. Simplify some assemble codes in switch.S which are necessary to=
 be
> >>>>>> replaced with pseudo-instructions. And any other instructions do n=
ot need
> >>>>>> to be replaced anymore.
> >>>>>> 3. Add kvm_{save,restore}_guest_gprs macros to replace these ld.d,=
st.d
> >>>>>> guest regs instructions when vcpu world switch.
> >>>>>> 4. It is more secure to disable irq when flush guest tlb by gpa, s=
o replace
> >>>>>> preempt_disable with loacl_irq_save in kvm_flush_tlb_gpa.
> >>>>>>
> >>>>>> Changes for v15:
> >>>>>> 1. Re-order some macros and variables in LoongArch kvm headers, pu=
t them
> >>>>>> together which have the same meaning.
> >>>>>> 2. Make some function definitions in one line, as it is not needed=
 to split
> >>>>>> them.
> >>>>>> 3. Re-name some macros such as KVM_REG_LOONGARCH_GPR.
> >>>>>>
> >>>>>> Changes for v14:
> >>>>>> 1. Remove the macro CONFIG_KVM_GENERIC_HARDWARE_ENABLING in
> >>>>>> loongarch/kvm/main.c, as it is not useful.
> >>>>>> 2. Add select KVM_GENERIC_HARDWARE_ENABLING in loongarch/kvm/Kconf=
ig,
> >>>>>> as it is used by virt/kvm.
> >>>>>> 3. Fix the LoongArch KVM source link in MAINTAINERS.
> >>>>>> 4. Improve LoongArch KVM documentation, such as add comment for
> >>>>>> LoongArch kvm_regs.
> >>>>>>
> >>>>>> Changes for v13:
> >>>>>> 1. Remove patch-28 "Implement probe virtualization when cpu init",=
 as the
> >>>>>> virtualization information about FPU,PMP,LSX in guest.options,opti=
ons_dyn
> >>>>>> is not used and the gcfg reg value can be read in kvm_hardware_ena=
ble, so
> >>>>>> remove the previous cpu_probe_lvz function.
> >>>>>> 2. Fix vcpu_enable_cap interface, it should return -EINVAL directl=
y, as
> >>>>>> FPU cap is enable by default, and do not support any other caps no=
w.
> >>>>>> 3. Simplify the jirl instruction with jr when without return addr,
> >>>>>> simplify case HW0 ... HW7 statment in interrupt.c
> >>>>>> 4. Rename host_stack,host_gp in kvm_vcpu_arch to host_sp,host_tp.
> >>>>>> 5. Remove 'cpu' parameter in _kvm_check_requests, as 'cpu' is not =
used,
> >>>>>> and remove 'cpu' parameter in kvm_check_vmid function, as it can g=
et
> >>>>>> cpu number by itself.
> >>>>>>
> >>>>>> Changes for v12:
> >>>>>> 1. Improve the gcsr write/read/xchg interface to avoid the previou=
s
> >>>>>> instruction statment like parse_r and make the code easy understan=
ding,
> >>>>>> they are implemented in asm/insn-def.h and the instructions consis=
tent
> >>>>>> of "opcode" "rj" "rd" "simm14" arguments.
> >>>>>> 2. Fix the maintainers list of LoongArch KVM.
> >>>>>>
> >>>>>> Changes for v11:
> >>>>>> 1. Add maintainers for LoongArch KVM.
> >>>>>>
> >>>>>> Changes for v10:
> >>>>>> 1. Fix grammatical problems in LoongArch documentation.
> >>>>>> 2. It is not necessary to save or restore the LOONGARCH_CSR_PGD wh=
en
> >>>>>> vcpu put and vcpu load, so we remove it.
> >>>>>>
> >>>>>> Changes for v9:
> >>>>>> 1. Apply the new defined interrupt number macros in loongarch.h to=
 kvm,
> >>>>>> such as INT_SWI0, INT_HWI0, INT_TI, INT_IPI, etc. And remove the
> >>>>>> previous unused macros.
> >>>>>> 2. Remove unused variables in kvm_vcpu_arch, and reorder the varia=
bles
> >>>>>> to make them more standard.
> >>>>>>
> >>>>>> Changes for v8:
> >>>>>> 1. Adjust the cpu_data.guest.options structure, add the ases flag =
into
> >>>>>> it, and remove the previous guest.ases. We do this to keep consist=
ent
> >>>>>> with host cpu_data.options structure.
> >>>>>> 2. Remove the "#include <asm/kvm_host.h>" in some files which also
> >>>>>> include the "<linux/kvm_host.h>". As linux/kvm_host.h already incl=
ude
> >>>>>> the asm/kvm_host.h.
> >>>>>> 3. Fix some unstandard spelling and grammar errors in comments, an=
d
> >>>>>> improve a little code format to make it easier and standard.
> >>>>>>
> >>>>>> Changes for v7:
> >>>>>> 1. Fix the kvm_save/restore_hw_gcsr compiling warnings reported by
> >>>>>> kernel test robot. The report link is:
> >>>>>> https://lore.kernel.org/oe-kbuild-all/202304131526.iXfLaVZc-lkp@in=
tel.com/
> >>>>>> 2. Fix loongarch kvm trace related compiling problems.
> >>>>>>
> >>>>>> Changes for v6:
> >>>>>> 1. Fix the Documentation/virt/kvm/api.rst compile warning about
> >>>>>> loongarch parts.
> >>>>>>
> >>>>>> Changes for v5:
> >>>>>> 1. Implement get/set mp_state ioctl interface, and only the
> >>>>>> KVM_MP_STATE_RUNNABLE state is supported now, and other states
> >>>>>> will be completed in the future. The state is also used when vcpu
> >>>>>> run idle instruction, if vcpu state is changed to RUNNABLE, the
> >>>>>> vcpu will have the possibility to be woken up.
> >>>>>> 2. Supplement kvm document about loongarch-specific part, such as =
add
> >>>>>> api introduction for GET/SET_ONE_REG, GET/SET_FPU, GET/SET_MP_STAT=
E,
> >>>>>> etc.
> >>>>>> 3. Improve the kvm_switch_to_guest function in switch.S, remove th=
e
> >>>>>> previous tmp,tmp1 arguments and replace it with t0,t1 reg.
> >>>>>>
> >>>>>> Changes for v4:
> >>>>>> 1. Add a csr_need_update flag in _vcpu_put, as most csr registers =
keep
> >>>>>> unchanged during process context switch, so we need not to update =
it
> >>>>>> every time. We can do this only if the soft csr is different form =
hardware.
> >>>>>> That is to say all of csrs should update after vcpu enter guest, a=
s for
> >>>>>> set_csr_ioctl, we have written soft csr to keep consistent with ha=
rdware.
> >>>>>> 2. Improve get/set_csr_ioctl interface, we set SW or HW or INVALID=
 flag
> >>>>>> for all csrs according to it's features when kvm init. In get/set_=
csr_ioctl,
> >>>>>> if csr is HW, we use gcsrrd/ gcsrwr instruction to access it, else=
 if csr is
> >>>>>> SW, we use software to emulate it, and others return false.
> >>>>>> 3. Add set_hw_gcsr function in csr_ops.S, and it is used in set_cs=
r_ioctl.
> >>>>>> We have splited hw gcsr into three parts, so we can calculate the =
code offset
> >>>>>> by gcsrid and jump here to run the gcsrwr instruction. We use this=
 function to
> >>>>>> make the code easier and avoid to use the previous SET_HW_GCSR(XXX=
) interface.
> >>>>>> 4. Improve kvm mmu functions, such as flush page table and make cl=
ean page table
> >>>>>> interface.
> >>>>>>
> >>>>>> Changes for v3:
> >>>>>> 1. Remove the vpid array list in kvm_vcpu_arch and use a vpid vari=
able here,
> >>>>>> because a vpid will never be recycled if a vCPU migrates from phys=
ical CPU A
> >>>>>> to B and back to A.
> >>>>>> 2. Make some constant variables in kvm_context to global such as v=
pid_mask,
> >>>>>> guest_eentry, enter_guest, etc.
> >>>>>> 3. Add some new tracepoints, such as kvm_trace_idle, kvm_trace_cac=
he,
> >>>>>> kvm_trace_gspr, etc.
> >>>>>> 4. There are some duplicate codes in kvm_handle_exit and kvm_vcpu_=
run,
> >>>>>> so we move it to a new function kvm_pre_enter_guest.
> >>>>>> 5. Change the RESUME_HOST, RESUME_GUEST value, return 1 for resume=
 guest
> >>>>>> and "<=3D 0" for resume host.
> >>>>>> 6. Fcsr and fpu registers are saved/restored together.
> >>>>>>
> >>>>>> Changes for v2:
> >>>>>> 1. Seprate the original patch-01 and patch-03 into small patches, =
and the
> >>>>>> patches mainly contain kvm module init, module exit, vcpu create, =
vcpu run,
> >>>>>> etc.
> >>>>>> 2. Remove the original KVM_{GET,SET}_CSRS ioctl in the kvm uapi he=
ader,
> >>>>>> and we use the common KVM_{GET,SET}_ONE_REG to access register.
> >>>>>> 3. Use BIT(x) to replace the "1 << n_bits" statement.
> >>>>>>
> >>>>>> Tianrui Zhao (29):
> >>>>>>      LoongArch: KVM: Add kvm related header files
> >>>>>>      LoongArch: KVM: Implement kvm module related interface
> >>>>>>      LoongArch: KVM: Implement kvm hardware enable, disable interf=
ace
> >>>>>>      LoongArch: KVM: Implement VM related functions
> >>>>>>      LoongArch: KVM: Add vcpu related header files
> >>>>>>      LoongArch: KVM: Implement vcpu create and destroy interface
> >>>>>>      LoongArch: KVM: Implement vcpu run interface
> >>>>>>      LoongArch: KVM: Implement vcpu handle exit interface
> >>>>>>      LoongArch: KVM: Implement vcpu get, vcpu set registers
> >>>>>>      LoongArch: KVM: Implement vcpu ENABLE_CAP ioctl interface
> >>>>>>      LoongArch: KVM: Implement fpu related operations for vcpu
> >>>>>>      LoongArch: KVM: Implement vcpu interrupt operations
> >>>>>>      LoongArch: KVM: Implement misc vcpu related interfaces
> >>>>>>      LoongArch: KVM: Implement vcpu load and vcpu put operations
> >>>>>>      LoongArch: KVM: Implement vcpu status description
> >>>>>>      LoongArch: KVM: Implement virtual machine tlb operations
> >>>>>>      LoongArch: KVM: Implement vcpu timer operations
> >>>>>>      LoongArch: KVM: Implement kvm mmu operations
> >>>>>>      LoongArch: KVM: Implement handle csr exception
> >>>>>>      LoongArch: KVM: Implement handle iocsr exception
> >>>>>>      LoongArch: KVM: Implement handle idle exception
> >>>>>>      LoongArch: KVM: Implement handle gspr exception
> >>>>>>      LoongArch: KVM: Implement handle mmio exception
> >>>>>>      LoongArch: KVM: Implement handle fpu exception
> >>>>>>      LoongArch: KVM: Implement kvm exception vector
> >>>>>>      LoongArch: KVM: Implement vcpu world switch
> >>>>>>      LoongArch: KVM: Enable kvm config and add the makefile
> >>>>>>      LoongArch: KVM: Supplement kvm document about LoongArch-speci=
fic part
> >>>>>>      LoongArch: KVM: Add maintainers for LoongArch KVM
> >>>>>>
> >>>>>>     Documentation/virt/kvm/api.rst             |  70 +-
> >>>>>>     MAINTAINERS                                |  12 +
> >>>>>>     arch/loongarch/Kbuild                      |   1 +
> >>>>>>     arch/loongarch/Kconfig                     |   3 +
> >>>>>>     arch/loongarch/configs/loongson3_defconfig |   2 +
> >>>>>>     arch/loongarch/include/asm/inst.h          |  16 +
> >>>>>>     arch/loongarch/include/asm/kvm_csr.h       | 221 +++++
> >>>>>>     arch/loongarch/include/asm/kvm_host.h      | 245 ++++++
> >>>>>>     arch/loongarch/include/asm/kvm_mmu.h       | 138 +++
> >>>>>>     arch/loongarch/include/asm/kvm_types.h     |  11 +
> >>>>>>     arch/loongarch/include/asm/kvm_vcpu.h      | 107 +++
> >>>>>>     arch/loongarch/include/asm/loongarch.h     |  19 +-
> >>>>>>     arch/loongarch/include/uapi/asm/kvm.h      | 108 +++
> >>>>>>     arch/loongarch/kernel/asm-offsets.c        |  32 +
> >>>>>>     arch/loongarch/kvm/Kconfig                 |  45 +
> >>>>>>     arch/loongarch/kvm/Makefile                |  20 +
> >>>>>>     arch/loongarch/kvm/exit.c                  | 711 +++++++++++++=
+++
> >>>>>>     arch/loongarch/kvm/interrupt.c             | 185 ++++
> >>>>>>     arch/loongarch/kvm/main.c                  | 429 ++++++++++
> >>>>>>     arch/loongarch/kvm/mmu.c                   | 922 +++++++++++++=
+++++++
> >>>>>>     arch/loongarch/kvm/switch.S                | 255 ++++++
> >>>>>>     arch/loongarch/kvm/timer.c                 | 200 +++++
> >>>>>>     arch/loongarch/kvm/tlb.c                   |  34 +
> >>>>>>     arch/loongarch/kvm/trace.h                 | 166 ++++
> >>>>>>     arch/loongarch/kvm/vcpu.c                  | 940 +++++++++++++=
++++++++
> >>>>>>     arch/loongarch/kvm/vm.c                    |  92 ++
> >>>>>>     include/uapi/linux/kvm.h                   |   9 +
> >>>>>>     27 files changed, 4979 insertions(+), 14 deletions(-)
> >>>>>>     create mode 100644 arch/loongarch/include/asm/kvm_csr.h
> >>>>>>     create mode 100644 arch/loongarch/include/asm/kvm_host.h
> >>>>>>     create mode 100644 arch/loongarch/include/asm/kvm_mmu.h
> >>>>>>     create mode 100644 arch/loongarch/include/asm/kvm_types.h
> >>>>>>     create mode 100644 arch/loongarch/include/asm/kvm_vcpu.h
> >>>>>>     create mode 100644 arch/loongarch/include/uapi/asm/kvm.h
> >>>>>>     create mode 100644 arch/loongarch/kvm/Kconfig
> >>>>>>     create mode 100644 arch/loongarch/kvm/Makefile
> >>>>>>     create mode 100644 arch/loongarch/kvm/exit.c
> >>>>>>     create mode 100644 arch/loongarch/kvm/interrupt.c
> >>>>>>     create mode 100644 arch/loongarch/kvm/main.c
> >>>>>>     create mode 100644 arch/loongarch/kvm/mmu.c
> >>>>>>     create mode 100644 arch/loongarch/kvm/switch.S
> >>>>>>     create mode 100644 arch/loongarch/kvm/timer.c
> >>>>>>     create mode 100644 arch/loongarch/kvm/tlb.c
> >>>>>>     create mode 100644 arch/loongarch/kvm/trace.h
> >>>>>>     create mode 100644 arch/loongarch/kvm/vcpu.c
> >>>>>>     create mode 100644 arch/loongarch/kvm/vm.c
> >>>>>>
> >>>>>> --
> >>>>>> 2.39.1
> >>>>>>
>
>
