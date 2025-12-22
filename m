Return-Path: <kvm+bounces-66474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BD58BCD642A
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 14:56:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E4F0A306CC26
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 13:54:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7369231A57A;
	Mon, 22 Dec 2025 13:54:09 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566C12FE591;
	Mon, 22 Dec 2025 13:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766411648; cv=none; b=X3UoMShIWtOyN82/xjMz9SE/Hvulj3wg4HGDisper6xw1sZuqR6LIxBOJJr/pUJTXzJEBEfuFEZPCpUsK66Min9FAWM5MoPGMuLX7EGxJO94Tuhyl9tZ+6EscPYJ8SurTAXNwsXMxaz3Odd+TBzGlYDF3Xc3mLa6zZHXwHNW9mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766411648; c=relaxed/simple;
	bh=EESYErKpkIym4pV/s44YmQuV5etFqxG9coHwLXR7A0o=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gO6HrpZKendbdiy6zwDs2SXalGgJunv+OvcjMaEfyIF4GQ4MzS3Nidu/b0Acz/CGRi3TjIhKsukTDRdnRaT/PeTPq4ilXasa6JyJ6u/qL6M4hevx17D5paIywarhcQbp1otC89ktCNN6mxKE0DblE3hcwoWT8JuusHIJIOpDJSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dZfjw6bq7zJ46Zw;
	Mon, 22 Dec 2025 21:53:24 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 7D8BB4056A;
	Mon, 22 Dec 2025 21:54:02 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 22 Dec
 2025 13:54:01 +0000
Date: Mon, 22 Dec 2025 13:54:00 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: <mhonap@nvidia.com>
CC: <aniketa@nvidia.com>, <ankita@nvidia.com>, <alwilliamson@nvidia.com>,
	<vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
	<skolothumtho@nvidia.com>, <alejandro.lucero-palau@amd.com>,
	<dave@stgolabs.net>, <dave.jiang@intel.com>, <alison.schofield@intel.com>,
	<vishal.l.verma@intel.com>, <ira.weiny@intel.com>,
	<dan.j.williams@intel.com>, <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<kevin.tian@intel.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<linux-kernel@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
	<kvm@vger.kernel.org>
Subject: Re: [RFC v2 06/15] vfio/cxl: introduce vfio-cxl core preludes
Message-ID: <20251222135400.000041d6@huawei.com>
In-Reply-To: <20251209165019.2643142-7-mhonap@nvidia.com>
References: <20251209165019.2643142-1-mhonap@nvidia.com>
	<20251209165019.2643142-7-mhonap@nvidia.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100009.china.huawei.com (7.191.174.83) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Tue, 9 Dec 2025 22:20:10 +0530
mhonap@nvidia.com wrote:

> From: Manish Honap <mhonap@nvidia.com>
> 
> In VFIO, common functions that used by VFIO variant drivers are managed
> in a set of "core" functions. E.g. the vfio-pci-core provides the common
> functions used by VFIO variant drviers to support PCI device
> passhthrough.
> 
> Although the CXL type-2 device has a PCI-compatible interface for device
> configuration and programming, they still needs special handlings when
> initialize the device:
> 
> - Probing the CXL DVSECs in the configuration.
> - Probing the CXL register groups implemented by the device.
> - Configuring the CXL device state required by the kernel CXL core.
> - Create the CXL region.
> - Special handlings of the CXL MMIO BAR.
> 
> Introduce vfio-cxl core preludes to hold all the common functions used
> by VFIO variant drivers to support CXL device passthrough.
> 
> Co-developed-by: Zhi Wang <zhiw@nvidia.com>
> Signed-off-by: Zhi Wang <zhiw@nvidia.com>
> Signed-off-by: Manish Honap <mhonap@nvidia.com>

One trivial thing from a first look.

> diff --git a/drivers/vfio/pci/vfio_cxl_core.c b/drivers/vfio/pci/vfio_cxl_core.c
> new file mode 100644
> index 000000000000..cf53720c0cb7
> --- /dev/null
> +++ b/drivers/vfio/pci/vfio_cxl_core.c
> @@ -0,0 +1,238 @@

> +
> +int vfio_cxl_core_create_cxl_region(struct vfio_cxl_core_device *cxl, u64 size)
> +{
> +	struct cxl_region *region;
> +	struct range range;
> +	int ret;
> +	struct vfio_cxl *cxl_core = cxl->cxl_core;
> +
> +	if (WARN_ON(cxl_core->region.region))
> +		return -EEXIST;
> +
> +	ret = get_hpa_and_request_dpa(cxl, size);
> +	if (ret)
> +		return ret;
> +
> +	region = cxl_create_region(cxl_core->cxlrd, &cxl_core->cxled, true);
> +	if (IS_ERR(region)) {
> +		ret = PTR_ERR(region);
> +		cxl_dpa_free(cxl_core->cxled);
> +		return ret;

Trivial but might as well do:

		return PTR_ERR(region);

and save a line.

> +	}
> +
> +	cxl_get_region_range(region, &range);
> +
> +	cxl_core->region.addr = range.start;
> +	cxl_core->region.size = size;
> +	cxl_core->region.region = region;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(vfio_cxl_core_create_cxl_region);


