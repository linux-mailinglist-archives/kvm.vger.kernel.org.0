Return-Path: <kvm+bounces-16526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B82F18BB16E
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 19:07:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45CDA284C43
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 17:07:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5777A157E62;
	Fri,  3 May 2024 17:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b="BCgRoDmx"
X-Original-To: kvm@vger.kernel.org
Received: from gentwo.org (gentwo.org [62.72.0.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF3957C8A;
	Fri,  3 May 2024 17:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.72.0.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714756044; cv=none; b=nIHTgb3Y81pgH+hZvyIwEKpVJFqREzoGiSvsgL7Am6xBBOmfk1FukDbzEFnZliKAbO0YQW4o+JXBWEpCIjD9pGg+6A9xN9kdws8Tx6P+IIFEOYOXdrU3dAlt/+5je/JfXzMkBoqwy063sRM1Ag1cI51fNC6z6iy8b0QXhwvA3jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714756044; c=relaxed/simple;
	bh=cHkztBQ7wMNR/fTvXGyHdqMW9ZTZw13HKJDxGYETkJA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=RXavdH/xr/nTZ/NeY0aZYgDpNsGtM0KoNg9frw34D+sAkNq45z29J0+kb/tfKJfyXP4bbeTE/UIElQMjtjVnU3YKDyeGhAykbf63M3eXQHcy3OBvXEuGsklSQQ+zQgEs493EJOZc09PuDwTlzRDXw3QHIolitlva53JznvcPAWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org; spf=pass smtp.mailfrom=gentwo.org; dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b=BCgRoDmx; arc=none smtp.client-ip=62.72.0.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1714756036;
	bh=cHkztBQ7wMNR/fTvXGyHdqMW9ZTZw13HKJDxGYETkJA=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=BCgRoDmxLXlkHx2mUJkXZ7ufOuusiCanBeFfIAefYKD4BZKfQVoriyeZtQJLF9W8J
	 W2P1E6mr5l6DiLHpZBQngzCVzmIFzHl6X97IITkZdl5TNOtp9F6ZKDC1ch97MBTRYq
	 CkgNmilea2DXN6Ka1KOP8gIMDswUt5M3gvxbnGmo=
Received: by gentwo.org (Postfix, from userid 1003)
	id 775C0401D7; Fri,  3 May 2024 10:07:16 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 73EF3401D1;
	Fri,  3 May 2024 10:07:16 -0700 (PDT)
Date: Fri, 3 May 2024 10:07:16 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Ankur Arora <ankur.a.arora@oracle.com>
cc: linux-pm@vger.kernel.org, kvm@vger.kernel.org, 
    linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
    catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de, 
    mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com, 
    pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com, 
    rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org, 
    arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com, harisokn@amazon.com, 
    joao.m.martins@oracle.com, boris.ostrovsky@oracle.com, 
    konrad.wilk@oracle.com
Subject: Re: [PATCH 1/9] cpuidle: rename ARCH_HAS_CPU_RELAX to
 ARCH_HAS_OPTIMIZED_POLL
In-Reply-To: <877cgba5xn.fsf@oracle.com>
Message-ID: <f72de572-bf9c-7b1c-194d-6e2de9d4c9b5@gentwo.org>
References: <20240430183730.561960-1-ankur.a.arora@oracle.com> <20240430183730.561960-2-ankur.a.arora@oracle.com> <7473bd3d-f812-e039-24cf-501502206dc9@gentwo.org> <877cgba5xn.fsf@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Thu, 2 May 2024, Ankur Arora wrote:

>> The intend was to make the processor aware that we are in a spin loop. Various
>> processors have different actions that they take upon encountering such a cpu
>> relax operation.
>
> Sure, though most processors don't have a nice mechanism to do that.
> x86 clearly has the REP; NOP thing. arm64 only has a YIELD which from my
> measurements is basically a NOP when executed on a system without
> hardware threads.
>
> And that's why only x86 defines ARCH_HAS_CPU_RELAX.

My impression is that the use of arm YIELD has led cpu architects to 
implement similar mechanisms to x86s PAUSE, This is not part of the spec 
but it has been there for a long time. So I would rather leave it as is.


>> These are not the same and I think we need both config options.
>
> My main concern is that poll_idle() conflates polling in idle with
> ARCH_HAS_CPU_RELAX, when they aren't really related.
>
> So, poll_idle(), and its users should depend on ARCH_HAS_OPTIMIZED_POLL
> which, if defined by some architecture, means that poll_idle() would
> be better than a spin-wait loop.
>
> Beyond that I'm okay to keep ARCH_HAS_CPU_RELAX around.
>
> That said, do you see a use for ARCH_HAS_CPU_RELAX? The only current
> user is the poll-idle path.

I would think that we need a generic cpu_poll() mechanism that can fall 
back to cpu_relax() on processors that do not offer such thing (x86?) and 
if not even that is there fall back.

We already have something like that in the smp_cond_acquire mechanism (a 
bit weird to put that in the barrier.h>).

So what if we had

void cpu_wait(unsigned flags, unsigned long timeout, void *cacheline);

With

#define CPU_POLL_INTERRUPT (1 << 0)
#define CPU_POLL_EVENT (1 <<  1)
#define CPU_POLL_CACHELINE (1 << 2)
#define CPU_POLL_TIMEOUT (1 << 3)
#define CPU_POLL_BROADCAST_EVENT (1 << 4)
#define CPU_POLL_LOCAL_EVENT (1 << 5)


The cpu_poll() function coud be generically defined in asm-generic and 
then arches could provide their own implementation optimizing the hardware 
polling mechanisms.

Any number of flags could be specified simultaneously. On ARM this would 
map then to SEVL SEV and WFI/WFE WFIT/WFET

So f.e.

cpu_wait(CPU_POLL_INTERUPT|CPU_POLL_EVENT|CPU_POLL_TIMEOUT|CPU_POLL_CACHELINE, 
timeout, &mylock);

to wait on a change in a cacheline with a timeout.

In additional we could then think about making effective use of the 
signaling mechanism provided by SEV in core logic of the kernel. Maybe 
that is more effective then waiting for a cacheline in some situations.


> With WFE, sure there's a problem in that you depend on an interrupt or
> the event-stream to get out of the wait. And, so sometimes you would
> overshoot the target poll timeout.

Right. The dependence on the event stream makes this approach a bit 
strange. Having some sort of generic cpu_wait() feature with timeout spec 
could avoid that.


