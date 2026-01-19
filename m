Return-Path: <kvm+bounces-68481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E5B4D3A108
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 09:12:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 825173009202
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 08:12:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D60A833B947;
	Mon, 19 Jan 2026 08:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QW+AfPuF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33F533A9F8;
	Mon, 19 Jan 2026 08:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768810338; cv=none; b=ik5Jq7PnCR7OaWAjUmuFTDkaoRu+hjdGDncKcsqOFdUvzSA815a972ncE3mPuc4STgVQSfZ6s5NfvUjrNNtdAkKjtZfhvuDEaVnLLRMtdXzIol97AQYS8ve/Z5TNaYoycT5tyAFK640i904TM8s2IVuWrc5wxXPGwKhNAR94PW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768810338; c=relaxed/simple;
	bh=kgic3w3XRTOVDzYviBXV2y1U9S8d4TkCfkexDRtU15E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o1XbbB50EStCo/HQ+PkYfp6NClSrsuJZ6axhgCTl0NzOTPb1uVclXNrE1YLyEY6Pu7XbTD2Mj15jm7n8FmotPxaGmKe1TgKuyBlAJYidLoqWuCWJsQjjU/d0v+z+tf78xH/pSGM+jDMOtLdBmcd7t1TW5cCUpm8aaV1QyFKAKD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QW+AfPuF; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768810337; x=1800346337;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kgic3w3XRTOVDzYviBXV2y1U9S8d4TkCfkexDRtU15E=;
  b=QW+AfPuFn7i3qdZY8DH6VR9GBPMonWQnNLaLmjUPslYEiRbMWwWM+1C5
   cipGLvIjluhCCTPuxAkHS0uiIiK36vNvdRPqHooIwcHjGG28W+eW0XO/m
   n326onLvjwm9qf4l07hbZa9tj+lx1WuRKbHzt2hE+NKtSaLg3oXTZJ4Xu
   eN9tAK+tCwyN4YYBQeM2TRlNBIT6JU5iNKE/OZ69FacM6PNooXb/UrcQc
   4in+bCZ0IVjoPu7pvnxhSnlfxvdbu76XOx6bbWM/n39AQ8spFtfhO00HY
   BR+LFTt47zcoJZo1wDSxCgO0ZfnA1x9cvq/ygq/LtoLZQsMoBdt6GCvQv
   Q==;
X-CSE-ConnectionGUID: c+hVoljTQ+uZ67fXbQ+isg==
X-CSE-MsgGUID: DvOrwPVxQXma2AtR0/Ibrg==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="80738632"
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="80738632"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 00:12:16 -0800
X-CSE-ConnectionGUID: IixwoLb3Rx69LUEj6McHBg==
X-CSE-MsgGUID: IGXIBBJvRe+yST5oIs2znA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="209945216"
Received: from aotchere-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.249])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 00:12:11 -0800
Date: Mon, 19 Jan 2026 10:12:07 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
	kvm@vger.kernel.org, x86@kernel.org, Chao Gao <chao.gao@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH v2 1/2] x86/virt/tdx: Retrieve TDX module version
Message-ID: <aW3nV5ZwmFnLdDss@tlindgre-MOBL1>
References: <20260109-tdx_print_module_version-v2-0-e10e4ca5b450@intel.com>
 <20260109-tdx_print_module_version-v2-1-e10e4ca5b450@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109-tdx_print_module_version-v2-1-e10e4ca5b450@intel.com>

On Fri, Jan 09, 2026 at 12:14:30PM -0700, Vishal Verma wrote:
> From: Chao Gao <chao.gao@intel.com>
> 
> Each TDX module has several bits of metadata about which specific TDX
> module it is. The primary bit of info is the version, which has an x.y.z
> format. These represent the major version, minor version, and update
> version respectively. Knowing the running TDX Module version is valuable
> for bug reporting and debugging. Note that the module does expose other
> pieces of version-related metadata, such as build number and date. Those
> aren't retrieved for now, that can be added if needed in the future.
> 
> Retrieve the TDX Module version using the existing metadata reading
> interface. Later changes will expose this information. The metadata
> reading interfaces have existed for quite some time, so this will work
> with older versions of the TDX module as well - i.e. this isn't a new
> interface.

This is great to have for debugging, if not too late:

Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>

