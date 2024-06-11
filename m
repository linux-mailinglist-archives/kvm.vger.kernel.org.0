Return-Path: <kvm+bounces-19290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05801902F0C
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 05:21:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00FEA1C21264
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 03:21:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3304116F90E;
	Tue, 11 Jun 2024 03:21:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3AA2AC29;
	Tue, 11 Jun 2024 03:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718076075; cv=none; b=cBo42DSaaR5KATqsXWvac/QGdk1j0MPqW3oUdSJZMuxQBzwrhAl54kDTntPcuJQxC0LKwDB8x2uJdCArmR8ycpKxROo1OQQLS+3l5t41gTMMuug5s/cXsT+FP1xevpMgMqmRKB5eLX9Jg/ESePh9nibgHyAwdCfxk97h1a4kMQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718076075; c=relaxed/simple;
	bh=leKenAyoLLpT+xv/RNP9pPj8UaNH6JFYkaxtW1lgvhc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ifY0Bc1AbbZB8WgfgsJMtIHMyB/lk2cXJOvOsHm6YiqVWJpbjNI2eNHvoSRKdIqyb0JchOQpSWz3jJkbcb0AppwJ7Tsa7J9Hxkci2rjly/IqaVAkR1hjQv/9HolgOahxvZ+L6hphRrXFVe0wHEo1+b6jjSJ3HjO8bLJymqohZHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sGs3z-007s1M-35;
	Tue, 11 Jun 2024 11:20:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 11 Jun 2024 11:20:50 +0800
Date: Tue, 11 Jun 2024 11:20:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	"Zeng, Xin" <xin.zeng@intel.com>,
	"Tian, Kevin" <kevin.tian@intel.com>, Arnd Bergmann <arnd@arndb.de>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	"Cao, Yahui" <yahui.cao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	qat-linux <qat-linux@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio/qat: add PCI_IOV dependency
Message-ID: <ZmfCkiuiag34_mjO@gondor.apana.org.au>
References: <20240528120501.3382554-1-arnd@kernel.org>
 <BN9PR11MB5276C0C078CF069F2BBE01018CF22@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DM4PR11MB55026977EA998C81870B32E688F22@DM4PR11MB5502.namprd11.prod.outlook.com>
 <BN9PR11MB5276ABB8C332CC8810CB1AD18CF22@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DM4PR11MB5502763ABCC526E7F277363888FC2@DM4PR11MB5502.namprd11.prod.outlook.com>
 <20240607153406.60355e6c.alex.williamson@redhat.com>
 <ZmcbNa4yn+/0NnTD@gcabiddu-mobl.ger.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmcbNa4yn+/0NnTD@gcabiddu-mobl.ger.corp.intel.com>

On Mon, Jun 10, 2024 at 04:26:59PM +0100, Cabiddu, Giovanni wrote:
> On Fri, Jun 07, 2024 at 03:34:06PM -0600, Alex Williamson wrote:
> > Is this then being taken care of in the QAT PF driver?  Are there
> > patches posted targeting v6.10?
> Yes. This is being taken care in the QAT PF driver. Xin just sent a fix
> for it [1].
> @Herbert, can this be sent to stable after the review?

This patch wasn't sent to linux-crypto so I cannot apply it.

In any case, is there any reason why the fix can't go through the
vfio tree?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

