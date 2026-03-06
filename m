Return-Path: <kvm+bounces-73180-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UC9CB+Jcq2mmcQEAu9opvQ
	(envelope-from <kvm+bounces-73180-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 00:01:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B0E6222877D
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 00:01:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4822D3068D96
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 23:01:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A1ED36164E;
	Fri,  6 Mar 2026 23:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uFm9fNSg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E216303A26
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 23:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772838083; cv=none; b=ldwJDJXLWXPJJXRkiOJJKT+DGxbLo9or69An1HdmbMVTUJehE/g+peizXJJkFvKaT2zgUlkRvV2uZT/ks/jbfd3tZQ5oCDnZT/gu1hgkQsXMdXSbrQoyY9MTikDHcw70st/oc1Tnfsgf3cmvKeqTbgOQPPs85/5JtygoxFH2CCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772838083; c=relaxed/simple;
	bh=I6W4M3U5C0LO6Qa0wQD+xffdC44snBWR6k9ZETyzMq8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f7FhfQxOwUe3hPYvzuvnwURORaE15WU/3g5r7P/8ZtG/Xc9X6RHzmMLUh+me+ntU0Ux5HaUQ6Tjk93yfnLBY5U5dIwnWYVFFQahOQRi5qpwBRal75Gi+RBkpjWHaQk1UeMK9twNmhxIDGQwW2AX9k+ffDBiN8kXL0noElfFig54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uFm9fNSg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26FBDC2BCAF
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 23:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772838083;
	bh=I6W4M3U5C0LO6Qa0wQD+xffdC44snBWR6k9ZETyzMq8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=uFm9fNSghCtzNU6IwzWjxD7jHiD0e1BHsT3A1C0iXE/fNN36ftmqADZDIaXSAz3oS
	 KohUdi1rjT5ZOLCQpDqVb0rof03FBiMKRWaghNJwAEvAwd6uong7ucGNvPUJKJ4SJQ
	 rZs3G9Q6C0orV+s582Qkz6NEqGxdPX3CvcXE/y4jo1DI7Zq0AUmmQatSAUtiSh86aL
	 Q6TxNShvzx5L2exaT2/Rg432PNUq5PRxMq7ggoatm+UgrZLb33oA5hq008V0xqY/bM
	 zwwg0/h3UjVWlOogEspWX9yAZW5lv+eXwDMVJj1QZF3l6kc5gjzBS3TYUTD1ZmvKNX
	 npkg5mF+x7O5g==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b9424501589so241411766b.0
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 15:01:23 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV74/8NYnxLaz3bngQbOGDRSBciMYmhUPRls2ux3XnM3Mvln0Gsel7wKoFPPoDCp0bOCpQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzemnYcj39RMZX30mlaIeweDTaBB7Oxe/TI+BvSznb+Uq1LT9P
	ba1so4iKFemAGYfs4QCnR8a0vzqnxefqfGtE9GE/Wode6rnNB805Eliv06Cioxj+4xE79SfJxuB
	XUehPVaeUnIGlvPA96KcH8pHv/Jm/xXw=
X-Received: by 2002:a17:907:72d3:b0:b94:2025:313 with SMTP id
 a640c23a62f3a-b942dfb4897mr213053266b.32.1772838081828; Fri, 06 Mar 2026
 15:01:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260306002327.1225504-1-yosry@kernel.org> <aar-gDulqlXtVDhR@google.com>
In-Reply-To: <aar-gDulqlXtVDhR@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 6 Mar 2026 15:01:10 -0800
X-Gmail-Original-Message-ID: <CAO9r8zO+sTttrKscx+9Sr+TECLrb5rHFTPThHYZG_e1qKSo+Cg@mail.gmail.com>
X-Gm-Features: AaiRm50vs2swz70u_HTOWE3CocsBXlJIjpWCDx3VaNJ77hVJzkg-sWu0PcGCIw4
Message-ID: <CAO9r8zO+sTttrKscx+9Sr+TECLrb5rHFTPThHYZG_e1qKSo+Cg@mail.gmail.com>
Subject: Re: [PATCH] KVM: SVM: Propagate Translation Cache Extensions to the guest
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Venkatesh Srinivas <venkateshs@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Venkatesh Srinivas <venkateshs@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: B0E6222877D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73180-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.950];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

> Hrm, I think we should handle all of the kvm_enable_efer_bits() calls that are
> conditioned only on CPU support in common code.  While it's highly unlikely Intel
> CPUs will ever support more EFER-based features, if they do, then KVM will
> over-report support since kvm_initialize_cpu_caps() will effectively enable the
> feature, but VMX won't enable the corresponding EFER bit.
>
> I can't think anything that will go sideways if we rely purely on KVM caps, so
> get to something like this as prep work, and then land TCE in common x86?

Taking a second look here, doesn't this break the changes introduced
by commit 11988499e62b ("KVM: x86: Skip EFER vs. guest CPUID checks
for host-initiated writes")? Userspace writes may fail if the
corresponding CPUID feature is not enabled.

We can still pull the enablement to common code, but
kvm_setup_efer_caps() still needs to query the host CPU features (i.e.
boot_cpu_has()) AFAICT.

