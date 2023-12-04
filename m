Return-Path: <kvm+bounces-3343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EF8018036F2
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 15:36:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A3C121F21248
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 14:36:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5393B28DD2;
	Mon,  4 Dec 2023 14:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="JdCDOZG/"
X-Original-To: kvm@vger.kernel.org
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6670DFE;
	Mon,  4 Dec 2023 06:36:05 -0800 (PST)
Received: from localhost (mdns.lwn.net [45.79.72.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id EB68B2C5;
	Mon,  4 Dec 2023 14:36:04 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net EB68B2C5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1701700565; bh=f0Yupj2ffJkFfSQu1LkFmAj29K/A4z7XLIh5uvmaoSU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=JdCDOZG/EPrMlKDDKR6CSHU28p9XJy2B85GDso7BOW2Zs93Yin54yfma27//zNsvi
	 z3P1hN41DdKYieJjFI+HZkkJHWMz4y8xt5orjfZWlCOKmKBEW+B+gTZ6ph71FZgQgK
	 YZuJJQIs4d7vju/s4BcT58hLysn6r8jzCPjr0cfvS6q8nXUxETn4V97Lpr2kGBc9t9
	 pXsIWtmLl3E/r2U6AkO8Vq8T4ItV9/gMTLMq9CA3eCkstJlEJgMCxrqhfX6/SooArw
	 q1hVt4B7Tp40/y1xbgHef0LyVtRobrmLnXHavzDA4ns30Ij2V+JDLHGVvBFvNICuGV
	 Fbl2NZoloXxtA==
From: Jonathan Corbet <corbet@lwn.net>
To: Dimitri John Ledkov <dimitri.ledkov@canonical.com>,
 linux-doc@vger.kernel.org
Cc: linux-perf-users@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: Converting manpages from asciidoc to rst2man ?
In-Reply-To: <CADWks+Z=kLTohq_3pk_PdXs54B6tLn25u6avn_Q1FyXN2-sVDQ@mail.gmail.com>
References: <CADWks+Z=kLTohq_3pk_PdXs54B6tLn25u6avn_Q1FyXN2-sVDQ@mail.gmail.com>
Date: Mon, 04 Dec 2023 07:36:04 -0700
Message-ID: <87fs0iujaj.fsf@meer.lwn.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Dimitri John Ledkov <dimitri.ledkov@canonical.com> writes:

> Hi all,
>
> I was going through build-depends on linux kernel in Ubuntu and I
> noticed that whilst most documentation and man-pages are written in
> Rst format, there are a few that require asciidoc.
>
> $ git grep -l asciidoc -- '*Makefile*'
> tools/kvm/kvm_stat/Makefile
> tools/lib/perf/Documentation/Makefile
> tools/perf/Documentation/Makefile
> tools/perf/Makefile.perf

Interesting...I was unaware of those...

> Are both Rst and asciidoc preferred in the kernel Documentation? Or
> should we upgrade kvm_stat & perf manpages from asciidoc to rst2man?

In general we don't have a lot of man pages in the kernel, so it's not
something we've put a lot of thought into.  Ideally, I suppose, it would
be nice to get all of those man pages integrated into the RST docs
build, but it's not something that is likely to inspire any great sense
of urgency.

Thanks,

jon

