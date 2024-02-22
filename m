Return-Path: <kvm+bounces-9369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ADD185F569
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 11:14:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C88B1C23454
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 10:14:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39D2C3A1DF;
	Thu, 22 Feb 2024 10:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="f9Q6/AWH"
X-Original-To: kvm@vger.kernel.org
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F50536B04;
	Thu, 22 Feb 2024 10:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.28.160.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708596830; cv=none; b=izNYcw9kHMh6S2yy2VKvPAUGznkg+LPYnb0IyelBBXPhoz+JEmyUr9NwKc/+MlKHTrJK2kf/g3BUYJC+cbDHC084tGhEpVsvzZYY8aBCmArJ31DUvsycaQadkVh9RZXjZJlC/8crpgSrQ5gquZsQ7z6jmULATnFtpzNKc9u3Ntg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708596830; c=relaxed/simple;
	bh=oodbZWvTEemwzj3mJtwBbb3QxaynjlmsQCl4euKBi8w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ogu2BEcFgHFC6o0ar1RQC6QK0E3kuL/LMpze2Ero5tHZQ8tqsL3w0EYT+htMrrMvag+6IP+ArNVW6C5cnchNWcwKYfAjMMLVZM+K4+kGOWwZTmrl0Q0d5oGqo9hR3G1YS+AMnoBj75IXD/pB+qgsqTzJYAYRyII0SAW5gwtaG6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name; spf=pass smtp.mailfrom=xen0n.name; dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b=f9Q6/AWH; arc=none smtp.client-ip=115.28.160.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xen0n.name
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1708596824; bh=oodbZWvTEemwzj3mJtwBbb3QxaynjlmsQCl4euKBi8w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=f9Q6/AWHFaCV5i7PVa37Pf3A1FwEcLSQE60jeXxYf0draOKc+RfHpRyNb7w7DvKDc
	 Ns7GlkvCm9iAl2r3xbATCjpbXlXItNcZyor2UiB4pJbRW5mZRM6cXALA6Y2MGruL29
	 76MF+RaL1gY5oAbKMpiS1QqifS2PzYy9UirV3kmY=
Received: from [IPV6:240e:688:100:1:5f9c:42f0:f9f2:a909] (unknown [IPv6:240e:688:100:1:5f9c:42f0:f9f2:a909])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 320EE60094;
	Thu, 22 Feb 2024 18:13:44 +0800 (CST)
Message-ID: <f93aed43-7100-445a-9909-52427dc201bd@xen0n.name>
Date: Thu, 22 Feb 2024 18:13:43 +0800
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
 <7867d9c8-22fb-4bfc-92dc-c782d29c56f9@xen0n.name>
 <542a8f4e-cec3-92d0-1cdd-43d112eec605@loongson.cn>
From: WANG Xuerui <kernel@xen0n.name>
In-Reply-To: <542a8f4e-cec3-92d0-1cdd-43d112eec605@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/22/24 18:06, maobibo wrote:
> 
> 
> On 2024/2/22 下午5:34, WANG Xuerui wrote:
>> On 2/17/24 11:15, maobibo wrote:
>>> On 2024/2/15 下午6:25, WANG Xuerui wrote:
>>>> On 2/15/24 18:11, WANG Xuerui wrote:
>>>>> Sorry for the late reply (and Happy Chinese New Year), and thanks 
>>>>> for providing microbenchmark numbers! But it seems the more 
>>>>> comprehensive CoreMark results were omitted (that's also absent in 
>>>>> v3)? While the 
>>>>
>>>> Of course the benchmark suite should be UnixBench instead of 
>>>> CoreMark. Lesson: don't multi-task code reviews, especially not 
>>>> after consuming beer -- a cup of coffee won't fully cancel the 
>>>> influence. ;-)
>>>>
>>> Where is rule about benchmark choices like UnixBench/Coremark for ipi 
>>> improvement?
>>
>> Sorry for the late reply. The rules are mostly unwritten, but in 
>> general you can think of the preference of benchmark suites as a 
>> matter of "effectiveness" -- the closer it's to some real workload in 
>> the wild, the better. Micro-benchmarks is okay for illustrating the 
>> points, but without demonstrating the impact on realistic workloads, a 
>> change could be "useless" in practice or even decrease various 
>> performance metrics (be that throughput or latency or anything that 
>> matters in the certain case), but get accepted without notice.
> yes, micro-benchmark cannot represent the real world, however it does 
> not mean that UnixBench/Coremark should be run. You need to point out 
> what is the negative effective from code, or what is the possible real 
> scenario which may benefit. And points out the reasonable benchmark 
> sensitive for IPIs rather than blindly saying UnixBench/Coremark.

I was not meaning to argue with you, nor was I implying that your 
changes "must be regressing things even though I didn't check myself" -- 
my point is, *any* comparison with realistic workload that shows the 
performance mostly unaffected inside/outside KVM, would give reviewers 
(and yourself too) much more confidence in accepting the change.

For me, personally I think a microbenchmark could be enough, because the 
only externally-visible change is the IPI mechanism overhead, but please 
consider other reviewers that may or may not be familiar enough with 
LoongArch to be able to notice the "triviality". Also, given the 6-patch 
size of the series, it could hardly be considered "trivial".

-- 
WANG "xen0n" Xuerui

Linux/LoongArch mailing list: https://lore.kernel.org/loongarch/


