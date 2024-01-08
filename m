Return-Path: <kvm+bounces-5814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 48E46826F35
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 14:04:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B81A7B21F1C
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 13:04:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FCA24121F;
	Mon,  8 Jan 2024 13:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="axYDKSpE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDCF40C1F
	for <kvm@vger.kernel.org>; Mon,  8 Jan 2024 13:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704719084;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K16gTYHcW3R+U7Fg39fSoUOy5CumITmRVkwMwFkvd8c=;
	b=axYDKSpE9ulrLvUXrxXboZtxdtDGX5hQvNZ53AzQJoGdoR1wmjAExQ+LzKx2SITPWeV4zE
	lA0zdk1qUGG9dD2F67klhrkMZ9tJlx7psYSu3+HlMcoCkHrvEmQuou84OElze0PMuDWU4L
	uw9Yi4KC8xgoAF0eI44xOt9c0yD0zMk=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-399-1coYHBdSPBiPeFJ1pmm4OQ-1; Mon, 08 Jan 2024 08:04:43 -0500
X-MC-Unique: 1coYHBdSPBiPeFJ1pmm4OQ-1
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-6dc0213a3d4so1785874a34.2
        for <kvm@vger.kernel.org>; Mon, 08 Jan 2024 05:04:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704719082; x=1705323882;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K16gTYHcW3R+U7Fg39fSoUOy5CumITmRVkwMwFkvd8c=;
        b=gqd3WepzRUhFtQhKKRnry27Svru0AipdaJ+5JXy7SMsUrS772TktUfKQVSRfCNAWuo
         ElFtPk9s+Wr8cLRicg+V8V0nnMvet0KYp6rxyepPVw7UOG8ZwUReEWuHNXakSjvlBn+f
         5tzOg/zeeLyTjW+nZTOK9RPpOsRMbZXKqfW4+ML+5JoyoCvyh/EvktOTR44v2JPJHXlA
         9RqzTfdwi9mHv/dqAJ3tBJkCaqrMiyujStIk56qpW1dQYquijZyoCtD7scEYkUHTgC2Z
         WvG8FvNFhC46QyMdBbaAQ/5xZB7HJBNFG5mc/OoecLQKPPjQSgNGpDwDxyIv9nCe2VQk
         qYrg==
X-Gm-Message-State: AOJu0Yw6/Qvp53RwllFeEc/DhJfG0uH3KKx/9YOY8AoWAfVtHQne0D9e
	zj8GHyqRXxUR/I1ebkwXU/bGXj4+82S2STiXHjltfJFxeum8se3Wh/DxhD7SRB7JMehEAvGBPlO
	A5b1aRUBYtzCCWEW7OkteTN1uj5zKUvZSNez0
X-Received: by 2002:a9d:664d:0:b0:6dc:2d7e:b2f4 with SMTP id q13-20020a9d664d000000b006dc2d7eb2f4mr2116206otm.4.1704719082418;
        Mon, 08 Jan 2024 05:04:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGJsw+mq7pUDEB0Bq9kX+hhDOVQWcrJXsPRITXHjSedjN0kt38eLG+cS531y0mNTOrAMDIBwzKJXx4sRT8okts=
X-Received: by 2002:a9d:664d:0:b0:6dc:2d7e:b2f4 with SMTP id
 q13-20020a9d664d000000b006dc2d7eb2f4mr2116198otm.4.1704719082117; Mon, 08 Jan
 2024 05:04:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240104193303.3175844-1-seanjc@google.com> <20240104193303.3175844-4-seanjc@google.com>
In-Reply-To: <20240104193303.3175844-4-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 8 Jan 2024 14:04:30 +0100
Message-ID: <CABgObfaBJQTm2stHFCsb8g0BKPsnnMYTvPfrqtc8aBmOcOimLQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: LAM support for 6.8
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 4, 2024 at 8:33=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> LAM virtualization support.  FWIW, I intended to send this in early-ish
> December as you've asked in the past, but December was basically a lost c=
ause
> for me in terms of doing upstream work.  :-/
>
> The following changes since commit e9e60c82fe391d04db55a91c733df4a017c28b=
2f:
>
>   selftests/kvm: fix compilation on non-x86_64 platforms (2023-11-21 11:5=
8:25 -0500)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-lam-6.8
>
> for you to fetch changes up to 183bdd161c2b773a62f01d1c030f5a3a5b7c33b5:
>
>   KVM: x86: Use KVM-governed feature framework to track "LAM enabled" (20=
23-11-28 17:54:09 -0800)

Patches are surprisingly small for this. What's the state of tests
(https://www.spinics.net/lists/kvm/msg313712.html) though?

Thanks,

Paolo

> ----------------------------------------------------------------
> KVM x86 support for virtualizing Linear Address Masking (LAM)
>
> Add KVM support for Linear Address Masking (LAM).  LAM tweaks the canonic=
ality
> checks for most virtual address usage in 64-bit mode, such that only the =
most
> significant bit of the untranslated address bits must match the polarity =
of the
> last translated address bit.  This allows software to use ignored, untran=
slated
> address bits for metadata, e.g. to efficiently tag pointers for address
> sanitization.
>
> LAM can be enabled separately for user pointers and supervisor pointers, =
and
> for userspace LAM can be select between 48-bit and 57-bit masking
>
>  - 48-bit LAM: metadata bits 62:48, i.e. LAM width of 15.
>  - 57-bit LAM: metadata bits 62:57, i.e. LAM width of 6.
>
> For user pointers, LAM enabling utilizes two previously-reserved high bit=
s from
> CR3 (similar to how PCID_NOFLUSH uses bit 63): LAM_U48 and LAM_U57, bits =
62 and
> 61 respectively.  Note, if LAM_57 is set, LAM_U48 is ignored, i.e.:
>
>  - CR3.LAM_U48=3D0 && CR3.LAM_U57=3D0 =3D=3D LAM disabled for user pointe=
rs
>  - CR3.LAM_U48=3D1 && CR3.LAM_U57=3D0 =3D=3D LAM-48 enabled for user poin=
ters
>  - CR3.LAM_U48=3Dx && CR3.LAM_U57=3D1 =3D=3D LAM-57 enabled for user poin=
ters
>
> For supervisor pointers, LAM is controlled by a single bit, CR4.LAM_SUP, =
with
> the 48-bit versus 57-bit LAM behavior following the current paging mode, =
i.e.:
>
>  - CR4.LAM_SUP=3D0 && CR4.LA57=3Dx =3D=3D LAM disabled for supervisor poi=
nters
>  - CR4.LAM_SUP=3D1 && CR4.LA57=3D0 =3D=3D LAM-48 enabled for supervisor p=
ointers
>  - CR4.LAM_SUP=3D1 && CR4.LA57=3D1 =3D=3D LAM-57 enabled for supervisor p=
ointers
>
> The modified LAM canonicality checks:
>  - LAM_S48                : [ 1 ][ metadata ][ 1 ]
>                               63               47
>  - LAM_U48                : [ 0 ][ metadata ][ 0 ]
>                               63               47
>  - LAM_S57                : [ 1 ][ metadata ][ 1 ]
>                               63               56
>  - LAM_U57 + 5-lvl paging : [ 0 ][ metadata ][ 0 ]
>                               63               56
>  - LAM_U57 + 4-lvl paging : [ 0 ][ metadata ][ 0...0 ]
>                               63               56..47
>
> The bulk of KVM support for LAM is to emulate LAM's modified canonicality
> checks.  The approach taken by KVM is to "fill" the metadata bits using t=
he
> highest bit of the translated address, e.g. for LAM-48, bit 47 is sign-ex=
tended
> to bits 62:48.  The most significant bit, 63, is *not* modified, i.e. its=
 value
> from the raw, untagged virtual address is kept for the canonicality check=
. This
> untagging allows
>
> Aside from emulating LAM's canonical checks behavior, LAM has the usual K=
VM
> touchpoints for selectable features: enumeration (CPUID.7.1:EAX.LAM[bit 2=
6],
> enabling via CR3 and CR4 bits, etc.
>
> ----------------------------------------------------------------
> Binbin Wu (9):
>       KVM: x86: Consolidate flags for __linearize()
>       KVM: x86: Add an emulation flag for implicit system access
>       KVM: x86: Add X86EMUL_F_INVLPG and pass it in em_invlpg()
>       KVM: x86/mmu: Drop non-PA bits when getting GFN for guest's PGD
>       KVM: x86: Add & use kvm_vcpu_is_legal_cr3() to check CR3's legality
>       KVM: x86: Remove kvm_vcpu_is_illegal_gpa()
>       KVM: x86: Introduce get_untagged_addr() in kvm_x86_ops and call it =
in emulator
>       KVM: x86: Untag addresses for LAM emulation where applicable
>       KVM: x86: Use KVM-governed feature framework to track "LAM enabled"
>
> Robert Hoo (3):
>       KVM: x86: Virtualize LAM for supervisor pointer
>       KVM: x86: Virtualize LAM for user pointer
>       KVM: x86: Advertise and enable LAM (user and supervisor)
>
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  5 +++-
>  arch/x86/kvm/cpuid.c               |  2 +-
>  arch/x86/kvm/cpuid.h               | 13 +++++----
>  arch/x86/kvm/emulate.c             | 27 ++++++++++---------
>  arch/x86/kvm/governed_features.h   |  1 +
>  arch/x86/kvm/kvm_emulate.h         |  9 +++++++
>  arch/x86/kvm/mmu.h                 |  8 ++++++
>  arch/x86/kvm/mmu/mmu.c             |  2 +-
>  arch/x86/kvm/mmu/mmu_internal.h    |  1 +
>  arch/x86/kvm/mmu/paging_tmpl.h     |  2 +-
>  arch/x86/kvm/svm/nested.c          |  4 +--
>  arch/x86/kvm/vmx/nested.c          | 11 +++++---
>  arch/x86/kvm/vmx/sgx.c             |  1 +
>  arch/x86/kvm/vmx/vmx.c             | 55 ++++++++++++++++++++++++++++++++=
++++--
>  arch/x86/kvm/vmx/vmx.h             |  2 ++
>  arch/x86/kvm/x86.c                 | 18 +++++++++++--
>  arch/x86/kvm/x86.h                 |  2 ++
>  18 files changed, 134 insertions(+), 30 deletions(-)
>


