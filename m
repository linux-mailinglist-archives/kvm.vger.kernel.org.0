Return-Path: <kvm+bounces-46012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 230D4AB0A04
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 07:53:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 50831B20F79
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 05:51:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAF2026A0DB;
	Fri,  9 May 2025 05:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uyol+scD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC74C26A0A8
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 05:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746769824; cv=none; b=ZUu1yrJCO1da+inGJMXrIrEOvGftyDWvjTFidhCCiw/+y886mi/qYmnLscosfEE9mm79bpz9HYxsIH0X5NPJDWdU9Oci4V6gnlEMDQOCfvzIQWcf3+qf9sAM70IchCVOrwCvtszo7T0AWjlp98PH4f9qx/2h3CSxshzcHKFZ/uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746769824; c=relaxed/simple;
	bh=Qp3EPRPo70sgN1uj4hzL+wEQ51l0JjZrt2iWIfrv9rg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HzswwKQ0GHzf9i8Lrhiy1++m98PVQY09zt+MPKEJ12QTEdBHiNuos5GLX2AwqE4vOzGtr21SEpamd5HiIJuZoQr1vUCpI/ZgeUuZ3DPx6OBLj1NirG8ww7W+WouFSJCq/u1vV3lDIGfYWD8ACmyOU7zZ1fHBul88Pag/TbBwi9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Uyol+scD; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746769822; x=1778305822;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Qp3EPRPo70sgN1uj4hzL+wEQ51l0JjZrt2iWIfrv9rg=;
  b=Uyol+scDBLOURDCGFiPFXOVfloArOo6vl7xDwJ4w9PBwL+sU2pH7ZNmq
   vBHtGPFkcnU+HvveZ4/eOKIHmzXujEe/1QWOavIglhYsW3y/OzLerR00g
   qvzgejSZ+fXFfABU4nuh5Y0FXvkVC8tFgNTDsu3RIBtdl7msRQVAJRsuY
   MN3ZBzZTsH2OPMIybNEDmR/LNmgnsW3PoLSKC4/xEYI+2Jh2dTPQHxp70
   5aI/5nOwGBmrR+RogK54mD+G3aRRglVvJO/T6eUNcIwc9Xl8DTbz3g6jC
   Qa0YoVMVRUwZFOxH18p+bYljsgHqjjADEZcv39lS1RujP84XcKb3D90ud
   Q==;
X-CSE-ConnectionGUID: ieXU+wuIR1m+ZOTeGzFtDA==
X-CSE-MsgGUID: s7bgqpTWSwayZaPFkbvArg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="58800376"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="58800376"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 22:50:21 -0700
X-CSE-ConnectionGUID: I+FTBT90SwOiAl9LEgJUUg==
X-CSE-MsgGUID: IySnxT85QRubxpZ9cXnaAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="136525784"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa007.fm.intel.com with ESMTP; 08 May 2025 22:50:14 -0700
Date: Fri, 9 May 2025 14:11:15 +0800
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
	Jason Wang <jasowang@redhat.com>, Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v4 08/27] hw/i386/pc: Remove multiboot.bin
Message-ID: <aB2cgzGANdpFfEBd@intel.com>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20250508133550.81391-9-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250508133550.81391-9-philmd@linaro.org>

On Thu, May 08, 2025 at 03:35:31PM +0200, Philippe Mathieu-Daudé wrote:
> Date: Thu,  8 May 2025 15:35:31 +0200
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH v4 08/27] hw/i386/pc: Remove multiboot.bin
> X-Mailer: git-send-email 2.47.1
> 
> All PC machines now use the multiboot_dma.bin binary,
> we can remove the non-DMA version (multiboot.bin).
> 
> Suggested-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  pc-bios/optionrom/optionrom.h     |   4 -
>  hw/i386/pc.c                      |   1 -
>  pc-bios/meson.build               |   1 -
>  pc-bios/multiboot.bin             | Bin 1024 -> 0 bytes
>  pc-bios/optionrom/Makefile        |   2 +-
>  pc-bios/optionrom/multiboot.S     | 232 -----------------------------
>  pc-bios/optionrom/multiboot_dma.S | 234 +++++++++++++++++++++++++++++-
>  7 files changed, 233 insertions(+), 241 deletions(-)
>  delete mode 100644 pc-bios/multiboot.bin
>  delete mode 100644 pc-bios/optionrom/multiboot.S
> 
> diff --git a/pc-bios/optionrom/optionrom.h b/pc-bios/optionrom/optionrom.h
> index 7bcdf0eeb24..2e6e2493f83 100644
> --- a/pc-bios/optionrom/optionrom.h
> +++ b/pc-bios/optionrom/optionrom.h
> @@ -117,16 +117,12 @@
>   *
>   * Clobbers: %eax, %edx, %es, %ecx, %edi and adresses %esp-20 to %esp
>   */
> -#ifdef USE_FW_CFG_DMA
>  #define read_fw_blob_dma(var)                           \
>          read_fw         var ## _SIZE;                   \
>          mov             %eax, %ecx;                     \
>          read_fw         var ## _ADDR;                   \
>          mov             %eax, %edi ;                    \
>          read_fw_dma     var ## _DATA, %ecx, %edi
> -#else
> -#define read_fw_blob_dma(var) read_fw_blob(var)
> -#endif

It seems read_fw_blob() could be dropped as well and this is not a big
deal. So,

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


