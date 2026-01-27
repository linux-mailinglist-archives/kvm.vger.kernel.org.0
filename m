Return-Path: <kvm+bounces-69260-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6CpCKBj9eGmOuQEAu9opvQ
	(envelope-from <kvm+bounces-69260-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 18:59:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id BF39D98B4D
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 18:59:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D6084300514E
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 17:59:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A724B3242B1;
	Tue, 27 Jan 2026 17:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N1/C+BsX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1FB314D2D
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 17:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769536765; cv=pass; b=e/9BP8modztZ4jxHM8FpmOQtkMWpxxU+vGiua8eTt+QVftRn8jynEQIy2tMTyASG18Sa/hT4HGdx0FBgPpGusqNzI1zapCwn188WNmoah73HJch/vt/3AMga0WQ6szvhrXhQoTbst/l3e5fq1MmhjS7WOPWXhTn9OndmdWcSDD0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769536765; c=relaxed/simple;
	bh=LuYLHuhCerbgSFOxdxa54N8FGEdtX2o0/IlNWz3mAEY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bfmi8UHaWXb8zV42sarZRDGnsuKtOB8zidBQ/OUbKjeXgSHxu0vzDaswz7h9h8nT2GD0o/a5tBuSSjtU6vXVgn8jlcllai0PLci8jOTZQkPwKEYU/dyGmlgUJwT8oO9fJH+LRuGddNKwOm9Mbd3H14v1hV/tXLQoMUs3CvYRaCk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N1/C+BsX; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5014b5d8551so17381cf.0
        for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 09:59:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769536763; cv=none;
        d=google.com; s=arc-20240605;
        b=epvQscsMOMFm7s1SEWkj/8FztVjrolE/9uFD328owhdfksqoxkIsO1J7cADB7/Z4Bg
         XvPqzXMFpm0T7oq0uz4xgQi5SJnSqJcYFf3uNnQOfUl0byZC3HioPYymIWnwEe6ZeygK
         e0k2yb1b/gssXs/dUl3p6FbYzpb59FtOISeR/aqganLzO2tQYfJ4+W4MShRWlNpV1ymb
         4eylOhC+UfVgu+OhdU5Vk+iZLag4gnhNvheVlY1k9BLU+v06Nb5/6gP8AjxCOfAoOnrH
         ASUlmZM4qmFZHOQcRQnpt+xHjYK5wA02SEbBfaBkhelkeuPebDM3e7yHG8fHn5IfErKw
         zTww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=UOQZvYTAv//pcJPda837MTWpR+PvpurRjquFigTQ1OA=;
        fh=raKeeew8W8shbZUdGKkxGccwx5Zm4fluyZ5xrHdKoT8=;
        b=VOeA67O4Tqi4MSLa6FCdkmJhuwWPOWkmtyEU9KncfyjkUmFR4fe5aesyYjAHSBuUyN
         S5qeo3ddVhZyZLQLoAp7QqvJi0UzrPgCgQvuX0Egz5dM1iLDVevQCqOD6ILi8s4c9UqM
         bt5Wy5cL4EXgkw1GHy0bwOhp0deHVDVKtpaooKxBE66xt6VxLDLItB0io7xIOCxrDtPY
         5/qspmKvuspYDyEjEpp41K9wmrLoB9yJ86AzRgsRSivaDUB7ehaW67Gn1a25Pr/l5lzE
         kLnjhMBInpOd5Vj2fVB3oX9QHshSeErIVaB2BqULX1fwTr5fQTvd4JZpFa8iyiapU19P
         q4OQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769536763; x=1770141563; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UOQZvYTAv//pcJPda837MTWpR+PvpurRjquFigTQ1OA=;
        b=N1/C+BsXCDCwCU02IFPV24Qn559Ozlg2ltyDEp9GKsoRmN35XXRAgxnB0fHn5IRPmg
         MwtgtuK0m2DZSqY7S52Q5ZgPXG1eP0Q6zU1t6h58C4kbtcBwb3gt0unS/LAzppovxglR
         3CLkbyzzsDclRcqsCB8M8kkIiw0rkYlLGoKuow9Hu5CgwQmYEq5ieJZ/hmKAyCAuZB9L
         xptLiccfb0WBylS/lqXI8V/jTLvg4lYU0x/t5F5VG5OPpoIv4fQzn9B2LW+RjkNqfkG/
         f5ufkoyp0XiU6mFkHN3MN3eitqDu+JYkENTXmuNvmCQl4EesLUwL68poX0fzMgk9HUZj
         eigQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769536763; x=1770141563;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UOQZvYTAv//pcJPda837MTWpR+PvpurRjquFigTQ1OA=;
        b=M3x/ct3nFm69hOQOTZFMndIL7rrOKsYgaxO9VuRuK20Jc3AmI2LP5FeQii/VJt0zvK
         7kz4Koeo3X+Ps4+AJGCLaJN5SQ1h+/wD5KfK1b43tKKCdRRzKIU8VLPOI1Xqp/1DVkTP
         +4QHIJQYfAAxTr1rAK0sDSlFv/8kIxDXbBDUar7VwfEKmt45HRSIkkqTXa2omL5DX481
         9qtQAfy0sOJZ73gNeH2evXpXl+DHhmAuK5HsOB8xmSy3PZ8ieiBLItEzyp7qa/fA2tpP
         yKG05Ua5P63WrFFR8iYTM/33LTc716FWTrHlvvXXXygivW5UFn94v8ZV4r5HCtWUZcRh
         LnPg==
X-Forwarded-Encrypted: i=1; AJvYcCU9LWxB2byE0ioa4HukzNLCeT7S791h6pVtMiNXVRx47U8luoaBpGcdFhSlgX3z8WbetHA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBtFpHcHkTU0Ifog6ywnhwIEEB2qUjOyjHlyziEl/gj8345k8W
	oARgTFFak+6Doyhp5LrYysVXT6bvaEZMcZoOCM7BfOd1LbODHmIfzQED/JuoQp8GHxRFixLFdTz
	AB68d8iFDvBbFkSIlzNUBikpVFGm/KyCbML56uC31
X-Gm-Gg: AZuq6aK5zHozO6b/CZhKGe5sVBTr720UggVpaueD4CZD9GwmYnBmZeUOu3KpQoZUP1e
	KDa7CtPDx0I2LOiOq/ltThi9l1ahyw0MiRuNjOg2Fq1R9k9p3HK77byA/7RvDk8uPCxiGVU6z3L
	lc6f2L9s78RBaIgt94Bk9Ofxh8lP8kbwKO1kqknRxrer7y+aEf3lFZTYfEdCMbptSCwdV67ySaB
	ifi5QcQ/l+r4NeXSp1Af2JNqgCJJh10Y8mAmrcVxX8xvBOkAGr9rpHVt1ZODajV1N1snJd/
X-Received: by 2002:ac8:5acd:0:b0:4ed:ff77:1a85 with SMTP id
 d75a77b69052e-5032f523d2cmr9890351cf.17.1769536763293; Tue, 27 Jan 2026
 09:59:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-8-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-8-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 27 Jan 2026 17:58:46 +0000
X-Gm-Features: AZwV_QhifucCrTaCB27apGhiPavJg-rm3JFwqkfMUM-JyXvNsgDNJJ3r6uYLx6U
Message-ID: <CA+EHjTzk_0n+Z3+WmHz0no+dJAcAxCtJgQFFs9hHG4WAw0rX=A@mail.gmail.com>
Subject: Re: [PATCH 07/20] KVM: arm64: Allow RES1 bits to be inferred from configuration
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69260-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: BF39D98B4D
X-Rspamd-Action: no action

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> So far, when a bit field is tied to an unsupported feature, we set
> it as RES0. This is almost forrect, but there are a few exceptions
> where the bits become RES1.

You need to correct forrect :)

> Add a AS_RES1 qualifier that instruct the RESx computing code to
> simply do that.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/config.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 8d152605999ba..6a4674fabf865 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -24,6 +24,7 @@ struct reg_bits_to_feat_map {
>  #define        CALL_FUNC       BIT(1)  /* Needs to evaluate tons of crap */
>  #define        FIXED_VALUE     BIT(2)  /* RAZ/WI or RAO/WI in KVM */
>  #define        MASKS_POINTER   BIT(3)  /* Pointer to fgt_masks struct instead of bits */
> +#define        AS_RES1         BIT(4)  /* RES1 when not supported */
>
>         unsigned long   flags;
>
> @@ -1316,8 +1317,12 @@ struct resx __compute_fixed_bits(struct kvm *kvm,
>                 else
>                         match = idreg_feat_match(kvm, &map[i]);
>
> -               if (!match || (map[i].flags & FIXED_VALUE))
> -                       resx.res0 |= reg_feat_map_bits(&map[i]);
> +               if (!match || (map[i].flags & FIXED_VALUE)) {
> +                       if (map[i].flags & AS_RES1)
> +                               resx.res1 |= reg_feat_map_bits(&map[i]);
> +                       else
> +                               resx.res0 |= reg_feat_map_bits(&map[i]);
> +               }

checkpatch is complaining about whitespaces here. I can't blame it.

With those fixed, looks good to me.

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>         }
>
>         return resx;



> --
> 2.47.3
>

