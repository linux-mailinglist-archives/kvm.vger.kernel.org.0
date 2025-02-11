Return-Path: <kvm+bounces-37776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B11A7A30151
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 03:10:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 21A441889118
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 02:10:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 073C1155336;
	Tue, 11 Feb 2025 02:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="J2NlU1bS"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EAB26BDB6;
	Tue, 11 Feb 2025 02:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739239820; cv=none; b=TvjErPu7cecAaaDEjy4pMVabdKd368Kj80b15bGtS/upST7FfMka9I8lEkAngr8osDWCdZqrnj0831gbVcm3/7B0wcyQxcDll/huoLrmtBnQOkcWsou6TJd525v8sh5ioYAuqJJWRinzqGIsc6iFgTTK2vRpOioLx0SUEp2CQgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739239820; c=relaxed/simple;
	bh=LNAELXR25QLhZ60L2E3BhWgFcqWuotAESCDfV6NklpA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EoHUgAgeK5WpmxcGCIkpy15I3KmY4ZZZHBn/ZfEBhhaHsn2T+wpV41jQmzbU2aggxgH7laJ8H7jIX2lciYgzcQ7VyvFoKXtwiWvWOoiLUs+7iT8QTJUPU9BtR54pHBPfeNcCiMUUEAluwZrohjvyOS00oLsMklFf5QwfZfHaiVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=J2NlU1bS; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 51B29ccE2395994
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 10 Feb 2025 18:09:38 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 51B29ccE2395994
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025011701; t=1739239779;
	bh=O5qRIdXnEK4dfbCNrq+hlyh6+pTco9nSmyBf6AOVPew=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=J2NlU1bSf5X5b8U5C/Pujcs8/juIxf5RXyQNvEflIEajXtw8uj8Bfci8+AGSiikVP
	 FtozmRQnST21BaewFCPXD/wn3LQBdgvu0/qRBbi69V+xmgQZvThOuBPEByKjbB+TsL
	 FpzijsPj81vny402aZ66s0s2+nyPwk7pxgHC1iITpVr3yNZaJvr00jNMohiuis+rQT
	 15DDDeoP+Z6bjhBAGZrbdFCQvd0m7OhgoEv3wa3PCex7NncrIQZ0gdW8rI9pRQPSxn
	 TbkYHpiviVrF3UfU3tq6IRiU1hEM73fS38uyS8FrDugqfmM+NpGaRXva3fKM59bEJ+
	 6vRWY+DzBXpXg==
Message-ID: <adcd4fb5-052a-4d75-b1f9-1168d153338a@zytor.com>
Date: Mon, 10 Feb 2025 18:09:37 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/6] Introduce CET supervisor state support
To: Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>,
        Borislav Petkov <bp@alien8.de>
Cc: tglx@linutronix.de, dave.hansen@intel.com, x86@kernel.org,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        peterz@infradead.org, rick.p.edgecombe@intel.com, mlevitsk@redhat.com,
        weijiang.yang@intel.com, john.allen@amd.com
References: <20241126101710.62492-1-chao.gao@intel.com>
 <Z0WitW5iFdu6L5IV@intel.com> <Z4HI2EsPwezokhB0@google.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <Z4HI2EsPwezokhB0@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/10/2025 5:26 PM, Sean Christopherson wrote:
> On Tue, Nov 26, 2024, Chao Gao wrote:
>> On Tue, Nov 26, 2024 at 06:17:04PM +0800, Chao Gao wrote:
>>> This v2 is essentially a resend of the v1 series. I took over this work
>> >from Weijiang, so I added my Signed-off-by and incremented the version
>>> number. This repost is to seek more feedback on this work, which is a
>>> dependency for CET KVM support. In turn, CET KVM support is a dependency
>>> for both FRED KVM support and CET AMD support.
>>
>> This series is primarily for the CET KVM series. Merging it through the tip
>> tree means this code will not have an actual user until the CET KVM series
>> is merged. A good proposal from Rick is that x86 maintainers can ack this
>> series, and then it can be picked up by the KVM maintainers along with the
>> CET KVM series. Dave, Paolo and Sean, are you okay with this approach?
> 
> Boris indicated off-list that he would prefer to take this through tip and give
> KVM an immutable branch.  I'm a-ok with either approach.
> 

So is the plan to merge this patch set in the v6.14 cycle?

Thanks!
     Xin

