Return-Path: <kvm+bounces-197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D1D97DCECD
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 15:10:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02A07281910
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 14:10:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46CD01DFD6;
	Tue, 31 Oct 2023 14:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UoUjsy8a"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D011DDFF
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 14:10:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD20D183
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 07:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698761414;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OiSKB3bUSv/HS7qcY3tq6bcuqLr5aDmdwQMGjVzvqHw=;
	b=UoUjsy8a9oQrNUUymQVykectp91Jg0q0Fi/iprX+yQXcmRPerjqvCeJEe5Pmnjf5g93mgu
	oDxLmSzEg29SraZlEs+1YhTfdFaK4XXuFFeZ2Z6IvsjJ+TJXmaxFsFv123y5eG++thdCSY
	jbWFsux1i9Tr2fzI1xSxLLhVJbUnk8o=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-399-afbWcFrGO6eqKIEaVa_Bpg-1; Tue, 31 Oct 2023 10:10:12 -0400
X-MC-Unique: afbWcFrGO6eqKIEaVa_Bpg-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-1e9adea7952so7003691fac.0
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 07:10:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698761411; x=1699366211;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OiSKB3bUSv/HS7qcY3tq6bcuqLr5aDmdwQMGjVzvqHw=;
        b=QlFqmAkQe/eXWy7vGwMfzwBeHXY2bTLUZhUaeqwlVk6NB13sydlvJ7aUn3MBsaLffG
         L4pUq36i8eQ/8nPZxxmW3WvoJ4ef/RoCu0roIl7U2qvpsPpw+IKpBM91gXnmsq9x6XNH
         w9JLprcPD0q2LemESjtWn7XLq8HVDelvffZ0EFFEXRksOwxsndt5v+KTwxCliJrEfdr5
         9Nfh/QQQCpRdnorM5vTCDEOxzzIf33khEG/PiBuQCii1wFB9UvS2ArnXHy7lXh22JsmT
         l6cgPWTHF9DxYaRzU/5s+u4TXrNgafkS+VIaOo1uVO7aJ/rnBETckRH8Ph+JmlaIFOjH
         WWpA==
X-Gm-Message-State: AOJu0YyjxcbHjjOKIn+4vS4ICCO742cw229Hwqi/7Sqg8fESExxIxo6l
	jX4AeqoRN1yHTEEQjBhBPqHPOLtaWkR0Rr0aLtlUL02z+aMnbo2W+qIx1L9P8Kq2g9EFaglYQRk
	oBtjsEak1ZLLDORE1bjM6P9VMPV6lB1g0pWqy
X-Received: by 2002:a05:6871:5a88:b0:1e9:dfe4:743d with SMTP id oo8-20020a0568715a8800b001e9dfe4743dmr16139670oac.16.1698761411340;
        Tue, 31 Oct 2023 07:10:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFVQuQJ/G/4ligJpilKpiM0deTmGBvpXWFGLn7D21GroXR7q47du5CgC+MS2YFpj9r2PzagWc9yGuPTTCnTCA4=
X-Received: by 2002:a05:6871:5a88:b0:1e9:dfe4:743d with SMTP id
 oo8-20020a0568715a8800b001e9dfe4743dmr16139632oac.16.1698761410950; Tue, 31
 Oct 2023 07:10:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy2dg61z7=vsrOqwxHoV1GBvaAzcdUY4o6pLmTNM0WV5ig@mail.gmail.com>
In-Reply-To: <CAAhSdy2dg61z7=vsrOqwxHoV1GBvaAzcdUY4o6pLmTNM0WV5ig@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 31 Oct 2023 15:09:59 +0100
Message-ID: <CABgObfauR28ttiM1cmM7jU-Xn8pPM0yhcqd2pfqy-6e4xZujEQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.7
To: Anup Patel <anup@brainfault.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Palmer Dabbelt <palmer@rivosinc.com>, 
	Atish Patra <atishp@atishpatra.org>, Atish Patra <atishp@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, KVM General <kvm@vger.kernel.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 24, 2023 at 9:58=E2=80=AFAM Anup Patel <anup@brainfault.org> wr=
ote:
>
> Hi Paolo,
>
> We have the following KVM RISC-V changes for 6.7:
> 1) Smstateen and Zicond support for Guest/VM
> 2) Virtualized senvcfg CSR for Guest/VM
> 3) Added Smstateen registers to the get-reg-list selftests
> 4) Added Zicond to the get-reg-list selftests
> 5) Virtualized SBI debug console (DBCN) for Guest/VM
> 6) Added SBI debug console (DBCN) to the get-reg-list selftests
>
> Please pull.

Done, thanks.

Paolo

> Please note that the following four patches are part of the
> shared tag kvm-riscv-shared-tag-6.7 provided to Palmer:
>  - dt-bindings: riscv: Add Zicond extension entry
>  - RISC-V: Detect Zicond from ISA string
>  - dt-bindings: riscv: Add smstateen entry
>  - RISC-V: Detect Smstateen extension
>
> Regards,
> Anup
>
> The following changes since commit 94f6f0550c625fab1f373bb86a6669b45e9748=
b3:
>
>   Linux 6.6-rc5 (2023-10-08 13:49:43 -0700)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.7-1
>
> for you to fetch changes up to d9c00f44e5de542340cce1d09e2c990e16c0ed3a:
>
>   KVM: riscv: selftests: Add SBI DBCN extension to get-reg-list test
> (2023-10-20 16:50:39 +0530)
>
> ----------------------------------------------------------------
> KVM/riscv changes for 6.7
>
> - Smstateen and Zicond support for Guest/VM
> - Virtualized senvcfg CSR for Guest/VM
> - Added Smstateen registers to the get-reg-list selftests
> - Added Zicond to the get-reg-list selftests
> - Virtualized SBI debug console (DBCN) for Guest/VM
> - Added SBI debug console (DBCN) to the get-reg-list selftests
>
> ----------------------------------------------------------------
> Andrew Jones (3):
>       MAINTAINERS: RISC-V: KVM: Add another kselftests path
>       KVM: selftests: Add array order helpers to riscv get-reg-list
>       KVM: riscv: selftests: get-reg-list print_reg should never fail
>
> Anup Patel (11):
>       RISC-V: Detect Zicond from ISA string
>       dt-bindings: riscv: Add Zicond extension entry
>       RISC-V: KVM: Allow Zicond extension for Guest/VM
>       KVM: riscv: selftests: Add senvcfg register to get-reg-list test
>       KVM: riscv: selftests: Add smstateen registers to get-reg-list test
>       KVM: riscv: selftests: Add condops extensions to get-reg-list test
>       RISC-V: Add defines for SBI debug console extension
>       RISC-V: KVM: Change the SBI specification version to v2.0
>       RISC-V: KVM: Allow some SBI extensions to be disabled by default
>       RISC-V: KVM: Forward SBI DBCN extension to user-space
>       KVM: riscv: selftests: Add SBI DBCN extension to get-reg-list test
>
> Mayuresh Chitale (7):
>       RISC-V: Detect Smstateen extension
>       dt-bindings: riscv: Add smstateen entry
>       RISC-V: KVM: Add kvm_vcpu_config
>       RISC-V: KVM: Enable Smstateen accesses
>       RISCV: KVM: Add senvcfg context save/restore
>       RISCV: KVM: Add sstateen0 context save/restore
>       RISCV: KVM: Add sstateen0 to ONE_REG
>
>  .../devicetree/bindings/riscv/extensions.yaml      |  12 ++
>  MAINTAINERS                                        |   1 +
>  arch/riscv/include/asm/csr.h                       |  18 ++
>  arch/riscv/include/asm/hwcap.h                     |   2 +
>  arch/riscv/include/asm/kvm_host.h                  |  18 ++
>  arch/riscv/include/asm/kvm_vcpu_sbi.h              |   7 +-
>  arch/riscv/include/asm/sbi.h                       |   7 +
>  arch/riscv/include/uapi/asm/kvm.h                  |  12 ++
>  arch/riscv/kernel/cpufeature.c                     |   2 +
>  arch/riscv/kvm/vcpu.c                              |  76 +++++--
>  arch/riscv/kvm/vcpu_onereg.c                       |  72 ++++++-
>  arch/riscv/kvm/vcpu_sbi.c                          |  61 +++---
>  arch/riscv/kvm/vcpu_sbi_replace.c                  |  32 +++
>  tools/testing/selftests/kvm/riscv/get-reg-list.c   | 233 +++++++++++++--=
------
>  14 files changed, 418 insertions(+), 135 deletions(-)
>


