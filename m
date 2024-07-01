Return-Path: <kvm+bounces-20749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A4F9F91D737
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 06:46:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5BA1A1F23467
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 04:46:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FEDA2C697;
	Mon,  1 Jul 2024 04:46:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE2B18651;
	Mon,  1 Jul 2024 04:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719809191; cv=none; b=EMoLHyvusEavNZqM/ptFExpwrKEOomzBQ/eb5/DHjrRN2Pfz7nqAP8eDqN75B1z6xSMrS443o0yR1pUH2awqoH8OhkVeCD9fS1/LiqgM+CY9ht60d1ru81yshQum/zjxI52X0QlpR//npGkSg4SlDtqjwPul7Mdq8UtduFXHRp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719809191; c=relaxed/simple;
	bh=xpiS+OyTSsUrQAqVnCqramDGG0ZkOfDZyUxJ7mcBmSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fp1xqqh1krIRNJwh5fhPtPgbva1D3Tj2g1FM1AIifRq/GwANkurKQr2gpcfNgfH07HyHctgEJ2MqJtftOxyUa4/DJ0fxl25+dw+ziJWIXuKxWF4p0fs/8ygseueWxWWeOAcC2UJnAH5lVcvhCWFbzi+OAQrSEzi2FCt4MDdBb80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7F29B68BFE; Mon,  1 Jul 2024 06:46:24 +0200 (CEST)
Date: Mon, 1 Jul 2024 06:46:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: dri-devel@lists.freedesktop.org, kvm@vger.kernel.org,
	linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
	Christoph Hellwig <hch@lst.de>, Robin Murphy <robin.murphy@arm.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH v2 0/3] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
Message-ID: <20240701044623.GB26515@lst.de>
References: <20240624065552.1572580-1-vivek.kasireddy@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240624065552.1572580-1-vivek.kasireddy@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Hi Vivek,

even a week later I've only received this cover letter.  Is there an
issue with your mail setup (or mine)?


