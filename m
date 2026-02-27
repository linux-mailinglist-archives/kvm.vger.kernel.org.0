Return-Path: <kvm+bounces-72151-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OF4kMaCXoWl8ugQAu9opvQ
	(envelope-from <kvm+bounces-72151-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 14:09:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 710761B77BF
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 14:09:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 041CC313688B
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 13:05:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38BAE38BF7A;
	Fri, 27 Feb 2026 13:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iVYXXo2g"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4921121771C;
	Fri, 27 Feb 2026 13:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772197501; cv=none; b=HpyJYsEWmoaAwKwfzyKntcil/0YYa9yILwG6L7IAKtJo5btvenpqHhgrtbPuRKAoUhCpk/QWnsuaOTM/wxcKsvPLin4QCZTTxigxfFIR6dhf3wwlywnsSIg3kl12TteUPafQZ3dECkSo4KEdFzAtGX9nWMN5RN0KGyl0OfYZL9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772197501; c=relaxed/simple;
	bh=iCzPOcKriOMXRsYKFBXac3LX4jsJNnFohj2Ac45N/fY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KazdKzpWE5QRvdc4eDxjPSYLPSyJAzFQVu/UyiA+CHmpCsr6n4P9CbO6bCW527KEe0RwjXqPSWaYgaozjRZMyQL8ejlczGk1U2q58G65fblU0qQA6XHKmRgV4eyRjnF/IIT8PZK8RocErZz6th0JEFJdgf+aUqfTw2w/sHkZHKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iVYXXo2g; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF896C116C6;
	Fri, 27 Feb 2026 13:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772197501;
	bh=iCzPOcKriOMXRsYKFBXac3LX4jsJNnFohj2Ac45N/fY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iVYXXo2gKSbajc15xIVGOfAMg4eZpKLeSGlD4lOLQrQjqDbHt33mmuz/BNCFpnrcZ
	 MYY0/ZEb+Z0x1u6ywibATEZGUOG03DHyrvJuaF6LVPM7aoPJIU7HyORJKK2/QSPQKC
	 yFqb52BPCeuL+SrnVe3Q+bIl09At6G9D/IyGw6sTnphZeU6fVLj7qBfbluTT2vcJTO
	 PGWZrfoV9VlOOD84/jppr0mi5wx8l93SIni7NzAfjCNn9LzoN6vDLprDcV6ro188BY
	 YhH4MKscPW5xl3MQnDAedm3uZkEFi8JNVsUU0Dhd+/oQYW6dxKy1nzv6g0rWbcPvHn
	 4oTXkIASEMvGQ==
Date: Fri, 27 Feb 2026 22:04:58 +0900
From: Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: linux-pci@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
	Alex Williamson <alex@shazbot.org>,
	Baruch Siach <baruch@tkos.co.il>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] PCI: Correct PCI_CAP_EXP_ENDPOINT_SIZEOF_V2 value
Message-ID: <20260227130458.GA1783251@rocinante>
References: <20260227123653.3891008-1-bhelgaas@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260227123653.3891008-1-bhelgaas@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.10 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.56)[subject];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-72151-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kwilczynski@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 710761B77BF
X-Rspamd-Action: no action

Hello,

[...]
> diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
> index ec1c54b5a310..14f634ab9350 100644
> --- a/include/uapi/linux/pci_regs.h
> +++ b/include/uapi/linux/pci_regs.h
> @@ -712,7 +712,7 @@
>  #define  PCI_EXP_LNKCTL2_HASD		0x0020 /* HW Autonomous Speed Disable */
>  #define PCI_EXP_LNKSTA2		0x32	/* Link Status 2 */
>  #define  PCI_EXP_LNKSTA2_FLIT		0x0400 /* Flit Mode Status */
> -#define PCI_CAP_EXP_ENDPOINT_SIZEOF_V2	0x32	/* end of v2 EPs w/ link */
> +#define PCI_CAP_EXP_ENDPOINT_SIZEOF_V2	0x34	/* end of v2 EPs w/ link */
>  #define PCI_EXP_SLTCAP2		0x34	/* Slot Capabilities 2 */
>  #define  PCI_EXP_SLTCAP2_IBPD	0x00000001 /* In-band PD Disable Supported */
>  #define PCI_EXP_SLTCTL2		0x38	/* Slot Control 2 */

Looks good!

Reviewed-by: Krzysztof Wilczyński <kwilczynski@kernel.org>

Thank you!

	Krzysztof

