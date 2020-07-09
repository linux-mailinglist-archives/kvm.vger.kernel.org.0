Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F1021AA38
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 00:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgGIWD1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 18:03:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbgGIWD1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 18:03:27 -0400
Received: from localhost (mobile-166-175-191-139.mycingular.net [166.175.191.139])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6606620672;
        Thu,  9 Jul 2020 22:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594332206;
        bh=qy6RYLxqUEQ6tzvfiO87oBuVPOTZPSC78p+1YdZ+m8Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=Tcyqn0001/W4HSpVVMSttjxDGnbeW2AW4UFrt2dv9KeR8l3GI1CNv3E1OHZyRDYww
         nPF5FmDipFiLiTXZi3tdzLy8HqYsW6W+H/KHb1GKEEFLNVGHMx/UecWCJx4qqylvOc
         MjUPRFX1u7sNHGVNdbKqkncEBB+t2PT8KTLpkfkw=
Date:   Thu, 9 Jul 2020 17:03:24 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] PCI: Move PCI_VENDOR_ID_REDHAT definition to pci_ids.h
Message-ID: <20200709220324.GA21641@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594195170-11119-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[+cc Kirti, Alex, kvm]

On Wed, Jul 08, 2020 at 03:59:30PM +0800, Huacai Chen wrote:
> Instead of duplicating the PCI_VENDOR_ID_REDHAT definition everywhere,
> move it to include/linux/pci_ids.h is better.
> 
> Signed-off-by: Huacai Chen <chenhc@lemote.com>

Applied with Gerd's ack to pci/misc for v5.9, thanks!

I also updated this in samples/vfio-mdev/mdpy-defs.h:

  -#define MDPY_PCI_VENDOR_ID     0x1b36 /* redhat */
  +#define MDPY_PCI_VENDOR_ID     PCI_VENDOR_ID_REDHAT

> ---
>  drivers/gpu/drm/qxl/qxl_dev.h           | 2 --
>  drivers/net/ethernet/rocker/rocker_hw.h | 1 -
>  include/linux/pci_ids.h                 | 2 ++
>  3 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/qxl/qxl_dev.h b/drivers/gpu/drm/qxl/qxl_dev.h
> index a0ee416..a7bc31f 100644
> --- a/drivers/gpu/drm/qxl/qxl_dev.h
> +++ b/drivers/gpu/drm/qxl/qxl_dev.h
> @@ -131,8 +131,6 @@ enum SpiceCursorType {
>  
>  #pragma pack(push, 1)
>  
> -#define REDHAT_PCI_VENDOR_ID 0x1b36
> -
>  /* 0x100-0x11f reserved for spice, 0x1ff used for unstable work */
>  #define QXL_DEVICE_ID_STABLE 0x0100
>  
> diff --git a/drivers/net/ethernet/rocker/rocker_hw.h b/drivers/net/ethernet/rocker/rocker_hw.h
> index 59f1f8b..62fd84c 100644
> --- a/drivers/net/ethernet/rocker/rocker_hw.h
> +++ b/drivers/net/ethernet/rocker/rocker_hw.h
> @@ -25,7 +25,6 @@ enum {
>  
>  #define ROCKER_FP_PORTS_MAX 62
>  
> -#define PCI_VENDOR_ID_REDHAT		0x1b36
>  #define PCI_DEVICE_ID_REDHAT_ROCKER	0x0006
>  
>  #define ROCKER_PCI_BAR0_SIZE		0x2000
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index 0ad5769..5c709a1 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2585,6 +2585,8 @@
>  
>  #define PCI_VENDOR_ID_ASMEDIA		0x1b21
>  
> +#define PCI_VENDOR_ID_REDHAT		0x1b36
> +
>  #define PCI_VENDOR_ID_AMAZON_ANNAPURNA_LABS	0x1c36
>  
>  #define PCI_VENDOR_ID_CIRCUITCO		0x1cc8
> -- 
> 2.7.0
> 
