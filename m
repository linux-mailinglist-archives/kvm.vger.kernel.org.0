Return-Path: <kvm+bounces-61487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F1FDC20FAF
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 16:40:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E066E1A23F50
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 15:36:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72C1C3655D2;
	Thu, 30 Oct 2025 15:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FpyRmDh5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D24426773C
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 15:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761838526; cv=none; b=E+GLYLmmHmwdHbylFK85F+ms6Sb7Cl+hUSRq9iwXujSGKCcjbHpj+xC7A3/l31BPg6gsZX/kHshwRjywshXh5dWkegii4FT6R9QW4SGSMIyn88EYWYp1+O37l/KIKdSawjUsTycOqshVVgplKQV28+mFQy3lcJUWttCMvSruQxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761838526; c=relaxed/simple;
	bh=fCS4z6Ye0JP+cKo2Hrda8Sh3rYbjMNOQols/w0IsCtI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iHmgpz49NvNN12n47EPJOJ8Dg5YAKABz86/7rZII9dUtz3Urgo8Xw+stlCpDMuLpIb4iLQ6V2jNKMniUUEjnH9UyPOOEwl3eerWtWWHeDr5ZSSspSZS6AkfZTHYO7f7z2fONN+3CvAXbgODyEMzT/nwytD6LT7ChC+ESeNo54Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FpyRmDh5; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761838525; x=1793374525;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fCS4z6Ye0JP+cKo2Hrda8Sh3rYbjMNOQols/w0IsCtI=;
  b=FpyRmDh537kTi8J16cy8ctxrTEe/mUoNwqfUyx+svFQh0r39UsV0q3d3
   YQhZLcwV9lri7rAKpkV2VhE4aIzIqkVCnafHYsqSIXCQNOkOjxNoCYsew
   sZMcfQv/t5whsN91CdyW4rSbWZ8t0yUxD0uv2FDpK7GADNlUf8XeS+5ec
   z863pIWPhLJVdi5tMSIGu/5zHysfF0OzfDuHinvlMauhVFgl8No7+hEUW
   y1ghER6/JjupfOxBK9LQW9nLJd9PxiBmgdokSZkf8BHhQduwTNtrWNmNi
   CVDJOEbd3QHbzSliGEgYrvViikr7MPlHiZvW+lPh4ek3vVGo6jpzsXyuK
   Q==;
X-CSE-ConnectionGUID: aCmOyIBXSuiS/NBpOcA8cw==
X-CSE-MsgGUID: 5pBm5sxuR8SfRh/JbRmBDQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="81401214"
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="81401214"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 08:35:25 -0700
X-CSE-ConnectionGUID: qynHfdgJSmyEQZV8k6P6DA==
X-CSE-MsgGUID: amNjm247S6SdOghf6h+reg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="186721596"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa010.fm.intel.com with ESMTP; 30 Oct 2025 08:35:21 -0700
Date: Thu, 30 Oct 2025 23:57:33 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Chenyi Qiang <chenyi.qiang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
	John Allen <john.allen@amd.com>, Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Farrah Chen <farrah.chen@intel.com>
Subject: Re: [PATCH v3 12/20] i386/cpu: Add CET support in CR4
Message-ID: <aQOK7b5VAzH8eiKk@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-13-zhao1.liu@intel.com>
 <bb8609f2-a17b-42ff-9784-379be0b77502@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb8609f2-a17b-42ff-9784-379be0b77502@intel.com>

> > @@ -274,7 +275,7 @@ typedef enum X86Seg {
> >                  | CR4_LA57_MASK \
> >                  | CR4_FSGSBASE_MASK | CR4_PCIDE_MASK | CR4_OSXSAVE_MASK \
> >                  | CR4_SMEP_MASK | CR4_SMAP_MASK | CR4_PKE_MASK | CR4_PKS_MASK \
> > -                | CR4_LAM_SUP_MASK | CR4_FRED_MASK))
> > +                | CR4_LAM_SUP_MASK | CR4_FRED_MASK | CR4_CET_MASK))
> 
> Maybe put CR4_CET_MASK between PKE and PKS to keep it in order.

Sure, good idea.

Regards,
Zhao


