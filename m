Return-Path: <kvm+bounces-29879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B5D89B38CA
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 19:11:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C4734283C3F
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 18:11:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 568A61DF97F;
	Mon, 28 Oct 2024 18:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="ZgpvCfWo"
X-Original-To: kvm@vger.kernel.org
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FEA155A52;
	Mon, 28 Oct 2024 18:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730139099; cv=none; b=Zk1/4jQGQiVFQ+4Wtb1CLgJ+dcDrp+grUrYR4XfiuGGyVbeq9quUK4V+3Y2DqGZ6qIjyUeEyBTOiuFlwwtwOhpxqRjWhqp/gNK4rde5L5BLwIpCAlmmBRhJR9gdT8Uy6EG38ZKvllMGVjKqVLyynFFUfOBTgfdwYxgTvW246jAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730139099; c=relaxed/simple;
	bh=SIxSdBe+RXcsbzx/Ctvx/wGBM6KxLLfq6vguV1usP0o=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=gEcXvCLpnrvNfmqCzTlxiBaxDf/RDoueBap//aNvkVAmK2zFwX4G/aWiaI4FYilhJ/L2+7iCe+yFS0BjslikbIgTH135LfdX7HZYKZewObC7+2c2ssdfNsMTKGW/yf3rJjC5Wc9BNRJWHd1I+J0GlPchVK7n+w51QOKL2eJ6GBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=ZgpvCfWo; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=8p+XeF371FBdizlYdFFfI+9cvX4PxDYJkCjxcGvOnbA=; b=ZgpvCfWocWsIQTbiuMoGgvu81j
	S/fCHcyzInt5f0gPKd+LIK7OJ5mxEaoNwY3if96O+eQaCdejZ8p5V3sgl/v9nalWlDJO5DRXi/kIn
	wvHhSbq4aAwqMIMsOMusADIniYrFBNpOPovhNcwteIj9k4BUkv8XY28rtPNRm9woscrRzWxlXqEZb
	x/tnpblDzlq9tceUkjNsArDEQcZsmuRZZSVXzOBFycNxqU3EB7/U9E1zPZg62v7QNAB9eXmVwn9dD
	fGPW5l7LzLYo6jMaIh+Joy5PZ/qKbf8+LukxoA/IHSVyQYhrFtbPf9diRx5yqeRINUUkSejoMIZIj
	4p2sRADA==;
Received: from d104-157-31-28.abhsia.telus.net ([104.157.31.28] helo=[192.168.1.250])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <logang@deltatee.com>)
	id 1t5UCo-002ZVS-20;
	Mon, 28 Oct 2024 12:11:07 -0600
Message-ID: <31cae8da-74fa-4a45-a88f-ad76572246d4@deltatee.com>
Date: Mon, 28 Oct 2024 12:10:38 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Leon Romanovsky <leon@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Jason Gunthorpe <jgg@ziepe.ca>, Robin Murphy <robin.murphy@arm.com>,
 Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>
Cc: Keith Busch <kbusch@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
 iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
 linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
References: <cover.1730037276.git.leon@kernel.org>
 <a4d93ca45f7ad09105a1cf347e6b6d6b6fb7e303.1730037276.git.leon@kernel.org>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <a4d93ca45f7ad09105a1cf347e6b6d6b6fb7e303.1730037276.git.leon@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 104.157.31.28
X-SA-Exim-Rcpt-To: leon@kernel.org, axboe@kernel.dk, jgg@ziepe.ca, robin.murphy@arm.com, joro@8bytes.org, will@kernel.org, hch@lst.de, sagi@grimberg.me, kbusch@kernel.org, bhelgaas@google.com, yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com, alex.williamson@redhat.com, m.szyprowski@samsung.com, jglisse@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, iommu@lists.linux.dev, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [PATCH 01/18] PCI/P2PDMA: refactor the p2pdma mapping helpers
X-SA-Exim-Version: 4.2.1 (built Wed, 06 Jul 2022 17:57:39 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2024-10-27 08:21, Leon Romanovsky wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> The current scheme with a single helper to determine the P2P status
> and map a scatterlist segment force users to always use the map_sg
> helper to DMA map, which we're trying to get away from because they
> are very cache inefficient.
> 
> Refactor the code so that there is a single helper that checks the P2P
> state for a page, including the result that it is not a P2P page to
> simplify the callers, and a second one to perform the address translation
> for a bus mapped P2P transfer that does not depend on the scatterlist
> structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Looks good to me. Thanks!

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

