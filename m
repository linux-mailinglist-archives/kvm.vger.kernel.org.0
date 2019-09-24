Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4DABC9F4
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 16:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388593AbfIXOQ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 10:16:27 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26118 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725855AbfIXOQ1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Sep 2019 10:16:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569334585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7SmBVrwKiIfuuB1qVseZcm0ycdGq172UWF2BBHbCP00=;
        b=FQ7NedjM2X4Snym8XowumBeNmzcDv65dBlxihS3gfr+bJGm8oqIL/2pfzBkfatyAvstyag
        kXKndnyvnoQiU4oSY/YGzoJXIp99k1v1yoPx/bGjr5phbEG+yY5WlUmqXgEvJXCWNTK4Qo
        G/dVuuvqosui2/vMWmAOrgtj9QxG/uM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-BJ-CC5icPzGC6slTC3nPgw-1; Tue, 24 Sep 2019 10:16:21 -0400
Received: by mail-wm1-f70.google.com with SMTP id 124so994871wmz.1
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 07:16:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O3zc9qvekpNrsQ2hzd1nrdMAy/4wQjyvjm3uXovRTdE=;
        b=jy+kC/U6FVjufncVvQA7DFOlHhQB9nv/8Q9++w08F96K4NFQPcs7tYfI3lK49RPVWc
         wxcqXH+gvXJvCSLK3x5j4eRrV5YljOOLIRJys4B0atKNqCYWNTtQrQRQD9nPiNm1SqXa
         CXWQJzgAiB3Bfi0LG3+otaQRc12E2K+/InZtCxnwONpM91MFZS6y6em2U+bOp5W7p6s7
         OxFidQ7biCbXtEqXTuRQuckWeaUruTBzaKBRNzQ9SxvxrTSjcGc+cs3AZUN59lHtnBbO
         7esLIGUDh3rVnA7Qxf4dG+I0amZ1MPjxTEsaytkGFO+athVttkAroNglzEHlJ0PPfufP
         8p+w==
X-Gm-Message-State: APjAAAWtzlys7axDDo2LoABkgeh/mqq1TKtJkyqrI2i4sUCqtoDAtZLx
        lb7631XzNNLKgh0xrgkcfIBxi7ZBjkYPlJZDOn0UsWBXpct6MPJxZlEL1q9T/uWUe35vyBIM7xY
        CXlgdKl2iq2xx
X-Received: by 2002:a1c:48d5:: with SMTP id v204mr247292wma.109.1569334580293;
        Tue, 24 Sep 2019 07:16:20 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxH7eko9xUPqG4sbqQTR47fFTpPBLlj1DttmLuYtq58OQMNQzvy3AXXGQ5OqZbGsywciYipcw==
X-Received: by 2002:a1c:48d5:: with SMTP id v204mr247263wma.109.1569334580000;
        Tue, 24 Sep 2019 07:16:20 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id d9sm3799551wrf.62.2019.09.24.07.16.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Sep 2019 07:16:19 -0700 (PDT)
Subject: Re: [PATCH] kvm: svm: Intercept RDPRU
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Drew Schmitt <dasch@google.com>, Jacob Xu <jacobhxu@google.com>,
        Peter Shier <pshier@google.com>
References: <20190919225917.36641-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <876a8f61-e84f-c3e1-a9c5-b2a26a083655@redhat.com>
Date:   Tue, 24 Sep 2019 16:16:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190919225917.36641-1-jmattson@google.com>
Content-Language: en-US
X-MC-Unique: BJ-CC5icPzGC6slTC3nPgw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/09/19 00:59, Jim Mattson wrote:
> The RDPRU instruction gives the guest read access to the IA32_APERF
> MSR and the IA32_MPERF MSR. According to volume 3 of the APM, "When
> virtualization is enabled, this instruction can be intercepted by the
> Hypervisor. The intercept bit is at VMCB byte offset 10h, bit 14."
> Since we don't enumerate the instruction in KVM_SUPPORTED_CPUID,
> intercept it and synthesize #UD.
>=20
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Drew Schmitt <dasch@google.com>
> Reviewed-by: Jacob Xu <jacobhxu@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>

Ugly stuff---Intel did the right thing in making the execution controls
"enable xxx" (xxx =3D RDRAND, RDSEED, etc.).

Queued, thanks.

Paolo

> ---
>  arch/x86/include/asm/svm.h      | 1 +
>  arch/x86/include/uapi/asm/svm.h | 1 +
>  arch/x86/kvm/svm.c              | 8 ++++++++
>  3 files changed, 10 insertions(+)
>=20
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index dec9c1e84c78..6ece8561ba66 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -52,6 +52,7 @@ enum {
>  =09INTERCEPT_MWAIT,
>  =09INTERCEPT_MWAIT_COND,
>  =09INTERCEPT_XSETBV,
> +=09INTERCEPT_RDPRU,
>  };
> =20
> =20
> diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/=
svm.h
> index a9731f8a480f..2e8a30f06c74 100644
> --- a/arch/x86/include/uapi/asm/svm.h
> +++ b/arch/x86/include/uapi/asm/svm.h
> @@ -75,6 +75,7 @@
>  #define SVM_EXIT_MWAIT         0x08b
>  #define SVM_EXIT_MWAIT_COND    0x08c
>  #define SVM_EXIT_XSETBV        0x08d
> +#define SVM_EXIT_RDPRU         0x08e
>  #define SVM_EXIT_NPF           0x400
>  #define SVM_EXIT_AVIC_INCOMPLETE_IPI=09=090x401
>  #define SVM_EXIT_AVIC_UNACCELERATED_ACCESS=090x402
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 04fe21849b6e..cef00e959679 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1539,6 +1539,7 @@ static void init_vmcb(struct vcpu_svm *svm)
>  =09set_intercept(svm, INTERCEPT_SKINIT);
>  =09set_intercept(svm, INTERCEPT_WBINVD);
>  =09set_intercept(svm, INTERCEPT_XSETBV);
> +=09set_intercept(svm, INTERCEPT_RDPRU);
>  =09set_intercept(svm, INTERCEPT_RSM);
> =20
>  =09if (!kvm_mwait_in_guest(svm->vcpu.kvm)) {
> @@ -3830,6 +3831,12 @@ static int xsetbv_interception(struct vcpu_svm *sv=
m)
>  =09return 1;
>  }
> =20
> +static int rdpru_interception(struct vcpu_svm *svm)
> +{
> +=09kvm_queue_exception(&svm->vcpu, UD_VECTOR);
> +=09return 1;
> +}
> +
>  static int task_switch_interception(struct vcpu_svm *svm)
>  {
>  =09u16 tss_selector;
> @@ -4791,6 +4798,7 @@ static int (*const svm_exit_handlers[])(struct vcpu=
_svm *svm) =3D {
>  =09[SVM_EXIT_MONITOR]=09=09=09=3D monitor_interception,
>  =09[SVM_EXIT_MWAIT]=09=09=09=3D mwait_interception,
>  =09[SVM_EXIT_XSETBV]=09=09=09=3D xsetbv_interception,
> +=09[SVM_EXIT_RDPRU]=09=09=09=3D rdpru_interception,
>  =09[SVM_EXIT_NPF]=09=09=09=09=3D npf_interception,
>  =09[SVM_EXIT_RSM]                          =3D rsm_interception,
>  =09[SVM_EXIT_AVIC_INCOMPLETE_IPI]=09=09=3D avic_incomplete_ipi_intercept=
ion,
>=20

