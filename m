Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 426BDE0574
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 15:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387831AbfJVNs3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 09:48:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53810 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387479AbfJVNs3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 09:48:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571752107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=YQwrO8GtQidGZq2f7azyljtcZR53gRduboQc8qaX8xY=;
        b=YQ5N6cUlHYpm3p2TAfUT8BbXtfvzUzToPbrPuHk1CCD4zJVWzJ4joufXqEUqoQz4Fw/Zls
        uOUMi2kn8Rc7gkopUAWV2GgD6xNzk0Z1I86Xzj+v7FmumeXtMEioyGedg61PEZD0RV/ZPT
        lMfmgiKMTyGfkOOINt+h1JNUihwI4c8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-gXq-Fua5M8O9bssVJY7MCw-1; Tue, 22 Oct 2019 09:48:25 -0400
Received: by mail-wm1-f71.google.com with SMTP id m68so2545802wme.7
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2019 06:48:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UYJn44mofyK6oeM1TPcglwuAiq767n8XhKqzqOqMQHc=;
        b=ZmvAGnjw2i1H0GWc187U7R1XZf7qEScyJxD4L47se7I08sa+Ow3Z/3QfYCXUWw9WV3
         1Y1StX1KyJ7xLZiqkdjlq4EhoYVJqow3FnLFJAIK+BIeBMBMnSxIrJPGrCZ4NghFuPdL
         LjTl/ZG5UmB2ruBjG/XSBYnAlOegoyfJNOl3aoI5Nw+FFPBhu1LV9q7sYCR2MYHFyVBJ
         /tgcZXhvin4DjujxUWCP4v6zqocuR0munr8BTB8eizFTz5XRnt4NZaSvPaSetsGIQ+jN
         E1YaAEcogOr6rpaQzY0Cmgvtk/C703TCJNU0M0dw+5GRhE7YAHQlnSxQSOg1EEUWEj4s
         XSBA==
X-Gm-Message-State: APjAAAXeyqR/8bvWxiEICs+DXLp2xWsvz0hdCdA1d135APv2x0s03Pt/
        NulOwvvt+9/9/Nh4OEL9kzT39U8R9BzB8ncHFtS00vTcoIvKORbQ3a4DnDaepS//D/LjidIDGOu
        Hs1897/8H0wgy
X-Received: by 2002:a1c:9990:: with SMTP id b138mr3273041wme.176.1571752104663;
        Tue, 22 Oct 2019 06:48:24 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzHk+GYrg529v9JGxZxCl7S47XjU1axJ+dEcu/TRPNHhCAWJsxo541JWQD8MYSKqsH1NPD1+A==
X-Received: by 2002:a1c:9990:: with SMTP id b138mr3273018wme.176.1571752104277;
        Tue, 22 Oct 2019 06:48:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c0e4:dcf4:b543:ce19? ([2001:b07:6468:f312:c0e4:dcf4:b543:ce19])
        by smtp.gmail.com with ESMTPSA id u26sm19320818wrd.87.2019.10.22.06.48.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2019 06:48:23 -0700 (PDT)
Subject: Re: [PATCH v3 0/9] Add support for XSAVES to AMD and unify it with
 Intel
To:     Aaron Lewis <aaronlewis@google.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>
References: <20191021233027.21566-1-aaronlewis@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <1ea8025f-7481-d392-a5de-0b43fbb10705@redhat.com>
Date:   Tue, 22 Oct 2019 15:48:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191021233027.21566-1-aaronlewis@google.com>
Content-Language: en-US
X-MC-Unique: gXq-Fua5M8O9bssVJY7MCw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/10/19 01:30, Aaron Lewis wrote:
> Unify AMD's and Intel's approach for supporting XSAVES.  To do this
> change Intel's approach from using the MSR-load areas to writing
> the guest/host values to IA32_XSS on a VM-enter/VM-exit.  Switching to
> this strategy allows for a common approach between both AMD and Intel.
> Additionally, define svm_xsaves_supported() based on AMD's feedback, and =
add
> vcpu->arch.xsaves_enabled to track whether XSAVES is enabled in the guest=
.
>=20
> This change sets up IA32_XSS to be a non-zero value in the future, which
> may happen sooner than later with support for guest CET feature being
> added.
>=20
> v2 -> v3:
>  - Remove guest_xcr0_loaded from kvm_vcpu.
>  - Add vcpu->arch.xsaves_enabled.
>  - Add staged rollout to load the hardware IA32_XSS MSR with guest/host
>    values on VM-entry and VM-exit:
>      1) Introduce vcpu->arch->xsaves_enabled.
>      2) Add svm implementation for switching between guest and host IA32_=
XSS.
>      3) Add vmx implementation for switching between guest and host IA32_=
XSS.
>      4) Remove svm and vmx implementation and add it to common code.
>=20
> v1 -> v2:
>  - Add the flag xsaves_enabled to kvm_vcpu_arch to track when XSAVES is
>    enabled in the guest, whether or not XSAVES is enumerated in the
>    guest CPUID.
>  - Remove code that sets the X86_FEATURE_XSAVES bit in the guest CPUID
>    which was added in patch "Enumerate XSAVES in guest CPUID when it is
>    available to the guest".  As a result we no longer need that patch.
>  - Added a comment to kvm_set_msr_common to describe how to save/restore
>    PT MSRS without using XSAVES/XRSTORS.
>  - Added more comments to the "Add support for XSAVES on AMD" patch.
>  - Replaced vcpu_set_msr_expect_result() with _vcpu_set_msr() in the
>    test library.
>=20
> Aaron Lewis (9):
>   KVM: x86: Introduce vcpu->arch.xsaves_enabled
>   KVM: VMX: Fix conditions for guest IA32_XSS support
>   KVM: x86: Remove unneeded kvm_vcpu variable, guest_xcr0_loaded
>   KVM: SVM: Use wrmsr for switching between guest and host IA32_XSS on AM=
D
>   KVM: VMX: Use wrmsr for switching between guest and host IA32_XSS on In=
tel
>   KVM: x86: Move IA32_XSS-swapping on VM-entry/VM-exit to common x86 code
>   kvm: x86: Move IA32_XSS to kvm_{get,set}_msr_common
>   kvm: svm: Update svm_xsaves_supported
>   kvm: tests: Add test to verify MSR_IA32_XSS
>=20
>  arch/x86/include/asm/kvm_host.h               |  1 +
>  arch/x86/kvm/svm.c                            |  9 ++-
>  arch/x86/kvm/vmx/vmx.c                        | 41 ++--------
>  arch/x86/kvm/x86.c                            | 52 ++++++++++---
>  arch/x86/kvm/x86.h                            |  4 +-
>  include/linux/kvm_host.h                      |  1 -
>  tools/testing/selftests/kvm/.gitignore        |  1 +
>  tools/testing/selftests/kvm/Makefile          |  1 +
>  .../selftests/kvm/include/x86_64/processor.h  |  7 +-
>  .../selftests/kvm/lib/x86_64/processor.c      | 72 +++++++++++++++---
>  .../selftests/kvm/x86_64/xss_msr_test.c       | 76 +++++++++++++++++++
>  11 files changed, 205 insertions(+), 60 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/xss_msr_test.c
>=20

Queued, thanks.

Paolo

