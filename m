Return-Path: <kvm+bounces-68104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 768B7D21EF9
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 02:07:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E68CC303E41E
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 01:07:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8282A1FE471;
	Thu, 15 Jan 2026 01:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ebg70OaY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4073FEF
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 01:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768439226; cv=none; b=qjcStTCXj5PtIyZAMBq7CinyWuz0W/hFfsADe9qAUg07YPuKrT25saSV7zm46FmBLz39dCsyZC/WT4ia4XRUFNe9xvgA3/j6dMd56oMPiatHs1DJ3IJdLM1qRM7Wcpuy7DvPcc2u34T4E39QIreHQ76+9bIbHucIUnt3PJJZqG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768439226; c=relaxed/simple;
	bh=WiznaQNyKTEee+KonRMn9LZpkSjZNvxzn8/0C5dd21s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C7+GaK/Rld1yKAECNxuOPMKO1UFYvZ94AjdqxcjKOiGrEqzb8NQGkSE94tsoALiodk6yPyvwCIYXjzod09+mWNKWDVpUnpiqPX3i0sbgf1eZXPvOklGYTQi4IuUypLITUBj4AZ7kRKa0eCSZfhpNw4CFEHrQ4njDA5iksxYTfDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ebg70OaY; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768439225; x=1799975225;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WiznaQNyKTEee+KonRMn9LZpkSjZNvxzn8/0C5dd21s=;
  b=Ebg70OaYBVL59srePE6nASj7e78Y9OD+3+5bRHUkwuCPuZ0GvWZXdSnE
   5xakDmrNOJlTQySBO9quLvYl6TZrTfy1WPTJYl2QEKT1HECgshxmqYxml
   MaXQMxsNpyoROUeSmGpEOv26uvugY0C7FsJsSTl7Xv8JLPk8hNneFbyPr
   Bve5U2lZOzmRQIF5TwNM/SQj/szV35Z4ofS6lyVysvyrhnKnVd7mLMM1H
   milN2RQTglyyihx5Cp+vvbdAhoNUR2UclPoIY6Bs0IsPuX+8JxhYX3b7O
   u3GIMYOuJWcA7Owp2GKnYXa6rSNezE/oWBEPbbC9GSfkD1XUpa82aKD27
   w==;
X-CSE-ConnectionGUID: UwL+9vxiRbeeI8rAVGy0/A==
X-CSE-MsgGUID: 6I1b8U0SRyGJ8APT2EJVbA==
X-IronPort-AV: E=McAfee;i="6800,10657,11671"; a="69723706"
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="69723706"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 17:07:05 -0800
X-CSE-ConnectionGUID: vlh9H0UkTtOO1ZhUT1gGXw==
X-CSE-MsgGUID: fc0feO5oQRevSrpIW+1Wpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="235544403"
Received: from fhuang-mobl1.amr.corp.intel.com (HELO [10.125.38.93]) ([10.125.38.93])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 17:07:05 -0800
Message-ID: <ca48a26d-251d-437d-9d5b-b29dd38a4ab1@intel.com>
Date: Wed, 14 Jan 2026 17:07:04 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 1/5] target/i386/kvm: set KVM_PMU_CAP_DISABLE if "-pmu"
 is configured
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
 <20260109075508.113097-2-dongli.zhang@oracle.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <20260109075508.113097-2-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/8/2026 11:53 PM, Dongli Zhang wrote:
> Although AMD PERFCORE and PerfMonV2 are removed when "-pmu" is configured,
> there is no way to fully disable KVM AMD PMU virtualization. Neither
> "-cpu host,-pmu" nor "-cpu EPYC" achieves this.
> 
> As a result, the following message still appears in the VM dmesg:
> 
> [    0.263615] Performance Events: AMD PMU driver.
> 
> However, the expected output should be:
> 
> [    0.596381] Performance Events: PMU not available due to virtualization, using software events only.
> [    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled
> 
> This occurs because AMD does not use any CPUID bit to indicate PMU
> availability.
> 
> To address this, KVM_CAP_PMU_CAPABILITY is used to set KVM_PMU_CAP_DISABLE
> when "-pmu" is configured.
> 
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---

LGTM.
Reviewed-by: Zide Chen <zide.chen@intel.com>

