Return-Path: <kvm+bounces-786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8490B7E2962
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 17:04:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 24381B21119
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 16:04:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B293F2940E;
	Mon,  6 Nov 2023 16:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wFpslrgm"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87B228E3B
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 16:04:23 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33355D4C
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 08:04:20 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5ae5b12227fso64364867b3.0
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 08:04:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699286659; x=1699891459; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vBcfSXW+7b0RYZr/CwodaGuIC1t2rSK8z82L7NdJqdg=;
        b=wFpslrgmIgIbaZOnLmqhhsJ9lDbgt0QTYXsM/t9b7FrC5cgpaymNsWQX/WWEoi7FQr
         E/bE/k+zCfeCsDQ6kp5smusq2Mr+EUiKnNmREGKBUaW+YC3SO+yS8VAGYnKZsvJ77fOE
         fMAnL0JHqR6sUtdNJjBm8Aik+fy2iGwNJW9rhJx2SBQ4S4UM5m/tLtDrWXuhjn3+ZHrm
         06Afvfng0cn8QBQcKGDsPnW+8DCJJpE4VHZCoiIaWRFxleb/9ugM75rY0RRFQSVvHZYx
         CeVPu3Fh483VCoEqrQSAnCd1jwLIhpCHNNho6qiGzNqwXXphlYb7mMh8JmrGlazciaNh
         sIWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699286659; x=1699891459;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vBcfSXW+7b0RYZr/CwodaGuIC1t2rSK8z82L7NdJqdg=;
        b=eeKcugwKk/M0BeQtZkIGNk47yS4A0d7hE9m5lY6bJrl9hPWXmK6Z1bratJF+A8CSpq
         yiVbAAIgLAOgvssM6tlEcg9tGGpeoElT9F0q9MquaUEXK9Av6N8L3u+qjOSKwkaL2ZhN
         8+QvkTyCSmx/P80muxF2AzViZYiSaIFfw1E3mA0oo1zm6y2AUE4tty7QCyv0EHCNvQ5L
         jzZuBQFFc3AvORM+iAeSM2k8Tj1l+bBGril6Dy3YohiP9yOAr3ceRYLIBLmkK76BJ17C
         pa9p2NlsDPjBjVVW0ei6GIQRvDIoItnTYSUBVbgY6d2Kl1jRwVoCVH78zo7T0v8qIBbr
         MOxw==
X-Gm-Message-State: AOJu0YzzIYlkc+rxgwMg3y+k+oNoZEt8BfxzlE+EhA6Udf446UAx9Kvy
	nPPZn+NmuRCnJGfC6/JgcTu0kWM76H0=
X-Google-Smtp-Source: AGHT+IG4M/eznhqFxpL/eWUumIXP2aANvxiOg95OzhM2lh4aiDVuodrpXWON7UbLhWxQPiRYqqCoKKt9NcE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:830d:0:b0:5a8:6162:b69 with SMTP id
 t13-20020a81830d000000b005a861620b69mr214046ywf.3.1699286659321; Mon, 06 Nov
 2023 08:04:19 -0800 (PST)
Date: Mon, 6 Nov 2023 08:04:17 -0800
In-Reply-To: <CA+EHjTxz-e_JKYTtEjjYJTXmpvizRXe8EUbhY2E7bwFjkkHVFw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231105163040.14904-1-pbonzini@redhat.com> <20231105163040.14904-28-pbonzini@redhat.com>
 <CA+EHjTxz-e_JKYTtEjjYJTXmpvizRXe8EUbhY2E7bwFjkkHVFw@mail.gmail.com>
Message-ID: <ZUkOgdTMbH40XFGE@google.com>
Subject: Re: [PATCH 27/34] KVM: selftests: Introduce VM "shape" to allow tests
 to specify the VM type
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
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
	Jarkko Sakkinen <jarkko@kernel.org>, Anish Moorthy <amoorthy@google.com>, 
	David Matlack <dmatlack@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=" <mic@digikod.net>, Vlastimil Babka <vbabka@suse.cz>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, David Hildenbrand <david@redhat.com>, 
	Quentin Perret <qperret@google.com>, Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 06, 2023, Fuad Tabba wrote:
> On Sun, Nov 5, 2023 at 4:34=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com=
> wrote:
> >
> > From: Sean Christopherson <seanjc@google.com>
> >
> > Add a "vm_shape" structure to encapsulate the selftests-defined "mode",
> > along with the KVM-defined "type" for use when creating a new VM.  "mod=
e"
> > tracks physical and virtual address properties, as well as the preferre=
d
> > backing memory type, while "type" corresponds to the VM type.
> >
> > Taking the VM type will allow adding tests for KVM_CREATE_GUEST_MEMFD,
> > a.k.a. guest private memory, without needing an entirely separate set o=
f
> > helpers.  Guest private memory is effectively usable only by confidenti=
al
> > VM types, and it's expected that x86 will double down and require uniqu=
e
> > VM types for TDX and SNP guests.
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > Message-Id: <20231027182217.3615211-30-seanjc@google.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
>=20
> nit: as in a prior selftest commit messages, references in the commit
> message to guest _private_ memory. Should these be changed to just
> guest memory?

Hmm, no, "private" is mostly appropriate here.  At this point in time, only=
 x86
supports KVM_CREATE_GUEST_MEMFD, and x86 only supports it for private memor=
y.
And the purpose of letting x86 selftests specify KVM_X86_SW_PROTECTED_VM, i=
.e.
the reason this patch exists, is purely to get private memory.

Maybe tweak the second paragraph to this?

Taking the VM type will allow adding tests for KVM_CREATE_GUEST_MEMFD
without needing an entirely separate set of helpers.  At this time,
guest_memfd is effectively usable only by confidential VM types in the
form of guest private memory, and it's expected that x86 will double down
and require unique VM types for TDX and SNP guests.

