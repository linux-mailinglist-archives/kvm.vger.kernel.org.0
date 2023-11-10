Return-Path: <kvm+bounces-1500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA5AD7E829C
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 20:32:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B264D1C20AD3
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 19:32:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B4783B29F;
	Fri, 10 Nov 2023 19:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kIY2MI5D"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C375D3B292
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 19:32:13 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A4A688F
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 11:32:11 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-da0c7d27fb0so2816968276.1
        for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 11:32:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699644730; x=1700249530; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rscOOVYju3IYaiMVnVP6ynDkK2d19s0rTRPZn172d+w=;
        b=kIY2MI5DJM/qzI+uyaJ+zXU+ZLkWnPqKz4qr6Hbe0AIIZnNxy6OZyl8NAvbJYCWDO9
         X8anEtkCWZioYhCqIV4l79Sf+3t0jb/YMpjyNDhbpgLmO6qRYCpFB50OmxkM8zSddNxn
         fGAd/uraB1xQ8IVEI2i0mkh3tnnDFXoItoMyq3jlNJFp6R95LqGY9EL3jJRi+2H5V6C9
         CM3SeGmJat1BcHy+idyBWYaJQqhbDaItOSh5cp94gO/xB+U11EGFTeJB2S0LVbDkG7fP
         J5QwD13ehBl8oBW3qlPad/j6VmJu+HmRbkh+Y1BM5Nmervx4Z/W/Eb1fZHpgimydjqN5
         IBMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699644730; x=1700249530;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rscOOVYju3IYaiMVnVP6ynDkK2d19s0rTRPZn172d+w=;
        b=wA2BwJ91H43WYlU8CmV5ANb5ZY8lo4l0INaz8+SdixMkOypoauUplxhYfx5oM05zYj
         w7FMhyj3kwF62gmeEsHDsAg8vXUxpIda7vBfwZJ6+bU080/7sG95gKGxsBRwuLpoHY6Y
         zP/wqgIxwX6LpFAzudnAI/+kW7RQrzyilUczT55AD3yakLZnySQ4O9w5ZJnnpDOT0lMS
         Dz3DUWvxEsAli5VUP326m+htk9xPGxGMFf6XkeJiko3/6BH38C9WSqvIARa1Frici6Wy
         szJuSgZa9UWghpKhyZdAhGXVDXYn/77G3yDrW1tbYkr0iCu5vqVyl7sZyPz0daEJcSGm
         MEiQ==
X-Gm-Message-State: AOJu0YwiEI4ad6ma8L+7vNvfseEw4qiJBhmPyQBGlU5+UdYXGtuK4o23
	33Bt6TZIJ98PWdmc2WWUxA5mfjRxr/M=
X-Google-Smtp-Source: AGHT+IHHBCWk9v52Oayu+9pKnzADg1rJkQ9vJxLG4FzLGShvKXoBpg0SlnafNs/DMgJlK4ypSOG/E3KH84E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:9c03:0:b0:d9d:973:a78b with SMTP id
 c3-20020a259c03000000b00d9d0973a78bmr1918ybo.3.1699644730558; Fri, 10 Nov
 2023 11:32:10 -0800 (PST)
Date: Fri, 10 Nov 2023 11:32:08 -0800
In-Reply-To: <CWVBQQ6GVQVG.2FKWLPBUF77UT@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231108111806.92604-1-nsaenz@amazon.com> <ZUu9lwJHasi2vKGg@google.com>
 <ZUvUZytj1AabvvrB@google.com> <CWVBQQ6GVQVG.2FKWLPBUF77UT@amazon.com>
Message-ID: <ZU6FOF0qUAv8b1zm@google.com>
Subject: Re: [RFC 0/33] KVM: x86: hyperv: Introduce VSM support
From: Sean Christopherson <seanjc@google.com>
To: Nicolas Saenz Julienne <nsaenz@amazon.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com, 
	anelkz@amazon.com, graf@amazon.com, dwmw@amazon.co.uk, jgowans@amazon.com, 
	corbert@lwn.net, kys@microsoft.com, haiyangz@microsoft.com, 
	decui@microsoft.com, x86@kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 10, 2023, Nicolas Saenz Julienne wrote:
> On Wed Nov 8, 2023 at 6:33 PM UTC, Sean Christopherson wrote:
> >  - What is the split between userspace and KVM?  How did you arrive at =
that split?
>=20
> Our original design, which we discussed in the KVM forum 2023 [1] and is
> public [2], implemented most of VSM in-kernel. Notably we introduced VTL
> awareness in struct kvm_vcpu.

...

> So we decided to move all this complexity outside of struct kvm_vcpu
> and, as much as possible, out of the kernel. We figures out the basic
> kernel building blocks that are absolutely necessary, and let user-space
> deal with the rest.

Sorry, I should have been more clear.  What's the split in terms of respons=
ibilities,
i.e. what will KVM's ABI look like?  E.g. if the vCPU=3D>VTLs setup is nons=
ensical,
does KVM care?

My general preference is for KVM to be as permissive as possible, i.e. let
userspace do whatever it wants so long as it doesn't place undue burden on =
KVM.
But at the same time I don't to end up in a similar boat as many of the par=
avirt
features, where things just stop working if userspace or the guest makes a =
goof.

> >  - Why not make VTLs a first-party concept in KVM?  E.g. rather than bu=
ry info
> >    in a VTL device and APIC ID groups, why not modify "struct kvm" to s=
upport
> >    replicating state that needs to be tracked per-VTL?  Because of how =
memory
> >    attributes affect hugepages, duplicating *memslots* might actually b=
e easier
> >    than teaching memslots to be VTL-aware.
>=20
> I do agree that we need to introduce some level VTL awareness into
> memslots. There's the hugepages issues you pointed out. But it'll be
> also necessary once we look at how to implement overlay pages that are
> per-VTL. (A topic I didn't mention in the series as I though I had
> managed to solve memory protections while avoiding the need for multiple
> slots). What I have in mind is introducing a memory slot address space
> per-VTL, similar to how we do things with SMM.

Noooooooo (I hate memslot address spaces :-) )

Why not represent each VTL with a separate "struct kvm" instance?  That wou=
ld
naturally provide per-VTL behavior for:

  - APIC groups
  - memslot overlays
  - memory attributes (and their impact on hugepages)
  - MMU pages

The only (obvious) issue with that approach would be cross-VTL operations. =
 IIUC,
sending IPIs across VTLs isn't allowed, but even if it were, that should be=
 easy
enough to solve, e.g. KVM already supports posting interrupts from non-KVM =
sources.

GVA=3D>GPA translation would be trickier, but that patch suggests you want =
to handle
that in userspace anyways.  And if translation is a rare/slow path, maybe i=
t could
simply be punted to userspace?

  NOTE: The hypercall implementation is incomplete and only shared for
  completion. Additionally we'd like to move the VTL aware parts to
  user-space.

Ewww, and looking at what it would take to support cross-VM translations sh=
ows
another problem with using vCPUs to model VTLs.  Nothing prevents userspace=
 from
running a virtual CPU at multiple VTLs concurrently, which means that anyth=
ing
that uses kvm_hv_get_vtl_vcpu() is unsafe, e.g. walk_mmu->gva_to_gpa() coul=
d be
modified while kvm_hv_xlate_va_walk() is running.

I suppose that's not too hard to solve, e.g. mutex_trylock() and bail if so=
mething
holds the other kvm_vcpu/VTL's mutex.  Though ideally, KVM would punt all c=
ross-VTL
operations to userspace.  :-)

If punting to userspace isn't feasible, using a struct kvm per VTL probably=
 wouldn't
make the locking and concurrency problems meaningfully easier or harder to =
solve.
E.g. KVM could require VTLs, i.e. "struct kvm" instances that are part of a=
 single
virtual machine, to belong to the same process.  That'd avoid headaches wit=
h
mm_struct, at which point I don't _think_ getting and using a kvm_vcpu from=
 a
different kvm would need special handling?

Heh, another fun one, the VTL handling in kvm_hv_send_ipi() is wildly broke=
n, the
in_vtl field is consumed before send_ipi is read from userspace.

	union hv_input_vtl *in_vtl;
	u64 valid_bank_mask;
	u32 vector;
	bool all_cpus;
	u8 vtl;

	/* VTL is at the same offset on both IPI types */
	in_vtl =3D &send_ipi.in_vtl;
	vtl =3D in_vtl->use_target_vtl ? in_vtl->target_vtl : kvm_hv_get_active_vt=
l(vcpu);

> >    E.g. if 90% of the state is guaranteed to be identical for a given
> >    vCPU across execution contexts, then modeling that with separate
> >    kvm_vcpu structures is very inefficient.  I highly doubt it's 90%,
> >    but it might be quite high depending on how much the TFLS restricts
> >    the state of the vCPU, e.g. if it's 64-bit only.
>=20
> For the record here's the private VTL state (TLFS 15.11.1):
>=20
> "In general, each VTL has its own control registers, RIP register, RSP
>  register, and MSRs:
>=20
>  SYSENTER_CS, SYSENTER_ESP, SYSENTER_EIP, STAR, LSTAR, CSTAR, SFMASK,
>  EFER, PAT, KERNEL_GSBASE, FS.BASE, GS.BASE, TSC_AUX
>  HV_X64_MSR_HYPERCALL
>  HV_X64_MSR_GUEST_OS_ID
>  HV_X64_MSR_REFERENCE_TSC
>  HV_X64_MSR_APIC_FREQUENCY
>  HV_X64_MSR_EOI
>  HV_X64_MSR_ICR
>  HV_X64_MSR_TPR
>  HV_X64_MSR_APIC_ASSIST_PAGE
>  HV_X64_MSR_NPIEP_CONFIG
>  HV_X64_MSR_SIRBP
>  HV_X64_MSR_SCONTROL
>  HV_X64_MSR_SVERSION
>  HV_X64_MSR_SIEFP
>  HV_X64_MSR_SIMP
>  HV_X64_MSR_EOM
>  HV_X64_MSR_SINT0 =E2=80=93 HV_X64_MSR_SINT15
>  HV_X64_MSR_STIMER0_COUNT =E2=80=93 HV_X64_MSR_STIMER3_COUNT
>  Local APIC registers (including CR8/TPR)

Ugh, the APIC state is quite the killer.  And I gotta image things like CET=
 and
FRED are only going to increase that list.

