Return-Path: <kvm+bounces-2202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 454EA7F3467
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 18:01:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 762D61C20AC2
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 17:01:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33F7958103;
	Tue, 21 Nov 2023 17:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Db909ZoJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0637112C
	for <kvm@vger.kernel.org>; Tue, 21 Nov 2023 09:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700586072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v93FwVXoTzkwCTHloTDbAyzgq12DcyzYpNvU8V0mZJE=;
	b=Db909ZoJYbcT2G6LLjfnci8yQDj6GeiSOnWmAa8m+VFijTu30q9djImk6aFIkpMgVdtS+Z
	c236IoYSFo0aEGPv7aYu++U66M0qv/B5ysNWiKeSjLp9LM0SBhlioFeP1Qc6bg1nFu6Qit
	IQjR/wgf7I/405DltkwXG0Kbe5KyMSs=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-497-Nb6h2uXDM4q_xBUfUAJC_A-1; Tue, 21 Nov 2023 12:01:09 -0500
X-MC-Unique: Nb6h2uXDM4q_xBUfUAJC_A-1
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-6d656fd896dso6402483a34.3
        for <kvm@vger.kernel.org>; Tue, 21 Nov 2023 09:01:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700586069; x=1701190869;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v93FwVXoTzkwCTHloTDbAyzgq12DcyzYpNvU8V0mZJE=;
        b=f/lKyoZAuDkAM6zH67OO7/4z4txyEY6uWYsx6n+xs/xkwjKEWFeZeNZRgpGdjD0qqM
         tg+vYhOXM1Y7f3ONnji80oUBHP8NvBso48Vhuk9YqBOPRTPuRSgrxghGPkzsFvAC1IrU
         1TlTxQC9HZhZdET3fJZNvx4JbfVDqH+d/ronW4qsnQnTvdGCX5jBF0oa4z7kj7Z0c/TA
         irJScnTSuOzN+emq9/ZleeXBj0XMsFJKuaGMBYUbONx2h+MkHT5mY/bWJibR7rh9SlSX
         3dZLb7fhaXsNFVeEa2hVVYRluDMKFWjSXa1woIDcQYVBCMem2zVFceIcYhhdaof62SE8
         Crzw==
X-Gm-Message-State: AOJu0YzqNJtUVv5fXz5r83LCkwGVkkhUaOJEJg1XdAWGh4kM8/9XSYQw
	9AYglkPBELwrTb8YtSBeZL+rP9gyarUORm0igTkZCNgLXqLqekM0+xwr49j+GyJrWBtQ7lmuByC
	6awOZEuU/zO3rQua5mIznkdHKutKU
X-Received: by 2002:a05:6358:7e47:b0:169:a9d4:3faf with SMTP id p7-20020a0563587e4700b00169a9d43fafmr12581510rwm.11.1700586069072;
        Tue, 21 Nov 2023 09:01:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHzwqwXTcQOMVq6+W/ToO1AFQnqdGCzNKV3DK3CezCKFyIOZTTVBddsfYxnVHAme/q2N84DW6rxhPtI5xPi31c=
X-Received: by 2002:a05:6358:7e47:b0:169:a9d4:3faf with SMTP id
 p7-20020a0563587e4700b00169a9d43fafmr12581454rwm.11.1700586068588; Tue, 21
 Nov 2023 09:01:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231105163040.14904-1-pbonzini@redhat.com> <20231105163040.14904-35-pbonzini@redhat.com>
 <CAF7b7mpmuYLTY6OQfRRoOryfO-2e1ZumQ6SCQDHHPD5XFyhFTQ@mail.gmail.com> <13677ced-e464-4cdb-82ae-4236536e169c@sirena.org.uk>
In-Reply-To: <13677ced-e464-4cdb-82ae-4236536e169c@sirena.org.uk>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 21 Nov 2023 18:00:56 +0100
Message-ID: <CABgObfZdk9Jn60QLJGweVZMN_yWsxo1d7W3Mu-NNTPZVO0uCnw@mail.gmail.com>
Subject: Re: [PATCH 34/34] KVM: selftests: Add a memory region subtest to
 validate invalid flags
To: Mark Brown <broonie@kernel.org>
Cc: Anish Moorthy <amoorthy@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Sean Christopherson <seanjc@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Xu Yilun <yilun.xu@intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	David Matlack <dmatlack@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Vlastimil Babka <vbabka@suse.cz>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 20, 2023 at 3:09=E2=80=AFPM Mark Brown <broonie@kernel.org> wro=
te:
>
> On Wed, Nov 08, 2023 at 05:08:01PM -0800, Anish Moorthy wrote:
> > Applying [1] and [2] reveals that this also breaks non-x86 builds- the
> > MEM_REGION_GPA/SLOT definitions are guarded behind an #ifdef
> > __x86_64__, while the usages introduced here aren't.
> >
> > Should
> >
> > On Sun, Nov 5, 2023 at 8:35=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.c=
om> wrote:
> > >
> > > +       test_invalid_memory_region_flags();
> >
> > be #ifdef'd, perhaps? I'm not quite sure what the intent is.
>
> This has been broken in -next for a week now, do we have any progress
> on a fix or should we just revert the patch?

Sorry, I was away last week. I have now posted a patch.

Paolo


