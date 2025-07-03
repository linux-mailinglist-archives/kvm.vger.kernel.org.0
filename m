Return-Path: <kvm+bounces-51391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62228AF6CD2
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:27:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F99F3BDD5A
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 08:27:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60AC22D0C64;
	Thu,  3 Jul 2025 08:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HQw3j3De"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D10C2C375F
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 08:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751531265; cv=none; b=MpTNPgvI6z5Sx5Wth6D4JkLOp4TYK4vqpuvJP6AYesMImc9MRJJcqyyA92y0pRV1LJjHYKb1n2VkIy/2kZJ+u7n6+4ps9XJdvY0kXPYDnyplsc+FgnMhOtGxGryML9Us3+poqlZB5DJmtW0mfTeYshN5FaHHJTWz9omUswZBuiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751531265; c=relaxed/simple;
	bh=kk77vUBEkSjmsCyANUUqBAMo+dxlEAVvzPvouifbixc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZkaanpplBILdalRLn+Rg6HxBqj4/w42PaB7EzgNktSuI+5tfnmBPY3XJ6yYSsA/HB5yVLMXRBJE4p86c8Q95FGC4M4dF15/VXeq+Qt797PgdinSu9P9Ad/S4sGzBTngy4Kx6xWNih3ocK0XXd2qzAGpVsxz7HSqb6+GTvJachTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HQw3j3De; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751531264; x=1783067264;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=kk77vUBEkSjmsCyANUUqBAMo+dxlEAVvzPvouifbixc=;
  b=HQw3j3DebrZ1TLiG9bcbI6orHRfsHXJErVJD4PZoevyXWXIMJAkB1S0d
   yCQLCZ3+1hG4dt2zbcpCiziCxgfGxHtuAODQj4rmxrthB7HTMibYCI/Vp
   fD4hJeenomVyqrcjzDXYY/EAKPjJcMwmMNBf604fyrq0cru60YkzJj5AR
   Zzcj/Du+YQKWkUeQHZpsyldCQqW/xQxl8jjo/XQaEP+Yyp+koH/oXqTn4
   NHNONK3SuauQIkVQBY2zA83XIJIYfbCjHaL4f0MRS+Vf9YHAW/sYcGJk8
   4C47k8JnFYujzy3lWzfQj/4Ui+Ay0ebkzOubanhbq235PKe4NUtK6drpf
   g==;
X-CSE-ConnectionGUID: kpOqfcSgRci3cMVIK3j8Gw==
X-CSE-MsgGUID: kJ5O9CR/RCSehLNsi1xkbw==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="53816281"
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="53816281"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 01:27:44 -0700
X-CSE-ConnectionGUID: Hyj8XmZIREGYlp0Fp6jlOQ==
X-CSE-MsgGUID: oA/EviQmTmWFP/GcZLUptQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="153737688"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa006.jf.intel.com with ESMTP; 03 Jul 2025 01:27:39 -0700
Date: Thu, 3 Jul 2025 16:49:03 +0800
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
	Mads Ynddal <mads@ynddal.dk>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>, kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v4 59/65] accel: Always register
 AccelOpsClass::get_virtual_clock() handler
Message-ID: <aGZD/1EXudZKwJXB@intel.com>
References: <20250702185332.43650-1-philmd@linaro.org>
 <20250702185332.43650-60-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250702185332.43650-60-philmd@linaro.org>

On Wed, Jul 02, 2025 at 08:53:21PM +0200, Philippe Mathieu-Daudé wrote:
> Date: Wed,  2 Jul 2025 20:53:21 +0200
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH v4 59/65] accel: Always register
>  AccelOpsClass::get_virtual_clock() handler
> X-Mailer: git-send-email 2.49.0
> 
> In order to dispatch over AccelOpsClass::get_virtual_clock(),
> we need it always defined, not calling a hidden handler under
> the hood. Make AccelOpsClass::get_virtual_clock() mandatory.
> Register the default cpus_kick_thread() for each accelerator.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  include/system/accel-ops.h        | 2 ++
>  accel/hvf/hvf-accel-ops.c         | 1 +
>  accel/kvm/kvm-accel-ops.c         | 1 +
>  accel/tcg/tcg-accel-ops.c         | 2 ++
>  accel/xen/xen-all.c               | 1 +
>  system/cpus.c                     | 7 ++++---
>  target/i386/nvmm/nvmm-accel-ops.c | 1 +
>  target/i386/whpx/whpx-accel-ops.c | 1 +
>  8 files changed, 13 insertions(+), 3 deletions(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


