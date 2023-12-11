Return-Path: <kvm+bounces-4084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 511D080D3E9
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 18:34:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF8F81F21A15
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 17:34:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E72E4E1DF;
	Mon, 11 Dec 2023 17:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PsrxwYGY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00039B
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 09:34:26 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1d04d286b5cso41910525ad.0
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 09:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702316066; x=1702920866; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4dy1GZPt4ahloA1lKMAAh2vw8dnz9eCUNT+pZwXAOsM=;
        b=PsrxwYGYkWHe0CkFvfaqqYjLelWXMpmqt8sKJnJ+TJR8yVwAIg9QBqI1Jk9k7cZjFV
         pqfxvWHWXcELwExNBrw9OIsUzU8lhC8lTc/A7FhgSXITD+9wVLoJY0bx67BVjrnmsWDJ
         81jcP8+UHbwyvx3wDqVsy+JSJj0kUUeCLgm8YKj/18PeSRwUBh6xApeM5Ym3KXbpQQZs
         26q2L6GtssE7w4jkpH0DqrlVpq+JDb7zPIHxgugASvFrouj0+f7BsI4caL2SdGmxKUjq
         V1hSOfdVa/9INaQhZbMsTVYkgXgNEEyZfkxs9gnG8wO6AAdC3Fyq5Y8JvPix+qwa1VOm
         mSIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702316066; x=1702920866;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4dy1GZPt4ahloA1lKMAAh2vw8dnz9eCUNT+pZwXAOsM=;
        b=EexA0Upgg4tMIkHreJL/AWpvKDicoHBFYA8yVCfcpsv8tT9peBr0ptQsR6PSlFByrU
         YRjZ153/NqlnLL64eNyrNOY+DZdrtYt3O7x/9geDZ6O1H+OkvMALF+Kl/vqN94uweqco
         +Awv10TwDaxAzSShzVFZbyAj7r1twOYB+I58S+CW0QmZBk8YvhWwNva/Z7RCZcd4Pgu/
         2zTbmBpZwJMBBCNH0ZQ6jE0omXFap42QXWqOf7t/En0xD6gcIkXHn0Zn3uASYZAu4PXF
         NGC7LeVaeRnmPPBwKFX+YSkBvn1reF1PonU72F2kbKlAjqor6A0/WUUaKWoTXkEfoph/
         po/g==
X-Gm-Message-State: AOJu0YwFmhVadCM5RzUaVRBV7UuEIQumSZ6W7ShiahSWyA5UgHF83t5N
	hm4fkc/OzIbOtES9pvewaOU+PtDkjpA=
X-Google-Smtp-Source: AGHT+IHqkXvBHkzpZr4xBbgwsL3PvOCK8qSlSmIRPscVFj5vuMB/n5MJcuPBtGQA7MQkmEwS8R6UC/HFYLE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:41cf:b0:1d0:80cd:4c44 with SMTP id
 u15-20020a17090341cf00b001d080cd4c44mr36557ple.10.1702316066276; Mon, 11 Dec
 2023 09:34:26 -0800 (PST)
Date: Mon, 11 Dec 2023 09:34:24 -0800
In-Reply-To: <cfed942fc767fa7b2fabc68a3357a7b95bd6a589.camel@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230512233127.804012-1-seanjc@google.com> <20230512233127.804012-2-seanjc@google.com>
 <cfed942fc767fa7b2fabc68a3357a7b95bd6a589.camel@amazon.com>
Message-ID: <ZXdIIBUXcCIK28ys@google.com>
Subject: Re: [PATCH v2 1/2] KVM: Use syscore_ops instead of reboot_notifier to
 hook restart/shutdown
From: Sean Christopherson <seanjc@google.com>
To: James Gowans <jgowans@amazon.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, Alexander Graf <graf@amazon.de>, 
	"Jan =?utf-8?Q?Sch=C3=B6nherr?=" <jschoenh@amazon.de>, "ebiederm@xmission.com" <ebiederm@xmission.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "atishp@atishpatra.org" <atishp@atishpatra.org>, 
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>, "james.morse@arm.com" <james.morse@arm.com>, 
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>, 
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "maz@kernel.org" <maz@kernel.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"aleksandar.qemu.devel@gmail.com" <aleksandar.qemu.devel@gmail.com>, 
	"anup@brainfault.org" <anup@brainfault.org>, 
	"kexec@lists.infradead.org" <kexec@lists.infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 09, 2023, James Gowans wrote:
> Hi Sean,
>=20
> Blast from the past but I've just been bitten by this patch when
> rebasing across v6.4.
>=20
> On Fri, 2023-05-12 at 16:31 -0700, Sean Christopherson wrote:
> > Use syscore_ops.shutdown to disable hardware virtualization during a
> > reboot instead of using the dedicated reboot_notifier so that KVM disab=
les
> > virtualization _after_ system_state has been updated.=C2=A0 This will a=
llow
> > fixing a race in KVM's handling of a forced reboot where KVM can end up
> > enabling hardware virtualization between kernel_restart_prepare() and
> > machine_restart().
>=20
> The issue is that, AFAICT, the syscore_ops.shutdown are not called when
> doing a kexec. Reboot notifiers are called across kexec via:
>=20
> kernel_kexec
>   kernel_restart_prepare
>     blocking_notifier_call_chain
>       kvm_reboot
>=20
> So after this patch, KVM is not shutdown during kexec; if hardware virt
> mode is enabled then the kexec hangs in exactly the same manner as you
> describe with the reboot.
>=20
> Some specific shutdown callbacks, for example IOMMU, HPET, IRQ, etc are
> called in native_machine_shutdown, but KVM is not one of these.
>=20
> Thoughts on possible ways to fix this:
> a) go back to reboot notifiers
> b) get kexec to call syscore_shutdown() to invoke all of these callbacks
> c) Add a KVM-specific callback to native_machine_shutdown(); we only
> need this for Intel x86, right?

I don't like (c).  VMX is the most sensitive/problematic, e.g. the whole bl=
ocking
of INIT thing, but SVM can also run afoul of EFER.SVME being cleared, and K=
VM really=20
should leave virtualization enabled across kexec(), even if leaving virtual=
ization
enabled is relatively benign on other architectures.

One more option would be:

 d) Add another sycore hook, e.g. syscore_kexec() specifically for this pat=
h.

> My slight preference is towards adding syscore_shutdown() to kexec, but
> I'm not sure that's feasible. Adding kexec maintainers for input.

In a vacuum, that'd be my preference too.  It's the obvious choice IMO, e.g=
. the
kexec_image->preserve_context path does syscore_suspend() (and then resume(=
), so
it's not completely uncharted territory.

However, there's a rather big wrinkle in that not all of the existing .shut=
down()
implementations are obviously ok to call during kexec.  Luckily, AFAICT the=
re are
very few users of the syscore .shutdown hook, so it's at least feasible to =
go that
route.

x86's mce_syscore_shutdown() should be ok, and arguably is correct, e.g. I =
don't
see how leaving #MC reporting enabled across kexec can work.

ledtrig_cpu_syscore_shutdown() is also likely ok and arguably correct.

The interrupt controllers though?  x86 disables IRQs at the very beginning =
of
machine_kexec(), so it's likely fine.  But every other architecture?  No cl=
ue.
E.g. PPC's default_machine_kexec() sends IPIs to shutdown other CPUs, thoug=
h I
have no idea if that can run afoul of any of the paths below.

        arch/powerpc/platforms/cell/spu_base.c  .shutdown =3D spu_shutdown,
        arch/x86/kernel/cpu/mce/core.c	        .shutdown =3D mce_syscore_sh=
utdown,
        arch/x86/kernel/i8259.c                 .shutdown =3D i8259A_shutdo=
wn,
        drivers/irqchip/irq-i8259.c	        .shutdown =3D i8259A_shutdown,
        drivers/irqchip/irq-sun6i-r.c	        .shutdown =3D sun6i_r_intc_sh=
utdown,
        drivers/leds/trigger/ledtrig-cpu.c	.shutdown =3D ledtrig_cpu_syscor=
e_shutdown,
        drivers/power/reset/sc27xx-poweroff.c	.shutdown =3D sc27xx_poweroff=
_shutdown,
        kernel/irq/generic-chip.c	        .shutdown =3D irq_gc_shutdown,
        virt/kvm/kvm_main.c	                .shutdown =3D kvm_shutdown,

The whole thing is a bit of a mess.  E.g. x86 treats machine_shutdown() fro=
m
kexec pretty much the same as shutdown for reboot, but other architectures =
have
what appear to be unique paths for handling kexec.

FWIW, if we want to go with option (b), syscore_shutdown() hooks could use
kexec_in_progress to differentiate between "regular" shutdown/reboot and ke=
xec.

