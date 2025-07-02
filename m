Return-Path: <kvm+bounces-51272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 006CDAF0E67
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 10:48:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1D56484779
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 08:48:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AABBD23BD0F;
	Wed,  2 Jul 2025 08:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j/s+hpJN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E7D1A5BA4
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 08:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751446100; cv=none; b=rAnqvnFr4eb7/pzmAFOwAD0mmj88Q6F7HZsPKU3tZev2tDBBn+ADWCmJ7PWAs3I9JpJ+lopZ3gb4ZQh0bq33fm20iYUbOTG1kAVRTqrjonhsR9WXcTem2DM5H9EDzieY2CEtWR07hGJsI/fcEo892QlELQ7+ACkp2zVFM8xN2rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751446100; c=relaxed/simple;
	bh=zk6cPQfsKpuWrDifx8+BrG8ShNF9/KPb42pCeEVTuV8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J1fC6VoF/1RzY/PDyuA8+8mQ/EfheG5wOaHF22AYJ5rsxtsvpRysYa+j2fLywZ0m/OqMTshMax1ePb+zvSYIHfx0JurCdxEZPDJjrkQPZ1NRZ9C0RwjanuiSkrDb6VISrVuLv1PWxgv4UPc8NA1bx6GWjbcWNxgDKhU4XfVp/rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j/s+hpJN; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751446100; x=1782982100;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zk6cPQfsKpuWrDifx8+BrG8ShNF9/KPb42pCeEVTuV8=;
  b=j/s+hpJNvqPi93wX8WmBCUK21oIYOqc/nS4RG/pWZPDzk/qyoqO0Q0DN
   HMJ7GEkI0Uw1Mkp1cVLTacB0G7SRjS4z+ysF9cdu6IFdzHmeMDH8672jk
   QEnHRpOrxshGv+R3dz1PEC+VEiqcXIE4Ig4DKO3e8GuzM5hW/kkVXa4q6
   Sd/nXM21izDrUTRXHHRTFCg99mZ8jftihRIlelJjrqJpCWtY8guQcPro5
   R0cQlQEBokzXaMjWmUb7/w5FbvYhZErahBPXBSsyepaiH9f6tHNhk8UGa
   Dx5rFC/lhadjCd0z319Iofn2Ad2nDxSDTdfIywFHugzZm+0XN8yPZd6zM
   w==;
X-CSE-ConnectionGUID: bQQumtlmTvCF1JzKqChK2w==
X-CSE-MsgGUID: jdnt4hLzT++ykfwADa9tNg==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="65187183"
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="65187183"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 01:48:18 -0700
X-CSE-ConnectionGUID: NUITdyxRRsOun/lNM0ItnA==
X-CSE-MsgGUID: zLN0N6NlRXaZmp58HrIXpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="153476348"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.80]) ([10.124.240.80])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 01:48:14 -0700
Message-ID: <4fde6b82-0d13-48d8-898a-e105b9a79858@linux.intel.com>
Date: Wed, 2 Jul 2025 16:48:11 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/16] i386/cpu: Refine comment of
 CPUID2CacheDescriptorInfo
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, "Michael S . Tsirkin"
 <mst@redhat.com>, =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>
Cc: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Babu Moger <babu.moger@amd.com>, Ewan Hai <ewanhai-oc@zhaoxin.com>,
 Pu Wen <puwen@hygon.cn>, Tao Su <tao1.su@intel.com>,
 Yi Lai <yi1.lai@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20250620092734.1576677-1-zhao1.liu@intel.com>
 <20250620092734.1576677-2-zhao1.liu@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250620092734.1576677-2-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 6/20/2025 5:27 PM, Zhao Liu wrote:
> Refer to SDM vol.3 table 1-21, add the notes about the missing
> descriptor, and fix the typo and comment format.
>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>  target/i386/cpu.c | 31 ++++++++++++++++++++++---------
>  1 file changed, 22 insertions(+), 9 deletions(-)
>
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 40aefb38f6da..e398868a3f8d 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -66,6 +66,7 @@ struct CPUID2CacheDescriptorInfo {
>  
>  /*
>   * Known CPUID 2 cache descriptors.
> + * TLB, prefetch and sectored cache related descriptors are not included.
>   * From Intel SDM Volume 2A, CPUID instruction
>   */
>  struct CPUID2CacheDescriptorInfo cpuid2_cache_descriptors[] = {
> @@ -87,18 +88,29 @@ struct CPUID2CacheDescriptorInfo cpuid2_cache_descriptors[] = {
>                 .associativity = 2,  .line_size = 64, },
>      [0x21] = { .level = 2, .type = UNIFIED_CACHE,     .size = 256 * KiB,
>                 .associativity = 8,  .line_size = 64, },
> -    /* lines per sector is not supported cpuid2_cache_descriptor(),
> -    * so descriptors 0x22, 0x23 are not included
> -    */
> +    /*
> +     * lines per sector is not supported cpuid2_cache_descriptor(),
> +     * so descriptors 0x22, 0x23 are not included
> +     */
>      [0x24] = { .level = 2, .type = UNIFIED_CACHE,     .size =   1 * MiB,
>                 .associativity = 16, .line_size = 64, },
> -    /* lines per sector is not supported cpuid2_cache_descriptor(),
> -    * so descriptors 0x25, 0x20 are not included
> -    */
> +    /*
> +     * lines per sector is not supported cpuid2_cache_descriptor(),
> +     * so descriptors 0x25, 0x29 are not included
> +     */
>      [0x2C] = { .level = 1, .type = DATA_CACHE,        .size =  32 * KiB,
>                 .associativity = 8,  .line_size = 64, },
>      [0x30] = { .level = 1, .type = INSTRUCTION_CACHE, .size =  32 * KiB,
>                 .associativity = 8,  .line_size = 64, },
> +    /*
> +     * Newer Intel CPUs (having the cores without L3, e.g., Intel MTL, ARL)
> +     * use CPUID 0x4 leaf to describe cache topology, by encoding CPUID 0x2
> +     * leaf with 0xFF. For older CPUs (without 0x4 leaf), it's also valid
> +     * to just ignore l3's code if there's no l3.

s/l3/L3/g

Others look good to me. 

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>


> +     *
> +     * This already covers all the cases in QEMU, so code 0x40 is not
> +     * included.
> +     */
>      [0x41] = { .level = 2, .type = UNIFIED_CACHE,     .size = 128 * KiB,
>                 .associativity = 4,  .line_size = 32, },
>      [0x42] = { .level = 2, .type = UNIFIED_CACHE,     .size = 256 * KiB,
> @@ -136,9 +148,10 @@ struct CPUID2CacheDescriptorInfo cpuid2_cache_descriptors[] = {
>                 .associativity = 4,  .line_size = 64, },
>      [0x78] = { .level = 2, .type = UNIFIED_CACHE,     .size =   1 * MiB,
>                 .associativity = 4,  .line_size = 64, },
> -    /* lines per sector is not supported cpuid2_cache_descriptor(),
> -    * so descriptors 0x79, 0x7A, 0x7B, 0x7C are not included.
> -    */
> +    /*
> +     * lines per sector is not supported cpuid2_cache_descriptor(),
> +     * so descriptors 0x79, 0x7A, 0x7B, 0x7C are not included.
> +     */
>      [0x7D] = { .level = 2, .type = UNIFIED_CACHE,     .size =   2 * MiB,
>                 .associativity = 8,  .line_size = 64, },
>      [0x7F] = { .level = 2, .type = UNIFIED_CACHE,     .size = 512 * KiB,

