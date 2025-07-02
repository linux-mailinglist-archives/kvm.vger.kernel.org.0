Return-Path: <kvm+bounces-51274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D984DAF0EC8
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 11:05:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D9CFB1C25F40
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 09:05:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F7CA23CEF8;
	Wed,  2 Jul 2025 09:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DH/sYZ57"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B52E19D8A7
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 09:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751447107; cv=none; b=hfzUOzZFWBWvWh4s+B0ufQEnNWtZqFnMdyxHSTme8/NnMJRQIWO6Exh4gifJhbZaCI32qO1UxkkPtT6bmeMSwbgc7FrtK31113ZTS9fdU+HFfWiY5qTYh4Ms8sB5Kv0WzwyQus4rdaOCKwtpNaSDzid+RFgD5aM16p6qvpp9CYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751447107; c=relaxed/simple;
	bh=FYvqE1dreIBJ0IRqIt+R5lkTuiFftO1lyqanVbKLGWI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DRFMn8/aiNiEbegn28r35xCqsgkRvTzL55xfdjkT/cozYzoujkjcO4nst8d3x5SZd9XPo59JHrvIttE+ibcNMJohMnMFcY3GMukBRFsixeToha/2frUr2MT7WPuRk/mWjv0QLUArl39Gi0wZ0//qJJXim2c+0I3MxkNu5bJntjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DH/sYZ57; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751447106; x=1782983106;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FYvqE1dreIBJ0IRqIt+R5lkTuiFftO1lyqanVbKLGWI=;
  b=DH/sYZ57OEfhfuDSDJJ9235Xzx6KN4GMaW/m3KKevZiFBi3C7WwBJyi3
   lZcrogVEijSMAuKvBkSfOzGb3PpCjCLrnJDi7Pt5O0mk46GSd14YUHewq
   gsZlLbo1ZwtkpjtT96LgbqC7p5KPZTYHnMIlbqEf3zr/ilwXWMBN8FGnd
   RhdK5VFTOzA23MvSt1QTKDM4dqw8uqbnW6JNNJhQbnYHQnagyHamw8KBs
   VxJsP/jlRlvErzfnrRKhloS6iWP/vcasUhnEkUIGgVf3wWB4bWErp5x2T
   E6dvVpicaLjjXyNg0YiMYgGu8g6CHHrr+OE+LfC6mRYAqthkPyO75Q+cY
   g==;
X-CSE-ConnectionGUID: K+Oci/FiRLuXxFXxHL2n1Q==
X-CSE-MsgGUID: GVtGAurRTHO/f9V4nHlyUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="53448819"
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="53448819"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 02:05:05 -0700
X-CSE-ConnectionGUID: 5Sm47SFVTVK1fTC6kNOAxA==
X-CSE-MsgGUID: bfGo06vLShOp4AMJp8MeXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="159724762"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.80]) ([10.124.240.80])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 02:05:02 -0700
Message-ID: <0b2a6fbe-6232-4e6a-8423-ab09f6d312b7@linux.intel.com>
Date: Wed, 2 Jul 2025 17:04:58 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/16] i386/cpu: Add descriptor 0x49 for CPUID 0x2
 encoding
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
 <20250620092734.1576677-3-zhao1.liu@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250620092734.1576677-3-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 6/20/2025 5:27 PM, Zhao Liu wrote:
> The legacy_l2_cache (2nd-level cache: 4 MByte, 16-way set associative,
> 64 byte line size) corresponds to descriptor 0x49, but at present
> cpuid2_cache_descriptors doesn't support descriptor 0x49 because it has
> multiple meanings.
>
> The 0x49 is necessary when CPUID 0x2 and 0x4 leaves have the consistent
> cache model, and use legacy_l2_cache as the default l2 cache.
>
> Therefore, add descriptor 0x49 to represent general l2 cache.
>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>  target/i386/cpu.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index e398868a3f8d..995766c9d74c 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -127,7 +127,18 @@ struct CPUID2CacheDescriptorInfo cpuid2_cache_descriptors[] = {
>                 .associativity = 8,  .line_size = 64, },
>      [0x48] = { .level = 2, .type = UNIFIED_CACHE,     .size =   3 * MiB,
>                 .associativity = 12, .line_size = 64, },
> -    /* Descriptor 0x49 depends on CPU family/model, so it is not included */
> +    /*
> +     * Descriptor 0x49 has 2 cases:
> +     *  - 2nd-level cache: 4 MByte, 16-way set associative, 64 byte line size.
> +     *  - 3rd-level cache: 4MB, 16-way set associative, 64-byte line size
> +     *    (Intel Xeon processor MP, Family 0FH, Model 06H).
> +     *
> +     * When it represents l3, then it depends on CPU family/model. Fortunately,
> +     * the legacy cache/CPU models don't have such special l3. So, just add it
> +     * to represent the general l2 case.

For comments and commit message, we'd better use the capital character
"L2/L3" to represent the 2nd/3rd level cache which is more conventional. 

Others look good to me.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>


> +     */
> +    [0x49] = { .level = 2, .type = UNIFIED_CACHE,     .size =   4 * MiB,
> +               .associativity = 16, .line_size = 64, },
>      [0x4A] = { .level = 3, .type = UNIFIED_CACHE,     .size =   6 * MiB,
>                 .associativity = 12, .line_size = 64, },
>      [0x4B] = { .level = 3, .type = UNIFIED_CACHE,     .size =   8 * MiB,

