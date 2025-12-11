Return-Path: <kvm+bounces-65793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DC93CB6E0E
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 19:13:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CCBF1301BE95
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 18:13:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 074753191C9;
	Thu, 11 Dec 2025 18:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KDhnaYbr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471B71F03EF;
	Thu, 11 Dec 2025 18:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765476807; cv=none; b=Cl8StiNqGalsr/z4SgvRAD4IO0wlqPYD4OfY/PjKl7V4GrDLVRC5Rg5B3QgNotsar4Lt4GAe2q/ik55irOpCSsK2rAfkmCTk9+r8fmhKeqIZVVxmgdCmHeTkBjlAVkoe+fkRQtF8TU3w466Xe44o6g+ivbyIkYZIX6/AssJcOgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765476807; c=relaxed/simple;
	bh=1ja2nTWbyUNeaHEFWkxsohvtLZ5vFjtzbve/3ZK1I3I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d6RQR7mFaenMA/DJRYfZ36OOiYVb6nYZ+ABnuqNJlrTPAbbfABLi2kS4jqAKqqwtW5uP0elphyaDmFommkCtFPEpfP/wcjZfU5v8evdYh5LWkwTjn716SHh/UjA01j2aNzt5IMrsdQCi1S9NzSVV5Xsg0+Vjihs/IzTplsO0BA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KDhnaYbr; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765476805; x=1797012805;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1ja2nTWbyUNeaHEFWkxsohvtLZ5vFjtzbve/3ZK1I3I=;
  b=KDhnaYbrHTS9SjHCbzSJxncBg8N9ERAuCb8Muk6KJ/oxNarjO6WcIi0i
   EMn/tpUBZ/IxqjGys+CQ+DxjegZ2b/YYbXZvSgxJLpoZFFdiNmLOG/5zG
   As0Wg/WYEbbKW13yAHQgQ/AIAXJbC5ylT8Kw3eHxxKSXCVRE4XiVoIB6D
   FQASVySUjFHq8Oe1kJpV0OP5gyTsCwo6kLi3GyByfYliP9PNSYAx8jsms
   dYtyEb0wiuMj8PZMzrZPaC06r1xkft1SbEXhGBOGEMSZm5RrVkOCjWbF2
   o6BKxvyu69NvmZIEcpUXXwUMavzb7ewgUkf4/dgSsfvo/kcqE2UdWMHKL
   w==;
X-CSE-ConnectionGUID: 80Yvf0M2QwarBMtgGYPo1Q==
X-CSE-MsgGUID: 9+2luauyR4mHJXDX5pB86w==
X-IronPort-AV: E=McAfee;i="6800,10657,11639"; a="92945419"
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="92945419"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 10:13:24 -0800
X-CSE-ConnectionGUID: pww1HZVkSri2lClMit+QLw==
X-CSE-MsgGUID: vR+5UJhDTVGSDfwULKc0rw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="196150835"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.109.218]) ([10.125.109.218])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 10:13:23 -0800
Message-ID: <80c04058-833b-4056-b47c-54a3a50f5f89@intel.com>
Date: Thu, 11 Dec 2025 11:13:21 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 11/15] vfio/cxl: introduce the emulation of HDM registers
To: mhonap@nvidia.com, aniketa@nvidia.com, ankita@nvidia.com,
 alwilliamson@nvidia.com, vsethi@nvidia.com, jgg@nvidia.com,
 mochs@nvidia.com, skolothumtho@nvidia.com, alejandro.lucero-palau@amd.com,
 dave@stgolabs.net, jonathan.cameron@huawei.com, alison.schofield@intel.com,
 vishal.l.verma@intel.com, ira.weiny@intel.com, dan.j.williams@intel.com,
 jgg@ziepe.ca, yishaih@nvidia.com, kevin.tian@intel.com
Cc: cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
 zhiw@nvidia.com, kjaju@nvidia.com, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, kvm@vger.kernel.org
References: <20251209165019.2643142-1-mhonap@nvidia.com>
 <20251209165019.2643142-12-mhonap@nvidia.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20251209165019.2643142-12-mhonap@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/9/25 9:50 AM, mhonap@nvidia.com wrote:
> From: Manish Honap <mhonap@nvidia.com>
> 
> CXL devices have HDM registers in its CXL MMIO bar. Many HDM registers
> requires a PA and they are owned by the host in virtualization.
> 
> Thus, the HDM registers needs to be emulated accordingly so that the
> guest kernel CXL core can configure the virtual HDM decoders.
> 
> Intorduce the emulation of HDM registers that emulates the HDM decoders.
> 
> Co-developed-by: Zhi Wang <zhiw@nvidia.com>
> Signed-off-by: Zhi Wang <zhiw@nvidia.com>
> Signed-off-by: Manish Honap <mhonap@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_cxl_core.c     |   7 +-
>  drivers/vfio/pci/vfio_cxl_core_emu.c | 242 +++++++++++++++++++++++++++
>  include/linux/vfio_pci_core.h        |   2 +
>  3 files changed, 248 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_cxl_core.c b/drivers/vfio/pci/vfio_cxl_core.c
> index cb75e9f668a7..c0bdf55997da 100644
> --- a/drivers/vfio/pci/vfio_cxl_core.c
> +++ b/drivers/vfio/pci/vfio_cxl_core.c
> @@ -247,8 +247,6 @@ int vfio_cxl_core_enable(struct vfio_cxl_core_device *cxl,
>  	if (!dvsec)
>  		return -ENODEV;
>  
> -	cxl->dvsec = dvsec;
> -
>  	cxl_core = devm_cxl_dev_state_create(&pdev->dev, CXL_DEVTYPE_DEVMEM,
>  					     pdev->dev.id, dvsec, struct vfio_cxl,
>  					     cxlds, false);
> @@ -257,9 +255,12 @@ int vfio_cxl_core_enable(struct vfio_cxl_core_device *cxl,
>  		return -ENOMEM;
>  	}
>  
> +	cxl->dvsec = dvsec;
> +	cxl->cxl_core = cxl_core;
> +
>  	ret = find_comp_regs(cxl);
>  	if (ret)
> -		return -ENODEV;
> +		return ret;
>  
>  	ret = setup_virt_regs(cxl);
>  	if (ret)
> diff --git a/drivers/vfio/pci/vfio_cxl_core_emu.c b/drivers/vfio/pci/vfio_cxl_core_emu.c
> index a0674bacecd7..6711ff8975ef 100644
> --- a/drivers/vfio/pci/vfio_cxl_core_emu.c
> +++ b/drivers/vfio/pci/vfio_cxl_core_emu.c
> @@ -5,6 +5,239 @@
>  
>  #include "vfio_cxl_core_priv.h"
>  
> +typedef ssize_t reg_handler_t(struct vfio_cxl_core_device *cxl, void *buf,
> +			      u64 offset, u64 size);
> +
> +static struct vfio_emulated_regblock *
> +new_reg_block(struct vfio_cxl_core_device *cxl, u64 offset, u64 size,
> +	      reg_handler_t *read, reg_handler_t *write)
> +{
> +	struct vfio_emulated_regblock *block;
> +
> +	block = kzalloc(sizeof(*block), GFP_KERNEL);
> +	if (!block)
> +		return ERR_PTR(-ENOMEM);
> +
> +	block->range.start = offset;
> +	block->range.end = offset + size - 1;
> +	block->read = read;
> +	block->write = write;
> +
> +	INIT_LIST_HEAD(&block->list);
> +
> +	return block;
> +}
> +
> +static int new_mmio_block(struct vfio_cxl_core_device *cxl, u64 offset, u64 size,
> +			  reg_handler_t *read, reg_handler_t *write)
> +{
> +	struct vfio_emulated_regblock *block;
> +
> +	block = new_reg_block(cxl, offset, size, read, write);
> +	if (IS_ERR(block))
> +		return PTR_ERR(block);
> +
> +	list_add_tail(&block->list, &cxl->mmio_regblocks_head);
> +	return 0;
> +}
> +
> +static u64 hdm_reg_base(struct vfio_cxl_core_device *cxl)
> +{
> +	return cxl->comp_reg_offset + cxl->hdm_reg_offset;
> +}
> +
> +static u64 to_hdm_reg_offset(struct vfio_cxl_core_device *cxl, u64 offset)
> +{
> +	return offset - hdm_reg_base(cxl);
> +}
> +
> +static void *hdm_reg_virt(struct vfio_cxl_core_device *cxl, u64 hdm_reg_offset)
> +{
> +	return cxl->comp_reg_virt + cxl->hdm_reg_offset + hdm_reg_offset;
> +}
> +
> +static ssize_t virt_hdm_reg_read(struct vfio_cxl_core_device *cxl, void *buf,
> +				 u64 offset, u64 size)
> +{
> +	offset = to_hdm_reg_offset(cxl, offset);
> +	memcpy(buf, hdm_reg_virt(cxl, offset), size);
> +
> +	return size;
> +}
> +
> +static ssize_t virt_hdm_reg_write(struct vfio_cxl_core_device *cxl, void *buf,
> +				  u64 offset, u64 size)
> +{
> +	offset = to_hdm_reg_offset(cxl, offset);
> +	memcpy(hdm_reg_virt(cxl, offset), buf, size);
> +
> +	return size;
> +}
> +
> +static ssize_t virt_hdm_rev_reg_write(struct vfio_cxl_core_device *cxl,
> +				      void *buf, u64 offset, u64 size)
> +{
> +	/* Discard writes on reserved registers. */
> +	return size;
> +}
> +
> +static ssize_t hdm_decoder_n_lo_write(struct vfio_cxl_core_device *cxl,
> +				      void *buf, u64 offset, u64 size)
> +{
> +	u32 new_val = le32_to_cpu(*(u32 *)buf);
> +
> +	if (WARN_ON_ONCE(size != 4))
> +		return -EINVAL;
> +
> +	/* Bit [27:0] are reserved. */
> +	new_val &= ~GENMASK(27, 0);

maybe define the mask

> +
> +	new_val = cpu_to_le32(new_val);
> +	offset = to_hdm_reg_offset(cxl, offset);
> +	memcpy(hdm_reg_virt(cxl, offset), &new_val, size);
> +	return size;
> +}
> +
> +static ssize_t hdm_decoder_global_ctrl_write(struct vfio_cxl_core_device *cxl,
> +					     void *buf, u64 offset, u64 size)
> +{
> +	u32 hdm_decoder_global_cap;
> +	u32 new_val = le32_to_cpu(*(u32 *)buf);
> +
> +	if (WARN_ON_ONCE(size != 4))
> +		return -EINVAL;
> +
> +	/* Bit [31:2] are reserved. */
> +	new_val &= ~GENMASK(31, 2);

same here re mask

> +
> +	/* Poison On Decode Error Enable bit is 0 and RO if not support. */
> +	hdm_decoder_global_cap = le32_to_cpu(*(u32 *)hdm_reg_virt(cxl, 0));
> +	if (!(hdm_decoder_global_cap & BIT(10)))
> +		new_val &= ~BIT(0);

Would be good to define the register bits to ease reading the code

> +
> +	new_val = cpu_to_le32(new_val);
> +	offset = to_hdm_reg_offset(cxl, offset);
> +	memcpy(hdm_reg_virt(cxl, offset), &new_val, size);
> +	return size;
> +}
> +
> +static ssize_t hdm_decoder_n_ctrl_write(struct vfio_cxl_core_device *cxl,
> +					void *buf, u64 offset, u64 size)
> +{
> +	u32 hdm_decoder_global_cap;
> +	u32 ro_mask, rev_mask;
> +	u32 new_val = le32_to_cpu(*(u32 *)buf);
> +	u32 cur_val;
> +
> +	if (WARN_ON_ONCE(size != 4))
> +		return -EINVAL;
> +
> +	offset = to_hdm_reg_offset(cxl, offset);
> +	cur_val = le32_to_cpu(*(u32 *)hdm_reg_virt(cxl, offset));
> +
> +	/* Lock on commit */
> +	if (cur_val & BIT(8))

define bit(s). same comment for the rest of the patch.

DJ

> +		return size;
> +
> +	hdm_decoder_global_cap = le32_to_cpu(*(u32 *)hdm_reg_virt(cxl, 0));
> +
> +	/* RO and reserved bits in the spec */
> +	ro_mask = BIT(10) | BIT(11);
> +	rev_mask = BIT(15) | GENMASK(31, 28);
> +
> +	/* bits are not valid for devices */
> +	ro_mask |= BIT(12);
> +	rev_mask |= GENMASK(19, 16) | GENMASK(23, 20);
> +
> +	/* bits are reserved when UIO is not supported */
> +	if (!(hdm_decoder_global_cap & BIT(13)))
> +		rev_mask |= BIT(14) | GENMASK(27, 24);
> +
> +	/* clear reserved bits */
> +	new_val &= ~rev_mask;
> +
> +	/* keep the RO bits */
> +	cur_val &= ro_mask;
> +	new_val &= ~ro_mask;
> +	new_val |= cur_val;
> +
> +	/* emulate HDM decoder commit/de-commit */
> +	if (new_val & BIT(9))
> +		new_val |= BIT(10);
> +	else
> +		new_val &= ~BIT(10);
> +
> +	new_val = cpu_to_le32(new_val);
> +	memcpy(hdm_reg_virt(cxl, offset), &new_val, size);
> +	return size;
> +}
> +
> +static int setup_mmio_emulation(struct vfio_cxl_core_device *cxl)
> +{
> +	u64 offset, base;
> +	int ret;
> +
> +	base = hdm_reg_base(cxl);
> +
> +#define ALLOC_BLOCK(offset, size, read, write) do {			\
> +		ret = new_mmio_block(cxl, offset, size, read, write);	\
> +		if (ret)						\
> +			return ret;					\
> +	} while (0)
> +
> +	ALLOC_BLOCK(base + 0x4, 4,
> +		    virt_hdm_reg_read,
> +		    hdm_decoder_global_ctrl_write);
> +
> +	offset = base + 0x10;
> +	while (offset < base + cxl->hdm_reg_size) {
> +		/* HDM N BASE LOW */
> +		ALLOC_BLOCK(offset, 4,
> +			    virt_hdm_reg_read,
> +			    hdm_decoder_n_lo_write);
> +
> +		/* HDM N BASE HIGH */
> +		ALLOC_BLOCK(offset + 0x4, 4,
> +			    virt_hdm_reg_read,
> +			    virt_hdm_reg_write);
> +
> +		/* HDM N SIZE LOW */
> +		ALLOC_BLOCK(offset + 0x8, 4,
> +			    virt_hdm_reg_read,
> +			    hdm_decoder_n_lo_write);
> +
> +		/* HDM N SIZE HIGH */
> +		ALLOC_BLOCK(offset + 0xc, 4,
> +			    virt_hdm_reg_read,
> +			    virt_hdm_reg_write);
> +
> +		/* HDM N CONTROL */
> +		ALLOC_BLOCK(offset + 0x10, 4,
> +			    virt_hdm_reg_read,
> +			    hdm_decoder_n_ctrl_write);
> +
> +		/* HDM N TARGET LIST LOW */
> +		ALLOC_BLOCK(offset + 0x14, 0x4,
> +			    virt_hdm_reg_read,
> +			    virt_hdm_rev_reg_write);
> +
> +		/* HDM N TARGET LIST HIGH */
> +		ALLOC_BLOCK(offset + 0x18, 0x4,
> +			    virt_hdm_reg_read,
> +			    virt_hdm_rev_reg_write);
> +
> +		/* HDM N REV */
> +		ALLOC_BLOCK(offset + 0x1c, 0x4,
> +			    virt_hdm_reg_read,
> +			    virt_hdm_rev_reg_write);
> +
> +		offset += 0x20;
> +	}
> +
> +#undef ALLOC_BLOCK
> +	return 0;
> +}
> +
>  void vfio_cxl_core_clean_register_emulation(struct vfio_cxl_core_device *cxl)
>  {
>  	struct list_head *pos, *n;
> @@ -17,10 +250,19 @@ void vfio_cxl_core_clean_register_emulation(struct vfio_cxl_core_device *cxl)
>  
>  int vfio_cxl_core_setup_register_emulation(struct vfio_cxl_core_device *cxl)
>  {
> +	int ret;
> +
>  	INIT_LIST_HEAD(&cxl->config_regblocks_head);
>  	INIT_LIST_HEAD(&cxl->mmio_regblocks_head);
>  
> +	ret = setup_mmio_emulation(cxl);
> +	if (ret)
> +		goto err;
> +
>  	return 0;
> +err:
> +	vfio_cxl_core_clean_register_emulation(cxl);
> +	return ret;
>  }
>  
>  static struct vfio_emulated_regblock *
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index 12ded67c7db7..31fd28626846 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -251,5 +251,7 @@ ssize_t vfio_cxl_core_write(struct vfio_device *core_vdev, const char __user *bu
>  			    size_t count, loff_t *ppos);
>  long vfio_cxl_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>  			 unsigned long arg);
> +int vfio_cxl_core_setup_register_emulation(struct vfio_cxl_core_device *cxl);
> +void vfio_cxl_core_clean_register_emulation(struct vfio_cxl_core_device *cxl);
>  
>  #endif /* VFIO_PCI_CORE_H */


