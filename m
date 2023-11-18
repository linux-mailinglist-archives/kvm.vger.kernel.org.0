Return-Path: <kvm+bounces-1997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F99C7EFFFD
	for <lists+kvm@lfdr.de>; Sat, 18 Nov 2023 14:52:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0961B1F231FB
	for <lists+kvm@lfdr.de>; Sat, 18 Nov 2023 13:52:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91FB016418;
	Sat, 18 Nov 2023 13:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Ns6nkaP8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FA8131
	for <kvm@vger.kernel.org>; Sat, 18 Nov 2023 05:52:32 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id 46e09a7af769-6ce2de8da87so1715019a34.1
        for <kvm@vger.kernel.org>; Sat, 18 Nov 2023 05:52:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1700315551; x=1700920351; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8dJdeaSl2iDXGD4fFQbdUz9nPWUPUtzPBa9eIdHnwHM=;
        b=Ns6nkaP8CKBOx+cP3P1IAD3CkuZ5LDKGh5aV51EMNbfpc777EvMv1BMWvnyu5kc4aL
         TqC1f5VAAeWw/wV6afeOJYZEENRX7qrw7g7InhBxEMrPKbRkfmFyDS2VQdQtml5cARVe
         7D5eGcITeYVndcfGorWzQr9zz/TYKryAK2R/NfLzQ26H2PCZLzwk9RtiXAXpM+lCgI4R
         3VLoumcMl2kZQ+b24u3A/teRs/L8NuLajUTauARF9PQj9h0ZbERmkuuaIZHeKhKkMDO0
         syqdvhUkK2XRiIMTa6qj5r049FJtsSTId7+9ruSyVzAEmH98i8Sukm777Nj/PNpLnG3J
         AUwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700315551; x=1700920351;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8dJdeaSl2iDXGD4fFQbdUz9nPWUPUtzPBa9eIdHnwHM=;
        b=rUTx9ht70FxNkbegLbJmc40+s30bdK+5pH3C+MZxVwZadNlFWoPYQGeM4Nfaa4FAZy
         mN4Z/txXKIaX+oUhpqF7vvmWIcrKfUTGWbvq/g0jDAIoNCVt2cImBzIoCU3kSpLExn63
         +kBGK+Hg6FAJ7PbMPj1psrxz06mA4ZSHJTjbblQXakRAqfLOdUx0RsI6puGRZx/tAwsg
         KdwRM2p7itaEnIHGxrSPCiq4obdP+rIUREfKlaC8RRqv1JKf07wQXr5w4fV1/cXJJ1PQ
         aOKAi/I+5HSfbrKLVcwWLIvCUQCY3EYBTQg3++cvPrOsReMtV4Stq+StNVc2jen/3A8E
         eS/w==
X-Gm-Message-State: AOJu0Yz8q4mT88y2/xMDoxr0aAtDF0odp5RsS85dV3OmRO8e51btDqJK
	mzkr0IpH9FCu5q9wKfoDy7T2gdJLZmqAgOFbTGyDyw==
X-Google-Smtp-Source: AGHT+IGK7VroMNoGU9r+hFvyRtjs17+/owh3naN9e8ofHzSejSo1J8BeVBLhPe37Qx9JiFyPkr/K8pCAD2vNxKPClV4=
X-Received: by 2002:a05:6871:200c:b0:1ef:b62d:24c9 with SMTP id
 rx12-20020a056871200c00b001efb62d24c9mr2510300oab.5.1700315551203; Sat, 18
 Nov 2023 05:52:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230918125730.1371985-1-apatel@ventanamicro.com>
 <CAK9=C2Vvu=kcR5CtzSFFh4DFvqxMsLrLNAHpMxoxrCf8nUixbw@mail.gmail.com> <20231107111142.GA19291@willie-the-truck>
In-Reply-To: <20231107111142.GA19291@willie-the-truck>
From: Anup Patel <apatel@ventanamicro.com>
Date: Sat, 18 Nov 2023 19:22:20 +0530
Message-ID: <CAK9=C2VRNyzfOok8rx-BXujDvD9yqKdkwLcDJWzOzEZ1aAWhyw@mail.gmail.com>
Subject: Re: [kvmtool PATCH v2 0/6] RISC-V AIA irqchip and Svnapot support
To: Will Deacon <will@kernel.org>
Cc: julien.thierry.kdev@gmail.com, maz@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Atish Patra <atishp@atishpatra.org>, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 7, 2023 at 4:41=E2=80=AFPM Will Deacon <will@kernel.org> wrote:
>
> On Thu, Oct 12, 2023 at 09:50:29AM +0530, Anup Patel wrote:
> > On Mon, Sep 18, 2023 at 6:27=E2=80=AFPM Anup Patel <apatel@ventanamicro=
.com> wrote:
> > >
> > > The latest KVM in Linux-6.5 has support for:
> > > 1) Svnapot ISA extension support
> > > 2) AIA in-kernel irqchip support
> > >
> > > This series adds corresponding changes in KVMTOOL to use the above
> > > mentioned features for Guest/VM.
> > >
> > > These patches can also be found in the riscv_aia_v2 branch at:
> > > https://github.com/avpatel/kvmtool.git
> > >
> > > Changes since v1:
> > >  - Rebased on commit 9cb1b46cb765972326a46bdba867d441a842af56
> > >  - Updated PATCH1 to sync header with released Linux-6.5
> > >
> > > Anup Patel (6):
> > >   Sync-up header with Linux-6.5 for KVM RISC-V
> > >   riscv: Add Svnapot extension support
> > >   riscv: Make irqchip support pluggable
> > >   riscv: Add IRQFD support for in-kernel AIA irqchip
> > >   riscv: Use AIA in-kernel irqchip whenever KVM RISC-V supports
> > >   riscv: Fix guest/init linkage for multilib toolchain
> >
> > Friendly ping ?
>
> There are a bunch of open review comments from Drew that need to be
> addressed in a subsequent version.

I have sent-out v3 with Drew's comments addressed.

Thanks,
Anup

