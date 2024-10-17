Return-Path: <kvm+bounces-29090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BC8C9A273A
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 17:45:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D3A91C25FE1
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 15:45:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4CF61DEFF3;
	Thu, 17 Oct 2024 15:45:09 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8D21DEFD9;
	Thu, 17 Oct 2024 15:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729179909; cv=none; b=p9XoPqKe8c4tuVsoJLyaDkP1iZTkmBQH8bnIxxTaQpiye9ubA6AUg3Xceh1Bu8K4QmneOIbDwCwgxBBKAUmzqrXlZ9cERklnPT60YzD9hv2AxkU8KCNCWiBOZ3xhpkFKmD/Ux5J0PBhAhlbmXYEsjFoXNBoAUtFjBYiq4tr07MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729179909; c=relaxed/simple;
	bh=z+KqskxnvtsvBDQHH6tuFMnvuSwgd5QQRptn8yELwJ4=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OMa+BPQlTNecRfpYklqTJUC2E3sL5pgnVDTI52lhCzzoB9gD2yT7qU2bzM0ukAuOX0cEmaHqv0h3cae5mh4pl6ShSO653+W62NzsNY8lFSS9AhDMK41lPXZ87PXHGUYidkfaTQ/6McNZWt51r/KUW4wx6ZNe23ZvL62ZKnr0wN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XTsVP5jXsz6D9SR;
	Thu, 17 Oct 2024 23:40:29 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 876A51400C9;
	Thu, 17 Oct 2024 23:45:01 +0800 (CST)
Received: from localhost (10.126.174.164) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 17 Oct
 2024 17:45:00 +0200
Date: Thu, 17 Oct 2024 16:44:58 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Zhi Wang <zhiw@nvidia.com>
CC: <kvm@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
	<alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<alison.schofield@intel.com>, <dan.j.williams@intel.com>,
	<dave.jiang@intel.com>, <dave@stgolabs.net>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alucerop@amd.com>, <acurrid@nvidia.com>,
	<cjia@nvidia.com>, <smitra@nvidia.com>, <ankita@nvidia.com>,
	<aniketa@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiwang@kernel.org>
Subject: Re: [RFC 02/13] cxl: introduce cxl_get_hdm_info()
Message-ID: <20241017164458.00003c1f@Huawei.com>
In-Reply-To: <20240920223446.1908673-3-zhiw@nvidia.com>
References: <20240920223446.1908673-1-zhiw@nvidia.com>
	<20240920223446.1908673-3-zhiw@nvidia.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100001.china.huawei.com (7.191.160.183) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Fri, 20 Sep 2024 15:34:35 -0700
Zhi Wang <zhiw@nvidia.com> wrote:

> CXL core has the information of what CXL register groups a device has.
> When initializing the device, the CXL core probes the register groups
> and saves the information. The probing sequence is quite complicated.
> 
> vfio-cxl requires the HDM register information to emualte the HDM decoder
Hi Zhi,

I know these were a bit rushed out so I'll only comment once.
Give your patch descriptions a spell check (I always forget :)
emulate

> registers.
> 
> Introduce cxl_get_hdm_info() for vfio-cxl to leverage the HDM
> register information in the CXL core. Thus, it doesn't need to implement
> its own probing sequence.
> 
> Signed-off-by: Zhi Wang <zhiw@nvidia.com>
> ---
>  drivers/cxl/core/pci.c        | 28 ++++++++++++++++++++++++++++
>  drivers/cxl/cxlpci.h          |  3 +++
>  include/linux/cxl_accel_mem.h |  2 ++
>  3 files changed, 33 insertions(+)
> 
> diff --git a/drivers/cxl/core/pci.c b/drivers/cxl/core/pci.c
> index a663e7566c48..7b6c2b6211b3 100644
> --- a/drivers/cxl/core/pci.c
> +++ b/drivers/cxl/core/pci.c
> @@ -502,6 +502,34 @@ int cxl_hdm_decode_init(struct cxl_dev_state *cxlds, struct cxl_hdm *cxlhdm,
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_hdm_decode_init, CXL);
>  
> +int cxl_get_hdm_info(struct cxl_dev_state *cxlds, u32 *hdm_count,
> +		     u64 *hdm_reg_offset, u64 *hdm_reg_size)
> +{
> +	struct pci_dev *pdev = to_pci_dev(cxlds->dev);
> +	int d = cxlds->cxl_dvsec;
> +	u16 cap;
> +	int rc;
> +
> +	if (!cxlds->reg_map.component_map.hdm_decoder.valid) {
> +		*hdm_reg_offset = *hdm_reg_size = 0;
Probably want to zero out the hdm_count as well?

> +	} else {
> +		struct cxl_component_reg_map *map =
> +			&cxlds->reg_map.component_map;
> +
> +		*hdm_reg_offset = map->hdm_decoder.offset;
> +		*hdm_reg_size = map->hdm_decoder.size;
> +	}
> +
> +	rc = pci_read_config_word(pdev,
> +				  d + CXL_DVSEC_CAP_OFFSET, &cap);
> +	if (rc)
> +		return rc;
> +
> +	*hdm_count = FIELD_GET(CXL_DVSEC_HDM_COUNT_MASK, cap);
> +	return 0;
> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_get_hdm_info, CXL);

