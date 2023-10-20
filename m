Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0D7F7D14FF
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 19:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377713AbjJTRk3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 13:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbjJTRk1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 13:40:27 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D54A126
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 10:40:22 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-53da72739c3so1599445a12.3
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 10:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697823620; x=1698428420; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5ecj4k7fUCeUFhk806jIEjdUHq1mY981ro5iqfcu8WI=;
        b=TmGNayKN87psKIMRzQKmID+ZWRgnboVIOzbAL8f1aXuwH47g0HOJ2re9G0IvLViVBy
         fHmEgV0eImxz9wPRub3skZNzK6oS6EF2tlZ8GW5Upkzx0OsN4nQMkC8jbyAqsxeSYDxU
         m6Vfi1Z3p6ddzwF5L6q8yP7kRFNA1JozDxQMDsr04D/g1yZl7U06pnM3MmDoitXOugCE
         dMcgJAAFyfMsvLPNdeva1yW7gvPaWN4+p/lVbShkZMGNQn9esQ9QcNRJhxfvkl6I8ImT
         HAUm15lBU6Fd6FZuRRSCkgw20+PZ6yTz8p8S7Ds7gXeFmPCDblqZ1I/vlRwx4mJOy3uf
         /92g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697823620; x=1698428420;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5ecj4k7fUCeUFhk806jIEjdUHq1mY981ro5iqfcu8WI=;
        b=QJE7OzE1mk/wpQxTTJ5OUzyl6N7GJrltWRI+v1q92hJ8CRVzN61oXx3iO1T8iY6PbX
         gqHXowwi0whGH+b7uebNFxVAYTY4p1hLPk7K6OFni3IM0k/XwfhGQWtBZAsaQUaWrcZz
         5OMAB7J6o0nuSWQn10hIqluVZLFJO9NsSSRNqIrcoXmowkcMDki0Qp0fBBrrhFme+TMN
         uOaWMX9PZb41e3DmiCWtUjz5tZjJOZ2pJ67OjUf4kPcmAWzAh9KCFHK+7mmyhPJU4XlK
         F0IhRkD+rf9ZtGgztLSM4nCaLZpNoKy7YHJb7DM2zAWxk7X6Lgx2C+hZBCeKhXpoU7LQ
         T3VA==
X-Gm-Message-State: AOJu0YzLBHwkkIF2WPmnKWg9a57Dg+cvRgtDsWWWjXoMJMfbMfYLHIv3
        6rEfeoDUKDmRTfuyPGq98A251I+73/USOmtIpgBJWg==
X-Google-Smtp-Source: AGHT+IG5XeIAflMpcqUls1q2bcmzj8M2720/NorBsJ559jux9veJWCY8EgwkFHN3rl7l1ptkNMF9o7lWjVanb/aRjds=
X-Received: by 2002:a05:6402:26cd:b0:53d:d913:d3cb with SMTP id
 x13-20020a05640226cd00b0053dd913d3cbmr2077965edd.28.1697823620612; Fri, 20
 Oct 2023 10:40:20 -0700 (PDT)
MIME-Version: 1.0
References: <20231020163643.86105-1-philmd@linaro.org> <20231020163643.86105-2-philmd@linaro.org>
 <CAFEAcA9FT+QMyQSLCeLjd7tEfaoS9JazmkYWQE++s1AmF7Nfvw@mail.gmail.com> <56646980-d38c-d844-1ee6-80453d092172@linaro.org>
In-Reply-To: <56646980-d38c-d844-1ee6-80453d092172@linaro.org>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Fri, 20 Oct 2023 18:40:09 +0100
Message-ID: <CAFEAcA-SwdO9qo=dFpbwOuEo2fu_WFxD7L5BipVnuvk99cz=Hg@mail.gmail.com>
Subject: Re: [RFC PATCH 01/19] cpus: Add argument to qemu_get_cpu() to filter
 CPUs by QOM type
To:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Cc:     =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        qemu-devel@nongnu.org, Thomas Huth <thuth@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        qemu-arm@nongnu.org, qemu-riscv@nongnu.org,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        qemu-ppc@nongnu.org, Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-s390x@nongnu.org,
        Zhao Liu <zhao1.liu@intel.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Radoslaw Biernacki <rad@semihalf.com>,
        Leif Lindholm <quic_llindhol@quicinc.com>,
        Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
        Shannon Zhao <shannon.zhaosl@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        David Woodhouse <dwmw2@infradead.org>,
        Paul Durrant <paul@xen.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Bin Meng <bin.meng@windriver.com>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Song Gao <gaosong@loongson.cn>,
        Thomas Huth <huth@tuxfamily.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        "Dr. David Alan Gilbert" <dave@treblig.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 20 Oct 2023 at 18:29, Philippe Mathieu-Daud=C3=A9 <philmd@linaro.or=
g> wrote:
>
> Hi Peter,
>
> On 20/10/23 19:14, Peter Maydell wrote:
> > So overall there are some places where figuring out the right
> > replacement for qemu_get_cpu() is tricky, and some places where
> > it's probably fairly straightforward but just an annoying
> > amount of extra code to write, and some places where we don't
> > care because we know the board model is not heterogenous.
> > But I don't think "filter by CPU architecture type" is usually
> > going to be what we want.
>
> Thank for these feedbacks. I agree the correct way to fix that
> is a tedious case by case audit, most often using link properties.
>
> "we know the board model is not heterogeneous" but we want to
> link such board/model altogether in a single binary, using common
> APIs.

This seems to me like a different thing -- just compiling
the different boards into one binary. That should be fine:
in this single-binary qemu, if you tell it -M foo that's an arm
board then qemu_get_cpu() returns the CPUs that are created,
and those will all be Arm. If you tell it -M bar that's a PPC
board, then qemu_get_cpu() will return the CPUs that are
created, and those will all be PPC. The assumptions of the
code that's currently calling qemu_get_cpu() or using the
first_cpu global won't be broken. It shouldn't need us to
change a lot of code that we don't intend to try to use in a
heterogenous-at-runtime setup.

thanks
-- PMM
