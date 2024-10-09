Return-Path: <kvm+bounces-28196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A65F2996434
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 10:57:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CAA421C248E9
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 08:57:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28B3C1990BB;
	Wed,  9 Oct 2024 08:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o9G7ZWkU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5B1198A01;
	Wed,  9 Oct 2024 08:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728463905; cv=none; b=ctsvPECxbQn8BXw4wVgy34rGKJ8FRFI94AdqK/tBep06JiOrqSLdNXj9avifBLuTtnvGv7xgSQNFHp0DmhObh325FRkuY14hTkaViLO+NdLT81N43lHVJAgnxn2V4nVPfhDFYQ8U8EvygCbG5aWKTYyLcVf+cdgZ4dV62Mz7Ibw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728463905; c=relaxed/simple;
	bh=b+116RTJglq8hKTMJPN3ihohHycl1ODOr7MG5VEIobs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GI7cZfTQA+tOxQ2HWseZr286hAcSUFhgPORiAvhl8LIN0ASvUBWHSw9ZT1P+J5jUFpZAZ30imHKq3Q+nJykUnP8e4WFM1oXgrLlgB9TWfER0C7mPUsBYa55Dn65n96V9pRFbO5nfh6SDad2XgBjcsBhGnZvUIOXKXF4l5A5Ox4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o9G7ZWkU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7B7C4CEC5;
	Wed,  9 Oct 2024 08:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728463904;
	bh=b+116RTJglq8hKTMJPN3ihohHycl1ODOr7MG5VEIobs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=o9G7ZWkUiZ2jhvq5Xffn69FYVlVdQLJ2vD2vq0OH8pOa8Pn2o184IsyAtOJxwSAhG
	 we51csfH2s/J3u4NwHuVw/Dua+LFoCmX2iprgUu13LHO8hXrFUkOJWqn6Yoe8JUNM5
	 UQzL1jZsg1xzOyZDIDpbPns/vU1fLfp7uT/2QwJ1ankVmgSZ7JxhyzIhIqq/GTlzo1
	 shGeQGD5ddN997v99g192UiOAWF2uno4uyLJUyM7z+ace2KK0y8tWbgtVRtOWwWwbH
	 wlL09TdEbFYJlE2bUuqk+VPUMQG/2vEwvQc44WN1H1e5n4GlbrhWh0e/Uq480U1VKK
	 RWMwG6nRnJW/g==
Message-ID: <95b23ff9-eb17-4e1c-b7a3-2d3691ffc48f@kernel.org>
Date: Wed, 9 Oct 2024 17:51:34 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 09/13] ata: Use always-managed version of pci_intx()
To: Philipp Stanner <pstanner@redhat.com>, Niklas Cassel <cassel@kernel.org>,
 Sergey Shtylyov <s.shtylyov@omp.ru>,
 Basavaraj Natikar <basavaraj.natikar@amd.com>, Jiri Kosina
 <jikos@kernel.org>, Benjamin Tissoires <bentiss@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alex Dubov
 <oakad@yahoo.com>, Sudarsana Kalluru <skalluru@marvell.com>,
 Manish Chopra <manishc@marvell.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Rasesh Mody <rmody@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
 Igor Mitsyanko <imitsyanko@quantenna.com>,
 Sergey Matyukevich <geomatsi@gmail.com>, Kalle Valo <kvalo@kernel.org>,
 Sanjay R Mehta <sanju.mehta@amd.com>,
 Shyam Sundar S K <Shyam-sundar.S-k@amd.com>, Jon Mason <jdmason@kudzu.us>,
 Dave Jiang <dave.jiang@intel.com>, Allen Hubbe <allenbh@gmail.com>,
 Bjorn Helgaas <bhelgaas@google.com>,
 Alex Williamson <alex.williamson@redhat.com>, Juergen Gross
 <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 Mario Limonciello <mario.limonciello@amd.com>, Chen Ni <nichen@iscas.ac.cn>,
 Ricky Wu <ricky_wu@realtek.com>, Al Viro <viro@zeniv.linux.org.uk>,
 Breno Leitao <leitao@debian.org>, Kevin Tian <kevin.tian@intel.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Mostafa Saleh <smostafa@google.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Hannes Reinecke <hare@suse.de>, John Garry <john.g.garry@oracle.com>,
 Soumya Negi <soumya.negi97@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Yi Liu <yi.l.liu@intel.com>, "Dr. David Alan Gilbert" <linux@treblig.org>,
 Christian Brauner <brauner@kernel.org>, Ankit Agrawal <ankita@nvidia.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Eric Auger <eric.auger@redhat.com>, Ye Bin <yebin10@huawei.com>,
 =?UTF-8?Q?Marek_Marczykowski-G=C3=B3recki?=
 <marmarek@invisiblethingslab.com>,
 Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Kai Vehmanen <kai.vehmanen@linux.intel.com>,
 Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
 Rui Salvaterra <rsalvaterra@gmail.com>, Marc Zyngier <maz@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-input@vger.kernel.org, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org, ntb@lists.linux.dev,
 linux-pci@vger.kernel.org, linux-staging@lists.linux.dev,
 kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
 linux-sound@vger.kernel.org
References: <20241009083519.10088-1-pstanner@redhat.com>
 <20241009083519.10088-10-pstanner@redhat.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241009083519.10088-10-pstanner@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/9/24 17:35, Philipp Stanner wrote:
> pci_intx() is a hybrid function which can sometimes be managed through
> devres. To remove this hybrid nature from pci_intx(), it is necessary to
> port users to either an always-managed or a never-managed version.
> 
> All users in ata enable their PCI-Device with pcim_enable_device(). Thus,
> they need the always-managed version.
> 
> Replace pci_intx() with pci_intx_unmanaged().

This contradicts the sentence above and the patche replaces pci_intx() with
pcim_intx()... So s/pci_intx_unmanaged/pcim_intx in the above sentence ?

> 
> Signed-off-by: Philipp Stanner <pstanner@redhat.com>
> ---
>  drivers/ata/ahci.c       | 2 +-
>  drivers/ata/ata_piix.c   | 2 +-
>  drivers/ata/pata_rdc.c   | 2 +-
>  drivers/ata/sata_sil24.c | 2 +-
>  drivers/ata/sata_sis.c   | 2 +-
>  drivers/ata/sata_uli.c   | 2 +-
>  drivers/ata/sata_vsc.c   | 2 +-
>  7 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index 45f63b09828a..9273ff3d4732 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -1985,7 +1985,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  
>  	if (ahci_init_msi(pdev, n_ports, hpriv) < 0) {
>  		/* legacy intx interrupts */
> -		pci_intx(pdev, 1);
> +		pcim_intx(pdev, 1);
>  	}
>  	hpriv->irq = pci_irq_vector(pdev, 0);
>  
> diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
> index 093b940bc953..d441246fa357 100644
> --- a/drivers/ata/ata_piix.c
> +++ b/drivers/ata/ata_piix.c
> @@ -1725,7 +1725,7 @@ static int piix_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	 * message-signalled interrupts currently).
>  	 */
>  	if (port_flags & PIIX_FLAG_CHECKINTR)
> -		pci_intx(pdev, 1);
> +		pcim_intx(pdev, 1);
>  
>  	if (piix_check_450nx_errata(pdev)) {
>  		/* This writes into the master table but it does not
> diff --git a/drivers/ata/pata_rdc.c b/drivers/ata/pata_rdc.c
> index 0a9689862f71..09792aac7f9d 100644
> --- a/drivers/ata/pata_rdc.c
> +++ b/drivers/ata/pata_rdc.c
> @@ -340,7 +340,7 @@ static int rdc_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  		return rc;
>  	host->private_data = hpriv;
>  
> -	pci_intx(pdev, 1);
> +	pcim_intx(pdev, 1);
>  
>  	host->flags |= ATA_HOST_PARALLEL_SCAN;
>  
> diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
> index 72c03cbdaff4..b771ebd41252 100644
> --- a/drivers/ata/sata_sil24.c
> +++ b/drivers/ata/sata_sil24.c
> @@ -1317,7 +1317,7 @@ static int sil24_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  
>  	if (sata_sil24_msi && !pci_enable_msi(pdev)) {
>  		dev_info(&pdev->dev, "Using MSI\n");
> -		pci_intx(pdev, 0);
> +		pcim_intx(pdev, 0);
>  	}
>  
>  	pci_set_master(pdev);
> diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
> index ef8724986de3..b8b6d9eff3b8 100644
> --- a/drivers/ata/sata_sis.c
> +++ b/drivers/ata/sata_sis.c
> @@ -290,7 +290,7 @@ static int sis_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	}
>  
>  	pci_set_master(pdev);
> -	pci_intx(pdev, 1);
> +	pcim_intx(pdev, 1);
>  	return ata_host_activate(host, pdev->irq, ata_bmdma_interrupt,
>  				 IRQF_SHARED, &sis_sht);
>  }
> diff --git a/drivers/ata/sata_uli.c b/drivers/ata/sata_uli.c
> index 60ea45926cd1..52894ff49dcb 100644
> --- a/drivers/ata/sata_uli.c
> +++ b/drivers/ata/sata_uli.c
> @@ -221,7 +221,7 @@ static int uli_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	}
>  
>  	pci_set_master(pdev);
> -	pci_intx(pdev, 1);
> +	pcim_intx(pdev, 1);
>  	return ata_host_activate(host, pdev->irq, ata_bmdma_interrupt,
>  				 IRQF_SHARED, &uli_sht);
>  }
> diff --git a/drivers/ata/sata_vsc.c b/drivers/ata/sata_vsc.c
> index d39b87537168..a53a2dfc1e17 100644
> --- a/drivers/ata/sata_vsc.c
> +++ b/drivers/ata/sata_vsc.c
> @@ -384,7 +384,7 @@ static int vsc_sata_init_one(struct pci_dev *pdev,
>  		pci_write_config_byte(pdev, PCI_CACHE_LINE_SIZE, 0x80);
>  
>  	if (pci_enable_msi(pdev) == 0)
> -		pci_intx(pdev, 0);
> +		pcim_intx(pdev, 0);
>  
>  	/*
>  	 * Config offset 0x98 is "Extended Control and Status Register 0"


-- 
Damien Le Moal
Western Digital Research

