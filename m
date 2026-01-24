Return-Path: <kvm+bounces-69038-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AH+MNfzZdGns+QAAu9opvQ
	(envelope-from <kvm+bounces-69038-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 15:41:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F05F7DCF3
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 15:41:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 62FBF30066B9
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 14:40:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C88083242A5;
	Sat, 24 Jan 2026 14:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thorondor.fr header.i=@thorondor.fr header.b="YbNfLH9z"
X-Original-To: kvm@vger.kernel.org
Received: from mail.thorondor.fr (unknown [82.66.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA441B4F2C;
	Sat, 24 Jan 2026 14:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.66.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769265652; cv=none; b=dHK1G7cPMmK8LHaZvtScPozk6bvQgIsA0WbMu6LGb9sEjTOUQNkzOY0wgGT/dy268E3pN7PAAHq2V13LkWNtBICTK/Go46DxRPTnJ1CTfMrzVi4EM+KahRVlcREpkssaLZ3v2PMI5OZHxAo+xXkljNh6Nedlzdu29o6+XUgFpVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769265652; c=relaxed/simple;
	bh=cS0mBluvzJW0KPbiT4PvyGUJVfzqblDmb8zlJD8r8dk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZdOGTKbzsxqUzngmdYm7VmbKc8HA7Yz6NDGuECMTRIU1a4g1Zr6We6XHWwMBBZycUhXgpNJFrdD9gDohAVoIAKj9LArPEfgf9omPKrbrZEeacSKn0RxAO5z2R1qjsvpThBnz+uZdspn1bk8lP9mUzEIUAR4AmyW5pQ/FKKrXSEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=thorondor.fr; spf=pass smtp.mailfrom=thorondor.fr; dkim=pass (2048-bit key) header.d=thorondor.fr header.i=@thorondor.fr header.b=YbNfLH9z; arc=none smtp.client-ip=82.66.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=thorondor.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thorondor.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=thorondor.fr; s=mail;
	t=1769265642; bh=cS0mBluvzJW0KPbiT4PvyGUJVfzqblDmb8zlJD8r8dk=;
	h=Subject:To:Cc:References:From:In-Reply-To;
	b=YbNfLH9zCXG2IZT6ag27gaMBYO7VLogsYOXFlz0VfQCfsYHALgM0rZVQLSzjuDagE
	 1rHOBQ74wLuQuOjQxPGSNjdVPIK6zdkjnD+J+4ENQ1ZVOf2knddPj31nJB3as72W32
	 YxTgKi26x7jvyi+RJEkvagbHgQLCD57CB/PuyfJcwEJ44MD6/7dAtX+vIS7Wu4EWo7
	 7IxmeIUEHAYw8TpsK1gz5KangpQJuSG+vOiNqtzHTwBHL7BYP68Tps9xPrQHdz5MG8
	 6dddWEI/FOtiVSg30gd6i2hI5OdRNFdPr9AwemWPo1ovqr8XAGnOT2+Rp/v3xQc9XM
	 CGTXLCPMOqCqw==
Message-ID: <879f354c-822f-4902-8cc3-6cf9557db969@thorondor.fr>
Date: Sat, 24 Jan 2026 15:40:41 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3] KVM: SEV: Add KVM_SEV_SNP_HV_REPORT_REQ command
To: Tom Lendacky <thomas.lendacky@amd.com>, ashish.kalra@amd.com,
 corbet@lwn.net, herbert@gondor.apana.org.au, john.allen@amd.com,
 nikunj@amd.com, pbonzini@redhat.com, seanjc@google.com
Cc: kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org
References: <20251215141417.2821412-1-thomas.courrege@vates.tech>
 <254d7d53-b523-452d-8c6f-d611ab08a9ff@amd.com>
Content-Language: en-US
From: Thomas Courrege <thomas.courrege@thorondor.fr>
In-Reply-To: <254d7d53-b523-452d-8c6f-d611ab08a9ff@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[thorondor.fr,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[thorondor.fr:s=mail];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69038-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[thomas.courrege@thorondor.fr,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[thorondor.fr:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6F05F7DCF3
X-Rspamd-Action: no action

Sorry, i didn't saw the response, i changed the email i use.

On 21-01-2026 00:45, Tom Lendacky wrote:
> On 12/15/25 08:14, Thomas Courrege wrote:
>
>> +	size_t rsp_size = sizeof(*report_rsp);
>> +	int ret;
> The declarations above should be in reverse fir tree order.
    
Like that ?
    struct sev_data_snp_msg_report_rsp *report_rsp;
    struct sev_data_snp_hv_report_req data;
    struct kvm_sev_snp_hv_report_req params;
    struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
    size_t rsp_size = sizeof(*report_rsp);
    void __user *u_report;
    void __user *u_params;
    int ret;
>> +	if (ret)
>> +		goto e_free_rsp;
>> +
>> +	if (!report_rsp->status)
>> +		rsp_size += report_rsp->report_size;
>> +
>> +	if (params.report_len < rsp_size) {
>> +		rsp_size = sizeof(*report_rsp);
>> +		ret = -ENOSPC;
>> +	}
> This can be contained within the if above it, right?
>
> if (!report_rsp->status) {
> 	if (params.report_len < (rsp_size + report_rsp->report_size))
> 		ret = -ENOSPC;
> 	else
> 		rsp_size += report_rsp->report_size;
> }

This leads to an error in case the user wants to query the report size.


Using params.report_len = 32, the nested if is true and thus the user get

back the default rsp_size (= 32), not increased with report_size (= 1184).

>> +
>> +	if (copy_to_user(u_report, report_rsp, rsp_size))
>> +		ret = -EFAULT;
>> +
>> +	params.report_len = sizeof(*report_rsp) + report_rsp->report_size;
> I'm not sure if we can rely on report_rsp->report_size being valid if
> resport_rsp->status is not zero. So maybe just set this to rsp_size.
>
> Thanks,
> Tom
maybe something like this ? to avoid copying on ENOSPC, where this issue come from

    if (!report_rsp->status)
        rsp_size += report_rsp->report_size;

    if (params.report_len < rsp_size) {
        ret = -ENOSPC;
    } else {
        if (copy_to_user(u_report, report_rsp, rsp_size))
            ret = -EFAULT;
    }

    params.report_len = rsp_size;


To test this specific case : 
    https://github.com/Th0rOnDoR/test-length-sev/blob/main/sev_test.c

Thanks, 
Thomas

