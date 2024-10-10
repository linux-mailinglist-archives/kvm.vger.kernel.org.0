Return-Path: <kvm+bounces-28387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 23CCA9980BE
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 10:50:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8E4E284CE5
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 08:50:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 387661A0AF7;
	Thu, 10 Oct 2024 08:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JmeV+bmo"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E24A1A3BAD
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 08:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728549480; cv=none; b=SNFkXcxPnYAEhJ5hc2fMmGlLqFIqd45UdSeiGgeskzarXux6z6X0r6Z3L7KjKEN2sto+0y2Ci3HaS0iCT7nsUYleIXN2ypcc7aet2lW6t06/UT25JHEyfqPKmjjlz7EsYF+uSoLj8+dDv0LPML0p7t5fbdezUVcy0NGvIgdj5xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728549480; c=relaxed/simple;
	bh=I3v9XZaCnbgzG8qvgOhB8p5WvceS8eUTl7Jj1GMKrcI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VJbp3F/tWc2NKM9y06xtmmTZkLZ+5stWL058U0JqDmvMyity4fC8sjUlyfbeK0oYl/dq97taKgL0YFTmIowQTGQkn8t92jBiwXaZm73BhNLagwB4FZIK1XJst4xehtoVWvyFYdfT/8bMiJ5nycLPjsEM9uDRIp1GvBUv+TROs3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JmeV+bmo; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 10 Oct 2024 10:37:50 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728549475;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MVBLh/e83RR1WpyIyTgYtU85Tbp7ULy6fwWWu8YecZk=;
	b=JmeV+bmoTg6N+/84frnBsG1LlIMGvhtmJlOyAabb6iFCjOgw1C5F87+GMEl95VikMT/RKP
	k0u7i4OccW4AH2fhP+7Erja6YLi2LHqpCzVTOjtoCPqSctGUVyQ+sYA1//sitlkduOwLxg
	5dfn2TSp7Y/5oG+Nr5wCt7lP+9Kr91M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nico Boehr <nrb@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>, 
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>, Thomas Huth <thuth@redhat.com>, linux-s390@vger.kernel.org, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 1/7] lib: Add pseudo random functions
Message-ID: <20241010-32dfe265772517ca7d986989@orel>
References: <20240620141700.4124157-1-nsg@linux.ibm.com>
 <20240620141700.4124157-2-nsg@linux.ibm.com>
 <172854874748.172737.3850110698077968232@t14-nrb.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172854874748.172737.3850110698077968232@t14-nrb.local>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 10, 2024 at 10:25:47AM GMT, Nico Boehr wrote:
> Quoting Nina Schoetterl-Glausch (2024-06-20 16:16:54)
> > Add functions for generating pseudo random 32 and 64 bit values.
> > The implementation uses SHA-256 and so the randomness should have good
> > quality.
> > Implement the necessary subset of SHA-256.
> > The PRNG algorithm is equivalent to the following python snippet:
> > 
> > def prng32(seed):
> >     from hashlib import sha256
> >     state = seed.to_bytes(8, byteorder="big")
> >     while True:
> >         state = sha256(state).digest()
> >         for i in range(8):
> >             yield int.from_bytes(state[i*4:(i+1)*4], byteorder="big")
> 
> Thomas, Andrew,
> do you want to take this patch or is it OK it if comes with the whole
> series via s390x tree?

It's already merged, commit e83373301c43 ("lib: Add pseudo random functions")

Thanks,
drew

