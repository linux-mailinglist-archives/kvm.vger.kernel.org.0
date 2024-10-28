Return-Path: <kvm+bounces-29886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3247B9B391F
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 19:28:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB6AC2812D5
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 18:28:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A75F51DF983;
	Mon, 28 Oct 2024 18:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="WMjqOgKe"
X-Original-To: kvm@vger.kernel.org
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF3F1DF266;
	Mon, 28 Oct 2024 18:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730140092; cv=none; b=pW6dssa28rzocVKYJMtPEFLytAYmmchKPdzaDDcP1cOo+td2rvpY86CPmcCgf5Z5iyZdQK6JVuE/lPydKhgSlazu5iVoNJoJFvxB4SreznZcGJ6XILji2Ry8u7QhKtV2KPxfHWXbRTxp9qHTQ5uOBVvH6ms4POXVBY4E86/tNIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730140092; c=relaxed/simple;
	bh=jysc9seah1CkGTogQocmaGVdqs178PC3SgenoTMtVGU=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=YIZH5js2bZpjzPlV2WDCLlUBbZ54xciUVZXz7tbkF9DoWhuqu2uYf9kfrHOX4aLVLAT4bcMLIWEFMuDKxrZBM3e7/UBIQ6LxRNVFU95l0ZhMICiq4GZy083F0qSRl82+xOAe/sScdR68GOwW3DURXbtV8pBCpllYIZYIvNwDukY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=WMjqOgKe; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=xfwaAlX8xBNBzzQd8cWtPopo9omhZXUl1zo673gmZPU=; b=WMjqOgKeRu8KLmj0e+FfaKQ5nw
	SgLTeMPtlxn7YvNSwEXm9WRVO6V3OfUYWzBkFxex8g5DhluJnjtGZAOP88y+oEYbhTswl001wqbjC
	VAMp0KBM1cV3pxfWiT9t7GEpH6PP3iHvzxFOSltTDDGP1nFT4qfRwTkyuhh+Ij31rgOzU9qZSzueN
	FXFsu3EvxwXrCsD6Ddkf3+5bHEPJculCmwf5FKruYO+4w5MEugAU88AXgFQlK1emwFsWfp6VAnMOR
	XgGvOU7wsYcyzcO9LPQQNiLmuWtrD8A0tY2Ryo4R36g1lHw3F9kJrwi9exvBKqXcTantt6HmE9C2I
	NC3mHOlg==;
Received: from d104-157-31-28.abhsia.telus.net ([104.157.31.28] helo=[192.168.1.250])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <logang@deltatee.com>)
	id 1t5UT4-002Zeg-0P;
	Mon, 28 Oct 2024 12:27:54 -0600
Message-ID: <9db04bd9-81e1-4e60-a590-0882cd86052f@deltatee.com>
Date: Mon, 28 Oct 2024 12:27:51 -0600
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
References: <cover.1730037261.git.leon@kernel.org>
 <34d44537a65aba6ede215a8ad882aeee028b423a.1730037261.git.leon@kernel.org>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <34d44537a65aba6ede215a8ad882aeee028b423a.1730037261.git.leon@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 104.157.31.28
X-SA-Exim-Rcpt-To: leon@kernel.org, axboe@kernel.dk, jgg@ziepe.ca, robin.murphy@arm.com, joro@8bytes.org, will@kernel.org, hch@lst.de, sagi@grimberg.me, kbusch@kernel.org, bhelgaas@google.com, yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com, alex.williamson@redhat.com, m.szyprowski@samsung.com, jglisse@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, iommu@lists.linux.dev, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [RFC PATCH 2/7] block: don't merge different kinds of P2P
 transfers in a single bio
X-SA-Exim-Version: 4.2.1 (built Wed, 06 Jul 2022 17:57:39 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2024-10-27 08:21, Leon Romanovsky wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> To get out of the dma mapping helpers having to check every segment for
> it's P2P status, ensure that bios either contain P2P transfers or non-P2P
> transfers, and that a P2P bio only contains ranges from a single device.
> 
> This means we do the page zone access in the bio add path where it should
> be still page hot, and will only have do the fairly expensive P2P topology
> lookup once per bio down in the dma mapping path, and only for already
> marked bios.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Looks good to me.

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>


