Return-Path: <kvm+bounces-66220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CF325CCAA8D
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 08:32:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A5B80302AB8D
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 07:28:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55C6E2C326D;
	Thu, 18 Dec 2025 07:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gjp2U1qI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9636218821
	for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 07:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766042887; cv=none; b=mj6OF06chzmeI+813xNgGxNTcA8wvzSkG9a+9/4jgrlx/myIubH+C3IlPCtZU9vfN9asT1EwtPHfqdoe/mf94pvrrWEfjjIBXTu3wM+j/wXv2l056UFfDiChy3J+K9wRAB/6ORK3eN3IsJNbD4peVnGISG3vC+VzX9mh7wI5wLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766042887; c=relaxed/simple;
	bh=hWNeVMjmF8yETmL2iScc7y+Xsno1MZFc4t4eczNLXrY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sAQ2HDgEodGf7Fh8Ml3Cg2ZDDQWa0IpRq6IX4hoKfLC+MXjN9HCf9poMorfMNqr+LovFs1f5AgBx9E2i4A4bdejse6m94/4hAGX92nsow9xpx2eWnPgr1fJuJo5VOX8kEyd5g/KiDFpwadqEEAz88xTenQSCOh5tgI5jJTz3sK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gjp2U1qI; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766042886; x=1797578886;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hWNeVMjmF8yETmL2iScc7y+Xsno1MZFc4t4eczNLXrY=;
  b=Gjp2U1qIKZ7DlTK8oArATCAwM/5OWpYnDg4UHYxnWlNRXtuuhX4Tp4Fl
   gTbOpgBKlrmRAxKci9xP9GeWBb7b9kK3L9pdrIfdtRyQJujqn5qpeaAv4
   1iQGcoU8wFo+Vi4m9I8iPkzxeEvHcAPWc8xa7UZ0I8ORqXRhfrf8HTpBz
   VP8wsXSdbnO32vpOazUipiPqARvLYKh4Om+WcjGYS5TzHxjz3FfKpwLJS
   0VD3VBgWiQNee1BoJXJPBvr+IwcYIIJHGX+7Cl80MlOVEgGck9gYB4j5Z
   +5tokp4A6qxnkZj89bMqVGPf4wSN3YEnyXIvlTNz8HuRt8chaCkWN9flo
   g==;
X-CSE-ConnectionGUID: GR/oPrnHS3uV7nl2EN8+og==
X-CSE-MsgGUID: fu4JY5VFRsqZvGECFSGHpQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="71622095"
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="71622095"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 23:28:04 -0800
X-CSE-ConnectionGUID: v88tZuomTSO56nWrPX/fYg==
X-CSE-MsgGUID: ulShamx1RQqj9xlNDkLIiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="229575059"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 17 Dec 2025 23:27:55 -0800
Date: Thu, 18 Dec 2025 15:52:45 +0800
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
Subject: Re: [PATCH v5 03/28] pc: Start with modern CPU hotplug interface by
 default
Message-ID: <aUOyzVHm+mt1pCfL@intel.com>
References: <20251202162835.3227894-1-zhao1.liu@intel.com>
 <20251202162835.3227894-4-zhao1.liu@intel.com>
 <20251217143237.7829af2e@imammedo>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217143237.7829af2e@imammedo>

On Wed, Dec 17, 2025 at 02:32:37PM +0100, Igor Mammedov wrote:
> Date: Wed, 17 Dec 2025 14:32:37 +0100
> From: Igor Mammedov <imammedo@redhat.com>
> Subject: Re: [PATCH v5 03/28] pc: Start with modern CPU hotplug interface
>  by default
> X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
> 
> On Wed,  3 Dec 2025 00:28:10 +0800
> Zhao Liu <zhao1.liu@intel.com> wrote:
> 
> > From: Igor Mammedov <imammedo@redhat.com>
> ^^^
> given you resplit original patch, it's better to replace this with you,
> keeping my SoB is sufficient

Thank you! Will re-organize these signatures

> > For compatibility reasons PC/Q35 will start with legacy CPU hotplug
> > interface by default but with new CPU hotplug AML code since 2.7
> > machine type (in commit 679dd1a957df ("pc: use new CPU hotplug interface
> > since 2.7 machine type")). In that way, legacy firmware that doesn't use
> > QEMU generated ACPI tables was able to continue using legacy CPU hotplug
> > interface.
> > 
> > While later machine types, with firmware supporting QEMU provided ACPI
> > tables, generate new CPU hotplug AML, which will switch to new CPU
> > hotplug interface when guest OS executes its _INI method on ACPI tables
> > loading.
> > 
> > Since 2.6 machine type is now gone, and consider that the legacy BIOS
> > (based on QEMU ACPI prior to v2.7) should be no longer in use, previous
> > compatibility requirements are no longer necessary. So initialize
> > 'modern' hotplug directly from the very beginning for PC/Q35 machines
> > with cpu_hotplug_hw_init(), and drop _INIT method.
> > 
> > Additionally, remove the checks and settings around cpu_hotplug_legacy
> > in cpuhp VMState (for piix4 & ich9), to eliminate the risk of
> > segmentation faults, as gpe_cpu no longer has the opportunity to be
> > initialized. This is safe because all hotplug now start with the modern
> > way, and it's impossible to switch to legacy way at runtime (even the
> > "cpu-hotplug-legacy" properties does not allow it either).
> > 
> > Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> 
> tested ping pong cross version (master vs master+this patch) migration
> with 10.1 machine type, nothing is broken, hence
> 
> Acked-by: Igor Mammedov <imammedo@redhat.com>

Thanks for your test and review!

Regards,
Zhao


