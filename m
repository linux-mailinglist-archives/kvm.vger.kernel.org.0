Return-Path: <kvm+bounces-66218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DEC10CCAA36
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 08:26:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 93A2130652D7
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 07:24:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8E221E5B88;
	Thu, 18 Dec 2025 07:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="laa656pg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7304972634
	for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 07:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766042655; cv=none; b=Uxoth6KbTYHOxa1sxdLLGbEIPVcbHiQcRHrk3UwXKTkk7SP/LnCdr02cXQN3DrEzlBImU1C7y1bZHIJPDgZnKetmUYf87dGXN5r4T5E8r2Ak6EzKwL0Vvv80QJUP+doClMBL3q6birYx0IscCR+5JqLCTyww91A0snfiuHTtxmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766042655; c=relaxed/simple;
	bh=7DwI0Qs8ZZROCxgks932LOqBfATLVNdCypOv4og2tA4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AmHPNgWcwAUqNFCy/7vE8x5XvrhLXizo9f19ETPfUrDl94W2oFY+IaKw6jt/D8GDDdjxp9UhbeIV8aoIKqGfDJpIcaNwq15NvwW4TO/qS/QZ1OmQFKEiShnSvtT4UoP4Nb4LjYgdiPOJ0DT5yrSC3LXPhJ8X8AuBZ/trpDSkuD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=laa656pg; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766042655; x=1797578655;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7DwI0Qs8ZZROCxgks932LOqBfATLVNdCypOv4og2tA4=;
  b=laa656pg5dh0xwqzJeGJQv+gTOuJucxCMFQjJR+OuW92MvpxdUu1moft
   bf6QO+9GKjqYGcJVE5OE0BQhGUP2twu9HX+AB89SMsawGyCvgmE9nyB7Z
   HqVHdnHFYhiRY+P49NzCZQce54B/AZoA0OkQvYUX7zJ1a/ucJR1OKGeoZ
   4ultwNyRkisLnywgMiV6FSA8FkiWguunaM3/6Z8Q16aiB/lDFFfCvRmaz
   vNzEaEGdJABTqKXRJeHiLS/fXiHA/ULqC7aYuLbcfcLaAR2/x3nh4WHTL
   IQRlWBc5ECyv9zYNE+MfKUY2JPs0gHUlp1hZRHp4QNlwKDJI5sjtUOjIC
   Q==;
X-CSE-ConnectionGUID: 8CFUbt7bRVixRZPB5+dsUg==
X-CSE-MsgGUID: Wy/PU/+dTYWsapayEmbl6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="67960045"
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="67960045"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 23:24:14 -0800
X-CSE-ConnectionGUID: sxbUkqeGSCCx2CAtSkrTbQ==
X-CSE-MsgGUID: oV8BMOWXTn2tBLC3VqwuDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="202898882"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa005.fm.intel.com with ESMTP; 17 Dec 2025 23:24:06 -0800
Date: Thu, 18 Dec 2025 15:48:55 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Thomas Huth <thuth@redhat.com>, qemu-devel@nongnu.org,
	devel@lists.libvirt.org, kvm@vger.kernel.org, qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Sergio Lopez <slp@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>, Yi Liu <yi.l.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>, Amit Shah <amit@kernel.org>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Yanan Wang <wangyanan55@huawei.com>, Helge Deller <deller@gmx.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Ani Sinha <anisinha@redhat.com>, Fabiano Rosas <farosas@suse.de>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?iso-8859-1?Q?Cl=E9ment?= Mathieu--Drif <clement.mathieu--drif@eviden.com>,
	=?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Mark Cave-Ayland <mark.caveayland@nutanix.com>,
	BALATON Zoltan <balaton@eik.bme.hu>,
	Peter Krempa <pkrempa@redhat.com>,
	Jiri Denemark <jdenemar@redhat.com>
Subject: Re: [PATCH v5 07/28] tests/acpi: Update DSDT tables for pc machine
Message-ID: <aUOx5wor+ysd2lNo@intel.com>
References: <20251202162835.3227894-1-zhao1.liu@intel.com>
 <20251202162835.3227894-8-zhao1.liu@intel.com>
 <20251217151627.3ee7bf07@imammedo>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217151627.3ee7bf07@imammedo>

On Wed, Dec 17, 2025 at 03:16:27PM +0100, Igor Mammedov wrote:
> Date: Wed, 17 Dec 2025 15:16:27 +0100
> From: Igor Mammedov <imammedo@redhat.com>
> Subject: Re: [PATCH v5 07/28] tests/acpi: Update DSDT tables for pc machine
> X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
> 
> On Wed,  3 Dec 2025 00:28:14 +0800
> Zhao Liu <zhao1.liu@intel.com> wrote:
> 
> > Now the legacy cpu hotplug way has gone away, and there's no _INIT
> > method in DSDT table for modern cpu hotplug support.
> > 
> > Update DSDT tables for pc machine.
> > 
> > The following diff changes show only _INIT methods are removed from DSDT
> > tables.
> > 
> 
> below diff in commit message confuses git am,
> I'd suggests to point out only what's deleted  
> and skip the rest, aka.
> removed section in x86 DSDTs:
>   -
>   -            Method (_INI, 0, Serialized)  // _INI: Initialize
>   -            {
>   -                CSEL = Zero
>   -            }
> 
> ditto for blurb in the next patch

Yes, good idea. Indeed, this nearly duplicated information makes the
commit message quite lengthy, so I had to split it into two patches.

Will merge these 2 patches (this patch and next patch).

Thanks,
Zhao

