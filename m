Return-Path: <kvm+bounces-46052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A70FAB0FB4
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 11:59:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0225A9C4137
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 09:58:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 850CA28DF53;
	Fri,  9 May 2025 09:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jldv0FcS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E107B2676FE
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 09:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746784744; cv=none; b=RaAoZsII5avZCDtVBJ++AFatidWJ5UP8rZ9uGXluXSPwDeDw0MQWWZ9Zgz5n0pbjfeYU8YqOACxaY4SjtzycrcY5/yQ5SqxoeSoihPB4PEyOgzQ6NMZMu1hkIq8Z/qvc4GzjrOib7CV3fO5B+oZMZ3MeVB2P7RmeWFwLxhnujZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746784744; c=relaxed/simple;
	bh=FrtgzPushvTfBtYzrA4xryV0T5y0Ofrk1OzBI442UsA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W/vsY8JEBDxn1Su/So+mJl9G1szJBB7npemFTPFFzXBlW2Lldm2SzvxfVpq8m0C/+QwK/RxgJiWMfDpYvnphJpfWVAL3rvuTv7OnkjLFXHGi/RILNq6wQgA678bg/y9KO8TvHV7X3b88/5J5B45HGPKpiROuDCmu3qErGryE4L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jldv0FcS; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746784743; x=1778320743;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=FrtgzPushvTfBtYzrA4xryV0T5y0Ofrk1OzBI442UsA=;
  b=jldv0FcSLqdkk2+miLitmlcBvWS8wf1fU4fcyUqdh0fSLfPaiI7qy8kK
   ZG44hDoP7qCwJ/IN37C5ID1xNa1zIJ309mWsrlzST2KBWETbR6GuUg4So
   u619UFar3d7F620baRGzT16Dk3C643pJSuQsC3EWOmOamVqecox5FhZSa
   aAMgev9pe/3o+xBrd1sooQD92KtmuYFUs1Zth+iEnlnxzLHbSWRayg4Hi
   EL5GqvSnvebsgUX2b5aAd1sv9ltRArsjoDnG1Nhqr8CS2+nMZ6X0sqA5O
   OPgDaugrEQMWc+kpTn2zDQIytsaZlNrG41sqqyi+BBAu+PdBl/6Krh/Os
   w==;
X-CSE-ConnectionGUID: 0fX4TXi/RFKpfD5hTqJRaQ==
X-CSE-MsgGUID: 80WK1V5sQm2CHp3s+tZ5Kw==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="51263050"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="51263050"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 02:59:02 -0700
X-CSE-ConnectionGUID: QWtv1rnXQuKrD0DM8sgCQA==
X-CSE-MsgGUID: iX3VjJpPSQSoXwK10eontg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="141524192"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa004.jf.intel.com with ESMTP; 09 May 2025 02:58:54 -0700
Date: Fri, 9 May 2025 18:19:56 +0800
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
Subject: Re: [PATCH v4 27/27] hw/virtio/virtio-pci: Remove
 VIRTIO_PCI_FLAG_PAGE_PER_VQ definition
Message-ID: <aB3WzIjvBmE1SjI9@intel.com>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20250508133550.81391-28-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250508133550.81391-28-philmd@linaro.org>

On Thu, May 08, 2025 at 03:35:50PM +0200, Philippe Mathieu-Daudé wrote:
> Date: Thu,  8 May 2025 15:35:50 +0200
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH v4 27/27] hw/virtio/virtio-pci: Remove
>  VIRTIO_PCI_FLAG_PAGE_PER_VQ definition
> X-Mailer: git-send-email 2.47.1
> 
> VIRTIO_PCI_FLAG_PAGE_PER_VQ was only used by the hw_compat_2_7[]
> array, via the 'page-per-vq=on' property. We removed all
> machines using that array, lets remove all the code around
> VIRTIO_PCI_FLAG_PAGE_PER_VQ (see commit 9a4c0e220d8 for similar
> VIRTIO_PCI_FLAG_* enum removal).
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
> ---
>  include/hw/virtio/virtio-pci.h |  1 -
>  hw/display/virtio-vga.c        | 10 ----------
>  hw/virtio/virtio-pci.c         |  7 +------
>  3 files changed, 1 insertion(+), 17 deletions(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


