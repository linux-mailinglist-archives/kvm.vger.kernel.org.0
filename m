Return-Path: <kvm+bounces-61149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F0979C0CC87
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 10:56:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 819B31896EED
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 09:54:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39705302CDE;
	Mon, 27 Oct 2025 09:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hKqQ4cyC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABDF3019DA
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 09:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761558714; cv=none; b=nwylGUx5WhD2wEiYP9wuaP9ZCW2P0FneiH5OAVY45r64zkAdrBx8qD1WmFZQEtv3Mh4dcTDsTRuWdSt9A8b9oAObrji7ZjpSADCDdwgCFZ892+yiPMvnqjTma+rNxMFvxF8Vx84Yeh2odI49K66LnpVwcI5OIydqweAgdeh1ySw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761558714; c=relaxed/simple;
	bh=pOktcS9kwkPjEXa37/dQ2r0t6/Ys/P8rTUy3GS729DY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tp2uMp9ZQPdyAeqhfsXDMxCQe9FU3lxqEQPoLkwx01m+lEeP1bdtVO02v/Dn3UjDIueIecz0QdU57NucyE5hmsoR78Ozn5fUQXAP9XQKhGeqCNB5V5uJtXZwR04ma50xGSZ0H2+DHwpNZVTb2Bhrl/gsuEb6AXn1dxKvh6N85bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hKqQ4cyC; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761558712; x=1793094712;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pOktcS9kwkPjEXa37/dQ2r0t6/Ys/P8rTUy3GS729DY=;
  b=hKqQ4cyClEr4eGnGARhvZpNHyoZ/0rwuMMFT0tDY5EAyy8UI0+xh7IXt
   8fUO93aKG8Ym/fSCmKYhvT4BvC5I5DlAWHTQmdq+RtDcwncVzXV9ZTaL8
   zk650pUO+RHfSbjTUGNEh7aVcCUQMmUP0TcNVjYz/93uvedhvfHL5oL+I
   ftOnzuP5e98BztNoe79TpkZe3ga7D7bcstTYjLsYKQBNwzXoIqtc6wqZs
   oAfHmB7ZWb3y1EStMKn5vSNd1tRmUOS4nyoH9frMkpRoxn6W4K9YKq9Df
   6hiSAsdz2UrblQT5GFtO2l5x+7hdEgiqx8CJSupekgbJX+ADbJXEqJHWV
   Q==;
X-CSE-ConnectionGUID: Po+1v+jNSLutwmKldEuB/Q==
X-CSE-MsgGUID: 8+ll/jtnQbWuIgHIJfJ+Cg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63671431"
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="63671431"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 02:51:52 -0700
X-CSE-ConnectionGUID: hhfk4mV1TS25CUZXzNCQ3Q==
X-CSE-MsgGUID: DmQaWATJSeqDO7CLnF366Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="222213035"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa001.jf.intel.com with ESMTP; 27 Oct 2025 02:51:49 -0700
Date: Mon, 27 Oct 2025 18:13:59 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
	John Allen <john.allen@amd.com>, Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Farrah Chen <farrah.chen@intel.com>
Subject: Re: [PATCH v3 09/20] i386/cpu: Fix supervisor xstate initialization
Message-ID: <aP9F5wpOh3zOF1rr@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-10-zhao1.liu@intel.com>
 <5d501d23-74d3-45aa-a51e-52ef59002e1a@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d501d23-74d3-45aa-a51e-52ef59002e1a@intel.com>

On Mon, Oct 27, 2025 at 03:55:30PM +0800, Xiaoyao Li wrote:
> Date: Mon, 27 Oct 2025 15:55:30 +0800
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> Subject: Re: [PATCH v3 09/20] i386/cpu: Fix supervisor xstate initialization
> 
> On 10/24/2025 2:56 PM, Zhao Liu wrote:
> > From: Chao Gao <chao.gao@intel.com>
> > 
> > Arch lbr is a supervisor xstate, but its area is not covered in
> > x86_cpu_init_xsave().
> > 
> > Fix it by checking supported xss bitmap.
> > 
> > In addition, drop the (uint64_t) type casts for supported_xcr0 since
> > x86_cpu_get_supported_feature_word() returns uint64_t so that the cast
> > is not needed. Then ensure line length is within 90 characters.
> > 
> > Tested-by: Farrah Chen <farrah.chen@intel.com>
> > Signed-off-by: Chao Gao <chao.gao@intel.com>
> > Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> > ---
> >   target/i386/cpu.c | 9 ++++++---
> >   1 file changed, 6 insertions(+), 3 deletions(-)
> > 
> > diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> > index 5cd335bb5574..1917376dbea9 100644
> > --- a/target/i386/cpu.c
> > +++ b/target/i386/cpu.c
> > @@ -9707,20 +9707,23 @@ static void x86_cpu_post_initfn(Object *obj)
> >   static void x86_cpu_init_xsave(void)
> >   {
> >       static bool first = true;
> > -    uint64_t supported_xcr0;
> > +    uint64_t supported_xcr0, supported_xss;
> >       int i;
> >       if (first) {
> >           first = false;
> >           supported_xcr0 =
> > -            ((uint64_t) x86_cpu_get_supported_feature_word(NULL, FEAT_XSAVE_XCR0_HI) << 32) |
> > +            x86_cpu_get_supported_feature_word(NULL, FEAT_XSAVE_XCR0_HI) |
> 
> missing the "<< 32" here,

Yes, good catch.


