Return-Path: <kvm+bounces-19333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6310F903FE3
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 17:23:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E6BD1F238C9
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 15:23:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 343F12574F;
	Tue, 11 Jun 2024 15:23:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A790C17554;
	Tue, 11 Jun 2024 15:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718119380; cv=none; b=Xy2uRD3E/5sI0NefEg6TuO0BOyUCd+XC0NoITM3efU2q6pG//G2nyMK7Pk+/+kBreXwWrJPcsDlaA3O//8ZFE58s3OF3gSw8gz2+30M9jWPXrrq6wOsov9tInHKmhQ6rKvYiufK6mYpC3Dz5Qbni52e8VtOWaC6Ht/L7RNq/CG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718119380; c=relaxed/simple;
	bh=9LLyWuNrYfqCUKsTv/Dm0H4/VmFA9sGfvD5+4jCeRf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GID/F7lOMNcDhr2jsKEa8wrTqjpYAQtEG5+MyaxLNsORzfZNKQSVvdK3Y13ikV1mO8zVAdZQWmQmjQPQaADcNk8L81GCuFIvPQ3zWoGi25ccWEWgCbnOSJUJL4QgwtmHoyKxFTPOuiXKP42gi7ukZMqX2lW5HYeQe3JYjjZ6w2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sH3KV-0087oP-1M;
	Tue, 11 Jun 2024 23:22:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 11 Jun 2024 23:22:38 +0800
Date: Tue, 11 Jun 2024 23:22:38 +0800
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
Message-ID: <Zmhrvsp766WsSfxn@gondor.apana.org.au>
References: <20240528120501.3382554-1-arnd@kernel.org>
 <BN9PR11MB5276C0C078CF069F2BBE01018CF22@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DM4PR11MB55026977EA998C81870B32E688F22@DM4PR11MB5502.namprd11.prod.outlook.com>
 <BN9PR11MB5276ABB8C332CC8810CB1AD18CF22@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DM4PR11MB5502763ABCC526E7F277363888FC2@DM4PR11MB5502.namprd11.prod.outlook.com>
 <20240607153406.60355e6c.alex.williamson@redhat.com>
 <ZmcbNa4yn+/0NnTD@gcabiddu-mobl.ger.corp.intel.com>
 <ZmfCkiuiag34_mjO@gondor.apana.org.au>
 <Zmg0muHFdWEp+M1x@gcabiddu-mobl.ger.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zmg0muHFdWEp+M1x@gcabiddu-mobl.ger.corp.intel.com>

On Tue, Jun 11, 2024 at 12:27:22PM +0100, Cabiddu, Giovanni wrote:
>
> > In any case, is there any reason why the fix can't go through the
> > vfio tree?
> It is a change in the QAT driver. That's why I asked.

Sorry, I got confused by the subject line.  I'll get onto this
patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

