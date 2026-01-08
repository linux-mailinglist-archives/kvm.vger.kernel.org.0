Return-Path: <kvm+bounces-67371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CD1DD024FD
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 12:11:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BB49530695FD
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 10:59:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F4DC4B8DF3;
	Thu,  8 Jan 2026 10:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lVJ4e930"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FD24946D9;
	Thu,  8 Jan 2026 10:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767868956; cv=none; b=KWb07oWDEC80HnO0x52f/J/m0X38Y66AAxEvlSu4F1G/gJnPJb0Tafnz4AjUCg9m+T1AQLqY2WgLxfZNnQYydAhLQWvyg8N6zy5AZhkGCjjlTbSI9Kl/ZS5OIxSiMoSkgEHC+RRgde2bElaGzDem9vONP4hkjZbOF0QQzUL3RZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767868956; c=relaxed/simple;
	bh=gFiq18moecTevjD0fOTzAn5k+PM0Rp/Uz5/ZwAO18/4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GW9aiIOLsuipqsTAn6Lh1oIa44G6RXz+0jicdUNqbHiQISypHoP4fOq2+weWaP+bYBf9KWFBElwqCg2tYfiOmvV2vuV8TM6AxDv/bhUzd0Ek6GLRoDsgd1w9e5PNkGKIxBE/luuQ/RPO8afdfKAyX7zforMWa7LZ/Hbby1JmDds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lVJ4e930; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D061C116C6;
	Thu,  8 Jan 2026 10:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767868956;
	bh=gFiq18moecTevjD0fOTzAn5k+PM0Rp/Uz5/ZwAO18/4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lVJ4e930FA+E7kPGcjHvr7M0tn8WbmlvUOLuifGfvYHU/1M4XYyXudrq4AiQUFQDZ
	 gMBexYoPpbXxHEiM9Qgyy2T4lz5W9G9gaTteOPoe7kDeTgICfYrmmvZ+LmNdoE8ucz
	 eGkp4DQByUoUlTLg1tg2wVyizxhu2MK4zHBrkt6xudC9+mNl7q8vhQx7R5p17NNJCQ
	 0Ik81gRKkbjNbf9Xs9zR+AHfvp7zO/QFAuDFKzPN1mx0NSPpFJqDTHYPYCvL68FxHH
	 jPKLtHa8KnmhtpW5PXQ25TIvWjjmebpO8h2XmSxUIQyTl7Y9EVrpAwWQbcWp9M9xZG
	 wVHpcDdH3FIGQ==
Date: Thu, 8 Jan 2026 16:06:05 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM: Fix an off-by-one typo in the comment for
 enabling AVIC by default
Message-ID: <aV-GPYoKB5HIzcs3@blrnaveerao1>
References: <20260107204546.570403-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107204546.570403-1-seanjc@google.com>

On Wed, Jan 07, 2026 at 12:45:46PM -0800, Sean Christopherson wrote:
> Fix a goof in the comment that documents KVM's logic for enabling AVIC by
> default to reference Zen5+ as family 0x1A (Zen5), not family 0x19 (Zen4).
> The code is correct (checks for _greater_ than 0x19), only the comment is
> flawed.

I had thought that the comment was correct and that you wanted to 
reference Zen4 there. That is:
	family 0x19 (Zen4) and later (Zen5+),

Though family 0x19 also includes Zen3 :/

I think it would be better to update the code as well, just so it is 
easier to correlate the comment and the code?

        if (avic == AVIC_AUTO_MODE)
                avic = boot_cpu_has(X86_FEATURE_X2AVIC) &&
-                      (boot_cpu_data.x86 > 0x19 || cpu_feature_enabled(X86_FEATURE_ZEN4));
+                      (cpu_feature_enabled(X86_FEATURE_ZEN4) || boot_cpu_data.x86 >= 0x1A);
 
        if (!avic || !npt_enabled)
		return false;

> 
> Fixes: ca2967de5a5b ("KVM: SVM: Enable AVIC by default for Zen4+ if x2AVIC is support")
> Cc: Naveen N Rao (AMD) <naveen@kernel.org>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Regardless of that, this change is accurate:
Acked-by: Naveen N Rao (AMD) <naveen@kernel.org>

> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 6b77b2033208..7e62d05c2136 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -1224,7 +1224,7 @@ static bool __init avic_want_avic_enabled(void)
>  	 * In "auto" mode, enable AVIC by default for Zen4+ if x2AVIC is
>  	 * supported (to avoid enabling partial support by default, and because
>  	 * x2AVIC should be supported by all Zen4+ CPUs).  Explicitly check for
> -	 * family 0x19 and later (Zen5+), as the kernel's synthetic ZenX flags
> +	 * family 0x1A and later (Zen5+), as the kernel's synthetic ZenX flags
>  	 * aren't inclusive of previous generations, i.e. the kernel will set
>  	 * at most one ZenX feature flag.
>  	 */
> 
> base-commit: 9448598b22c50c8a5bb77a9103e2d49f134c9578
> -- 
> 2.52.0.351.gbe84eed79e-goog
> 

- Naveen

