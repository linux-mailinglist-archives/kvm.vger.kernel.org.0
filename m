Return-Path: <kvm+bounces-43908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B223A98506
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 11:12:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BC8C3A44A2
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 09:10:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 975EB242D6C;
	Wed, 23 Apr 2025 09:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="Ji33UZRI"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA23202C3A;
	Wed, 23 Apr 2025 09:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745399238; cv=none; b=nZtgc4CF4N8O0IYklcI1e09dY1/AuBPFOTTRpMTjuLLLVo08SXvVSGejpif0zRw9Nw1MEmWE2ejdyOk73Ej96Cy9PN12WXHfqVZuONKxMrVKp+w/UQXppkGYh8mJFuPvVNUiJWErbDgAy/cUKNOw5p27fLd7Xk/nS7KdJaL7uS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745399238; c=relaxed/simple;
	bh=hLSARZ7ezUIq94E3XhsRXvqFBKwnXy1y41F52yDm+4Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RGyWhzIHHUoC83t56AHo4R+mt+n8fHlgpfCuMzcrK+iUWcEa8KDvhyu789Ns2Xqc8jniDCc8X+qkwYwBJiYgiLyhMwjQq3+hU74w0xIRKKKzQEGmBXqwOy2iVmgTAjNHt7jjnTD67SkYU7Sb1lIcstS0tgrVYz/Q9nL3ga4r3H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=Ji33UZRI; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53N979GH3193929
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 23 Apr 2025 02:07:09 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53N979GH3193929
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745399230;
	bh=VjiSCI2JWGHeVcYMO/H7zWlpwh581PPs/q3++1PExpY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ji33UZRIUpEME1IjGELrymZaXtLvxPrFsYusqS19Q0xdCe0mFaa0gDh/JSw6p1d0l
	 PqCvthRxi4c5WjxuhHKWtkfgXeL/rp5l0lf7fNTT1vMmKNZHV/IrgktZm0ve8XL3GP
	 BnK7uJzs0ZuDYZ3IG3Hu6rkmxWPR3l8SBpHTqo/usYSUnoKwuN/Gcq4vXgu97erMSN
	 l0eizhqd4y5iF/lyTU2X2opWJ3nbC4x4hRCJ8L3DA0vjWbqkxR9W1V1/lKBJaH2bG/
	 /04SkaI9UMbshlp9VpAw6NvbHh9VMnSrwSzILkxIH/CpXCSGT3IReK17J7cEFG/tv4
	 8muXMfOvur7Pg==
Message-ID: <08e2aa3f-4232-45bc-8a95-1eac1074ff9c@zytor.com>
Date: Wed, 23 Apr 2025 02:07:08 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: MSR access API uses in KVM x86
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "H. Peter Anvin"
 <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
References: <a82f4722-478f-4972-a072-80cd13666137@zytor.com>
 <aAeqRk8fk8mvutw2@google.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <aAeqRk8fk8mvutw2@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/22/2025 7:40 AM, Sean Christopherson wrote:
> On Mon, Apr 21, 2025, Xin Li wrote:
>> It looks to me that MSR access API uses in KVM x86 are NOT consistent;
>> sometimes {wr,rd}msrl() are used and sometimes native_{wr,rd}msrl() are
>> used.
>>
>> Was there a reason that how a generic or native MSR API was chosen?
> 
> I doubt anyone knows for sure; that'd likely require a time travelling device
> and/or telepathic abilities :-)
> 
>> In my opinion KVM should use the native MSR APIs, which can streamline
>> operations and potentially improve performance by avoiding the overhead
>> associated with generic MSR API indirect calls when CONFIG_XEN_PV=y.
> 
> As Jürgen pointed out, they aren't indirect calls.  Though IIUC, there is still

Right, I didn't notice such an optimization went in.

> a direct CALL and thus a RET when PARAVIRT_XXL=Y.

Correct.

> 
> I agree that using PV APIs in KVM doesn't make much sense, as running KVM in a
> XEN PV guest doesn't seem like something we should optimize for, if it's even
> supported.  So if we end up churning all of the rdmsr/wrmsr macros, I have no
> objection to switching to native variants.

Thanks for the confirmation.

> 
> Though if we do that, it would be nice if there's a way to avoid the "native_"
> prefix everywhere, for the sake of readability.
> 

Yeah, I will think about better naming them.


