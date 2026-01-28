Return-Path: <kvm+bounces-69407-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SHoBCqtfemkc5gEAu9opvQ
	(envelope-from <kvm+bounces-69407-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 20:12:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 48057A8151
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 20:12:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D3C96300A593
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:12:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DF2537417D;
	Wed, 28 Jan 2026 19:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Su/N10kA"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3290B2F7ADE;
	Wed, 28 Jan 2026 19:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769627557; cv=none; b=rQsx1e8RchbRhlyphefqxfgw/56R1bKULfErKdqxp6OMgtWV/sq9udMMiNuBrCuasb9dIdARFgZaYSXPBFWx+sYHbNQ84glGvFHVrjEuMw0YaXaSi9vPvyC084Vj4J5n/R7hZJPAv41yFYEnTegh9hf9+LoyjezFRPzcsDKGg9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769627557; c=relaxed/simple;
	bh=IJFSZVCsvtg+mrh9IR4VvUNY9sVjFe98VaQ2irbJdAk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MYklkHVievnKSfko9NzHd58cYpCHiCWGx5xD0EG50fiZ4OC2cFxVGNruzvNFJPBgNM0mL1XmvjTJowx6QK4sCd7F+G9iUwWxg+L5tewlsfwt+6JM7N4Bq10Fgcnl3qaCrpw7+zFPYSbuMyWieyZ2ntE0j5J4QU6KPDOAEz4ytw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Su/N10kA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=Yk6NqBka7Y23oFWb4hZZsO9LBcBAlQiUDANZ1wr1iDA=; b=Su/N10kA2ehEE6B1rQLV1BBq47
	7cVqMdJCWZSVnVT+FJXyvgTa4xT/mklLRSjEj6OAyi3LThQmXI1tEsJ4u4n0cwtWznS/j0Ucr1Yjy
	4jxLxaS0zA4b10Ro7Rued3r3wM0n/re10C2UprJiYbMR2tcmE/bxG7yLYmCHeHzBaS08DVvSoAGTi
	Jab20HFcx8P3B0h2J0pb5arVv+6ZRdyGOb3CrPVu0zZ0R2owP2IwHeZ1hKp+FVckhpEPYbv6pOlf9
	R7KdwBor7+7Sgyk9/vRoSRZnUT9T14CG0W1/0OAaGUwlDnoFDz/N8vha5fvJz2erik+6dZ4lQFyQs
	adlIDxIA==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vlAxt-0000000GfZ9-1460;
	Wed, 28 Jan 2026 19:12:33 +0000
Message-ID: <9d992d4a-1aea-42a7-aa79-4ede80293f9b@infradead.org>
Date: Wed, 28 Jan 2026 11:12:31 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio: selftests: fix format conversion compiler warning
To: David Matlack <dmatlack@google.com>, Ted Logan <tedlogan@fb.com>
Cc: Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>,
 Raghavendra Rao Ananta <rananta@google.com>, Alex Mastro <amastro@fb.com>,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
References: <20260128183750.1240176-1-tedlogan@fb.com>
 <CALzav=dMhycS2iBxkhPCz3tMUKxkfgr1dCLFGYzGuXZCeYhijw@mail.gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <CALzav=dMhycS2iBxkhPCz3tMUKxkfgr1dCLFGYzGuXZCeYhijw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69407-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rdunlap@infradead.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,intel.com:email,fb.com:email,infradead.org:mid,infradead.org:dkim]
X-Rspamd-Queue-Id: 48057A8151
X-Rspamd-Action: no action



On 1/28/26 11:06 AM, David Matlack wrote:
> On Wed, Jan 28, 2026 at 10:38 AM Ted Logan <tedlogan@fb.com> wrote:
>>
>> Use the standard format conversion macro PRIx64 to generate the
>> appropriate format conversion for 64-bit integers. Fixes a compiler
>> warning with -Wformat on i386.
>>
>> Signed-off-by: Ted Logan <tedlogan@fb.com>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Closes: https://lore.kernel.org/oe-kbuild-all/202601211830.aBEjmEFD-lkp@intel.com/
> 
> Thanks for the patch.
> 
> I've been seeing these i386 reports as well. I find the PRIx64, etc.
> format specifiers make format strings very hard to read. And I think
> there were some other issues when building VFIO selftests with i386
> the last time I tried.
> 
> I was thinking instead we should just not support i386 builds of VFIO
> selftests. But I hadn't gotten around to figuring out the right
> Makefile magic to make that happen.

There are other 32-bit CPUs besides i386.
Or do only support X86?

-- 
~Randy


