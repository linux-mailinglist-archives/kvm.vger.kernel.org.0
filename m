Return-Path: <kvm+bounces-70358-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ODZiDNDWhGlo5gMAu9opvQ
	(envelope-from <kvm+bounces-70358-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 18:43:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A30DDF619E
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 18:43:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BB379302E843
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 17:43:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B9EF2FD7C6;
	Thu,  5 Feb 2026 17:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V2FYhWU+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CDB2F7462
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 17:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770313396; cv=pass; b=fJIETP/ukpJhPUgsZyhF6MM8E0sZ+GQI9pDYzxc4/g+LHv/e4GYi/T7TbXsNOz8j1M4nUt0mRUwgKgRjnib9WMTa+sc1cydEe8DzSFl46hF68PlbLGuy6E2IvSZ+5L6DYy9eiQkDq0yT4F5m0854Yxx5AP64YmgD+XIQhGq4Ie0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770313396; c=relaxed/simple;
	bh=W7PKbjr3sm8K2EitecNIWP8s6CcOSoC5YBXcikD3Z/Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e98xa9XHFiwPsAW2deCSVJxn5DIgo/NqIZiSgDEaRG7A9V0dWYpUj0VVw4t+mR9n6J62P0XBjFzb7ksLE2ubCtJasr8t8awmqSpMyUz+8Nh3/jbO52rL5/ku0KXlnC6q+73RDrtjCrlv/7Z3/D1KRAHzvrSPmG8n3NYEKk9ZcTo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V2FYhWU+; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-65821afe680so43a12.1
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 09:43:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770313394; cv=none;
        d=google.com; s=arc-20240605;
        b=OuhFeEOvzseuEXNJl5q7HgSf9fZyjuudnQXFYq2o9B1UjGTzLidPzAQZq/axlV03wo
         JCXDpknN5lgrvd01VaAh0HfX90bUZxPM9QqCv8TfwORKCWTkC4EGrLahzlZcCszUGdWB
         3iSkUDcRC9uqE5fiMwrIfsUXNkRrytcK7TfAmNbFStH/sS07pbMiNvbbSdxu70hF9acz
         pszH9Wb5sFhznsmK3gL4Px2IrO5HSEvYA0Va+J0PDzIxTCvzULvLJ6TvF/NIAgLfZt4k
         G/sGMQTGpDhfqzIKjL/c9TnUY5FnoFqR3nay1o24jqgWOPp4Q49wHmGrvcHaLQ6DRkmz
         7bIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ohb+oFC1mbgPld1c1rVcaRxKKHn/WerjH5KdHZYbAwI=;
        fh=s7ZCFhx8LKH/zYyU/kUe2gd0Fl4XqkRjWYkiHEOBeLs=;
        b=hXVbRyLDPVQBryVZ6RxM2LG9GdNlewVMLt02ZRAR8aGv1rU/28NU8lsIAYIHFNl5Fa
         DC8lPtxQB1ux3QgUEhMDrFA7COMnq/QA1fMbgX4GCJgQsBjNaJisRBhIq5PawGmEFx+T
         Ofra1VIX9zIwgS4kroRvlyVA/NKUTrRO/GmaOe9buxNFY4BCvX1dw7PgvN7HVR8F6WaA
         tPC1kRh4QLkXgahxFP/UOuFDbWzYc/YrYDDDhFXLW//uuHo/BG+jYV2QP3r8paK7cJBL
         s8bQF4R65o6hwix/+EJALqOe3qFrJbnGdKNijvEVLaQf2Kum+VNQKnamab7Rbqr01tQ1
         dlXA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770313394; x=1770918194; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ohb+oFC1mbgPld1c1rVcaRxKKHn/WerjH5KdHZYbAwI=;
        b=V2FYhWU+rADJOagkSqGOfUO2E/edQ5pK5MwLldb/dwq0aYYjhH+bxdkeDpZ6wVTqwL
         mpheB+FvdGksnuqEExz5VMH/44FpxwKozpxXEnlp3rQpJNKV82pzOApOuxDt/3Tdiciq
         q7k+YjE8ob5I5QDSN7GQFw4aXJ5GvgbucTZqpVntQApTDavxQaladE9pkIuYBjS/X0vo
         6pvXprPeZ+IE1qdJi8cMrHkk9oJoXTXBNYTRVUc6KM1Z/J9ou3yrcgYzkUxzeHoNKPZJ
         euxdXOo2whLQXsP4F43tDcqcvJxApWjdf/2roJc5d9YSorHIU0wEH459fqDV5goXCPj7
         3qSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770313394; x=1770918194;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ohb+oFC1mbgPld1c1rVcaRxKKHn/WerjH5KdHZYbAwI=;
        b=PGCQlcBvAPkF/QRgx4HHrtFwewmJ/40YhnUPCMOGEe2SHYuMcb+652AFBKQAXzuqLM
         U25dTuCcojnkX+4W80xeTRZpQoiVJjiBmBZubeFd1O8GSk799LP2XvL9iF/Uzys1OPZH
         ISekjAqjCPLl0SNLPUgdMrkTP4iDZPAnWiWSihOoUAJimtqYSQ2OE1vj6CtecO0A3+0Y
         5HcmcR4fb5nYN+ns3EJWca+XFHSCkwKigABdD7ki2GT/1qbm7xgH8b+fvEar0i76lIxn
         bnClSXGfV3PoWddWCGxPvBVzNdC6JQ2Qg3LKyAvGH1ZzpVEhyYZlziWHmWIoBNoxImF9
         Pdgg==
X-Forwarded-Encrypted: i=1; AJvYcCXsybYjYxGuxqfrm3DaZzG4s0qhmheb6t5xoqony1CVQtRtg4HELttcUx6DgCQQjA4z7hQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2ZlWcshl0BhkUxTmqAA5drqU3qJHLh1abeYZ10wchtbkL6cON
	VqRgn+6oNNhwdftY3m8vB45K1lQepa81+FksjyvLwgGdTfLDokMRyJuj8ig8sWOM5UjuC0mmHC6
	4lS4iQbzGaAF560CL7wGYHAsY6i18rM29MhTUDGk5
X-Gm-Gg: AZuq6aIEGcD865JLWyMNWE5v7uX9/MpGRs8TLpSkFxoFUZW8+iHfM9iZp0jIceRXoTe
	IXjByhg4WsVFb3YAEu/h/j+SWLsXpxX9TW5VRSVHpyzLZFkaxyVNMpGVTvcdCSYu8cZKHNbQf1P
	Jax1U6kmXHPc6F9LeSS9EPGQbo/Fe4/RYMmISufQIvg8nZ3xF9FxpbqfP5s4AFvKYWNOdZsXvZw
	evps6HyouSpb3kbRRM7hIAGdQGkcDS0ob9ZTkfrJg7kMYqdbSvixQpnJrmocxwlaq11Xqo=
X-Received: by 2002:a05:6402:510f:b0:64b:560e:41e2 with SMTP id
 4fb4d7f45d1cf-659634ab258mr56359a12.6.1770313394070; Thu, 05 Feb 2026
 09:43:14 -0800 (PST)
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
 <aYPvyMDipM9Z9Z7t@google.com> <CALMp9eR4trBDwgDnyEJmrHnStKnAMiRgehty=xu=NMnLVN2vtw@mail.gmail.com>
 <aYStVN5MyME-Pkwt@google.com>
In-Reply-To: <aYStVN5MyME-Pkwt@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 5 Feb 2026 09:43:01 -0800
X-Gm-Features: AZwV_Qigg_-JCEjJmebwjFdGWMLQ6vwSO12veSukovsezN310bnQnkd0-q3_c9M
Message-ID: <CALMp9eT_uJZwO5AF-wWHFH1DnOKWjUtU2u9TCOs7=ZK8_xCx+w@mail.gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70358-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A30DDF619E
X-Rspamd-Action: no action

On Thu, Feb 5, 2026 at 6:47=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Wed, Feb 04, 2026, Jim Mattson wrote:
> > On Wed, Feb 4, 2026 at 5:18=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > >
> > > On Wed, Feb 04, 2026, Jim Mattson wrote:
> > > > On Tue, Feb 3, 2026 at 6:00=E2=80=AFPM Sean Christopherson <seanjc@=
google.com> wrote:
> > > > >
> > > > > On Thu, Jan 22, 2026, Jim Mattson wrote:
> > > > > > On Tue, Jan 13, 2026 at 7:47=E2=80=AFPM Jim Mattson <jmattson@g=
oogle.com> wrote:
> > > > > > > On Tue, Jan 13, 2026 at 4:42=E2=80=AFPM Sean Christopherson <=
seanjc@google.com> wrote:
> > > > > > > >
> > > > > > > > On Tue, Jan 13, 2026, Jim Mattson wrote:
> > > > > > > > > Add KVM_X86_QUIRK_VMCS12_FREEZE_IN_SMM to allow L1 to set
> > > > > > > > > IA32_DEBUGCTL.FREEZE_IN_SMM in vmcs12 when using nested V=
MX.  Prior to
> > > > > > > > > commit 6b1dd26544d0 ("KVM: VMX: Preserve host's
> > > > > > > > > DEBUGCTLMSR_FREEZE_IN_SMM while running the guest"), L1 c=
ould set
> > > > > > > > > FREEZE_IN_SMM in vmcs12 to freeze PMCs during physical SM=
M coincident
> > > > > > > > > with L2's execution.  The quirk is enabled by default for=
 backwards
> > > > > > > > > compatibility; userspace can disable it via KVM_CAP_DISAB=
LE_QUIRKS2 if
> > > > > > > > > consistency with WRMSR(IA32_DEBUGCTL) is desired.
> > > > > > > >
> > > > > > > > It's probably worth calling out that KVM will still drop FR=
EEZE_IN_SMM in vmcs02
> > > > > > > >
> > > > > > > >         if (vmx->nested.nested_run_pending &&
> > > > > > > >             (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBU=
G_CONTROLS)) {
> > > > > > > >                 kvm_set_dr(vcpu, 7, vmcs12->guest_dr7);
> > > > > > > >                 vmx_guest_debugctl_write(vcpu, vmcs12->gues=
t_ia32_debugctl &
> > > > > > > >                                                vmx_get_supp=
orted_debugctl(vcpu, false)); <=3D=3D=3D=3D
> > > > > > > >         } else {
> > > > > > > >                 kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
> > > > > > > >                 vmx_guest_debugctl_write(vcpu, vmx->nested.=
pre_vmenter_debugctl);
> > > > > > > >         }
> > > > > > > >
> > > > > > > > both from a correctness standpoint and so that users aren't=
 mislead into thinking
> > > > > > > > the quirk lets L1 control of FREEZE_IN_SMM while running L2=
.
> > > > > > >
> > > > > > > Yes, it's probably worth pointing out that the VM is now subj=
ect to
> > > > > > > the whims of the L0 administrators.
> > > > > > >
> > > > > > > While that makes some sense for the legacy vPMU, where KVM is=
 just
> > > > > > > another client of host perf, perhaps the decision should be r=
evisited
> > > > > > > in the case of the MPT vPMU, where KVM owns the PMU while the=
 vCPU is
> > > > > > > in VMX non-root operation.
> > > > >
> > > > > Eh, running guests with FREEZE_IN_SMM=3D0 seems absolutely crazy =
from a security
> > > > > perspective.  If an admin wants to disable FREEZE_IN_SMM, they ge=
t to keep the
> > > > > pieces.  And KVM definitely isn't going to override the admin, e.=
g. to allow the
> > > > > guest to profile host SMM.
> > > >
> > > > I'm not sure what you mean by "they get to keep the pieces." What i=
s
> > > > the security problem with allowing L1 to freeze *guest-owned* PMCs
> > > > during SMM?
> > >
> > > To give L1 the option to freeze PMCs, KVM would also need to give L1 =
the option
> > > to *not* freeze PMCs.  At that point, the guest can use its PMCs to p=
rofile host
> > > SMM code.  Maybe even leverage a PMI to attack a poorly written SMM h=
andler.
> >
> > Perhaps I'm missing something. I was thinking, essentially, of a logica=
l or:
> >
> > vmcs02.debugctl.freeze_in_smm =3D vmcs12.debugctl.freeze_in_smm |
> > vmcs01.debugctl.freeze_in_smm
> >
> > So, an L1 request to freeze counters in SMM would be granted, but an
> > L1 request to *not* freeze counters could be overruled by the host.
>
> /facepalm
>
> Sorry, I misunderstood what you were suggesting.  Not sure how, it's supe=
r obvious,
> at least in hindsight.

My bad. I should have been more explicit (or maybe I should have just
omitted the aside).

> > I'm not suggesting this in the context of the legacy vPMU, because
> > some PMCs may be counting host-initiated perf events, and L1 should
> > not have any say in what those PMCs count. However, with the mediated
> > vPMU, L1 owns the entire PMU while L2 is running, so it seems
> > reasonable to allow it to freeze the counters during physical SMM.
>
> Agreed.
>
> > > In other words, unless I'm missing something, the only reasonable opt=
ion is to
> > > run the guest with FREEZE_IN_SMM=3D1, which means ignoring the guest'=
s wishes.
> > > Or I guess another way to look at it: you can have any color car you =
want, as
> > > long as it's black :-)
> >
> > I would be happy with FREEZE_IN_SMM=3D1. I'm not happy with the host
> > dictating FREEZE_IN_SMM=3D0.
>
> Yep, make sense.

Perhaps we should ignore both L0 and L1, and arbitrarily set
FREEZE_IN_SMM=3D1 for both vmcs01 and vmcs02 when MPT is enabled. But, I
don't think that discussion should block the resolution of this quirk.
I'll try to send v2 out later today.

