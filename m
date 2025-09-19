Return-Path: <kvm+bounces-58138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DFA62B890CF
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 12:35:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CB637C7970
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 10:31:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B81643081DC;
	Fri, 19 Sep 2025 10:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jbevbhjY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45622F9DBE;
	Fri, 19 Sep 2025 10:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758277767; cv=none; b=EmeqoZbxgP2QtaYL0bLAkMOQgSRsTDzaQ51ZncCGkguu3I1y8N+ayQzIK1pRlZT7T2q6LFJa/r5zPEULOxCKZBbqoibdc31zp+iUDP0j+uWj87Wd2G1381zs6hRT0ivAdEN7C9KcLDx0iBfp7ESKOKxNqORmg2SzpWXDSqvGEcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758277767; c=relaxed/simple;
	bh=GSm6LeWENKsElYI1rCQgxDl1aE0oGrk6Ua++05A6rdE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V5weG3Mz5Ia0J97w+WKHo1cWbBzlWOA+Bdc1wcdSxGo2zp+1bbogPnfVpereO5CcWZMUOw0E5P1p/cZFtw+gufZrOEHrY2m55bxmQ/Ln537L9KIzp2VNisOjRIFGe8k0dhC/j28GuvIVy9CcmDO/qubwrf2NKGkR31bthFrTVZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jbevbhjY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C964BC4CEF1;
	Fri, 19 Sep 2025 10:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758277767;
	bh=GSm6LeWENKsElYI1rCQgxDl1aE0oGrk6Ua++05A6rdE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jbevbhjY7CbWt9mDLYFM0dhqYNR+xwwkK1UFJ2rU4MQM04g2fSUoCfhu0tRzfMQJX
	 9Jt6xzqXET7SRzxJ149wvjIQepvLBRGTKdbT2LAsgX1fUAxATL/4yBCN1oDT/PYEDq
	 UtmwSXVntNcMINaI1F3gH23gUTijIJKLZFmASRlOqxK+IZmDFsMjHgBp6+fuWzywQO
	 VC44K9w9qPe1je35YUOn7hxvKRi8NvCdrh7WIZK8GJKx0ZdYghh3JlryGXljAR2HYN
	 xYf2UfUNQ9JXC/T7cnMVpLbxXPeXlxYzM4JOVWyhT2Tbc7bkf3NpMpFK1/W88b+Fcv
	 FerG9vcVmCoqg==
Date: Fri, 19 Sep 2025 15:56:01 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/6] KVM: SVM: Don't advise the user to do
 force_avic=y (when x2AVIC is detected)
Message-ID: <75n6j3eu6hlfkeug46ekp2po24hiuoia7sju32h73gt4hwjzgk@ddb7t6npdddg>
References: <20250919002136.1349663-1-seanjc@google.com>
 <20250919002136.1349663-5-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919002136.1349663-5-seanjc@google.com>

On Thu, Sep 18, 2025 at 05:21:34PM -0700, Sean Christopherson wrote:
> Don't advise the end user to try to force enable AVIC when x2AVIC is
> reported as supported in CPUID,
			in CPUID but AVIC isn't,

> as forcefully enabling AVIC isn't something
> that should be done lightly.  E.g. some Zen4 client systems hide AVIC but
> leave x2AVIC behind, and while such a configuration is indeed due to buggy
> firmware in the sense the reporting x2AVIC without AVIC is nonsensical,
			^^ that

> KVM has no idea _why_ firmware disabled AVIC in the first place.
> 
> Suggesting that the user try to run with force_avic=y is sketchy even if
> the user explicitly tries to enable AVIC, and will be downright
> irresponsible once KVM starts enabling AVIC by default.  Alternatively,
> KVM could print the message only when the user explicitly asks for AVIC,
> but running with force_avic=y isn't something that should be encouraged
> for random users.  force_avic is a useful knob for developers and perhaps
> even advanced users, but isn't something that KVM should advertise broadly.
> 
> Opportunistically append a newline to the pr_warn() so that it prints out
> immediately, and tweak the message to say that AVIC is unsupported instead
> of disabled (disabled suggests that the kernel/KVM is somehow responsible).
> 
> Suggested-by: Naveen N Rao <naveen@kernel.org>

Suggested-by: Naveen N Rao (AMD) <naveen@kernel.org>

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Reviewed-by: Naveen N Rao (AMD) <naveen@kernel.org>


- Naveen


