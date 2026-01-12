Return-Path: <kvm+bounces-67680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6491FD102FD
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 01:41:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 10FB230505A5
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 00:41:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 522721E8342;
	Mon, 12 Jan 2026 00:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TVSv0zNH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06646F2F2;
	Mon, 12 Jan 2026 00:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768178499; cv=none; b=pS95D5h5FBzlw6xzYFZpUVfr1rahzMzAnXdV7SysEcjSuKQliM4P4W8z3W7uf0yyDUoEW3cu3x8e6Q6GRnedeCqnRgNs+ux4wU6Tp0CvpI7PF8dRB10QVJR9dP2an3SxArxgaokwtho+wbACjZjTuNuQc2+7d26ECmJHFFHOggA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768178499; c=relaxed/simple;
	bh=f29n6SEDgdX326rQS0iXN+uixIdO75WX44yumqkLtLU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LlOtMbMQaP/wrFAAhC06JFP+q0spuiclFzlO2xD3YDwi8HGF0ge1vR81YJy75qi9gKIOgTllyPSR8eBOkwt8P2hKCklUOoy4TqXD9HhJhWyIYmaWYX0ZepujeA38h2aFWugZQFtY85zdUglKaKC9ylwn2FfaY0mdK0/ll2oxgds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TVSv0zNH; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768178498; x=1799714498;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=f29n6SEDgdX326rQS0iXN+uixIdO75WX44yumqkLtLU=;
  b=TVSv0zNHr4jWBhnXSBMh25b7/U5t3CRLxZTM249hoHB52FtIdDgr/Xm3
   lNvSHjPj6/+HD+ndN3vtK0h0AP9zUNmr2DvdPh7WP/wD7bXS5kdabNNRD
   FyBI2eeHutqqdfqwXVQa7yGRtBvRpGMuQky1rWx4cQfW2BurVXEuxhl5/
   zfMH3eGo4sDRmMgchURBrU5usaCkdrAPdet4BnDP8mySqRQFVG000HWnn
   Ab7QA9JQ1NH83lGZ9ioWsHx7W5bhA0jBmpr6G8Y2WyVPFN0Fz9z8uz5OW
   U+/QbtiWFUwMsh7QBdtFYKjY5OAjvrGWsoWmdLrwSDhBmlOPdRjt64rBj
   g==;
X-CSE-ConnectionGUID: TmpITj7kRISidb+SG5uMxA==
X-CSE-MsgGUID: JA5nzm2ASGGdYd2O/7K/bg==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="94931270"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="94931270"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 16:41:38 -0800
X-CSE-ConnectionGUID: fojhc3eKRNWNN2sX2qoO4w==
X-CSE-MsgGUID: 7pab6++EQASEiuiXUqrFjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="203107411"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa006.jf.intel.com with ESMTP; 11 Jan 2026 16:41:33 -0800
Date: Mon, 12 Jan 2026 08:24:09 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"Huang, Kai" <kai.huang@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>,
	"Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v4 04/16] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
Message-ID: <aWQ/KSgH49t0MIZO@yilunxu-OptiPlex-7050>
References: <aUut+PYnX3jrSO0i@yilunxu-OptiPlex-7050>
 <0734a6cc7da3d210f403fdf3e0461ffba6b0aea0.camel@intel.com>
 <aVyJG+vh9r/ZMmOG@yilunxu-OptiPlex-7050>
 <94b619208022ee29812d871eeacab4f979e51d85.camel@intel.com>
 <aV32uDSqEDOgYp6L@yilunxu-OptiPlex-7050>
 <44fb20f8cfaa732eb34c3f5d3a3ff0c22c713939.camel@intel.com>
 <aV+o1VOTxt8hU4ou@yilunxu-OptiPlex-7050>
 <b4af0f9795d69fdc1f6599032335a2103c2fe29a.camel@intel.com>
 <aWBlcCUvybAYWed8@yilunxu-OptiPlex-7050>
 <4b75ddb133d35d133725ba270a9dfcb9acda38b4.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b75ddb133d35d133725ba270a9dfcb9acda38b4.camel@intel.com>

On Fri, Jan 09, 2026 at 04:05:30PM +0000, Edgecombe, Rick P wrote:
> On Fri, 2026-01-09 at 10:18 +0800, Xu Yilun wrote:
> > On the other hand, the cost of a newly designed firmware interface
> > for an already online functionality is not low, especially when you
> > want backward compatibility to old TDX Module. The worst case is we
> > keep both sets of the code...
> 
> I think TDX module changes are something to consider long term. We
> already discussed not overhauling the metadata reading again ahead of
> the current work, so I don't think there is anything else to discuss
> here.

I agree. We don't have to introduce new interfaces for optional feature
checking. That's another topic.

