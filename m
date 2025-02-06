Return-Path: <kvm+bounces-37472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B2CCA2A58B
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 11:08:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 166671652FF
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 10:08:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 545BC226552;
	Thu,  6 Feb 2025 10:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l9toVNMB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9101226540
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 10:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738836505; cv=none; b=uZJKwRJy1l7AMVIzBsq+Ia2SyNviTHeYrvReHhDL2hXCggHJJOnja2owj3V++XIfzlFh0bwtiP0quVdtq0k7+vfUirQFqMEgPaqOoNo9lKUy9Y6nSjDeg7SND/OhNOVWmNueXpE5dlh0uA80aenx3eP3H553Q2O0orh4OFovMr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738836505; c=relaxed/simple;
	bh=oP0y8I2b0k86JdcYw9jox2qnw26MXTvDoDpMb9y/Ax4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I9K0Z7jmcpUuVY3O9isYQWDX8FucRgfQ+QTuaLV8sxX6SqO1awiDDrPFjnxtZI84FGsKU2n5CJgriwzmzClnyxiYoCbhw4mNPRQh3RQHh1HHvbfFGARJGyzmFNkq9jhJYk77IX3+ShPzrnuqlrX9evnaqn232qTSexUT577eqOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l9toVNMB; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738836504; x=1770372504;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oP0y8I2b0k86JdcYw9jox2qnw26MXTvDoDpMb9y/Ax4=;
  b=l9toVNMByYwYco/7ubGTz58BqXODY9OXa1M6bt9goL1DBV5tY2O3LVtC
   SGlzdRzo3Dyk8LTcC13C53jC8PCjCTY9k+KGbnCru35ZowjG5TQz9JjYj
   bRRbCmxjrayaNADOYNB0Ryb8xfh34YpeVyvPkV4H5L7Awr/7m1jz8EtIz
   xJJ9ZkVxHEW3hx1YxGIIZZOIbXHg6/3DzzkXm2Qn9pEhkdzQYq/CLKCU+
   U+vu5nj/eCeGV72SVQWGjGRZPAl9eOXMD8KS+F7SCegUiCXT8W1uwzvOU
   l0+y604LKR2XiojbJ9c7DmlVucn9y5yebs0KenxC2LHnQeyTBj0sRG0bi
   w==;
X-CSE-ConnectionGUID: 3Zr5ohkOR5S5pa9rBISX1w==
X-CSE-MsgGUID: Qrp3+H1yQQ6SxLOppj68tg==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="43187320"
X-IronPort-AV: E=Sophos;i="6.13,264,1732608000"; 
   d="scan'208";a="43187320"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2025 02:08:23 -0800
X-CSE-ConnectionGUID: na8BE7FXTjK8oidnTjBbzw==
X-CSE-MsgGUID: twhacpdTQ+mS2Rq1hHFoAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,264,1732608000"; 
   d="scan'208";a="111744739"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa009.fm.intel.com with ESMTP; 06 Feb 2025 02:08:19 -0800
Date: Thu, 6 Feb 2025 18:27:48 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Daniel P =?utf-8?B?LiBCZXJyYW5n77+9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>, Eric Auger <eauger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>,
	Sebastian Ott <sebott@redhat.com>, Gavin Shan <gshan@redhat.com>,
	qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
	Dapeng Mi <dapeng1.mi@intel.com>, Yi Lai <yi1.lai@intel.com>
Subject: Re: [RFC v2 1/5] qapi/qom: Introduce kvm-pmu-filter object
Message-ID: <Z6SOpEcLjNW5NpFy@intel.com>
References: <20250122090517.294083-1-zhao1.liu@intel.com>
 <20250122090517.294083-2-zhao1.liu@intel.com>
 <871pwc3dyw.fsf@pond.sub.org>
 <Z6SMxlWhHgronott@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6SMxlWhHgronott@intel.com>

> > > @@ -1183,6 +1185,7 @@
> > >                                        'if': 'CONFIG_LINUX' },
> > >        'iommufd':                    'IOMMUFDProperties',
> > >        'iothread':                   'IothreadProperties',
> > > +      'kvm-pmu-filter':             'KVMPMUFilterPropertyVariant',
> > 
> > The others are like
> > 
> >          'mumble': 'MumbleProperties'
> > 
> > Let's stick to that, and also avoid running together multiple
> > capitalized acronyms: KvmPmuFilterProperties.
> 
> IIUC, then I should use the name "KvmPmuFilterProperties" (string version
> for QAPI), and the name "KvmPmuFilterPropertiesVariant" (numeric version
> in codes), do you agree?
>  

Thanks to Daniel's feedback, pmu filter doesn't need the string version
anymore. So there's only 1 "KvmPmuFilterProperties" structure in QAPI.


