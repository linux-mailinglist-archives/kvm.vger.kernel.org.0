Return-Path: <kvm+bounces-72742-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iFNwMXyJqGn2vQAAu9opvQ
	(envelope-from <kvm+bounces-72742-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 20:35:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BB2D207242
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 20:35:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 81472301EF28
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 19:35:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EAD33DEAF6;
	Wed,  4 Mar 2026 19:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i+jnnzmT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850213A4F48
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 19:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772652917; cv=none; b=SMSUnTEOVdmJLEdHdZnOeF0wcJGBvbnRG3VGcRxFjOclVh7/XQIiMzVGFDyfjS5uE3f8bN2Keh4dTqARTNHDAB2jQ012qn5esP2u7rF1LWoIvVEGJgRkwCjKw+xvarbfZ1rnWP9UkIuSDfuei0Q4LkU2l1StGEXL0eE+5b+NGEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772652917; c=relaxed/simple;
	bh=px2XsPD6fM4UJ75XYwb06Ld+5FA4LnkprLiwjoqolkU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mvzbV9/Kvq4TJrg4E9FJ72493j3UPbFjoxrx5Dcgla3Unu0Ujxe8efqR4zZIkjFxyLQdkX+ZzOx5uLgrMpARkNaSdSz7IloL8xN7d7UuHBh5mAPsluGE1K7Nd3ySNkHkTI+CuS++Coewmu/0iW2q7ovZ92Kob2HIuGBycBbtTsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i+jnnzmT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2CBC2BCAF
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 19:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772652917;
	bh=px2XsPD6fM4UJ75XYwb06Ld+5FA4LnkprLiwjoqolkU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=i+jnnzmTczc03QwAOPu1CQ6uvyS7K4e+4yurEC02d+cFNablz3yvEq8S/fR7Y1rlF
	 DKMnTo0zmLX2jrq1+SBN7Jyv66crlA+5NLh0AcxqH9EmmQGvQHWa1w9DAY4cGIuglb
	 ss9JgQK4Vu3iIQ4hcjgwMMNLtdikOnZ0MdGgwwDUDPJKtQp12NG0bp5cpt7AwlKzGN
	 Cex1BPhHyG+GWkLE/qyF+rD9YSrfekN1RrmJYp0iAUMBsVXBbqE+7WNv7ZdFT74KKF
	 QDYBKBOOEBsihQDrIefCzthdBDpqD8oYVTNZXnvmI0e0Mqt+/+P7NHSA4yzJvhpfnJ
	 iBG8A7N8ec10w==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-65faaa8b807so3901756a12.3
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 11:35:17 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUSY6/F1UQNkvRcfXBt+05P4QedNjaxJGglS0V4uSCRvy+zX3spLAENDsztYLYyi00uyXk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwynRIv0KFcssu63PSRP/rT045h7078rBFZyAhXvVY8VC1rd+Rq
	Z2KXjPKadXOBKI9NRgf6GS79VWCYSeQBGrIncD8JefsKLKGABzUnJ8/iz2vEYvHI1wKD5sH5Fr4
	qf9rsjZzCpMTeS6/uOZ8LpfG8vyc7kls=
X-Received: by 2002:a17:907:2d87:b0:b88:5158:d106 with SMTP id
 a640c23a62f3a-b93f154b56dmr197162166b.52.1772652915916; Wed, 04 Mar 2026
 11:35:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260224005500.1471972-1-jmattson@google.com> <20260224005500.1471972-9-jmattson@google.com>
 <aahn2ZfDAJTj-Afn@google.com> <CALMp9eR7gKWp8M2Q8Q7vA5hGx5bc12KCh1NZMK33A1dpiKNt+Q@mail.gmail.com>
 <aaiD0k-BE4RZJPfv@google.com>
In-Reply-To: <aaiD0k-BE4RZJPfv@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 4 Mar 2026 11:35:04 -0800
X-Gmail-Original-Message-ID: <CAO9r8zP+tdUtDwxzDVKbtCk7Ui5y=Zw_aZ+ptL4-H6-R5vXWTQ@mail.gmail.com>
X-Gm-Features: AaiRm50aL4JiTvlrRjow1Hoe0PK1MYqEFABWOPGZCK8qrEFRxuzuDgJC5J1qBcU
Message-ID: <CAO9r8zP+tdUtDwxzDVKbtCk7Ui5y=Zw_aZ+ptL4-H6-R5vXWTQ@mail.gmail.com>
Subject: Re: [PATCH v5 08/10] KVM: x86: nSVM: Save/restore gPAT with KVM_{GET,SET}_NESTED_STATE
To: Sean Christopherson <seanjc@google.com>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6BB2D207242
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72742-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_TWELVE(0.00)[14];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Wed, Mar 4, 2026 at 11:11=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, Mar 04, 2026, Jim Mattson wrote:
> > On Wed, Mar 4, 2026 at 9:11=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > > index 991ee4c03363..099bf8ac10ee 100644
> > > --- a/arch/x86/kvm/svm/nested.c
> > > +++ b/arch/x86/kvm/svm/nested.c
> > > @@ -1848,7 +1848,7 @@ static int svm_get_nested_state(struct kvm_vcpu=
 *vcpu,
> > >         if (is_guest_mode(vcpu)) {
> > >                 kvm_state.hdr.svm.vmcb_pa =3D svm->nested.vmcb12_gpa;
> > >                 if (nested_npt_enabled(svm)) {
> > > -                       kvm_state.hdr.svm.flags |=3D KVM_STATE_SVM_VA=
LID_GPAT;
> > > +                       kvm_state->flags |=3D KVM_STATE_NESTED_GPAT_V=
ALID;
> > >                         kvm_state.hdr.svm.gpat =3D svm->vmcb->save.g_=
pat;
> > >                 }
> > >                 kvm_state.size +=3D KVM_STATE_NESTED_SVM_VMCB_SIZE;
> > > @@ -1914,7 +1914,8 @@ static int svm_set_nested_state(struct kvm_vcpu=
 *vcpu,
> > >
> > >         if (kvm_state->flags & ~(KVM_STATE_NESTED_GUEST_MODE |
> > >                                  KVM_STATE_NESTED_RUN_PENDING |
> > > -                                KVM_STATE_NESTED_GIF_SET))
> > > +                                KVM_STATE_NESTED_GIF_SET |
> > > +                                KVM_STATE_NESTED_GPAT_VALID))
> > >                 return -EINVAL;
> >
> > Unless I'm missing something, this breaks forward compatibility
> > completely. An older kernel will refuse to accept a nested state blob
> > with GPAT_VALID set.
>
> Argh, so we've painted ourselves into an impossible situation by restrict=
ing the
> set of valid flags.  I.e. VMX's omission of checks on unknown flags is a =
feature,
> not a bug.
>
> Chatted with Jim offlist, and he pointed out that KVM's standard way to d=
eal with
> this is to make setting the flag opt-in, e.g. KVM_CAP_X86_TRIPLE_FAULT_EV=
ENT and
> KVM_CAP_EXCEPTION_PAYLOAD.
>
> As much as I want to retroactively change KVM's documentation to state do=
ing
> KVM_SET_NESTED_STATE with data that didn't come from KVM_GET_NESTED_STATE=
 is
> unsupported, that feels too restrictive and could really bite us in the f=
uture.
> And it doesn't help if there's already userspace that's putting garbage i=
nto the
> header.
>
> So yeah, I don't see a better option than adding yet another capability.
>
> Can you send a new version based on `kvm-x86 next`?  (give me ~hour to dr=
op these
> and push).  This has snowballed beyond what I'm comfortable doing as fixu=
p. :-(

Will the current patches still be reachable through
kvm-x86-next-2026.03.03? I imagine Jim will want to pull those and
change them directly as they have all your fixups (rather than
reconstructing them).

