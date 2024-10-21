Return-Path: <kvm+bounces-29261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CC77A9A5F05
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 10:46:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06BE91C240BE
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 08:46:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E2C81E2618;
	Mon, 21 Oct 2024 08:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="H+r0j0dl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.smtpout.orange.fr (smtp-14.smtpout.orange.fr [80.12.242.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AB51C36;
	Mon, 21 Oct 2024 08:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729500370; cv=none; b=bbPrHc7GFDKJSfTzqYhOPlB+BXlMluTbtRcnmx6UNXoQTiHld0+SmoM7nuQiDGGYCFpb+tGix+U5t4XDH1d2ZACVPbBIaHm2rmHXi4qhoopbFuRyu3q8qsjWClrTlC3D4rBN3C22fcJmWQAqaBs/RJWBeiR5KTdPbsjQzfn2lsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729500370; c=relaxed/simple;
	bh=fJXjH5qlfC6ASDlZU2YZEnFhYawwdHJBoYR3WOBcS30=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pCfp0qEpuZPyLjKWvMy7tvbMpZ0oCoDyM6yFnKFY1JIGsLAPrhy2MwLfHQdrlPZwbxIRngwaaEg9SL8IA8jqI8Nwz6DYOlucruMwvGnU+By7J7msmeN6roG1X1NBZGVWtZdOO7WDqikghDxsOMyz2aC+uM+Kgd+uC76jmnAxS6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=H+r0j0dl; arc=none smtp.client-ip=80.12.242.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Received: from [192.168.1.37] ([90.11.132.44])
	by smtp.orange.fr with ESMTPA
	id 2nWit5w2oIGzd2nWitpn3w; Mon, 21 Oct 2024 10:12:34 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1729498354;
	bh=b74pKJMrbi0EjSGOws8bCaw1p7JE0thrw1ZwFQ6pL1M=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=H+r0j0dlHG4EKgzxFMUkKsG0q8pg0iKdICETVBVlDYM4vUPoYmBSun26Yq6zYs0w2
	 hJJ9JBJljmEjks5Kgck6/lPlN36DpOAb0x8llN3+x+k085av3NhGRRjyg1WEKQnsnB
	 AT56vYHIHdtKFXDyIOnd3VaH1bTZqR8pwD4m92m83h+A8n5MlWHGZ6dHINU7MXNOnj
	 OcvTmGJXQPFZEybml5JwseYK1jndJ1iXYTNeFhH6CQzXNKU6wtjmD7135nU1TdBVMz
	 pvjChI0pGFkk+0aEKF4qHhenW+g8lMpikzKzw6m7X6B0nAK0I/yAmPsRWMd4bLdJCd
	 dbEAfkYmELjEg==
X-ME-Helo: [192.168.1.37]
X-ME-Auth: bWFyaW9uLmphaWxsZXRAd2FuYWRvby5mcg==
X-ME-Date: Mon, 21 Oct 2024 10:12:34 +0200
X-ME-IP: 90.11.132.44
Message-ID: <396e511f-e5cc-4850-bf72-0a2111f7683c@wanadoo.fr>
Date: Mon, 21 Oct 2024 10:12:32 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 03/13] x86/sev: Add Secure TSC support for SNP guests
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 thomas.lendacky@amd.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241021055156.2342564-1-nikunj@amd.com>
 <20241021055156.2342564-4-nikunj@amd.com>
Content-Language: en-US, fr-FR
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20241021055156.2342564-4-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 21/10/2024 à 07:51, Nikunj A Dadhania a écrit :
> Add support for Secure TSC in SNP-enabled guests. Secure TSC allows guests
> to securely use RDTSC/RDTSCP instructions, ensuring that the parameters
> used cannot be altered by the hypervisor once the guest is launched.
> 
> Secure TSC-enabled guests need to query TSC information from the AMD
> Security Processor. This communication channel is encrypted between the AMD
> Security Processor and the guest, with the hypervisor acting merely as a
> conduit to deliver the guest messages to the AMD Security Processor. Each
> message is protected with AEAD (AES-256 GCM). Use a minimal AES GCM library
> to encrypt and decrypt SNP guest messages for communication with the PSP.
> 
> Use mem_encrypt_init() to fetch SNP TSC information from the AMD Security
> Processor and initialize snp_tsc_scale and snp_tsc_offset. During secondary
> CPU initialization, set the VMSA fields GUEST_TSC_SCALE (offset 2F0h) and
> GUEST_TSC_OFFSET (offset 2F8h) with snp_tsc_scale and snp_tsc_offset,
> respectively.
> 
> Add confidential compute platform attribute CC_ATTR_GUEST_SNP_SECURE_TSC
> that can be used by the guest to query whether the Secure TSC feature is
> active.
> 
> Since handle_guest_request() is common routine used by both the SEV guest
> driver and Secure TSC code, move it to the SEV header file.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Tested-by: Peter Gonda <pgonda@google.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---

..

> +static int __init snp_get_tsc_info(void)
> +{
> +	static u8 buf[SNP_TSC_INFO_RESP_SZ + AUTHTAG_LEN];
> +	struct snp_guest_request_ioctl rio;
> +	struct snp_tsc_info_resp tsc_resp;
> +	struct snp_tsc_info_req *tsc_req;
> +	struct snp_msg_desc *mdesc;
> +	struct snp_guest_req req;
> +	int rc;
> +
> +	/*
> +	 * The intermediate response buffer is used while decrypting the
> +	 * response payload. Make sure that it has enough space to cover the
> +	 * authtag.
> +	 */
> +	BUILD_BUG_ON(sizeof(buf) < (sizeof(tsc_resp) + AUTHTAG_LEN));
> +
> +	mdesc = snp_msg_alloc();
> +	if (IS_ERR_OR_NULL(mdesc))
> +		return -ENOMEM;
> +
> +	rc = snp_msg_init(mdesc, snp_vmpl);
> +	if (rc)
> +		return rc;
> +
> +	tsc_req = kzalloc(sizeof(struct snp_tsc_info_req), GFP_KERNEL);
> +	if (!tsc_req)
> +		return -ENOMEM;
> +
> +	memset(&req, 0, sizeof(req));
> +	memset(&rio, 0, sizeof(rio));
> +	memset(buf, 0, sizeof(buf));
> +
> +	req.msg_version = MSG_HDR_VER;
> +	req.msg_type = SNP_MSG_TSC_INFO_REQ;
> +	req.vmpck_id = snp_vmpl;
> +	req.req_buf = tsc_req;
> +	req.req_sz = sizeof(*tsc_req);
> +	req.resp_buf = buf;
> +	req.resp_sz = sizeof(tsc_resp) + AUTHTAG_LEN;
> +	req.exit_code = SVM_VMGEXIT_GUEST_REQUEST;
> +
> +	rc = snp_send_guest_request(mdesc, &req, &rio);
> +	if (rc)
> +		goto err_req;
> +
> +	memcpy(&tsc_resp, buf, sizeof(tsc_resp));
> +	pr_debug("%s: response status %x scale %llx offset %llx factor %x\n",
> +		 __func__, tsc_resp.status, tsc_resp.tsc_scale, tsc_resp.tsc_offset,
> +		 tsc_resp.tsc_factor);
> +
> +	if (tsc_resp.status == 0) {
> +		snp_tsc_scale = tsc_resp.tsc_scale;
> +		snp_tsc_offset = tsc_resp.tsc_offset;
> +	} else {
> +		pr_err("Failed to get TSC info, response status %x\n", tsc_resp.status);
> +		rc = -EIO;
> +	}
> +
> +err_req:
> +	/* The response buffer contains the sensitive data, explicitly clear it. */
> +	memzero_explicit(buf, sizeof(buf));
> +	memzero_explicit(&tsc_resp, sizeof(tsc_resp));
> +	memzero_explicit(&req, sizeof(req));

req does not seem to hold sensitive data.
Is it needed, or maybe should it be tsc_req?

> +
> +	return rc;
> +}

...

CJ

