Return-Path: <kvm+bounces-28059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FB36992A06
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 13:09:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1FC9A1F22C7E
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 11:09:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A1721D1302;
	Mon,  7 Oct 2024 11:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nxeXjm2/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7AE2AD05
	for <kvm@vger.kernel.org>; Mon,  7 Oct 2024 11:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728299353; cv=none; b=Q1e1cch4jMGJd+CMp8rHz4Yd4+IoUBqSsvbEONytLE7sCYw/k+4rickj3Dy5uHNOOF2Lgw6T7tYvLxY6/CNRGdD0YzyolYNqekSklaRzRLKFJc6QAKTQR8L+Zyk4RR20Ynsw9QEcPeT7tnnnFRmU/2BAqaT1T88tjt25cq+tCgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728299353; c=relaxed/simple;
	bh=mdl3O6UZDSmkKcS6mryVKnf7fIORJIf2348ydZdIMdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JV4XAD1D0v2hcSqcrHdOSNLjlm9vIZ1XLaBuWVcZ0GUR8jc3ez6Pvi/tHN87oGyHONO0ZX+7Bmxlo2ZNu+KAh3FtOJJ9hoVgaiidR9o5JfnDNA9DlGedvIgI34TxVv0cmhY/hOnIpxEjvvm4vcsYLJZcTkbwEERrOEDnxT0Cg1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nxeXjm2/; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728299351; x=1759835351;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mdl3O6UZDSmkKcS6mryVKnf7fIORJIf2348ydZdIMdU=;
  b=nxeXjm2/dl1s+yyBrJbCdTEW8qDQWfWq+RjJMa0/Z13qfxxR3XXUUEAI
   Pm9qJnnE7g6PBADw0c1z99LTPDJOVDk1nUxAc4I3wlrMRxaK4wwXKdQsG
   QyHgLaoGy8QbKhH+AT4QG3QGzKlNUPafMjrBznDRZpvpS5KTQMklkgXEd
   4wyvbohBzAj9tJKdxQ+kC05CwMmvhnSkPsbSyLarQakznh8uvwwWxR49U
   SNCoiwzw1iMia/va4FyLELb8SfmxdiUO5zuJVFdx0T0gmoWNOpG1sEtEv
   1p2bgYEbHdJSVw1MvQZk7kCPJvjZPo9Yfbnofc9NeRkQsBqmWOgBGxsGA
   w==;
X-CSE-ConnectionGUID: pfmh4p8NQre1mnRsKIN2Ig==
X-CSE-MsgGUID: abEmIggAQkC8sGTSKQ9Wjw==
X-IronPort-AV: E=McAfee;i="6700,10204,11217"; a="27567917"
X-IronPort-AV: E=Sophos;i="6.11,184,1725346800"; 
   d="scan'208";a="27567917"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 04:09:11 -0700
X-CSE-ConnectionGUID: NG4iK1/SQZutev+AM5LZCQ==
X-CSE-MsgGUID: SRN2jDpjQQqXbhSdUU9EgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,184,1725346800"; 
   d="scan'208";a="75413361"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa009.jf.intel.com with ESMTP; 07 Oct 2024 04:09:05 -0700
Date: Mon, 7 Oct 2024 19:25:17 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S.Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v2 6/7] i386/cpu: Update cache topology with machine's
 configuration
Message-ID: <ZwPFHZQA4ar1j2+0@intel.com>
References: <20240908125920.1160236-1-zhao1.liu@intel.com>
 <20240908125920.1160236-7-zhao1.liu@intel.com>
 <20240917100641.000050a8@Huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240917100641.000050a8@Huawei.com>

On Tue, Sep 17, 2024 at 10:06:41AM +0100, Jonathan Cameron wrote:
> Date: Tue, 17 Sep 2024 10:06:41 +0100
> From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
> Subject: Re: [PATCH v2 6/7] i386/cpu: Update cache topology with machine's
>  configuration
> X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
> 
> On Sun,  8 Sep 2024 20:59:19 +0800
> Zhao Liu <zhao1.liu@intel.com> wrote:
> 
> > User will configure smp cache topology via -machine smp-cache.
> > 
> > For this case, update the x86 CPUs' cache topology with user's
> > configuration in MachineState.
> > 
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> > Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Seems simple enough.
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

Thanks!

-Zhao



