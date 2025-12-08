Return-Path: <kvm+bounces-65501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 289D8CACE31
	for <lists+kvm@lfdr.de>; Mon, 08 Dec 2025 11:33:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 868C23015009
	for <lists+kvm@lfdr.de>; Mon,  8 Dec 2025 10:33:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B473F310631;
	Mon,  8 Dec 2025 10:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N2b9QPP5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5EA2E611B;
	Mon,  8 Dec 2025 10:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765190019; cv=none; b=k4IW8uFbZJTeTSXKj8Y+Z1AkYrTqMkVDTjsulV1T/iPK1n/2RfJBnM8CrcCsZK2xic8wav9Dgam0eJ5C9WJ/YOgGT2T6dOETrepwFiSNTCkALXBG7XtZyCFHejh1ph/3i/6XGQ23D/2qD6u3mcKBhOqVp4mOxVm0yKwqdEUlUog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765190019; c=relaxed/simple;
	bh=c9l9ce6UYP/otnK59dV0eUb1DOzxB9nYVZ9wNE6XKIc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aTs4mwNI7Aq8vOul9VbzL6VHxQPWmnLGoikSkRkFkmIm2DmdTD60xYvKj9LAfdHElW/ADcynligOYqrJe6axcHvF6BkhRpMgDiXVNq3VQkR3ihS4s0P1jT8ANoh5H2n0J7BREb4VicH2xQdCzaCwv/rA7Gg57GGmaVyefRBmtH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N2b9QPP5; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765190018; x=1796726018;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=c9l9ce6UYP/otnK59dV0eUb1DOzxB9nYVZ9wNE6XKIc=;
  b=N2b9QPP5YqlpnCLhIJtQTwujsmyOWSSR1CnnluzRQF4O+Plwp2S7wXml
   15auyO2lrCA4hLAtaUNJ5xiUcBP+waROqp5n/Wm2gwZy65B/XuzRnXKlo
   VVDZMtwAekKJTs7VLQX6a7+IBC2VzW30yjNA3EwWWG8Mv3fb5TV4bdyc/
   bW1IDu2EbDy6Xegdds/nveINco5+EKQhuY39B/Vpz+N0yWTzIEaQ2aGjz
   rJYoUFyTC9pWRfVEG5DNPw3SQZkWlK6ks4UiIbTn/GmWBhGxxOjrD39P3
   z+AbsXuE4E/8Lizn8SOv4bDzW04qe83jpanT+s3bH6Zmtp5a/+45OGmGW
   w==;
X-CSE-ConnectionGUID: ksSslthDT56m4rTt1yTLSw==
X-CSE-MsgGUID: rPckdfFeSv2hPDBpkKlqkA==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="78594106"
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="78594106"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 02:33:37 -0800
X-CSE-ConnectionGUID: e6nxTTSbT22YX5Eez07vfA==
X-CSE-MsgGUID: fv/G4m+TT/m2CAbeXx+M8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="194957582"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa006.jf.intel.com with ESMTP; 08 Dec 2025 02:33:35 -0800
Date: Mon, 8 Dec 2025 18:17:51 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: dan.j.williams@intel.com
Cc: x86@kernel.org, dave.hansen@linux.intel.com, kas@kernel.org,
	linux-kernel@vger.kernel.org, chao.gao@intel.com,
	rick.p.edgecombe@intel.com, baolu.lu@linux.intel.com,
	yilun.xu@intel.com, zhenzhong.duan@intel.com, kvm@vger.kernel.org,
	adrian.hunter@intel.com
Subject: Re: [PATCH 0/6] TDX: Stop metadata auto-generation, improve
 readability
Message-ID: <aTalzz/eE9xFIwSN@yilunxu-OptiPlex-7050>
References: <20251202050844.2520762-1-yilun.xu@linux.intel.com>
 <69353071424df_1e0210079@dwillia2-mobl4.notmuch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69353071424df_1e0210079@dwillia2-mobl4.notmuch>

On Sat, Dec 06, 2025 at 11:44:49PM -0800, dan.j.williams@intel.com wrote:
> Xu Yilun wrote:
> > Hi:
> > 
> > This addresses the common need [1][2] to stop auto-generating metadata
> > reading code, improve readability, allowing us to manually edit and
> > review metadata code in a comfortable way. TDX Connect needs to add more
> > metadata fields based on this series, and I believe also for DPAMT and
> > TDX Module runtime update.
> 
> While the writing is on the wall that the autogenerated metadata
> infrastructure has become more trouble than it is worth, that work can
> come after some of the backlog built on the old way has cleared out.
> These in-flight sets of DPAMT, Module Update, and TDX PCIe Linux
> Encryption can stay with what they started.
> 
> I.e. let us not start injecting new dependencies into in-flight review.

Yes, I agree. One of the goal is to minimize the manual changes when a
new metadata is to be added, so I expect minor work for the switching
later.

Thanks,
Yilun

