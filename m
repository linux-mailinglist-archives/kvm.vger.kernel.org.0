Return-Path: <kvm+bounces-33670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 41B949EFEF3
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 23:04:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F0C3188A505
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 22:04:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E9F71DB34B;
	Thu, 12 Dec 2024 22:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h/TQZS7f"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA1A15696E
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 22:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734041091; cv=none; b=Ex8sEnjf2tU8TCTOLHgooUuPz++vQdVXXqoriKjzW+ga5etG2XiY1GobSn8jG1KeiV5Ai0IpkyBojK+J6l4FmPanftf1HCXKZktGs2pnmQ5S8jEUlvS33rL3xo4/mVQ427kQ7yEBwKX388EZZNligehq/phzJnpPffogosSXVpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734041091; c=relaxed/simple;
	bh=fcLqNUWXZKdJqXPcRRGkSkyE41XaNnf3cqr6Sktyuwg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i0cAoaG1dMh5g44+jANn5k1Rz85II4nPDVcviN7i8LOfGmtmxNbbhNakIY5Eo/0GmnZNkTe5oNLfGi1a7fLp+9fgg/qfN6JzrWFVvOg2Z8DbK+dPmU9E1X0Ti6wULks9ggy2A5+2ZtCIcGHlNdLM8gNhZ3mJ3+ae5V4GJC9Rh/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h/TQZS7f; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734041089; x=1765577089;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=fcLqNUWXZKdJqXPcRRGkSkyE41XaNnf3cqr6Sktyuwg=;
  b=h/TQZS7fb6sI+bnREfnBjse+ATHi51XPlJc4mosm0yK6R8C2+59+JmSI
   HBHhyQ2PNWq7xukUzZPweh1erjZ4nc5DCIi5PexQ6QqPjbKyKWxASdEIi
   hE24n4+x73dHtcf5Ls7Q70Ygh8rnxN81jZnmGqQk0LaOxKlDn3qEhV/0S
   dfPFjZxANX4UXTIq/aqFGq7I/SdY3R1CLRH/Y7b9aC7coDSAxB67JuUPp
   Cdw37+8q4JAD63bSClIBptMY4d1dVz7hj72WcWrmsXj9KkfXm6AUaES+n
   pJBjQUWE8w00uLJJLbKkzdiAj3HSadABFSLg26FOl9waDJbLE3UvlhnBF
   g==;
X-CSE-ConnectionGUID: zUjDKUAZRCOINy5IGj55NQ==
X-CSE-MsgGUID: GV9SJowqST6lpw8/oMWh0w==
X-IronPort-AV: E=McAfee;i="6700,10204,11284"; a="34614680"
X-IronPort-AV: E=Sophos;i="6.12,229,1728975600"; 
   d="scan'208";a="34614680"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 14:04:49 -0800
X-CSE-ConnectionGUID: q2EolBEBSMe+Nve+GU6ohA==
X-CSE-MsgGUID: xqpa35YQRpCHDYTgrkEiCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,229,1728975600"; 
   d="scan'208";a="96589080"
Received: from puneetse-mobl.amr.corp.intel.com (HELO localhost) ([10.125.110.112])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 14:04:47 -0800
Date: Thu, 12 Dec 2024 16:04:44 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH v6 34/60] i386/tdx: implement tdx_cpu_realizefn()
Message-ID: <Z1td_BZPlZ5G9Zaq@iweiny-mobl>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-35-xiaoyao.li@intel.com>
 <82b74218-f790-4300-ab3b-9c41de1f96b8@redhat.com>
 <2bedfcda-c2e7-4e5b-87a7-9352dfe28286@intel.com>
 <44627917-a848-4a86-bddb-20151ecfd39a@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <44627917-a848-4a86-bddb-20151ecfd39a@redhat.com>

On Tue, Nov 05, 2024 at 12:53:25PM +0100, Paolo Bonzini wrote:
> On 11/5/24 12:38, Xiaoyao Li wrote:
> > On 11/5/2024 6:06 PM, Paolo Bonzini wrote:
> > > On 11/5/24 07:23, Xiaoyao Li wrote:
> > > > +static void tdx_cpu_realizefn(X86ConfidentialGuest *cg, CPUState *cs,
> > > > +                              Error **errp)
> > > > +{
> > > > +    X86CPU *cpu = X86_CPU(cs);
> > > > +    uint32_t host_phys_bits = host_cpu_phys_bits();
> > > > +
> > > > +    if (!cpu->phys_bits) {
> > > > +        cpu->phys_bits = host_phys_bits;
> > > > +    } else if (cpu->phys_bits != host_phys_bits) {
> > > > +        error_setg(errp, "TDX only supports host physical bits (%u)",
> > > > +                   host_phys_bits);
> > > > +    }
> > > > +}
> > > 
> > > This should be already handled by host_cpu_realizefn(), which is
> > > reached via cpu_exec_realizefn().
> > > 
> > > Why is it needed earlier, but not as early as instance_init?  If
> > > absolutely needed I would do the assignment in patch 33, but I don't
> > > understand why it's necessary.
> > 
> > It's not called earlier but right after cpu_exec_realizefn().
> > 
> > Patch 33 adds x86_confidenetial_guest_cpu_realizefn() right after
> > ecpu_exec_realizefn(). This patch implements the callback and gets
> > called in x86_confidenetial_guest_cpu_realizefn() so it's called after
> > cpu_exec_realizefn().
> > 
> > The reason why host_cpu_realizefn() cannot satisfy is that for normal
> > VMs, the check in cpu_exec_realizefn() is just a warning and QEMU does
> > allow the user to configure the physical address bit other than host's
> > value, and the configured value will be seen inside guest. i.e., "-cpu
> > phys-bits=xx" where xx != host_value works for normal VMs.
> > 
> > But for TDX, KVM doesn't allow it and the value seen in TD guest is
> > always the host value.  i.e., "-cpu phys-bits=xx" where xx != host_value
> > doesn't work for TDX.
> > 
> > > Either way, the check should be in tdx_check_features.
> > 
> > Good idea. I will try to implement it in tdx_check_features()

Is there any reason the TDX code can't just force cpu->host_phys_bits to true?

> 
> Thanks, and I think there's no need to change cpu->phys_bits, either. So
> x86_confidenetial_guest_cpu_realizefn() should not be necessary.

I was going to comment that patch 33 should be squashed here but better to just
drop it.

Ira

> 
> Paolo
> 

