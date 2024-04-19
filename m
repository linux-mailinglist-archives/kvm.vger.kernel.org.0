Return-Path: <kvm+bounces-15297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 89A648AB014
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 16:04:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DB78285336
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 14:04:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED5AA12D76F;
	Fri, 19 Apr 2024 14:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jYt/u8bH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D2312D1E7;
	Fri, 19 Apr 2024 14:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713535355; cv=none; b=FBJbKLO8JJjqxziLdt71erWqO8e4eHxAUs5gCdn/9N965BbTQbMqWrRKZ6HWBK4s41tVJZ3jXIAu6K9rk+Lt1VVvVR+fNMK2tfrixvPnzjMeekv2xlFcdmAS7x1m8ZjPzs5FeKGFJe07xvqcvrW0C+yr/HiKXna/A1YTkyaUa5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713535355; c=relaxed/simple;
	bh=Ja3+Ie6Jc53FYU2X0JbI5M6SoFSf4BFAJXi850lyzcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KCbEp0IlSSgnWemGU6EcqLUNHuZR9XXVrRDkuqrM+mUPO0thq8xeCKilqQwVYma3mg8+6RR3QDEgoirnT2bnTTZbmBnPJu/aTbILxprBEkoSYs8bvzdjg7YwLNF6gXbLnMoaDxCr/Wp3mKQF6N4QyZXtGR2EfCEDnCxw78dsTA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jYt/u8bH; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713535354; x=1745071354;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Ja3+Ie6Jc53FYU2X0JbI5M6SoFSf4BFAJXi850lyzcs=;
  b=jYt/u8bHKQpXhXaH6JQ8OIdHlj9lIx2Qvdda8xHjUo0mbkOBPa3is1Dx
   ibbxPzRAQB31NS2AExOd16Z0eZi52ID+pwmWj4W7aDuCj8SLRHycnqAWA
   U5zvzKfLbw7IKq+G2HZfqkEd1O1ojxeUrES5zzY3w26/8fJc+iPS8WeKS
   QiKO15FmOH8xiM5yHtYD4pJV/UIs2ybEfDXGzGrF5rlrVVj/STAJ9dnPi
   1sXsrF0S2ENkWmqKwwJ/+Kjiyz0SkbnAneoJua6mKMCpCQSm9QGPCanur
   Cxx03K6fXiIMjDiNslsR29sgiufqGDatlDg0uB3n8n4EMGjou33MR/PQF
   A==;
X-CSE-ConnectionGUID: RGKXi6CeTA6+P9qngYevnA==
X-CSE-MsgGUID: ZmTMDvHNSj+BFBU3WjOWSQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11049"; a="8997232"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="8997232"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 07:02:23 -0700
X-CSE-ConnectionGUID: ATRwipnzQiGvAK1Qji5L7A==
X-CSE-MsgGUID: Tw7rUNNuTCqbe22QHc0+jQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="23366460"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa009.fm.intel.com with ESMTP; 19 Apr 2024 07:02:20 -0700
Date: Fri, 19 Apr 2024 21:57:05 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, isaku.yamahata@intel.com, xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com, rick.p.edgecombe@intel.com
Subject: Re: [PATCH 1/7] KVM: Document KVM_MAP_MEMORY ioctl
Message-ID: <ZiJ4McRA1zqcSCjN@yilunxu-OptiPlex-7050>
References: <20240417153450.3608097-1-pbonzini@redhat.com>
 <20240417153450.3608097-2-pbonzini@redhat.com>
 <ZiAw1jd8840jXqok@google.com>
 <CABgObfYNNgpwOWFNmhHED7wL72Gi7sbFi5_ED_B7f-BUO+nrZg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfYNNgpwOWFNmhHED7wL72Gi7sbFi5_ED_B7f-BUO+nrZg@mail.gmail.com>

On Wed, Apr 17, 2024 at 10:37:00PM +0200, Paolo Bonzini wrote:
> On Wed, Apr 17, 2024 at 10:28 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Wed, Apr 17, 2024, Paolo Bonzini wrote:
> > > +4.143 KVM_MAP_MEMORY
> > > +------------------------
> > > +
> > > +:Capability: KVM_CAP_MAP_MEMORY
> > > +:Architectures: none
> > > +:Type: vcpu ioctl
> > > +:Parameters: struct kvm_map_memory (in/out)
> > > +:Returns: 0 on success, < 0 on error

The definition of *success* here doesn't align with below comments.
Maybe replace success with a clearer definition, e.g. 0 when all or
part of the pages are processed. < 0 when error and no page is
processed.

> > > +
> > > +Errors:
> > > +
> > > +  ========== ===============================================================
> > > +  EINVAL     The specified `base_address` and `size` were invalid (e.g. not
> > > +             page aligned or outside the defined memory slots).
> >
> > "outside the memslots" should probably be -EFAULT, i.e. keep EINVAL for things
> > that can _never_ succeed.
> >
> > > +  EAGAIN     The ioctl should be invoked again and no page was processed.
> > > +  EINTR      An unmasked signal is pending and no page was processed.
> >
> > I'm guessing we'll want to handle large ranges, at which point we'll likely end
> > up with EAGAIN and/or EINTR after processing at least one page.
> 
> Yes, in that case you get a success (return value of 0), just like read().

[...]

> >
> > > +When the ioctl returns, the input values are updated to point to the
> > > +remaining range.  If `size` > 0 on return, the caller can just issue
> > > +the ioctl again with the same `struct kvm_map_memory` argument.
> >
> > This is likely misleading.  Unless KVM explicitly zeros size on *every* failure,
> > a pedantic reading of this would suggest that userspace can retry and it should
> > eventually succeed.
> 
> Gotcha... KVM explicitly zeros size on every success, but never zeros
> size on a failure.

Thanks,
Yilun

