Return-Path: <kvm+bounces-4380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7801A811B98
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 18:54:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7D0D282645
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 17:54:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 395CA59553;
	Wed, 13 Dec 2023 17:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rpYpcepw"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1112B93
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 09:53:56 -0800 (PST)
Date: Wed, 13 Dec 2023 18:53:51 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1702490034;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VuclNBNbIiDYd23oZT5bv7JSGswBpCzrTS//DedbxCY=;
	b=rpYpcepwG8/MY7sdVTet5OgULPcfBMrBBBqCkiKd1wYTWe+ixkRJHEkecf8KHYLs9obDCh
	qs4phzLUHAOsHaQDCepAZjvAQ8ixMmALlN+o3su8ubxj0kLEWpSg1kZZrBAwIQj7bOvdJK
	aYs16CdTkvY0+ZukmOrYs3qA8HvRCiY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: Thomas Huth <thuth@redhat.com>, Nico Boehr <nrb@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 1/5] lib: Add pseudo random functions
Message-ID: <20231213-d38a53f4d505a631ead7af80@orel>
References: <20231213124942.604109-1-nsg@linux.ibm.com>
 <20231213124942.604109-2-nsg@linux.ibm.com>
 <20231213-8407f7ddc3a972de2715db9c@orel>
 <ed6b4a7188389617ffc85453e9270ffadd863a01.camel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ed6b4a7188389617ffc85453e9270ffadd863a01.camel@linux.ibm.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Dec 13, 2023 at 06:43:51PM +0100, Nina Schoetterl-Glausch wrote:
> On Wed, 2023-12-13 at 14:38 +0100, Andrew Jones wrote:
> > On Wed, Dec 13, 2023 at 01:49:38PM +0100, Nina Schoetterl-Glausch wrote:
> > > Add functions for generating pseudo random 32 and 64 bit values.
> > > The implementation is very simple and the randomness likely not
> > > of high quality.
> 
> [...]
> 
> > Alex Bennée posted a prng patch a long time ago that never got merged.
> > 
> > https://www.spinics.net/lists/kvm-arm/msg50921.html
> > 
> > would it be better to merge that?
> 
> Well, it's hard to say what metric to apply here.
> How good does the randomness need to be?

Better randomness would improve coverage for random sample set type tests
and possibly help stress more for stress tests.

> I chose a minimal interface that should be amendable to evolution.
> That's why the state is hidden behind a typedef.
> I think this would be good for Alex' patch, too, and there is nothing gained
> by exposing the implementation by prefixing everything with isaac.

I agree.

> My patch is also simpler to review.
> But I'm certainly not opposed to better algorithms.

Do you mind reposting Alex's patch, maintaining his authorship, but with
your interface changes?

Thanks,
drew

