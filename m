Return-Path: <kvm+bounces-28357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7729C997A48
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 03:49:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5B9F283A5B
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 01:49:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B773D2BD0E;
	Thu, 10 Oct 2024 01:49:02 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFF3179A3;
	Thu, 10 Oct 2024 01:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728524942; cv=none; b=RJr2fn6jNYJEvyoTcDrQOX8h4TmfwGVBRBkXMb72qsi4WuAMQPQjygYa3iCJGWVGtddmPbkYxbvzNJTQh9yOxhprqsjg2GGM0f60pqlugigrYi+v4uNuVpQKJlVLB/4e2GANxTGwpsJrxWp4mjDR8Sd2hiy624teiAmevxBC+a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728524942; c=relaxed/simple;
	bh=hueCzQH/AfAa2c9bLUILdhl3uuN8EfCbcDmuU3f6jk0=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Ei3YrcZmfttvpux/ted4dvuTSY5mIzgWUZ8HjKwJrf3CyUe7RUEYHQIppZY6B/ZnLtkkhcK5YMwGwtDTAGR4VRnQw+sHMdSntirKH3EDN551AeDS6299rJLo++uwPH+R0l5NnIwFBRB+TibiP8n/ukWLtoiE41/pxPascZVNMns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4XPCLt2fhFz1SCQ3;
	Thu, 10 Oct 2024 09:47:50 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 0795E18001B;
	Thu, 10 Oct 2024 09:48:57 +0800 (CST)
Received: from [10.174.178.247] (10.174.178.247) by
 dggpemf500002.china.huawei.com (7.185.36.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 10 Oct 2024 09:48:55 +0800
Subject: Re: [PATCH v3 2/9] ACPICA: IORT: Update for revision E.f
To: Jason Gunthorpe <jgg@nvidia.com>, <acpica-devel@lists.linux.dev>,
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Kevin Tian
	<kevin.tian@intel.com>, <kvm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
	<linux-acpi@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>, Lorenzo
 Pieralisi <lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>
CC: Alex Williamson <alex.williamson@redhat.com>, Eric Auger
	<eric.auger@redhat.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>, Michael Shavit <mshavit@google.com>, Nicolin
 Chen <nicolinc@nvidia.com>, <patches@lists.linux.dev>, "Rafael J. Wysocki"
	<rafael.j.wysocki@intel.com>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>
References: <2-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
From: Hanjun Guo <guohanjun@huawei.com>
Message-ID: <c19cd18c-fe36-52d9-754e-135af2018f0b@huawei.com>
Date: Thu, 10 Oct 2024 09:48:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <2-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemf500002.china.huawei.com (7.185.36.57)

On 2024/10/10 0:23, Jason Gunthorpe wrote:
> From: Nicolin Chen <nicolinc@nvidia.com>
> 
> ACPICA commit c4f5c083d24df9ddd71d5782c0988408cf0fc1ab
> 
> The IORT spec, Issue E.f (April 2024), adds a new CANWBS bit to the Memory
> Access Flag field in the Memory Access Properties table, mainly for a PCI
> Root Complex.
> 
> This CANWBS defines the coherency of memory accesses to be not marked IOWB
> cacheable/shareable. Its value further implies the coherency impact from a
> pair of mismatched memory attributes (e.g. in a nested translation case):
>    0x0: Use of mismatched memory attributes for accesses made by this
>         device may lead to a loss of coherency.
>    0x1: Coherency of accesses made by this device to locations in
>         Conventional memory are ensured as follows, even if the memory
>         attributes for the accesses presented by the device or provided by
>         the SMMU are different from Inner and Outer Write-back cacheable,
>         Shareable.
> 

Acked-by: Hanjun Guo <guohanjun@huawei.com>

Thanks
Hanjun

