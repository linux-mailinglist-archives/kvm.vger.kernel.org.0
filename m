Return-Path: <kvm+bounces-4371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D45AD811ACF
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 18:21:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 744C41C211FA
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 17:21:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0C1A5646E;
	Wed, 13 Dec 2023 17:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QX5FBp6j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44E3D5
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 09:21:15 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-dbcd4696599so705882276.1
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 09:21:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702488075; x=1703092875; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AUER+D4xe6qS+B1oKWs50YXOCoyXjBc3WM+/yGcEVoE=;
        b=QX5FBp6jzLZh5gCBAy2h22nqyENcL1EB0kJ6BPSIS6XmNIWrAL81u6cc59Im04Jyqq
         3vUYKZJsGlaLxdzw5y59C4uIAyaCCkLr5ectb/2dcWVoXfhmCWy5WSQ4u1pFakISSTZd
         qB7c1oBpTT6WZYCS50ohGRS14xxOLVEVRTDpKmYzCm8QsGxE75jWUH4Onj0pHkaUW9rz
         bikNqc27HabAtCTJ9sKNkC40++VJDl8yaxhylNyQ0SUv0to/Frb7Zi4YDNx7XTHjLYT2
         CFr+DrWgfS0BOpEUx/PDVD7vdkZqbPQk7AnKYyAU1+Uv6D0IM1vv17W5cA/QvsyTsQHF
         eWpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702488075; x=1703092875;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AUER+D4xe6qS+B1oKWs50YXOCoyXjBc3WM+/yGcEVoE=;
        b=vMlzNTr5bKmYbk4RWEqILiBKLFM4LJA8oh3DbuoKVWIfsxBpTzKK6vWX/j1eegyt8E
         6K9mEADRaB9vQrYsTOp3a6ga1YTJouclDuxPGLaFJLKnZFn1AAuX6ft9SMEVJITgQOAm
         odG1+U8lkLRxqQJbYGYQ5UfmPc4Nn9PPxVO6WOoVfgt9n7WwzHL6bRCPE4nx9Qc4VBe4
         MqCY0o4dmXBAZVXnUkXTObJbzZq3aGDvacAVzq0UC0vZuE/+sbNSBmcn5JDNMvZbzJ3s
         4Mw598s5k9j1KNaEhwm+/huDnl2w0SXdNKx5QJodRq9ieCxbznOU4V3cOWqBPA8u/75d
         oxug==
X-Gm-Message-State: AOJu0Yw9kS13ZS25rAg5C0aEwU67fQjPrH79Xw4u12f1VWUML2HbHzlW
	jugPr5nC3KiWwQY3gvdBJPKoFbyb5yM=
X-Google-Smtp-Source: AGHT+IHxxvfKb7sYphqiEH80MgNn6no+WlSe6mwkjghyGVLAhz51UUraQXN2vSCIrd3Mg+DzJsjQQlvELHM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:150:b0:da0:3da9:ce08 with SMTP id
 p16-20020a056902015000b00da03da9ce08mr91009ybh.10.1702488074979; Wed, 13 Dec
 2023 09:21:14 -0800 (PST)
Date: Wed, 13 Dec 2023 09:21:13 -0800
In-Reply-To: <184e253d-06c4-419e-b2b4-7cce1f875ba5@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231208184628.2297994-1-pbonzini@redhat.com> <ZXPRGzgWFqFdI_ep@google.com>
 <184e253d-06c4-419e-b2b4-7cce1f875ba5@redhat.com>
Message-ID: <ZXnoCadq2J3cPz2r@google.com>
Subject: Re: [PATCH] KVM: selftests: fix supported_flags for aarch64
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Shaoqin Huang <shahuang@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 12, 2023, Paolo Bonzini wrote:
> On 12/9/23 03:29, Sean Christopherson wrote:
> > On Fri, Dec 08, 2023, Paolo Bonzini wrote:
> > > KVM/Arm supports readonly memslots; fix the calculation of
> > > supported_flags in set_memory_region_test.c, otherwise the
> > > test fails.
> > 
> > You got beat by a few hours, and by a better solution ;-)
> > 
> > https://lore.kernel.org/all/20231208033505.2930064-1-shahuang@redhat.com
> 
> Better but also wrong---and my patch has the debatable merit of more
> clearly exposing the wrongness.  Testing individual architectures is bad,
> but testing __KVM_HAVE_READONLY_MEM makes the test fail when running a new
> test on an old kernel.

But we already crossed that bridge and burned it for good measure by switching
to KVM_SET_USER_MEMORY_REGION2, i.e. as of commit

  8d99e347c097 ("KVM: selftests: Convert lib's mem regions to KVM_SET_USER_MEMORY_REGION2")

selftests built against a new kernel can't run on an old kernel.  Building KVM
selftests requires kernel headers, so while not having a hard requirement that
the uapi headers are fresh would be nice, I don't think it buys all that much.

If we wanted to assert that x86, arm64, etc. enumerate __KVM_HAVE_READONLY_MEM,
i.e. ensure that read-only memory is supported as expected, then that can be done
as a completely unrelated test.

IMO, one of the big selling points of selftests over KUT is that we can punt on
supporting old kernels since selftests are in-tree.  I don't think it's at all
unreasonable to require that selftests be built against the target kernel, and
by doing so we can signficantly reduce the maintenance burden.  The kernel needs
to be backwards compatibile, but I don't see why selftests need to be backwards
compatible.

