Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74DDD150605
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 13:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbgBCMVH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 07:21:07 -0500
Received: from foss.arm.com ([217.140.110.172]:52692 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgBCMVG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Feb 2020 07:21:06 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2C4A0FEC;
        Mon,  3 Feb 2020 04:21:06 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2BC603F52E;
        Mon,  3 Feb 2020 04:21:05 -0800 (PST)
Date:   Mon, 3 Feb 2020 12:20:49 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
Subject: Re: [PATCH v2 kvmtool 18/30] hw/vesa: Set the size for BAR 0
Message-ID: <20200203122049.05483484@donnerap.cambridge.arm.com>
In-Reply-To: <20200123134805.1993-19-alexandru.elisei@arm.com>
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
        <20200123134805.1993-19-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Jan 2020 13:47:53 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> BAR 0 is an I/O BAR and is registered as an ioport region. Let's set its
> size, so a guest can actually use it.

Well, the whole I/O bar emulates as RAZ/WI, so I would be curious how the guest would actually use it, but specifying the size is surely a good thing, so:
 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Andre Przywara <andre.przywara>

Cheers,
Andre

> ---
>  hw/vesa.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/hw/vesa.c b/hw/vesa.c
> index a665736a76d7..e988c0425946 100644
> --- a/hw/vesa.c
> +++ b/hw/vesa.c
> @@ -70,6 +70,7 @@ struct framebuffer *vesa__init(struct kvm *kvm)
>  
>  	vesa_base_addr			= (u16)r;
>  	vesa_pci_device.bar[0]		= cpu_to_le32(vesa_base_addr | PCI_BASE_ADDRESS_SPACE_IO);
> +	vesa_pci_device.bar_size[0]	= PCI_IO_SIZE;
>  	r = device__register(&vesa_device);
>  	if (r < 0)
>  		return ERR_PTR(r);

