Return-Path: <kvm+bounces-29881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4384F9B38E4
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 19:13:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06B93283691
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 18:13:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0232F1E0094;
	Mon, 28 Oct 2024 18:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="K19VSXkL"
X-Original-To: kvm@vger.kernel.org
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B21A1DF97A;
	Mon, 28 Oct 2024 18:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730139171; cv=none; b=VZKbRqFpTCxPqw9s9DRnRvyqb8voqGOYWD/4iv/GForaMkvXpdSK/DbYFTu/rBApk0Is9a64Vmj/sDnPnfzL6PlZRlKbuFIHKc+DHyJUTCPEi1NNb0ZqtrMFdbaMCmD1ZORWyDVMv6XlaoR836nqB/J3a8whX0pB/hNlkmYH5bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730139171; c=relaxed/simple;
	bh=5MaPsfR2hKKODgbANuDJ+3vdVd9wsJj23KxRLquFmkc=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=Ra6FpbEM9XLjA6K3ULHuTl8jODPqEmw9qDKatyh/BfvcTwbUBUT4DWxknevcxtdnxKwLy80jd59WvHDRDSoemrE9plldeCsxVKBTn9nin0odWhtlSnm7wXCQrVfnyvLTN7gjww0TqvAqkDWPWAgjZmWIra2AXCQyc3tKeSNa+m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=K19VSXkL; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=PVgGO8I+aKJHmvYCR04uOsA3HSUhN0BC0EboYMzK8as=; b=K19VSXkL0jbE9wKlLQwlzKl5Qt
	dFI8msaT1mELaj5hwKIwDlCJ46EwcaMmEobLfzfEKq+Eq7nTnteRjLb92tlfPf+mQ1jHZs/uau/Zv
	btPElz6z7lxamWA9dafk7bpsCpOHuPE5ytvXdPKxSvkskCQz9G9p+Cd3hVlToTbBzJvAgoSIlT37A
	r+ZWM2l+KvYFm7d2b43t3ljFpzoofdPK8h6WvgnWHW7sU/zCs1CIEnQebX78Y3u5+eOJI3mrSnt5j
	dSSu52KwvY+eSIGe4RXd3JdoU0j37bdCROcQ7YHpM0slV0+MpM5Xaz7qZFasLUl12Cvd6Oj0uBW7u
	ffpSvEzg==;
Received: from d104-157-31-28.abhsia.telus.net ([104.157.31.28] helo=[192.168.1.250])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <logang@deltatee.com>)
	id 1t5UEF-002ZWw-0E;
	Mon, 28 Oct 2024 12:12:35 -0600
Message-ID: <30e87c78-1021-4fa4-8aa6-e81245e77379@deltatee.com>
Date: Mon, 28 Oct 2024 12:12:34 -0600
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
 <f7ee023a7497ad3d8a7a31b12f492339d155ac39.1730037276.git.leon@kernel.org>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <f7ee023a7497ad3d8a7a31b12f492339d155ac39.1730037276.git.leon@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 104.157.31.28
X-SA-Exim-Rcpt-To: leon@kernel.org, axboe@kernel.dk, jgg@ziepe.ca, robin.murphy@arm.com, joro@8bytes.org, will@kernel.org, hch@lst.de, sagi@grimberg.me, kbusch@kernel.org, bhelgaas@google.com, yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com, alex.williamson@redhat.com, m.szyprowski@samsung.com, jglisse@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, iommu@lists.linux.dev, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [PATCH 09/18] docs: core-api: document the IOVA-based API
X-SA-Exim-Version: 4.2.1 (built Wed, 06 Jul 2022 17:57:39 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)


I noticed a couple of typos below:

On 2024-10-27 08:21, Leon Romanovsky wrote:

> +Part Ie - IOVA-based DMA mappings
> +---------------------------------
> +
> +These APIs allow a very efficient mapping when using an IOMMU.  They are an
> +optional path that requires extra code and are only recommended for drivers
> +where DMA mapping performance, or the space usage for storing the dma addresses

The second 'dma' should be capitalized as it is in other uses.


> +    int dma_iova_sync(struct device *dev, struct dma_iova_state *state,
> +		size_t offset, size_t size, int ret);
> +
> +Must called to sync the IOMMU page tables for IOVA-range mapped by one or
> +more calls to ``dma_iova_link()``.

"Must be called" instead of "Must called"

Thanks,

Logan

