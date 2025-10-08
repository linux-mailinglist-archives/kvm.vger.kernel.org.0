Return-Path: <kvm+bounces-59633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C57CBBC48B2
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 13:25:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F206D4E70FB
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 11:25:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61CFB2F6180;
	Wed,  8 Oct 2025 11:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uMDpyVQg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F99B21767A;
	Wed,  8 Oct 2025 11:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759922726; cv=none; b=JwKzcOtVZhqUkr+E7WydPPDvfHlyTjKUh+y2oGyizz4sXRfLr++TSZnGxBlJ5re000fOm7bvNPJJ28KjQZSUnqGtcDGrEQ51BJo+0lold/uMUUOFK8f5pwjXEzWQHzywkwX+RInqch1kSfU7W+h/BXQ4y0Zr5PEcK9zc/Kk9rp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759922726; c=relaxed/simple;
	bh=poIF2riGhaBofeLwn1VhQxAG78OMsPq+FubQHTiVldo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Im67U3S9kTCzIpWRfiyC4Y4kvkzKyKt235h4LTj5WpTPB776yl7ZCa7k6b7p9rnnibsuApgeYCH08cLNATzRCuVhdTUauabfHB1nt6HoYp8TgkyBtggpcGkP11qVQpLD1CbBZP5vLVkl7PpMQY3SE1FK+/kgY232/+bABwvGsLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uMDpyVQg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37BA7C4CEF4;
	Wed,  8 Oct 2025 11:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759922725;
	bh=poIF2riGhaBofeLwn1VhQxAG78OMsPq+FubQHTiVldo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uMDpyVQgFUxUhdE8yUURy6O4BujHRp25+ugs+N9smsfrQryBGWqPlkOLnpkoBHTdi
	 vPVSlxg7UvabIJLGOsKap8KU+0Ih5lpcpwe3sOZyGt0AEM/FRKOcEk97f8eLZmjIlB
	 MC5mbUGJ4/Zb6mfjE4G0TFBueOuVC1gAzfAmy0OK95m+5klmyqsMvq/eq0nBaq4+OM
	 j6D02pr9mvHP76mamVIsho1sbJDdjaP8pWVFtCAA3ToHHPUWUKBo3iQWy3ef4aBmhf
	 fQXZCz7178IEngM3ykV/u/Nsa0mrq+MafEvjoJH2/6GXAFATZ7fc0gls6cLQv6ge1U
	 iqcvNS4FqlZdg==
Date: Wed, 8 Oct 2025 12:28:42 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Manali Shukla <manali.shukla@amd.com>
Cc: kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-doc@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com, nikunj@amd.com, 
	bp@alien8.de, peterz@infradead.org, mingo@redhat.com, mizhang@google.com, 
	thomas.lendacky@amd.com, ravi.bangoria@amd.com, Sandipan.Das@amd.com
Subject: Re: [PATCH v2 04/12] x86/cpufeatures: Add CPUID feature bit for
 Extended LVT
Message-ID: <gugvbbcl3q6qu3dabwyl75nsf7tvy4tbsa34s4on2q5jclz3fd@4my3uhrovbtv>
References: <20250901051656.209083-1-manali.shukla@amd.com>
 <20250901052212.209171-1-manali.shukla@amd.com>
 <kgavy7x2hweqc5fbg65fwxv7twmaiyt3l5brluqhxt57rjfvmq@aixr2qd436a2>
 <1acb5a6d-377b-4f0a-8a70-0dddaefa149c@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1acb5a6d-377b-4f0a-8a70-0dddaefa149c@amd.com>

On Wed, Sep 17, 2025 at 09:04:57PM +0530, Manali Shukla wrote:
> Hi Naveen,
> 
> Thank you for reviewing my patches.
> 
> On 9/8/2025 7:09 PM, Naveen N Rao wrote:
> > On Mon, Sep 01, 2025 at 10:52:12AM +0530, Manali Shukla wrote:
> >> From: Santosh Shukla <santosh.shukla@amd.com>
> >>
> >> Local interrupts can be extended to include more LVT registers in
> >> order to allow additional interrupt sources, like Instruction Based
> >> Sampling (IBS).
> >>
> >> The Extended APIC feature register indicates the number of extended
> >> Local Vector Table(LVT) registers in the local APIC.  Currently, there
> >> are 4 extended LVT registers available which are located at APIC
> >> offsets (400h-530h).
> >>
> >> The EXTLVT feature bit changes the behavior associated with reading
> >> and writing an extended LVT register when AVIC is enabled. When the
> >> EXTLVT and AVIC are enabled, a write to an extended LVT register
> >> changes from a fault style #VMEXIT to a trap style #VMEXIT and a read
> >> of an extended LVT register no longer triggers a #VMEXIT [2].
> >>
> >> Presence of the EXTLVT feature is indicated via CPUID function
> >> 0x8000000A_EDX[27].
> >>
> >> More details about the EXTLVT feature can be found at [1].
> >>
> >> [1]: AMD Programmer's Manual Volume 2,
> >> Section 16.4.5 Extended Interrupts.
> >> https://bugzilla.kernel.org/attachment.cgi?id=306250
> >>
> >> [2]: AMD Programmer's Manual Volume 2,
> >> Table 15-22. Guest vAPIC Register Access Behavior.
> >> https://bugzilla.kernel.org/attachment.cgi?id=306250
> >>
> >> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> >> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
> >> ---
> >>  arch/x86/include/asm/cpufeatures.h | 1 +
> >>  1 file changed, 1 insertion(+)
> >>
> >> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> >> index 286d509f9363..0dd44cbf7196 100644
> >> --- a/arch/x86/include/asm/cpufeatures.h
> >> +++ b/arch/x86/include/asm/cpufeatures.h
> >> @@ -378,6 +378,7 @@
> >>  #define X86_FEATURE_X2AVIC		(15*32+18) /* "x2avic" Virtual x2apic */
> >>  #define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* "v_spec_ctrl" Virtual SPEC_CTRL */
> >>  #define X86_FEATURE_VNMI		(15*32+25) /* "vnmi" Virtual NMI */
> >> +#define X86_FEATURE_EXTLVT		(15*32+27) /* Extended Local vector Table */
> > 
> > Per APM Vol 3, Appendix E.4.9 "Function 8000_000Ah", bit 27 is:
> > ExtLvtAvicAccessChgExtended: Interrupt Local Vector Table Register AVIC 
> > Access changes. See “Virtual APIC Register Accesses.”
> > 
> > And, APM Vol 2, 15.29.3.1 "Virtual APIC Register Accesses" says:
> > Extended Interrupt [3:0] Local Vector Table Registers:
> > 	CPUID Fn8000_000A_EDX[27]=1:
> > 		Read: Allowed
> > 		Write: #VMEXIT (trap)
> > 	CPUID Fn8000_000A_EDX[27]=0:
> > 		Read: #VMEXIT (fault)
> > 		Write: #VMEXIT(fault)
> > 
> > So, as far as I can tell, this feature is only used to determine how 
> > AVIC hardware handles accesses to the extended LVT entries. Does this 
> > matter for vIBS? In the absence of this feature, we should take a fault 
> > and KVM should be able to handle that.
> > 
> 
> Yes, but KVM still needs to emulate extended LVT registers to handle the
> fault when the guest IBS driver attempts to read/write extended LVT
> registers.
> 
> "KVM: x86: Add emulation support for Extented LVT registers"
> patch covers two aspects:
> 
> Extended LVT register emulation (EXTAPIC feature bit in
> CPUID 0x80000001:ECX[3])
> 
> ExtLvtAvicAccessChgExtended which changes the behavior of read/write
> access when AVIC is enabled.

Sure, it will be good if you can separate out the changes required for 
the latter, and perhaps move those at the beginning of this series.

- Naveen


