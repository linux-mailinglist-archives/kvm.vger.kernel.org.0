Return-Path: <kvm+bounces-69531-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qO/gMZg7e2mNCgIAu9opvQ
	(envelope-from <kvm+bounces-69531-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 11:51:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B54DAF25A
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 11:51:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 160B5310C7C8
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 10:37:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D473388846;
	Thu, 29 Jan 2026 10:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thorondor.fr header.i=@thorondor.fr header.b="S6Na3Uds"
X-Original-To: kvm@vger.kernel.org
Received: from mail.thorondor.fr (unknown [82.66.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCC23876A6;
	Thu, 29 Jan 2026 10:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.66.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769682937; cv=none; b=YOM5QNQLf8rSjSvDDfObetjyj72H9n0T+eDaXlSgm8zWnzREjqEcWZB6ABLlUT7f1+iJ7qg2WrVhDMYcTSDuC/kRy/XPZBxJ57FIF4NT19t0avx5W5lcvK4liofJeDIqDvGFchl6sxYS3owM/UWvxV7JvnQId/pX2oAq5+5uFhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769682937; c=relaxed/simple;
	bh=pB05o+FNxJuOZKYxadKQglpf0zYg+JCb9JSnbOG3zHQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pSVHCJT5qhYY/Xi/HyfJ1+/pSTy6ZF30GviB1wf/38ePeDq2Mvx24YOXIl53a5t77FTjfSUnLoTVctXBMpPrCVm148dpez0eVUCHcmZeqCll2zb4awqR+L4mqEXQNA7tpygtHN6eNtBUURW3alVhydS6o+kCEMSOwlVV/F5YFKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=thorondor.fr; spf=pass smtp.mailfrom=thorondor.fr; dkim=pass (2048-bit key) header.d=thorondor.fr header.i=@thorondor.fr header.b=S6Na3Uds; arc=none smtp.client-ip=82.66.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=thorondor.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thorondor.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=thorondor.fr; s=mail;
	t=1769682933; bh=pB05o+FNxJuOZKYxadKQglpf0zYg+JCb9JSnbOG3zHQ=;
	h=Subject:To:Cc:References:From:In-Reply-To;
	b=S6Na3UdsuJ3b3LxA/GSXMPE7tjhRRRZuZ29wo4kCpGvMLJkvAZdb0Zb2dUvf2pHgG
	 dxa/3pPMs8hkGtGqSTNoRN3CdYxxXsurX5DUUyDjzxoOXy8ObEcxskMbcerXyCG5IS
	 R6Ut3iUZDyGwIe2TUA+sREmozRDNt+jDBBmsVDFsA/JqSqCHQsq5ItF4hVlLJF+fnN
	 7Q9sxc3zh9G6ZOUUuOqeNRXAHd3jRaZxH22Y3liWES1Kb0/WWVFwoZ1XVrBVOZiCKU
	 tfCNaUClPNUjBnesSXLDQNj9njpqAQXdyxnw/tgialIWqgv4+t0izKcc8VRu7suWOd
	 4Ua+74YYTrrkw==
Message-ID: <4d286692-3e29-4e8d-b6d9-f04ceb748499@thorondor.fr>
Date: Thu, 29 Jan 2026 11:35:24 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v6 0/1] KVM: SEV: Add KVM_SEV_SNP_HV_REPORT_REQ command
To: ashish.kalra@amd.com, corbet@lwn.net, herbert@gondor.apana.org.au,
 john.allen@amd.com, nikunj@amd.com, pbonzini@redhat.com, seanjc@google.com,
 thomas.lendacky@amd.com
Cc: kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org
References: <20260128194956.314678-1-thomas.courrege@thorondor.fr>
Content-Language: en-US
From: Thomas Courrege <thomas.courrege@thorondor.fr>
In-Reply-To: <20260128194956.314678-1-thomas.courrege@thorondor.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[thorondor.fr,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[thorondor.fr:s=mail];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69531-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[thorondor.fr:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[12];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[thomas.courrege@thorondor.fr,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[thorondor.fr:mid,thorondor.fr:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6B54DAF25A
X-Rspamd-Action: no action

On 28-01-2026 20:49, Thomas Courrege wrote:
> Overview
> --------
> The SEV-SNP Firmware ABI allows the hypervisor to request an
> attestation report via the SEV_CMD_SNP_HV_REPORT_REQ firmware command.
This allow KVM to expose more of AMD’s SEV‑SNP features.

It also allow developers to easily request attestation.
It could maybe be use by some cloud provider to easily provide an
attestation report through their API, in case the Guest doesn't respond
fast enough or even to compare the reports.
> Testing
> -------
> For testing this via QEMU, please use the following tree:
>         https://github.com/Th0rOnDoR/qemu
>
> Patch History
> -------------
> v5 -> v6:
> Fix typos issues in documentation
>
> v4 -> v5:
> Set variables in reverse christmas tree order
> Fix and clean the rsp_size logic
>
> v3 -> v4:
> Add newline in documentation to avoid a warning
> Add base commit
>
> v2 -> v3:
> Add padding to structure, code format
> Write back the full MSG_REPORT_RSP structure
> Remove the memzero_explicit for the report
>
> v1 -> v2:
> Renaming, code format
> Zeroes the report before returning
>
>
> Any feedback is appreciated.
>
> Thanks,
> Thomas
>
>
> Thomas Courrege (1):
>   KVM: SEV: Add KVM_SEV_SNP_HV_REPORT_REQ command
>
>  .../virt/kvm/x86/amd-memory-encryption.rst    | 28 +++++++++
>  arch/x86/include/uapi/asm/kvm.h               |  9 +++
>  arch/x86/kvm/svm/sev.c                        | 63 +++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.c                  |  1 +
>  include/linux/psp-sev.h                       | 31 +++++++++
>  5 files changed, 132 insertions(+)
>
>
> base-commit: e89f0e9a0a007e8c3afb8ecd739c0b3255422b00

