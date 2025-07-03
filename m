Return-Path: <kvm+bounces-51392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 35007AF6CF6
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:32:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BAB3252278F
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 08:32:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BEAF2D0C86;
	Thu,  3 Jul 2025 08:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XTYcTqy6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035FF2DE6E8
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 08:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751531512; cv=none; b=il75CsAntoNHIQeGK1oRYixcveaC8v2Pj7Wnkd947Ui3ugGSD3q/CA/yzCHa+gPKPm7z8m+ijxNDGR2+5xPX8/Tf+BOyfKAMyw86oUKntBDC+5B2eowHSvHVltIWeA4cAtb6EDQsLThJL8nluf8CbUgA1P0D8xllQ0Sm5RzThzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751531512; c=relaxed/simple;
	bh=ByU4hpYzsvjOd9VZE1TBCs8POchjSwZa0YYeiaUeNw0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HNCZJZg8NFnvFGcY0VJn+EnHydVJyYwLeQWFJzhonAFxccJf67MIl/rRv6OujJYfwSdcaYzg9CfITnuuDLgyOX/P+HAu7B4a2wB1RmINKJ666MAdHxqWTcICyQH67b+//VseBsztePd5118mGt3J+7trB3a4t3VygoMqlIF31AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XTYcTqy6; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751531512; x=1783067512;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=ByU4hpYzsvjOd9VZE1TBCs8POchjSwZa0YYeiaUeNw0=;
  b=XTYcTqy6ODehrgY7gYPVFdp96L16hLa6BDCtDY4h/FxReuidkdn7LY6U
   odECRVB96W/pRWnOKfT9Bdx5oknO0yaib+B6BUgO0mk65dBTqDdBM7rlT
   5frdmMA1VBTyupyeMcY7xBb6cIZcVHWdilk/gPJsTfxrDSifhvoRVYG6z
   o+JLiL5jfDgf88tBgPe0Dzz5LF7voOIFrxw3Uewvl5HIvDfiQTikbhlkM
   SlAJhtec8yTAkghWR+Vf9lnpVRW9zCsxjYyfEnH9hdultc2AYPNMIWtqX
   IauX5DzqOwV0xzP7vdRDN0WlMLggWuwnDQXaOTHplik4Dx006+a44lvlO
   g==;
X-CSE-ConnectionGUID: n48a2iJeSa2N4BzvA0bXDg==
X-CSE-MsgGUID: GJ4YQrzkRXu7o+V3aWFaaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="53960994"
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="53960994"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 01:31:44 -0700
X-CSE-ConnectionGUID: AuvEBSWtSWyGr0z8bLAlKw==
X-CSE-MsgGUID: HlkdXOsfS96ROan7iqiTJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="154797421"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa008.jf.intel.com with ESMTP; 03 Jul 2025 01:31:39 -0700
Date: Thu, 3 Jul 2025 16:53:04 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Mads Ynddal <mads@ynddal.dk>, Fabiano Rosas <farosas@suse.de>,
	Laurent Vivier <lvivier@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>, kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v4 56/65] accel: Expose and register
 generic_handle_interrupt()
Message-ID: <aGZE8PkdEEVxU+Gm@intel.com>
References: <20250702185332.43650-1-philmd@linaro.org>
 <20250702185332.43650-57-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250702185332.43650-57-philmd@linaro.org>

On Wed, Jul 02, 2025 at 08:53:18PM +0200, Philippe Mathieu-Daudé wrote:
> Date: Wed,  2 Jul 2025 20:53:18 +0200
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH v4 56/65] accel: Expose and register
>  generic_handle_interrupt()
> X-Mailer: git-send-email 2.49.0
> 
> In order to dispatch over AccelOpsClass::handle_interrupt(),
> we need it always defined, not calling a hidden handler under
> the hood. Make AccelOpsClass::handle_interrupt() mandatory.
> Expose generic_handle_interrupt() prototype and register it
> for each accelerator.
> 
> Suggested-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  include/system/accel-ops.h        | 3 +++
>  accel/hvf/hvf-accel-ops.c         | 1 +
>  accel/kvm/kvm-accel-ops.c         | 1 +
>  accel/qtest/qtest.c               | 1 +
>  accel/xen/xen-all.c               | 1 +
>  system/cpus.c                     | 9 +++------
>  target/i386/nvmm/nvmm-accel-ops.c | 1 +
>  target/i386/whpx/whpx-accel-ops.c | 1 +
>  8 files changed, 12 insertions(+), 6 deletions(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


