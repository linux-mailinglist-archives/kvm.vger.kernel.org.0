Return-Path: <kvm+bounces-51380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 957CCAF6B39
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 09:17:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3AED4E5EDB
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 07:17:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78AE22980A3;
	Thu,  3 Jul 2025 07:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cdylckEC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA6F1CD1F
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 07:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751527026; cv=none; b=V7dQAReCo1r4m3PYUbSSHyiR3urwU34dgkWGo/zNHOTJpLl7kt7wawh1IKSrtGU/wGD3lcOZd6Zz+8pLwPRoUdHuQT+Fs+5iowq1LIpF9iOjWUClXT6YyQK5v/VNMUz2UmKJmx2Gq9pjxxGO82XgBS2Ay/v0oHFp4SQCDydpqnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751527026; c=relaxed/simple;
	bh=FKARZY7CsmsxWAOOzUTp75oHFn/qz7dtYMYywXdXkO8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DpXuu3tjJ0yJVSam3nBSz7yjkDvcxgknUqf8+QNOsHDVLD3GWi1ykoJBrSRTRUUoknjeGeTjzDCi9faaRXrsgpKU8oklm4xIL0qilEEHNKBwcJXB8TKPGF+XzXibfmf4LC5qNPsnxBQIzTaAnQY/OUOxrNOFK/Jsr8CxdtdWumc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cdylckEC; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751527025; x=1783063025;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=FKARZY7CsmsxWAOOzUTp75oHFn/qz7dtYMYywXdXkO8=;
  b=cdylckECYCsYMGdBPuCSo+1YpBrXqtv/CZHnQznBgyD3Fr8cqrjwgVAf
   InolbPwTe6R5mixfsYo0pN6rOW50kC7fbkrNgEvs0+MUv5VjUaXv4VXGV
   hHhVSsQM/YG1+FwMx2M/G5zimnf1TSutd2+meR7q8vwfdEU1K2zaPT4X/
   xN1IH9W7LBhEIs86f0wO61t5pavmuQQaz1e08ZfufRraG8x2/HQ4AIyac
   L8yoOPtSrJ4TgkzRIkXtzCcOTTIBNRae6ddKWtwg5Vkgd6SS5dsUHE2SS
   mGlQv2YJ9j3oZGQOn1MoCaBzYA1oVJSjtaMMtXMDmZ0DBkeF5CyVq2ewJ
   w==;
X-CSE-ConnectionGUID: +ROHZAdBQteS6gtGZCXVdQ==
X-CSE-MsgGUID: NCe2WZ6fRriM+lTKC9uRyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="53935807"
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="53935807"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 00:17:05 -0700
X-CSE-ConnectionGUID: V5wKbvZBTV6Fqy2m/ghA5w==
X-CSE-MsgGUID: chQ9cZvYQUu91pO2sXBRsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="154370223"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa006.fm.intel.com with ESMTP; 03 Jul 2025 00:17:01 -0700
Date: Thu, 3 Jul 2025 15:38:26 +0800
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
Subject: Re: [PATCH 01/16] i386/cpu: Refine comment of
 CPUID2CacheDescriptorInfo
Message-ID: <aGYzcgbyJglePNHF@intel.com>
References: <20250620092734.1576677-1-zhao1.liu@intel.com>
 <20250620092734.1576677-2-zhao1.liu@intel.com>
 <4fde6b82-0d13-48d8-898a-e105b9a79858@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4fde6b82-0d13-48d8-898a-e105b9a79858@linux.intel.com>

> > +    /*
> > +     * Newer Intel CPUs (having the cores without L3, e.g., Intel MTL, ARL)
> > +     * use CPUID 0x4 leaf to describe cache topology, by encoding CPUID 0x2
> > +     * leaf with 0xFF. For older CPUs (without 0x4 leaf), it's also valid
> > +     * to just ignore l3's code if there's no l3.
> 
> s/l3/L3/g

Sure!

> Others look good to me. 
> 
> Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
 
Thanks!


