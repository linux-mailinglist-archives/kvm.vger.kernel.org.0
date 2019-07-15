Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 491E16830E
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 06:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfGOEvH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 00:51:07 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36292 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfGOEvG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 00:51:06 -0400
Received: by mail-qt1-f193.google.com with SMTP id z4so14336409qtc.3;
        Sun, 14 Jul 2019 21:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=fxoz3b35mB76XmW1D+fGughI9Hfn9dcGcsYdA0ynYnE=;
        b=Vp/3NvGpixQOiFSyHoz043jbp6eh2e/QJSONwfpQk+78wlJgHWJd3jOCFOQSxgoVI1
         wAs0vnW1AtQhJjk0jeUsxwe4+VFZVdAnTC6ts5rV1wWQjYZ5iT0ajDyUAHY5CFU15HmK
         bBDJIqxwWTmarrOcfBBYHlV5IuVrBrvRm9LwapVUZDCVCmSpFbfRhYIOmarha1TMarG9
         3yNyhz9cebweUUawXWaCttvISn5y8eyvML/g+MJS3QStIThJTRUxXYo4u+Z7AIgIDtJw
         wZf1bJHi3wPMkXt0/6uzsiI8J0d39E3GtcgL1ACCURzjHk8SVOPnxC9GqYxqM8UqTnJc
         QTcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=fxoz3b35mB76XmW1D+fGughI9Hfn9dcGcsYdA0ynYnE=;
        b=NOO7AecSiIkciGWfmCW19CxtG0Hc6lUHODwk7WYk6fJgHEkgh1zzsWsmJAQjaUnN4K
         UypxkD9ilbqv2ThfmGT3r7EhhI+wHvX8ornKkCcHXkK/9zJZRuLw5QRlz63qaKXGezBY
         x0IDZoLZIWNmqqykqgQ0bRlABizwvz4EbyUQDo8F5spUCOXwNWfNTO3lbvrc93vlZxVp
         XewM0GPN0WLP0HQKt6gSw5RVJYemz+hTNmw+rNn2hFu0sZ4kiV7k8FzAXMRbvPqerEhV
         BIvwfiRIBqCVM+F5nZdyAR57hzIQV0KYodtkjrD+YlWvdGsz4aeJpHz4I3tLehr5P4E2
         nu2Q==
X-Gm-Message-State: APjAAAX17xwv16JhtPZtW5w+aL0YQfYnIs88rtFUEYTHoEWjQ+c006I0
        ZFIPbIo0f7KJys+9TcEK5Qc=
X-Google-Smtp-Source: APXvYqyxF2poLFEuAbDTKuoCIELx2C8lbGD+bR5JkW9AE+lOJyyNAcBdctpdm3+lRbEthmwyFQzhfg==
X-Received: by 2002:a05:6214:1c3:: with SMTP id c3mr11052124qvt.144.1563166265855;
        Sun, 14 Jul 2019 21:51:05 -0700 (PDT)
Received: from [240.0.0.1] ([104.168.52.128])
        by smtp.gmail.com with ESMTPSA id s25sm7181207qkm.130.2019.07.14.21.51.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Jul 2019 21:51:05 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] kvm: x86: some tsc debug cleanup
From:   Yi Wang <up2wing@gmail.com>
X-Mailer: iPhone Mail (16F203)
In-Reply-To: <1562346622-1003-1-git-send-email-wang.yi59@zte.com.cn>
Date:   Mon, 15 Jul 2019 12:50:58 +0800
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        xue.zhihong@zte.com.cn, wang.liang82@zte.com.cn
Content-Transfer-Encoding: quoted-printable
Message-Id: <499986B6-E3E3-4A43-A820-8D9B5E05F14B@gmail.com>
References: <1562346622-1003-1-git-send-email-wang.yi59@zte.com.cn>
To:     Yi Wang <wang.yi59@zte.com.cn>, Paolo Bonzini <pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,
Would you help to review this patch, plz?
Many thanks.

---
Best wishes
Yi Wang

> =E5=9C=A8 2019=E5=B9=B47=E6=9C=886=E6=97=A5=EF=BC=8C01:10=EF=BC=8CYi Wang <=
wang.yi59@zte.com.cn> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> There are some pr_debug in TSC code, which may have
> been no use, so remove them as Paolo suggested.
>=20
> Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
> ---
> arch/x86/kvm/x86.c | 8 --------
> 1 file changed, 8 deletions(-)
>=20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fafd81d..86f9861 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1518,9 +1518,6 @@ static void kvm_get_time_scale(uint64_t scaled_hz, u=
int64_t base_hz,
>=20
>    *pshift =3D shift;
>    *pmultiplier =3D div_frac(scaled64, tps32);
> -
> -    pr_debug("%s: base_hz %llu =3D> %llu, shift %d, mul %u\n",
> -         __func__, base_hz, scaled_hz, shift, *pmultiplier);
> }
>=20
> #ifdef CONFIG_X86_64
> @@ -1763,12 +1760,10 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, struct m=
sr_data *msr)
>        vcpu->arch.virtual_tsc_khz =3D=3D kvm->arch.last_tsc_khz) {
>        if (!kvm_check_tsc_unstable()) {
>            offset =3D kvm->arch.cur_tsc_offset;
> -            pr_debug("kvm: matched tsc offset for %llu\n", data);
>        } else {
>            u64 delta =3D nsec_to_cycles(vcpu, elapsed);
>            data +=3D delta;
>            offset =3D kvm_compute_tsc_offset(vcpu, data);
> -            pr_debug("kvm: adjusted tsc offset by %llu\n", delta);
>        }
>        matched =3D true;
>        already_matched =3D (vcpu->arch.this_tsc_generation =3D=3D kvm->arc=
h.cur_tsc_generation);
> @@ -1787,8 +1782,6 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr=
_data *msr)
>        kvm->arch.cur_tsc_write =3D data;
>        kvm->arch.cur_tsc_offset =3D offset;
>        matched =3D false;
> -        pr_debug("kvm: new tsc generation %llu, clock %llu\n",
> -             kvm->arch.cur_tsc_generation, data);
>    }
>=20
>    /*
> @@ -6857,7 +6850,6 @@ static void kvm_timer_init(void)
>        cpufreq_register_notifier(&kvmclock_cpufreq_notifier_block,
>                      CPUFREQ_TRANSITION_NOTIFIER);
>    }
> -    pr_debug("kvm: max_tsc_khz =3D %ld\n", max_tsc_khz);
>=20
>    cpuhp_setup_state(CPUHP_AP_X86_KVM_CLK_ONLINE, "x86/kvm/clk:online",
>              kvmclock_cpu_online, kvmclock_cpu_down_prep);
> --=20
> 1.8.3.1
>=20
