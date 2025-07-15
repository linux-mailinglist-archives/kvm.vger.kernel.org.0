Return-Path: <kvm+bounces-52491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B15F3B05881
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 13:10:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2D334A5FED
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 11:10:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0E412D8394;
	Tue, 15 Jul 2025 11:10:03 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF29258CF2;
	Tue, 15 Jul 2025 11:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752577803; cv=none; b=TdwxlA6ZrK9JIWesxLaM+DYCfAmxTKzL4Gm1ZWlHmqweR0+YgjfgpZnnuK3zKHJqF8Zfj/8LD4qKxlm296wO5Ojg/5CgEhjO/QgyxplgVR/OcWcwmp5iYdv7vAA/EKoz7w00c/f9kVdc7xwaIdYh//mO2p9gV7Ez/uPbcEonguw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752577803; c=relaxed/simple;
	bh=Da1cdmHqfF5cPQZb9asyENrgMPN99pHRn7FhxxwG5dA=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nuwk4wo1HL6KZHbE4V6W3cPsxRdet1R74PVjFGyEoER+1p1TL4lMkIRUOpmC0yDo7pD84OrC5SW5keZeui2hXUeWkrJ477siOdz6ldHgP0sOtC6aLL9Mc5Y9y/acPwqgo8Y2XSKYut0ifg4PcEJOoTzhlUhogfhyZMS6LKZXFEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bhGdt4hCnz6L5Hn;
	Tue, 15 Jul 2025 19:08:50 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 1EB4E140370;
	Tue, 15 Jul 2025 19:09:58 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 15 Jul
 2025 13:09:56 +0200
Date: Tue, 15 Jul 2025 12:09:55 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: <dan.j.williams@intel.com>
CC: Xu Yilun <yilun.xu@linux.intel.com>, Alexey Kardashevskiy <aik@amd.com>,
	<kvm@vger.kernel.org>, <sumit.semwal@linaro.org>, <christian.koenig@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <alex.williamson@redhat.com>,
	<jgg@nvidia.com>, <linux-coco@lists.linux.dev>,
	<dri-devel@lists.freedesktop.org>, <linux-media@vger.kernel.org>,
	<linaro-mm-sig@lists.linaro.org>, <vivek.kasireddy@intel.com>,
	<yilun.xu@intel.com>, <linux-kernel@vger.kernel.org>, <lukas@wunner.de>,
	<yan.y.zhao@intel.com>, <daniel.vetter@ffwll.ch>, <leon@kernel.org>,
	<baolu.lu@linux.intel.com>, <zhenzhong.duan@intel.com>, <tao1.su@intel.com>,
	<linux-pci@vger.kernel.org>, <zhiw@nvidia.com>, <simona.vetter@ffwll.ch>,
	<shameerali.kolothum.thodi@huawei.com>, <aneesh.kumar@kernel.org>,
	<iommu@lists.linux.dev>, <kevin.tian@intel.com>
Subject: Re: [RFC PATCH 00/30] Host side (KVM/VFIO/IOMMUFD) support for
 TDISP using TSM
Message-ID: <20250715120955.00006c40@huawei.com>
In-Reply-To: <68719960cc414_1d3d10056@dwillia2-xfh.jf.intel.com.notmuch>
References: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
	<e886855f-25cc-4274-9f11-fe0e5b025284@amd.com>
	<f5958bda-838a-4ed6-84c6-fef62cd0b28f@amd.com>
	<aFvTL6MUkVZrPoBS@yilunxu-OptiPlex-7050>
	<68719960cc414_1d3d10056@dwillia2-xfh.jf.intel.com.notmuch>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500002.china.huawei.com (7.191.160.78) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Fri, 11 Jul 2025 16:08:16 -0700
dan.j.williams@intel.com wrote:

> Xu Yilun wrote:
> > On Sat, Jun 21, 2025 at 11:07:24AM +1000, Alexey Kardashevskiy wrote:  
> > > 
> > > 
> > > On 11/6/25 11:55, Alexey Kardashevskiy wrote:  
> > > > Hi,
> > > > 
> > > > Is there a QEMU tree using this somewhere?  
> > > 
> > > Ping? Thanks,  
> > 
> > Sorry for late. I've finally got a public tree.
> > 
> > https://github.com/yiliu1765/qemu/tree/zhenzhong/devsec_tsm
> > 
> > Again, I think the changes are far from good, just work for enabling.  
> 
> At some point I want to stage a merge tree QEMU bits here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/devsec/qemu.git/ (not
> created yet)
> 
> ...unless Paolo or others in QEMU community are open to running a
> staging branch in qemu.git. At some point we need to collide all the
> QEMU POC branches, and I expect that needs to happen and show some
> success before the upstream projects start ingesting all these changes.
> 

Qemu relies heavily on gitlab infrastructure for testing - so annoying though it
is maybe we need to host the qemu tree there - possibly mirrored to
kernel.org.

Jonathan


