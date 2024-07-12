Return-Path: <kvm+bounces-21571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A369892FFCA
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 19:28:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4814A1F23655
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:28:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9183176AB1;
	Fri, 12 Jul 2024 17:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="VVdKgrqv"
X-Original-To: kvm@vger.kernel.org
Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6456C176226;
	Fri, 12 Jul 2024 17:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.114.26.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720805320; cv=none; b=DO49leCgrpfecVbV6i0PPAXOSeoS5Z3OWcy77ZNusHSyU3QPVPF2u/Ee4vfX+OVIgv4PVAyov6Gp+Z0EBSN61MadJiXS1YpeRxbzDkok+nEeSkD3QrxAHiJD43Dn4CL2elG37wfKTDJlwe4f3C8Te+nzskoCIeW/Rg6zRRV69pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720805320; c=relaxed/simple;
	bh=UcTTM2UQHQ4zFDkXWD/5VaZUWSmGXcw8UKCyFji3gw4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=huX6ZZjWdjS1I2w16jv3Cbakyj9ki37VHakyfXY70NWZwrodo5OX/ACnL9Oitbi7IeiGDQuQZpsmVcplJhBEq7XQadjb1w7HCRwpolvlixhZpb6kcdKcmMKnf709dBmP5E6dTZCgD68sGn8lA6TpfTjAQIrtWHGHYLi05Hgc/OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=VVdKgrqv; arc=none smtp.client-ip=167.114.26.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
	s=smtpout1; t=1720805317;
	bh=UcTTM2UQHQ4zFDkXWD/5VaZUWSmGXcw8UKCyFji3gw4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VVdKgrqv2/7mtNAtMHYbV+pTsERp820wzE8AzVmkI2K4N2/FO4PiX+LiH3G3FpWue
	 kwJoHLOAuTkklI7hgXT4meBpczcWMj56EfNx80Eqn70ZiWNGv5FNTVyYtRmmVm9R4j
	 WQG+UnpJpuf0tLj2/4xs4QUvWictu9/2uWHIlOLGl22M8Wh32eRyLnw0XWXFd2MeJH
	 dog55HB+cvS5hr5H8US9N3bKVYPeXWuIYOsMkSg4GhYAiyNK435qWZ1r0qlbvLjzws
	 iscLT8G3Fzuf7DrTZimonW7InojSSjaz7u2LZFV7FVQp9xwMwFuMYVNQsFIK3/S8xU
	 gUuc61XpjiGUA==
Received: from [172.16.0.134] (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4WLJTw4Jnfz19Px;
	Fri, 12 Jul 2024 13:28:36 -0400 (EDT)
Message-ID: <b624819b-aa56-45db-b140-c830e300ab85@efficios.com>
Date: Fri, 12 Jul 2024 13:28:36 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 0/5] Paravirt Scheduling (Dynamic vcpu priority
 management)
To: Joel Fernandes <joel@joelfernandes.org>
Cc: Vineeth Remanan Pillai <vineeth@bitbyteword.org>,
 Sean Christopherson <seanjc@google.com>, Ben Segall <bsegall@google.com>,
 Borislav Petkov <bp@alien8.de>,
 Daniel Bristot de Oliveira <bristot@redhat.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>, "H . Peter Anvin"
 <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 Juri Lelli <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>,
 Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>,
 Valentin Schneider <vschneid@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 Steven Rostedt <rostedt@goodmis.org>, Suleiman Souhlal
 <suleiman@google.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 himadrics@inria.fr, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 x86@kernel.org, graf@amazon.com, drjunior.org@gmail.com
References: <20240403140116.3002809-1-vineeth@bitbyteword.org>
 <ZjJf27yn-vkdB32X@google.com>
 <CAO7JXPgbtFJO6fMdGv3jf=DfiCNzcfi4Hgfn3hfotWH=FuD3zQ@mail.gmail.com>
 <CAO7JXPhMfibNsX6Nx902PRo7_A2b4Rnc3UP=bpKYeOuQnHvtrw@mail.gmail.com>
 <66912820.050a0220.15d64.10f5@mx.google.com>
 <19ecf8c8-d5ac-4cfb-a650-cf072ced81ce@efficios.com>
 <CAEXW_YRBNs30ZC1e+U3mco22=XxaCfhPO_5wEHe+wFJjAbbSvA@mail.gmail.com>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <CAEXW_YRBNs30ZC1e+U3mco22=XxaCfhPO_5wEHe+wFJjAbbSvA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2024-07-12 12:24, Joel Fernandes wrote:
> On Fri, Jul 12, 2024 at 10:09 AM Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
[...]
>>>
>>> Steven Rostedt told me, what we instead need is a tracepoint callback in a
>>> driver, that does the boosting.
>>
>> I utterly dislike changing the system behavior through tracepoints. They were
>> designed to observe the system, not modify its behavior. If people start abusing
>> them, then subsystem maintainers will stop adding them. Please don't do that.
>> Add a notifier or think about integrating what you are planning to add into the
>> driver instead.
> 
> Well, we do have "raw" tracepoints not accessible from userspace, so
> you're saying even those are off limits for adding callbacks?

Yes. Even the "raw" tracepoints were designed as an "observation only"
API. Using them in lieu of notifiers is really repurposing them for
something they were not meant to do.

Just in terms of maintainability at the caller site, we should be
allowed to consider _all_ tracepoints as mostly exempt from side-effects
outside of the data structures within the attached tracers. This is not
true anymore if they are repurposed as notifiers.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com


