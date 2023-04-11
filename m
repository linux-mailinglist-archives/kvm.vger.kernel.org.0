Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEA76DDE0B
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 16:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjDKOf1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 10:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjDKOf0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 10:35:26 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A71D171B
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 07:35:25 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id gb34so21119747ejc.12
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 07:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681223723; x=1683815723;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y3Txt+HQpQ8Mj9XB8+cfu2O7Y6JX7xFB30c+4HBEc0Y=;
        b=qNnKuI4bVRG+Yze1xxSxL6INqM4EJRCeSBz2A3KqfgGwIn601UYceNDJ65/JDqDoUb
         ZwL/+njQGKtQN5qyhs6oqHCyXoxmgPSuup8iQII9cyMyw0W0iz0qdcAOhacT0pTFlU2j
         j99nWi+ePKrxS8GCBwdL+RJnc0HLgCv3Gw4dq/fZuSAO0UGvW+LFiYQiuY8br9DzjbVQ
         kdK+jxZ8hs6UkQ6lHSVBb8/Ofs/WV3oZNr1OhMv1vKRHSBJ/czOJAdhXgfPtjRXUIDBW
         JEXAh0Toi6V2rRMQbVewtneTnsScuqJZmeupYrK/60gxG8LPMHlWZd0hcSEKTtbUIGzp
         QZqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681223723; x=1683815723;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y3Txt+HQpQ8Mj9XB8+cfu2O7Y6JX7xFB30c+4HBEc0Y=;
        b=GeRIl6hmL2qfdDF8s0G8TxhQZyVMG8sXqd9beUM2WCBL6AcwZH9azVs/wVYgrAFuu2
         lU9iTj0fupSoE4PGi1BHYtFKmuER6XSSL453R/arm+7UzQ509uwjB3tcQ20TGzEc1Oil
         AjX6Y7s1qNEKp8tCNQslzj+a9tGrfebbTMed5vUyAm2P9JjjDqOwNmyREXK8qFp+ZDrW
         TILu3EUPsOaINAZnZCqmmpif/nkEU0RP2JnMD447CkbjQWYy0L9SExeI8Fmr18IhMBzB
         NJemfBYqcLCFSg7jkgr0jCVwzpGp2fmcdlqwX5Vzn/buqvvOFRHDF4/4ft9ExPpxsYYG
         Kg2A==
X-Gm-Message-State: AAQBX9emGtUI4qS432Ho5nYUb/XayaaQE/4pRW0HESyyEQbv6Te+LDnp
        e0EAYMHFIog6hIM95QmuW+USDQMsQfH7RY053HnFACTsv5XPAJ/1
X-Google-Smtp-Source: AKy350Ya/FOtb/RKu8E7+WG9sY1p3h1XruX7gAy5olNZw3A+qo7S5W/KZ769tr1UwCae8KWsft7GgpQDtDWNzrNdfKo=
X-Received: by 2002:a17:907:1628:b0:92f:41e4:e48b with SMTP id
 hb40-20020a170907162800b0092f41e4e48bmr5137574ejc.6.1681223723560; Tue, 11
 Apr 2023 07:35:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230405100848.76145-1-philmd@linaro.org> <42d004e7-efa8-cd94-950b-525eac0d7ee1@linaro.org>
In-Reply-To: <42d004e7-efa8-cd94-950b-525eac0d7ee1@linaro.org>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 11 Apr 2023 15:35:12 +0100
Message-ID: <CAFEAcA9knoY=_7+XMtQY4_vxe78MT9+LkYUrLfThVxkVm5trDg@mail.gmail.com>
Subject: Re: [PATCH 0/2] target/arm: KVM Aarch32 spring cleaning
To:     Richard Henderson <richard.henderson@linaro.org>
Cc:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 5 Apr 2023 at 23:06, Richard Henderson
<richard.henderson@linaro.org> wrote:
>
> On 4/5/23 03:08, Philippe Mathieu-Daud=C3=A9 wrote:
> > Remove unused KVM/Aarch32 definitions.
> >
> > Philippe Mathieu-Daud=C3=A9 (2):
> >    target/arm: Remove KVM AArch32 CPU definitions
> >    hw/arm/virt: Restrict Cortex-A7 check to TCG
> >
> >   target/arm/kvm-consts.h | 9 +++------
> >   hw/arm/virt.c           | 2 ++
> >   target/arm/cpu_tcg.c    | 2 --
> >   3 files changed, 5 insertions(+), 8 deletions(-)
> >
>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

Applied to target-arm.next for 8.1, thanks.

-- PMM
