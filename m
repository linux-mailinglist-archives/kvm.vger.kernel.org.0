Return-Path: <kvm+bounces-30273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E0F8B9B8945
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 03:21:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C6F31F24967
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 02:21:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 964B8137742;
	Fri,  1 Nov 2024 02:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WbHXI+8a"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9FF1369AE
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 02:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730427677; cv=none; b=qdcoCs0yF9AT6D83dE4lml/EYHfG+1S950o0y/dtSEQ3NBZWt0AA5dz7T6M3Ll6JyxQc33NUsAo5UOA09CiwvuiyBuIep1EIPAVVAtKugFR5RFfEtlnDoRJZT1nUUemrkHTSsj4/VczRO/KDrn8VrhaGSo2NxmIaIoDc5cHUr9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730427677; c=relaxed/simple;
	bh=f5edtnaWl0000c3Tv65SjcYIpMNCaJtIb4m9wYByLX8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZfCuBv7XkG3exDDXa9O5bD7alr7a0R7/XgT1EJJMCiBZEjjmPIgrhrrKmTrVgtl3HFPg/33QGhlhDK740LGJkeQYOdoHjjixaLPezc7cVWY9mbkSDjeZF1HMmYw1RBOUSr5Fi6CjWJT2zKCE6LHxp0120jIzEynXds0J0smzI/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WbHXI+8a; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730427672; x=1761963672;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=f5edtnaWl0000c3Tv65SjcYIpMNCaJtIb4m9wYByLX8=;
  b=WbHXI+8agBtQC68rehL4scurz5CKNmd4SYp4e38xwF8m0s7P/vQQ0kdH
   R5uQfVkdciBVegwCkzKg0E0GxG4zQJVf2xxcWbbKGHSzqBaPfof85yOs4
   kOViHFm7VK6WeE3wTH1uXszwYGREYw+cuXZX0IenpcT3/DJBXL58yWjWz
   lY1CB7U4fL13O7V1IbEh1IgDgTsNfsVtbUmBXJlb74Z6A2nBOQgZoNVUM
   V04Mcizz6325pua4TZJ/SMoaZ/iUY4rGqRv852yYHLh36Fq7SkMbR+tIM
   pPts3fXCq7EaSNhWRoi9lbTxlK1DVEd7j3nWlzR+QUSgnnnm5IQk0lkTo
   w==;
X-CSE-ConnectionGUID: lybGvBN9TXO1rQ5XoYVkgQ==
X-CSE-MsgGUID: yNZ4PwObTE+CgDJjdCbXEA==
X-IronPort-AV: E=McAfee;i="6700,10204,11242"; a="30082690"
X-IronPort-AV: E=Sophos;i="6.11,248,1725346800"; 
   d="scan'208";a="30082690"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 19:21:11 -0700
X-CSE-ConnectionGUID: FmrdQIZqQ9a0t/TsjpyEKg==
X-CSE-MsgGUID: nzCFyinlQqu3gqOKIYVunQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,248,1725346800"; 
   d="scan'208";a="82502436"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa007.fm.intel.com with ESMTP; 31 Oct 2024 19:21:05 -0700
Date: Fri, 1 Nov 2024 10:38:56 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [PATCH v4 2/9] hw/core: Make CPU topology enumeration
 arch-agnostic
Message-ID: <ZyQ/QJnTPvo9wO+H@intel.com>
References: <20241022135151.2052198-1-zhao1.liu@intel.com>
 <20241022135151.2052198-3-zhao1.liu@intel.com>
 <31e8dc51-f70f-44eb-a768-61cfa50eed5b@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <31e8dc51-f70f-44eb-a768-61cfa50eed5b@linaro.org>

Hi Phil,

> > -static uint32_t cpuid1f_topo_type(enum CPUTopoLevel topo_level)
> > +static uint32_t cpuid1f_topo_type(enum CpuTopologyLevel topo_level)
> >   {
> >       switch (topo_level) {
> > -    case CPU_TOPO_LEVEL_INVALID:
> > +    case CPU_TOPOLOGY_LEVEL_INVALID:
> 
> Since we use an enum, I'd rather directly use CPU_TOPOLOGY_LEVEL__MAX.
>
> Or maybe in this case ...
> 
> >           return CPUID_1F_ECX_TOPO_LEVEL_INVALID;
> > -    case CPU_TOPO_LEVEL_SMT:
> > +    case CPU_TOPOLOGY_LEVEL_THREAD:
> >           return CPUID_1F_ECX_TOPO_LEVEL_SMT;
> > -    case CPU_TOPO_LEVEL_CORE:
> > +    case CPU_TOPOLOGY_LEVEL_CORE:
> >           return CPUID_1F_ECX_TOPO_LEVEL_CORE;
> > -    case CPU_TOPO_LEVEL_MODULE:
> > +    case CPU_TOPOLOGY_LEVEL_MODULE:
> >           return CPUID_1F_ECX_TOPO_LEVEL_MODULE;
> > -    case CPU_TOPO_LEVEL_DIE:
> > +    case CPU_TOPOLOGY_LEVEL_DIE:
> >           return CPUID_1F_ECX_TOPO_LEVEL_DIE;
> >       default:
>            /* Other types are not supported in QEMU. */
>            g_assert_not_reached();
> 
> ... return CPUID_1F_ECX_TOPO_LEVEL_INVALID as default.

I prefer the first way you mentioned since I want "default" to keep
to detact unimplemented levels.

> Can be cleaned on top, so:

Yes, I'll rebase (now there's the conflict) with this fixed.

> Acked-by: Philippe Mathieu-Daudé <philmd@linaro.org>

Thanks!

Regards,
Zhao


