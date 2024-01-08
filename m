Return-Path: <kvm+bounces-5810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3C89826F13
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 13:57:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 266061C22787
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 12:57:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA619446DA;
	Mon,  8 Jan 2024 12:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GySrfD8Z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A0C41202
	for <kvm@vger.kernel.org>; Mon,  8 Jan 2024 12:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704718611;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ISXiGgepSDaneibA7s4lFlhDl4H7ixQ1k4wuTYixcIs=;
	b=GySrfD8Z1XMVc+ezax0k1ZipC9t2HB8mlNDPxj4oXcteFaWPyhZzzB/z7LLc29BD+LLkJ5
	wsORg9EN0TNiQ1Og1QzqxOoJd8qpH/wqa9BC3OqjSgsF5A+mqUWplLEcD4pEmyb47kdYw5
	dwt64esciGfHU/hUHd9VjwJhxRoRwGI=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-8mMTvIYlOIK52xUrVdg0EA-1; Mon, 08 Jan 2024 07:56:38 -0500
X-MC-Unique: 8mMTvIYlOIK52xUrVdg0EA-1
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-4b72368af77so70310e0c.1
        for <kvm@vger.kernel.org>; Mon, 08 Jan 2024 04:56:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704718597; x=1705323397;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ISXiGgepSDaneibA7s4lFlhDl4H7ixQ1k4wuTYixcIs=;
        b=aVp2K7mysFyEJXUgkeTlpqwVmkSZON2XLMIghyQSzACB2jOKmKpBZtqw/SBrah9BYD
         i+VJGY/jGoac7291u2sALRE9ivJYfQ0FqGdXHGTVM7k5zj9+9P+KMxDBJ0cIEkZXvL8t
         5NkQE+7GMYSfnZjPJn3WECDiMoKaDaGuHRXcegk0xhul3IYEDVAjroyOXT8GLjavlWPd
         1V+8C0malnH4/SNlvM5/xbGneGAj3QGulyaSxvSkIp0bpttrW9yPjSA3vmilxj7yczc2
         Z+wpet3zRdzTTy24RlXsa+1H5q2827SOvucb6YBrIimTlxkY3bPmUMq0QnR7FnyCXqv2
         a4eg==
X-Gm-Message-State: AOJu0YzDVkmIwBrrMK0OwYG/Oe6KCoTkm0TfhTW7MKGI9L5j/Gd9Pkm9
	DkbBz4SGAN8UJd5oxF7rGwbPm+xIrAONcMV6ULuA5/o0h0Gz+3ywEZBBc3B4Pwu8oEwdbZx7YHg
	hWZ/rQEez4JsLijH/YY3EaCcxZUgCBGmbr3DDZX3bL0k9
X-Received: by 2002:a05:6122:c84:b0:4b6:cdb7:9818 with SMTP id ba4-20020a0561220c8400b004b6cdb79818mr663750vkb.8.1704718597500;
        Mon, 08 Jan 2024 04:56:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH0KuUL3VY/Zdpr4TsKX0PdDblMIKt348WRFnTYkQKXtYhiA3fioEDGJQzDFg5Z6wUfdX1YTcAbxzfUv9X1xsE=
X-Received: by 2002:a05:6122:c84:b0:4b6:cdb7:9818 with SMTP id
 ba4-20020a0561220c8400b004b6cdb79818mr663745vkb.8.1704718597176; Mon, 08 Jan
 2024 04:56:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240104193303.3175844-1-seanjc@google.com> <20240104193303.3175844-3-seanjc@google.com>
In-Reply-To: <20240104193303.3175844-3-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 8 Jan 2024 13:56:25 +0100
Message-ID: <CABgObfbs2NZhRxnW0tV1yUOXSoFhnYMJ4e0hx6jRmiZOL6gqJA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: Hyper-V changes for 6.8
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 4, 2024 at 8:33=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> This is essentially Vitaly's series to add CONFIG_KVM_HYPERV, along with =
a
> one-off patch to clean up the range-based TLB flush APIs.  While it's not=
 super
> obvious that adding CONFIG_KVM_HYPERV is worth the churn, e.g. very few s=
etups
> can actually disable CONFIG_KVM_HYPERV in practice, the end result is nic=
e and
> at the very least makes it easier for non-HyperV gurus to follow along.
>
> The following changes since commit e9e60c82fe391d04db55a91c733df4a017c28b=
2f:
>
>   selftests/kvm: fix compilation on non-x86_64 platforms (2023-11-21 11:5=
8:25 -0500)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-hyperv-6.8
>
> for you to fetch changes up to 017a99a966f1183e611f0b0fa6bec40160c81813:
>
>   KVM: nSVM: Hide more stuff under CONFIG_KVM_HYPERV/CONFIG_HYPERV (2023-=
12-07 09:35:26 -0800)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> KVM x86 Hyper-V changes for 6.8:
>
>  - Guard KVM-on-HyperV's range-based TLB flush hooks with an #ifdef on
>    CONFIG_HYPERV as a minor optimization, and to self-document the code.
>
>  - Add CONFIG_KVM_HYPERV to allow disabling KVM support for HyperV "emula=
tion"
>    at build time.
>
> ----------------------------------------------------------------
> Sean Christopherson (1):
>       KVM: x86/mmu: Declare flush_remote_tlbs{_range}() hooks iff HYPERV!=
=3Dn
>
> Vitaly Kuznetsov (16):
>       KVM: x86/xen: Remove unneeded xen context from kvm_arch when !CONFI=
G_KVM_XEN
>       KVM: x86: Move Hyper-V partition assist page out of Hyper-V emulati=
on context
>       KVM: VMX: Split off vmx_onhyperv.{ch} from hyperv.{ch}
>       KVM: x86: Introduce helper to check if auto-EOI is set in Hyper-V S=
ynIC
>       KVM: x86: Introduce helper to check if vector is set in Hyper-V Syn=
IC
>       KVM: VMX: Split off hyperv_evmcs.{ch}
>       KVM: x86: Introduce helper to handle Hyper-V paravirt TLB flush req=
uests
>       KVM: nVMX: Split off helper for emulating VMCLEAR on Hyper-V eVMCS
>       KVM: selftests: Make Hyper-V tests explicitly require KVM Hyper-V s=
upport
>       KVM: selftests: Fix vmxon_pa =3D=3D vmcs12_pa =3D=3D -1ull nVMX tes=
tcase for !eVMCS
>       KVM: nVMX: Move guest_cpuid_has_evmcs() to hyperv.h
>       KVM: x86: Make Hyper-V emulation optional
>       KVM: nVMX: Introduce helpers to check if Hyper-V evmptr12 is valid/=
set
>       KVM: nVMX: Introduce accessor to get Hyper-V eVMCS pointer
>       KVM: nVMX: Hide more stuff under CONFIG_KVM_HYPERV
>       KVM: nSVM: Hide more stuff under CONFIG_KVM_HYPERV/CONFIG_HYPERV
>
>  arch/x86/include/asm/kvm-x86-ops.h                 |   2 +
>  arch/x86/include/asm/kvm_host.h                    |  25 +-
>  arch/x86/kvm/Kconfig                               |  14 +
>  arch/x86/kvm/Makefile                              |  16 +-
>  arch/x86/kvm/cpuid.c                               |   6 +
>  arch/x86/kvm/hyperv.h                              |  85 +++-
>  arch/x86/kvm/irq.c                                 |   2 +
>  arch/x86/kvm/irq_comm.c                            |   9 +-
>  arch/x86/kvm/kvm_onhyperv.h                        |  20 +
>  arch/x86/kvm/lapic.c                               |   5 +-
>  arch/x86/kvm/mmu/mmu.c                             |  12 +-
>  arch/x86/kvm/svm/hyperv.h                          |   9 +
>  arch/x86/kvm/svm/nested.c                          |  30 +-
>  arch/x86/kvm/svm/svm.h                             |   2 +
>  arch/x86/kvm/svm/svm_onhyperv.c                    |  10 +-
>  arch/x86/kvm/vmx/hyperv.c                          | 447 ---------------=
------
>  arch/x86/kvm/vmx/hyperv.h                          | 238 +++--------
>  arch/x86/kvm/vmx/hyperv_evmcs.c                    | 315 +++++++++++++++
>  arch/x86/kvm/vmx/hyperv_evmcs.h                    | 166 ++++++++
>  arch/x86/kvm/vmx/nested.c                          | 149 ++++---
>  arch/x86/kvm/vmx/nested.h                          |   3 +-
>  arch/x86/kvm/vmx/vmx.c                             |  20 +-
>  arch/x86/kvm/vmx/vmx.h                             |  12 +-
>  arch/x86/kvm/vmx/vmx_onhyperv.c                    |  36 ++
>  arch/x86/kvm/vmx/vmx_onhyperv.h                    | 125 ++++++
>  arch/x86/kvm/vmx/vmx_ops.h                         |   2 +-
>  arch/x86/kvm/x86.c                                 |  66 ++-
>  tools/testing/selftests/kvm/x86_64/hyperv_clock.c  |   2 +
>  tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c  |   5 +-
>  .../kvm/x86_64/hyperv_extended_hypercalls.c        |   2 +
>  .../testing/selftests/kvm/x86_64/hyperv_features.c |   2 +
>  tools/testing/selftests/kvm/x86_64/hyperv_ipi.c    |   2 +
>  .../testing/selftests/kvm/x86_64/hyperv_svm_test.c |   1 +
>  .../selftests/kvm/x86_64/hyperv_tlb_flush.c        |   2 +
>  .../kvm/x86_64/vmx_set_nested_state_test.c         |  16 +-
>  35 files changed, 1091 insertions(+), 767 deletions(-)
>  create mode 100644 arch/x86/kvm/vmx/hyperv_evmcs.c
>  create mode 100644 arch/x86/kvm/vmx/hyperv_evmcs.h
>  create mode 100644 arch/x86/kvm/vmx/vmx_onhyperv.c
>  create mode 100644 arch/x86/kvm/vmx/vmx_onhyperv.h
>


