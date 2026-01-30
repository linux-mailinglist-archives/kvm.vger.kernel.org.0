Return-Path: <kvm+bounces-69692-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6Ik3ARx+fGk8NgIAu9opvQ
	(envelope-from <kvm+bounces-69692-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 10:47:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 49A0CB9060
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 10:47:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 86E5A30138A0
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 09:46:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3746352940;
	Fri, 30 Jan 2026 09:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I1TC7iju"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF513033C6
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 09:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769766411; cv=none; b=bucbYVDTAscs/NsgFMog8WQKcNdFa8k0vON/zkoutu3ZlQxH1LDiA737Fw1k/ZEkkXbRR9wPrLzyre4ZS307iG20LK9nu5v416uLfJ4Jk8YPF4Kna7XxaqRG8K8AlnvWnZE5b6kLs0DAOy+FcTPD9EUczzgHHJU9m1KjpTT000s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769766411; c=relaxed/simple;
	bh=0Oj5NX16mK8aX0rpuH1UQUMGWP9VQ2RZPyEuLMLuyVk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q/dRvfvi/hG7jkXedEN3F6vXrw8xriuvNJKrgzAueI1wWJGFZYic9uzcuBCITmynBx3majckcs8Mq7SHq2VF30r/ONLqyW1nIAd8NjP1MQYx8FtY3ynXsg996OrCw5zbg3FuD2vz7tcyBpRXQJ0OCV9MzqPjQhvwVDG9fs7Z2uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I1TC7iju; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FB0C4CEF7
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 09:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769766410;
	bh=0Oj5NX16mK8aX0rpuH1UQUMGWP9VQ2RZPyEuLMLuyVk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=I1TC7ijumAj8DsJXPlmxVB6WL95glhAFnjUWXIrKRBMKc2kt7tdn4D2VFxcZV+fTy
	 mXGKZpMrz1fekwEOjVq5m0Kg4vkcBPRh7X/6ai7hamP2780i4CQUnBNb5VZSHfp68A
	 0OPgBxWRjYhaDP/Y546dMxamk7gRr2oyWZIjqZbWtAsOaK1Pcu7qcsERMKb0EvhH7E
	 QvWtsEWchWzzZfiSYHbOBzwLGi+2I0o/VpLZ3DEx5ZeCmIMFctvCX/N3j+ZOm7mKhW
	 41UDwNUre/faD3uaOmfHMoEV5atxSvIXxLJ54VhFImQG4jZ/wFty9wZM32G0+3FlTh
	 gS3KPgCwwRSmw==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-64bea6c5819so2735821a12.3
        for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 01:46:50 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXgTa9EVmM+/VfjIJ/M5whdk+o2LHgOCgpI/Ey6N1zpjcLpjJ5PndMJNglwa3CnbLf5X0g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0okGCnirjlr2wZ9/taemdAyFtEKlnZRUuBTO/5wv4mKXRlaAo
	MTFYivrhS1CSTlmc/NQAiy0s3DzrrdMv9sI9khQJakuH9fjL6XJdOGwIq386Hms5CHx1BTWaFR0
	uSqT6zVzT21LG77v2gixfLWrUixUVzqY=
X-Received: by 2002:a17:907:2d0e:b0:b8d:c364:5e28 with SMTP id
 a640c23a62f3a-b8dff7242cemr142155366b.63.1769766409219; Fri, 30 Jan 2026
 01:46:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260128030326.3377462-1-maobibo@loongson.cn>
In-Reply-To: <20260128030326.3377462-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 30 Jan 2026 17:46:38 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4E2k2-yQ0o_N5nD+weBufXdU7vwKCD_1CtPFcaGn-9Cg@mail.gmail.com>
X-Gm-Features: AZwV_QiRAh8hWh60Gwnp0hXtY-Juzg802KMhs4qdhuuD3B_g-g6yRay1eBmUiZQ
Message-ID: <CAAhV-H4E2k2-yQ0o_N5nD+weBufXdU7vwKCD_1CtPFcaGn-9Cg@mail.gmail.com>
Subject: Re: [PATCH 0/4] LoongArch: KVM: Code cleanup about feature detect
To: Bibo Mao <maobibo@loongson.cn>
Cc: WANG Xuerui <kernel@xen0n.name>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69692-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chenhuacai@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 49A0CB9060
X-Rspamd-Action: no action

Series applied, thanks.

Huacai

On Wed, Jan 28, 2026 at 11:03=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wro=
te:
>
> Here is code cleanup about feature detection, there is feature
> initialization about host machine, feature checking about VM and host.
>
> Also add register LOONGARCH_CSR_IPR during vCPU context switch, though
> it is not used by msgint driver now, it is defined by HW and may be used
> in future.
>
> Bibo Mao (4):
>   LoongArch: KVM: Move feature detection in function
>     kvm_vm_init_features
>   LoongArch: KVM: Add msgint registers in function kvm_init_gcsr_flag
>   LoongArch: KVM: Check VM msgint feature during interrupt handling
>   LoongArch: KVM: Add register LOONGARCH_CSR_IPR during vCPU context
>     switch
>
>  arch/loongarch/include/asm/kvm_host.h  |  5 ++++
>  arch/loongarch/include/asm/loongarch.h |  2 +-
>  arch/loongarch/kvm/interrupt.c         |  4 +--
>  arch/loongarch/kvm/main.c              |  8 ++++++
>  arch/loongarch/kvm/vcpu.c              |  6 +++--
>  arch/loongarch/kvm/vm.c                | 36 +++++++++++---------------
>  6 files changed, 35 insertions(+), 26 deletions(-)
>
>
> base-commit: 1f97d9dcf53649c41c33227b345a36902cbb08ad
> --
> 2.39.3
>

