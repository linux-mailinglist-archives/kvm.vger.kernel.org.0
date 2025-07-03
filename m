Return-Path: <kvm+bounces-51381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A81DAF6B44
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 09:18:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 702A0169D8A
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 07:18:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 607F02980A3;
	Thu,  3 Jul 2025 07:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WxQ+iKHd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292631CD1F
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 07:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751527082; cv=none; b=MeNXMcjboCsbXIIMHxNEmpJzNK260qI9gH58mKqbAH2i5nlTODy71UpAaN+eqFn7Sq5iPlq0I8C/hrdsRV+uosvseIe/EE5M7XbNGn8JBVUTNBXgX72iICsEBuMrGaLFOMaUx8RyblDhXiJfuxIYebON8zf5GLdrpHuMfbGFERQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751527082; c=relaxed/simple;
	bh=gVSmDn6dadFMZFYmEeJHA7ecHxg6HSPxUgwGHWgIW4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kYhqjt7QknaGxKsfvNxbJQRCuvTIbPzffkZee5xnYs8SDJDbbZNbM/V3JH5icvd9uZIbukdaajutWrfZiv6eQZOxQA6K+ReNO46CXtfF1Flld96SBBt6r9cD4Nd9bnFaGqk4bY7oTW8UGfCfOM1drZG6+ENpCS5qlAGbVaLUHHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WxQ+iKHd; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751527081; x=1783063081;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=gVSmDn6dadFMZFYmEeJHA7ecHxg6HSPxUgwGHWgIW4Y=;
  b=WxQ+iKHdHT0RwA0BucrRCYxIZ3/YUoTXn5DcnLrxUCRmoxzUC7O/oslk
   sgUcVBiBKHaC7jleAf6TBxo27hfxmGsDC5fChYzzxD4/bJzDuS8KThipv
   YUJ2ONxule2UXhscJhttFV6Jql7THeuJTwZhPbfSvS4gpdA/UW8FfTjTF
   ToPlk82CMmkBvGpl+Hi2CV0BAeMGCQ1V62nZGEmuk5H3ouBFQpuZ8jjqu
   Prsg5mwLRVFyPpbGkId/KvpX3qXmqG3jIrEzGXPYdicFe+/VIj1K7uORY
   v9vW1zjgB21DKKjK/x2HJmkhj4767JjxqWmXzC+yNtL5e87SymhkZwSgf
   g==;
X-CSE-ConnectionGUID: nwXFStRZTee03CHW9dVn9w==
X-CSE-MsgGUID: EqlSMfgNSWuov4YHIwtHxA==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="65188063"
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="65188063"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 00:18:00 -0700
X-CSE-ConnectionGUID: FAI4D8/oQSOLWFQ72zhtSw==
X-CSE-MsgGUID: JxEFckacSomB8SdkLRZXiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="185229199"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 03 Jul 2025 00:17:56 -0700
Date: Thu, 3 Jul 2025 15:39:22 +0800
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
Subject: Re: [PATCH 02/16] i386/cpu: Add descriptor 0x49 for CPUID 0x2
 encoding
Message-ID: <aGYzqrKldFwlbPoZ@intel.com>
References: <20250620092734.1576677-1-zhao1.liu@intel.com>
 <20250620092734.1576677-3-zhao1.liu@intel.com>
 <0b2a6fbe-6232-4e6a-8423-ab09f6d312b7@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0b2a6fbe-6232-4e6a-8423-ab09f6d312b7@linux.intel.com>

> > -    /* Descriptor 0x49 depends on CPU family/model, so it is not included */
> > +    /*
> > +     * Descriptor 0x49 has 2 cases:
> > +     *  - 2nd-level cache: 4 MByte, 16-way set associative, 64 byte line size.
> > +     *  - 3rd-level cache: 4MB, 16-way set associative, 64-byte line size
> > +     *    (Intel Xeon processor MP, Family 0FH, Model 06H).
> > +     *
> > +     * When it represents l3, then it depends on CPU family/model. Fortunately,
> > +     * the legacy cache/CPU models don't have such special l3. So, just add it
> > +     * to represent the general l2 case.
> 
> For comments and commit message, we'd better use the capital character
> "L2/L3" to represent the 2nd/3rd level cache which is more conventional. 

Sure.

> Others look good to me.
> 
> Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>

Thanks!


