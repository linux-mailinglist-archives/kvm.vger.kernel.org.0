Return-Path: <kvm+bounces-70291-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MATrF8kYhGk1ywMAu9opvQ
	(envelope-from <kvm+bounces-70291-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 05:12:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B7F55EE772
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 05:12:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 41891301B71B
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 04:12:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31F272E8B97;
	Thu,  5 Feb 2026 04:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VR935B40"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F1D286430
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 04:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770264732; cv=pass; b=iWztX4EOa8nGr/2V7XtFhM0L9eOm2h7JF+KL8uWSkE0xigk4fsapkamq8cMDcMnz9GHLFdd0eQluz0Kr3vutXB8Wfu2TNC35FPaqO3QvPh7gp/0wF3aKJawLil+kglax38S90nNG/hL2HAS9WK7RveMbNunmSb0MN9DOSp3LDb4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770264732; c=relaxed/simple;
	bh=iHv3eVZ4uKQEnCsixa8y4B/vLhRYUmz/8FIeHb+C3QU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cUmYTVE0SbDN6DKHN9KG2bfrMrEqln07uSiiBQLvZTcxD7OxaxmhZF2V7jItAPdjIdtBlSGgIqsg9zR1kLrVMxO7CWwLY9YE1Pb7wnwAhpTCcbq5kWun3cbdE8tdUrH42vJHsOrUYcovMDL1Ge2GIPA0BaiV6DF6yUN4pKvQDKg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VR935B40; arc=pass smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6581551aa88so3716a12.0
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 20:12:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770264730; cv=none;
        d=google.com; s=arc-20240605;
        b=jG2neZXSkRccR0Au57GyaGOZgKPCRx3WLEMrXJFC02UzHCFU+mgW31Ap7HX/ibGbEq
         D4cr/x/RR1w4MXDDquA9bwZBtcjJovJzqbsbnbAb2ZOd1/ETEAUGR8qLLdtmSG3yTt0A
         UQL/b2BgoiplTTxM5AF0XaRnLoIyAdRX38SOA8trT7VFbYRwz4h/xyIHEM3Js92Ajx7s
         ZPZKiDBCmwaVPruXh5N60mwM9iFuUvLquZtmFLIQjNvL/V0a6AVxij1xayfQx6C/32ue
         GJC00ZFdfQ0ozkfI7/5ja+mK/zq5qnm5BgQk5KU+JNye3Y87DJQCQnVuymmgdcBaQJ7H
         YSEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ICuQy7A+pz8n4uIx9cAJ+hnxhishMNCKfdmmi6Or3XQ=;
        fh=ekYukuQwRS2FP1SNe4D/VCv4CYW45mU0QXXcxBTtMUo=;
        b=C5s/jT+HR/asvPDLJUAcAcIeIMJMi6ly2lxXkuOY6tcuI/yI0Mnc6zIc/IsyKmsGn/
         XShKtiKyt22PbLzcA+/AnDvugDmKSFlAkM9m8f38gwyDTOFPgo0wQBYEC8NWUJyQBCNn
         Dxv+BzAb6H3161915YEHSvJqHaHSkkEbuwcjqMVMwCV6cA3Ptv8W8thrcuFvR+zsIxrp
         rGw3lAee5bTyzkYyA9ufnVltTmbACnmQJXBqFCx1DDkXGicMKXgj71Fhk63UM0L44bh/
         jFcGggYp5LOEc9z+tADFZqwkz13qzacimVxJr+WQ33O50H3fQ/IBs6TgvrD1WLVMklfp
         9vEQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770264730; x=1770869530; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ICuQy7A+pz8n4uIx9cAJ+hnxhishMNCKfdmmi6Or3XQ=;
        b=VR935B40t49/OEw8tjlQgRRex6rXoo9ezw1nnj4BbNEkaCLca27lWZwfOs6pwRd8Pb
         evki0mBw9+1RoZdsoNCTITCCV0v/XRrtdl7ipL/guJGBjVu1w3tJ1Pjzws7ClgT6/wJQ
         TmM/x8DjG4htW3DKcXjz04HMw8ZuNgIASrCeaXuTUbrMgqsonCxtUvBqItRH8kpQffyz
         n+bSA6IIgSZ2TOJUzGAHNt0mME9iY0G6FkusW+dwli7R10vu4WO1/Cw4XSywy1d1Wx1D
         JU92TOkQ5/0gEET8SUAdR/6HfYmN6qPH3iDtnWKZj7iuRQUeWhtVt48uL4wM6KckkQk/
         HTVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770264730; x=1770869530;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ICuQy7A+pz8n4uIx9cAJ+hnxhishMNCKfdmmi6Or3XQ=;
        b=seMgGVSrkrbOiUM2fcEYnva3EG9CD+tfJ4Ll4xC1WT7dN5Fncd1UoqMX09guOIrtBA
         /ATknVDnIYQvsP5UQMaoM5GB7JM53mrA2kjKIFM9hfNk3MvNzwc26hsoPiEgitT5etk3
         9Cqq6dtfPhIJgC5dATnpVyPu8/it/bBwRcWWsyqlJc1zfqzuDfwcgHBu8wO7RRRKxfxw
         7VX+3f28lQ7oBP+uZYPuM5v0cEgq8soOBhTLwNgC91IfEg8BOrsCnBwTb1C6X7hV+Vzc
         jyBQhWpiSLgsQ/7ELox4Qk/OTwTqi7FqIFHkPXIGOB7M09sfFbOfEtnzVT8n60hSv+NL
         Zh1A==
X-Forwarded-Encrypted: i=1; AJvYcCUMFaA5CTQho+0t5uEaUn6iypIVrpgq0vR0NtnGMOffFpQJlNlMtj4gadBEzRnIZ52gSCU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7XWQybUvhcEzL5/QSW58LFdqAvjndTjdVljZBCgWo7RMosAlx
	XOhCN8IqdnDbr8CfvOHzSOyKkmNaa3w61VJhR3e1vJQqs9mJTgb5J5CKVtgeznKApLSPDykp+qf
	LLelKG5uRABaEeFGcqWEvExk/38kxvUsvjf4x6wIy
X-Gm-Gg: AZuq6aKYFnxZ0GPATZkLI0XosT2wcZZ3kL1/m9/Dw1Q4O6SPfBISShIeyTLl5JbIywE
	VxT9XXncyDag3b98OoIJPwIXpzviukGtQxKuVMJS0hD9wTvVvhQkK/luewuyeEYRnUjLYOAgkBf
	cnah6FM01K8YmN3t2XKQy9mk+2riILvijB97vtRu9W1N7ZQijPB5Bp2OE4RgnsIwvkjs+Ry8Snm
	qrcmVPJYFOJE7fwJv9kDry+30XaT3ugdOqcGhguJLJUMstCzEXOcS6dpHtX02SGqO1jK2M=
X-Received: by 2002:a50:fb99:0:b0:649:8aa1:e524 with SMTP id
 4fb4d7f45d1cf-65965ebe482mr10226a12.11.1770264730115; Wed, 04 Feb 2026
 20:12:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260113225406.273373-1-jmattson@google.com> <aWbmXTJdZDO_tnvE@google.com>
 <CALMp9eTYakMk0Bogxa_GdGU5_h4PK-YOXcu-cSQ16m1QcusHxw@mail.gmail.com>
 <CALMp9eQx7EVim4iYGbAhoHrei2YmTra6oxtdmKaY7bw-M0PHbw@mail.gmail.com>
 <aYKoJ74MWboBuE_M@google.com> <CALMp9eSc=0zS+6Rk-c_0P-Q1Y8_9Xv58G5BYxieKpv_XaSj0wg@mail.gmail.com>
 <aYPvyMDipM9Z9Z7t@google.com>
In-Reply-To: <aYPvyMDipM9Z9Z7t@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Wed, 4 Feb 2026 20:11:57 -0800
X-Gm-Features: AZwV_Qhrwh_pA1gXlaRFSMVmwpj18Td64_tdGrDJiNzY-mtZF0eo8OUjw8uOEFA
Message-ID: <CALMp9eR4trBDwgDnyEJmrHnStKnAMiRgehty=xu=NMnLVN2vtw@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Add quirk to allow L1 to set FREEZE_IN_SMM in vmcs12
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70291-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: B7F55EE772
X-Rspamd-Action: no action

On Wed, Feb 4, 2026 at 5:18=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Wed, Feb 04, 2026, Jim Mattson wrote:
> > On Tue, Feb 3, 2026 at 6:00=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > >
> > > On Thu, Jan 22, 2026, Jim Mattson wrote:
> > > > On Tue, Jan 13, 2026 at 7:47=E2=80=AFPM Jim Mattson <jmattson@googl=
e.com> wrote:
> > > > > On Tue, Jan 13, 2026 at 4:42=E2=80=AFPM Sean Christopherson <sean=
jc@google.com> wrote:
> > > > > >
> > > > > > On Tue, Jan 13, 2026, Jim Mattson wrote:
> > > > > > > Add KVM_X86_QUIRK_VMCS12_FREEZE_IN_SMM to allow L1 to set
> > > > > > > IA32_DEBUGCTL.FREEZE_IN_SMM in vmcs12 when using nested VMX. =
 Prior to
> > > > > > > commit 6b1dd26544d0 ("KVM: VMX: Preserve host's
> > > > > > > DEBUGCTLMSR_FREEZE_IN_SMM while running the guest"), L1 could=
 set
> > > > > > > FREEZE_IN_SMM in vmcs12 to freeze PMCs during physical SMM co=
incident
> > > > > > > with L2's execution.  The quirk is enabled by default for bac=
kwards
> > > > > > > compatibility; userspace can disable it via KVM_CAP_DISABLE_Q=
UIRKS2 if
> > > > > > > consistency with WRMSR(IA32_DEBUGCTL) is desired.
> > > > > >
> > > > > > It's probably worth calling out that KVM will still drop FREEZE=
_IN_SMM in vmcs02
> > > > > >
> > > > > >         if (vmx->nested.nested_run_pending &&
> > > > > >             (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CO=
NTROLS)) {
> > > > > >                 kvm_set_dr(vcpu, 7, vmcs12->guest_dr7);
> > > > > >                 vmx_guest_debugctl_write(vcpu, vmcs12->guest_ia=
32_debugctl &
> > > > > >                                                vmx_get_supporte=
d_debugctl(vcpu, false)); <=3D=3D=3D=3D
> > > > > >         } else {
> > > > > >                 kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
> > > > > >                 vmx_guest_debugctl_write(vcpu, vmx->nested.pre_=
vmenter_debugctl);
> > > > > >         }
> > > > > >
> > > > > > both from a correctness standpoint and so that users aren't mis=
lead into thinking
> > > > > > the quirk lets L1 control of FREEZE_IN_SMM while running L2.
> > > > >
> > > > > Yes, it's probably worth pointing out that the VM is now subject =
to
> > > > > the whims of the L0 administrators.
> > > > >
> > > > > While that makes some sense for the legacy vPMU, where KVM is jus=
t
> > > > > another client of host perf, perhaps the decision should be revis=
ited
> > > > > in the case of the MPT vPMU, where KVM owns the PMU while the vCP=
U is
> > > > > in VMX non-root operation.
> > >
> > > Eh, running guests with FREEZE_IN_SMM=3D0 seems absolutely crazy from=
 a security
> > > perspective.  If an admin wants to disable FREEZE_IN_SMM, they get to=
 keep the
> > > pieces.  And KVM definitely isn't going to override the admin, e.g. t=
o allow the
> > > guest to profile host SMM.
> >
> > I'm not sure what you mean by "they get to keep the pieces." What is
> > the security problem with allowing L1 to freeze *guest-owned* PMCs
> > during SMM?
>
> To give L1 the option to freeze PMCs, KVM would also need to give L1 the =
option
> to *not* freeze PMCs.  At that point, the guest can use its PMCs to profi=
le host
> SMM code.  Maybe even leverage a PMI to attack a poorly written SMM handl=
er.

Perhaps I'm missing something. I was thinking, essentially, of a logical or=
:

vmcs02.debugctl.freeze_in_smm =3D vmcs12.debugctl.freeze_in_smm |
vmcs01.debugctl.freeze_in_smm

So, an L1 request to freeze counters in SMM would be granted, but an
L1 request to *not* freeze counters could be overruled by the host.

I'm not suggesting this in the context of the legacy vPMU, because
some PMCs may be counting host-initiated perf events, and L1 should
not have any say in what those PMCs count. However, with the mediated
vPMU, L1 owns the entire PMU while L2 is running, so it seems
reasonable to allow it to freeze the counters during physical SMM.

> In other words, unless I'm missing something, the only reasonable option =
is to
> run the guest with FREEZE_IN_SMM=3D1, which means ignoring the guest's wi=
shes.
> Or I guess another way to look at it: you can have any color car you want=
, as
> long as it's black :-)

I would be happy with FREEZE_IN_SMM=3D1. I'm not happy with the host
dictating FREEZE_IN_SMM=3D0.

