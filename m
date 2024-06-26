Return-Path: <kvm+bounces-20546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EBDB91805E
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 13:59:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B71C284985
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 11:59:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FC30180A7B;
	Wed, 26 Jun 2024 11:59:38 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE9017F51D;
	Wed, 26 Jun 2024 11:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719403178; cv=none; b=Ng8mmd3uF8TDP12So4U5hUimulztemAzQBvMTWeiM5MXZipn8/QyLiMPiqtbdZQxOn3gT636r2cr0q2GZwS5TPc4bN7iT3fGc/gvqr7vhLWhM3o4CmI9EuYulXmShvLhdtF90m4FhBzpDfSjfBQth1JcH8bVawBglNgHqtFshkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719403178; c=relaxed/simple;
	bh=tPM+jCFdESn3+sp7MZRc6Bc2XZRHKgShQQM/k/U3kfg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rdi1N04dQrbfWx1eZQub/r3bktwvXPd7DMWI197C7yiyNxLvaM/Nn1E/2iyZB8HdBE4MGDVdGoX7dZL/WlvxVSQlsAhiQgMVBvpk6QSw2SkuZJ+cRyvG6RP/V8eKtm4EianKRA1xuXAVlSiJhQDPTQgTNH8i8jv3+MSa2k52rl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 04EB4227A87; Wed, 26 Jun 2024 13:59:31 +0200 (CEST)
Date: Wed, 26 Jun 2024 13:59:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 0/4] vfio/pci: s390: Fix issues preventing
 VFIO_PCI_MMAP=y for s390 and enable it
Message-ID: <20240626115930.GA14790@lst.de>
References: <20240626-vfio_pci_mmap-v4-0-7f038870f022@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240626-vfio_pci_mmap-v4-0-7f038870f022@linux.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Thanks Niklas,

I like the quirk version much better than the magic check for the
ioremap range.


