Return-Path: <kvm+bounces-65114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08300C9BBC7
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 15:14:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BB1C3A083E
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 14:12:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D66B3242A3;
	Tue,  2 Dec 2025 14:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ROuULJyO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9553627E7EC
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 14:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764684763; cv=none; b=TexRq48qLnl7tWyLMSNvthEsL13OGn+SvCyrnsbKaNheRtioOZN9Aw+AmnTPsX2fhnbyPfzVOMv+im53TnCjRWAE6M8gyuIHQVlV4NTfa/AkFEQOjraBrLZtm5Ytv+ocl1if2gqavKkdgsUKZRd0joh3UAlTHCY++pUT2Fp1e3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764684763; c=relaxed/simple;
	bh=aJaYH3znAEtvfWy8ObOCzqWUUuF3YuHU7SuXuJqKynQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NCavpU0QYejT29WI1v1O5ja1eoBSVZqDvjj0WzHaTlWNnHMtwrCVSC7SirV6tm/sCrRKg9jXrsB/k+wLFZXQgygHmJ7EUcEPbVIoNCEEXhwMSn1hhtIKSBbbbDowrxHieT1U+dH8WxlPpZRVTcogxuQDhMCzMR+KV65EtzZTzEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ROuULJyO; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764684762; x=1796220762;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aJaYH3znAEtvfWy8ObOCzqWUUuF3YuHU7SuXuJqKynQ=;
  b=ROuULJyOQ6W3IrtC+PH3z6HI/jd/0h/PaHsDxmJ2nfg/RmhbuavsdhWa
   wkgI94Gy4K3lhP6QYYurcUMxkk8JjBQzEmQhRuUpZxTgXPEGew8qd8Hqo
   vwDgSklqoj32xFrNhIZXltQ40Ixf/jG8PqzLTva8O3IAmhE/o09zQYPYB
   pqms/ur9J71Ls3Yy3IVx4oJOwlA6EAxq5TFUJXF0OTDPuXJ1wDuqqIGJR
   7USv5ccrJN/PvmeO5vlHuqYkTU6ONOMR5D3Pzbi5dcdvTghq24tLy/hXa
   dYjAYrvRvYOTA9hSbmQUHmTjc3YLQS/dc+O4Do2hQB4ZBM6Ks0yfNZzoG
   w==;
X-CSE-ConnectionGUID: klB+3wpaSi6tNKbbN00Biw==
X-CSE-MsgGUID: Mp2Hy2j7SVuos2k+nNldzg==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="69244849"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="69244849"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 06:12:41 -0800
X-CSE-ConnectionGUID: AsDAqZKXTPKEo4/369JIMA==
X-CSE-MsgGUID: Gz3JRl+JRD++Z8OWe6OqgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="195194782"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa010.fm.intel.com with ESMTP; 02 Dec 2025 06:12:34 -0800
Date: Tue, 2 Dec 2025 22:37:17 +0800
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
Subject: Re: [PATCH v4 05/27] hw/nvram/fw_cfg: Factor
 fw_cfg_init_mem_internal() out
Message-ID: <aS75nb+h31F8uZuc@intel.com>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20250508133550.81391-6-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250508133550.81391-6-philmd@linaro.org>

> +FWCfgState *fw_cfg_init_mem_wide(hwaddr ctl_addr,
> +                                 hwaddr data_addr, uint32_t data_width,
> +                                 hwaddr dma_addr, AddressSpace *dma_as)
> +{
> +    assert(dma_addr && dma_as);
> +    return fw_cfg_init_mem_internal(ctl_addr, data_addr, data_addr,
                                                            ^^^^^^^^^
a typo: data_width...The type was converted "silently", making it easy
to be missed.

> +                                    dma_addr, dma_as);

Thanks,
Zhao


