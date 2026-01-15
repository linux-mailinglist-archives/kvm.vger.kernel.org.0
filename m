Return-Path: <kvm+bounces-68107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 90EACD21F0B
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 02:09:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DED793019665
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 01:09:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF1B9238C0D;
	Thu, 15 Jan 2026 01:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eLIpk+Ko"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E795FF9D9
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 01:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768439379; cv=none; b=X0NVLWYLWXRpSK5tUvKjVME4Px3DbV1EKH2xWoRRA2n/CtJPOzsFrDKweQxyAloZbjfLnJv4Y+LRWlKQPyr2FaTegVrtHw54OAqDfUezpkPlfE2FAnazhdmtTqb0hqmfXvdoJgPraRx4LwxEZSM8QWWDZvWSvsK4mCcw0jHC8ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768439379; c=relaxed/simple;
	bh=nKfA7oo3iz6NvIQgBLyXvj0eZxvS2QvpIqQx4MrvuoU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BirWCoeVohPan5Lop2GoomsnpxfVpcaEvGe6LypMFMSwRC7B9pzU53QCjcg/+o9iZS2TdtJWReuqDbavcI8YGKYSFvVEZvi5DaT+5K3TxTYonKQy9dHQbFfXv0jIDomepDIryhaMEqGVOqgS2xsnw+oi+u/RyRT+Z1Hk8v5shEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eLIpk+Ko; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768439378; x=1799975378;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nKfA7oo3iz6NvIQgBLyXvj0eZxvS2QvpIqQx4MrvuoU=;
  b=eLIpk+Konxija1L85RM8BrCbgEUtoanCX7hT5JI+HGWYdYZx8a0SYOqP
   sTTcloahH8rH1o3ggI8ZnvH5xZ1jtFFXhk1Db2dH1AhiVM93kcC9rcMo6
   nvUf25381BUQiCdjkV7krrcvrpG6zgRdzaK+IiNkgeGeCapGmQ0HayKfI
   tgJy96rzkPLZ+0fheqLYQDZ5QA62uZYC9sy8KuUoVaXfgIAdngMqDPfEU
   WFlfvJlz3DHGCZ0kDcO7+N4ZogUTLclA50HkAbvyK8LXQiGe3KP2gbeJV
   2GmPw4hRT2VRNjdMD4JobyxqvrA0kmMHu78IAiGBMr851IMKr1N0XRH+l
   g==;
X-CSE-ConnectionGUID: EJ3EqfRHRviNRxtCi7GXUg==
X-CSE-MsgGUID: r43RyY2dRyiDPqeGxILRgQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11671"; a="69723965"
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="69723965"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 17:09:37 -0800
X-CSE-ConnectionGUID: ttJ52xNnST253F5pAA8OGw==
X-CSE-MsgGUID: M37YBMv5QM6LqbjoKOvHhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="235544620"
Received: from fhuang-mobl1.amr.corp.intel.com (HELO [10.125.38.93]) ([10.125.38.93])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 17:09:37 -0800
Message-ID: <fe918947-054b-4b53-b065-2b51a3fe1835@intel.com>
Date: Wed, 14 Jan 2026 17:09:36 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 3/5] target/i386/kvm: rename architectural PMU
 variables
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
 <20260109075508.113097-4-dongli.zhang@oracle.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <20260109075508.113097-4-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/8/2026 11:53 PM, Dongli Zhang wrote:
> AMD does not have what is commonly referred to as an architectural PMU.
> Therefore, we need to rename the following variables to be applicable for
> both Intel and AMD:
> 
> - has_architectural_pmu_version
> - num_architectural_pmu_gp_counters
> - num_architectural_pmu_fixed_counters
> 
> For Intel processors, the meaning of pmu_version remains unchanged.
> 
> For AMD processors:
> 
> pmu_version == 1 corresponds to versions before AMD PerfMonV2.
> pmu_version == 2 corresponds to AMD PerfMonV2.
> 
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> Reviewed-by: Sandipan Das <sandipan.das@amd.com>
> ---
LGTM.
Reviewed-by: Zide Chen <zide.chen@intel.com>

