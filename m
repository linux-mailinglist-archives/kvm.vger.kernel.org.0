Return-Path: <kvm+bounces-1137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 444707E5044
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 07:21:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 694941C20B14
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 06:21:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AD33D26E;
	Wed,  8 Nov 2023 06:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="azWoiZcn"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DF8CA78
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 06:21:35 +0000 (UTC)
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD191BE
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 22:21:34 -0800 (PST)
Date: Wed, 8 Nov 2023 07:21:30 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1699424492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dpJvBcOas5VxP912xJGgbL8aXmWviBYqEfIMwRmZhaE=;
	b=azWoiZcn4vQ9Fo8yxv6lzJWvSsUrkJEiwm3AVg3jWvDDKQKLg3EVYpiWpnuNF4KbwPLbAZ
	a1S6Ni5kz6u1YntsVxhiu1WBZRJImzwwdel6fEDXDWJ9dDrI9msBrXI4Qea6LOePxd7twu
	ev92JbUGySp3QD+mI3LThMR8k90ySHM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Eric Auger <eric.auger@redhat.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, eric.auger.pro@gmail.com, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev, 
	jarichte@redhat.com
Subject: Re: [kvm-unit-tests PATCH] arm: pmu-overflow-interrupt: Increase
 count values
Message-ID: <20231108-16a8164e368af66f5928c30e@orel>
References: <20231103100139.55807-1-eric.auger@redhat.com>
 <ZUoIxznZwPyti254@monolith>
 <5d93f447-c2c5-4c41-b0ea-9108736a2372@redhat.com>
 <ZUpEPbILA-idXISd@monolith>
 <78773d4c-21b6-4366-a1ec-da42286d2458@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78773d4c-21b6-4366-a1ec-da42286d2458@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Nov 07, 2023 at 03:28:12PM +0100, Eric Auger wrote:
> 
> 
> On 11/7/23 15:05, Alexandru Elisei wrote:
...
> > By the way, pmu_stats is not declared volatile, which means that the
> > compiler is free to optimize accesses to the struct by caching previously
> > read values in registers. Have you tried declaring it as volatile, in case
> > that fixes the issues you were seeing?
> In my case it won't fix the issue because the stats match what happens
> but your suggestion makes total sense in general.
> 
> I will add that.
>

We also have READ/WRITE_ONCE() in lib/linux/compiler.h

Thanks,
drew

