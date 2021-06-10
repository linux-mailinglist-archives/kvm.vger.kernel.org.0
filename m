Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 610D93A21D4
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 03:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhFJB0S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 21:26:18 -0400
Received: from mail-lj1-f172.google.com ([209.85.208.172]:35659 "EHLO
        mail-lj1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhFJB0P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 21:26:15 -0400
Received: by mail-lj1-f172.google.com with SMTP id n17so2393446ljg.2
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 18:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RMzSuCgOEYIzd573kQ1OWYO+8EI6xppe3qhTmc0uAk8=;
        b=GTgFXw+Q7H4OHIZH0Qqiv1guDzMzyqLqhq8Au3YKfAPWCHHsBlZ+YOmEVkzuT92DS2
         txltkNfX/dLP94AUxInHKdb4SPt/QmbaCChg9X7UqlfDwdDL0s/T4MEokU6e1W/y9vay
         6Mmcekuto86odomlUiJMza+VeqyYiThe8J7WQ3gx2rVjqUCtYo53NWkVGXChmjy0qgyH
         Fj9kvho3tA/J+704p1kw5QDF/exzzztFlZ2iJ1za8ZFoIKlZDMyXMTG8wC2Jj+WNg1Bf
         R1KLqN1VZlwTtFs6OJEMVyHQ1ZFnZW87EBBG7QHohu8kZlD5Y9/OD8pnUIYs7qm2RpB6
         ATwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RMzSuCgOEYIzd573kQ1OWYO+8EI6xppe3qhTmc0uAk8=;
        b=Bxz7ivUitS2HAVTWHq1kQqEkqvFLsDiecWmo+sLVVWT0nEZvRNR+DewNfnesBan5Kj
         6wLYQ+Lq45MqbTeLS5K5sc7lIKs+nwjpqHcxi7C4UP/VAk17u+uUkfZW1IZt9ha6WZKf
         pIZWb9RjKGV0DLtFEoAf8dqQ0iFNSRHh/G6bMMRHwBP7H+klmQe3zAOuoaknOmGR0AKO
         BOpaME8Fltwm6i3rAo2eeisxJ5IYFGw7cFF/o72OGi1rSuD4ekSZHt6s1bkd2zzrF/72
         6tHS9JZ2uCcgV6laHu0W2e2Aq7I6A8/7DpRxBOWxc9WLgBKlUnL9xrFU/jvytdl+BImo
         rrzg==
X-Gm-Message-State: AOAM5312ca+RxgFH3YhQK2bnnxbM1yHqNR9v3yL7D4TXYkvxDDkpoJmP
        gwiit3bN38lepJvA3c1Yf2jl/sQOya/cA11HjKE=
X-Google-Smtp-Source: ABdhPJy4UR+CBwndZVq3L6YU7kKhddJo3vK2tXJQS7lSWA0UPiV/XEdX5KPUeFj75EK8IPqU2mxrA0z/HWjzqv2niRo=
X-Received: by 2002:a2e:8e90:: with SMTP id z16mr296238ljk.508.1623288184506;
 Wed, 09 Jun 2021 18:23:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210609182945.36849-1-nadav.amit@gmail.com> <20210609182945.36849-8-nadav.amit@gmail.com>
In-Reply-To: <20210609182945.36849-8-nadav.amit@gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Date:   Thu, 10 Jun 2021 09:22:48 +0800
Message-ID: <CAA3+yLd4AML_eEtUwzFrd1-KKiiZ4W9Uy0gTdrEMC2YXVayJRQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 7/8] x86/pmu: Skip the tests on PMU version 1
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Nadav,

Nadav Amit <nadav.amit@gmail.com> =E4=BA=8E2021=E5=B9=B46=E6=9C=8810=E6=97=
=A5=E5=91=A8=E5=9B=9B =E4=B8=8A=E5=8D=882:33=E5=86=99=E9=81=93=EF=BC=9A
>
> From: Nadav Amit <nadav.amit@gmail.com>
>
> x86's PMU tests are not compatible with version 1. Instead of finding
> how to adapt them, just skip them if the PMU version is too old.

Instead of skipping pmu.v1, it would be better to just skip the tests
of fixed counters.
But considering this version is really too old, this change looks fine to m=
e.

>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>  x86/pmu.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/x86/pmu.c b/x86/pmu.c
> index 5a3d55b..ec61ac9 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -544,6 +544,12 @@ int main(int ac, char **av)
>                 printf("No pmu is detected!\n");
>                 return report_summary();
>         }
> +
> +       if (eax.split.version_id =3D=3D 1) {
> +               printf("PMU version 1 is not supported\n");
> +               return report_summary();
> +       }
> +
>         printf("PMU version:         %d\n", eax.split.version_id);
>         printf("GP counters:         %d\n", eax.split.num_counters);
>         printf("GP counter width:    %d\n", eax.split.bit_width);
> --
> 2.25.1
>
