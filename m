Return-Path: <kvm+bounces-134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C39C17DC225
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 22:52:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3104CB20EDE
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 21:52:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24FE31CFA6;
	Mon, 30 Oct 2023 21:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KP0aBuSR"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B1E1A5AF
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 21:52:10 +0000 (UTC)
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28BC0ED
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 14:52:09 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1cc56a9ece7so9844625ad.3
        for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 14:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698702728; x=1699307528; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BzJ/Ymhb65Ar0LBBebue0mT9iTpkJ0/uT6hATBgr33I=;
        b=KP0aBuSRG+skxT/wl+FSpA5EVV+giIddQX8FRcsP1y5rNL/R2lJmj+HOOUPunWV6WZ
         TfFiIMZUdjs5h8RvyzdZCjT0ay1CgH/W/a3qxKgFRY0lRxHuBSBpDkM1o4Vx1EkZLfYe
         7ot7sGHINw+mXQ/o8Ml86bLas2yjzd0u/IzK2arIiDUn2n1SAwmj10hk39RPZFGSI+/q
         G7Iay+I1nwjufxTMiIGpxMWfokBkRP9oR4q21o9gZDdFQg5VsO50vqbDt1RDTB9vvRBL
         vxNwACn7pPb/dSX4vCsiTB5SZaTUJwRrO7h+YKjYNo/2bSa31MGKRFp7trSbR7ZhSZdo
         6qDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698702728; x=1699307528;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BzJ/Ymhb65Ar0LBBebue0mT9iTpkJ0/uT6hATBgr33I=;
        b=gODeCF9y4rvD4WpiMAMHYiO1pvfjp18c+bA+FeHziahJtA86UJADzNU7zNSWmEK8KQ
         Aso9nx1+fDqH3fAly9I3tBWIu8RKJSpAgAzPR4XHgzMu2QmrAQ5tHl57+0X7gbmHPrZR
         QpuoPD6GH05Ij29YPNpiMuBusdRDylB5N747DFM1e4kCzIM0QZWuRL8bk7E17ZTBU/2j
         aKt+95UhDQlMc0Isq2sAjjHOuaEiWo5/6P47KRtQkJLXSjbp9D8fk/EypwL6wk3pEYNx
         rg5fmsmoyP3ofwkVA4GsCx2OlSK84dqFyu7G4m8zuWtgouIDbGENZKSBQ52XPO0SL7UO
         OuVw==
X-Gm-Message-State: AOJu0YyWXrs9pCPcZ5fBDIVNthGY99n3YgXBZNLAnDcuC/yaOPOr5cuB
	OzFs2G+HtQMtc0F9ymcablhaO9teCNs=
X-Google-Smtp-Source: AGHT+IH2J9EhY1pZytvMjUtYvpcL+sIpMNtzT9vyOr4cvb4mXzpvu/rjLEjNyHYHjdQ8EJndP2Z1wMEcKoE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ab84:b0:1c5:7226:d5d6 with SMTP id
 f4-20020a170902ab8400b001c57226d5d6mr176972plr.6.1698702728708; Mon, 30 Oct
 2023 14:52:08 -0700 (PDT)
Date: Mon, 30 Oct 2023 21:52:07 +0000
In-Reply-To: <3E43ADC6-E817-411A-9EBF-B16142B9B478@cs.utexas.edu>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <2C868574-37F4-437D-8355-46A6D1615E51@cs.utexas.edu>
 <ZTxEIGmq69mUraOD@google.com> <ZT+eipbV5+mSjr+G@yzhao56-desk.sh.intel.com>
 <ZUAC0jvFE0auohL4@google.com> <3E43ADC6-E817-411A-9EBF-B16142B9B478@cs.utexas.edu>
Message-ID: <ZUAlh87sS5pUbBOd@google.com>
Subject: Re: A question about how the KVM emulates the effect of guest MTRRs
 on AMD platforms
From: Sean Christopherson <seanjc@google.com>
To: Yibo Huang <ybhuang@cs.utexas.edu>
Cc: Yan Zhao <yan.y.zhao@intel.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 30, 2023, Yibo Huang wrote:
> Well, I agree with Sean=E2=80=99s opinion that SVM+NPT obviates the need =
to emulate
> guest MTRRs for real-world guest workloads.  However, from my own experie=
nce,
> I think KVM does emulate the effect of guest MTRRs on AMD platforms.
>=20
> Here's the reason:
> 2 months ago, I was trying to attach a QEMU ivshmem device to my VMs runn=
ing
> on Intel and AMD machines.  Since ivshmem is an emulated memory-backed
> device, it should be cacheable to get the best performance.
> Interestingly, I found that the memory region associated with ivshmem (PC=
Ie
> BAR 2 region) was cacheable on Intel machines, but not cacheable on AMD
> machines.
> After some digging, I found that this was because of the guest MTRRs - on=
 AMD
> machines, BIOS or guest OS (not sure who did this) set the memory region =
of
> ivshmem as non-cacheable in guest MTRRs (but cacheable in guest PAT). Thi=
s
> was supported by the fact that ivhsmem became cacheable after removing th=
e
> corresponding guest MTRRs (reg02) on AMD machines (using "echo -n disable=
=3D2 >
> /proc/mtrr=E2=80=9D)
> Additionally, the reason why ivshmem was cacheable on Intel machines was =
that
> BIOS or guest OS didn=E2=80=99t set ivshmem as uncacheable in guest MTRRs=
 on Intel
> machines (not sure why though).

What test(s) did you run to determine whether or not the memory was truly c=
acheable?
KVM emulates the MTRR MSRs themselves, e.g. the guest can read and write MT=
RRs,
and the guest will _think_ memory has a certain memtype, but that doesn't n=
ecessarily
have any impact on the memtype used by the CPU.

> Below is the output of =E2=80=9Ccat /proc/mtrr=E2=80=9D on my VMs running=
 on AMD machines. By
> removing reg02, ivshmem BAR 2 region became cacheable.
>=20
>=20
> So in my opinion, the above phenomenon suggests that KVM does honor guest
> MTRRs on AMD platforms.

Heh, this isn't opinion.  Unless you're running a very specific 10-year old=
 kernel,
or a custom KVM build, KVM simply out doesn't propagate guest MTRRs into NP=
T.

And unless your setup also has non-coherent DMA attached to the device, KVM=
 doesn't
honor guest MTRRs for EPT either (AFAICT, QEMU ivshmem doesn't require VFIO=
).

It's definitely possible that disabling a guest MTRR resulted in memory bec=
oming
cacheable, but unless there's some very, very magical code hiding, it's not=
 because
KVM actually fully virtualizes guest MTRRs on AMD.

E.g. before commit 9a3768191d95 ("KVM: x86/mmu: Zap SPTEs on MTRR update if=
f guest
MTRRs are honored"), which hasn't even made its way to Linus (or Paolo's) t=
ree yet,
KVM unnecessarily zapped all NPT entries on MTRR changes.  Zapping NPT entr=
ies
could have cleared some weird TLB state, or perhaps even wiped out buggy KV=
M NPT
entries.

And on AMD, hardware virtualizes gCR0.CD, i.e. puts the caches into no-fill=
 mode
when guest CR0.CD=3D1.  But Intel CPUs completely ignore guest CR0.CD, i.e.=
 punt it
to software, and under QEMU, for all intents and purposes KVM never honors =
guest
CR0.CD for VMX.  It's seems highly quite unlikely that something in the gue=
st left
CR0.CD=3D1, but it's possible.  And then the guest kernel's process of togg=
ling
CR0.CD when doing MTRR updates would end up clearing CR0.CD and thus re-ena=
ble
caching.

> The thing was that I could not find any KVM code related to emulating gue=
st
> MTRRs on AMD platforms, which was the reason why I decided to send the
> initial email asking about it.
>=20
> I found this in the AMD64 Architecture Programmer=E2=80=99s Manual Volume=
s 1=E2=80=935 (page
> 553):=20
>=20
> "Table 15-19 shows how guest and host PAT types are combined into an
> effective PAT type. When interpreting this table, recall (a) that guest a=
nd
> host PAT types are not combined when nested paging is disabled and (b) th=
at
> the intent is for the VMM to use its PAT type to simulate guest MTRRs.=E2=
=80=9D
>=20
> Does this mean that AMD expects the VMM to emulate the effect of guest MT=
RRs
> by altering the host PAT types?

Yes.  Which is exactly what KVM did in commit 3c2e7f7de324 ("KVM: SVM: use =
NPT
page attributes"), which was a reverted a few months after it was introduce=
d.

> I am not sure if I misunderstood something. But I can reproduce the examp=
le I
> mentioned above if you would like to look into it.

Yes, it would be helpful to confirm what's going on. =20

