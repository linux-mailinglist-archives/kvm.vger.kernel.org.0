Return-Path: <kvm+bounces-40073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 31714A4ED9E
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 20:41:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 360FE3A5914
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 19:41:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 759D625F7A8;
	Tue,  4 Mar 2025 19:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="Ukh/ua5t"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F291F5826;
	Tue,  4 Mar 2025 19:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741117268; cv=none; b=MZbctmMJ6fJWry54bh2URllId0irT55VSebS/S9leVYsQdbYi6fHnqrjazsJmUd0Ba+MjLS8IXAFnEAmyZ++b9FILJExhfA+R9xngzbrI2jif+Wi/Z9ZClne1OMyWaDM6jvjhij0WTca1YZvSZ6tcRf51lEtFw3leOY0Dft0p8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741117268; c=relaxed/simple;
	bh=v/Vr8bPgJVi4b56HsC7uD+j/eXRtL5xKFUSYo3KB2+c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JyWAMgzbqiByMtQmoXo/SF++ySUeBColsCbPyxFxtxKDQJSEgCqI/Ixt/6xFhndR1PZuOHvq6gE9BXvcmQTrCu4wHqiExlbeRZv7wc+sGUTnyNFIAHVzTRqPZ67i6c38PoX18nuPqV+Aqk4aElTVywu2bOETbCAUb5xxNZcifxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=Ukh/ua5t; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 524JeSPD2519447
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 4 Mar 2025 11:40:29 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 524JeSPD2519447
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025021701; t=1741117230;
	bh=kUcC1ROd6ts2PVfPTnLLJGMF2+Ppt5KyMe8XWtwQebI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ukh/ua5tx+lAUps1FKfHQxEGNqHF0+RzTS8KY7eIR3jxHaCdqYWoMVXhti8QO6c1r
	 p2rmmuEXtXQDIub60B1mEcLV9MiIfAKh7u0NN2SBh1vzGoDJ2C2PW6cOIs2YGIVW4W
	 QDoYp3nFUUF/DUaag4joeVoSwM32dXn73y+vwMj7qohWfi4LHHtvCSB/2ecYPWaPoH
	 yzkYfo0UA/4mqKqmzagbblb4rgFNH6/sx1kn5DV8e4cf0A+4O6cStDd+KdJkDo1SAC
	 sUBCQLPtpHI2K9v3RcoA5D5c+HV7uoY/2dz/q1C4g5YU3clTChEjzpnl7jZKPiqyDa
	 beuJ3fgzqKAKg==
Message-ID: <42035a43-660c-4d38-9369-db824e271671@zytor.com>
Date: Tue, 4 Mar 2025 11:40:27 -0800
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

Hi Sean and Boris,

At this point because KVM is the only user of this feature, would it
make more sense to take this patch set through KVM x86 tree?

Thanks!
     Xin

