Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 226E144E82F
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 15:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235124AbhKLOLt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 09:11:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235095AbhKLOLs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 09:11:48 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC6CDC061766
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 06:08:57 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id d72-20020a1c1d4b000000b00331140f3dc8so6874049wmd.1
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 06:08:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=LvcYQf11PARVGCPaBocJIwE2u4Koi7pmpNUlWEMd4Cs=;
        b=L2J4Dq6FxomGl67aZpSolpe2vs6NVpgH6dJgY+slakbQHyj4vHP0WTbo2DeihNmCeF
         o6ukr4f2ga6HH91i/v0yrUWl0bQtrj3xt02aCQ3OKaOWxDI5q85DbenR10rWCTfWAXyF
         nL3XHvQOtWRgv9hb62SJwgAhaqlfrJp69iAK97QUeg2KZbvUAFW20EWf780eI+c7eGjQ
         kdZhnFSpsQy1ZpbuR3nqIXpR2kYVPOB57U/0exwFS8KDw0Vi+PhkLYR6p2qvapphvtDh
         AbfPaHT3wEEQ8eOKxnmjeLSvErZZ1sABEMwC/3jIM/ehniVXbq2N77pl3/umyiOvMlqg
         zcFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=LvcYQf11PARVGCPaBocJIwE2u4Koi7pmpNUlWEMd4Cs=;
        b=ituTduT8AXA2zTrs0oHXo9HxftzXcABL6wxW5B83lYEONI8trnoQiIrU+IcAK77AQT
         bZiJzHViXjnUgrpYFL8m02y8L/V+d2YwljRem27z4b+4G8vwb+h1pceV9KtVavb8lnP0
         D0RLzoqB86PP4N1WVSc0+AO4KJfwMToacRP7eKMWUqTACN2rI2IiKeheBtIa25cAsuXM
         TqA0aSJpL/H0q4QGe9uSdcWDw0bFlIJBHk5s/8mZLvxwiXGHWQgjhZp92erfyGI0DqMe
         HuGG4Gu1EhnKZFPZS55zV5CDv9az+b+YlBEi0xgNJ6CanRG1IsC/lSsPvPz5TeTnC0Pp
         wwqQ==
X-Gm-Message-State: AOAM532ZSsyBk4fVMIv56ifSS/pZkMoUZrMfZJugQg8PGQatWEk8vFDH
        Da94ZPiV4tAIrB0UWkmjFo9VOA==
X-Google-Smtp-Source: ABdhPJxLKpfOe7BU/uBpUgsE7avktdh1qKpR60mHaE8U1RGlwiGEstkhWhMJmbfqohLiP9Q2KZVxHw==
X-Received: by 2002:a05:600c:17c3:: with SMTP id y3mr33939958wmo.136.1636726132597;
        Fri, 12 Nov 2021 06:08:52 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id q4sm5912967wrs.56.2021.11.12.06.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 06:08:51 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id B88221FF96;
        Fri, 12 Nov 2021 14:08:50 +0000 (GMT)
References: <20211112114734.3058678-1-alex.bennee@linaro.org>
 <20211112132312.qrgmby55mlenj72p@gator.home>
User-agent: mu4e 1.7.4; emacs 28.0.60
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, shashi.mallela@linaro.org,
        qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 0/3] GIC ITS tests
Date:   Fri, 12 Nov 2021 14:08:01 +0000
In-reply-to: <20211112132312.qrgmby55mlenj72p@gator.home>
Message-ID: <87wnldfoul.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Andrew Jones <drjones@redhat.com> writes:

> On Fri, Nov 12, 2021 at 11:47:31AM +0000, Alex Benn=C3=A9e wrote:
>> Hi,
>>=20
>> Sorry this has been sitting in my tree so long. The changes are fairly
>> minor from v2. I no longer split the tests up into TCG and KVM
>> versions and instead just ensure that ERRATA_FORCE is always set when
>> run under TCG.
>>=20
>> Alex Benn=C3=A9e (3):
>>   arm64: remove invalid check from its-trigger test
>>   arm64: enable its-migration tests for TCG
>>   arch-run: do not process ERRATA when running under TCG
>>=20
>>  scripts/arch-run.bash |  4 +++-
>>  arm/gic.c             | 16 ++++++----------
>>  arm/unittests.cfg     |  3 ---
>>  3 files changed, 9 insertions(+), 14 deletions(-)
>>=20
>> --=20
>> 2.30.2
>>=20
>> _______________________________________________
>> kvmarm mailing list
>> kvmarm@lists.cs.columbia.edu
>> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
>
> Hi Alex,
>
> Thanks for this. I've applied to arm/queue, but I see that
>
> FAIL: gicv3: its-trigger: inv/invall: dev2/eventid=3D20 pending LPI is re=
ceived
>
> consistently fails for me. Is that expected? Does it work for you?

doh - looks like I cocked up the merge conflict...

Did it fail for TCG or for KVM (or both)?

--=20
Alex Benn=C3=A9e
