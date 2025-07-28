Return-Path: <kvm+bounces-53563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95FC0B13FA7
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 18:14:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 44DFC7A49C3
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 16:11:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E17402741B6;
	Mon, 28 Jul 2025 16:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="NuShxQGB"
X-Original-To: kvm@vger.kernel.org
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DBB1DE4EF;
	Mon, 28 Jul 2025 16:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753719179; cv=none; b=L6P2wcly+3L7QOB2JRl562OHItRyvq5IYLE53a85uq301egSx3hU4WJsCP3zXZp0yET9iVYdANJl6JNWw51YBXmIaiSM09ElCUK92ci7BvMBUz+mk0ENLb2jXLU90X/yQB5AwNNno60T4806K0yNYmVB6RFePo0Ph70Hxt6BsaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753719179; c=relaxed/simple;
	bh=R0FQOHpsHRyxpvqcJA2ITt/gHmHam74Pd/G3iRxqIRA=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=G2TJaFP6nzCix3Jbl/SgulMa11AMhmll7uo1ZxTUH07+TGNppNub0ZxUqjaYV9T9FiRQU7J6d3zWPo1Yk1joul8OlvpEqJa4ZxKyaN3nZ77kxL+RReUW6eIy7s0K1DLyvoxnQfMSY4Wjf96KGsJf9VggumpdcN1bgk3XIxng2yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=NuShxQGB; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=VSF5wX9vjIP6fRF1ybWxqYJSZXcEgqAR8cCPBeo7HdU=; b=NuShxQGBV5IaVLB+r9+8Z5iKvq
	dFIGr5esAaj+hCO3a4jw+w6/OlzvIoB6kvaxTwpkrr6lmTchzYodZvaI+lNSnKbAzMm0EglMM03Vv
	crZTKZAcuqrSFjxZewSYCzRT/HYo/mkFbMKO7es26V5QoeFZvRVj7QgbRx/G4WDAZX6VXrq9/YsDD
	xRRo8ObEJbFOXuNbyFVv5S0ZE/n4R76NpOr3WVRG9mlUx6T3DEJBkwhVcxvUHoaulcQa3MefNqBEW
	9lVNjow5xoGlNwMQVVuWUtFAwKyMGUtxejZnJC6r2JA2ZkfHlVUptsg1l/w1rFXLBfEBhBC4DZjlx
	SCCTlj+w==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <logang@deltatee.com>)
	id 1ugQSy-008Nxz-1h;
	Mon, 28 Jul 2025 10:12:45 -0600
Message-ID: <d69e0d74-285e-4cde-a2e4-a803accfa9e1@deltatee.com>
Date: Mon, 28 Jul 2025 10:12:31 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Alex Williamson <alex.williamson@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
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
 <20250727190514.GG7551@nvidia.com>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20250727190514.GG7551@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: jgg@nvidia.com, leon@kernel.org, hch@lst.de, alex.williamson@redhat.com, akpm@linux-foundation.org, bhelgaas@google.com, christian.koenig@amd.com, dri-devel@lists.freedesktop.org, iommu@lists.linux.dev, axboe@kernel.dk, jglisse@redhat.com, joro@8bytes.org, kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, m.szyprowski@samsung.com, robin.murphy@arm.com, sumit.semwal@linaro.org, vivek.kasireddy@intel.com, will@kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [PATCH 05/10] PCI/P2PDMA: Export pci_p2pdma_map_type() function
X-SA-Exim-Version: 4.2.1 (built Wed, 06 Jul 2022 17:57:39 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2025-07-27 13:05, Jason Gunthorpe wrote:
> On Fri, Jul 25, 2025 at 10:30:46AM -0600, Logan Gunthorpe wrote:
>>
>>
>> On 2025-07-24 02:13, Leon Romanovsky wrote:
>>> On Thu, Jul 24, 2025 at 10:03:13AM +0200, Christoph Hellwig wrote:
>>>> On Wed, Jul 23, 2025 at 04:00:06PM +0300, Leon Romanovsky wrote:
>>>>> From: Leon Romanovsky <leonro@nvidia.com>
>>>>>
>>>>> Export the pci_p2pdma_map_type() function to allow external modules
>>>>> and subsystems to determine the appropriate mapping type for P2PDMA
>>>>> transfers between a provider and target device.
>>>>
>>>> External modules have no business doing this.
>>>
>>> VFIO PCI code is built as module. There is no way to access PCI p2p code
>>> without exporting functions in it.
>>
>> The solution that would make more sense to me would be for either
>> dma_iova_try_alloc() or another helper in dma-iommu.c to handle the
>> P2PDMA case.
> 
> This has nothing to do with dma-iommu.c, the decisions here still need
> to be made even if dma-iommu.c is not compiled in.

Doesn't it though? Every single call in patch 10 to the newly exported
PCI functions calls into the the dma-iommu functions. If there were
non-iommu paths then I would expect the code would use the regular DMA
api directly which would then call in to dma-iommu.

I can't imagine a use case where someone would want to call the p2pdma
functions to map p2p memory and not have a similar path to do the exact
same mapping with vanilla memory and thus call the DMA API. And it seems
much better to me to export higher level functions to drivers that take
care of the details correctly than to expose the nuts and bolts to every
driver.

The thing that seems special to me about VFIO is that it is calling
directly into dma-iommu code to setup unique mappings as opposed to
using the higher level DMA API. I don't see in what way it is special
that it needs to know intimate details of the memory it's mapping and
have different paths to map different types of memory. That's what the
dma layer is for.

Logan


