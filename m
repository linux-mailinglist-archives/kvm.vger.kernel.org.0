Return-Path: <kvm+bounces-28064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6092B992E3C
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 16:05:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 859251C22F43
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 14:05:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5650B1D54FD;
	Mon,  7 Oct 2024 14:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="QexIW1ta"
X-Original-To: kvm@vger.kernel.org
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F0F1D417B;
	Mon,  7 Oct 2024 14:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728309870; cv=none; b=F1j9gYIa/o5tiX4Sj7OUbYbgQVjWr/lmeYvrRWakwLCzNSQcvS5IBC0MUBLjDQzJXzLYOAgIY1uGgb1IOT7YQ4Z+9w/egfSRTR8Lt36AOQC3zGhwbIkzHbyNuli/rQoBXsCDLcdPKxqBwNPbYH616t01psr7H1ozibVHivZ1Qs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728309870; c=relaxed/simple;
	bh=rYFip1NklXra7HzTO1VszgtuzTsU+opowy+ALEYJL4c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lqEncr0jfU/B6Z0n6XfrsejBvcWduP+RxOSjf+9oq6lGerRDtiD5M1/XZg1TIYl6o0gRhdMQENaYWWX/nKeKGlEWQ9pxOgspyL1t1EY58aJo/6XimlyuaYHjcMrTUl05LSn9CV4Dh3rqkOR2sRiJ7Gp3zZ1dqhn6INZgFfQx/9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=QexIW1ta; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
	Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	In-Reply-To:References; bh=5BN/qPr4UHro54JgcseHqfbV3VVI2TKoS2hEvYZX07s=;
	t=1728309868; x=1728741868; b=QexIW1taqCqeM9s91UlHbuoMAukJ6TLBLJ/iQXrO6BykbXs
	YRq2BCigAw/rGcJqfqdxHmUsH/MCg+TgQXtWiAhgaBthPzTx5BPlmyDCz9BZHMS/vxP9z8hdC+N7B
	9b/rRABkQrmaXtxmHKGrsvLuLm8WDDH6kw387B9N+YUs2CIjwCsKmMQy76VIerngmj7oZV2lwb/mm
	lNwWrZfaECe9P+8LnSNcAB5tLlMWzYG/vrUF6aDWOtfSZ9Wmj0XbiRMg3SH7HiK8kxcIi/ahZS9qY
	Zgmf3t6yGCX3SriniSx1vgc2LfjhCGo4uZGZ8ZlcKq3IiRCUOn9DUmYl5XEsxnZw==;
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1sxoLZ-0005v6-Qm; Mon, 07 Oct 2024 16:04:25 +0200
Message-ID: <ba91a7cc-c647-4e33-82f3-0c4e52ce89ea@leemhuis.info>
Date: Mon, 7 Oct 2024 16:04:24 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] KVM: VMX: Always honor guest PAT on CPUs that support
 self-snoop
To: Vitaly Kuznetsov <vkuznets@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, rcu@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kevin Tian <kevin.tian@intel.com>, Yan Zhao <yan.y.zhao@intel.com>,
 Yiwei Zhang <zzyiwei@google.com>, Lai Jiangshan <jiangshanlai@gmail.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Josh Triplett <josh@joshtriplett.org>, Gerd Hoffmann <kraxel@redhat.com>,
 Linux kernel regressions list <regressions@lists.linux.dev>
References: <20240309010929.1403984-1-seanjc@google.com>
 <20240309010929.1403984-6-seanjc@google.com> <877cbyuzdn.fsf@redhat.com>
 <df3c6560-dd37-4ec2-9b7e-1ad4c3ceba07@leemhuis.info>
 <87iku4ghiw.fsf@redhat.com>
From: "Linux regression tracking (Thorsten Leemhuis)"
 <regressions@leemhuis.info>
Content-Language: en-US, de-DE
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <87iku4ghiw.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1728309868;6e9e8a64;
X-HE-SMSGID: 1sxoLZ-0005v6-Qm

On 07.10.24 15:38, Vitaly Kuznetsov wrote:
> "Linux regression tracking (Thorsten Leemhuis)"
> <regressions@leemhuis.info> writes:
> 
>> On 30.08.24 11:35, Vitaly Kuznetsov wrote:
>>> Sean Christopherson <seanjc@google.com> writes:
>>>
>>>> Unconditionally honor guest PAT on CPUs that support self-snoop, as
>>>> Intel has confirmed that CPUs that support self-snoop always snoop caches
>>>> and store buffers.  I.e. CPUs with self-snoop maintain cache coherency
>>>> even in the presence of aliased memtypes, thus there is no need to trust
>>>> the guest behaves and only honor PAT as a last resort, as KVM does today.
>>>>
>>>> Honoring guest PAT is desirable for use cases where the guest has access
>>>> to non-coherent DMA _without_ bouncing through VFIO, e.g. when a virtual
>>>> (mediated, for all intents and purposes) GPU is exposed to the guest, along
>>>> with buffers that are consumed directly by the physical GPU, i.e. which
>>>> can't be proxied by the host to ensure writes from the guest are performed
>>>> with the correct memory type for the GPU.
>>>
>>> Necroposting!
>>>
>>> Turns out that this change broke "bochs-display" driver in QEMU even
>>> when the guest is modern (don't ask me 'who the hell uses bochs for
>>> modern guests', it was basically a configuration error :-). E.g:
>>> [...]
>>
>> This regression made it to the list of tracked regressions. It seems
>> this thread stalled a while ago. Was this ever fixed? Does not look like
>> it, but I might have missed something. Or is this a regression I should
>> just ignore for one reason or another?
>>
> 
> The regression was addressed in by reverting 377b2f359d1f in 6.11
> 
> commit 9d70f3fec14421e793ffbc0ec2f739b24e534900
> Author: Paolo Bonzini <pbonzini@redhat.com>
> Date:   Sun Sep 15 02:49:33 2024 -0400
> 
>     Revert "KVM: VMX: Always honor guest PAT on CPUs that support self-snoop"

Thx. Sorry, missed that, thx for pointing me towards it. I had looked
for things like that, but seems I messed up my lore query. Apologies for
the noise!

> Also, there's a (pending) DRM patch fixing it from the guest's side:
> https://gitlab.freedesktop.org/drm/misc/kernel/-/commit/9388ccf69925223223c87355a417ba39b13a5e8e

Great!

Ciao, Thorsten

P.S.:

#regzbot fix: 9d70f3fec14421e793ffbc0ec2f739b24e534900



