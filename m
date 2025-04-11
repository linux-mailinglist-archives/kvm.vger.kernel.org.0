Return-Path: <kvm+bounces-43125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E925A85152
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 03:44:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C7353B0BEF
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 01:42:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0267279349;
	Fri, 11 Apr 2025 01:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ms02BtLa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754032572;
	Fri, 11 Apr 2025 01:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744335759; cv=none; b=iwnh4CC3/5mAloLOzVw4znresYNA/hNg3Agc/PlecJcxAIwJFOvYE4uLAsZ/cHB6G8L77IsInVfFyFQqbozAMeaLaM23rFdE1QzHIE5QTIi+/avq2np8ay5hcsL//kNYwKve3PHrc088EO+UpeW3au1I6TDuvdEWvd8ZEUOX/ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744335759; c=relaxed/simple;
	bh=vuczt/nLn+O/E/I4EjuHCPEeYNFrTcNRZwGWR8XUbT0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C4RSsHg4CN33kDWzDA4I8C/iughQV3OywlxS4F/Jg6zRMTsqhPcee08P2zDIQIG5kdgMjJvdsogS9eyvkBnOSq3U/thAfNK+cKvc5i/8/DDwFzmhDtzYTHyLcCSxjFyWNmyyfNqrqErXCxlybeRQb9pdNLbsm2a+abnCi2EGX0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ms02BtLa; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744335757; x=1775871757;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vuczt/nLn+O/E/I4EjuHCPEeYNFrTcNRZwGWR8XUbT0=;
  b=Ms02BtLazYtSpEJW/R+nDjgeyU3CZl9N4H73UtisN580xWahpP6DNfz8
   CADQfkfo3a5qRGFEc0qY5jLxg3PBG+0aywTKj6dgxYG5kQLudluXV/z8I
   c2sN629uoVocHu5Lh4kkuHLby/8+T05UdP4b5fvei5GTH/BjA7fljXeME
   iE4Y7lPDl9e5bP5c9/NCT0uJLmEot4qPC6GGuI8d/ly42qi7Yex9nCWsJ
   aCan68UO3K/ZF9ZLPgV8LAps+NOhiD+pl7fb5wve8oMfI6tCudaPPX7yR
   arOniEl8IeKBm2t0Z5Wtst2Rf7C70hMOSndmxIOPVIK6PXOAGlzEGJb0C
   w==;
X-CSE-ConnectionGUID: syHVDscRTPW5eXGyr7qBZg==
X-CSE-MsgGUID: 1ad60x7QQSK8kCUxgKUDkQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11400"; a="63420466"
X-IronPort-AV: E=Sophos;i="6.15,203,1739865600"; 
   d="scan'208";a="63420466"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 18:42:36 -0700
X-CSE-ConnectionGUID: tamrV7dqTHKT49LsI90sFw==
X-CSE-MsgGUID: iWF81tKsTcqx/K0UuPzD7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,203,1739865600"; 
   d="scan'208";a="134227869"
Received: from yijiemei-mobl.ccr.corp.intel.com (HELO [10.238.2.108]) ([10.238.2.108])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 18:42:34 -0700
Message-ID: <6cc63871-e739-49ef-8bef-e2799fc3f83f@linux.intel.com>
Date: Fri, 11 Apr 2025 09:42:30 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] TDX attestation support
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "Gao, Chao" <chao.gao@intel.com>,
 "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>,
 "Huang, Kai" <kai.huang@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "Lindgren, Tony" <tony.lindgren@intel.com>,
 "Hunter, Adrian" <adrian.hunter@intel.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>
References: <20250402001557.173586-1-binbin.wu@linux.intel.com>
 <b5bb71fdb3f9b4a1b08a169b2d6c9c70210c6d02.camel@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <b5bb71fdb3f9b4a1b08a169b2d6c9c70210c6d02.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/2/2025 8:20 AM, Edgecombe, Rick P wrote:
> On Wed, 2025-04-02 at 08:15 +0800, Binbin Wu wrote:
>> Opens
>> =====
>> Linux TDX guests don't use SetupEventNotifyInterrupt for TD attestation
>> currently. If no other TDX guests use it, the support for
>> SetupEventNotifyInterrupt could be dropped. But it would require an opt-in
>> if the support is added later.
> I think we shouldn't be afraid of opt-ins. We will need one sooner or later.
> Better to not add the second exit with no users.
>
OK, will drop it in the next version.

