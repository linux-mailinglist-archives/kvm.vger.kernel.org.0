Return-Path: <kvm+bounces-66614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 318E8CD8F9F
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 11:55:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0AA4230202E1
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 10:55:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D463B322C67;
	Tue, 23 Dec 2025 10:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vt+MVyAO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECF0327208;
	Tue, 23 Dec 2025 10:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766487342; cv=none; b=LcWnMiVLrjidYyvfz7OkLVHYtfxd3O88jg6FYBTverO3ctdu0+LpiJ9VKEfC9SGYb5XOhnoGVogtVxGZ+9rNzIqlNDG1q7VaXCMDlEdEVG8bI0BcgrIPyHJLpvw9TtmDzYLiIff4G4SdRkaBEyUReDlsgsplqv4XT8Awl9PUXvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766487342; c=relaxed/simple;
	bh=0MkwZrX1T1LeSLHzFNoDWJL+sFoAXO5+alSFH6ZqLLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fzRvXRelo7L8WnmnHYtlJXz9rhhovuImTK6IBnPWH0Ls4bUzWr/R6tPc38kiZO95DWXWjNJl7jN1L+AjF9r+aYO08oaQKwYofhqVJAs/4S0GXYWyPrkkCIZTivzi0in8I3/Lx0qcinuyoTbxbBd5GmxVeaC1ZVvm+xp+uN9ZbNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vt+MVyAO; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766487339; x=1798023339;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=0MkwZrX1T1LeSLHzFNoDWJL+sFoAXO5+alSFH6ZqLLQ=;
  b=Vt+MVyAOetPbJXIn0DsYt4z0G5M0NmLRDZfEDbXBgoMFtOy1LYqFkf9g
   IdJqe6DuVb1O+bspsRBZaAfcbr0kJnpOT9+P+B+4VYWaFjrJ4hqwks1Hs
   4YIM4AfqtR6Z4p6v3S68l2elymxT5Pi0i91TOs9z7qiKdSUGEpTY85Zxy
   zLQq+5KOg/LUE0xt/c1B5QC0yEucj9BkaSUPkJ35m30mubXjE0nXZS0SL
   5zhxg+noiokICmzURvHdYm7auaD7/6HokddkWuiFqPSsvtZWXu018skqb
   ghhbVHwld0Fz+mlp2TXGAmwk+wefprfxWm2erj5IHwmTarC2WtE76uZgo
   A==;
X-CSE-ConnectionGUID: JAJZjOehT0aHvZx29Bo+gA==
X-CSE-MsgGUID: JqRh1f6RQNyO7F1e9SkRkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11650"; a="79453581"
X-IronPort-AV: E=Sophos;i="6.21,170,1763452800"; 
   d="scan'208";a="79453581"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2025 02:55:38 -0800
X-CSE-ConnectionGUID: l3XXydjMRKWMs9RlLeKyMw==
X-CSE-MsgGUID: t004zd1tStaREg6nDqq5KA==
X-ExtLoop1: 1
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa003.fm.intel.com with ESMTP; 23 Dec 2025 02:55:35 -0800
Date: Tue, 23 Dec 2025 18:39:08 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-coco@lists.linux.dev, linux-pci@vger.kernel.org,
	chao.gao@intel.com, dave.jiang@intel.com, baolu.lu@linux.intel.com,
	yilun.xu@intel.com, zhenzhong.duan@intel.com, kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com, dave.hansen@linux.intel.com,
	dan.j.williams@intel.com, kas@kernel.org, x86@kernel.org
Subject: Re: [PATCH v1 12/26] iommu/vt-d: Reserve the MSB domain ID bit for
 the TDX module
Message-ID: <aUpxTD3yyU20jqzy@yilunxu-OptiPlex-7050>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
 <20251117022311.2443900-13-yilun.xu@linux.intel.com>
 <20251219115115.00000922@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251219115115.00000922@huawei.com>

On Fri, Dec 19, 2025 at 11:51:15AM +0000, Jonathan Cameron wrote:
> On Mon, 17 Nov 2025 10:22:56 +0800
> Xu Yilun <yilun.xu@linux.intel.com> wrote:
> 
> > From: Lu Baolu <baolu.lu@linux.intel.com>
> > 
> > The Intel TDX Connect Architecture Specification defines some enhancements
> > for the VT-d architecture to introduce IOMMU support for TEE-IO requests.
> > Section 2.2, 'Trusted DMA' states that:
> > 
> > "I/O TLB and DID Isolation – When IOMMU is enabled to support TDX
> > Connect, the IOMMU restricts the VMM’s DID setting, reserving the MSB bit
> > for the TDX module. The TDX module always sets this reserved bit on the
> > trusted DMA table. IOMMU tags IOTLB, PASID cache, and context entries to
> > indicate whether they were created from TEE-IO transactions, ensuring
> > isolation between TEE and non-TEE requests in translation caches."
> > 
> > Reserve the MSB in the domain ID for the TDX module's use if the
> > enhancement is required, which is detected if the ECAP.TDXCS bit in the
> > VT-d extended capability register is set and the TVM Usable field of the
> > ACPI KEYP table is set.
> > 
> > Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Hi,
> One comment inline.
> 
> Thanks,
> 
> Jonathan
> 
> > diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
> > index a54934c0536f..e9d65b26ad64 100644
> > --- a/drivers/iommu/intel/dmar.c
> > +++ b/drivers/iommu/intel/dmar.c
> > @@ -1033,6 +1033,56 @@ static int map_iommu(struct intel_iommu *iommu, struct dmar_drhd_unit *drhd)
> >  	return err;
> >  }
> >  
> > +static int keyp_config_unit_tvm_usable(union acpi_subtable_headers *header,
> > +				       void *arg, const unsigned long end)
> > +{
> > +	struct acpi_keyp_config_unit *acpi_cu =
> > +		(struct acpi_keyp_config_unit *)&header->keyp;
> > +	int *tvm_usable = arg;
> > +
> > +	if (acpi_cu->flags & ACPI_KEYP_F_TVM_USABLE)
> > +		*tvm_usable = true;
> As below. Be consistent on int vs bool as otherwise the subtle use of -1 is very confusing.
> > +
> > +	return 0;
> > +}
> > +
> > +static bool platform_is_tdxc_enhanced(void)
> > +{
> > +	static int tvm_usable = -1;
> > +	int ret;
> > +
> > +	/* only need to parse once */
> > +	if (tvm_usable != -1)
> > +		return tvm_usable;
> > +
> > +	tvm_usable = false;
> 
> This is flipping between an int and a bool which seems odd.
> I'd stick to an integer then make it a bool only at return.

I agree. My change below:

> 
> > +	ret = acpi_table_parse_keyp(ACPI_KEYP_TYPE_CONFIG_UNIT,
> > +				    keyp_config_unit_tvm_usable, &tvm_usable);
> > +	if (ret < 0)
> > +		tvm_usable = false;
> > +
> > +	return tvm_usable;
> > +}

-----------8<----------------------

diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
index 645b72270967..fd14de8775b6 100644
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -1041,7 +1041,7 @@ static int keyp_config_unit_tvm_usable(union acpi_subtable_headers *header,
        int *tvm_usable = arg;

        if (acpi_cu->flags & ACPI_KEYP_F_TVM_USABLE)
-               *tvm_usable = true;
+               *tvm_usable = 1;

        return 0;
 }
@@ -1053,15 +1053,15 @@ static bool platform_is_tdxc_enhanced(void)

        /* only need to parse once */
        if (tvm_usable != -1)
-               return tvm_usable;
+               return !!tvm_usable;

-       tvm_usable = false;
+       tvm_usable = 0;
        ret = acpi_table_parse_keyp(ACPI_KEYP_TYPE_CONFIG_UNIT,
                                    keyp_config_unit_tvm_usable, &tvm_usable);
        if (ret < 0)
-               tvm_usable = false;
+               tvm_usable = 0;

-       return tvm_usable;
+       return !!tvm_usable;
 }


> 
> 
> 

