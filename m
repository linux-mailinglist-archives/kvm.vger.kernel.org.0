Return-Path: <kvm+bounces-46035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7077AAB0E44
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 11:10:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C94331C24391
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 09:10:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80547274FEE;
	Fri,  9 May 2025 09:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZY7bDLNP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C2F201266
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 09:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746781805; cv=none; b=J4zU3hUOwhXPEl09UscZKMPYy5Lf8rC5mSEwmwwIUQx5sKvHnTNS9WfmHmO0RbNL7SrDKl03n5wWa1TWXhP/KhzI+z8FS5pcjSnu0SKhP6RSeEx8kT8sx2Gx0epVww6Hp/nh7rRc5rcnVMar9s2jSw68gSpkqk2+Q6JHQyJncVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746781805; c=relaxed/simple;
	bh=UxsyZzWNkwrxjYcXBWnFnM0Egm8Nx5UTD5jcKBNb4Es=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t6V6RNFyyfiMTGjSaRoQ00VgiURI/CT0yGNAeV0p+Vq15zE6rFeKwAn1+9BF65ANMWUVcUyqSFA8iDMgi9JYUl2xOVNYForG+EVyjsE98Bddrln+KSgipKMblsV8qYd8ZzLTw0AYPPnL9QKz1lG1SasB+30fOsZqhcyHb6nQYAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZY7bDLNP; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746781804; x=1778317804;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=UxsyZzWNkwrxjYcXBWnFnM0Egm8Nx5UTD5jcKBNb4Es=;
  b=ZY7bDLNPSA3Nvud1l1JDCETIMPhWFoN6JLy7U/pv8ZMzmgvigMQoq2DD
   ny7dmt61WMRGhqOgd1J9XJdSQ9zAhqy96JKHD7oaAC7kXJ1U562MlXaxk
   XhEecO5jlLOoMSlZ/vEUfH1mM2zcOdnGX/wKOqhfAkO+Ee5zFHKdoOPYV
   klWNT1ONz3M+p0bx7ge6f974vNdgTMbQi4vPh/e9e9GIAtXfjq5MUgzqz
   g0XwxnCbZyHnL9i7xBj/wVSure9xXks5drIPvODYuzvLSOdlLJ/iuZT4z
   DJPNDQ137TiqOlLn+rOK49y3fHNfStv4Z+pxXJngaATGaCZU8cNXHAZbs
   A==;
X-CSE-ConnectionGUID: B3+REHOsSfq8uJaujSCcwg==
X-CSE-MsgGUID: Efxu5w1wTxSRpPRrL0FiTA==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="60004056"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="60004056"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 02:10:03 -0700
X-CSE-ConnectionGUID: q2n6DGcgQ961UrU2zD5Opg==
X-CSE-MsgGUID: ixYYo8l2QHy72d+IpCL59A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="136952061"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa008.fm.intel.com with ESMTP; 09 May 2025 02:09:56 -0700
Date: Fri, 9 May 2025 17:30:58 +0800
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
	Mark Cave-Ayland <mark.caveayland@nutanix.com>,
	Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v4 14/27] hw/intc/apic: Remove
 APICCommonState::legacy_instance_id field
Message-ID: <aB3LUkdAtoXr5U8u@intel.com>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20250508133550.81391-15-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250508133550.81391-15-philmd@linaro.org>

On Thu, May 08, 2025 at 03:35:37PM +0200, Philippe Mathieu-Daudé wrote:
> Date: Thu,  8 May 2025 15:35:37 +0200
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH v4 14/27] hw/intc/apic: Remove
>  APICCommonState::legacy_instance_id field
> X-Mailer: git-send-email 2.47.1
> 
> The APICCommonState::legacy_instance_id boolean was only set
> in the pc_compat_2_6[] array, via the 'legacy-instance-id=on'
> property. We removed all machines using that array, lets remove
> that property, simplifying apic_common_realize().
> 
> Because instance_id is initialized as initial_apic_id, we can
> not register vmstate_apic_common directly via dc->vmsd.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>  include/hw/i386/apic_internal.h | 1 -
>  hw/intc/apic_common.c           | 5 -----
>  2 files changed, 6 deletions(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


