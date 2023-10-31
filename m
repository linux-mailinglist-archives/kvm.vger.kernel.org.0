Return-Path: <kvm+bounces-200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E96E17DCEDA
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 15:15:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CF102818CA
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 14:15:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 756001DFC0;
	Tue, 31 Oct 2023 14:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UYuvTV2p"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92201DDF5
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 14:15:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE64107
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 07:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698761714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zUGnQiCF/6Ik0AtOZ0SWI2X75euizpW/yno5GZDuOec=;
	b=UYuvTV2piSdrDWMuyo79TpmnGB0fc3cVoE6yP+sx5e6Xcz5xPT6vMuOf5q5/ggILV3mmNQ
	PRVVg088zJBF6kDovAruTHxMb3V/akES1DUEjQ34Lq57AqoSjBh/QVVSQFREQF89koX1ia
	cHsXiuZziWCr78T3XkBpSi2xcsBweUQ=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-96-emB6R0dPNbC-ydQb6Ld8Vg-1; Tue, 31 Oct 2023 10:15:12 -0400
X-MC-Unique: emB6R0dPNbC-ydQb6Ld8Vg-1
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-457bdbb84dbso2343285137.0
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 07:15:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698761712; x=1699366512;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zUGnQiCF/6Ik0AtOZ0SWI2X75euizpW/yno5GZDuOec=;
        b=vinOqd5IjGpwrzPtxC9GrB6fTYJpRqTH/DdKyDjb7KYJb+AjEsUDBII+OsHkxivhgl
         24zmlxijQgCfZ2uU62DNVmVNwidbgEcsSCTffjNHbIEHTcH/kmqbSZIlD8NB4gVM3O3J
         gKQIb3hIs+loCPKQg5cjjjTZ3SpIzD0DUUk5yeclMhz9GPU3q/itLLTWibs03C4Og9U3
         X2/rqygt8GX5JnVg8lhRmP9lBnt1Q9HlfO2nglEgPVwndG6ESTMzs8knHwIBOUy23Mtm
         L3Ov8rDCg3UOYYBXAcbVtU9F8ihUM313jv51ZCqJJ4xhsoOwqtU4urkl4GrTSzm+yPIf
         Nt+Q==
X-Gm-Message-State: AOJu0Yy/Klr3OtMwlmoxQNAMU5IO50yG7uOaAnbUcVRLqidG6B7iv1Px
	4Q5tHiXV7d62bviIyRyuxotl8br0C82f3sraXHhiTQvo5tkCmHTlJfajRX+3HqFUsSJT22hNPcU
	dhaLbk7tcU2wAjpa58lAitQy3/m09W4Lwnkht
X-Received: by 2002:a67:c89e:0:b0:458:19fc:e1e5 with SMTP id v30-20020a67c89e000000b0045819fce1e5mr12735502vsk.6.1698761711826;
        Tue, 31 Oct 2023 07:15:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEzfspbtQPT/PwHpMJ6AmRbIK+Xv0rm0SMcOh4AZ98GXC/seDM6hbA1/X8AnPzKjQfoUtt/DHdK26LXWPMwctU=
X-Received: by 2002:a67:c89e:0:b0:458:19fc:e1e5 with SMTP id
 v30-20020a67c89e000000b0045819fce1e5mr12735480vsk.6.1698761711580; Tue, 31
 Oct 2023 07:15:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231027204933.3651381-1-seanjc@google.com> <20231027204933.3651381-2-seanjc@google.com>
In-Reply-To: <20231027204933.3651381-2-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 31 Oct 2023 15:15:00 +0100
Message-ID: <CABgObfZEXKOnLaU9pcH8n3VSGgFRYWy00VP4n5szjdK-pBMhqw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: APIC changes for 6.7
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 27, 2023 at 10:49=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> Two small APIC changes for 6.7, both specific to Intel's APICv.
>
> The following changes since commit 5804c19b80bf625c6a9925317f845e497434d6=
d3:
>
>   Merge tag 'kvm-riscv-fixes-6.6-1' of https://github.com/kvm-riscv/linux=
 into HEAD (2023-09-23 05:35:55 -0400)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-apic-6.7
>
> for you to fetch changes up to 629d3698f6958ee6f8131ea324af794f973b12ac:
>
>   KVM: x86: Clear bit12 of ICR after APIC-write VM-exit (2023-09-28 10:42=
:16 -0700)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> KVM x86 APIC changes for 6.7:
>
>  - Purge VMX's posted interrupt descriptor *before* loading APIC state wh=
en
>    handling KVM_SET_LAPIC.  Purging the PID after loading APIC state resu=
lts in
>    lost APIC timer IRQs as the APIC timer can be armed as part of loading=
 APIC
>    state, i.e. can immediately pend an IRQ if the expiry is in the past.
>
>  - Clear the ICR.BUSY bit when handling trap-like x2APIC writes to suppre=
ss a
>    WARN due to KVM expecting the BUSY bit to be cleared when sending IPIs=
.
>
> ----------------------------------------------------------------
> Haitao Shan (1):
>       KVM: x86: Fix lapic timer interrupt lost after loading a snapshot.
>
> Tao Su (1):
>       KVM: x86: Clear bit12 of ICR after APIC-write VM-exit
>
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  1 +
>  arch/x86/kvm/lapic.c               | 30 +++++++++++++++++-------------
>  arch/x86/kvm/vmx/vmx.c             |  4 ++--
>  4 files changed, 21 insertions(+), 15 deletions(-)
>


