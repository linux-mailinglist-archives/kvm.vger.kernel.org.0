Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42E4469231C
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 17:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbjBJQR4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 11:17:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbjBJQRz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 11:17:55 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5937BEC66
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 08:17:54 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id d2so5638935pjd.5
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 08:17:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=z386OrgC0qZ45jmFowK1MUQp1qTHcI3ZIUz9+Q/1B5U=;
        b=jEgnr/RsvmK6O0qewRMj8zhwUUsq2E7XpWnjCzHvQZgCohf6pYdO5YlYh4aQGwn1Rh
         FGtTuwUHWzG0GzP/VAUm8/4A6l9T1RwbDXiwUE9wTBaQJMSTR8C2sbrGzxZ7b6yHsQEC
         vHiIKK6KYrn7a7fMMjDdC4WvilK36r+33G9HmnxUMlXTlJ3c/uYJgxFIAXYNWGds5THi
         tK89bjXXoUknj4/AUuu9T1ACfumCCQZjHbwcax6I3R03HlgW3psfglVLmZSS34avs1j7
         GR5EgsNS6vrRjVUCihgzzh8Dn5Ch+DAT/5KtjNqdi/jGf9729PUOyzgfz1cPxr1XJUYj
         /neg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z386OrgC0qZ45jmFowK1MUQp1qTHcI3ZIUz9+Q/1B5U=;
        b=7IsPllVHNy2pZEuUNmqlaKV1HxDxM3DNffkuWXpftYVSH4oLeMzeTAraYhBSHqxrkL
         x+vn/rHp3QIGqIvycgUnPU42b6OhKrxJKIGtrOPl6gFLN+HR2CP+UxcopvoexnywKEbK
         MKCARfSICeE2m1YdEByA0pDdfRt1mLUFFgMXOOyyfE1qjHP3SR+U/4I6ZmKja72d81tw
         Bq0s4PINQU6P0iNRLea2MUbU2VmwDjTTi/2nvunW5mOVGQsNbON1rywFKUCMQrBHZOUa
         D24CP/CqUX1nEiZEMF4I2SW+ym1O4tTVUa58CHyYRHO5fSTiIMWG+TOViZvIzZy9swB9
         MfdQ==
X-Gm-Message-State: AO0yUKXW0jWkAB3eOlTuxbgHhy4jWR+XG/h4IjdYQGiCLrCqmniWdBy9
        yzHTx398vZpU5maI6Wvx+R6gqCBrY4atTBrapm5Q2A==
X-Google-Smtp-Source: AK7set8CoQNvdtuQ5N0z1SHxuNOdM734bNbotniAk8x3KQfciFelnNewiRKDgidLq0l2zfjbhmbfRiH2RkXDDvnOz6Y=
X-Received: by 2002:a17:90a:d353:b0:230:c24b:f22c with SMTP id
 i19-20020a17090ad35300b00230c24bf22cmr2746960pjx.53.1676045873790; Fri, 10
 Feb 2023 08:17:53 -0800 (PST)
MIME-Version: 1.0
References: <20230209233426.37811-1-quintela@redhat.com> <CAFEAcA-qSWck=ga4XBGvGXJohtGrSPO6t6+U4KqRvJdN8hrAug@mail.gmail.com>
 <87r0uxy528.fsf@secure.mitica> <CAFEAcA-SOpRiX+s14OxCJ+Lwx6kzUdroM9ufugzTVLM9Tq2gHA@mail.gmail.com>
 <87edqxxzur.fsf@secure.mitica>
In-Reply-To: <87edqxxzur.fsf@secure.mitica>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Fri, 10 Feb 2023 16:17:42 +0000
Message-ID: <CAFEAcA_DdytX0qF-WwjgVeOWm-D7Hpfd3F2eZhahdDtJZctFeA@mail.gmail.com>
Subject: Re: [PULL 00/17] Migration 20230209 patches
To:     quintela@redhat.com
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 10 Feb 2023 at 16:13, Juan Quintela <quintela@redhat.com> wrote:
> Again, I don't know why it fails.
>
> diff --git a/tests/bench/meson.build b/tests/bench/meson.build
> index daefead58d..7477a1f401 100644
> --- a/tests/bench/meson.build
> +++ b/tests/bench/meson.build
> @@ -3,9 +3,11 @@ qht_bench = executable('qht-bench',
>                         sources: 'qht-bench.c',
>                         dependencies: [qemuutil])
>
> +if have_system
>  xbzrle_bench = executable('xbzrle-bench',
>                         sources: 'xbzrle-bench.c',
>                         dependencies: [qemuutil,migration])
> +endif
>
>  executable('atomic_add-bench',
>             sources: files('atomic_add-bench.c'),
>
> This make it works.

Before you added your test, meson had no need to compile
any of the object files in 'migration', so it didn't. Now
you tell meson to build a new executable, and it says "OK,
I must build these object files". Only it turns out that
they won't actually compile in this config, so you get an
error.

The same issue can happen in good old Make :-)

thanks
-- PMM
