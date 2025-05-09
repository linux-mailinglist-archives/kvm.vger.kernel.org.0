Return-Path: <kvm+bounces-46018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D25ECAB0AD6
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 08:46:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C618B7BBBDB
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 06:45:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C518626F445;
	Fri,  9 May 2025 06:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TVmlcWiZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB1226D4F9
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 06:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746773183; cv=none; b=MC0spmof8Zh9Fcgh+M2xOwWG3OkIkVpqGNJjQiuRQHd5+kydshDAmJcTp3R++AdAtaNc5DBbrVcwDKDh0VCtiLMoBLrJSqzLwLPhWR4JKQ9hRBEvqe3lZ5kJ3hX6yEvSr86IIU5HJdixcGmtuPOAUUE0s/K8R5SceFXCt4NOGSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746773183; c=relaxed/simple;
	bh=B/S648cE9UMjrXY4G55L/9UarDhdPR/uC967jP+/D6Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SSw9e/lzRdyytZYmZoFmobmcPTJLvSRQtElgmVXiwA4DlrU+nE7dUrPSr6CNzsT1cSOsWhqEgWIfRt7ektfXGPlVmQkiFa3ck1Y4H/7SYBrtyY06KTT7Wv1l3B+HXN0n9K+KStG4RJYO8rLa3lai/sI6tJC3JGUMrcjzmv3Ucs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TVmlcWiZ; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746773182; x=1778309182;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=B/S648cE9UMjrXY4G55L/9UarDhdPR/uC967jP+/D6Y=;
  b=TVmlcWiZueEWPruv+A5G6zMwu9tdCvVX+z2D1XDGoB01ONWgOSWfLDf+
   g38KFC7t63zjFUG+DBziXLyLfBtsZFoKZr0kP7YvC9GiQ5Wq+Wld5LLbp
   lWWo82GFJhBOa4x4KGzT0oNYgoCkA8lZ/8z8x42UsgJm8xJqUuHyj65mS
   YI4bQHQ7E64G3WZ52GS9IeaLbxDK2vKkMwiz7sUrDYbhZqdolo/Phazd6
   d3FuhQcwGo5cDnswKr6XZ5y8CLEehOzPP6l0A3nBoGwEVAVZIODSAxJZa
   QtS7GJCmoQdeNn1WyZYbrQqk26EIKVbdeeY1JmHHbYo4HgLgvBFqILTrm
   g==;
X-CSE-ConnectionGUID: PVsMD9jWRtuUPvUqn+DGTA==
X-CSE-MsgGUID: wI4HNa5URX672lxmGxygfg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48744118"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="48744118"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 23:46:15 -0700
X-CSE-ConnectionGUID: zdojglEvRUWT+tIOOBWUpw==
X-CSE-MsgGUID: AyroqVwHRgiYPYok+xNV4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="141482476"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 23:46:12 -0700
Message-ID: <013b36a9-9310-4073-b54c-9c511f23decf@linux.intel.com>
Date: Fri, 9 May 2025 14:41:41 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/13] ram-block-attribute: Introduce RamBlockAttribute
 to manage RAMBLock with guest_memfd
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
 Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-8-chenyi.qiang@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20250407074939.18657-8-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/7/25 15:49, Chenyi Qiang wrote:
> Commit 852f0048f3 ("RAMBlock: make guest_memfd require uncoordinated
> discard") highlighted that subsystems like VFIO may disable RAM block
> discard. However, guest_memfd relies on discard operations for page
> conversion between private and shared memory, potentially leading to
> stale IOMMU mapping issue when assigning hardware devices to
> confidential VMs via shared memory. To address this, it is crucial to
> ensure systems like VFIO refresh its IOMMU mappings.
> 
> PrivateSharedManager is introduced to manage private and shared states in
> confidential VMs, similar to RamDiscardManager, which supports
> coordinated RAM discard in VFIO. Integrating PrivateSharedManager with
> guest_memfd can facilitate the adjustment of VFIO mappings in response
> to page conversion events.
> 
> Since guest_memfd is not an object, it cannot directly implement the
> PrivateSharedManager interface. Implementing it in HostMemoryBackend is
> not appropriate because guest_memfd is per RAMBlock, and some RAMBlocks
> have a memory backend while others do not. Notably, virtual BIOS
> RAMBlocks using memory_region_init_ram_guest_memfd() do not have a
> backend.
> 
> To manage RAMBlocks with guest_memfd, define a new object named
> RamBlockAttribute to implement the RamDiscardManager interface. This
> object stores guest_memfd information such as shared_bitmap, and handles
> page conversion notification. The memory state is tracked at the host
> page size granularity, as the minimum memory conversion size can be one
> page per request. Additionally, VFIO expects the DMA mapping for a
> specific iova to be mapped and unmapped with the same granularity.
> Confidential VMs may perform partial conversions, such as conversions on
> small regions within larger regions. To prevent invalid cases and until
> cut_mapping operation support is available, all operations are performed
> with 4K granularity.

Just for your information, IOMMUFD plans to introduce the support for
cut operation. The kickoff patch series is under discussion here:

https://lore.kernel.org/linux-iommu/0-v2-5c26bde5c22d+58b-iommu_pt_jgg@nvidia.com/

This new cut support is expected to be exclusive to IOMMUFD and not
directly available in the VFIO container context. The VFIO uAPI for map/
unmap is being superseded by IOMMUFD, and all new features will only be
available in IOMMUFD.

> 
> Signed-off-by: Chenyi Qiang<chenyi.qiang@intel.com>

<...>

> +
> +int ram_block_attribute_realize(RamBlockAttribute *attr, MemoryRegion *mr)
> +{
> +    uint64_t shared_bitmap_size;
> +    const int block_size  = qemu_real_host_page_size();
> +    int ret;
> +
> +    shared_bitmap_size = ROUND_UP(mr->size, block_size) / block_size;
> +
> +    attr->mr = mr;
> +    ret = memory_region_set_generic_state_manager(mr, GENERIC_STATE_MANAGER(attr));
> +    if (ret) {
> +        return ret;
> +    }
> +    attr->shared_bitmap_size = shared_bitmap_size;
> +    attr->shared_bitmap = bitmap_new(shared_bitmap_size);

Above introduces a bitmap to track the private/shared state of each 4KB
page. While functional, for large RAM blocks managed by guest_memfd,
this could lead to significant memory consumption.

Have you considered an alternative like a Maple Tree or a generic
interval tree? Both are often more memory-efficient for tracking ranges
of contiguous states.

> +
> +    return ret;
> +}
> +
> +void ram_block_attribute_unrealize(RamBlockAttribute *attr)
> +{
> +    g_free(attr->shared_bitmap);
> +    memory_region_set_generic_state_manager(attr->mr, NULL);
> +}

Thanks,
baolu

