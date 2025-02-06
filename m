Return-Path: <kvm+bounces-37485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 711CFA2AAD2
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 15:13:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A38C165BBC
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 14:13:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F1091C7018;
	Thu,  6 Feb 2025 14:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GNqtcr11"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884941EA7FD
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 14:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738851183; cv=none; b=QrUGeTBXsWxXL5Rol+bM6rtcy3xmsRTOaqmdQOxPBukxUJJjNok/zICfUk9zNgTuDl2UNHVRupL7clm4d2OBgj2U7MtFHGInmMP2GkR6lb1jsZipGOuCUuniDOOeDNBWwD/q63wBNpYT1Ft9Qy7jXybaaRq2vQ2UhAV4De9jKQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738851183; c=relaxed/simple;
	bh=ZMq35FrhEk5mDeRr7RJiv16EUshbu3LSB2bSHyn92zU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n5DpncQc8m7Rjd7KqFGsEyHO+BJeb3+NFRi89XWljeDNHwzXxG7g75OHfAfRWtdYAE7NxlfoZGCkIU8qV05RAc1AbG8MpSD7V0jOo5+oit/8Hu9Xd6r/z6TyteJVD7IGNOoZn9CdmW9Br7TZvG/KMONXQTvk7zhwEBi+XteI89M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GNqtcr11; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738851182; x=1770387182;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZMq35FrhEk5mDeRr7RJiv16EUshbu3LSB2bSHyn92zU=;
  b=GNqtcr11CfJg7By4oLSYdkeYcHVT4SSUzd3BPD2VvjT3oQJk2iREPpIO
   OyvLmpf20lS/Wq01SkVYYhDuxdvAImYL/TL90Q7JUJiHK+3AN3IfaHKGJ
   D0gcnZysrDL7Uz4jf2o0w5aio/tYYfkVXj/dMSCZPNB+E35wEEyqi1Qws
   dSg6s1LZ0Kq7myn/wX2k4UBwsdhzBI5XrDmSkfwZD0sE9tuf7KVeLPUcp
   xiOZUSvmHfVvDWAkar/3NczBBby9E3BzSCWbU6mTiVc/eGFa0XAVdAoN6
   1hD2y2fDm0hS3KrUFIWXNaoGX81KL2X4tR/MpeEC65yGi3WTQX3S6VZqo
   Q==;
X-CSE-ConnectionGUID: LZ9nkyIPQO+dtgB47RUDUA==
X-CSE-MsgGUID: yizg1aC/T/a7S3EZJiXS6A==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="38686408"
X-IronPort-AV: E=Sophos;i="6.13,264,1732608000"; 
   d="scan'208";a="38686408"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2025 06:13:01 -0800
X-CSE-ConnectionGUID: dGmgrJBGSfyPuxx/edfiyg==
X-CSE-MsgGUID: 4Ek+cwODRZqo7tx2bSyBtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="116180151"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 06 Feb 2025 06:12:57 -0800
Date: Thu, 6 Feb 2025 22:32:25 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
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
Subject: Re: [RFC v2 1/5] qapi/qom: Introduce kvm-pmu-filter object
Message-ID: <Z6TH+ZyLg/6pgKId@intel.com>
References: <20250122090517.294083-1-zhao1.liu@intel.com>
 <20250122090517.294083-2-zhao1.liu@intel.com>
 <871pwc3dyw.fsf@pond.sub.org>
 <Z6SMxlWhHgronott@intel.com>
 <87h657p8z0.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h657p8z0.fsf@pond.sub.org>

> Let's ignore how to place it for now, and focus on where we would *like*
> to place it.
> 
> Is it related to anything other than ObjectType / ObjectOptions in the
> QMP reference manual?

Yes!

> I guess qapi/kvm.json is for KVM-specific stuff in general, not just the
> KVM PMU filter.  Should we have a section for accelerator-specific
> stuff, with subsections for the various accelerators?
> 
> [...]

If we consider the accelerator from a top-down perspective, I understand
that we need to add accelerator.json, kvm.json, and kvm-pmu-filter.json.

The first two files are just to include subsections without any additional
content. Is this overkill? Could we just add a single kvm-pmu-filter.json
(I also considered this name, thinking that kvm might need to add more
things in the future)?

Of course, I lack experience with the file organization here. If you think
the three-level sections (accelerator.json, kvm.json, and kvm-pmu-filter.json)
is necessary, I am happy to try this way. :-)



