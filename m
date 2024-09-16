Return-Path: <kvm+bounces-26961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EAA81979BF3
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 09:20:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 290661C228F5
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 07:20:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20C75139578;
	Mon, 16 Sep 2024 07:20:38 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C6720B22;
	Mon, 16 Sep 2024 07:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726471237; cv=none; b=gcsEEa9eO8PHw3UJYmptHZvlOwlosNQQcaqdSqpJ8RyKWstwPWaoKNj1LPBl+beEU9dNMk6gdnkCHVitZJkvR/Y2RLFM3WiD83pqWng02KQaysbp7QO3rNgcTH2ioYoTbPIuAuWxYf359Q4SiVs683nZ+mhyw7JFsb7Z9LxjjPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726471237; c=relaxed/simple;
	bh=82vHmi8ozG4X8T4z16a0738yGdikAB7EbfGQTDd99dE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lyiRYxTKFKbW2b2RXo3Z09mu7lEjo6ZUgB0NMLprCspuM+v8mrWU+y1zhWC+OL89jkcjCN2cNzPMsUSXSMVzaP5nUoXJEX/gI5IWNCIYXvOvXoJbdBAepkQGfn32cWU5SXd97A4OulsBCbDfbKZQjtV19EVTQI5qiwo71sAm0F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EB8E0227AAD; Mon, 16 Sep 2024 09:20:30 +0200 (CEST)
Date: Mon, 16 Sep 2024 09:20:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jon Kohler <jon@nutanix.com>
Cc: Christoph Hellwig <hch@lst.de>, Kirti Wankhede <kwankhede@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Tony Krowiak <akrowiak@linux.ibm.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>, Rohit Shenoy <rshenoy@nvidia.com>,
	Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH] vfio-mdev: reinstate VFIO_MDEV Kconfig
Message-ID: <20240916072030.GC16514@lst.de>
References: <20240912141956.237734-1-jon@nutanix.com> <20240912140509.GA893@lst.de> <8A26B654-51D0-4007-919C-F1934BD0DFEE@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8A26B654-51D0-4007-919C-F1934BD0DFEE@nutanix.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Sep 12, 2024 at 03:32:52PM +0000, Jon Kohler wrote:
> Christoph - thanks for the swift reply, I appreciate it. To clarify slightly,
> MDEV does have various exported symbols in MDEV, with both regular
> EXPORT_SYMBOL and _GPL variant; however, there is just no way to 
> consume them out of tree without this patch, unless there is also
> incidentally another in-tree module that has select VFIO_MDEV set.

The point of kernel infrastructure is not to consume it out of tree.
Get your driver upstream and fully participate instead wasting your
time on this kind of stuff please.

