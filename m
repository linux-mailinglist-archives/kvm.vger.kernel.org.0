Return-Path: <kvm+bounces-72398-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eJ/YGfq1pWkiFQAAu9opvQ
	(envelope-from <kvm+bounces-72398-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 17:08:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D748D1DC673
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 17:08:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 02449308C593
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 16:04:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6D1F40149C;
	Mon,  2 Mar 2026 16:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E+v5ilfp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9A23603D4
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 16:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772467380; cv=none; b=P5nvbKOAQL2Ys5fz7WVFaZAm/AlEsjEHtSusUnKAcZzcqRBZ466JMBpvycnPhZYd5wh3ziyheDXmnmqgah3afGZUXqJU/abWJKjwgzao0vi5/LsHoiYwm3ySa99vJHRQh+xUJ57ka6ZTlolEHXoZV0At+poXHyjAFiu/YPWEjHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772467380; c=relaxed/simple;
	bh=x+S0GQMfmr/lSbc+D4zHvln2sig1ozKiD35K43MESKw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TxqUBPxADSefnJ0Gm0VbKVWuIbv6WS0gUFLUbTkyybPht5en+7ahLR14YigEFiproKsosCzj7Nm/bbbMBOUJEHoLID6CSE77xwtJt+DdP+Ur7OkSwmuINpL2es2BVaUgbBNNaYI0u4CAUBZTmx50dhZ7i1RsbKi2XBg27uKyvGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E+v5ilfp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA67CC19423
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 16:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772467379;
	bh=x+S0GQMfmr/lSbc+D4zHvln2sig1ozKiD35K43MESKw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=E+v5ilfptjxxLejchysjpG/9n8t4rpNuVknsBpnOOyIU7LbqfkozqIuAGOneIM2Ai
	 ngj2bmAyCakVJbg6J11COZZAZbbVDwgEl+mLjs9f64CK6ys+BFIyV6FzvW/8rAU8gV
	 qN1GTD3P/aiVo8rFxIzk+vu4yv7h1MkJhmfPSzaCtHPdHuFqRmlufbWGr4SOdLUpKE
	 Dc4q7q+1GjNpO6m297Cqd1ikFoSa0QiR/wQcy/+paT9ApexvgdmIEy5RGCOegKOOaY
	 Fnv0993cZAMKnZvcF1O2T9N9VTCb0REzJX3ZBvtg1Sp+D3HTCRxBnZT3c4bVp6oC6v
	 DWMKICGEiK7TA==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b93695f7cdcso527057866b.3
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 08:02:59 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUprK6nl35OLbcVSi7T9auncx1TfyaKKLzAtIfbJCH3u+mMFlE86/X1nQyKB0wW4gprHy4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwR3nZ4AMaiqPKem0tSAE7po3NTEvAoPPc313/olbf/napVVk+c
	0j3znfxc21A3jz7kBmLqJYma/xFnC85GS0g2GwCk04TISRyVvaajrjl2TFRnOUi2uRFjXcgmKpR
	G6a6WF6r+ZDcLuI81GQry9IK+L8zNlDo=
X-Received: by 2002:a17:907:d20:b0:b88:48ba:cdd with SMTP id
 a640c23a62f3a-b937652bdd8mr801240966b.43.1772467378484; Mon, 02 Mar 2026
 08:02:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260224223405.3270433-1-yosry@kernel.org> <20260224223405.3270433-17-yosry@kernel.org>
 <aaIxtBYRNCHdEvsV@google.com> <CAO9r8zMRkFfxm_zs88uc_ijARrU4XxHQQZAQFmC_t0H9qdbM-A@mail.gmail.com>
 <aaI_XogE98GvJjAU@google.com>
In-Reply-To: <aaI_XogE98GvJjAU@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 2 Mar 2026 08:02:47 -0800
X-Gmail-Original-Message-ID: <CAO9r8zP-chd6VcS5zGgU=g_AWAu9ytqnxzemQ9BKdV61rRHimQ@mail.gmail.com>
X-Gm-Features: AaiRm53-1AXUYFs4ixMjDlmhaA3cQcnhMekzIIFzh8IR8IGzErRKc2L-bOAzrSM
Message-ID: <CAO9r8zP-chd6VcS5zGgU=g_AWAu9ytqnxzemQ9BKdV61rRHimQ@mail.gmail.com>
Subject: Re: [PATCH v6 16/31] KVM: nSVM: Unify handling of VMRUN failures with
 proper cleanup
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: D748D1DC673
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72398-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Action: no action

> > As for refactoring the code, I didn't really do it for SMM, but I
> > think the code is generally cleaner with the single VMRUN failure
> > path.
>
> Except for the minor detail of being wrong :-)

I guess we're nitpicking now :P

> My preference is to completely drop these:
>
>   KVM: nSVM: Unify handling of VMRUN failures with proper cleanup
>   KVM: nSVM: Refactor minimal #VMEXIT handling out of nested_svm_vmexit()
>   KVM: nSVM: Call nested_svm_init_mmu_context() before switching to VMCB02
>   KVM: nSVM: Call nested_svm_merge_msrpm() from enter_svm_guest_mode()
>   KVM: nSVM: Call enter_guest_mode() before switching to VMCB02
>
> > I am fine with dropping the stable@ tag from everything from this
> > point onward, or re-ordering the patches to keep it for the missing
> > consistency checks.
>
> And then moving these to the end of the series (or at least, beyond the stable@
> patches):
>
>   KVM: nSVM: Make nested_svm_merge_msrpm() return an errno

I don't think there's much value in keeping this now, it was mainly needed for:

>   KVM: nSVM: Call nested_svm_merge_msrpm() from enter_svm_guest_mode()

But I can keep it if you like it on its own.

>   KVM: nSVM: Drop nested_vmcb_check_{save/control}() wrappers

This one will still be needed ahead of the consistency checks, specifically:

> KVM: nSVM: Add missing consistency check for hCR0.PG and NP_ENABLE

As we pass in L1's CR0, and with the wrappers in place it isn't
obviously correct that the current CR0 is L1's.

> > If you mean drop them completely, it's a bit of a shame because I
> > think the code ends up looking much better, but I also understand
> > given all the back-and-forth, and the new problem I reported recently
> > that will need further refactoring to address (see my other reply to
> > the same patch).
>
> After paging more of this stuff back in (it's been a while since I looked at the
> equivalent nVMX flow in depth), I'm quite opposed to aiming for a unified #VMEXIT
> path for VMRUN.  Although it might seem otherwise at times, nVMX and nSVM didn't
> end up with nested_vmx_load_cr3() buried toward the end of their flows purely to
> make the code harder to read, there are real dependencies that need to be taken
> into account.

Yeah, and I tried to take them into account but that obviously didn't
work out well :)

> And there's also value in having similar flows for nVMX and nSVM, e.g. where most
> consistency checks occur before KVM starts loading L2 state.  VMX just happens to
> architecturally _require_ that, whereas with SVM it was a naturally consequence
> of writing the code.
>
> Without the unification, a minimal #VMEXIT helper doesn't make any sense, and
> I don't see any strong justification for shuffling around the order.

Yeah that's fair.

