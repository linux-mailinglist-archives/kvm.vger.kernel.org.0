Return-Path: <kvm+bounces-33122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C14189E51C1
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 11:10:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5EA531881F35
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 10:10:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E954C21764C;
	Thu,  5 Dec 2024 10:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="Sc5Z0v62";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="BaiZmjW5"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2863D1D5CC2;
	Thu,  5 Dec 2024 10:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733393405; cv=none; b=Al2VyhufYhYEKH/qWvdMRK2omZdUpyVNzF3sO44MWlMAiJ1XOu0l00H7yh7D95ixrlxwVjCkT86QIuFqruB3SH4V6iY50BcdPpzz1dtNq1YS2ektFBhiv5DTcjw1nOMwtYlEoo/vN46qRTDBog8GGg41AvJTV4P3t59XoD/5f0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733393405; c=relaxed/simple;
	bh=Uye7Sg7D5JhsboEsNHfZkUDA25xAWur279dkqxnPAXc=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=uAn/tLRNbvGm0sYthn+mhiDz5J1HdcSl/dKYEgXSi5MqkJ/u0QOqrDGRRltRjF2Dkcphj6KcE1lH7HLUAvimBep/FHQjkRr2muetmwlbQstaG8/ZAnGX574BcjHENyFfhCsD6+t5dNFFjtoj2+3xyLLUwS4+bf4hpkZ9LvrEprE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=Sc5Z0v62; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=BaiZmjW5; arc=none smtp.client-ip=202.12.124.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfhigh.stl.internal (Postfix) with ESMTP id EF60E254021E;
	Thu,  5 Dec 2024 05:10:02 -0500 (EST)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-10.internal (MEProxy); Thu, 05 Dec 2024 05:10:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1733393402;
	 x=1733479802; bh=FSPKuoKyCdYS29EwGZWiI7JAIKFRf2AXJz4FVE+fs2c=; b=
	Sc5Z0v62Jq1g3a51rnsVQX5t+mLhb124Dy7WZLhEUD7FeFjLfbCwuLl4MnRXtM46
	d2vvHkPo1etp7WENNJj4DB7fF7GyEOMxziwdn4LB1kj9vXr6ipgmXSlCrqSizPZI
	ulkhSVrSMITviexXeJzwwQRXjiIxmEplb43jtfTgQlGsrUKF0ZbUCJ3ykDEdA39s
	Ayr41fYYVf5XTeGu2ORblznhmWpFMqjIOQiwUQ40/rj3tOWXLDqOLFiYNMIdEOhv
	1p+UfZ0cZaAmxsqRYbu5welnrpUrULq6aAIvxFmMhubW9s0arnqSTalYQ4MvTYyK
	flyiD+0dZY3wYzW8BUk5Xw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1733393402; x=
	1733479802; bh=FSPKuoKyCdYS29EwGZWiI7JAIKFRf2AXJz4FVE+fs2c=; b=B
	aiZmjW5kFdczqEqObRlXmtDqB00gslq+oglU+LEE1tp+YQKJKqXYVtIzHogO7rEJ
	+b2lpCMfbURiFo2UXUtEPvkQO7o9oUF5l+5gelfwkEsl6m+Zcnm2JrNhTSHLDEWL
	qbqwuwtYoU9fKHe9pFJjyyxmJYsVdnDzEb9UJObUsha/e5rfkEbvYivBN+/9PqTf
	CPJnKmGuyc+cfm8HBtK2nooVrtbr/ko2Q2XFS/UkXvI6gT+b39hptHGo5tqu60qf
	i97LfRhE2SJhp5PcdE0YaXewzvI3HqVU9e9nX6Gg0Qdkb9UXXI9lOkRggQzKppgn
	ouA4KN8a8zHcASxN5eEsw==
X-ME-Sender: <xms:-XtRZwEoP1x99iNz-eH0sC2PcPfRkh5momsIhzLFmp2mKg8IsaGXIA>
    <xme:-XtRZ5UKtwuqhYNXGcckZMtjFtUCMVoDIGBQo7wUYK--CoXJQ-oB_ms_4fWDxezQ6
    IHwrjIQMkfs0rPS8Qo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrieejgdduudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdpuffr
    tefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnth
    hsucdlqddutddtmdenucfjughrpefoggffhffvvefkjghfufgtgfesthejredtredttden
    ucfhrhhomhepfdetrhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdrug
    gvqeenucggtffrrghtthgvrhhnpefhtdfhvddtfeehudekteeggffghfejgeegteefgffg
    vedugeduveelvdekhfdvieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggvpdhnsggprhgtphhtthhopeduhedp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepsghpsegrlhhivghnkedruggvpdhrtg
    hpthhtoheptghimhhinhgrghhhihesghhnuhguugdrtghomhdprhgtphhtthhopehsvggr
    nhhjtgesghhoohhglhgvrdgtohhmpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvg
    grugdrohhrghdprhgtphhtthhopegrnhguhieskhgvrhhnvghlrdhorhhgpdhrtghpthht
    oheprghrnhgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopeigkeeisehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehtghhlgieslhhinhhuthhrohhnihigrdguvgdprhgtphht
    thhopehtohhrvhgrlhgusheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhg
X-ME-Proxy: <xmx:-ntRZ6K3LV8oUegDWFgqeEx_OwWQcFYmU111TMNt680Q3A-OSgdpGQ>
    <xmx:-ntRZyEorqMY_FC3voU5RGSSKgIuU13lQWjIgWcvV9c6vi1FSAMdng>
    <xmx:-ntRZ2WA5AFy6_cQoctov9G0AAKRrNt2mStAoq4BHumJvdubExrmMA>
    <xmx:-ntRZ1MFqI3DKNTe0bQkByZOZUH4I6tiDdIEITEIbF_RgdkvpPSGeA>
    <xmx:-ntRZ3sla-b7ibxU0xinfs8p0FLqDG05pqJSzFyHV6SCapNOm2PC9LqT>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id D691D2220072; Thu,  5 Dec 2024 05:10:01 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 05 Dec 2024 11:09:41 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Andy Shevchenko" <andy@kernel.org>,
 "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Arnd Bergmann" <arnd@kernel.org>, linux-kernel@vger.kernel.org,
 x86@kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
 "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, "Matthew Wilcox" <willy@infradead.org>,
 "Sean Christopherson" <seanjc@google.com>,
 "Davide Ciminaghi" <ciminaghi@gnudd.com>,
 "Paolo Bonzini" <pbonzini@redhat.com>, kvm@vger.kernel.org
Message-Id: <74e8e9c6-8205-413a-97a4-aae32042c019@app.fastmail.com>
In-Reply-To: <Z1FgxAWHKgyjOZIU@smile.fi.intel.com>
References: <20241204103042.1904639-1-arnd@kernel.org>
 <20241204103042.1904639-10-arnd@kernel.org>
 <CAHk-=wh_b8b1qZF8_obMKpF+xfYnPZ6t38F1+5pK-eXNyCdJ7g@mail.gmail.com>
 <d189f1a1-40d4-4f19-b96e-8b5dd4b8cefe@app.fastmail.com>
 <CAHk-=wji1sV93yKbc==Z7OSSHBiDE=LAdG_d5Y-zPBrnSs0k2A@mail.gmail.com>
 <Z1FgxAWHKgyjOZIU@smile.fi.intel.com>
Subject: Re: [PATCH 09/11] x86: rework CONFIG_GENERIC_CPU compiler flags
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, Dec 5, 2024, at 09:13, Andy Shevchenko wrote:
> On Wed, Dec 04, 2024 at 03:33:19PM -0800, Linus Torvalds wrote:
>> On Wed, 4 Dec 2024 at 11:44, Arnd Bergmann <arnd@arndb.de> wrote:
>
> ...
>
>> Will that work when you cross-compile? No. Do we care? Also no. It's
>> basically a simple "you want to optimize for your own local machine"
>> switch.
>
> Maybe it's okay for 64-bit machines, but for cross-compiling for 32-bit on
> 64-bit. I dunno what '-march=native -m32' (or equivalent) will give in such
> cases.

From the compiler's perspective this is nothing special, it just
builds a 32-bit binary that can use any instruction supported in
32-bit mode of that 64-bit CPU, the same as the 32-bit CONFIG_MCORE2
option that I disallow in patch 04/11.

     Arnd

