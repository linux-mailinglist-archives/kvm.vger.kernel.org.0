Return-Path: <kvm+bounces-46047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 163C3AB0EDE
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 11:25:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 05AF71C41BE0
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 09:24:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C13722777F9;
	Fri,  9 May 2025 09:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QBo+mYrU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1FC2741A2
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 09:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746782608; cv=none; b=RacXTfGlNtzCf9fFmTrX2anXTEDJ9t+aX/VC8YPcqhrtN2asHwxyR2lMnSD11JLoeCJOBkgbvpDOm9GT/itxh6EOW+JwLcwqLVhpXESr2756FoxgRSRX1X5OOmxE9J80n5+p8NIsWcsZ+vJsH1yFgLUjQshVHC0nWDKVgNZv5y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746782608; c=relaxed/simple;
	bh=iFMZIw+14kY1d7IgnZ74KIDB4WWlMeVYLeVjbCOX2dM=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Tdu4R7cYCa51jIupAOb3BpXDFAGPJbztYci63JrRynN+jMZ89Cpc3pXJZdRe5ZgP9mWCcShaIRHYp11jkrKxFp48UN/8ld748RZ1xFtER1YdnZs210YooPHnQVo7bZ07q11rnRwX1zzQ+OXv4SHf6qka3drMC7w4M1uKYTtRrtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QBo+mYrU; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746782607; x=1778318607;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iFMZIw+14kY1d7IgnZ74KIDB4WWlMeVYLeVjbCOX2dM=;
  b=QBo+mYrU7mv5RRwFGFqFX20jCAC62PvWzNIdXTpYEgjEOeQnuJQkli+V
   zrGanTJt2M+C/TbyJpYzGVZl792HQqEgaiU1KLxIX7CULHmm7clh9f8i2
   gVv7JSCNXuj4eKFiS4pfYsh77R+r2DuT6I4ai+v8iKYk1H0Wj7Kn0ZXN0
   dpLCHn6RrhILagdbkVFZz+H4qSd3kGTko6FRWeriiI0bt6jl3JlNnlZO/
   znqafLb6hlRrN7EtEFXlg4EulWZHthGClmWmK3/FJqZr9kTRjZvUbMtSz
   GsMXbyYL7ZqQKxyDXN1p8BsOkNWLtgL18W/kHoLBlbIh0QKy+ZUS2lZe+
   A==;
X-CSE-ConnectionGUID: UE8yqVyxSgCsXuUsG8XKhQ==
X-CSE-MsgGUID: a0GdWT96R0KavrDANhP6fg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48609170"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="48609170"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 02:23:27 -0700
X-CSE-ConnectionGUID: HBHVEMxFRIKC7P0+mu0rog==
X-CSE-MsgGUID: EjiDTsgnRJqTNFKFc6Id4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="141474549"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.240.236]) ([10.124.240.236])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 02:23:23 -0700
Message-ID: <e089f11a-da4c-44c9-8553-3492e236d4aa@linux.intel.com>
Date: Fri, 9 May 2025 17:23:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
Subject: Re: [PATCH v4 12/13] ram-block-attribute: Add priority listener
 support for PrivateSharedListener
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
 Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-13-chenyi.qiang@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20250407074939.18657-13-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/7/2025 3:49 PM, Chenyi Qiang wrote:
> In-place page conversion requires operations to follow a specific
> sequence: unmap-before-conversion-to-private and
> map-after-conversion-to-shared. Currently, both attribute changes and
> VFIO DMA map/unmap operations are handled by PrivateSharedListeners,
> they need to be invoked in a specific order.
> 
> For private to shared conversion:
> - Change attribute to shared.
> - VFIO populates the shared mappings into the IOMMU.
> - Restore attribute if the operation fails.
> 
> For shared to private conversion:
> - VFIO discards shared mapping from the IOMMU.
> - Change attribute to private.
> 
> To faciliate this sequence, priority support is added to
> PrivateSharedListener so that listeners are stored in a determined
> order based on priority. A tail queue is used to store listeners,
> allowing traversal in either direction.
> 
> Signed-off-by: Chenyi Qiang<chenyi.qiang@intel.com>
> ---
> Changes in v4:
>      - Newly added.
> ---
>   accel/kvm/kvm-all.c          |  3 ++-
>   hw/vfio/common.c             |  3 ++-
>   include/exec/memory.h        | 19 +++++++++++++++++--
>   include/exec/ramblock.h      |  2 +-
>   system/ram-block-attribute.c | 23 +++++++++++++++++------
>   5 files changed, 39 insertions(+), 11 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index aec64d559b..879c61b391 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -1745,7 +1745,8 @@ static void kvm_region_add(MemoryListener *listener,
>       psl = &cpsl->listener;
>       QLIST_INSERT_HEAD(&cgs->cvm_private_shared_list, cpsl, next);
>       private_shared_listener_init(psl, kvm_private_shared_notify_to_shared,
> -                                 kvm_private_shared_notify_to_private);
> +                                 kvm_private_shared_notify_to_private,
> +                                 PRIVATE_SHARED_LISTENER_PRIORITY_MIN);
>       generic_state_manager_register_listener(gsm, &psl->scl, section);
>   }
>   
> diff --git a/hw/vfio/common.c b/hw/vfio/common.c
> index 6e49ae597d..a8aacae26c 100644
> --- a/hw/vfio/common.c
> +++ b/hw/vfio/common.c
> @@ -515,7 +515,8 @@ static void vfio_register_private_shared_listener(VFIOContainerBase *bcontainer,
>   
>       psl = &vpsl->listener;
>       private_shared_listener_init(psl, vfio_private_shared_notify_to_shared,
> -                                 vfio_private_shared_notify_to_private);
> +                                 vfio_private_shared_notify_to_private,
> +                                 PRIVATE_SHARED_LISTENER_PRIORITY_COMMON);
>       generic_state_manager_register_listener(gsm, &psl->scl, section);
>       QLIST_INSERT_HEAD(&bcontainer->vpsl_list, vpsl, next);
>   }
> diff --git a/include/exec/memory.h b/include/exec/memory.h
> index 9472d9e9b4..3d06cc04a0 100644
> --- a/include/exec/memory.h
> +++ b/include/exec/memory.h
> @@ -770,11 +770,24 @@ struct RamDiscardManagerClass {
>       GenericStateManagerClass parent_class;
>   };
>   
> +#define PRIVATE_SHARED_LISTENER_PRIORITY_MIN       0
> +#define PRIVATE_SHARED_LISTENER_PRIORITY_COMMON    10

For the current implementation with primarily KVM and VFIO needing
ordered execution, the two priority levels are likely sufficient. Not
sure whether it needs more priority levels for future development.

Thanks,
baolu

