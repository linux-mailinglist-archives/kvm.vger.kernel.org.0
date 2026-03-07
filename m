Return-Path: <kvm+bounces-73187-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kDXAC/Rxq2m6dAEAu9opvQ
	(envelope-from <kvm+bounces-73187-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 01:31:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B3BEA228FE6
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 01:31:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7FC6A30234EC
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 00:31:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0FC426D4F7;
	Sat,  7 Mar 2026 00:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k/icpihP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2083D1DF723
	for <kvm@vger.kernel.org>; Sat,  7 Mar 2026 00:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772843504; cv=none; b=MAX/IN8SgsnIR9s/cvJfom9Mvec1DmUWxoNj10eGefBEeqQQVLM8SEp3qu7PyQCc0VOjzrNlJET00uHeGLSQgWVhIaeZ1qV1+fDsMsZ+cHzb3HHB22+dSJRW+WPNRIVnOSsp+nwo0S8rYWyim6SaFznuTtpp+XSjxvS29vEoJBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772843504; c=relaxed/simple;
	bh=Z3Uqj+qsLmKLg1Vht/YEzdurvSFckZQ+tLUZBnr+scU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DvEp3/31xlyhebOvsmO9YtULE4D/i/VFfBQ4Vc9FCDEs1xUbhVs3uKk3XveQDcbGAJMXZaZhESJ5iOkl9WRAY4OXxSnfLKAOIyzUOemZfrorQyA7xewDGEtJjkqBuT8xBYhryFnUORonLVy/tKGAOa9/gnCCorIU+2Ui4GZnoos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k/icpihP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE07DC4CEF7
	for <kvm@vger.kernel.org>; Sat,  7 Mar 2026 00:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772843503;
	bh=Z3Uqj+qsLmKLg1Vht/YEzdurvSFckZQ+tLUZBnr+scU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=k/icpihPw9MdS0xGXUSiaK+852RrGqXcx25BLyjJTeiBqbNP8RHDilO6ifw5SX8+X
	 SMegB9aFH2gAwuLjMH2TwKjHnOcl50jxLWl4Bd/z40/dH3ZY/ffXu+7j6xmiyRh1LP
	 O4FfsSUG4vPDkZ54f2x/cyGYI/XSlYKkLw8bg48qm8Dnm92uP0kFDAUJkkfYUAVqeF
	 87Du/pvFwbZxESImxbK2jFAyRJ7/WQ81OUlSe7Zr0EqpHNc+yqXHKb5pp6/pG4rTTH
	 7NcEN4pasKOkMJmzHRBkiz/QLsqt0UTu3KdUXK4btr/UVnEa0QtGuHLyHhGp/D51XS
	 /pEpQ1Fw1IcAg==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b8f9568e074so1654395766b.0
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 16:31:43 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUIz3nHHPQA7/i305iiFU1LiRkw8CDly8UwRt9l2Z0e2NvRWx1IQ8eE/RBj85b9qCLUoNE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmLYeLg6ssRlwE8uFSHKd7SootpUto2JxFuPZTKmE6iw4wuMYJ
	2bMJnlUpSffDXzro7O/UYFsCyNu4EE9jhoYHH/EFzOZD6W7uq0BMAA8F237pjAoCSnpuvdhI5ML
	Pid8DNsrq8Wx3KgoFtqYDjkEbEmoIazE=
X-Received: by 2002:a17:907:3f13:b0:b8f:b082:e26c with SMTP id
 a640c23a62f3a-b942dfb2e32mr259539866b.40.1772843502700; Fri, 06 Mar 2026
 16:31:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260306210900.1933788-1-yosry@kernel.org> <20260306210900.1933788-2-yosry@kernel.org>
 <CALMp9eRWwPwUSyQmizy8i2tF1CVO4iLY6x0vX1OoPUiRdCm4NQ@mail.gmail.com>
 <CAO9r8zOhaDeYWq_6TNdPGyEE323o_8xsWTozGdro9Oni8310kA@mail.gmail.com>
 <CALMp9eScswzFak+PMOcaDXM-W+cXtkG7fQ=jadq__+5JeqYcTQ@mail.gmail.com> <aatxQXV-mQX6uE1C@google.com>
In-Reply-To: <aatxQXV-mQX6uE1C@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 6 Mar 2026 16:31:31 -0800
X-Gmail-Original-Message-ID: <CAO9r8zP6KX6GWyCinuPHAkmoBeUG_6Y_o8DU-ety7wTJAEhr+A@mail.gmail.com>
X-Gm-Features: AaiRm53W4X85pXw2N8Oj8007bPx5K6kt_RvQVMy46Pcyd9jHjfuW_Gp36x_aIaA
Message-ID: <CAO9r8zP6KX6GWyCinuPHAkmoBeUG_6Y_o8DU-ety7wTJAEhr+A@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] KVM: SVM: Use maxphyaddr in emulator RAX check for VMRUN/VMLOAD/VMSAVE
To: Sean Christopherson <seanjc@google.com>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: B3BEA228FE6
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73187-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.969];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid]
X-Rspamd-Action: no action

> > > >
> > > > Note that virtual VMLOAD/VMSAVE cannot be used if the guest's
> > > > maxphyaddr doesn't match the host's maxphyaddr.
> > >
> > > Not sure what you mean? Do you mean it wouldn't be correct to use it?
> > > AFAICT that doesn't prevent it from being enabled.
>
> It does, actually.  KVM doesn't support allow_smaller_maxphyaddr when NPT is
> enabled, because AMD CPUs (and now some Intel CPUs, lolz) do A/D updates before
> signalling the reserved #NPF.
>
>         allow_smaller_maxphyaddr = !npt_enabled;
>
>
> And vls is disabled if NPT is disabled, for all the reasons Jim is pointing out.
>
>         if (vls) {
>                 if (!npt_enabled ||
>                     !boot_cpu_has(X86_FEATURE_V_VMSAVE_VMLOAD) ||
>                     !IS_ENABLED(CONFIG_X86_64)) {
>                         vls = false;
>                 } else {
>                         pr_info("Virtual VMLOAD VMSAVE supported\n");
>                 }
>         }
>
> Thus running with allow_smaller_maxphyaddr+vls is impossible.

Oh, well never mind then.. :)

Will switch to cpuid_maxphyaddr(vcpu) in the next version (assuming
there's one).

