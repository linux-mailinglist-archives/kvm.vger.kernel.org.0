Return-Path: <kvm+bounces-66312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E1E8CCEFC3
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 09:32:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F035730BAD74
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 08:27:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5D7D30F532;
	Fri, 19 Dec 2025 08:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JR+6Q+mR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CEB930EF8F
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 08:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766132411; cv=none; b=DKwcq0crv/N78MGkFaY0JZ1cRg/nXvUj2BWFNu16wlYOlsdb4HmBGdrUCHUGkeLb3QoKjx4fFT5/uENyNGh7+o/lBAJ3TilEcr8WbhYoVNlUuN4xk53geIF/DTpGxDmYuccjE7wuqKuBN57hONxpclrpUKMhgnpxj4qmqdZhJv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766132411; c=relaxed/simple;
	bh=rbqD8yaIdenCZwbjEjjw/OflDKuC2ytzzOoneMqP9Fc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jdPF9JI9j176gXKWei4igSDcf9x0BXVHrnM/Ai0BAPooBXnqVi5uDh46xhexI5FldCsMjI2DheCMvMXwDv90mUIfZaP/wv+i3wqxxVhnJhFcRzacL53pUYge6FQM2dtvWXt1EM/yK+2ws71XkRIt5GKZwJEZbTd5dyRqBUBMqN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JR+6Q+mR; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766132410; x=1797668410;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=rbqD8yaIdenCZwbjEjjw/OflDKuC2ytzzOoneMqP9Fc=;
  b=JR+6Q+mR/8Py8AeZpxjDqDb/wBsUS9mmDbuQ6VeexPXjlwgfTuLuVfQj
   M3FmD+VPDFjW/+B6YwyNRQIrUjLJTTUZJbku+fVfpeJ0a3UmgPgs5Ygdb
   Dm10GsPtn2soIxZmNuQ7pNvMS69sdU0i26X04mlZxBh1pEvkZzAiiAE6P
   vhEG2yQLaZMBQOieVBy4eR13SvWxeHoY3ZAEXXk0a6IryF0VixrTWkEci
   w7aiJnmEebxdEcKSxjIDyOmzeFNbLNwkMSIWDmsgYg5M4yXXTOd0mI6zQ
   jOmtH5dh1D/FsMYGL0iRr2OGC37swu1dOFqKcHvZyYJmAk4kQag3d1MGP
   Q==;
X-CSE-ConnectionGUID: O96MM6rGTDiwbBpvx+r0hw==
X-CSE-MsgGUID: /0sVO+PbRFqcyh8dO+F7sQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11646"; a="70662217"
X-IronPort-AV: E=Sophos;i="6.21,159,1763452800"; 
   d="scan'208";a="70662217"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2025 00:20:10 -0800
X-CSE-ConnectionGUID: /IV1u42/TVakiYPS8EdN1g==
X-CSE-MsgGUID: 7sbsnnn2QKuos6f3534EGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,159,1763452800"; 
   d="scan'208";a="203196386"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa005.fm.intel.com with ESMTP; 19 Dec 2025 00:20:01 -0800
Date: Fri, 19 Dec 2025 16:44:51 +0800
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
Subject: Re: [PATCH v5 16/28] hw/i386: Remove linuxboot.bin
Message-ID: <aUUQgyGDiwV7NC0U@intel.com>
References: <20251202162835.3227894-1-zhao1.liu@intel.com>
 <20251202162835.3227894-17-zhao1.liu@intel.com>
 <20251217155530.3353e904@imammedo>
 <aUOxBg3bVii1HAOx@intel.com>
 <20251218153333.6cb6e080@imammedo>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251218153333.6cb6e080@imammedo>

> > On Wed, Dec 17, 2025 at 03:55:30PM +0100, Igor Mammedov wrote:
> > > Date: Wed, 17 Dec 2025 15:55:30 +0100
> > > From: Igor Mammedov <imammedo@redhat.com>
> > > Subject: Re: [PATCH v5 16/28] hw/i386: Remove linuxboot.bin
> > > X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
> > > 
> > > On Wed,  3 Dec 2025 00:28:23 +0800
> > > Zhao Liu <zhao1.liu@intel.com> wrote:
> > >   
> > > > From: Philippe Mathieu-Daudé <philmd@linaro.org>
> > > > 
> > > > All machines now use the linuxboot_dma.bin binary, so it's safe to
> > > > remove the non-DMA version (linuxboot.bin).  
> > > 
> > > after applying this patch:
> > > 
> > > git grep linuxboot.bin
> > > 
> > >     option_rom[nb_option_roms].bootindex = 0;                                    
> > >     option_rom[nb_option_roms].name = "linuxboot.bin";                           
> > >     if (fw_cfg_dma_enabled(fw_cfg)) {                                            
> > >         option_rom[nb_option_roms].name = "linuxboot_dma.bin";                   
> > >     }        
> > > 
> > > perhaps it should be fixed in previous patch  
> > 
> > Thanks, I find this change was included in the previous patch (patch 15).
> 
> Yep, sorry for confusion. /I forgot to apply #15, hence it led to a stray linuxboot.bin/

You're welcome and thanks for your review!

Regards,
Zhao


