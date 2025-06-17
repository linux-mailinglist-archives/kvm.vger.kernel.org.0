Return-Path: <kvm+bounces-49773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 877B3ADDF62
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 01:09:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 53BA9189DAD7
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 23:09:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3928C296160;
	Tue, 17 Jun 2025 23:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="T+qboT5M"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC902F532C;
	Tue, 17 Jun 2025 23:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750201766; cv=none; b=cdbSi5j1eF6SxdgCKDSO0iEAKCG9kaJfdOxzqqNJLJmzZdvWW+ZH3m8l4R/i73L3qt1xG94Zcd0Q+Y7KXua4h4b7aQKILfwKutBKbMhBWNSCafSGHg2ObOUeXDDlcrd3pZ0eiYSdutR3VTmLFgJXwIXEJpWbbFWUEqc1zetJzK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750201766; c=relaxed/simple;
	bh=/lPytD/D3cajYO2gj+Ujkh1JW+PnI0w/YfVrlYEE3xs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bTL41IcYOOW8TTjmNBjaQrmt14xBKLT2K2iRRIWf9G80atdB0tHquCn0zas4oOZ4csCO/f+pLsx7yteyTU3nManRXjOTvXS/fX8p19C91Q9ICuZPxyuW4m7VnC9L5E4G7j9AIx/gwhbPM5lRgPs1LScsA/jMheXjB0K5xsIife8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=T+qboT5M; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55HN8qJe1308572
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 17 Jun 2025 16:08:53 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55HN8qJe1308572
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025052101; t=1750201734;
	bh=YFyQUnHfC6MCqPgzwbmXxqWCFr4/Lqi2i8XL/zaI6KI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=T+qboT5Mm9+r4r6CX9urHDGSfRrgCyY13NjxBRW8AloQZXbgK94N8a8j0KvDZeuoR
	 +byWoUgBwm4krVeFyV8A1OY7L1LkobNd8HhkpoRH8A/bJZC9myLgnTdJQ9YpfwaCkm
	 rQBjLAqszcaqoxo3tpg8SAUMZ4cCcaZR+hw+e5wGyXYHbOm7t8THHNZPxm9i+SkJw4
	 CIJf3EaZnD9QQMAKFXucDszCx2HzeV+NRSBd+Z4+/uSHcExdmOC25sygICCJeTlUsb
	 uKsS98X3xMOJHqXQm7F4bIO+rWuFDPl4a/GAtjCRbeOIig1S7MA3ee9NgCJcD0AF0K
	 DEsErzH8hkJBg==
Message-ID: <9720c605-c542-4969-b7f0-b4477bc2ab1e@zytor.com>
Date: Tue, 17 Jun 2025 16:08:51 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] x86/traps: Initialize DR7 by writing its
 architectural reset value
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        peterz@infradead.org, sohil.mehta@intel.com, brgerst@gmail.com,
        tony.luck@intel.com, fenghuay@nvidia.com
References: <20250617073234.1020644-1-xin@zytor.com>
 <20250617073234.1020644-3-xin@zytor.com> <aFFvECpO3lBCjo1l@google.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <aFFvECpO3lBCjo1l@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/17/2025 6:35 AM, Sean Christopherson wrote:
> On Tue, Jun 17, 2025, Xin Li (Intel) wrote:
>> Initialize DR7 by writing its architectural reset value to ensure
>> compliance with the specification.
> 
> I wouldn't describe this as a "compliance with the specificiation" issue.  To me,
> that implies that clearing bit 10 would somehow be in violation of the SDM, and
> that's simply not true.  MOV DR7 won't #GP, the CPU (hopefully) won't catch fire,
> etc.
> 
> The real motiviation is similar to the DR6 fix: if the architecture changes and
> the bit is no longer reserved, at which point clearing it could actually have
> meaning.  Something like this?
> 
>    Always set bit 10, which is reserved to '1', when "clearing" DR7 so as not
>    to trigger unanticipated behavior if said bit is ever unreserved, e.g. as
>    a feature enabling flag with inverted polarity.

I will use your description.

I hope the bit will be kept reserved to 1 *forever*, because inverted
polarity seems causing confusing and complicated code only.

> 
> With a tweaked changelog,
> 
> Acked-by: Sean Christopherson <seanjc@google.com>

Thanks!
     Xin



