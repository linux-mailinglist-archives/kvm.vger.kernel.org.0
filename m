Return-Path: <kvm+bounces-7983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D9E8849776
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 11:14:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E658EB2A1B6
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 10:08:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98C1E168DD;
	Mon,  5 Feb 2024 10:07:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37CB168D9;
	Mon,  5 Feb 2024 10:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707127679; cv=none; b=aI/jCq6PKunj/bSeJq7XxqoDLtJPwDo8ry4i+00hayWrW+W5b1F0NhuldU7AE/dK0GRhtk0bNgeNu/9q0ZlPUZcd123cNCjLRGxaD0P8zl1XOcBPZBJ4P9c/xzGSXil8PVjxY/n2BEGGXzTnOIHWTcQPY1mNuG8UeNUttkxhlT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707127679; c=relaxed/simple;
	bh=iBaUmXBlN0VxxLhGqD9SvUefjOy+3CbgHgnuPzCue3A=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FxqXdmmtIAicsRKyp9mODHykKfiu6kIQfQow/pK6ddGWPfp2kPpZHzueGHtzDS0lPMILClToBaDDJOEvV0heuhZqZlP+JXY5jwfMxyYXEfxs4hK6QU/gWCWqLAW1Zdw/KsQDtYy8GXSFsZV3QCrRmPxwDkbxrtDHgySs3pwNJqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4TT26g0TNXz6GBd5;
	Mon,  5 Feb 2024 18:04:43 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id BFC8314185F;
	Mon,  5 Feb 2024 18:07:54 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 5 Feb
 2024 10:07:54 +0000
Date: Mon, 5 Feb 2024 10:07:53 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Lukas Wunner <lukas@wunner.de>
CC: Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>, "Bjorn
 Helgaas" <helgaas@kernel.org>, David Howells <dhowells@redhat.com>, "David
 Woodhouse" <dwmw2@infradead.org>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, Alex Williamson
	<alex.williamson@redhat.com>, <linux-pci@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<keyrings@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>, <linuxarm@huawei.com>, David Box
	<david.e.box@intel.com>, Dan Williams <dan.j.williams@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, "Li, Ming" <ming4.li@intel.com>, Zhi Wang
	<zhi.a.wang@intel.com>, Alistair Francis <alistair.francis@wdc.com>, Wilfred
 Mallawa <wilfred.mallawa@wdc.com>, Alexey Kardashevskiy <aik@amd.com>, Tom
 Lendacky <thomas.lendacky@amd.com>, "Sean Christopherson"
	<seanjc@google.com>, Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH 07/12] spdm: Introduce library to authenticate devices
Message-ID: <20240205100753.0000798b@Huawei.com>
In-Reply-To: <20240204172510.GA19805@wunner.de>
References: <cover.1695921656.git.lukas@wunner.de>
	<89a83f42ae3c411f46efd968007e9b2afd839e74.1695921657.git.lukas@wunner.de>
	<20231003153937.000034ca@Huawei.com>
	<20240204172510.GA19805@wunner.de>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500006.china.huawei.com (7.191.161.198) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

On Sun, 4 Feb 2024 18:25:10 +0100
Lukas Wunner <lukas@wunner.de> wrote:

> On Tue, Oct 03, 2023 at 03:39:37PM +0100, Jonathan Cameron wrote:
> > On Thu, 28 Sep 2023 19:32:37 +0200 Lukas Wunner <lukas@wunner.de> wrote:  
> > > +/**
> > > + * spdm_challenge_rsp_sz() - Calculate CHALLENGE_AUTH response size
> > > + *
> > > + * @spdm_state: SPDM session state
> > > + * @rsp: CHALLENGE_AUTH response (optional)
> > > + *
> > > + * A CHALLENGE_AUTH response contains multiple variable-length fields
> > > + * as well as optional fields.  This helper eases calculating its size.
> > > + *
> > > + * If @rsp is %NULL, assume the maximum OpaqueDataLength of 1024 bytes
> > > + * (SPDM 1.0.0 table 21).  Otherwise read OpaqueDataLength from @rsp.
> > > + * OpaqueDataLength can only be > 0 for SPDM 1.0 and 1.1, as they lack
> > > + * the OtherParamsSupport field in the NEGOTIATE_ALGORITHMS request.
> > > + * For SPDM 1.2+, we do not offer any Opaque Data Formats in that field,
> > > + * which forces OpaqueDataLength to 0 (SPDM 1.2.0 margin no 261).
> > > + */
> > > +static size_t spdm_challenge_rsp_sz(struct spdm_state *spdm_state,
> > > +				    struct spdm_challenge_rsp *rsp)
> > > +{
> > > +	size_t  size  = sizeof(*rsp)		/* Header */  
> > 
> > Double spaces look a bit strange...
> >   
> > > +		      + spdm_state->h		/* CertChainHash */
> > > +		      + 32;			/* Nonce */
> > > +
> > > +	if (rsp)
> > > +		/* May be unaligned if hash algorithm has unusual length. */
> > > +		size += get_unaligned_le16((u8 *)rsp + size);
> > > +	else
> > > +		size += SPDM_MAX_OPAQUE_DATA;	/* OpaqueData */
> > > +
> > > +	size += 2;				/* OpaqueDataLength */
> > > +
> > > +	if (spdm_state->version >= 0x13)
> > > +		size += 8;			/* RequesterContext */
> > > +
> > > +	return  size  + spdm_state->s;		/* Signature */  
> > 
> > Double space here as well looks odd to me.  
> 
> This was criticized by Ilpo as well, but the double spaces are
> intentional to vertically align "size" on each line for neatness.
> 
> How strongly do you guys feel about it? ;)

I suspect we'll see 'fixes' for this creating noise for maintainers.
So whilst I don't feel that strongly about it I'm not sure the alignment
really helps much with readability either.
 
> 
> 
> > > +int spdm_authenticate(struct spdm_state *spdm_state)
> > > +{
> > > +	size_t transcript_sz;
> > > +	void *transcript;
> > > +	int rc = -ENOMEM;
> > > +	u8 slot;
> > > +
> > > +	mutex_lock(&spdm_state->lock);
> > > +	spdm_reset(spdm_state);  
> [...]
> > > +	rc = spdm_challenge(spdm_state, slot);
> > > +
> > > +unlock:
> > > +	if (rc)
> > > +		spdm_reset(spdm_state);  
> > 
> > I'd expect reset to also clear authenticated. Seems odd to do it separately
> > and relies on reset only being called here. If that were the case and you
> > were handling locking and freeing using cleanup.h magic, then
> > 
> > 	rc = spdm_challenge(spdm_state);
> > 	if (rc)
> > 		goto reset;
> > 	return 0;
> > 
> > reset:
> > 	spdm_reset(spdm_state);  
> 
> Unfortunately clearing "authenticated" in spdm_reset() is not an
> option:
> 
> Note that spdm_reset() is also called at the top of spdm_authenticate().
> 
> If the device was previously successfully authenticated and is now
> re-authenticated successfully, clearing "authenticated" in spdm_reset()
> would cause the flag to be briefly set to false, which may irritate
> user space inspecting the sysfs attribute at just the wrong moment.

That makes sense. Thanks.

> 
> If the device was previously successfully authenticated and is
> re-authenticated successfully, I want the "authenticated" attribute
> to show "true" without any gaps.  Hence it's only cleared at the end
> of spdm_authenticate() if there was an error.
> 
> I agree with all your other review feedback and have amended the
> patch accordingly.  Thanks a lot!
> 
> Lukas
> 


