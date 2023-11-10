Return-Path: <kvm+bounces-1407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C8417E7671
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 02:14:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11E5A2816DB
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 01:14:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD859EA0;
	Fri, 10 Nov 2023 01:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZOf4mzZk"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B9B7F1
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 01:14:07 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA4C3C19
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 17:14:07 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a7cc433782so20601107b3.3
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 17:14:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699578846; x=1700183646; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lrQ+gxpnjkKgi3JxYTT73SI9ToeZhNDb+Kb3YH/r30w=;
        b=ZOf4mzZkwVI5ykeDpPXjgoT7d/zNG+Cy4vNkCWrcDLBfsHlMh2aq/hXfZecoFxZkU8
         xJ+XUur/T07N4oA0oRlS2WbjjrEquGIaIy37LTD7WkJfwNa5KU4DgICYQGn9PgnrIFoE
         f3huelu1RzJV2vl+c7G5qgTNBtWOGdXKyeYjlVqK1/R4t2+5b5eg145Daa6SRTHz6L+e
         7xAL7SH+1vR3ECwWkTTSYMKlGcsSDX5F08XQqLflTOye2+/ZShEoI18eNBPPvibVUoXq
         Mb5Z4QmVkFy7B+w31GjRZw5exkI2KNUmSUXYf8wVLzb6rNMlGYJF4L82/qzOaR/9qi9B
         G14A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699578846; x=1700183646;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lrQ+gxpnjkKgi3JxYTT73SI9ToeZhNDb+Kb3YH/r30w=;
        b=EYtrDwPZNaJsXgOzLZubwnHtCQvjUdd84pHYk6XiLlGO0NNRxv2YSnVD1uelP/wzVa
         UfQWWDjQ653l4y6K+djy6anDyXx8dCu2uprLiMlFLLPMGONiCn7fUd2tTiZQIHBD4DB3
         mJyycajIBq6FwFzwsNoXHK6mRW5HFSdq/FzLfSO6aMoxj8jgAG44+/UCtBnl8md6XHzk
         QDjvc8YtmeQKwxFbqLE9s6QXZkms28Kelfj78eqKoGg8m+4RbIHn1xfpw/7hPl6qoQvv
         oiYknPnsiE1KOSG/GRApgeqJgYfSC+YcrKiIgmtSBUaST6qOfZvJ+UAVZdpKGTw0obnT
         DksA==
X-Gm-Message-State: AOJu0YzEkE/hKMpZx+dZJjaQhDaPHvHxoFmMURojDUgMr0bEbDk0PZDV
	uyJApB04O9CCgmyJ0ha/29qBLv/sUlA=
X-Google-Smtp-Source: AGHT+IGKWoeGsO4hriSx6DSWMVi29RAJ4A8gnoO4AttuaWGuavcDVTxU5cD+ixUslDVltoGGzYWeuPh1KAc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:102:b0:da3:723b:b2a4 with SMTP id
 o2-20020a056902010200b00da3723bb2a4mr170083ybh.7.1699578846684; Thu, 09 Nov
 2023 17:14:06 -0800 (PST)
Date: Thu, 9 Nov 2023 17:14:05 -0800
In-Reply-To: <ZU1-sTcb2fvU2TYZ@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231109180646.2963718-1-khorenko@virtuozzo.com>
 <CALMp9eQGqqo66fQGwFJMc3y+9XdUrL7ageE8kvoAOV6NJGfJpw@mail.gmail.com>
 <ZU1ua1mHDZFTmkHX@google.com> <CALMp9eTqdg32KGh38wQYW-fvyrjrc7VQAsA1wnHhoCn-tLwyYg@mail.gmail.com>
 <ZU1-sTcb2fvU2TYZ@google.com>
Message-ID: <ZU2D3f6kc0MDzNR5@google.com>
Subject: Re: [PATCH 0/1] KVM: x86/vPMU: Speed up vmexit for AMD Zen 4 CPUs
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Konstantin Khorenko <khorenko@virtuozzo.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Denis V. Lunev" <den@virtuozzo.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 10, 2023, Sean Christopherson wrote:
> On Thu, Nov 09, 2023, Jim Mattson wrote:
> > On Thu, Nov 9, 2023 at 3:42=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > > static inline bool pmc_is_eventsel_match(struct kvm_pmc *pmc, u64 eve=
ntsel)
> > > {
> > >         return !((pmc->eventsel ^ eventsel) & AMD64_RAW_EVENT_MASK_NB=
);
> > > }
> >=20
> > The top nybble of AMD's 3-nybble event select collides with Intel's
> > IN_TX and IN_TXCP bits. I think we can assert that the vCPU can't be
> > in a transaction if KVM is emulating an instruction, but this probably
> > merits a comment.
>=20
> Argh, more pre-existing crud.  This is silly, the vendor mask is already =
in
> kvm_pmu_ops.EVENTSEL_EVENT.  What's one more patch...

Ah, I see what your saying.  Checking the bits is actually correct, probabl=
y through
sheer dumb luck.  I'll expand the comment to cover that and the reserved bi=
ts.

