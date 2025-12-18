Return-Path: <kvm+bounces-66221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BB21CCAC28
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 09:02:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D8195302408B
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 08:02:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAFE1270EC3;
	Thu, 18 Dec 2025 08:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=weilnetz.de header.i=@weilnetz.de header.b="LaQhU/4G"
X-Original-To: kvm@vger.kernel.org
Received: from mail.v2201612906741603.powersrv.de (mail.weilnetz.de [37.120.169.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB435139579
	for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 08:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.120.169.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766044918; cv=none; b=M2xAw/u59isiA2wVm9Nqgh3l202xYd1rWXCq9attrVkACLX2hfBdxpplRbeXMJEDKfxkdfNp8nyAqkqM6fsd2fHN7HQNtz8Ocgj4pOzEHD36JJdxxjxS0X7ezEgdx2lJ0W6OApMuCrPEPeewWdDQkmnjXzLm5bWm3ukssvgDqTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766044918; c=relaxed/simple;
	bh=AOD/Bgr/YQXGQuhj8m4aJP26ijG/sBf3vF7oWBRVL9U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rX33mdJSieoAsQQWX9DLeTIo1HDyBa13k0fio/JK+fh81qcaZ/X9ldfz8yRfXwb9mfXet8tv3ZK0N9wAV+rTLtHY5gbWtLwd6VNJfufPVTgDEzl2IRoVHzqQxRiGtvIFB4bXxKlycTMapInqaFJlUN0+K39PLWFjK7RajeEm3Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weilnetz.de; spf=pass smtp.mailfrom=weilnetz.de; dkim=fail (0-bit key) header.d=weilnetz.de header.i=@weilnetz.de header.b=LaQhU/4G reason="key not found in DNS"; arc=none smtp.client-ip=37.120.169.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weilnetz.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=weilnetz.de
Received: from [192.168.178.140] (p5b151e44.dip0.t-ipconnect.de [91.21.30.68])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.v2201612906741603.powersrv.de (Postfix) with ESMTPSA id A6A81DA045A;
	Thu, 18 Dec 2025 08:56:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=weilnetz.de; s=dkim1;
	t=1766044602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WLVjI7qNBJqOzX4ulp3bRld7vOrqA5CUnNqo3FO1yIQ=;
	b=LaQhU/4G179ZMeLkX5PItHCzuP92WG2S1AWCWq5rLiFXm97hebclt9/KrJyuMB5/378Jb/
	dmP72erHVGQSbtP0P9arsczWRszEGSlXChvHKGJJ+94sg0ATvYG205+bI2KWJgp3VAKmtW
	XEfzfzTaEwxAGBEiwKUMmTiYVQtynys=
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=stefan.weil@weilnetz.de smtp.mailfrom=sw@weilnetz.de
Message-ID: <21c88d7a-10ca-472f-bea0-a6c9ab74f459@weilnetz.de>
Date: Thu, 18 Dec 2025 08:56:40 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] target/arm/kvm: add constants for new PSCI
 versions
To: Sebastian Ott <sebott@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, Eric Auger <eric.auger@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20251202160853.22560-1-sebott@redhat.com>
 <20251202160853.22560-2-sebott@redhat.com>
From: Stefan Weil <sw@weilnetz.de>
Autocrypt: addr=sw@weilnetz.de; keydata=
 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
In-Reply-To: <20251202160853.22560-2-sebott@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: v2201612906741603
X-Rspamd-Queue-Id: A6A81DA045A
X-Spamd-Bar: ---
X-Spamd-Result: default: False [-3.10 / 12.00];
	BAYES_HAM(-3.00)[100.00%];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_ZERO(0.00)[0];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[weilnetz.de:s=dkim1];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[p5b151e44.dip0.t-ipconnect.de:rdns]
X-Rspamd-Action: no action

Am 02.12.25 um 17:08 schrieb Sebastian Ott:
> Add constants for PSCI version 1_2 and 1_3.
> 
> Signed-off-by: Sebastian Ott <sebott@redhat.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> ---
>   target/arm/kvm-consts.h | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/target/arm/kvm-consts.h b/target/arm/kvm-consts.h
> index 54ae5da7ce..9fba3e886d 100644
> --- a/target/arm/kvm-consts.h
> +++ b/target/arm/kvm-consts.h
> @@ -97,6 +97,8 @@ MISMATCH_CHECK(QEMU_PSCI_1_0_FN_PSCI_FEATURES, PSCI_1_0_FN_PSCI_FEATURES);
>   #define QEMU_PSCI_VERSION_0_2                     0x00002
>   #define QEMU_PSCI_VERSION_1_0                     0x10000
>   #define QEMU_PSCI_VERSION_1_1                     0x10001
> +#define QEMU_PSCI_VERSION_1_2                     0x10002
> +#define QEMU_PSCI_VERSION_1_3                     0x10003
>   
>   MISMATCH_CHECK(QEMU_PSCI_0_2_RET_TOS_MIGRATION_NOT_REQUIRED, PSCI_0_2_TOS_MP);
>   /* We don't bother to check every possible version value */

Reviewed-by: Stefan Weil <sw@weilnetz.de>

