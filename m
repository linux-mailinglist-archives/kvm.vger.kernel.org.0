Return-Path: <kvm+bounces-46055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CFD0BAB1003
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 12:11:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 039EB1C253B1
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 10:11:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D4EF28E5E4;
	Fri,  9 May 2025 10:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HLQeEdYs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9310028E5E3
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 10:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746785473; cv=none; b=efviuX09fxCiar9OgS+a5PNkHasOnsRhWarlV1oq/Llrf7dv8Y8DFHHucb7pZ2VyYP9+xyAVhZOu+8xbx0LXNIKwjAFEnbna1rAhs6c//gDQCuIpg0TtoObi3dhWTpT3r2WKm02GYG1ZruA5mSTo8CNcIG+dgfaVMr8DTbqgF74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746785473; c=relaxed/simple;
	bh=DYzgfmr2nHUFnRtfKx2VUV7W2FkMFo4CpLIHKoL2k0I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mHLDO5o6R786b6AbAPqkEpDuNGQOizF0DWAJ9EGQcUWenfFv93YDDGzrNMVDxXo8ZKyBRpsp2TqpBr0stvUYUQvyhHigPThFlghaCrYlSxEfGMzKhtlrMCEYKVKYyB1wd4ePDR9FGv1YGommxDr2RT8I1zbEsIZz7q6kiT1zJ1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HLQeEdYs; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746785471; x=1778321471;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=DYzgfmr2nHUFnRtfKx2VUV7W2FkMFo4CpLIHKoL2k0I=;
  b=HLQeEdYseJ2qq3XsUXd+M6kSGEvOTEmXD4E6m1c+02SGPv6R7t+ciVFR
   UB1BK8lOSZvXRijYIkNpTalTCQy9seK0Jh00hi8oF6HYDUt9ZJnIUznrq
   kbPvjhUM+fpsQll+SD+bjLihAH95tbvTUWebMk9zitgcKbFoG121ynExK
   D6ET+n+aMFNWZYJWLWur3l0xLi2xCWKx96BGg9sKydK7c8ASlaogn4KGz
   9XW0LhXu5gdBD0m0OZUcZbfNoSIC8qcOl2TLDQ3RotFsfoQGTOscjfk75
   7NsuG0WSdhDuq+Q4akLCp6kF6Hm/dIrGcdoj2ebzHubupRppUaPzeemXT
   g==;
X-CSE-ConnectionGUID: l1sGLwSJQaCMxsupBKJQlQ==
X-CSE-MsgGUID: n/IlRBxGSYOlJbhljiMsdA==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="66013416"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="66013416"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 03:11:10 -0700
X-CSE-ConnectionGUID: HKEkuJfoTV22rXlvJht/zw==
X-CSE-MsgGUID: 34wmXNVFQ0SpQaxijdq0mQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="137577882"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa009.fm.intel.com with ESMTP; 09 May 2025 03:11:02 -0700
Date: Fri, 9 May 2025 18:32:05 +0800
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
	Jason Wang <jasowang@redhat.com>,
	Mark Cave-Ayland <mark.caveayland@nutanix.com>
Subject: Re: [PATCH v4 24/27] hw/intc/ioapic: Remove
 IOAPICCommonState::version field
Message-ID: <aB3Zpc45+/OZ7hq2@intel.com>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20250508133550.81391-25-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250508133550.81391-25-philmd@linaro.org>

On Thu, May 08, 2025 at 03:35:47PM +0200, Philippe Mathieu-Daudé wrote:
> Date: Thu,  8 May 2025 15:35:47 +0200
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH v4 24/27] hw/intc/ioapic: Remove IOAPICCommonState::version
>  field
> X-Mailer: git-send-email 2.47.1
> 
> The IOAPICCommonState::version integer was only set
> in the hw_compat_2_7[] array, via the 'version=0x11'
> property. We removed all machines using that array,
> lets remove that property, simplify by only using the
> default version (defined as IOAPIC_VER_DEF).
> 
> For the record, this field was introduced in commit
> 20fd4b7b6d9 ("x86: ioapic: add support for explicit EOI"):
> 
>  >   Some old Linux kernels (upstream before v4.0), or any released RHEL
>  >   kernels has problem in sending APIC EOI when IR is enabled.
>  >   Meanwhile, many of them only support explicit EOI for IOAPIC, which
>  >   is only introduced in IOAPIC version 0x20. This patch provide a way
>  >   to boost QEMU IOAPIC to version 0x20, in order for QEMU to correctly
>  >   receive EOI messages.
>  >
>  >   Without boosting IOAPIC version to 0x20, kernels before commit
>  >   d32932d ("x86/irq: Convert IOAPIC to use hierarchical irqdomain
>  >   interfaces") will have trouble enabling both IR and level-triggered
>  >   interrupt devices (like e1000).
>  >
>  >   To upgrade IOAPIC to version 0x20, we need to specify:
>  >
>  >     -global ioapic.version=0x20
>  >
>  >   To be compatible with old systems, 0x11 will still be the default
>  >   IOAPIC version. Here 0x11 and 0x20 are the only versions to be
>  >   supported.
>  >
>  >   One thing to mention: this patch only applies to emulated IOAPIC. It
>  >   does not affect kernel IOAPIC behavior.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
> ---
>  hw/intc/ioapic_internal.h |  3 +--
>  hw/intc/ioapic.c          | 18 ++----------------
>  hw/intc/ioapic_common.c   |  2 +-
>  3 files changed, 4 insertions(+), 19 deletions(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


