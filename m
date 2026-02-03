Return-Path: <kvm+bounces-69985-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2Of0BALDgWmgJgMAu9opvQ
	(envelope-from <kvm+bounces-69985-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 10:42:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id B3A04D6F91
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 10:42:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5DE85302CF28
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 09:41:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85A78399013;
	Tue,  3 Feb 2026 09:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o4/In8aP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C8C396D38
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 09:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770111703; cv=pass; b=txKyczoPmhbwxk0LUHCzjxo0tJPXE8cMN4uvAPtze1PJ1aTnrC7VinmdTrF7hoMgY96I8X1AlUNIsAu6wgNmi4OHdoEVRVbShNojLQudSvoBnKLq2Tn/CgRhNrHdI9SsEgbcpqGtDAC9os+fismGDi8cXEg1KH9IDpjs4hID01I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770111703; c=relaxed/simple;
	bh=us1083ZECDfL4S3CH0lycoRH/Kw+2jLcC17kXf2gHtU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GNwum5FD1Y9va4RR7DYy00vrLLkp+cHp3Q4w8Mc3uQ61y5rS7r2HQ6u0NBx9PCeA2nWLbCcVJtSsTZOmWqVdTyjL2uarCmpYaQFXiI7VbfmEBorVZ+/sEgBMShJMJowTtfOABQVA2XH2kN2YXgqcQ57+fEEmS4YFFUwKW6Vu+Ls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o4/In8aP; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5014b5d8551so275091cf.0
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 01:41:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770111697; cv=none;
        d=google.com; s=arc-20240605;
        b=H/pHO+iSs9RaYsVzkgCasZe8qTOZs0n2UO1uPoowEhDwIIqnnlpi/K7OjQoesRcPGz
         AsWqXhGtLsYMsYlh1Q/RPlhc6lKTJrg4yxAS2su3ZaPNlOzNELQg88HrWju5NMnjsQPs
         5pBtiCoKz4UWme/2maJB4Mk1hMu6h7QyyXLpD4cZkzw0P//qmF1kH1PP8RxZmTyo5ABH
         MKHa9tk8DeZoSfAwUSsQffGFW2hKITa625yUJLr9scLslHbB5chdP5AcQNet36gGBHf4
         Ml98xJltIXOpwX6cxwuJOpvEkN6CjrIxmcyF9fQn9Dj/LcYHTdvFqVgDJDWuNQngXXn6
         MTww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Fex5v7o8CPkY7hhbst5vKC6sK9Ovg5CdBS9vwalDDZM=;
        fh=+2xD7tELaG67BvrvopJGLqsqwQ1v+hTYbXznBwiFS1k=;
        b=GyElmHpYxjKMrHoS/zG+Mn2kAsmTAcj4Fszq87JV5UlGCBTP70kMdtgb6duxbGLoOU
         B4JMCPV2GCUgrPt54AiWrMxrmiOv2CVykJyckxA7t5QhPJ0BwQhBnjOtji6HzNoUlMME
         yG30a4IEpabAk7b9jC813lDz1/bqlrMsz4aYgwTlQ8fStq1wtTBuKsm9d8GGfJytu6gU
         yl1Hl2HUbrYa70CMHHa1C8J/nR30OVrLKTLM6S5/xLROEF84+H6SohAa0Zvz91OUqaKM
         afaTwWzgggxnrQFTktjOWPM0uxIMXS1v7CcWnk+QdUDJWmAUN2FL6xcvXhLCwu1hYPar
         eLZg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770111697; x=1770716497; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Fex5v7o8CPkY7hhbst5vKC6sK9Ovg5CdBS9vwalDDZM=;
        b=o4/In8aPni/zA/UOccv0cG1Nb1zZ9uVACmLm72jS6yqQQZAVKkVS47C1e6o0Qsi5aG
         kZ4doASHJYKm2a6oisxZ6Vfk2vIr21EykOGAb2nfsev4W8xiQSGV6Lvlcoft+l1WMXkd
         u+pqdbbgbfVddJ6ti2rEOUieOIR+ppEylmt7+hyTw/4e6I7ho8da+xskAwWvpLb95I0D
         4g/rocrSXCp88o7NwJKADCCCkwPBcFn9bfGJe0vAmGhroW/U5g8+JA+W7qgrQUET/xk7
         yvfo17nN2wXrULj2693X1P+2uHBFhNQlSJEeG5+NPO06gGJBOIZrwVwxj+74r9yDTYzO
         x8OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770111697; x=1770716497;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fex5v7o8CPkY7hhbst5vKC6sK9Ovg5CdBS9vwalDDZM=;
        b=IEbKG7XQQ5GLcbmlTewf8gslpXpI3hcn5IE3VYrEeWLRQuCpjFIM2GKxGhUX47S/yQ
         U3sGhap27yBjEBBNhEGokUJtzDPFeF2s174EHvzkJikntmI3CLzynDO9WLatJw0BHF0G
         1/Ow5pdmKxTrJuSc9iK6TvhAfwgI+ikIZ3C2toDb6ci987QLl2TjHkz28/TLhW32Zik3
         mUYSRMfLOBJAoITzXMMxL+CcRHUFLQ5kwp47N4k8hCUT77ysOgcqggQkEC/BsLrkRfEr
         be93U0bLsvVVuhmON7fOg5cHWtpKA0izKCP+rCySnUI7tQtu8MowR3uxy/pAvIUsC1sB
         I0Cw==
X-Forwarded-Encrypted: i=1; AJvYcCUSVzf9ruSZwaaiZGcebZ8L5PWAHrwwb1kQ+Kr0qXHAycZ9APCzxe4f7Ddtp+CiT+W9r7Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YymGWlhWzttjHUxjOlniArUCAA7CoRpV6cyLZiHFscXDX8F3DnG
	+CwgcTD0H8nMnRLEdoUyrJcreWSuesxiYqFkFdXo0JWeetuCkm8VxQKW9XiEeW/ZEjdoDbVMymL
	ohiKLeqVMfq8MUCBLDO+KIPDPam85C+IGT/ANSI06WSjSBYtsGiL1TI9Zj+52cQ==
X-Gm-Gg: AZuq6aKCSCJ29Gfq4AjmdMOhvdB+ZYjVF2VssA56D/85UB4hx96/19wpzCOmk+mETZI
	TmG2V5reOiYuw9Z30UrykQFhYSiOTSCgs70h1LG8gPFDMkn5gfPLtJILoNsq7ypDae23Klw+Hvb
	FQXa8zRAB/oRma8JUXK1lUjctcuLvdHb/r1ioZzdwtYojp3FptbnHAki9X4tghKghEFqD8F8/1z
	Jr5977FZCrH0rxcb7+D/GfBsWLX6VZ/NnmPS91sWF270UHvKWq2liH1N1Gm4xbtklzsXYXSZmeL
	gBfCepthJSP2W0mncscpxOKykQ==
X-Received: by 2002:a05:622a:610:b0:4ff:cb25:998b with SMTP id
 d75a77b69052e-5060f0d0fc2mr4910981cf.12.1770111697142; Tue, 03 Feb 2026
 01:41:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260202184329.2724080-1-maz@kernel.org>
In-Reply-To: <20260202184329.2724080-1-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 3 Feb 2026 09:41:00 +0000
X-Gm-Features: AZwV_QjqZ1UnCxkfe67UIBzq-4b3eaUyZq-nxMFFw9q75AKQJgz1vWaiA_7G-bc
Message-ID: <CA+EHjTzyiOFyy+Zf-2Zxd8W3vap=88xjLUF7bA4OWZOGTDOR4w@mail.gmail.com>
Subject: Re: [PATCH v2 00/20] KVM: arm64: Generalise RESx handling
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69985-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: B3A04D6F91
X-Rspamd-Action: no action

Hi Marc,

For the series:
Tested-by: Fuad Tabba <tabba@google.com>

Thanks!
/fuad

On Mon, 2 Feb 2026 at 18:43, Marc Zyngier <maz@kernel.org> wrote:
>
> Having spent some time dealing with some dark corners of the
> architecture, I have realised that our RESx handling is a bit patchy.
> Specially when it comes to RES1 bits, which are not clearly defined in
> config.c, and rely on band-aids such as FIXED_VALUE.
>
> This series takes the excuse of adding SCTLR_EL2 sanitisation to bite
> the bullet and pursue several goals:
>
> - clearly define bits that are RES1 when a feature is absent
>
> - have a unified data structure to manage both RES0 and RES1 bits
>
> - deal with the annoying complexity of some features being
>   conditioned on E2H==1
>
> - allow a single bit to take different RESx values depending on the
>   value of E2H
>
> This allows quite a bit of cleanup, including the total removal of the
> FIXED_VALUE horror, which was always a bizarre construct. We also get
> a new debugfs file to introspect the RESx settings for a given guest.
>
> Overall, this lowers the complexity of expressing the configuration
> constraints, for very little code (most of the extra lines are
> introduced by the debugfs stuff, and SCTLR_EL2 being added to the
> sysreg file).
>
> Patches on top of my kvm-arm64/vtcr branch (which is currently
> simmering in -next).
>
> * From v1 [1]
>
>   - Simplified RES0 handling by dropping the RES0_WHEN_E2Hx macros
>
>   - Cleaned up the kvm_{g,s}et_sysreg_resx() helpers
>
>   - Simplified dynamic RESx handling
>
>   - New improved debugfs handling, thanks to Fuad!
>
>   - Various clean-ups and spelling fixes
>
>   - Collected RBs (thanks Fuad and Joey!)
>
> [1] https://lore.kernel.org/all/20260126121655.1641736-1-maz@kernel.org
> Marc Zyngier (20):
>   arm64: Convert SCTLR_EL2 to sysreg infrastructure
>   KVM: arm64: Remove duplicate configuration for SCTLR_EL1.{EE,E0E}
>   KVM: arm64: Introduce standalone FGU computing primitive
>   KVM: arm64: Introduce data structure tracking both RES0 and RES1 bits
>   KVM: arm64: Extend unified RESx handling to runtime sanitisation
>   KVM: arm64: Inherit RESx bits from FGT register descriptors
>   KVM: arm64: Allow RES1 bits to be inferred from configuration
>   KVM: arm64: Correctly handle SCTLR_EL1 RES1 bits for unsupported
>     features
>   KVM: arm64: Convert HCR_EL2.RW to AS_RES1
>   KVM: arm64: Simplify FIXED_VALUE handling
>   KVM: arm64: Add REQUIRES_E2H1 constraint as configuration flags
>   KVM: arm64: Add RES1_WHEN_E2Hx constraints as configuration flags
>   KVM: arm64: Move RESx into individual register descriptors
>   KVM: arm64: Simplify handling of HCR_EL2.E2H RESx
>   KVM: arm64: Get rid of FIXED_VALUE altogether
>   KVM: arm64: Simplify handling of full register invalid constraint
>   KVM: arm64: Remove all traces of FEAT_TME
>   KVM: arm64: Remove all traces of HCR_EL2.MIOCNCE
>   KVM: arm64: Add sanitisation to SCTLR_EL2
>   KVM: arm64: Add debugfs file dumping computed RESx values
>
>  arch/arm64/include/asm/kvm_host.h             |  38 +-
>  arch/arm64/include/asm/sysreg.h               |   7 -
>  arch/arm64/kvm/config.c                       | 427 ++++++++++--------
>  arch/arm64/kvm/emulate-nested.c               |  10 +-
>  arch/arm64/kvm/nested.c                       | 151 +++----
>  arch/arm64/kvm/sys_regs.c                     |  68 +++
>  arch/arm64/tools/sysreg                       |  82 +++-
>  tools/arch/arm64/include/asm/sysreg.h         |   6 -
>  tools/perf/Documentation/perf-arm-spe.txt     |   1 -
>  .../testing/selftests/kvm/arm64/set_id_regs.c |   1 -
>  10 files changed, 478 insertions(+), 313 deletions(-)
>
> --
> 2.47.3
>

