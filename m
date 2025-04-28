Return-Path: <kvm+bounces-44528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC11DA9E9C7
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 09:45:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1DC2F172CAD
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 07:45:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39C181DF247;
	Mon, 28 Apr 2025 07:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="RFeRNuA3"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E611D6DAA;
	Mon, 28 Apr 2025 07:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745826294; cv=none; b=cs3geW8G2GDRPGIKHlU8krfS6n+Z+peexkwOP1X+jqK/4smpToctFwXOa+9kyXb6qai7uJNsTtQy1M93QMGD9fQmHrfXOIj+elG5YL4YPVXyz0NLQtCtPGpqjYGc8bhLbfyn+yCNnVf+BQI81Qw1pyAjBu1hLdRa4Vy3PrhW934=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745826294; c=relaxed/simple;
	bh=NYm63tbfaXgDfW0aBIqEJQfnIBRLoLZfmjY0nzxO2Vs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xb6lcS0MwKCMbupveeg2HH+D0aJI0wFi4U6byUtdMG721JKXG6NSy8jb51VO8XQtqflrTBiw/X1FXSvMSoRXUHFzE5wwP0ec75YiVzQCqqsu7hMtfBshqwTzK21i72yv4vy3Lgk6XmV/Hi88kVYjJHgBtJrCqM7Sal7Da8a/DYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=RFeRNuA3; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53S7i75n3115917
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 28 Apr 2025 00:44:08 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53S7i75n3115917
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745826251;
	bh=+2DjUZrTCltqsS6c9mpaqFIMdN7tyQkbibgydyEnOd0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RFeRNuA3VITJtjtCWgnIR1gSeyfuKcFlaE9dfPbek+ei/rtJ6ELFEox78CBB3bzOK
	 41LaibC4KCT1SwB6sJF4gQjRa6xA2MLNTn6+mLbk3i9Em5US8txbCR18bOwjsvqbZl
	 yIdXK9FCN68rSPUICMMOTILqvW6O8zL4KL8ztDXzOEeXUfIvAJIS2yrfyHDei1Cr5u
	 VTWrH/q2bNR9mq3uIst28+AHUch6ra6e+3+eep6a6kOl2yeeuZWoL9Y14ZLOAw6roO
	 JJLicnkGRn3I/+qPwc6Te+887dVQiOciXlHKThq9Xo7ykEmsWT7e58GB5aZcK8CQOW
	 sHY8T5/tXyoSw==
Message-ID: <15fd8eaf-ba71-4f0e-9aed-5f7a6f5a4ea7@zytor.com>
Date: Mon, 28 Apr 2025 00:44:06 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/7] x86/fpu/xstate: Differentiate default features for
 host and guest FPUs
To: Chao Gao <chao.gao@intel.com>, Sean Christopherson <seanjc@google.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "ebiggers@google.com" <ebiggers@google.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        Stanislav Spassov <stanspas@amazon.de>,
        "levymitchell0@gmail.com" <levymitchell0@gmail.com>,
        "samuel.holland@sifive.com" <samuel.holland@sifive.com>,
        Xin3 Li <xin3.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Weijiang Yang <weijiang.yang@intel.com>,
        "mingo@redhat.com"
 <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "john.allen@amd.com" <john.allen@amd.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        Chang Seok Bae <chang.seok.bae@intel.com>,
        "vigbalas@amd.com" <vigbalas@amd.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "hpa@zytor.com"
 <hpa@zytor.com>, "bp@alien8.de" <bp@alien8.de>,
        "aruna.ramakrishna@oracle.com" <aruna.ramakrishna@oracle.com>,
        "x86@kernel.org" <x86@kernel.org>
References: <20250410072605.2358393-1-chao.gao@intel.com>
 <20250410072605.2358393-4-chao.gao@intel.com>
 <f53bea9b13bd8351dc9bba5e443d5e4f4934555d.camel@intel.com>
 <aAtG13wd35yMNahd@intel.com>
 <4a4b1f18d585c7799e5262453e4cfa2cf47c3175.camel@intel.com>
 <aAwdQ759Y6V7SGhv@google.com> <aA71VD0NgLZMmNGi@intel.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <aA71VD0NgLZMmNGi@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/27/2025 8:26 PM, Chao Gao wrote:
>> For KVM, it's just the one MSR, and KVM needs to support save/restore of that MSR
>> no matter what, so supporting it via XSAVE would be more work, a bit sketchy, and
>> create yet another way for userspace to do weird things when saving/restoring vCPU
>> state.
> Agreed. One more issue of including CET_S into KVM_GET/SET_XSAVE{2} is:
> 
> XSAVE UABI buffers adhere to the standard format defined by the SDM, which
> never includes supervisor states. Attempting to incorporate supervisor states
> into UABI buffers would lead to many issues, such as deviating from the
> standard format and the need to define offsets for each supervisor state.

Good point.

FRED RSPs are in the supervisor state and are not defined within the
XSAVE area.  Their save/restore operations need to be explicitly added 
one by one.

Would it be sensible to introduce a KVM supervisor MSR state that
includes new MSRs?

This approach is similar to what KVM has with its CPUID API, allowing
batch MSR set/get operations and improving MSR code sharing.  Since the
FRED state is entirely defined in MSRs (except for CR4.FRED), this
should simplify the context save and restore for FRED.

Thanks!
     Xin

