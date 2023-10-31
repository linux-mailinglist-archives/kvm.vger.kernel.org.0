Return-Path: <kvm+bounces-251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A3E5D7DD87D
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 23:40:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D50A91C20D1C
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 22:40:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32C4127469;
	Tue, 31 Oct 2023 22:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1K8ZS/bJ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD302744E
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 22:40:16 +0000 (UTC)
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91953118
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 15:40:14 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-4083740f92dso47905315e9.3
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 15:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698792013; x=1699396813; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dJWbuo+9TPVToDVPf96jeRxWUliwPBKXtZxQViTwJnU=;
        b=1K8ZS/bJ+GdgqaZUvAP2WwNROh7zVafE6rW0I41BI7g6Cuii9iWqj6tqLetfVQnuij
         mqrLEsygd5w8lFAbQgvkcROrnJCCEWMldrHP4O25qc38/KI1iGCpM4/wrvLPnGiRRjUy
         UET+n2k3pAZakVazyzGziZONC7dCPAfAWcn8RnZtvZvjJ74w7BjYg9SOd2E/VCWJsh/Q
         hjUqjy6DwE0Kw7wq3scIRWXIYCWNSNlnBFHdqI4GR7b6c9oH1dXwTcZ3eALS/mu/CWM4
         6h7c+KWgRKLbE/7nXwFViCsz1g/egULjDKcBBbXrfllPtyavfMqnz40g0XlTC3tuQAJS
         fXUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698792013; x=1699396813;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dJWbuo+9TPVToDVPf96jeRxWUliwPBKXtZxQViTwJnU=;
        b=iGZ4kv7Zki50AHIbTHJogSUwRzOLgOoJ0qUIvLAaKcAh/S4zcziR2HeuhoottrCCxQ
         bMyCDP8eKGUgkKGba6gfieLzA2/NKbDg6XMXXMxd2gAFj9aGGI4sPb30QUUV+nkIr1w/
         eT3wlkMtsBTJ3oC6kJsGXp/VvoK3pfjYtvigZ51XUYjMMhdTv7lkr6cTUpyQZCNLB3F/
         c0Zq53XUkiw/ZVL1paZfJ19eWrZFdHjFVYoCqRknzYJueMKwGzpiBuYgjOhY1RJnH47R
         Zs/q0IEa6PmM2XLp/yPHpfGsmSGwr5ICQkgH0umysCFUpqxUXntekdwoy3Zmg2H+YFJT
         C8AA==
X-Gm-Message-State: AOJu0Ywdqzwwz3aJLWO1hNoddL2IzXMkayZkwrgpTaZ7P/m0G95RK8EC
	GR9L7kPptyR3L5K0ihyoObLh5jL2sjE67PYIPdhEww==
X-Google-Smtp-Source: AGHT+IHkDiPkYLUipg1BNgD620eOceDAkQD+A32NnZclx+AVnVsN45AUMqsjx/qUof6Oj5kTmFWO4hEnjV9b1jDP2pc=
X-Received: by 2002:adf:d1ef:0:b0:32f:7db1:22fb with SMTP id
 g15-20020adfd1ef000000b0032f7db122fbmr8716023wrd.28.1698792012937; Tue, 31
 Oct 2023 15:40:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-17-seanjc@google.com>
 <ZUFGRyQEuWj4RJS0@google.com> <ZUFzZf-YmCRYP6qo@google.com>
In-Reply-To: <ZUFzZf-YmCRYP6qo@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 31 Oct 2023 15:39:42 -0700
Message-ID: <CALzav=d9eXZfK=op7A=UftbpuPpUbxqV6CmkqqxxBNuNsUU4nw@mail.gmail.com>
Subject: Re: [PATCH v13 16/35] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
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

On Tue, Oct 31, 2023 at 2:36=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> On Tue, Oct 31, 2023, David Matlack wrote:
> > On 2023-10-27 11:21 AM, Sean Christopherson wrote:
> > > Introduce an ioctl(), KVM_CREATE_GUEST_MEMFD, to allow creating file-=
based
> > > memory that is tied to a specific KVM virtual machine and whose prima=
ry
> > > purpose is to serve guest memory.
>
> > Maybe can you sketch out how you see this proposal being extensible to
> > using guest_memfd for shared mappings?
>
> For in-place conversions, e.g. pKVM, no additional guest_memfd is needed.=
  What's
> missing there is the ability to (safely) mmap() guest_memfd, e.g. KVM nee=
ds to
> ensure there are no outstanding references when converting back to privat=
e.
>
> For TDX/SNP, assuming we don't find a performant and robust way to do in-=
place
> conversions, a second fd+offset pair would be needed.

Is there a way to support non-in-place conversions within a single guest_me=
mfd?

