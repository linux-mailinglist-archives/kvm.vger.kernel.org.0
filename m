Return-Path: <kvm+bounces-38665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 53FE9A3D7D4
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 12:08:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 25890189C3CA
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 11:07:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9AA31F1936;
	Thu, 20 Feb 2025 11:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fA8HMVt4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49EF1F152D
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 11:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740049615; cv=none; b=jNsHfbI/tn4C9YNXjZxQKxeHt8+HZkAzc2pWjSH2E9TmTeOr/9VyAKrPY7aFzzX8CgP/SgQgVL7L/Brbl+/4FrlC5desJbcXU71q+MnwNvei2suWGsW8FaFUyWbNUZhFHJj5RyngNZ+CgCfrIIdtsO/OZAmyDrZSAjAAmEPaorU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740049615; c=relaxed/simple;
	bh=ajeAZBlPYk2/mVr6+dIxx2jF+Qx8akOXbX7dEAQPtyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=djEhmZDCGxbvcO+KKP2Zt5ZdJdHoktPxcp5vwMJBix5WgkUs9VseVDF/GwrP5OjoorPf270hVYEKRHyN6dpclfGW6pgMaK3fjTK3mWWOYyyFMN/bN6kSfaHjNImumzo0pol37A36XLO7SGeWpQFATR0k46U8gJLb5RSFiCgH/TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fA8HMVt4; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740049613; x=1771585613;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ajeAZBlPYk2/mVr6+dIxx2jF+Qx8akOXbX7dEAQPtyY=;
  b=fA8HMVt4te4ePy+AGxU+ZH7+R+E4636K0lK0bC7rWJDdElAWqX+NF2vZ
   4D+gBDziKknp7vLzXYJEY22mLITpyiDcm1BS/OkZh9sTbybiP11GCFMMe
   AXV1XsRyU5QkGFLX3kPrqyIW0I3XrFfEELla3aag9kukxwU2zahqKoDHf
   HrUHzYOcLSdYACj56DE5RjOB79bpL7taNXYqzqB1poLz7f2YFjGD+cPfd
   voWvR6KAZbtYvU2Y504LLY0UUQJpo4aKMK7CelS+7dGKaPsM5ueLTumo7
   t7Ii5Q0wjJ4V3+0KLfhmwAvZUUP2Kz+DBBieuBdxeLnWUf0JLiyWli5Lu
   w==;
X-CSE-ConnectionGUID: du8Lf2/FQn+hW+XJdug38g==
X-CSE-MsgGUID: EKoZ6HjwRhqEacCy0i0psw==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="41027809"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="41027809"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 03:06:52 -0800
X-CSE-ConnectionGUID: 1RVwLXHETwqFtWo0m7PmjQ==
X-CSE-MsgGUID: Z5ptAAJuSYa5jaFwSbyzTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,301,1732608000"; 
   d="scan'208";a="114989214"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa007.fm.intel.com with ESMTP; 20 Feb 2025 03:06:50 -0800
Date: Thu, 20 Feb 2025 19:26:25 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Babu Moger <babu.moger@amd.com>
Cc: pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org,
	davydov-max@yandex-team.ru
Subject: Re: [PATCH v5 3/6] target/i386: Update EPYC-Milan CPU model for
 Cache property, RAS, SVM feature bits
Message-ID: <Z7cRYbhxviv1wNyD@intel.com>
References: <cover.1738869208.git.babu.moger@amd.com>
 <e1aeb2a8d03cd47da7b9684183df06ec73136f87.1738869208.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1aeb2a8d03cd47da7b9684183df06ec73136f87.1738869208.git.babu.moger@amd.com>

> +static const CPUCaches epyc_milan_v3_cache_info = {
> +    .l1d_cache = &(CPUCacheInfo) {
> +        .type = DATA_CACHE,
> +        .level = 1,
> +        .size = 32 * KiB,
> +        .line_size = 64,
> +        .associativity = 8,
> +        .partitions = 1,
> +        .sets = 64,
> +        .lines_per_tag = 1,
> +        .self_init = 1,

true.

> +        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
> +    },
> +    .l1i_cache = &(CPUCacheInfo) {
> +        .type = INSTRUCTION_CACHE,
> +        .level = 1,
> +        .size = 32 * KiB,
> +        .line_size = 64,
> +        .associativity = 8,
> +        .partitions = 1,
> +        .sets = 64,
> +        .lines_per_tag = 1,
> +        .self_init = 1,

true.

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


