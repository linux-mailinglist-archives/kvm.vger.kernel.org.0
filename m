Return-Path: <kvm+bounces-28416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 056559983DB
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 12:36:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 176291C22BC1
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 10:36:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3968B1C0DCC;
	Thu, 10 Oct 2024 10:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CnM0V1/2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4BC19E7D0;
	Thu, 10 Oct 2024 10:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728556581; cv=none; b=DA4Wx4tDWeP7mFu7DCkMzyNZ5UpcTVMLKHVYANWdup9GJ90Xb7q9veN+ppXVvFCcLSopS4TqiRZPbLDa5Q6RcELFujAA9xX610AVvJArRaEDxUbKdVbYKaHYCvLZyitnKtNC7iKMqjkBfRT372k+LfHghplWr13MJjDi4ftz6eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728556581; c=relaxed/simple;
	bh=gQqKk10pAyRy63nmdJoeEtOLWCVNkzBN/hKzrk+TGN8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G+O40MBQazDmiEVyknQETgc9nFs/MhPGN3/f1qsJo1k/jei/YYQHnZcDkm6FTCGC1onUrDrdnciGYupYvtRHjmP5XYdgOiush5yrRcN2MEuGbdZ9Ov5t68hsPNEP5cSTzsD7KzOoAKlFniNCzjgJJxaDj1QT2RNVfQk3UfFi6bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CnM0V1/2; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728556580; x=1760092580;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gQqKk10pAyRy63nmdJoeEtOLWCVNkzBN/hKzrk+TGN8=;
  b=CnM0V1/2LfJGi63eOdKDp5hRzk3Qrhks7LsvHJpmklZUHd/N4wAxYL1F
   ZyhGvZgDPmzTnzT1ahdjOhjR+BXlOH5HBbkPd+jeCU6MuHIU4NIsTa2Dt
   3rqKdEuZ+abyTZ6oxm9OdJh7ICMUYibxjLU7Cl1X3DqXrNy3OncJBtLw9
   8GL1R5zVfJ7otTwROxNAT5+5KTmVeImfFh2iN55kDY+5a27a4INYmSvgu
   XWG1/ATlCtq5ifGfA54b8XG3hA4+uk/QN2IriL4TMTULrj2eyayZT4zvJ
   omenL+IF5OwCYrJdQ4fuo4JL+gmEKSdyfLhsSttvoiV9MV97Faz/fSR/z
   Q==;
X-CSE-ConnectionGUID: QysAjBI4QNuyhUNLkcGhsw==
X-CSE-MsgGUID: aUgEyZ1vTo2dbXItQWQOwA==
X-IronPort-AV: E=McAfee;i="6700,10204,11220"; a="27376827"
X-IronPort-AV: E=Sophos;i="6.11,192,1725346800"; 
   d="scan'208";a="27376827"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2024 03:36:19 -0700
X-CSE-ConnectionGUID: KGM/QkRPRoqUkEvTHk6vQw==
X-CSE-MsgGUID: nvI/NMsoRWGJ40Kksv9lww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,192,1725346800"; 
   d="scan'208";a="107396403"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.114])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2024 03:36:15 -0700
Date: Thu, 10 Oct 2024 13:36:09 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org, kai.huang@intel.com,
	isaku.yamahata@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 22/25] KVM: TDX: Use guest physical address to configure
 EPT level and GPAW
Message-ID: <ZweuGbBxy5ZfBi82@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-23-rick.p.edgecombe@intel.com>
 <f04c20f6-fce1-49e3-9cc8-c696032720fc@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f04c20f6-fce1-49e3-9cc8-c696032720fc@intel.com>

On Thu, Oct 10, 2024 at 05:13:43PM +0800, Xiaoyao Li wrote:
> On 8/13/2024 6:48 AM, Rick Edgecombe wrote:
> > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > 
> > KVM reports guest physical address in CPUID.0x800000008.EAX[23:16],
> > which is similar to TDX's GPAW. Use this field as the interface for
> > userspace to configure the GPAW and EPT level for TDs.
> > 
> > Note,
> > 
> > 1. only value 48 and 52 are supported. 52 means GPAW-52 and EPT level
> >     5, and 48 means GPAW-48 and EPT level 4.
> > 2. value 48, i.e., GPAW-48 is always supported. value 52 is only
> >     supported when the platform supports 5 level EPT.
> > 
> > Current TDX module doesn't support max_gpa configuration. However
> > current implementation relies on max_gpa to configure  EPT level and
> > GPAW. Hack KVM to make it work.
> 
> This patch needs to be squashed into patch 14.

Yes agreed that makes sense.

Regards,

Tony

