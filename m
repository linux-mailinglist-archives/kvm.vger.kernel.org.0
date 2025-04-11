Return-Path: <kvm+bounces-43179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9363DA867A6
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 22:52:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BE964A09A4
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 20:52:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D8E5293B4D;
	Fri, 11 Apr 2025 20:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="MaUaGM8p"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB7B2857E3;
	Fri, 11 Apr 2025 20:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744404734; cv=none; b=gKIivrK99KlmnuQqS6T9y6B+g0NRg4zCi2N+H2Rvi5U2xoz1JmBYrkSwfydllclTPngXazdwuLLu/hXvIp9QAt8z3U1IEmsn3+A6tda56xaBD9Y7flznimh0ztDsnFxv5i1O2RyxrDELbTRIOmNK6rc/wmeaLySwgADS05VnKEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744404734; c=relaxed/simple;
	bh=kxTCj2K40xus1IkV+DNiWTNVByJ6Z3Ovx9rtSTGdTRk=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=ozyC7CivqUL25/ybZe33nFUC8jejRF3xi5PVIuPIu22b8qheLCU87KN3l6O9Mer1VbeaEVyNSbfVz3M9ELXf+OitH9J/3uyn/qgrdpRvUszinTBOkhkb5iPz/0BNntfuxoLOnwLWKLy91R78nhMFspvgW3bKYSAj9K6Hr092rYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=MaUaGM8p; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [127.0.0.1] ([76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53BKokUU689207
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 11 Apr 2025 13:50:46 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53BKokUU689207
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025032001; t=1744404648;
	bh=RSxA6WjXfzTzp9cSLSXzWSj0aQbPDgdMx3rGgv5vZFo=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=MaUaGM8ptiyNi5JNPWt6NXDw8PAuW9ldRndGnP2Ms2a5WhDxGDZmG9wZSREChComZ
	 5WZ/ACqI8QPIApW2H+3S60a8ZuhEXXT3/4CoGujji3jvmFlwVOFHC9tj+gJU0zYj76
	 fLPUlJt1NAlnsIICrT1IBvg8ssoIvqY4BrCd0zWR2qJWd/gvqDxfJWqsioW+lcez2s
	 0OjBs72/2ECaksg5m8Zdd+dsabWYMF97MvLqFSlWKKuRnrqMJtIZxV9Y2X0uNN/Twt
	 qct8mM81m1xNoj3uyJYNXFGbNRMRc88O5YTcpLTHLdVRgYOnAL34JelLSSB8abrZsj
	 FVc2EtkpGepIg==
Date: Fri, 11 Apr 2025 13:50:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Xin Li <xin@zytor.com>, Sean Christopherson <seanjc@google.com>
CC: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
        linux-edac@vger.kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org, bpf@vger.kernel.org, llvm@lists.linux.dev,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, jgross@suse.com,
        andrew.cooper3@citrix.com, peterz@infradead.org, acme@kernel.org,
        namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, luto@kernel.org,
        boris.ostrovsky@oracle.com, kys@microsoft.com, haiyangz@microsoft.com,
        decui@microsoft.com
Subject: =?US-ASCII?Q?Re=3A_=5BRFC_PATCH_v1_10/15=5D_KVM=3A_VMX=3A_Use_WR?=
 =?US-ASCII?Q?MSRNS_or_its_immediate_form_when_available?=
User-Agent: K-9 Mail for Android
In-Reply-To: <41eb2d08-1b2d-4ca8-bcb7-f5f4611f91a9@zytor.com>
References: <20250331082251.3171276-1-xin@zytor.com> <20250331082251.3171276-11-xin@zytor.com> <Z_hTI8ywa3rTxFaz@google.com> <41eb2d08-1b2d-4ca8-bcb7-f5f4611f91a9@zytor.com>
Message-ID: <39ECA4CA-9CBC-4F72-B52E-9BD06DBF9B6D@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On April 11, 2025 9:18:08 AM PDT, Xin Li <xin@zytor=2Ecom> wrote:
>On 4/10/2025 4:24 PM, Sean Christopherson wrote:
>>> +/*
>>> + * Write EAX to MSR_IA32_SPEC_CTRL=2E
>>> + *
>>> + * Choose the best WRMSR instruction based on availability=2E
>>> + *
>>> + * Replace with 'wrmsrns' and 'wrmsrns %rax, $MSR_IA32_SPEC_CTRL' onc=
e binutils support them=2E
>>> + */
>>> +=2Emacro WRITE_EAX_TO_MSR_IA32_SPEC_CTRL
>>> +	ALTERNATIVE_2 __stringify(mov $MSR_IA32_SPEC_CTRL, %ecx;		\
>>> +				  xor %edx, %edx;				\
>>> +				  mov %edi, %eax;				\
>>> +				  ds wrmsr),					\
>>> +		      __stringify(mov $MSR_IA32_SPEC_CTRL, %ecx;		\
>>> +				  xor %edx, %edx;				\
>>> +				  mov %edi, %eax;				\
>>> +				  ASM_WRMSRNS),					\
>>> +		      X86_FEATURE_WRMSRNS,					\
>>> +		      __stringify(xor %_ASM_AX, %_ASM_AX;			\
>>> +				  mov %edi, %eax;				\
>>> +				  ASM_WRMSRNS_RAX; =2Elong MSR_IA32_SPEC_CTRL),	\
>>> +		      X86_FEATURE_MSR_IMM
>>> +=2Eendm
>> This is quite hideous=2E  I have no objection to optimizing __vmx_vcpu_=
run(), but
>> I would much prefer that a macro like this live in generic code, and th=
at it be
>> generic=2E  It should be easy enough to provide an assembly friendly eq=
uivalent to
>> __native_wrmsr_constant()=2E
>
>Will do=2E

This should be coming anyway, right?

