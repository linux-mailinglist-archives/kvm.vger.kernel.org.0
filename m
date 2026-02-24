Return-Path: <kvm+bounces-71659-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cKArNz72nWlzSwQAu9opvQ
	(envelope-from <kvm+bounces-71659-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 20:04:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 04E5618BA5F
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 20:04:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 48EFD3039669
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:04:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6FD42EDD6B;
	Tue, 24 Feb 2026 19:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r73x5M1M"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0222E7BD3
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 19:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771959864; cv=none; b=LhcGT9UzejMULPRBVbRpVOtkR1r8qYPw4gTYcoWzB4fJ5QTNx6MIhpGTZ9WdOXXliZtAMsMg3R27Ztuv1+3UPikhNSpjGMhKbFuvd1qPC6Y9MI1HjeO2uSYTF9JhO59jOX9pZhRp04l7qNbjnZwYwQMGjC4zTbghNjFSNm9EzhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771959864; c=relaxed/simple;
	bh=yuxubmrUGrDAA0A4bfXgAusOW3sdaXsTd2mR/9EuHgE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DrZTgyb9hagPE/rm7NK8lpqEohq2uMm/3WN88dF1I6pZmhnqHfkuvuGrwNoGZlfwtp51HVODK4VRmYQdHv0eNlEI8AGp9pI7ZZjJ2kax+33KPERJp24PIXHoFCX4kqcaJt4jXRRnUTBh6Hs9JC93EIi4iJqYfQuFGhibG0LjbIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r73x5M1M; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91119C19422
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 19:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771959864;
	bh=yuxubmrUGrDAA0A4bfXgAusOW3sdaXsTd2mR/9EuHgE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=r73x5M1MgfMcZ1OUvpqE4t64C2dgGemb5mbqHXlUAdwTP0O89tjZFrpPakaILmSxR
	 QO2rl6XGllSx2y0Af7XJ0ZEfS0iXNsd+8sTrAF/hnZGXi+IVLIgzy5TRa3WFAcqxRq
	 ORNxvf/kRIe52p02frNyebvy72QtjwFbIh4XMrz6YmPI4XubcEZUqxGHMXchezheO3
	 4Pq2eBoen5gkOCbkS2kKUzDdF2V7wdhq6TEpU4ehqFVFniE0n00DslF551yME3Q9cq
	 xRPXLOXOZfW2fKSwwYszxaFWWxXBKmFj7Sbv8QG4GXB8rpIyYHzcDWFZ8WF6r7Kn/B
	 oEjpv0Tz/6LCw==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-65c5a778923so9105762a12.2
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 11:04:24 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUj+wKLg4A9unKu9eZhdYdV2y9O2mRNlMcw4ZiYqB6SothNt3LyJfsTK6H+DdayTJ7g+lU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQIk3RATeeTMIczEob68CM3Yp3GGR5By5LHa3YKCeRpZgfxZC/
	KdaFtJtR59C3dLocMNYgh4m9hg2SQvXz9aAjd7WcSSP2MAnkZrLJOuqbQl/t0UmzbiwEr6cnO1s
	Fbs7WnvvbPe8m/ToYaxnI16AFsGCvhBM=
X-Received: by 2002:a17:906:9f85:b0:b8e:d4ed:5eeb with SMTP id
 a640c23a62f3a-b9081a45252mr899102566b.26.1771959863435; Tue, 24 Feb 2026
 11:04:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260224005500.1471972-1-jmattson@google.com> <20260224005500.1471972-6-jmattson@google.com>
 <aZ3jQ1prL4dgG0-H@google.com>
In-Reply-To: <aZ3jQ1prL4dgG0-H@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 24 Feb 2026 11:04:12 -0800
X-Gmail-Original-Message-ID: <CAO9r8zMq87ORsuox7XGQqBeaN0+1x=thxCe6zZC19Sfnbigwfg@mail.gmail.com>
X-Gm-Features: AaiRm51TIU5UJc1DXSmBDRvNKSJlug6l8rc2QmCzMSvRd-bpELQ-JURuMybv_qs
Message-ID: <CAO9r8zMq87ORsuox7XGQqBeaN0+1x=thxCe6zZC19Sfnbigwfg@mail.gmail.com>
Subject: Re: [PATCH v5 05/10] KVM: x86: nSVM: Redirect IA32_PAT accesses to
 either hPAT or gPAT
To: Sean Christopherson <seanjc@google.com>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71659-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 04E5618BA5F
X-Rspamd-Action: no action

On Tue, Feb 24, 2026 at 9:43=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Feb 23, 2026, Jim Mattson wrote:
> > +static void svm_set_pat(struct kvm_vcpu *vcpu, bool from_host, u64 dat=
a)
> > +{
> > +     struct vcpu_svm *svm =3D to_svm(vcpu);
> > +
> > +     if (svm_pat_accesses_gpat(vcpu, from_host)) {
> > +             vmcb_set_gpat(svm->vmcb, data);
> > +     } else {
> > +             svm->vcpu.arch.pat =3D data;
> > +             if (npt_enabled) {
> > +                     vmcb_set_gpat(svm->vmcb01.ptr, data);
> > +                     if (is_guest_mode(&svm->vcpu) &&
> > +                         !nested_npt_enabled(svm))
> > +                             vmcb_set_gpat(svm->vmcb, data);
> > +             }
> > +     }
>
> Overall, this LGTM.  For this particular code, any objection to using ear=
ly
> returns to reduce indentation?  The else branch above is a bit gnarly, es=
pecially
> when legacy_gpat_semantics comes along.
>
> I.e. end up with this
>
>   static void svm_set_pat(struct kvm_vcpu *vcpu, bool from_host, u64 data=
)
>   {
>         struct vcpu_svm *svm =3D to_svm(vcpu);
>
>         if (svm_pat_accesses_gpat(vcpu, from_host)) {
>                 vmcb_set_gpat(svm->vmcb, data);
>                 return;
>         }
>
>         svm->vcpu.arch.pat =3D data;
>
>         if (!npt_enabled)
>                 return;
>
>         vmcb_set_gpat(svm->vmcb01.ptr, data);
>         if (is_guest_mode(&svm->vcpu) &&
>             (svm->nested.legacy_gpat_semantics || !nested_npt_enabled(svm=
)))
>                 vmcb_set_gpat(svm->vmcb, data);
>   }
>
> I can fixup when applying (unless you and/or Yosry object).

LGTM.

