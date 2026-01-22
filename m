Return-Path: <kvm+bounces-68934-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EHVQL3aWcmmSmwAAu9opvQ
	(envelope-from <kvm+bounces-68934-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 22:28:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A1EE6DC21
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 22:28:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 50F733038AE5
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 21:27:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 486A93C0879;
	Thu, 22 Jan 2026 21:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BCJ0AjLn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A918A3C0870
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 21:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769117217; cv=pass; b=PrDrOWbH7a6gNSAvFPmA9nNNwKbWRxsIY4xrxvw/ij984shEzmUacvBdmOHLxelsJ6ANQIRlXO5TvsvqRGI+4qWBplqFH9fHzLsT1+7GNsZ4f67bnFKhYK7tiI3Tg4ylguno9qYr7RnWeHeLnMxdYuUiwuWURciLQJ7PkyOEzDI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769117217; c=relaxed/simple;
	bh=BC8nFTG86vfd/JV3Ur3Vnv61JQ8TQGgb2hnHokTdwfs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cMcbDBF28+wkL61X3bAgJiKYk74VgYUx44t6PopWkLX5f+UzAHq7CofBJmIo+n/NBzYyzfjjy6KVGU6tpaeoU05MtdW/TbyKYIp+LFhxxNi7jh04FIYOatvxlEib3uTToxd6VDbTaZkt+rxtjRxBcnhTpI+UAiAMIL396K+MaLk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BCJ0AjLn; arc=pass smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-64baa44df99so3157a12.0
        for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 13:26:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769117205; cv=none;
        d=google.com; s=arc-20240605;
        b=MmZxI+StIctLURF0rq7CF2dhKNzUlaufHImPkMkO/ZEY9GoyKS0EGhyDOaTWcODuEr
         Ezf2xud+rstU3z3sR8Z+SYDnarors+Olpm8u+OJzAvG/AF/SISK5NCss9ZKRDmk/Ssu8
         lgLQcPCY1O1sFmt7/vfbIhv10cHGPce7sc3BD+3Vsk74kusbD9ho2zMwN6lAFx4QdLUe
         jmZluxrKokifVIWy6BgXR3lC+047QMxRVZTTiiewb8J00xC10HRedemwrwZD7zOb1WA9
         LscuxJgdBAMjNvUGwN+zJqZY2+KWkO5cOOnVXkxlTrcCVqPSgXm2bmRGaXDulAqHZZk9
         O66A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=e/+D/s4bwsqNNaSjIaXHNf2UcfLo5UUZymlR0tqKlbQ=;
        fh=RNX2nad/6Mm1xA8i3rmUeCLag6zJ0Ws5xmHdKiuKYv0=;
        b=BH2MSTnP2dNEoPD8wZ5S6/X3jBjndUhZBTeWGRS5wkXPYQpfdmhOxi1sygGHrpK/Pi
         yaruZQpLoodtq3idkV8Mg0AAU5thajz07jXvBSAmMBwiu82I3oIf1ly6cFfkrll+c9dP
         oQalb1zAeBAdEI0UAJXnOzfyaBuwaDVb4tVS9Z2IDMZ8Lq62ewhcD+6XnDEMHNFlsZDs
         hd/YxDJ+j+rI7UX34fzna2UcJG9PswsLtDOdO4GDr4ZniKFZ4A61csP7xISD9VLbeoLk
         FxryA9eFAWPE2k6M/mNCfbvLpz/cUJFrRjy9Khicl7V2vAasQTjaTRcHlOAsuRQjcQSB
         d06w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769117205; x=1769722005; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e/+D/s4bwsqNNaSjIaXHNf2UcfLo5UUZymlR0tqKlbQ=;
        b=BCJ0AjLn3+m4uTzW+3XHgZBfCM+s/Cdo4me9s8vFGRnzyWkS21yZBz2RJqPFJljAc1
         DXO93QcdFh7XW3k9p6DPz+k3W4qx5NNtpdU1arYFW6y/P+CtpRs2xsqezHnLtmYZ3RZi
         GmY9WLZdG8FSGvbnt6/kyEJNQbqpiuY+seIb2HpR53l9K9QjNAnt+PkmAUwWyQlf2A7J
         JytiEWoBrQqaQKpYS36u9WORYuP73TfbRczcUX4PPlPdQ+0zjTqpMA5JR4taiFYXk+x/
         atV0APikoAFqQhpWuaKgfp/f6Yj4iug6w0b2sKeKx5Uj3t8qtyzud4O71a/nchQcWdi7
         hsLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769117205; x=1769722005;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e/+D/s4bwsqNNaSjIaXHNf2UcfLo5UUZymlR0tqKlbQ=;
        b=Pf4IrXSr7NHKyh/1DhaP/8FbWY7mwEG7u55LueP3i56I3XNec9fCa+FXRqEpype8Rf
         WMEmkgRToG03+eybSycLIKRs0TO4kDf6K07cI5jpGoKQwrMHqNnWNbXR1JFAprwXAv3G
         DKUHLtZF5oW2IFT2tFg1cTvN+lTqfCwPxcH/3D66pfE0Eqr4oSpTFkTyJJJZdrQfnLEF
         iPNYdH+dYA8lNe3pQrqmg2sDQAaip5E0hIN4nAalfUL4fjlvsEbeKa1tssSpwsbtHDgQ
         x/a0O02zvPdmccXbQpIHkHhDzRtUdOA9l6Oj9wbK/jGBC5MfI4ecTO2V9B5tF/fTqtkh
         n/XA==
X-Forwarded-Encrypted: i=1; AJvYcCWAPSOLCzv4kaRUKJCOT9ehgc/xVEVIzn9ISigfcEgK15EszOTF63PwjMmd3psoAlLbTbY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFIZXfg7yEkSrpg5EZOpVZxnxjOfnSTpJd9W2RnqnLscuuTjaH
	aNX3v7Tas/ttDU/xvLrepDF24o9SXMCBdG7FUdjHlCPSrADCaGH7UROsnESO8Z/A6USXhB5mO2D
	wAQ0SrLSLCwkk1fZIBFk/BZE06ohiWkC/v7c1TsCT
X-Gm-Gg: AZuq6aI+OIX02AaZDzR+VeFxB69SfNfM7flRd0ABoXAL7v82IBWP6KxWXtE64Un+Y23
	N+gQ+ue1G/tovhfBtDrXkTYn5JBlir4hQ8vAtuHhzDszUDu8U46DUzwrvUDWiPw5W3WlQ7lXah0
	whh1DV6+TGleqmBWBxfOeD8uTIq01+y9qweXHerJ28IeV5kqx4+Usm20rCMVRNltx1XXbHiw69D
	GVkw8bSJTXu6KxuPPaQxD8T7ngtXTnXlqfc7lQSjOdeuCdN2nbEsSX8IoAd8tc3qXvAoJwWA6zZ
	sfmlMw==
X-Received: by 2002:aa7:c606:0:b0:658:e7a:6fa7 with SMTP id
 4fb4d7f45d1cf-6584bfcad65mr10888a12.4.1769117205288; Thu, 22 Jan 2026
 13:26:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260113225406.273373-1-jmattson@google.com> <aWbmXTJdZDO_tnvE@google.com>
 <CALMp9eTYakMk0Bogxa_GdGU5_h4PK-YOXcu-cSQ16m1QcusHxw@mail.gmail.com>
In-Reply-To: <CALMp9eTYakMk0Bogxa_GdGU5_h4PK-YOXcu-cSQ16m1QcusHxw@mail.gmail.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 22 Jan 2026 13:26:32 -0800
X-Gm-Features: AZwV_QhQTOem4BLVo53HKT58urNX60REF_SUeJPvF_yxD4XbcC-SDKdt9bRc4xc
Message-ID: <CALMp9eQx7EVim4iYGbAhoHrei2YmTra6oxtdmKaY7bw-M0PHbw@mail.gmail.com>
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
	TAGGED_FROM(0.00)[bounces-68934-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.998];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3A1EE6DC21
X-Rspamd-Action: no action

On Tue, Jan 13, 2026 at 7:47=E2=80=AFPM Jim Mattson <jmattson@google.com> w=
rote:
>
> On Tue, Jan 13, 2026 at 4:42=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Tue, Jan 13, 2026, Jim Mattson wrote:
> > > Add KVM_X86_QUIRK_VMCS12_FREEZE_IN_SMM to allow L1 to set
> > > IA32_DEBUGCTL.FREEZE_IN_SMM in vmcs12 when using nested VMX.  Prior t=
o
> > > commit 6b1dd26544d0 ("KVM: VMX: Preserve host's
> > > DEBUGCTLMSR_FREEZE_IN_SMM while running the guest"), L1 could set
> > > FREEZE_IN_SMM in vmcs12 to freeze PMCs during physical SMM coincident
> > > with L2's execution.  The quirk is enabled by default for backwards
> > > compatibility; userspace can disable it via KVM_CAP_DISABLE_QUIRKS2 i=
f
> > > consistency with WRMSR(IA32_DEBUGCTL) is desired.
> >
> > It's probably worth calling out that KVM will still drop FREEZE_IN_SMM =
in vmcs02
> >
> >         if (vmx->nested.nested_run_pending &&
> >             (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))=
 {
> >                 kvm_set_dr(vcpu, 7, vmcs12->guest_dr7);
> >                 vmx_guest_debugctl_write(vcpu, vmcs12->guest_ia32_debug=
ctl &
> >                                                vmx_get_supported_debugc=
tl(vcpu, false)); <=3D=3D=3D=3D
> >         } else {
> >                 kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
> >                 vmx_guest_debugctl_write(vcpu, vmx->nested.pre_vmenter_=
debugctl);
> >         }
> >
> > both from a correctness standpoint and so that users aren't mislead int=
o thinking
> > the quirk lets L1 control of FREEZE_IN_SMM while running L2.
>
> Yes, it's probably worth pointing out that the VM is now subject to
> the whims of the L0 administrators.
>
> While that makes some sense for the legacy vPMU, where KVM is just
> another client of host perf, perhaps the decision should be revisited
> in the case of the MPT vPMU, where KVM owns the PMU while the vCPU is
> in VMX non-root operation.
>
> > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > index 0521b55d47a5..bc8f0b3aa70b 100644
> > > --- a/arch/x86/kvm/vmx/nested.c
> > > +++ b/arch/x86/kvm/vmx/nested.c
> > > @@ -3298,10 +3298,24 @@ static int nested_vmx_check_guest_state(struc=
t kvm_vcpu *vcpu,
> > >       if (CC(vmcs12->guest_cr4 & X86_CR4_CET && !(vmcs12->guest_cr0 &=
 X86_CR0_WP)))
> > >               return -EINVAL;
> > >
> > > -     if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) =
&&
> > > -         (CC(!kvm_dr7_valid(vmcs12->guest_dr7)) ||
> > > -          CC(!vmx_is_valid_debugctl(vcpu, vmcs12->guest_ia32_debugct=
l, false))))
> > > -             return -EINVAL;
> > > +     if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) {
> > > +             u64 debugctl =3D vmcs12->guest_ia32_debugctl;
> > > +
> > > +             /*
> > > +              * FREEZE_IN_SMM is not virtualized, but allow L1 to se=
t it in
> > > +              * L2's DEBUGCTL under a quirk for backwards compatibil=
ity.
> > > +              * Prior to KVM taking ownership of the bit to ensure P=
MCs are
> > > +              * frozen during physical SMM, L1 could set FREEZE_IN_S=
MM in
> > > +              * vmcs12 to freeze PMCs during physical SMM coincident=
 with
> > > +              * L2's execution.
> > > +              */
> > > +             if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_VMCS12=
_FREEZE_IN_SMM))
> > > +                     debugctl &=3D ~DEBUGCTLMSR_FREEZE_IN_SMM;
> > > +
> > > +             if (CC(!kvm_dr7_valid(vmcs12->guest_dr7)) ||
> > > +                 CC(!vmx_is_valid_debugctl(vcpu, debugctl, false)))
> >
> > I'm mildly tempted to say we should quirk the entire consistency check =
instead of
> > limiting it to FREEZE_IN_SMM, purely so that we don't have to add yet a=
nother quirk
> > if a different setup breaks on a different bit.  I suppose we could lim=
it the quirk
> > to bits that could have been plausibly set in hardware, because otherwi=
se VM-Entry
> > using L2 would VM-Fail, but that's still quite a few bits.
> >
> > I'm definitely not opposed to a targeted quirk though.
>
> I have no preference.
>
Sean -

Would you like me to post a v2?

