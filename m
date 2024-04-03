Return-Path: <kvm+bounces-13484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 17CE1897757
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 19:51:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6CEA28277C
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 17:51:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E151157A74;
	Wed,  3 Apr 2024 17:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iwj0ayyN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87CF152DFF;
	Wed,  3 Apr 2024 17:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712165627; cv=none; b=m0FpmRQ1eOVSu4WFUW+dPI9fVlz7G5LYWaGRLmL6OtDJHOBg53OMWavCwK7avGbS1Z7t7f6P/N4L76hMeQ0+qXr23UGZ0rMxzNwTv519A7LIlrXHSBYGWhn6b1HwmZhHkUJ4GRbc8PdJlp9WHwDOlLw0uoJtNcpw7Yni+v7fn5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712165627; c=relaxed/simple;
	bh=9M6pQXCLQk8hrqWFX4ZHDR4Ubl2/SRKz80hJnhH60ZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nwFnx1C+ndsl8EiKLZiZohoYWSrCTyabxZHxXy3C1s58bBZoeq7qfArAQ2RfzRY+NCyLI4+glMP7ll+JM14iah/6HTtPF0FDfdeIzvevRLWDqHJAcIKjyTZRI+3eNlRDHhysCQ+FqFum6ED4nyclsSaw8MQml12vjx+knZz5lGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iwj0ayyN; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712165626; x=1743701626;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9M6pQXCLQk8hrqWFX4ZHDR4Ubl2/SRKz80hJnhH60ZI=;
  b=iwj0ayyNWJXqVG3yNMuQQqYCNccw8/AEzJTK39/4YOT0f2hsH+1oCmJ8
   /pcLhX0A63z+IkjCF5Sm7CM4UezEIy4nlqhE3P/JGXDAff1tzGwbW6Pr9
   z9OjLuIMEOfXwqo3nzS93UbZW1PyGPgaQIT4zmcyldwdYieZb/BKYYCm1
   K8oczPb/Wv2RVDP/TBYD1gOATUVc34Y94TgIImNMvyFGfKx5aP3pV8XHo
   k8DTJdeLKA+V8lxiRNDFukLyljS5yFBgBNwq6bqtw8aVQFApGPltMoEKJ
   HMqyRtWuXlBes+clj2Unw5fxIWdOHr8PdwcuELyEdO9xc7wIoHSbRrJvp
   g==;
X-CSE-ConnectionGUID: NwdNRhD7R+a/KcyEkybAnw==
X-CSE-MsgGUID: 0gWPP1PUSuyYE7us8IgPOg==
X-IronPort-AV: E=McAfee;i="6600,9927,11033"; a="7531216"
X-IronPort-AV: E=Sophos;i="6.07,177,1708416000"; 
   d="scan'208";a="7531216"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2024 10:33:45 -0700
X-CSE-ConnectionGUID: U2jYK7gtQ2OMeEzcNs+Erg==
X-CSE-MsgGUID: R9bihAgVSIeuhhS5gpnUwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,177,1708416000"; 
   d="scan'208";a="41673836"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2024 10:33:44 -0700
Date: Wed, 3 Apr 2024 10:33:44 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 067/130] KVM: TDX: Add load_mmu_pgd method for TDX
Message-ID: <20240403173344.GF2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <bef7033b687e75c5436c0aee07691327d36734ea.1708933498.git.isaku.yamahata@intel.com>
 <331fbd0d-f560-4bde-858f-e05678b42ff0@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <331fbd0d-f560-4bde-858f-e05678b42ff0@linux.intel.com>

On Mon, Apr 01, 2024 at 11:49:43PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > For virtual IO, the guest TD shares guest pages with VMM without
> > encryption.
> 
> Virtual IO is a use case of shared memory, it's better to use it
> as a example instead of putting it at the beginning of the sentence.
> 
> 
> >   Shared EPT is used to map guest pages in unprotected way.
> > 
> > Add the VMCS field encoding for the shared EPTP, which will be used by
> > TDX to have separate EPT walks for private GPAs (existing EPTP) versus
> > shared GPAs (new shared EPTP).
> > 
> > Set shared EPT pointer value for the TDX guest to initialize TDX MMU.
> May have a mention that the EPTP for priavet GPAs is set by TDX module.

Sure, let me update the commit message.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

