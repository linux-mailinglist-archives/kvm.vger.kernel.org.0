Return-Path: <kvm+bounces-73091-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CHX9Ap/6qmmcZAEAu9opvQ
	(envelope-from <kvm+bounces-73091-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 17:02:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C3253224798
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 17:02:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3A50330774E4
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 15:58:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 406503ED5A4;
	Fri,  6 Mar 2026 15:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GQXZkjH6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712CC3ECBD9
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 15:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772812655; cv=none; b=FPzRLYL9gX4nsqeke0dD8whsCJ2GKV7z8BajD06Hlb0T+IuACyYy8HdefttBCjt6Suy9A2vDMJuCBBdtoJWxMHyHRDTY2r/LHaz0/CfsCcVh+iXqbXXhSFLCT5LETNU+wBFIzzsSZ/2o9NO0D7ErxwnoXbXPoXi7BFbMGDqiWlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772812655; c=relaxed/simple;
	bh=xN/GHYIFBenQ6dbwvffVKRU4ttOhiHEW0puwMhyb9vQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DB9G92VW/Vz5igYT2IeY0dPFnruU9vCTjeKyFxKJ0SvYbQEctZR14vnHtgTLYlIjwA55ik1EkeyZ0SFvq1XG3lKxPgX75b60ChhkDvhPLh03Mja0UUIuJlVYCSFVqPp2ddBMuuRtr533sH5yi+1OpVOxGOHiJFuQpKkMH1HCPpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GQXZkjH6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D718C4CEF7
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 15:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772812655;
	bh=xN/GHYIFBenQ6dbwvffVKRU4ttOhiHEW0puwMhyb9vQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=GQXZkjH6lfr3ftTqtJbINUzsQZXqwz0LXSblW5FUZ2a7jFPJiMRO7ZSlgrkYQx2LI
	 nQfPYUU97tIX4jr+jYKf3jm9zhq5P035fyJEWy+PVkMc7SE9VQDIwqY/i5Upatpo+F
	 zVmM2hBpGd3ILNkkGt4q86U9Mq5FBf4QK+wHTokG8pgC3OK3qh5Puk7h9s+lsbCbAk
	 QBRRmr6TuqlCXOQ5A5ytwdXGn4IFKOfr18D3h1KFBI5EH9s/zoDrGCGw7/691DuMAw
	 WHGY/iTSHEf7bhwLx5umjkCgLCz9BOL603/P057dK0hGYuT4c6jmjqqBMVZkdS5+m1
	 52LWqkDY7XA7w==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b93695f7cdcso1254033966b.3
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 07:57:35 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWGTVPK97akVvKRsPHPz6BdRzgbfoKID57aIZpxVO0nCtk/tW1K89o6fG4EJShIGl6t2Kk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFM9KnoBSyFMUNR29zMq4j7rMdd9Q+sFVfIPYrkwbgy87UNN+v
	0R09EtfP3vByQfdaTMPapbe2KtvOeru9YNWxzPaLpuJBwyTqAZV00gtjyGlAnLk4cpgGRhDK1tW
	42OeZOLdQwKUb4PY9w+Kqt6bP2Jp64TM=
X-Received: by 2002:a17:906:fe47:b0:b8a:f29e:307a with SMTP id
 a640c23a62f3a-b942e051f67mr161752966b.57.1772812653932; Fri, 06 Mar 2026
 07:57:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260305203005.1021335-1-yosry@kernel.org>
In-Reply-To: <20260305203005.1021335-1-yosry@kernel.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 6 Mar 2026 07:57:22 -0800
X-Gmail-Original-Message-ID: <CAO9r8zPpC_S2TAc+Kq2JyRwYN2ctTQohRcciLaJTKMXUj3vX+A@mail.gmail.com>
X-Gm-Features: AaiRm52PkiG3_SwiKwujmtG7snHMkAr5Cz1sX_yOjoc1YSHP4hq77CAoirPMqAg
Message-ID: <CAO9r8zPpC_S2TAc+Kq2JyRwYN2ctTQohRcciLaJTKMXUj3vX+A@mail.gmail.com>
Subject: Re: [PATCH 0/2] KVM: nSVM: Minor post-war fixups
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C3253224798
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-73091-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.958];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid]
X-Rspamd-Action: no action

On Thu, Mar 5, 2026 at 12:30=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> A couple of fixups in the aftermath of all nSVM patches, the first one
> is just a cleanup suggested offlist by Sean, and the second is a fix for
> the test to make sure it's checking #GP on VMRUN not VMLOAD.
>
> In all honestly, I am not sure *why* the test was passing and a #GP was
> generated on VMLOAD with a very large but valid GPA. vls=3D1, so KVM
> should not be intercepting VMLOAD (in which case it would inject the
> #GP). A #NPF is generated on the VMLOAD, and through tracing I found out
> that kvm_mmu_page_fault() returns 1 (RETRY) to npf_interception(). There
> shouldn't be a corresponding memslot, so I am not sure if KVM stuffed an
> invalid mapping in the NPTs, or if KVM did nothing and the CPU #GP due
> to an infinite #NPF loop (although npf_interception() was only called
> once). Anyway, figuring that out is irrelevant to the fixup, which makes
> sure we're actually getting #GP on VMRUN.

The answer is here:
https://lore.kernel.org/kvm/CAO9r8zPZ7ezHSHfksZPu4Bj8O7WTmDfO-Wu8fUAEebDFV4=
EoRw@mail.gmail.com/T/#u.

TL;DR the emulator is injecting the #GP, I didn't catch it initially
because I was tracing kvm_queue_exception_e() and I think it's being
inlined into inject_emulated_exception().

Anyway, ignore this version. I will send a new version with fixes for
#GP on non-existent vmcb12 GPA on top of patch 1, and then the test
patch will be replaced with a minor fix (to actually test VMRUN),
followed by a change to test the new behavior (emulation failure)
instead of #GP. I will probably also rename it from "invalid" vmcb12
to "unmappable" since all these discussions made the distinction more
clear architecturally. The test uses a valid GPA, just not one that
KVM can map because userspace did not create a memslot for it.

>
> Yosry Ahmed (2):
>   KVM: nSVM: Simplify error handling of
>     nested_svm_copy_vmcb12_to_cache()
>   KVM: selftests: Actually check #GP on VMRUN with invalid vmcb12
>
>  arch/x86/kvm/svm/nested.c                     | 23 +++++++-------
>  .../kvm/x86/svm_nested_invalid_vmcb12_gpa.c   | 31 +++++++++----------
>  2 files changed, 26 insertions(+), 28 deletions(-)
>
>
> base-commit: 5128b972fb2801ad9aca54d990a75611ab5283a9
> --
> 2.53.0.473.g4a7958ca14-goog
>

