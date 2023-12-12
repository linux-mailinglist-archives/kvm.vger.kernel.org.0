Return-Path: <kvm+bounces-4216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4302280F446
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 18:18:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 43FBDB20EC7
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 17:18:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F20E7B3DC;
	Tue, 12 Dec 2023 17:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rAdRlyB4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB419F
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 09:18:16 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-dbcc8f895daso139570276.2
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 09:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702401496; x=1703006296; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AYZqQZ0C1vTq1Q5ZgORnfs0Fnsc+4+uug2eKsahCD6s=;
        b=rAdRlyB49LqjGc2UkgdDCZMJ8AJtP3agvepRBHQCjSXAP65azbwRkNSC55KcfsYZpl
         /wt56DVAKCZFKM62GxbPuGi8EWezBlnOWQq4z9sPtme7hloMB2vRTRdG6yFRxOvMbzg4
         xDQdyJM8KTn1KD47ckKUU58YUnXyC56PoPIHf1vCeSbaIlyp0+cGNKs+BpE20QNWZsFV
         Is10v1qxaGf91lD0hTTclv74sZOKHfabDVvcbBWm8EweIsf5ip187o/csHRc8LBNrMSr
         kp1alQp02PZtC1MVIJI/bXA5e3qPdZNMsb+ORh5ShLMxhSGOYFYKMOP0fP9nG2ABcQLq
         r8Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702401496; x=1703006296;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AYZqQZ0C1vTq1Q5ZgORnfs0Fnsc+4+uug2eKsahCD6s=;
        b=CTad6I8yP8LTfHz+DBrI9uv/7pDfGsrCan9GLaXuL5Au8pW1R77imPPGKtXvRoEYPX
         nT5vPqFmoyTE87KvS6IQYuAWNSpzImDqsk0oZ4n62YQVeGkqseMlgxHSvPDy+Umi6pDf
         ZXXEqLfouwUQ173vqLgo37gF1yOvHacKNRmnKDE3eJ4JVVGKqN8TTT6bDrApVNq1hYli
         YzfmE7K6w/C5w4XElgrQ8UiRqq2+x30sgwBJ1p+vv+zMzgHOXpli7UaucJxFPFl+DZPu
         K3V3R/iWM3kfHqFL5TVrZ6wkFj55NSvJ6OHz5Pr4XMGMJF3WkneblcPBinQLy54jCITl
         awWg==
X-Gm-Message-State: AOJu0YySIW/hYkbJtdzPVHdBuJT02vZMrilFVGjfSizePWk24+qoSeLj
	8QihF7qv1sqp3thEfC0hn0p8vBWYTME=
X-Google-Smtp-Source: AGHT+IECIs8G3jM2WZyRE4oWJhjBQvPB3/u39KEvPcuAITAWFWLvSUfQ0hYgQ8mlsjkrjvzsZAZLs8GXAU0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:150:b0:da0:3da9:ce08 with SMTP id
 p16-20020a056902015000b00da03da9ce08mr64114ybh.10.1702401495879; Tue, 12 Dec
 2023 09:18:15 -0800 (PST)
Date: Tue, 12 Dec 2023 09:18:14 -0800
In-Reply-To: <e40d3884-bf39-8286-627f-e0ce7dacfcbe@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231130111804.2227570-1-zhaotianrui@loongson.cn>
 <20231130111804.2227570-2-zhaotianrui@loongson.cn> <e40d3884-bf39-8286-627f-e0ce7dacfcbe@loongson.cn>
Message-ID: <ZXiV1rMrXY0hNgvZ@google.com>
Subject: Re: [PATCH v5 1/4] KVM: selftests: Add KVM selftests header files for LoongArch
From: Sean Christopherson <seanjc@google.com>
To: zhaotianrui <zhaotianrui@loongson.cn>
Cc: Shuah Khan <shuah@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Vishal Annapurve <vannapurve@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev, 
	Peter Xu <peterx@redhat.com>, Vipin Sharma <vipinsh@google.com>, maobibo@loongson.cn
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 12, 2023, zhaotianrui wrote:
> Hi, Sean:
>=20
> I want to change the definition of=C2=A0 DEFAULT_GUEST_TEST_MEM in the co=
mmon
> file "memstress.h", like this:
>=20
>  /* Default guest test virtual memory offset */
> +#ifndef DEFAULT_GUEST_TEST_MEM
>  #define DEFAULT_GUEST_TEST_MEM		0xc0000000
> +#endif
>=20
> As this address should be re-defined in LoongArch headers.

Why?  E.g. is 0xc0000000 unconditionally reserved, not guaranteed to be val=
id,
something else?

> So, do you have any suggesstion?

Hmm, I think ideally kvm_util_base.h would define a range of memory that ca=
n be
used by tests for arbitrary data.  Multiple tests use 0xc0000000, which is =
not
entirely arbitrary, i.e. it doesn't _need_ to be 0xc0000000, but 0xc0000000=
 is
convenient because it's 32-bit addressable and doesn't overlap reserved are=
as in
other architectures.

