Return-Path: <kvm+bounces-49394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A6E0BAD8502
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 09:53:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D8973188A7FD
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 07:49:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 875E62DA77A;
	Fri, 13 Jun 2025 07:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="xKz5uMPx"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DF62DA75B;
	Fri, 13 Jun 2025 07:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749800306; cv=none; b=D7Kw3bje2R1E6ueSfrewQQ3LGGxYU5vRrU2XmfnnT7Aw3ChRglC4CIOZWWuNSOioy3D52Qb4LNNG5PWz/MxgDtA7H++5YEdhU403WnPvf1CR2MNgAjRvh2T/JrSA1Bw8Fbg3y03oqinESB9v8W6CVfGCqh3UW7RnSi/HOtDOnw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749800306; c=relaxed/simple;
	bh=w6Iij3cwmrMQPwKKuH03Kpq1oTsbrkREQC03eBxFJiM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qxQOcFSroyGej/IzU9FWMkn34HmrWuCUb7R9VQ5QN4e9DbKEaXmZRYXTEFDpNhXsXT8Q+8LChriBHYfl1FDss/2NiAEx2Q9EBZHRc2T0SARFCDDxJfqnZ4ae2MoDgQj0CghknFLQ/XDwijLJO8yPCT6gr6gPCMP9ThTad2rvi8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=xKz5uMPx; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55D7bkNp3705775
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 13 Jun 2025 00:37:47 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55D7bkNp3705775
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025052101; t=1749800271;
	bh=+/yyrSGfQwPBZ1V+CFmZ/PDgxnfgD/HUBTSSml50TD4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=xKz5uMPx52/eNlp0eiFTnJZNJrFbMI/rlNNtNSXShO8zJiTp0mAET+JVcHP+Wv8nN
	 tLVo5f7HPHpPCQxOUor6oY0TNdqYfo0co2TiUmqze5EeoTzjiv+kvwmSnlcSHkrfER
	 xkTa1hkIJqJY5vMFMD7XhgvJjkO8ObTde9aqkp0wEzHBJVSiuHiUT2Fypr2n9eDIG4
	 HRxa/+WRc9fZhBISxHTQ63MdtxTN/L8UNgM7lBE05kNgOTu9+vawYnqZoJbcXzfIB0
	 S9A7w81/OW86oO01xsR+plnYwA5EAAfyX0jzmm+R9E/5yswUdJpEJaw/dLSx+o76v6
	 xYFx81SS8BK7w==
Message-ID: <457250dc-5e3f-498f-8b71-6ea4879f91af@zytor.com>
Date: Fri, 13 Jun 2025 00:37:46 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/3] x86/traps: Fix DR6/DR7 inintialization
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com,
        brgerst@gmail.com, tony.luck@intel.com, fenghuay@nvidia.com
References: <20250613070118.3694407-1-xin@zytor.com>
 <20250613071842.GH2273038@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <20250613071842.GH2273038@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/13/2025 12:18 AM, Peter Zijlstra wrote:
> On Fri, Jun 13, 2025 at 12:01:14AM -0700, Xin Li (Intel) wrote:
>>
>> Since only BLD-induced #DB exceptions clear DR6.BLD and other debug
>> exceptions leave it unchanged, even if the first #DB is unrelated to
>> BLD, DR6.BLD is still cleared.  As a result, such a first #DB is
>> misinterpreted as a BLD #DB, and a false warning is triggerred.
>>
>>
>> Fix the bug by initializing DR6 by writing its architectural reset
>> value at boot time.
>>
>>
>> DR7 suffers from a similar issue.  We apply the same fix.
> 
> Bah, this DR6 polarity is a pain in the behind for sure. Patches look
> good, except I'm really not a fan of using those 'names'. But I'll not
> object too much of others like it.

Let's see if there will be more objections :)

