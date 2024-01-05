Return-Path: <kvm+bounces-5727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFA608257B9
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 17:09:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7CE872848E7
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 16:09:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A5872E85C;
	Fri,  5 Jan 2024 16:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="AnNlgIoY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D892E829
	for <kvm@vger.kernel.org>; Fri,  5 Jan 2024 16:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-78102c516a7so118166385a.2
        for <kvm@vger.kernel.org>; Fri, 05 Jan 2024 08:09:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1704470955; x=1705075755; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OpooDyfXmW8Ut7AOpOztJZrrSaKLYxmTTrMVAmO+7hU=;
        b=AnNlgIoYKHr3+H47TP0eRp9eH029K1Rjfcr4zoauWtfXv3+tvg+ZqOMAePtnZ4eId0
         ftCVo8QriuhywS+fCFhyRzz/z5iPJF20xdKQvvmxaTSF5J+2gpYpq6Igdpi+xp7qgx2Z
         fTMxrP5Uo8iWRDasmiEdkH8vaqUhbz64IOxsICuAL650/NSd78nZhU+KgBMpwqYl6Dx1
         C0n8IwrazMM1fjif73nc9CYTOfGUixhkuGStWtAEhml0jKmhT7NuI/DSKcqeP8fpStJa
         6fuetUmuYlytDjG6tsp8L6gSwOeTR79pT2ZIcAK+jAL/av/AWZehwbPdBB7N6TYGu78F
         BB3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704470955; x=1705075755;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OpooDyfXmW8Ut7AOpOztJZrrSaKLYxmTTrMVAmO+7hU=;
        b=OC3V2n8wh+EEBERbne+Lvy6zFUjt+0SH4E7/hAcz4QFFddpktCXIjrH33wXm7Yjs93
         w9YMjnW7NIbMv25e/WtpMahrXbt+/voA+v1JrTE0fBtJYXE8NLFEh8jifB4dHQhJVAZx
         48qfBhrSfQQCCJeX0AK+Tz68mnh1WGtHbdoaVsAkqArVkAIpWCvQCJECewgYH2s5+/LF
         qDvS8RDd5CnbSN8ht7Tc5MPcKUQ51VFzMhib2jBeCEJJsM8YROXlqtUZQKE5bz2OdM9v
         dz8PStSutqdzcSbgy/egjC9PnGEu3PFTeOAFe6jJobo0WrJA+9h926SdXVXeQc49PTEg
         Y71Q==
X-Gm-Message-State: AOJu0YwXYNASYebDQvi5kegZyx/I6Q26oz/RWaNU7fFsQVSxYKt7IikB
	ml4Bx3pnsWMnE1Sx19I0DO6DzVlZMVBe3g==
X-Google-Smtp-Source: AGHT+IF9Lt2OpQmNDIgqSurQI3h0cZY6/3o6oVwPtrzRc3YbYutPrsiJKSv+ksjxFIKq2d/NBCHwxw==
X-Received: by 2002:a05:622a:134a:b0:428:1295:6e1b with SMTP id w10-20020a05622a134a00b0042812956e1bmr3172412qtk.28.1704470954942;
        Fri, 05 Jan 2024 08:09:14 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id w17-20020ac86b11000000b00425dac6d04csm836926qts.3.2024.01.05.08.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jan 2024 08:09:14 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1rLmkz-001TTG-VU;
	Fri, 05 Jan 2024 12:09:13 -0400
Date: Fri, 5 Jan 2024 12:09:13 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Longfang Liu <liulongfang@huawei.com>,
	Yan Zhao <yan.y.zhao@intel.com>, iommu@lists.linux.dev,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 12/14] iommu: Use refcount for fault data access
Message-ID: <20240105160913.GG50608@ziepe.ca>
References: <20231220012332.168188-1-baolu.lu@linux.intel.com>
 <20231220012332.168188-13-baolu.lu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231220012332.168188-13-baolu.lu@linux.intel.com>

On Wed, Dec 20, 2023 at 09:23:30AM +0800, Lu Baolu wrote:
> The per-device fault data structure stores information about faults
> occurring on a device. Its lifetime spans from IOPF enablement to
> disablement. Multiple paths, including IOPF reporting, handling, and
> responding, may access it concurrently.
> 
> Previously, a mutex protected the fault data from use after free. But
> this is not performance friendly due to the critical nature of IOPF
> handling paths.
> 
> Refine this with a refcount-based approach. The fault data pointer is
> obtained within an RCU read region with a refcount. The fault data
> pointer is returned for usage only when the pointer is valid and a
> refcount is successfully obtained. The fault data is freed with
> kfree_rcu(), ensuring data is only freed after all RCU critical regions
> complete.
> 
> An iopf handling work starts once an iopf group is created. The handling
> work continues until iommu_page_response() is called to respond to the
> iopf and the iopf group is freed. During this time, the device fault
> parameter should always be available. Add a pointer to the device fault
> parameter in the iopf_group structure and hold the reference until the
> iopf_group is freed.
> 
> Make iommu_page_response() static as it is only used in io-pgfault.c.
> 
> Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Tested-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  include/linux/iommu.h      |  17 +++--
>  drivers/iommu/io-pgfault.c | 129 +++++++++++++++++++++++--------------
>  drivers/iommu/iommu-sva.c  |   2 +-
>  3 files changed, 90 insertions(+), 58 deletions(-)

This looks basically Ok

> +/* Caller must hold a reference of the fault parameter. */
> +static void iopf_put_dev_fault_param(struct iommu_fault_param *fault_param)
> +{
> +	if (refcount_dec_and_test(&fault_param->users))
> +		kfree_rcu(fault_param, rcu);
> +}

[..]

> @@ -402,10 +429,12 @@ int iopf_queue_add_device(struct iopf_queue *queue, struct device *dev)
>  	INIT_LIST_HEAD(&fault_param->faults);
>  	INIT_LIST_HEAD(&fault_param->partial);
>  	fault_param->dev = dev;
> +	refcount_set(&fault_param->users, 1);
> +	init_rcu_head(&fault_param->rcu);

No need to do init_rcu_head() when only using it for calling
kfree_rcu()

> @@ -454,8 +485,10 @@ int iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
>  	list_for_each_entry_safe(iopf, next, &fault_param->partial, list)
>  		kfree(iopf);
>  
> -	param->fault_param = NULL;
> -	kfree(fault_param);
> +	/* dec the ref owned by iopf_queue_add_device() */
> +	rcu_assign_pointer(param->fault_param, NULL);
> +	if (refcount_dec_and_test(&fault_param->users))
> +		kfree_rcu(fault_param, rcu);

Why open code iopf_put_dev_fault_param()? Just call it.

With those:

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

