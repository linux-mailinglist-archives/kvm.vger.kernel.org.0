Return-Path: <kvm+bounces-73175-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uDJ9BtRWq2lpcQEAu9opvQ
	(envelope-from <kvm+bounces-73175-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 23:36:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D6E8228582
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 23:36:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CD22B302732B
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 22:36:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0B6A35B64B;
	Fri,  6 Mar 2026 22:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dYCwAKsR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030DF3502BA
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 22:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772836558; cv=none; b=RbkpDHZ2icdYRAQcPyhTUhCUC4lRKJndZ5SufF8B6Xh8XP2NFQ/CzEx8PzBjB4ZVc8gP6CZn7JxHfpvYXXEmhW53P4mkHbb2CuXtbi+s7xk1iLLIwHwA1ZhYW7hNOxT8pB75Y9wKKZlzaUGNM3JG0yDuu5M5G+kLtAWgwHfJDyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772836558; c=relaxed/simple;
	bh=yhFwx2Kz/wuz0xCLNknLO5zcU3ngylRA1PODAFgzVp4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tMrZPEOAznIMCZtT6rfnbVIdPMs2jjAryeI4X59yWcLejnUpgPlxiOXZQttOc9EUhElycE0iXiE1THbRuo2ueIU1RFrmI2BBCWNaew278oQR16/DAX/t8TkcGittMgUeqG5eRO46w2iH2xrDAzVwola/SZbmA1LFzHGey9njGkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dYCwAKsR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4ACC4AF09
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 22:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772836557;
	bh=yhFwx2Kz/wuz0xCLNknLO5zcU3ngylRA1PODAFgzVp4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dYCwAKsRHkdKcUo9eFKWkE43fWMAS6HBdD4JUPn+ZgPFuI/BLZrQCf+8o6nWsNoAQ
	 OzzuSg19kHNKZ6/fypmFcFtMW64S5ccdQgNnma4gIj7YLGStu1gJriZsvTnFplgw6f
	 LPloa4nClSFz6KuGfIKAK2atI0oaIgACUDNAlDqSbf6o+qIiN5Ob13gkMcBQorNSfW
	 tIjmf7aZpfaESfrLbwV2aoiVhzeGOwP16SIkt2bHe+k+N54S7quZseFl3J8x3YDMC2
	 qUEnX0TYjzB8VcjuSO6ABruFQPlXs3oyGA2xyABoGOQMqSGvBA/FEuZYB+4IgZOxdP
	 XwezaPky3wRrg==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b9419139eb7so271249566b.2
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 14:35:57 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUopdNWNqzDfbm95DuScZn4FLkDJ2STHBOORqoBGFosm7rYAz1R65pCjlVOcO0oMdOipvg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMbX/KjpLvjhqB5hl2TsxsJviFWfm4zhtYIlAzN1etxNvUx0G8
	GF7lGXEyUPRMeOMrgVdKapW0K4qz+TpGWiAfCzVDxoNOZpZkvx3kEU0xcftIND+wX0RssIbLp9H
	mzV7j6viexjA2tIxhd/Bf2/DD0rEOGwI=
X-Received: by 2002:a17:906:f588:b0:b90:7fac:c668 with SMTP id
 a640c23a62f3a-b942dbaca4amr187450666b.11.1772836556516; Fri, 06 Mar 2026
 14:35:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260303003421.2185681-1-yosry@kernel.org> <20260303003421.2185681-27-yosry@kernel.org>
 <CALMp9eSMtzDJn7tGtbj=zLYpcU7Tc7XjcWBRZH7Aa5YihSmN7g@mail.gmail.com>
 <CAO9r8zMhwdc6y1JPxmoJOaH8g1i7NuhPo4V1iOhsc7WFskAPFw@mail.gmail.com>
 <CALMp9eRzy+C1KmEvt1FDXJrdhmXyyur8yPCr1q2M+AfNUcvnsQ@mail.gmail.com>
 <CAO9r8zPRJGde9PruGkc1TGvbSU=N=pFMo5uc78XNJYKMX0rUNg@mail.gmail.com>
 <CALMp9eQMqZa5ci6RsroNZEEpTTx_5pBPTLxk_zOBaA8_Vy4jyw@mail.gmail.com>
 <aaowUfyt7tu8g5fr@google.com> <CAO9r8zPZ7ezHSHfksZPu4Bj8O7WTmDfO-Wu8fUAEebDFV4EoRw@mail.gmail.com>
 <CAO9r8zOV-4Nx7rZxHy8XsK3_X-enGm==Unj1NiiaaM2EuxK2WQ@mail.gmail.com> <CALMp9eQ9uf09NuTsafC+y1VEUSp-kVtfosJS424bxiySfHqhuw@mail.gmail.com>
In-Reply-To: <CALMp9eQ9uf09NuTsafC+y1VEUSp-kVtfosJS424bxiySfHqhuw@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 6 Mar 2026 14:35:45 -0800
X-Gmail-Original-Message-ID: <CAO9r8zOBpkK-fjnW-69swdmbX4LLSHYCE3=jV+D-zYh7w7x-jw@mail.gmail.com>
X-Gm-Features: AaiRm50UITwiBahFLPZPLX_x3AdFvXksTPZspXU8n_5RyADGRpBe6Z3Y5b4QUuE
Message-ID: <CAO9r8zOBpkK-fjnW-69swdmbX4LLSHYCE3=jV+D-zYh7w7x-jw@mail.gmail.com>
Subject: Re: [PATCH v7 26/26] KVM: selftest: Add a selftest for VMRUN/#VMEXIT
 with unmappable vmcb12
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7D6E8228582
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73175-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.950];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Fri, Mar 6, 2026 at 2:15=E2=80=AFPM Jim Mattson <jmattson@google.com> wr=
ote:
>
> On Fri, Mar 6, 2026 at 9:54=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wro=
te:
> > Actually, not quite. check_svme_pa() should keep injecting #GP, but
> > based on checking rax against kvm_host.maxphyaddr instead of the
> > hardcoded 0xffff000000000000ULL value.
>
> Shouldn't it check against the guest's maxphyaddr, in case
> allow_smaller_maxphyaddr is in use?

Will respond to the other thread.

