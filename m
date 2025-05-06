Return-Path: <kvm+bounces-45553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 79E4FAAB954
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 08:55:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6656452063D
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 06:52:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FEF829009F;
	Tue,  6 May 2025 04:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="kafLiDKX"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F5328D8C2;
	Tue,  6 May 2025 02:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.92.39.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746498798; cv=none; b=ta2hOfWbDHpLOSPz6U+4wr5UnN6VhMZHVlIK1KTKOtO64Nn2asaB58adCBvxvqnM3qyFDeFZ7+SbTbDv2egAoZ+sBQAvo4qd/wZnoweJhlw0vyevZIsKZgjZrpT76zdTM9PMqsLdhncKcRwHKQCP8rSAOlIcAQlh2YiNDjoKATM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746498798; c=relaxed/simple;
	bh=RK8CB/ILucoxkojMLroxyaAqpj6rXkr8cb1h0tuO+FM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AF2zqg+naWnQFIpLDRWgQtRF1ubUTQDYm41gkj2Z+Af6YUU0osTZ9X2Y+vtSWLtlBFfFIoeD8xsqtsAA+LA9PdxPDpl4f7iGVfrT+iio9rGNNOlo5+p5G7dyRkNDybKk52JmnGqX6gkOX9f8jfjGMmSLknAhHoS9DWSrXkgJ5fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=kafLiDKX; arc=none smtp.client-ip=54.92.39.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1746498699;
	bh=RK8CB/ILucoxkojMLroxyaAqpj6rXkr8cb1h0tuO+FM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=kafLiDKXS816BmywaQFx+/F9Y6knLlHjegnJC8EOCpdTsnxr/e1yaY6y4wWVWU5Cc
	 pEmJcSIFvrEg1Nxq/uND+kyneyz+lm4cL848VLV2wWlvOab3SEPuOTkyOQdSj+ClQW
	 LZ+Ex6H0L9ikuOIyZud7Tr25Wd3PVQAdT9G4v3o8=
X-QQ-mid: esmtpsz17t1746498663t4c1b9905
X-QQ-Originating-IP: 2vhUXsJq6NqiLO1Htm0IxhFYAPx746WeA0MvTVyM9nk=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 06 May 2025 10:30:59 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 1353101163767275647
EX-QQ-RecipientCnt: 52
From: Chen Linxuan <chenlinxuan@uniontech.com>
To: hch@lst.de
Cc: akpm@linux-foundation.org,
	alex.williamson@redhat.com,
	andreyknvl@gmail.com,
	axboe@kernel.dk,
	boqun.feng@gmail.com,
	boris.ostrovsky@oracle.com,
	bp@alien8.de,
	changbin.du@intel.com,
	chenlinxuan@uniontech.com,
	dave.hansen@linux.intel.com,
	dvyukov@google.com,
	hannes@cmpxchg.org,
	hpa@zytor.com,
	jackmanb@google.com,
	jarkko@kernel.org,
	jgg@ziepe.ca,
	jgross@suse.com,
	justinstitt@google.com,
	kasan-dev@googlegroups.com,
	kbusch@kernel.org,
	kevin.tian@intel.com,
	kvm@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-nvme@lists.infradead.org,
	llvm@lists.linux.dev,
	masahiroy@kernel.org,
	mathieu.desnoyers@efficios.com,
	mhocko@suse.com,
	mingo@redhat.com,
	morbo@google.com,
	nathan@kernel.org,
	nick.desaulniers+lkml@gmail.com,
	nicolas.schier@linux.dev,
	paulmck@kernel.org,
	peterhuewe@gmx.de,
	peterz@infradead.org,
	sagi@grimberg.me,
	shameerali.kolothum.thodi@huawei.com,
	surenb@google.com,
	tglx@linutronix.de,
	torvalds@linux-foundation.org,
	vbabka@suse.cz,
	virtualization@lists.linux.dev,
	wentao@uniontech.com,
	x86@kernel.org,
	xen-devel@lists.xenproject.org,
	yishaih@nvidia.com,
	ziy@nvidia.com
Subject: Re: [PATCH RFC v3 0/8] kernel-hacking: introduce CONFIG_NO_AUTO_INLINE
Date: Tue,  6 May 2025 10:30:53 +0800
Message-ID: <AB2D78307A5FD403+20250506023053.541751-1-chenlinxuan@uniontech.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250429123504.GA13093@lst.de>
References: <20250429123504.GA13093@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-QQ-XMAILINFO: NYwvw9/V3eZZYpedOr8jwZgzIt+Nn0Burlbno8RYLO+9Fuq2TsAj+tZX
	bCFNFygJ3Swd5s8Jo4yUIDF8Pq//PsZoXmckP0HGuXmwE1diSBpDRVd+qMkJxRpB5LmNOcq
	Sen+lMxflHr/OXP/REeL6nstqNFJMWUc4yaJZldbeeybf45r5u8JloooYAwB3mTNCgs3qsr
	cuHELjO0Jp43LeqVUrgMNVzTWsApLN365ZHE67sMM4PcD5ts7cDFGmoGBxFGgwEuYv8dA2E
	zACoWzjPrjTOcJ9JfVRexWtsK618S5CFE66Fl/1x7gHmXVzSsq0GcDgCR2GPN+spDgDKDDc
	aIXYepkT3ti1mTqay5fINjwzjORtN0HHpasIC82QGVNXCJHHQz5CIxX9EYa8GD65yKErZ3e
	rkMS5Wj7GycTiIZosuInTgRyOeLE/c8sA1GYeus1acnrPiBOJh1ICo/NJH3M4P3TJBYEecu
	ROWHVRkgAS48TTcheSGqOOQDTe/L6B008otdAsKTQm0lcDcz81woANxd0PkD6rkBsEeAWIX
	0M1krjBUmbWAqzLknZNotIb5LfXHbalBZrix8OuednLPQK9CSEvSbK6KjuYWvTOzdurHFw6
	L4SOzRhNxpVhBFWEClOxVMve4lpkBntr4pbD/U7/vdTbZQjMQ6xptzY1ISkCUr34lWm1UDc
	b18zUjUpWmr5WnA3KXfUq/VrLyEtj0WbNqfLprSxbmgwrG79OoMnAmViO5N9DamWCcuDcLv
	Hl00leM6/grk9Hnhd8tX+h2KSSzdWWngf2tpwGYe8eLcsq1ssJ28NSAlmrTwNAxkAr5ZZsA
	bZXW3QTR9cU+pV5g+st2AsY33FmZubXPTmI6C1FTHnA6SzWa3N9WhiLdMro7WtCY2h7pafB
	/JhCot0ZuiGDm5/WkvZXn08uNMH9poQC5ABs9GLZlKRf0q/AjIVp8l5RsZ+nVM3JlKWCerZ
	7/cp1495nrc22umlv0oW0ZsLrI9glSjBz1xF1VMPCUOaKUQFyZw0W6v4rWZD4i98Juaehm/
	lsfQbjOX+5vl1GFmCw/S4b256ZsrY=
X-QQ-XMRINFO: MPJ6Tf5t3I/ycC2BItcBVIA=
X-QQ-RECHKSPAM: 0

On Tue, 29 Apr 2025 14:35:04 +0200 Christoph Hellwig wrote:

> On Tue, Apr 29, 2025 at 12:06:04PM +0800, Chen Linxuan via B4 Relay wrote:
>
> > This series introduces a new kernel configuration option NO_AUTO_INLINE,
> > which can be used to disable the automatic inlining of functions.
> >
> > This will allow the function tracer to trace more functions
> > because it only traces functions that the compiler has not inlined.
>
> This still feels like a bad idea because it is extremely fragile.

I'm not entirely sure if we're on the same page regarding this issue.
However, I'd like to address the concerns about the fragility of NO_AUTO_INLINE.

Maintaining NO_AUTO_INLINE to function correctly is indeed challenging,
and I share some reservations about whether it should exist as a Kbuild option,
which is precisely why this patch series is submitted as an RFC.
I cannot even guarantee that I've addressed all existing issues in the current
kernel repository with this patch series, as testing all possible compilation
configurations is beyond my capabilities.

Looking at the functions where I've added __always_inline in this patch series,
nearly all of them require inlining specifically because their calls need to be
resolved at compile time.

The fundamental source of this fragility stems from the fact that compiler
auto-inlining decisions aren't well-defined. If these functions were to change
in the future for unrelated reasons - for example, if they became longer - and
the compiler consequently decided not to automatically inline them, these same
issues would surface regardless.

