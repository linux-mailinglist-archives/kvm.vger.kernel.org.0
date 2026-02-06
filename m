Return-Path: <kvm+bounces-70472-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uLEYKHo3hmmHLAQAu9opvQ
	(envelope-from <kvm+bounces-70472-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 19:48:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id AC3A81023D1
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 19:48:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D3EAD3049070
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 18:32:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3217642EEAA;
	Fri,  6 Feb 2026 18:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="w61hwdrn"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DEB542E010
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 18:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770402552; cv=none; b=cIIMDzL2RDuqb4DPfzRqWIQThEBMFlYfZPnBrdzA1tz4GT0Tt+E6MKo7lHwUFWyfarWnzvD4jU63k2jMtLHLIEKG/q5akgjKAFLlgAljAGob+qjJZVN9h9RcofPYX8gnu4H11Cl79YnjHsKy9kfnsaEm7s/h7PMJIJrGDQQHbsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770402552; c=relaxed/simple;
	bh=ymfAs3xB8hAuETyebogRx9mBd07Qw8b8lS7I2myLjSk=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=T9rtIljBjXc0K9NGaCPmU5l3jdjcDBBveZ/F7yvMC8rBS58EBD6uMZiFx3VUR0vLnDm5pVHIXkXY0SSUtl52OIlk0k8+7MWlsyMgEuoZlpjw/Cqi3vLthU3dR7BhLnj7J3sC00GC5CG12Jxx1LOoR9tVZQGA2KIbcOcFZl7wSO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=w61hwdrn; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770402550;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oEqsT/9o28ooWpXG8lklZvWxvcXOZono2CP5ZVtyGks=;
	b=w61hwdrnqOhRiR8XiXSao9xW8xRL17RkWx+39mLRCIIk3YV1x8EbiAkvCOqof1kzmj8VYn
	08G9VMj4R2nQ/4DApBJzcBTXgBGyEy/etkcjF79+zG5WZ5ghjhBo397b3K5QG/E58awrx9
	QJk9jm89AgUR715SuijijjPvaGyjsBg=
Date: Fri, 06 Feb 2026 18:29:05 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yosry Ahmed" <yosry.ahmed@linux.dev>
Message-ID: <0468715595718af34a8a3551663cffa79dd3ce2e@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v3 3/8] KVM: x86: nSVM: Set vmcb02.g_pat correctly for
 nested NPT
To: "Sean Christopherson" <seanjc@google.com>, "Jim Mattson"
 <jmattson@google.com>
Cc: "Paolo Bonzini" <pbonzini@redhat.com>, "Thomas Gleixner"
 <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov"
 <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, "Shuah Khan"
 <shuah@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
In-Reply-To: <aYYxh8EiLrBTiq0L@google.com>
References: <20260205214326.1029278-1-jmattson@google.com>
 <20260205214326.1029278-4-jmattson@google.com>
 <aYYxh8EiLrBTiq0L@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70472-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[linux.dev:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,linux.dev:mid,linux.dev:dkim]
X-Rspamd-Queue-Id: AC3A81023D1
X-Rspamd-Action: no action

February 6, 2026 at 10:23 AM, "Sean Christopherson" <seanjc@google.com> w=
rote:
>=20
>=20On Thu, Feb 05, 2026, Jim Mattson wrote:
>=20
>=20>=20
>=20> When nested NPT is enabled in vmcb12, copy the (cached and validate=
d)
> >  vmcb12 g_pat field to the guest PAT register. Under KVM, the guest P=
AT
> >  register lives in the vmcb02 g_pat field.
> >=20=20
>=20>  When NPT is enabled, but nested NPT is disabled, copy L1's IA32_PA=
T MSR to
> >  the vmcb02 g_pat field, since L2 shares the IA32_PAT MSR with L1.
> >=20=20
>=20>  When NPT is disabled, the vmcb02 g_pat field is ignored by hardwar=
e.
> >=20
>=20Uber nit, the "vmcb02" qualifier can be dropped, i.e.
>=20
>=20 When NPT is disabled, the g_pat field is ignored by hardware.
>=20
>=20Scoping it to vmcb02 makes it sound like there's a special rule about=
 vmcb02.
>=20
>=20>=20
>=20> Fixes: 15038e147247 ("KVM: SVM: obey guest PAT")
> >  Signed-off-by: Jim Mattson <jmattson@google.com>
> >  ---
> >  arch/x86/kvm/svm/nested.c | 16 +++++++++++++---
> >  1 file changed, 13 insertions(+), 3 deletions(-)
> >=20=20
>=20>  diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> >  index 1d4ff6408b34..1ff2ede96094 100644
> >  --- a/arch/x86/kvm/svm/nested.c
> >  +++ b/arch/x86/kvm/svm/nested.c
> >  @@ -646,9 +646,6 @@ static void nested_vmcb02_prepare_save(struct vc=
pu_svm *svm, struct vmcb *vmcb12
> >  struct vmcb *vmcb02 =3D svm->nested.vmcb02.ptr;
> >  struct kvm_vcpu *vcpu =3D &svm->vcpu;
> >=20=20
>=20>  - nested_vmcb02_compute_g_pat(svm);
> >  - vmcb_mark_dirty(vmcb02, VMCB_NPT);
> >  -
> >  /* Load the nested guest state */
> >  if (svm->nested.vmcb12_gpa !=3D svm->nested.last_vmcb12_gpa) {
> >  new_vmcb12 =3D true;
> >  @@ -656,6 +653,19 @@ static void nested_vmcb02_prepare_save(struct v=
cpu_svm *svm, struct vmcb *vmcb12
> >  svm->nested.force_msr_bitmap_recalc =3D true;
> >  }
> >=20=20
>=20>  + if (npt_enabled) {
> >  + if (nested_npt_enabled(svm)) {
> >  + if (unlikely(new_vmcb12 ||
> >  + vmcb_is_dirty(vmcb12, VMCB_NPT))) {
> >  + vmcb02->save.g_pat =3D svm->nested.gpat;
> >  + vmcb_mark_dirty(vmcb02, VMCB_NPT);
> >  + }
> >  + } else {
> >  + vmcb02->save.g_pat =3D vcpu->arch.pat;
> >  + vmcb_mark_dirty(vmcb02, VMCB_NPT);
> >  + }
> >  + }
> >=20
>=20To reduce indentation, how about this? There's a consistency check fo=
r
> nested_npt_enabled() vs. npt_enabled, so it's guaranteed to do the righ=
t thing.

You mean the one that goes away after this patch: https://lore.kernel.org=
/kvm/20260115011312.3675857-16-yosry.ahmed@linux.dev/?

>=20
>=20 if (nested_npt_enabled(svm)) {
>  if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_NPT))) {
>  vmcb02->save.g_pat =3D svm->nested.gpat;
>  vmcb_mark_dirty(vmcb02, VMCB_NPT);
>  }
>  } else if (npt_enabled) {
>  vmcb02->save.g_pat =3D vcpu->arch.pat;
>  vmcb_mark_dirty(vmcb02, VMCB_NPT);
>  }
>=20
>=20>=20
>=20> +
> >  if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_SEG))) {
> >  vmcb02->save.es =3D vmcb12->save.es;
> >  vmcb02->save.cs =3D vmcb12->save.cs;
> >  --=20
>=20>  2.53.0.rc2.204.g2597b5adb4-goog
> >
>

