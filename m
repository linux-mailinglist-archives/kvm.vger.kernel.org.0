Return-Path: <kvm+bounces-51389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C37C9AF6CC1
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:25:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7176E3A8E85
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 08:24:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A65162D0C6E;
	Thu,  3 Jul 2025 08:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="goYDY+Cr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE872DE708
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 08:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751531091; cv=none; b=rQOev8gnzonoJxklqyUyr++HAHg9dgja3sQablMp4Nmaxc/KLrV4F1SxtcsHFVjRJAJssDD9xJEzHuKAn4URC4cnJ5/JNzOKrGeM/q4tVCIoIZbvP/hJwhX6KviKe9DEox2l/yU03x29llUT5x8rKYlSNraiS+MtwOACxC+FKUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751531091; c=relaxed/simple;
	bh=OL7YB4QqrsOIrbmMdhLO6b5EBpFpjMPIWAfHz4kxYTk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BoRNS4SDRG3qfmscR+r/XpKEstG2YWCYZ1fWFM+Wm+Y2bn/5A+Nli6o4ZgHZAyuVOCB+VsyLzzimPdtM35n7nzPfG5s/m38MoKeSJbHFWM3f/JGW6sW005A2jKm9ZrlDA36F1BlUJWtnG4hb7oFL1mmDD8wOrH03K+Of+DFvwhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=goYDY+Cr; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751531090; x=1783067090;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=OL7YB4QqrsOIrbmMdhLO6b5EBpFpjMPIWAfHz4kxYTk=;
  b=goYDY+CrWbX+J6iXaxIyAmS8LcdO6AFUyiU0UzITDJ9fJUJMkfXArFFp
   fXrNofUuTq8KFpIkik7BYaNc4ixTqQDg7/Y/74FKIUYwl1aDKn6AKcYEU
   XSeRkq+5T3z7JKmLn6WxOtWNsaHwNhyZm9okOFuI6SXBDN9fdItsv81bo
   8LQHk+uUmyAMDczFZ5UjaSmZCQWKeVfcETeOUKaeLW57LZFPDh71XUHEJ
   JQo7FJ2Wa/xVmwVqusIgjC6ONtCJB2+XXMPOUsZZA1cQn5Oyz8V9QBJPl
   pwv40Q4Q2P2nKRATRxUIr/U+dNHs85dkxTp2KwCwgoSLExWs2S0eSDv8x
   Q==;
X-CSE-ConnectionGUID: /U70m2P1QBSLRuHjS1HN5Q==
X-CSE-MsgGUID: 2+i/F64vSSOdyro/4iJLIA==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="64897784"
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="64897784"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 01:24:50 -0700
X-CSE-ConnectionGUID: K/Lh4bp/RTiD0Ygz1JEFag==
X-CSE-MsgGUID: enRRDQADQwmF7whpYfHbxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="158577105"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa005.fm.intel.com with ESMTP; 03 Jul 2025 01:24:46 -0700
Date: Thu, 3 Jul 2025 16:46:12 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Fabiano Rosas <farosas@suse.de>,
	Laurent Vivier <lvivier@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>, kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v4 57/65] accel: Always register
 AccelOpsClass::kick_vcpu_thread() handler
Message-ID: <aGZDVG3775oKYQmI@intel.com>
References: <20250702185332.43650-1-philmd@linaro.org>
 <20250702185332.43650-58-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250702185332.43650-58-philmd@linaro.org>

On Wed, Jul 02, 2025 at 08:53:19PM +0200, Philippe Mathieu-Daudé wrote:
> Date: Wed,  2 Jul 2025 20:53:19 +0200
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH v4 57/65] accel: Always register
>  AccelOpsClass::kick_vcpu_thread() handler
> X-Mailer: git-send-email 2.49.0
> 
> In order to dispatch over AccelOpsClass::kick_vcpu_thread(),
> we need it always defined, not calling a hidden handler under
> the hood. Make AccelOpsClass::kick_vcpu_thread() mandatory.
> Register the default cpus_kick_thread() for each accelerator.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  include/system/accel-ops.h | 1 +
>  accel/kvm/kvm-accel-ops.c  | 1 +
>  accel/qtest/qtest.c        | 1 +
>  accel/xen/xen-all.c        | 1 +
>  system/cpus.c              | 7 ++-----
>  5 files changed, 6 insertions(+), 5 deletions(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


