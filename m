Return-Path: <kvm+bounces-72734-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QOkIAMZ9qGluvAAAu9opvQ
	(envelope-from <kvm+bounces-72734-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 19:45:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 23FD520691B
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 19:45:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 286DE303A26D
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 18:37:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AB503D75D0;
	Wed,  4 Mar 2026 18:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qxubPyUn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A18739EF00
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 18:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772649463; cv=pass; b=BaI7TFp2wJJEmytw5/PCWJgty/myJ6XotLVwnjqffYghY0yt5JPcu9v9i/E1zFiKzUdceq7mpudTlEwbtWZoXr3hk2nmJnDKt/eDyX8TnsCizG6cDPp/kayLX4UWVb2Z3oM+MbLTmL3vwknpfJmqqYXv4xcS2GuahNWof8TQr/4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772649463; c=relaxed/simple;
	bh=0MAhsQztQctAeKwrF4Xh8Tv+ZEx/NHMxtMK7pSDmIW0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ntGUEp7OnzWBX3aVlpzM/r0oCt9FdTcP4GzCsclUZxJamyVJQvsLia1WinGwviVPwMpallqQVnsFguCJ7klFSXlwnWDojV99oUo0EUVJcbsTPY9VObohODMBheSqP0gbzvgnt0T9NVcS9o1xxDz/lCjr3spBJ7riQU3v02xC3ZU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qxubPyUn; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-65fe2d2b744so1262a12.1
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 10:37:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772649459; cv=none;
        d=google.com; s=arc-20240605;
        b=PZ2gY/YGuq8ZJASKjHm9CCh3zY2U/HA6RL4EgpUyqb8faWtL60B8HyHx6205eQuJ/H
         M4h/vSfUtQsSYN6IYdYlWRqlCsoQyX4f3C3izEn5DX1r/rrIpqJBOYqfcpahxQz/vvUb
         4BVyFzd5KV/aLbhWQXdugP/gEBER5gZkzAWzRnEZqNrGHUM+4gKkmh0TZMc1yugv8wl7
         I9t+KI245Ly5Jhjk4LqV8PMuGDUKZza3KcHqxVHFwNHd3GtKwMeUCIECgVfvUOs4FiDG
         Bmv7OgbpEh9I2VXga4XYEBe979rbRDqH3epqdhtNs/NJA9LnOnoVc59+4RTg22w+K8Z7
         EI2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qyg7JiALUhnTVHTDoz+Wh3a71GEFMfJh5eqsvim4jwM=;
        fh=9uGkSJKawNG94kjKpAjT6y4kRrQVWf4E59v4qknJfbY=;
        b=cBm9M8GM14cye71RY4lZzhsVcoACy2Yxg+I59wEm1BDou+Knh4JPWDk0EbmBPjcMkh
         BkpQc20KKp2dDffDZC+35RZ6x5GYHxWgx1wisqEIHzzhv3DAjc8faQMh8/rrE+/49Zo5
         LQdL7yyU+tlYRAMXj/6th3Czx6lTyelLGL16ZTHJQtXXEEeewuEq9N5Iu/tNVqmLtjyT
         ij2XMDYQUZ4k73F4O7hqKdbaQK09eAwuNpENrptrCowfbuq5y1zQ0nRVmnlx3E6msNaj
         QaR4jT1KweeDN/ZAsNt43khjhQh+g+XA8qfpL43Kb44i0oXUIV3V1A0SSilpIe/fDaqT
         9kEw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772649459; x=1773254259; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qyg7JiALUhnTVHTDoz+Wh3a71GEFMfJh5eqsvim4jwM=;
        b=qxubPyUnFnbLLaAU23PpztVoNAuXiam5j/NDJOMku8iIKyTbHYROy3ykiQrB6F9wMj
         P0nYgvo2c33VhCcxQHlzgUD1XZyRQluRbAe50J/mx7xFL/5X7M5RiWp+esE9/D7Kk1li
         GRcG0tQZTWrMCL0iaKcZdXagKWnQ7+8OIeB++ydCJJoSHXFAUAOETmO4lTykwS8/+o5d
         yXlB+W3BcqAcXABZ6iWUJk8bsXJa0yfNFCAqFA5YTEP5LW9CtIKMSCL1HM1PE0I6WNQB
         rLXqRVPCoRcElg4Wa17eVThd13/aDGiuu7ESK77fychFd+C2PP7VjVksZWqcxVGS6W0Q
         c5Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772649459; x=1773254259;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qyg7JiALUhnTVHTDoz+Wh3a71GEFMfJh5eqsvim4jwM=;
        b=hhUYK1ASCbXK0hbRu60vQpPg6NsrqDll5HvT/xuRjiDyccwvQiqXTTtq4exvQ6IHyk
         bZ4x/80RlwDKiUO/ejHmr9d00avPubcOHgzHOXP1KaFyBnfkQe49HTxvLg1uC+mnsCpD
         5tYL1qLPIdfgkEA51ZuvbRoMaYqfTnC/oaqKdEkv82FmDwT7XF6GRjpgxO03yGd0W5J4
         uZyGLZbNUcUvHwrI7gyD7lgjzUcrmLR4DRA9/GnLzVtu//0uw2rnOBx5Xg0IaK1au1VI
         LhOXCpcS2JvnsEiQ2Z2dUZGv6WiHZdzFp4vBYV9R3GYZ/rlc615Gk5nhDJ44qRyq/hi8
         rugQ==
X-Forwarded-Encrypted: i=1; AJvYcCXyJDsPw6TdCf0MnVgAfueOu6b2tdFvV1YLdGFMfUF8N2CUUOOQp4bL0H5fK6N2Bazs644=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEPs5dgzBh0QmZW+CuAsEIOuRNowVBwXkmIZ6BR0YhoXDx01hU
	eFgM04fCao7lhQ+kXubt8icxtxaurN9KZGdodVFhFfSJNfVXz7PYrJQBaD/GkzXcz6J0d7E3Vjo
	rQlCtcjwYAbnNYJ4RgZTUUYDrdSuQKG2W+MkXjT8q
X-Gm-Gg: ATEYQzxYLogagaaCw5DKg4YOgsDJ/q6bXX9nFaw9D3C7xc9SzNeOGmxV0UdkMMtb5O7
	KcdIV9jdpDJ/j4fxwvyt71czx/9spJ1NMScw6pOutNvdk0csbTuUGlPBB06GICx5bued/ACvIak
	fMXmMNm50/EGmMpj3JMKpm4f3yeLVha0MUiceTWCxXe14v+eDrf1u9YaOSTbKvImviCenzDYeH4
	6BYtiYFKzLCAYdqx+fkFJcnsOMVc686wDmTD8L7y0lZHH3c3EFJleV8UbK0pwPn2hNrh4fy2oVd
	MoZyfu2nWIdOa1nOSQ==
X-Received: by 2002:a05:6402:11c7:b0:65f:76c8:b92f with SMTP id
 4fb4d7f45d1cf-6612a7ac28bmr49817a12.0.1772649458305; Wed, 04 Mar 2026
 10:37:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260224005500.1471972-1-jmattson@google.com> <20260224005500.1471972-9-jmattson@google.com>
 <aahn2ZfDAJTj-Afn@google.com>
In-Reply-To: <aahn2ZfDAJTj-Afn@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Wed, 4 Mar 2026 10:37:26 -0800
X-Gm-Features: AaiRm50YWu54ulNxMcZtc5Mz8kw3MXpfQLRVptEK6Cn1xRR91Wdq3CyvdybtG2g
Message-ID: <CALMp9eR7gKWp8M2Q8Q7vA5hGx5bc12KCh1NZMK33A1dpiKNt+Q@mail.gmail.com>
Subject: Re: [PATCH v5 08/10] KVM: x86: nSVM: Save/restore gPAT with KVM_{GET,SET}_NESTED_STATE
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 23FD520691B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72734-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[14];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Wed, Mar 4, 2026 at 9:11=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 991ee4c03363..099bf8ac10ee 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1848,7 +1848,7 @@ static int svm_get_nested_state(struct kvm_vcpu *vc=
pu,
>         if (is_guest_mode(vcpu)) {
>                 kvm_state.hdr.svm.vmcb_pa =3D svm->nested.vmcb12_gpa;
>                 if (nested_npt_enabled(svm)) {
> -                       kvm_state.hdr.svm.flags |=3D KVM_STATE_SVM_VALID_=
GPAT;
> +                       kvm_state->flags |=3D KVM_STATE_NESTED_GPAT_VALID=
;
>                         kvm_state.hdr.svm.gpat =3D svm->vmcb->save.g_pat;
>                 }
>                 kvm_state.size +=3D KVM_STATE_NESTED_SVM_VMCB_SIZE;
> @@ -1914,7 +1914,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vc=
pu,
>
>         if (kvm_state->flags & ~(KVM_STATE_NESTED_GUEST_MODE |
>                                  KVM_STATE_NESTED_RUN_PENDING |
> -                                KVM_STATE_NESTED_GIF_SET))
> +                                KVM_STATE_NESTED_GIF_SET |
> +                                KVM_STATE_NESTED_GPAT_VALID))
>                 return -EINVAL;

Unless I'm missing something, this breaks forward compatibility
completely. An older kernel will refuse to accept a nested state blob
with GPAT_VALID set.

