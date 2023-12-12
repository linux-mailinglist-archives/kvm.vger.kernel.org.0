Return-Path: <kvm+bounces-4188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D3A8480EFE8
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 16:18:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CD43281BCD
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 15:18:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54D5F75425;
	Tue, 12 Dec 2023 15:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="dbZCWhMd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9515ACA
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 07:18:11 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id af79cd13be357-77f5b3fa323so211172585a.0
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 07:18:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1702394290; x=1702999090; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/fUIa9V7UktxZJFMOjKnGCbu4VLxyvHPNj4gCPjpKbw=;
        b=dbZCWhMdelQt22bjfK5pmXaNXkzjATMkBRQRgAymNXmWujrCV26O56Tbrkho8v/hHm
         +UvT0vg00L/E+5+tiKwCIM68hDT5un4m6E/RDxYtINwSiXqYtGf7jm4vFOd/PUYe+lXX
         5WY8dKgzGaiJ3zy7/7N+IwEMzSPD0pLaa9NatW+JuAjOyG6L3osoQgzA8MDQK06F9yoj
         9lpnBHiSkP08SWNPvuBIkFnYXHb8cTNmF6CTyiKh/+Pnsbeln7tYcgIHgtufxo4up0ev
         rXb8oTu02eO2qS68oEgwitsE5/Txj7Vew/1HaqYVT2sBaSFpJHN+YtVupagf5XL2GAiq
         Dxlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702394290; x=1702999090;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/fUIa9V7UktxZJFMOjKnGCbu4VLxyvHPNj4gCPjpKbw=;
        b=mJJxltLWhOQSWBPHsEbBfoVK9LeRhz72XyAJFGYT985gy3pfFCru74ZGmF5KIDcdgJ
         k+jDP4d21mhN/xybtl34sHIoN+VtXAWJEl9fvICYv4EORR0Tipu37epIENZjFYjhnEN+
         j6i30vt1bEh7Cx2po8EAOPA8quDO+p9GccYKZqVaoGSiU4mIzDZdqcVRPtMtoq5nFZ+V
         z4rK+YHijfT9l4lJTAkHg2Ab7iBYiXPeWWyrmU2NpIqCd+/IbJ1EeFSKuTCgcOyLv6kV
         GtdFuDquYUBAfqkZQkiXWjnN7/N5s/CNCh/MU/gCLGvoUrri7V6Svhyg7L/GEMOLgo1I
         NhPg==
X-Gm-Message-State: AOJu0YxrAUBtOmJ870VmDhIYQYdydopL4YFG8EPPZk5VHcja6+VVqFXY
	W9YAm5rHHT7phQo6Pcawlmne5w==
X-Google-Smtp-Source: AGHT+IEO/Sp55UvFmU80+iPDIwa6VlDwgsHYJtE8bskomQaUuOkqvskk69ktoa1wViJw6YFWts4t4A==
X-Received: by 2002:a0c:d644:0:b0:67a:bc4f:341f with SMTP id e4-20020a0cd644000000b0067abc4f341fmr7016622qvj.83.1702394290678;
        Tue, 12 Dec 2023 07:18:10 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-134-23-187.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.134.23.187])
        by smtp.gmail.com with ESMTPSA id c13-20020a056214004d00b0067a4f49a13csm4048421qvr.127.2023.12.12.07.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Dec 2023 07:18:10 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1rD4WP-00Ck2Y-Mq;
	Tue, 12 Dec 2023 11:18:09 -0400
Date: Tue, 12 Dec 2023 11:18:09 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Longfang Liu <liulongfang@huawei.com>,
	Yan Zhao <yan.y.zhao@intel.com>, iommu@lists.linux.dev,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 12/12] iommu: Use refcount for fault data access
Message-ID: <20231212151809.GD3013885@ziepe.ca>
References: <20231207064308.313316-1-baolu.lu@linux.intel.com>
 <20231207064308.313316-13-baolu.lu@linux.intel.com>
 <20231211152456.GB1489931@ziepe.ca>
 <0f23e37a-5ace-492c-82e9-cf3d13f4ef6f@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f23e37a-5ace-492c-82e9-cf3d13f4ef6f@linux.intel.com>

On Tue, Dec 12, 2023 at 01:07:17PM +0800, Baolu Lu wrote:

> Yes, agreed. The iopf_fault_param should be passed in together with the
> iopf_group. The reference count should be released in the
> iopf_free_group(). These two helps could look like below:
> 
> int iommu_page_response(struct iopf_group *group,
> 			struct iommu_page_response *msg)
> {
> 	bool needs_pasid;
> 	int ret = -EINVAL;
> 	struct iopf_fault *evt;
> 	struct iommu_fault_page_request *prm;
> 	struct device *dev = group->fault_param->dev;
> 	const struct iommu_ops *ops = dev_iommu_ops(dev);
> 	bool has_pasid = msg->flags & IOMMU_PAGE_RESP_PASID_VALID;
> 	struct iommu_fault_param *fault_param = group->fault_param;
>
> 	if (!ops->page_response)
> 		return -ENODEV;

We should never get here if this is the case, prevent the device from
being added in the first place

> 	/* Only send response if there is a fault report pending */
> 	mutex_lock(&fault_param->lock);
> 	if (list_empty(&fault_param->faults)) {
> 		dev_warn_ratelimited(dev, "no pending PRQ, drop response\n");
> 		goto done_unlock;
> 	}
> 	/*
> 	 * Check if we have a matching page request pending to respond,
> 	 * otherwise return -EINVAL
> 	 */
> 	list_for_each_entry(evt, &fault_param->faults, list) {
> 		prm = &evt->fault.prm;
> 		if (prm->grpid != msg->grpid)
> 			continue;
> 
> 		/*
> 		 * If the PASID is required, the corresponding request is
> 		 * matched using the group ID, the PASID valid bit and the PASID
> 		 * value. Otherwise only the group ID matches request and
> 		 * response.
> 		 */
> 		needs_pasid = prm->flags & IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID;
> 		if (needs_pasid && (!has_pasid || msg->pasid != prm->pasid))
> 			continue;
> 
> 		if (!needs_pasid && has_pasid) {
> 			/* No big deal, just clear it. */
> 			msg->flags &= ~IOMMU_PAGE_RESP_PASID_VALID;
> 			msg->pasid = 0;
> 		}
> 
> 		ret = ops->page_response(dev, evt, msg);
> 		list_del(&evt->list);
> 		kfree(evt);
> 		break;
> 	}
> 
> done_unlock:
> 	mutex_unlock(&fault_param->lock);

I would have expected the group to free'd here? But regardless this
looks like a good direction

Jason

