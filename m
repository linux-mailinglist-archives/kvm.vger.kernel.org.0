Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C06B772931
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 17:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbjHGP2M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 11:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbjHGP2D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 11:28:03 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C0851BE3
        for <kvm@vger.kernel.org>; Mon,  7 Aug 2023 08:27:55 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-4fe389d6f19so7332841e87.3
        for <kvm@vger.kernel.org>; Mon, 07 Aug 2023 08:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1691422073; x=1692026873;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QoOuEPwXAoB1CcjOzijYnAuXvV/Nt/hIFSXgej+7r2U=;
        b=WnujQTuJX9CTtEQZgkoDjS7in/bKcKItleRv5OMk+2I1R2NZsJ217ZnDtiKz0B0tEQ
         b2NxTNA6XTlkTdmTKy7qbTX4ZyOCfnpUcCHxcpnNspb/UscDGFhoS2vv4+SklzfRIDkb
         SMTZuqNAYxIEtQ4IPXJN961rQXHQe5UU9V6pH7oZ65RWqXG65iv73BaXEhDnA+lcMrmt
         imMK5iq9IO+hGkH1FIfKHsrBmhVKKFKowStzsaTB/W1CFndfgZkv2yAb1Gw3PUSUtGJ6
         JTEa1i5Yv0X75Cdqoq+i//njLbeWQJvBWRnxPstoNugOuhnsuNTpdTHDlEiwCxjbjZZA
         xomQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691422073; x=1692026873;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QoOuEPwXAoB1CcjOzijYnAuXvV/Nt/hIFSXgej+7r2U=;
        b=W3Ye8/4g3PGZ0hUKLv0ASMmdLP24pl5Bs+hFQ8J2z4kfmy+IfFkQcxj4/dnqvLax9h
         B9DrNJpj//ZkzEaffJL6YWWIeDld7VzprHy8TQMm7p2NNGVlYAICDZ/VOWWsVc7v2ADP
         BAaVh1XCG3ONE2hz5/wUJhNtrfp8L/htlrHgFnPFD+t2I4MH+exwEtQ/uufSLCtoPmAT
         l16XoVDhospDXa0zd497KO9KuNu7egDv/eUBzkVA0056Y8Sy2emPoS2j3+dCQ0Ln/rRm
         W1VlmMVMI5GEg8qfxFdPQYkWIhMRdzjOPXKWi5dl/Ie3/Qe1XnYbBLgSXA2+bt7qCH1D
         vqCg==
X-Gm-Message-State: AOJu0YyJV0fY6QKVSrCiPawQaFpWEq0KgbE5MY+POqrCEv7ZLE/agSuh
        CW0KHZzZHO4MLjjL7z9k0x2hbG6Cvhmd9tHe/P+IlA==
X-Google-Smtp-Source: AGHT+IGBANRbPwCTQseSaIfmRqk0Uk8t9EGhTT4K7ebfXgm82Uqvo+wFcHhcw3lSVwBBpEFZCQDHH0BGZhTSHgs23Cg=
X-Received: by 2002:a19:5f19:0:b0:4f8:5b23:5287 with SMTP id
 t25-20020a195f19000000b004f85b235287mr6052226lfb.62.1691422073568; Mon, 07
 Aug 2023 08:27:53 -0700 (PDT)
MIME-Version: 1.0
References: <20230727073134.134102-1-akihiko.odaki@daynix.com> <CAFEAcA9zGqkWL2zf_z-CuWEnrGxCHmO_i=_9CY347b8zCC2AuA@mail.gmail.com>
In-Reply-To: <CAFEAcA9zGqkWL2zf_z-CuWEnrGxCHmO_i=_9CY347b8zCC2AuA@mail.gmail.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Mon, 7 Aug 2023 16:27:42 +0100
Message-ID: <CAFEAcA9A9ZG8q6cYYbtUNgAe5JQZKVKKXWWzipzDDqcjLr39sQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/6] accel/kvm: Specify default IPA size for arm64
To:     Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-stable <qemu-stable@nongnu.org>
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

On Fri, 4 Aug 2023 at 18:41, Peter Maydell <peter.maydell@linaro.org> wrote=
:
>
> On Thu, 27 Jul 2023 at 08:31, Akihiko Odaki <akihiko.odaki@daynix.com> wr=
ote:
> >
> > Some Arm systems such as Apple Silicon Macs have IPA size smaller than =
the
> > default used by KVM. Introduce our own default IPA size that fits on su=
ch a
> > system.
> >
> > When reviewing this series, Philippe Mathieu-Daud=C3=A9 found the error=
 handling
> > around KVM type decision logic is flawed so I added a few patches for f=
ixing
> > the error handling path.
> >
> > V4 -> V5: Fixed KVM type error handling
> > V3 -> V4: Removed an inclusion of kvm_mips.h that is no longer needed.
> > V2 -> V3: Changed to use the maximum IPA size as the default.
> > V1 -> V2: Introduced an arch hook
>
> Applied to target-arm-for-8.2 with an extra doc comment in patch 1;
> thanks.

I also figured it would be good to tag the first 2 patches
for qemu-stable, so I'll do that as well.

thanks
-- PMM
