Return-Path: <kvm+bounces-41066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E65C9A6137D
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 15:18:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE832173EF1
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 14:18:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9E0A201032;
	Fri, 14 Mar 2025 14:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l6ZnPTFK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7821FFC6C;
	Fri, 14 Mar 2025 14:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741961885; cv=none; b=b79Cbm6cbrTCqAYfStPUEvhtZZ6pThq9yXAk6bEiyC38pSfr0z4MLoCx0p0VYJ6T6JiY06hcT3J9bvKdb+KMOpTKPcfdnzdW7BfQt5LM0W/fAxMql/iZ//KUCqI5lU8y1t7h7SKjVZ18NQPVdWbfBkREOzizHifW6uO/5Mmz2MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741961885; c=relaxed/simple;
	bh=ehI+5WGoJFvH581UmEMGS+mVsEWVHHCA1L3bFq4wMaE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kmJQYgf45SCVte35n6PbnnARgIL0D7HcLl96Rchinu3lJPROAiB0jktaq9rCYwv8NjjFPntNW3LAVvVbBfPYhPa1lKSgNNtnYtmqZ8n9uLBOlGWxxxHRrfpjAUw0HnSyuau9IMY8I/hOeJXGfn8kjJg/3N5IQy400kSuE+N/lJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l6ZnPTFK; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741961883; x=1773497883;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ehI+5WGoJFvH581UmEMGS+mVsEWVHHCA1L3bFq4wMaE=;
  b=l6ZnPTFKPHGIfKdubKjoc/Kw9WKS0KW0ab8H8zHuptkQM7iecRxkTmWv
   hahiv0huI0RQp7ElYW5WRTvCGNbYi2u8/wrdWzKgMako0nKYa2i6WSXEi
   DONZV3Qd0M06eceJKCHYyMBSrS73fs3Wq9cmCsaa05kZL4fI0ocUYO2j9
   N9r5FcvvJzCBcEgf+7OLI7D1XZh2FR/jenyO2zjLK7Y2dknwv+tZ1p9jA
   QF3WIyVRFxhrzgLX1EqzTl4lvt1D6EvUF6LfxujV6u24Zodms+3pxP5I0
   irGqptNsqVpfEs0ija9RSHfmB/O1xenrCL2rK76vEkN9EO1S6NmrrDmyT
   w==;
X-CSE-ConnectionGUID: eilAbbtaQiSE7kxHPrFbwg==
X-CSE-MsgGUID: HBZ+QytOS6+99ciS/nEc6A==
X-IronPort-AV: E=McAfee;i="6700,10204,11373"; a="65574409"
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="65574409"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2025 07:18:00 -0700
X-CSE-ConnectionGUID: ZE11eKY3Qf6YHGYfEHzQ7g==
X-CSE-MsgGUID: 9+i+eknqSmmAOmOP3TzZtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="122006741"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2025 07:18:00 -0700
Date: Thu, 13 Mar 2025 17:43:11 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
	pbonzini@redhat.com, Sean Christopherson <seanjc@google.com>,
	chao.gao@intel.com, rick.p.edgecombe@intel.com,
	yan.y.zhao@intel.com, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Nikunj A Dadhania <nikunj@amd.com>
Subject: Re: [PATCH 0/2] KVM: kvm-coco-queue: Support protected TSC
Message-ID: <Z9N7n903V6Xz/gKj@ls.amr.corp.intel.com>
References: <cover.1728719037.git.isaku.yamahata@intel.com>
 <Z9DfurM5LwR5fwX4@tpad>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z9DfurM5LwR5fwX4@tpad>

On Tue, Mar 11, 2025 at 10:13:30PM -0300,
Marcelo Tosatti <mtosatti@redhat.com> wrote:

> On Sat, Oct 12, 2024 at 12:55:54AM -0700, Isaku Yamahata wrote:
> > This patch series is for the kvm-coco-queue branch.  The change for TDX KVM is
> > included at the last.  The test is done by create TDX vCPU and run, get TSC
> > offset via vCPU device attributes and compare it with the TDX TSC OFFSET
> > metadata.  Because the test requires the TDX KVM and TDX KVM kselftests, don't
> > include it in this patch series.
> 
> OK, previous results were incorrect. In fact, this patches (which apply
> cleanly to current kvm-coco-queue) reduce cyclictest latency from:

Thank you for evaluating it.  Does your guest include [1] (or similar fix)?
The patch would affect the result much.

[1] https://lore.kernel.org/lkml/20250228014416.3925664-1-vannapurve@google.com/
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

