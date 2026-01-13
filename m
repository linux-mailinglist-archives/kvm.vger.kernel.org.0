Return-Path: <kvm+bounces-67904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 61ECFD16736
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 04:16:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 90BD13013D6C
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 03:14:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93ECB318EF2;
	Tue, 13 Jan 2026 03:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NxM0PMM8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E7B313E07;
	Tue, 13 Jan 2026 03:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768274025; cv=none; b=EDrMN8xPhIAlbg0CvlgLM2H6haKPCBRbCmhHoERNfOnygJTKn0DRg8AcWtznfNkf6JywZo/qG26SEd/zNw9sqM3nenMC6Ok+xAomRmyAIWFP2kr4zy/TjY84lhtzEGbkDBdso8DffZKTJIciO0/lGF9402zGlv84/bYNTSKiCrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768274025; c=relaxed/simple;
	bh=AwCkgRj14uBxQvDHAGmv7QGalcQYD/TiXaWUnMWuays=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SaDL3ON7lx+HrCXbB8YeFb8KCWpl9zJQajCNjK+FyolmXDDnELcCVr+rqvwsDxZaqyvLAQidXO+h50dlG6wI2jZdJCzak8QO4hrMRWwyLicff8JQtnH84Pd++96Cpy3J3LPyq/P8MQO9L5LutRW8vo6ZZ5tCVMYWwi9RpaG+UWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NxM0PMM8; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768274025; x=1799810025;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AwCkgRj14uBxQvDHAGmv7QGalcQYD/TiXaWUnMWuays=;
  b=NxM0PMM844leiJ8KIfzuVoYtoo4yc2qzwZxUkDwN3tKsrV5OAblSKci3
   +BkP8fKFOk6y8dgzAW4/4OQQypsZsGz8pVC0/Wf2s+QzwMcI8mW++fqFn
   Wp/J4eizgcGq9nMfGNDK7v622KfcanxPszPSXqeilorA8KUBrAlDPkmIJ
   nMSWDOwruzKXEDRZQjDhdabLPiY/RCpRJRWbIQzp1vvabZqrnbR5SbqmI
   c4tTvryqgbwtNvRira+joiUNFPpXEei3q8DZq5is3GNupAr95UaJhdZOy
   BuafQImHsk/T1fITUgzIpvGjMLrTEajzhWVgU0v43/DUuo1jWHI3Z8iww
   A==;
X-CSE-ConnectionGUID: /elBWELGTxy7e2dcOoTkQQ==
X-CSE-MsgGUID: nBN4jBXWSVKOO6Reuzu9YQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="86970873"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="86970873"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 19:13:44 -0800
X-CSE-ConnectionGUID: eljSsRuuR4uwTYaG8qo/IQ==
X-CSE-MsgGUID: y4Wk7NuzRBuqKbfT4Siq6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="204665749"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa009.fm.intel.com with ESMTP; 12 Jan 2026 19:13:40 -0800
Date: Tue, 13 Jan 2026 10:56:13 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
	kvm@vger.kernel.org, x86@kernel.org, Chao Gao <chao.gao@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH v2 1/2] x86/virt/tdx: Retrieve TDX module version
Message-ID: <aWW0TZNdWdN/C6Yi@yilunxu-OptiPlex-7050>
References: <20260109-tdx_print_module_version-v2-0-e10e4ca5b450@intel.com>
 <20260109-tdx_print_module_version-v2-1-e10e4ca5b450@intel.com>
 <93ab41bc-91bf-405a-84c4-6355a556596d@intel.com>
 <f0cc6afe-0f58-4314-9a77-34c5b005b677@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0cc6afe-0f58-4314-9a77-34c5b005b677@intel.com>

On Mon, Jan 12, 2026 at 06:56:58AM -0800, Dave Hansen wrote:
> On 1/11/26 18:25, Xiaoyao Li wrote:
> > ... I know it's because minor_version has the least field ID among the
> > three. But the order of the field IDs doesn't stand for the order of the
> > reading. Reading the middle part y of x.y.z as first step looks a bit odd.
> 
> I wouldn't sweat it either way. Reading 4, 3, 5 would also look odd. I'm
> fine with it as-is in the patch.

I prefer 3, 4, 5. The field IDs are not human readable hex magic so
should take extra care when copying from excel file to C file manually,
A different list order would make the code adding & reviewing even
harder.
> 

