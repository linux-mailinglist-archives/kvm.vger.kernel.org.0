Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA8EA155C24
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 17:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgBGQvL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 11:51:11 -0500
Received: from foss.arm.com ([217.140.110.172]:42038 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727031AbgBGQvL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 11:51:11 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E64E81FB;
        Fri,  7 Feb 2020 08:51:10 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CBE273F68E;
        Fri,  7 Feb 2020 08:51:09 -0800 (PST)
Date:   Fri, 7 Feb 2020 16:51:07 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org,
        Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH v2 kvmtool 28/30] arm/fdt: Remove 'linux,pci-probe-only'
 property
Message-ID: <20200207165107.157b2fb6@donnerap.cambridge.arm.com>
In-Reply-To: <20200123134805.1993-29-alexandru.elisei@arm.com>
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
        <20200123134805.1993-29-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Jan 2020 13:48:03 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi,

> From: Julien Thierry <julien.thierry@arm.com>
> 
> PCI now supports configurable BARs. Get rid of the no longer needed,
> Linux-only, fdt property.

\o/

> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre.

> ---
>  arm/fdt.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arm/fdt.c b/arm/fdt.c
> index c80e6da323b6..02091e9e0bee 100644
> --- a/arm/fdt.c
> +++ b/arm/fdt.c
> @@ -130,7 +130,6 @@ static int setup_fdt(struct kvm *kvm)
>  
>  	/* /chosen */
>  	_FDT(fdt_begin_node(fdt, "chosen"));
> -	_FDT(fdt_property_cell(fdt, "linux,pci-probe-only", 1));
>  
>  	/* Pass on our amended command line to a Linux kernel only. */
>  	if (kvm->cfg.firmware_filename) {

