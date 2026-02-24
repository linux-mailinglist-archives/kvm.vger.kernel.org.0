Return-Path: <kvm+bounces-71666-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aBL0LHH/nWkNTAQAu9opvQ
	(envelope-from <kvm+bounces-71666-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 20:43:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B43A18C2EE
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 20:43:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DB0D830BF9B5
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:42:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB30B30F946;
	Tue, 24 Feb 2026 19:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k/EqS330"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B32830F547
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 19:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771962176; cv=none; b=QV22kzUSMDDhgDqeVKPla87jifohqsYkT6HSJhhEhECXZ9D2Ee3w/LY6gnKO7ap6P3UVJtIUIcldkeJ9c1P/xyrcUwiuEYmUPMJYkMMNiBY7ctbT9/dXaMRWq9hSmAoMXPMrBLR4nO0r0/XkPvxWZm94lnyKp6Gj3QrPYEclzDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771962176; c=relaxed/simple;
	bh=KuVemg/B01PMia4qQdNg/8L0bVTm/y9J/0XyzeqSDfw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nrcM1xOXYeAiMaHaJwR0bI3vS2pLHIxHAYUtClUAlSiETdiAa2AQXKdJvsGsYkiJIqlVBMqCDpvybxr3UUBsDLQnVrmRbHrlkXiqjZx0OmzXKWNIINfBGbn19EVP8EnuYMs0ohjkTFWKZfiz1wSIA5roWpSZFiwAXPBNDjJRIQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k/EqS330; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A35C19422
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 19:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771962175;
	bh=KuVemg/B01PMia4qQdNg/8L0bVTm/y9J/0XyzeqSDfw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=k/EqS3309ucvfyFJqpYy4DhPxIVAe+ni+Vvh9wvaa+0dQZbIR6JhyPrQXHniQzFTM
	 CkNz4tz/oH4EGxbnn/Z37BRgJ0jkOHYkzOWpA+1fInvMlWq6kMf3hYziDZQGOlzR31
	 tYi9dbt8L7fYjy5KFyWiozJ99Mpz6umTkl7zBlFfCpYARpflJ5jEkl2aJt8iL6SO6+
	 A2JbHMDOqaBxW3AfE7RvBwXtq2CRHIftyhXNUxAuOy3zZYAylmVhkbZ8S+A4+BAw/4
	 juFiFadTSIlTQYrZR22noPNoLud5CGO0Rt+6OpETj12cyP8JQzjgRNKJHq4SBrPYhF
	 T09hJDBZZ7UfQ==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-65c187dfc82so7363888a12.2
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 11:42:55 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUgxCXH0f7Gpj04fqvq5MRhF38XdOowPsGCjJ8X5WOXyi6HAKrtg2OSS81i6xPCbh5yEl8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRRW0rNXCyvIeetruadbqyhSQ9Pgz7L/pFWMgNy6/epxitCCmY
	V6W+/sldRK3SYonTlXBsD6etHjZFyTPssatHv5pOzf5yYv/vV3YgbzcFeQD8HZ7wVsHDoj+GWsJ
	Srntmq9C/iCrdu/enNUMhyAGau6b7Tec=
X-Received: by 2002:a17:907:7fa0:b0:b8e:fad0:6c97 with SMTP id
 a640c23a62f3a-b9081920c9fmr698250166b.8.1771962174809; Tue, 24 Feb 2026
 11:42:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260224071822.369326-1-chengkev@google.com> <20260224071822.369326-4-chengkev@google.com>
 <aZ3gg2VsrWGKrX4l@google.com> <CAO9r8zNrQGKM0N345+KG=W72FyV1pp2EqOLcTMUZkz6bCA3MgQ@mail.gmail.com>
 <aZ3-AqK3liE1XNGB@google.com>
In-Reply-To: <aZ3-AqK3liE1XNGB@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 24 Feb 2026 11:42:42 -0800
X-Gmail-Original-Message-ID: <CAO9r8zPvUW0TxohX8Xw6Vi8NgNgWPHfxzsSp0kSVxU5hi7H8QA@mail.gmail.com>
X-Gm-Features: AaiRm534hAfVcncsIyxbcErGZhFzDPcAXVq44PJVIbxFUzZveoN9j7kLpbXJWJw
Message-ID: <CAO9r8zPvUW0TxohX8Xw6Vi8NgNgWPHfxzsSp0kSVxU5hi7H8QA@mail.gmail.com>
Subject: Re: [PATCH V2 3/4] KVM: VMX: Don't consult original exit
 qualification for nested EPT violation injection
To: Sean Christopherson <seanjc@google.com>
Cc: Kevin Cheng <chengkev@google.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yosry.ahmed@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71666-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 3B43A18C2EE
X-Rspamd-Action: no action

On Tue, Feb 24, 2026 at 11:37=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Tue, Feb 24, 2026, Yosry Ahmed wrote:
> > > > @@ -496,7 +510,7 @@ static int FNAME(walk_addr_generic)(struct gues=
t_walker *walker,
> > > >        * [2:0] - Derive from the access bits. The exit_qualificatio=
n might be
> > > >        *         out of date if it is serving an EPT misconfigurati=
on.
> > > >        * [5:3] - Calculated by the page walk of the guest EPT page =
tables
> > > > -      * [7:8] - Derived from [7:8] of real exit_qualification
> > > > +      * [7:8] - Set at the kvm_translate_gpa() call sites above
> > > >        *
> > > >        * The other bits are set to 0.
> > > >        */
> > > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > > index 248635da67661..6a167b1d51595 100644
> > > > --- a/arch/x86/kvm/vmx/nested.c
> > > > +++ b/arch/x86/kvm/vmx/nested.c
> > > > @@ -444,9 +444,6 @@ static void nested_ept_inject_page_fault(struct=
 kvm_vcpu *vcpu,
> > > >                       exit_qualification =3D 0;
> > > >               } else {
> > > >                       exit_qualification =3D fault->exit_qualificat=
ion;
> > > > -                     exit_qualification |=3D vmx_get_exit_qual(vcp=
u) &
> > > > -                                           (EPT_VIOLATION_GVA_IS_V=
ALID |
> > > > -                                            EPT_VIOLATION_GVA_TRAN=
SLATED);
> > >
> > > Hmm, this isn't quite correct.  If KVM injects an EPT Violation (or a=
 #NPF) when
> > > handling an EPT Violation (or #NPF) from L2, then KVM _should_ follow=
 hardware.
> > >
> > > Aha!  I think the easiest way to deal with that is to flag nested pag=
e faults
> > > that were the result of walking L1's TDP when handling an L2 TDP page=
 fault, and
> > > then let vendor code extract the fault information out of hardaware.
> >
> > Is it not possible that KVM gets an EPT Violation (or a #NPF) on an L2
> > memory access while the CPU is walking L2's page tables, then KVM
> > walks L1's TDP and finds mappings for the L2 page tables but not the
> > final translation? Or will KVM always just fixup the immediate EPT
> > Violation (or #NPF) by inserting a shadow mapping of L2's page tables
> > and retry the instruction immediately?
>
> The latter, assuming by "shadow mapping of L2's page tables" out meant "i=
nstalling
> a shadow mapping of the faulting L2 GPA according to L1's TDP page tables=
".
>
> I.e. when servicing an L2 TDP fault, KVM is only resolving the fault for =
the reported
> L2 GPA, _not_ the originating L2 GVA (if there is one).

I see. Does this need special handling when forwarding #NPFs to L1 as
well? Or will fault->error_code have the HW fault bits in
nested_svm_inject_npf_exit() in this case?

