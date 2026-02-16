Return-Path: <kvm+bounces-71123-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UG9sGqEck2m11gEAu9opvQ
	(envelope-from <kvm+bounces-71123-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 14:33:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D37B7143D64
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 14:33:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 40A43302517D
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 13:32:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 945CC2C08AC;
	Mon, 16 Feb 2026 13:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hLxUKW/c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62E91F8723
	for <kvm@vger.kernel.org>; Mon, 16 Feb 2026 13:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771248733; cv=pass; b=PIt/el3syFV2Ge8XCvT22CybR0pBlBlaMRFbX6k9FBf2WGtT6f8DqkZN3OY744Eq84oq7tEUxyghfpQ5PvN0Q65Z9srSYzS8T1hjDe7+kRcvtJhk9H0+wNMRAYH3tT+Q7f0hZKg/UaKHO8mgNHPDJfuwJwR1kBjw7Ec1PtpFW2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771248733; c=relaxed/simple;
	bh=LmGbuBMM9mMPZgC9VCrTZN3o5Iw2RZSVYw2EZg7byTw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aV8kdNLjO7D+yC7GsjGywhEttiS4KjL7nI+ZdNWFr1qmDUM4+zbcYNxeAUZpjRRhfY9/dDbsYUdfQ9je99jbQCN84zLKOnqoS/JMaqdcU9TvIUbHHshE+Pu4l+AL70OFe6+nUhtRxXqtckQrtQhJBlQ/Dd8jEjPLyKffTcHRFko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hLxUKW/c; arc=pass smtp.client-ip=74.125.224.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-64c31ca77b4so1014054d50.2
        for <kvm@vger.kernel.org>; Mon, 16 Feb 2026 05:32:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771248732; cv=none;
        d=google.com; s=arc-20240605;
        b=NLXTCEi7jXPMjiipScNqG/dSooSPVV1mXmtRRN670xUvFVE7Ngail7gAEJOrqsf4Mi
         MPxJzptnGOHqUWItfMkqZJWYgnz8os39tItgRBo0/brpNYxg/l4BbtplAqvt70MZA9R2
         VyGu4gF0wYvfP1dqA3LGB2dFH+ZLZCkWzA6rZnBmKnrmFtdNFJUEPMatR5APEzltHRz8
         EaTUokWW9gAPDxSwhOKdatWqwGR0bnM08C5xvAstcPVwTWfV+PJHLHtIWaM28L8NAE7C
         gP1ja8Yd0eQFqKl9nMHDtZJsOtOEPXErFP9nPYTIv/YFyOQkMh0Vdc9HMjn6n+5rNjyf
         3Tzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=LmGbuBMM9mMPZgC9VCrTZN3o5Iw2RZSVYw2EZg7byTw=;
        fh=AWyU3kIfT63vN6DHB7BRX4G9P6wgXnrYDQPevXpfMV8=;
        b=NGdSJNxcadPiNovs6IaPRkWKnS0+jyXx4UPUUCZ6CGVG5pCB2XTNTrffOZqQG2V+yJ
         kzicb2cVnvisw9njWFjK/c3qSqjmes+WkDUZpFSWpherpi9UnvWWCwrh8ch1MgIYncDu
         msdxRwB4U1wP8AkkPbB/6JaZ8Ze97Bmzi0/BKV9IJcfVSdfEE6DVApBxnTlb4qJQ/q9l
         3jv6Xs56w4dDfS4vgJBs8c91AejfW01h32nNz6eaVnuhZhZ7L8o2+iRT72gTruisRU82
         B5U5/e+Ai6otEFCbzaA+yuqjAhfjWflOhrm5JuzqPfxTd8DBMvgW7qykQ9RYNJOG0oDs
         g6Nw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771248732; x=1771853532; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LmGbuBMM9mMPZgC9VCrTZN3o5Iw2RZSVYw2EZg7byTw=;
        b=hLxUKW/cQom8Fz3moieSeYVV8zcERnrXNoxCbfFocMUkpJfEqAuAi/pVJSZWnmEtkq
         75yLnuvyPurogTVXWI9InmreJtRgD8QIsJAgKRj2ign/TA7RiyeTvTwuiY/cqUacXlre
         Dx/bWHIIJZuG22pCZvlKdR+KzXnNQHNZeOFOPAYfm87VpxPhIvfFNEQ8P8DX5Dy5aK1S
         AXIXvUn7lPTcW7jjSN8jYFGTjQZEfWOcKpvIxyRONMVIVqdz65h4mRYo2ZNIyO8e3qtK
         5yDQaxGjG5KLA6kgiwS2xuBdlTvDQ8dbgaEbmDiaevJf3HBa76/XK41T05TyNS9XmiQS
         tPJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771248732; x=1771853532;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LmGbuBMM9mMPZgC9VCrTZN3o5Iw2RZSVYw2EZg7byTw=;
        b=UF3Rqm1mjD5EEmVhMxD7LpvgPjikofZzpagYTtsXpMpCXF8rC975EZiOnzCMbnxrMY
         4Kl7qvjxmNuiW/9D+Ey46jpClYKlkW3IKjNWjOYyXRaTrKVyRvVOBbWPxYANn99r8D1i
         3aIYySSZcDtfPVj9GitBd2Dyk0PUNnsdiJrym6ac40kkG55CtBmGBFHuuiyMlNbBopBS
         91YH7wMIis2NfiOQjACVaY3TiplE9PICqH7dDA6+26gUfqHo0+5I/P8G9aQdHmGCHe8e
         Xdw9EvSwYHT3Xe/40GzHu2iU4S7gCwG+AnMfNptm/yG8gHIAyO0l4PHqi0pg0IP0V8LS
         QJxQ==
X-Forwarded-Encrypted: i=1; AJvYcCW51Lknoh+q6QPpz2OGabu/UehTtEQ2Rj4MYLmLXkBjTFhsM2E3+/3b4yR4cDMo8ReAvME=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxqo9Vl8/xjLHnsT+rxWYvKPCZbipiNhT1fCtTXI+6frOnxv8S/
	Fh5FwuzQwKvLfLjXXeFgg0YjhJZ9PQq6+smpOGwjQJTvHjizhBhmIpqW9YYa5sBjXaRPYHPMTSq
	iYpC/uj0CDc4BT2W1kGhzpY29nT59qehHyQoZ/UH20w==
X-Gm-Gg: AZuq6aI7dno49WO+e1laODroTeDb7jjakL88SsGwHjRq5lRZ4Ac8thjwe86Ytgq/EFr
	7Y6YLQxIet6Mt+CzmLmT3ZGkAiGEfYJB6DP3/3WA/RvX3nWgugtKIZm3JTwDDpmrEtMRSv8YQii
	YTeDoZWSaETU4vYwQFGFgTUNR1bFzLjBT6euEAOxPBtfK3LXg5OciSfaS/c6YtGMiqOxQqgosRz
	dpG/8iWHDqvVaNwGfbgh3R5m+vXmpO7/Klh3bywunMszAgUPe3/uNX5zT3EIQFclMsIFUAxnXa9
	upt8Rlt7PhWoZKaFspPY2UIGlifDWrRHUwcRzYG2/ylvKa1h8D8+mICmOJyoMHmBdSk=
X-Received: by 2002:a05:690e:118e:b0:649:6a9b:9902 with SMTP id
 956f58d0204a3-64c21b5b3c2mr5216445d50.65.1771248731837; Mon, 16 Feb 2026
 05:32:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260211153032.19327-1-sebott@redhat.com>
In-Reply-To: <20260211153032.19327-1-sebott@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 16 Feb 2026 13:31:59 +0000
X-Gm-Features: AZwV_Qik7Hb9tvNVxNdB7PyGF3aH47GzKSPZsyoH50sfvOzAKc1pDMKbuGM6PI0
Message-ID: <CAFEAcA--EaA9sGFXRdit0uV-H18u2zpuCAXa-ZczEN66TTWoFg@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] arm: add kvm-psci-version vcpu property
To: Sebastian Ott <sebott@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Auger <eric.auger@redhat.com>, qemu-arm@nongnu.org, 
	qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peter.maydell@linaro.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-71123-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,linaro.org:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[linaro.org:+]
X-Rspamd-Queue-Id: D37B7143D64
X-Rspamd-Action: no action

On Wed, 11 Feb 2026 at 15:30, Sebastian Ott <sebott@redhat.com> wrote:
>
> This series adds a vcpu knob to request a specific PSCI version
> from KVM via the KVM_REG_ARM_PSCI_VERSION FW register.
>
> The use case for this is to support migration between host kernels
> that differ in their default (a.k.a. most recent) PSCI version.
>
> Note: in order to support PSCI v0.1 we need to drop vcpu
> initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
> Alternatively we could limit support to versions >=0.2 .

Patch 1 already upstream; for patch 2 the review discussion
has been on the thread for the v4 version of patch.

thanks
-- PMM

