Return-Path: <kvm+bounces-48711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12BC8AD177F
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 05:22:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D27F816A94E
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 03:22:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5914258CD3;
	Mon,  9 Jun 2025 03:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XD/U00Tq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B25180B;
	Mon,  9 Jun 2025 03:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749439338; cv=none; b=nbx9KueiPXJbk5akAMF9Hpvanw9gQgcCXxjKIsSsZlKef3wblRbhdtF/5R8E8JkJF37Vyx5ocDoAsocD8BU+wbFjWsGOOjDH1O+XNKDkuIk6JeUDLJWfLGU5M8YVulUTNPtzoyjCSG9N5QORc9YWTwr/xcCUWjRz5fSv7ygdQQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749439338; c=relaxed/simple;
	bh=BbK3oIpLTYsKJb4yBwjgaQYiax8NdJVCzOR6QWvCZss=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=QMtaRgRQOdu6y/ln6Sy5es0f1uOXjbeVRkOf+Ata4vTx35ueLjC5Tk6MmUCTBY4j1e9utRGItHPRu1U3Ewo4jp2rvQa4/Im2sS/FyGllzFxEiheWVAncrJi/A1A1H6BwRO4/s1n8xlUZiGMLT2CGthcDYd/a3fBYCL+Uz7el+5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XD/U00Tq; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749439337; x=1780975337;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=BbK3oIpLTYsKJb4yBwjgaQYiax8NdJVCzOR6QWvCZss=;
  b=XD/U00TqY+iZ3gG/v4/M2FhBlQGA0nPDQ9gwKyo/pHXzmnxBGwVWfRW5
   8WLjHRf7eke2W1Ry2rw4gQDsyeiQoNnjtJ+CgO8LT4E9OWOGau6OXNXuB
   3TJ3RumBP9kN4h/owUdn0QC6HR6t9VPFhPDe5Pxfgr7ohyU6vxhD9nlap
   J4h0MrnbWN1/QUlQ5MgWZcGSnmHcqIp8bk3M8EfSBK0gdujxGm9VtEf8h
   AwqBDM9QRP5iK9VcTJkip8w53dl/YXIxySbF2P2ZkvduLmvD9Ykw7H/K7
   ktLdr/mXS9StT9yHfSTYpAiIZUa1EXQloEjllXhRiLqfKpRbdm1ijZ9de
   g==;
X-CSE-ConnectionGUID: nbkIBlEnRp2C/PX2Z9SXtw==
X-CSE-MsgGUID: JKLJaXHFRDqq+JbDvwie2Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11458"; a="55169652"
X-IronPort-AV: E=Sophos;i="6.16,221,1744095600"; 
   d="scan'208";a="55169652"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2025 20:22:16 -0700
X-CSE-ConnectionGUID: hUT08QQGTauJwvoV7V8NnA==
X-CSE-MsgGUID: zNzEdeWCT2mT5tSVDK1fmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,221,1744095600"; 
   d="scan'208";a="150206501"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.144]) ([10.124.245.144])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2025 20:22:14 -0700
Message-ID: <6e162be6-0ab0-4cfe-a9f4-fad4f605e16b@linux.intel.com>
Date: Mon, 9 Jun 2025 11:22:11 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kvm: preemption must be disabled when calling
 smp_call_function_many
To: Salah Triki <salah.triki@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <aEQW81I9kO5-eyrg@pc>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <aEQW81I9kO5-eyrg@pc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/7/2025 6:39 PM, Salah Triki wrote:
> {Disable, Enable} preemption {before, after} calling
> smp_call_function_many().
>
> Signed-off-by: Salah Triki <salah.triki@gmail.com>
> ---
>  virt/kvm/kvm_main.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index eec82775c5bf..ab9593943846 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -209,7 +209,10 @@ static inline bool kvm_kick_many_cpus(struct cpumask *cpus, bool wait)
>  	if (cpumask_empty(cpus))
>  		return false;
>  
> +	preempt_disable();
>  	smp_call_function_many(cpus, ack_kick, NULL, wait);
> +	preempt_enable();
> +
>  	return true;
>  }
>  

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



