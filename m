Return-Path: <kvm+bounces-71878-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YKQPN0BQn2n+ZwQAu9opvQ
	(envelope-from <kvm+bounces-71878-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 20:40:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9680A19CCA2
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 20:40:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EF4793042D75
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 19:40:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E52073EF0B5;
	Wed, 25 Feb 2026 19:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XQvyfEvI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B423EDADB
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 19:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772048441; cv=none; b=mF+cszGa0fEkyHnCbszsF2Q19VT/Qd38WtzkupN/0IQzjjisNfCKnv+/698OPUdnMZy+lEj+6azv/CSYeO9yAVF+0p3IkmirEHd7hv4AYyxTC7PhG35ltz0UGJOG0Si5enAmxNQfC1pL69rxFuWyCO9/jjCEgCyB8lOsaqCulxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772048441; c=relaxed/simple;
	bh=VHW1mw4iIiD+DgzlDwpkCeHMYIU60W35rrzN64DwPko=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tnbdw0ZwGilp2mHHykzjYbMk5KST9oG4XDY1Vai7aCbyMv5ADrqWPhxKOtynWQ67ioXD+BdKHDlasZ1yZvyQAiI+Y/moo3pnVs9aCxY2QXQ7Xp5R/TRku68JIZdjfP96JP/ug6iDzdHjbADUXdHDKusCDboaVDZZr+qgOxVy6yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XQvyfEvI; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2adc1d9ec56so91475ad.0
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 11:40:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1772048439; x=1772653239; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UUj1S673p3detSktifXeGb28LBC3jFbCrEafskFBIyo=;
        b=XQvyfEvIwGiRi01QVPYQn2I0uF5VjhW+HpsMAQPEsqpHzoJrfek+lq94WBthvm+ND9
         M838CBMPg4Au9TsUzQ0gLqKUICRn8GMihnyadl503FHJBifxA0gplS1icMIrFhtRtwYu
         OS3QdGIQlV0ZoZ9TapsBqavyS/To0iredBlEaSghUNVcvalyLdkzTlQ8QbzWblPleV3P
         l2cPOhVlkN55bC9PqUzTHzf9ivonLEbXo4ICI12xAQl+w4HGudSoEt/m5jt5fQi0VDyX
         p2nL0acgNpRXSPmEUA1eEnCFBTt40Di7OkRzelKIxVqx+NflVxD+ocSMShV7uBTNe/HC
         xc9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772048439; x=1772653239;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UUj1S673p3detSktifXeGb28LBC3jFbCrEafskFBIyo=;
        b=I11XeJ7ieCDf5AiDnDsxPFoLOdsaDyxukpP8x7Y3edKTMxLTNtlKJJFMLS2k0zGmVZ
         MyfcFmEyEtyBpiNy9p6ez4sL9xmtcpaiSLYc1AEXQjFV7eKliG3ou+OgsFvyRZUEhl4U
         yIUmI6Jwc3dzcHJrA7aOvi6UEyhckBU+iTD4rwRS0Tl/vbLwvt9AVZX3Knh4NhI6jaVl
         OIzoBjPt8SoEhTUZFt9qr6/8NoAeRNypWeaqXU/iZi1J/8bRKjlk+s1WfVxokMQRyUP7
         JJ4WYnbHVi+a1KQZE9rf6aYl6L39qKxsGzAgyRPbyPA1E7XEvgNzOAhJ/ZCr8DUFkzNC
         xWaw==
X-Gm-Message-State: AOJu0YykBZQ7358lKhUvyB/pM8aacBG1z2LShHlBvUGHxXyhIZXWbapV
	SnDY2J8K1obStHAN6nRKV4AI+390c0Gmse5EqCRUZ4PZ+ZMo6SSAdZXM2Y2LQQjE06c=
X-Gm-Gg: ATEYQzwlll3BpFx2ulBUEejMFUAkObtCW7pR7astFpCSiA+Sewv4Xb5PpzP6j8J9Of1
	7ETPq36VhGD3vDxLoG+x3x+JHE8tB3BcB//f5EanG25h/b0Bf6Sqh/z9bdtyKuy8g3pZabQM6x1
	yjtEVVxa8Ow6qRDgbF2G0S+wmbmNpGGRClB/M0gYoxjb/JI9IEMuBOwNFHJ8ClN8GxSJqo2rTjI
	SFCeXrpVeH857fBlvEF5CryFvzMRTXIMJiKRvZ5B2+LouUC33vSnPAzQCpnCyMU5wo3qiVY0EGs
	Vmyw+rA3RgbYF6VwlqvmonFLapnkSopjxwl0pJw64ifJwNhsbtxKQJe0N2rygRpLBtpiw6YVsWS
	7fLumqbysTRawqwk2dy/ethZIXo72tXMZ2rgBV1Czbe7fIiC+xCKGLwH7J3NrtRis0+g3cSOcxn
	ZreAEkmLCoXQOUAlvsskUjsRlwcrX8GwLcfwGJkkrVxegNOxI3DjiQRIgxapNSGFG+ZITD
X-Received: by 2002:a17:902:db10:b0:2a9:4870:9606 with SMTP id d9443c01a7336-2ad7453b5f2mr164846735ad.42.1772048439231;
        Wed, 25 Feb 2026 11:40:39 -0800 (PST)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb5c9f79sm338045ad.33.2026.02.25.11.40.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Feb 2026 11:40:38 -0800 (PST)
Message-ID: <2a0b5bb2-f29a-49f5-9840-cc1385e1ada1@linaro.org>
Date: Wed, 25 Feb 2026 11:40:38 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] accel/mshv: Build without target-specific knowledge
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 xen-devel@lists.xenproject.org,
 Magnus Kulke <magnus.kulke@linux.microsoft.com>, Wei Liu <wei.liu@kernel.org>
References: <20260225051303.91614-1-philmd@linaro.org>
 <20260225051303.91614-4-philmd@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Autocrypt: addr=pierrick.bouvier@linaro.org; keydata=
 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
 ZtfdHNZotF092MIH0IQC3poExQpV/WBYFAI=
In-Reply-To: <20260225051303.91614-4-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71878-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DKIM_TRACE(0.00)[linaro.org:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 9680A19CCA2
X-Rspamd-Action: no action

On 2/24/26 9:13 PM, Philippe Mathieu-Daudé wrote:
> Code in accel/ aims to be target-agnostic. Enforce that
> by moving the MSHV file units to system_ss[], which is
> target-agnostic.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   accel/mshv/meson.build | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
> 

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>

