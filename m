Return-Path: <kvm+bounces-46032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B4ABAB0DCD
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 10:51:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E42EF1635AB
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 08:50:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 223C326FA57;
	Fri,  9 May 2025 08:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MSk+RrOR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4568027057A
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 08:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746780623; cv=none; b=KMHDJEv/O+MkrZKCUOtfdBBh1Oe9Z8fDsRkDkTQngIwXvi1eGd9UaHC/Lw464ZGAiRDpix7hBQQxnd+2WqQ0P527Zx4K3wgXDx+hOAxuUWuEMkSQmY4QEVoDlqhidqNUE3wFeCOSSWWVecEj32FHuwnEs6/FEJP4cHp9lsNarTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746780623; c=relaxed/simple;
	bh=frJ8xDYf5dCgwXDohsd3IDh9hXwJr3cVlXyTzjKPOJA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OpxtPo6a61kxswPTEVzb35KfBSY4zWqSSi/vopT+SZjX0qBRzrBsxN73zb0xxrcUCuK3vm4reAE/c7Y60rdD3rHbnc5iUaInWTTF0EcHIpdHYjBuUoN7ACOy9IJ3nzCzWgR7Z9UM+G/ztEA+avBjFCqh7+6eIk0Ced4YwUbYNF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MSk+RrOR; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746780622; x=1778316622;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=frJ8xDYf5dCgwXDohsd3IDh9hXwJr3cVlXyTzjKPOJA=;
  b=MSk+RrORrvYC7pC0gDM+eye4CxxqEG+7i3w4zWg83VFmxWRsNeFrrR5e
   N7+D88iUNFaxgwR4YwNtistsPGlieRdyuv4DRkU3sprjXKsBQ1Ivr7FYc
   kI/FDXUAm5OkTfoSiGSwVpBlff/1wyPTztLSTeQfv1PJSNqE3q2n/q7+L
   fXDj5YxDKIhz5hMOeMBc4OcDPyqYYJZm1KnapT2T0pdZPEvCKkJjGw4Vu
   blNZaoamaQmIFfhx7EXsy+ikPAqacDd+rBpOUvHmunOtBx6iksf1702Fo
   x9aLhM29eZEHPeYTPIelKGTNghJ6BDwUeln/PSRTFZakmWGsED+BdUOco
   g==;
X-CSE-ConnectionGUID: aIQ4YU5FTSeB4T4hmZAQLg==
X-CSE-MsgGUID: Amfmf1WuTQ2yg4q0BjfIcw==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="66005251"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="66005251"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 01:50:19 -0700
X-CSE-ConnectionGUID: OMtp7xesTVq/J5C7ScuQFg==
X-CSE-MsgGUID: 4CmTpZuORRSlXGdxVuxfhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="159855159"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa002.fm.intel.com with ESMTP; 09 May 2025 01:50:11 -0700
Date: Fri, 9 May 2025 17:11:13 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org, Sergio Lopez <slp@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>, Yi Liu <yi.l.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-riscv@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>, Amit Shah <amit@kernel.org>,
	Yanan Wang <wangyanan55@huawei.com>, Helge Deller <deller@gmx.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Ani Sinha <anisinha@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?iso-8859-1?Q?Cl=E9ment?= Mathieu--Drif <clement.mathieu--drif@eviden.com>,
	qemu-arm@nongnu.org,
	=?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v4 20/27] target/i386/cpu: Remove
 CPUX86State::enable_l3_cache field
Message-ID: <aB3GsY71YH4usdSi@intel.com>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20250508133550.81391-21-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250508133550.81391-21-philmd@linaro.org>

On Thu, May 08, 2025 at 03:35:43PM +0200, Philippe Mathieu-Daudé wrote:
> Date: Thu,  8 May 2025 15:35:43 +0200
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH v4 20/27] target/i386/cpu: Remove
>  CPUX86State::enable_l3_cache field
> X-Mailer: git-send-email 2.47.1
> 
> The CPUX86State::enable_l3_cache boolean was only disabled
> for the pc-q35-2.7 and pc-i440fx-2.7 machines, which got
> removed.  Being now always %true, we can remove it and simplify
> cpu_x86_cpuid() and encode_cache_cpuid80000006().
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  target/i386/cpu.h |  6 ------
>  target/i386/cpu.c | 39 +++++++++++++--------------------------
>  2 files changed, 13 insertions(+), 32 deletions(-)
> 
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index b5cbd91c156..62239b0a562 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -2219,12 +2219,6 @@ struct ArchCPU {
>       */
>      bool enable_lmce;
>  
> -    /* Compatibility bits for old machine types.
> -     * If true present virtual l3 cache for VM, the vcpus in the same virtual
> -     * socket share an virtual l3 cache.
> -     */
> -    bool enable_l3_cache;
> -
>      /* Compatibility bits for old machine types.
>       * If true present L1 cache as per-thread, not per-core.
>       */

I realize this is another special case.

There is no support for hybrid x86 CPUs in QEMU, but it's also true that
there are some actual modern x86 Client CPUs without l3 cache, such as
Intel MTL's low power E core (and it has vmx support, i.e., support KVM).

So I think we can keep this property as well, to have some more
configuration options for users' emulation.



