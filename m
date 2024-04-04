Return-Path: <kvm+bounces-13520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83E9E89833F
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 10:36:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B18B01C26D3A
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 08:36:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C15B71730;
	Thu,  4 Apr 2024 08:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="ZJ98WAic"
X-Original-To: kvm@vger.kernel.org
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F1E1E86F;
	Thu,  4 Apr 2024 08:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712219758; cv=none; b=T0hjZCTpEsogmrte2NazkOXUtkEfb2L/x9BCcqBmThNAl4DERDqOcwA8jDf6NOp9XHCdIsOfHX1ejQKb9A5XoVT2f7V3EwyFcRdmPBi+m3MkbXnezmqcUhCJaSns4fDLS8bWwSmyp8MIbsRan0ZfVJyB2IkZF3S8Lsq3OfgBxC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712219758; c=relaxed/simple;
	bh=pW9lJVcByIr6coYIc9zEDDgHzk/MplgZr99q4AzfSIc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q4qb8UjwCSUrgsZsdorQppifHzyFlMjomeiL3aFwjJgc470RuVdIVL+12KefjmyT3lqTxyd/o+fNwGuzZj6kq8sumQAwLXRPaKD7+37L0WXX6dlz7cSffCqzjHJBIDFbZ0pv9SqY+DmUon2eg0ByvDWJ74jQqK4jn1KNMTiI1J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=ZJ98WAic; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:Reply-To:MIME-Version:Date:
	Message-ID:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
	Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	In-Reply-To:References; bh=XGHxVqk4pP10Jn+yNRakH5zgTP0QZEzijKIINGCO2kM=;
	t=1712219756; x=1712651756; b=ZJ98WAicu+XqWCQv2CJyv1smUti1qPzCU85iUh5WstpgnY6
	9QNTu1HcWcbgBiEbPBFXtOBVK2szMZfReqQc5Oy6nD3i18/Hj6tiCE3uL2XFTRL8CpxO44yDWuKbF
	m8Up9HY1x1muwojyGrZB1Ii31pQvq3hyUkevBXs7ggUqz9Bl7L6j4Fyb7MLYO7EJbGRXiFBDvSAsq
	/9JRt4iR+ZODo7lYRaHAb/ZkZGsN7VRVQDfu6jb43J2OKr6anDbRo0hA4T94rjc0QhycJKvtSAdOv
	jxrXKxLFZbCCpO/y/x8yURJWDEeyjE8V81W+OtQHwifLRtTE5iNddBOVS+oYt4sQ==;
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1rsIZd-0002eV-40; Thu, 04 Apr 2024 10:35:53 +0200
Message-ID: <a4f022e8-1f84-4bbb-b00d-00f1eba1f877@leemhuis.info>
Date: Thu, 4 Apr 2024 10:35:52 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
Subject: Re: [PATCH] KVM: PPC: Book3S HV nestedv2: Cancel pending HDEC
 exception
To: Nicholas Piggin <npiggin@gmail.com>, Vaibhav Jain
 <vaibhav@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 kvm-ppc@vger.kernel.org
Cc: Michael Ellerman <mpe@ellerman.id.au>, Jordan Niethe
 <jniethe5@gmail.com>, Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
 mikey@neuling.org, paulus@ozlabs.org, sbhat@linux.ibm.com,
 gautam@linux.ibm.com, kconsul@linux.vnet.ibm.com,
 amachhiw@linux.vnet.ibm.com, David.Laight@ACULAB.COM,
 Linux kernel regressions list <regressions@lists.linux.dev>
References: <20240313072625.76804-1-vaibhav@linux.ibm.com>
 <CZYME80BW9P7.3SC4GLHWCDQ9K@wheely>
From: "Linux regression tracking (Thorsten Leemhuis)"
 <regressions@leemhuis.info>
Content-Language: en-US, de-DE
In-Reply-To: <CZYME80BW9P7.3SC4GLHWCDQ9K@wheely>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1712219756;98cda012;
X-HE-SMSGID: 1rsIZd-0002eV-40

Hi, Thorsten here, the Linux kernel's regression tracker. Top-posting
for once, to make this easily accessible to everyone.

Was this regression ever resolved? Doesn't look like it, but maybe I
just missed something.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.

#regzbot poke

On 20.03.24 14:43, Nicholas Piggin wrote:
> On Wed Mar 13, 2024 at 5:26 PM AEST, Vaibhav Jain wrote:
>> This reverts commit 180c6b072bf360b686e53d893d8dcf7dbbaec6bb ("KVM: PPC:
>> Book3S HV nestedv2: Do not cancel pending decrementer exception") which
>> prevented cancelling a pending HDEC exception for nestedv2 KVM guests. It
>> was done to avoid overhead of a H_GUEST_GET_STATE hcall to read the 'HDEC
>> expiry TB' register which was higher compared to handling extra decrementer
>> exceptions.
>>
>> This overhead of reading 'HDEC expiry TB' register has been mitigated
>> recently by the L0 hypervisor(PowerVM) by putting the value of this
>> register in L2 guest-state output buffer on trap to L1. From there the
>> value of this register is cached, made available in kvmhv_run_single_vcpu()
>> to compare it against host(L1) timebase and cancel the pending hypervisor
>> decrementer exception if needed.
> 
> Ah, I figured out the problem here. Guest entry never clears the
> queued dec, because it's level triggered on the DEC MSB so it
> doesn't go away when it's delivered. So upstream code is indeed
> buggy and I think I take the blame for suggesting this nestedv2
> workaround.
> 
> I actually don't think that is necessary though, we could treat it
> like other interrupts.  I think that would solve the problem without
> having to test dec here.
> 
> I am wondering though, what workload slows down that this patch
> was needed in the first place. We'd only get here after a cede
> returns, then we'd dequeue the dec and stop having to GET_STATE
> it here.
> 
> Thanks,
> Nick
> 
>>
>> Fixes: 180c6b072bf3 ("KVM: PPC: Book3S HV nestedv2: Do not cancel pending decrementer exception")
>> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
>> ---
>>  arch/powerpc/kvm/book3s_hv.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
>> index 0b921704da45..e47b954ce266 100644
>> --- a/arch/powerpc/kvm/book3s_hv.c
>> +++ b/arch/powerpc/kvm/book3s_hv.c
>> @@ -4856,7 +4856,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
>>  	 * entering a nested guest in which case the decrementer is now owned
>>  	 * by L2 and the L1 decrementer is provided in hdec_expires
>>  	 */
>> -	if (!kvmhv_is_nestedv2() && kvmppc_core_pending_dec(vcpu) &&
>> +	if (kvmppc_core_pending_dec(vcpu) &&
>>  			((tb < kvmppc_dec_expires_host_tb(vcpu)) ||
>>  			 (trap == BOOK3S_INTERRUPT_SYSCALL &&
>>  			  kvmppc_get_gpr(vcpu, 3) == H_ENTER_NESTED)))
> 

