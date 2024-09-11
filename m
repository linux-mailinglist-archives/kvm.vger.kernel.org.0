Return-Path: <kvm+bounces-26498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 584D297507E
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 13:11:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8BE3D1C22AF8
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 11:11:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C29CD186617;
	Wed, 11 Sep 2024 11:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tbd2WXUW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479C148CDD;
	Wed, 11 Sep 2024 11:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726053071; cv=none; b=ESpoKIzpbTWbQEIJNGLw0F1Jpb4kchiQE6P4mNmoSW+3iJsApKw8U1B/+nvAZnVo+ZZa86J7TdznxcnNnpZ6kyj1LIk4x0ke3IVNq34svjg9herOVohn6TRNlCCuFf4TPeQw5ZhxftxQzWb27WNYbx0cRpLpVW6lzAp4JpjhJFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726053071; c=relaxed/simple;
	bh=TJKUhgN6N7ctiISRF1YLUsjTx+p+elgwMQtDSzGiZqA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G697zVdktwAOlow/AqZ9bNHzPG2BDqyWxBokAmfqvKaMmkGEXM8+x9EoYpcM7YiPzUbM3hwi4+kuX7qCh2r5PTWAqmxHX7H5WMr6e+EWsYSQThyZxOpCoUxUOYnsOAahvIZ2wu2ocwQNN6vmjiOSbch0C952fIysLKQd99pOCXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tbd2WXUW; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726053070; x=1757589070;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TJKUhgN6N7ctiISRF1YLUsjTx+p+elgwMQtDSzGiZqA=;
  b=Tbd2WXUWNb+caqP1QIu48/vIQo70dnUGOh6qovFxREaiiEy4Ze7Oo00l
   xjLG9/JamsKPEnGggcSiMq7xcDgFyK+/guV9ZIqa+HyUcG/t92MSVKa7c
   m7AgVlDDo008YU+n2Avd5Xr6jgwgyR8GEbY1KluIkoGW35zXdWvG6TemB
   +ZQf1Q2y7A1n/E15X6enspaWLoG1vZzdV0+vqG0LTZKc2kAoo/D23IZSr
   WleXpRu34Oeo6/q3xRX8drVgM/Cf9Y2m2naM3n7DTv/UDZjttzab4ifqW
   iEPcHnEK/1XT6LPyAxbSqPc6lNgtl4W86EzB21ods33X0hDgYwUXutjrg
   A==;
X-CSE-ConnectionGUID: uCa2n2tIRIWb63rAC9q3jQ==
X-CSE-MsgGUID: rB+G4yBjRLO7FBbFe5e1xg==
X-IronPort-AV: E=McAfee;i="6700,10204,11191"; a="35413477"
X-IronPort-AV: E=Sophos;i="6.10,219,1719903600"; 
   d="scan'208";a="35413477"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2024 04:11:09 -0700
X-CSE-ConnectionGUID: EyLeILBhT8GqQ9iza4CQjw==
X-CSE-MsgGUID: Ofww2NsUTBqempbtf7Le5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,219,1719903600"; 
   d="scan'208";a="72324954"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.117])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2024 04:11:05 -0700
Date: Wed, 11 Sep 2024 14:11:01 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
	kvm@vger.kernel.org, kai.huang@intel.com, isaku.yamahata@gmail.com,
	xiaoyao.li@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 21/25] KVM: x86: Introduce KVM_TDX_GET_CPUID
Message-ID: <ZuF6xa9RAR5dEf3f@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-22-rick.p.edgecombe@intel.com>
 <ZsLRyk5F9SRgafIO@yilunxu-OptiPlex-7050>
 <Zta4if4oEHiAIkz7@tlindgre-MOBL1>
 <a59e021f-fe90-41d1-aa8d-6ce0a0abcfcc@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a59e021f-fe90-41d1-aa8d-6ce0a0abcfcc@redhat.com>

On Tue, Sep 10, 2024 at 07:29:13PM +0200, Paolo Bonzini wrote:
> On 9/3/24 09:19, Tony Lindgren wrote:
> > > > +			gpa_t gpa_bits = gfn_to_gpa(kvm_gfn_direct_bits(vcpu->kvm));
> > > > +			unsigned int g_maxpa = __ffs(gpa_bits) + 1;
> > > > +
> > > > +			output_e->eax &= ~0x00ff0000;
> > > > +			output_e->eax |= g_maxpa << 16;
> > > Is it possible this workaround escapes the KVM supported bits check?
> > 
> > Yes it might need a mask for (g_maxpa << 16) & 0x00ff0000 to avoid setting
> > the wrong bits, will check.
> 
> The mask is okay, __ffs(gpa_bits) + 1 will be between 1 and 64.

OK

> The question is whether the TDX module will accept nonzero bits 16..23 of
> CPUID[0x80000008].EAX.

Just for reference, that's the 0x80000008 quirk as you noticed in 22/25.

Regards,

Tony

