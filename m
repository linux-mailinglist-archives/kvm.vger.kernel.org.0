Return-Path: <kvm+bounces-15529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EF7B88AD138
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 17:48:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8FA1F1F2145D
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 15:48:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8140515380D;
	Mon, 22 Apr 2024 15:48:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C552D153593
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 15:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713800903; cv=none; b=ViaJ2quc0pHBMvxxSvgOWM7+fcYieEK+6HNBxovrR+dVZ0npDCck6b3oLI99uFoNwQbUcBthimETzswZesj+NJXdGa2YbjrX4Co4LML/YhE+mS5O2+XvnNfDSphtOS+IUhab2OD3V5qyV0qCRnkI2TGdgd2FXfS4V9dtnFTojmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713800903; c=relaxed/simple;
	bh=a8/HxN4LeYC6wAGy+xyDNNo3BK/fu39NEQB5hddsTMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lwd7G39Kf1A5B/f96DDOjQ0JR3aa0jDT7Wo0NDocBj5puKkJoy9jzoHbLjrzx5CD9IoiEsLzuPQG7bd0VQPEeLSShsDALu+dHsxZeqBgKOEPg5DsGZrw5Pw+Kcz52411tkHHa2PSh1SvyXEa35UKCpA6zwyGhgboXUtTI8UAxiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C9312F;
	Mon, 22 Apr 2024 08:48:48 -0700 (PDT)
Received: from arm.com (e121798.cambridge.arm.com [10.1.197.37])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9B2F63F73F;
	Mon, 22 Apr 2024 08:48:18 -0700 (PDT)
Date: Mon, 22 Apr 2024 16:48:16 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	joey.gouly@arm.com, steven.price@arm.com, james.morse@arm.com,
	oliver.upton@linux.dev, yuzenghui@huawei.com,
	andrew.jones@linux.dev, eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH 14/33] arm: selftest: realm: skip pabt
 test when running in a realm
Message-ID: <ZiaGwP7Dvg8y4Bwu@arm.com>
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
 <20240412103408.2706058-15-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240412103408.2706058-15-suzuki.poulose@arm.com>

Hi,

On Fri, Apr 12, 2024 at 11:33:49AM +0100, Suzuki K Poulose wrote:
> From: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> The realm manager treats instruction aborts as fatal errors, skip this
> test.

I wrote the commit message, and now I don't remember if this was a
limitation of the (at the time) implementation for the realm manager that I
used for developing the patch or if this was specified in the architecture
:(

Would you mind clearing that up?

Thanks,
Alex

> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  arm/selftest.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arm/selftest.c b/arm/selftest.c
> index 1553ed8e..8caadad3 100644
> --- a/arm/selftest.c
> +++ b/arm/selftest.c
> @@ -19,6 +19,7 @@
>  #include <asm/smp.h>
>  #include <asm/mmu.h>
>  #include <asm/barrier.h>
> +#include <asm/rsi.h>
>  
>  static cpumask_t ready, valid;
>  
> @@ -393,11 +394,17 @@ static void check_vectors(void *arg __unused)
>  					  user_psci_system_off);
>  #endif
>  	} else {
> +		if (is_realm()) {
> +			report_skip("pabt test not supported in a realm");
> +			goto out;
> +		}
> +
>  		if (!check_pabt_init())
>  			report_skip("Couldn't guess an invalid physical address");
>  		else
>  			report(check_pabt(), "pabt");
>  	}
> +out:
>  	exit(report_summary());
>  }
>  
> -- 
> 2.34.1
> 

