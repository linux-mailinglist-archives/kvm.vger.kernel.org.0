Return-Path: <kvm+bounces-43335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BBE01A8981B
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 11:39:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 14F5C1895F8D
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 09:39:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00934289378;
	Tue, 15 Apr 2025 09:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lxXKnFwo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B56289372
	for <kvm@vger.kernel.org>; Tue, 15 Apr 2025 09:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744709922; cv=none; b=s36RXkr/vJ2QmjDa45n/ZyN5z/t/NI2dGwaO+gjxslI3F31FFD04pm3f1A6zFaajcA8Ttiav7iW42nl6vb4vdCeR7NSb64GUE0rVbhpvYFFg+13yScE9JZcJv8ZL9Eq0Iba2NpKcwvGVE674wbi4gPdy1kBLPAHNKeDjoaR/BPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744709922; c=relaxed/simple;
	bh=DIFM4eqQu01Zbc5fSSrZIkWVfd0JHiP4PmzdSxbGFGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EnlHvI71bunUE+TBRdTTG1jiKJyJf8EETLl0cnp896eieS8zFsHxYLcUiGiDBTbT3ZIQb4IqISI78Dy03in28eVL3q5yYbkC5UhCCBfcZ4Tw3hOqqdxtoS7Dic9sUZxFiBLpF0zWTEO2keQ8hXkZDplchQixj0+VkMoKrvB5hT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lxXKnFwo; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744709920; x=1776245920;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DIFM4eqQu01Zbc5fSSrZIkWVfd0JHiP4PmzdSxbGFGs=;
  b=lxXKnFwopSQysx3XJaed9bTHxITMWv2NUGFhDSKm+0YATqIqArxSoNoo
   TNVC3OGLzNyFUjV0uXU/pYbqzwHvsEYIBBTQiMNfux4wF1URHonFpkyKN
   WRc3IaMQywJ7d/qsLSxrtEf/tGdIIBlbCBVZ7x+CfKX+Y6h0zauxVEqUX
   mLWuSX6b5uu0o8Z6guUpNW+wkliodnsR6Bm2j1liuUqN8P273jJjpkOFS
   5JdvCffym8h5t4mRPei/5HznzC0AxNQeOodSRIi464bEWWk8bbbS1w4me
   kjYTAPk3RzAdYODpFTr2JYCS9pDYJA10Vi7SiwsHm2kB3QlvLrZjVsOtZ
   w==;
X-CSE-ConnectionGUID: jLHO18ceQCSrUzTsO3GfSA==
X-CSE-MsgGUID: 9rgsgpirRFGznEKUFmxzEA==
X-IronPort-AV: E=McAfee;i="6700,10204,11403"; a="56847393"
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="56847393"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 02:38:39 -0700
X-CSE-ConnectionGUID: Kqa946dMR6KG/menuDGeCw==
X-CSE-MsgGUID: Fn+ryVDoRseBGNiN5UVZNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="161113285"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 15 Apr 2025 02:38:35 -0700
Date: Tue, 15 Apr 2025 17:59:27 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Eric Auger <eauger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>,
	Sebastian Ott <sebott@redhat.com>, Gavin Shan <gshan@redhat.com>,
	qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
	Dapeng Mi <dapeng1.mi@intel.com>, Yi Lai <yi1.lai@intel.com>
Subject: Re: [PATCH 0/5] accel/kvm: Support KVM PMU filter
Message-ID: <Z/4t/zxQzp4Wxdm9@intel.com>
References: <20250409082649.14733-1-zhao1.liu@intel.com>
 <21f3fedd-274e-4e81-87f8-369deefa8c1a@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21f3fedd-274e-4e81-87f8-369deefa8c1a@redhat.com>

On Tue, Apr 15, 2025 at 03:49:59PM +0800, Shaoqin Huang wrote:
> Date: Tue, 15 Apr 2025 15:49:59 +0800
> From: Shaoqin Huang <shahuang@redhat.com>
> Subject: Re: [PATCH 0/5] accel/kvm: Support KVM PMU filter
> 
> Hi Zhao,
> 
> I've added some code and test it on ARM64, it works very well.
> 
> And after reviewing the code, it looks good to me.
> 
> Reviewed-by: Shaoqin Huang <shahuang@redhat.com>

Thank you Shaoqin for your support!

Regards,
Zhao


