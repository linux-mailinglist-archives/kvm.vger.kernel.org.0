Return-Path: <kvm+bounces-580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4512E7E0F7C
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 13:52:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 758671C20A65
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 12:52:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8F3518632;
	Sat,  4 Nov 2023 12:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RXPhzG7k"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089E911725
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 12:51:59 +0000 (UTC)
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A12194
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 05:51:58 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-51e24210395so6819a12.0
        for <kvm@vger.kernel.org>; Sat, 04 Nov 2023 05:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699102317; x=1699707117; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V2AIE4p4WRtdyGEtqiMMAREra62fDWl2hz5iPPeenLI=;
        b=RXPhzG7kV/uuD1QgBw6ZDyEWL0RwPFIZpJiZSmZ46uBbvuIzkOS57NXghzaj3JwJts
         BescPL0P3Sx7Xny3ryiDZqP/tA33oFLm3OKDXgfrLnrsLwA0ThZ7CyGco332boEhTtg+
         kxP6i/CRrCz9MwvW6MnXxzd6Xd9kePkBQICze7lib4xRMKVBVOo/kJRFDN3UiMtTo2x1
         YZs5rzsbEmggHyxNBgXUOc5rbpq8V632gh83ZraoWiJankFRM4QE9S27qMq3vmWGtgMJ
         rrbSRguQK46GcVzDz99A6KM0fDsbdmzrXh17VZyjCbT0//3KH3RwH9CQ9c+n8y6XdiOY
         Gxkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699102317; x=1699707117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V2AIE4p4WRtdyGEtqiMMAREra62fDWl2hz5iPPeenLI=;
        b=tqe8fyKVhhm30wj930MMGMA0BAGFIZapvBjyA4YnPgN0XDHBBOtaTfMc01ZuIzwnZ9
         DhTZBWFZvAF2MVTx69N7IjktsCaHrC6EVDbFAnSD3ezzg2jQezBlKc9UjgwqEGkvQcCO
         ws6zJImR6EsweQnMVYtLEY3tEwna4D5cagWGsyrKb2TDWpD+qvwPUSNlvobuSV1w4tao
         VieunCiT3IbSb1DeQJSXl3MF2wZR5CnufTMrsQC/gIoreyQJwD0LMLGWmRSEDjVNv0sp
         c0JWQZstJajuN7uDxo9MYqNcvggOJ2CeZ3eTl4Cv/JFTPZxEPe14ou/QEdpSJHCfZttr
         yGLg==
X-Gm-Message-State: AOJu0YzrXKSFxoAKd/Qjn1pJUVdviRT8eUj+G8ZMgP4CkKSg8kGCj3gv
	FVUGoXEka7geiU8/dW+F1FH1EjXUzeh+iSc095wBfw==
X-Google-Smtp-Source: AGHT+IEEGLyii3aUasxcuPocdOK0Vspj4P9pjJ/spYgKztqFYT3Mr3ycE6hYjTmsTLqbwlPPNX+TJ0UKeNgWANwRlcc=
X-Received: by 2002:a50:9b07:0:b0:543:fc4f:b7ac with SMTP id
 o7-20020a509b07000000b00543fc4fb7acmr56154edi.7.1699102316747; Sat, 04 Nov
 2023 05:51:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231104000239.367005-1-seanjc@google.com> <20231104000239.367005-7-seanjc@google.com>
In-Reply-To: <20231104000239.367005-7-seanjc@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Sat, 4 Nov 2023 05:51:45 -0700
Message-ID: <CALMp9eTQiom+0b5qPP_0u2tGqw9GcWbJVMNGeNZms8MTH8byuQ@mail.gmail.com>
Subject: Re: [PATCH v6 06/20] KVM: selftests: Add vcpu_set_cpuid_property() to
 set properties
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Like Xu <likexu@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 3, 2023 at 5:02=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> From: Jinrong Liang <cloudliang@tencent.com>
>
> Add vcpu_set_cpuid_property() helper function for setting properties, and
> use it instead of open coding an equivalent for MAX_PHY_ADDR.  Future vPM=
U
> testcases will also need to stuff various CPUID properties.
>
> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../testing/selftests/kvm/include/x86_64/processor.h |  4 +++-
>  tools/testing/selftests/kvm/lib/x86_64/processor.c   | 12 +++++++++---
>  .../kvm/x86_64/smaller_maxphyaddr_emulation_test.c   |  2 +-
>  3 files changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/too=
ls/testing/selftests/kvm/include/x86_64/processor.h
> index 25bc61dac5fb..a01931f7d954 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -994,7 +994,9 @@ static inline void vcpu_set_cpuid(struct kvm_vcpu *vc=
pu)
>         vcpu_ioctl(vcpu, KVM_GET_CPUID2, vcpu->cpuid);
>  }
>
> -void vcpu_set_cpuid_maxphyaddr(struct kvm_vcpu *vcpu, uint8_t maxphyaddr=
);
> +void vcpu_set_cpuid_property(struct kvm_vcpu *vcpu,
> +                            struct kvm_x86_cpu_property property,
> +                            uint32_t value);
>
>  void vcpu_clear_cpuid_entry(struct kvm_vcpu *vcpu, uint32_t function);
>  void vcpu_set_or_clear_cpuid_feature(struct kvm_vcpu *vcpu,
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/t=
esting/selftests/kvm/lib/x86_64/processor.c
> index d8288374078e..9e717bc6bd6d 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -752,11 +752,17 @@ void vcpu_init_cpuid(struct kvm_vcpu *vcpu, const s=
truct kvm_cpuid2 *cpuid)
>         vcpu_set_cpuid(vcpu);
>  }
>
> -void vcpu_set_cpuid_maxphyaddr(struct kvm_vcpu *vcpu, uint8_t maxphyaddr=
)
> +void vcpu_set_cpuid_property(struct kvm_vcpu *vcpu,
> +                            struct kvm_x86_cpu_property property,
> +                            uint32_t value)
>  {
> -       struct kvm_cpuid_entry2 *entry =3D vcpu_get_cpuid_entry(vcpu, 0x8=
0000008);
> +       struct kvm_cpuid_entry2 *entry;
> +
> +       entry =3D __vcpu_get_cpuid_entry(vcpu, property.function, propert=
y.index);
> +
> +       (&entry->eax)[property.reg] &=3D ~GENMASK(property.hi_bit, proper=
ty.lo_bit);
> +       (&entry->eax)[property.reg] |=3D value << (property.lo_bit);

What if 'value' is too large?

Perhaps:
         value <<=3D property.lo_bit;
         TEST_ASSERT(!(value & ~GENMASK(property.hi_bit,
property.lo_bit)), "value is too large");
         (&entry->eax)[property.reg] |=3D value;

> -       entry->eax =3D (entry->eax & ~0xff) | maxphyaddr;
>         vcpu_set_cpuid(vcpu);
>  }
>
> diff --git a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulat=
ion_test.c b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulatio=
n_test.c
> index 06edf00a97d6..9b89440dff19 100644
> --- a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_tes=
t.c
> +++ b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_tes=
t.c
> @@ -63,7 +63,7 @@ int main(int argc, char *argv[])
>         vm_init_descriptor_tables(vm);
>         vcpu_init_descriptor_tables(vcpu);
>
> -       vcpu_set_cpuid_maxphyaddr(vcpu, MAXPHYADDR);
> +       vcpu_set_cpuid_property(vcpu, X86_PROPERTY_MAX_PHY_ADDR, MAXPHYAD=
DR);
>
>         rc =3D kvm_check_cap(KVM_CAP_EXIT_ON_EMULATION_FAILURE);
>         TEST_ASSERT(rc, "KVM_CAP_EXIT_ON_EMULATION_FAILURE is unavailable=
");
> --
> 2.42.0.869.gea05f2083d-goog
>

