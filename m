Return-Path: <kvm+bounces-60002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E32AFBD8023
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 09:51:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 273964F8898
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 07:51:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD5B230E83B;
	Tue, 14 Oct 2025 07:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="J3dDjttD"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54661E3DED;
	Tue, 14 Oct 2025 07:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760428251; cv=none; b=qoKuglumoExxIzGz21h7sC7vQHAtySqKZetbZdTM4WnZ6MQe1wjzvLE4s9inNziBxz5E8ATN/7EQG9crq1tT1KU2+YTqBlAgl7kSKbd9+CDu/mYFKRMasVbGRbi/k542bt1SlwdgSKijekw4O1Ug10ZvQI9QwC+mdbwZO7b5Iy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760428251; c=relaxed/simple;
	bh=rkzxwYdk/sO5dPB4cyPt2Q1DynRcNTAZtLm3ShlRJ5Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NWJY7WrDOP9ON4ew3pL74tXVVt55W7iX3d+gTLGIra8pDNRrvQQkOhv6wFS317Qm5YJLbGZnjCrbTjy9Rvm2PSfKbJK8Vrx2hwIdJRjQjgORBBxQpRAS4hprSYEE9srkio5cxFn7Oz3OnvOZPRUvrfJgJq3XihdRD5aCsUncpW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=J3dDjttD; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.72.64] ([218.1.208.81])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59E7o0Ap1720266
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 14 Oct 2025 00:50:02 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59E7o0Ap1720266
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025092201; t=1760428205;
	bh=Pfkhhn7MCj9tnWUfx9B2jU4KtwzZcqKV0f6oWqcM3H8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=J3dDjttD8k2nIqq+9CGJb1KBqxep2rp0RSh3PBJu3l7FP+d840idhtvhdmD2DMo8r
	 UF7JkpU24jM06uX2+P1cZ0CaNAjXgVjtWVgKuwaqeDlIgRi7+HKdAbkdcRUG7djMwY
	 XzeNQNqHJFck+wIXG4LiY70Is2NOlTvrt1XjmUvaFKR4uKqJNERE+HiQ6v5zui6hdz
	 XITc+TnZsZEPNfR0AG/CBD9XGMDGO6/HOaD0/PkVeNOzRVbotnSPKrWqQVKvw++MiM
	 3BOS21m9y2QqbTgeCgKLEv7wcL9T+J2b9RgCLO1McwGwHVru4MbVyYs+AuZ2bBB+5s
	 4kGGcEeKN8ApQ==
Message-ID: <7f33ee53-1569-4a47-8018-fd48e9c65901@zytor.com>
Date: Tue, 14 Oct 2025 15:49:59 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 18/21] KVM: nVMX: Add FRED VMCS fields to nested VMX
 context handling
To: Chao Gao <chao.gao@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com,
        hch@infradead.org
References: <20251014010950.1568389-1-xin@zytor.com>
 <20251014010950.1568389-19-xin@zytor.com> <aO30XxyprRrs3pT2@intel.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <aO30XxyprRrs3pT2@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/14/2025 2:57 PM, Chao Gao wrote:
>> +	if (!vmx->nested.nested_run_pending ||
>> +	    !nested_cpu_load_guest_fred_state(vmcs12)) {
>> +		vmx->nested.pre_vmenter_fred_config = vmcs_read64(GUEST_IA32_FRED_CONFIG);
>> +		vmx->nested.pre_vmenter_fred_rsp1 = vmcs_read64(GUEST_IA32_FRED_RSP1);
>> +		vmx->nested.pre_vmenter_fred_rsp2 = vmcs_read64(GUEST_IA32_FRED_RSP2);
>> +		vmx->nested.pre_vmenter_fred_rsp3 = vmcs_read64(GUEST_IA32_FRED_RSP3);
>> +		vmx->nested.pre_vmenter_fred_stklvls = vmcs_read64(GUEST_IA32_FRED_STKLVLS);
>> +		vmx->nested.pre_vmenter_fred_ssp1 = vmcs_read64(GUEST_IA32_FRED_SSP1);
>> +		vmx->nested.pre_vmenter_fred_ssp2 = vmcs_read64(GUEST_IA32_FRED_SSP2);
>> +		vmx->nested.pre_vmenter_fred_ssp3 = vmcs_read64(GUEST_IA32_FRED_SSP3);
> FRED state save/restore is needed only when the guest has FRED support. So, the
> above save/restore should be guarded by guest_cpu_cap_has(vcpu, X86_FEATURE_FRED).
> Otherwise, on hardware without FRED, vmread_error() would be triggered here as
> reported by syzbot.

You're right, I wanted to avoid unnecessary checking, but this caught me.

Will fix it with a v8A patch.

