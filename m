Return-Path: <kvm+bounces-5451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ADE7382209F
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 18:53:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CFFA283EEC
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 17:53:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7545D156D2;
	Tue,  2 Jan 2024 17:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Momju1TA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661CD156C0
	for <kvm@vger.kernel.org>; Tue,  2 Jan 2024 17:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-28c05e74e36so10344874a91.0
        for <kvm@vger.kernel.org>; Tue, 02 Jan 2024 09:53:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704218008; x=1704822808; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2JWSinxBPahJL5G6ilkag7k2Ha57KIycyEmjKB/DcoQ=;
        b=Momju1TAcLMvhUpzYwuIDB2bSr3/5xqDGV/hxK8TXXaOHT5bbRejVs8u0hKDkByYsW
         wNHAWdBb9JNdR3QjAOESHpbls00HebBAxnCujhsX7lokgTS5uCyAwdaY378okWthVXX7
         JHDnqserkdrefL51uQ7OHezu1kKZGsqZHEua59uzocwhQs2RT6zt0XcYMKf/YKKav29E
         dqTptTcf6/DsjydWnEfwWaSksVlAASXKRrl2bSsliefBcqPThfVk/w1A+fxN3u0UJxeI
         i8XGFxLY+KQjABVpgOoDdaaUAsF0NIJQiNEhC/zHMaJ9zvVshvULUw2gjLPdXus3kpEC
         H0Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704218009; x=1704822809;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2JWSinxBPahJL5G6ilkag7k2Ha57KIycyEmjKB/DcoQ=;
        b=SB2FZgCcCmDWHvQ8MAy5niLF66yio0/AT3GUFfXfYBFbPtfVmWCsAp0UAUpoCExbIL
         7dEJJIEusoaGMAKCKcUyTrvrcseo7ybfsfpxKV62eL28jpKsik3hxUI2+zVq1hiMfwUS
         VqGP8eOywF8QUqU/thoAJ/sk4HSGjUPN0Ardeq3lWgwjQaKrU5JGAMVqtDYvgYea3req
         UO4ehpWlPD5EzZpyfXkyx71j0Buis5XBWjmUs0RClozTow1407C6TS+sJHt+2DaRU+jl
         hMpKhEQYGjtuIQIRTXNltg21z1Sm7yuQZ6VCmyShsBzrKwDamOeJAuFf4E0yRxw10uSS
         dl5g==
X-Gm-Message-State: AOJu0YxrJ0ltu6lLqNJUcGjZI6qqV+BTcL1WDbsB+Ry2yPDuvktkNkGD
	4xmse4fdFlXmUz+ASHXmRZXVVhXqZb76TyqQNw==
X-Google-Smtp-Source: AGHT+IH5AsbqQpeWg9Ux939hh4uYHKomZmPgZXaGgGmjIytCbBANzJTQ1mNK/ytQuClydE/B0ySgHektLI4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:38c7:b0:28b:e0cd:64a4 with SMTP id
 nn7-20020a17090b38c700b0028be0cd64a4mr1587418pjb.3.1704218008704; Tue, 02 Jan
 2024 09:53:28 -0800 (PST)
Date: Tue, 2 Jan 2024 09:53:27 -0800
In-Reply-To: <a31d33cb6eb14ddda272b9d291c5ae00@epfl.ch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CAJGDS+Ez+NpVtaO5_NTdiwrnTTGFbevz+aDUyLMZk6ufie701Q@mail.gmail.com>
 <20240101220601.2828996-1-tao.lyu@epfl.ch> <f1535a39-4f3b-bae8-950e-9a0e5df46681@oracle.com>
 <a31d33cb6eb14ddda272b9d291c5ae00@epfl.ch>
Message-ID: <ZZRNly2jIIVyC5F6@google.com>
Subject: Re: obtain the timestamp counter of physical/host machine inside the VMs.
From: Sean Christopherson <seanjc@google.com>
To: Tao Lyu <tao.lyu@epfl.ch>
Cc: Dongli Zhang <dongli.zhang@oracle.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"akalita@cs.stonybrook.edu" <akalita@cs.stonybrook.edu>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 02, 2024, Tao Lyu wrote:
>=20
> Hi=C2=A0Dongli,
>=20
> > On 1/1/24 14:06, Tao Lyu wrote:
> >> Hello Arnabjyoti, Sean, and everyone,
> >>=20
> >> I'm having a similiar but slightly differnt issue about the rdtsc in K=
VM.
> >>=20
> >> I want to obtain the timestamp counter of physical/host machine inside=
 the VMs.
> >>=20
> >> Acccording to the previous threads, I know I need to disable the offse=
tting, VM exit, and scaling.
> >> I specify the correspoding parameters in the qemu arguments.
> >> The booting command is listed below:
> >>=20
> >> qemu-system-x86_64 -m 10240 -smp 4 -chardev socket,id=3DSOCKSYZ,server=
=3Don,nowait,host=3Dlocalhost,port=3D3258 -mon chardev=3DSOCKSYZ,mode=3Dcon=
trol -display none -serial stdio -device virtio-rng-pci -enable-kvm -cpu ho=
st,migratable=3Doff,tsc=3Don,rdtscp=3Don,vmx-tsc-offset=3Doff,vmx-rdtsc-exi=
t=3Doff,tsc-scale=3Doff,tsc-adjust=3Doff,vmx-rdtscp-exit=3Doff  -netdev bri=
dge,id=3Dhn40 -device virtio-net,netdev=3Dhn40,mac=3De6:c8:ff:09:76:38 -hda=
 XXX -kernel XXX -append "root=3D/dev/sda console=3DttyS0"
> >>=20
> >>=20
> >> But the rdtsc still returns the adjusted tsc.
> >> The vmxcap script shows the TSC settings as below:
> >>=C2=A0=C2=A0=20
> >>=C2=A0=C2=A0 Use TSC offsetting=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 no
> >>=C2=A0=C2=A0 RDTSC exiting=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 no
> >>=C2=A0=C2=A0 Enable RDTSCP=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 no
> >>=C2=A0=C2=A0 TSC scaling=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 yes
> >>=20
> >>=20
> >> I would really appreciate it if anyone can tell me whether and how I c=
an get the tsc of physical machine insdie the VM.
>=20
> > If the objective is to obtain the same tsc at both VM and host side (th=
at is, to
> > avoid any offset or scaling), I can obtain quite close tsc at both VM a=
nd host
> > side with the below linux-6.6 change.
>=20
> > My env does not use tsc scaling.
>=20
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 41cce50..b102dcd 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> >@@ -2723,7 +2723,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *v=
cpu, u64
> data)
> >=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool synchronizing =3D false;
> >
> >=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 raw_spin_lock_irqsave(&kvm->arch.ts=
c_write_lock, flags);
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 offset =3D kvm_compute_l1_tsc_off=
set(vcpu, data);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 offset =3D 0;
> >=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ns =3D get_kvmclock_base_ns()=
;
> >=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 elapsed =3D ns - kvm->arch.la=
st_tsc_nsec;
> >
> > Dongli Zhang
>=20
>=20
> Hi Dongli,
>=20
> Thank you so much for the explanation and for providing a patch.
> It works for me now.

Yeah, during vCPU creation KVM sets a target guest TSC of '0', i.e. sets th=
e TSC
offset to "0 - HOST_TSC".  As of commit 828ca89628bf ("KVM: x86: Expose TSC=
 offset
controls to userspace"), userspace can explicitly set an offset of '0' via
KVM_VCPU_TSC_CTRL+KVM_VCPU_TSC_OFFSET, but AFAIK QEMU doesn't support that =
API.

All the other methods for setting the TSC offset are indirect, i.e. userspa=
ce
provides the target TSC and KVM computes the offset.  So even if QEMU provi=
des a
way to specify an explicit TSC (or offset), there will be a healthy amount =
of slop.

