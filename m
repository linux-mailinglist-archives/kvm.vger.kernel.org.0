Return-Path: <kvm+bounces-69633-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KMDbJ5Hde2kdJAIAu9opvQ
	(envelope-from <kvm+bounces-69633-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 23:22:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 49253B5429
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 23:22:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 06A543019839
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:22:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D84E36AB70;
	Thu, 29 Jan 2026 22:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="JFbmvvQb"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C5EF30AACA;
	Thu, 29 Jan 2026 22:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769725323; cv=none; b=LEgVzYFc8Jk8pjy8oH1KC8K78HR1PaYnb3YQ3AB1zgVbtkcXqbo2giE7A4nubFmoVYeuurnA2Cj58RB9+t+/Z2g8oL/fp4TSUU2WIKxyOAkbL91Lhqgy/2zQ7EbpmpSYm8Kl8OuuwFrq/RQVGzZjIT7z0xJcXswR0/PsStMpbHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769725323; c=relaxed/simple;
	bh=YOhuPnqO0WqEosTb6OgiV/9VaOPjLa3inOLH+4qFvDA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WzHcpn57YuO0RlGgmxpnfOKVY2+HotJ3nUSXVOJUwzs6znaG290TrHjO9QP7HiDNC+PSV5KCWpIkIV/v8vXgHjS14A1hPfft2U8PKvLW1Tep7AZ3UK0QBxyoFAQ53V0GeQiDbNTUjFr001zSEtBWahMuXz5Of5gL5HicFAt1G/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=JFbmvvQb; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from localhost (unknown [40.65.108.177])
	by linux.microsoft.com (Postfix) with ESMTPSA id 5D12120B7168;
	Thu, 29 Jan 2026 14:22:00 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5D12120B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1769725321;
	bh=l69U1dIrB2ccHzImzegm889MzCj0l8Bz/N1WHXvfoHo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JFbmvvQbSZuWgKtGygvkszx2JeEWdtJpgkKy9JrbMd/Wd5/9p+qh8F8DQZUL3TZRu
	 2F9IotVi63Q1+5xtXPAj5Z5VpgM5SnxXvlYLMhpARcjtNuquJ02rdkhqPezl4x+bzG
	 YQ4Gy7p2dGglcG8jvPE5kn+665aOMwS0WLDY/OxQ=
Date: Thu, 29 Jan 2026 14:21:58 -0800
From: Jacob Pan <jacob.pan@linux.microsoft.com>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Adithya Jayachandran
 <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, Alex Mastro
 <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, Andrew Morton
 <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, Bjorn
 Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, David Rientjes
 <rientjes@google.com>, Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke
 <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>,
 kexec@lists.infradead.org, kvm@vger.kernel.org, Leon Romanovsky
 <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, "=?UTF-8?Q?Mic?=
 =?UTF-8?Q?ha=C5=82?= Winiarski" <michal.winiarski@intel.com>, Mike Rapoport
 <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>,
 Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta
 <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed
 <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, Shuah Khan
 <skhan@linuxfoundation.org>, "Thomas =?UTF-8?Q?Hellstr=C3=B6m?="
 <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>,
 Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy
 <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu
 <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 10/22] vfio/pci: Skip reset of preserved device after
 Live Update
Message-ID: <20260129142158.00004cdc@linux.microsoft.com>
In-Reply-To: <20260129212510.967611-11-dmatlack@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
	<20260129212510.967611-11-dmatlack@google.com>
Organization: LSG
X-Mailer: Claws Mail 3.21.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.microsoft.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[linux.microsoft.com:s=default];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69633-lists,kvm=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FREEMAIL_CC(0.00)[shazbot.org,nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	RCPT_COUNT_TWELVE(0.00)[44];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	HAS_ORG_HEADER(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jacob.pan@linux.microsoft.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[linux.microsoft.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.microsoft.com:mid,linux.microsoft.com:dkim]
X-Rspamd-Queue-Id: 49253B5429
X-Rspamd-Action: no action

Hi David,

On Thu, 29 Jan 2026 21:24:57 +0000
David Matlack <dmatlack@google.com> wrote:

> From: Vipin Sharma <vipinsh@google.com>
>=20
> Do not reset the device when a Live Update preserved vfio-pci device
> is retrieved and first enabled. vfio_pci_liveupdate_freeze()
> guarantees the device is reset prior to Live Update, so there's no
> reason to reset it again after Live Update.
>=20
> Since VFIO normally uses the initial reset to detect if the device
> supports function resets, pass that from the previous kernel via
> struct vfio_pci_core_dev_ser.
>=20
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c       | 22 +++++++++++++++++-----
>  drivers/vfio/pci/vfio_pci_liveupdate.c |  1 +
>  include/linux/kho/abi/vfio_pci.h       |  2 ++
>  include/linux/vfio_pci_core.h          |  1 +
>  4 files changed, 21 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/vfio_pci_core.c
> b/drivers/vfio/pci/vfio_pci_core.c index b01b94d81e28..c9f73f597797
> 100644 --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -515,12 +515,24 @@ int vfio_pci_core_enable(struct
> vfio_pci_core_device *vdev) if (ret)
>  		goto out_power;
> =20
> -	/* If reset fails because of the device lock, fail this path
> entirely */
> -	ret =3D pci_try_reset_function(pdev);
> -	if (ret =3D=3D -EAGAIN)
> -		goto out_disable_device;
> +	if (vdev->liveupdate_incoming_state) {
> +		/*
> +		 * This device was preserved by the previous kernel
> across a
> +		 * Live Update, so it does not need to be reset.
> +		 */
> +		vdev->reset_works =3D
> vdev->liveupdate_incoming_state->reset_works;
Just wondering what happened to skipping the bus master clearing. I
understand this version does not preserve the device itself yet; I=E2=80=99m
just curious whether there were specific difficulties that led to
dropping the earlier patch which skipped clearing bus master.

> +	} else {
> +		/*
> +		 * If reset fails because of the device lock, fail
> this path
> +		 * entirely.
> +		 */
> +		ret =3D pci_try_reset_function(pdev);
> +		if (ret =3D=3D -EAGAIN)
> +			goto out_disable_device;
> +
> +		vdev->reset_works =3D !ret;
> +	}
> =20
> -	vdev->reset_works =3D !ret;
>  	pci_save_state(pdev);
>  	vdev->pci_saved_state =3D pci_store_saved_state(pdev);
>  	if (!vdev->pci_saved_state)
> diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c
> b/drivers/vfio/pci/vfio_pci_liveupdate.c index
> 1ad7379c70c4..c52d6bdb455f 100644 ---
> a/drivers/vfio/pci/vfio_pci_liveupdate.c +++
> b/drivers/vfio/pci/vfio_pci_liveupdate.c @@ -57,6 +57,7 @@ static int
> vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)=20
>  	ser->bdf =3D pci_dev_id(pdev);
>  	ser->domain =3D pci_domain_nr(pdev->bus);
> +	ser->reset_works =3D vdev->reset_works;
> =20
>  	args->serialized_data =3D virt_to_phys(ser);
>  	return 0;
> diff --git a/include/linux/kho/abi/vfio_pci.h
> b/include/linux/kho/abi/vfio_pci.h index 9bf58a2f3820..6c3d3c6dfc09
> 100644 --- a/include/linux/kho/abi/vfio_pci.h
> +++ b/include/linux/kho/abi/vfio_pci.h
> @@ -34,10 +34,12 @@
>   *
>   * @bdf: The device's PCI bus, device, and function number.
>   * @domain: The device's PCI domain number (segment).
> + * @reset_works: Non-zero if the device supports function resets.
>   */
>  struct vfio_pci_core_device_ser {
>  	u16 bdf;
>  	u16 domain;
> +	u8 reset_works;
>  } __packed;
> =20
>  #endif /* _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H */
> diff --git a/include/linux/vfio_pci_core.h
> b/include/linux/vfio_pci_core.h index 350c30f84a13..95835298e29e
> 100644 --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -16,6 +16,7 @@
>  #include <linux/types.h>
>  #include <linux/uuid.h>
>  #include <linux/notifier.h>
> +#include <linux/kho/abi/vfio_pci.h>
> =20
>  #ifndef VFIO_PCI_CORE_H
>  #define VFIO_PCI_CORE_H


