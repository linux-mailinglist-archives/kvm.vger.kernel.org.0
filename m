Return-Path: <kvm+bounces-124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36B1B7DBFA7
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 19:20:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CD0EBB20D5B
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 18:20:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0099D19BCE;
	Mon, 30 Oct 2023 18:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vMBjNLJL"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FB319BAA
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 18:20:16 +0000 (UTC)
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE33BC2
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 11:20:14 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2c509d5ab43so69925011fa.0
        for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 11:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698690013; x=1699294813; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EYDArYAPbuwvLuQnLMgYzD5G3hQJ3JuyTKb70j8k5kM=;
        b=vMBjNLJLnNwZ92n0kiLKy/KDvv6bmRWazPVY7EzuCAXijQXOd/L6nvrX2ZWXjw+lNq
         4G5yJaJPhMqxsSmWmQroKSm+2R3tkccCRs0o978wCj0l5sy5+qU6vjM8CCHZZW53vydq
         p5Q03CC8DatEWTV07ALKn+wiFR2o2FRnMzJbqLuMgJ2Ub5QuR13k3/n1s73F50qjfkJW
         jYiv09MpMPkZEbaNGpQQ9n6vWpNk1OHs0sffooFU3t8jPASRTjzGdPCT9bTwlS4yKF0n
         0udHFnJONG3fQytXR4K5Q+c/1vSUxumJ6xHiwhVUu+7gs9M3D3ejbpd+PQJLXSO5jHDJ
         abyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698690013; x=1699294813;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EYDArYAPbuwvLuQnLMgYzD5G3hQJ3JuyTKb70j8k5kM=;
        b=GhkNCih+KpnLKJU4A+qrIjY2BGIQAGHRJrNP9uU6S1I66/89nBFsAjbPILi9UfrhHv
         PlE0H6odGrL8GRNu9G50XQgdbfjTfdja+LycjauffJWLV1wtkveOQn6etuckJLjM3yI3
         ZI1O/orjNCaXt7Z0vbiHmLb/f3TTJEkZc4uR1FoCN0QeDiNOD62V+w3FN2TtITgKEwYD
         k+jVL7dxQ870u8Hlhhzr1ycJORglRaV1eX0L8968bKlDyvXc4QyS9kkFAZ6PGKf6ZLhx
         jMmJ/j3lCMGb2D7rkJMLziX8UDliIV6F+R9Cm649jSK1hhWU+JhqltH1OpxCs8b3EDWp
         tSOw==
X-Gm-Message-State: AOJu0Yzj7x+/5ADwmGJm1rbbrlLNbB04fDCB6BIPZxVpM4WEXSI3PzP6
	GjB/SK16hlVy1BozzP+Ba1zGGDvr+8awgDsiouOYAg==
X-Google-Smtp-Source: AGHT+IGWQtTaV5Bzkdlkn1e/3Zt5UNsfNX/Ijo670f/udb747Y9rnFPe4I+UgnAkk/OF+ECMZnUUXa4ItRfh9V5jdaA=
X-Received: by 2002:a05:6512:10cb:b0:507:aaa9:b080 with SMTP id
 k11-20020a05651210cb00b00507aaa9b080mr9836391lfg.33.1698690012887; Mon, 30
 Oct 2023 11:20:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-4-seanjc@google.com>
 <ZT_fnAcDAvuPCwws@google.com>
In-Reply-To: <ZT_fnAcDAvuPCwws@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 30 Oct 2023 11:19:43 -0700
Message-ID: <CALzav=cjq_MbJgi3DMytVWwZLFxEPi1dp7YiBYRBw-sRf2+BLw@mail.gmail.com>
Subject: Re: [PATCH v13 03/35] KVM: Use gfn instead of hva for mmu_notifier_retry
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
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

On Mon, Oct 30, 2023 at 9:53=E2=80=AFAM David Matlack <dmatlack@google.com>=
 wrote:
>
> On 2023-10-27 11:21 AM, Sean Christopherson wrote:
> > From: Chao Peng <chao.p.peng@linux.intel.com>
> >
> > +void kvm_mmu_invalidate_range_add(struct kvm *kvm, gfn_t start, gfn_t =
end);
>
> What is the reason to separate range_add() from begin()?

Nevermind, I see how it's needed in kvm_mmu_unmap_gfn_range().

