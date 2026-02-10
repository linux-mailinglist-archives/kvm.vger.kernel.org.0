Return-Path: <kvm+bounces-70721-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OMv3MSwGi2kdPQAAu9opvQ
	(envelope-from <kvm+bounces-70721-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 11:19:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 451F61198ED
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 11:19:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9BB70303933D
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 10:19:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 464543542F9;
	Tue, 10 Feb 2026 10:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="FbFgozVJ"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A612353EEC;
	Tue, 10 Feb 2026 10:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770718741; cv=none; b=RbmJV0dGd2jUutOIoubvHQwutpB0fsA5KBWpz65Kphq20XBokhpauNb3CJckq6KuWocBFMeXOK60SGG/UJmuBDjuOU2v4aIIRTpe3P4AOB/m46LLcUwxXsp5vwkPAyvQEzql9a4079FPf8XQ46d6tcMn+UaJ0qoKqoTNcy+4iGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770718741; c=relaxed/simple;
	bh=ywOA7zfE8Lv1fr6bNxhYOryZUqsQjNbr9v7UavuNwqc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U1S0pDLCWLggaJ/mr64W4wzq4chnzUI9jS094TsaAYpitLks6Orr5b5exK/yX+OV4s3khC9y54vzh7iILU+QoVVBHjSJF1IjM5NzKLoBXT4crWA3X6/8ez9RTSHFDb2mR0VHsNQWSVi2nnKF29z5K63qiTBFaXEe2VabjTJCi1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=FbFgozVJ; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=rHqlACyURYj6T5Yu3zzvypDlt2cz/l/7e88EGWJQZ/Q=;
	b=FbFgozVJLBNNKdrDcvdJPTaNf3oCudxYrkuZd2jO4LELBuDPbjPe+0LrOnzJJ/
	XYEDlVu6MOiAt2uHxHKl34ZuqGtMd/noFIK2auX0I/adehTxezYkghbemXdFr6uF
	9X/ZLt12bJmlismMjYQlcj193pPvkeeBoFBZLUrYV3NLs=
Received: from [10.0.2.15] (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wD3nzjvBYtp8wTAKw--.39588S2;
	Tue, 10 Feb 2026 18:18:24 +0800 (CST)
Message-ID: <65765e72-fce0-48ed-ab95-af2736a562cd@163.com>
Date: Tue, 10 Feb 2026 18:17:48 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND 5/5] KVM: x86: selftests: Fix write MSR_TSC_AUX
 reserved bits test failure on Hygon
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiquan_li@163.com
References: <20260209041305.64906-1-zhiquan_li@163.com>
 <20260209041305.64906-6-zhiquan_li@163.com> <aYoOHzwgxvpZ5Iso@google.com>
From: Zhiquan Li <zhiquan_li@163.com>
Content-Language: en-US
In-Reply-To: <aYoOHzwgxvpZ5Iso@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3nzjvBYtp8wTAKw--.39588S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZF4UJFy5GFW3uFWkCw1kGrg_yoWrXr1fpa
	yxGa1YgFZrGFnaqa97WF1kJF1rZrnrKr1jgr9aqry7Xwn8Jryavr1fKayY9a48ZrWSvrWY
	vF42gr13CF4DAa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JU5KINUUUUU=
X-CM-SenderInfo: 52kl13xdqbzxi6rwjhhfrp/xtbC6hC6o2mLBfB4yAAA3E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[163.com,none];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_FROM(0.00)[163.com];
	TAGGED_FROM(0.00)[bounces-70721-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[163.com:+];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zhiquan_li@163.com,kvm@vger.kernel.org];
	FREEMAIL_CC(0.00)[redhat.com,kernel.org,vger.kernel.org,163.com];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 451F61198ED
X-Rspamd-Action: no action


On 2/10/26 00:41, Sean Christopherson wrote:
> On Mon, Feb 09, 2026, Zhiquan Li wrote:
>> Therefore, the expectation of writing MSR_TSC_AUX reserved bits on Hygon
>> CPUs should be:
>> 1) either RDTSCP or RDPID is supported case, and both are supported
>>    case, expect success and a truncated value, not #GP.
>> 2) neither RDTSCP nor RDPID is supported, expect #GP.
> 
> That's how Intel and AMD behave as well.  I don't understand why there needs to
> be a big pile of special case code for Hygon.  Presumably just fixup_rdmsr_val()
> needs to be changed?
> 

Currently the conditions cannot cover the case that the host *only* supports
RDTSCP but not support RDPID, like Hygon CPU.  Let me give more details for this
test failure.

When testing the case MSR_TEST2(MSR_TSC_AUX, 0x12345678, u64_val, RDPID,
RDTSCP), the cupid bit for RDPID (as feature) of vCPU 0 and vCPU1 will be
removed because host is not supported it, but please note RDTSCP (as feature2)
is supported.  Therefore, the preceding condition “!this_cpu_has(msr->feature)”
here is true and then the test run into the first branch.  Because the feature2
RDTSCP is supported, writing reserved bits (that is, guest_test_reserved_val())
will succeed, unfortunately, the expectation for the first branch is #GP.

The check to fixup_rdmsr_val() is too late, since the preceding condition
already leads to the test run into the wrong branch.

The test can be passed on AMD CPU is because RDPID is usually supported by host,
the cupid bit for RDPID of vCPU 0 and vCPU1 can be kept, then fixup_rdmsr_val()
can drive it to the second branch.  Theoretically, the failure also can be
reproduced on some old AMD CPUs which only support RDTSCP, it’s hard to find
such an old machine to confirm it, but I suppose this case can be covered by
slight changes based on this patch.

Intel CPU no such failure, because writing MSR_TSC_AUX reserved bits results in
#GP is expected behavior.


>>  tools/testing/selftests/kvm/x86/msrs_test.c | 26 +++++++++++++++++----
>>  1 file changed, 21 insertions(+), 5 deletions(-)
>>
>> diff --git a/tools/testing/selftests/kvm/x86/msrs_test.c b/tools/testing/selftests/kvm/x86/msrs_test.c
>> index 40d918aedce6..2f1e800fe691 100644
>> --- a/tools/testing/selftests/kvm/x86/msrs_test.c
>> +++ b/tools/testing/selftests/kvm/x86/msrs_test.c
>> @@ -94,6 +94,17 @@ static u64 fixup_rdmsr_val(u32 msr, u64 want)
>>  	}
>>  }
>>  
>> +/*
>> + * On Hygon processors either RDTSCP or RDPID is supported in the host,
>> + * MSR_TSC_AUX is able to be accessed.
>> + */
>> +static bool is_hygon_msr_tsc_aux_supported(const struct kvm_msr *msr)
>> +{
>> +	return host_cpu_is_hygon &&
>> +			msr->index == MSR_TSC_AUX &&
>> +			(this_cpu_has(msr->feature) || this_cpu_has(msr->feature2));
> 
> Align indentation, but as above, this shouldn't be necessary.
> 

OK, let me fix it if this chunk still needed.

Best Regards,
Zhiquan

>> +}
>> +
>>  static void __rdmsr(u32 msr, u64 want)
>>  {
>>  	u64 val;
>> @@ -174,9 +185,14 @@ void guest_test_reserved_val(const struct kvm_msr *msr)
>>  	/*
>>  	 * If the CPU will truncate the written value (e.g. SYSENTER on AMD),
>>  	 * expect success and a truncated value, not #GP.
>> +	 *
>> +	 * On Hygon CPUs whether or not RDPID is supported in the host, once RDTSCP
>> +	 * is supported, MSR_TSC_AUX is able to be accessed.  So, for either RDTSCP
>> +	 * or RDPID is supported case and both are supported case, expect
>> +	 * success and a truncated value, not #GP.
>>  	 */
>> -	if (!this_cpu_has(msr->feature) ||
>> -	    msr->rsvd_val == fixup_rdmsr_val(msr->index, msr->rsvd_val)) {
>> +	if (!is_hygon_msr_tsc_aux_supported(msr) && (!this_cpu_has(msr->feature) ||
>> +	    msr->rsvd_val == fixup_rdmsr_val(msr->index, msr->rsvd_val))) {
>>  		u8 vec = wrmsr_safe(msr->index, msr->rsvd_val);
>>  
>>  		__GUEST_ASSERT(vec == GP_VECTOR,
>> -- 
>> 2.43.0
>>


