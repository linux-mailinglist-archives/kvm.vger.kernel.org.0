Return-Path: <kvm+bounces-202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE8167DCEEA
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 15:21:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DED1A1C20C6D
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 14:21:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92E7613FE1;
	Tue, 31 Oct 2023 14:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BuEDuozH"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231FB1D532
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 14:20:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD92CC9
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 07:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698762055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QXthgqjY+SpDv3y6xxTLIrI9RIFKk1NjsAtr8h5OfqY=;
	b=BuEDuozHbSZwNU+XkdMcIedVTB+Bn7iGagUqX8t8NJv7OgwRAs8ZdpTJDoAT7wJTpp1ufR
	FCtgD30up9tTjcV+iCmzv8YIAieXQrvEdBx3XPH3wiVlV+H8Wfjj7SQdVxvAQ/oayJk5m5
	1qpC4SGTnjDxhrXcPRHI2h1mRkv9VGA=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-226-tA7pqKMoPjyvFe-FiRP9tQ-1; Tue, 31 Oct 2023 10:20:54 -0400
X-MC-Unique: tA7pqKMoPjyvFe-FiRP9tQ-1
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-7b9b269f05cso2065529241.3
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 07:20:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698762053; x=1699366853;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QXthgqjY+SpDv3y6xxTLIrI9RIFKk1NjsAtr8h5OfqY=;
        b=QSCs0QV508iTPHoBAh1Bj6Npd3cMH5GqIK15ifNX7u8HvhKHI+QEijVfxMjuJ9HsNc
         Qm6BUOW4KehMxbzam8xUNcw/Bgr7CkfruQApERsbWD8tkwA7nOhlitg80D+iXZ4OnlfZ
         7FKzNJ8cEEpveR0y89/ESsasxIZTkANM09LCPIaxdi424qD6hK4ARKomq4eFgVZU8sqK
         FnMhVGI2EIfKj0l5iBSDs4+xqq2AhBwiI0nAPYdVKcH1JgFqgFvnhoBsYVGpCQHaCWXX
         XQZM+Jhd8dbLF6tMIuThplwA1lbZzolO+Nhta4XcuDXVfb+BeH5HPKn+XS5tf0JuE1ja
         xHtQ==
X-Gm-Message-State: AOJu0YxpEqqAykGXncKP5Z6fEckoWGJE1wtiRn/UDEsdZ+Us5UoK2dK7
	zFx3U5nTZGnTW4234p+ErosnVw7vcWNTtxbhn9p3fWWZBwR0AjvEXUGcNZtbGCuDybpwd0S9H10
	K07UB0ADPA4DJEoRadOJBEt1zAGenGns9pWQy
X-Received: by 2002:a67:c89d:0:b0:457:bc5f:b497 with SMTP id v29-20020a67c89d000000b00457bc5fb497mr11554246vsk.27.1698762053570;
        Tue, 31 Oct 2023 07:20:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGZTNWIrtxgjAmfW2uP5CgYHQb74iSe9pyTPKxSUoeAiL/+ELfGW3MKgEGC5lWgJVeaIXdJwYHIgvWDZhYMIJs=
X-Received: by 2002:a67:c89d:0:b0:457:bc5f:b497 with SMTP id
 v29-20020a67c89d000000b00457bc5fb497mr11554223vsk.27.1698762053277; Tue, 31
 Oct 2023 07:20:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231027204933.3651381-1-seanjc@google.com> <20231027204933.3651381-5-seanjc@google.com>
In-Reply-To: <20231027204933.3651381-5-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 31 Oct 2023 15:20:41 +0100
Message-ID: <CABgObfb55_B0SC41j9iiqBuccoSiZK+x488Pqpyq=R32eObtwQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: MMU changes for 6.7
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 27, 2023 at 10:49=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> This is mostly the first half of a series by Yan to optimize KVM's handli=
ng of
> guest MTRR changes for VMs with non-coherent DMA.  Yan had to put more co=
mplex
> changes that actually realize the optimizations on hold, but the patches =
here
> are all nice cleanups on their own.
>
> The following changes since commit 5804c19b80bf625c6a9925317f845e497434d6=
d3:
>
>   Merge tag 'kvm-riscv-fixes-6.6-1' of https://github.com/kvm-riscv/linux=
 into HEAD (2023-09-23 05:35:55 -0400)

Pulled, thanks.

Paolo


> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-mmu-6.7
>
> for you to fetch changes up to 1de9992f9de0a92b6e11133aba0e2be833c11084:
>
>   KVM: x86/mmu: Remove unnecessary =E2=80=98NULL=E2=80=99 values from spt=
ep (2023-10-18 14:34:28 -0700)
>
> ----------------------------------------------------------------
> KVM x86 MMU changes for 6.7:
>
>  - Clean up code that deals with honoring guest MTRRs when the VM has
>    non-coherent DMA and host MTRRs are ignored, i.e. EPT is enabled.
>
>  - Zap EPT entries when non-coherent DMA assignment stops/start to preven=
t
>    using stale entries with the wrong memtype.
>
>  - Don't ignore guest PAT for CR0.CD=3D1 && KVM_X86_QUIRK_CD_NW_CLEARED=
=3Dy, as
>    there's zero reason to ignore guest PAT if the effective MTRR memtype =
is WB.
>    This will also allow for future optimizations of handling guest MTRR u=
pdates
>    for VMs with non-coherent DMA and the quirk enabled.
>
>  - Harden the fast page fault path to guard against encountering an inval=
id
>    root when walking SPTEs.
>
> ----------------------------------------------------------------
> Li zeming (1):
>       KVM: x86/mmu: Remove unnecessary =E2=80=98NULL=E2=80=99 values from=
 sptep
>
> Yan Zhao (5):
>       KVM: x86/mmu: Add helpers to return if KVM honors guest MTRRs
>       KVM: x86/mmu: Zap SPTEs when CR0.CD is toggled iff guest MTRRs are =
honored
>       KVM: x86/mmu: Zap SPTEs on MTRR update iff guest MTRRs are honored
>       KVM: x86/mmu: Zap KVM TDP when noncoherent DMA assignment starts/st=
ops
>       KVM: VMX: drop IPAT in memtype when CD=3D1 for KVM_X86_QUIRK_CD_NW_=
CLEARED
>
>  arch/x86/kvm/mmu.h     |  7 +++++++
>  arch/x86/kvm/mmu/mmu.c | 37 ++++++++++++++++++++++++++-----------
>  arch/x86/kvm/mtrr.c    |  2 +-
>  arch/x86/kvm/vmx/vmx.c |  9 +++------
>  arch/x86/kvm/x86.c     | 21 ++++++++++++++++++---
>  5 files changed, 55 insertions(+), 21 deletions(-)
>


