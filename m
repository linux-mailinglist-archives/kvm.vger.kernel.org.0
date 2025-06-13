Return-Path: <kvm+bounces-49464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44762AD93D5
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 19:37:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD013174853
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 17:37:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D907D226D0D;
	Fri, 13 Jun 2025 17:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="JKSfXSSb"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E913D2135DE;
	Fri, 13 Jun 2025 17:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749836259; cv=none; b=mxC/SpoKYjpGIG3ssbtx311Yf0Djm88s3jTL4dHxnvcDarw00NtGm4FvGF+O3vU6plfYU+3SObyBuWEGRUXfDnoFKOQ62iizKAASIXlPlbnB23MibsQxpWjTv/jcHohzddOkYixTRF/u2Tlv493wVDopOLbH2+CIqrJRSQTFR2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749836259; c=relaxed/simple;
	bh=RCHzA/w1RDDF7+L88gYrHyusz6EWsbz4ORoB6/zmq00=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NWjADukGCqcn+Kvs3Ogybr9nXAn23SRHvTS4d8T8kJkQBRUxGdFRe8wpynZ0GYw4aPTPIItfJ4SX3FMXJPgnvo0I/CT/KUx7qJVl7l9ySfoVzuvwLNqQ7ZfzmsYksk+iOzG8KxIxEN6rNIP6Rw9LAQspwFzLSeeIbCRfdJlE88U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=JKSfXSSb; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55DHaqHM3883025
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 13 Jun 2025 10:36:54 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55DHaqHM3883025
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025052101; t=1749836220;
	bh=kPSMyvkHiVSMixJXEZQhsjiAeIt3rBCyb1wBlVTjgBw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JKSfXSSb47/SY2ZIbaNLIFq7kcFFnamgnNP9sthLAomRa1SP4bq8+T3ZAaTU/taT5
	 qsETGYLFo3gpwg6f/xm9tdJzc81qap42U/jho+nQczfV0Z95LmBdRNrN+PgkOZwTnx
	 gCTfaFCv1yLNGJRDlx776ZXDEH5hed6G4T8RjNzHNE5eZZLlhmtdTqKFw/dSgRgsBb
	 zc1eNI2Y10yZth86fyBoD5DjcjKAfHWXemmitGLU+oxzUdIuJTORQCJ1zrMUdOXJBH
	 oCOhjsJPpQyiMI+8Q4Z+KG4XI2WjofmAb6ye8NGziiQ3WETv6FfybnGE4VkdpuiNEC
	 Zs4u1pE6vAlUA==
Message-ID: <0d2e6039-943a-4b7a-ab8d-29049cb02a90@zytor.com>
Date: Fri, 13 Jun 2025 10:36:52 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/3] x86/traps: Initialize DR7 by writing its
 architectural reset value
To: Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com, brgerst@gmail.com,
        tony.luck@intel.com, fenghuay@nvidia.com
References: <20250613070118.3694407-1-xin@zytor.com>
 <20250613070118.3694407-3-xin@zytor.com>
 <20250613071536.GG2273038@noisy.programming.kicks-ass.net>
 <aEwxcVzQubz3BmmJ@google.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <aEwxcVzQubz3BmmJ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/13/2025 7:10 AM, Sean Christopherson wrote:
> On Fri, Jun 13, 2025, Peter Zijlstra wrote:
>> On Fri, Jun 13, 2025 at 12:01:16AM -0700, Xin Li (Intel) wrote:
>>
>>> While at it, replace the hardcoded debug register number 7 with the
>>> existing DR_CONTROL macro for clarity.
>>
>> Yeah, not really a fan of that... IMO that obfuscates the code more than
>> it helps, consider:
> 
> +1, and NAK to the KVM changes.

I guess I was too aggressive to make overkill changes in a bug-fixing
patch, which will be back-ported.

I will revise the patch set to focus on bug fixing first.

> Pretty much everything in KVM deals with the
> "raw" names.  The use of dr6 and dr7 is pervasive throughout the VMX and SVM
> architectures:
> 
>   vmcs.GUEST_DR7
>   vmcb.save.dr6
>   vmcb.save.dr7
> 
> And is cemented in KVM's uAPI:
> 
>   kvm_debug_exit_arch.dr6
>   kvm_debug_exit_arch.dr7
>   kvm_debugregs.dr6
>   kvm_debugregs.dr7
> 
> Using DR_STATUS and DR_CONTROL is not an improvement when everything else is using
> '6' and '7'.  E.g. I skipped the changelog and was very confused by the '6' =>
> DR_STATUS change in the next patch.
> 
> And don't even think about renaming the prefixes on these :-)

I did think about changing DR6_ to DR_STATUS_ and DR7_ to DR_CONTROL_ ;)

However it seems that DR7_ and DR6_ are de facto prefixes in the kernel
code, and everyone appears to recognize their intended use.  It's better
for me to leave them as-is.

> 
> #define DR6_BUS_LOCK   (1 << 11)
> #define DR6_BD		(1 << 13)
> #define DR6_BS		(1 << 14)
> #define DR6_BT		(1 << 15)
> #define DR6_RTM		(1 << 16)
> /*
>   * DR6_ACTIVE_LOW combines fixed-1 and active-low bits.
>   * We can regard all the bits in DR6_FIXED_1 as active_low bits;
>   * they will never be 0 for now, but when they are defined
>   * in the future it will require no code change.
>   *
>   * DR6_ACTIVE_LOW is also used as the init/reset value for DR6.
>   */
> #define DR6_ACTIVE_LOW	0xffff0ff0
> #define DR6_VOLATILE	0x0001e80f
> #define DR6_FIXED_1	(DR6_ACTIVE_LOW & ~DR6_VOLATILE)
> 
> #define DR7_BP_EN_MASK	0x000000ff
> #define DR7_GE		(1 << 9)
> #define DR7_GD		(1 << 13)
> #define DR7_FIXED_1	0x00000400
> #define DR7_VOLATILE	0xffff2bff


