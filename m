Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B73DA9186D
	for <lists+kvm@lfdr.de>; Sun, 18 Aug 2019 19:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbfHRRoc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 18 Aug 2019 13:44:32 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:60649 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726247AbfHRRoc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 18 Aug 2019 13:44:32 -0400
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:AES256-GCM-SHA384:256)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1hzPED-0007S9-Tg; Sun, 18 Aug 2019 19:44:30 +0200
Date:   Sun, 18 Aug 2019 18:44:27 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        julien.grall@arm.com, andre.przywara@arm.com, eric.auger@redhat.com
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Make function comments match
 function declarations
Message-ID: <20190818184427.0fc263ad@why>
In-Reply-To: <1565862982-9787-1-git-send-email-alexandru.elisei@arm.com>
References: <1565862982-9787-1-git-send-email-alexandru.elisei@arm.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, julien.grall@arm.com, andre.przywara@arm.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 15 Aug 2019 10:56:22 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> Since commit 503a62862e8f ("KVM: arm/arm64: vgic: Rely on the GIC driver to
> parse the firmware tables"), the vgic_v{2,3}_probe functions stopped using
> a DT node. Commit 909777324588 ("KVM: arm/arm64: vgic-new: vgic_init:
> implement kvm_vgic_hyp_init") changed the functions again, and now they
> require exactly one argument, a struct gic_kvm_info populated by the GIC
> driver. Unfortunately the comments regressed and state that a DT node is
> used instead. Change the function comments to reflect the current
> prototypes.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-v2.c | 7 ++++---
>  virt/kvm/arm/vgic/vgic-v3.c | 7 ++++---
>  2 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
> index 96aab77d0471..27b1ddf71aa0 100644
> --- a/virt/kvm/arm/vgic/vgic-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-v2.c
> @@ -354,10 +354,11 @@ int vgic_v2_map_resources(struct kvm *kvm)
>  DEFINE_STATIC_KEY_FALSE(vgic_v2_cpuif_trap);
>  
>  /**
> - * vgic_v2_probe - probe for a GICv2 compatible interrupt controller in DT
> - * @node:	pointer to the DT node
> + * vgic_v2_probe - probe for a VGICv2 compatible interrupt controller
> + * @info:	pointer to the GIC description
>   *
> - * Returns 0 if a GICv2 has been found, returns an error code otherwise
> + * Returns 0 if the VGICv2 has been probed successfully, returns an error code
> + * otherwise
>   */
>  int vgic_v2_probe(const struct gic_kvm_info *info)
>  {
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index 0c653a1e5215..4874f3266bea 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -570,10 +570,11 @@ static int __init early_gicv4_enable(char *buf)
>  early_param("kvm-arm.vgic_v4_enable", early_gicv4_enable);
>  
>  /**
> - * vgic_v3_probe - probe for a GICv3 compatible interrupt controller in DT
> - * @node:	pointer to the DT node
> + * vgic_v3_probe - probe for a VGICv3 compatible interrupt controller
> + * @info:	pointer to the GIC description
>   *
> - * Returns 0 if a GICv3 has been found, returns an error code otherwise
> + * Returns 0 if the VGICv3 has been probed successfully, returns an error code
> + * otherwise
>   */
>  int vgic_v3_probe(const struct gic_kvm_info *info)
>  {


Queued, thanks.

	M.
-- 
Without deviation from the norm, progress is not possible.
