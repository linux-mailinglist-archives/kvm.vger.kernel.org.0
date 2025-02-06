Return-Path: <kvm+bounces-37456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3345A2A3B5
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 09:58:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACB2D3A31ED
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 08:58:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37970225798;
	Thu,  6 Feb 2025 08:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MbdklJIL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA68422578E
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 08:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738832315; cv=none; b=hP3yqKGKR2P959SZlBbyEY/vNN6y2+7Ls2PMDPRtKP1Bdr0e63oKbiYFf80AMgWz8W58W0ULh9GWzo6QW/kWgQBUQ/tLwNi+/dBCPDlJwWktJEcgXuvs31EZZGOLrb5mUCJzyucQSsKFmXNLhUrTxtELBCfAqGcQRA+PDqsq8wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738832315; c=relaxed/simple;
	bh=eeuulv5JLGftzUOJMSAtkOWvy58gJZCXRj6UIl2qTYg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JKHVP34BEYPAP76DeBGpZRPZjygKNgf+iSIQYkJCHVIG96/OIQEUCfFQzGIkXMFm2KDOqVgOV3BTTHHWmBy+GL/JAyGZi2EZjIhxGn81eAAmAyuvH2nEaXIDAJ9F/cXwV4413YGrmxdZT424oRCf9nyjR/23ba7sIJWJkfISvEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MbdklJIL; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738832313; x=1770368313;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eeuulv5JLGftzUOJMSAtkOWvy58gJZCXRj6UIl2qTYg=;
  b=MbdklJILyKbHspD4Lg0aAt5N6Qr8cO2p4WyNPRQvPvTXFxzqCdOx0QBD
   C9Asdvq/4C6yRbn+ONU7eqgX5ebhoSQcmD37hbal0ziOyA4ZnGK3hx5DB
   lWaMBsD+vQxZf5b8eCMKR25lxTfBbscALnnp4VmnqhDTj/hfhO5yjyCfk
   rE8Jk9NuzSLTF39pS60VqDEILXBsc0PfJXnASzA7bCgxcnYzWMNNZUgzx
   EDGjP27arSAFPGAfVuw+VZ+vzDGhQkN00XrOXTWWZT4XsZ6FhEHMsooA2
   20as6j5bBPSNps4t0VEnmQv4o+hdHB/Uj4mUYkOS/hnvoIRiXodhyUL74
   w==;
X-CSE-ConnectionGUID: ZMYBiCmESGGEITJqBqFHsw==
X-CSE-MsgGUID: L4JNQxQsSSmJ+qEckrQ29Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="64779124"
X-IronPort-AV: E=Sophos;i="6.13,264,1732608000"; 
   d="scan'208";a="64779124"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2025 00:58:32 -0800
X-CSE-ConnectionGUID: J1i99jh2QnOK8baB8N2FXg==
X-CSE-MsgGUID: uq7B1JZ1QNmZ9MO8yBtwog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,264,1732608000"; 
   d="scan'208";a="116184254"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa004.fm.intel.com with ESMTP; 06 Feb 2025 00:58:29 -0800
Date: Thu, 6 Feb 2025 17:17:58 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v7 RESEND 0/5] i386: Support SMP Cache Topology
Message-ID: <Z6R+RpFGJHWyE5iq@intel.com>
References: <20250110145115.1574345-1-zhao1.liu@intel.com>
 <87jza4zi5o.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87jza4zi5o.fsf@pond.sub.org>

On Wed, Feb 05, 2025 at 01:32:19PM +0100, Markus Armbruster wrote:
> Date: Wed, 05 Feb 2025 13:32:19 +0100
> From: Markus Armbruster <armbru@redhat.com>
> Subject: Re: [PATCH v7 RESEND 0/5] i386: Support SMP Cache Topology
> 
> Zhao Liu <zhao1.liu@intel.com> writes:
> 
> > Hi folks,
> >
> > This is my v7 resend version (updated the commit message of origin
> > v7's Patch 1).
> 
> If anything changed, even if it's just a commit message, make it a new
> version, not a resend, to avoid confusion.  Next time :)
> 
> [...]

Thanks Markus! I'll keep in my mind about this :-).


