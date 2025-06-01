Return-Path: <kvm+bounces-48148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C9660AC9F31
	for <lists+kvm@lfdr.de>; Sun,  1 Jun 2025 17:44:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A0151171445
	for <lists+kvm@lfdr.de>; Sun,  1 Jun 2025 15:44:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEE4C1E3DFA;
	Sun,  1 Jun 2025 15:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E4iHOpjn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0641BC2A
	for <kvm@vger.kernel.org>; Sun,  1 Jun 2025 15:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748792666; cv=none; b=Sg1feI3EZK0/5CkAaUNbdYqxxUDKGgm/K8QqxbYlSvmUhRwEOIYUe6cAi4xSLIBMzkGMjj4sZJEiAXCKqod+1D5et0nVbdh1279ST4oJ2uH8tkrvsvX4bw5p9ri2jOwmMS6M1tftyn7MV5RXPfis9A0Uuw5C6sDIj4+05cvSepo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748792666; c=relaxed/simple;
	bh=CrzePAb4bB7XgRH1J0UXaTlj3s1yRQ9aXdOygA9u6iw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K0eqmvkVaE6IU5TNT5EdbEX/cF/Ao28GiQMKIFucjc/n8q3CckqVPYNh1F/NqOzFmWTvfzrkRGicQbds3ydEvOZ+77RhA0eTvI6ZPSn2OVR4MbYVtazY/22sdF+sdZcHUmxl0CU5dSngbs7n2OoQmG6/ZiLM9btpxEm6FxgomU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E4iHOpjn; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748792666; x=1780328666;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CrzePAb4bB7XgRH1J0UXaTlj3s1yRQ9aXdOygA9u6iw=;
  b=E4iHOpjndU8hlLENGAmsJqxwSFmZyn7UR2GSxS5xx/UXAjiFjWpeg31X
   yrOPtADUsLgH9+WYr3yv7Dk8SQkZVgi6S0uu+anC5fgzik10sZCHLEaR4
   Yj0O8l8pdWP3KgV5/HFLrLSo30dEZnU3RfUeIcpmvEHhin8IJxTQeTllJ
   KygHFGHGvD41MFO0B2O4Tf4645TS+N7zpdgSi8niysJ+syB5OwBtJn3iA
   Qzq6DgA7Dp/Od9lYqJ5uwnbIn5dPQso1Z5xBMnQDvkwNUzI8glSoBTIte
   Oi2qg37ZafEH7z1/elj3k7HJ5VxGiiJ2Z9yOvn8DGMqDdwBulVzQTGEir
   w==;
X-CSE-ConnectionGUID: NHhwdGAYRQKCVpPzc42HsA==
X-CSE-MsgGUID: HAN1a3tqSZmLwlznZSq3KA==
X-IronPort-AV: E=McAfee;i="6700,10204,11450"; a="50517336"
X-IronPort-AV: E=Sophos;i="6.16,201,1744095600"; 
   d="scan'208";a="50517336"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2025 08:44:25 -0700
X-CSE-ConnectionGUID: 4RaEFyP8SvqAErzzBo7uyQ==
X-CSE-MsgGUID: x5GmQESmQLKTuiau8cRcjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,201,1744095600"; 
   d="scan'208";a="175340974"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2025 08:44:19 -0700
Message-ID: <a5fbaad2-87c2-4791-8728-39db9e977521@intel.com>
Date: Sun, 1 Jun 2025 23:44:16 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/5] memory: Export a helper to get intersection of a
 MemoryRegionSection with a given range
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
 Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@kaod.org>, Alex Williamson <alex.williamson@redhat.com>
References: <20250530083256.105186-1-chenyi.qiang@intel.com>
 <20250530083256.105186-2-chenyi.qiang@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250530083256.105186-2-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/30/2025 4:32 PM, Chenyi Qiang wrote:
> Rename the helper to memory_region_section_intersect_range() to make it
> more generic. Meanwhile, define the @end as Int128 and replace the
> related operations with Int128_* format since the helper is exported as
> a wider API.
> 
> Suggested-by: Alexey Kardashevskiy<aik@amd.com>
> Reviewed-by: Alexey Kardashevskiy<aik@amd.com>
> Reviewed-by: David Hildenbrand<david@redhat.com>
> Reviewed-by: Zhao Liu<zhao1.liu@intel.com>
> Signed-off-by: Chenyi Qiang<chenyi.qiang@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

