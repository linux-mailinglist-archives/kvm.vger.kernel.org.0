Return-Path: <kvm+bounces-53472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D32DB124A9
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 21:13:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 80D484E1C64
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 19:12:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9916B25A2DA;
	Fri, 25 Jul 2025 19:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="DrqrpaR7"
X-Original-To: kvm@vger.kernel.org
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498DE237164;
	Fri, 25 Jul 2025 19:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753470769; cv=none; b=RFQwQRJr+vC+uf2OfteMg337ragNwFdS5LC+BsPsRnBtuOv+Br8Ol7/FSWLU16KQymXBTT0NM/Mw9TafDsQMInx4aJsvRrD2tYeWOIScTVtkIc2Racz3IVuruZrWdnOKbN7oLO7PQmtwDs5t5pQ+SMBvNIsKXPpK+ddhiS5i8oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753470769; c=relaxed/simple;
	bh=yEGS1ssuNCOYiWmsNeefkXYNsZTqbAuSG41TI3nN59I=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=D1OSirQQRkYo+OxUoOZNgdO+5G1PnroQE6lZGtSwHrrclOcgAkrjvQkVqQXbD11WqwURr6nGI8+e1PmwQeXlXb8JuGN639Sw3vYa+HHwk8ZpHhxOoNtD+Yfoen9ttOceDDSoVLveMWh7KT12X9AIsfAmg9gKt23gHCdSN4B/N0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=DrqrpaR7; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=EeOo9vMPBFT+62n5mqYkCAxWsQk1Wvt4dBFyCgwjFrk=; b=DrqrpaR7S9OrXgfKiTlAraouUx
	i4ghrIDe0rHZjeUNlfEzZoAUiPbvMyzYgY3NP/FMkua4fsEG4BUEfWmG08NaN3AJaxLLtN7IEqbhj
	4WALY5AeeenGjVOoB5wbIg0n3jzsD5dSSYuovvsWyo6RrCK5quFSZw02fh++FfvIYO/9zgKYx9SHc
	ffj80QXJEfFoR9tRFdpABXThOf1TAKdNiRKAY7HTLi6iU5GP9OmSa0ys2SxJ5ifdpvS0AuGd7so8G
	WtqXMuLWHNwwZap6WIJ6fbeihB/YIucDtjbo21c+DH8bj/20oQ4+GwAjSz3Bt9RGNE02AWYwVosV8
	6WQn0Kww==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <logang@deltatee.com>)
	id 1ufNqT-006E5j-0X;
	Fri, 25 Jul 2025 13:12:42 -0600
Message-ID: <a749c502-7794-42f0-8f86-163efd4640b2@deltatee.com>
Date: Fri, 25 Jul 2025 13:12:35 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Leon Romanovsky <leon@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
 Alex Williamson <alex.williamson@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Bjorn Helgaas <bhelgaas@google.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
 Jens Axboe <axboe@kernel.dk>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?=
 <jglisse@redhat.com>, Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, Will Deacon <will@kernel.org>
References: <cover.1753274085.git.leonro@nvidia.com>
 <82e62eb59afcd39b68ae143573d5ed113a92344e.1753274085.git.leonro@nvidia.com>
 <20250724080313.GA31887@lst.de> <20250724081321.GT402218@unreal>
 <b32ae619-6c4a-46fc-a368-6ad4e245d581@deltatee.com>
 <20250725185402.GU402218@unreal>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20250725185402.GU402218@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: leon@kernel.org, hch@lst.de, alex.williamson@redhat.com, jgg@nvidia.com, akpm@linux-foundation.org, bhelgaas@google.com, christian.koenig@amd.com, dri-devel@lists.freedesktop.org, iommu@lists.linux.dev, axboe@kernel.dk, jglisse@redhat.com, joro@8bytes.org, kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, m.szyprowski@samsung.com, robin.murphy@arm.com, sumit.semwal@linaro.org, vivek.kasireddy@intel.com, will@kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [PATCH 05/10] PCI/P2PDMA: Export pci_p2pdma_map_type() function
X-SA-Exim-Version: 4.2.1 (built Wed, 06 Jul 2022 17:57:39 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2025-07-25 12:54, Leon Romanovsky wrote:
>> The solution that would make more sense to me would be for either
>> dma_iova_try_alloc() or another helper in dma-iommu.c to handle the
>> P2PDMA case. dma-iommu.c already uses those same interfaces and thus
>> there would be no need to export the low level helpers from the p2pdma code.
> 
> I had same idea in early versions of DMA phys API discussion and it was
> pointed (absolutely right) that this is layering violation.

Respectfully, I have to disagree with this. Having the layer (ie.
dma-iommu) that normally checks how to handle a P2PDMA request now check
 how to handle these DMA requests is the exact opposite of a layering
violation. Expecting every driver that wants to do P2PDMA to have to
figure out for themselves how to map the memory before calling into the
DMA API doesn't seem like a good design choice to me.

> So unfortunately, I think that dma*.c|h is not right place for p2p
> type check.

dma*.c is already where those checks are done. I'm not sure patches to
remove the code from that layer and put it into the NVMe driver would
make a lot of sense (and then, of course, we'd have to put it into every
other driver that wants to participate in p2p transactions).

Logan


