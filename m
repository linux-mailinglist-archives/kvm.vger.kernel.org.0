Return-Path: <kvm+bounces-73301-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mADrEvfQrmlhJAIAu9opvQ
	(envelope-from <kvm+bounces-73301-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 14:53:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E1D7C23A16D
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 14:53:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C84D3302143B
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 13:53:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 411983BD623;
	Mon,  9 Mar 2026 13:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t3+RtRpS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76511346E40
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 13:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773064432; cv=none; b=A9YHj51kHlWRPtpJdfCtSFEWmPrW+H6lZufZoHjq3eTQEYur8bxdaW1HPZQ8rXSJJI/i1rookfbawM1p5Q/Bmicby6CpD1BGf/mlwwT32mmdFJmICiRikUfgR0rBHxQ4SQ04bh8CRtB6CJvU2f1EdmGDGx+GuV+UBUbLFXqMcvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773064432; c=relaxed/simple;
	bh=WzqB9hJPpdwgEtMvlaNtEcSaXRcBKx6MsZkJs5aiSQc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nns+4xXzRdqVeANbyIjkJg3b99CrUWPj8gceHa0mPXv2PIlypXxE2p7Qwc50YtWZY6WNTSHY3mxbkKb+bAohwuGsBAyuam38Pgd1KosKNaDHeIau8Jrr5nKxi1N3KYsaytxvgwWO3uD0YhKlapFAe8TYMZbNW+obMf9Gd7veaVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t3+RtRpS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C802C4AF09
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 13:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773064432;
	bh=WzqB9hJPpdwgEtMvlaNtEcSaXRcBKx6MsZkJs5aiSQc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=t3+RtRpSP6mTJX7fc59w9z+7SrNxufNvtIRrI4BIYWNgDc0nRjtCXwoKUsPBqhKc3
	 p8Lre58tujrI0ZsIKfVhbJEO0PMC+XO1BXGOmEveL6nczTZH4tzoEz9/dQrx9zcoO7
	 R+dY9t/5iFhYRb0jRu/d4cRL0AA2Ss43+dpaW6WSYjSVwMY9a0oSvwkvQk9NCMuBaj
	 auRW63Zwwbxi14MvT1ftZrTvHozaKhDvmKsr2toOBPkLwJLc6TH4p2cNCExghfKKUC
	 ePDSymbK4kHJgUSmIccofrRFO91VIOeRvSJvfWUdZo7H9QNkDl0ue4OrTuWb9sCdVQ
	 0V0z52Imy6ANw==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b941762394aso442390666b.1
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 06:53:52 -0700 (PDT)
X-Gm-Message-State: AOJu0YyiwrECiuylc3TL9v7urm7Fuo+bf9+2A5mU4ahIuL1j5Zvn2yvn
	7oZcHw0iNCRe8yF5nIHgM5dvL4OWQ3l+4veCogpuZ+gPjs1nJ4hEiSIQ3eNXhxjrdGFNHXq5DVh
	W4Beb0IiMuIsmmV2HBf1zudn84wXNguc=
X-Received: by 2002:a17:907:a0c8:b0:b93:80f3:b356 with SMTP id
 a640c23a62f3a-b942dbcd374mr620849066b.8.1773064430902; Mon, 09 Mar 2026
 06:53:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260307011619.2324234-4-yosry@kernel.org> <34cbc227-f01f-4d4b-b6ab-19bcb02d7e3c@citrix.com>
In-Reply-To: <34cbc227-f01f-4d4b-b6ab-19bcb02d7e3c@citrix.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 9 Mar 2026 06:53:39 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOM0OWaFvAQd6FGkCC6WxkVBbQZa10pFm9b-wF1G1A6ew@mail.gmail.com>
X-Gm-Features: AaiRm50dDlXd9Pe0nt2WS1Wuxlt2u0tCYF69UxrNC8sOX5xmvDcubswprjha5oM
Message-ID: <CAO9r8zOM0OWaFvAQd6FGkCC6WxkVBbQZa10pFm9b-wF1G1A6ew@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: SVM: Advertise Translation Cache Extensions
 to userspace
To: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	seanjc@google.com, venkateshs@chromium.org, venkateshs@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E1D7C23A16D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73301-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.946];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,chromium.org:email,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,citrix.com:email]
X-Rspamd-Action: no action

On Fri, Mar 6, 2026 at 5:54=E2=80=AFPM Andrew Cooper <andrew.cooper3@citrix=
.com> wrote:
>
> > From: Venkatesh Srinivas <venkateshs@chromium.org>
> >
> > TCE augments the behavior of TLB invalidating instructions (INVLPG,
> > INVLPGB, and INVPCID) to only invalidate translations for relevant
> > intermediate mappings to the address range, rather than ALL intermdiate
> > translations.
> >
> > The Linux kernel has been setting EFER.TCE if supported by the CPU sinc=
e
> > commit 440a65b7d25f ("x86/mm: Enable AMD translation cache extensions")=
,
> > as it may improve performance.
> >
> > KVM does not need to do anything to virtualize the feature, only
> > advertise it and allow setting EFER.TCE. If a TLB invalidating
> > instruction is not intercepted, it will behave according to the guest's
> > setting of EFER.TCE as the value will be loaded on VM-Enter. Otherwise,
> > KVM's emulation may invalidate more TLB entries, which is perfectly fin=
e
> > as the CPU is allowed to invalidate more TLB entries that it strictly
> > needs to.
> >
> > Advertise X86_FEATURE_TCE to userspace, and allow the guest to set
> > EFER.TCE if available.
> >
> > Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>
> > Co-developed-by: Yosry Ahmed <yosry@kernel.org>
> > Signed-off-by: Yosry Ahmed <yosry@kernel.org>
>
> I'll repeat what I said on that referenced patch.
>
> What's the point?  AMD have said that TCE doesn't exist any more; it's a
> bit that's no longer wired into anything.
>
> You've got to get to pre-Zen hardware before this has any behavioural
> effect, at which point the breath of testing is almost 0.

Oh, I did not know that, thanks for pointing it out.

I'll leave it up to Sean whether to pick this up (because Linux guests
still set the bit), just pick up patches 1-2 as cleanups, or drop this
entirely.

