Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4344A492C21
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 18:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243047AbiARRSL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 12:18:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiARRSK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 12:18:10 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41D3C061574
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 09:18:09 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id ay4-20020a05600c1e0400b0034a81a94607so9278590wmb.1
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 09:18:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q22wl6OCD19GypMuT9QWRHowipst+oy+Pq7cX65GDBI=;
        b=XUFayqN3S6FO4rPKr8roe5K/9ilHZSe4lyDj0PGBjfxYK5UPUK9yVoOP1cuzZi4978
         EL7ELnSrMVQtL1DugrfPVtAtJSIY9W+fs7/RXfkHB2QzccKaNTJw8Quj6AapJKw7kBCy
         zZ+HMyYgZvn9L1V9WWHUmuzT0IOQLDQJqJbGehtZvALfgf8Ff/QezpFCPRx7KvGTEUH6
         G8cfFfn2dpLENFi+QttOleeMdDgK8352iOb30OOWBVbWR4NbhjndWOglswuUnm5+5zw1
         J8KquigKXGiv3hUXXABfzkZgl4Gx9eJG63UzqSQX9HEQrxdrwRGhEI0yrIoK/Eh4r+E7
         p9Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q22wl6OCD19GypMuT9QWRHowipst+oy+Pq7cX65GDBI=;
        b=C+vYsYz0V6Mu5+pSj6iAcxRHTS+5r7dX5JsdchB5cAo8ac0E1V3Q0RXoKJsebZLPgF
         PN1fTuIUwV6a+oNv7PnCDnvmrUuh8cYaV2Fqqy5F5PHcm+qYyyJVXnMHyvYy++dzSbIt
         SJRWZ5ZuvdV8SBTgwDgxpyehDbzvXYt6f26MlXUEYUO0UNlzWySRHpiFPSwuxZJmdKBf
         uILBKib8A8F52LqRGFd0qxQ7WiLnj2v3tpzAbUbTd9NpU8yiHI+toEF1QM9L2oD43HQ6
         whZsS3Zf/tD0CD0gU64Npa+IAoxKjlGfy6Z23Ik6TGF+WU7mKwTFa1ZyaPYsP35aKEVT
         R4rg==
X-Gm-Message-State: AOAM533fnX/9QqWJaXjwUIw0LZ5XrV1ES14fTbJV2TKfLz5eg4StvpR4
        wTQQqSw4/ji/k5rW5LIPMVUREC32L346obwJ9rp7KQ==
X-Google-Smtp-Source: ABdhPJz8MsvFIKOMo3v6OXCZ/Gti1AwvjDfQH2v2OENrYDIXl+aE+R5HUBYG9wft9NNF4CAYxEC9y6k8jNSNNSoXMnQ=
X-Received: by 2002:a05:600c:4f51:: with SMTP id m17mr11463648wmq.32.1642526288443;
 Tue, 18 Jan 2022 09:18:08 -0800 (PST)
MIME-Version: 1.0
References: <20220114140741.1358263-1-maz@kernel.org>
In-Reply-To: <20220114140741.1358263-1-maz@kernel.org>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 18 Jan 2022 17:17:57 +0000
Message-ID: <CAFEAcA9dFVUY5a9WANrS1UEPrbsUueYaUzneMYhjdn=XTKDGvA@mail.gmail.com>
Subject: Re: [PATCH v5 0/6] target/arm: Reduced-IPA space and highmem fixes
To:     Marc Zyngier <maz@kernel.org>
Cc:     qemu-devel@nongnu.org, Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 14 Jan 2022 at 14:08, Marc Zyngier <maz@kernel.org> wrote:
>
> Here's yet another stab at enabling QEMU on systems with
> pathologically reduced IPA ranges such as the Apple M1 (previous
> version at [1]). Eventually, we're able to run a KVM guest with more
> than just 3GB of RAM on a system with a 36bit IPA space, and at most
> 123 vCPUs.
>
> This also addresses some pathological QEMU behaviours, where the
> highmem property is used as a flag allowing exposure of devices that
> can't possibly fit in the PA space of the VM, resulting in a guest
> failure.
>
> In the end, we generalise the notion of PA space when exposing
> individual devices in the expanded memory map, and treat highmem as
> another flavour of PA space restriction.



Applied to target-arm.next, thanks.

-- PMM
