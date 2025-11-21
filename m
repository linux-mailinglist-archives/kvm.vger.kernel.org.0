Return-Path: <kvm+bounces-64220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B691CC7B4D3
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:22:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7251B3A5A74
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:18:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AD6427F74B;
	Fri, 21 Nov 2025 18:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="lRWvFvhr";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Kwx619He"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A8E27CCF0;
	Fri, 21 Nov 2025 18:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763748976; cv=none; b=AhpM6TGkKKS+vcwrEkKfmZTna/GX6MRo7oJmA589WJ05zuuollcCUHMBry2nA3o1yQSf3F2IArwbMKRxa1w2co7kM0w92DXoyWqFHFCo/xjYnrt+GcxCATL5xlSuw73ofXnQhTPrir71zHyPM8vaBnFgRoKLwerraE8tEzKKCy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763748976; c=relaxed/simple;
	bh=yveYxf601gUI2WejABs9DgRT4X54E6FcQGEJxn0D/Bw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q470hMCp+IxdYQEE0HsHhWBCKBIuGhss9Ne16aZa1q1AvKak4ujru1wrPTDlEXahNUWkRZXS1Bpsti4wrZvu1NBeIXDsIkrxxB+9zH6WLFuCw60D1ubMk0CU8wjzY2rLcVN9RZu3emF3dcyl/CVHGqi1LmmRIBaDJn2o/QZfgBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=lRWvFvhr; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Kwx619He; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 228CB14001F7;
	Fri, 21 Nov 2025 13:16:08 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 21 Nov 2025 13:16:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1763748968;
	 x=1763835368; bh=zjME/9JSvWA92wOpgiUBcMVDsMJievSWU90Zl75g/PM=; b=
	lRWvFvhr1YL7KLcuicDeg0M6ZUD7FSO72Jv1GRsa+ulOOl4POzESTqQABrbaUWVa
	Rf1nZ6HQCkDWFwXHG7zUnI2R4au+DFShxQYXKWY/fRu0Jo1yGaa9cGMgJJ8qAeGm
	hYcJ2EOVusSkmji7qdC7sbcHt5ry2XweEyxrTpl6xnt3setfPMyTZfCIDlzYRb6s
	potRPuXWhez6502vib0Cw2yqZ+7HhbR6ewNPOhWlUBpLZA1fOBblJoK8J5EydCJY
	cfQcGOTgsUzcvXOXtMY3tfzrqsIQJSexgOhxg1gsDvi0qfq89kDOAiuzESfMbSLe
	Io0b7nQrc4rUYHRhEjRigw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1763748968; x=
	1763835368; bh=zjME/9JSvWA92wOpgiUBcMVDsMJievSWU90Zl75g/PM=; b=K
	wx619HekG9UL9FGH+ck5tG5OGbXA4EVgCJck7L0gGG8cx8FfJvopjzFNbZigngqu
	/F876Mpx6zpVs8VucixdIjKZNoLlZLO5GTKUmL/UScfWX8fzj4S/80zHizsISS7G
	4XygGoZxpy/erKXG0yH41f2SIxLz2PPhFQ6K/jlVnyPev7oaqx5VaCZc3e+wPZQC
	1ghVCdJ0P/wM/fqFIizwmon2iQHZiA1NE99o8j5Q0vSnpoRLHMjL31Q70InB/Gsv
	Mhp8A+OBrl82Ybcm0YVEa8uLYz/M0n0qVzKhpeR/XQixukXTvpqD8ROeVL/CfI0g
	FNkIS62Mw9CXgXu4W1Jvw==
X-ME-Sender: <xms:Z6wgabtzkvu40Pu-Goq8TVyVCY-9NFuank5KKDtnZ4CVc2XiDpIK8g>
    <xme:Z6wgaUkauLb0lSWgrEITI-cRmg-iEgdjfo33zRn6cLFNNxGBZUNGPFXPNDRt-j29Y
    SOIcd337owio3p2Hmz8ZZcXlOLWIOmHfI7PTi2akb_z6iBcNrevNA>
X-ME-Received: <xmr:Z6wgaeTU5YY30uRujYLcKiTWGqkzkdKuy56eX51nHReKg_ech7YVwVla>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvfedtieeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthhqredttddtjeenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhepgfffvdefjeejueevfeetudfhgeetfeeuheetfeekjedvuddvueehffdtgeej
    keetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hlvgigsehshhgriigsohhtrdhorhhgpdhnsggprhgtphhtthhopeduvddpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtohepmhhitghhrghlrdifihhnihgrrhhskhhisehinhhtvg
    hlrdgtohhmpdhrtghpthhtohepjhhgghesiihivghpvgdrtggrpdhrtghpthhtohepkhgv
    vhhinhdrthhirghnsehinhhtvghlrdgtohhmpdhrtghpthhtohephihishhhrghihhesnh
    hvihguihgrrdgtohhmpdhrtghpthhtoheplhhiuhhlohhnghhfrghngheshhhurgifvghi
    rdgtohhmpdhrtghpthhtohepshhkohhlohhthhhumhhthhhosehnvhhiughirgdrtghomh
    dprhgtphhtthhopegsrhgvthhtrdgtrhgvvghlvgihsegrmhgurdgtohhmpdhrtghpthht
    ohepghhiohhvrghnnhhirdgtrggsihguughusehinhhtvghlrdgtohhmpdhrtghpthhtoh
    epkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:Z6wgaaL7ujn7uSB11HYu-t-ZGIa83lGoQIwIDNlsuujiRcpJWTBD5w>
    <xmx:Z6wgaYHR-IS1_kbJ56TDS7z3_KOpmMfI9Y2f7Re36ygWBLGXZvv5cQ>
    <xmx:Z6wgaX25hJCopOqxymzvbzwak3gwbAQTzLX4xxqS0JL8XRu_mhzWtw>
    <xmx:Z6wgaQJTT8XgCDTBve0pimhht__LDFe-ihmewjdO4-CeVW2PyO5AHA>
    <xmx:aKwgabQacLkL89BpOfLj7rccYXVfrEJr_Vz57-J-CJvhPFFUXLw1q79k>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 21 Nov 2025 13:16:05 -0500 (EST)
Date: Fri, 21 Nov 2025 11:16:03 -0700
From: Alex Williamson <alex@shazbot.org>
To: =?UTF-8?B?TWljaGHFgg==?= Winiarski <michal.winiarski@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, "Kevin Tian" <kevin.tian@intel.com>,
 Yishai Hadas <yishaih@nvidia.com>, Longfang Liu <liulongfang@huawei.com>,
 Shameer Kolothum <skolothumtho@nvidia.com>, "Brett Creeley"
 <brett.creeley@amd.com>, Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
 <kvm@vger.kernel.org>, <qat-linux@intel.com>,
 <virtualization@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] vfio: Introduce .migration_reset_state() callback
Message-ID: <20251121111603.49b1577c.alex@shazbot.org>
In-Reply-To: <20251120123647.3522082-2-michal.winiarski@intel.com>
References: <20251120123647.3522082-1-michal.winiarski@intel.com>
 <20251120123647.3522082-2-michal.winiarski@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 20 Nov 2025 13:36:42 +0100
Micha=C5=82 Winiarski <michal.winiarski@intel.com> wrote:

> Resetting the migration device state is typically delegated to PCI
> .reset_done() callback.
> With VFIO, reset is usually called under vdev->memory_lock, which causes
> lockdep to report a following circular locking dependency scenario:
>=20
> 0: set_device_state
> driver->state_mutex -> migf->lock
> 1: data_read
> migf->lock -> mm->mmap_lock
> 2: vfio_pin_dma
> mm->mmap_lock -> vdev->memory_lock
> 3: vfio_pci_ioctl_reset
> vdev->memory_lock -> driver->state_mutex
>=20
> Introduce a .migration_reset_state() callback called outside of
> vdev->memory_lock to break the dependency chain.
>=20
> Signed-off-by: Micha=C5=82 Winiarski <michal.winiarski@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 25 ++++++++++++++++++++++---
>  include/linux/vfio.h             |  4 ++++
>  2 files changed, 26 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci=
_core.c
> index 7dcf5439dedc9..d919636558ec8 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -553,6 +553,16 @@ int vfio_pci_core_enable(struct vfio_pci_core_device=
 *vdev)
>  }
>  EXPORT_SYMBOL_GPL(vfio_pci_core_enable);
> =20
> +static void vfio_pci_dev_migration_reset_state(struct vfio_pci_core_devi=
ce *vdev)
> +{
> +	lockdep_assert_not_held(&vdev->memory_lock);
> +
> +	if (!vdev->vdev.mig_ops->migration_reset_state)

mig_ops itself is generally NULL.

> +		return;
> +
> +	vdev->vdev.mig_ops->migration_reset_state(&vdev->vdev);
> +}
> +
>  void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>  {
>  	struct pci_dev *pdev =3D vdev->pdev;
> @@ -662,8 +672,10 @@ void vfio_pci_core_disable(struct vfio_pci_core_devi=
ce *vdev)
>  	 * overwrite the previously restored configuration information.
>  	 */
>  	if (vdev->reset_works && pci_dev_trylock(pdev)) {
> -		if (!__pci_reset_function_locked(pdev))
> +		if (!__pci_reset_function_locked(pdev)) {
>  			vdev->needs_reset =3D false;
> +			vfio_pci_dev_migration_reset_state(vdev);
> +		}
>  		pci_dev_unlock(pdev);
>  	}
> =20
> @@ -1230,6 +1242,8 @@ static int vfio_pci_ioctl_reset(struct vfio_pci_cor=
e_device *vdev,
>  	ret =3D pci_try_reset_function(vdev->pdev);
>  	up_write(&vdev->memory_lock);
> =20
> +	vfio_pci_dev_migration_reset_state(vdev);
> +
>  	return ret;
>  }
> =20
> @@ -2129,6 +2143,7 @@ int vfio_pci_core_register_device(struct vfio_pci_c=
ore_device *vdev)
>  	if (vdev->vdev.mig_ops) {
>  		if (!(vdev->vdev.mig_ops->migration_get_state &&
>  		      vdev->vdev.mig_ops->migration_set_state &&
> +		      vdev->vdev.mig_ops->migration_reset_state &&

For bisection purposes it would be better to enforce this after all the
drivers are converted.

>  		      vdev->vdev.mig_ops->migration_get_data_size) ||
>  		    !(vdev->vdev.migration_flags & VFIO_MIGRATION_STOP_COPY))
>  			return -EINVAL;
> @@ -2486,8 +2501,10 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_=
device_set *dev_set,
> =20
>  err_undo:
>  	list_for_each_entry_from_reverse(vdev, &dev_set->device_list,
> -					 vdev.dev_set_list)
> +					 vdev.dev_set_list) {
>  		up_write(&vdev->memory_lock);
> +		vfio_pci_dev_migration_reset_state(vdev);
> +	}
> =20
>  	list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list)
>  		pm_runtime_put(&vdev->pdev->dev);
> @@ -2543,8 +2560,10 @@ static void vfio_pci_dev_set_try_reset(struct vfio=
_device_set *dev_set)
>  		reset_done =3D true;
> =20
>  	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list) {
> -		if (reset_done)
> +		if (reset_done) {
>  			cur->needs_reset =3D false;
> +			vfio_pci_dev_migration_reset_state(cur);
> +		}

This and the core_disable path above are only called in the
close/open-error path.  Do we really need this behavior there?  We
might need separate reconciliation vs .reset_done for these.

As Kevin also noted, we're missing the non-ioctl reset paths.  This
approach seems a bit error prone.  I wonder if instead we need a
counterpart of vfio_pci_zap_and_down_write_memory_lock(), ie.
vfio_pci_up_write_memory_lock_from_reset().  An equal mouthful, but
scopes the problem to be more manageable at memory_lock release.
Thanks,

Alex


> =20
>  		if (!disable_idle_d3)
>  			pm_runtime_put(&cur->pdev->dev);
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index eb563f538dee5..36aab2df40700 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -213,6 +213,9 @@ static inline bool vfio_device_cdev_opened(struct vfi=
o_device *device)
>   * @migration_get_state: Optional callback to get the migration state for
>   *         devices that support migration. It's mandatory for
>   *         VFIO_DEVICE_FEATURE_MIGRATION migration support.
> + * @migration_reset_state: Optional callback to reset the migration stat=
e for
> + *         devices that support migration. It's mandatory for
> + *         VFIO_DEVICE_FEATURE_MIGRATION migration support.
>   * @migration_get_data_size: Optional callback to get the estimated data
>   *          length that will be required to complete stop copy. It's man=
datory for
>   *          VFIO_DEVICE_FEATURE_MIGRATION migration support.
> @@ -223,6 +226,7 @@ struct vfio_migration_ops {
>  		enum vfio_device_mig_state new_state);
>  	int (*migration_get_state)(struct vfio_device *device,
>  				   enum vfio_device_mig_state *curr_state);
> +	void (*migration_reset_state)(struct vfio_device *device);
>  	int (*migration_get_data_size)(struct vfio_device *device,
>  				       unsigned long *stop_copy_length);
>  };


