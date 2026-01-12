Return-Path: <kvm+bounces-67700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0ED25D10E76
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 08:36:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B01683016DC4
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 07:36:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D3D2331A4B;
	Mon, 12 Jan 2026 07:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OXIkDwwB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5DF32652B0
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 07:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768203359; cv=none; b=kRnACD1jhar0PnJu0bir0c0IV+9Yz/D2T8DRxAeucnHLzb5UIKFaYV9KMsiBBUiV6fJqJc0o93JX4kcKDj1nMcEIwisqePRI1zJB3bFXZ44EDg3qZMHPNZl+dBInARbwP4G5OEy/DaMZ9FXRw85p/41GGUWwR+Wi0GKvDn+FseA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768203359; c=relaxed/simple;
	bh=V2y9jR5BLpe3D/6SpLQolujjrx0LqpdtXifG3y9ZbwQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KkiWsnqwsTuGKrg5SNcaZ6/UkgJr8D9r7w2XhFJWXItrwK0SbI6TWYfN9bCZqTs/oA7lnXj13UKRp4cD5rQR5fNFqZWo90gkvGKHAeg7nlJlGQvfyTni1alNvODm6xk+8PCExMbGPGrC7jhbMD2mBSbB2WNnhiSjbH4v4fxVTxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OXIkDwwB; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768203358; x=1799739358;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=V2y9jR5BLpe3D/6SpLQolujjrx0LqpdtXifG3y9ZbwQ=;
  b=OXIkDwwBmLKdYjdlkRXzyEJYHRzCx1rl1xasoO2adCQybC6AzlBvXliy
   BZgvj3aDn2sIbG61Xh8e60ZfYAyXBz4uKH6SUD1Qg+WHepUwxymEOvk20
   fgK9jGbytuyfiLIg4JllRBa7FQYCVR6BaYJ+s7PTEjAMSeToAa1BTyTwU
   HzCwrH6OfO6oU/0oQKERVtN15p90GOkjfrb7Vch10ck2owi7kntxDM4ZG
   6xnWEECEYAvPwvsLSCzlQc4Fd4GrPlGkGWeJs/KsBUdn9WYLuz1fMIds3
   GvYCNflhL6ddzWTN0uBKc07ZMck0NxbegMbuf6wxg3c4K2hHRYwuP3+5o
   Q==;
X-CSE-ConnectionGUID: G0UuNKjLSg2/9YtkQxOCEQ==
X-CSE-MsgGUID: x0heMZ0oSTCQ/Fd9CCEprA==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="72051204"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="72051204"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 23:35:57 -0800
X-CSE-ConnectionGUID: KvJwy6cTRvShJ62gP2sunA==
X-CSE-MsgGUID: eNjkj5SZREq7cebp4o5s4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="204304266"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa008.fm.intel.com with ESMTP; 11 Jan 2026 23:35:55 -0800
Date: Mon, 12 Jan 2026 16:01:23 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Shivansh Dhiman <shivansh.dhiman@amd.com>
Cc: pbonzini@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
	qemu-devel@nongnu.org, seanjc@google.com, santosh.shukla@amd.com,
	nikunj.dadhania@amd.com, ravi.bangoria@amd.com, babu.moger@amd.com,
	K Prateek Nayak <kprateek.nayak@amd.com>
Subject: Re: [PATCH 1/5] i386: Implement CPUID 0x80000026
Message-ID: <aWSqUylwHmhIeBjq@intel.com>
References: <20251121083452.429261-1-shivansh.dhiman@amd.com>
 <20251121083452.429261-2-shivansh.dhiman@amd.com>
 <aV4KVjjZXZSB5YGw@intel.com>
 <eb712000-bc67-468a-b691-097688233659@amd.com>
 <aWDEYEfB4va41+Tv@intel.com>
 <df23391a-599a-495b-a1b2-ed548215e2c5@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df23391a-599a-495b-a1b2-ed548215e2c5@amd.com>

> >> The current kernel doesn't have sensitivity to a level between L3 boundary and
> >> socket. Also, most production systems in current AMD CPU landscape have CCD=CCX.
> >> Only a handful of models feature CCD=2CCX, so this isn't an immediate pressing need.
> >>
> >> In QEMU's terminology, socket represents an actual socket and die represents the
> >> L3 cache boundary. There is no intermediate level between them. Looking ahead,
> >> when more granular topology information (like CCD) becomes necessary for VMs,
> >> introducing a "diegroup" level would be the logical approach. This level would
> >> fit naturally between die and socket, as its role cannot be fulfilled by
> >> existing topology levels.
> > 
> > With your nice clarification, I think this problem has become a bit easier.
> > 
> > In fact, we can consider that CCD=CCX=die is currently the default
> > assumption in QEMU. When future implementations require distinguishing between
> > these CCD/CCX concepts, we can simply introduce an additional "smp.tiles" and
> > map CCX to it. This may need a documentation or a compatibility option, but I
> > believe these extra efforts are worthwhile.
> > 
> > And "smp.tiles" means "how many tiles in a die", so I feel it's perfect
> > to describe CCX.
> 
> That indeed looks like a cleaner solution. However, I'm concerned about
> retaining compatibility with existing "dies". But yeah, that's a task for a
> later time.

Yes, it may be necessary to address some compatibility issues. But I think
this way could align with the topology mapping of the Linux kernel as much
as possible.

Thanks,
Zhao


