Return-Path: <kvm+bounces-20893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 84F859259E9
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 12:52:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2F8101F222D1
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 10:52:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93F9717DA3A;
	Wed,  3 Jul 2024 10:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UGo3+dYa"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC57D17D8BB
	for <kvm@vger.kernel.org>; Wed,  3 Jul 2024 10:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003379; cv=none; b=K3GfNR9JV+DDYGsnuzu5za6u+HZyWQHXVyqBr7XNqhPjtNmlpM8jQotNAy/KZNFOsQJ4V2VzsxEYf8Dt/ui0b8YuQwSsa6ClEmGyRK4nvi3suDg1WkBV/nTNc1TOoW6/zOSk6IHcnWF2hG5aPtl5qp7nBvGzAsmuqlTISFT/Gck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003379; c=relaxed/simple;
	bh=5x7iVFmmOCeg7gmKXakTIO88Klmb/Ljrt+SWcudmyj8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ya0a095iXeRKEjyjAMUu+IjJQdnqzfxqh0x7hhM7OnMHo2TMVn+0q9sYT8SWAVtEfKyrRmz+HK6EzRlIuJhh575q9Bl4jUf7Oi4txbB9Z1Hw04IIfb0y+eOfmD+J/DLHCQaAaZbHtRWgHgSbQBDH1qCnqe2r78wlrfB8p2yDc3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UGo3+dYa; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: hch@lst.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1720003375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VQ0x5M8745iJdoh6tHN0tzYonslhz7xwJWvLxeue+x0=;
	b=UGo3+dYatV3+LHOqZstdITsJeOnkGNrjjKudxHxps7f66nrP6L2jPec8eQh+kgocd01E++
	5ZH9rxoshew0yf6Kc3Deyv+ijw/nOCWKOnj/sPJHL/iD1p19uxG1dh3GI+QQiruFD8TsYh
	lVwQS8zKiifLTR0s/1tHh0utloLHppM=
X-Envelope-To: leon@kernel.org
X-Envelope-To: axboe@kernel.dk
X-Envelope-To: jgg@ziepe.ca
X-Envelope-To: robin.murphy@arm.com
X-Envelope-To: joro@8bytes.org
X-Envelope-To: will@kernel.org
X-Envelope-To: kbusch@kernel.org
X-Envelope-To: oak.zeng@intel.com
X-Envelope-To: kch@nvidia.com
X-Envelope-To: sagi@grimberg.me
X-Envelope-To: bhelgaas@google.com
X-Envelope-To: logang@deltatee.com
X-Envelope-To: yishaih@nvidia.com
X-Envelope-To: shameerali.kolothum.thodi@huawei.com
X-Envelope-To: kevin.tian@intel.com
X-Envelope-To: alex.williamson@redhat.com
X-Envelope-To: m.szyprowski@samsung.com
X-Envelope-To: jglisse@redhat.com
X-Envelope-To: akpm@linux-foundation.org
X-Envelope-To: linux-block@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: linux-rdma@vger.kernel.org
X-Envelope-To: iommu@lists.linux.dev
X-Envelope-To: linux-nvme@lists.infradead.org
X-Envelope-To: linux-pci@vger.kernel.org
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: linux-mm@kvack.org
Message-ID: <f781c3ea-8097-4e5f-84b2-0cd1f49bdb96@linux.dev>
Date: Wed, 3 Jul 2024 18:42:42 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [RFC PATCH v1 00/18] Provide a new two step DMA API mapping API
To: Christoph Hellwig <hch@lst.de>, Leon Romanovsky <leon@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
 Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Keith Busch <kbusch@kernel.org>,
 "Zeng, Oak" <oak.zeng@intel.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 Sagi Grimberg <sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>,
 Logan Gunthorpe <logang@deltatee.com>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
 linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
References: <cover.1719909395.git.leon@kernel.org>
 <20240703054238.GA25366@lst.de>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20240703054238.GA25366@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

在 2024/7/3 13:42, Christoph Hellwig 写道:
> I just tried to boot this on my usual qemu test setup with emulated
> nvme devices, and it dead-loops with messages like this fairly late
> in the boot cycle:
> 
> [   43.826627] iommu: unaligned: iova 0xfff7e000 pa 0x000000010be33650 size 0x1000 min_pagesz 0x1000
> [   43.826982] dma_mapping_error -12
> 
> passing intel_iommu=off instead of intel_iommu=on (expectedly) makes

I also confronted this problem.IMO, if intel_iommu=off, the driver of 
drivers/iommu can not be used.

If I remember correctly, some guys in the first version can fix this 
problem. I will check the mails.

To me, I just revert this commit because I do not use this commit about 
nvme.

Zhu Yanjun

> it go away.
> 


