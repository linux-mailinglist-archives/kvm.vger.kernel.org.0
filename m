Return-Path: <kvm+bounces-73313-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eJHnCZfjrmmeJwIAu9opvQ
	(envelope-from <kvm+bounces-73313-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 16:13:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A16D23B72B
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 16:13:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 95E44305CA32
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 15:10:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B11DA3D9034;
	Mon,  9 Mar 2026 15:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rzLzpo3L"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B58A3D7D74
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 15:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773069024; cv=none; b=GH2/DixZkdEMOWg7BPTKU1d/yfClaGJ5VCYceXyWUvuj2tRpFoxX7em5u6qJzhGCj+a50TmzriiDH9Wur3dTJyHh0ijNfFWR67abCyNiFYzF90YBIH/BsJ8epVuTmICUw98QTWc7yUDrRj+KH0L3VAxmCXvQP9S9ecGGK1FP358=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773069024; c=relaxed/simple;
	bh=XYNFcrg8ES75ZZJ68Ru5+FbzIGT85gmn7wUB4yP348E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=agmuGIB3GvomhawSFwVQO2UWIKvrGu9KXFkangRD8fGcENizYCJTzIyfeYQ+P+v6JyAaOl7cNNPpqrSHOnkYwJ5ziga2v4SqU8Xbhayljz7GlPbrATYMRTA7GMFeNRkU6MKzThBTW7c/kGNC+PHrYDeddvtgdvQRxcusAGrAMAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rzLzpo3L; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7B6C2BCB2
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 15:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773069023;
	bh=XYNFcrg8ES75ZZJ68Ru5+FbzIGT85gmn7wUB4yP348E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=rzLzpo3LYIQgl06zvhtz2OuddTAIdfDt+0hSLAezzQKELFBgwHxadMsqLaghJ5W/j
	 d1bmAMOG102WYaKPsVvISouZVtpOicByHkJaC0IGiNNMigS5jC+eQCeqoru0VTnsju
	 nv0rGjyN14VBWQPYI7uZkqZAzRIrnXeZifOnzC0pMd8yczKHNc/q7iiNKmI4FPNe6y
	 YyEqE+gxTpt88Cm4q+wuyilGdDw3O/Jl1dF/7CCTQXtR7ym6S3xXCgO9YlnHGGHdsT
	 Rnce5ZMhUeXjew0hBByNxqA8xPP+gDShwwxLIb2GitBJcat6xKIW0IU0nfmQ4Ms398
	 nbv42UTKkmCCg==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b8f97c626aaso1986620266b.2
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 08:10:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXD9tf5C4yB2H57QoAILJnOGo+nxpppx4vvPAcWq6pyfL3x9/L0E4hfLY59dzCMsUI2rwI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4v8EOl5TZCvOVbWBc0wUaCREV/V6stzIUTEZXQF1TPs938laG
	7fMloyAs7pT5S0MWLWVBjVnNSpAUEIDyWF3pjMu4oogSGLy8VyrzdVspVboqHO+dBmGBJk7E+hC
	u+KgA+P4n2pVqmlZ1UmUPjwsKXe1uyX4=
X-Received: by 2002:a17:907:9715:b0:b87:efa:8786 with SMTP id
 a640c23a62f3a-b942e05d9eamr710749466b.55.1773069021995; Mon, 09 Mar 2026
 08:10:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260307011619.2324234-4-yosry@kernel.org> <34cbc227-f01f-4d4b-b6ab-19bcb02d7e3c@citrix.com>
 <CAO9r8zOM0OWaFvAQd6FGkCC6WxkVBbQZa10pFm9b-wF1G1A6ew@mail.gmail.com> <aa7h39_Vp6P5TVA7@google.com>
In-Reply-To: <aa7h39_Vp6P5TVA7@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 9 Mar 2026 08:10:10 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMHYmaZcUurJ_nGp14TONY9N8mNNWFsddz9YPSsAsKJXA@mail.gmail.com>
X-Gm-Features: AaiRm53KTolJTg0h7BvuOVHKEWMYu_8CY-t3ovOiC-vuj_wswFnK6eE5yqai8xo
Message-ID: <CAO9r8zMHYmaZcUurJ_nGp14TONY9N8mNNWFsddz9YPSsAsKJXA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: SVM: Advertise Translation Cache Extensions
 to userspace
To: Sean Christopherson <seanjc@google.com>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, pbonzini@redhat.com, venkateshs@chromium.org, 
	venkateshs@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 7A16D23B72B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73313-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.948];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

> > I'll leave it up to Sean whether to pick this up (because Linux guests
> > still set the bit), just pick up patches 1-2 as cleanups, or drop this
> > entirely.
>
> I'll grab 1-2 and leave 3 alone, at least for now.  It _should_ do no harm, but
> it would really suck to discover that pre-Zen hardware has a TLB bug that affects
> TCE, or worse, affects TCE but only for ASID!=0 translations or something.

Sounds good to me, thanks.

