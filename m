Return-Path: <kvm+bounces-44490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 446F8A9E056
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 09:15:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8357F5A3535
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 07:14:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCA0C245029;
	Sun, 27 Apr 2025 07:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cgLtDra0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BAB173
	for <kvm@vger.kernel.org>; Sun, 27 Apr 2025 07:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745738099; cv=none; b=cbgRRe11usHLgI9/2l4fCiyE9e18LSxrU449jnrrnH5NNQmZWfqhkfw0OHRwerRmYRfLW2H43gynd979Xy2/Wc977g8qjSNBdp3fosYzea/lXUu9kcpCphP86sWxvxsv0KdQjMAh4ci1Tl0UqSRb0XnsaBzU6jXzQWlpVppFGZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745738099; c=relaxed/simple;
	bh=aLKBRMi982qUAHpHdxX4Pn/tcuPuoLKos+FcQs/PFQ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OMHNxhIe2QllMN85boZ8Wivy+B3XPgHoFpMKL8eH9iELXnMA3e/RlIlwv9AEDBs+zVGUsJW9c7/aUtI4KRQ8cQFev9XK1AHzDRq4KvKI7E+ZAxcgtUQ5+fONVemdsJQYvonaHrTzjQtHZ5BCeLC41hCnk5j2npqVr1IGfWoK0Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cgLtDra0; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745738098; x=1777274098;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aLKBRMi982qUAHpHdxX4Pn/tcuPuoLKos+FcQs/PFQ8=;
  b=cgLtDra0o1PIaQv1/vDw+/Fob9Xvz1P6+ZaCi0Jy4lqBaz0kzdywa3pW
   PrFRMvDEMfgxS0Dfb5myywMxJeicRinPLpSfZLxjUUvSyJxMuv/Vn9YrU
   +mWmi3FxHYsBMyjFRIhYhhHvXVDil5dAd6qDruQgEUdAxbRcZ9+g4siPW
   8L2CiNrt/b6zCKbtfCnpnF3nvli0oD8HpLf2DvUe0uFbJ/AW6GgUM5pRH
   RhvSsb+fVVeGGI17yBdkY1+5I7cT6BQ3T7krGU3fV8bCXlDK2Xu/y9Bbo
   5fhIMSSyqqIRq4u0W7rlRvFXvrzBhhW3JV7mpisUHQAR2Tf2ayD4nP9zA
   w==;
X-CSE-ConnectionGUID: cgFge1kCQbirABg2vv/I1w==
X-CSE-MsgGUID: VWTsc2+lRxWhMYHbEFz2fA==
X-IronPort-AV: E=McAfee;i="6700,10204,11415"; a="47255933"
X-IronPort-AV: E=Sophos;i="6.15,243,1739865600"; 
   d="scan'208";a="47255933"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2025 00:14:57 -0700
X-CSE-ConnectionGUID: yiYQh6xbR5mx5fsKnfCVjg==
X-CSE-MsgGUID: +JKhKX8pQWayxyAvjVHFBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,243,1739865600"; 
   d="scan'208";a="156477006"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa002.fm.intel.com with ESMTP; 27 Apr 2025 00:14:53 -0700
Date: Sun, 27 Apr 2025 15:35:49 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>, Eric Auger <eauger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>,
	Sebastian Ott <sebott@redhat.com>, Gavin Shan <gshan@redhat.com>,
	qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
	Dapeng Mi <dapeng1.mi@intel.com>, Yi Lai <yi1.lai@intel.com>
Subject: Re: [PATCH 5/5] i386/kvm: Support fixed counter in KVM PMU filter
Message-ID: <aA3eVdwujSmqKAKu@intel.com>
References: <20250409082649.14733-1-zhao1.liu@intel.com>
 <20250409082649.14733-6-zhao1.liu@intel.com>
 <6a93fa6b-d38d-48ac-9cde-488765238247@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a93fa6b-d38d-48ac-9cde-488765238247@linaro.org>

> >   static void kvm_pmu_filter_class_init(ObjectClass *oc, void *data)
> >   {
> >       object_class_property_add_enum(oc, "action", "KvmPmuFilterAction",
> > @@ -116,6 +139,14 @@ static void kvm_pmu_filter_class_init(ObjectClass *oc, void *data)
> >                                 NULL, NULL);
> >       object_class_property_set_description(oc, "events",
> >                                             "KVM PMU event list");
> > +
> > +    object_class_property_add(oc, "x86-fixed-counter", "uint32_t",
> > +                              kvm_pmu_filter_get_fixed_counter,
> > +                              kvm_pmu_filter_set_fixed_counter,
> > +                              NULL, NULL);
> > +    object_class_property_set_description(oc, "x86-fixed-counter",
> > +                                          "Enablement bitmap of "
> > +                                          "x86 PMU fixed counter");
> 
> Adding that x86-specific field to all architectures is a bit dubious.

Similarly, do you think that it would be a good idea to wrap x86 related
codes in "#if defined(TARGET_I386)"? Like I said in this reply:

https://lore.kernel.org/qemu-devel/aA3TeaYG9mNMdEiW@intel.com/


