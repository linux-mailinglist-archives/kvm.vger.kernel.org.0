Return-Path: <kvm+bounces-27421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FF00986083
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 16:25:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 075B91F25208
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 14:25:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5358C1A76A0;
	Wed, 25 Sep 2024 13:05:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0841A704B;
	Wed, 25 Sep 2024 13:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727269528; cv=none; b=tr4k8oF5wHa5KT7ufIjckftXaGFrDmHAvKJe4fBB4zMyeXwwlLotPuR49Lsp93a1QDvfl1C2+oOBqaSs1H7OrfRCKAJej5Cp3yRHoIFjPwrnJUqAgaYy6HusnWZY1J4hUk1bjT7ij1XyyfraNwmBIYw8FzQrncqwabN7oLF0A1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727269528; c=relaxed/simple;
	bh=Z8A+F6g+ckcqDRO/xPuowSQmdScdm2BzOdA9oeqi8hI=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W5zPbAfZP5AOd1A12r7TsUit1+GOqejWWY7S1rJcWgxlXTvmLT3zZxMdZJ3/uQ/adxF/yNLldB5dw6C32T3yOwqub6/7ZKS7DUR2eK1CY57SoRA8Kfk606qffTC1wNEiA+5KA12nQ9KpwgZl/DIYZpmMjelnTlSa2wCnbOlT51g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XDH0862gfz6K9B2;
	Wed, 25 Sep 2024 21:00:40 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id D06A9140F63;
	Wed, 25 Sep 2024 21:05:17 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 25 Sep
 2024 15:05:16 +0200
Date: Wed, 25 Sep 2024 14:05:15 +0100
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
	<cjia@nvidia.com>, Surath Mitra <smitra@nvidia.com>, "Ankit Agrawal"
	<ankita@nvidia.com>, Aniket Agashe <aniketa@nvidia.com>, "Kirti Wankhede"
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	"zhiwang@kernel.org" <zhiwang@kernel.org>
Subject: Re: [RFC 00/13] vfio: introduce vfio-cxl to support CXL type-2
 accelerator passthrough
Message-ID: <20240925140515.000077f5@Huawei.com>
In-Reply-To: <75c0c6f1-07e4-43c1-819c-2182bdd0b47c@nvidia.com>
References: <20240920223446.1908673-1-zhiw@nvidia.com>
	<BN9PR11MB5276B821A9732BF0A9EC67988C6F2@BN9PR11MB5276.namprd11.prod.outlook.com>
	<75c0c6f1-07e4-43c1-819c-2182bdd0b47c@nvidia.com>
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
X-ClientProxiedBy: lhrpeml100003.china.huawei.com (7.191.160.210) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Tue, 24 Sep 2024 08:30:17 +0000
Zhi Wang <zhiw@nvidia.com> wrote:

> On 23/09/2024 11.00, Tian, Kevin wrote:
> > External email: Use caution opening links or attachments
> > 
> >   
> >> From: Zhi Wang <zhiw@nvidia.com>
> >> Sent: Saturday, September 21, 2024 6:35 AM
> >>  
> > [...]  
> >> - Create a CXL region and map it to the VM. A mapping between HPA and DPA
> >> (Device PA) needs to be created to access the device memory directly. HDM
> >> decoders in the CXL topology need to be configured level by level to
> >> manage the mapping. After the region is created, it needs to be mapped to
> >> GPA in the virtual HDM decoders configured by the VM.  
> > 
> > Any time when a new address space is introduced it's worthy of more
> > context to help people who have no CXL background better understand
> > the mechanism and think any potential hole.
> > 
> > At a glance looks we are talking about a mapping tier:
> > 
> >    GPA->HPA->DPA
> > 
> > The location/size of HPA/DPA for a cxl region are decided and mapped
> > at @open_device and the HPA range is mapped to GPA at @mmap.
> > 
> > In addition the guest also manages a virtual HDM decoder:
> > 
> >    GPA->vDPA
> > 
> > Ideally the vDPA range selected by guest is a subset of the physical
> > cxl region so based on offset and vHDM the VMM may figure out
> > which offset in the cxl region to be mmaped for the corresponding
> > GPA (which in the end maps to the desired DPA).
> > 
> > Is this understanding correct?
> >   
> 
> Yes. Many thanks to summarize this. It is a design decision from a 
> discussion in the CXL discord channel.
> 
> > btw is one cxl device only allowed to create one region? If multiple
> > regions are possible how will they be exposed to the guest?
> >  
> 
> It is not an (shouldn't be) enforced requirement from the VFIO cxl core. 
> It is really requirement-driven. I am expecting what kind of use cases 
> in reality that needs multiple CXL regions in the host and then passing 
> multiple regions to the guest.

Mix of back invalidate and non back invalidate supporting device memory
maybe?  A bounce region for p2p traffic would the obvious reason to do
this without paying the cost of large snoop filters. If anyone puts PMEM
on the device, then maybe mix of that at volatile. In theory you might
do separate regions for QoS reasons but seems unlikely to me...

Anyhow not an immediately problem as I don't know of any
BI capable hosts yet and doubt anyone (other than Dan) cares about PMEM :)


> 
> Presumably, the host creates one large CXL region that covers the entire 
> DPA, while QEMU can virtually partition it into different regions and 
> map them to different virtual CXL region if QEMU presents multiple HDM 
> decoders to the guest.

I'm not sure why it would do that. Can't think why you'd break up
a host region - maybe I'm missing something.

...

> >> In the L2 guest, a dummy CXL device driver is provided to attach to the
> >> virtual pass-thru device.
> >>
> >> The dummy CXL type-2 device driver can successfully be loaded with the
> >> kernel cxl core type2 support, create CXL region by requesting the CXL
> >> core to allocate HPA and DPA and configure the HDM decoders.  
> > 
> > It'd be good to see a real cxl device working to add confidence on
> > the core design.  
> 
> To leverage the opportunity of F2F discussion in LPC, I proposed this 
> patchset to start the discussion and meanwhile offered an environment 
> for people to try and hack around. Also patches is good base for 
> discussion. We see what we will get. :)
> 
> There are devices already there and on-going. AMD's SFC (patches are 
> under review) and I think they are going to be the first variant driver 
> that use the core. NVIDIA's device is also coming and NVIDIA's variant 
> driver is going upstream for sure. Plus this emulated device, I assume 
> we will have three in-tree variant drivers talks to the CXL core.
Nice.
> 
> Thanks,
> Zhi.


