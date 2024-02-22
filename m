Return-Path: <kvm+bounces-9359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 402D285F474
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 10:34:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 714171C23556
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 09:34:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AEA939852;
	Thu, 22 Feb 2024 09:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="Yj9/ya4Q"
X-Original-To: kvm@vger.kernel.org
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3059238399;
	Thu, 22 Feb 2024 09:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.28.160.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708594472; cv=none; b=OmsiUxYA5mpKTk9yeeBeoTeovCBEAoH0BektOp6/NQkjyu7Pub7PNiEuALBWio5AiOasKc4o8kkUYwC0WGEq0zn/AKBaC5CS59RA37hWqpspe9VQMfHpPurEfapxF0xrudd0NqEwLzNV6flWjlDOZN7tZ6DfbJanBTzbPoNeNN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708594472; c=relaxed/simple;
	bh=YrftTzEXxxE3CbE+JzHbyCcHi9kHbl0n2PpROgeW3GU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NuDO8OVBcN1/X6+fc5Q5XYNc3dwOen3jfiV7kJgI7xFCkvtvs02rRsqZ2KL/hvL0lpXBQdJYLC/2ORSnjIDpe0r0A64YmvY5b8QjoSV6oadIEeQt/VR7TbyEmP8vGd7voNu8CrtHEBsnQGNST3vyldvjVlrHi9rxAFw8iKoBBgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name; spf=pass smtp.mailfrom=xen0n.name; dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b=Yj9/ya4Q; arc=none smtp.client-ip=115.28.160.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xen0n.name
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1708594462; bh=YrftTzEXxxE3CbE+JzHbyCcHi9kHbl0n2PpROgeW3GU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Yj9/ya4QhvBHvDY349kvXnR+2Pyll4cM74+g75s0lAd4lPPUwLq2Mn6Zz6FNwyeN0
	 VSl6fcvEwxqwVGD9ivmfN/ciwYb/nB7QqMzmzVZKXQzmowthAc4RMwtAhNA5Y/sMBd
	 D1hsJjcjjoKlLdlE8KgYw3WFCkH8GE31e9ld6wP8=
Received: from [IPV6:240e:688:100:1:5f9c:42f0:f9f2:a909] (unknown [IPv6:240e:688:100:1:5f9c:42f0:f9f2:a909])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 6E717600A6;
	Thu, 22 Feb 2024 17:34:22 +0800 (CST)
Message-ID: <7867d9c8-22fb-4bfc-92dc-c782d29c56f9@xen0n.name>
Date: Thu, 22 Feb 2024 17:34:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/6] LoongArch: Add pv ipi support on LoongArch VM
Content-Language: en-US
To: maobibo <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org
References: <20240201031950.3225626-1-maobibo@loongson.cn>
 <0f4d83e2-bff9-49d9-8066-9f194ce96306@xen0n.name>
 <447f4279-aea9-4f35-b87e-a3fc8c6c20ac@xen0n.name>
 <4a6e25ec-cdb6-887a-2c64-3df12d30c89a@loongson.cn>
From: WANG Xuerui <kernel@xen0n.name>
In-Reply-To: <4a6e25ec-cdb6-887a-2c64-3df12d30c89a@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/17/24 11:15, maobibo wrote:
> On 2024/2/15 下午6:25, WANG Xuerui wrote:
>> On 2/15/24 18:11, WANG Xuerui wrote:
>>> Sorry for the late reply (and Happy Chinese New Year), and thanks for 
>>> providing microbenchmark numbers! But it seems the more comprehensive 
>>> CoreMark results were omitted (that's also absent in v3)? While the 
>>
>> Of course the benchmark suite should be UnixBench instead of CoreMark. 
>> Lesson: don't multi-task code reviews, especially not after consuming 
>> beer -- a cup of coffee won't fully cancel the influence. ;-)
>>
> Where is rule about benchmark choices like UnixBench/Coremark for ipi 
> improvement?

Sorry for the late reply. The rules are mostly unwritten, but in general 
you can think of the preference of benchmark suites as a matter of 
"effectiveness" -- the closer it's to some real workload in the wild, 
the better. Micro-benchmarks is okay for illustrating the points, but 
without demonstrating the impact on realistic workloads, a change could 
be "useless" in practice or even decrease various performance metrics 
(be that throughput or latency or anything that matters in the certain 
case), but get accepted without notice.

-- 
WANG "xen0n" Xuerui

Linux/LoongArch mailing list: https://lore.kernel.org/loongarch/


