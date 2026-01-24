Return-Path: <kvm+bounces-69051-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CNTQNK8rdWk1BgEAu9opvQ
	(envelope-from <kvm+bounces-69051-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 21:29:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4372E7EE5C
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 21:29:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6CA7D300E5D6
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 20:29:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7DF227EFF7;
	Sat, 24 Jan 2026 20:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thorondor.fr header.i=@thorondor.fr header.b="krnLB6St"
X-Original-To: kvm@vger.kernel.org
Received: from mail.thorondor.fr (unknown [82.66.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9AD25A33F;
	Sat, 24 Jan 2026 20:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.66.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769286560; cv=none; b=qNX4ON550ubWUnGxirnG4M5zg+I1YtWrrreCBQlnkB1oIbUBzRD93Sjh+q/EAzykFISQ0VF4DbYBrh0CYluFAZKAEHOMzIlG7yckNNhGsibbFTTugJmmANcLaoHbw/JoCAahxh4gv2kA1XRw6HZJsEmUMbHxTz69n6cQOF4mGGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769286560; c=relaxed/simple;
	bh=fO0+NnEJmu+E1+vcYlmyfbaGDgFd6gfUPbrhtcCpp2U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HZXHF31QkPaU+7h5C2s4CouTg0Hn/s0b8zpy87901yBz0sw1CVnYlcxdDUBbamnRGk61SuJzpSVoRsxv+10vWzf2ZOusVv5Ciy9kOWCYkVYWqhEtnXtXc+xMoaWhJCu/o4T6GlW8cqGMYsBvLpoHWRWvXOe9AxZGnvWGhbZlGfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=thorondor.fr; spf=pass smtp.mailfrom=thorondor.fr; dkim=pass (2048-bit key) header.d=thorondor.fr header.i=@thorondor.fr header.b=krnLB6St; arc=none smtp.client-ip=82.66.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=thorondor.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thorondor.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=thorondor.fr; s=mail;
	t=1769286555; bh=fO0+NnEJmu+E1+vcYlmyfbaGDgFd6gfUPbrhtcCpp2U=;
	h=Subject:To:Cc:References:From:In-Reply-To;
	b=krnLB6St7FYfv/Lu7V/+VugPRt1XTMmQlHNnTlnD1ioQOVnNET8n6f436gqEoQxVQ
	 l7l+r6+kopjNNJpP6C5W+qJ3ujjOQqnj/NVSfLfmlSmqWElZEJG1dJ2fYhm6+f4qNz
	 7hv1pd/kqnqb0A9IkUWVHYDbUVDz+AmU+m+l0hBR4Fe9EG5nQhbzq0VzR4XrK4AROQ
	 lO87uy0tWN0I0Gi1cSlds3eXDFGR9MPjxrAg38t6ovMeXatuJ3EY7auG/lHGeSI125
	 fJRccdsAGzzNgDY/Us0MS6p+/OmJt+FENAYoaQga9wmzAY8ofd2cGoKxXCweF070/9
	 ucvaTRbEjzaiw==
Message-ID: <cccd63da-1ccd-47b3-9ca3-f65e86ce98bf@thorondor.fr>
Date: Sat, 24 Jan 2026 21:29:15 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3] KVM: SEV: Add KVM_SEV_SNP_HV_REPORT_REQ command
To: Tom Lendacky <thomas.lendacky@amd.com>,
 Thomas Courrege <thomas.courrege@thorondor.fr>, ashish.kalra@amd.com,
 corbet@lwn.net, herbert@gondor.apana.org.au, john.allen@amd.com,
 nikunj@amd.com, pbonzini@redhat.com, seanjc@google.com
Cc: kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org
References: <20251215141417.2821412-1-thomas.courrege@vates.tech>
 <254d7d53-b523-452d-8c6f-d611ab08a9ff@amd.com>
 <879f354c-822f-4902-8cc3-6cf9557db969@thorondor.fr>
 <2882b35a-89ac-4f91-abf3-a3b64e7770eb@amd.com>
Content-Language: en-US
From: xen <xen@thorondor.fr>
In-Reply-To: <2882b35a-89ac-4f91-abf3-a3b64e7770eb@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[thorondor.fr,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[thorondor.fr:s=mail];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69051-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xen@thorondor.fr,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[thorondor.fr:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4372E7EE5C
X-Rspamd-Action: no action


On 24-01-2026 17:27, Tom Lendacky wrote:
> On 1/24/26 08:40, Thomas Courrege wrote:
>> Sorry, i didn't saw the response, i changed the email i use.
>>
>> On 21-01-2026 00:45, Tom Lendacky wrote:
>>> On 12/15/25 08:14, Thomas Courrege wrote:
>>>
>>>> +	size_t rsp_size = sizeof(*report_rsp);
>>>> +	int ret;
>>> The declarations above should be in reverse fir tree order.
>>     
>> Like that ?
>>     struct sev_data_snp_msg_report_rsp *report_rsp;
>>     struct sev_data_snp_hv_report_req data;
>>     struct kvm_sev_snp_hv_report_req params;
>>     struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>>     size_t rsp_size = sizeof(*report_rsp);
>>     void __user *u_report;
>>     void __user *u_params;
>>     int ret;
> 	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
> 	struct sev_data_snp_msg_report_rsp *report_rsp;
> 	struct kvm_sev_snp_hv_report_req params;
> 	struct sev_data_snp_hv_report_req data;
> 	size_t rsp_size = sizeof(*report_rsp);
> 	void __user *u_report;
> 	void __user *u_params;
> 	int ret;
>
>>>> +	if (ret)
>>>> +		goto e_free_rsp;
>>>> +
>>>> +	if (!report_rsp->status)
>>>> +		rsp_size += report_rsp->report_size;
>>>> +
>>>> +	if (params.report_len < rsp_size) {
>>>> +		rsp_size = sizeof(*report_rsp);
>>>> +		ret = -ENOSPC;
>>>> +	}
>>> This can be contained within the if above it, right?
>>>
>>> if (!report_rsp->status) {
>>> 	if (params.report_len < (rsp_size + report_rsp->report_size))
>>> 		ret = -ENOSPC;
>>> 	else
>>> 		rsp_size += report_rsp->report_size;
>>> }
>> This leads to an error in case the user wants to query the report size.
>>
>>
>> Using params.report_len = 32, the nested if is true and thus the user get
>>
>> back the default rsp_size (= 32), not increased with report_size (= 1184).
> But isn't params.report_len set below to the proper value since it wasn't
> using rsp_size? The rsp_size variable is only used for the copy_to_user()
> for the report itself. Assuming you want to copy what's in 'rsp' no matter
> the return code you get, then can't you just do:
>
> if (!report_rsp->status) {
> 	if (params.report_len < (rsp_size + report_rsp->report_size))
> 		ret = -ENOSPC;
> 	else
> 		rsp_size += report_rsp->report_size;
>
> 	params.report_len = sizeof(*report_rsp) + report_rsp->report_size;
> }
>
> if (copy_to_user(u_report, report_rsp, rsp_size))
> 	ret = -EFAULT;
>
> Thanks,
> Tom
That's a good solution, thank you.

I'll also add a patch note for the next one.

Thanks,
Thomas
>>>> +
>>>> +	if (copy_to_user(u_report, report_rsp, rsp_size))
>>>> +		ret = -EFAULT;
>>>> +
>>>> +	params.report_len = sizeof(*report_rsp) + report_rsp->report_size;
>>> I'm not sure if we can rely on report_rsp->report_size being valid if
>>> resport_rsp->status is not zero. So maybe just set this to rsp_size.
>>>
>>> Thanks,
>>> Tom
>> maybe something like this ? to avoid copying on ENOSPC, where this issue come from
>>
>>     if (!report_rsp->status)
>>         rsp_size += report_rsp->report_size;
>>
>>     if (params.report_len < rsp_size) {
>>         ret = -ENOSPC;
>>     } else {
>>         if (copy_to_user(u_report, report_rsp, rsp_size))
>>             ret = -EFAULT;
>>     }
>>
>>     params.report_len = rsp_size;
>>
>>
>> To test this specific case : 
>>     https://github.com/Th0rOnDoR/test-length-sev/blob/main/sev_test.c
>>
>> Thanks, 
>> Thomas
>

