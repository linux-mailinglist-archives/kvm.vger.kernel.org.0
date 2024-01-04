Return-Path: <kvm+bounces-5639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EDCEC8240A7
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 12:29:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 83A7F1F26D33
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 11:29:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D201621346;
	Thu,  4 Jan 2024 11:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="Q4mocSRp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4126321112
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 11:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7ba737ee9b5so17542039f.0
        for <kvm@vger.kernel.org>; Thu, 04 Jan 2024 03:29:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1704367777; x=1704972577; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3DetrKFz1HozFLUYq3IBWTWL18XuPTYWqXXjIl+V6I4=;
        b=Q4mocSRpUkuq2xwxtRHjh5FrBaxn25KjnRWoQsHFCWMVV7OUDcr8ukxnQT5SAJwPi0
         1raY3t0mE8Nqg/Mf4/bGsNPqqY9spoOPgMiwXdd2ozSex36xEGK2hX+yp6+kBSsqNvts
         SFHlYRW0iyoDeXxceSTkCTsbvqH2Vxx5/xKgHridmTm5ARQq6gMFGyNYQQlvJSuXuYLm
         6ZBrdaeZJKqhV6AZ0h1hdtD+xYNiDr3Oi6M3zjSWDhFngyWsc/TRhALaOJ16bS0IZvol
         fN2yRouM3Qgafnebie0qMBfAOacGzRXwXmwmiYkvwQDZmADx+AQ5rNf5IsMB4wqTzU5O
         5I1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704367777; x=1704972577;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3DetrKFz1HozFLUYq3IBWTWL18XuPTYWqXXjIl+V6I4=;
        b=HLdU83QL1chAk92E5aumc5SNWw0E1NDeOEL4OD2YEOu4u83fXuVKCELqMuIRiYDCma
         7d61y2hSmgMsE1FRsgN2WClwr+VRt5NOEYXDJMDhw+A6nl8XWCy2gqNkLsAvwadlnRN2
         Vcna2RFO5c/OG8tHrCjdR7Ac68UkLaqwftVVHjloLThMGW/d9CrnM8GT6sKebSY4eTMw
         FEcR2lqldtvV4h76QJwPRZ+tYprKykNMXKUGLWUq23KWijXeHTFKNJPURYv/AmWDJ21t
         a8+LIhcMheL2Ykd1IEVDA3mt4lZV+a19V8WUOjal+xoP2qBJUuRTx01UrXVEettyqMxe
         xvUA==
X-Gm-Message-State: AOJu0Yzvk/bMbnpdAnNvt/U5RTmJFyz4kkbbU+WOh9WvoAidrj+x1jdJ
	yVOCMmjc89ZWgtl+I22te8epBAcdZeQ2o7Yz+ly6r7KFxC6FQA==
X-Google-Smtp-Source: AGHT+IHCeu4Jvokb24tgL2OXFn0C/D4aZOQBaBAHEDlQ872zADqtLfMS8Xss2615C8A+/DgV91umDFOHrk3Z2h2r1w8=
X-Received: by 2002:a92:cd8f:0:b0:35f:e305:3060 with SMTP id
 r15-20020a92cd8f000000b0035fe3053060mr438677ilb.92.1704367777306; Thu, 04 Jan
 2024 03:29:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231221095002.7404-1-duchao@eswincomputing.com>
 <CAK9=C2Wfv7=fCitUdjBpC9=0icN82Bb+9p1-Gq5ha8o9v13nEg@mail.gmail.com> <19434eff.1deb.18c90a3a375.Coremail.duchao@eswincomputing.com>
In-Reply-To: <19434eff.1deb.18c90a3a375.Coremail.duchao@eswincomputing.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 4 Jan 2024 16:59:26 +0530
Message-ID: <CAAhSdy0VWxjvKsxiad72JY7_Ottt5S9ymZ3axt=W3-4nf+g4VQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] RISC-V: KVM: Guest Debug Support
To: Chao Du <duchao@eswincomputing.com>
Cc: Anup Patel <apatel@ventanamicro.com>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, atishp@atishpatra.org, 
	dbarboza@ventanamicro.com, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 22, 2023 at 1:59=E2=80=AFPM Chao Du <duchao@eswincomputing.com>=
 wrote:
>
> On 2023-12-21 21:01, Anup Patel <apatel@ventanamicro.com> wrote:
> >
> > On Thu, Dec 21, 2023 at 3:21=E2=80=AFPM Chao Du <duchao@eswincomputing.=
com> wrote:
> > >
> > > This series implements KVM Guest Debug on RISC-V. Currently, we can
> > > debug RISC-V KVM guest from the host side, with software breakpoints.
> > >
> > > A brief test was done on QEMU RISC-V hypervisor emulator.
> > >
> > > A TODO list which will be added later:
> > > 1. HW breakpoints support
> > > 2. Test cases
> >
> > Himanshu has already done the complete HW breakpoint implementation
> > in OpenSBI, Linux RISC-V, and KVM RISC-V. This is based on the upcoming
> > SBI debug trigger extension draft proposal.
> > (Refer, https://lists.riscv.org/g/tech-debug/message/1261)
> >
> > There are also RISE projects to track these efforts:
> > https://wiki.riseproject.dev/pages/viewpage.action?pageId=3D394541
> > https://wiki.riseproject.dev/pages/viewpage.action?pageId=3D394545
> >
> > Currently, we are in the process of upstreaming the OpenSBI support
> > for SBI debug trigger extension. The Linux RISC-V and KVM RISC-V
> > patches require SBI debug trigger extension and Sdtrig extension to
> > be frozen which will happen next year 2024.
> >
> > Regards,
> > Anup
> >
>
> Hi Anup,
>
> Thank you for the information and your great work on the SBI
> Debug Trigger Extension proposal.
>
> So I think that 'HW breakpoints support' in the above TODO list
> will be taken care of by Himanshu following the extension proposal.
>
> On the other hand, if I understand correctly, the software
> breakpoint part of KVM Guest Debug has no dependency on the new
> extension since it does not use the trigger module. Just an
> ebreak substitution is made.
>
> So may I know your suggestion about this RFC? Both in KVM and QEMU.

Sorry for the delay in response due to holiday season other
stuff keeping me busy.

If this is about ebreak instruction virtualization then this series
needs following changes:
1) Update cover letter to indicate this series focus on ebreak
     instruction virtualization
2) PATCH1 and PATCH2 can be merged into one PATCH1
3) Include a new patch which adds KVM selftest for ebreak
    based guest debug. This selftest will test both:
    A) Taking "ebreak" trap from guest as KVM_EXIT_DEBUG
         in host user-space
    B) Taking "ebreak" trap from guest as BREAKPOINT
        exception in guest

Regards,
Anup

>
> Regards,
> Chao
>
> > >
> > > This series is based on Linux 6.7-rc6 and is also available at:
> > > https://github.com/Du-Chao/linux/tree/riscv_gd_sw
> > >
> > > The matched QEMU is available at:
> > > https://github.com/Du-Chao/qemu/tree/riscv_gd_sw
> > >
> > > Chao Du (3):
> > >   RISC-V: KVM: Enable the KVM_CAP_SET_GUEST_DEBUG capability
> > >   RISC-V: KVM: Implement kvm_arch_vcpu_ioctl_set_guest_debug()
> > >   RISC-V: KVM: Handle breakpoint exits for VCPU
> > >
> > >  arch/riscv/include/uapi/asm/kvm.h |  1 +
> > >  arch/riscv/kvm/vcpu.c             | 15 +++++++++++++--
> > >  arch/riscv/kvm/vcpu_exit.c        |  4 ++++
> > >  arch/riscv/kvm/vm.c               |  1 +
> > >  4 files changed, 19 insertions(+), 2 deletions(-)
> > >
> > > --
> > > 2.17.1
> > >
> > >
> > > --
> > > kvm-riscv mailing list
> > > kvm-riscv@lists.infradead.org
> > > http://lists.infradead.org/mailman/listinfo/kvm-riscv

