Return-Path: <kvm+bounces-33112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 192A79E4F31
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 09:03:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD9F0167BB4
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 08:03:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C621B1CEEA4;
	Thu,  5 Dec 2024 08:03:49 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2BC7E9;
	Thu,  5 Dec 2024 08:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733385829; cv=none; b=AcM5+DWmJU19fPlLalhknv2UvfoJFjHKkrjIZxZjaCPbSPY4Eb4hwX/sPNZTgrNVAJ5iCZEke572ftjEE+MHYVCNPAkirIhAcTsTHFeUvQE6Dh0CS914hX9tbL+/uvbeQQBWhuAptVxLhFUcHCU0tKVPckWzmuWQKJDKbLVZA6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733385829; c=relaxed/simple;
	bh=BtEY6LY5skviZ6QJefJW/gv0kGmA3u1dzpbnAWvNbmE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EzQKapb5WjZGXsAlieR0t6rgdTZSraOcqcN3V8JxRhKpyv6fpm5iokTjxLfFknWQrif/+9qMa6aR5FRlAwpXFzb625LE5fXKVxWRvn1DRZgORNK5ZZ73wig4Cv3R1/YY1LcuPTdu0peEqozm4RaWkLOBqmJ8t8lt3pc2eqCIzr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=fail smtp.mailfrom=gmail.com; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=gmail.com
X-CSE-ConnectionGUID: uFBDJMngSAuFrps1Nhwwkw==
X-CSE-MsgGUID: 6JFic3FxSvqlwKHAxxEzdQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11276"; a="36521338"
X-IronPort-AV: E=Sophos;i="6.12,209,1728975600"; 
   d="scan'208";a="36521338"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2024 00:03:47 -0800
X-CSE-ConnectionGUID: Bb3nMzzcQVynfmw/m5976w==
X-CSE-MsgGUID: R1MKQbMeReS45nGvnnpc2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="99057342"
Received: from smile.fi.intel.com ([10.237.72.154])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2024 00:03:43 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.98)
	(envelope-from <andy.shevchenko@gmail.com>)
	id 1tJ6pn-000000041LC-2a9E;
	Thu, 05 Dec 2024 10:03:39 +0200
Date: Thu, 5 Dec 2024 10:03:39 +0200
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Arnd Bergmann <arnd@kernel.org>, Ferry Toth <fntoth@gmail.com>,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Davide Ciminaghi <ciminaghi@gnudd.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 08/11] x86: document X86_INTEL_MID as 64-bit-only
Message-ID: <Z1FeWwoyJMA0Zx5z@smile.fi.intel.com>
References: <20241204103042.1904639-1-arnd@kernel.org>
 <20241204103042.1904639-9-arnd@kernel.org>
 <CAHp75VfzHmV2anw6C8iSCiwnJc2YNa+1aLDj6Frf9OZyGjD0MQ@mail.gmail.com>
 <206b50a2-922f-4a29-8c1a-b8695b19e65c@app.fastmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <206b50a2-922f-4a29-8c1a-b8695b19e65c@app.fastmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Wed, Dec 04, 2024 at 09:38:05PM +0100, Arnd Bergmann wrote:
> On Wed, Dec 4, 2024, at 19:55, Andy Shevchenko wrote:
> > On Wed, Dec 4, 2024 at 12:31 PM Arnd Bergmann <arnd@kernel.org> wrote:

...

> > It's all other way around (from SW point of view). For unknown reasons
> > Intel decided to release only 32-bit SW and it became the only thing
> > that was heavily tested (despite misunderstanding by some developers
> > that pointed finger to the HW without researching the issue that
> > appears to be purely software in a few cases) _that_ time.  Starting
> > ca. 2017 I enabled 64-bit for Merrifield and from then it's being used
> > by both 32- and 64-bit builds.
> >
> > I'm totally fine to drop 32-bit defaults for Merrifield/Moorefield,
> > but let's hear Ferry who might/may still have a use case for that.
> 
> Ok. I tried to find the oldest Android image and saw it used a 64-bit
> kernel, but that must have been after your work then.

I stand up corrected, what I said is related to Merrifield, Moorefield
may have 64-bit users on the phones from day 1, though.

...

> Changed now to
> 
>           The only supported devices are the 22nm Merrified (Z34xx) and
>           Moorefield (Z35xx) SoC used in the Intel Edison board and
>           a small number of Android devices such as the Asus Zenfone 2,
>           Asus FonePad 8 and Dell Venue 7.

LGTM, thanks!

...

> >> -         Intel MID platforms are based on an Intel processor and chipset which
> >> -         consume less power than most of the x86 derivatives.
> >
> > Why remove this? AFAIK it states the truth.
> 
> It seemed irrelevant for users that configure the kernel. I've
> put it back now.

It might be, but it was already there. Thanks for leaving it untouched.

-- 
With Best Regards,
Andy Shevchenko



