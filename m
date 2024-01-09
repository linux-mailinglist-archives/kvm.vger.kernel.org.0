Return-Path: <kvm+bounces-5897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CA3E8289E1
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 17:21:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 331A01C24649
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 16:21:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B0423A8C6;
	Tue,  9 Jan 2024 16:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eXb71HRN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3250E3A27E
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 16:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1d552f40a4aso9244485ad.0
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 08:21:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704817275; x=1705422075; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C1QljfHuBYifZoSINkWQXPLhbOWgB2wu97cY9uJdSqw=;
        b=eXb71HRNaSYXIM/fwofyVtht4DMwVZ904v3q4I/TTcQTBOFSCMRc6wB7vhc2cyAmif
         JqlC7M8Ggk3WYmOfYzi11JTwBRuBPE7uMJO/RCJGH0/xTYuni1eozaaTrWwa2RmUcE8E
         afBVnRVr3RML2OFoZX1rC4JrANPF6vFWHsiS47cSq0ceyZ9DaXbQAvG9fUCehsSvBiZf
         i6bUzmy6UQrGQyADHKilrpT9PzDFgd6yfdEo+xHvWNSP5vEcpNsR3jFcarTgwDfHYt79
         rNmmGECdl4gfpIRYrRCGHXHPa97FayW1mU8MlIxSUJwyaF23yYm1aqA3vMKE2aJtZmL6
         dB+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704817275; x=1705422075;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=C1QljfHuBYifZoSINkWQXPLhbOWgB2wu97cY9uJdSqw=;
        b=WNeQRwQITg6RE7N64XZ6J8XbSAyj46AQf0hfNNqFVNwS9Yl530EbXHsPmfgROHxZoX
         a2L49P1MkahFUnlaWD4FJBlYscy7ygSmwXFq2Gzs0Z0qnVeLkZJkB6cQFhdGuIoRS9Tw
         QFcm2mcxGACTQiW2Omlgbn3T5nQqhWIXXVFK2BIN+3nydnbLzkrro5d9QzQm/KfeAboo
         nMiF4IiuyOveV13HgTDALeZPYv7iddh2ZO8sPd8UWZ3he/43dpdQWgafv3Y+Z58AMQD4
         pXYZAd36XAcZ+vUcIDHazcvgNpCVQywGZh2O/tAYzkOwgZTGwUaQj+UuLbsatH5UpX+r
         5cvg==
X-Gm-Message-State: AOJu0YysfjAfF1hWKm5fJZj0N6jtuxCkN+gLGWCUSbBxEWqu7Cg7sfbt
	0461t2W6Uc8nemNBFpDCpdlRdcUym1s5LvWJAQ==
X-Google-Smtp-Source: AGHT+IGV8/ULEe3M2qwHzudjngx0cTn6Q7dyzC6iRpAHOxHlK8K8x9ybRqADHaQ05tYFX2UBRgPVs3ESUg8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c946:b0:1d5:82f:4fe9 with SMTP id
 i6-20020a170902c94600b001d5082f4fe9mr31097pla.2.1704817275575; Tue, 09 Jan
 2024 08:21:15 -0800 (PST)
Date: Tue, 9 Jan 2024 08:21:13 -0800
In-Reply-To: <ZZuDp+Pl0BHKEfPt@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1699368322.git.isaku.yamahata@intel.com>
 <7ca4b7af33646e3f5693472b4394ba0179b550e1.1699368322.git.isaku.yamahata@intel.com>
 <ZZiLKKobVcmvrPmb@google.com> <ZZuDp+Pl0BHKEfPt@chao-email>
Message-ID: <ZZ1yeYyXiYlB_7-N@google.com>
Subject: Re: [PATCH v17 092/116] KVM: TDX: Handle TDX PV HLT hypercall
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com, 
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com, Sagi Shahar <sagis@google.com>, 
	David Matlack <dmatlack@google.com>, Kai Huang <kai.huang@intel.com>, 
	Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com, hang.yuan@intel.com, 
	tina.zhang@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 08, 2024, Chao Gao wrote:
> On Fri, Jan 05, 2024 at 03:05:12PM -0800, Sean Christopherson wrote:
> >On Tue, Nov 07, 2023, isaku.yamahata@intel.com wrote:
> >> From: Isaku Yamahata <isaku.yamahata@intel.com>
> >>=20
> >> Wire up TDX PV HLT hypercall to the KVM backend function.
> >>=20
> >> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> >> ---
> >>  arch/x86/kvm/vmx/tdx.c | 42 +++++++++++++++++++++++++++++++++++++++++=
-
> >>  arch/x86/kvm/vmx/tdx.h |  3 +++
> >>  2 files changed, 44 insertions(+), 1 deletion(-)
> >>=20
> >> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> >> index 3a1fe74b95c3..4e48989d364f 100644
> >> --- a/arch/x86/kvm/vmx/tdx.c
> >> +++ b/arch/x86/kvm/vmx/tdx.c
> >> @@ -662,7 +662,32 @@ void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu=
)
> >> =20
> >>  bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu)
> >>  {
> >> -	return pi_has_pending_interrupt(vcpu);
> >> +	bool ret =3D pi_has_pending_interrupt(vcpu);
> >> +	struct vcpu_tdx *tdx =3D to_tdx(vcpu);
> >> +
> >> +	if (ret || vcpu->arch.mp_state !=3D KVM_MP_STATE_HALTED)
> >> +		return true;
> >> +
> >> +	if (tdx->interrupt_disabled_hlt)
> >> +		return false;
> >> +
> >> +	/*
> >> +	 * This is for the case where the virtual interrupt is recognized,
> >> +	 * i.e. set in vmcs.RVI, between the STI and "HLT".  KVM doesn't hav=
e
> >> +	 * access to RVI and the interrupt is no longer in the PID (because =
it
> >> +	 * was "recognized".  It doesn't get delivered in the guest because =
the
> >> +	 * TDCALL completes before interrupts are enabled.
> >> +	 *
> >> +	 * TDX modules sets RVI while in an STI interrupt shadow.
> >> +	 * - TDExit(typically TDG.VP.VMCALL<HLT>) from the guest to TDX modu=
le.
> >> +	 *   The interrupt shadow at this point is gone.
> >> +	 * - It knows that there is an interrupt that can be delivered
> >> +	 *   (RVI > PPR && EFLAGS.IF=3D1, the other conditions of 29.2.2 don=
't
> >> +	 *    matter)
> >> +	 * - It forwards the TDExit nevertheless, to a clueless hypervisor t=
hat
> >> +	 *   has no way to glean either RVI or PPR.
> >
> >WTF.  Seriously, what in the absolute hell is going on.  I reported this=
 internally
> >four ***YEARS*** ago.  This is not some obscure theoretical edge case, t=
his is core
> >functionality and it's completely broken garbage.
> >
> >NAK.  Hard NAK.  Fix the TDX module, full stop.
> >
> >Even worse, TDX 1.5 apparently _already_ has the necessary logic for dea=
ling with
> >interrupts that are pending in RVI when handling NESTED VM-Enter.  Reall=
y!?!?!
> >Y'all went and added nested virtualization support of some kind, but can=
't find
> >the time to get the basics right?
>=20
> We actually fixed the TDX module. See 11.9.5. Pending Virtual Interrupt
> Delivery Indication in TDX module 1.5 spec [1]
>=20
>   The host VMM can detect whether a virtual interrupt is pending delivery=
 to a
>   VCPU in the Virtual APIC page, using TDH.VP.RD to read the VCPU_STATE_D=
ETAILS
>   TDVPS field.
>  =20
>   The typical use case is when the guest TD VCPU indicates to the host VM=
M, using
>   TDG.VP.VMCALL, that it has no work to do and can be halted. The guest T=
D is
>   expected to pass an =E2=80=9Cinterrupt blocked=E2=80=9D flag. The guest=
 TD is expected to set
>   this flag to 0 if and only if RFLAGS.IF is 1 or the TDCALL instruction =
that
>   invokes TDG.VP.VMCALL immediately follows an STI instruction. If the =
=E2=80=9Cinterrupt
>   blocked=E2=80=9D flag is 0, the host VMM can determine whether to re-sc=
hedule the guest
>   TD VCPU based on VCPU_STATE_DETAILS.
>=20
> Isaku, this patch didn't read VCPU_STATE_DETAILS. Maybe you missed someth=
ing
> during rebase? Regarding buggy_hlt_workaround, do you aim to avoid readin=
g
> VCPU_STATE_DETAILS as much as possible (because reading it via SEAMCALL i=
s
> costly, ~3-4K cycles)?=20

*sigh*  Why only earth doesn't the TDX module simply compute VMXIP on TDVMC=
ALL?
It's literally one bit and one extra VMREAD.  There are plenty of register =
bits
available, and I highly doubt ~20 cycles in the TDVMCALL path will be notic=
eable,
let alone problematic.  Such functionality could even be added on top in a =
TDX
module update, and Intel could even bill it as a performance optimization.

Eating 4k cycles in the HLT path isn't the end of the world, but it's far f=
rom
optimal and it's just so incredibly wasteful.  I wouldn't be surprised if t=
he
latency is measurable for certain workloads, which will lead to guests usin=
g
idle=3Dpoll and/or other games being played in the guest.

And AFAICT, the TDX module doesn't support HLT passthrough, so fully dedica=
ted
CPUs can't even mitigate the pain that way.

Anyways, regarding the "workaround", my NAK stands.  It has bad tradeoffs o=
f its
own, e.g. will result in spurious wakeups, and can't possibly work for VMs =
with
passthrough devices.  Not to mention that the implementation has several ra=
ces
and false positives.

