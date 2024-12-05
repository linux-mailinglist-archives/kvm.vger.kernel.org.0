Return-Path: <kvm+bounces-33125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54C5A9E5383
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 12:17:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15EBE2834E8
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 11:17:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A23AA1F471D;
	Thu,  5 Dec 2024 11:17:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F291DFE2B;
	Thu,  5 Dec 2024 11:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733397430; cv=none; b=q+Mk4oUDg4lAfUu3AopIXV01rA52YFG/ugUjKALLfOnb8wkodXRPLuKV+lXbQjOWqqLMY6Ptv3n6C52ilzh28ixoGUIgeEmKb3D49LxBnEVHIvZtQZJC+W5nyUTLIdRsJhHNd+fXJUmwjWHR8kur3mimbop5VixWkhOmRI6pTvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733397430; c=relaxed/simple;
	bh=RQkwyRD0doVFajjJ5Kd7+6rUV8dyJ/VQkaUXx4nT6Ls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SV5WgfuI4hyrJNazFOWLy0hdHGCqeIRm6hPGKCHgw50tPDDwtp+2bsbsY2021lFPjjzFKX6dTEtA/b0AyfHJP/IHICfp5RUY4b/8NlO4SFrbq0C7IhgEmHs+59igBReOT3hJ47TYqfDA0QJUdR2LWD91DNLVZxdhTvpB+mf08H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=fail smtp.mailfrom=kernel.org; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.org
X-CSE-ConnectionGUID: Ws9yMnk7SU+7FfyS6njkBw==
X-CSE-MsgGUID: biEF8o+sRqCw4zEGmzhpjA==
X-IronPort-AV: E=McAfee;i="6700,10204,11276"; a="37639116"
X-IronPort-AV: E=Sophos;i="6.12,210,1728975600"; 
   d="scan'208";a="37639116"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2024 03:17:08 -0800
X-CSE-ConnectionGUID: iDeKZM9URCS0267tyxyt4g==
X-CSE-MsgGUID: oPViH0/YQmiuYgFtgjW/vg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="99104601"
Received: from smile.fi.intel.com ([10.237.72.154])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2024 03:17:05 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.98)
	(envelope-from <andy@kernel.org>)
	id 1tJ9qv-000000044BE-02lr;
	Thu, 05 Dec 2024 13:17:01 +0200
Date: Thu, 5 Dec 2024 13:17:00 +0200
From: Andy Shevchenko <andy@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Arnd Bergmann <arnd@kernel.org>, linux-kernel@vger.kernel.org,
	x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Matthew Wilcox <willy@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Davide Ciminaghi <ciminaghi@gnudd.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 09/11] x86: rework CONFIG_GENERIC_CPU compiler flags
Message-ID: <Z1GLrISQEaXelzqu@smile.fi.intel.com>
References: <20241204103042.1904639-1-arnd@kernel.org>
 <20241204103042.1904639-10-arnd@kernel.org>
 <CAHk-=wh_b8b1qZF8_obMKpF+xfYnPZ6t38F1+5pK-eXNyCdJ7g@mail.gmail.com>
 <d189f1a1-40d4-4f19-b96e-8b5dd4b8cefe@app.fastmail.com>
 <CAHk-=wji1sV93yKbc==Z7OSSHBiDE=LAdG_d5Y-zPBrnSs0k2A@mail.gmail.com>
 <Z1FgxAWHKgyjOZIU@smile.fi.intel.com>
 <74e8e9c6-8205-413a-97a4-aae32042c019@app.fastmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74e8e9c6-8205-413a-97a4-aae32042c019@app.fastmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Thu, Dec 05, 2024 at 11:09:41AM +0100, Arnd Bergmann wrote:
> On Thu, Dec 5, 2024, at 09:13, Andy Shevchenko wrote:
> > On Wed, Dec 04, 2024 at 03:33:19PM -0800, Linus Torvalds wrote:
> >> On Wed, 4 Dec 2024 at 11:44, Arnd Bergmann <arnd@arndb.de> wrote:

...

> >> Will that work when you cross-compile? No. Do we care? Also no. It's
> >> basically a simple "you want to optimize for your own local machine"
> >> switch.
> >
> > Maybe it's okay for 64-bit machines, but for cross-compiling for 32-bit on
> > 64-bit. I dunno what '-march=native -m32' (or equivalent) will give in such
> > cases.
> 
> From the compiler's perspective this is nothing special, it just
> builds a 32-bit binary that can use any instruction supported in
> 32-bit mode of that 64-bit CPU,

But does this affect building, e.g., for Quark on my Skylake desktop?

> the same as the 32-bit CONFIG_MCORE2 option that I disallow in patch 04/11.

-- 
With Best Regards,
Andy Shevchenko



