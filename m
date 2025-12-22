Return-Path: <kvm+bounces-66477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CFBACD655B
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 15:11:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 732E3305AE51
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 14:09:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0A682D9496;
	Mon, 22 Dec 2025 14:09:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CFE2D94A5;
	Mon, 22 Dec 2025 14:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766412585; cv=none; b=JX/nzk3oTezYNwTQ9BVRswl9gKp82EM1hpEuaNnSvOgWSMZmUTFSWDEmgUp/NxpwrM+CPOE6z1u0wdD0CfHMi45Sj8pFitfcEYcSSmM7gEQ6qrY+9daEY1VSSnY6xo4eCs+UccvTBJz8QvLmZeKrQhJKGCUZKRGF/4dakn2GyTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766412585; c=relaxed/simple;
	bh=iDkI3c5olkkh1xfth4C9dhq1JkjQUDqdLnM9hgDCCyw=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KeSAImherulvzbjI03QGxTX5FhQH2FX/3ubTVTy0lHwER5H72AtnuL9HegYfSRoQrClY17y7hNrK7QNTc5XctdNqMwmCzc9pRGlcshJ1NQmXy3fZVKSWNM36F4sSUmvsgKKcVghE+CVv0TJisQWf/8L1agjgw7tQx2de38abP38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dZg402RVBzHnGjH;
	Mon, 22 Dec 2025 22:09:04 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 785A64056C;
	Mon, 22 Dec 2025 22:09:39 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 22 Dec
 2025 14:09:38 +0000
Date: Mon, 22 Dec 2025 14:09:36 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: <mhonap@nvidia.com>
CC: <aniketa@nvidia.com>, <ankita@nvidia.com>, <alwilliamson@nvidia.com>,
	<vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
	<skolothumtho@nvidia.com>, <alejandro.lucero-palau@amd.com>,
	<dave@stgolabs.net>, <dave.jiang@intel.com>, <alison.schofield@intel.com>,
	<vishal.l.verma@intel.com>, <ira.weiny@intel.com>,
	<dan.j.williams@intel.com>, <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<kevin.tian@intel.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<linux-kernel@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
	<kvm@vger.kernel.org>
Subject: Re: [RFC v2 08/15] vfio/cxl: discover precommitted CXL region
Message-ID: <20251222140936.00007f38@huawei.com>
In-Reply-To: <20251209165019.2643142-9-mhonap@nvidia.com>
References: <20251209165019.2643142-1-mhonap@nvidia.com>
	<20251209165019.2643142-9-mhonap@nvidia.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100009.china.huawei.com (7.191.174.83) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Tue, 9 Dec 2025 22:20:12 +0530
mhonap@nvidia.com wrote:

> From: Zhi Wang <zhiw@nvidia.com>
> 
> A type-2 device can have precommitted CXL region that is configured by
> BIOS. Before letting a VFIO CXL variant driver create a new CXL region,
> the VFIO CXL core first needs to discover the precommited CXL region.

This is similar to the discussion in Alejandro's type 2 series.
Before we put infrastructure in place for handling bios precommitting I'd
like some discussion of why they are doing that.

There are a few possible reasons, but in at least some cases I suspect it
is misguided attempt to set things up that the BIOS should be leaving
well alone. I'd also be curious to hear if the decoders are locked
or not in the systems you've seen it on?  I.e. can we rip it down
and start again?

I'm definitely not saying we should not support this, but I want
people to enumerate the reasons they need it.

> 
> Discover the precommited CXL region when enabling CXL devices.
> 
> Signed-off-by: Zhi Wang <zhiw@nvidia.com>
> Signed-off-by: Manish Honap <mhonap@nvidia.com>



