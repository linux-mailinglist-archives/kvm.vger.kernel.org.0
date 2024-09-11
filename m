Return-Path: <kvm+bounces-26472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2195974C47
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 10:15:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 771E6B23283
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 08:15:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7BA213D8AC;
	Wed, 11 Sep 2024 08:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QH20hfCv"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B4213D510
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 08:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726042525; cv=none; b=jNZtxBKsh64jc2sF7aDfxq5eJ2Knn3HrT5v45AYb9KSyfiIJPOpzUlyARzu+tdtVgP7Q/bbatSoInKOxt3zRI7WBjrnOUOy3mwO6PZpnIfYQob5ikMh+ODtenSgj3dam/LDBShtl6mv2YZ8P2I67JkOe28gbNnF8qQqEdK+pJpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726042525; c=relaxed/simple;
	bh=eVUKOIYAw5aoyTC7VA+7kbvlur+eIyJI8kzLj6ED0Og=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G1vMYY9fmuc5sVhoIWcHJ7oH+QvC9MYoO2BbS7OU7Vr2bsTrnRpcm1eUvZmYWVrMER079jBk/P8htqpILwJlAoz3rAdHHL9cPSsdUxivcs7mSPCxRwLPGHitkY4utK6gHAo08r9YZ8nVe0qPpq6z+YdRn1VcfrmQPueEzeUYkCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QH20hfCv; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 11 Sep 2024 10:15:14 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726042520;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V987fBm6F9emK0J95GoYEdiv+Gd6fbUioktZ1lszOmg=;
	b=QH20hfCvh9Cvy1MeUujlEhHWUY3A3d/I1Y15631aaDCYouDnUvYEgYv1OOPLoU+JNzJQaz
	FcUHxiszgnbUqFJoRPq5D1Dlgfyo7jviih14D+7UJeIBS0ez7V96uKkLujVBgHmY5K4Imh
	SYjV42ODWjbbywoFaXc1JSYBM7/02a0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
	pbonzini@redhat.com, thuth@redhat.com, lvivier@redhat.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, nrb@linux.ibm.com, atishp@rivosinc.com, 
	cade.richard@berkeley.edu, jamestiotio@gmail.com
Subject: Re: [kvm-unit-tests PATCH 1/2] configure: Introduce add-config
Message-ID: <20240911-d6ec4d38091c5f852f825d17@orel>
References: <20240903143946.834864-4-andrew.jones@linux.dev>
 <20240903143946.834864-5-andrew.jones@linux.dev>
 <D431AYECDJV3.1AVQCTIRV2J4G@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D431AYECDJV3.1AVQCTIRV2J4G@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Sep 11, 2024 at 10:39:03AM GMT, Nicholas Piggin wrote:
> On Wed Sep 4, 2024 at 12:39 AM AEST, Andrew Jones wrote:
> > Allow users to add additional CONFIG_* and override defaults
> > by concatenating a given file with #define's and #undef's to
> > lib/config.h
> 
> That's a horrible config format lol, but probbaly the simplest way to
> get something working. What if you included the user config first, then
> make the generated config test ifndef before defining the default?

User config first and then #ifndef would indeed be better.

> 
> Is it better to have a config file than to just add more --options to
> configure? If we had thousands of options maybe, but so far we are
> getting by with configure options.

I have some unposted patches where I introduce two more configs, which
is what inspired me to stop adding configure command line options.

> I think I prefer that for now
> unless we wholesale moved everything to a .config style.

Moving to .config would be good, and importing and applying Kconfiglib
doesn't look too daunting either. We can put this --add-config idea on
hold until we've had a chance to experiment.

Thanks,
drew

