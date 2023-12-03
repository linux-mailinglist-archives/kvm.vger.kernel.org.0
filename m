Return-Path: <kvm+bounces-3277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 53C028027AA
	for <lists+kvm@lfdr.de>; Sun,  3 Dec 2023 22:03:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B73721F20FE0
	for <lists+kvm@lfdr.de>; Sun,  3 Dec 2023 21:03:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39FCB18C35;
	Sun,  3 Dec 2023 21:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="EPCIT76H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C9ECF
	for <kvm@vger.kernel.org>; Sun,  3 Dec 2023 13:03:31 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id 6a1803df08f44-67a934a5b7eso20112536d6.3
        for <kvm@vger.kernel.org>; Sun, 03 Dec 2023 13:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1701637410; x=1702242210; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YaXGORkgyD8V8K3kt/4/CeA1q7F0AqMm8u3Qa3gndrU=;
        b=EPCIT76HtPBzRKP4TG88oBEItjAruT/TTDWWfxqJSSEkJEoxLIuU6pjKPlLcgcHGYD
         WFz1IaJNLWkca7++6Qqc5Jc1VGIDPjKpNzXGyA0vcz2yFjRQFTXs8p8NYck2NLxke3Qj
         nCwFHy5GZ4viyiQ9urM/vDn7N2gvKceph+Bnlc2h5pb7Gq+lXuXWANfWvKk3a+BIuMsD
         kfmqABSLvCtDUQy5WQYcJ/9CB3Rf2ETDH+U/kjlbwc+Jb3KB9flQZ216XRoEIQof9VsU
         +cKuwGPSx5jrO2BLwNNdcZLv/iKeJfa4tpILcfpWlXL8Ljmo8qc17ycCEPV+y2aLa++a
         /DxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701637410; x=1702242210;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YaXGORkgyD8V8K3kt/4/CeA1q7F0AqMm8u3Qa3gndrU=;
        b=Cq/F2CgrPnVrZ0gqdEBQQFFC2lrguIg397SUUSm6ENwyLZrW6pBycyHrqgoeKdPtEs
         F4RKziLrb6t7bSBd4U25dg9fzujiq4CHuhT1Re9c29R/AY9YJ1OvTipkHhTQPd8bntbr
         whbug1hb28xjdvxpYcZWmFBvcmj4NNfIcN36T8h1Q9Ot5ISrN+jkuSIQ4ZGwuKDB4mER
         CjW5qWkPgh5nNAupfjE37fTP9B0vm50zBgXEpyiJVAEynxLXFUquKz5uHKTcnnOF41ul
         I5FCfk2OS6R8kQotVHp5XgGTxgHSIhqPImY7ZVUWIkohKRsX/iHk2UirHPx+1vTyQtSY
         p03A==
X-Gm-Message-State: AOJu0YwfAu96HDez3JoBC9yzJID4zjvQTd2xDuYa9uUgOETledTJPjFz
	pOltLIPLSqEYbZwHCaLON9vpOy1Me3TRBWp+vsM=
X-Google-Smtp-Source: AGHT+IFYzHr/0YyRjB08FkzLtTmSfc4SoE5PAVUiQe+99X3u0yla2mEqYMqaHTxcjvabk9kqiuCHHg==
X-Received: by 2002:a0c:ec86:0:b0:67a:8d3c:22a8 with SMTP id u6-20020a0cec86000000b0067a8d3c22a8mr4170105qvo.65.1701637410157;
        Sun, 03 Dec 2023 13:03:30 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-134-23-187.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.134.23.187])
        by smtp.gmail.com with ESMTPSA id k7-20020a0cabc7000000b0067a3991d002sm3712187qvb.30.2023.12.03.13.03.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Dec 2023 13:03:29 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1r9nEc-009I57-0J;
	Sun, 03 Dec 2023 10:14:14 -0400
Date: Sun, 3 Dec 2023 10:14:14 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Yan Zhao <yan.y.zhao@intel.com>, iommu@lists.linux.dev,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 12/12] iommu: Improve iopf_queue_flush_dev()
Message-ID: <20231203141414.GJ1489931@ziepe.ca>
References: <20231115030226.16700-1-baolu.lu@linux.intel.com>
 <20231115030226.16700-13-baolu.lu@linux.intel.com>
 <20231201203536.GG1489931@ziepe.ca>
 <a0ef3a4f-88fc-40fe-9891-495d1b6b365b@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0ef3a4f-88fc-40fe-9891-495d1b6b365b@linux.intel.com>

On Sun, Dec 03, 2023 at 04:53:08PM +0800, Baolu Lu wrote:
> On 12/2/23 4:35 AM, Jason Gunthorpe wrote:
> > On Wed, Nov 15, 2023 at 11:02:26AM +0800, Lu Baolu wrote:
> > > The iopf_queue_flush_dev() is called by the iommu driver before releasing
> > > a PASID. It ensures that all pending faults for this PASID have been
> > > handled or cancelled, and won't hit the address space that reuses this
> > > PASID. The driver must make sure that no new fault is added to the queue.
> > This needs more explanation, why should anyone care?
> > 
> > More importantly, why is*discarding*  the right thing to do?
> > Especially why would we discard a partial page request group?
> > 
> > After we change a translation we may have PRI requests in a
> > queue. They need to be acknowledged, not discarded. The DMA in the
> > device should be restarted and the device should observe the new
> > translation - if it is blocking then it should take a DMA error.
> > 
> > More broadly, we should just let things run their normal course. The
> > domain to deliver the fault to should be determined very early. If we
> > get a fault and there is no fault domain currently assigned then just
> > restart it.
> > 
> > The main reason to fence would be to allow the domain to become freed
> > as the faults should be holding pointers to it. But I feel there are
> > simpler options for that then this..
> 
> In the iommu_detach_device_pasid() path, the domain is about to be
> removed from the pasid of device. The IOMMU driver performs the
> following steps sequentially:

I know that is why it does, but it doesn't explain at all why.

> 1. Clears the pasid translation entry. Thus, all subsequent DMA
>    transactions (translation requests, translated requests or page
>    requests) targeting the iommu domain will be blocked.
> 
> 2. Waits until all pending page requests for the device's PASID have
>    been reported to upper layers via the iommu_report_device_fault().
>    However, this does not guarantee that all page requests have been
>    responded.
>
> 3. Free all partial page requests for this pasid since the page request
>    response is only needed for a complete request group. There's no
>    action required for the page requests which are not last of a request
>    group.

But we expect the last to come eventually since everything should be
grouped properly, so why bother doing this?

Indeed if 2 worked, how is this even possible to have partials?
 
> 5. Follow the IOMMU hardware requirements (for example, VT-d sepc,
>    section 7.10, Software Steps to Drain Page Requests & Responses) to
>    drain in-flight page requests and page group responses between the
>    remapping hardware queues and the endpoint device.
> 
> With above steps done in iommu_detach_device_pasid(), the pasid could be
> re-used for any other address space.

As I said, that isn't even required. There is no issue with leaking
PRI's across attachments.


> > I suppose the driver is expected to stop calling
> > iommu_report_device_fault() before calling this function, but that
> > doesn't seem like it is going to be possible. Drivers should be
> > implementing atomic replace for the PASID updates and in that case
> > there is no momement when it can say the HW will stop generating PRI.
> 
> Atomic domain replacement for a PASID is not currently implemented in
> the core or driver. 

It is, the driver should implement set_dev_pasid in such a way that
repeated calls do replacements, ideally atomically. This is what ARM
SMMUv3 does after my changes.

> Even if atomic replacement were to be implemented,
> it would be necessary to ensure that all translation requests,
> translated requests, page requests and responses for the old domain are
> drained before switching to the new domain. 

Again, no it isn't required.

Requests simply have to continue to be acked, it doesn't matter if
they are acked against the wrong domain because the device will simply
re-issue them..

Jason

