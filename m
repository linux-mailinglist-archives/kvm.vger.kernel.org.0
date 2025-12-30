Return-Path: <kvm+bounces-66811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B9A4FCE886C
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 03:13:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A7DE23019B7B
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 02:13:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDB642DFA31;
	Tue, 30 Dec 2025 02:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nrQYGKzX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8942DF137
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 02:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767060809; cv=none; b=b/bMOGx7nUoXmrSe+b/+OYHXd5zYvsap1lZQb2L4GKie00ePHk8g6Rxd2RuGOPG3Cz1Ite7EdNpNVPGGYpBgcSJflcoPNSY/LU2halZApLeaKfthPy3dFdT3niGxCWNZYnHecvJUkmJ40hizjoXJoEAm9WgFRWwlb38ouaFh5n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767060809; c=relaxed/simple;
	bh=NOS2WpZwZtVwhomfiqRqdBKvV+jpSB0x7B5ZONRf0+E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=McH2xByNZF3djKT3PT4gcxWt4VO5aRF7PMzx6jTjStxmkvgfjffw8/5xHnBfGf15T1May42xMn2XUWR6tW4bt6+mER4tz5Xf/AMMuCANL1CZjgxyUgI1Q6JziaUOszh6LjLJdtY9mK+IrkP4YbSM5cJqDVVPI1MNwF6/pu6oYYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nrQYGKzX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2235C2BC87
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 02:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767060808;
	bh=NOS2WpZwZtVwhomfiqRqdBKvV+jpSB0x7B5ZONRf0+E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=nrQYGKzX3gueEKVMGbg8rZBcokjPgVskP9hckMcHtybJVj6fnLm+gHQJ8OAtrURhD
	 9XZN2l6Q5LSlGo1rs/2duful1Bu+BZA6SMd26J9Vus7oATYR6XT0BClzUSNOi4DIgE
	 KqI2vjODLnyA1cm5eI1k3XlB745ySYjhjNJr0ZLWtCvTyHutCwdIi724UqA3+OXOhx
	 ao9PPaG8QqfX3VOO1HUqzskqKy5QXQjTYQL7booxX9pQs3Y5TgUS0+15cLc7yKlxt4
	 orZQxfq0mmJXlUH1DKBSG8sMLXK38roBWKGuOewNVOzCQM8qzRTQgEN5qf2nPXpmej
	 pf1PK/9n1aSJQ==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b79af62d36bso1628653966b.3
        for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 18:13:28 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVvigfZacw0z/zt1komq5jC8qwmQtAsy8lOs+rvmPvAyvjnW+kqw54O/TvXmI5U3ICaU58=@vger.kernel.org
X-Gm-Message-State: AOJu0YypKl1Jts+dbj4I4iaLiGUONUAwSLDu6afOpbEvK1vteKa+GyFl
	FSWS5/Leaj0+kzEAsZVnEDI2MhilrFquDrmNe993f4UMK0oBvaJVI8IWaLP0esOt5iySVmlitaC
	rMfi9IuqGGejaOQ7JQVs1be7oI+Yht40=
X-Google-Smtp-Source: AGHT+IFCATd73B+KoUHJAYGGIvBRAVuH5eZsfqs4HzxJE6cnrrrJ/bSCOZgTsHi/yCCNQHo7p6rQ8Ht1DtbWMUpmJ90=
X-Received: by 2002:a17:907:829a:b0:b83:246c:d125 with SMTP id
 a640c23a62f3a-b83246cd206mr986368266b.41.1767060807212; Mon, 29 Dec 2025
 18:13:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251227012712.2921408-1-lixianglai@loongson.cn>
 <20251227012712.2921408-3-lixianglai@loongson.cn> <08143343-cb10-9376-e7df-68ad854b9275@loongson.cn>
 <9e1a8d4f-251f-f78e-01a3-5c483249fac8@loongson.cn> <dec5cb06-6858-20f2-facb-d5e7f44f5d16@loongson.cn>
 <df8f52e3-fea5-763a-d5fd-629308dc6fcc@loongson.cn> <a1009e1e-34de-68b4-7680-d2a99a06a71c@loongson.cn>
 <39ee51e4-6073-6f00-44f5-46bbcbd393c2@loongson.cn>
In-Reply-To: <39ee51e4-6073-6f00-44f5-46bbcbd393c2@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 30 Dec 2025 10:13:45 +0800
X-Gmail-Original-Message-ID: <CAAhV-H77o_4Khi-tNB7nK1yAzaD5O4RfJq+V0UyYo=1Ry_2AyQ@mail.gmail.com>
X-Gm-Features: AQt7F2rxySgrN77tMhfB6B3fSkkrBssyg9Xt7r-jARqtX3qAnqw3oWWOBSW-zLU
Message-ID: <CAAhV-H77o_4Khi-tNB7nK1yAzaD5O4RfJq+V0UyYo=1Ry_2AyQ@mail.gmail.com>
Subject: Re: [PATCH V3 2/2] LoongArch: KVM: fix "unreliable stack" issue
To: Bibo Mao <maobibo@loongson.cn>
Cc: Jinyang He <hejinyang@loongson.cn>, lixianglai <lixianglai@loongson.cn>, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	stable@vger.kernel.org, WANG Xuerui <kernel@xen0n.name>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Charlie Jenkins <charlie@rivosinc.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Tiezhu Yang <yangtiezhu@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 30, 2025 at 9:21=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
>
>
> On 2025/12/29 =E4=B8=8B=E5=8D=886:41, Jinyang He wrote:
> > On 2025-12-29 18:11, lixianglai wrote:
> >
> >> Hi Jinyang:
> >>>
> >>> On 2025-12-29 11:53, lixianglai wrote:
> >>>> Hi Jinyang:
> >>>>> On 2025-12-27 09:27, Xianglai Li wrote:
> >>>>>
> >>>>>> Insert the appropriate UNWIND macro definition into the
> >>>>>> kvm_exc_entry in
> >>>>>> the assembly function to guide the generation of correct ORC table
> >>>>>> entries,
> >>>>>> thereby solving the timeout problem of loading the
> >>>>>> livepatch-sample module
> >>>>>> on a physical machine running multiple vcpus virtual machines.
> >>>>>>
> >>>>>> While solving the above problems, we have gained an additional
> >>>>>> benefit,
> >>>>>> that is, we can obtain more call stack information
> >>>>>>
> >>>>>> Stack information that can be obtained before the problem is fixed=
:
> >>>>>> [<0>] kvm_vcpu_block+0x88/0x120 [kvm]
> >>>>>> [<0>] kvm_vcpu_halt+0x68/0x580 [kvm]
> >>>>>> [<0>] kvm_emu_idle+0xd4/0xf0 [kvm]
> >>>>>> [<0>] kvm_handle_gspr+0x7c/0x700 [kvm]
> >>>>>> [<0>] kvm_handle_exit+0x160/0x270 [kvm]
> >>>>>> [<0>] kvm_exc_entry+0x100/0x1e0
> >>>>>>
> >>>>>> Stack information that can be obtained after the problem is fixed:
> >>>>>> [<0>] kvm_vcpu_block+0x88/0x120 [kvm]
> >>>>>> [<0>] kvm_vcpu_halt+0x68/0x580 [kvm]
> >>>>>> [<0>] kvm_emu_idle+0xd4/0xf0 [kvm]
> >>>>>> [<0>] kvm_handle_gspr+0x7c/0x700 [kvm]
> >>>>>> [<0>] kvm_handle_exit+0x160/0x270 [kvm]
> >>>>>> [<0>] kvm_exc_entry+0x104/0x1e4
> >>>>>> [<0>] kvm_enter_guest+0x38/0x11c
> >>>>>> [<0>] kvm_arch_vcpu_ioctl_run+0x26c/0x498 [kvm]
> >>>>>> [<0>] kvm_vcpu_ioctl+0x200/0xcf8 [kvm]
> >>>>>> [<0>] sys_ioctl+0x498/0xf00
> >>>>>> [<0>] do_syscall+0x98/0x1d0
> >>>>>> [<0>] handle_syscall+0xb8/0x158
> >>>>>>
> >>>>>> Cc: stable@vger.kernel.org
> >>>>>> Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
> >>>>>> ---
> >>>>>> Cc: Huacai Chen <chenhuacai@kernel.org>
> >>>>>> Cc: WANG Xuerui <kernel@xen0n.name>
> >>>>>> Cc: Tianrui Zhao <zhaotianrui@loongson.cn>
> >>>>>> Cc: Bibo Mao <maobibo@loongson.cn>
> >>>>>> Cc: Charlie Jenkins <charlie@rivosinc.com>
> >>>>>> Cc: Xianglai Li <lixianglai@loongson.cn>
> >>>>>> Cc: Thomas Gleixner <tglx@linutronix.de>
> >>>>>> Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
> >>>>>>
> >>>>>>   arch/loongarch/kvm/switch.S | 28 +++++++++++++++++++---------
> >>>>>>   1 file changed, 19 insertions(+), 9 deletions(-)
> >>>>>>
> >>>>>> diff --git a/arch/loongarch/kvm/switch.S
> >>>>>> b/arch/loongarch/kvm/switch.S
> >>>>>> index 93845ce53651..a3ea9567dbe5 100644
> >>>>>> --- a/arch/loongarch/kvm/switch.S
> >>>>>> +++ b/arch/loongarch/kvm/switch.S
> >>>>>> @@ -10,6 +10,7 @@
> >>>>>>   #include <asm/loongarch.h>
> >>>>>>   #include <asm/regdef.h>
> >>>>>>   #include <asm/unwind_hints.h>
> >>>>>> +#include <linux/kvm_types.h>
> >>>>>>     #define HGPR_OFFSET(x)        (PT_R0 + 8*x)
> >>>>>>   #define GGPR_OFFSET(x)        (KVM_ARCH_GGPR + 8*x)
> >>>>>> @@ -110,9 +111,9 @@
> >>>>>>        * need to copy world switch code to DMW area.
> >>>>>>        */
> >>>>>>       .text
> >>>>>> +    .p2align PAGE_SHIFT
> >>>>>>       .cfi_sections    .debug_frame
> >>>>>>   SYM_CODE_START(kvm_exc_entry)
> >>>>>> -    .p2align PAGE_SHIFT
> >>>>>>       UNWIND_HINT_UNDEFINED
> >>>>>>       csrwr    a2,   KVM_TEMP_KS
> >>>>>>       csrrd    a2,   KVM_VCPU_KS
> >>>>>> @@ -170,6 +171,7 @@ SYM_CODE_START(kvm_exc_entry)
> >>>>>>       /* restore per cpu register */
> >>>>>>       ld.d    u0, a2, KVM_ARCH_HPERCPU
> >>>>>>       addi.d    sp, sp, -PT_SIZE
> >>>>>> +    UNWIND_HINT_REGS
> >>>>>>         /* Prepare handle exception */
> >>>>>>       or    a0, s0, zero
> >>>>>> @@ -200,7 +202,7 @@ ret_to_host:
> >>>>>>       jr      ra
> >>>>>>     SYM_CODE_END(kvm_exc_entry)
> >>>>>> -EXPORT_SYMBOL(kvm_exc_entry)
> >>>>>> +EXPORT_SYMBOL_FOR_KVM(kvm_exc_entry)
> >>>>>>     /*
> >>>>>>    * int kvm_enter_guest(struct kvm_run *run, struct kvm_vcpu *vcp=
u)
> >>>>>> @@ -215,6 +217,14 @@ SYM_FUNC_START(kvm_enter_guest)
> >>>>>>       /* Save host GPRs */
> >>>>>>       kvm_save_host_gpr a2
> >>>>>>   +    /*
> >>>>>> +     * The csr_era member variable of the pt_regs structure is
> >>>>>> required
> >>>>>> +     * for unwinding orc to perform stack traceback, so we need
> >>>>>> to put
> >>>>>> +     * pc into csr_era member variable here.
> >>>>>> +     */
> >>>>>> +    pcaddi    t0, 0
> >>>>>> +    st.d    t0, a2, PT_ERA
> >>>>> Hi, Xianglai,
> >>>>>
> >>>>> It should use `SYM_CODE_START` to mark the `kvm_enter_guest` rather
> >>>>> than
> >>>>> `SYM_FUNC_START`, since the `SYM_FUNC_START` is used to mark
> >>>>> "C-likely"
> >>>>> asm functionw.
> >>>>
> >>>> Ok, I will use SYM_CODE_START to mark kvm_enter_guest in the next
> >>>> version.
> >>>>
> >>>>> I guess the kvm_enter_guest is something like exception
> >>>>> handler becuase the last instruction is "ertn". So usually it shoul=
d
> >>>>> mark UNWIND_HINT_REGS where can find last frame info by "$sp".
> >>>>> However, all info is store to "$a2", this mark should be
> >>>>>   `UNWIND_HINT sp_reg=3DORC_REG_A2(???) type=3DUNWIND_HINT_TYPE_REG=
S`.
> >>>>> I don't konw why save this function internal PC here by `pcaddi t0,
> >>>>> 0`,
> >>>>> and I think it is no meaning(, for exception handler, they save
> >>>>> last PC
> >>>>> by read CSR.ERA). The `kvm_enter_guest` saves registers by
> >>>>> "$a2"("$sp" - PT_REGS) beyond stack ("$sp"), it is dangerous if IE
> >>>>> is enable. So I wonder if there is really a stacktrace through this
> >>>>> function?
> >>>>>
> >>>> The stack backtracking issue in switch.S is rather complex because
> >>>> it involves the switching between cpu root-mode and guest-mode:
> >>>> Real stack backtracking should be divided into two parts:
> >>>> part 1:
> >>>>     [<0>] kvm_enter_guest+0x38/0x11c
> >>>>     [<0>] kvm_arch_vcpu_ioctl_run+0x26c/0x498 [kvm]
> >>>>     [<0>] kvm_vcpu_ioctl+0x200/0xcf8 [kvm]
> >>>>     [<0>] sys_ioctl+0x498/0xf00
> >>>>     [<0>] do_syscall+0x98/0x1d0
> >>>>     [<0>] handle_syscall+0xb8/0x158
> >>>>
> >>>> part 2:
> >>>>     [<0>] kvm_vcpu_block+0x88/0x120 [kvm]
> >>>>     [<0>] kvm_vcpu_halt+0x68/0x580 [kvm]
> >>>>     [<0>] kvm_emu_idle+0xd4/0xf0 [kvm]
> >>>>     [<0>] kvm_handle_gspr+0x7c/0x700 [kvm]
> >>>>     [<0>] kvm_handle_exit+0x160/0x270 [kvm]
> >>>>     [<0>] kvm_exc_entry+0x104/0x1e4
> >>>>
> >>>>
> >>>> In "part 1", after executing kvm_enter_guest, the cpu switches from
> >>>> root-mode to guest-mode.
> >>>> In this case, stack backtracking is indeed very rare.
> >>>>
> >>>> In "part 2", the cpu switches from the guest-mode to the root-mode,
> >>>> and most of the stack backtracking occurs during this phase.
> >>>>
> >>>> To obtain the longest call chain, we save pc in kvm_enter_guest to
> >>>> pt_regs.csr_era,
> >>>> and after restoring the sp of the root-mode cpu in kvm_exc_entry,
> >>>> The ORC entry was re-established using "UNWIND_HINT_REGS",
> >>>>  and then we obtained the following stack backtrace as we wanted:
> >>>>
> >>>>     [<0>] kvm_vcpu_block+0x88/0x120 [kvm]
> >>>>     [<0>] kvm_vcpu_halt+0x68/0x580 [kvm]
> >>>>     [<0>] kvm_emu_idle+0xd4/0xf0 [kvm]
> >>>>     [<0>] kvm_handle_gspr+0x7c/0x700 [kvm]
> >>>>     [<0>] kvm_handle_exit+0x160/0x270 [kvm]
> >>>>     [<0>] kvm_exc_entry+0x104/0x1e4
> >>> I found this might be a coincidence=E2=80=94correct behavior due to t=
he
> >>> incorrect
> >>> UNWIND_HINT_REGS mark and unusual stack adjustment.
> >>>
> >>> First, the kvm_enter_guest contains only a single branch instruction,
> >>> ertn.
> >>> It hardware-jump to the CSR.ERA address directly, jump into
> >>> kvm_exc_entry.
> >>>
> >>> At this point, the stack layout looks like this:
> >>> -------------------------------
> >>>   frame from call to `kvm_enter_guest`
> >>> -------------------------------  <- $sp
> >>>   PT_REGS
> >>> -------------------------------  <- $a2
> >>>
> >>> Then kvm_exc_entry adjust stack without save any register (e.g. $ra,
> >>> $sp)
> >>> but still marked UNWIND_HINT_REGS.
> >>> After the adjustment:
> >>> -------------------------------
> >>>   frame from call to `kvm_enter_guest`
> >>> -------------------------------
> >>>   PT_REGS
> >>> -------------------------------  <- $a2, new $sp
> >>>
> >>> During unwinding, when the unwinder reaches kvm_exc_entry,
> >>> it meets the mark of PT_REGS and correctly recovers
> >>>  pc =3D regs.csr_era, sp =3D regs.sp, ra =3D regs.ra
> >>>
> >> Yes, here unwinder does work as you say.
> >>
> >>> a) Can we avoid "ertn" rather than `jr reg (or jirl ra, reg, 0)`
> >>> instead, like call?
> >> No,  we need to rely on the 'ertn instruction return PIE to CRMD IE,
> >> at the same time to ensure that its atomic,
> >> there should be no other instruction than' ertn 'more appropriate here=
.
> > You are right! I got it.
> >>
> >>> The kvm_exc_entry cannot back to kvm_enter_guest
> >>> if we use "ertn", so should the kvm_enter_guest appear on the
> >>> stacktrace?
> >>>
> >>
> >> It is flexible. As I mentioned above, the cpu completes the switch
> >> from host-mode to guest mode through kvm_enter_guest,
> >> and then the switch from guest mode to host-mode through
> >> kvm_exc_entry. When we ignore the details of the host-mode
> >> and guest-mode switching in the middle, we can understand that the
> >> host cpu has completed kvm_enter_guest->kvm_exc_entry.
> >> From this perspective, I think it can exist in the call stack, and at
> >> the same time, we have obtained the maximum call stack information.
> >>
> >>
> >>> b) Can we adjust $sp before entering kvm_exc_entry? Then we can mark
> >>> UNWIND_HINT_REGS at the beginning of kvm_exc_entry, which something
> >>> like ret_from_kernel_thread_asm.
> >>>
> >> The following command can be used to dump the orc entries of the kerne=
l:
> >> ./tools/objtool/objtool --dump vmlinux
> >>
> >> You can observe that not all orc entries are generated at the
> >> beginning of the function.
> >> For example:
> >> handle_tlb_protect
> >> ftrace_stub
> >> handle_reserved
> >>
> >> So, is it unnecessary for us to modify UNWIND_HINT_REGS in order to
> >> place it at the beginning of the function.
> >>
> >> If you have a better solution, could you provide an example of the
> >> modification?
> >> I can test the feasibility of the solution.
> >>
> > The expression at the beginning of the function is incorrect (feeling
> > sorry).
> > It should be marked where have all stacktrace info.
> > Thanks for all the explaining, since I'm unfamiliar with kvm, I need
> > these to help my understanding.
> >
> > Can you try with follows, with save regs by $sp, set more precise era t=
o
> > pt_regs, and more unwind hint.
> >
> >
> > diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
> > index f1768b7a6194..8ed1d7b72c54 100644
> > --- a/arch/loongarch/kvm/switch.S
> > +++ b/arch/loongarch/kvm/switch.S
> > @@ -14,13 +14,13 @@
> >   #define GGPR_OFFSET(x)        (KVM_ARCH_GGPR + 8*x)
> >
> >   .macro kvm_save_host_gpr base
> > -    .irp n,1,2,3,22,23,24,25,26,27,28,29,30,31
> > +    .irp n,1,2,22,23,24,25,26,27,28,29,30,31
> >       st.d    $r\n, \base, HGPR_OFFSET(\n)
> >       .endr
> >   .endm
> >
> >   .macro kvm_restore_host_gpr base
> > -    .irp n,1,2,3,22,23,24,25,26,27,28,29,30,31
> > +    .irp n,1,2,22,23,24,25,26,27,28,29,30,31
> >       ld.d    $r\n, \base, HGPR_OFFSET(\n)
> >       .endr
> >   .endm
> > @@ -88,6 +88,7 @@
> >       /* Load KVM_ARCH register */
> >       ld.d    a2, a2,    (KVM_ARCH_GGPR + 8 * REG_A2)
> >
> > +111:
> >       ertn /* Switch to guest: GSTAT.PGM =3D 1, ERRCTL.ISERR =3D 0,
> > TLBRPRMD.ISTLBR =3D 0 */
> >   .endm
> >
> > @@ -158,9 +159,10 @@ SYM_CODE_START(kvm_exc_entry)
> >       csrwr    t0, LOONGARCH_CSR_GTLBC
> >       ld.d    tp, a2, KVM_ARCH_HTP
> >       ld.d    sp, a2, KVM_ARCH_HSP
> > +    UNWIND_HINT_REGS
> > +
> >       /* restore per cpu register */
> >       ld.d    u0, a2, KVM_ARCH_HPERCPU
> > -    addi.d    sp, sp, -PT_SIZE
> >
> >       /* Prepare handle exception */
> >       or    a0, s0, zero
> > @@ -184,10 +186,11 @@ SYM_CODE_START(kvm_exc_entry)
> >       csrwr    s1, KVM_VCPU_KS
> >       kvm_switch_to_guest
> >
> > +    UNWIND_HINT_UNDEFINED
> >   ret_to_host:
> > -    ld.d    a2, a2, KVM_ARCH_HSP
> > -    addi.d  a2, a2, -PT_SIZE
> > -    kvm_restore_host_gpr    a2
> > +    ld.d    sp, a2, KVM_ARCH_HSP
> > +    kvm_restore_host_gpr    sp
> > +    addi.d    sp, sp, PT_SIZE
> >       jr      ra
> >
> >   SYM_INNER_LABEL(kvm_exc_entry_end, SYM_L_LOCAL)
> > @@ -200,11 +203,15 @@ SYM_CODE_END(kvm_exc_entry)
> >    *  a0: kvm_run* run
> >    *  a1: kvm_vcpu* vcpu
> >    */
> > -SYM_FUNC_START(kvm_enter_guest)
> > +SYM_CODE_START(kvm_enter_guest)
> > +    UNWIND_HINT_UNDEFINED
> >       /* Allocate space in stack bottom */
> > -    addi.d    a2, sp, -PT_SIZE
> > +    addi.d    sp, sp, -PT_SIZE
> >       /* Save host GPRs */
> > -    kvm_save_host_gpr a2
> > +    kvm_save_host_gpr sp
> > +    la.pcrel a2, 111f
> > +    st.d     a2, sp, PT_ERA
> > +    UNWIND_HINT_REGS
> >
> >       addi.d    a2, a1, KVM_VCPU_ARCH
> >       st.d    sp, a2, KVM_ARCH_HSP
> >
> wow, so quick and wonderful.
>
> Huacai,
>   the loongarch kernel and kvm maintainer, what is your point about this?
Xianglai's patch really has some problems. But Jinyang's solution is a
little big, can we minimize the changes? For example, don't touch
kvm_exc_entry, only modify kvm_enter_guest. In my opinion the current
problem has no relationship with kvm_exc_entry (but I'm not sure).

Huacai

>
> Regards
> Bibo Mao
> > Jinyang
> >
>
>

