Return-Path: <kvm+bounces-46016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D4B09AB0A9B
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 08:33:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2BCC91B62CC1
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 06:33:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF9F326AAA5;
	Fri,  9 May 2025 06:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hO3IDFCo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF2E18DF8D
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 06:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746772378; cv=none; b=esu+6AohGSAObxsLdx5tQekUab1ocOdJRS7NrPIa0LOzKH+vU2wYigobT7z26ixZCz1PwNKUGHA7gLg9TL25Sk22T0NR34q7pn+vUn5LlLuxaUrbXW1TTvsmWpgTxZuSWmG91KxHlXbjVnZGv8fQkBlD9K5862rmp4vcRQiy9d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746772378; c=relaxed/simple;
	bh=6EFiaT0nYvORCtcVuWMkfjhgQbjVLv9V1cMeI30pMKI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Za8I7b/AEpGeqk2W29VA0YtGsx2ZcHDGwNx1VjEWWbx1ztvDyqduJpvOHQBOFRbbhT0vU9jIJW53Uuxd676t7CbQaasdvue53a/SMN7/U/SlvGeYtN17XX3UCFm5px5XshQzZOT3sOPi/06BeM10OEbE1MI0Eyv3lH8gTYOJDZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hO3IDFCo; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746772376; x=1778308376;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=6EFiaT0nYvORCtcVuWMkfjhgQbjVLv9V1cMeI30pMKI=;
  b=hO3IDFCoI/l2nwit3kjOcidiPhcttooUx8p4So0AQlpXnx7WN0GDM7XR
   oG4FPbWzhO58m//IM6bo8bmwG8O0Tc+y49j87w9ONjnccfEE540RCqDyR
   SiidroCSP8gDg4YV9TsOuI2gF4OE5MEKMjPepMG77WA8MC8zFvA2hl9Kw
   BhK7CMle7wjTK90a9rt8+bIdaamlY9V7NOoPqPDk0BF+rIH3JOAaWM/kE
   Kut/ZNHpUK6kx9+1ftG7gEamgcxcu02Y3hGvjW2ZQJMuedafMB1bRNBCk
   ldI4DT7QSwg5t3uefazRUaeedeedZNDO61u5Bm/NVy/EKTX41UefwyzEz
   w==;
X-CSE-ConnectionGUID: HwTKaNpLSxunxTa1zTrdnA==
X-CSE-MsgGUID: u7aFjiJmSj62XAgQjLdfsw==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48737052"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="48737052"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 23:32:55 -0700
X-CSE-ConnectionGUID: awG5SpBiR5OmJ7es03eNog==
X-CSE-MsgGUID: 3vPGJfzmToOTqbYQ0fgKXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="141299293"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 08 May 2025 23:32:48 -0700
Date: Fri, 9 May 2025 14:53:50 +0800
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
Subject: Re: [PATCH v4 10/27] hw/i386/pc: Remove linuxboot.bin
Message-ID: <aB2mfvdqMOImbNcQ@intel.com>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20250508133550.81391-11-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250508133550.81391-11-philmd@linaro.org>

On Thu, May 08, 2025 at 03:35:33PM +0200, Philippe Mathieu-Daudé wrote:
> Date: Thu,  8 May 2025 15:35:33 +0200
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH v4 10/27] hw/i386/pc: Remove linuxboot.bin
> X-Mailer: git-send-email 2.47.1
> 
> All PC machines now use the linuxboot_dma.bin binary,
> we can remove the non-DMA version (linuxboot.bin).
> 
> Suggested-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  hw/i386/pc.c                  |   3 +-
>  pc-bios/meson.build           |   1 -
>  pc-bios/optionrom/Makefile    |   2 +-
>  pc-bios/optionrom/linuxboot.S | 195 ----------------------------------
>  4 files changed, 2 insertions(+), 199 deletions(-)
>  delete mode 100644 pc-bios/optionrom/linuxboot.S

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


