Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0463B4096DC
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 17:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbhIMPQQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 11:16:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51175 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347039AbhIMPP2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Sep 2021 11:15:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631546052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SoOPs9oOXI+40UoV373ZTlyTrX7TrHj4IutDP3kxVcA=;
        b=YMAgXiDlTYMif/gO/jJHeCkpUY0EVq6s+8RoAa1H/NskYVe5Vn5OGjspqKhSaBjwy0hxHK
        3yvzXYAjLDDgxiycL/EU3j6zLDH2xWxMLDoTT5VNs7SmzbH1c2v8ZmszeUDF53BiTXguY/
        cFSFfinE40fImZawYmfagmrXGtDYylA=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-CdRpXTBJNY-aCeRtefMj-Q-1; Mon, 13 Sep 2021 11:14:11 -0400
X-MC-Unique: CdRpXTBJNY-aCeRtefMj-Q-1
Received: by mail-oi1-f197.google.com with SMTP id n9-20020a0568080a0900b002689a4834e4so5482956oij.12
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 08:14:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SoOPs9oOXI+40UoV373ZTlyTrX7TrHj4IutDP3kxVcA=;
        b=qMPByv2NDT7seSbzxL9lMKnnW0lsEiQ2oR5H431u6znm345ExKFAUUvf+OPBAr+cNA
         HrtlA608g/yeIbuiYCLAPa+SxPiLxMrv9i09En6JO2wIPC+8DHjZk9Odp+9EGhNg4ulr
         2ZoW3t8zrtdhbl+sM26Y8NS3FXnFohXknHR2eUFLpYMQXMm0Rt5cLr6Fzq0sRa+CdZ05
         k5VKCu7ftNwbjGqbWXM+FWTCslxVqt0A9qktvU2z+hawlTPIifcqIRtGTbMp/a3OYmf2
         B2xPQBU8j1ae624fJwz3/X1XXOdMmVsdTvBb6yC/GU13koSsoIdbEavBqE6xUqP8sqHh
         u0pA==
X-Gm-Message-State: AOAM5314VygHx2zggDLe8kB5S1JpiUMDRlPjDYRdjxtU+S1VWXng8VwV
        QUP1FooW2Gxjb79CV8V7alsaJD5WOrP7CeEr5JNDzj2p+XsDNTWFuBI9FZC1/kPbBxsqXNRtSiZ
        lj74hU+UzX83B
X-Received: by 2002:aca:3051:: with SMTP id w78mr7926249oiw.159.1631546050398;
        Mon, 13 Sep 2021 08:14:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwZyAhjvq/9F+/aqoMDR4kFRU1bXt58kgkvBxfAa8omCwOtCUW8VWDlx1sYQBj2iAV5aOEU+w==
X-Received: by 2002:aca:3051:: with SMTP id w78mr7926226oiw.159.1631546050084;
        Mon, 13 Sep 2021 08:14:10 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id u194sm1758646oie.37.2021.09.13.08.14.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 08:14:09 -0700 (PDT)
Date:   Mon, 13 Sep 2021 09:14:08 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Colin Xu <colin.xu@intel.com>
Cc:     kvm@vger.kernel.org, zhenyuw@linux.intel.com,
        hang.yuan@linux.intel.com, swee.yee.fonn@intel.com,
        fred.gao@intel.com
Subject: Re: [PATCH v4] vfio/pci: Add OpRegion 2.0+ Extended VBT support.
Message-ID: <20210913091408.4ceae061.alex.williamson@redhat.com>
In-Reply-To: <20210913124158.68775-1-colin.xu@intel.com>
References: <8a444890-63ba-e96a-63ab-7e6993ea1b4b@outlook.office365.com>
        <20210913124158.68775-1-colin.xu@intel.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 13 Sep 2021 20:41:58 +0800
Colin Xu <colin.xu@intel.com> wrote:

> Due to historical reason, some legacy shipped system doesn't follow
> OpRegion 2.1 spec but still stick to OpRegion 2.0, in which the extended
> VBT is not contiguous after OpRegion in physical address, but any
> location pointed by RVDA via absolute address. Also although current
> OpRegion 2.1+ systems appears that the extended VBT follows OpRegion,
> RVDA is the relative address to OpRegion head, the extended VBT location
> may change to non-contiguous to OpRegion. In both cases, it's impossible
> to map a contiguous range to hold both OpRegion and the extended VBT and
> expose via one vfio region.
> 
> The only difference between OpRegion 2.0 and 2.1 is where extended
> VBT is stored: For 2.0, RVDA is the absolute address of extended VBT
> while for 2.1, RVDA is the relative address of extended VBT to OpRegion
> baes, and there is no other difference between OpRegion 2.0 and 2.1.
> To support the non-contiguous region case as described, the updated read
> op will patch OpRegion version and RVDA on-the-fly accordingly. So that
> from vfio igd OpRegion view, only 2.1+ with contiguous extended VBT
> after OpRegion is exposed, regardless the underneath host OpRegion is
> 2.0 or 2.1+. The mechanism makes it possible to support legacy OpRegion
> 2.0 extended VBT systems with on the market, and support OpRegion 2.1+
> where the extended VBT isn't contiguous after OpRegion.
> Also split the write op with read ops to leave flexibility for OpRegion
> write op support in future.
> 
> V2:
> Validate RVDA for 2.1+ before increasing total size. (Alex)
> 
> V3: (Alex)
> Split read and write ops.
> On-the-fly modify OpRegion version and RVDA.
> Fix sparse error on assign value to casted pointer.
> 
> V4: (Alex)
> No need support write op.
> Direct copy to user buffer with several shift instead of shadow.
> Copy helper to copy to user buffer and shift offset.
> 
> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> Cc: Hang Yuan <hang.yuan@linux.intel.com>
> Cc: Swee Yee Fonn <swee.yee.fonn@intel.com>
> Cc: Fred Gao <fred.gao@intel.com>
> Signed-off-by: Colin Xu <colin.xu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_igd.c | 229 ++++++++++++++++++++++++--------
>  1 file changed, 174 insertions(+), 55 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
> index 228df565e9bc..14e958893be6 100644
> --- a/drivers/vfio/pci/vfio_pci_igd.c
> +++ b/drivers/vfio/pci/vfio_pci_igd.c
> @@ -25,20 +25,119 @@
>  #define OPREGION_RVDS		0x3c2
>  #define OPREGION_VERSION	0x16
>  
> +struct igd_opregion_vbt {
> +	void *opregion;
> +	void *vbt_ex;
> +	__le16 version;
> +	__le64 rvda;

I thought storing version here was questionable because we're really
only saving ourselves a read from the opregion, test against 0x0200,
and conversion to 0x0201.  Storing rvda here feel gratuitous since it
can be calculated from readily available data in the rw function.

> +};
> +
> +/**
> + * igd_opregion_shift_copy() - Copy OpRegion to user buffer and shift position.
> + * @dst: User buffer ptr to copy to.
> + * @off: Offset to user buffer ptr. Increased by bytes_adv on return.
> + * @src: Source buffer to copy from.
> + * @pos: Increased by bytes_adv on return.
> + * @remaining: Decreased by bytes_adv on return.
> + * @bytes_cp: Bytes to copy.
> + * @bytes_adv: Bytes to adjust off, pos and remaining.
> + *
> + * Copy OpRegion to offset from specific source ptr and shift the offset.
> + *
> + * Return: 0 on success, -EFAULT otherwise.
> + *
> + */
> +static inline unsigned long igd_opregion_shift_copy(char __user *dst,
> +						    loff_t *off,
> +						    void *src,
> +						    loff_t *pos,
> +						    loff_t *remaining,
> +						    loff_t bytes_cp,
> +						    loff_t bytes_adv)
> +{
> +	if (copy_to_user(dst + (*off), src, bytes_cp))
> +		return -EFAULT;
> +
> +	*off += bytes_adv;
> +	*pos += bytes_adv;
> +	*remaining -= bytes_adv;

@bytes_cp always equals @bytes_adv except for the last case, it's not
worth the special handling imo.

> +
> +	return 0;
> +}
> +
>  static size_t vfio_pci_igd_rw(struct vfio_pci_device *vdev, char __user *buf,
>  			      size_t count, loff_t *ppos, bool iswrite)
>  {
>  	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
> -	void *base = vdev->region[i].data;
> +	struct igd_opregion_vbt *opregionvbt = vdev->region[i].data;
>  	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
> +	loff_t remaining = count;
> +	loff_t off = 0;
>  
>  	if (pos >= vdev->region[i].size || iswrite)
>  		return -EINVAL;
>  
>  	count = min(count, (size_t)(vdev->region[i].size - pos));

We set @remaining before we bounds check @count here.  Thanks,

Alex

>  
> -	if (copy_to_user(buf, base + pos, count))
> -		return -EFAULT;
> +	/* Copy until OpRegion version */
> +	if (remaining && pos < OPREGION_VERSION) {
> +		loff_t bytes = min(remaining, OPREGION_VERSION - pos);
> +
> +		if (igd_opregion_shift_copy(buf, &off,
> +					    opregionvbt->opregion + pos, &pos,
> +					    &remaining, bytes, bytes))
> +			return -EFAULT;
> +	}
> +
> +	/* Copy patched (if necessary) OpRegion version */
> +	if (remaining && pos < OPREGION_VERSION + sizeof(__le16)) {
> +		loff_t bytes = min(remaining,
> +				   OPREGION_VERSION + (loff_t)sizeof(__le16) - pos);
> +
> +		if (igd_opregion_shift_copy(buf, &off,
> +					    &opregionvbt->version, &pos,
> +					    &remaining, bytes, bytes))
> +			return -EFAULT;
> +	}
> +
> +	/* Copy until RVDA */
> +	if (remaining && pos < OPREGION_RVDA) {
> +		loff_t bytes = min((loff_t)remaining, OPREGION_RVDA - pos);
> +
> +		if (igd_opregion_shift_copy(buf, &off,
> +					    opregionvbt->opregion + pos, &pos,
> +					    &remaining, bytes, bytes))
> +			return -EFAULT;
> +	}
> +
> +	/* Copy modified (if necessary) RVDA */
> +	if (remaining && pos < OPREGION_RVDA + sizeof(__le64)) {
> +		loff_t bytes = min(remaining, OPREGION_RVDA +
> +					      (loff_t)sizeof(__le64) - pos);
> +
> +		if (igd_opregion_shift_copy(buf, &off,
> +					    &opregionvbt->rvda, &pos,
> +					    &remaining, bytes, bytes))
> +			return -EFAULT;
> +	}
> +
> +	/* Copy the rest of OpRegion */
> +	if (remaining && pos < OPREGION_SIZE) {
> +		loff_t bytes = min(remaining, OPREGION_SIZE - pos);
> +
> +		if (igd_opregion_shift_copy(buf, &off,
> +					    opregionvbt->opregion + pos, &pos,
> +					    &remaining, bytes, bytes))
> +			return -EFAULT;
> +	}
> +
> +	/* Copy extended VBT if exists */
> +	if (remaining) {
> +		if (igd_opregion_shift_copy(buf, &off,
> +					    opregionvbt->vbt_ex, &pos,
> +					    &remaining, remaining, 0))
> +			return -EFAULT;
> +	}
>  
>  	*ppos += count;
>  
> @@ -48,7 +147,13 @@ static size_t vfio_pci_igd_rw(struct vfio_pci_device *vdev, char __user *buf,
>  static void vfio_pci_igd_release(struct vfio_pci_device *vdev,
>  				 struct vfio_pci_region *region)
>  {
> -	memunmap(region->data);
> +	struct igd_opregion_vbt *opregionvbt = region->data;
> +
> +	if (opregionvbt->vbt_ex)
> +		memunmap(opregionvbt->vbt_ex);
> +
> +	memunmap(opregionvbt->opregion);
> +	kfree(opregionvbt);
>  }
>  
>  static const struct vfio_pci_regops vfio_pci_igd_regops = {
> @@ -60,7 +165,7 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
>  {
>  	__le32 *dwordp = (__le32 *)(vdev->vconfig + OPREGION_PCI_ADDR);
>  	u32 addr, size;
> -	void *base;
> +	struct igd_opregion_vbt *opregionvbt;
>  	int ret;
>  	u16 version;
>  
> @@ -71,84 +176,98 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
>  	if (!addr || !(~addr))
>  		return -ENODEV;
>  
> -	base = memremap(addr, OPREGION_SIZE, MEMREMAP_WB);
> -	if (!base)
> +	opregionvbt = kzalloc(sizeof(*opregionvbt), GFP_KERNEL);
> +	if (!opregionvbt)
> +		return -ENOMEM;
> +
> +	opregionvbt->opregion = memremap(addr, OPREGION_SIZE, MEMREMAP_WB);
> +	if (!opregionvbt->opregion) {
> +		kfree(opregionvbt);
>  		return -ENOMEM;
> +	}
>  
> -	if (memcmp(base, OPREGION_SIGNATURE, 16)) {
> -		memunmap(base);
> +	if (memcmp(opregionvbt->opregion, OPREGION_SIGNATURE, 16)) {
> +		memunmap(opregionvbt->opregion);
> +		kfree(opregionvbt);
>  		return -EINVAL;
>  	}
>  
> -	size = le32_to_cpu(*(__le32 *)(base + 16));
> +	size = le32_to_cpu(*(__le32 *)(opregionvbt->opregion + 16));
>  	if (!size) {
> -		memunmap(base);
> +		memunmap(opregionvbt->opregion);
> +		kfree(opregionvbt);
>  		return -EINVAL;
>  	}
>  
>  	size *= 1024; /* In KB */
>  
>  	/*
> -	 * Support opregion v2.1+
> -	 * When VBT data exceeds 6KB size and cannot be within mailbox #4, then
> -	 * the Extended VBT region next to opregion is used to hold the VBT data.
> -	 * RVDA (Relative Address of VBT Data from Opregion Base) and RVDS
> -	 * (Raw VBT Data Size) from opregion structure member are used to hold the
> -	 * address from region base and size of VBT data. RVDA/RVDS are not
> -	 * defined before opregion 2.0.
> -	 *
> -	 * opregion 2.1+: RVDA is unsigned, relative offset from
> -	 * opregion base, and should point to the end of opregion.
> -	 * otherwise, exposing to userspace to allow read access to everything between
> -	 * the OpRegion and VBT is not safe.
> -	 * RVDS is defined as size in bytes.
> +	 * OpRegion and VBT:
> +	 * When VBT data doesn't exceed 6KB, it's stored in Mailbox #4.
> +	 * When VBT data exceeds 6KB size, Mailbox #4 is no longer large enough
> +	 * to hold the VBT data, the Extended VBT region is introduced since
> +	 * OpRegion 2.0 to hold the VBT data. Since OpRegion 2.0, RVDA/RVDS are
> +	 * introduced to define the extended VBT data location and size.
> +	 * OpRegion 2.0: RVDA defines the absolute physical address of the
> +	 *   extended VBT data, RVDS defines the VBT data size.
> +	 * OpRegion 2.1 and above: RVDA defines the relative address of the
> +	 *   extended VBT data to OpRegion base, RVDS defines the VBT data size.
>  	 *
> -	 * opregion 2.0: rvda is the physical VBT address.
> -	 * Since rvda is HPA it cannot be directly used in guest.
> -	 * And it should not be practically available for end user,so it is not supported.
> +	 * Due to the RVDA difference in OpRegion VBT (also the only diff between
> +	 * 2.0 and 2.1), expose OpRegion and VBT as a contiguous range for
> +	 * OpRegion 2.0 and above makes it possible to support the non-contiguous
> +	 * VBT via a single vfio region. From r/w ops view, only contiguous VBT
> +	 * after OpRegion with version 2.1+ is exposed regardless the underneath
> +	 * host is 2.0 or non-contiguous 2.1+. The r/w ops will on-the-fly shift
> +	 * the actural offset into VBT so that data at correct position can be
> +	 * returned to the requester.
>  	 */
> -	version = le16_to_cpu(*(__le16 *)(base + OPREGION_VERSION));
> +	opregionvbt->version = *(__le16 *)(opregionvbt->opregion +
> +					   OPREGION_VERSION);
> +	version = le16_to_cpu(opregionvbt->version);
> +
>  	if (version >= 0x0200) {
> -		u64 rvda;
> -		u32 rvds;
> +		u64 rvda = le64_to_cpu(*(__le64 *)(opregionvbt->opregion +
> +						   OPREGION_RVDA));
> +		u32 rvds = le32_to_cpu(*(__le32 *)(opregionvbt->opregion +
> +						   OPREGION_RVDS));
>  
> -		rvda = le64_to_cpu(*(__le64 *)(base + OPREGION_RVDA));
> -		rvds = le32_to_cpu(*(__le32 *)(base + OPREGION_RVDS));
> +		/* The extended VBT is valid only when RVDA/RVDS are non-zero */
>  		if (rvda && rvds) {
> -			/* no support for opregion v2.0 with physical VBT address */
> +			size += rvds;
> +
>  			if (version == 0x0200) {
> -				memunmap(base);
> -				pci_err(vdev->pdev,
> -					"IGD assignment does not support opregion v2.0 with an extended VBT region\n");
> -				return -EINVAL;
> +				/* Patch to version 2.0 in read ops */
> +				opregionvbt->version = cpu_to_le16(0x0201);
> +				/* Absolute physical addr for 2.0 */
> +				addr = rvda;
> +			} else {
> +				/* Relative addr to OpRegion header for 2.1+ */
> +				addr += rvda;
>  			}
>  
> -			if (rvda != size) {
> -				memunmap(base);
> -				pci_err(vdev->pdev,
> -					"Extended VBT does not follow opregion on version 0x%04x\n",
> -					version);
> -				return -EINVAL;
> +			opregionvbt->vbt_ex = memremap(addr, rvds, MEMREMAP_WB);
> +			if (!opregionvbt->vbt_ex) {
> +				memunmap(opregionvbt->opregion);
> +				kfree(opregionvbt);
> +				return -ENOMEM;
>  			}
>  
> -			/* region size for opregion v2.0+: opregion and VBT size. */
> -			size += rvds;
> +			/* Always set RVDA to make exVBT follows OpRegion */
> +			opregionvbt->rvda = cpu_to_le64(OPREGION_SIZE);
>  		}
>  	}
>  
> -	if (size != OPREGION_SIZE) {
> -		memunmap(base);
> -		base = memremap(addr, size, MEMREMAP_WB);
> -		if (!base)
> -			return -ENOMEM;
> -	}
> -
>  	ret = vfio_pci_register_dev_region(vdev,
>  		PCI_VENDOR_ID_INTEL | VFIO_REGION_TYPE_PCI_VENDOR_TYPE,
> -		VFIO_REGION_SUBTYPE_INTEL_IGD_OPREGION,
> -		&vfio_pci_igd_regops, size, VFIO_REGION_INFO_FLAG_READ, base);
> +		VFIO_REGION_SUBTYPE_INTEL_IGD_OPREGION, &vfio_pci_igd_regops,
> +		size, VFIO_REGION_INFO_FLAG_READ, opregionvbt);
>  	if (ret) {
> -		memunmap(base);
> +		if (opregionvbt->vbt_ex)
> +			memunmap(opregionvbt->vbt_ex);
> +
> +		memunmap(opregionvbt->opregion);
> +		kfree(opregionvbt);
>  		return ret;
>  	}
>  

