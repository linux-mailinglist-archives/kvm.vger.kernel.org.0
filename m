Return-Path: <kvm+bounces-13636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5543A8994D2
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 07:54:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E8A371F23749
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 05:54:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7139224DD;
	Fri,  5 Apr 2024 05:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="thhaDw7h"
X-Original-To: kvm@vger.kernel.org
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB8B28E2;
	Fri,  5 Apr 2024 05:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712296481; cv=none; b=eoi4yqYqcheomuKd25cVII6Xkj2hO/7KROg9iZqwwkZ4fbYoNhafBmvc1t2eFppVCWgCHIoSbly5iWn8PIdskf5nyrieE4QeS9UUiQfGPLfI12x8Enn/75JsRiftpaSAjWrNOPx0x5uZ7Q9Lmq+hOsAYqsXWl8nfEZh6w1Qy4Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712296481; c=relaxed/simple;
	bh=kpeRlCRjQYB9jQvGRYR8m1gduP3dQIVeiVNAcTnLfI0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LCdZpAOxAk4YUyuGZNLGBOFWLbG1KDkLavKk7m3W5rckyn+gTcAnaDg0/7AGfwpF+FT8qCAA06XoFY1E3h94sn1f29O4pdTg2VA6/+vdmfiopq5viUYMNPJaEYnsNz0xz34gVMyoqeoiTPi1SVZTyriQVjGcqvsEnXlzwTYCgQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=thhaDw7h; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=5+CSatVUX1mB5iLzA7Er8OGguj0pB7lpB5xhAhk7j8k=; t=1712296479;
	x=1712728479; b=thhaDw7h4wBp37OhoHgzfSlW3c/g4wl3hTo0PiCjbMAQV126Ue75+XxYy56yN
	qFaPK1yOdfYnFD7L0C8T/nJvosGfep1d4MzgAjS4L+mqIxWXnKJaiVH7UaaZUdCeezgtlNllVKj1n
	FepsIcaIPhSaHEBtsH/Y5mWwwjworbO77Y3dgSG7KkPfFs/+gh4vTav9ZzAof7FQxdB48rbhqNkz0
	dm8t/gYSa4MTJcuZzoKEyltR9IHPn/zSy4hxI5tD4QCi7MDdQ+jklWZHcF8eJsOBAjzh/XqLjZ0FL
	k6BLSfMYp5W/XZAsjvFrGehaUDL9ZqzKKX2fEi9hE1rSIokzjg==;
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1rscX3-00021j-El; Fri, 05 Apr 2024 07:54:33 +0200
Message-ID: <cb038940-63fd-4348-bed2-13e1b2844b92@leemhuis.info>
Date: Fri, 5 Apr 2024 07:54:32 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: PPC: Book3S HV nestedv2: Cancel pending HDEC
 exception
To: Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin
 <npiggin@gmail.com>, Vaibhav Jain <vaibhav@linux.ibm.com>,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org
Cc: Jordan Niethe <jniethe5@gmail.com>,
 Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>, mikey@neuling.org,
 paulus@ozlabs.org, sbhat@linux.ibm.com, gautam@linux.ibm.com,
 kconsul@linux.vnet.ibm.com, amachhiw@linux.vnet.ibm.com,
 David.Laight@ACULAB.COM,
 Linux kernel regressions list <regressions@lists.linux.dev>
References: <20240313072625.76804-1-vaibhav@linux.ibm.com>
 <CZYME80BW9P7.3SC4GLHWCDQ9K@wheely>
 <a4f022e8-1f84-4bbb-b00d-00f1eba1f877@leemhuis.info>
 <87sf007ax6.fsf@mail.lhotse>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: en-US, de-DE
In-Reply-To: <87sf007ax6.fsf@mail.lhotse>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1712296479;f77730c1;
X-HE-SMSGID: 1rscX3-00021j-El

On 05.04.24 05:20, Michael Ellerman wrote:
> "Linux regression tracking (Thorsten Leemhuis)"
> <regressions@leemhuis.info> writes:
>> Hi, Thorsten here, the Linux kernel's regression tracker. Top-posting
>> for once, to make this easily accessible to everyone.
>>
>> Was this regression ever resolved? Doesn't look like it, but maybe I
>> just missed something.
> 
> I'm not sure how it ended up on the regression list.

That is easy to explain: I let lei search for mails containing words
like regress, bisect, and revert to become aware of regressions that
might need tracking. And...

> IMHO it's not really a regression.

...sometimes I misjudge or misinterpret something and add it to the
regression tracking. Looks like that happened here.

Sorry for that and the noise it caused!

#regzbot resolve: invalid: was not really a regression in the first place

Ciao, Thorsten

