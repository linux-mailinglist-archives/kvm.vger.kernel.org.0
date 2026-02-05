Return-Path: <kvm+bounces-70276-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oJO6B3/ng2n+vQMAu9opvQ
	(envelope-from <kvm+bounces-70276-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 01:42:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C8847ED778
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 01:42:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EE93A30182BB
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 00:42:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D1951FC0FC;
	Thu,  5 Feb 2026 00:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wZEriRCj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49B21E9B3D
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 00:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770252147; cv=pass; b=p2LgZz1ld1Ime697uR4pYS/7Gwo6u38gxjSDLJgCJ0X5ZwzNsqXcCrS251dFIM2He1XSgQXNvSx0xiDp/ncZJlo2C/i99cmvBNvgPtneXe4rywcOAGZjkRNWzvN9UNpcTc3THNv/40TS6bIBFASWFGZVizmZKpBYfTzCcTbClQY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770252147; c=relaxed/simple;
	bh=Ow7r61Ujx6Fwtsev9bVFnpw1yXZnUtB5DPBVgBvAnEE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pt37OfD8L5l9yMKBwvPqgAIWGCWqD8O3eyx+7aMg4byjZvxJsc7nZPgAWaxMI2kSRVn3MUtgK5VcpusY/uui8TdRlzhQLlpKoYrC8QQwqxlk3nfLUZx0QSxTWoVhiS3zmlsnLFnQYfYxmKhj07v6tXuX+6/HIYe5xbV+8Xpddks=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wZEriRCj; arc=pass smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-65821afe680so2420a12.1
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 16:42:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770252145; cv=none;
        d=google.com; s=arc-20240605;
        b=C46kwEXl20/PioMxFVrVLbkupTd2FxOcpjik/De3ca8SaXrAnHWMH3XDy6MK/w6ojn
         yYk9PdXBDOEXtrIT+SWUBKsULfp1u3FlGBZKMXhw3Jewxvaqd5zpFg/CAuVuDEyL43Ey
         JpluesVUE6Bymd3CxavlAtnszAMdzbueXSXNshescfqFY5MNqqpU3CMwKi+22l/WfdUA
         fqn6cAe+iBHZh9HPvedaW3VWp9MVhCGF89N1jqRcDgq1BRJl0efxIYlI6+MNhk/tUEN1
         XSq5IIcttLUMGtbHU2LE8Sa20qJWZXzJCbOODZA8PqHqC9YuwzU6XkWgpE+RM76jrAZL
         gzZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VlDrMcmalHLovHdz8eEZBmrC943QEAplMoC4h6ttO+8=;
        fh=8GSXKf4E9OxKdDDJWopB/OQoEeuiboFydDlN+zNkeCo=;
        b=SYf1Cfqj7cORp10OCUhnWz7yh0eX8xTVkzhxLti+lQkmGZlS9Z5kjREGtcFCkP/EGu
         CkgHLFHlcbl9q1NFkhG5dnqYVcjT10ZBd7i7Ta5FpaneA2z6PJrQvqZbZjP7yStsbc73
         ZREnDPfnpM1yYzpczLyMmapJt7Iohu268sK9Wo8Sa0aliz6ScYxwP2pOAMk3IGAZEPFM
         la3MtbGCNH4xl7suj5ArTSZTY5DdpRfHKktRAvSQ5QDwKnQi3kohJqJ9lAtkQ8OB404W
         JsPplO5CJX/aXNQMltMDtwPSu+soQufMSe3xd29wz12dL0HTi25HooAWvrt6latB2qax
         TgeQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770252145; x=1770856945; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VlDrMcmalHLovHdz8eEZBmrC943QEAplMoC4h6ttO+8=;
        b=wZEriRCjDzYAfqVgNYog+pKLyAT6ZsKdSxkkzrciJH51y2oQUal0uzZs8GEjzO0TJ/
         bPSN0Hfar6apX5DKOrcvPdXq/XBhapoqDE0Tdo8xdhEhBfNBlUMLzK+gwAGyRhNhrPWM
         YjKaJieHX0qjSz+yeARUB20l+0XtHqtFloEkK+jW5Bug4hYZ0WRl8jYAyEQQef5hAhvG
         BT1TFlW06bSbGUecIgiozyyodCu6xw0rP4yeTcmbQIH5KyRQcxVoBVSC2hoMouwDMA8e
         TMqcFt3Oaf1q5MaEKKpzRloTrzhh/mHw6TVj0lRmh01BuEMZ59Av3duQ4mcCG0VZhGyM
         bwDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770252145; x=1770856945;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VlDrMcmalHLovHdz8eEZBmrC943QEAplMoC4h6ttO+8=;
        b=KEnHLiniwaO7p3ayq70hmN1indla/FIGlSoiO0oSp5G5aIk5gLR8iuNtEcqPizD/CK
         3HuVRjKACNeD6b4HiV90rtoeqf7RH45JamM2bRz9t0XWujBGaNSqAwScnWWJ3FgB5GDO
         H3jsTtfluPmKm9A4WrXB+g8coN7w5Sk+csnzMwZwUPAIY4FJPKM4YbUXPX3bwEkoZFts
         ulWNpUe2ZwhBBICaSBecUkCM0PN5qx6lDE+dW3IZYP2u3tJ5vHRJufojxubfAE388DdZ
         sACAt3OoyitHPurlYEBHhOnPd4Gz1Uw0E0r8tOpC/RrGY68Twqm1Je8UH0PJvotNFU7h
         q5Jg==
X-Forwarded-Encrypted: i=1; AJvYcCURb+Q49fVrKt2GIb5zJVl5hYmS7T4W+WF4VK0b1OLppvqSATjFj9DMX7pcV/6F2MCXmg0=@vger.kernel.org
X-Gm-Message-State: AOJu0YydqmMN7w+/gz2jiMNEdUW17DeSv21DmtikTx7YELlXD9Z/cQHp
	m0dMiGER1mZpeH/8d4luu88OjKETFEC7TFMlBRkVrehj6MeyrWOzqU9xnK4ZFbqAW+qU4vMlt6v
	zs/ARDJE+uCRG5XM/WhbDrLEsuEZaKPgDNgxJ+EcU
X-Gm-Gg: AZuq6aL2Ppf+QsF7Q4nPkl50aBwdgEcPRbRnrR0wB6akybOh/Nl83IptQ1+CLzak1Xk
	pHErRMtQY0fS+vv2FOnvZPas4YqAv/V8yk4zzJ+wXRlr5/qGl/KFKFKx3waWEr/pjLgYyLy+AOc
	rJDw/0ZrDoIjSWXLY75jG1tAHFd4/DEEy+pUURMVqn12tphTftDLrNEpH1e/zGbPOLI8kp6H3Ml
	USEHuBhcDg92xeXPMW/L+C91B5Dlse1UjZgXPIu6cf6Xyq2ydF8Yks0zGEYrAVTSMOjd7E=
X-Received: by 2002:aa7:da0d:0:b0:649:69e6:cd4d with SMTP id
 4fb4d7f45d1cf-65965ebacd3mr5686a12.11.1770252144864; Wed, 04 Feb 2026
 16:42:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260113225406.273373-1-jmattson@google.com> <aWbmXTJdZDO_tnvE@google.com>
 <CALMp9eTYakMk0Bogxa_GdGU5_h4PK-YOXcu-cSQ16m1QcusHxw@mail.gmail.com>
 <CALMp9eQx7EVim4iYGbAhoHrei2YmTra6oxtdmKaY7bw-M0PHbw@mail.gmail.com> <aYKoJ74MWboBuE_M@google.com>
In-Reply-To: <aYKoJ74MWboBuE_M@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Wed, 4 Feb 2026 16:42:12 -0800
X-Gm-Features: AZwV_QhLA8eJsXkrtDZzOLlw96qtQQW2WL1CaWfZKw649MsGypEsGWxa5AFa2fo
Message-ID: <CALMp9eSc=0zS+6Rk-c_0P-Q1Y8_9Xv58G5BYxieKpv_XaSj0wg@mail.gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70276-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: C8847ED778
X-Rspamd-Action: no action

On Tue, Feb 3, 2026 at 6:00=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Thu, Jan 22, 2026, Jim Mattson wrote:
> > On Tue, Jan 13, 2026 at 7:47=E2=80=AFPM Jim Mattson <jmattson@google.co=
m> wrote:
> > > On Tue, Jan 13, 2026 at 4:42=E2=80=AFPM Sean Christopherson <seanjc@g=
oogle.com> wrote:
> > > >
> > > > On Tue, Jan 13, 2026, Jim Mattson wrote:
> > > > > Add KVM_X86_QUIRK_VMCS12_FREEZE_IN_SMM to allow L1 to set
> > > > > IA32_DEBUGCTL.FREEZE_IN_SMM in vmcs12 when using nested VMX.  Pri=
or to
> > > > > commit 6b1dd26544d0 ("KVM: VMX: Preserve host's
> > > > > DEBUGCTLMSR_FREEZE_IN_SMM while running the guest"), L1 could set
> > > > > FREEZE_IN_SMM in vmcs12 to freeze PMCs during physical SMM coinci=
dent
> > > > > with L2's execution.  The quirk is enabled by default for backwar=
ds
> > > > > compatibility; userspace can disable it via KVM_CAP_DISABLE_QUIRK=
S2 if
> > > > > consistency with WRMSR(IA32_DEBUGCTL) is desired.
> > > >
> > > > It's probably worth calling out that KVM will still drop FREEZE_IN_=
SMM in vmcs02
> > > >
> > > >         if (vmx->nested.nested_run_pending &&
> > > >             (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTRO=
LS)) {
> > > >                 kvm_set_dr(vcpu, 7, vmcs12->guest_dr7);
> > > >                 vmx_guest_debugctl_write(vcpu, vmcs12->guest_ia32_d=
ebugctl &
> > > >                                                vmx_get_supported_de=
bugctl(vcpu, false)); <=3D=3D=3D=3D
> > > >         } else {
> > > >                 kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
> > > >                 vmx_guest_debugctl_write(vcpu, vmx->nested.pre_vmen=
ter_debugctl);
> > > >         }
> > > >
> > > > both from a correctness standpoint and so that users aren't mislead=
 into thinking
> > > > the quirk lets L1 control of FREEZE_IN_SMM while running L2.
> > >
> > > Yes, it's probably worth pointing out that the VM is now subject to
> > > the whims of the L0 administrators.
> > >
> > > While that makes some sense for the legacy vPMU, where KVM is just
> > > another client of host perf, perhaps the decision should be revisited
> > > in the case of the MPT vPMU, where KVM owns the PMU while the vCPU is
> > > in VMX non-root operation.
>
> Eh, running guests with FREEZE_IN_SMM=3D0 seems absolutely crazy from a s=
ecurity
> perspective.  If an admin wants to disable FREEZE_IN_SMM, they get to kee=
p the
> pieces.  And KVM definitely isn't going to override the admin, e.g. to al=
low the
> guest to profile host SMM.

I'm not sure what you mean by "they get to keep the pieces." What is
the security problem with allowing L1 to freeze *guest-owned* PMCs
during SMM?

> > > > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.=
c
> > > > > index 0521b55d47a5..bc8f0b3aa70b 100644
> > > > > --- a/arch/x86/kvm/vmx/nested.c
> > > > > +++ b/arch/x86/kvm/vmx/nested.c
> > > > > @@ -3298,10 +3298,24 @@ static int nested_vmx_check_guest_state(s=
truct kvm_vcpu *vcpu,
> > > > >       if (CC(vmcs12->guest_cr4 & X86_CR4_CET && !(vmcs12->guest_c=
r0 & X86_CR0_WP)))
> > > > >               return -EINVAL;
> > > > >
> > > > > -     if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTRO=
LS) &&
> > > > > -         (CC(!kvm_dr7_valid(vmcs12->guest_dr7)) ||
> > > > > -          CC(!vmx_is_valid_debugctl(vcpu, vmcs12->guest_ia32_deb=
ugctl, false))))
> > > > > -             return -EINVAL;
> > > > > +     if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROL=
S) {
> > > > > +             u64 debugctl =3D vmcs12->guest_ia32_debugctl;
> > > > > +
> > > > > +             /*
> > > > > +              * FREEZE_IN_SMM is not virtualized, but allow L1 t=
o set it in
> > > > > +              * L2's DEBUGCTL under a quirk for backwards compat=
ibility.
> > > > > +              * Prior to KVM taking ownership of the bit to ensu=
re PMCs are
> > > > > +              * frozen during physical SMM, L1 could set FREEZE_=
IN_SMM in
> > > > > +              * vmcs12 to freeze PMCs during physical SMM coinci=
dent with
> > > > > +              * L2's execution.
> > > > > +              */
> > > > > +             if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_VM=
CS12_FREEZE_IN_SMM))
> > > > > +                     debugctl &=3D ~DEBUGCTLMSR_FREEZE_IN_SMM;
> > > > > +
> > > > > +             if (CC(!kvm_dr7_valid(vmcs12->guest_dr7)) ||
> > > > > +                 CC(!vmx_is_valid_debugctl(vcpu, debugctl, false=
)))
> > > >
> > > > I'm mildly tempted to say we should quirk the entire consistency ch=
eck instead of
> > > > limiting it to FREEZE_IN_SMM, purely so that we don't have to add y=
et another quirk
> > > > if a different setup breaks on a different bit.  I suppose we could=
 limit the quirk
> > > > to bits that could have been plausibly set in hardware, because oth=
erwise VM-Entry
> > > > using L2 would VM-Fail, but that's still quite a few bits.
> > > >
> > > > I'm definitely not opposed to a targeted quirk though.
> > >
> > > I have no preference.
>
> After mulling over the options from time to time, I think our best be is =
to quirk
> only FREEZE_IN_SMM, but very explicity scope the quirk to just the consis=
tency
> check.  E.g. maybe KVM_X86_QUIRK_VMCS12_FREEZE_IN_SMM_CC?  That should he=
lp alert
> readers to the fact that the quirk bypasses the check, but L2 will still =
see
> FREEZE_IN_SMM=3D0 (e.g. in the unlikely scenario L1 disables interception=
 of
> DEBUGCTL).
>
> As for why just FREEZE_IN_SMM, in addition to the fact that FREEZE_IN_SMM=
 is the
> only bit that broke anyone (as far as we know, /knock wood), it's also th=
e only
> bit that is host-owned.  I.e. unless the host admin likes SMM mucking wit=
h things,
> skipping the consistency check isn't terrible from a functionality perspe=
ctive
> (KVM doesn't honor the bit for emulated SMM, but that's QEMU's problem :-=
D).
>
> > Would you like me to post a v2?
>
> Yes please.

