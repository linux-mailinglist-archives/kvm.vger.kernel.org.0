Return-Path: <kvm+bounces-41982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CF94DA7079C
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 18:03:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4738816BB04
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 17:02:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1ADB25C6EA;
	Tue, 25 Mar 2025 17:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="m8d4PUdD"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CE42E339B
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 17:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742922164; cv=none; b=QBL6Pt1snVW3vQpk5gCi4ERMNK16iiUfTo34FC0/RZhcIo7QF4CQS9PfFllfu1wAlqbEBhKZXFDgetLisJ10DMVqWp0kaLicOYrJw8pk0xHJs1V8OF+SauAgmWofRe9GFxj9hhh/PVNf2MVnHLRaEtpwZTh1DkfS6wg1i5JwrGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742922164; c=relaxed/simple;
	bh=XXde8LJYQO8tatSoKIRCR8CfXJxdd+VGx9Dn01SUWvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uPTCaC5yJZMzd8nfbkk2zdxQAihIdirYDxcR70upaFKu45z5DE7vikKMbyGm9dFcxMIA48WF+y98W96GNKpTb3VOR35dYZ4EjT29UrWIeTlKW6wC3Vgx1J/j/No8f/SYdYbyhE9D7maZ4/OoZIWPFGWR3A/mM2F+y7CqcQlVaJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=m8d4PUdD; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 25 Mar 2025 10:02:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742922149;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Pvm/JJUDO3VfLlS+vzoxNGh7x3V6BVgwZ85y95H3Jjk=;
	b=m8d4PUdDuVu6yV2S9ASbtiIyxl+PhnNVBtqvXCEuz4sqzQhi9rqUL1UEXSJhw1/6qHwv0z
	WDa+0uTcyx1S2KWKI0iKyGevm7fPBT8ruEkIBYjK7NTBCEyyclQt61QymDZXCw3jN9JRtZ
	9G8XvtLYeRF0mDS7SrIeKTEFc6Do6dA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [RFC kvmtool 9/9] arm64: Get rid of the 'arm-common' include
 directory
Message-ID: <Z-LhoOxnQ9xpqL-Q@linux.dev>
References: <20250314222516.1302429-1-oliver.upton@linux.dev>
 <20250314222516.1302429-10-oliver.upton@linux.dev>
 <Z9xJ10c4pwJ-TF3o@raptor>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9xJ10c4pwJ-TF3o@raptor>
X-Migadu-Flow: FLOW_OUT

Hi Alex,

On Thu, Mar 20, 2025 at 05:01:11PM +0000, Alexandru Elisei wrote:
> Hi Oliver,
> 
> On Fri, Mar 14, 2025 at 03:25:16PM -0700, Oliver Upton wrote:
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arm64/arm-cpu.c                        | 4 ++--
> >  arm64/fdt.c                            | 4 ++--
> >  arm64/gic.c                            | 2 +-
> >  arm64/gicv2m.c                         | 2 +-
> >  arm64/include/{arm-common => }/gic.h   | 0
> >  arm64/include/kvm/kvm-arch.h           | 2 +-
> >  arm64/include/{arm-common => }/pci.h   | 0
> >  arm64/include/{arm-common => }/timer.h | 0
> 
> Looking at x86 and riscv, the pattern is to have the header files in
> <arch>/include/kvm, even if they're only used by the arch code.
> 
> Do we care about following this pattern?

I have no strong preference in either direction, I just did the laziest
thing here.

Thanks,
Oliver

