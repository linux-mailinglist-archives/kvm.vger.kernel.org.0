Return-Path: <kvm+bounces-46015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 780ACAB0A96
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 08:30:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B537D1BA39B7
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 06:30:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C172266EFB;
	Fri,  9 May 2025 06:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XnCTc5Cq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16151238D3A
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 06:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746772215; cv=none; b=YRbV165K6HJ1lSlRGomz37rTCdCDbZMFFAtJLnmvGcDSpvwwO+sfDorrzDIIZVWHt3W1WrO3wHAEa8IuOjEFflQisPUDq9epIeXip64khSnTb1lAZBX3Re14eobo3B0Sgru5+Si2kgwmlRj081R8PpOsG/WXjy2dUSuTt/6gNcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746772215; c=relaxed/simple;
	bh=MwKGYQG9WPfO/eaUNra1yxomNX0ZRmzfFjJZWMYXPD8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PN2JngyE9LujOYDpV8Yv7M0ELt1mnD4Zz5dOlQoa0zwr1gCj3lINsQshrMk/119wXMcWbLfzzwIrXzlmLhMtcXffBT4JwPEM7vbdSdhe6ElpIwl5yG4gjTkghSwGPS6swTkkswOQs8uKy+nLTzMMTYOFzSOvmy4I1Tqyai2G0yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XnCTc5Cq; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746772213; x=1778308213;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=MwKGYQG9WPfO/eaUNra1yxomNX0ZRmzfFjJZWMYXPD8=;
  b=XnCTc5Cqju36iG7PNNYSdSpnOV/uLBGxX3Bef4V7s5NW4GBkxZuEsGII
   1Ie35K29LDzRmiwF298iNL9KpPNywlM48vt6gsbZZ/eHKajWQYF6/kbD1
   SmOicYddD98Aed8LzJCfVUr8AS6D0sODT18x2Law7ImBiW8S6mcsKmZAX
   27hZ+Alr0+lGZyOWe+j8DYU9KIfk4UOtR9KK6GKiviOxawUh6y72aSyzx
   v8HAbKU6JEvpdsva2spwbuaN4zGV4XLAsmUf7Pnfy35liT/t5/tqOUBS2
   10u1tTyyJTEeVsrUDmtpFeLA+elrkfbL5PnPsfl+K07vqvZF0am9vW12e
   Q==;
X-CSE-ConnectionGUID: e3p1bAEFRsyyW5bOibI2WQ==
X-CSE-MsgGUID: C3QmzbNvQ1iFNSh6JldZKQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48666601"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="48666601"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 23:30:12 -0700
X-CSE-ConnectionGUID: ntFz4u6uTvCcURBhCR8UiQ==
X-CSE-MsgGUID: wgmLekf5RmKGnRzsEc3R9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="159825084"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa002.fm.intel.com with ESMTP; 08 May 2025 23:30:05 -0700
Date: Fri, 9 May 2025 14:51:07 +0800
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
Subject: Re: [PATCH v4 06/27] hw/nvram/fw_cfg: Rename fw_cfg_init_mem_wide()
 -> fw_cfg_init_mem_dma()
Message-ID: <aB2l25PwH4e0jaTb@intel.com>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20250508133550.81391-7-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250508133550.81391-7-philmd@linaro.org>

On Thu, May 08, 2025 at 03:35:29PM +0200, Philippe Mathieu-Daudé wrote:
> Date: Thu,  8 May 2025 15:35:29 +0200
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH v4 06/27] hw/nvram/fw_cfg: Rename fw_cfg_init_mem_wide() ->
>  fw_cfg_init_mem_dma()
> X-Mailer: git-send-email 2.47.1
> 
> "wide" in fw_cfg_init_mem_wide() means "DMA support".
> Rename for clarity.
> 
> Suggested-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  include/hw/nvram/fw_cfg.h | 6 +++---
>  hw/arm/virt.c             | 2 +-
>  hw/nvram/fw_cfg.c         | 6 +++---
>  hw/riscv/virt.c           | 4 ++--
>  4 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/include/hw/nvram/fw_cfg.h b/include/hw/nvram/fw_cfg.h
> index d5161a79436..c4c49886754 100644
> --- a/include/hw/nvram/fw_cfg.h
> +++ b/include/hw/nvram/fw_cfg.h
> @@ -309,9 +309,9 @@ FWCfgState *fw_cfg_init_io_dma(uint32_t iobase, uint32_t dma_iobase,
>                                  AddressSpace *dma_as);
>  FWCfgState *fw_cfg_init_mem_nodma(hwaddr ctl_addr, hwaddr data_addr,
>                                    unsigned data_width);
> -FWCfgState *fw_cfg_init_mem_wide(hwaddr ctl_addr,
> -                                 hwaddr data_addr, uint32_t data_width,
> -                                 hwaddr dma_addr, AddressSpace *dma_as);
> +FWCfgState *fw_cfg_init_mem_dma(hwaddr ctl_addr,
> +                                hwaddr data_addr, uint32_t data_width,
> +                                hwaddr dma_addr, AddressSpace *dma_as);

There's one more use in latest master:

git grep fw_cfg_init_mem_wide
hw/loongarch/fw_cfg.c:    fw_cfg = fw_cfg_init_mem_wide(VIRT_FWCFG_BASE + 8, VIRT_FWCFG_BASE, 8,


