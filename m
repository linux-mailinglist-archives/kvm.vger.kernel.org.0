Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943E43079FD
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 16:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhA1Pnm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 10:43:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbhA1Pni (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 10:43:38 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A598C061756
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 07:42:58 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id u14so4947036wmq.4
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 07:42:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=12mnrR8ms+5WwSs+PQVzHOmb66VScSLabLuV3gix8ak=;
        b=kuTguAq0PIxh75dPU2EoEK+kClZITPzeJAUWVxlLI4qXRRy0EHl5JbOERJ2BxGOyRM
         yT9Tn2JPqLmUg1A3k8U6kD+EsS/KfoJGq9MFVYh1n8kwm6jXSeAX2yYYRA7aC9a1Tz6n
         0GCdFo8Jl+PO5frszxrgjaOu4QaG1xRcSPJ8EJY2gfZN8GPFN+cNDPBLf9r43uEjFP1y
         cNa99zIFL8b2J2DfkG7gudABYoDzAsb7EoAiXxTgM9xjF4L79iif28PCWFM98gV85lYI
         mF4/w+be+bo5oU8WNNF4yL9GPmFxOZgI2MR7EO0+zvwHSE+o8VkEvGppO+YJPgKIMJB2
         deLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=12mnrR8ms+5WwSs+PQVzHOmb66VScSLabLuV3gix8ak=;
        b=YVv0VHoiqIIjDPViYGf2uqqhF2xU8t7hZdHgHRSlCBrmVRLzAQQnJX/8CmATKxVNkw
         /zmlUBQmR1nph3tGDKzIQnAPMhU8iuTDOZtHFMoRzVm0UiJ7wAr5rIdDbZ9M1qPMvv5C
         CLZwU2dFKgr0GiC66eCOF0XxEjH4BkX9Oq5M/tLQi0eOMto9dhlHyN5uTmvrk88j6YXB
         xxO7pxqfwYM/q5qmIMhWmqhjb28xCveKyPxhBxFNajsrZcAFLzch7EOy1nt0+gOpBOP9
         KGnvOE012GD6VWfzzajIflxoXuFIBfrjRUA2WGCjrV9lol0UYeDGIlsn1LuwCN7blKfT
         IOXg==
X-Gm-Message-State: AOAM5312syJnsUSc6oyeWxC5q+Hjl0rowWvxA9ovNEHyWb5ryLZj6sKq
        zai544VHuSbYlhWXK89GYwjSjvvij4Njjf71
X-Google-Smtp-Source: ABdhPJyuRinAeKRNz0U8QY7HX488Da2kP0mO3x8wMmScPfiPSOxC3b+qIw/y4ga4d/V9tTSnOTvOrQ==
X-Received: by 2002:a1c:ed0b:: with SMTP id l11mr9248340wmh.47.1611848576851;
        Thu, 28 Jan 2021 07:42:56 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id y14sm7258669wro.58.2021.01.28.07.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 07:42:55 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id A63981FF7E;
        Thu, 28 Jan 2021 15:42:54 +0000 (GMT)
References: <20200929224355.1224017-1-philmd@redhat.com>
 <87r1m5x56h.fsf@linaro.org>
 <98f06a0a-efe6-c630-8e68-0e4559f04d58@redhat.com>
User-agent: mu4e 1.5.7; emacs 28.0.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Cc:     Claudio Fontana <cfontana@suse.de>, qemu-devel@nongnu.org,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Fam Zheng <fam@euphon.net>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH v4 00/12] Support disabling TCG on ARM (part 2)
Date:   Thu, 28 Jan 2021 15:42:38 +0000
In-reply-to: <98f06a0a-efe6-c630-8e68-0e4559f04d58@redhat.com>
Message-ID: <87bld9ukxt.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com> writes:

> Hi Alex,
>
> On 1/28/21 1:41 AM, Alex Benn=C3=A9e wrote:
>> Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com> writes:
>>=20
>>> Cover from Samuel Ortiz from (part 1) [1]:
>>>
>>>   This patchset allows for building and running ARM targets with TCG
>>>   disabled. [...]
>>>
>>>   The rationale behind this work comes from the NEMU project where we're
>>>   trying to only support x86 and ARM 64-bit architectures, without
>>>   including the TCG code base. We can only do so if we can build and run
>>>   ARM binaries with TCG disabled.
>>>
>>> v4 almost 2 years later... [2]:
>>> - Rebased on Meson
>>> - Addressed Richard review comments
>>> - Addressed Claudio review comments
>>=20
>> Have you re-based recently because I was having a look but ran into
>> merge conflicts. I'd like to get the merged at some point because I ran
>> into similar issues with the Xen only build without TCG.
>
> I addressed most of this review comments locally. Since Claudio's
> accelerator series was getting more attention (and is bigger) I was
> waiting it gets merged first. He just respun v14:
> https://lists.gnu.org/archive/html/qemu-devel/2021-01/msg07171.html

OK I'll have a look at Claudio's first ;-)



--=20
Alex Benn=C3=A9e
