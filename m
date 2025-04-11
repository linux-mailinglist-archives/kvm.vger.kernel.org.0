Return-Path: <kvm+bounces-43137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 890FBA853FB
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 08:13:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD4859A00E1
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 06:13:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB92B27CCD8;
	Fri, 11 Apr 2025 06:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LsoQQeNb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C5A1EF0A9
	for <kvm@vger.kernel.org>; Fri, 11 Apr 2025 06:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744352030; cv=none; b=T1ZSVVietYUcCQGY9oxplRB98HrUCL0tRohd5huT5uVUFC/3mKkFJm7DfqQQKFdOXuys1CdzQgiF5ZjsIK7F3AFf23hbyBmUCItHj7aIcM8xmCmLPsDnWXoSxRTBF+IF4qaA9lXloCBF9JMnBY5I7ncGr0343nMayrZn0RXCu4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744352030; c=relaxed/simple;
	bh=XiD4Ot+jgvnkKI7STgAM9iTJOwfmABvmI0JlTGgCnBk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HX9J9ipsL/cZGJ/b9NL0GMa2PFMBlNj5vgOCbO+kssvFN4BVAP89LTzBazwKQjXjymJwSh5YlRieaxNROm+Jqq6SfFaCTOiJrk+0mKLkMlr+hT7HYzZwEpUuGFEh7ksRPmNiqSXXtn/bAiVnZfJwqcw2GPOMt4gxTM1Dar3ZThs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LsoQQeNb; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744352029; x=1775888029;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=XiD4Ot+jgvnkKI7STgAM9iTJOwfmABvmI0JlTGgCnBk=;
  b=LsoQQeNbBu6MNDNsQwU8geQuU59q+4S9bipQ91JsPwF8P2+b6dAEPyD9
   bHlQ5JFp4Fd8mJTaAcpPCGN50UTK7+vMvsKa4kNyCtzE46NgdFCOrsnLU
   VQa7DbNsHpE6ki9n1Q6FnjxiVULyMPQ4AUZ8uvSQtzN8wkGCaJltQYl+n
   rhePHprfEc8YGP3HZk7otTtuZr6KTEdS/xxEQiHgP54VOxpoMn1sBYX9G
   DYAfDHA13xn2hj1F2WbxWScsC+q5aMbn2bQZr10WYE4zP1QjWskWTTvc7
   sJx0B2MRSpG/BqHBEaT6jyr66YGWaQttOG3xzdha9fd9fD6dkOeJ2dsZ1
   w==;
X-CSE-ConnectionGUID: 2rBgGwYSS7qc4UaCyPSVYw==
X-CSE-MsgGUID: caoqruGrRv6+PCpHi4pD8A==
X-IronPort-AV: E=McAfee;i="6700,10204,11400"; a="56076139"
X-IronPort-AV: E=Sophos;i="6.15,203,1739865600"; 
   d="scan'208";a="56076139"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 23:13:48 -0700
X-CSE-ConnectionGUID: TUGIGU/aTYqXKX7y6P1t4Q==
X-CSE-MsgGUID: 7Ebq+NivTnqdNeSWdeYkxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,203,1739865600"; 
   d="scan'208";a="134219489"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa004.fm.intel.com with ESMTP; 10 Apr 2025 23:13:44 -0700
Date: Fri, 11 Apr 2025 14:34:34 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>, Eric Auger <eauger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>,
	Sebastian Ott <sebott@redhat.com>, Gavin Shan <gshan@redhat.com>,
	qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
	Dapeng Mi <dapeng1.mi@intel.com>, Yi Lai <yi1.lai@intel.com>
Subject: Re: [PATCH 1/5] qapi/qom: Introduce kvm-pmu-filter object
Message-ID: <Z/i3+l3uQ3dTjnHT@intel.com>
References: <20250409082649.14733-1-zhao1.liu@intel.com>
 <20250409082649.14733-2-zhao1.liu@intel.com>
 <878qo8yu5u.fsf@pond.sub.org>
 <Z/iUiEXZj52CbduB@intel.com>
 <87frifxqgk.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87frifxqgk.fsf@pond.sub.org>

On Fri, Apr 11, 2025 at 06:38:35AM +0200, Markus Armbruster wrote:
> Date: Fri, 11 Apr 2025 06:38:35 +0200
> From: Markus Armbruster <armbru@redhat.com>
> Subject: Re: [PATCH 1/5] qapi/qom: Introduce kvm-pmu-filter object
> 
> Zhao Liu <zhao1.liu@intel.com> writes:
> 
> > Hi Markus
> >
> > On Thu, Apr 10, 2025 at 04:21:01PM +0200, Markus Armbruster wrote:
> >> Date: Thu, 10 Apr 2025 16:21:01 +0200
> >> From: Markus Armbruster <armbru@redhat.com>
> >> Subject: Re: [PATCH 1/5] qapi/qom: Introduce kvm-pmu-filter object
> >> 
> >> Zhao Liu <zhao1.liu@intel.com> writes:
> >> 
> >> > Introduce the kvm-pmu-filter object and support the PMU event with raw
> >> > format.
> >> 
> >> Remind me, what does the kvm-pmu-filter object do, and why would we
> >> want to use it?
> >
> > KVM PMU filter allows user space to set PMU event whitelist / blacklist
> > for Guest. Both ARM and x86's KVMs accept a list of PMU events, and x86
> > also accpets other formats & fixed counter field.
> 
> But what does the system *do* with these event lists?

This is for security purposes, and can restrict Guest users from
accessing certain sensitive hardware information on the Host via perf or
PMU counter.

When a PMU event is blocked by KVM, Guest users can't get the
corresponding event count via perf/PMU counter.

EMM, if ¡®system¡¯ refers to the QEMU part, then QEMU is responsible
for checking the format and passing the list to KVM.

Thanks,
Zhao


