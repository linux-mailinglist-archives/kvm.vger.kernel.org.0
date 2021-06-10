Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBFE3A25BC
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 09:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbhFJHrs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 03:47:48 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:33455 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhFJHrr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 03:47:47 -0400
Received: by mail-pj1-f47.google.com with SMTP id k22-20020a17090aef16b0290163512accedso5045660pjz.0
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 00:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=U6ksZAob7TKdDLpcxJzavIEY63fSiSQXgK1vK7E4l0U=;
        b=fTquTMEv1aQiMNb3O7aFgwacm10ndcsC6WnOPKVdkOfNa9YeA0V8YRcIB5UpMtKbMc
         jXZsglfyWxaLIoO4HNi/50b1wHmLONhjSKW7xFbJ5ZmG8L3pW+HEBKwdH9LUHIexogcC
         EHq4BAd1Pvy2VaHvsQNkCOZ3jyX2IS32RLCNY/M2RdE5acEr1hrU7+0pd0ie3U953sJy
         Zaj8UsjI5mqzJfXtrmk+Qkbp7K88HupPAsPcjzAvUFDhwHYZFhQ6nGcQW4NXfvfB0vTm
         zGB5ekWKXD5M94cF2YWDZj/Pee5kuTw4kQiSd4iIsQ5Nd83+T3frk1VJk7by2HWBMmAr
         /1Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=U6ksZAob7TKdDLpcxJzavIEY63fSiSQXgK1vK7E4l0U=;
        b=pdyRQQ0gryhYTAHNCVOHIC7D9kjJUEYOTrQX59mE1L8w1lsJIhn+U/48kXEFZ7Rbmp
         SGAr+Vlf36bQx/Qa2PJP+dZ5x5ESsTX9VjIV7oY2iKn+tNCw5mNgaQBV4vlduKIooOCI
         N7MBO/V3wvaM0McSDKSRsIJ8gv+tKHMRMU2VoBoU1O9SD6hppjQUvpji21KCcFBETRcd
         o+Xnpw9uhgyDVDfcc4Bkp3qqcurVdsEHuAGkj3MIqNDcvtBna+E/ZwOgukSA4pq2N2H9
         uJbgOYjL++JoCWUYu0JSuXf8hZWR2wuiNP/ZTQwcC+DP8Zog4KCxpl286YYHSJTHPxuf
         H54g==
X-Gm-Message-State: AOAM533fXi7OtMvIQWbmmdRXOZntw3vLJaLSBg1zxUf43e6XimYcq9N2
        dil6YRmJTE9PZBrRpY1D2Go=
X-Google-Smtp-Source: ABdhPJz+uGwPFzTT/6+7puUrUBRt1A5HkP4qS/Y54u8OTcONLXRetxezLfO3ULAqv7AczttuVBei2w==
X-Received: by 2002:a17:90a:ec10:: with SMTP id l16mr2051282pjy.142.1623311078414;
        Thu, 10 Jun 2021 00:44:38 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id o20sm1707997pjq.4.2021.06.10.00.44.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Jun 2021 00:44:37 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [kvm-unit-tests PATCH 7/8] x86/pmu: Skip the tests on PMU version
 1
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CAA3+yLd4AML_eEtUwzFrd1-KKiiZ4W9Uy0gTdrEMC2YXVayJRQ@mail.gmail.com>
Date:   Thu, 10 Jun 2021 00:44:35 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <E2E14CA1-FAD4-47B7-BCAA-3D9012FC7391@gmail.com>
References: <20210609182945.36849-1-nadav.amit@gmail.com>
 <20210609182945.36849-8-nadav.amit@gmail.com>
 <CAA3+yLd4AML_eEtUwzFrd1-KKiiZ4W9Uy0gTdrEMC2YXVayJRQ@mail.gmail.com>
To:     Like Xu <like.xu.linux@gmail.com>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Jun 9, 2021, at 6:22 PM, Like Xu <like.xu.linux@gmail.com> wrote:
>=20
> Hi Nadav,
>=20
> Nadav Amit <nadav.amit@gmail.com> =E4=BA=8E2021=E5=B9=B46=E6=9C=8810=E6=97=
=A5=E5=91=A8=E5=9B=9B =E4=B8=8A=E5=8D=882:33=E5=86=99=E9=81=93=EF=BC=9A
>>=20
>> From: Nadav Amit <nadav.amit@gmail.com>
>>=20
>> x86's PMU tests are not compatible with version 1. Instead of finding
>> how to adapt them, just skip them if the PMU version is too old.
>=20
> Instead of skipping pmu.v1, it would be better to just skip the tests
> of fixed counters.
> But considering this version is really too old, this change looks fine =
to me.

If it were that simple, I would have done it.

v1 does not support MSR_CORE_PERF_GLOBAL_OVF_CTRL,
MSR_CORE_PERF_GLOBAL_STATUS and MSR_CORE_PERF_GLOBAL_CTRL, which are
being used all over the code. These MSRs were only introduced on
version 2 (Intel SDM, section 18.2.2 "Architectural Performance
Monitoring Version 2=E2=80=9D).

