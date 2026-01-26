Return-Path: <kvm+bounces-69165-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WCz6A4Ord2kZkAEAu9opvQ
	(envelope-from <kvm+bounces-69165-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 18:59:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C03028BD91
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 18:59:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3AF0430818BD
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 17:54:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B097634CFD9;
	Mon, 26 Jan 2026 17:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="noLej1aJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF40233149
	for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 17:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769450072; cv=pass; b=DBt6Vt3/m3dsCJzUG79uj1gJyT1w6EQFdVaW1E5z1i/fLN200F5dZj1PYEjd8Rw8tNuB7W2gxeGP88V3BL8VSgspjarO4kxr+AV91rk4uQZgLIxZzoB9Ejk+SLALJ+QcJQNxPJEh+reb19SktXiBfryvgOAmqTOD+Tdlrvdohmk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769450072; c=relaxed/simple;
	bh=DIDaa8firDc56kY0NwhQG07DNj47bE43T5LOLE1M3Ws=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FxigidrgjbtAPCIcMdjf2xIQcGUKJA4IBnBiHyqX+Nxwm/fDRhhYODFslHqgqN8SiZwdYzs+q8itg0djoAVOZkBxIXEk5/yAKVthn6kUGoCvsJ41XMyAZxxBQKV/38JOy9FqEBJU0jECsV8S3Ct/bpstihmVR+TZNWMjODwAaVU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=noLej1aJ; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-501511aa012so12701cf.0
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 09:54:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769450069; cv=none;
        d=google.com; s=arc-20240605;
        b=jcagNBSvauxZmFcD0axFshWT6q4rkmCgiQ+0MxVq69Kg9F4kYZxPX2FEycLd8h87Tc
         Qfu5XCohZuLG5sOdikxHtq0tdwz+QX3s10oUHvWMjXRdbrCWigIuiqN1yIebtnUCLtYl
         utbl3yOR0znFyAYOJ/lL7jE1FlZYOu9G1d9txErumsWIt7PB/ZcUFni71OrI6DHnyU3b
         DErO2+1o8UGzWNchbFjZht31LroEzNlnWVYcUeBlxSmedhI/MrS6hGCujYzXDb4+JYe6
         Pep4c6JIPryF1T0w2acuxiQooWIL4/70tvXuNXBHZmTzpqGFhRc2QcL0VpXXvYjvizW4
         NjPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=BaBaPbjRvnSlT5xuKPMaHPCMLrVAT3axwn7YGYLPHX8=;
        fh=oySkBM02pg0HfW4co7qBT5cQ2UAMwfDpy+B1puvuIDg=;
        b=gkT0Sw0sG7+DjLa0yWVqxKoyGHY8qxgHbbFjmu/H6KryOuc+vQtIc1rrSdASvrlpeC
         X+X/TpwZAiXrrph72bjqAXKdHBPNQ/L5R6ON3IyMakJLPOOzjNmdGe8WRQJc9fO+rz2/
         yIUtlLJCahoQHi94RrQHlWJZjIC0jtoWOHlsRsT+PzxCgRuG3cvWy7dl5/jb/sQJm3vI
         UgZa+Q09dEO+4mcH6DepNZf9++BnDosPfA3p7QjgJd5ejGF1gUaXFNIrlKBCMqzDsxkI
         g015CGwh3MyOcRHOTjwHOju6ZkrY8CFouKG0TQQggTv2DrcJXm0nsSTUaVM34K4BRYIy
         gbiQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769450069; x=1770054869; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BaBaPbjRvnSlT5xuKPMaHPCMLrVAT3axwn7YGYLPHX8=;
        b=noLej1aJ4TcluSpP2E6jAfy3pnMdSbfQTjJGp4NinzXdYyy5OJu4VwCTVrr5sT6TZl
         BcjWzwlyW2JX/bm0LSAxkvn5zxLTzllQl9mp/j2AOzuhkLmvLWc2JUFcAmjBX65ZKHF9
         W5WXfvdnL9AF8XvgCcvLgVsJFgKXV15+wIRRsj63XNyskoKp0SMrXCzV5EgMWSG2UxH3
         pdiKpVh6D0bry9Vi88iO21zLauBS30EH0kWp77i2be6zt8ks3gwqjSMcl6L+gSs+heqB
         7pOb+GvQ5bgGf0EzZG7CQ027JnXnhh0JZQuAS9YBhrinT7HgKp5yR35gnSOhDXiXmdof
         MrTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769450069; x=1770054869;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BaBaPbjRvnSlT5xuKPMaHPCMLrVAT3axwn7YGYLPHX8=;
        b=l0AHBiyQaaxXOoemdaYL5Z/y497lJjrswfYKHCdnEc7pbKsbOPsRBiqpeO83hpynh0
         3pqEQ1EwFdoDcM5OIAM3nMxyOV8iGs9IqkmKPSYm8h/G9adOdtKqYuDmZb1ZEsNgTSef
         jYZcsXBfemO+UXzFc41Q7mAJI308U2yO0K55r6URmA8dgVPeVV47QBDKl1IyKFsfUWn0
         H5TdY2T37acd65CwrgNqWVWaWOX7Kg+uNETKT509LHzf1Ad7SQFBPE/N38crtUpFuOIM
         vVEly9pYTns/UUElhiHUc9qJ9wHR3G42OBCJnPCMbFzrf/qXVPV7EOCX/Zoi8qTitZ40
         xkVQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1shUdsele3fNt9GUSXju4EopI2JXPDPy5ysla9DDJr29lTRHF1UyI0zC+pRqtDUEaVHw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzaxgsTBj1C1E7wPrykmBuLSZ1YW4t8qKhUNva7s8Uj8mfTuC0I
	er0CGd/H4iBItlg0HR//mSv9gbDofTRonLmjbV8nIJBshOuAVLMqNzbaBOW8Oetkj65f6hQWWV8
	FKxXNPdfmrINvXIPSggOJVYa0OLu1S7Wz6xcICmCn
X-Gm-Gg: AZuq6aLMAVJoJCsBHHsBHdM7aApPpHEsNlHmg/5qCLuqq1FyzQLUs8YKfXIEw1OHqw4
	/wm558ZQHbcwmJWwdzM1Jz31GQjDxmz3EieaCWvCkCcFrFN6X0hxr+2bqc7HTNDQA1SJcjAjqE2
	CVDsXYZygIoTi56WrU+XqW52oXGdn6RzgRmrg7QYOHUgaQCI5bi+F239Ef1bvb92p4sVASEbRei
	72pgRS0YUrQdfar5QPnxApmmTN7Nm22ofkDu+HBM16pwReZ9/uGcJWaorC55i7Un8aw3gcy
X-Received: by 2002:a05:622a:344:b0:501:4539:c81 with SMTP id
 d75a77b69052e-503142cc1d6mr14568201cf.2.1769450069071; Mon, 26 Jan 2026
 09:54:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-2-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-2-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 26 Jan 2026 17:53:52 +0000
X-Gm-Features: AZwV_QgKcivEy-Bh-scWxupdI_fJg4uVKAjUzJrjPt4iiSwWyjT8Fk2XVUt0Fj0
Message-ID: <CA+EHjTzToNnEV6Ow0WaVwpYwE3RBfLfvuzvDcnOjSmGB028vvQ@mail.gmail.com>
Subject: Re: [PATCH 01/20] arm64: Convert SCTLR_EL2 to sysreg infrastructure
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69165-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: C03028BD91
X-Rspamd-Action: no action

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> Convert SCTLR_EL2 to the sysreg infrastructure, as per the 2025-12_rel
> revision of the Registers.json file.
>
> Note that we slightly deviate from the above, as we stick to the ARM
> ARM M.a definition of SCTLR_EL2[9], which is RES0, in order to avoid
> dragging the POE2 definitions...
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Other than the deliberate deviation for bit 9, it matches the spec.

Of course, this changes the semantics of SCTLR_EL2_RES1, since now
it's 0. But I see you handle the consequences of this change later on.

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad



> ---
>  arch/arm64/include/asm/sysreg.h       |  7 ---
>  arch/arm64/tools/sysreg               | 69 +++++++++++++++++++++++++++
>  tools/arch/arm64/include/asm/sysreg.h |  6 ---
>  3 files changed, 69 insertions(+), 13 deletions(-)
>
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 939f9c5bbae67..30f0409b1c802 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -504,7 +504,6 @@
>  #define SYS_VPIDR_EL2                  sys_reg(3, 4, 0, 0, 0)
>  #define SYS_VMPIDR_EL2                 sys_reg(3, 4, 0, 0, 5)
>
> -#define SYS_SCTLR_EL2                  sys_reg(3, 4, 1, 0, 0)
>  #define SYS_ACTLR_EL2                  sys_reg(3, 4, 1, 0, 1)
>  #define SYS_SCTLR2_EL2                 sys_reg(3, 4, 1, 0, 3)
>  #define SYS_HCR_EL2                    sys_reg(3, 4, 1, 1, 0)
> @@ -837,12 +836,6 @@
>  #define SCTLR_ELx_A     (BIT(1))
>  #define SCTLR_ELx_M     (BIT(0))
>
> -/* SCTLR_EL2 specific flags. */
> -#define SCTLR_EL2_RES1 ((BIT(4))  | (BIT(5))  | (BIT(11)) | (BIT(16)) | \
> -                        (BIT(18)) | (BIT(22)) | (BIT(23)) | (BIT(28)) | \
> -                        (BIT(29)))
> -
> -#define SCTLR_EL2_BT   (BIT(36))
>  #ifdef CONFIG_CPU_BIG_ENDIAN
>  #define ENDIAN_SET_EL2         SCTLR_ELx_EE
>  #else
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index a0f6249bd4f98..969a75615d612 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -3749,6 +3749,75 @@ UnsignedEnum     2:0     F8S1
>  EndEnum
>  EndSysreg
>
> +Sysreg SCTLR_EL2       3       4       1       0       0
> +Field  63      TIDCP
> +Field  62      SPINTMASK
> +Field  61      NMI
> +Field  60      EnTP2
> +Field  59      TCSO
> +Field  58      TCSO0
> +Field  57      EPAN
> +Field  56      EnALS
> +Field  55      EnAS0
> +Field  54      EnASR
> +Res0   53:50
> +Field  49:46   TWEDEL
> +Field  45      TWEDEn
> +Field  44      DSSBS
> +Field  43      ATA
> +Field  42      ATA0
> +Enum   41:40   TCF
> +       0b00    NONE
> +       0b01    SYNC
> +       0b10    ASYNC
> +       0b11    ASYMM
> +EndEnum
> +Enum   39:38   TCF0
> +       0b00    NONE
> +       0b01    SYNC
> +       0b10    ASYNC
> +       0b11    ASYMM
> +EndEnum
> +Field  37      ITFSB
> +Field  36      BT
> +Field  35      BT0
> +Field  34      EnFPM
> +Field  33      MSCEn
> +Field  32      CMOW
> +Field  31      EnIA
> +Field  30      EnIB
> +Field  29      LSMAOE
> +Field  28      nTLSMD
> +Field  27      EnDA
> +Field  26      UCI
> +Field  25      EE
> +Field  24      E0E
> +Field  23      SPAN
> +Field  22      EIS
> +Field  21      IESB
> +Field  20      TSCXT
> +Field  19      WXN
> +Field  18      nTWE
> +Res0   17
> +Field  16      nTWI
> +Field  15      UCT
> +Field  14      DZE
> +Field  13      EnDB
> +Field  12      I
> +Field  11      EOS
> +Field  10      EnRCTX
> +Res0   9
> +Field  8       SED
> +Field  7       ITD
> +Field  6       nAA
> +Field  5       CP15BEN
> +Field  4       SA0
> +Field  3       SA
> +Field  2       C
> +Field  1       A
> +Field  0       M
> +EndSysreg
> +
>  Sysreg HCR_EL2         3       4       1       1       0
>  Field  63:60   TWEDEL
>  Field  59      TWEDEn
> diff --git a/tools/arch/arm64/include/asm/sysreg.h b/tools/arch/arm64/include/asm/sysreg.h
> index 178b7322bf049..f75efe98e9df3 100644
> --- a/tools/arch/arm64/include/asm/sysreg.h
> +++ b/tools/arch/arm64/include/asm/sysreg.h
> @@ -847,12 +847,6 @@
>  #define SCTLR_ELx_A     (BIT(1))
>  #define SCTLR_ELx_M     (BIT(0))
>
> -/* SCTLR_EL2 specific flags. */
> -#define SCTLR_EL2_RES1 ((BIT(4))  | (BIT(5))  | (BIT(11)) | (BIT(16)) | \
> -                        (BIT(18)) | (BIT(22)) | (BIT(23)) | (BIT(28)) | \
> -                        (BIT(29)))
> -
> -#define SCTLR_EL2_BT   (BIT(36))
>  #ifdef CONFIG_CPU_BIG_ENDIAN
>  #define ENDIAN_SET_EL2         SCTLR_ELx_EE
>  #else
> --
> 2.47.3
>

