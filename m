Return-Path: <kvm+bounces-70797-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AGlgNuGSi2kVWQAAu9opvQ
	(envelope-from <kvm+bounces-70797-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:19:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 50CBD11F002
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:19:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6D4E13046D95
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 20:19:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AAC932F745;
	Tue, 10 Feb 2026 20:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MgX3/DQi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B5123B604
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 20:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770754777; cv=none; b=LhARUs1fMUtVgMvxGEoScHitesy+NFzvZ+rujZZuF6qza5rFuiPluvYzui1P9D1DfjtVAdb1SQtQD6o+NB5JM9Ap1ctXJYWsXfpcOoUrNKihXlk6E1y1COVubcz5yvbfs6LMBt1OxjY3oeB9EctkoDYza8+BTeApx6Kr62HvNtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770754777; c=relaxed/simple;
	bh=Jg5ZKWADJEw9z4A/epzi2X3lwCK+G4mayqaFrbykNc4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k2qlrvbqH6karnxbzYAy2Vy9DvVRQLSDf9g4KDaFpWBDOlqY6pFpL5hIG3U1KMmqphK09xHttOGwReXu7HM/rzx+ZLYPo3Uht+T772gZ+G2KUBukjXoSZGjURbmn31hCNidmuSJP1fCnX0WWeEVyatsiA8IEkk5wLqwAkmg1FKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MgX3/DQi; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2a7bced39cfso13165525ad.1
        for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 12:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770754776; x=1771359576; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S8A0p8XkZmyMhYbKZktWyakNNU+WLUQpbvCNmbLPKmY=;
        b=MgX3/DQiejjVwe8rca2BAmFuOA7NPwagEvfUTO4NxRmv1l1k0r0zs608jTAD3W+R2Q
         KPhHY/OghCvCL8FuyGWMR2q2H80EHojM1bB12VVnnoPHc8k9O6cgh8smL2iT8ioZwRRY
         pRizGE6SPgIL/u0Ur0nmERsVbwObcsytyT0jXqZqaKsRMsepOx3QRBx6KgT43uT5w4CY
         ngEZIkqVvHGfLNsJT2Z3/EmOcfzjA9kVTgR/q5p8ZKplDO499td+CcM2by+6SZ3yBSep
         Hdd9/AFJdibh4CCwzbu0XjZGKKj73/o0XiNGk+H7hxHq1p/9We6Z168tCbB5455Nrevq
         iTCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770754776; x=1771359576;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S8A0p8XkZmyMhYbKZktWyakNNU+WLUQpbvCNmbLPKmY=;
        b=rv/UBHxF3bWcmvk/RH7JdfySDhyPiVV34pOGa7dJlsp47b1PT5Mfc3/RLLz7GAetaO
         9q+DvDoxo9kb8A2jPIFGnsX2w7tpyYopacIyZ3pjfKy1SjFaAmCMWtVLXw/2EZDIDfQb
         +vgpCIj9MRW2DvAaT8EPtDnL42aj3oxclt/9A2KSlMdsMJYhpTSV7nM3Uqn798Why/LX
         RDsKo31AJm+owUgdxMBehF8HbwkcBJryvE9lFFnC941y1oNEX0HYr54VUj02tbR1m63W
         PvQTXT7zIvhUiRjCuItpFmDqJvUxb/9uebhN9EnAVpC3IwST6eqzIFUk2+S+S9phE5Pa
         RzCA==
X-Forwarded-Encrypted: i=1; AJvYcCUM7nNCDVemRHOuaP/OtvOiOn96MV29nGO41z5N94YcNISqLtN0B9p26PUuiJ6bxkpArmE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSXVz2FCdsEuS3rdTuaaxyqcBC5D++v3Pw1zPwZ+O466+Axtbs
	/qI1NVJ9uErVbtrfDE6HTT5tw1PGnwe5jLjjDQBh6taHdxmkHpSR8HXx4z+9PmuRWlI=
X-Gm-Gg: AZuq6aL39u/UjLoH+dsC6xtreskwGhY4uBeQ5MrETWksqmm2M3MAnGv0Kgs8crR2aqI
	CpOMxlOcg434T6G2LB1VnjODD74kLAzV9jsulGZwm9uuyYBOZwxdg33NcAVQDVPjgCNJGw3/TyZ
	M8ytmnIBNFM0xYJKeCCk9FTRBXaMMYXwPXr6BYsR8TNANvJXY3bh1ApCNE+2VYddlqLkMakGA58
	UxIAQcMXCVYBAz7QjV2cioALZcDZhXOfyqQ8MQF/80Fi9p4IP4ZkDBUdN8l2wGlxXGBuzYyoCx/
	X3Wc4P0btoFj0NXd0MpmQ2xL2d54Jc1EuiPC6wTOOcvLDqwp8BDgeuI08Sqn4HWNPJ17xmm1D9a
	nPOBxB8oX9ikThmYFV9OU8a9ORQfjifARvheqDFH1Qvkr6jIUJpotPlGk7qys6L4tMAfjk2OxZi
	C9l0Ci1O79O2uzfrJQXe0/FpQzjFgAQI2Q8n1Vk8Iu/oUq8IcC9upuRf25nU+K8F+pfmlMfar2C
	m/NQ14=
X-Received: by 2002:a17:902:db07:b0:2a5:8c1c:7451 with SMTP id d9443c01a7336-2a9519f5b02mr181168565ad.58.1770754775772;
        Tue, 10 Feb 2026 12:19:35 -0800 (PST)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ab017c0461sm52081175ad.27.2026.02.10.12.19.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Feb 2026 12:19:35 -0800 (PST)
Message-ID: <93f8f250-7899-4528-b277-1ddd469c192c@linaro.org>
Date: Tue, 10 Feb 2026 12:19:34 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/12] target/arm: single-binary
Content-Language: en-US
To: qemu-devel@nongnu.org
Cc: anjo@rev.ng, Jim MacArthur <jim.macarthur@linaro.org>,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 Richard Henderson <richard.henderson@linaro.org>
References: <20260210201540.1405424-1-pierrick.bouvier@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Autocrypt: addr=pierrick.bouvier@linaro.org; keydata=
 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
 ZtfdHNZotF092MIH0IQC3poExQpV/WBYFAI=
In-Reply-To: <20260210201540.1405424-1-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[linaro.org:+];
	TAGGED_FROM(0.00)[bounces-70797-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linaro.org:mid,linaro.org:dkim]
X-Rspamd-Queue-Id: 50CBD11F002
X-Rspamd-Action: no action

On 2/10/26 12:15 PM, Pierrick Bouvier wrote:
> This series continues cleaning target/arm, especially tcg folder.
> 
> For now, it contains some cleanups in headers, and it splits helpers per
> category, thus removing several usage of TARGET_AARCH64.
> First version was simply splitting 32 vs 64-bit helpers, and Richard asked
> to split per sub category.
> 
> v3
> --
> 
> - translate.h: missing vaddr replacement
> - move tcg_use_softmmu to tcg/tcg-internal.h to avoid duplicating compilation
>    units between system and user builds.
> - eradicate TARGET_INSN_START_EXTRA_WORDS by calling tcg_gen_insn_start with
>    additional 0 parameters if needed.
> 
> v2
> --
> 
> - add missing kvm_enabled() in arm-qmp-cmds.c
> - didn't extract arm_wfi for tcg/psci.c. If that's a hard requirement, I can do
>    it in next version.
> - restricted scope of series to helper headers, so we can validate things one
>    step at a time. Series will keep on growing once all patches are reviewed.
> - translate.h: use vaddr where appropriate, as asked by Richard.
> 
> Pierrick Bouvier (12):
>    target/arm: extract helper-mve.h from helper.h
>    target/arm: extract helper-a64.h from helper.h
>    target/arm: extract helper-sve.h from helper.h
>    target/arm: extract helper-sme.h from helper.h
>    tcg: move tcg_use_softmmu to tcg/tcg-internal.h
>    target/arm: move exec/helper-* plumbery to helper.h
>    target/arm/tcg/psci.c: make compilation unit common
>    target/arm/tcg/cpu-v7m.c: make compilation unit common
>    target/arm/tcg/vec_helper.c: make compilation unit common
>    target/arm/tcg/translate.h: replace target_ulong with vaddr
>    target/arm/tcg/translate.h: replace target_long with int64_t
>    include/tcg/tcg-op.h: eradicate TARGET_INSN_START_EXTRA_WORDS
> 
>   include/tcg/tcg-op-common.h                   |   8 +
>   include/tcg/tcg-op.h                          |  29 ---
>   include/tcg/tcg.h                             |   6 -
>   target/alpha/cpu-param.h                      |   2 -
>   target/arm/cpu-param.h                        |   7 -
>   target/arm/helper-a64.h                       |  14 ++
>   target/arm/helper-mve.h                       |  14 ++
>   target/arm/helper-sme.h                       |  14 ++
>   target/arm/helper-sve.h                       |  14 ++
>   target/arm/helper.h                           |  17 +-
>   .../tcg/{helper-a64.h => helper-a64-defs.h}   |   0
>   target/arm/tcg/{helper.h => helper-defs.h}    |   0
>   .../tcg/{helper-mve.h => helper-mve-defs.h}   |   0
>   .../tcg/{helper-sme.h => helper-sme-defs.h}   |   0
>   .../tcg/{helper-sve.h => helper-sve-defs.h}   |   0
>   target/arm/tcg/translate-a32.h                |   2 +-
>   target/arm/tcg/translate.h                    |  22 +-
>   target/arm/tcg/vec_internal.h                 |  49 ++++
>   target/avr/cpu-param.h                        |   2 -
>   target/hexagon/cpu-param.h                    |   2 -
>   target/hppa/cpu-param.h                       |   2 -
>   target/i386/cpu-param.h                       |   2 -
>   target/loongarch/cpu-param.h                  |   2 -
>   target/m68k/cpu-param.h                       |   2 -
>   target/microblaze/cpu-param.h                 |   2 -
>   target/mips/cpu-param.h                       |   2 -
>   target/or1k/cpu-param.h                       |   2 -
>   target/ppc/cpu-param.h                        |   2 -
>   target/riscv/cpu-param.h                      |   7 -
>   target/rx/cpu-param.h                         |   2 -
>   target/s390x/cpu-param.h                      |   2 -
>   target/sh4/cpu-param.h                        |   2 -
>   target/sparc/cpu-param.h                      |   2 -
>   target/tricore/cpu-param.h                    |   2 -
>   target/xtensa/cpu-param.h                     |   2 -
>   tcg/tcg-internal.h                            |   6 +
>   target/alpha/translate.c                      |   4 +-
>   target/arm/debug_helper.c                     |   4 +-
>   target/arm/helper.c                           |   5 +-
>   target/arm/tcg/arith_helper.c                 |   4 +-
>   target/arm/tcg/crypto_helper.c                |   4 +-
>   target/arm/tcg/gengvec64.c                    |   3 +-
>   target/arm/tcg/helper-a64.c                   |   6 +-
>   target/arm/tcg/hflags.c                       |   4 +-
>   target/arm/tcg/m_helper.c                     |   2 +-
>   target/arm/tcg/mte_helper.c                   |   3 +-
>   target/arm/tcg/mve_helper.c                   |   6 +-
>   target/arm/tcg/neon_helper.c                  |   4 +-
>   target/arm/tcg/op_helper.c                    |   2 +-
>   target/arm/tcg/pauth_helper.c                 |   3 +-
>   target/arm/tcg/psci.c                         |   4 +-
>   target/arm/tcg/sme_helper.c                   |   5 +-
>   target/arm/tcg/sve_helper.c                   |   6 +-
>   target/arm/tcg/tlb_helper.c                   |   4 +-
>   target/arm/tcg/translate-a64.c                |   3 +
>   target/arm/tcg/translate-mve.c                |   1 +
>   target/arm/tcg/translate-sme.c                |   3 +
>   target/arm/tcg/translate-sve.c                |   3 +
>   target/arm/tcg/translate.c                    |  25 +-
>   target/arm/tcg/vec_helper.c                   | 224 ++----------------
>   target/arm/tcg/vec_helper64.c                 | 142 +++++++++++
>   target/arm/tcg/vfp_helper.c                   |   4 +-
>   target/avr/translate.c                        |   2 +-
>   target/hexagon/translate.c                    |   2 +-
>   target/i386/tcg/translate.c                   |   2 +-
>   target/loongarch/tcg/translate.c              |   2 +-
>   target/m68k/translate.c                       |   2 +-
>   target/microblaze/translate.c                 |   2 +-
>   target/or1k/translate.c                       |   2 +-
>   target/ppc/translate.c                        |   2 +-
>   target/rx/translate.c                         |   2 +-
>   target/sh4/translate.c                        |   4 +-
>   target/sparc/translate.c                      |   2 +-
>   target/tricore/translate.c                    |   2 +-
>   target/xtensa/translate.c                     |   2 +-
>   tcg/tcg.c                                     |   4 -
>   target/arm/tcg/meson.build                    |  11 +-
>   77 files changed, 383 insertions(+), 381 deletions(-)
>   create mode 100644 target/arm/helper-a64.h
>   create mode 100644 target/arm/helper-mve.h
>   create mode 100644 target/arm/helper-sme.h
>   create mode 100644 target/arm/helper-sve.h
>   rename target/arm/tcg/{helper-a64.h => helper-a64-defs.h} (100%)
>   rename target/arm/tcg/{helper.h => helper-defs.h} (100%)
>   rename target/arm/tcg/{helper-mve.h => helper-mve-defs.h} (100%)
>   rename target/arm/tcg/{helper-sme.h => helper-sme-defs.h} (100%)
>   rename target/arm/tcg/{helper-sve.h => helper-sve-defs.h} (100%)
>   create mode 100644 target/arm/tcg/vec_helper64.c
> 

Patches 1-11 are reviewed and ready to be pulled.

Regards,
Pierrick

