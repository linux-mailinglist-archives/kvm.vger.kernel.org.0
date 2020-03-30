Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6671977DE
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 11:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbgC3J2Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 05:28:25 -0400
Received: from foss.arm.com ([217.140.110.172]:48266 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728031AbgC3J2Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 05:28:24 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CDE1331B;
        Mon, 30 Mar 2020 02:28:23 -0700 (PDT)
Received: from [192.168.3.111] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C85643F52E;
        Mon, 30 Mar 2020 02:28:22 -0700 (PDT)
Subject: Re: [PATCH v3 kvmtool 08/32] pci: Fix ioport allocation size
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        sami.mujawar@arm.com, lorenzo.pieralisi@arm.com,
        Julien Thierry <julien.thierry@arm.com>
References: <20200326152438.6218-1-alexandru.elisei@arm.com>
 <20200326152438.6218-9-alexandru.elisei@arm.com>
From:   =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Autocrypt: addr=andre.przywara@arm.com; prefer-encrypt=mutual; keydata=
 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
 i4aIXCH3Wv6K
X-Enigmail-Draft-Status: N11100
Organization: ARM Ltd.
Message-ID: <0dc3bf33-d2e0-66f7-c399-0585e744307b@arm.com>
Date:   Mon, 30 Mar 2020 10:27:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200326152438.6218-9-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/03/2020 15:24, Alexandru Elisei wrote:
> From: Julien Thierry <julien.thierry@arm.com>

Hi,

> The PCI Local Bus Specification, Rev. 3.0,
> Section 6.2.5.1. "Address Maps" states:
> "Devices that map control functions into I/O Space must not consume more
> than 256 bytes per I/O Base Address register."
> 
> Yet all the PCI devices allocate IO ports of IOPORT_SIZE (= 1024 bytes).
> 
> Fix this by having PCI devices use 256 bytes ports for IO BARs.
> 
> There is no hard requirement on the size of the memory region described
> by memory BARs. Since BAR 1 is supposed to offer the same functionality as
> IO ports, let's make its size match BAR 0.
> 
> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
> [Added rationale for changing BAR1 size to PCI_IO_SIZE]
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  hw/vesa.c            |  4 ++--
>  include/kvm/ioport.h |  1 -
>  pci.c                |  2 +-
>  virtio/pci.c         | 15 +++++++--------
>  4 files changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/hw/vesa.c b/hw/vesa.c
> index 24fb46faad3b..d8d91aa9c873 100644
> --- a/hw/vesa.c
> +++ b/hw/vesa.c
> @@ -63,8 +63,8 @@ struct framebuffer *vesa__init(struct kvm *kvm)
>  
>  	if (!kvm->cfg.vnc && !kvm->cfg.sdl && !kvm->cfg.gtk)
>  		return NULL;
> -	r = pci_get_io_port_block(IOPORT_SIZE);
> -	r = ioport__register(kvm, r, &vesa_io_ops, IOPORT_SIZE, NULL);
> +	r = pci_get_io_port_block(PCI_IO_SIZE);
> +	r = ioport__register(kvm, r, &vesa_io_ops, PCI_IO_SIZE, NULL);
>  	if (r < 0)
>  		return ERR_PTR(r);
>  
> diff --git a/include/kvm/ioport.h b/include/kvm/ioport.h
> index b10fcd5b4412..8c86b7151f25 100644
> --- a/include/kvm/ioport.h
> +++ b/include/kvm/ioport.h
> @@ -14,7 +14,6 @@
>  
>  /* some ports we reserve for own use */
>  #define IOPORT_DBG			0xe0
> -#define IOPORT_SIZE			0x400
>  
>  struct kvm;
>  
> diff --git a/pci.c b/pci.c
> index 80b5c5d3d7f3..b6892d974c08 100644
> --- a/pci.c
> +++ b/pci.c
> @@ -20,7 +20,7 @@ static u16 io_port_blocks		= PCI_IOPORT_START;
>  
>  u16 pci_get_io_port_block(u32 size)
>  {
> -	u16 port = ALIGN(io_port_blocks, IOPORT_SIZE);
> +	u16 port = ALIGN(io_port_blocks, PCI_IO_SIZE);
>  
>  	io_port_blocks = port + size;
>  	return port;
> diff --git a/virtio/pci.c b/virtio/pci.c
> index d73414abde05..eeb5b5efa6e1 100644
> --- a/virtio/pci.c
> +++ b/virtio/pci.c
> @@ -421,7 +421,7 @@ static void virtio_pci__io_mmio_callback(struct kvm_cpu *vcpu,
>  {
>  	struct virtio_pci *vpci = ptr;
>  	int direction = is_write ? KVM_EXIT_IO_OUT : KVM_EXIT_IO_IN;
> -	u16 port = vpci->port_addr + (addr & (IOPORT_SIZE - 1));
> +	u16 port = vpci->port_addr + (addr & (PCI_IO_SIZE - 1));
>  
>  	kvm__emulate_io(vcpu, port, data, direction, len, 1);
>  }
> @@ -435,17 +435,16 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>  	vpci->kvm = kvm;
>  	vpci->dev = dev;
>  
> -	BUILD_BUG_ON(!is_power_of_two(IOPORT_SIZE));
>  	BUILD_BUG_ON(!is_power_of_two(PCI_IO_SIZE));
>  
> -	r = pci_get_io_port_block(IOPORT_SIZE);
> -	r = ioport__register(kvm, r, &virtio_pci__io_ops, IOPORT_SIZE, vdev);
> +	r = pci_get_io_port_block(PCI_IO_SIZE);
> +	r = ioport__register(kvm, r, &virtio_pci__io_ops, PCI_IO_SIZE, vdev);
>  	if (r < 0)
>  		return r;
>  	vpci->port_addr = (u16)r;
>  
> -	vpci->mmio_addr = pci_get_mmio_block(IOPORT_SIZE);
> -	r = kvm__register_mmio(kvm, vpci->mmio_addr, IOPORT_SIZE, false,
> +	vpci->mmio_addr = pci_get_mmio_block(PCI_IO_SIZE);
> +	r = kvm__register_mmio(kvm, vpci->mmio_addr, PCI_IO_SIZE, false,
>  			       virtio_pci__io_mmio_callback, vpci);
>  	if (r < 0)
>  		goto free_ioport;
> @@ -475,8 +474,8 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>  							| PCI_BASE_ADDRESS_SPACE_MEMORY),
>  		.status			= cpu_to_le16(PCI_STATUS_CAP_LIST),
>  		.capabilities		= (void *)&vpci->pci_hdr.msix - (void *)&vpci->pci_hdr,
> -		.bar_size[0]		= cpu_to_le32(IOPORT_SIZE),
> -		.bar_size[1]		= cpu_to_le32(IOPORT_SIZE),
> +		.bar_size[0]		= cpu_to_le32(PCI_IO_SIZE),
> +		.bar_size[1]		= cpu_to_le32(PCI_IO_SIZE),
>  		.bar_size[2]		= cpu_to_le32(PCI_IO_SIZE*2),
>  	};
>  
> 

