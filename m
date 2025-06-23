Return-Path: <kvm+bounces-50372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E1A8AE482E
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 17:17:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28D1217D0D6
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 15:15:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02D1228466F;
	Mon, 23 Jun 2025 15:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OmCoXbQf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E8024169B;
	Mon, 23 Jun 2025 15:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750691682; cv=none; b=EDC1kz8YAHsUEmGfY97wo4TMxYSuCHxXDWx68GVCktKk7ILSRrTRi5aTUv2NVhMEtj4409qEC8p2jegZPwRpW9dflbm7Jglb+tgLfHysKmXhEH/3lx+FcqzZA+S0udVzzUYWciQNtFUxwZSRZaqCGHI8rjjB3Nc4hk+DyC1KCyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750691682; c=relaxed/simple;
	bh=XSDrVBVnhyxYp1JMKvQx3EG0b0XeZk8MBikoZoNvSPA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gTt5US/p+FpBDBl5nTTkrAobqpG3uNMKJUEOyigjsSyRlVHa5iMda7eTIGtL0glqRn8VeICOxvjihT6DmmWz+Op1Mk3AFaFUFxYOvDBoJHLqqbgGAr7AIQWWHrY78csfa8xfifd/y2R5px5pZYJClQa3idZdx55/evQ3cFTqkus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OmCoXbQf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2742EC4CEEA;
	Mon, 23 Jun 2025 15:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750691681;
	bh=XSDrVBVnhyxYp1JMKvQx3EG0b0XeZk8MBikoZoNvSPA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OmCoXbQf/tjUIpINpxj6vwdUqDZybUpwjdWVlsS76SySfStDAGZ61o1ANRZoqQjPG
	 8PB+6z/OaL3uYgFT3hzwwpRGKnIvCLqf1FLbvHBugmzjEoSWyBnDNLNnVnK18oEqQo
	 NJPa/wbKeZsV6TTtEDYn2s+KrdSCTmNs6ejzDIQC/vtygeq6/S4gez8uy6/kyvlHLD
	 SGGhZr2G7/86WqxshFSb/HYHgENdhplZMRLtlRMIQDJfa5WqDGYugWqqCT0YdUJ2l4
	 ap8E3G7oamo2KDrBMaPSTGXdgJWyPgcjLr6F3YDdKQW8I82pgl//a8FozORPIpQJlA
	 rEGxf3sYaX2sA==
Date: Mon, 23 Jun 2025 17:14:35 +0200
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
Subject: Re: [PATCH 2/5] irqchip/gic-v5: Populate struct gic_kvm_info
Message-ID: <aFlvW2FNCyCi3h3Y@lpieralisi>
References: <20250620160741.3513940-1-sascha.bischoff@arm.com>
 <20250620160741.3513940-3-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250620160741.3513940-3-sascha.bischoff@arm.com>

On Fri, Jun 20, 2025 at 04:07:51PM +0000, Sascha Bischoff wrote:
> Populate the gic_kvm_info struct based on support for
> FEAT_GCIE_LEGACY.  The struct is used by KVM to probe for a compatible
> GIC.
> 
> Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  drivers/irqchip/irq-gic-v5.c          | 34 +++++++++++++++++++++++++++
>  include/linux/irqchip/arm-vgic-info.h |  4 ++++
>  2 files changed, 38 insertions(+)
> 
> diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
> index 28853d51a2ea..6aecd2343fee 100644
> --- a/drivers/irqchip/irq-gic-v5.c
> +++ b/drivers/irqchip/irq-gic-v5.c
> @@ -13,6 +13,7 @@
>  
>  #include <linux/irqchip.h>
>  #include <linux/irqchip/arm-gic-v5.h>
> +#include <linux/irqchip/arm-vgic-info.h>
>  
>  #include <asm/cpufeature.h>
>  #include <asm/exception.h>
> @@ -1049,6 +1050,37 @@ static void gicv5_set_cpuif_idbits(void)
>  	}
>  }
>  
> +#ifdef CONFIG_KVM
> +static struct gic_kvm_info gic_v5_kvm_info __initdata;
> +
> +static bool gicv5_cpuif_has_gcie_legacy(void)

__init ?

> +{
> +	u64 idr0 = read_sysreg_s(SYS_ICC_IDR0_EL1);
> +
> +	return !!FIELD_GET(ICC_IDR0_EL1_GCIE_LEGACY, idr0);
> +}
> +
> +static void __init gic_of_setup_kvm_info(struct device_node *node)
> +{
> +	gic_v5_kvm_info.type = GIC_V5;
> +	gic_v5_kvm_info.has_gcie_v3_compat = gicv5_cpuif_has_gcie_legacy();
> +
> +	/* GIC Virtual CPU interface maintenance interrupt */
> +	gic_v5_kvm_info.no_maint_irq_mask = false;
> +	gic_v5_kvm_info.maint_irq = irq_of_parse_and_map(node, 0);
> +	if (!gic_v5_kvm_info.maint_irq) {
> +		pr_warn("cannot find GICv5 virtual CPU interface maintenance interrupt\n");
> +		return;
> +	}
> +
> +	vgic_set_kvm_info(&gic_v5_kvm_info);
> +}
> +#else
> +static void __init gic_of_setup_kvm_info(struct device_node *node)

static inline

Thanks,
Lorenzo

> +{
> +}
> +#endif // CONFIG_KVM
> +
>  static int __init gicv5_of_init(struct device_node *node, struct device_node *parent)
>  {
>  	int ret = gicv5_irs_of_probe(node);
> @@ -1081,6 +1113,8 @@ static int __init gicv5_of_init(struct device_node *node, struct device_node *pa
>  
>  	gicv5_irs_its_probe();
>  
> +	gic_of_setup_kvm_info(node);
> +
>  	return 0;
>  out_int:
>  	gicv5_cpu_disable_interrupts();
> diff --git a/include/linux/irqchip/arm-vgic-info.h b/include/linux/irqchip/arm-vgic-info.h
> index a75b2c7de69d..ca1713fac6e3 100644
> --- a/include/linux/irqchip/arm-vgic-info.h
> +++ b/include/linux/irqchip/arm-vgic-info.h
> @@ -15,6 +15,8 @@ enum gic_type {
>  	GIC_V2,
>  	/* Full GICv3, optionally with v2 compat */
>  	GIC_V3,
> +	/* Full GICv5, optionally with v3 compat */
> +	GIC_V5,
>  };
>  
>  struct gic_kvm_info {
> @@ -34,6 +36,8 @@ struct gic_kvm_info {
>  	bool		has_v4_1;
>  	/* Deactivation impared, subpar stuff */
>  	bool		no_hw_deactivation;
> +	/* v3 compat support (GICv5 hosts, only) */
> +	bool		has_gcie_v3_compat;
>  };
>  
>  #ifdef CONFIG_KVM
> -- 
> 2.34.1

