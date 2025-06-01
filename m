Return-Path: <kvm+bounces-48149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 02914AC9F39
	for <lists+kvm@lfdr.de>; Sun,  1 Jun 2025 17:54:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DEA503A65ED
	for <lists+kvm@lfdr.de>; Sun,  1 Jun 2025 15:53:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC5D71E5B9D;
	Sun,  1 Jun 2025 15:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="acgzUuCW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E491DDA1E
	for <kvm@vger.kernel.org>; Sun,  1 Jun 2025 15:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748793235; cv=none; b=Ti6M2fH1qBJi9HBFghX0kUow1wjgFgTDAQUlYSga4PiCaxSDAm9Uw4U0uLLYOLHDvQaDgBdT/VJCePtzYzf8Vtyjnl9qutRZ6/FoRhByAZCohNCVFI+GytGe4sSjLSS1L6NNlLhuf4J+kikQXAV2mt57AZR2toxbkMRmvYNufRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748793235; c=relaxed/simple;
	bh=a+rsVvs42P6P6HnIX16lnuDZ8+2PuELJSaeSCvUQPDU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pXKcIH5mJ7wO02VO9BzYERWZoPDGDksuLe+6kLP4T1407zHsF0VYpkiE9JRMBmtl4wzYvZDhVzjq8bKfI97kelmKzEYsSXW3JiNVNSsNqNBJTjHiFEflY/nrTuR0fQag5R4P0NU8prWZeHWDWsZkbbB2gWNkMV0CEhpujvDet78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=acgzUuCW; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748793233; x=1780329233;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=a+rsVvs42P6P6HnIX16lnuDZ8+2PuELJSaeSCvUQPDU=;
  b=acgzUuCWgMm0jzHxWCFBAQocgkA1Fpv7knABQfTyadacdumHlf2ngYmq
   43081TW/UlXS/fAKEM09Ftr+LR6KP+9NBFJvJPclOIffq3v9TO/HibmmS
   GEy7FhHylU7ZtGSQbxKirJEG9TgWGxXzyfUg2Y4JhiCPegiJneskIjjai
   IOIoYfcuXLnC5zTevVvwxfssy2wFoK8UwA1923JzRfLNYaQ1asce4mf3K
   4pw+UUdw4l/bIxP3GsofGyaUsAE7hwyDzM7Cc1dSkC7BuHk9Tkvv57dNp
   xOk7IF6njMRbRJM2udjzr0oLoz3++Q/61nPb7I/sUCwzO+gUYMbiLlyza
   A==;
X-CSE-ConnectionGUID: Qec5X55MSIix8QRxrPGSMQ==
X-CSE-MsgGUID: ZZ/zCHeaTDa8oxz9vZ7ZEg==
X-IronPort-AV: E=McAfee;i="6700,10204,11450"; a="62168622"
X-IronPort-AV: E=Sophos;i="6.16,201,1744095600"; 
   d="scan'208";a="62168622"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2025 08:53:51 -0700
X-CSE-ConnectionGUID: XMtRHrsaQS+W0lNbolr6dg==
X-CSE-MsgGUID: cK9aRdw0QnWkSgkcFQidbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,201,1744095600"; 
   d="scan'208";a="144306076"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2025 08:53:47 -0700
Message-ID: <ad5f550b-5d74-4635-996e-1b1d754e727f@intel.com>
Date: Sun, 1 Jun 2025 23:53:43 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/5] memory: Change
 memory_region_set_ram_discard_manager() to return the result
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
 Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@kaod.org>, Alex Williamson <alex.williamson@redhat.com>
References: <20250530083256.105186-1-chenyi.qiang@intel.com>
 <20250530083256.105186-3-chenyi.qiang@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250530083256.105186-3-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/30/2025 4:32 PM, Chenyi Qiang wrote:
> Modify memory_region_set_ram_discard_manager() to return -EBUSY if a
> RamDiscardManager is already set in the MemoryRegion. The caller must
> handle this failure, such as having virtio-mem undo its actions and fail
> the realize() process. Opportunistically move the call earlier to avoid
> complex error handling.
> 
> This change is beneficial when introducing a new RamDiscardManager
> instance besides virtio-mem. After
> ram_block_coordinated_discard_require(true) unlocks all
> RamDiscardManager instances, only one instance is allowed to be set for
> one MemoryRegion at present.
> 
> Suggested-by: David Hildenbrand<david@redhat.com>
> Reviewed-by: David Hildenbrand<david@redhat.com>
> Signed-off-by: Chenyi Qiang<chenyi.qiang@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

