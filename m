Return-Path: <kvm+bounces-54926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1E79B2B413
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 00:27:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EFFF216FF5B
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 22:26:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB6282773CD;
	Mon, 18 Aug 2025 22:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="QbjTHmbo"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B235B17A2E3;
	Mon, 18 Aug 2025 22:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755555984; cv=none; b=fAALPantLEF9FzipQW714DWPcWRDzRNYE0tG7ww5gPzWkW7dacYOeyjjJU0Hl74G85kmQKlbgguwTtolAIT5rYNlLB1gU9kwdWxrqjRoZknU8zi2QldXCm0rCOVTdf93OQo5Nq8DUWhr9EwLL3CIzXCUtTwcniD55J94XSwFJdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755555984; c=relaxed/simple;
	bh=Xzho2zfC5Pt9Y+SyVdwgTy8fpFH6SmIykbzOF5a22qQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BUxyF20LU/r0T7/ynUxRP3UFMCGhTEUdk4t8a02zXzHdiY/8ZjVbn9t2PJeMsp0hgkGrwcfpW4kMcL51svkgk3XKmvAf/0zfXOBbIK1lioI/BuH9lLheBzYTx64EDMfTcWXqxtmzk09+coxVmEVOn0VoEByo7FVeAPX/FYDMOFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=QbjTHmbo; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57IMPN5b2211088
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 18 Aug 2025 15:25:23 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57IMPN5b2211088
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1755555924;
	bh=UKmAx3b8wSfwksopDk41sL+BkapNoeLCB5juJv9NLo0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QbjTHmbo0jcWLgKjY/sprmAgo8JI3/1MjWXhmM9Xqu3eIZ2diN1zzrCVL+XAAlHcM
	 s0STCJAbKA+7gV2NbueAneMp0o0GUfRu896ofZsX6efu0K8G/twJqWBPw8zMQyp1+g
	 75j5HLybgVREBfEyRfmFj2b1V0ePy1xunx17Ry/Km2Bed05ZFtVNrrnXJ2Kl9R4chX
	 hjcazbODp8l0/q54fF+5hlSmEO6m1eja60U3i6sKrGrln1uvoknvRpvT144IJN2NmO
	 Hj/EfEIe+dp3IOF+Zyrrn2utPdM404+s1mgCY2c86Le9JIlREIbncJCXMkFU1qpAn6
	 aTvxvvn59MhhA==
Message-ID: <8dba55b2-9ae8-4199-b93c-024795777032@zytor.com>
Date: Mon, 18 Aug 2025 15:25:21 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 00/24] Enable CET Virtualization
To: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: mlevitsk@redhat.com, rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson
 <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
References: <20250812025606.74625-1-chao.gao@intel.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <20250812025606.74625-1-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/11/2025 7:55 PM, Chao Gao wrote:
> The FPU support for CET virtualization has already been merged into 6.17-rc1.
> Building on that, this series introduces Intel CET virtualization support for
> KVM.
> 
> Changes in v12:
> 1. collect Tested-by tags from John and Mathias.
> 2. use less verbose names for KVM rdmsr/wrmsr emulation APIs in patch 1/2
>     (Sean/Xin)
> 3. refer to s_cet, ssp, and ssp_table in a consistent order in patch 22
>     (Xin)
> 
> Please note that I didn't include Mathias' patch, which makes CR4.CET
> guest-owned. I expect that patch to be posted separately.
> 
> ---
> Control-flow Enforcement Technology (CET) is a kind of CPU feature used
> to prevent Return/CALL/Jump-Oriented Programming (ROP/COP/JOP) attacks.
> It provides two sub-features(SHSTK,IBT) to defend against ROP/COP/JOP
> style control-flow subversion attacks.
> 
> Shadow Stack (SHSTK):
>    A shadow stack is a second stack used exclusively for control transfer
>    operations. The shadow stack is separate from the data/normal stack and
>    can be enabled individually in user and kernel mode. When shadow stack
>    is enabled, CALL pushes the return address on both the data and shadow
>    stack. RET pops the return address from both stacks and compares them.
>    If the return addresses from the two stacks do not match, the processor
>    generates a #CP.
> 
> Indirect Branch Tracking (IBT):
>    IBT introduces new instruction(ENDBRANCH)to mark valid target addresses
>    of indirect branches (CALL, JMP etc...). If an indirect branch is
>    executed and the next instruction is _not_ an ENDBRANCH, the processor
>    generates a #CP. These instruction behaves as a NOP on platforms that
>    doesn't support CET.
> 
> CET states management
> =====================
> KVM cooperates with host kernel FPU framework to manage guest CET registers.
> With CET supervisor mode state support in this series, KVM can save/restore
> full guest CET xsave-managed states.
> 
> CET user mode and supervisor mode xstates, i.e., MSR_IA32_{U_CET,PL3_SSP}
> and MSR_IA32_PL{0,1,2}, depend on host FPU framework to swap guest and host
> xstates. On VM-Exit, guest CET xstates are saved to guest fpu area and host
> CET xstates are loaded from task/thread context before vCPU returns to
> userspace, vice-versa on VM-Entry. See details in kvm_{load,put}_guest_fpu().
> 
> CET supervisor mode states are grouped into two categories : XSAVE-managed
> and non-XSAVE-managed, the former includes MSR_IA32_PL{0,1,2}_SSP and are
> controlled by CET supervisor mode bit(S_CET bit) in XSS, the later consists
> of MSR_IA32_S_CET and MSR_IA32_INTR_SSP_TBL.
> 
> VMX introduces new VMCS fields, {GUEST|HOST}_{S_CET,SSP,INTR_SSP_TABL}, to
> facilitate guest/host non-XSAVES-managed states. When VMX CET entry/exit load
> bits are set, guest/host MSR_IA32_{S_CET,INTR_SSP_TBL,SSP} are loaded from
> equivalent fields at VM-Exit/Entry. With these new fields, such supervisor
> states require no addtional KVM save/reload actions.
> 
> Tests
> ======
> This series has successfully passed the basic CET user shadow stack test
> and kernel IBT test in both L1 and L2 guests. The newly added
> KVM-unit-tests [2] also passed, and its v11 has been tested with the AMD
> CET series by John [3].
> 
> For your convenience, you can use my WIP QEMU [1] for testing.
> 
> [1]: https://github.com/gaochaointel/qemu-dev qemu-cet
> [2]: https://lore.kernel.org/kvm/20250626073459.12990-1-minipli@grsecurity.net/
> [3]: https://lore.kernel.org/kvm/aH6CH+x5mCDrvtoz@AUSJOHALLEN.amd.com/
> 

I rebased the KVM FRED patch set on top of this KVM CET patch set, and
will send out soon.



