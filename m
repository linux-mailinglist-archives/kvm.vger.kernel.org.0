Return-Path: <kvm+bounces-40157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F032A5013A
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 15:01:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89EF63AE5EF
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 14:00:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83EB42459F8;
	Wed,  5 Mar 2025 14:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IIw+UNbv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB611E50B
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 14:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741183241; cv=none; b=BWoucVwJuE00OZh8ArKsJRavlcQHsriOH4rtCY6yXHSRFEqVgHDfJRgzEFDQtOmV9g7bTlHnJrYdbCQSdqI8QuF/7JeorDt9k23+OJ8vwIMRybQ1BHYIMsekmVNDlgh+v1tQyUEfARJq/9xcYGebitfscyFXK8tvzsWHF1TJtfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741183241; c=relaxed/simple;
	bh=gxIy8ueMCd4X6MIxHjdnqpDtjVZtahN6h+VUJ5acYwU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TOTO20RH2oXmbJQUR8Nu05JeYgz4UdZbyi0pACknnuI7n7sUagalEC75Jr1rcVhwP7kci100tPF2JzSrZDHnqMxZp22Xg2UMpgh6IVMFQbs3+m7rGn6rmi/9rmSBghylywYzw3vAh9Xs7yOTWXrGrXll3xLCuiGyViPPO+eWhPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IIw+UNbv; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741183240; x=1772719240;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gxIy8ueMCd4X6MIxHjdnqpDtjVZtahN6h+VUJ5acYwU=;
  b=IIw+UNbvnrfJnzypvCV2jNzPuKcBBSF1qBE9yzJJqr3PEBP7/8OhcXYj
   fRq7jnprMrCbBafW0tD1mY5bCplgt+CxY5Z8drI+BUs7Iu+wtwkh9U4RV
   /ZHMiMaIz5V7nomzaUZwom9DTvoN/cDw61YuTVrg8hvyFSHpvB/9138UX
   O3nfBwTa5DxKGqAi8NIepNTooUZSbHVSXzZecJG4/Qbo/287QLNEryGrk
   mng3nur14E61hLvJNuwG0eG/RdnjMEImI44+jEWZmxbawKg3y/inc+CnT
   yKFAGLR2LyCj8zN/Vbj9inHi0UON9PR7fz6ohB/rTc6b41bJOrTPn5aDi
   Q==;
X-CSE-ConnectionGUID: UNfg5O7LQyeIVb6CWCGtGA==
X-CSE-MsgGUID: Olxrkxk0SPawQtiU6hawKA==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="59558613"
X-IronPort-AV: E=Sophos;i="6.14,223,1736841600"; 
   d="scan'208";a="59558613"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2025 06:00:39 -0800
X-CSE-ConnectionGUID: HEE7XtrFQqWU73Ojc81ZOQ==
X-CSE-MsgGUID: YdeBfGBYS0mT90dge/v51g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,223,1736841600"; 
   d="scan'208";a="118848760"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa008.fm.intel.com with ESMTP; 05 Mar 2025 06:00:34 -0800
Date: Wed, 5 Mar 2025 22:20:42 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
	mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
	likexu@tencent.com, like.xu.linux@gmail.com,
	zhenyuw@linux.intel.com, groug@kaod.org, khorenko@virtuozzo.com,
	alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
	davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
	dapeng1.mi@linux.intel.com, joe.jin@oracle.com
Subject: Re: [PATCH v2 01/10] target/i386: disable PerfMonV2 when PERFCORE
 unavailable
Message-ID: <Z8hdurk8e0CSB6hP@intel.com>
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-2-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250302220112.17653-2-dongli.zhang@oracle.com>

On Sun, Mar 02, 2025 at 02:00:09PM -0800, Dongli Zhang wrote:
> Date: Sun,  2 Mar 2025 14:00:09 -0800
> From: Dongli Zhang <dongli.zhang@oracle.com>
> Subject: [PATCH v2 01/10] target/i386: disable PerfMonV2 when PERFCORE
>  unavailable
> X-Mailer: git-send-email 2.43.5
> 
> When the PERFCORE is disabled with "-cpu host,-perfctr-core", it is
> reflected in in guest dmesg.
> 
> [    0.285136] Performance Events: AMD PMU driver.
> 
> However, the guest CPUID indicates the PerfMonV2 is still available.
> 
> CPU:
>    Extended Performance Monitoring and Debugging (0x80000022):
>       AMD performance monitoring V2         = true
>       AMD LBR V2                            = false
>       AMD LBR stack & PMC freezing          = false
>       number of core perf ctrs              = 0x6 (6)
>       number of LBR stack entries           = 0x0 (0)
>       number of avail Northbridge perf ctrs = 0x0 (0)
>       number of available UMC PMCs          = 0x0 (0)
>       active UMCs bitmask                   = 0x0
> 
> Disable PerfMonV2 in CPUID when PERFCORE is disabled.
> 
> Suggested-by: Zhao Liu <zhao1.liu@intel.com>
> Fixes: 209b0ac12074 ("target/i386: Add PerfMonV2 feature bit")
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
> Changed since v1:
>   - Use feature_dependencies (suggested by Zhao Liu).
> 
>  target/i386/cpu.c | 4 ++++
>  1 file changed, 4 insertions(+)

Thanks!

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


