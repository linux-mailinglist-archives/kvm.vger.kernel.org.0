Return-Path: <kvm+bounces-40538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 85D81A58ADF
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 04:35:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 206F7188AB20
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 03:35:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B78E1B4257;
	Mon, 10 Mar 2025 03:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GkMgNIyc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5771025761
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 03:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741577738; cv=none; b=nHQ4WozW9yynvryEYP4mCwXQjMZ/ybyDxAqaPERgohQI21XOYj9d/y5Dv2Xb1N4HXa+mtYXT2N2ID8uYuQhJIs6386dcSJa13Lzj7GcFiI9kNfkALFmd205K0EQ7lrHrFR6xwuXUZrBAXEys/gzd6uhEG0Dl05b4TyxgHiGzKko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741577738; c=relaxed/simple;
	bh=LXMGQOQfMpK8Ot0XRMhmYs2+5Wy8pzBjI6L07qFxgvo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eip40ZVaTgBP7+u60qbTug+AWkxtSbHgNtf7vqjpTWDuOr8gq1SAcKPO8uz0uRDcBXr4+pUwrywaQ0hLWk2kztVcB5cXh6/xoNTtYsiNUaRPZN7+r1Qhhi+sUObnGE+mGjtSG3AQBJsjuJBcvKpRbnT9MxFNNarCRrU+hlA43gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GkMgNIyc; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741577736; x=1773113736;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LXMGQOQfMpK8Ot0XRMhmYs2+5Wy8pzBjI6L07qFxgvo=;
  b=GkMgNIycvzKGOwZ95RARIuV2uuAmXtHUMg+IXGyQ2d06jxaLkyiQQjQq
   /xyBkTjuIuBZnSV366lzn0Y4tf2oeFqyAVv7RSROERJ4E0h64Id3uiaFD
   sBCaj0I2bETPnyf2W5t+4D2RX88qWtBiTwDM2E7pLMm8ouMGdG9/jW/c1
   MxmmjfsMBGsHVL3Oikk2rS/jhhK0y6q53Y0BLTFFSQCLYV2ctmxWQFqtA
   uhT8nslPEriFb8wawuvy3Z75DesY+fj3ldWChXwkKhcEc+ZbkS7VqeEyG
   Rw5xNjBB8K8Y0m3PTVpN7g4w1b0EFWcpREfM1uvzbyBtd0tL7JsQmeWw0
   w==;
X-CSE-ConnectionGUID: 1A/2bSwRRTidLNYJxK6ldA==
X-CSE-MsgGUID: mDG1WPdXQeCnDclAbsIYaA==
X-IronPort-AV: E=McAfee;i="6700,10204,11368"; a="45352867"
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="45352867"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2025 20:35:35 -0700
X-CSE-ConnectionGUID: gkhPiYgGRZWuXQQ4yRtvVA==
X-CSE-MsgGUID: UFXEgryWS+CdMoFJ+c1w1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="157067879"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa001.jf.intel.com with ESMTP; 09 Mar 2025 20:35:30 -0700
Date: Mon, 10 Mar 2025 11:55:40 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
	mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
	likexu@tencent.com, like.xu.linux@gmail.com,
	zhenyuw@linux.intel.com, groug@kaod.org, khorenko@virtuozzo.com,
	alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
	davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
	dapeng1.mi@linux.intel.com, joe.jin@oracle.com
Subject: Re: [PATCH v2 05/10] target/i386/kvm: extract unrelated code out of
 kvm_x86_build_cpuid()
Message-ID: <Z85ivB8XYyVKVurm@intel.com>
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-6-dongli.zhang@oracle.com>
 <Z8q5NHQeIgXxTmPO@intel.com>
 <23cca084-2081-408d-a360-22fad0ff5037@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23cca084-2081-408d-a360-22fad0ff5037@oracle.com>

> How about we still wrap in another new function with &cpuid_data.cpuid as
> an argument?
> 
> 1. In current patch, we need cpuid(0xa) to query Intel PMU info.
> 
> 2. In PATCH 08/10 (AMD), we need cpuid(0x80000001) to determine PERFCORE.
> 
> https://lore.kernel.org/all/20250302220112.17653-9-dongli.zhang@oracle.com/
> 
> (Otherwise, we may use ((env->features[FEAT_8000_0001_ECX] &
> CPUID_EXT3_PERFCORE), but I prefer something consistent)
> 
> 
> 3. In PATCH 09/10 (AMD PerfMonV2), we need cpuid(0x80000022) to query the
> PerfMonV2 support, and the number of PMU counters.
> 
> https://lore.kernel.org/all/20250302220112.17653-10-dongli.zhang@oracle.com/

Thanks, I see. This new function makes sense for me.

Regards,
Zhao


