Return-Path: <kvm+bounces-69263-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eE4kGrD/eGmOuQEAu9opvQ
	(envelope-from <kvm+bounces-69263-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 19:10:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BB67298D29
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 19:10:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B847B3073405
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 18:09:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 888B43254A5;
	Tue, 27 Jan 2026 18:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CWhOHDcb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8400921ADB7
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 18:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769537393; cv=pass; b=iY8/DQzW9aiCPItI/w7Gue8W2mKNe/eyJnh1/+Is6wH9+gT95jVePvddpJmYaygfQ+6lBd3/WKbMoK/4jUjNpv1gDLKiOi477zJ1tZCE1NsSZOpC78RxapPvTzF5w/49sov2iJaV+5m8VfuWEp4yVzQTllBdaU0tEnX6MKPT+K0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769537393; c=relaxed/simple;
	bh=QhsDz6emSteQN6HE837EJTl9yLXUpogqzdkgXhKPUOc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W8XaE86EMKtJ7T32tekbPBRH9ryBMVcTVsJO49nvVRtPjh1x4P1TPaBUacei8iAQT7N/ht6gLRny0hSUzR9y4hH5yDWxAGdH3owdd5mpKi3Z017E4FhWb+2JKoCFgKBOBPgP+fYEZ1XhZdPqEeXLcaFFwdQFvbXV12An3h0gMqk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CWhOHDcb; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-501511aa012so28381cf.0
        for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 10:09:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769537390; cv=none;
        d=google.com; s=arc-20240605;
        b=OSSjaMF6oYArEZy88NoH7latZOte0/R2myzuHffB0wuCDviobg2hVdXK/ild0MYiGB
         +EB0SoqaJfUlI7BqB7cMqQSqP3SUC6s/p6MiqguB1JymLqEfzznWXosLVrBKjddbtm0L
         q0kS9TqyAvd4fkx+OTjPY5hNSkwy97hH0lgQH8fuDNtdA32P9aQVqaM7m7xdePzgpk2J
         YzLOy64W2DO1d/LnAM/QxF8vqUbFMawros8XkPE0uGJZyGCfxXSanO1kARvThePVEYRY
         xjA6rvuwXWhRA7htc9oLoWdAySrlMwL/AKmTxYWnUe58qwzk9ENfyfXS0yAWc0wwjPF4
         5PzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=A/fdw3HSB7m2kNlxcxEsVX9/NQhTkjGaXcMCpnvtKt0=;
        fh=B0TkPySAzKMznom74ao23DVWpPlKbHUzy/KKvRh5N34=;
        b=dLFphlJGOZkWNGsnvMpmkRQBIfXWvbCDCPaf1l6p02ZH+J6YpAEc72ypMYLPfrDzTJ
         vbMasxumzqevPRD3XIQ449gmAQf5jI2va2UhDU6qRX2g2ZSkXtj2WsCM5VPUn9hrjWq0
         JtrXwTDu/nvEBlmXlSBpOxRnPpVepEy8LsBQ8QFl0GuYepvIGj6CA7vuzTAfHjpx1ZRW
         JKUC+Rmsm0CEzmAKn0vSTdKRmVjaTXrhieXfTfei9oXQTsVpWk2Grc/eZbPNQh+28cjm
         3rsYGGAWTueLeZyjWj0gnTnxcjYXchAoQyjXlhenYYPPexfqVq6lw1qUl3BBfnhV+6lt
         CZeg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769537390; x=1770142190; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=A/fdw3HSB7m2kNlxcxEsVX9/NQhTkjGaXcMCpnvtKt0=;
        b=CWhOHDcbVBLd50Vm3h1xD74ZRgaCWuJ3V6p+7d0hwOq9FHPH34vinvHabGO94Tlx/x
         x2o5Uzf2p23wEVmTTduJx8VJl5C61VuQG2+t/fN29SElL5G+51q5rR9iXeaOZ7elgaKn
         sPYJSrLPGPE4wRzSRBOBp4iuOcvn+a6IJR6Qm20TG1w6/uZDv6dAvk4QZ0kapsiQ5xJb
         kB9K9Lh9rUI9Mk8QGqannOfot0v/9o4c6GBaRtJPNfIdHZ4ZdaZGxZI90uc4hLI5ZT1D
         UBpV+RImweH5xxgTcS8QoKe2p/G0AD0CeSTwjtSuv+2QMlU61hXN8rdxx41/ngeD+xkx
         CLyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769537390; x=1770142190;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A/fdw3HSB7m2kNlxcxEsVX9/NQhTkjGaXcMCpnvtKt0=;
        b=G+cvtY8ITAjIyu4k6aHj1giQVWzG8W7F7xkSrD9fLLBjsyyqjNwlzyYWAsYi9bgzKL
         jDp/SiIorS/81mTA7B8Hb6DDDZw0aFB3AszRQtT8EfSQn86HCyypLa4eIokaR2IEiHNv
         Bk/WkMdizsXWF2YozBkGehp+GZ3PgbmJommZ0Imib4LFm3y2zk/R4h77u8XUxAjyTij8
         c/KF4pHqblYlOwZqKDCDXlENmmwCBf/FMNV4+l07Tjs2yLGbU3t4oc4bPeTEHmLKEbcz
         vVPh0Dov/K6KJtLEHbKPEVnTsoZ8cMYjfrxtin9WhJrQoCATy9BSG+J9UbwymCxTNyuf
         D5qQ==
X-Forwarded-Encrypted: i=1; AJvYcCXICc4o33zKY1V3lWmMPtPWHCtoGqvKIG8xxcsxt3XxR9PX6RPZ8rELETACFJPlk8TDgJ8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcE1ItYm1pO6k9QU/lgCk2bbXeqc7VQhLvmUZqBqqnV1iMx1fA
	g3QW6HVdZpJP4UFDl2aKZF+R+dndctAwKxq2PB+pLH9m0tvjEDg1zaH3DBP2nBTNZGEGrAQNC/c
	n9QEs05PuIUnSECDiTdtK/2SGVyuEVZhSpi+2ojE/zos/NkhXzuLsZu2Nnx8=
X-Gm-Gg: AZuq6aKkwFnJ74Vk52OnKOB7+xIuJaRG3LtwzU0KdSfyF9pGIndio/RosTukIdRIxJo
	MTrR57OetO2aOeHr3ga/q7y4uxU+69qFlDQZpGnCjZZtI8mn5t7GLb4ztD9w48fffAek+dJE+fW
	fCLj6GQKk2OCFAvdfhCRcpLFiqWoO46RWxFVHC7hlN86x1dArYYYqUR/qd1zxEgA0DP73/hbSs3
	mJi0a/qrWbIbAraVi+Yjxuioekbl8byLMfTLlyhGvoupPwiOyVs/Bmk/Wx/gMAyJdEEcrjM
X-Received: by 2002:ac8:7d55:0:b0:4ed:8103:8c37 with SMTP id
 d75a77b69052e-5032f4c7f16mr11147521cf.12.1769537389984; Tue, 27 Jan 2026
 10:09:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-10-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-10-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 27 Jan 2026 18:09:13 +0000
X-Gm-Features: AZwV_QheZWlu-Uzsp1OFbCkpBH6_EN7Esc-S0xm2N0aOTBYMl0RK4FXDHy6Zuj0
Message-ID: <CA+EHjTyQdLO3pk2yqDDptXemRSFJmt674P_H2-VtWC967o-c3g@mail.gmail.com>
Subject: Re: [PATCH 09/20] KVM: arm64: Convert HCR_EL2.RW to AS_RES1
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
	TAGGED_FROM(0.00)[bounces-69263-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[hcr_el2.rw:url,mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BB67298D29
X-Rspamd-Action: no action

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> Now that we have the AS_RES1 constraint, it becomes trivial to express
> the HCR_EL2.RW behaviour.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/config.c | 15 +--------------
>  1 file changed, 1 insertion(+), 14 deletions(-)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 68ed5af2b4d53..39487182057a3 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -389,19 +389,6 @@ static bool feat_vmid16(struct kvm *kvm)
>         return kvm_has_feat_enum(kvm, ID_AA64MMFR1_EL1, VMIDBits, 16);
>  }
>
> -static bool compute_hcr_rw(struct kvm *kvm, u64 *bits)
> -{
> -       /* This is purely academic: AArch32 and NV are mutually exclusive */
> -       if (bits) {
> -               if (kvm_has_feat(kvm, FEAT_AA32EL1))
> -                       *bits &= ~HCR_EL2_RW;
> -               else
> -                       *bits |= HCR_EL2_RW;
> -       }
> -
> -       return true;
> -}
> -
>  static bool compute_hcr_e2h(struct kvm *kvm, u64 *bits)
>  {
>         if (bits) {
> @@ -967,7 +954,7 @@ static const DECLARE_FEAT_MAP(hcrx_desc, __HCRX_EL2,
>
>  static const struct reg_bits_to_feat_map hcr_feat_map[] = {
>         NEEDS_FEAT(HCR_EL2_TID0, FEAT_AA32EL0),
> -       NEEDS_FEAT_FIXED(HCR_EL2_RW, compute_hcr_rw),
> +       NEEDS_FEAT_FLAG(HCR_EL2_RW, AS_RES1, FEAT_AA32EL1),
>         NEEDS_FEAT(HCR_EL2_HCD, not_feat_aa64el3),
>         NEEDS_FEAT(HCR_EL2_AMO          |
>                    HCR_EL2_BSU          |
> --
> 2.47.3
>

