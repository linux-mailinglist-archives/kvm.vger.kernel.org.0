Return-Path: <kvm+bounces-73307-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QE6JFQrbrmm/JQIAu9opvQ
	(envelope-from <kvm+bounces-73307-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 15:36:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B458523AA0D
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 15:36:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8769E30234C9
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 14:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 024863D1CDF;
	Mon,  9 Mar 2026 14:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thorondor.fr header.i=@thorondor.fr header.b="OEG9kjzv"
X-Original-To: kvm@vger.kernel.org
Received: from mail.thorondor.fr (unknown [82.66.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A4F246774;
	Mon,  9 Mar 2026 14:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.66.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773067005; cv=none; b=PMdtu7HevizvAU6QtklrRMzB99W07iQ7fVx4G0EVFLAB7KhnBuQeT1Gp9M30cTCoafN7mVhtw5tKXYtpuOpqlOJ1e+7Ag+c8NXus57LPLWsS//MKqFJco8fTUGCLyWbtZSaG90swaA2JQbbpnvpjF8K9g0utubix30OGh7CMfls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773067005; c=relaxed/simple;
	bh=7qcA1ra2Byw2cymy6cg1YIgLBaGD6tJpt4IkB60n3NU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NaIJYNl790WGdrz8ZYf5HGaWPY2Osj9/LCPlTvDuVThZf+3gM5r3+r0HxCUF5o+b59g7/KEV1BE8TFC91rr2yQla/5b6aetpYXtXJIdcoJuxxp5LqXF1dDCnjI49DjcRrG4hAUErTFP2nKFCaKRi9UzxsSegjNWQlAgQq3FDAcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=thorondor.fr; spf=pass smtp.mailfrom=thorondor.fr; dkim=pass (2048-bit key) header.d=thorondor.fr header.i=@thorondor.fr header.b=OEG9kjzv; arc=none smtp.client-ip=82.66.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=thorondor.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thorondor.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=thorondor.fr; s=mail;
	t=1773066995; bh=7qcA1ra2Byw2cymy6cg1YIgLBaGD6tJpt4IkB60n3NU=;
	h=Subject:To:Cc:References:From:In-Reply-To;
	b=OEG9kjzvYp1Is3sbUeYwLYZ1QJ9ZVZskPwf78r1ZT6dz2UvR7UhNb1sFdkQaO/lqQ
	 ze/z6wbTLzWOJhpLPeaUl3sqBBYH9j2BBYMVKTOXSJip1FfotQguBM6v5PyksStTiJ
	 fex+1JcaV6sEMIAy3lGdxlic6zOMcVe+LPdxb9NJfqaPY7Apdbp4HrnHkFgxMHD3k4
	 QbKnbb1m0e8o38n8bVuGulvNZpjHlxGh+/TxFUiYZsdqD8k/tb229aPw/8kelLgJiN
	 QLekutJblLi/5OlhMYvU91EOsT6eG856RJMWNSu1R+epN0JYsJSL8jCHg2+xaC8B4t
	 3PjqaMq013Agg==
Message-ID: <aa49739b-0432-4d20-afbe-c63dd7c5608a@thorondor.fr>
Date: Mon, 9 Mar 2026 15:36:24 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v7 0/1] KVM: SEV: Add KVM_SEV_SNP_HV_REPORT_REQ command
To: Thomas Courrege <thomas.courrege@thorondor.fr>, ashish.kalra@amd.com,
 corbet@lwn.net, herbert@gondor.apana.org.au, john.allen@amd.com,
 nikunj@amd.com, pbonzini@redhat.com, seanjc@google.com,
 thomas.lendacky@amd.com
Cc: kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org
References: <20260302143626.289792-1-thomas.courrege@thorondor.fr>
Content-Language: en-US
From: Thomas Courrege <thomas.courrege@thorondor.fr>
In-Reply-To: <20260302143626.289792-1-thomas.courrege@thorondor.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B458523AA0D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[thorondor.fr,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[thorondor.fr:s=mail];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73307-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[thorondor.fr:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[thomas.courrege@thorondor.fr,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.942];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[thorondor.fr:dkim,thorondor.fr:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action


On 02-03-2026 15:36, Thomas Courrege wrote:
> Overview
> ========
> The SEV-SNP Firmware ABI allows the hypervisor to request an
> attestation report via the SEV_CMD_SNP_HV_REPORT_REQ firmware command.
>
> This allow KVM to expose more of AMD’s SEV‑SNP features.
>
> It also allow developers to easily request attestation.
> It could maybe be use by some cloud provider to easily provide an
> attestation report through their API, in case the Guest doesn't respond
> fast enough or even to compare the reports.
>
> Testing
> =======
> For testing this via QEMU, please use the following tree:
>         https://github.com/Th0rOnDoR/qemu
>
> Patch History
> =============
> v6 -> v7:
> Rebase after 7.0 merge window
>
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
> Thomas Courrege (1):
>   KVM: SEV: Add KVM_SEV_SNP_HV_REPORT_REQ command
>
>  .../virt/kvm/x86/amd-memory-encryption.rst    | 27 ++++++++
>  arch/x86/include/uapi/asm/kvm.h               |  9 +++
>  arch/x86/kvm/svm/sev.c                        | 63 +++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.c                  |  1 +
>  include/linux/psp-sev.h                       | 31 +++++++++
>  5 files changed, 131 insertions(+)
>
>
> base-commit: 55365ab85a93edec22395547cdc7cbe73a98231b
Gentle ping.

Thanks,
Thomas

