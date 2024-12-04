Return-Path: <kvm+bounces-33042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E12B9E3E87
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 16:42:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6FB9C167D96
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 15:42:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6509720C47D;
	Wed,  4 Dec 2024 15:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="nusfCG3X"
X-Original-To: kvm@vger.kernel.org
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160AA20B816;
	Wed,  4 Dec 2024 15:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733326933; cv=none; b=MGTupTDWq29vn7th8j/oBEQ4lOpn4TgEjIWRUWoc2aCrzlovVmw2A4FDDAaysz3lsyMjoQIFlyGYwinHFwpohRjnSwv85+mj4b3+uypcF9SVfGdrX7N89oWEaEeKoT3haoRMDYmChhgZbTQ1KcDk3cUnZQbG0K6nh4nG+3X0rnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733326933; c=relaxed/simple;
	bh=bnmAm1jUiG8QXJyizFgCwu3PvdmDTJ36Tvtsyi2/MGA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=grIueSs33DKRIM19/yhAyopan2NdRf9eJNIHMeJ8MVxLqSisZnmpi7rZzBfF3/W4YutFcME+oxzOaDeu2uYc83ar7PgRIhjKWaHCBI8oQSxXbvyPIUG3OXk8/0cqDF92Qg6RTAYC1tucelVSP69tr8UYzFIjOjptGi0QhkCi++A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=nusfCG3X; arc=none smtp.client-ip=80.241.56.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4Y3M7x37nBz9sry;
	Wed,  4 Dec 2024 16:36:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1733326605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vEbiDca7zp0P6QUlbgj1AObVHCUUIBhvErhOW/G7qOA=;
	b=nusfCG3XW4GE0jLvDBNVvKMcqFnRfue+dvUhLx5lcON4bL8Zokmj1mbdE6KDijuiKdDbx3
	arJTxXvnw1TnBh21WwsBQMMzxP569K2EdmHlkTei9/4nEqPNSDNKxkWvsUAVo87wKTiHGS
	lUrrepgxAfHxKYZ1EicD7s7vyvW1Rq1ANJljZTkaREU53O41DpxUKm9IoNfRYJCrpoCF8k
	z0He0BtS/HxFZTSwW3rpB/yto9OlPvQNaqByGVLU0/5zdH4QYpjVEDU/E8YxGrLpz5ZtEP
	31L/qIIumrRwcXe6cGJraVVIJ0Wgq8RnPN2pt1DARerj1v5y6RTUXwsXgdYJ/w==
Message-ID: <6c037258-4263-426d-beb2-e6a0697be3ab@mailbox.org>
Date: Wed, 4 Dec 2024 16:36:40 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 09/11] x86: rework CONFIG_GENERIC_CPU compiler flags
Content-Language: en-US
To: Arnd Bergmann <arnd@kernel.org>, linux-kernel@vger.kernel.org,
 x86@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Andy Shevchenko <andy@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Sean Christopherson <seanjc@google.com>,
 Davide Ciminaghi <ciminaghi@gnudd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org
References: <20241204103042.1904639-1-arnd@kernel.org>
 <20241204103042.1904639-10-arnd@kernel.org>
From: Tor Vic <torvic9@mailbox.org>
In-Reply-To: <20241204103042.1904639-10-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MBO-RS-META: 4e9m7dwkykgcxtqczw8zqyhhwrynqgzr
X-MBO-RS-ID: 2b3f8d057a29b455e8d



On 12/4/24 11:30, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Building an x86-64 kernel with CONFIG_GENERIC_CPU is documented to
> run on all CPUs, but the Makefile does not actually pass an -march=
> argument, instead relying on the default that was used to configure
> the toolchain.
> 
> In many cases, gcc will be configured to -march=x86-64 or -march=k8
> for maximum compatibility, but in other cases a distribution default
> may be either raised to a more recent ISA, or set to -march=native
> to build for the CPU used for compilation. This still works in the
> case of building a custom kernel for the local machine.
> 
> The point where it breaks down is building a kernel for another
> machine that is older the the default target. Changing the default
> to -march=x86-64 would make it work reliable, but possibly produce
> worse code on distros that intentionally default to a newer ISA.
> 
> To allow reliably building a kernel for either the oldest x86-64
> CPUs or a more recent level, add three separate options for
> v1, v2 and v3 of the architecture as defined by gcc and clang
> and make them all turn on CONFIG_GENERIC_CPU. Based on this it
> should be possible to change runtime feature detection into
> build-time detection for things like cmpxchg16b, or possibly
> gate features that are only available on older architectures.
> 

Hi Arnd,

Similar but not identical changes have been proposed in the past several 
times like e.g. in 1, 2 and likely even more often.

Your solution seems to be much cleaner, I like it.

That said, on my Skylake platform, there is no difference between 
-march=x86-64 and -march=x86-64-v3 in terms of kernel binary size or 
performance.
I think Boris also said that these settings make no real difference on 
code generation.

Other settings might make a small difference (numbers are from 2023):
   -generic:       85.089.784 bytes
   -core2:         85.139.932 bytes
   -march=skylake: 85.017.808 bytes

----
[1] 
https://lore.kernel.org/all/4_u6ZNYPbaK36xkLt8ApRhiRTyWp_-NExHCH_tTFO_fanDglEmcbfowmiB505heI4md2AuR9hS-VSkf4s90sXb5--AnNTOwvPaTmcgzRYSY=@proton.me/

[2] 
https://lore.kernel.org/all/20230707105601.133221-1-dimitri.ledkov@canonical.com/



