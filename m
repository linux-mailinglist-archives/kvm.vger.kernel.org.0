Return-Path: <kvm+bounces-50376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CE32AE488A
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 17:28:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5A0C418873E1
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 15:21:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AEE22868B8;
	Mon, 23 Jun 2025 15:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sa+E3D8P"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7607E262FFD;
	Mon, 23 Jun 2025 15:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750692073; cv=none; b=ignYex5P0y09Ngp/5bsTKBvHJnWja8WcSqMQP11mwYQ1CrlMPsMSgMCdYOyiwU3gJWZDcs3Y+9O5ItfuS8D3fve+mzytPd+GIYrs9F3CDIMxpyDw6+/7dWc1seMaUmLIWQb2q/6UxnR8Mn4aYAoVgFPEIlHqac+cYxsnOectUAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750692073; c=relaxed/simple;
	bh=AO8oR9iVOI3X3E2H+YguT8JIoUYuH/+e9B86cY82fto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RJJDWtmEYPGFKqgJpWouw/taq2TBBTN/q5PbY2AIWQsG828WIMVt0jYzLjMr9vOlyjlcKK8aZDwCixSUrN4EAWm4XsmwwdCP4buVEtLBtOED/M0783ZJXlTXb89cOanV60sL4fV0eY4iyhheQYzxGUBiuWloDASkeM5N25e/wWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sa+E3D8P; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A034C4CEEA;
	Mon, 23 Jun 2025 15:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750692073;
	bh=AO8oR9iVOI3X3E2H+YguT8JIoUYuH/+e9B86cY82fto=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Sa+E3D8P4hEplewoicY3Mvfbf4eR2Yo3VUfGk+HHCP5ZBEVNk5ilpjQhWbrsTiCdC
	 j+CngHKTkWWRmYVxRaRrX1dqJlq8EeMIknsiE6xq5D9SzAYt4IIP4Z8HUbgKTbs4FN
	 qVOM08civmJRGvOsffFXSJgKDJXDyBmWxsuDHhgkFPG5qTLQjZPM9K9dQV2S+XBBo2
	 vQrWZASrHOvgjJvjtHT+QNTIxyK+F8tW9SRonKLYT+KfivTmEPxjX3B1kx+Fe7yId5
	 30TZvOO+kK50QC7CP3ShJLMiph/awnZRvDul3fzpWj6qrsdVKn3aMSkQDbS8yQKRkk
	 P0xUF1/W8G/oQ==
Date: Mon, 23 Jun 2025 17:21:06 +0200
From: Lorenzo Pieralisi <lpieralisi@kernel.org>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	Joey Gouly <Joey.Gouly@arm.com>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"will@kernel.org" <will@kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: Re: [PATCH 1/5] irqchip/gic-v5: Skip deactivate for forwarded PPI
 interrupts
Message-ID: <aFlw4lOj8tUGrSTb@lpieralisi>
References: <20250620160741.3513940-1-sascha.bischoff@arm.com>
 <20250620160741.3513940-2-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250620160741.3513940-2-sascha.bischoff@arm.com>

On Fri, Jun 20, 2025 at 04:07:50PM +0000, Sascha Bischoff wrote:
> If a PPI interrupt is forwarded to a guest, skip the deactivate and
> only EOI. Rely on the guest deactivating the both the virtual and

"deactivating both"

> physical interrupts (due to ICH_LRx_EL2.HW being set) later on as part
> of handling the injected interrupt. This mimics the behaviour seen on
> native GICv3.
> 
> This is part of adding support for the GICv3 compatibility mode on a
> GICv5 host.
> 
> Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  drivers/irqchip/irq-gic-v5.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)

Reviewed-by: Lorenzo Pieralisi <lpieralisi@kernel.org>

> diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
> index 4a0990f46358..28853d51a2ea 100644
> --- a/drivers/irqchip/irq-gic-v5.c
> +++ b/drivers/irqchip/irq-gic-v5.c
> @@ -213,6 +213,12 @@ static void gicv5_hwirq_eoi(u32 hwirq_id, u8 hwirq_type)
>  
>  static void gicv5_ppi_irq_eoi(struct irq_data *d)
>  {
> +	/* Skip deactivate for forwarded PPI interrupts */
> +	if (irqd_is_forwarded_to_vcpu(d)) {
> +		gic_insn(0, CDEOI);
> +		return;
> +	}
> +
>  	gicv5_hwirq_eoi(d->hwirq, GICV5_HWIRQ_TYPE_PPI);
>  }
>  
> @@ -494,6 +500,16 @@ static bool gicv5_ppi_irq_is_level(irq_hw_number_t hwirq)
>  	return !!(read_ppi_sysreg_s(hwirq, PPI_HM) & bit);
>  }
>  
> +static int gicv5_ppi_irq_set_vcpu_affinity(struct irq_data *d, void *vcpu)
> +{
> +	if (vcpu)
> +		irqd_set_forwarded_to_vcpu(d);
> +	else
> +		irqd_clr_forwarded_to_vcpu(d);
> +
> +	return 0;
> +}
> +
>  static const struct irq_chip gicv5_ppi_irq_chip = {
>  	.name			= "GICv5-PPI",
>  	.irq_mask		= gicv5_ppi_irq_mask,
> @@ -501,6 +517,7 @@ static const struct irq_chip gicv5_ppi_irq_chip = {
>  	.irq_eoi		= gicv5_ppi_irq_eoi,
>  	.irq_get_irqchip_state	= gicv5_ppi_irq_get_irqchip_state,
>  	.irq_set_irqchip_state	= gicv5_ppi_irq_set_irqchip_state,
> +	.irq_set_vcpu_affinity	= gicv5_ppi_irq_set_vcpu_affinity,
>  	.flags			= IRQCHIP_SKIP_SET_WAKE	  |
>  				  IRQCHIP_MASK_ON_SUSPEND,
>  };
> -- 
> 2.34.1

