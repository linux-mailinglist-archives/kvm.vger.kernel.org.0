Return-Path: <kvm+bounces-40884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 76436A5EBCF
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 07:37:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B9899179795
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 06:37:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18B791D88D0;
	Thu, 13 Mar 2025 06:37:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59888EC4
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 06:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741847855; cv=none; b=f6LzDAgFWPIxebadVewBd3YFxEKljFQQjG02stv/6dKT0/OaZiMa8QjaWpTa/Q85qYesTR3KWV9Beoi6mG03csAHQGT1KROhVkdPBFRwZxQqrQY7ami0hdCL+g5L6b094nm1DHN+2FHbmac5dkK7ztMrO3HwWsMIxp5x+y17d7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741847855; c=relaxed/simple;
	bh=z+M7T5+oesBRFEivtacNct45Um0/S+YIRwesyjMdhZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lzYvRloUGWjTHzm5UdZ0qP5JaBLXBOHRIui4y/5xQLQS5vsJr6+fjElOUcNnGYsj0YaNde8JtuhrROGWYRIyCOalazmVR/C7vnwrwZ7AgFltKTnuXSovmMSxBEMIxUVK5UBIvZoTnP/ftJspuoifrd7JZcnSlDVLUeWAyFPU6D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9503D68C4E; Thu, 13 Mar 2025 07:37:30 +0100 (CET)
Date: Thu, 13 Mar 2025 07:37:30 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mike Christie <michael.christie@oracle.com>
Cc: chaitanyak@nvidia.com, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
	joao.m.martins@oracle.com, linux-nvme@lists.infradead.org,
	kvm@vger.kernel.org, kwankhede@nvidia.com,
	alex.williamson@redhat.com, mlevitsk@redhat.com
Subject: Re: [PATCH RFC 03/11] nvmet: Add nvmet_fabrics_ops flag to
 indicate SGLs not supported
Message-ID: <20250313063730.GC9967@lst.de>
References: <20250313052222.178524-1-michael.christie@oracle.com> <20250313052222.178524-4-michael.christie@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250313052222.178524-4-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 13, 2025 at 12:18:04AM -0500, Mike Christie wrote:
> The nvmet_mdev_pci driver does not initially support SGLs. In some
> prelim testing I don't think there will be a perf gain (the virt related
> interface may be the major bottleneck so I may not notice) so I wasn't
> sure if they will be required/needed. This adds a nvmet_fabrics_ops flag
> so we can tell nvmet core to tell the host we do not supports SGLS.

I'd prefer to be able to support SGLs if we can, but if not I could
live with a flag of some sort.


