Return-Path: <kvm+bounces-70880-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QHxGEUiyjGlLsQAAu9opvQ
	(envelope-from <kvm+bounces-70880-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:46:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AC32012649B
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:45:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 10CDA30210F4
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:45:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 672143469F8;
	Wed, 11 Feb 2026 16:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thorondor.fr header.i=@thorondor.fr header.b="eICYbdjl"
X-Original-To: kvm@vger.kernel.org
Received: from mail.thorondor.fr (unknown [82.66.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5413C344DAA;
	Wed, 11 Feb 2026 16:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.66.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770828337; cv=none; b=OfR56lzL58Jv7VGCD74O8ATDQ/9eaGNR+xKhme+WefjqtVIvvSMOhwg1ybMzvU8lX3dEOK8C0V4I3SAbMDMkjGqSdmAjRsAmRYGrm5k9pxDPc6rs7Um4EauHRY18WvCeBmi+ozKLYDDOxxo9BditRCvqI7JEocFBSbIBcgJGv18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770828337; c=relaxed/simple;
	bh=idCVNzxeGorW16JtFn2b9Rbbcvhjhg05WWwYU68FgJ0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=FjXFS4BxbysPS0OlktWm+VsdHWxvDDFyQ7NZP5NDpAq2sjdy256i8+UU/pbj4Rx1V8AUHlfkBhkmXHdW1qVFQ27LO+eAPYz6EXj/zHz3sqVJa6r7LExZwmeNxGsGLkxsBOXbgYEn7WFhWCjvrwkdFoTCM9wB9oRdBuMlloFizTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=thorondor.fr; spf=pass smtp.mailfrom=thorondor.fr; dkim=pass (2048-bit key) header.d=thorondor.fr header.i=@thorondor.fr header.b=eICYbdjl; arc=none smtp.client-ip=82.66.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=thorondor.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thorondor.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=thorondor.fr; s=mail;
	t=1770827862; bh=idCVNzxeGorW16JtFn2b9Rbbcvhjhg05WWwYU68FgJ0=;
	h=Subject:From:To:Cc:References:In-Reply-To;
	b=eICYbdjlej+ar6HewNVlINgnmlxsvFBBc2LKU7ZDJZQaHflpb2WrL26m1JDNbtUU+
	 yvVamQgpFEyBdnpcVqR5/Rj4Ax5lErX8AyzxhJhXQDlL6tMrdNPmfYfw+ggjfAwsba
	 TYqLPW2w19FCDkzPSuZ7jb0XkH4YzS/maVpT7nl7E6fft2f+ZVMPmFs08RHrefdP9e
	 AG4itcCPamqpt3OFA+cjWIlHGrlFQZ0iaOuyM5G5hB0ZjkYUVqRzTfeNf2Pb5Pa1v2
	 x0FQu/CKrFmPZuzxGBroyrVgl20LeQDfikBGY8caj4IsF65MFvCs0ZxpTPq/RUv34e
	 F2As9KVKFHLKQ==
Message-ID: <421a20ea-2788-493d-8f25-497880c04a7e@thorondor.fr>
Date: Wed, 11 Feb 2026 17:37:41 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v6 0/1] KVM: SEV: Add KVM_SEV_SNP_HV_REPORT_REQ command
From: Thomas Courrege <thomas.courrege@thorondor.fr>
To: ashish.kalra@amd.com, seanjc@google.com, thomas.lendacky@amd.com
Cc: kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org
References: <20260128194956.314678-1-thomas.courrege@thorondor.fr>
 <4d286692-3e29-4e8d-b6d9-f04ceb748499@thorondor.fr>
Content-Language: en-US
In-Reply-To: <4d286692-3e29-4e8d-b6d9-f04ceb748499@thorondor.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[thorondor.fr,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[thorondor.fr:s=mail];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[thorondor.fr:+];
	RCVD_COUNT_THREE(0.00)[3];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70880-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[thomas.courrege@thorondor.fr,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,thorondor.fr:mid,thorondor.fr:dkim]
X-Rspamd-Queue-Id: AC32012649B
X-Rspamd-Action: no action



On 29-01-2026 11:35, Thomas Courrege wrote:
>
> -- 
> Regards,
> Thomas
> On 28-01-2026 20:49, Thomas Courrege wrote:
>> Overview
>> --------
>> The SEV-SNP Firmware ABI allows the hypervisor to request an
>> attestation report via the SEV_CMD_SNP_HV_REPORT_REQ firmware command.
> This allow KVM to expose more of AMD’s SEV‑SNP features.
>
> It also allow developers to easily request attestation.
> It could maybe be use by some cloud provider to easily provide an
> attestation report through their API, in case the Guest doesn't respond
> fast enough or even to compare the reports.
>> Testing
>> -------
>> For testing this via QEMU, please use the following tree:
>>         https://github.com/Th0rOnDoR/qemu
>>
>> Patch History
>> -------------
>> v5 -> v6:
>> Fix typos issues in documentation
>>
>> v4 -> v5:
>> Set variables in reverse christmas tree order
>> Fix and clean the rsp_size logic
>>
>> v3 -> v4:
>> Add newline in documentation to avoid a warning
>> Add base commit
>>
>> v2 -> v3:
>> Add padding to structure, code format
>> Write back the full MSG_REPORT_RSP structure
>> Remove the memzero_explicit for the report
>>
>> v1 -> v2:
>> Renaming, code format
>> Zeroes the report before returning
>>
>>
>> Any feedback is appreciated.
>>
>> Thanks,
>> Thomas
>>
>>
>> Thomas Courrege (1):
>>   KVM: SEV: Add KVM_SEV_SNP_HV_REPORT_REQ command
>>
>>  .../virt/kvm/x86/amd-memory-encryption.rst    | 28 +++++++++
>>  arch/x86/include/uapi/asm/kvm.h               |  9 +++
>>  arch/x86/kvm/svm/sev.c                        | 63 +++++++++++++++++++
>>  drivers/crypto/ccp/sev-dev.c                  |  1 +
>>  include/linux/psp-sev.h                       | 31 +++++++++
>>  5 files changed, 132 insertions(+)
>>
>>
>> base-commit: e89f0e9a0a007e8c3afb8ecd739c0b3255422b00

Gentle ping

Regards,
Thomas


