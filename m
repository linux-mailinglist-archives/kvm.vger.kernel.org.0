Return-Path: <kvm+bounces-25705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E018D969344
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 07:44:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 95CB91F2297A
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 05:44:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE61419C54B;
	Tue,  3 Sep 2024 05:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RtPuazrK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D58319C551;
	Tue,  3 Sep 2024 05:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725342273; cv=none; b=UWPjO6Sg7wNAHz0Uk4h6Cm/8OD49ieC5KyJW87/4hWLe8O5DDNPoqpDilNqJPqDhQ28XXZy9/tHSRN0N/e0AHpFSEiB9ty2+ymgWdtGh1cWigqstbi464xQCB8V6bWl8nJF5mNmVrpPKUHiA4uWucLKLKJlU47Y9Wglo/cUm2Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725342273; c=relaxed/simple;
	bh=XRlwMA50dP3WAnNvn79Eoc/ZXVvHXloTh9whwGUU7Iw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A9f7DzetShkyLhp0EZjGx39bs/h1PEwc//jkEu4ie3gDSU0PKNI854N5z7llqI7w5QT+835qH7DcwDB6okcYjTsK2feeEGCCy05CT/9jPLZkVK7w1V1A3XyxlVpLQ85ui7/DkIl/bgWfyxlLbRYQp/fKZ9I2P2FcerNaDqjrZvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RtPuazrK; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725342272; x=1756878272;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XRlwMA50dP3WAnNvn79Eoc/ZXVvHXloTh9whwGUU7Iw=;
  b=RtPuazrK6UZ0NtXJ1YZk0fWkB87XCnPTGREBrrKiXL5JdIC7AHaTSwA/
   mkoz97nW5Lyb0wMHYGai4DvWRRYs9uAFbg5hkggwHSmsGaBbB5SAyZaTe
   rQ/8cX/88jRsYNE3bDPw36Sd0g+MTpeDrEV+AFaK2PwKFIbsIzs1S1ObE
   eVK+YLWs3X1Yq+q87Vo4aFmW69IpXiGGd8scTA9pqZlVrPAjKIZQN8Zsj
   UE3K99UUp2q+dHOtHLVzlPbENunrMsRr13GLNZQFUz1QQ9Zk+sRBzlFUC
   fXT9iSoK5zN8HE35g7SuTHMcVinCRDNDkT2jinKDKnbYsmXXv+fYWc8pO
   A==;
X-CSE-ConnectionGUID: UySmByGhSoS4flnnnep6TA==
X-CSE-MsgGUID: Uc7oUEF0Q7+jKuaV2Fqgaw==
X-IronPort-AV: E=McAfee;i="6700,10204,11183"; a="24074991"
X-IronPort-AV: E=Sophos;i="6.10,197,1719903600"; 
   d="scan'208";a="24074991"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 22:44:32 -0700
X-CSE-ConnectionGUID: v8GGjcvjQ4Cedjxa/aJTyg==
X-CSE-MsgGUID: gvzVmqoaS4+vq06zHGVbjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,197,1719903600"; 
   d="scan'208";a="65517300"
Received: from cpetruta-mobl1.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.115])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 22:44:28 -0700
Date: Tue, 3 Sep 2024 08:44:22 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Chenyi Qiang <chenyi.qiang@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org, kai.huang@intel.com,
	isaku.yamahata@gmail.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [PATCH 14/25] KVM: TDX: initialize VM with TDX specific
 parameters
Message-ID: <ZtaiNi09UQ1o-tPP@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-15-rick.p.edgecombe@intel.com>
 <43a12ed3-90a7-4d44-aef9-e1ca61008bab@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43a12ed3-90a7-4d44-aef9-e1ca61008bab@intel.com>

On Tue, Sep 03, 2024 at 10:58:11AM +0800, Chenyi Qiang wrote:
> On 8/13/2024 6:48 AM, Rick Edgecombe wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > @@ -543,10 +664,23 @@ static int __tdx_td_init(struct kvm *kvm)
> >  		}
> >  	}
> >  
> > -	/*
> > -	 * Note, TDH_MNG_INIT cannot be invoked here.  TDH_MNG_INIT requires a dedicated
> > -	 * ioctl() to define the configure CPUID values for the TD.
> > -	 */
> > +	err = tdh_mng_init(kvm_tdx, __pa(td_params), &rcx);
> > +	if ((err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_INVALID) {
> > +		/*
> > +		 * Because a user gives operands, don't warn.
> > +		 * Return a hint to the user because it's sometimes hard for the
> > +		 * user to figure out which operand is invalid.  SEAMCALL status
> > +		 * code includes which operand caused invalid operand error.
> > +		 */
> > +		*seamcall_err = err;
> 
> I'm wondering if we could return or output more hint (i.e. the value of
> rcx) in the case of invalid operand. For example, if seamcall returns
> with INVALID_OPERAND_CPUID_CONFIG, rcx will contain the CPUID
> leaf/sub-leaf info.

Printing a decriptive error here would be nice when things go wrong.
Probably no need to return that information.

Sounds like you have a patch already in mind though :) Care to post a
patch against the current kvm-coco branch? If not, I can do it after all
the obvious comment changes are out of the way.

Regards,

Tony

