Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75954676BED
	for <lists+kvm@lfdr.de>; Sun, 22 Jan 2023 10:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjAVJhi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Jan 2023 04:37:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbjAVJhh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Jan 2023 04:37:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B000C1420B;
        Sun, 22 Jan 2023 01:37:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5572760BAF;
        Sun, 22 Jan 2023 09:37:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC521C4339C;
        Sun, 22 Jan 2023 09:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674380255;
        bh=5DRyo3CrCvjcrQiE2XRnY3KDz/9FE09qT4m/dJZH0aE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lNZIpcXkSoIvkFOhU4vTZhoSMYH/FNrvyVZoqcjnGD2/s69Cq72+OwArNRF4Y0XfB
         K8wZSWe0o3Ez8X35Z8m9gZ5px+EoB3UpyoXrO0Jn3YGzCabyabgxUQZUD9s+4ayFxf
         TwxwFCrsUDltNDS2jG8PhJQ98LTT3bm3MWRgUsXNBoAOYjvbr4vzKAgkShJiKAK0om
         ZpXDxImFRySz+saPmOQDwYI/CYL9PeQJFnK1HoJDjhN/RikP2iSzxT+WsnOUXmtCdd
         Ylgn69DBTJn7EbQ8Orshu3ZKKQejnYB1OhOwAkeUsLr7Ooym/PKu23lPzYon+3ZGI+
         QXiwxf144D42g==
Received: by mail-yb1-f173.google.com with SMTP id 123so11561336ybv.6;
        Sun, 22 Jan 2023 01:37:35 -0800 (PST)
X-Gm-Message-State: AFqh2kqmQTJWa4dsaQBF89yhes7R6ITscTNk4uOyEH3gha9E7tbROEFA
        uyeQ9/LTjyymU9hvZu9ZuF30wuVssaJmpK4Lc7Q=
X-Google-Smtp-Source: AMrXdXsNA4vdApz7Jqsu/ybWJW5C5xYsmc6pnH1yI7UZkk+OVVQkpt4eufUHjmXdw7J7YX64IDe4L/lGXFrrrcbkdYc=
X-Received: by 2002:a25:344a:0:b0:803:60ae:431c with SMTP id
 b71-20020a25344a000000b0080360ae431cmr697945yba.642.1674380254802; Sun, 22
 Jan 2023 01:37:34 -0800 (PST)
MIME-Version: 1.0
References: <20230120123534.137413-1-bagasdotme@gmail.com> <20230120123534.137413-3-bagasdotme@gmail.com>
In-Reply-To: <20230120123534.137413-3-bagasdotme@gmail.com>
From:   Oded Gabbay <ogabbay@kernel.org>
Date:   Sun, 22 Jan 2023 11:37:08 +0200
X-Gmail-Original-Message-ID: <CAFCwf11O75ivb2RjXCvbOyNRTgYrbNz8JSDgHprnoNS1vx9SQg@mail.gmail.com>
Message-ID: <CAFCwf11O75ivb2RjXCvbOyNRTgYrbNz8JSDgHprnoNS1vx9SQg@mail.gmail.com>
Subject: Re: [PATCH linux-next 2/3] habanalabs: Fix list of /sys/class/habanalabs/hl<n>/status
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     Freedesktop DRI List <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation <linux-doc@vger.kernel.org>,
        Linux KVM <kvm@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jeffrey Hugo <quic_jhugo@quicinc.com>,
        Ofir Bitton <obitton@habana.ai>,
        Sean Christopherson <seanjc@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 20, 2023 at 2:35 PM Bagas Sanjaya <bagasdotme@gmail.com> wrote:
>
> Stephen Rothwell reported htmldocs warnings when merging accel tree:
>
> Documentation/ABI/testing/sysfs-driver-habanalabs:201: ERROR: Unexpected indentation.
> Documentation/ABI/testing/sysfs-driver-habanalabs:201: WARNING: Block quote ends without a blank line; unexpected unindent.
> Documentation/ABI/testing/sysfs-driver-habanalabs:201: ERROR: Unexpected indentation.
> Documentation/ABI/testing/sysfs-driver-habanalabs:201: WARNING: Block quote ends without a blank line; unexpected unindent.
>
> Fix these by fixing alignment of list of card status returned by
> /sys/class/habanalabs/hl<n>/status.
>
> Link: https://lore.kernel.org/linux-next/20230120130634.61c3e857@canb.auug.org.au/
> Fixes: 0a14c331682f61 ("habanalabs: update device status sysfs documentation")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>  .../ABI/testing/sysfs-driver-habanalabs       | 23 ++++++++++---------
>  1 file changed, 12 insertions(+), 11 deletions(-)
>
> diff --git a/Documentation/ABI/testing/sysfs-driver-habanalabs b/Documentation/ABI/testing/sysfs-driver-habanalabs
> index df2ca1a401b5a1..1b98b6503b23f5 100644
> --- a/Documentation/ABI/testing/sysfs-driver-habanalabs
> +++ b/Documentation/ABI/testing/sysfs-driver-habanalabs
> @@ -202,17 +202,18 @@ Date:           Jan 2019
>  KernelVersion:  5.1
>  Contact:        ogabbay@kernel.org
>  Description:    Status of the card:
> -                "operational" - Device is available for work.
> -                "in reset" - Device is going through reset, will be available
> -                        shortly.
> -                "disabled" - Device is not usable.
> -                "needs reset" - Device is not usable until a hard reset will
> -                        be initiated.
> -                "in device creation" - Device is not available yet, as it is
> -                        still initializing.
> -                "in reset after device release" - Device is going through
> -                        a compute-reset which is executed after a device release
> -                        (relevant for Gaudi2 only).
> +
> +                  * "operational" - Device is available for work.
> +                  * "in reset" - Device is going through reset, will be
> +                    available shortly.
> +                  * "disabled" - Device is not usable.
> +                  * "needs reset" - Device is not usable until a hard reset
> +                    is initiated.
> +                  * "in device creation" - Device is not available yet, as it
> +                    is still initializing.
> +                  * "in reset after device release" - Device is going through
> +                    a compute-reset which is executed after a device release
> +                    (relevant for Gaudi2 only).
>
>  What:           /sys/class/habanalabs/hl<n>/thermal_ver
>  Date:           Jan 2019
> --
> An old man doll... just what I always wanted! - Clara
>

Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Thanks!
Applied to my -next tree.
Oded
