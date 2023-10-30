Return-Path: <kvm+bounces-125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CC607DBFC8
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 19:22:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBB6C2815C4
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 18:22:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB3BD19BB1;
	Mon, 30 Oct 2023 18:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="evnelxo6"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6306319BA7
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 18:22:11 +0000 (UTC)
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14651B9
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 11:21:44 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-40837ebba42so32157035e9.0
        for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 11:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698690100; x=1699294900; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+/9ggluaJ++InohprDPxvdU7Uw478trPLaD3bhLrtl4=;
        b=evnelxo6BHvIfCZLkH2HljZAClVdE9ks4A0+VrbC9RPeA11urFDr2tenj96AWZwyAh
         DNKriGKjs9z0/Hk0iHZ0UUznlW7GwojmeUQiLnk94LmHovwxp7wxg2l7CYsRx1SpCGFv
         pt3EXezQdlu6PGaOfE1jrpG0yuNNjiMI9gr9GDTgXE3MLzq9zulE+JC6y4uKSSnluXR/
         QMCW4L/fWQzumgtidJ2PxovL03srHOZS+U+lRsLxX6zbILHMPnqfBJeIjteHqxv9Oxyn
         8p0gUE7P6cWiwtideNc5db/5PLVCeUnyqICIf+JlPh0ZwsKZQBMRxrpeLPVSO3XCEyHA
         YsGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698690100; x=1699294900;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+/9ggluaJ++InohprDPxvdU7Uw478trPLaD3bhLrtl4=;
        b=roox4E7G3Q++rr65ktYEnnltEmNXDmfd6r3YRUKJ9j7rmBCNjTt5+5bPBnGwLXI2zk
         0dIvz47I5DJk81YAgE3FrHHla3Ypfytq8M4t1L+liHW3xpWwhwmOSQ9C8P0bCDNRSaQO
         WeqGc6xOsXiaJIg59BBZ4qhVoTBeX3UiKLt+UDgV1c1B3ynSgTTyG4wm4V7szOB0dOxJ
         9TvkrfJl4ksybDa/YH3XMLA7hz26KKxzFPkHbkenitLjJxSeT20K6nisZFce1LEzZwk4
         nNqLRTMzPgtjGKZO8GPWJg2VQbZifokFh5I62GY4Rc2/UpNohRFGVcFFY6cDawNgWY/6
         7zJQ==
X-Gm-Message-State: AOJu0YzwKDh0Yg5mgTkkqtQInVwO7t4V3ig80igVRQbF1gjOGamhhjOM
	WfLFj799ZSY8nnq1UFMoC4aMKIpHLYxWWRuB5wiN3w==
X-Google-Smtp-Source: AGHT+IEmwHEAyRl4O1ADBUXlJ8Ir1QajxdHcmQhP1+JwZ6AL7EQf1l2WpAn/vfiQDkHuuhxFizw+5mWU1UT2yp1CF+k=
X-Received: by 2002:a05:600c:524a:b0:408:4160:1528 with SMTP id
 fc10-20020a05600c524a00b0040841601528mr8760818wmb.30.1698690100370; Mon, 30
 Oct 2023 11:21:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-4-seanjc@google.com>
 <ZT_fnAcDAvuPCwws@google.com> <CABgObfYM4nyb1K3xJVGvV+eQmZoLPAmz2-=1CG8++pCwvVW7Qg@mail.gmail.com>
In-Reply-To: <CABgObfYM4nyb1K3xJVGvV+eQmZoLPAmz2-=1CG8++pCwvVW7Qg@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 30 Oct 2023 11:21:12 -0700
Message-ID: <CALzav=djOS8T7AmUa3A7QmP1f0xAm2W-KRDmOov_H8ps77A2qA@mail.gmail.com>
Subject: Re: [PATCH v13 03/35] KVM: Use gfn instead of hva for mmu_notifier_retry
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Xu Yilun <yilun.xu@intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Anish Moorthy <amoorthy@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Vlastimil Babka <vbabka@suse.cz>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 30, 2023 at 10:01=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.com=
> wrote:
>
> On Mon, Oct 30, 2023 at 5:53=E2=80=AFPM David Matlack <dmatlack@google.co=
m> wrote:
> >
> > On 2023-10-27 11:21 AM, Sean Christopherson wrote:
> > > From: Chao Peng <chao.p.peng@linux.intel.com>
> > >
> > > Currently in mmu_notifier invalidate path, hva range is recorded and
> > > then checked against by mmu_notifier_retry_hva() in the page fault
> > > handling path. However, for the to be introduced private memory, a pa=
ge
> >                           ^^^^^^^^^^^^^^^^^^^^^^^^
> >
> > Is there a missing word here?
>
> No but there could be missing hyphens ("for the to-be-introduced
> private memory"); possibly a "soon" could help parsing and that is
> what you were talking about?

Ah that explains it :)

>
> > >       if (likely(kvm->mmu_invalidate_in_progress =3D=3D 1)) {
> > > +             kvm->mmu_invalidate_range_start =3D INVALID_GPA;
> > > +             kvm->mmu_invalidate_range_end =3D INVALID_GPA;
> >
> > I don't think this is incorrect, but I was a little suprised to see thi=
s
> > here rather than in end() when mmu_invalidate_in_progress decrements to
> > 0.
>
> I think that would be incorrect on the very first start?

Good point. KVM could initialize start/end before registering
notifiers, but that's extra code.

