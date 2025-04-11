Return-Path: <kvm+bounces-43126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 71309A85210
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 05:33:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59B723BF43A
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 03:32:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B33FE27BF6C;
	Fri, 11 Apr 2025 03:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="R+1KZ6Mz"
X-Original-To: kvm@vger.kernel.org
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472BB28F1;
	Fri, 11 Apr 2025 03:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744342381; cv=none; b=Y4EAMn9MAN77wZE4a6W+XZEEfILCt/Aa9cw5dJlMxBHOUIs8HIDdV1PaAijw2/hT3jWrcxn39IroLPRW08ioUvM+5GzBxooLr0W1EaC/uvX6SNA96kdiQbsHluJq2HqbUVuVHcrzfTgliCS6RCpsO3jxaQ/2v3uCdScbaWjT/Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744342381; c=relaxed/simple;
	bh=Y3RcddSGjWAAwq2TDLG7Co+ofKt9Ax8koqEjhnrjHEw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cONsK2GgL2vfDBlHnDaYnCCBImc4iPlt5AaFkOmuv31zMEODb613zHf6dPydiZ1X0GORE96ysun4NFQ5vLlTcBUeUEJH5B7JWkC0CT0FpCLHvDZBb6rLQELZYyW96ZB4VOQ5g8paPy8NCb1sSXzsq/26qKGYbGJGvqoDt3Fce4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=R+1KZ6Mz; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1744342369; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=6qUyEujLX22GdEnd5CUDnJ4Pz1LPAiyWrj7/y+BbMoE=;
	b=R+1KZ6Mztf5GATFYUNuqTwJuIpDgwzOWWpbYrrQLH1+7OPiUPuGMVPRoUGUkD79R718Cdbl1LSw6FMXDHlgFvbVM3RlAeZgTLRgxX3jv8rRAvBtE2RBSehuuJfTA2coq8GlgcGVk9Ur980bmaEqk0gFKD8NNoUJfUKPP73j4FUg=
Received: from 30.246.160.68(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0WWRkGtA_1744342365 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 11 Apr 2025 11:32:47 +0800
Message-ID: <18875bd7-bf01-4ba8-b38a-4c0767e3130e@linux.alibaba.com>
Date: Fri, 11 Apr 2025 11:32:45 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 10/11] arm64: idle: export arch_cpu_idle()
To: Ankur Arora <ankur.a.arora@oracle.com>, linux-pm@vger.kernel.org,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: catalin.marinas@arm.com, will@kernel.org, x86@kernel.org,
 pbonzini@redhat.com, vkuznets@redhat.com, rafael@kernel.org,
 daniel.lezcano@linaro.org, peterz@infradead.org, arnd@arndb.de,
 lenb@kernel.org, mark.rutland@arm.com, harisokn@amazon.com,
 mtosatti@redhat.com, sudeep.holla@arm.com, cl@gentwo.org, maz@kernel.org,
 misono.tomohiro@fujitsu.com, maobibo@loongson.cn, zhenglifeng1@huawei.com,
 joao.m.martins@oracle.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20250218213337.377987-1-ankur.a.arora@oracle.com>
 <20250218213337.377987-11-ankur.a.arora@oracle.com>
From: Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <20250218213337.377987-11-ankur.a.arora@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2025/2/19 05:33, Ankur Arora 写道:
> Needed for cpuidle-haltpoll.
> 
> Acked-by: Will Deacon <will@kernel.org>
> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> ---
>   arch/arm64/kernel/idle.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/kernel/idle.c b/arch/arm64/kernel/idle.c
> index 05cfb347ec26..b85ba0df9b02 100644
> --- a/arch/arm64/kernel/idle.c
> +++ b/arch/arm64/kernel/idle.c
> @@ -43,3 +43,4 @@ void __cpuidle arch_cpu_idle(void)
>   	 */
>   	cpu_do_idle();

Hi, Ankur,

With haltpoll_driver registered, arch_cpu_idle() on x86 can select
mwait_idle() in idle threads.

It use MONITOR sets up an effective address range that is monitored
for write-to-memory activities; MWAIT places the processor in
an optimized state (this may vary between different implementations)
until a write to the monitored address range occurs.

Should arch_cpu_idle() on arm64 also use the LDXR/WFE
to avoid wakeup IPI like x86 monitor/mwait?

Thanks.
Shuai



