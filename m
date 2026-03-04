Return-Path: <kvm+bounces-72624-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +EQ8GMB5p2kshwAAu9opvQ
	(envelope-from <kvm+bounces-72624-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 01:16:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A6E8A1F8C8A
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 01:15:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4F8153078EA8
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 00:13:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB75B150997;
	Wed,  4 Mar 2026 00:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="UaK4RJgX";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="T65tGGoN"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE8D1A275;
	Wed,  4 Mar 2026 00:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772583237; cv=none; b=Xi+vgjaKYw8uuZGWdrDLNRLpdEjndAT8T7zuXrw77GgYhyNC3qrC4Ucj4uPm3x55k11dO5i8pCO5bvdtqiThK5qFWxq7W3ghMGP+hGIDX9hFLQHHrT/1Y2IsygRvzJlTMrUBPMpZjzeOkQuG0I2iEeujXoYkExqnTe2F1nPOAk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772583237; c=relaxed/simple;
	bh=iedQR2Yn0yW0ctSKeGQxwEmjN4tBn9D/VlqGr3+6RPo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sDj3fxGRI/JNJxWMdzM7aSV5Pk4wBHOxvX93fByPTsGAPXLbYzuRi0iuGl7cD65h2akRw9t3Pbj89X7XQMDHww4eIy14P4FSJzCyskBPgxhGNSZPut9228dwrDx9I/MH10/KxFUGDqRaVWkYS9kWdinHs1y/J0lY7zt3huabnQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=UaK4RJgX; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=T65tGGoN; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id B77B01D00187;
	Tue,  3 Mar 2026 19:13:52 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Tue, 03 Mar 2026 19:13:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772583232;
	 x=1772669632; bh=e0mrxs5IMYGcdk+EMr2nADxwsrU1E+sBH4OceEOUCfQ=; b=
	UaK4RJgX2LFpsT/94nM5gmcaqlYFcomKpMYQDQcS7bPgqkj06RmlMALxNBCbgNKC
	JhXww8cb2tiSAhnY+Gyz0QyNdMGGqnwnAYj1FcFG44QmO4WWGoEqW7Rm9r4DZdpg
	EcaN4bsyRXRN24AvLjYGejXWsMRhL3asJ0xT67yPf0imYbOohb01Ai/QkXRsQH0Z
	u5a/B8Vnm+VM2lygYzxNlXkwsfx6SU6wDxjvlK0HMIL75BBWsgC/iBXlFwRarskF
	ZQYUB+DK5pfrCBjEt95Kr7QIcCZZ7FvgUTpJXxOzSI/NCE/t4D8rJZ5j1wTuo1Fr
	6VWw76kfc945VWLtMrg5/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1772583232; x=
	1772669632; bh=e0mrxs5IMYGcdk+EMr2nADxwsrU1E+sBH4OceEOUCfQ=; b=T
	65tGGoNRHpYicmh2FSoauJPdiGncntpL3WBj6679E7ppnk/Yq/ugTWPMeoViZ6M8
	YjABYLWfYlF+gCiSKqWb86gYfCKCrp1BdIbysI22BXiR4zwlzIjd8z0QQ3OCQnjJ
	repeRcQOGkTHayrDcDO/xc+KKTkxtEKxPlN3245asq4A/uvoHk4n+F1Wo+78/j7c
	BVrQpw5ACbGHu2LerQzoE5fPCZjMAOD+9x+2YfmINcHQW1hTtavzQewH6gI9HFcf
	GSVq8eDQI5CNNPjgEn/nD4xvk6K4OlVUEuZWt2Z+xn3PASF/X8KGpl9MPXW0e1cm
	IrseMMEOoJwz5cRbssKlg==
X-ME-Sender: <xms:QHmnab3E0zaXYt8Bmgm7-1QKD7uZTIHdopngEd7WErd1lxyUk5hftg>
    <xme:QHmnafTZqA_cdYzQnZ-zOpvLBf2zNW_cExDxQpep-tiZvoSRVI_hxiHVXumQ73_Pm
    jqAoeAWcClVGdOC8ZjwVyp_YrsAelxoBf1XQeuhM2m0H69X9QcYqg>
X-ME-Received: <xmr:QHmnafSMEAMJg_miIgjWDte2Zr-06lgCbneTJkQE-LF-Nw2v_38BfBn8jgI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddviedvtddtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfgjfhfogggtgfesthejre
    dtredtvdenucfhrhhomheptehlvgigucghihhllhhirghmshhonhcuoegrlhgvgiesshhh
    rgiisghothdrohhrgheqnecuggftrfgrthhtvghrnhepvdekfeejkedvudfhudfhteekud
    fgudeiteetvdeukedvheetvdekgfdugeevueeunecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomheprghlvgigsehshhgriigsohhtrdhorhhgpdhnsg
    gprhgtphhtthhopedugedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghnkhhi
    thgrsehnvhhiughirgdrtghomhdprhgtphhtthhopehvshgvthhhihesnhhvihguihgrrd
    gtohhmpdhrtghpthhtohepjhhgghesnhhvihguihgrrdgtohhmpdhrtghpthhtohepmhho
    tghhshesnhhvihguihgrrdgtohhmpdhrtghpthhtohepjhhgghesiihivghpvgdrtggrpd
    hrtghpthhtohepshhkohhlohhthhhumhhthhhosehnvhhiughirgdrtghomhdprhgtphht
    thhopegtjhhirgesnhhvihguihgrrdgtohhmpdhrtghpthhtohepiihhihifsehnvhhiug
    hirgdrtghomhdprhgtphhtthhopehkjhgrjhhusehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:QHmnaQV7vVNDYAR1jRI0JsTsxQaCWvUGMqqMti38xXmeAEOJ0fK2ag>
    <xmx:QHmnaZJyS4XVPNZQO6PaPQW6jmFh5J6Q-6Kc2TB9n9AD-T6mhnKXWQ>
    <xmx:QHmnaRh0hwVoirkM2uMRrWX8MsM6fXAHZnpPoQtce61BL0hgiwW5cQ>
    <xmx:QHmnaWKP1SVjNF1AXLcqXwzNafJ1v1r5s44j11Xj7HGU9f_aDARzTA>
    <xmx:QHmnabj5aC2qiNaJdDSjXSLMGbhuO3FGFAOshyDC_AqSQ4SDGbI6kkAZ>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 3 Mar 2026 19:13:51 -0500 (EST)
Date: Tue, 3 Mar 2026 17:13:49 -0700
From: Alex Williamson <alex@shazbot.org>
To: <ankita@nvidia.com>
Cc: <vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
 <jgg@ziepe.ca>, <skolothumtho@nvidia.com>, <cjia@nvidia.com>,
 <zhiw@nvidia.com>, <kjaju@nvidia.com>, <yishaih@nvidia.com>,
 <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, alex@shazbot.org
Subject: Re: [PATCH RFC v2 02/15] vfio/nvgrace-gpu: Create auxiliary device
 for EGM
Message-ID: <20260303171349.36be0589@shazbot.org>
In-Reply-To: <20260223155514.152435-3-ankita@nvidia.com>
References: <20260223155514.152435-1-ankita@nvidia.com>
	<20260223155514.152435-3-ankita@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A6E8A1F8C8A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[shazbot.org,none];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm3,messagingengine.com:s=fm1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72624-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_TWELVE(0.00)[14]
X-Rspamd-Action: no action

On Mon, 23 Feb 2026 15:55:01 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> The Extended GPU Memory (EGM) feature enables the GPU access to
> the system memory across sockets and physical systems on the
> Grace Hopper and Grace Blackwell systems. When the feature is
> enabled through SBIOS, part of the system memory is made available
> to the GPU for access through EGM path.
> 
> The EGM functionality is separate and largely independent from the

"largely independent", what happens to access to the remote memory
through the GPU during reset?

In your KVM Forum presentation you show a remote CPU accessing EGM
memory through a local GPU, through the NVLink, though a remote GPU, to
the remote CPU memory.  Does this only work if all the GPUs in the path
are bound to nvgrace-gpu?

The ownership of these egm devices vs the vfio device seems dubious.

> core GPU device functionality. However, the EGM region information
> of base SPA and size is associated with the GPU on the ACPI tables.
> An architecture wih EGM represented as an auxiliary device suits well

s/wih/with/

> in this context.
> 
> The parent GPU device creates an EGM auxiliary device to be managed
> independently by an auxiliary EGM driver. The EGM region information
> is kept as part of the shared struct nvgrace_egm_dev along with the
> auxiliary device handle.
> 
> Each socket has a separate EGM region and hence a multi-socket system
> have multiple EGM regions. Each EGM region has a separate nvgrace_egm_dev
> and the nvgrace-gpu keeps the EGM regions as part of a list.
> 
> Note that EGM is an optional feature enabled through SBIOS. The EGM
> properties are only populated in ACPI tables if the feature is enabled;
> they are absent otherwise. The absence of the properties is thus not
> considered fatal. The presence of improper set of values however are
> considered fatal.
> 
> It is also noteworthy that there may also be multiple GPUs present per
> socket and have duplicate EGM region information with them. Make sure
> the duplicate data does not get added.

De-duplication isn't done until the next patch.

> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  MAINTAINERS                            |  5 +-
>  drivers/vfio/pci/nvgrace-gpu/Makefile  |  2 +-
>  drivers/vfio/pci/nvgrace-gpu/egm_dev.c | 61 +++++++++++++++++++++
>  drivers/vfio/pci/nvgrace-gpu/egm_dev.h | 17 ++++++
>  drivers/vfio/pci/nvgrace-gpu/main.c    | 76 +++++++++++++++++++++++++-
>  include/linux/nvgrace-egm.h            | 23 ++++++++
>  6 files changed, 181 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/vfio/pci/nvgrace-gpu/egm_dev.c
>  create mode 100644 drivers/vfio/pci/nvgrace-gpu/egm_dev.h
>  create mode 100644 include/linux/nvgrace-egm.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 765ad2daa218..5b3d86de9ec0 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -27379,7 +27379,10 @@ VFIO NVIDIA GRACE GPU DRIVER
>  M:	Ankit Agrawal <ankita@nvidia.com>
>  L:	kvm@vger.kernel.org
>  S:	Supported
> -F:	drivers/vfio/pci/nvgrace-gpu/
> +F:	drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> +F:	drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> +F:	drivers/vfio/pci/nvgrace-gpu/main.c

This was better before, you own the sub-directory, we don't need to
list each file and it adds maintenance.

> +F:	include/linux/nvgrace-egm.h
>  
>  VFIO PCI DEVICE SPECIFIC DRIVERS
>  R:	Jason Gunthorpe <jgg@nvidia.com>
> diff --git a/drivers/vfio/pci/nvgrace-gpu/Makefile b/drivers/vfio/pci/nvgrace-gpu/Makefile
> index 3ca8c187897a..e72cc6739ef8 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/Makefile
> +++ b/drivers/vfio/pci/nvgrace-gpu/Makefile
> @@ -1,3 +1,3 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  obj-$(CONFIG_NVGRACE_GPU_VFIO_PCI) += nvgrace-gpu-vfio-pci.o
> -nvgrace-gpu-vfio-pci-y := main.o
> +nvgrace-gpu-vfio-pci-y := main.o egm_dev.o
> diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> new file mode 100644
> index 000000000000..faf658723f7a
> --- /dev/null
> +++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> @@ -0,0 +1,61 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES. All rights reserved

2026

> + */
> +
> +#include <linux/vfio_pci_core.h>
> +#include "egm_dev.h"
> +
> +/*
> + * Determine if the EGM feature is enabled. If disabled, there
> + * will be no EGM properties populated in the ACPI tables and this
> + * fetch would fail.
> + */
> +int nvgrace_gpu_has_egm_property(struct pci_dev *pdev, u64 *pegmpxm)
> +{
> +	return device_property_read_u64(&pdev->dev, "nvidia,egm-pxm",
> +					pegmpxm);
> +}
> +
> +static void nvgrace_gpu_release_aux_device(struct device *device)
> +{
> +	struct auxiliary_device *aux_dev = container_of(device, struct auxiliary_device, dev);
> +	struct nvgrace_egm_dev *egm_dev = container_of(aux_dev, struct nvgrace_egm_dev, aux_dev);
> +
> +	kvfree(egm_dev);

This was allocated with kzalloc() it should use kfree() not kvfree().

> +}
> +
> +struct nvgrace_egm_dev *
> +nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
> +			      u64 egmpxm)
> +{
> +	struct nvgrace_egm_dev *egm_dev;
> +	int ret;
> +
> +	egm_dev = kzalloc(sizeof(*egm_dev), GFP_KERNEL);
> +	if (!egm_dev)
> +		goto create_err;
> +
> +	egm_dev->egmpxm = egmpxm;
> +	egm_dev->aux_dev.id = egmpxm;
> +	egm_dev->aux_dev.name = name;
> +	egm_dev->aux_dev.dev.release = nvgrace_gpu_release_aux_device;
> +	egm_dev->aux_dev.dev.parent = &pdev->dev;
> +
> +	ret = auxiliary_device_init(&egm_dev->aux_dev);
> +	if (ret)
> +		goto free_dev;
> +
> +	ret = auxiliary_device_add(&egm_dev->aux_dev);
> +	if (ret) {
> +		auxiliary_device_uninit(&egm_dev->aux_dev);
> +		goto free_dev;

There's a double free here, from auxiliary_device_init():

 * It returns 0 on success.  On success, the device_initialize has been
 * performed.  After this point any error unwinding will need to include a call
 * to auxiliary_device_uninit().  In this post-initialize error scenario, a call
 * to the device's .release callback will be triggered, and all memory clean-up
 * is expected to be handled there.


> +	}
> +
> +	return egm_dev;
> +
> +free_dev:
> +	kvfree(egm_dev);
> +create_err:
> +	return NULL;
> +}
> diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.h b/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> new file mode 100644
> index 000000000000..c00f5288f4e7
> --- /dev/null
> +++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> @@ -0,0 +1,17 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES. All rights reserved

2026

> + */
> +
> +#ifndef EGM_DEV_H
> +#define EGM_DEV_H
> +
> +#include <linux/nvgrace-egm.h>
> +
> +int nvgrace_gpu_has_egm_property(struct pci_dev *pdev, u64 *pegmpxm);
> +
> +struct nvgrace_egm_dev *
> +nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
> +			      u64 egmphys);

egmpxm

> +
> +#endif /* EGM_DEV_H */
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index 7c4d51f5c701..23028e6e7192 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -10,6 +10,8 @@
>  #include <linux/pci-p2pdma.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/memory-failure.h>
> +#include <linux/nvgrace-egm.h>
> +#include "egm_dev.h"
>  
>  /*
>   * The device memory usable to the workloads running in the VM is cached
> @@ -66,6 +68,68 @@ struct nvgrace_gpu_pci_core_device {
>  	bool reset_done;
>  };
>  
> +/*
> + * Track egm device lists. Note that there is one device per socket.
> + * All the GPUs belonging to the same sockets are associated with
> + * the EGM device for that socket.
> + */
> +static struct list_head egm_dev_list;

As Shameer notes, this list needs locking to avoid concurrent
operation corruption.  I'd also question why we're tracking this list
in the main code of the nvgrace-gpu driver rather than in the egm_dev
aux driver portion of the code.  It would be trivial to do
de-duplication in the create function if the list were over there.

> +
> +static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
> +{
> +	struct nvgrace_egm_dev_entry *egm_entry;
> +	u64 egmpxm;
> +	int ret = 0;
> +
> +	/*
> +	 * EGM is an optional feature enabled in SBIOS. If disabled, there
> +	 * will be no EGM properties populated in the ACPI tables and this
> +	 * fetch would fail. Treat this failure as non-fatal and return
> +	 * early.
> +	 */
> +	if (nvgrace_gpu_has_egm_property(pdev, &egmpxm))
> +		goto exit;

return 0;

> +
> +	egm_entry = kzalloc(sizeof(*egm_entry), GFP_KERNEL);
> +	if (!egm_entry)
> +		return -ENOMEM;
> +
> +	egm_entry->egm_dev =
> +		nvgrace_gpu_create_aux_device(pdev, NVGRACE_EGM_DEV_NAME,
> +					      egmpxm);
> +	if (!egm_entry->egm_dev) {
> +		kvfree(egm_entry);

kzalloc() -> kfree()

> +		ret = -EINVAL;

Why doesn't the previous function return ERR_PTR() to propagate the
errno through rather than clobber it?  We don't really need the goto
here for now either.

struct nvgrace_egm_dev egm_dev;

egm_dev = nvgrace_gpu_create...

if (IS_ERR(egm_dev)) {
	kfree(egm_entry);
	return ERR_PTR(egm_dev);
}

egm_entry->egm_dev = egm_dev;

> +		goto exit;
> +	}
> +
> +	list_add_tail(&egm_entry->list, &egm_dev_list);
> +
> +exit:

s/exit://

> +	return ret;

return 0;

> +}
> +
> +static void nvgrace_gpu_destroy_egm_aux_device(struct pci_dev *pdev)
> +{
> +	struct nvgrace_egm_dev_entry *egm_entry, *temp_egm_entry;
> +	u64 egmpxm;
> +
> +	if (nvgrace_gpu_has_egm_property(pdev, &egmpxm))
> +		return;
> +
> +	list_for_each_entry_safe(egm_entry, temp_egm_entry, &egm_dev_list, list) {
> +		/*
> +		 * Free the EGM region corresponding to the input GPU
> +		 * device.
> +		 */
> +		if (egm_entry->egm_dev->egmpxm == egmpxm) {
> +			auxiliary_device_destroy(&egm_entry->egm_dev->aux_dev);
> +			list_del(&egm_entry->list);
> +			kvfree(egm_entry);

kfree()

Why do we continue walking the list after we've found it?  Is this
because we don't yet do the de-duplication?

> +		}
> +	}
> +}
> +
>  static void nvgrace_gpu_init_fake_bar_emu_regs(struct vfio_device *core_vdev)
>  {
>  	struct nvgrace_gpu_pci_core_device *nvdev =
> @@ -1212,6 +1276,11 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
>  						    memphys, memlength);
>  		if (ret)
>  			goto out_put_vdev;
> +
> +		ret = nvgrace_gpu_create_egm_aux_device(pdev);
> +		if (ret)
> +			goto out_put_vdev;
> +
>  		nvdev->core_device.pci_ops = &nvgrace_gpu_pci_dev_ops;
>  	} else {
>  		nvdev->core_device.pci_ops = &nvgrace_gpu_pci_dev_core_ops;
> @@ -1219,10 +1288,12 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
>  
>  	ret = vfio_pci_core_register_device(&nvdev->core_device);
>  	if (ret)
> -		goto out_put_vdev;
> +		goto out_reg;
>  
>  	return ret;
>  
> +out_reg:
> +	nvgrace_gpu_destroy_egm_aux_device(pdev);
>  out_put_vdev:
>  	vfio_put_device(&nvdev->core_device.vdev);
>  	return ret;
> @@ -1232,6 +1303,7 @@ static void nvgrace_gpu_remove(struct pci_dev *pdev)
>  {
>  	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
>  
> +	nvgrace_gpu_destroy_egm_aux_device(pdev);

I'm curious how this will handle the lifecycle issues if the device is
unbound from the nvgrace-gpu driver while the aux egm device is still
in use...

>  	vfio_pci_core_unregister_device(core_device);
>  	vfio_put_device(&core_device->vdev);
>  }
> @@ -1289,6 +1361,8 @@ static struct pci_driver nvgrace_gpu_vfio_pci_driver = {
>  
>  static int __init nvgrace_gpu_vfio_pci_init(void)
>  {
> +	INIT_LIST_HEAD(&egm_dev_list);
> +
>  	return pci_register_driver(&nvgrace_gpu_vfio_pci_driver);
>  }
>  module_init(nvgrace_gpu_vfio_pci_init);
> diff --git a/include/linux/nvgrace-egm.h b/include/linux/nvgrace-egm.h
> new file mode 100644
> index 000000000000..9575d4ad4338
> --- /dev/null
> +++ b/include/linux/nvgrace-egm.h
> @@ -0,0 +1,23 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES. All rights reserved

2026

> + */
> +
> +#ifndef NVGRACE_EGM_H
> +#define NVGRACE_EGM_H
> +
> +#include <linux/auxiliary_bus.h>
> +
> +#define NVGRACE_EGM_DEV_NAME "egm"
> +
> +struct nvgrace_egm_dev {
> +	struct auxiliary_device aux_dev;
> +	u64 egmpxm;
> +};
> +
> +struct nvgrace_egm_dev_entry {
> +	struct list_head list;
> +	struct nvgrace_egm_dev *egm_dev;
> +};

Looks like only nvgrace_egm_dev eventually requires a public header.
The list entry certainly doesn't need to be here.  Thanks,

Alex

