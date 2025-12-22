Return-Path: <kvm+bounces-66472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 85C0ECD5FB9
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 13:32:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C54083036593
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 12:32:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 932A529A33E;
	Mon, 22 Dec 2025 12:31:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D712853F8;
	Mon, 22 Dec 2025 12:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766406719; cv=none; b=dRVDBq00+a9Xk4ALoPOo5orei8m3eovLV/pS5LxytK7IaXCgZpfBgwn5bWAk0X4Ini/vnT+BzPylQlFdMjahP1Bve3NdEAxGUlLS5QFL6QpWNTxKTHsDaGDM3HF7488r0w0IleEku3Iam6kBdZ2aJTmp+CqrpVDWEav+cNXBdgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766406719; c=relaxed/simple;
	bh=8A9xyXlI1g1GPbGgGHNbTaLkYLYd+HjYtpSorbOPFm0=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R6xpuJ30S2u1JrGVpV0GybY3tONqujkQjtz4SzGLwDhZI2Lus5llv9sgulvlECWk+TAdZNxzRxNYtAgJZhHxNvtCxPnEE4nEH9jddu82HJ3QdhwQv0i+Qh0Cvp8+bNZn+W0BoEXkb7ll5jtMBcxmKrYCfXjAqoIWOm30/o8H7lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dZcv94CG4zHnH7S;
	Mon, 22 Dec 2025 20:31:17 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 94BFC40579;
	Mon, 22 Dec 2025 20:31:52 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 22 Dec
 2025 12:31:51 +0000
Date: Mon, 22 Dec 2025 12:31:49 +0000
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
Subject: Re: [RFC v2 05/15] cxl: introduce cxl_get_committed_regions()
Message-ID: <20251222123149.00003f91@huawei.com>
In-Reply-To: <20251209165019.2643142-6-mhonap@nvidia.com>
References: <20251209165019.2643142-1-mhonap@nvidia.com>
	<20251209165019.2643142-6-mhonap@nvidia.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Tue, 9 Dec 2025 22:20:09 +0530
mhonap@nvidia.com wrote:

> From: Zhi Wang <zhiw@nvidia.com>
> 
> The kernel CXL core can discover the configured and committed CXL regions
> from BIOS or firmware, respect its configuration and create the related
> kernel CXL core data structures without configuring and committing the CXL
> region.
> 
> However, those information are kept within the kernel CXL core. A type-2
> device can have the same usage and a type-2 driver would like to know
> about it before creating the CXL regions.
> 
> Introduce cxl_get_committed_regions() for a type-2 driver to discover the
> committed regions.
> 
> Signed-off-by: Zhi Wang <zhiw@nvidia.com>
> Signed-off-by: Manish Honap <mhonap@nvidia.com>
A few trivial things inline.

Thanks,

Jonathan

> ---
>  drivers/cxl/core/region.c | 73 +++++++++++++++++++++++++++++++++++++++
>  include/cxl/cxl.h         |  1 +
>  2 files changed, 74 insertions(+)
> 
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index e89a98780e76..6c368b4641f1 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -2785,6 +2785,79 @@ int cxl_get_region_range(struct cxl_region *region, struct range *range)
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_get_region_range, "CXL");
>  
> +struct match_region_info {
> +	struct cxl_memdev *cxlmd;
> +	struct cxl_region **cxlrs;
> +	int nr_regions;
> +};
> +
> +static int match_region_by_device(struct device *match, void *data)
> +{
> +	struct match_region_info *info = data;
> +	struct cxl_endpoint_decoder *cxled;
> +	struct cxl_memdev *cxlmd;
> +	struct cxl_region_params *p;
> +	struct cxl_region *cxlr;
> +	int i;
> +
> +	if (!is_cxl_region(match))
> +		return 0;
> +
> +	lockdep_assert_held(&cxl_rwsem.region);
> +	cxlr = to_cxl_region(match);
> +	p = &cxlr->params;
> +
> +	if (p->state != CXL_CONFIG_COMMIT)
> +		return 0;
> +
> +	for (i = 0; i < p->nr_targets; i++) {
> +		void *cxlrs;

Might be worth giving this a type.

> +
> +		cxled = p->targets[i];
> +		cxlmd = cxled_to_memdev(cxled);
> +
> +		if (info->cxlmd != cxlmd)
> +			continue;
> +
> +		cxlrs = krealloc(info->cxlrs, sizeof(cxlr) * (info->nr_regions + 1),
> +				 GFP_KERNEL);

krealloc_array() slightly better here I think.

> +		if (!cxlrs) {
> +			kfree(info->cxlrs);
> +			return -ENOMEM;
> +		}
> +		info->cxlrs = cxlrs;
> +
> +		info->cxlrs[info->nr_regions++] = cxlr;
> +	}
> +
> +	return 0;
> +}
> +
> +int cxl_get_committed_regions(struct cxl_memdev *cxlmd, struct cxl_region ***cxlrs, int *num)
> +{
> +	struct match_region_info info = {0};
> +	int ret = 0;

Always set, so don't initialize here.

> +
> +	ret = down_write_killable(&cxl_rwsem.region);

Look at the ACQUIRE() stuff for this.

> +	if (ret)
> +		return ret;
> +
> +	info.cxlmd = cxlmd;
> +
> +	ret = bus_for_each_dev(&cxl_bus_type, NULL, &info, match_region_by_device);
> +	if (ret) {
> +		kfree(info.cxlrs);

With acquire magic above, ran return directly here.

> +	} else {
> +		*cxlrs = info.cxlrs;
> +		*num = info.nr_regions;
> +	}
> +
> +	up_write(&cxl_rwsem.region);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_get_committed_regions, "CXL");
> +
>  static ssize_t __create_region_show(struct cxl_root_decoder *cxlrd, char *buf)
>  {
>  	return sysfs_emit(buf, "region%u\n", atomic_read(&cxlrd->region_id));
> diff --git a/include/cxl/cxl.h b/include/cxl/cxl.h
> index e3bf8cf0b6d6..0a1f245557f4 100644
> --- a/include/cxl/cxl.h
> +++ b/include/cxl/cxl.h
> @@ -295,5 +295,6 @@ int cxl_get_region_range(struct cxl_region *region, struct range *range);
>  int cxl_get_hdm_reg_info(struct cxl_dev_state *cxlds, u64 *count, u64 *offset,
>  			 u64 *size);
>  int cxl_find_comp_regblock_offset(struct pci_dev *pdev, u64 *offset);
> +int cxl_get_committed_regions(struct cxl_memdev *cxlmd, struct cxl_region ***cxlrs, int *num);
>  
>  #endif /* __CXL_CXL_H__ */


