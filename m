Return-Path: <kvm+bounces-5696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 33C3F824C20
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 01:22:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5B3D286620
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 00:22:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2A0320E6;
	Fri,  5 Jan 2024 00:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nW1s889E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E57A1FAD
	for <kvm@vger.kernel.org>; Fri,  5 Jan 2024 00:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbeba57a668so1495494276.3
        for <kvm@vger.kernel.org>; Thu, 04 Jan 2024 16:22:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704414164; x=1705018964; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SybjoZW/cSlkZVzh68IoTGFRywrzT9vwqlEyGtKNIR8=;
        b=nW1s889EcBi6/ZEEivT1Tdcz14mP89CvHhu8vTAV3L0Cp3thifcDDnteK6uK4I54XS
         MNadKGzilIXllqqCva6BeYSzR8wLC36OVmnTI6ahlLQIMihH7oFMQXfj3/xwlXcJUV9+
         zO+Zg4AeG6Mcwtrv8e+YqMSkO6MLjAdBgQVJ/W2sXf+jAmD11gbhhs4Kpw95l2+5tMqf
         J+JmFPmNfvK64jZYWr2D9RvyNL/saXbCXTyhHz0T1Y04Rt9Q1+4pDfntnPj39/M5xSbd
         xYxUvLMnUGqELmSUh3VNps432oyL3VunW/A2hsuKffgYNFhTA6i0Jg4MnEM0s3fTvTqr
         s1dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704414164; x=1705018964;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SybjoZW/cSlkZVzh68IoTGFRywrzT9vwqlEyGtKNIR8=;
        b=X4mlMPXt0edVsWtIJnzIfMT5+PbpLv7CNdzky7XKzXS6vgwe2hb3K9QkOBtSyL9fKW
         vZxgQC1KQWZ+6KUCOdhpkKA9uTyq8jsr13uOkPkTJwdj7xWTq8Hay4Hu/OoCtqPF3nyG
         tecB6madPnStuwXJceMLse+rLKKJTNExkgeTweuO3YFONtaK53zP/eQBMY6iuyvz/0VJ
         0Wnw3QHUYPz+qCH64oTMxMUSIS+CBgmN3i3iGZ8yhjxuR9BFAYkNPoFcczxsZHuzxFNV
         zQQbklh/4iRMIokk/V9me5qU8sZs3OtwPBTROWyi65Rgimd3tNSQzdhXwrkX7VAP0Qy2
         iT7A==
X-Gm-Message-State: AOJu0YwM4MsIHNiDmfnRRm4i4uIqhogu4oZFRP0FwGTu0ki4qsFzdgNO
	0IWj2C3XhSeVnhafLpSbkDNUOWxBcC1eg9nVoA==
X-Google-Smtp-Source: AGHT+IE2lDtrpQIEVCpgXRAwTbbQce/auhLPKxXM0cM+isW8l4+fyA1xhwXCG5D7sTu+36O5XoJoBYeK4xM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:a286:0:b0:dbd:5be2:deee with SMTP id
 c6-20020a25a286000000b00dbd5be2deeemr519915ybi.1.1704414164220; Thu, 04 Jan
 2024 16:22:44 -0800 (PST)
Date: Thu, 4 Jan 2024 16:22:42 -0800
In-Reply-To: <6179ddcb25c683bd178e74e7e2455cee63ba74de.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231221140239.4349-1-weijiang.yang@intel.com>
 <93f118670137933980e9ed263d01afdb532010ed.camel@intel.com>
 <5f57ce03-9568-4739-b02d-e9fac6ed381a@intel.com> <6179ddcb25c683bd178e74e7e2455cee63ba74de.camel@intel.com>
Message-ID: <ZZdLG5W5u19PsnTo@google.com>
Subject: Re: [PATCH v8 00/26] Enable CET Virtualization
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Weijiang Yang <weijiang.yang@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Dave Hansen <dave.hansen@intel.com>, "peterz@infradead.org" <peterz@infradead.org>, 
	"john.allen@amd.com" <john.allen@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 04, 2024, Rick P Edgecombe wrote:
> On Thu, 2024-01-04 at 15:11 +0800, Yang, Weijiang wrote:
> > > What is the design around CET and the KVM emulator?
> >=20
> > KVM doesn't emulate CET HW behavior for guest CET, instead it leaves CE=
T
> > related checks and handling in guest kernel. E.g., if emulated JMP/CALL=
 in
> > emulator triggers mismatch of data stack and shadow stack contents, #CP=
 is
> > generated in non-root mode instead of being injected by KVM.=C2=A0 KVM =
only
> > emulates basic x86 HW behaviors, e.g., call/jmp/ret/in/out etc.
>=20
> Right. In the case of CET those basic behaviors (call/jmp/ret) now have
> host emulation behavior that doesn't match what guest execution would
> do.

I wouldn't say that KVM emulates "basic" x86.  KVM emulates instructions th=
at
BIOS and kernels execute in Big Real Mode (and other "illegal" modes prior =
to Intel
adding unrestricted guest), instructions that guests commonly use for MMIO,=
 I/O,
and page table modifications, and few other tidbits that have cropped up ov=
er the
years.

In other words, as Weijiang suspects below, KVM's emulator handles juuust e=
nough
stuff to squeak by and not barf on real world guests.  It is not, and has n=
ever
been, anything remotely resembling a fully capable architectural emulator.

> > > My understanding is that the KVM emulator kind of does what it has to
> > > keep things running, and isn't expected to emulate every possible
> > > instruction. With CET though, it is changing the behavior of existing
> > > supported instructions. I could imagine a guest could skip over CET
> > > enforcement by causing an MMIO exit and racing to overwrite the exit-
> > > causing instruction from a different vcpu to be an indirect CALL/RET,
> > > etc.
> >=20
> > Can you elaborate the case? I cannot figure out how it works.
>=20
> The point that it should be possible for KVM to emulate call/ret with
> CET enabled. Not saying the specific case is critical, but the one I
> used as an example was that the KVM emulator can (or at least in the
> not too distant past) be forced to emulate arbitrary instructions if
> the guest overwrites the instruction between the exit and the SW fetch
> from the host.=C2=A0
>=20
> The steps are:
> vcpu 1                         vcpu 2
> -------------------------------------
> mov to mmio addr
> vm exit ept_misconfig
>                                overwrite mov instruction to call %rax
> host emulator fetches
> host emulates call instruction
>=20
> So then the guest call operation will skip the endbranch check. But I'm
> not sure that there are not less exotic cases that would run across it.
> I see a bunch of cases where write protected memory kicks to the
> emulator as well. Not sure the exact scenarios and whether this could
> happen naturally in races during live migration, dirty tracking, etc.

It's for shadow paging.  Instead of _immediately_ zapping SPTEs on any writ=
e to
a shadowed guest PTE, KVM instead tries to emulate the faulting instruction=
 (and
then still zaps SPTE).  If KVM can't emulate the instruction for whatever r=
eason,
then KVM will _usually_ just zap the SPTE and resume the guest, i.e. retry =
the
faulting instruction.

The reason KVM doesn't automatically/unconditionally zap and retry is that =
there
are circumstances where the guest can't make forward progress, e.g. if an
instruction is using a guest PTE that it is writing, if L2 is modifying L1 =
PTEs,
and probably a few other edge cases I'm forgetting.

> Again, I'm more just asking the exposure and thinking on it.

If you care about exposure to the emulator from a guest security perspectiv=
e,
assume that a compromised guest can coerce KVM into attempting to emulate
arbitrary bytes.  As in the situation described above, it's not _that_ diff=
icult
to play games with TLBs and instruction vs. data caches.

If all you care about is not breaking misbehaving guests, I wouldn't worry =
too
much about it.

> > > With reasonable assumptions around the threat model in use by the gue=
st
> > > this is probably not a huge problem. And I guess also reasonable
> > > assumptions about functional expectations, as a misshandled CALL or R=
ET
> > > by the emulator would corrupt the shadow stack.
> >=20
> > KVM emulates general x86 HW behaviors, if something wrong happens after
> > emulation then it can happen even on bare metal, i.e., guest SW most li=
kely
> > gets wrong somewhere and it's expected to trigger CET exceptions in gue=
st
> > kernel.

No, the days of KVM making shit up from are done.  IIUC, you're advocating =
that
it's ok for KVM to induce a #CP that architecturally should not happen.  Th=
at is
not acceptable, full stop.

Retrying the instruction in the guest, exiting to userspace, and even termi=
nating
the VM are all perfectly acceptable behaviors if KVM encounters something i=
t can't
*correctly* emulate.  But clobbering the shadow stack or not detecting a CF=
I
violation, even if the guest is misbehaving, is not ok.

> > > But, another thing to do could be to just return X86EMUL_UNHANDLEABLE=
 or
> > > X86EMUL_RETRY_INSTR when CET is active and RET or CALL are emulated.
> >=20
> > IMHO, translating the CET induced exceptions into X86EMUL_UNHANDLEABLE =
or
> > X86EMUL_RETRY_INSTR would confuse guest kernel or even VMM, I prefer
> > letting guest kernel handle #CP directly.
>
> Doesn't X86EMUL_RETRY_INSTR kick it back to the guest which is what you
> want? Today it will do the operations without the special CET behavior.
>=20
> But I do see how this could be tricky to avoid the guest getting stuck
> in a loop with X86EMUL_RETRY_INSTR. I guess the question is if this
> situation is encountered, when KVM can't handle the emulation
> correctly, what should happen? I think usually it returns
> KVM_INTERNAL_ERROR_EMULATION to userspace? So I don't see why the CET
> case is different.
>=20
> If the scenario (call/ret emulation with CET enabled) doesn't happen,
> how can the guest be confused? If it does happen, won't it be an issue?
>=20
> > > And I guess also for all instructions if the TRACKER bit is set. It
> > > might tie up that loose end without too much trouble.
> > >=20
> > > Anyway, was there a conscious decision to just punt on CET enforcemen=
t in
> > > the emulator?
> >=20
> > I don't remember we ever discussed it in community, but since KVM
> > maintainers reviewed the CET virtualization series for a long time, I
> > assume we're moving on the right way :-)
>=20
> It seems like kind of leap that if it never came up that they must be
> approving of the specific detail. Don't know. Maybe they will chime in.

Yeah, I don't even know what the TRACKER bit does (I don't feel like readin=
g the
SDM right now), let alone if what KVM does or doesn't do in response is rem=
otely
correct.

For CALL/RET (and presumably any branch instructions with IBT?) other instr=
uctions
that are directly affected by CET, the simplest thing would probably be to =
disable
those in KVM's emulator if shadow stacks and/or IBT are enabled, and let KV=
M's
failure paths take it from there.

Then, *if* a use case comes along where the guest is utilizing CET and "nee=
ds"
KVM to emulate affected instructions, we can add the necessary support the =
emulator.

Alternatively, if teaching KVM's emulator to play nice with shadow stacks a=
nd IBT
is easy-ish, just do that.

