Return-Path: <kvm+bounces-53594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 37693B14614
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 04:18:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8460C1AA117A
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 02:18:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 733131FDA8C;
	Tue, 29 Jul 2025 02:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="G1W44HCM"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0217483;
	Tue, 29 Jul 2025 02:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753755504; cv=none; b=JFxzFxkM1ZCPUQVot3/6VVrIbflqf8Fr2BC961p/qcBG0yT/s+TzHAj0icsi8lM/zYXYg5WlbVjImXUIOJyoij92Cs8vy89CP8bxaP3ZkxqxGM7dbaWqjoeVe1SI6f+qkm7cVG8UtgYhRRu/CY6T+1Jyi4bwFRAQIoCLSCQ6Z8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753755504; c=relaxed/simple;
	bh=KS8HWrhgz8fnRq87XwWNhCMPn39jx9HbFOH3eZggN9c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rYN/sMlaYCxf0kHp68GCauSd0PNU/ySLN0FCWafb60vMDNxfuj0eK7NT0QOM9WLp7RvFS/ZW2bUnOMNPOKxVOqUmHe0Vh/X60ZeWyOmIzWCFeOqXtzCYLfOJGaPgFEmI54SjROfI54AJX0NgLSjt0OUP/Hc4cNjw7375ZzQzrpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=G1W44HCM; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 56T2Hgg1598952
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 28 Jul 2025 19:17:43 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 56T2Hgg1598952
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1753755467;
	bh=RO1R3VhjF2DHy2JY4w58Uf4YbGuzU//YBTsJv/wKNoI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=G1W44HCMVJtdI8XiMRmYm6f5vSZGHivytkICyuiMAvOTgm1SoKN8IMVDFsuVVSgMS
	 YNIsZ8y6sYA0OiW5sTCIm9wO0ueNXY4+AvipUAkVzPec6WJZ7lzgWDB67/I4Yku/tA
	 h5EbKZqrFqtbVF0T0lTAfui2yxxszfE/A/dW2kn4XRbnztonF0eKDxbAR7Kzrz5Vjk
	 r8nv9HT+4zN94Ec6lc8aP8LFfXCvUgZk3iNMESSoLaDxLyc/06oj85SACbeo9Ulc+P
	 2z0wO4q/rbO4WwvI619xbirtcrA4fJ4BTliW2zizJX+qwYUvBhaIJ1plPWpj927YyC
	 owOOYnXvFpKeQ==
Message-ID: <49ad9e5a-57a1-42fc-8488-6f35f02e802c@zytor.com>
Date: Mon, 28 Jul 2025 19:17:41 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 12/23] KVM: VMX: Introduce CET VMCS fields and control
 bits
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        rick.p.edgecombe@intel.com, mlevitsk@redhat.com, john.allen@amd.com,
        weijiang.yang@intel.com, minipli@grsecurity.net,
        Zhang Yi Z <yi.z.zhang@linux.intel.com>,
        Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20250704085027.182163-1-chao.gao@intel.com>
 <20250704085027.182163-13-chao.gao@intel.com>
 <b63275a2-8d7e-4e45-ae4b-f69e90644fe5@zytor.com> <aIgkKTkxCLoBHOIs@intel.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <aIgkKTkxCLoBHOIs@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/28/2025 6:30 PM, Chao Gao wrote:
>> A comment not on this patch itself.
>>
>> Both spaces and tabs are currently used to align columns in
>> arch/x86/include/asm/vmx.h.  Can we standardize on one, either spaces or
>> tabs?
> I'm okay with using tabs or spaces consistently, but doing so will cause a lot
> of code churn and make it slightly harder to use git-blame. Let's see what
> others think.

Agreed, lets see what Sean would say :)


