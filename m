Return-Path: <kvm+bounces-70831-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UDCMDLdMjGmukgAAu9opvQ
	(envelope-from <kvm+bounces-70831-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 10:32:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 91061122C31
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 10:32:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DE3873042B68
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 09:31:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C48FF3559E8;
	Wed, 11 Feb 2026 09:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="K1SGs/F5"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CD121ADA4;
	Wed, 11 Feb 2026 09:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770802315; cv=none; b=dWcoSNyeVkpTvJQ1xvW3AgNV/6H5mvDl81C2IeZVJN6VmLAO4Qv6IsjUKD39JItfBawRKJR5rn99iiuFbOY3tLx3W6OAOcGy2OAAzXA8X0jdYErQJG48UbmqDF6yjzcriQpLJOuCPXQnfv7PfXoO1zExHdEefDXRstdXKBELGiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770802315; c=relaxed/simple;
	bh=YKztGQYHHgMoyymLi5rcFx8rm5vupgBgQHLQaf66Epc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KVo8YSnVih8EQ4eeS00X8a2NkJYQfJZDjtot0HCLRw6dNpREQ8xWnWJpjVExkBYhyJNa3Beg0OFJ+dW7isAh6rSCrl6vTmXI4W219MLogh6Ize+FEROlf2GayhiI6u5Lmqq3T4VxP+NiYfw1D0I1OoFREKzKZCGJKryHgt/PuWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=K1SGs/F5; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=stZNSwbzwsYm4L8Ah3PrZDxSt1sHe98tFd48xTgRgbQ=;
	b=K1SGs/F52hSroMsRHwJUJIXJMtPjRGJSKKj/uGRXfhc4fE+7W8sPjPV0ozE0p3
	1K6swzDKKZWe5VtFp3yK4HX3dbz0Jegall0v6pihT6YmdBE/I66rM25ZkYg2kRZT
	Ccw7r88FuilS9+XfKWqISOFdGfCJMPxtR6JB10s/k+Co0=
Received: from [10.0.2.15] (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wDX_wptTIxpF4rwKg--.11732S2;
	Wed, 11 Feb 2026 17:31:25 +0800 (CST)
Message-ID: <3088af31-7ef8-45f3-9e0c-c51274ab9ca0@163.com>
Date: Wed, 11 Feb 2026 17:24:52 +0800
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
 <65765e72-fce0-48ed-ab95-af2736a562cd@163.com> <aYuO673vMcZ-DJ7m@google.com>
From: Zhiquan Li <zhiquan_li@163.com>
Content-Language: en-US
In-Reply-To: <aYuO673vMcZ-DJ7m@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDX_wptTIxpF4rwKg--.11732S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7KFyfWFyDGryruF47Jw13Arb_yoW8Gr43pa
	1xt3WFkFZ7Ka48t3WxZa40qr4fuF1kCw18Kryktry7A3W5Jr97Ar4xKFWjya95urZYgw45
	Z3WIgws8C3W5AFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUSApUUUUUU=
X-CM-SenderInfo: 52kl13xdqbzxi6rwjhhfrp/xtbCwQ2rlGmMTG0DigAA3+
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[163.com,none];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70831-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,kernel.org,vger.kernel.org,163.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[163.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zhiquan_li@163.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[163.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6]
X-Rspamd-Queue-Id: 91061122C31
X-Rspamd-Action: no action


On 2/11/26 04:02, Sean Christopherson wrote:
> Gah, I think I tested -rdpid and -rdtscp in a VM on Intel, but not AMD.  I think
> the fix is just this:
> 
> diff --git a/tools/testing/selftests/kvm/x86/msrs_test.c b/tools/testing/
> selftests/kvm/x86/msrs_test.c
> index 40d918aedce6..ebd900e713c1 100644
> --- a/tools/testing/selftests/kvm/x86/msrs_test.c
> +++ b/tools/testing/selftests/kvm/x86/msrs_test.c
> @@ -175,7 +175,7 @@ void guest_test_reserved_val(const struct kvm_msr *msr)
>          * If the CPU will truncate the written value (e.g. SYSENTER on AMD),
>          * expect success and a truncated value, not #GP.
>          */
> - if (!this_cpu_has(msr->feature) ||
> + if ((!this_cpu_has(msr->feature) && !this_cpu_has(msr->feature2)) ||
>             msr->rsvd_val == fixup_rdmsr_val(msr->index, msr->rsvd_val)) {
>                 u8 vec = wrmsr_safe(msr->index, msr->rsvd_val);

Perfect!  You found the root cause and fixed it.
I’ve verified the fix on Hygon platform, I will test it on Intel and AMD
platforms as well to make sure there is no regression.
I’m going to include the you fix in the V2 series.  Since my modifications are
totally miss the point, I will remove my SoB and only add my “Reported-by:” tag,
I suppose the SoB position would be wait for you, Sean :-)

Great many thanks for your help for the whole series!!

Best Regards,
Zhiquan


