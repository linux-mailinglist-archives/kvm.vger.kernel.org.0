Return-Path: <kvm+bounces-72197-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id II4LLWTaoWlcwgQAu9opvQ
	(envelope-from <kvm+bounces-72197-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 18:54:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 594501BBA9E
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 18:54:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1B7AA307171F
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 17:53:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 332C43644A7;
	Fri, 27 Feb 2026 17:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BZjGZt++"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64754362149
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 17:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772214811; cv=none; b=YpIAXbPP5DXzDzQnQlgDyfAN8+Se5yOlTOP15c9X09+AhBNXV0kxCtRnLpxsmJ2eVVliYciFxap6e6htgChWxznqWnuyHm9uyNAnk3B67eYWIpHgC6mQPdDqqi9L97Ybp5hONv/XoFfMX7Rpzmo4UYGG8uDY871L0BJYqVXurt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772214811; c=relaxed/simple;
	bh=60SX2zWL+Wq1e+4Vk7xvhndhMSeEdai/dASP3FehDq8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aYZTZrXESdyp3wcJoY73KpPAkV4S555BvWFw+e+9HG+dYeay87zcYLPzxPqD93SMMSuwvAPareeTHKHjCQ7iEKYzyLETgD3PowRP39/GQAPxIcYBv1g1r5TWPtNBi5I6qdMe0EQ2vYCBdroWcena3ejpmRQlpEjLZa/WzCpO9c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BZjGZt++; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232F7C2BC86
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 17:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772214811;
	bh=60SX2zWL+Wq1e+4Vk7xvhndhMSeEdai/dASP3FehDq8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=BZjGZt++BTRI3erlmM7x183VtO8pZCeaqSwJa9JDG2leABbdgQkNMTr9P9ENk4bds
	 7R7EwykL9xkGzzJX4Q2mxw3kNk9j1YJ+sxqUhUV+AY56QJ8inViWK2nJKbS344lQ0H
	 r7ZcWhh1ILS6yInqepfYis4mxyjILWc36W0H/7KIcs8bxbapUiwFLkOdXBCJpYpwZS
	 SkaF7UFDPF/dsqcYby0wamIhAKQLyv3ibvaZF1xkwU1u9MRIkgaFLiF58SN1K3NJzg
	 d5puyvxEdCPcFjGYU8d6vKOunriEVuz4oum9RZBSxZVri8GwHhyZvLigNKn3I2a96y
	 SsysWv73bwOyA==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-65c20dc9577so4276666a12.2
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 09:53:31 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXG+ZoMMBWkgd+nNCl9Px9LnGOls4E76RBIYwnp2JLDjp+3TYDPXegMneG0ErD+bB+0BLA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxx1XC96BUX+NbWWVo2sqrR8WSXHDhmmabo+tS4kGXAD7dfSuL8
	XrPZXlvAhJYWkJrRj8hl6xVlafMccdvirn5bupgxAYGiydh0Bza9L07XjuXER+Ec2QHAqTTZPj0
	vHzTCyT+2wj5/ynpNAUlV0kYj0uaBxEI=
X-Received: by 2002:a17:907:6d0b:b0:b8d:bf4d:7458 with SMTP id
 a640c23a62f3a-b93763b8264mr223114066b.24.1772214809964; Fri, 27 Feb 2026
 09:53:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260225005950.3739782-1-yosry@kernel.org> <20260225005950.3739782-3-yosry@kernel.org>
In-Reply-To: <20260225005950.3739782-3-yosry@kernel.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 27 Feb 2026 09:53:18 -0800
X-Gmail-Original-Message-ID: <CAO9r8zMJ8rvzS00eXJ7RPkRPicg2BwB4eq+xVtKXFWn5ZUamUw@mail.gmail.com>
X-Gm-Features: AaiRm52wbA11YYfysglrUdod8DsiSganDwwCeS7nycMRcmW5SXwBFu27b11_Ayk
Message-ID: <CAO9r8zMJ8rvzS00eXJ7RPkRPicg2BwB4eq+xVtKXFWn5ZUamUw@mail.gmail.com>
Subject: Re: [PATCH v3 2/8] KVM: nSVM: Sync interrupt shadow to cached vmcb12
 after VMRUN of L2
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72197-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 594501BBA9E
X-Rspamd-Action: no action

> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index de90b104a0dd5..9909ff237e5ca 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -521,6 +521,7 @@ void nested_sync_control_from_vmcb02(struct vcpu_svm *svm)
>         u32 mask;
>         svm->nested.ctl.event_inj      = svm->vmcb->control.event_inj;
>         svm->nested.ctl.event_inj_err  = svm->vmcb->control.event_inj_err;
> +       svm->nested.ctl.int_state       = svm->vmcb->control.int_state;

FWIW, this is an incomplete fix. KVM might update the interrupt shadow
after this point through __svm_skip_emulated_instruction(), and that
won't be captured in svm->nested.ctl.int_state.

I think it's not worth fixing that case too, and any further effort
should go toward teaching KVM_GET_NESTED_STATE to pull state from the
correct place as discussed earlier.

