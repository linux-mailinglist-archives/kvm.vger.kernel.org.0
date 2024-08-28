Return-Path: <kvm+bounces-25252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 189FB962942
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 15:50:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC4562837B8
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 13:50:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07377188CC2;
	Wed, 28 Aug 2024 13:49:57 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFE61EB3D;
	Wed, 28 Aug 2024 13:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724852996; cv=none; b=KXjHR8YGgARR2tWVqTJIaAV7IlR87izXA41YRm23aZCHzJJ8Gb9rsKxjBSZg1tMhHJyiwo26L9DVNNt4jSQqVsBzwgNm3IWlx0kqFB2Yw81Ndh8tl23rkbPY6NTYEEElNmvhHNFymhYuEBCAHk/2wU1ag8MJ36foztdCS1Q4ZvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724852996; c=relaxed/simple;
	bh=MlvzK++rts6N5s5ER6D1ysWQa4XUMbHr4Vl8gRTANUE=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tORVbLu7AaW3h34LpmQy7VDJLpvorhGAdMGzpWLODxqZfiGXxwc/pW4mRnChBwsQJaVgAz1PgtY3624j9kRW/i42VQsc/ePUXCVeS8E80SmuGCYbWIdpwbqlOazJqGUVXpoKUa0hBnxD4p8FBnLdlgzvCNE963BIKcOpaeurptE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Wv5L32qKpz67ZDL;
	Wed, 28 Aug 2024 21:46:35 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id AC1641400D4;
	Wed, 28 Aug 2024 21:49:51 +0800 (CST)
Received: from localhost (10.203.177.66) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 28 Aug
 2024 14:49:51 +0100
Date: Wed, 28 Aug 2024 14:49:50 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Alexey Kardashevskiy <aik@amd.com>
CC: <kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
	<linux-coco@lists.linux.dev>, <linux-pci@vger.kernel.org>, "Suravee
 Suthikulpanit" <suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, Dan Williams <dan.j.williams@intel.com>,
	<pratikrajesh.sampat@amd.com>, <michael.day@amd.com>, <david.kaplan@amd.com>,
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, "Michael Roth" <michael.roth@amd.com>, Alexander
 Graf <agraf@suse.de>, "Nikunj A Dadhania" <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, "Lukas Wunner" <lukas@wunner.de>
Subject: Re: [RFC PATCH 01/21] tsm-report: Rename module to reflect what it
 does
Message-ID: <20240828144950.000004b7@Huawei.com>
In-Reply-To: <20240823132137.336874-2-aik@amd.com>
References: <20240823132137.336874-1-aik@amd.com>
	<20240823132137.336874-2-aik@amd.com>
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
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

On Fri, 23 Aug 2024 23:21:15 +1000
Alexey Kardashevskiy <aik@amd.com> wrote:

> And release the name for TSM to be used for TDISP-associated code.
> 
Mention that it's not a simple file rename.
Some structure renames etc as well.

Maybe consider renaming the bits of the exported API as
well?


> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
>  drivers/virt/coco/Makefile                |  2 +-
>  include/linux/{tsm.h => tsm-report.h}     | 15 ++++++++-------
>  drivers/virt/coco/sev-guest/sev-guest.c   | 10 +++++-----
>  drivers/virt/coco/tdx-guest/tdx-guest.c   |  8 ++++----
>  drivers/virt/coco/{tsm.c => tsm-report.c} | 12 ++++++------
>  MAINTAINERS                               |  4 ++--
>  6 files changed, 26 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/virt/coco/Makefile b/drivers/virt/coco/Makefile
> index 18c1aba5edb7..75defec514f8 100644
> --- a/drivers/virt/coco/Makefile
> +++ b/drivers/virt/coco/Makefile
> @@ -2,7 +2,7 @@
>  #
>  # Confidential computing related collateral
>  #
> -obj-$(CONFIG_TSM_REPORTS)	+= tsm.o
> +obj-$(CONFIG_TSM_REPORTS)	+= tsm-report.o
>  obj-$(CONFIG_EFI_SECRET)	+= efi_secret/
>  obj-$(CONFIG_SEV_GUEST)		+= sev-guest/
>  obj-$(CONFIG_INTEL_TDX_GUEST)	+= tdx-guest/
> diff --git a/include/linux/tsm.h b/include/linux/tsm-report.h
> similarity index 92%
> rename from include/linux/tsm.h
> rename to include/linux/tsm-report.h
> index 11b0c525be30..4d815358790b 100644
> --- a/include/linux/tsm.h
> +++ b/include/linux/tsm-report.h
> @@ -1,6 +1,6 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
> -#ifndef __TSM_H
> -#define __TSM_H
> +#ifndef __TSM_REPORT_H
> +#define __TSM_REPORT_H
>  
>  #include <linux/sizes.h>
>  #include <linux/types.h>
> @@ -88,7 +88,7 @@ enum tsm_bin_attr_index {
>  };
>  
>  /**
> - * struct tsm_ops - attributes and operations for tsm instances
> + * struct tsm_report_ops - attributes and operations for tsm instances
>   * @name: tsm id reflected in /sys/kernel/config/tsm/report/$report/provider
>   * @privlevel_floor: convey base privlevel for nested scenarios
>   * @report_new: Populate @report with the report blob and auxblob
> @@ -99,7 +99,7 @@ enum tsm_bin_attr_index {
>   * Implementation specific ops, only one is expected to be registered at
>   * a time i.e. only one of "sev-guest", "tdx-guest", etc.
>   */
> -struct tsm_ops {
> +struct tsm_report_ops {
>  	const char *name;
>  	unsigned int privlevel_floor;
>  	int (*report_new)(struct tsm_report *report, void *data);
> @@ -107,6 +107,7 @@ struct tsm_ops {
>  	bool (*report_bin_attr_visible)(int n);
>  };
>  
> -int tsm_register(const struct tsm_ops *ops, void *priv);
> -int tsm_unregister(const struct tsm_ops *ops);
> -#endif /* __TSM_H */
> +int tsm_register(const struct tsm_report_ops *ops, void *priv);
> +int tsm_unregister(const struct tsm_report_ops *ops);
Perhaps makes sense to make thiese
tsm_report_register() etc.

> +#endif /* __TSM_REPORT_H */
> +


