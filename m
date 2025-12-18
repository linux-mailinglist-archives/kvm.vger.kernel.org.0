Return-Path: <kvm+bounces-66217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 855D3CCA9D0
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 08:20:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 110C63011ABD
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 07:20:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C04E9330B28;
	Thu, 18 Dec 2025 07:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OaP7UQSI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5CC330B0D
	for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 07:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766042443; cv=none; b=VBuQ64y/BFyCeDAp0fnQQgkRcZGcSzWk6eMNgFRw9uhrRhpQR637J+y2v77pbiDMT8mYoGmW6xd0jvLkBJWLwdekle8hCxKWql2/WSUDr5imIQ87XmQli4497o+mrer0DDsDBWVUyn6LGlmGJUVjcIjhXOelf0PHjWIZPa2WUsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766042443; c=relaxed/simple;
	bh=WJEIgxu3+zm1akya5uEapVzOpJ64gXw/82xWr1E4ihU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UTLTiXznMLecdOKVHlCpJJ5AzATWVLZ6fOSsWhxCS8xwbgIrU1dWL8y9KRQmR+YEbXHg5UEjbmNMW7H6M3Dimd7fqNiwhLJjw7J/EiVkM4d3GwBE592xUBhxraDMT+tkjwzFdR14GV23yv3NKxkfpj/AfcZASCO9t3SeVNVtpIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OaP7UQSI; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766042441; x=1797578441;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=WJEIgxu3+zm1akya5uEapVzOpJ64gXw/82xWr1E4ihU=;
  b=OaP7UQSIHW8majestc+mvvpxEIK4ky49bPbcwNAmWmBW/NFC1MVcNZhw
   Yhlri6rERGjEKUL5yjWKxnqm4Tdb94Ch1o4rvudUA8JmhlRa8IpZQFA/o
   bwphBxUHSp1CPVDiREkcrA1/PyA8WxAMBpcfwS5Bt/9/FwcEFX4SXwLXI
   tyWu+rtuA79yA0xkw739UklXlGdnlQCHsRsggRFCs2jtSNCCVrcBL+IlA
   2kUT9E9HQxDqEUaqS0Wav4QvyIAiQQ82EjCqZqYgZpw91WqYis5KGz3Gm
   ExD2zQSUgjf3eJ3mFGQtW8KtOdqKiKLuRLYGcPwZTga1sH33KEJA1AcSO
   g==;
X-CSE-ConnectionGUID: l6yuq9qyTtGzt51zstkBrg==
X-CSE-MsgGUID: 67s1ZKQnRDSt0YdARaoPEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="66986695"
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="66986695"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 23:20:30 -0800
X-CSE-ConnectionGUID: Wvc3fFGoR+mxeHpJsuEI3A==
X-CSE-MsgGUID: L6Cpx68PQoy7+Y2uTiOR7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="203582897"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 17 Dec 2025 23:20:21 -0800
Date: Thu, 18 Dec 2025 15:45:10 +0800
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
Message-ID: <aUOxBg3bVii1HAOx@intel.com>
References: <20251202162835.3227894-1-zhao1.liu@intel.com>
 <20251202162835.3227894-17-zhao1.liu@intel.com>
 <20251217155530.3353e904@imammedo>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251217155530.3353e904@imammedo>

On Wed, Dec 17, 2025 at 03:55:30PM +0100, Igor Mammedov wrote:
> Date: Wed, 17 Dec 2025 15:55:30 +0100
> From: Igor Mammedov <imammedo@redhat.com>
> Subject: Re: [PATCH v5 16/28] hw/i386: Remove linuxboot.bin
> X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
> 
> On Wed,  3 Dec 2025 00:28:23 +0800
> Zhao Liu <zhao1.liu@intel.com> wrote:
> 
> > From: Philippe Mathieu-Daudé <philmd@linaro.org>
> > 
> > All machines now use the linuxboot_dma.bin binary, so it's safe to
> > remove the non-DMA version (linuxboot.bin).
> 
> after applying this patch:
> 
> git grep linuxboot.bin
> 
>     option_rom[nb_option_roms].bootindex = 0;                                    
>     option_rom[nb_option_roms].name = "linuxboot.bin";                           
>     if (fw_cfg_dma_enabled(fw_cfg)) {                                            
>         option_rom[nb_option_roms].name = "linuxboot_dma.bin";                   
>     }        
> 
> perhaps it should be fixed in previous patch

Thanks, I find this change was included in the previous patch (patch 15).

And I have a GitLab branch and hopefully it could help apply and review:

https://gitlab.com/zhao.liu/qemu/-/commits/remove-2.6-and-2.7-pc-v5-11-26-2025

Regards,
Zhao


