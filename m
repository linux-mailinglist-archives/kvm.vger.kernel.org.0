Return-Path: <kvm+bounces-27908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EDD799022E
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 13:40:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 11E1B1F2228C
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 11:40:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1C16158DC5;
	Fri,  4 Oct 2024 11:40:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE0428E8;
	Fri,  4 Oct 2024 11:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728042022; cv=none; b=D6xIOA4fy/2EBN8b40/96uTXg4iYomOzRZcSbGWAgvNoS3NrQfQyyNNkuc/TkONk/dPp6Y6THrPtkympCyqXTy1A3LV54POSpabznaOen19iuQYitOc0C6Yt0GE+D7j66xG6WggwlojOZmip/C61TiK57FWairh+oXOtBPqkPvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728042022; c=relaxed/simple;
	bh=zj/v/YSZm7JOt2SMXu1c+xcBVS6L9M+HRftbnsyzSPQ=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oo01DR/hvg0zw7XZED3B5PBYINkEyHglDyqB1/JqpCXUJPgQmUOrQR4zJYLmSfKjj0LgdM5onT1O3Wyx02bI5PywZUOfxWRWNF4EFF3jHe22ER3lNdqSA8hznt6O58FSYxFCHasLOAqZS5a+miEkCwfODFnq48qgupuSegSJygI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XKmhM2X03z6L774;
	Fri,  4 Oct 2024 19:36:03 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 26059140B63;
	Fri,  4 Oct 2024 19:40:15 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 4 Oct
 2024 13:40:14 +0200
Date: Fri, 4 Oct 2024 12:40:13 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Zhi Wang <zhiw@nvidia.com>
CC: "Tian, Kevin" <kevin.tian@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>, "Schofield,
 Alison" <alison.schofield@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>,
	"dave@stgolabs.net" <dave@stgolabs.net>, "Weiny, Ira" <ira.weiny@intel.com>,
	"Verma, Vishal L" <vishal.l.verma@intel.com>, "alucerop@amd.com"
	<alucerop@amd.com>, Andy Currid <ACurrid@nvidia.com>, Neo Jia
	<cjia@nvidia.com>, Surath Mitra <smitra@nvidia.com>, Ankit Agrawal
	<ankita@nvidia.com>, Aniket Agashe <aniketa@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	"zhiwang@kernel.org" <zhiwang@kernel.org>
Subject: Re: [RFC 00/13] vfio: introduce vfio-cxl to support CXL type-2
 accelerator passthrough
Message-ID: <20241004124013.00004bca@Huawei.com>
In-Reply-To: <5ad34682-5fa9-44ee-b36b-b17317256187@nvidia.com>
References: <20240920223446.1908673-1-zhiw@nvidia.com>
	<BN9PR11MB5276B821A9732BF0A9EC67988C6F2@BN9PR11MB5276.namprd11.prod.outlook.com>
	<75c0c6f1-07e4-43c1-819c-2182bdd0b47c@nvidia.com>
	<20240925140515.000077f5@Huawei.com>
	<5ad34682-5fa9-44ee-b36b-b17317256187@nvidia.com>
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
X-ClientProxiedBy: lhrpeml100002.china.huawei.com (7.191.160.241) To
 frapeml500008.china.huawei.com (7.182.85.71)


> >   
> >>
> >> Presumably, the host creates one large CXL region that covers the entire
> >> DPA, while QEMU can virtually partition it into different regions and
> >> map them to different virtual CXL region if QEMU presents multiple HDM
> >> decoders to the guest.  
> > 
> > I'm not sure why it would do that. Can't think why you'd break up
> > a host region - maybe I'm missing something.
> >   
> 
> It is mostly concerning about a device can have multiple HDM decoders. 
> In the current design, a large physical CXL (pCXL) region with the whole 
> DPA will be passed to the userspace. Thinking that the guest will see 
> the virtual multiple HDM decoders, which usually SW is asking for, the 
> guest SW might create multiple virtual CXL regions. In that case QEMU 
> needs to map them into different regions of the pCXL region.

Don't let the guest see multiple HDM decoders?

There is no obvious reason why it would want them other than type
differences.

Why is it useful for a type 2 device to be setup for multiple CXL regions?
It shouldn't be a performance thing. Might be convenient for management
I guess, but the driver can layer it's own allocator etc on top of a single
region so I'm not sure I see a reason to do this...

Jonathan



