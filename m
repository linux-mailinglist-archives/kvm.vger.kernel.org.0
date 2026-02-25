Return-Path: <kvm+bounces-71728-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0B+OOzxNnmkrUgQAu9opvQ
	(envelope-from <kvm+bounces-71728-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:15:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D15F18E933
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:15:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BDAAF304E310
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 01:15:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E8962505B2;
	Wed, 25 Feb 2026 01:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZTv/5NnP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407C91D5ABA
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 01:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982121; cv=none; b=EqpHck8TLmnsAJeWFkSD64P1Q31WXucmcW81syA8oGJrNo41kNPzLgZRMWj3ZhRB30ymXp8rCFQgSvRJqirfOYiFnBDaLGYeEE8a5Vdwwkt9IEj55xj4dt64tG3syw6XFFMQP6X+hiKOL3IL/idrJD5QuzCQIbDTj3zD6VesfUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982121; c=relaxed/simple;
	bh=n+u/0UrOS8wDiRcogIJpySLs5nFd2D9X9CWYEXVo/58=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AzikJLoL8W/JaCzZiIEcSOyFZiyzBG9Uzpy3JpdmlxHLgAQL18YbLyaKSIxTQouBy1AdA+vKcj6qnQEFMgyQ6qV19Ql1QiMzJTYc0wdaKoTJi/Oc0ISTg2ed4/Zep8gpYWlSTPY2UMw6IufgUPbX4gSZrEig/8H91HXQWoK78Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZTv/5NnP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1635C4AF09
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 01:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771982121;
	bh=n+u/0UrOS8wDiRcogIJpySLs5nFd2D9X9CWYEXVo/58=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ZTv/5NnPP1jsDhsKNv2TL8SR6EV2ho0Ti1HGsSXAmP6h1dujSLiZ/R5zKduJruMTk
	 vdHYqZHv3VPssev8Mxr9O8mZfpHngGtKB3WzDRGRtm6WY3Z4EqLCb8wukGTBWWMSGS
	 ZI12w763hWWz/Qgn+RtfES6IbKFn2/ZkQoIRbVcMoTQXC8waOj/Py4CacPbYJOvLk1
	 mAQ70Rc+fj81IvRzUSMrs/MV4YfuwezQdQJyVue3ByEcU5hF5LJYqcDLXtIMQhXSin
	 nNaOQ4NTXicSfgf1s3twoGlECW5TGUk9aLFQdKX7uni/e1UrUwM+Om0D/aE8zwr+v5
	 vRn4sSWN0CeiA==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-65c0d2f5fe1so10702741a12.3
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 17:15:20 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUYzrpxtlbOswlRxW3/PSE4IYttwJR+2bzkHTpKvWgdxL/E+7qyVX+6/MeKzS+DjMyiEx0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsdRaInFLPe0JUyQ78slrSM4A/VFvRWL17uzyEKSzlPIcLaxbq
	CjqpNfQAtTE0rxTTxzGNN7/LZkq754SvboHwnB5bFfZNkFf4p7/PbqrGDpHM59gYaHU5vvzmELa
	lAxJV5Bc674rYxhHdXzfcu/hK8LV2Vzc=
X-Received: by 2002:a17:906:eec7:b0:b88:68b6:e578 with SMTP id
 a640c23a62f3a-b9081a56f6dmr969898966b.25.1771982119795; Tue, 24 Feb 2026
 17:15:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260223154636.116671-1-yosry@kernel.org> <20260223154636.116671-3-yosry@kernel.org>
 <CAO9r8zPsAMaiU794xoXDso3sdAM0_EN2PyE13vR4NqqEh9e2=g@mail.gmail.com>
 <aZ5ItfEUtIlVbzuQ@google.com> <CAO9r8zPbu1BsOsPU02YcCLDbRXZoDmVd8XiMHssSDnkjdDPC4g@mail.gmail.com>
 <aZ5MF8_RK56C8B9Q@google.com>
In-Reply-To: <aZ5MF8_RK56C8B9Q@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 24 Feb 2026 17:15:08 -0800
X-Gmail-Original-Message-ID: <CAO9r8zO+Eej0AjzQt6dnELKLKHZ33DGLbDv=_sP1J1qLMVWpvw@mail.gmail.com>
X-Gm-Features: AaiRm51zZM0Is3b-LtBf4aQZAOknKs6HKlrafyNxEOqS0N8mFqZNFzIg8jKGQN0
Message-ID: <CAO9r8zO+Eej0AjzQt6dnELKLKHZ33DGLbDv=_sP1J1qLMVWpvw@mail.gmail.com>
Subject: Re: [PATCH v1 2/4] KVM: nSVM: Delay stuffing L2's current RIP into
 NextRIP until vCPU run
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
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
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71728-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Queue-Id: 9D15F18E933
X-Rspamd-Action: no action

On Tue, Feb 24, 2026 at 5:10=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Feb 24, 2026, Yosry Ahmed wrote:
> > > > Doing this in svm_prepare_switch_to_guest() is wrong, or at least
> > > > after the svm->guest_state_loaded check. It's possible to emulate t=
he
> > > > nested VMRUN without doing a vcpu_put(), which means
> > > > svm->guest_state_loaded will remain true and this code will be
> > > > skipped.
> > > >
> > > > In fact, this breaks the svm_nested_soft_inject_test test. Funny
> > > > enough, I was only running it with my repro changes, which papered
> > > > over the bug because it forced an exit to userspace after VMRUN due=
 to
> > > > single-stepping, so svm->guest_state_loaded got cleared and the cod=
e
> > > > was executed on the next KVM_RUN, before L2 runs.
> > > >
> > > > I can move it above the svm->guest_state_loaded check, but I think =
I
> > > > will just put it in pre_svm_run() instead.
> > >
> > > I would rather not expand pre_svm_run(), and instead just open code i=
t in
> > > svm_vcpu_run().  pre_svm_run() probably should never have been added,=
 because
> > > it's far from a generic "pre run" API.  E.g. if we want to keep the h=
elper around,
> > > it should probably be named something something ASID.
> >
> > I sent a new version before I saw your response.. sorry.
> >
> > How strongly do you feel about this? :P
>
> Strong enough that I'll fix it up when applying, unless it's a sticking p=
oint on
> your end.

It's just that 99% of the time someone is reading svm_vcpu_run(), they
won't care about this code, and it's also cognitive load to filter it
out. We can add a helper for this code (and the soft IRQ inject),
something like svm_fixup_nested_rips() or sth.

We discussed a helper before and you didn't like it, but that was in a
different context (a helper that combined normal and special cases).
WDYT?

>
> E.g. one thing that I don't love is that the code never runs for SEV gues=
ts.
> Which is fine, because in practice I can't imagine KVM ever supporting ne=
sted
> SVM for SEV, but it adds unnecessary cognitive load, because readers need=
 to
> reason through why the code only applies to !SEV guests.

