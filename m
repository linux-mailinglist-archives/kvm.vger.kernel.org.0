Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50EEB4572F7
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 17:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235117AbhKSQeU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 11:34:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232663AbhKSQeT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 11:34:19 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897B6C061574
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 08:31:17 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id j140-20020a1c2392000000b003399ae48f58so3041025wmj.5
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 08:31:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=XonVBN9UhK3TNdc3A1YJVcvvL67hZKsmNPxUpmHwItk=;
        b=rC9uz1gZXdPk56Nk1Dga+Mzt5srm/6DA12btE8+r1C7t9CBSmkBwo3Hfqjj6Mb8vR6
         tg+TM3G1LBeSNXK4nxjLnlPiIoEL7X4Q//7jHhzVC7cNFTuivF3BEq9xCb92F4wAds+6
         wlrQPPts1zZpw5JMvTmfXlg3+KZE0AK6wEAEPQfT5+Sb8mvLhQxfAdxG2gb8wmoSLJJB
         TmOEln4YDW8P3hndFtguagY9LGjYmDu3WY4p7xJbQmUP5nfm/JA5angfK4H1ibFwJTOE
         cAW+8F0EQvtMc5V5XrU+TZ0W/wTqWj3VxqErijViSeeVEbkM/sIN4RaJiCGVtX+xNafp
         K2Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=XonVBN9UhK3TNdc3A1YJVcvvL67hZKsmNPxUpmHwItk=;
        b=lyIKoDgWm9Wd9gCt2/zchct2KxQi9bBUCFtEl4N6b0nQaDwcYB2VJSJjik5qwdAczT
         REWsUii03GHjEqRResFYazL0Gf1/JkpM4IAlLmoniNULgJn6dc0q4wdGZDCCdgE48rTc
         b+LqFtpzuv+l8lXAdMrAEZ+Eit9zj8NOMQdxHb5BHLCigDH4RSx+ZjCwyTpfsb/2adXs
         +r5MQKZfSgtdb0gJavD0ngoMfQ8PgcZ07oGHIScHbfoHspR864xpusM/GRxpz0H+Skuq
         yy8vfV7y5rajLM19f/xo2fkRP/TA7GQBmbAzNG8womO188QIOqzislCKOTDQxYCt46Ay
         7toQ==
X-Gm-Message-State: AOAM532sKy/wLrKq3BmUPDEH+/Cf377948foCT1Y9cCH/v+cSTnZCGjJ
        w8zcEsc3PEY+v567z8F+MQ9MWA==
X-Google-Smtp-Source: ABdhPJy4m0XfeadVPe3VvpHbxVbveI8YvM0lUgplP9BkWybjPN0yJWrOgZpbmCDr2hgqJbZc+aGBMQ==
X-Received: by 2002:a1c:790d:: with SMTP id l13mr1116489wme.101.1637339476035;
        Fri, 19 Nov 2021 08:31:16 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id h15sm15359588wmq.32.2021.11.19.08.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 08:31:14 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 053491FF96;
        Fri, 19 Nov 2021 16:31:14 +0000 (GMT)
References: <20211112114734.3058678-1-alex.bennee@linaro.org>
 <20211112132312.qrgmby55mlenj72p@gator.home> <87wnldfoul.fsf@linaro.org>
 <20211112145442.5ktlpwyolwdsxlnx@gator.home>
User-agent: mu4e 1.7.5; emacs 28.0.60
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, shashi.mallela@linaro.org,
        qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 0/3] GIC ITS tests
Date:   Fri, 19 Nov 2021 16:30:47 +0000
In-reply-to: <20211112145442.5ktlpwyolwdsxlnx@gator.home>
Message-ID: <877dd4umy6.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Andrew Jones <drjones@redhat.com> writes:

> On Fri, Nov 12, 2021 at 02:08:01PM +0000, Alex Benn=C3=A9e wrote:
>>=20
>> Andrew Jones <drjones@redhat.com> writes:
>>=20
>> > On Fri, Nov 12, 2021 at 11:47:31AM +0000, Alex Benn=C3=A9e wrote:
>> >> Hi,
>> >>=20
>> >> Sorry this has been sitting in my tree so long. The changes are fairly
>> >> minor from v2. I no longer split the tests up into TCG and KVM
>> >> versions and instead just ensure that ERRATA_FORCE is always set when
>> >> run under TCG.
>> >>=20
>> >> Alex Benn=C3=A9e (3):
>> >>   arm64: remove invalid check from its-trigger test
>> >>   arm64: enable its-migration tests for TCG
>> >>   arch-run: do not process ERRATA when running under TCG
>> >>=20
>> >>  scripts/arch-run.bash |  4 +++-
>> >>  arm/gic.c             | 16 ++++++----------
>> >>  arm/unittests.cfg     |  3 ---
>> >>  3 files changed, 9 insertions(+), 14 deletions(-)
>> >>=20
>> >> --=20
>> >> 2.30.2
>> >>=20
>> >> _______________________________________________
>> >> kvmarm mailing list
>> >> kvmarm@lists.cs.columbia.edu
>> >> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
>> >
>> > Hi Alex,
>> >
>> > Thanks for this. I've applied to arm/queue, but I see that
>> >
>> > FAIL: gicv3: its-trigger: inv/invall: dev2/eventid=3D20 pending LPI is=
 received
>> >
>> > consistently fails for me. Is that expected? Does it work for you?
>>=20
>> doh - looks like I cocked up the merge conflict...
>>=20
>> Did it fail for TCG or for KVM (or both)?
>
> Just TCG, which was why I was wondering if it was expected. I've never run
> these tests with TCG before.

Hmm I think expecting the IRQ at all is broken so I think I should
delete the whole pending test.

>
> Thanks,
> drew


--=20
Alex Benn=C3=A9e
