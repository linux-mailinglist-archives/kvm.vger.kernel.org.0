Return-Path: <kvm+bounces-54114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 304F2B1C76A
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 16:13:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1FADC4E34C1
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 14:13:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59E4D28CF7B;
	Wed,  6 Aug 2025 14:12:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BA328AAE6;
	Wed,  6 Aug 2025 14:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754489578; cv=none; b=EvBlPvBq93AdTPWslg+pe2XKiGoI/swXE5JUvj7wtEcYxpYc9BCr0FxgNIuD6MMP6+q+zzr6lrjeqhmlL4oX/wvjLNYPy2jADrgY9pLb3KpPEtkdwzGi6M1fxXaZK9/+X7jYCzpaZyCUfPbqWH1qXcSblutThLh/cjR7jJldE8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754489578; c=relaxed/simple;
	bh=V/dVNsM+cmqBM7zUq1pQlgUZUed6LArBaFY9Pn5trYQ=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B5mSukO9ZZDEdxh1Su0dRmIOWCOLZxw7Kj04mYV9xS7Y6g3OIB8fsM8W0CJVLSgNjeoWY2wYvK+No6oC0jnrWdqQDKJONB2C+eNHgHOa2G8JEcKPnWTbiJe3kOgGRJUi8q7pLHw4zOWfKbl8513An3/4EPLcscK5C0GAL9u1HaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bxsdQ5KvNz6L55m;
	Wed,  6 Aug 2025 22:10:34 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 70CDB140446;
	Wed,  6 Aug 2025 22:12:53 +0800 (CST)
Received: from localhost (10.81.207.60) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 6 Aug
 2025 16:12:52 +0200
Date: Wed, 6 Aug 2025 15:12:50 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Shameer Kolothum <shameerkolothum@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<alex.williamson@redhat.com>, <wangzhou1@hisilicon.com>,
	<liulongfang@huawei.com>, <linuxarm@huawei.com>,
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH] MAINTAINERS: Update Shameer Kolothum's email address
Message-ID: <20250806151250.0000678d@huawei.com>
In-Reply-To: <20250805083913.55863-1-shameerkolothum@gmail.com>
References: <20250805083913.55863-1-shameerkolothum@gmail.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500003.china.huawei.com (7.191.162.67) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Tue,  5 Aug 2025 09:39:13 +0100
Shameer Kolothum <shameerkolothum@gmail.com> wrote:

> My Huawei email will soon bounce and hence change to my personal
> email for now.
> 
> Also, since I no longer have access to HiSilicon hardware, remove
> myself from HISILICON PCI DRIVER maintainer entry.
> 
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Shameer Kolothum <shameerkolothum@gmail.com>
Acked-by: Jonathan Cameron <jonathan.cameron@huawei.com>

Good luck with your next adventure!

Jonathan

> ---
>  .mailmap    | 1 +
>  MAINTAINERS | 3 +--
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/.mailmap b/.mailmap
> index 4bb3a7f253b9..0d0f689e0912 100644
> --- a/.mailmap
> +++ b/.mailmap
> @@ -700,6 +700,7 @@ Sergey Senozhatsky <senozhatsky@chromium.org> <sergey.senozhatsky@mail.by>
>  Sergey Senozhatsky <senozhatsky@chromium.org> <senozhatsky@google.com>
>  Seth Forshee <sforshee@kernel.org> <seth.forshee@canonical.com>
>  Shakeel Butt <shakeel.butt@linux.dev> <shakeelb@google.com>
> +Shameer Kolothum <shameerkolothum@gmail.com> <shameerali.kolothum.thodi@huawei.com>
>  Shannon Nelson <sln@onemain.com> <shannon.nelson@amd.com>
>  Shannon Nelson <sln@onemain.com> <snelson@pensando.io>
>  Shannon Nelson <sln@onemain.com> <shannon.nelson@intel.com>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c0b444e5fd5a..424cb734215b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -26038,7 +26038,6 @@ F:	drivers/vfio/fsl-mc/
>  
>  VFIO HISILICON PCI DRIVER
>  M:	Longfang Liu <liulongfang@huawei.com>
> -M:	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
>  L:	kvm@vger.kernel.org
>  S:	Maintained
>  F:	drivers/vfio/pci/hisilicon/
> @@ -26067,7 +26066,7 @@ F:	drivers/vfio/pci/nvgrace-gpu/
>  VFIO PCI DEVICE SPECIFIC DRIVERS
>  R:	Jason Gunthorpe <jgg@nvidia.com>
>  R:	Yishai Hadas <yishaih@nvidia.com>
> -R:	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> +R:	Shameer Kolothum <shameerkolothum@gmail.com>
>  R:	Kevin Tian <kevin.tian@intel.com>
>  L:	kvm@vger.kernel.org
>  S:	Maintained


