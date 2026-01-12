Return-Path: <kvm+bounces-67752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 650A0D12D17
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 14:32:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 47F67301FFA9
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 13:29:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01096359707;
	Mon, 12 Jan 2026 13:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XhnzU/Oa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EFC3590AA
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 13:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768224570; cv=pass; b=cJ4V5E2ah6+5GxIfoxdy0jl8ToMjHTshiSZqvBeb/WTYhKlNjUru4wR/drtKpAPpYD0JwvCIqb/tDqCxgbyJeSSJd3H6rjX9Z8zNDZZkBYIppOq89WY/MQ3TnS38SdFmkqLkyVXsktKSVveYI7UNhsMvROzuykEVDy6DkiiE7YI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768224570; c=relaxed/simple;
	bh=nNsvMblRGGki6ohemJFCJRABNbnFZNgKUtyaxPDO2cs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KdxouPsoCy5JFsQoQ3lKlRfYOM5ZB4Yg9wMCNcxl7UmW9zHjKBAzFrmDbkZLCHqduYXduxmHjgdjO8wUoTdaLTy6Rxti7lNKymQ96exRHJtbmIPyGR0Z2SS/tLvYOEa65bjS15uNWVshavSKpwcVeOpMPmD3l7s9OEX3AMWX9hU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XhnzU/Oa; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4ee147baf7bso825111cf.1
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 05:29:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768224568; cv=none;
        d=google.com; s=arc-20240605;
        b=aFlOXdxL/BrCpNVWkew/QqG+12+dwumbiwT60GfsM5EwiY/poD4vjmkBCX2eeX2hpu
         kybsC2qlWNSCss+gg462X/rB/XHIR/Fl/QhJaC5Ih86h0RMXwg8UFjkyXyHneHV5pYbq
         LfMCFI8qwxsNOJZ2RPZhpPeN+hFtB6XI0yWpG13I/iREqAgBlLdz55X/L95uc5Gv44JN
         8P4O9pfzfYD56/iEXWE7VcsP0weQgsDmLU2O0fO07OVwB8/5r1jLdDXu+m7vnkeOskaT
         01zU/4NmDXUgaoP1vaUIswPlzg+qm7PTJ/4g9F2LE0DutyP9HrRiypouhWGM0CWPicTb
         l4Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=jaGuPXqFXeyZwxS5wActQiEFDVDRQPMhfrfAWEZUdIY=;
        fh=iHdsIOOxxjf5BDMDZSlt7gbrsBL73xxdjZZlFydbZdE=;
        b=Xh6d+nYBXD2nPc6Ia1t7v9jrLhF7Tkr7njbo8O14lEIacIaYo8/CKygS/qlc/Kw3YS
         pjatpgLOfn3Cu3HNCT/TtkjDINd7JUZXOb30yInHXnJl8VW17Kv8YjoDODNNzGt7Qevh
         ugzsjlpOF6J6hViLH++2g2bbTnMMQFlM92vTQqUqGbnHrWocmlMEyxnqSyMKIhw/bBws
         DxnvLeglEDl/o68k4OpR1qb+bl8aEvSGA2FAs2ycGBmqz3EJ/4fF7EYrv4HNC5IZqT5Z
         aI0+eFcUNX8e1thRnbMdMI1pI89HLbYyUdVCuhTYl3YRbLcCPaaBJ7rROjwKu5mPFeKw
         /F4w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768224568; x=1768829368; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jaGuPXqFXeyZwxS5wActQiEFDVDRQPMhfrfAWEZUdIY=;
        b=XhnzU/OazUV0/DISFr0GHJ+waTpgosZSjtk093b+5BKr+7lBd+gd2X1kwkAI7+2uEK
         4ZOI8KqpXTaomRaQ0nXCk8d1EnNL1rKWEl7n9jC733FniDOhDprgoxq7AFs+08/x96Tl
         WlfFcRGgnrZN6z2Q1t5hyYHbMT40TuYrK8i2M0CSSHcWyVrjPUa6adfG19fPvesxNojy
         y9MiuOMv4mIqdmgn1cUgn2eiOhRZTDyNXXU2Ao/qwOSVh2suz3vCb22qoiIEaGfVMtp6
         61CQ2PfyQNXvFtXjsSDzWVQNPLnn1TiQDzzm4CdYPZL1pk2S+UtxjxRWZa/MwcGc6E3D
         QyKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768224568; x=1768829368;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jaGuPXqFXeyZwxS5wActQiEFDVDRQPMhfrfAWEZUdIY=;
        b=aWHxrU7n7ic/Ky2tsBIPdGIQpVcbTMaecp4YvyiokZp/cD68FhiO6GxW3goLWMBjq4
         jC30B0cy1tOOwiAYGJc5ufe+uf7sJo2qCokIV1OAvcKM823cDOV2oJ2xM24pwkrJeMH1
         xZYHgsbmXprEx5Mnph1xflJ+urDC95I7aqKIH4rrq2vSCJ9KeF9dEB/yJnUBugEKgEle
         JN2QcCmvdGUqVKbcLUtPCwFuGkIcuxvCvVJGWOg/Be4xb2dDVl7Ow2ShVLHdd2d8OTp+
         PFCaFWu1QQMuQBIukSSOzjSfbpG8d0d65Wk8KTBnbz9MQt839jBF0rCyxWfLUEabXc1x
         RcBA==
X-Forwarded-Encrypted: i=1; AJvYcCU3hxnXyR78z0dCgXa6UHizsVlhMPlZaHafyvyWWAIP+r7FT8bcSrgsWaOE3UGWH1XuIjg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyk+JA/sUVaaSUriQaJkuJuOIpIl4FI46k9m5siTqnHZr3gnFkP
	v/fQLo0WPP/Ksdu6i2AR3UOuQRtKi/Lj60IfLN1cjTjBU6cIpbvhAH4hJMoG7SOZV2j0wa1qajG
	+SHFI7xS4kyuqDVZ3SWBwYb/843WHxQenpYK62JWI
X-Gm-Gg: AY/fxX6KP7Hb8HQ0N7gDwXbNJfmcPTjUT89qWPJ69e9W1v7NKvyEQW8hrbcLk5v8FrO
	ce0GWG1JV9HEgh75iUQAsBHeBm2zzzc1c5vfTz77GgB2ddR3tq7pNhC/nfYfTsVJMPtYHNB7w4P
	8hr4bnvKUSTadNDVfuyLc66Z4hcviaSex3jnjDaiRKmcnOi1d6fd2Ur6wP59vOwho4jzb8g6orJ
	P+ue2vUoUOevgCbAhNUUbKyhTJFRdbo255R4vmhjqFMq3u+O3D4Y7cPBDe6u7vWCbkEY2M3
X-Received: by 2002:ac8:5891:0:b0:4ff:bfdd:3f46 with SMTP id
 d75a77b69052e-5011979b086mr18062621cf.15.1768224567393; Mon, 12 Jan 2026
 05:29:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org>
 <20251223-kvm-arm64-sme-v9-14-8be3867cb883@kernel.org> <CA+EHjTw-6-BFcr60+tgDzOE-OfcetD7yQtbNMkqr7BgiMXfeJA@mail.gmail.com>
 <96efc90e-bf1f-4b87-ab7b-0e24970eb967@sirena.org.uk>
In-Reply-To: <96efc90e-bf1f-4b87-ab7b-0e24970eb967@sirena.org.uk>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 12 Jan 2026 13:28:51 +0000
X-Gm-Features: AZwV_Qhr0cnxEyY0NvApe2jyI_fTASUjPe1TmX1ATOL61XV_IRaHe4gUVPwKxys
Message-ID: <CA+EHjTxQUADWmCbSgUiFcXz_BxDPLE+THHnF6Mwx73hnhc7OJw@mail.gmail.com>
Subject: Re: [PATCH v9 14/30] KVM: arm64: Implement SME vector length configuration
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>, 
	Eric Auger <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 12 Jan 2026 at 13:27, Mark Brown <broonie@kernel.org> wrote:
>
> On Fri, Jan 09, 2026 at 03:59:00PM +0000, Fuad Tabba wrote:
> > On Tue, 23 Dec 2025 at 01:22, Mark Brown <broonie@kernel.org> wrote:
>
> > > +
> > > +#define vcpu_cur_sve_vl(vcpu) (vcpu_in_streaming_mode(vcpu) ? \
> > > +                              vcpu_sme_max_vl(vcpu) : vcpu_sve_max_vl(vcpu))
>
> > nit: This isn't really the current VL, but the current max VL. That
> > said, I don't think 'cur_max` is a better name. Maybe a comment or
> > something?
>
> It is the current VL for the hypervisor and what we present to
> userspace, EL1 can reduce the VL that it sees to something lower if the
> hardware supports that but as far as the hypervisor is concerned the VL
> is always whatever is configured at EL2.  We can obviously infer what
> the guest is doing internally but we never really interact with it.  The
> existing code doesn't really have a concept of current VL since with SVE
> only the hypervisor set VL is always the SVE VL, it often refers to the
> maximum VL when it means the VL the hypervisor works with.
>
> > > +       if (WARN_ON(vcpu->arch.sve_state || vcpu->arch.sme_state))
> > > +               return -EINVAL;
> > > +
>
> > Can this ever happen? kvm_arm_vcpu_vec_finalized() is checked above,
> > and vcpu->arch.{sve,sme}_state are only assigned in
> > kvm_vcpu_finalize_vec() immediately before setting the finalized flag.
>
> I don't expect it to, hence why it's a WARN_ON.

I understand. My point is, by code inspection we can demonstrate that
this isn't needed.

Cheers,
/fuad

