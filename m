Return-Path: <kvm+bounces-51169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 61755AEF3B4
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 11:46:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 938894A2D71
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 09:46:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3C6E26E6F1;
	Tue,  1 Jul 2025 09:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r6nkgnRV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A611F239B;
	Tue,  1 Jul 2025 09:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751363165; cv=none; b=lMmlBH1ou5ir4wmMQdZd1bSCUqqGx1r1lRarVshuThLZ7BNJuUWMIjKfUfNMJM8mUlVhIpPxXi/ukkAGcpKNNgIS+rykiaUJLzIDNfaibtQd6v07NOGiwiA/wEX4zZDzqDsYGy50iok3MRVhUdpR3nbKv4av9u7iGCtIXjRggko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751363165; c=relaxed/simple;
	bh=MzK+tBHEvikT/y3icY0EOlfB0eIQiJbDL/vPnBH5ZC0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hg8WMj3CxI/QUu1tk/MG3W1XQoKhqHJUJdt883WFS73IvZDKt/roYpWnpem/mIP/LOkTfBUmMcXSKWAzjCYFHn73OgtBxN7NWLpC5aeGjwL7scllAiWDmx/G7TKbKurFayYZ4CoNk7mTO7IU2dK8ppMDDrRt6ahIN/3Aev4K7nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r6nkgnRV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE54C4CEEB;
	Tue,  1 Jul 2025 09:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751363164;
	bh=MzK+tBHEvikT/y3icY0EOlfB0eIQiJbDL/vPnBH5ZC0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r6nkgnRVrxpsEhrSynq7t3OUsleGE7pItMeHT0asVMWR32cxKjoPirQimg891wiwo
	 63X/x1ovRlUxKJwCM5gmW/Qa1un4NcmGdRIf4PCMIoHuWo4ka0elgPeRcbwj/3tvRi
	 5FzH0zsYYHdYMHZlHdo9WXkGEFt4OgRZz8I7ES/LZrE5oPAs0/CQMHYyj9N7Rg04E8
	 nMsYPJIWcTI3uufeSdpWajM3LuDSM5/4ii7CE6CvoeocVIqn8pDb5hfJd/cF5ScJaR
	 SaTpNfQvPcGDSv1Lpk9JDq9ncLBQr7kJx3kIF0UGrv2VTvvJMmodN8NTI5av8qdTy3
	 lyjMHJA+sbX0Q==
Date: Tue, 1 Jul 2025 11:45:58 +0200
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
Subject: Re: [PATCH v2 2/5] irqchip/gic-v5: Populate struct gic_kvm_info
Message-ID: <aGOuVhED/SSnzwWU@lpieralisi>
References: <20250627100847.1022515-1-sascha.bischoff@arm.com>
 <20250627100847.1022515-3-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250627100847.1022515-3-sascha.bischoff@arm.com>

On Fri, Jun 27, 2025 at 10:09:01AM +0000, Sascha Bischoff wrote:
> Populate the gic_kvm_info struct based on support for
> FEAT_GCIE_LEGACY.  The struct is used by KVM to probe for a compatible
> GIC.
> 
> Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  drivers/irqchip/irq-gic-v5.c          | 33 +++++++++++++++++++++++++++
>  include/linux/irqchip/arm-vgic-info.h |  4 ++++
>  2 files changed, 37 insertions(+)

Reviewed-by: Lorenzo Pieralisi <lpieralisi@kernel.org>

> diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
> index 6b42c4af5c79..9ba43ec9318b 100644
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
> @@ -1049,6 +1050,36 @@ static void gicv5_set_cpuif_idbits(void)
>  	}
>  }
>  
> +#ifdef CONFIG_KVM
> +static struct gic_kvm_info gic_v5_kvm_info __initdata;
> +
> +static bool __init gicv5_cpuif_has_gcie_legacy(void)
> +{
> +	u64 idr0 = read_sysreg_s(SYS_ICC_IDR0_EL1);
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
> +static inline void __init gic_of_setup_kvm_info(struct device_node *node)
> +{
> +}
> +#endif // CONFIG_KVM
> +
>  static int __init gicv5_of_init(struct device_node *node, struct device_node *parent)
>  {
>  	int ret = gicv5_irs_of_probe(node);
> @@ -1081,6 +1112,8 @@ static int __init gicv5_of_init(struct device_node *node, struct device_node *pa
>  
>  	gicv5_irs_its_probe();
>  
> +	gic_of_setup_kvm_info(node);
> +
>  	return 0;
>  
>  out_int:
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

