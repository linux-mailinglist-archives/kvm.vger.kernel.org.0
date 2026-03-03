Return-Path: <kvm+bounces-72578-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QDyHAUE0p2k9fwAAu9opvQ
	(envelope-from <kvm+bounces-72578-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:19:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A27D1F5DCA
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:19:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 726CE304939B
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 19:16:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0576384256;
	Tue,  3 Mar 2026 19:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NR7qM361"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59E638422F
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 19:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772565355; cv=none; b=qjTKJsx5uzs0ZOHcjQNglHNfqjHWwnwmFMeQKrlXC0RZDFA9mvR2D3xg/iAcRBzhh6hx3JgppAA+208iOXqdVVwqRIK02/2XZYiklzDZKO9ji5TNP8fKo8uA+d2zc+Oog/Bet7l/l2ITPU0qe04mjCFgOCMbxGk2EzcRqFsnlS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772565355; c=relaxed/simple;
	bh=f547AEbYxu/DMI6JnUp5q81lu69/hFXLp+OhFcorB4k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ogJKnlmHfEBBHJF0489e2QQUJi13bYmGcYOzfmy+FPP0YReCCzdHg0yoTx2+Mswrx8NAefoKg+R+xrwFzA/17FMbkCHIKIxwMn/eMVR2kyzIyTZIURCQxkVXM+iAMdLkVTNaQksNBm+zCmSxlLVG+gMwPluHS8fb4u8OCo0r1nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NR7qM361; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876C9C2BCAF
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 19:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772565355;
	bh=f547AEbYxu/DMI6JnUp5q81lu69/hFXLp+OhFcorB4k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=NR7qM361RBDdp1Mi1r2SZaZqkfw05NkVTLcwprx5rLE00juNVN3e2qls4p2fEwGXZ
	 XaTh5y20Bpz3arvNq8mEpvdkBIYrVrC+Gd9bbg+TmQsUxS/2flBToqEQ3KZFBxGD4/
	 9lBjVzlNt/7oPy/lGzXqCJegJl2AbfIKkf4feFdyD2WgbXFbD7zr1v0NW7lfpxwa0J
	 VAiKAPGp4VjBWBM1Ss9/tx23ufcvp/lAHRk0Oc5qqP47Xtm1G+ryl/SViCd83NTcg6
	 Ae384wtW2pF1N2u2BJhCAozDVJC1VZwHjqux8Rukhm05flK5ALRONDPj1P5NO+s9K4
	 PixlYkmfMUjvA==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-65b9d8d6b7dso9870397a12.2
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 11:15:55 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV0XjMBxIpb35zMAhdsKmI9RttSbL//Ln+5YiKqhvfQiYKiERzS2jEfkmpaIbG7WORotrQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzp3I3HEt0+bhte48Ghcg448Mc1r0WTJ54aBX4Cp4RfIqQYy+Bc
	ura4mlDn7HGdZOGNhFtkQa442Ug0WTutIhR1RcG9TJKqXNpJ5Ld8IV361jtVCNfiCjcNswzMTqd
	GSCfBFF2UYYCn9CtM7ES6AVOjU5E2yDA=
X-Received: by 2002:a17:906:9fc5:b0:b93:6559:3148 with SMTP id
 a640c23a62f3a-b93765defa9mr959439866b.61.1772565354381; Tue, 03 Mar 2026
 11:15:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260303003421.2185681-1-yosry@kernel.org> <20260303003421.2185681-13-yosry@kernel.org>
 <aacRVwsI0x_kDZ0u@google.com>
In-Reply-To: <aacRVwsI0x_kDZ0u@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 3 Mar 2026 11:15:42 -0800
X-Gmail-Original-Message-ID: <CAO9r8zO3vOtSpEPDagqNF7t+nW8_ZCxCgfZjyt_zKYPDf4W5TA@mail.gmail.com>
X-Gm-Features: AaiRm51OZxT8EaALiZMjoD8WlAvgoQ7PyEMjl2-cHcFwJMcBi8hwdDPVm6vXooI
Message-ID: <CAO9r8zO3vOtSpEPDagqNF7t+nW8_ZCxCgfZjyt_zKYPDf4W5TA@mail.gmail.com>
Subject: Re: [PATCH v7 12/26] KVM: nSVM: Clear tracking of L1->L2 NMI and soft
 IRQ on nested #VMEXIT
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1A27D1F5DCA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72578-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, Mar 3, 2026 at 8:50=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Tue, Mar 03, 2026, Yosry Ahmed wrote:
> > KVM clears tracking of L1->L2 injected NMIs (i.e. nmi_l1_to_l2) and sof=
t
> > IRQs (i.e. soft_int_injected) on a synthesized #VMEXIT(INVALID) due to
> > failed VMRUN. However, they are not explicitly cleared in other
> > synthesized #VMEXITs.
> >
> > soft_int_injected is always cleared after the first VMRUN of L2 when
> > completing interrupts, as any re-injection is then tracked by KVM
> > (instead of purely in vmcb02).
> >
> > nmi_l1_to_l2 is not cleared after the first VMRUN if NMI injection
> > failed, as KVM still needs to keep track that the NMI originated from L=
1
> > to avoid blocking NMIs for L1. It is only cleared when the NMI injectio=
n
> > succeeds.
> >
> > KVM could synthesize a #VMEXIT to L1 before successfully injecting the
> > NMI into L2 (e.g. due to a #NPF on L2's NMI handler in L1's NPTs). In
> > this case, nmi_l1_to_l2 will remain true, and KVM may not correctly mas=
k
> > NMIs and intercept IRET when injecting an NMI into L1.
> >
> > Clear both nmi_l1_to_l2 and soft_int_injected in nested_svm_vmexit() to
> > capture all #VMEXITs, except those that occur due to failed consistency
> > checks, as those happen before nmi_l1_to_l2 or soft_int_injected are
> > set.
>
> This last paragraph confused me a little bit.  I read "to capture all #VM=
EXITs"
> as some sort of "catching" that KVM was doing.  I've got it reworded to t=
his:
>
> Clear both nmi_l1_to_l2 and soft_int_injected in nested_svm_vmexit(), i.e=
.
> for all #VMEXITs except those that occur due to failed consistency checks=
,
> as those happen before nmi_l1_to_l2 or soft_int_injected are set.

LGTM.

