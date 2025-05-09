Return-Path: <kvm+bounces-46003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B83AAB07E8
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 04:29:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13AE116C27E
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 02:29:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A51524466B;
	Fri,  9 May 2025 02:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JmjDBPVO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521DA13E02D
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 02:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746757736; cv=none; b=S7zUZEi6+HaAAKdwknBlR+mtitrq1sMeQJ8fJ0t58u85ZYHQy+u8lwklO95X5HUYfMGP1ClKip4a2k9ERn/iZEUwYQ1bDd/8oFf6sTyHmLNfe6jR/pHeceZJdMD5UbYusN9ipE/vT2GgSc6pnXloKnCcD5YgOBu2uS8k6CscJGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746757736; c=relaxed/simple;
	bh=RMprCGbtdSV40HLQjrF+qRBk02ekzXK5EPWksg+SrrM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JsKqIRQQxfZN915OzB7DootmuHwl4t+f8Oal1KNZt48V7+CeUIRfIbzYoVnfSrceK8VowB/eHKk7aktAU2RsYH0KkvLRCkovayRBMiulX3HlOsg94ax/99V8LWTrC4Xa4nSU15ojt0bczuSa1I7GIzbMdRNQ7VQBmh0HnQNeZZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JmjDBPVO; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746757734; x=1778293734;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=RMprCGbtdSV40HLQjrF+qRBk02ekzXK5EPWksg+SrrM=;
  b=JmjDBPVO8KypqzqHLQEwrjEi7k+vQfNJ+0D4dFTyqJvkyRW7VBErxdwL
   9f54hfN8KK8MSP65oAVEwe9e9hcpOnu75FaXjkjQnGxLIhlW5/ZYQEE+z
   nWo++sB0oNnQHsvp+2/LzpJJaIgcZdkqWf/dWV+EmW1SP4taqNcU8dCqO
   Txtt0GgWwgDgwLofnZThCXQB986yW3FTn4ux4b5nPvRInSPZd6k3d6Dtt
   SOeN+mEfXoxpM+w2gYZhYoFgLIJMp05VRWPebMNzAtD/wgJ3XP0NBNNSk
   E6p3XsgErA9ZGqg2YO+aElqyDulhz2srMrjyo4VniwcpnJaaHLqdW6U0M
   g==;
X-CSE-ConnectionGUID: apUlp2CHSyuZZknsUT1+wQ==
X-CSE-MsgGUID: tsiPp4I4Sb2fywzSxmoIkg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48683052"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="48683052"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 19:28:53 -0700
X-CSE-ConnectionGUID: 4cioW0uESkCHgfQCf0s58Q==
X-CSE-MsgGUID: CXGlrR/DRviiDer3bjIwEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="136183450"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa009.jf.intel.com with ESMTP; 08 May 2025 19:28:47 -0700
Date: Fri, 9 May 2025 10:49:48 +0800
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
Subject: Re: [PATCH v4 04/27] hw/mips/loongson3_virt: Prefer using
 fw_cfg_init_mem_nodma()
Message-ID: <aB1tTCJ2isIYbiIt@intel.com>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20250508133550.81391-5-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250508133550.81391-5-philmd@linaro.org>

On Thu, May 08, 2025 at 03:35:27PM +0200, Philippe Mathieu-Daudé wrote:
> Date: Thu,  8 May 2025 15:35:27 +0200
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH v4 04/27] hw/mips/loongson3_virt: Prefer using
>  fw_cfg_init_mem_nodma()
> X-Mailer: git-send-email 2.47.1
> 
> fw_cfg_init_mem_wide() is prefered to initialize fw_cfg
> with DMA support. Without DMA, use fw_cfg_init_mem_nodma().
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  hw/mips/loongson3_virt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


