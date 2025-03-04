Return-Path: <kvm+bounces-40039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D1CCA4E15B
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 15:42:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4FBBD7A3867
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 14:41:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 361A625290A;
	Tue,  4 Mar 2025 14:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IyUc/eiX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD75253B55
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 14:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741099211; cv=none; b=IBLqGRbg7zrcqO9aGsiVy1fkEflLdV8q1aPcrtzrx2X8oH3BFkrTmEO7ZstMKjG+3iUH/15aYvISWM8gHvPmwUn4tQOdBqzhXGaTVnu9DzGFnlaZJlTFYALfPN1a1YzvSEEiTMy2GlrMNeoNnXHuTeJpwS3isF6OH+jN4Yf7QnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741099211; c=relaxed/simple;
	bh=BkcukU1BDLk2mTwIOUdDKSgw1hKEbvTZjuCIFTQz47c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HF8G6wXtDBdeUAVhEnoRcPc3AO1tC/bCMbjT+ONw0udrY1Grn713ueF2TvQp+9t7OcxxGSm+VXVqZLWmGqFlc82gWncXvr/L+4ChUSIOFiFOUQZRt05p7fAkiNfD3sKfZKat5p7axy/NDMmqzPMMaF7dz9l6t2ayON3U8CdndJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IyUc/eiX; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741099209; x=1772635209;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BkcukU1BDLk2mTwIOUdDKSgw1hKEbvTZjuCIFTQz47c=;
  b=IyUc/eiXEtrszimPKK/8HB6nTyQcYQ+T2hn7zbGZYP60/rUPr4BPAfjs
   FkKIfZI+5lCGYhkqc0hds7wGw+8ECv4L8xqxDO6VLS2xliFgiobe2Cfye
   0YVc+W+zVSRP+oj/jtzUwNyLs6Esd9AftuB6LIbpMyl/8yc15PjhK80Cw
   N3vEOBxHELR4csxWGWCpLLCTKMZyaDdiz6VVewPdeGx5TsIhm70tGZI28
   qq7XY+mxH6yT1XdjP3hti57SEgk0HmBtxcnG2+Tzv5Kd+maqYbny4Nd3z
   yHr36A5OCRkH2aLoH7a7BKAKvPL/lPS1o7p7M9OU1KCoJXEFYsAubSMX+
   w==;
X-CSE-ConnectionGUID: hOCMwqNDRYa58VoBXbTfbg==
X-CSE-MsgGUID: 1ddqWZDhTzecrmkt9yDs8w==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="52657718"
X-IronPort-AV: E=Sophos;i="6.14,220,1736841600"; 
   d="scan'208";a="52657718"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 06:40:08 -0800
X-CSE-ConnectionGUID: 92loLUt3Qwyag4Zc3g121g==
X-CSE-MsgGUID: nw1HtKbyQ8eArmS7eVlySg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,220,1736841600"; 
   d="scan'208";a="141614002"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 06:40:03 -0800
Message-ID: <46cd2769-aad6-4b99-aea9-426968a9d7cb@intel.com>
Date: Tue, 4 Mar 2025 22:40:00 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/10] target/i386: disable PerfMonV2 when PERFCORE
 unavailable
To: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
 sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
 like.xu.linux@gmail.com, zhenyuw@linux.intel.com, groug@kaod.org,
 khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
 davydov-max@yandex-team.ru, dapeng1.mi@linux.intel.com, joe.jin@oracle.com
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-2-dongli.zhang@oracle.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250302220112.17653-2-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/3/2025 6:00 AM, Dongli Zhang wrote:
> When the PERFCORE is disabled with "-cpu host,-perfctr-core", it is
> reflected in in guest dmesg.
> 
> [    0.285136] Performance Events: AMD PMU driver.

I'm a little confused. wWhen no perfctr-core, AMD PMU driver can still 
be probed? (forgive me if I ask a silly question)

> However, the guest CPUID indicates the PerfMonV2 is still available.
> 
> CPU:
>     Extended Performance Monitoring and Debugging (0x80000022):
>        AMD performance monitoring V2         = true
>        AMD LBR V2                            = false
>        AMD LBR stack & PMC freezing          = false
>        number of core perf ctrs              = 0x6 (6)
>        number of LBR stack entries           = 0x0 (0)
>        number of avail Northbridge perf ctrs = 0x0 (0)
>        number of available UMC PMCs          = 0x0 (0)
>        active UMCs bitmask                   = 0x0
> 
> Disable PerfMonV2 in CPUID when PERFCORE is disabled.
> 
> Suggested-by: Zhao Liu <zhao1.liu@intel.com>

Though I have above confusion of the description, the change itself 
looks good to me. So

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> Fixes: 209b0ac12074 ("target/i386: Add PerfMonV2 feature bit")
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
> Changed since v1:
>    - Use feature_dependencies (suggested by Zhao Liu).
> 
>   target/i386/cpu.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 72ab147e85..b6d6167910 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -1805,6 +1805,10 @@ static FeatureDep feature_dependencies[] = {
>           .from = { FEAT_7_1_EDX,             CPUID_7_1_EDX_AVX10 },
>           .to = { FEAT_24_0_EBX,              ~0ull },
>       },
> +    {
> +        .from = { FEAT_8000_0001_ECX,       CPUID_EXT3_PERFCORE },
> +        .to = { FEAT_8000_0022_EAX,         CPUID_8000_0022_EAX_PERFMON_V2 },
> +    },
>   };
>   
>   typedef struct X86RegisterInfo32 {


