Return-Path: <kvm+bounces-72832-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yEUDOuKsqWn+CAEAu9opvQ
	(envelope-from <kvm+bounces-72832-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 17:18:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EC9CF215530
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 17:18:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BA0DD3006827
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 16:14:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 597913CD8BB;
	Thu,  5 Mar 2026 16:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UUvoikNx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B5122258C
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 16:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772727263; cv=pass; b=OPGutFZAlCN/zxncG+x5qRnzG9ksQ4kZFn+LpTcgABJensAZYipA3j6miqgs+rw8OiCTuDED+qkqe4sD3SoIpi2he8VP4yqO/+qW3H9QcUJSnjrNiu9tTN7hPieawL8dVcm0CPcR0xn0ujdRsfL37UP6nNMpCtCdOfjresagBq4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772727263; c=relaxed/simple;
	bh=E2JN73GYFbl+ZdDy42TwPsf59BvisQzxvbwqRQGdtaU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KgSz/vsX0n7Tyr1xy5fz1y7Rig4Lo1YJmXBLJBhqeZthckbr9sVqLBmAnHwVgkWdSqdQuOLLcPdpWIH4C08Sb3acOuFV8XkAcd7HocY3GyB9wpwbL/hbbDsgmhsbMX6q29Cp7rD675ygYdcgX1VXUZ/+65/g4dDhLHOFqHD8zkY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UUvoikNx; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-506a355aedfso601541cf.0
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 08:14:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772727261; cv=none;
        d=google.com; s=arc-20240605;
        b=MWz9W6Ez96du0CVOeJXWCJI/lfPSQ1SJOA6lI8oaoRT0P26uPa1G/f8t661T58O26K
         wxsTtQ3P3kAK+1eGtbnNRD/eIzeemO6J183IJCNfcnmsNj5rIrcrRBcA+sZl+0Z7p/iP
         LAcbY47rhPOi5BHrH0vwKfpXdwlpSM6/bvCMpEq3bimIHPt0p0FosXKkfQocW5LnCtVK
         vxka7gJnN1PFktCXzK/TnoEvmKFIWmfeujmcccaNtlCKZxOWiDAQFxXAiuk3tgC0ebTw
         veds2rcyC5x/rRX8fyYneDw+tEuTOOQKPrfexR+46340OqCDeJit5/O8rCJFVEAW7r2D
         WyCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=RZX8IkznGuT8tzheZIwXF+8NCOjzDtkabhnGyWvo57Q=;
        fh=1NnkoE44iydqwaKIvZldbbixCVVisB2zZR4hOif3g18=;
        b=B45J5N3Gk5Wj3oOGCQ98+G0EUAAy0DH/Wvoz8eP6aTgqw1NtLY0pbe810Chga0qp8g
         b7HmEq0LtQsfrXUBRRHJJ11BD++fKmaVgDwFrd2mkcqTxaF655BN1P3nME59KHlZKd0B
         YtehMs9YDDxQhfri0RUn9X6kQcKHniF07pSF9PDM3AiHYpeJRc8B6iBR9u3h/ygsfwhP
         h7SMDb/mBI3Cydto9LbV+hqW2riMKsTDXCj2moC5FJhJGT2SmZdbJ6zAIp0cuEXbcZEd
         UTsIoQHzmJjCryymBo1/c14EVoWvyWBjPY1P7SaBSxPsC0OlKi1fF3kvgEF1bQz5vdi0
         VatA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772727261; x=1773332061; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RZX8IkznGuT8tzheZIwXF+8NCOjzDtkabhnGyWvo57Q=;
        b=UUvoikNxHHu7wRAKrJgfZNwelmC9HSYxCfwCMDqhg4lqoYxdYOoEnArWnQ351rlEtn
         f2seSQJhxf2kWqpFTFs/ll2+Je5KFW5KbaKspdNUsI/HvApg+tucg54IG1oRvvcFErG4
         UTkybqX/xExZjdklRSoL01jTwbhD82ABqnBVpCiFm4+TeQKPTUBxfr4JtcMxj5EhaMqO
         OZ9gzXL0GeY8e8I/O34xYRuX8bYQKg1vKXzDLD9Ojkq5tn4r05p0B7ssMcYtEVWHQv6d
         0NQujdhDRjdUCphbSuKvB3bABXmfw+cRtB/frxh/HlPN8D3dYfP/DJfxuSMDRuo0DUWf
         MRrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772727261; x=1773332061;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RZX8IkznGuT8tzheZIwXF+8NCOjzDtkabhnGyWvo57Q=;
        b=uijbG9KckRm5ATZvQmAWUdKZj7AHzwbFZBzu/gGqlaFOvW5PsRkr+lbYg20E1orbNJ
         dxqtpoVUnKFR6twmUBZ8BQw9nNrvkLiHwbbPK7/AOy3taDIVmE5AvrcMiqK8837DBTGE
         mLXvDMJwTOmR0glKkzo7/ws2vXQI+WvOMp07vKpL5Fl68HEOiRJ3BOhtKTkFUbNEdwIY
         b1pxTaEJ4QBduNUKxV7kdHVccbAxAxcrdAJ3Af3N8kFAtZnP9764ZOXPQpiIQ5i4GQhV
         WKuK+u5M9wt749xfxncS4QFWxypCmSZEO/0VYt9wB0iF6GAnjdrW+IrJVzcWd2ykAS0i
         yHaw==
X-Gm-Message-State: AOJu0YxzPzGjMqnGj14GvagHtjjUSH1bKbtRBRQMs0p8eEgS1ld9UoOc
	//AIPaM6DQ9XvP2jIdygtKsRdZ4cicULnV0orerdw8dbN9UyFzEYlt70U8OAIHqxp/GpVGbOoup
	RU6w9Yb5aPa7uY7de43LwL2Oldogj6ko5AnEqNTYr
X-Gm-Gg: ATEYQzyNvXs9MlRJNYjsigoGVlnLici80OE2/hyMeTqItXjC2OCvtCDzKBxFdh5lSbK
	fUWkPppMxizrpYW9RAuY2BjS3g5g4GnhweYk/6LHPBfPU8CyExf8yP041vRamvGVwXZexT7XpBs
	rkRqzH7B1TCQKMRrrOvMc+8uuddvFUu5e8p6tLZnX3B4c7GYCKtuaIm7z5AGTX8+oCLKLVE/WzN
	frM3EQlG5vW/TyV1L1gNCs+mDpeGyTmPHIpSKzJqucFd0+LynBFiO628o06YNdC6O9yYnLDfWFm
	wxC+NMTO
X-Received: by 2002:a05:622a:1908:b0:501:5180:3c90 with SMTP id
 d75a77b69052e-508e78bc5a4mr10844941cf.15.1772727260703; Thu, 05 Mar 2026
 08:14:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260304162222.836152-1-tabba@google.com> <20260304162222.836152-3-tabba@google.com>
 <86ms0m6yzk.wl-maz@kernel.org>
In-Reply-To: <86ms0m6yzk.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 5 Mar 2026 16:13:43 +0000
X-Gm-Features: AaiRm50AKwVyEzy5F_vJgB74LeS4g576zBjIzkwS3u0xl1hmNy8i_O0Mvctk7UE
Message-ID: <CA+EHjTwQP=sXJ=SJE3OqByHKm7Si3S41BfuFO827_ZVwaygC9g@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] KVM: arm64: Fix vma_shift staleness on nested
 hwpoison path
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, yangyicong@hisilicon.com, 
	wangzhou1@hisilicon.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: EC9CF215530
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72832-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Thu, 5 Mar 2026 at 16:08, Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Fuad,
>
> On Wed, 04 Mar 2026 16:22:22 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > When user_mem_abort() handles a nested stage-2 fault, it truncates
> > vma_pagesize to respect the guest's mapping size. However, the local
> > variable vma_shift is never updated to match this new size.
> >
> > If the underlying host page turns out to be hardware poisoned,
> > kvm_send_hwpoison_signal() is called with the original, larger
> > vma_shift instead of the actual mapping size. This signals incorrect
> > poison boundaries to userspace and breaks hugepage memory poison
> > containment for nested VMs.
> >
> > Update vma_shift to match the truncated vma_pagesize when operating
> > on behalf of a nested hypervisor.
> >
> > Fixes: fd276e71d1e7 ("KVM: arm64: nv: Handle shadow stage 2 page faults")
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/mmu.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index e1d6a4f591a9..b08240e0cab1 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1751,6 +1751,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >
> >               force_pte = (max_map_size == PAGE_SIZE);
> >               vma_pagesize = min_t(long, vma_pagesize, max_map_size);
> > +             vma_shift = force_pte ? PAGE_SHIFT : __ffs(vma_pagesize);
>
> If force_pte is set, then we know that max_map_size == PAGE_SIZE. From
> there, vma_pagesize == PAGE_SIZE, since nothing can be smaller.
>
> Is there anything preventing us from having:
>
>                 vma_shift = __ffs(vma_pagesize);
>
> and be done with it?

Nope, nothing prevents that. Even simpler and better.

Would you like me to respin it?

Cheers,
/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

