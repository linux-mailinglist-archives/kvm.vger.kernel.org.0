Return-Path: <kvm+bounces-17325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 708A38C4382
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 16:52:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B5B9285B62
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 14:52:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C91FF4C7E;
	Mon, 13 May 2024 14:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hhtej7Wj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C114A1C;
	Mon, 13 May 2024 14:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715611969; cv=none; b=tiakM1s54PdkX12XgiN7b1H9pv6mRKqX5HCqJ6l2n/t3boz9Klm8u9Kx9vpeBGXftW3Br/ZHaXbFuxODXBRMHIhWYkbWBdI/FRpTq5U6qwJLl+0wxgfKseoc1kygRIWVM6G2pRQ2Dfr7u7vX31wL7clEPkaRAy1jlJgU66cRAdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715611969; c=relaxed/simple;
	bh=GhGdQKNqljv/diEmKy6DBZ8tuusN/Q8wpaUsamwB/l0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FUvKCEwxiIQO6mctIwAi5gxMs3xx2uZzLoXiRwh/tfTNGgdlRbbpjwehTLnoBDD/MRdyQjLwvUv+WxXxZBT50FptloTdYGJszoCRZLbO9n4V6IzGFr+Tnv7q2KuG5uSgDY2jWQ3uMzztDjulNc0irQG8i4eQ0UxDXhFRvu1gAUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hhtej7Wj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C640EC32782;
	Mon, 13 May 2024 14:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715611968;
	bh=GhGdQKNqljv/diEmKy6DBZ8tuusN/Q8wpaUsamwB/l0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hhtej7WjJN6Rpnnoomhym6z3QD0H55mJhktM4st/nRJULRJPxIE0whb9NzbGTGItu
	 5vi84OiA6wfl+1yxEsDDSIxOEQV1XUD0yHwDbFwp34EruER5NIw2x0ozsgrZ8zeq2M
	 CvB9j71bkPpVKIWuL8AmhJvJJDvUYw5GWjTLVIepZFoQlTZ71/dWcdkZpKOK9MmvZl
	 1hAXZi05pddgjUfsgZJ10sOhc5G0CxlL42tcM2KpFhmNyZKjLuvcDvEAr3V2AheAQN
	 1cwGUViXKwxPIEM2nqB3f0Wq69VBku74uiYAwXE3ypHuGSe9M+vqaslgvNItcD4WhV
	 tv93nVawotJfw==
Date: Mon, 13 May 2024 15:52:43 +0100
From: Will Deacon <will@kernel.org>
To: =?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v3 07/12] KVM: arm64: VHE: Mark __hyp_call_panic
 __noreturn
Message-ID: <20240513145243.GF28749@willie-the-truck>
References: <20240510112645.3625702-1-ptosi@google.com>
 <20240510112645.3625702-8-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240510112645.3625702-8-ptosi@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, May 10, 2024 at 12:26:36PM +0100, Pierre-Clément Tosi wrote:
> Given that the sole purpose of __hyp_call_panic() is to call panic(), a
> __noreturn function, give it the __noreturn attribute, removing the need
> for its caller to use unreachable().
> 
> Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
> ---
>  arch/arm64/kvm/hyp/vhe/switch.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 1581df6aec87..9db04a286398 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -301,7 +301,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  	return ret;
>  }
>  
> -static void __hyp_call_panic(u64 spsr, u64 elr, u64 par)
> +static void __noreturn __hyp_call_panic(u64 spsr, u64 elr, u64 par)
>  {
>  	struct kvm_cpu_context *host_ctxt;
>  	struct kvm_vcpu *vcpu;
> @@ -326,7 +326,6 @@ void __noreturn hyp_panic(void)
>  	u64 par = read_sysreg_par();
>  
>  	__hyp_call_panic(spsr, elr, par);
> -	unreachable();
>  }
> 

Acked-by: Will Deacon <will@kernel.org>

Will

