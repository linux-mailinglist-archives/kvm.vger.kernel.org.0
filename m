Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1626E6BF088
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 19:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbjCQSQw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 14:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjCQSQv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 14:16:51 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA90CA783
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 11:16:48 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-5416698e889so109225977b3.2
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 11:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679077007;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bFRBKtX+/PyklcfQ2bUmQg4j7iwvYjlYQ0GbIMM+hsQ=;
        b=Q7VKajUdg9R8u40ypO6Vk3mFldx1Cfdmb4K1PsbVh71xYVxOtv3U4r2PMDg5u6Fjvm
         FnQbA3572dCphEwdpiQJwVWkHMSeM52fDrbNF8r/kcMc7svZBYkBJOVkb0S7L0s2/nVf
         14Gv9j9VmvO45WPEk7oYFSOJv2WdBNe1TO9KHzo8SDxPjgGfNU7oXsEYZ0W2Y078VRkT
         4ZHzWGqGzphrleU/w8KFhdOARDbYeprQeJ+utw2CX8HkzE6zsYvCaFLVgY6almH17+v/
         D+9aNtwRVkxynTnnyaUqPeIMVoKApXRb5CrjK440OT/5d8j/q6jcu+lgehkLiG9/TGaX
         ey5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679077007;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bFRBKtX+/PyklcfQ2bUmQg4j7iwvYjlYQ0GbIMM+hsQ=;
        b=cGdOzG5tyPUptTkC++gMOzQU2TinWEEZtMc2PpmI3tS0QtzQdao04tGMk6tjjeUuLY
         q8VqroC/5J2pToGKRxdCgtjaL0GsYlsxxyThSt5FXA+pr17LqPXFGDxYDrKe2aha2Xu4
         8tM3pvqstK/DeT+YuDAcXpMey/Jz4i6bquSKrdkMAXCsSQYoJL20WYmxxWUT62Zyi1Yp
         AG44VkO8VuZYWaeR588P5Y9dA7en4+26lKiF22Q+CySjAtnHd98Hk29JaGjQsUrkuwFu
         h6tDokrbqPtfyjRtrBfIv6/TARRWgfegNDHCxzkNXyUWFPny/50QqWmbhog2PzCCnXxs
         rwwg==
X-Gm-Message-State: AO0yUKXkM4kSxQG6SR3YSqJ5+USGUSkSMyORNJHlXffHtl3c/aA83LbT
        KEVnuHXVlJLzBZErF3WScaJayQjSQHQm4uJae1RZtQ==
X-Google-Smtp-Source: AK7set8JJ7lRaLRQR4qGb7VcDy2cdV2zgVzCwEl/WhleoxOrrb86dpcjLQPiggC1+DsRGV5V/MkEd8kcQntTiELVDWk=
X-Received: by 2002:a81:b703:0:b0:541:a0ab:bd28 with SMTP id
 v3-20020a81b703000000b00541a0abbd28mr2435552ywh.4.1679077007135; Fri, 17 Mar
 2023 11:16:47 -0700 (PDT)
MIME-Version: 1.0
References: <20230316222752.1911001-1-coltonlewis@google.com> <20230316222752.1911001-3-coltonlewis@google.com>
In-Reply-To: <20230316222752.1911001-3-coltonlewis@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Fri, 17 Mar 2023 11:16:11 -0700
Message-ID: <CAHVum0edWWs0cw6pTMFA_qnU++4qP=J88gyL6eSSYaLL-W9kxw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: selftests: Print summary stats of memory
 latency distribution
To:     Colton Lewis <coltonlewis@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Marc Zyngier <maz@kernel.org>, Ben Gardon <bgardon@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 16, 2023 at 3:29=E2=80=AFPM Colton Lewis <coltonlewis@google.co=
m> wrote:
>
> Print summary stats of the memory latency distribution in nanoseconds
> for dirty_log_perf_test. For every iteration, this prints the minimum,
> the maximum, and the 50th, 90th, and 99th percentiles.
>

Can you also write how this is useful and why these 5 specific
percentiles are valuable for testers? Generally, 5 number summaries
are 0, 25, 50, 75, 100 %ile.
It might also be too much data to display with each iteration.

Nit: minimum, 50th, 90th, 99th and maximum since this is the order you
are printing.


> @@ -428,6 +432,7 @@ int main(int argc, char *argv[])
>                 .slots =3D 1,
>                 .random_seed =3D 1,
>                 .write_percent =3D 100,
> +               .samples_per_vcpu =3D 1000,

Why is 1000 the right default choice? Maybe the default should be 0
and if anyone wants to use it then they can use the command line
option to set it?

> @@ -438,7 +443,7 @@ int main(int argc, char *argv[])
>
>         guest_modes_append_default();
>
> -       while ((opt =3D getopt(argc, argv, "ab:c:eghi:m:nop:r:s:v:x:w:"))=
 !=3D -1) {
> +       while ((opt =3D getopt(argc, argv, "ab:c:eghi:m:nop:r:s:S:v:x:w:"=
)) !=3D -1) {

1. Please add the help section to tell about the new command line option.
2. Instead of having s and S, it may be better to use a different
lower case letter, like "l" for latency. Giving this option will print
memory latency and users need to provide the number of samples they
prefer per vCPU.

> @@ -480,6 +485,9 @@ int main(int argc, char *argv[])
>                 case 's':
>                         p.backing_src =3D parse_backing_src_type(optarg);
>                         break;
> +               case 'S':
> +                       p.samples_per_vcpu =3D atoi_positive("Number of s=
amples/vcpu", optarg);
> +                       break;

This will force users to always see latency stat when they do not want
to see it. I think this patch should be modified in a way to easily
disable this feature.
I might be wrong here and it is actually a useful metric to see with
each run. If this is true then maybe the commit should mention why it
is good for each run.

> +void memstress_print_percentiles(struct kvm_vm *vm, int nr_vcpus)
> +{
> +       uint64_t n_samples =3D nr_vcpus * memstress_args.samples_per_vcpu=
;
> +       uint64_t *host_latency_samples =3D addr_gva2hva(vm, memstress_arg=
s.latency_samples);
> +
> +       qsort(host_latency_samples, n_samples, sizeof(uint64_t), &memstre=
ss_qcmp);
> +
> +       pr_info("Latency distribution (ns) =3D min:%6.0lf, 50th:%6.0lf, 9=
0th:%6.0lf, 99th:%6.0lf, max:%6.0lf\n",
> +               cycles_to_ns(vcpus[0], (double)host_latency_samples[0]),

I am not much aware of how tsc is set up and used. Will all vCPUs have
the same tsc value? Can this change if vCPU gets scheduled to
different pCPU on the host?

> +               cycles_to_ns(vcpus[0], (double)host_latency_samples[n_sam=
ples / 2]),
> +               cycles_to_ns(vcpus[0], (double)host_latency_samples[n_sam=
ples * 9 / 10]),
> +               cycles_to_ns(vcpus[0], (double)host_latency_samples[n_sam=
ples * 99 / 100]),
> +               cycles_to_ns(vcpus[0], (double)host_latency_samples[n_sam=
ples - 1]));
> +}

All of the dirty_log_perf_tests print data in seconds followed by
nanoseconds. I will recommend keeping it the same.
Also, 9 digits for nanoseconds instead of 6 as in other formats.
