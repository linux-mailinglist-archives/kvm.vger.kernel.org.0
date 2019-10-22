Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCDFE032B
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 13:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388777AbfJVLkN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 07:40:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42484 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387827AbfJVLkK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 07:40:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571744408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=hr2PZJqY6ri+x9eL2G3gfJOxyUdGSaLhO3Ruj/lc0V8=;
        b=KQ5y4F2cjGidXq7KGelAR5P63EKnOutUbh92mC8f0mWRXMIHnl7ae9Ny0BAzZsDrEB7hKf
        K4R8G9ttUMYksdWk+JzftolE6pZQ1XbVg/D2D3JAhbbhUTiYABHmjtOW+/hM6PbRfWyL7t
        /IlLdCuzBthRbJqWHgeZuEGKqlm1uho=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-MqsjyqubOQu726AscDNXNw-1; Tue, 22 Oct 2019 07:40:07 -0400
Received: by mail-wm1-f70.google.com with SMTP id q22so5752529wmc.1
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2019 04:40:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PeLZbmIO9rpF1zF9RF04jfgeZFapsne4Se0jbZ+6eME=;
        b=jOrEVbZWR15SYwHAsdKQdO7hgu1/upw66p+Fsf2LVLPhXhmNUyk9JGhK1EtRecP4p1
         EdZCmOki8vkoB26qKxaL9SIKWnt3HZKUh0qPhl18kVwUw4VKJ5gKwVkRgkTh3OF3hmKx
         xnN+396w7sM+oy9tXkSNTcGCxf9cvPBdYb6g5faQuoY9MfXDXAGPyprunlc8ccRtOYM3
         r6wMVSioVe4cBwV5EPtWgLiJTlApbDm4MC+Cy2J2OXg1Oo9o696W2SjGhdjj7+jgbWp5
         +TqWaPMwQPnQdYm7HIeZ2hIZUCAyZ5Tzae2SmF/6IFotvGEm+oHtc2zAglEPpufNok4t
         QXZw==
X-Gm-Message-State: APjAAAWe8GfoL+6GeQmJrR2VBMaEVzzw7z38q41efi7cSTYaaqML+ixU
        4EXu5bGOXBOnr3AQv5CdA3JHq5HtOdP2xrPClRuY4sc+ZGxFRbxBy13oTmBGI0MX53QpN/rrlxK
        xMZ8LwJCuscO8
X-Received: by 2002:a5d:4803:: with SMTP id l3mr3107946wrq.381.1571744405929;
        Tue, 22 Oct 2019 04:40:05 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxOzCpV/sIwcKO18/EmaaENiPNQj4rz0dY689l1MwSwWyS7FlrjW+u/4JCPYAZK91BybxKeZw==
X-Received: by 2002:a5d:4803:: with SMTP id l3mr3107924wrq.381.1571744405614;
        Tue, 22 Oct 2019 04:40:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c0e4:dcf4:b543:ce19? ([2001:b07:6468:f312:c0e4:dcf4:b543:ce19])
        by smtp.gmail.com with ESMTPSA id s12sm18705126wra.82.2019.10.22.04.40.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2019 04:40:05 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86/vPMU: Declare kvm_pmu->reprogram_pmi field using
 DECLARE_BITMAP
To:     Like Xu <like.xu@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <2175c2cd-2c1e-22e8-2f67-3fc334ef2a40@redhat.com>
 <20191021105504.120838-1-like.xu@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <6b7569cf-5977-6992-8c97-cd8a11660f3d@redhat.com>
Date:   Tue, 22 Oct 2019 13:40:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191021105504.120838-1-like.xu@linux.intel.com>
Content-Language: en-US
X-MC-Unique: MqsjyqubOQu726AscDNXNw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/10/19 12:55, Like Xu wrote:
> Replace the explicit declaration of "u64 reprogram_pmi" with the generic
> macro DECLARE_BITMAP for all possible appropriate number of bits.
>=20
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/pmu.c              | 15 +++++----------
>  2 files changed, 6 insertions(+), 11 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 50eb430b0ad8..236a876a5a2e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -469,7 +469,7 @@ struct kvm_pmu {
>  =09struct kvm_pmc gp_counters[INTEL_PMC_MAX_GENERIC];
>  =09struct kvm_pmc fixed_counters[INTEL_PMC_MAX_FIXED];
>  =09struct irq_work irq_work;
> -=09u64 reprogram_pmi;
> +=09DECLARE_BITMAP(reprogram_pmi, X86_PMC_IDX_MAX);
>  };
> =20
>  struct kvm_pmu_ops;
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 46875bbd0419..75e8f9fae031 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -62,8 +62,7 @@ static void kvm_perf_overflow(struct perf_event *perf_e=
vent,
>  =09struct kvm_pmc *pmc =3D perf_event->overflow_handler_context;
>  =09struct kvm_pmu *pmu =3D pmc_to_pmu(pmc);
> =20
> -=09if (!test_and_set_bit(pmc->idx,
> -=09=09=09      (unsigned long *)&pmu->reprogram_pmi)) {
> +=09if (!test_and_set_bit(pmc->idx, pmu->reprogram_pmi)) {
>  =09=09__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
>  =09=09kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
>  =09}
> @@ -76,8 +75,7 @@ static void kvm_perf_overflow_intr(struct perf_event *p=
erf_event,
>  =09struct kvm_pmc *pmc =3D perf_event->overflow_handler_context;
>  =09struct kvm_pmu *pmu =3D pmc_to_pmu(pmc);
> =20
> -=09if (!test_and_set_bit(pmc->idx,
> -=09=09=09      (unsigned long *)&pmu->reprogram_pmi)) {
> +=09if (!test_and_set_bit(pmc->idx, pmu->reprogram_pmi)) {
>  =09=09__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
>  =09=09kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
> =20
> @@ -137,7 +135,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc=
, u32 type,
>  =09}
> =20
>  =09pmc->perf_event =3D event;
> -=09clear_bit(pmc->idx, (unsigned long*)&pmc_to_pmu(pmc)->reprogram_pmi);
> +=09clear_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
>  }
> =20
>  void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
> @@ -253,16 +251,13 @@ EXPORT_SYMBOL_GPL(reprogram_counter);
>  void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
>  {
>  =09struct kvm_pmu *pmu =3D vcpu_to_pmu(vcpu);
> -=09u64 bitmask;
>  =09int bit;
> =20
> -=09bitmask =3D pmu->reprogram_pmi;
> -
> -=09for_each_set_bit(bit, (unsigned long *)&bitmask, X86_PMC_IDX_MAX) {
> +=09for_each_set_bit(bit, pmu->reprogram_pmi, X86_PMC_IDX_MAX) {
>  =09=09struct kvm_pmc *pmc =3D kvm_x86_ops->pmu_ops->pmc_idx_to_pmc(pmu, =
bit);
> =20
>  =09=09if (unlikely(!pmc || !pmc->perf_event)) {
> -=09=09=09clear_bit(bit, (unsigned long *)&pmu->reprogram_pmi);
> +=09=09=09clear_bit(bit, pmu->reprogram_pmi);
>  =09=09=09continue;
>  =09=09}
> =20
>=20

Queued, thanks.

Paolo

