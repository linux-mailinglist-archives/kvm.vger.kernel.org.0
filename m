Return-Path: <kvm+bounces-72396-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EDcDBj22pWkiFQAAu9opvQ
	(envelope-from <kvm+bounces-72396-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 17:09:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DB5F1DC6B8
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 17:09:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2149C307389F
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 15:57:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A69A941C0D2;
	Mon,  2 Mar 2026 15:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tJw7NUrA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6150D421A0C
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 15:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772466914; cv=none; b=tlw0ku1ZnqqkqthplEE9q/D7HDy85lSU2Wh4UY0g1hoPGmqIuCMdRsWgmjpC9K5aARd4qLanzI59s/xThOCmyArJtsVeJCABehRuWthT0u7t9FM1Wu5auSyXJA4L9/UumAACc26F05LufeSF0OoNfMgD4R/88ZOglqUIHagqKcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772466914; c=relaxed/simple;
	bh=Gv1hAy9n33v3SO1KTwkytbNRNrjnCLcM99zmVWC9nc0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t16dnN0SfkaNO2mFNGppVH+gtZJhz717aJlLsoHGnTFmJnBZVJjRzumcV2noVkCHKfJyzikHfvCVfzdg/QdAmDSoi4nw/abwdV2G4ofpaaWGHN9wj1jFEpOfhlQMGR4CcBzwmQ+0bH1ZdUq2UcLSDIQnCEWVhzzjkqUkNCZdh2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tJw7NUrA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C2AC2BCB0
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 15:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772466913;
	bh=Gv1hAy9n33v3SO1KTwkytbNRNrjnCLcM99zmVWC9nc0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=tJw7NUrA6pPQPPs8TBobFcPwvm/Hd/5to5fmZYhEDQvoaKVMwPMSEaEoF9Niwqa70
	 GznBYZvz3UwZ+USgYSMGnIIoe/buSx0tAdgZrm2SZqqmsszzjE29awGZyPZ5EnOWep
	 I4xG8rdNTY0WUVfE0fbUXpjQZIB43BMmCup1B1WIBz6LuENxsKk0Fkuyub5CBQsVGl
	 6/ptuFUtfVuOmmUPKseRk7nUcruqCkaxWxh9ccOdUwjIMguKfAmgPs62G52aaz1n2U
	 SsWGC5XR467u+AD2n4lDfr5r5ZZJURR94pfm8RI/57TBo0tTYzi056zAZHEPf2C+co
	 FbF/eYTBHiKCQ==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b8d7f22d405so726559466b.0
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 07:55:13 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVsAmeyTsRyV1dRGZf7STco1hUAgMw/9hLzGSUjV8GBG/QJA89KBMXu3XkN9uCMRdM2ygg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJrqyUETVANJPqRi/OI38IxLlfibOV2eQuyWXfvGWgFl5MseMy
	3QYru9T+zdGKaRDj8e92E0SeiZ+UKnd3mH5Yhn+rt1lDpv1xys4jEAAymyqr+X4Hfp8TlWKTKWy
	FsCVMHSXIRbPNP12iKFXFv52eBvF/Ktg=
X-Received: by 2002:a17:906:4fcf:b0:b88:22f1:768f with SMTP id
 a640c23a62f3a-b937659594cmr829969066b.54.1772466912581; Mon, 02 Mar 2026
 07:55:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260302154249.784529-1-yosry@kernel.org> <aaWyHyB91OolxRD7@google.com>
In-Reply-To: <aaWyHyB91OolxRD7@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 2 Mar 2026 07:55:00 -0800
X-Gmail-Original-Message-ID: <CAO9r8zPOYX=cTvM5vqgyXGFW7ko_EJhkZqREd=C9VwUVVN5EgQ@mail.gmail.com>
X-Gm-Features: AaiRm52UY5Mdu9ZwbT1ZrfCgHN9JwKbwLqEa8UVCvdIzROtf0PZduXsXzDeXvVI
Message-ID: <CAO9r8zPOYX=cTvM5vqgyXGFW7ko_EJhkZqREd=C9VwUVVN5EgQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Drop redundant call to kvm_deliver_exception_payload()
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Kevin Cheng <chengkev@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1DB5F1DC6B8
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72396-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Mar 2, 2026 at 7:52=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Mon, Mar 02, 2026, Yosry Ahmed wrote:
> > In kvm_check_and_inject_events(), kvm_deliver_exception_payload() is
> > called for pending #DB exceptions. However, shortly after, the
> > per-vendor inject_exception callbacks are made. Both
> > vmx_inject_exception() and svm_inject_exception() unconditionally call
> > kvm_deliver_exception_payload(), so the call in
> > kvm_check_and_inject_events() is redundant.
> >
> > Note that the extra call for pending #DB exceptions is harmless, as
> > kvm_deliver_exception_payload() clears exception.has_payload after the
> > first call.
> >
> > The call in kvm_check_and_inject_events() was added in commit
> > f10c729ff965 ("kvm: vmx: Defer setting of DR6 until #DB delivery"). At
> > that point, the call was likely needed because svm_queue_exception()
> > checked whether an exception for L2 is intercepted by L1 before calling
> > kvm_deliver_exception_payload(), as SVM did not have a
> > check_nested_events callback. Since DR6 is updated before the #DB
> > intercept in SVM (unlike VMX), it was necessary to deliver the DR6
> > payload before calling svm_queue_exception().
> >
> > After that, commit 7c86663b68ba ("KVM: nSVM: inject exceptions via
> > svm_check_nested_events") added a check_nested_events callback for SVM,
> > which checked for L1 intercepts for L2's exceptions, and delivered the
> > the payload appropriately before the intercept. At that point,
> > svm_queue_exception() started calling kvm_deliver_exception_payload()
> > unconditionally, and the call to kvm_deliver_exception_payload() from
> > its caller became redundant.
>
> Nice!  I vaguely remember staring at this code when working on 5623f751bd=
9c
> ("KVM: x86: Treat #DBs from the emulator as fault-like (code and DR7.GD=
=3D1)"),
> but never pieced together that it was redundant.

Yeah I was confused by that call a couple of times as well, then it
recently confused an AI bot into thinking there's a bug because we
call it for #DB and not #PF. At that point I thought enough is enough!

