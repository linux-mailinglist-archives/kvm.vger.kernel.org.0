Return-Path: <kvm+bounces-66568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C7DAECD7E61
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 03:46:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 15D9A301CD17
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 02:46:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 630F729BDB3;
	Tue, 23 Dec 2025 02:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A8Z2r/la"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895C6FBF0
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 02:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766457997; cv=none; b=YQM+bK81sMXaS22lJSjgE3SlC5S6JlivTKCxar3BrH1z40e/xHDslC+Zdszkm/wIHeyfVUzMvgs2zmB8z96QDWwIFuq0b8AOuoNAThMiuilntVs0ihQYBfR9uXW6itj5IAJtLNb1I4FAVGz2/Sj3MRxL18C44dF6BzhBvT4p1CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766457997; c=relaxed/simple;
	bh=lgwlYJzSoFQyF2DIHHhHEKAMucOxLBXXjNHIr/Dhblk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cYcnUneU2V5pPAYRZnJhxMP/Gz4143ocCGf0kdSZyP/QglLnBbyI5n+FKIbEUyqHgZMCtWDBAvsRQMq30scX7KIYozprdzFoRmBGHvOToALsvPZdvxKJIrr43ZB9RJmm8uq8mSx1GGEVtmKjkAdg5+EZFDJGIdXqLvy/3Ihk8u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A8Z2r/la; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5448AC19424
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 02:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766457997;
	bh=lgwlYJzSoFQyF2DIHHhHEKAMucOxLBXXjNHIr/Dhblk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=A8Z2r/lapXoGOuy2keKD6aq3SmMlfu77cB+3gXz3R4fXoJKNcvlPgj86bUdu0b5lq
	 RWkqKOilTKzFGSYq32sgfW+tG2C4+bQKhmDkHcToo56fjMcOB4HgubzudXWR/W/hkc
	 2q+PfygcJpkbj53TtSwhLjVxgDvA+0NERqFc05KKpYcToglION3MdbG33Cn7+SLbxk
	 MneKNnRxkIEhO3qmMviPUGXb0fk5hY5HQmuU9Hco0wUapgLwlq5BURSqYTvYfbXtyg
	 b8qnK7H4AJcFLTwgAfN/Uni53XOspmGxzjT+b2EtJImigTjId1AHMIV9IlWEXSFGBZ
	 yL/cjN3u8BRbA==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b79af62d36bso791912166b.3
        for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 18:46:37 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWimfJeATncKn9+WMAAxlcVsu5ggqcI+jwntV1KxVxlUUipQEMZlrMTHny1YB6KbANtbLA=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywr3dhmUrSRZWoFtrQDJ6Xfpk7NDyratl1Zdj1NOuv2+BMu3iJJ
	IYo0Kv7rcMRpkTkWCh1VQhVJoS9eoS/HKCt+JNliDh44DfIZz3hPqfXqRMZizKXtBmzojAWC+xk
	q+lQJFq1tnQZl3nWDtamdESRxPznb+HE=
X-Google-Smtp-Source: AGHT+IF3GO6AdS8DbuCemUAdcBFUnvEgFfaAAkmzpJMMuYYAmrQWpUOCMuzEo4/RLOkH6dPueUT3xP2c4t56CcqQeig=
X-Received: by 2002:a17:907:1c13:b0:b73:8b79:a31a with SMTP id
 a640c23a62f3a-b8036f25deemr1213622566b.16.1766457995927; Mon, 22 Dec 2025
 18:46:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251222113409.2343711-1-lixianglai@loongson.cn>
 <20251222113409.2343711-3-lixianglai@loongson.cn> <e1f4b85e-0177-91b7-c422-22ed60607260@loongson.cn>
In-Reply-To: <e1f4b85e-0177-91b7-c422-22ed60607260@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 23 Dec 2025 10:46:51 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4PehwGm-WwEuu4ZPbQutJR6m62tOSUxLcGQAxR_YX0Eg@mail.gmail.com>
X-Gm-Features: AQt7F2oKXjjioHQYpY2NYdW2QGgbg6abOSwan6H92jv7m_pBv_H6a83kXJQlRsI
Message-ID: <CAAhV-H4PehwGm-WwEuu4ZPbQutJR6m62tOSUxLcGQAxR_YX0Eg@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] LoongArch: KVM: fix "unreliable stack" issue
To: Bibo Mao <maobibo@loongson.cn>
Cc: Xianglai Li <lixianglai@loongson.cn>, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, stable@vger.kernel.org, 
	WANG Xuerui <kernel@xen0n.name>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Charlie Jenkins <charlie@rivosinc.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 23, 2025 at 9:27=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
>
>
> On 2025/12/22 =E4=B8=8B=E5=8D=887:34, Xianglai Li wrote:
> > Insert the appropriate UNWIND macro definition into the kvm_exc_entry i=
n
> > the assembly function to guide the generation of correct ORC table entr=
ies,
> > thereby solving the timeout problem of loading the livepatch-sample mod=
ule
> > on a physical machine running multiple vcpus virtual machines.
> >
> > While solving the above problems, we have gained an additional benefit,
> > that is, we can obtain more call stack information
> >
> > Stack information that can be obtained before the problem is fixed:
> > [<0>] kvm_vcpu_block+0x88/0x120 [kvm]
> > [<0>] kvm_vcpu_halt+0x68/0x580 [kvm]
> > [<0>] kvm_emu_idle+0xd4/0xf0 [kvm]
> > [<0>] kvm_handle_gspr+0x7c/0x700 [kvm]
> > [<0>] kvm_handle_exit+0x160/0x270 [kvm]
> > [<0>] kvm_exc_entry+0x100/0x1e0
> >
> > Stack information that can be obtained after the problem is fixed:
> > [<0>] kvm_vcpu_block+0x88/0x120 [kvm]
> > [<0>] kvm_vcpu_halt+0x68/0x580 [kvm]
> > [<0>] kvm_emu_idle+0xd4/0xf0 [kvm]
> > [<0>] kvm_handle_gspr+0x7c/0x700 [kvm]
> > [<0>] kvm_handle_exit+0x160/0x270 [kvm]
> > [<0>] kvm_exc_entry+0x100/0x1e0
> > [<0>] kvm_arch_vcpu_ioctl_run+0x260/0x488 [kvm]
> > [<0>] kvm_vcpu_ioctl+0x200/0xcd8 [kvm]
> > [<0>] sys_ioctl+0x498/0xf00
> > [<0>] do_syscall+0x94/0x190
> > [<0>] handle_syscall+0xb8/0x158
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
> > ---
> > Cc: Huacai Chen <chenhuacai@kernel.org>
> > Cc: WANG Xuerui <kernel@xen0n.name>
> > Cc: Tianrui Zhao <zhaotianrui@loongson.cn>
> > Cc: Bibo Mao <maobibo@loongson.cn>
> > Cc: Charlie Jenkins <charlie@rivosinc.com>
> > Cc: Xianglai Li <lixianglai@loongson.cn>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> >
> >   arch/loongarch/kvm/switch.S | 2 ++
> >   1 file changed, 2 insertions(+)
> >
> > diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
> > index 93845ce53651..e3ecb24a3bc5 100644
> > --- a/arch/loongarch/kvm/switch.S
> > +++ b/arch/loongarch/kvm/switch.S
> > @@ -170,6 +170,7 @@ SYM_CODE_START(kvm_exc_entry)
> >       /* restore per cpu register */
> >       ld.d    u0, a2, KVM_ARCH_HPERCPU
> >       addi.d  sp, sp, -PT_SIZE
> > +     UNWIND_HINT_REGS
> >
> >       /* Prepare handle exception */
> >       or      a0, s0, zero
> > @@ -214,6 +215,7 @@ SYM_FUNC_START(kvm_enter_guest)
> >       addi.d  a2, sp, -PT_SIZE
> >       /* Save host GPRs */
> >       kvm_save_host_gpr a2
> > +     st.d    ra, a2, PT_ERA
> Had better add some comments here to show that it is special for unwind
> usage since there is "st.d ra, a2, PT_R1" already in macro
> kvm_save_host_gpr().
Then there is a new problem, why can unwinder not recognize the
instruction in  kvm_save_host_gpr()?

Huacai
>
> Regards
> Bibo Mao
> >
> >       addi.d  a2, a1, KVM_VCPU_ARCH
> >       st.d    sp, a2, KVM_ARCH_HSP
> >
>

