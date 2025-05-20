Return-Path: <kvm+bounces-47135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83753ABDC4B
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 16:22:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 474178A42E6
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 14:17:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA789253340;
	Tue, 20 May 2025 14:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PkkqAnuQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B9D24C06A;
	Tue, 20 May 2025 14:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750387; cv=none; b=WsllXNG31V7tO+x84UU7CiAm9VbgNVxhpIn9ApwYrELqeflN8aZFOi6MFbqm3FpjHrep1EZu+7mxDRYaeiyaAq81baHoFwsnzQFP5N0EuGT1NOwP+xZQ+GCJGSurHxI0H0bDoFBeyy6rvLt3USugZ95EQni/4yl0jzl7evP6ZV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750387; c=relaxed/simple;
	bh=9n8dw9eb+20GuWmjSS7Yp145AHRnH4TAd5VgGo22PGg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L1rv5yKCzzqU/Qo5SrDlJG7d/Ms+FkThg9zylzl3VTfOuK4bGFHKKBghtO6/AMyeyF7AjgxjVQ0vBLF5kfergsk7AzEq4MtO+VT1daO8VrAp2xaMGQWLSpQwcqzuO8Ma5MH17mqbCqV+s9A43fbYd8aKI4WHd+MgiS+DxFFiAw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PkkqAnuQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E96EC4CEE9;
	Tue, 20 May 2025 14:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747750386;
	bh=9n8dw9eb+20GuWmjSS7Yp145AHRnH4TAd5VgGo22PGg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PkkqAnuQDZemhPobQcEFfl1TI/R06HqSZtcwwVMGtCBfVh4bZBi8TTq744KJEOOHO
	 Axh3uE+27/VbanrjgsCg22XTKjfLJS7V6gR8GISr5HXOzo7ocKhXHKMnvYlyH26OJz
	 gphpiW9R9RVxguFCf3zKXLGGcUPLio9Lq76oSnt9fxwong4+ANeheuGKdeIXbaWKJb
	 qS/S6mQl/8kHEjym0qt4t0dnC4TPtfIuf34GKuFz1dqzO6KrWbnQMuaYG6MPMWy3c4
	 0QnGaAAJrXv8ThzHt3GoKMePT1LEhl7f/ozeS38X7ECJv/6nT+Yto08Jg70ghPrClO
	 4E00B8DEaEdUw==
Date: Tue, 20 May 2025 10:13:04 -0400
From: Sasha Levin <sashal@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Borislav Petkov <bp@alien8.de>, tglx@linutronix.de,
	peterz@infradead.org, jpoimboe@kernel.org, corbet@lwn.net,
	mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
	pbonzini@redhat.com, thomas.lendacky@amd.com,
	mario.limonciello@amd.com, perry.yuan@amd.com, kai.huang@intel.com,
	xiaoyao.li@intel.com, tony.luck@intel.com, xin3.li@intel.com,
	kan.liang@linux.intel.com, linux-doc@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.14 317/642] x86/bugs: KVM: Add support for
 SRSO_MSR_FIX
Message-ID: <aCyN8IoJXk5G3eR6@lappy>
References: <20250505221419.2672473-1-sashal@kernel.org>
 <20250505221419.2672473-317-sashal@kernel.org>
 <aBk9nVsmHObvxU7o@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aBk9nVsmHObvxU7o@google.com>

On Mon, May 05, 2025 at 03:37:17PM -0700, Sean Christopherson wrote:
>On Mon, May 05, 2025, Sasha Levin wrote:
>> From: Borislav Petkov <bp@alien8.de>
>>
>> [ Upstream commit 8442df2b49ed9bcd67833ad4f091d15ac91efd00 ]
>>
>> Add support for
>>
>>   CPUID Fn8000_0021_EAX[31] (SRSO_MSR_FIX). If this bit is 1, it
>>   indicates that software may use MSR BP_CFG[BpSpecReduce] to mitigate
>>   SRSO.
>>
>> Enable BpSpecReduce to mitigate SRSO across guest/host boundaries.
>>
>> Switch back to enabling the bit when virtualization is enabled and to
>> clear the bit when virtualization is disabled because using a MSR slot
>> would clear the bit when the guest is exited and any training the guest
>> has done, would potentially influence the host kernel when execution
>> enters the kernel and hasn't VMRUN the guest yet.
>>
>> More detail on the public thread in Link below.
>>
>> Co-developed-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
>> Link: https://lore.kernel.org/r/20241202120416.6054-1-bp@kernel.org
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>
>Can we please hold off on this until the fix lands[1]?  This version introduces
>a very measurable performance regression[2] for non-KVM use cases.

Sure, I'll drop it. Thanks!

-- 
Thanks,
Sasha

