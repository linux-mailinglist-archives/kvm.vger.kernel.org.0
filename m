Return-Path: <kvm+bounces-51384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C7BCCAF6B94
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 09:31:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2CAD3AB37B
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 07:30:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12C162AEFE;
	Thu,  3 Jul 2025 07:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BxbbKwkj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E152DE709
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 07:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751527873; cv=none; b=KIMFJSgbdYxv7c1Fka2DpUk529z306cWHZADXwXxEOYv+NT2RezsUnBDJazty3vadFuEceCMM39pL2XTPElU7kFz+r2FNK+hYQ2xVBlvN/on67duRzhpUvmipWVdyHYGEfNN2oQWDJA5jAotjtAkFDMflxjgk69pJPNDJ1rVi14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751527873; c=relaxed/simple;
	bh=umhNYtMq0xc0JruKddyKpbWr9UG6Y0MImL389MvdeJA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g5HP7UE6oXLMqYU0S2bJ4zvuJssUxF9mGE60h8HzrLfTor1WmpbL/Ht2BxO0kFyHS8ALoCy5R+USpbuaKH+7A+C67g2YjI99jWsCqiR3CxeS03lVqi8TYlklNDBnsupjhsQvcmxIonz8aSx5GMBrYnDQ1pjYNRS8fvCjIw1h5PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BxbbKwkj; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751527872; x=1783063872;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=umhNYtMq0xc0JruKddyKpbWr9UG6Y0MImL389MvdeJA=;
  b=BxbbKwkjPrddxIOzSg5JmEFuLPWopDGUfk8vKJhEyoFX/MWIDmTLHcVW
   +85AF2I91f9DL4AFbhNPrQuhEAhDe5f+CQ54FiIwTbiJ1W7Edznye/7qn
   sBYfgCYmmmcvmwCMCPGAoPd3VQH5rgBMIqHEwRfB4eBM5othEV6R7uqZ7
   r2JdYv6tYZ6S2BHWENs7sziZw8KSEfqRLltcTi1g4nt4pwCK2yGlwADbS
   4LrusvYoZ7mAK9ocHL4IDhCaF0GKelr3Nv7Q1AhFDNEqDmu7nJGsrgIHt
   X2S0ORGZvZ+KqMHQjm3iJDxsyohZxJvemgMMvs+WkUFDnXR2XmS0R2HiV
   Q==;
X-CSE-ConnectionGUID: vecG3zRrTV2um5xmlmZ2MQ==
X-CSE-MsgGUID: QWQ5lymbTiKWXB+fFT3MEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="65189364"
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="65189364"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 00:31:11 -0700
X-CSE-ConnectionGUID: duyQJDzBSf2hK3L8jDImjw==
X-CSE-MsgGUID: WZlE00q1THa5jVLuCDVe6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="159800370"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa004.fm.intel.com with ESMTP; 03 Jul 2025 00:31:07 -0700
Date: Thu, 3 Jul 2025 15:52:33 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Babu Moger <babu.moger@amd.com>, Ewan Hai <ewanhai-oc@zhaoxin.com>,
	Pu Wen <puwen@hygon.cn>, Tao Su <tao1.su@intel.com>,
	Yi Lai <yi1.lai@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>,
	qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH 08/16] i386/cpu: Fix CPUID[0x80000006] for Intel CPU
Message-ID: <aGY2wfQJWeigUhm+@intel.com>
References: <20250620092734.1576677-1-zhao1.liu@intel.com>
 <20250620092734.1576677-9-zhao1.liu@intel.com>
 <bd979e2d-e036-4a1a-bf8a-0098eadb4821@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd979e2d-e036-4a1a-bf8a-0098eadb4821@linux.intel.com>

> >  static void encode_cache_cpuid80000006(CPUCacheInfo *l2,
> >                                         CPUCacheInfo *l3,
> > -                                       uint32_t *ecx, uint32_t *edx)
> > +                                       uint32_t *ecx, uint32_t *edx,
> > +                                       bool lines_per_tag_supported)
> >  {
> >      assert(l2->size % 1024 == 0);
> >      assert(l2->associativity > 0);
> > -    assert(l2->lines_per_tag > 0);
> > -    assert(l2->line_size > 0);
> 
> why remove the assert for l2->line_size?

Good catch! My bad...

> > +    assert(lines_per_tag_supported ?
> > +           l2->lines_per_tag > 0 : l2->lines_per_tag == 0);
> >      *ecx = ((l2->size / 1024) << 16) |
> > -           (AMD_ENC_ASSOC(l2->associativity) << 12) |
> > +           (X86_ENC_ASSOC(l2->associativity) << 12) |
> >             (l2->lines_per_tag << 8) | (l2->line_size);
> >  

