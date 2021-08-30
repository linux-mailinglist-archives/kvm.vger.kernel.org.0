Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D413FBD6F
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 22:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235352AbhH3U2n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 16:28:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46660 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232906AbhH3U2m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Aug 2021 16:28:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630355268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=toDpzVktpIRLMFAUD5tUTpGYXL1XjXMdGuB84dmigo8=;
        b=RxwZIVN76JL1GomK+NQ/rZhrLf1bpW/TZ9oxM7J+5iDYcHQQ8QUVf22YKOVhgGoItQJ85W
        7IxzWtHSZPDGTpElPibSFde/LsvV0Y1vjUPNTN+nzZgDgMFDVDB18/g1uTLwODjHH6c19/
        IemVg0q8bjVdPEnDxV2lUkXA702IlFw=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-fkxQ-CNeO-ieGYBsVXv-8w-1; Mon, 30 Aug 2021 16:27:46 -0400
X-MC-Unique: fkxQ-CNeO-ieGYBsVXv-8w-1
Received: by mail-il1-f198.google.com with SMTP id c2-20020a92c8c2000000b002246dcb2b5dso9869111ilq.17
        for <kvm@vger.kernel.org>; Mon, 30 Aug 2021 13:27:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=toDpzVktpIRLMFAUD5tUTpGYXL1XjXMdGuB84dmigo8=;
        b=hxEK35UMEzpzCPVPfOAYB7diLVVwKC0AlfypjCLxxP3AVzbCEcSoIv9ls1uVe6etGK
         OYyBZEEBxRQ7Q2mn5pe5fxZVWdn26CABKL5FwdcdQ75Y67IbNywPXzNzUdOP9zHWkqKv
         zJH2MRLcYqlD+B3u6Bb10nTvBJ6mr87ghzySPjr7Gwu04md6kDA7jgKz5lc6fuxcbq9z
         EaH11CxRm7c0iPw/UiMX8lDws8Oj2VR/0EyU4qn2pxEKPr0mMhwDVjlVS0HFd7C74Hke
         2XsgKCSYLXnSjBZsQpJu4TicyZygPvGRZr7m0X+JRUbFw1pk599BeTa1cmI0fXjVgGXl
         yg2g==
X-Gm-Message-State: AOAM5315ne/noGolyhiXaOW1vkQiVgSgnP/M2/VoDjEk/DiUFhdmUisV
        yICzJSm0iFd1+y8JZ8SveiSV2HkCPpH30qJR2Y1LqNAgowel4UQS/HExuQnZ1nMexmCQI7dQ32e
        vjLJnjxyhIfyg
X-Received: by 2002:a5d:818b:: with SMTP id u11mr19380342ion.43.1630355265906;
        Mon, 30 Aug 2021 13:27:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyh2brQ2PPXi0zbXf+GsueAxHH0Uc359muSpsuyUt8I4FeLEmoa9eH2uzksDusMiVrJ7XA6+A==
X-Received: by 2002:a5d:818b:: with SMTP id u11mr19380332ion.43.1630355265668;
        Mon, 30 Aug 2021 13:27:45 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id t15sm8878338ilq.88.2021.08.30.13.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 13:27:45 -0700 (PDT)
Date:   Mon, 30 Aug 2021 14:27:42 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Colin Xu <colin.xu@intel.com>
Cc:     kvm@vger.kernel.org, zhenyuw@linux.intel.com,
        hang.yuan@linux.intel.com, swee.yee.fonn@intel.com,
        fred.gao@intel.com
Subject: Re: [PATCH v2] vfio/pci: Add OpRegion 2.0 Extended VBT support.
Message-ID: <20210830142742.402af95f.alex.williamson@redhat.com>
In-Reply-To: <20210827023716.105075-1-colin.xu@intel.com>
References: <441994e-52e-c1bb-c72d-b6db52b39e3f@outlook.office365.com>
        <20210827023716.105075-1-colin.xu@intel.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 27 Aug 2021 10:37:16 +0800
Colin Xu <colin.xu@intel.com> wrote:

> Due to historical reason, some legacy shipped system doesn't follow
> OpRegion 2.1 spec but still stick to OpRegion 2.0, in which the extended
> VBT is not contigious after OpRegion in physical address, but any
> location pointed by RVDA via absolute address. Thus it's impossible
> to map a contigious range to hold both OpRegion and extended VBT as 2.1.
> 
> Since the only difference between OpRegion 2.0 and 2.1 is where extended
> VBT is stored: For 2.0, RVDA is the absolute address of extended VBT
> while for 2.1, RVDA is the relative address of extended VBT to OpRegion
> baes, and there is no other difference between OpRegion 2.0 and 2.1,
> it's feasible to amend OpRegion support for these legacy system (before
> upgrading the system firmware), by kazlloc a range to shadown OpRegion
> from the beginning and stitch VBT after closely, patch the shadow
> OpRegion version from 2.0 to 2.1, and patch the shadow RVDA to relative
> address. So that from the vfio igd OpRegion r/w ops view, only OpRegion
> 2.1 is exposed regardless the underneath host OpRegion is 2.0 or 2.1
> if the extended VBT exists. vfio igd OpRegion r/w ops will return either
> shadowed data (OpRegion 2.0) or directly from physical address
> (OpRegion 2.1+) based on host OpRegion version and RVDA/RVDS. The shadow
> mechanism makes it possible to support legacy systems on the market.
> 
> V2:
> Validate RVDA for 2.1+ before increasing total size. (Alex)
> 
> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> Cc: Hang Yuan <hang.yuan@linux.intel.com>
> Cc: Swee Yee Fonn <swee.yee.fonn@intel.com>
> Cc: Fred Gao <fred.gao@intel.com>
> Signed-off-by: Colin Xu <colin.xu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_igd.c | 117 ++++++++++++++++++++------------
>  1 file changed, 75 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
> index 228df565e9bc..9cd44498b378 100644
> --- a/drivers/vfio/pci/vfio_pci_igd.c
> +++ b/drivers/vfio/pci/vfio_pci_igd.c
> @@ -48,7 +48,10 @@ static size_t vfio_pci_igd_rw(struct vfio_pci_device *vdev, char __user *buf,
>  static void vfio_pci_igd_release(struct vfio_pci_device *vdev,
>  				 struct vfio_pci_region *region)
>  {
> -	memunmap(region->data);
> +	if (is_ioremap_addr(region->data))
> +		memunmap(region->data);
> +	else
> +		kfree(region->data);


Since we don't have write support to the OpRegion, should we always
allocate a shadow copy to simplify?  Or rather than a shadow copy,
since we don't support mmap of the region, our read handler could
virtualize version and rvda on the fly and shift accesses so that the
VBT appears contiguous.  That might also leave us better positioned for
handling dynamic changes (ex. does the data change when a monitor is
plugged/unplugged) and perhaps eventually write support.


>  }
>  
>  static const struct vfio_pci_regops vfio_pci_igd_regops = {
> @@ -59,10 +62,11 @@ static const struct vfio_pci_regops vfio_pci_igd_regops = {
>  static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
>  {
>  	__le32 *dwordp = (__le32 *)(vdev->vconfig + OPREGION_PCI_ADDR);
> -	u32 addr, size;
> -	void *base;
> +	u32 addr, size, rvds = 0;
> +	void *base, *opregionvbt;


opregionvbt could be scoped within the branch it's used.


>  	int ret;
>  	u16 version;
> +	u64 rvda = 0;
>  
>  	ret = pci_read_config_dword(vdev->pdev, OPREGION_PCI_ADDR, &addr);
>  	if (ret)
> @@ -89,66 +93,95 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
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
> -	 * opregion 2.1+: RVDA is unsigned, relative offset from
> -	 * opregion base, and should point to the end of opregion.
> -	 * otherwise, exposing to userspace to allow read access to everything between
> -	 * the OpRegion and VBT is not safe.
> -	 * RVDS is defined as size in bytes.
> -	 *
> -	 * opregion 2.0: rvda is the physical VBT address.
> -	 * Since rvda is HPA it cannot be directly used in guest.
> -	 * And it should not be practically available for end user,so it is not supported.
> +	 * Due to the RVDA difference in OpRegion VBT (also the only diff between
> +	 * 2.0 and 2.1), while for OpRegion 2.1 and above it's possible to map
> +	 * a contigious memory to expose OpRegion and VBT r/w via the vfio
> +	 * region, for OpRegion 2.0 shadow and amendment mechanism is used to
> +	 * expose OpRegion and VBT r/w properly. So that from r/w ops view, only
> +	 * OpRegion 2.1 is exposed regardless underneath Region is 2.0 or 2.1.
>  	 */
>  	version = le16_to_cpu(*(__le16 *)(base + OPREGION_VERSION));
> -	if (version >= 0x0200) {
> -		u64 rvda;
> -		u32 rvds;
>  
> +	if (version >= 0x0200) {
>  		rvda = le64_to_cpu(*(__le64 *)(base + OPREGION_RVDA));
>  		rvds = le32_to_cpu(*(__le32 *)(base + OPREGION_RVDS));
> +
> +		/* The extended VBT must follows OpRegion for OpRegion 2.1+ */


Why?  If we're going to make our own OpRegion to account for v2.0, why
should it not apply to the same scenario for >2.0?


> +		if (rvda != size && version > 0x0200) {
> +			memunmap(base);
> +			pci_err(vdev->pdev,
> +				"Extended VBT does not follow opregion on version 0x%04x\n",
> +				version);
> +			return -EINVAL;
> +		}
> +
> +		/* The extended VBT is valid only when RVDA/RVDS are non-zero. */
>  		if (rvda && rvds) {
> -			/* no support for opregion v2.0 with physical VBT address */
> -			if (version == 0x0200) {
> +			size += rvds;
> +		}
> +	}
> +
> +	if (size != OPREGION_SIZE) {


@size can only != OPREGION_SIZE due to the above branch, so the below
could all be scoped under the version test, or perhaps to a separate
function.


> +		/* Allocate memory for OpRegion and extended VBT for 2.0 */
> +		if (rvda && rvds && version == 0x0200) {


We go down this path even if the VBT was contiguous with the OpRegion.


> +			void *vbt_base;
> +
> +			vbt_base = memremap(rvda, rvds, MEMREMAP_WB);
> +			if (!vbt_base) {
>  				memunmap(base);
> -				pci_err(vdev->pdev,
> -					"IGD assignment does not support opregion v2.0 with an extended VBT region\n");
> -				return -EINVAL;
> +				return -ENOMEM;
>  			}
>  
> -			if (rvda != size) {
> +			opregionvbt = kzalloc(size, GFP_KERNEL);
> +			if (!opregionvbt) {
>  				memunmap(base);
> -				pci_err(vdev->pdev,
> -					"Extended VBT does not follow opregion on version 0x%04x\n",
> -					version);
> -				return -EINVAL;
> +				memunmap(vbt_base);
> +				return -ENOMEM;
>  			}
>  
> -			/* region size for opregion v2.0+: opregion and VBT size. */
> -			size += rvds;
> +			/* Stitch VBT after OpRegion noncontigious */
> +			memcpy(opregionvbt, base, OPREGION_SIZE);
> +			memcpy(opregionvbt + OPREGION_SIZE, vbt_base, rvds);
> +
> +			/* Patch OpRegion 2.0 to 2.1 */
> +			*(__le16 *)(opregionvbt + OPREGION_VERSION) = 0x0201;


= cpu_to_le16(0x0201);


> +			/* Patch RVDA to relative address after OpRegion */
> +			*(__le64 *)(opregionvbt + OPREGION_RVDA) = OPREGION_SIZE;


= cpu_to_le64(OPREGION_SIZE);


I think this is what triggered the sparse errors.  Thanks,

Alex

> +
> +			memunmap(vbt_base);
> +			memunmap(base);
> +
> +			/* Register shadow instead of map as vfio_region */
> +			base = opregionvbt;
> +		/* Remap OpRegion + extended VBT for 2.1+ */
> +		} else {
> +			memunmap(base);
> +			base = memremap(addr, size, MEMREMAP_WB);
> +			if (!base)
> +				return -ENOMEM;
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
>  		VFIO_REGION_SUBTYPE_INTEL_IGD_OPREGION,
>  		&vfio_pci_igd_regops, size, VFIO_REGION_INFO_FLAG_READ, base);
>  	if (ret) {
> -		memunmap(base);
> +		if (is_ioremap_addr(base))
> +			memunmap(base);
> +		else
> +			kfree(base);
>  		return ret;
>  	}
>  

