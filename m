Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2576114A971
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 19:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgA0SIL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 13:08:11 -0500
Received: from foss.arm.com ([217.140.110.172]:47822 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726173AbgA0SIL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jan 2020 13:08:11 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2832A30E;
        Mon, 27 Jan 2020 10:08:11 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1F2023F67D;
        Mon, 27 Jan 2020 10:08:10 -0800 (PST)
Date:   Mon, 27 Jan 2020 18:08:07 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
Subject: Re: [PATCH v2 kvmtool 06/30] arm/pci: Advertise only PCI bus 0 in
 the DT
Message-ID: <20200127180807.3fd3162b@donnerap.cambridge.arm.com>
In-Reply-To: <20200123134805.1993-7-alexandru.elisei@arm.com>
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
        <20200123134805.1993-7-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Jan 2020 13:47:41 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi,

> The "bus-range" property encodes the PCI bus number of the PCI
> controller and the largest bus number of any PCI buses that are
> subordinate to this node [1]. kvmtool emulates only PCI bus 0.

I am wondering if that ever becomes a limitation, but in the current context it looks like the right thing to do.

> Advertise this in the PCI DT node by setting "bus-range" to <0,0>.
> 
> [1] IEEE Std 1275-1994, Section 3 "Bus Nodes Properties and Methods"
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  arm/pci.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arm/pci.c b/arm/pci.c
> index 557cfa98938d..ed325fa4a811 100644
> --- a/arm/pci.c
> +++ b/arm/pci.c
> @@ -30,7 +30,7 @@ void pci__generate_fdt_nodes(void *fdt)
>  	struct of_interrupt_map_entry irq_map[OF_PCI_IRQ_MAP_MAX];
>  	unsigned nentries = 0;
>  	/* Bus range */
> -	u32 bus_range[] = { cpu_to_fdt32(0), cpu_to_fdt32(1), };
> +	u32 bus_range[] = { cpu_to_fdt32(0), cpu_to_fdt32(0), };
>  	/* Configuration Space */
>  	u64 cfg_reg_prop[] = { cpu_to_fdt64(KVM_PCI_CFG_AREA),
>  			       cpu_to_fdt64(ARM_PCI_CFG_SIZE), };

