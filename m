Return-Path: <kvm+bounces-68106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id BB882D21F02
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 02:09:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 606653004619
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 01:09:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CADF20E31C;
	Thu, 15 Jan 2026 01:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CB9mEl2y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBFDF9D9
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 01:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768439357; cv=none; b=Tn2IwuAH88sexUHbjBYwPplhhlMMJvRSrfPUWs5DKCmI5TzSplRB6HGBx+e0+znANd7T9g0MbZnW8g2UsdxSpjfXe9FJZdri/Wt+ZKgWIzKRwPyVrR2MlRJ7x/z2BzwLKH9G78DCJOo1Qr0EoMkc7MD1h75qE+XgpjkxMKYfUEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768439357; c=relaxed/simple;
	bh=j7+IM67mifDuc48YzmS+Yh9v4dq1w2CzQp4UFeFTzMI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R3mCqPRDC4eLJUyAnZi5Ftuce6wrFjIyVZP62/FfIXmiraMbuTGP+BHnRmR8uEvroNSPJBHrp20JFZQSQ4EFTJ/7Cqc9piC5KUnb9tRA9MzNhLH/tRj0tShQfPF3x86F3wA027Tev4yJs42GI9XhdozvuDZLkd0ZqSGomFrU/V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CB9mEl2y; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768439356; x=1799975356;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=j7+IM67mifDuc48YzmS+Yh9v4dq1w2CzQp4UFeFTzMI=;
  b=CB9mEl2ybU+pH/AM6A3kEPKUKlV7PuO1v7tc3HLipSgfLlOJ7OhAqohW
   QCh1JcSYx6HKPR2zHtOhMWE7VVKkbrPTRGbSucG3zNEUOl9GeFRj8tKJE
   UChPOzWkNZdOBYURcrTTRF8/dhrqWkBLZa8Y9SZ2KENfTZiHLkdrBo4sN
   6g2G4k3PisaqAp0mLOdF0r2TwsAVyZWVYENZ/psZMuhr0kvLDM9jwz4m1
   0thdbRLThQxP9Uq9ivtjdVaU0sdAc1KMepJzzv1Dcp0wLXMuBl5Q4r7t/
   22Tt+/2VIwrSHpmc9xjFurPlGxjrHCB5fiA5HF3v+F3G+PeNcVZz4lEsu
   Q==;
X-CSE-ConnectionGUID: LoxyfPxCQpyAJxymTFfsSA==
X-CSE-MsgGUID: nSLNS8lpSfGvSKYeqaE45Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11671"; a="95227390"
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="95227390"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 17:09:15 -0800
X-CSE-ConnectionGUID: x7Hd1BQJTFiAN1uNp3YVvQ==
X-CSE-MsgGUID: BeZaA6sYTA65ZO1YNeCn2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="205241351"
Received: from fhuang-mobl1.amr.corp.intel.com (HELO [10.125.38.93]) ([10.125.38.93])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 17:09:14 -0800
Message-ID: <5e72cb05-25b9-4bfe-89da-6f67b54de9b8@intel.com>
Date: Wed, 14 Jan 2026 17:09:13 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 5/5] target/i386/kvm: support perfmon-v2 for reset
To: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
 sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
 like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
 alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
 davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
 dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai-oc@zhaoxin.com,
 ewanhai@zhaoxin.com
References: <20260109075508.113097-1-dongli.zhang@oracle.com>
 <20260109075508.113097-6-dongli.zhang@oracle.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <20260109075508.113097-6-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/8/2026 11:54 PM, Dongli Zhang wrote:
> Since perfmon-v2, the AMD PMU supports additional registers. This update
> includes get/put functionality for these extra registers.
> 
> Similar to the implementation in KVM:
> 
> - MSR_CORE_PERF_GLOBAL_STATUS and MSR_AMD64_PERF_CNTR_GLOBAL_STATUS both
> use env->msr_global_status.
> - MSR_CORE_PERF_GLOBAL_CTRL and MSR_AMD64_PERF_CNTR_GLOBAL_CTL both use
> env->msr_global_ctrl.
> - MSR_CORE_PERF_GLOBAL_OVF_CTRL and MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR
> both use env->msr_global_ovf_ctrl.
> 
> No changes are needed for vmstate_msr_architectural_pmu or
> pmu_enable_needed().
> 
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> Reviewed-by: Sandipan Das <sandipan.das@amd.com>
> ---

LGTM.
Reviewed-by: Zide Chen <zide.chen@intel.com>

