Return-Path: <kvm+bounces-47606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 22778AC2901
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 19:45:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA16C178293
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 17:45:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4B642989A5;
	Fri, 23 May 2025 17:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NAYkbMnB"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C885B367
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 17:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748022298; cv=none; b=rM3gUpSS43StgVQBQqLFrzBoArNPx361fg2iZURztA/EGOS8PKnwpcmKczAlRI0DdIiXrVDsBYPDFjXwQCBuPzt/HwjpzYuJmMECbFrH7KS29jn69oa51uI5Yyo36nJm9M4uSg3xCItRpA30ualPCBg7BvUPbV4qo8fF1Wr96Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748022298; c=relaxed/simple;
	bh=WLYdKQDt07xomL9E7YSjellVtwIwFOs4bfXXPpfWz3w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bwq487crS+I+tq1rslpbFiPObpsG7yRR7o7uL/T/ckS11/Rq5hTLBz7/yBtYlu914rFOgrRvfnKtlL9hqtuX/12QuW+RKSHFQtvsIgV130/o4IMVoL2t6hUVbHhwwJ48JBFaDTaA/HNv+v5EqhmelasPp/9MXVromUyhln9X1ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NAYkbMnB; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <7ad8cfad-745f-4626-a2ce-eab33998a711@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748022283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rQan1lP1SvjQ3YoRxtVwG6BShbKuywXf8Ct5XNCQIOg=;
	b=NAYkbMnBv2evElrcBOFds8eWgU1fYgMA3/0NEOiNFfz9SqkvlWQGDOpCmog0ZWqn9eNse8
	fgii+JDcSH7sb67ucwZRsWTjlg7ojV58E/jfFNqNTcCx/JnTYuL4z8vytXAqUB3iq1OggA
	4d+3iHUV/8HVnz+o13xmZw9cjoW8J+s=
Date: Fri, 23 May 2025 10:44:37 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 0/2] RISC-V: KVM: VCPU reset fixes
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>,
 Anup Patel <apatel@ventanamicro.com>
Cc: kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones <ajones@ventanamicro.com>
References: <20250515143723.2450630-4-rkrcmar@ventanamicro.com>
 <1a7a81fd-cf15-4b54-a805-32d66ced4517@linux.dev>
 <DA3CUGMQXZNW.2BF5WWE4ANFS0@ventanamicro.com>
 <CAK9=C2Xi3=9JL5f=0as2nEYKuRVTtJoL6Vdt_y2E06ta6G_07A@mail.gmail.com>
 <DA3FGGI5PEZG.3T26KJXT2QO8M@ventanamicro.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Atish Patra <atish.patra@linux.dev>
In-Reply-To: <DA3FGGI5PEZG.3T26KJXT2QO8M@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On 5/23/25 2:20 AM, Radim Krčmář wrote:
> 2025-05-23T13:38:26+05:30, Anup Patel <apatel@ventanamicro.com>:
>> On Fri, May 23, 2025 at 12:47 PM Radim Krčmář <rkrcmar@ventanamicro.com> wrote:
>>> 2025-05-22T14:43:40-07:00, Atish Patra <atish.patra@linux.dev>:
>>>> On 5/15/25 7:37 AM, Radim KrÄmÃ¡Å wrote:
>>>>> Hello,
>>>>>
>>>>> the design still requires a discussion.
>>>>>
>>>>> [v3 1/2] removes most of the additional changes that the KVM capability
>>>>> was doing in v2.  [v3 2/2] is new and previews a general solution to the
>>>>> lack of userspace control over KVM SBI.
>>>>>
>>>> I am still missing the motivation behind it. If the motivation is SBI
>>>> HSM suspend, the PATCH2 doesn't achieve that as it forwards every call
>>>> to the user space. Why do you want to control hsm start/stop from the
>>>> user space ?
>>> HSM needs fixing, because KVM doesn't know what the state after
>>> sbi_hart_start should be.
>>> For example, we had a discussion about scounteren and regardless of what
>>> default we choose in KVM, the userspace might want a different value.
>>> I don't think that HSM start/stop is a hot path, so trapping to
>>> userspace seems better than adding more kernel code.
>> There are no implementation specific S-mode CSR reset values
>> required at the moment.
> Jessica mentioned that BSD requires scounteren to be non-zero, so
> userspace should be able to provide that value.

Jessica admitted that it was a bug which should be fixed.

> I would prefer if KVM could avoid getting into those discussions.
> We can just just let userspace be as crazy as it wants.

The scounteren state you mentioned is already fixed now.

I would prefer to do this if there are more of these issues. Otherwise,
we may gain little by just delegating more work to the userspace for no 
reason.

>>                          Whenever the need arises, we will extend
>> the ONE_REG interface so that user space can specify custom
>> CSR reset values at Guest/VM creation time. We don't need to
>> forward SBI HSM calls to user space for custom S-mode CSR
>> reset values.
> The benefits of adding a new ONE_REG interface seem very small compared
> to the drawbacks of having extra kernel code.

How ? The extra kernel code is just few lines where it just registers a 
SBI extension and forwards
it to the userspace. That's for the entire extension.

For extensions like HSM, only selective functions that should be 
forwarded to the userspace which
defeats the purpose.

Let's not try to fix something that is not broken yet.

> If userspace would want to reset or setup new multi-VCPUs VMs often, we
> could add an interface that loads the whole register state from
> userspace in a single IOCTL, because ONE_REG is not the best interface
> for bulk data transfer either.
>
>>> Forwarding all the unimplemented SBI ecalls shouldn't be a performance
>>> issue, because S-mode software would hopefully learn after the first
>>> error and stop trying again.
>>>
>>> Allowing userspace to fully implement the ecall instruction one of the
>>> motivations as well -- SBI is not a part of RISC-V ISA, so someone might
>>> be interested in accelerating a different M-mode software with KVM.
>>>
>>> I'll send v4 later today -- there is a missing part in [2/2], because
>>> userspace also needs to be able to emulate the base SBI extension.
>>>
>> [...]          The best approach is to selectively forward SBI
>> calls to user space where needed (e.g. SBI system reset,
>> SBI system suspend, SBI debug console, etc.).
> That is exactly what my proposal does, it's just that the userspace says
> what is "needed".
>
> If we started with this mechanism, KVM would not have needed to add
> SRST/SUSP/DBCN SBI emulation at all -- they would be forwarded as any
> other unhandled ecall.

