Return-Path: <kvm+bounces-5731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C28282581A
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 17:25:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06A291C233C1
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 16:25:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98C003175F;
	Fri,  5 Jan 2024 16:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="X7QrslCm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919C72E846
	for <kvm@vger.kernel.org>; Fri,  5 Jan 2024 16:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-5ec7a5a4b34so18347607b3.0
        for <kvm@vger.kernel.org>; Fri, 05 Jan 2024 08:25:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1704471941; x=1705076741; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xt6bOKxX4WKSd5QuH7ry/2mZIxNV/j9IGmlac4AQg1Q=;
        b=X7QrslCm8Hjgqy4GrPM7QIUCYsRj7QiPrDpw8+cvLZapgFDjYVulbuIbTkc5oOWVh0
         edVzaOXBhzXsiNxULvmhF61xSSBhvfng3aZsPU7HNEb+bsJmNhWpxMQDb7aqM/2uSeZG
         alze4MmOoCon4EAuMZfEftvVb/qCcfQN019KIukNWWLHSCTL0Td6D3BvP23muTn1buCL
         NpLD/gRuyL9dms28cW1mGr+cHzV5BsYjQ9jMzi5IOlf+3HpjISUsrsXCJkf0J5j7gaqB
         Z0ZQbBtoq+0M9t7tLMHe+CYB4/zthh13yE9vqoxV1KEn6tb6epCE5T1iO3lTO52Ki4UE
         OiUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704471941; x=1705076741;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xt6bOKxX4WKSd5QuH7ry/2mZIxNV/j9IGmlac4AQg1Q=;
        b=nx9ImwwhtAvDU4wx9MyT7ZFzlYj0+kWmpkrDKcAExVHqJFxrAqDJovNBHJqwN6Amkx
         Cuz7s9yp/qgfzq6/WAn2/JK+DoJzlipD926+97rd6NYxJB6YlqZcSlTUyopuWSuCHdGs
         jZ9FJEuP5YD+2HWoTJEbi5f/pfgXq431K8CAOPKOCPB0V7oNS7wFys9OAczIcjNYWCJu
         sdTcLIjWTteMHZQW0T+ztmryTzkycJUVVhDah6yDckjJKhWVlCyyJCu9AKklOzlmRvI9
         WZPM8WzsOSKeFvsb9QdlwM+Pj8ZcqaXtqanSf942bUb438VMy7KF+DmhGkmKps+tmdDX
         /u9Q==
X-Gm-Message-State: AOJu0Yx+OH9iq6hSvcF+dTFaLQEP9VW9EMpWVA3IVfVL5wAQMYyk+Zke
	T1fIlQY57yE62YpSzsBZX6dXXDzDxI/Btg==
X-Google-Smtp-Source: AGHT+IHH8UN8MoX0zsxIuGAZ3wRCTin7zoXycnqxgOEJNmeU4cje+YwzHaFJ7RjoRuZOBMhG15NGxQ==
X-Received: by 2002:a0d:c783:0:b0:5ea:c5d5:6a00 with SMTP id j125-20020a0dc783000000b005eac5d56a00mr2373497ywd.55.1704471941479;
        Fri, 05 Jan 2024 08:25:41 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id da13-20020a05621408cd00b0067f9bbd1689sm720815qvb.76.2024.01.05.08.25.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jan 2024 08:25:41 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1rLn0u-001Td8-HY;
	Fri, 05 Jan 2024 12:25:40 -0400
Date: Fri, 5 Jan 2024 12:25:40 -0400
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
Subject: Re: [PATCH v9 13/14] iommu: Improve iopf_queue_remove_device()
Message-ID: <20240105162540.GH50608@ziepe.ca>
References: <20231220012332.168188-1-baolu.lu@linux.intel.com>
 <20231220012332.168188-14-baolu.lu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231220012332.168188-14-baolu.lu@linux.intel.com>

On Wed, Dec 20, 2023 at 09:23:31AM +0800, Lu Baolu wrote:
> -int iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
> +void iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
>  {
> -	int ret = 0;
>  	struct iopf_fault *iopf, *next;
> +	struct iommu_page_response resp;
>  	struct dev_iommu *param = dev->iommu;
>  	struct iommu_fault_param *fault_param;
> +	const struct iommu_ops *ops = dev_iommu_ops(dev);
>  
>  	mutex_lock(&queue->lock);
>  	mutex_lock(&param->lock);
>  	fault_param = rcu_dereference_check(param->fault_param,
>  					    lockdep_is_held(&param->lock));
> -	if (!fault_param) {
> -		ret = -ENODEV;
> -		goto unlock;
> -	}
> -
> -	if (fault_param->queue != queue) {
> -		ret = -EINVAL;
> -		goto unlock;
> -	}
>  
> -	if (!list_empty(&fault_param->faults)) {
> -		ret = -EBUSY;
> +	if (WARN_ON(!fault_param || fault_param->queue != queue))
>  		goto unlock;
> -	}
> -
> -	list_del(&fault_param->queue_list);
>  
> -	/* Just in case some faults are still stuck */
> +	mutex_lock(&fault_param->lock);
>  	list_for_each_entry_safe(iopf, next, &fault_param->partial, list)
>  		kfree(iopf);
>  
> +	list_for_each_entry_safe(iopf, next, &fault_param->faults, list) {
> +		memset(&resp, 0, sizeof(struct iommu_page_response));
> +		resp.pasid = iopf->fault.prm.pasid;
> +		resp.grpid = iopf->fault.prm.grpid;
> +		resp.code = IOMMU_PAGE_RESP_INVALID;

I would probably move the resp and iopf variables into here:

		struct iopf_fault *iopf = &group->last_fault;
		struct iommu_page_response resp = {
			.pasid = iopf->fault.prm.pasid,
			.grpid = iopf->fault.prm.grpid,
			.code = IOMMU_PAGE_RESP_INVALID
		};

(and call the other one partial_iopf)

But this looks fine either way

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

