Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63C156D20C7
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 14:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbjCaMrj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 08:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232350AbjCaMrd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 08:47:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C967120323;
        Fri, 31 Mar 2023 05:47:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A12362889;
        Fri, 31 Mar 2023 12:47:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946E6C433A8;
        Fri, 31 Mar 2023 12:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680266824;
        bh=JCi9GVM3mtwp6mIWudeUCVrCJNL56Muu1u8evTBy+Wc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=I/36sq5YnttrK9nAJ+yAGj5x1IpyNsT71dECgjcBoaca9HJKhneSL4z3L6otMFji3
         GOq/2hPGw6UR5D3BFyqa8TjCrqlFuvRJ66X/cG8E+mntKhf4ICBjJ1/dlYFYaA8Yc4
         3GOJIfyG2idba3EzDGv6X8RZkHCoFGp3To+lOAyj1M/UkxchL4VH7umv2G/l08/VkJ
         040/Tlts8qn+VMOCR3m6jTv81npE+cCzoTwDBNLfO737ZBVuuvzk56RjtGwkDwYKjy
         zS1THS9S28ejO0jvGJeBP3utl3TzvZ87rxeQgWfiyI1wWdXuonTWyuxIXtSJnqwwdw
         sn8dL7+KF2WSw==
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-5445009c26bso412547247b3.8;
        Fri, 31 Mar 2023 05:47:04 -0700 (PDT)
X-Gm-Message-State: AAQBX9cz1CZktmiZc11UBF4T8jb0ZoSOyONiAzXlSPjR4OAQb5PiIbWO
        MaKf7rcfCm7EyFzph2T1f+wHhco7kar28G01Gw==
X-Google-Smtp-Source: AKy350aWaizMSmlvku55rVfJmDcUeUGwlpCsDANKH3NMxDTLCeFuL9w+bIkaybQ1c5aF0yC2W2Oz1NrI68bsVGHq5rA=
X-Received: by 2002:a81:ae4f:0:b0:545:ed8e:f4f6 with SMTP id
 g15-20020a81ae4f000000b00545ed8ef4f6mr9257438ywk.5.1680266823488; Fri, 31 Mar
 2023 05:47:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230331014356.1033759-1-davidai@google.com> <20230331014356.1033759-6-davidai@google.com>
In-Reply-To: <20230331014356.1033759-6-davidai@google.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Fri, 31 Mar 2023 07:46:52 -0500
X-Gmail-Original-Message-ID: <CAL_JsqJErVOZZ==i1HpMABfuVEDC+drboLTntMDB0sUC9ZdQ_Q@mail.gmail.com>
Message-ID: <CAL_JsqJErVOZZ==i1HpMABfuVEDC+drboLTntMDB0sUC9ZdQ_Q@mail.gmail.com>
Subject: Re: [RFC PATCH v2 5/6] dt-bindings: cpufreq: add bindings for virtual
 kvm cpufreq
To:     David Dai <davidai@google.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Saravana Kannan <saravanak@google.com>,
        kernel-team@android.com, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 30, 2023 at 8:45=E2=80=AFPM David Dai <davidai@google.com> wrot=
e:
>
> Add devicetree bindings for a virtual kvm cpufreq driver.
>
> Co-developed-by: Saravana Kannan <saravanak@google.com>
> Signed-off-by: Saravana Kannan <saravanak@google.com>
> Signed-off-by: David Dai <davidai@google.com>
> ---
>  .../bindings/cpufreq/cpufreq-virtual-kvm.yaml | 39 +++++++++++++++++++
>  1 file changed, 39 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/cpufreq/cpufreq-vir=
tual-kvm.yaml
>
> diff --git a/Documentation/devicetree/bindings/cpufreq/cpufreq-virtual-kv=
m.yaml b/Documentation/devicetree/bindings/cpufreq/cpufreq-virtual-kvm.yaml
> new file mode 100644
> index 000000000000..31e64558a7f1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/cpufreq/cpufreq-virtual-kvm.yaml
> @@ -0,0 +1,39 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/cpufreq/cpufreq-virtual-kvm.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Virtual KVM CPUFreq
> +
> +maintainers:
> +  - David Dai <davidai@google.com>
> +
> +description: |
> +
> +  KVM CPUFreq is a virtualized driver in guest kernels that sends utiliz=
ation
> +  of its vCPUs as a hint to the host. The host uses hint to schedule vCP=
U
> +  threads and select CPU frequency. It enables accurate Per-Entity Load
> +  Tracking for tasks running in the guest by querying host CPU frequency
> +  unless a virtualized FIE exists(Like AMUs).
> +
> +properties:
> +  compatible:
> +    const: virtual,kvm-cpufreq
> +
> +required:
> +  - compatible
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    {
> +      #address-cells =3D <2>;
> +      #size-cells =3D <2>;
> +
> +      cpufreq {
> +            compatible =3D "virtual,kvm-cpufreq";
> +      };

The same thing was tried on non-virtual h/w too. This is not a device
so it doesn't go in DT. It is just an abuse of DT as a kernel driver
instantiation mechanism.

Rob
