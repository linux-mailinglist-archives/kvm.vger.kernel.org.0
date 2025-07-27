Return-Path: <kvm+bounces-53511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 66672B12F89
	for <lists+kvm@lfdr.de>; Sun, 27 Jul 2025 14:45:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 901441895483
	for <lists+kvm@lfdr.de>; Sun, 27 Jul 2025 12:45:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19DF821771A;
	Sun, 27 Jul 2025 12:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="auSmkDmj"
X-Original-To: kvm@vger.kernel.org
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21C826ADD;
	Sun, 27 Jul 2025 12:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753620326; cv=none; b=OXpY5NBA3CGdi3pk+SQunjudwVpR901TJy5mbgy2cC6E9/AiCx5FIlDhcWBI3Y1zKzilcmb8zSdtx644yXZg7TAQmxP0Sc4KhObnA/z74EVSXQ/dBWOiKyZtvKb7qlEgCOBMIEpoaTVDlYGnQn+adnM2wICw1YATolB3fGacVkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753620326; c=relaxed/simple;
	bh=YJQ9n08UXrt/MB8gxQHjbOjHgVm8H6qWDmJ+9NBxXdQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XhPwJ9igQWCPCwovopAnJ5QvIodgu0Eh4KXd+fgwMTMauPsC+PaoB5UForZlsE4zw039bIKjxx6MFmN/ralXsY932GqQ9cgN0PS5Zas/GIPVIbwPb2hoCJqwJhnPjP/GS+H9s+zS3wgmNpfJHs+AZvtB4yvco9B05gVAo+23/98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=auSmkDmj; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=i8n2gLyEyUOh6UKSpBhhS1CfYOGr3T7f2FfB477MpxY=; b=auSmkDmj7a3k4oUBaC+FyEF4NT
	oKwg2uFSI2z+sXBuoT9if/Vtxe4YXPISfqvJq1S0PiXadjs7flE2x55/xqoxaJc9M2os7Fa97oix6
	Tzon5j2f3F6CtX4jVUWrY/qjy7HDllEim+Ckl4DpLrQLtR8Bx6S3JfvZt56srKJSPGiCcBQ1gsQRA
	H7ljG8lmqEvl2h36nRcuAK8Xuq8vStJBjipzMVCRoQciKx7any29fq5FQ1L+bEybW/qU9YbKkUu9r
	aB6QWWEdzbqHmtgbD2VxnW1YZuUU5eYelQkCyUEqrXxHzl6MeUuOs9uh2y40cmfUoPh/pun3h0Fbx
	qDfW/Wqg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ug0V9-00A4tl-0x;
	Sun, 27 Jul 2025 20:45:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 27 Jul 2025 20:45:11 +0800
Date: Sun, 27 Jul 2025 20:45:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: liulongfang <liulongfang@huawei.com>
Cc: alex.williamson@redhat.com, jgg@nvidia.com,
	shameerali.kolothum.thodi@huawei.com, jonathan.cameron@huawei.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxarm@openeuler.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v5 2/3] migration: qm updates BAR configuration
Message-ID: <aIYfVyBp6trHWnwj@gondor.apana.org.au>
References: <20250630085402.7491-1-liulongfang@huawei.com>
 <20250630085402.7491-3-liulongfang@huawei.com>
 <7694ee87-2852-3759-1360-6349f46e7d70@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7694ee87-2852-3759-1360-6349f46e7d70@huawei.com>

On Tue, Jul 15, 2025 at 03:23:09PM +0800, liulongfang wrote:
> On 2025/6/30 16:54, Longfang Liu wrote:
> > On new platforms greater than QM_HW_V3, the configuration region for the
> > live migration function of the accelerator device is no longer
> > placed in the VF, but is instead placed in the PF.
> > 
> > Therefore, the configuration region of the live migration function
> > needs to be opened when the QM driver is loaded. When the QM driver
> > is uninstalled, the driver needs to clear this configuration.
> > 
> > Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> > ---
> >  drivers/crypto/hisilicon/qm.c | 29 +++++++++++++++++++++++++++++
> >  1 file changed, 29 insertions(+)
> >
> 
> Hello, Herbert. There is a patch in this patchset that modifies the crypto subsystem.
> Could you help review it?

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

