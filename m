Return-Path: <kvm+bounces-43080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 33691A83EAF
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 11:30:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D3181189DA19
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 09:27:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F45825A32E;
	Thu, 10 Apr 2025 09:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DqjQc4dn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7571B2571BB
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 09:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744277103; cv=none; b=BfydX92w+UjpoETP5rYZ2gvP7Q+dBkuNODAcJOC2fX/vSd6RNATkI5rAZjh8dJo7EM1pE6Fg6dbEnLtqsjqCB4VyFvtfin8EGzirQOTNR45nwRMGSHsiy2zSV1SwU5WpjP9DPOqZvwWlib1Lkq54aHfR9fhMH7J+/i0fMKoM2QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744277103; c=relaxed/simple;
	bh=vWFTCAHyc4ZZSNblinRf0t8BBfuIQYEI8cO6hq8NbrA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=joOPNw9Y/VeRLayE+3fa9C9OUXMrilHbpqGU5o18dnJ8mQw3mFgJ9Yt2nIa5F+vFTe1ZqFSCGhdNLmZjJsuv/7lpZn333Cgv/SrRZPa/5LJd/3BVav0gfK73B/qWYhIfe9NoIYDLRuZsLysVo0nyv4Y4bVgOEjx4JVzbEh+O434=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DqjQc4dn; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744277101; x=1775813101;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vWFTCAHyc4ZZSNblinRf0t8BBfuIQYEI8cO6hq8NbrA=;
  b=DqjQc4dn8qC+E54nW6UuNYvQhIlLhJCKst1PwRQIHV/zlKpg7phcedIr
   Ub2d0tKJbUq3uHqpaXZUx7AvwHK/PwyQD/lvHMgHqngcXPtnwxqwA+9xw
   kAZu6Q4H6MPU7ZEiD+CdTZdKIdtleXdSeWtZX4nctQiEA+BQTtNxigNZs
   X/61O/03PXWaLSpc3w2cHbEoAmH+ytjKB44I5iDRBPDUcBxWNbNsSqdMz
   xJuiZAsIrb6/wfC1mNGABmHGYv6yv0DxvxfqNO6ijyyT/rkSb20Pp3wVR
   7XIbEPBw/ACOkAXGfNBNlgRlGjZyKu2N0QOAf+H/6rmrJ4UrC7qpm7P+a
   g==;
X-CSE-ConnectionGUID: B/aRoSWeS4iH4ME3Con5IQ==
X-CSE-MsgGUID: YktUyqUJRJCr5p6TUn1IOA==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="49625362"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="49625362"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 02:25:00 -0700
X-CSE-ConnectionGUID: 7EFLD+8sQoiP2fdPZgk4+Q==
X-CSE-MsgGUID: aiCRLBNDQsqVw5PNhNlRAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="129685784"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa009.fm.intel.com with ESMTP; 10 Apr 2025 02:24:51 -0700
Date: Thu, 10 Apr 2025 17:45:41 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
	qemu-ppc@nongnu.org, qemu-riscv@nongnu.org, qemu-s390x@nongnu.org,
	pbonzini@redhat.com, mtosatti@redhat.com, sandipan.das@amd.com,
	babu.moger@amd.com, likexu@tencent.com, like.xu.linux@gmail.com,
	groug@kaod.org, khorenko@virtuozzo.com,
	alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
	davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
	dapeng1.mi@linux.intel.com, joe.jin@oracle.com,
	peter.maydell@linaro.org, gaosong@loongson.cn,
	chenhuacai@kernel.org, philmd@linaro.org, aurelien@aurel32.net,
	jiaxun.yang@flygoat.com, arikalo@gmail.com, npiggin@gmail.com,
	danielhb413@gmail.com, palmer@dabbelt.com, alistair.francis@wdc.com,
	liwei1518@gmail.com, zhiwei_liu@linux.alibaba.com,
	pasic@linux.ibm.com, borntraeger@linux.ibm.com,
	richard.henderson@linaro.org, david@redhat.com, iii@linux.ibm.com,
	thuth@redhat.com, flavra@baylibre.com, ewanhai-oc@zhaoxin.com,
	ewanhai@zhaoxin.com, cobechen@zhaoxin.com, louisqi@zhaoxin.com,
	liamni@zhaoxin.com, frankzhu@zhaoxin.com, silviazhao@zhaoxin.com
Subject: Re: [PATCH v3 10/10] target/i386/kvm: don't stop Intel PMU counters
Message-ID: <Z/eTRVSveNMwZBaa@intel.com>
References: <20250331013307.11937-1-dongli.zhang@oracle.com>
 <20250331013307.11937-11-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250331013307.11937-11-dongli.zhang@oracle.com>

On Sun, Mar 30, 2025 at 06:32:29PM -0700, Dongli Zhang wrote:
> Date: Sun, 30 Mar 2025 18:32:29 -0700
> From: Dongli Zhang <dongli.zhang@oracle.com>
> Subject: [PATCH v3 10/10] target/i386/kvm: don't stop Intel PMU counters
> X-Mailer: git-send-email 2.43.5
> 
> The kvm_put_msrs() sets the MSRs using KVM_SET_MSRS. The x86 KVM processes
> these MSRs one by one in a loop, only saving the config and triggering the
> KVM_REQ_PMU request. This approach does not immediately stop the event
> before updating PMC.

This is ture after KVM's 68fb4757e867 (v6.2). QEMU even supports v4.5
(docs/system/target-i386.rst)... I'm not sure whether it is outdated,
but it's better to mention the Linux version.

> In additional, PMU MSRs are set only at levels >= KVM_PUT_RESET_STATE,
> excluding runtime. Therefore, updating these MSRs without stopping events
> should be acceptable.

I agree.

> Finally, KVM creates kernel perf events with host mode excluded
> (exclude_host = 1). While the events remain active, they don't increment
> the counter during QEMU vCPU userspace mode.
> 
> No Fixed tag is going to be added for the commit 0d89436786b0 ("kvm:
> migrate vPMU state"), because this isn't a bugfix.
> 
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
>  target/i386/kvm/kvm.c | 9 ---------
>  1 file changed, 9 deletions(-)

Fine for me,

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


